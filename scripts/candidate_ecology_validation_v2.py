#!/usr/bin/env python3
"""Module 2.5 V2. Read-only source audit, actual BLAST, curated literature snapshot.

Requires Python standard library and the existing BLAST+ installation. New output
directories only. Literature is a dated manual primary-source review, NOT an
automatic function predictor. All claims are attached to reference organisms.
"""
import argparse
import collections
import csv
from datetime import datetime
import gzip
import hashlib
import io
import json
from pathlib import Path
import platform
import re
import shlex
import subprocess
import sys
import tempfile
import time
import zipfile
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
ORDER = ['C02', 'C04', 'C05', 'C10', 'C09', 'N026', 'N045', 'N072', 'C01', 'C03']
B24 = 'results/ecological_candidates/2026-11-07_v2'
B22 = 'results/candidate_asvs/2026-11-05_v2'
B23 = 'results/operational_performance/2026-11-06_design_recipe_v2'
MIDAS_URL = 'https://www.midasfieldguide.org/files/downloads/taxonomies/SINTAX.fa%20MiDAS%205.3.fa'
MIDAS_SHA = '06e2fa3edc892676ef1356901d2bf0320520b3e79be6f73caf98955c0aecc00e'
PANEL_IDS = ['LC349727.1', 'KF245634.1', 'KX443571.1', 'MW182516.1', 'MW182517.1', 'MN817941.1']
GENOME_IDS = ['CP054675.1', 'CP058702.1', 'CP062983.1']
FIELDS = 'qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen nident gaps qseq sseq'.split()
ACCESS_DATE = '2026-11-08'


def stamp():
    return datetime.now(ZoneInfo('Asia/Shanghai')).isoformat(timespec='seconds')


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def tsv(p, skip=0):
    with p.open(encoding='utf-8', newline='') as h:
        for _ in range(skip):
            next(h)
        rd = csv.DictReader(h, delimiter='\t')
        rows = list(rd)
        if not rd.fieldnames or len(set(rd.fieldnames)) != len(rd.fieldnames):
            raise ValueError(f'Duplicate/missing columns: {p}')
        if any(None in r or None in r.values() for r in rows):
            raise ValueError(f'Malformed TSV: {p}')
        return rows


def keyed(rows, key):
    d = {r[key]: r for r in rows}
    if len(d) != len(rows):
        raise ValueError(f'Duplicate {key}')
    return d


def fasta(text):
    result = {}
    for line in text.splitlines():
        if line.startswith('>'):
            k = line[1:].strip()
            if not k or k in result:
                raise ValueError('Empty/duplicate FASTA header')
            result[k] = ''
        elif line.strip():
            result[k] += line.strip().upper()
    if not result or any(not s or not set(s) <= set('ACGTRYSWKMBDHVN') for s in result.values()):
        raise ValueError('Empty/malformed DNA FASTA')
    return result


def genomes_from_genbank(p):
    result = {}
    for rec in p.read_text().split('\n//'):
        if not rec.strip():
            continue
        rid = re.search(r'^VERSION\s+(\S+)', rec, re.M).group(1)
        n = int(re.search(r'^LOCUS\s+\S+\s+(\d+) bp', rec, re.M).group(1))
        sequence = re.sub(r'[^a-zA-Z]', '', rec.split('ORIGIN')[1]).upper()
        if len(sequence) != n or not set(sequence) <= set('ACGTRYSWKMBDHVN'):
            raise ValueError(f'GenBank length/alphabet FAIL: {rid}')
        if rid in result:
            raise ValueError(f'Duplicate genome: {rid}')
        result[rid] = sequence
    return result


def revcomp(s):
    return s.translate(str.maketrans('ACGTRYSWKMBDHVN', 'TGCAYRSWMKVHDBN'))[::-1]


def taxonomy(header):
    return dict(x.split(':', 1) for x in header.split(';tax=')[1].strip(';').split(','))


def lca(hits, refs):
    taxa = [taxonomy(refs[h['sseqid']][0]) for h in hits]
    common = []
    for rank in ['d', 'p', 'c', 'o', 'f', 'g', 's']:
        vals = {t.get(rank, '') for t in taxa}
        if len(vals) != 1 or not next(iter(vals)):
            break
        common.append(rank + ':' + next(iter(vals)))
    return ';'.join(common) or 'NA'


def md(headers, rows):
    def cell(v):
        return str(v).replace('|', '/').replace('\n', ' ')
    return '\n'.join(['| ' + ' | '.join(headers) + ' |', '|' + '|'.join(['---'] * len(headers)) + '|'] +
                     ['| ' + ' | '.join(map(cell, row)) + ' |' for row in rows])


def compact(x):
    return json.dumps(x, ensure_ascii=False, separators=(',', ':'))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output-dir', default='results/candidate_ecology/2026-11-08_v2')
    ap.add_argument('--midas-fasta', type=Path, required=True)
    ap.add_argument('--type-fasta', type=Path, required=True)
    ap.add_argument('--genbank', type=Path, required=True)
    ap.add_argument('--vicinibacter-zips', type=Path, nargs=2, required=True)
    ap.add_argument('--supplement-pdf', type=Path, required=True)
    ap.add_argument('--metabolic-figure', type=Path, required=True)
    ap.add_argument('--blast-bin', type=Path, default=Path('/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin'))
    ap.add_argument('--precomputed-midas', type=Path, help='Reuse actual recorded blastn output; all reported alignments are rechecked against full database')
    args = ap.parse_args()
    out = Path(args.output_dir)
    out = out if out.is_absolute() else ROOT / out
    if not out.name.endswith('_v2') or out.exists():
        raise ValueError('拒绝已有目录或非_v2目标；不覆盖结果。')
    paths = ['AGENTS.md', 'docs/research_context.md', 'docs/batch_01/experiment_design.md',
             'docs/batch_01/analysis_plan.md', 'docs/batch_01/analysis_log.md',
             'data/asv_table.tsv', 'data/taxonomy.tsv', 'data/exported_sequences/dna-sequences.fasta',
             'input/qiime2/rep-seqs.qza', 'metadata/source_sample_metadata.tsv',
             B24 + '/candidate_priority_table.tsv', B24 + '/candidate_screening_report.md',
             B22 + '/candidate_asv_taxonomy_review.tsv', B22 + '/candidate_asv_evidence.tsv',
             B23 + '/analysis_metadata.tsv', 'logs/taxonomy/inputs.json',
             'results/community_composition/2026-11-03_v2/analysis_report.md',
             'results/functional_guilds/2026-11-03_v2/analysis_report.md',
             'results/diversity/2026-11-04_v2/analysis_report.md',
             'results/asv_contributions/2026-11-05_v2/analysis_report.md',
             B22 + '/analysis_report.md', B23 + '/analysis_report.md']
    extra_sources = [args.type_fasta, args.genbank, *args.vicinibacter_zips, args.supplement_pdf, args.metabolic_figure]
    for p in [ROOT / x for x in paths] + [args.midas_fasta, *extra_sources]:
        if not p.is_file():
            raise FileNotFoundError(p)
    protected = {p: sha(p) for base in ['data', 'input', 'metadata', 'results', 'scripts']
                 for p in (ROOT / base).rglob('*') if p.is_file()}
    fingerprints = {p: sha(ROOT / p) for p in paths}
    external = {str(p): sha(p) for p in [args.midas_fasta, *extra_sources]}
    out.mkdir(parents=True, exist_ok=False)
    checks = []
    started, timer = stamp(), time.monotonic()
    with (out / 'run.log').open('x', encoding='utf-8') as log:
        def emit(status, item, detail):
            checks.append((status, item, detail))
            log.write(f'{stamp()} {status} {item}: {detail}\n')
            log.flush()

        def check(ok, item, detail):
            emit('PASS' if ok else 'FAIL', item, detail)
            if not ok:
                raise ValueError(f'{item}: {detail}')

        def run(command):
            log.write('COMMAND ' + shlex.join(map(str, command)) + '\n'); log.flush()
            r = subprocess.run(list(map(str, command)), capture_output=True, text=True)
            if r.stdout:
                log.write(r.stdout + '\n')
            if r.stderr:
                log.write(r.stderr + '\n')
            check(r.returncode == 0, '外部命令退出', str(r.returncode))
            return r.stdout.strip()

        def write_table(name, rows):
            with (out / name).open('x', encoding='utf-8', newline='') as h:
                wr = csv.DictWriter(h, list(rows[0]), delimiter='\t', lineterminator='\n')
                wr.writeheader(); wr.writerows(rows)
            check(tsv(out / name) == [{k: str(v) for k, v in r.items()} for r in rows],
                  name + '回读', f'{len(rows)}行×{len(rows[0])}列')

        try:
            log.write(f'START {started}\nPYTHON {platform.python_version()}\nCOMMAND {shlex.join(sys.argv)}\n')
            log.write('SCRIPT_SHA256 ' + sha(Path(__file__)) + '\n')
            log.write('INPUT_SHA256 ' + compact(fingerprints) + '\nEXTERNAL_SHA256 ' + compact(external) + '\n')
            log.write('ACCESS 2026-11-08 primary websites reviewed with web search/open/find. Curated evidence below is a frozen manual snapshot, not online revalidation during replay.\n')
            log.write('ACQUISITION MiDAS official download; first 60-second transfer timed out at 20692704 bytes, curl --continue-at - completed 169354955 bytes. No partial database used.\n')
            log.write('ACQUISITION NCBI efetch nuccore: ' + ','.join(PANEL_IDS + GENOME_IDS) + '\n')
            log.write('ACQUISITION_TYPE16S https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=LC349727,KF245634,KX443571,MW182516,MW182517,MN817941&rettype=fasta&retmode=text\n')
            log.write('ACQUISITION_GENBANK https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP054675.1,CP058702.1,CP062983.1&rettype=gb&retmode=text\n')
            log.write('ACQUISITION_SUPPLEMENT https://public-pages-files-2025.frontiersin.org/articles/917553/file/Data_Sheet_5.pdf/917553_supplementary-materials_datasheets_5_pdf/1\n')
            log.write('ACQUISITION_FIG5 https://www.frontiersin.org/files/Articles/917553/xml-images/fmicb-13-917553-g0005.webp\n')
            log.write('PRECHECK initial temporary genome parser omitted ambiguous N bases; LOCUS length check prompted correction before final analysis. CP058702.1 retains all 7207 Ns. Preliminary shifted coordinates are superseded.\n')
            version = run([args.blast_bin / 'blastn', '-version'])
            check(external[str(args.midas_fasta)] == MIDAS_SHA, 'MiDAS5.3完整文件指纹', MIDAS_SHA)
            allseq = fasta((ROOT / 'data/exported_sequences/dna-sequences.fasta').read_text())
            allseq = {k.split()[0]: v for k, v in allseq.items()}
            original = keyed(tsv(ROOT / 'data/taxonomy.tsv'), 'Feature ID')
            pool = keyed(tsv(ROOT / B24 / 'candidate_priority_table.tsv'), 'candidate_id')
            previous = keyed(tsv(ROOT / B22 / 'candidate_asv_taxonomy_review.tsv'), 'feature_id')
            classifier_provenance = json.loads((ROOT / 'logs/taxonomy/inputs.json').read_text())
            check(set(classifier_provenance['sample_ids']) == set(tsv(ROOT / 'metadata/source_sample_metadata.tsv')[i]['sample-id'] for i in range(33)),
                  '历史SILVA样本来源', '旧参数日志33样本一致；不加载或重跑外部分类器')
            report24 = (ROOT / B24 / 'candidate_screening_report.md').read_text()
            for p in ['data/asv_table.tsv', 'data/taxonomy.tsv', 'data/exported_sequences/dna-sequences.fasta',
                      'metadata/source_sample_metadata.tsv', B22 + '/candidate_asv_taxonomy_review.tsv', B23 + '/analysis_metadata.tsv']:
                check(fingerprints[p] in report24, '有效v2指纹链', p)
            check(set(allseq) == set(original), '既有FASTA与原taxonomy ID', f'{len(allseq)}个ID一致；不重做上游QC')
            check({r['candidate_id'] for r in pool.values() if r['recommended_next_stage'] == 'TRUE'} == set(ORDER[:8]),
                  '固定8目标', ';'.join(ORDER[:8]))
            check(all(pool[x]['primary_candidate'] == 'TRUE' for x in ORDER), '10对象身份与既有主池', '8目标+2对照；没有扩大候选')
            queries = {c: allseq[pool[c]['feature_id']] for c in ORDER}
            for c, s in queries.items():
                fid = pool[c]['feature_id']
                check(hashlib.md5(s.encode()).hexdigest() == fid and set(s) <= set('ACGT'), c + '真实序列',
                      f'{fid}; {len(s)}bp; SHA256={hashlib.sha256(s.encode()).hexdigest()}')
                check(pool[c]['original_taxonomy'] == original[fid]['Taxon'] and
                      pool[c]['original_Confidence_text'] == original[fid]['Confidence'], c + '原SILVA保留', '完整Taxon和Confidence逐字符一致')
                if fid in previous:
                    check(previous[fid]['sequence'] == s and previous[fid]['original_taxonomy'] == original[fid]['Taxon'] and
                          previous[fid]['original_Confidence_text'] == original[fid]['Confidence'], c + '模块2.2复用', '序列/完整谱系/原Confidence一致')
            with zipfile.ZipFile(ROOT / 'input/qiime2/rep-seqs.qza') as z:
                names = [n for n in z.namelist() if n.endswith('/data/dna-sequences.fasta')]
                check(len(names) == 1, 'Artifact序列源唯一', str(names))
                qzaseq = fasta(z.read(names[0]).decode())
                check(all(qzaseq[pool[c]['feature_id']] == queries[c] for c in ORDER), '10序列与原QZA核对', '只读zip内已有数据；无重复导出')
            metadata = tsv(ROOT / B23 / 'analysis_metadata.tsv')
            source = keyed(tsv(ROOT / 'metadata/source_sample_metadata.tsv'), 'sample-id')
            m = keyed(metadata, 'sample-id')
            with (ROOT / 'data/asv_table.tsv').open() as h:
                next(h); ids = next(h).rstrip('\n').split('\t')[1:]
            check(len(m) == 33 and set(m) == set(ids) == set(source) and len(ids) == len(set(ids)), '33样本ID', '计数仅仅读表头，深度QC沿用历史指纹')
            check(collections.Counter(r['group'] for r in metadata) == {'G1':8, 'G2':2, 'G3':4, 'G4':15, 'G5':4}, '分组', '8/2/4/15/4')
            check(all(all(r[k] == source[r['sample-id']][k] for k in source[r['sample-id']]) for r in metadata), '原metadata保留', '33×14原值逐项一致')
            g4 = [r for r in metadata if r['group'] == 'G4']
            check(all(r['G4_initial_sludge_distinctness'].startswith('different_per_reactor') and
                      r['temperature_setpoint_C'] == ('30' if r['reactor_id'] in ['Reactor_01','Reactor_03'] else 'NA') and
                      r['temperature_measured_C'] == 'NA' for r in g4), 'G4设计', '四不同起始污泥；R1/R3=30℃，R2/R4室温未知，纵向不独立')
            check(all(r['influent_data_type'] == 'design_recipe' and r['influent_sample_measured'] == 'FALSE' and
                      r['performance_association_gate'] == 'closed_missing_measured_performance' for r in metadata), '性能门控', '统一名义配方不增加同期实测、出水或功能基因')
            full = fasta(args.midas_fasta.read_text())
            refs = {k.split(';')[0]: (k, v) for k, v in full.items()}
            check(len(refs) == len(full) == 111037, 'MiDAS参考ID唯一', '完整官方SINTAX 5.3参考集111037条')
            panel = {k.split()[0]: (k, v) for k, v in fasta(args.type_fasta.read_text()).items()}
            genomes = genomes_from_genbank(args.genbank)
            check(set(panel) == set(PANEL_IDS) and set(genomes) == set(GENOME_IDS), '定向参考集', '6条培养株16S、3个文献基因组；编号含ZRK33勘误')
            references = {'MiDAS5.3': refs, 'INSDC_type16S': panel,
                          'INSDC_genome': {k: (k, v) for k, v in genomes.items()}}
            mag_meta = {}
            for zp in args.vicinibacter_zips:
                with zipfile.ZipFile(zp) as z:
                    record = json.loads(z.read('ncbi_dataset/data/assembly_data_report.jsonl'))
                    assembly = record['currentAccession']
                    check(assembly in ['GCA_016714365.1','GCA_016713905.1'], 'MAG原始记录', assembly)
                    expected = {'GCA_016714365.1':('EsbW_18-Q3-R4-48_MAXAC.074','Candidatus Vicinibacter affinis'),
                                'GCA_016713905.1':('Fred_18-Q3-R57-64_BAT3C.331','Candidatus Vicinibacter proximus')}[assembly]
                    check((record['assemblyInfo']['biosample']['isolate'], record['organism']['organismName']) == expected,
                          '参考MAG实际isolate与种名', assembly + ';' + ';'.join(expected))
                    f = [k for k in z.namelist() if k.endswith('_genomic.fna')]
                    check(len(f) == 1, 'MAG完整序列文件唯一', assembly)
                    sequences = {k.split()[0]: (k, v) for k,v in fasta(z.read(f[0]).decode()).items()}
                    check(sum(len(v[1]) for v in sequences.values()) == int(record['assemblyStats']['totalSequenceLength']),
                          'MAG基因组长度', assembly)
                    for rid in sequences:
                        mag_meta[rid] = dict(assembly=assembly, isolate=record['assemblyInfo']['biosample']['isolate'],
                                             organism=record['organism']['organismName'], source='NCBI Datasets v2;PRJNA629478')
                    references[assembly] = sequences
            hits = []
            with tempfile.TemporaryDirectory(prefix='batch01_module25_v2_') as td:
                tmp = Path(td)
                q = tmp / 'queries.fasta'
                q.write_text(''.join('>' + c + '\n' + s + '\n' for c, s in queries.items()))
                for dbname, db in references.items():
                    subject = tmp / (dbname + '.fasta')
                    subject.write_text(''.join('>' + k + '\n' + v[1] + '\n' for k, v in db.items()))
                    result = tmp / (dbname + '.tsv')
                    if dbname == 'MiDAS5.3' and args.precomputed_midas:
                        result = args.precomputed_midas
                        check(result.is_file() and result.stat().st_size > 0, '实际BLAST结果复用', str(result) + '; SHA256=' + sha(result))
                        log.write('PRECOMPUTED_COMMAND blastn -task blastn -dust no -word_size 11 -evalue 1e-10 -perc_identity 85 -qcov_hsp_perc 90 -max_target_seqs 200000 -max_hsps 1 -num_threads 2 -outfmt "6 ' + ' '.join(FIELDS) + '"\n')
                    else:
                        cmd = [args.blast_bin / 'blastn', '-query', q, '-task', 'blastn', '-dust', 'no',
                               '-word_size', '11', '-evalue', '1e-10', '-max_hsps', '1' if dbname in ['MiDAS5.3','INSDC_type16S'] else '10',
                               '-max_target_seqs', str(len(db)), '-outfmt', '6 ' + ' '.join(FIELDS), '-out', result]
                        if dbname == 'MiDAS5.3':
                            dbpath = tmp / 'midas_db'
                            run([args.blast_bin / 'makeblastdb', '-in', subject, '-dbtype', 'nucl', '-parse_seqids', '-out', dbpath])
                            cmd += ['-db', dbpath, '-perc_identity', '85', '-qcov_hsp_perc', '90', '-num_threads', '2']
                        else:
                            cmd += ['-subject', subject]
                        run(cmd)
                    rows = list(csv.DictReader(result.open(), delimiter='\t', fieldnames=FIELDS))
                    check(bool(rows) and all(None not in h and None not in h.values() for h in rows), dbname + '比对格式', f'{len(rows)} HSP')
                    for h in rows:
                        h = {'database': dbname, **h}
                        for k in ['length','mismatch','gapopen','qstart','qend','sstart','send','qlen','slen','nident','gaps']:
                            h[k] = int(h[k])
                        for k in ['pident','bitscore','evalue']:
                            h[k] = float(h[k])
                        qs = queries[h['qseqid']]
                        ss = db[h['sseqid']][1]
                        a, b = h['qseq'].upper(), h['sseq'].upper()
                        assert h['qlen'] == len(qs) and h['slen'] == len(ss)
                        assert a.replace('-', '') == qs[h['qstart']-1:h['qend']]
                        sub = ss[min(h['sstart'],h['send'])-1:max(h['sstart'],h['send'])]
                        if h['send'] < h['sstart']:
                            sub = revcomp(sub)
                        assert b.replace('-', '') == sub, (dbname,h['qseqid'],h['sseqid'])
                        assert len(a) == len(b) == h['length']
                        assert sum(x == y and x != '-' for x,y in zip(a,b)) == h['nident']
                        assert sum(x == '-' or y == '-' for x,y in zip(a,b)) == h['gaps']
                        assert abs(h['pident'] - 100*h['nident']/h['length']) < .00051
                        h['query_coverage_pct'] = 100*(h['qend']-h['qstart']+1)/h['qlen']
                        h['reference_header'] = db[h['sseqid']][0]
                        hits.append(h)
                    check(True, dbname + '逐HSP核验', 'qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致')
            summary = []
            for c in ORDER:
                eligible = [h for h in hits if h['database'] == 'MiDAS5.3' and h['qseqid'] == c and h['query_coverage_pct'] >= 99]
                eligible.sort(key=lambda h: (-h['pident'], -h['query_coverage_pct'], -h['bitscore'], h['sseqid']))
                check(bool(eligible), c + '合理覆盖MiDAS匹配', '至少1个HSP覆盖查询≥99%')
                best = eligible[0]
                tie = [h for h in eligible if h['pident'] == best['pident'] and h['query_coverage_pct'] == best['query_coverage_pct']]
                near05 = [h for h in eligible if h['pident'] >= best['pident']-.5]
                near10 = [h for h in eligible if h['pident'] >= best['pident']-1.0]
                fid = pool[c]['feature_id']
                s = queries[c]
                item = dict(candidate_id=c, feature_id=fid, role='target' if c in ORDER[:8] else 'GAO_related_control',
                            original_SILVA_Taxon=original[fid]['Taxon'], original_SILVA_Confidence=original[fid]['Confidence'],
                            original_classifier_log='logs/taxonomy/inputs.json',
                            original_classifier_filename=Path(classifier_provenance['inputs']['classifier']['path']).name,
                            original_classifier_sha256_recorded=classifier_provenance['inputs']['classifier']['sha256'],
                            original_classifier_training_database_verification='NOT_VERIFIED_filename_is_historical_provenance_only',
                            sequence=s, sequence_length_bp=len(s), sequence_md5=hashlib.md5(s.encode()).hexdigest(),
                            sequence_sha256=hashlib.sha256(s.encode()).hexdigest(),
                            sequence_source='input/qiime2/rep-seqs.qza::data/dna-sequences.fasta;data/exported_sequences/dna-sequences.fasta',
                            module22_reused='TRUE' if fid in previous else 'FALSE_new_target',
                            reference_database='MiDAS', database_version='5.3', database_url=MIDAS_URL,
                            database_sha256=MIDAS_SHA, accessed_on=ACCESS_DATE,
                            alignment_status='VERIFIED_SEQUENCE_COMPARISON', best_identity_pct=best['pident'],
                            query_coverage_pct=best['query_coverage_pct'], query_start=best['qstart'], query_end=best['qend'],
                            best_identity_tie_n=len(tie), best_tie_ids=';'.join(h['sseqid'] for h in tie),
                            best_tie_taxonomies=compact(sorted({h['reference_header'] for h in tie})),
                            best_tie_LCA=lca(tie, refs), near_0_5pp_n=len(near05), near_0_5pp_LCA=lca(near05,refs),
                            near_1pp_n=len(near10), near_1pp_LCA=lca(near10,refs),
                            species_or_strain_identity='NOT_VERIFIED', reliable_interpretation=ADJUDICATION[c],
                            conservative_named_rank=CONSERVATIVE_RANK[c],
                            amplicon_coordinates_status='query_coordinates_verified;universal_16S_primer_coordinates_NOT_VERIFIED',
                            all_hit_details='reference_alignments_v2.tsv.gz', taxonomy_overwritten='FALSE')
                summary.append(item)
            write_table('candidate_taxonomy_validation.tsv', summary)
            # Keep actual alignment evidence and the exact matched sequences, not a
            # second copy of the entire database or temporary BLAST indexes.
            with gzip.open(out / 'reference_alignments_v2.tsv.gz', 'wt', encoding='utf-8', newline='') as h:
                wr = csv.DictWriter(h, list(hits[0]), delimiter='\t', lineterminator='\n'); wr.writeheader(); wr.writerows(hits)
            retained = collections.defaultdict(set)
            for h in hits:
                if h['database'] in ['MiDAS5.3','INSDC_type16S']:
                    retained[h['database']].add(h['sseqid'])
            with gzip.open(out / 'reference_sequences_v2.fasta.gz', 'wt', encoding='utf-8') as h:
                for dbname in ['MiDAS5.3','INSDC_type16S']:
                    for rid in sorted(retained[dbname]):
                        header, s = references[dbname][rid]
                        h.write('>' + dbname + '|' + header + '\n' + s + '\n')
                for hit in hits:
                    if hit['database'] not in ['MiDAS5.3','INSDC_type16S']:
                        h.write(f">{hit['database']}|{hit['sseqid']}:{hit['sstart']}..{hit['send']}|{hit['qseqid']}\n" + hit['sseq'].replace('-','') + '\n')
            # One frozen evidence bundle permits independent re-reading of source
            # metadata, the two complete MAGs and the published metabolic figure.
            # The large MiDAS database is identified by URL/version/full-file hash.
            with zipfile.ZipFile(out / 'reference_evidence_v2.zip', 'x', compression=zipfile.ZIP_DEFLATED) as z:
                for p, name in zip(extra_sources, ['type16S.fasta','genome_records.gb','vicinibacter_1.zip',
                                                  'vicinibacter_2.zip','supplement.pdf','metabolic_figure.webp']):
                    z.write(p, name)
            check(zipfile.ZipFile(out / 'reference_evidence_v2.zip').testzip() is None, '参考原件归档', '6个实际下载源文件；完整MiDAS不重复归档')
            with gzip.open(out / 'reference_alignments_v2.tsv.gz', 'rt', encoding='utf-8') as h:
                back = list(csv.DictReader(h, delimiter='\t'))
            check(back == [{k:str(v) for k,v in r.items()} for r in hits], '全部匹配证据回读', f'{len(hits)}行，原坐标/匹配碱基/并列及低identity均保留')
            literature, genome_table, roles = build_evidence(summary, hits, pool, mag_meta)
            check(set(r['candidate_id'] for r in literature) == set(ORDER) and
                  set(r['candidate_id'] for r in genome_table) == set(ORDER), '证据覆盖与边界', '10对象都有显式证据或NA/NOT_VERIFIED记录')
            check(all(r['project_function_validation'] == 'not_measured' for r in roles) and
                  all(r['asv_gene_or_pathway_assignment'] == 'NOT_PERFORMED' for r in genome_table), '代谢外推门控', 'N072仅审核近缘参考MAG已报道潜力；全部项目ASV不作基因/通路赋值')
            write_table('candidate_reference_genomes.tsv', genome_table)
            write_table('candidate_literature_evidence.tsv', literature)
            write_table('candidate_ecological_roles.tsv', roles)
            emit('WARNING', '分类冲突及代码', '原SILVA仅为标签；MiDAS代码不等于培养属，短片段匹配不得定种；原taxonomy不改')
            emit('WARNING', '参考株距离', 'C04/C10/N026/N045/N072部分命名参考株距离大，文献降为远缘背景；C05同属参考也不支持定种')
            emit('WARNING', '文献可访问性', '已核实范围按逐条记录；全文/补充表/近缘基因组/数据库命名映射未完成者NOT_VERIFIED，未检出不等于不存在')
            emit('WARNING', '科研设计与测量缺口', '纵向/不同起始污泥/混合保存恢复/温度与反应器混杂、G5同母样、批次效应；无性能/功能基因或机制实证')
            check(all(sha(p) == v for p,v in protected.items()), '既有科研文件保护', f'{len(protected)}文件SHA256不变')
            report = make_report(started, stamp(), version, summary, literature, genome_table, roles, checks, fingerprints, external, len(hits))
            (out / 'analysis_report.md').write_text(report, encoding='utf-8')
            counts = collections.Counter(x[0] for x in checks)
            log.write('CHECK_COUNTS ' + compact(counts) + '\n')
            for p in sorted(out.iterdir()):
                if p.name != 'run.log':
                    log.write('OUTPUT_SHA256 ' + p.name + ' ' + sha(p) + '\n')
            log.write(f'END {stamp()} elapsed_seconds={time.monotonic()-timer:.3f}\n')
            print(compact(dict(output=str(out), checks=counts, alignments=len(hits))))
        except Exception as e:
            emit('FAIL', '模块2.5必要检查', repr(e))
            raise


# Dated manual adjudications. Database placeholders are operational placements,
# not newly identified cultured genera. No original taxonomy is replaced.
ADJUDICATION = {
    'C02':'保守命名层级Sphingobacteriales目；MiDAS操作定位AKYH767/midas_g_9646（全片段100%）；SILVA科名与MiDAS不一致，非已鉴定属，功能未知。',
    'C04':'保守命名层级Cytophagales目；MiDAS操作定位Microscillaceae/midas_g_85782（全片段100%）；不支持套用Chryseotalea Ys生理。',
    'C05':'保守到Blastocatellaceae科；MiDAS最佳Blastocatella，1个百分点近邻跨Blastocatella/Aridibacter；短16S不能裁定属或定种。',
    'C10':'保守命名层级Cytophagales目；MiDAS候选Microscillaceae，最佳93.617%且跨多个代码属并列；不确认Chryseosolibacter属。',
    'C09':'保守命名层级Rhodobacterales目；原Paracoccaceae与MiDAS Rhodobacteraceae版本名称并列保留；7条100%跨Rhodobacter/Tabrizicola，不能改善为唯一属。',
    'N026':'保守到Anaerolineae纲；MiDAS近邻SBR1031/Flexifilaceae/midas_g_29983（97.037%）；与Phototrophicus ZRK33仅79.506%，不支持光合身份。',
    'N045':'保留Ignavibacteria/SJA-28关联；MiDAS操作定位midas_f_31/midas_g_171（全片段100%）；不确认Tepidaquicella命名属或Ch128a功能。',
    'N072':'支持Ca_Vicinibacter参考谱系关联（MiDAS midas_s_177），不定种；与affinis和proximus两参考MAG各两份16S拷贝全片段100%，不能仅凭旧OLB8代码套用其他分支。',
    'C01':'支持Ca_Competibacter属谱系关联；MiDAS种标签仅记录命中，不作denitrificans种/菌株鉴定或本研究反硝化证据。',
    'C03':'支持Defluviicoccus属谱系关联；99.257%短片段匹配不确定参考cluster或物种，沿用GAO关联对照。',
}
CONSERVATIVE_RANK = dict(C02='order',C04='order',C05='family',C10='order',C09='order',
                         N026='class',N045='order_level_SJA28_lineage',N072='reference_genus_lineage',
                         C01='reference_genus_lineage',C03='reference_genus_lineage')

# The summaries are paraphrases of the actually inspected primary source scope.
# Missing source text is explicitly excluded from verified claims.
PAPERS = {
    'L01': ('10.1007/s00284-019-01823-4',
        'Chryseotalea sanaruensis gen. nov., sp., nov., a Member of the Family Cytophagaceae, Isolated from a Brackish Lake in Hamamatsu Japan',
        'https://pubmed.ncbi.nlm.nih.gov/31792570/', 'Maejima et al. 2020',
        'primary_abstract_verified;full_text_NOT_VERIFIED', 'abstract',
        'YsT/JCM30318，咸淡水湖分离株',
        '参考株好氧；原摘要报告不能代谢葡萄糖及相关糖。',
        '与C04仅91.726%片段identity；培养背景不能归于C04，尤其不能从Bacteroidota标签反推降糖能力。'),
    'L02': ('10.1099/ijsem.0.002318',
        'Aridibacter nitratireducens sp. nov., a member of the family Blastocatellaceae, class Blastocatellia, isolated from an African soil',
        'https://www.microbiologyresearch.org/content/journal/ijsem/10.1099/ijsem.0.002318?crawler=true', 'Huber et al. 2017',
        'primary_abstract_verified;full_text_NOT_VERIFIED', 'abstract',
        'A24_SHP_-5_238T/DSM102177，非洲土壤分离株',
        '该参考株利用多种有机底物，缺氧时可用硝酸盐作替代电子受体。',
        'C05属有歧义且对famidurans/nitratireducens片段均98.020%；不赋予本ASV硝酸盐呼吸、完整反硝化或TN去除。'),
    'L03': ('10.1099/ijs.0.060236-0',
        'Aridibacter famidurans gen. nov., sp. nov. and Aridibacter kavangonensis sp. nov., two novel members of subdivision 4 of the Acidobacteria isolated from semiarid savannah soil',
        'https://pubmed.ncbi.nlm.nih.gov/24573163/', 'Huber et al. 2014',
        'primary_abstract_verified;full_text_NOT_VERIFIED', 'abstract',
        'A22_HD_4HT/DSM26555和Ac_23_E3T/DSM26558，半干旱稀树草原土壤分离株',
        '有真实培养和分类学来源；本次仅采用土壤分离及分类背景。',
        '并非本项目污泥ASV的培养株，不据此推断储存、氮转化或EPS。'),
    'L04': ('10.1007/s10482-022-01756-2',
        'Four new members of the family Cytophagaceae: Chryseosolibacter histidini gen. nov., sp. nov., Chryseosolibacter indicus gen. nov., sp. nov., Dawidia cretensis, gen. nov., sp. nov., and Dawidia soli, gen. nov., sp. nov. isolated from diverse habitat',
        'https://pmc.ncbi.nlm.nih.gov/articles/PMC9296434/', 'Octaviana et al. 2022',
        'primary_abstract_and_relevant_full_text_verified', 'abstract;species descriptions;sequence accession paragraphs',
        'PWU4T和PWU20T；论文包含其他Dawidia株，不能混用',
        'Chryseosolibacter参考株有好氧培养及有机底物利用背景；16S为MW182516/MW182517。',
        'C10与两株仅88.416/90.566%；不能把株特异底物谱或好氧性赋给C10。摘要PWU20采样地与正文描述不一致，本次不裁定、不用于项目来源。'),
    'L05': ('10.1128/mbio.00287-22',
        'Characterization of the First Cultured Representative of “Candidatus Thermofonsia” Clade 2 within Chloroflexi Reveals Its Phototrophic Lifestyle',
        'https://journals.asm.org/doi/10.1128/mbio.00287-22', 'Zheng et al. 2022',
        'primary_relevant_full_text_verified_with_erratum', 'abstract;strain description;data availability;erratum L06',
        'Phototrophicus methaneseepsis ZRK33，深海冷泉分离株',
        '该培养株的光营养、混合营养及有机底物生长已有实验报道。',
        'N026对MN817941及更正后基因组仅79.506%；这是远缘背景，不支持本ASV光合、固碳或甲烷利用。'),
    'L06': ('10.1128/mbio.00657-22',
        'Erratum for Zheng et al., “Characterization of the First Cultured Representative of ‘Candidatus Thermofonsia’ Clade 2 within Chloroflexi Reveals Its Phototrophic Lifestyle”',
        'https://journals.asm.org/doi/10.1128/mbio.00657-22', 'Zheng et al. 2022 erratum',
        'primary_erratum_full_text_verified', 'ERRATUM', 'ZRK33',
        '基因组编号CP051151更正为CP062983，另更正图4A辅因子标签。',
        '原文旧编号不用于参考基因组身份；勘误不是本ASV功能证据。'),
    'L07': ('10.3389/fmicb.2020.572252',
        'Microbial Life in the Deep Subsurface Aquifer Illuminated by Metagenomics',
        'https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2020.572252/full', 'Kadnikov et al. 2020',
        'primary_relevant_full_text_verified', 'Ignavibacteriae Bacterium Ch128a;Fig3;protologue',
        'Ch128a/CP054675，深部地下含水层MAG；原拼写Tepidiaquacella proteinivora',
        '蛋白底物利用、发酵及NrfAH型亚硝酸盐还原为该参考MAG的预测；并非分离株生理实测。',
        'N045与Ch128a仅84.906%，门控关闭；不把该预测转为N045蛋白降解、DNRA或反硝化证据。'),
    'L08': ('10.3389/fmicb.2022.917553',
        'Diversity and Ecophysiology of the Genus OLB8 and Other Abundant Uncultured Saprospiraceae Genera in Global Wastewater Treatment Systems',
        'https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2022.917553/full', 'Kondrotaite et al. 2022',
        'primary_relevant_full_text_Fig5_Table1_and_supplement_verified', 'Fig4;Fig5;Table1;Fig6;Supplementary Tables S9/S10',
        'Ca_Vicinibacter proximus/affinis参考MAG和污泥原位细胞',
        '参考Vicinibacter有异养/水解及PHA潜力；原位检出PHA，糖原及poly-P未检出；观察到絮体内及附着分布。',
        'midas_s_177包含两个基因组种；不把旧OLB8其他分支糖原结果、附着关系或参考MAG基因当本ASV实测；附着不等于产EPS。'),
    'L09': ('10.1038/ismej.2013.162',
        '‘Candidatus Competibacter’-lineage genomes retrieved from metagenomes reveal functional metabolic diversity',
        'https://pmc.ncbi.nlm.nih.gov/articles/PMC3930307/', 'McIlroy et al. 2014 (online 2013)',
        'primary_indexed_abstract_verified;live_full_text_recaptcha', 'indexed primary abstract;module2.2 evidence reused',
        'Competibacter谱系参考基因组', '支持GAO相关糖原/PHA碳储存背景且谱系间代谢多样。',
        'C01为GAO关联对照；不由MiDAS denitrificans标签赋予物种、反硝化活性或竞争机制。'),
    'L10': ('10.1099/mic.0.2006/001032-0',
        'Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes',
        'https://pubmed.ncbi.nlm.nih.gov/17185546/', 'Burow et al. 2007',
        'primary_abstract_verified', 'abstract;FISH-MAR results',
        '全规模EBPR系统Defluviicoccus cluster1/2参考细胞',
        'FISH-MAR支持参考类群底物摄取；cluster2表现与GAO储存模型相容。',
        'C03短片段不能定位这些cluster；不证明项目GAO活性、碳竞争或去除损失。'),
    'L11': ('10.1007/s00253-023-12822-8',
        'Bacterial community and filamentous population of industrial wastewater treatment plants in Belgium',
        'https://link.springer.com/content/pdf/10.1007/s00253-023-12822-8.pdf', 'Seguel Suazo et al. 2024',
        'primary_abstract_and_indexed_Fig4_excerpt_verified;full_text_NOT_VERIFIED', 'Fig4b indexed original PDF excerpt',
        '29个工业污水厂；midas_g_9646代码',
        '原图出现midas_g_9646，提供污泥系统中的同代码出现背景。',
        '出现/分组比例不等于该代码为丝状菌、产EPS或引起膨胀；参考16S原序列未重比对。'),
    'L12': ('10.1186/s12866-023-02765-5',
        'Genome-centric metagenomic insights into the role of Chloroflexi in anammox, activated sludge and methanogenic reactors',
        'https://link.springer.com/article/10.1186/s12866-023-02765-5', 'Bovio-Winkler et al. 2023',
        'primary_full_text_and_indexed_Fig2_excerpt_verified', 'Fig2 genus/species panels;Methods MiDAS3.7 V4 amplicons',
        '污水反应器Chloroflexi；midas_g_29983/midas_s_29983代码',
        '原图含该代码，支持污水背景中的近邻代码出现线索。',
        'N026仅97.037%近邻；该文其他Chloroflexi MAG的水解/EPS/氮功能不能转给该代码或N026，未建立MAG对应。'),
    'L13': ('10.1128/aem.01151-23',
        'Amplicon-guided isolation and cultivation of previously uncultured microbial species from activated sludge',
        'https://pmc.ncbi.nlm.nih.gov/articles/PMC10734543/', 'Verhoeven et al. 2023',
        'primary_relevant_full_text_verified', 'Preparation of single cell suspensions;Fig1c;MiDAS5.1',
        'Aalborg West活性污泥；midas_g_171代码',
        '原研究在活性污泥及分散细胞制备比较中记录midas_g_171。',
        '不把样本制备后相对比例增加称为生长、富集培养成功、纯培养或已知代谢能力。'),
    'L14': ('10.1038/ncomms15416',
        'Metabolic network analysis reveals microbial community interactions in anammox granules',
        'https://pmc.ncbi.nlm.nih.gov/articles/PMC5460018/', 'Lawson et al. 2017',
        'primary_relevant_full_text_verified', 'CHB1/OLB4 comparison;carbon metabolism;discussion',
        'UTCHB1/OLB4，anammox颗粒污泥MAG及转录',
        '参考CHB1/OLB4研究提出蛋白底物分解及硝酸盐/亚硝酸盐循环联系。',
        '相对于N045只是SJA-28相关远缘背景；未把N045比对到这些MAG，不建立本项目互作或氮转化路径。'),
    'L15': ('10.1038/s41522-021-00196-6',
        'Recovery of complete genomes and non-chromosomal replicons from activated sludge enrichment microbial communities with long read metagenome sequencing',
        'https://www.nature.com/articles/s41522-021-00196-6', 'Arumugam et al. 2021',
        'primary_abstract_Table1_and_data_availability_verified', 'Table1 CP058702;data availability',
        'PAO1-tig00198536/CP058702，旧OLB8 sp001567405参考基因组',
        '存在可追溯的活性污泥富集系统参考基因组。',
        'N072对该旧OLB8参考仅90.094%最高；不能套用这个分支，改用实际Vicinibacter近缘MAG。'),
}

REF_PAIRS = [
    ('C04','INSDC_type16S','LC349727.1','GCA_003990915.1','Chryseotalea sanaruensis YsT','L01'),
    ('C05','INSDC_type16S','KF245634.1','NA','Aridibacter famidurans A22_HD_4HT','L03'),
    ('C05','INSDC_type16S','KX443571.1','NA','Aridibacter nitratireducens A24_SHP_-5_238T','L02'),
    ('C10','INSDC_type16S','MW182516.1','JAHESF000000000','Chryseosolibacter histidini PWU4T','L04'),
    ('C10','INSDC_type16S','MW182517.1','JAHESD000000000','Chryseosolibacter indicus PWU20T','L04'),
    ('N026','INSDC_genome','CP062983.1','CP062983.1','Phototrophicus methaneseepsis ZRK33','L05'),
    ('N045','INSDC_genome','CP054675.1','GCA_013348845.1','Ca_Tepidaquicella proteinivorans Ch128a','L07'),
    ('N072','INSDC_genome','CP058702.1','CP058702.1','旧OLB8/PAO1-tig00198536','L15'),
    ('N072','GCA_016714365.1','JADJNH010000005.1','GCA_016714365.1','Ca_Vicinibacter affinis EsbW_18-Q3-R4-48_MAXAC.074','L08'),
    ('N072','GCA_016713905.1','JADJOE010000001.1','GCA_016713905.1','Ca_Vicinibacter proximus Fred_18-Q3-R57-64_BAT3C.331','L08'),
]


def build_evidence(summary, hits, pool, mag_meta):
    rows = []
    genome_rows = []
    context = {'C02':['L11'],'C04':['L01'],'C05':['L02','L03'],'C10':['L04'],
               'C09':[],'N026':['L05','L06','L12'],'N045':['L07','L13','L14'],
               'N072':['L08','L15'],'C01':['L09'],'C03':['L10']}
    for s in summary:
        c = s['candidate_id']
        rows.append(dict(candidate_id=c, feature_id=s['feature_id'], evidence_id=c+'_16S',
            evidence_level='1_ASV_16S_composition', citation='本研究模块2.4有效v2', title='candidate_priority_table.tsv;真实rep-seqs',
            doi='NA', url=B24+'/candidate_priority_table.tsv', verification_status='VERIFIED_LOCAL_ASV_SEQUENCE_AND_SOURCE',
            verified_date=ACCESS_DATE, inspected_scope='原候选表比例/检出原值直接复用；原QZA/FASTA真实片段',
            reference_organism=s['feature_id'], supported_conclusion=f"主29最大比例={pool[c]['main29_max_relative_abundance']};检出={pool[c]['main29_detected_n_ge1']}/29；真实16S片段及MiDAS匹配。",
            relevance_to_ASV='直接组成证据，不是功能/活性证据', prohibited_extrapolation='不等于绝对菌量、代谢基因、活性、独立重复或处理贡献',
            project_function_validation='not_measured'))
        for lid in context[c]:
            doi,title,url,citation,status,section,organism,claim,limit = PAPERS[lid]
            reliable_context = lid in ['L08','L09','L10','L11','L12','L13']
            level = '2_reference_lineage_context' if reliable_context else '4_distant_or_taxonomically_ambiguous_background'
            if lid == 'L12':
                level = '4_near_database_code_context_97pct_not_ASV_identity'
            rows.append(dict(candidate_id=c, feature_id=s['feature_id'], evidence_id=lid,
                evidence_level=level, citation=citation, title=title, doi=doi, url=url,
                verification_status=status, verified_date=ACCESS_DATE, inspected_scope=section,
                reference_organism=organism, supported_conclusion=claim,
                relevance_to_ASV='参考谱系关联；原文未研究本ASV' if reliable_context else '与本ASV亲缘/属身份不足，仅背景或勘误',
                prohibited_extrapolation=limit, project_function_validation='not_measured'))
        if c in ORDER[:7]:
            rows.append(dict(candidate_id=c, feature_id=s['feature_id'], evidence_id=c+'_UNKNOWN',
                evidence_level='5_no_reliable_function_evidence', citation='NA', title='NA', doi='NA', url='NA',
                verification_status='NOT_VERIFIED_FUNCTION', verified_date=ACCESS_DATE,
                inspected_scope='本次定向检索及分类/近缘门控；不是系统综述或不存在证明', reference_organism='NA',
                supported_conclusion='本次没有可可靠赋予该ASV的有机物/储存/氮转化/EPS具体功能证据。',
                relevance_to_ASV='保留功能未知', prohibited_extrapolation='未知不等于没有功能；背景文献不得升级为本ASV机制',
                project_function_validation='not_measured'))
    for c, db, rid, acc, organism, lid in REF_PAIRS:
        selected = [h for h in hits if h['database']==db and h['qseqid']==c and h['sseqid']==rid]
        selected.sort(key=lambda h:(-h['pident'],-h['query_coverage_pct'],-h['bitscore']))
        if not selected:
            raise ValueError(f'Missing actual reference alignment: {c}/{rid}')
        best = selected[0]
        near = c=='N072' and db.startswith('GCA_')
        doi,title,url,*_ = PAPERS[lid]
        published = 'NA'
        negative = 'NA'
        if near:
            if not (best['pident']==100 and best['query_coverage_pct']==100):
                raise ValueError('Vicinibacter reference gate unexpectedly changed')
            published = '原论文Fig5对应MAG列：phaA/phaB/phaC、nosZ及多糖/氨基酸利用相关标注；只归该参考MAG，未新注释或作表达验证。'
            negative = '原Fig5对应MAG列narG/narH/narI=0、glgB/glgC=0；草图/注释缺失不证明永远无此能力；不称完整反硝化、GAO或PAO。'
        genome_rows.append(dict(candidate_id=c, feature_id=pool[c]['feature_id'], reference_organism=organism,
            genome_accession=acc, aligned_sequence_accession=rid, reference_database=db, reference_url=url,
            sequence_access_url='https://www.ncbi.nlm.nih.gov/nuccore/'+rid,
            sequence_record_version=rid.rsplit('.',1)[-1],
            genome_download_url=('https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/'+acc+'/download?include_annotation_type=GENOME_FASTA') if near else
                ('https://www.ncbi.nlm.nih.gov/nuccore/'+rid if db=='INSDC_genome' else 'NA'),
            genome_record_status='VERIFIED_DOWNLOADED_GENOME' if near or db=='INSDC_genome' else
                ('GENOME_MENTION_VERIFIED_NOT_DOWNLOADED' if acc!='NA' else 'NOT_VERIFIED_GENOME_ACCESSION'),
            actual_query_id=c, actual_query_sequence=next(s['sequence'] for s in summary if s['candidate_id']==c),
            query_coverage_pct=best['query_coverage_pct'], identity_pct=best['pident'],
            HSP_n=len(selected), alignments=compact([{k:h[k] for k in ['sstart','send','pident','query_coverage_pct','nident','gaps']} for h in selected]),
            reference_lineage_gate='PASS_NEAR_16S_REFERENCE_ONLY' if near else 'STOP_NO_RELIABLE_NEAR_GENOME_LINK',
            genome_identity_of_ASV='NOT_VERIFIED', asv_gene_or_pathway_assignment='NOT_PERFORMED',
            genome_quality_source='原论文Fig5对应MAG括号；本次不重跑CheckM' if near else 'NA',
            reported_completeness_pct=('99.01' if acc=='GCA_016714365.1' else '98.51') if near else 'NA',
            reported_contamination_pct=('0' if acc=='GCA_016714365.1' else '1.02') if near else 'NA',
            reported_reference_metabolic_potential=published, reported_reference_limits=negative,
            doi=doi, title=title, inspected_scope='Fig5 exact MAG columns;Table1 genus-level Raman;NCBI assembly/isolate metadata' if near else '16S/record comparison and paper background only;stop detailed metabolic audit',
            source_note='S9的type MAG格印为GCA_016714365.1、accession格为GCA_016713905.1；NCBI及正文isolate证明前者affinis、后者proximus；不依赖错误格定种。' if near else '单一短片段相似度不足以绑定基因组；无可靠近缘关系即停止',
            accessed_on=ACCESS_DATE))
        if near:
            rows.append(dict(candidate_id=c, feature_id=pool[c]['feature_id'], evidence_id=acc,
                evidence_level='3_specific_reference_MAG_not_project_ASV', citation='Kondrotaite et al. 2022 Fig5;NCBI Datasets',
                title=title, doi=doi, url=url, verification_status='VERIFIED_REFERENCE_FIGURE_AND_SEQUENCE', verified_date=ACCESS_DATE,
                inspected_scope='Fig5 '+mag_meta[rid]['isolate']+'列；实际下载16S片段两拷贝', reference_organism=organism,
                supported_conclusion=published, relevance_to_ASV='424bp全片段匹配到两个参考种，支持属谱系背景；不确定本ASV物种/基因组',
                prohibited_extrapolation='基因/通路只归于实际研究的参考MAG；不赋予本项目ASV功能基因或活性', project_function_validation='not_measured'))
    for c in ORDER:
        if not any(r['candidate_id']==c for r in genome_rows):
            genome_rows.append(dict.fromkeys(genome_rows[0], 'NA'))
            genome_rows[-1].update(candidate_id=c, feature_id=pool[c]['feature_id'],
                genome_record_status='NOT_VERIFIED_NEAR_GENOME', reference_lineage_gate='STOP_NO_RELIABLE_NEAR_GENOME_LINK',
                genome_identity_of_ASV='NOT_VERIFIED', asv_gene_or_pathway_assignment='NOT_PERFORMED',
                inspected_scope='无可靠逐ASV近缘基因组绑定；对照仅保留既有GAO关联，不强制基因组推断', accessed_on=ACCESS_DATE)
    roles = []
    for s in summary:
        c = s['candidate_id']
        potential = c=='N072'
        control = c in ['C01','C03']
        roles.append(dict(candidate_id=c, feature_id=s['feature_id'], original_label=pool[c]['genus'],
            conservative_taxonomic_conclusion=ADJUDICATION[c],
            ASV_16S_evidence=f"主29检出{pool[c]['main29_detected_n_ge1']}/29；最大相对丰度{pool[c]['main29_max_relative_abundance']}；其余组成指标复用模块2.4。",
            organic_substrate_use='参考Vicinibacter异养/水解背景；本ASV未测' if potential else ('参考GAO谱系碳摄取背景；本ASV未测' if control else 'UNKNOWN'),
            storage_metabolism='参考Vicinibacter PHA证据；不套用旧OLB8糖原结论；本ASV未测' if potential else ('GAO_reference_lineage_only' if control else 'UNKNOWN'),
            nitrogen_transformation='参考MAG部分氮氧化物还原潜力，非完整反硝化；不列为本ASV机制' if potential else 'UNKNOWN',
            EPS_biofilm='参考Vicinibacter絮体内/附着观察；EPS生产未确证；本ASV未测' if potential else 'UNKNOWN',
            sludge_ecology_context='同参考谱系污泥原研究' if c in ['C02','N045','N072','C01','C03'] else
                ('近邻代码在污水原图出现，但97.037%片段不确认为同一ASV' if c=='N026' else '仅本研究组成；原标签培养背景不足以转移功能'),
            functional_status='REFERENCE_SUPPORTED_POTENTIAL_NOT_ASV_VALIDATED' if potential else ('GAO_RELATED_CONTROL_ONLY' if control else 'FUNCTION_UNKNOWN'),
            co_succession_recommendation='优先潜在辅助类群：参考支持的异养/PHA/附着相关候选；只可作待验证假设' if potential else
                ('GAO关联对照' if control else '固定范围内可作组成生态伴随对象；不得作为已知功能辅助类群'),
            evidence_ids=';'.join(r['evidence_id'] for r in rows if r['candidate_id']==c),
            project_function_validation='not_measured', performance_or_causal_inference='NOT_PERFORMED'))
    return rows, genome_rows, roles


def make_report(started, ended, version, summary, literature, genomes, roles, checks, fingerprints, external, nhits):
    counts = collections.Counter(x[0] for x in checks)
    classification = md(['对象','长度bp','MiDAS最佳identity/coverage%','并列数','MiDAS最佳谱系共同部分','审核结论'],
        [[s['candidate_id'],s['sequence_length_bp'],f"{s['best_identity_pct']:.3f}/{s['query_coverage_pct']:.1f}",s['best_identity_tie_n'],s['best_tie_LCA'],s['reliable_interpretation']] for s in summary])
    references = md(['对象','参考株/MAG','实际序列编号','identity%','coverage%','代谢审核门控'],
        [[r['candidate_id'],r['reference_organism'],r['aligned_sequence_accession'],r['identity_pct'],r['query_coverage_pct'],r['reference_lineage_gate']] for r in genomes])
    bibliography = '\n\n'.join(f"- **{lid}** {p[3]}. [{p[1]}]({p[2]}). DOI: {p[0]}。核实范围：{p[4]}；定位：{p[5]}。研究对象：{p[6]}。支持：{p[7]} 限制：{p[8]}" for lid,p in PAPERS.items())
    manifest = md(['输入路径','SHA256'], list(fingerprints.items()))
    ext = md(['实际外部输入（运行时临时路径）','SHA256'], list(external.items()))
    return f'''# 模块2.5第一阶段：重点非传统候选ASV分类核实与潜在生态证据调查（V2）

实际分析运行：{started} 至 {ended}（Asia/Shanghai）。外部检索/下载及初步比对发生在同日、正式脚本前，阶段记录见项目分析日志；不把正式运行时间冒充整个检索耗时。Python {platform.python_version()}；{version.splitlines()[0]}。

**交付PASS：{counts['PASS']} PASS / {counts['WARNING']} WARNING / {counts['FAIL']} FAIL。** 此计数仅针对实际交付必要检查；功能、性能及因果门控均未因此通过。七个重点对象仍保留功能未知；N072仅获得近缘参考谱系的潜在生态角色支持，C01/C03为原GAO关联对照。

## 执行前检查、依据与范围

已阅读AGENTS及背景/设计/计划/日志、模块1.1–2.4当前有效v2报告。先检查真实文件与ID、报告歧义和计划，再处理数据。固定C02/C04/C05/C10/C09/N026/N045/N072共8目标，另有C01/C03两个对照；没有扩大项目候选。原始代表序列实际取自现有FASTA，并只读核对原rep-seqs.qza内部相同序列；7条已有C编号复用模块2.2审核，3条N编号本次首次提取。原SILVA完整Taxon、原字符串Confidence、真实查询序列与指纹均写入分类表，不覆盖taxonomy。

保持33样本及G1–G5=8/2/4/15/4，主29与G5单母样四粒径级分边界不变。G4四份初始污泥不同、四反应器纵向采样；R1/R3=30℃运行标签，R2/R4室温数值未知；R1缺30d；前期混合均分、4℃59d保存恢复及轮次依赖仍在。G1–G5共享名义人工进水配方，不能当同期实测、独立水质重复或样本间协变量。无可靠同期出水、去除率、功能基因/活性；温度与DO因果、处理性能关联、网络、PICRUSt2均未执行。未重复DADA2/SILVA/深度QC/Alpha-Beta或ASV筛选，也未更新RDS。

## 数据库、实际比对与解释规则

MiDAS适用于污水/消化系统的依据为[MiDAS4原研究](https://www.nature.com/articles/s41467-022-29438-7)（DOI 10.1038/s41467-022-29438-7）与[MiDAS5原研究](https://www.nature.com/articles/s41467-024-49641-y)（DOI 10.1038/s41467-024-49641-y）。2026-11-08从[官方下载入口](https://www.midasfieldguide.org/guide/downloads)对应[5.3 SINTAX序列文件]({MIDAS_URL})实际下载169354955 bytes、111037条参考，完整SHA256 `{MIDAS_SHA}`；版本由具体下载文件锁定，不声称已查遍所有参考库或全网最新版本。初次沙箱网络禁止、经权限工具访问；首段下载超时后续传，最终完整指纹/格式通过才使用。MiDAS动态网页属页面未可靠呈现，不将其空白页面当功能证据。

完整参考库建立临时BLAST索引，10条实际查询同时检索。blastn task=blastn、word_size=11、dust=no、evalue=1e-10、perc_identity=85、qcov_hsp_perc=90、max_target_seqs=200000（大于全部参考条数）、max_hsps=1、2线程。结果实际21643个MiDAS HSP，全部保留于压缩比对表。后续分类摘要只取查询覆盖≥99%的HSP，以identity优先、coverage/bit score/ID确定输出顺序；同最高identity与覆盖率者全部并列，**排序首位不代表唯一分类**。另审阅距最佳0.5/1.0个百分点内所有匹配的最近共同谱系，作为预设歧义检查，不是统计置信区间或通用物种界限。保留1个百分点结果较保守；跨属不强配属。blastn为启发式检索，未进行全长16S系统树或全库穷举动态规划，低相似未知分支仍可能欠覆盖。

查询404–429bp；MiDAS摘要匹配均覆盖查询100%。历史引物线索338F/806R，**精确引物切除及E. coli通用坐标未独立对齐核定**；按实际查询全片段相同/合理覆盖比较，不能写成已经核实统一全长V3–V4或全长16S。identity=匹配碱基/含gap对齐列数，coverage=HSP覆盖查询碱基/查询长度；逐HSP重算并与原查询/参考逐碱基断言核对，subject正/反向坐标保留。原Confidence是分类器分值，非功能概率。历史参数日志classifier文件名为silva144-2026.7-full-length.qza，记录的classifier SHA256为e6a6ac57b880c4f9e92baf8c4050483a6deed2615a9c001a7251c01dfe32a047；confidence=0.7、read_orientation=same。这里只转述可回查的旧日志，未加载该外部分类器，其文件名不替代训练数据库来源核实。

参考株/MAG定向比对不设85%截断，保留远缘证据；基因组最多10个HSP以保留拷贝。参考库之间的门/纲/目/科命名变化逐来源保留，例如原Paracoccaceae与MiDAS Rhodobacteraceae、原Lewinellaceae/OLB8与MiDAS Saprospiraceae/Ca_Vicinibacter。未独立重建命名体系或证明所有差异是生物学冲突；保守命名层级及数据库操作代码分开报告。`midas_s_*`是参考库标签，不是本ASV物种确证。

## 已核实的序列事实与分类结论

{classification}

1. **C02**：从Incertae_Sedis推进到MiDAS可回查的AKYH767 / midas_g_9646操作谱系，但这仍是代码类群。跨体系保守命名层级为Sphingobacteriales目，不再把旧Sphingobacteriaceae科标签视为独立确认。工业污水原图L11有同代码出现背景，未获得培养、近缘基因组或目标功能证据。
2. **C04/C05**：两者有真实可追溯的原标签培养文献，但可靠关联程度不足。C04对Ys仅91.726%，而MiDAS全片段匹配未知代码midas_g_85782，不能采用Ys生理。C05对两Aridibacter株同为98.020%，MiDAS最佳却为Blastocatella（9条并列、多个species代码），1个百分点近邻跨两属，保守到Blastocatellaceae；不列为硝酸盐还原菌。
3. **C09**：7条全片段100%并列包含Rhodobacter与Tabrizicola，不能改善到唯一属；即使最高identity=100%、原Confidence很高，仍保持功能未知。科名按两数据库并列保存，保守共识为Rhodobacterales目。
4. **C10**：MiDAS最佳93.617%且并列跨代码属，对PWU4/PWU20仅88.416/90.566%；原Chryseosolibacter培养背景不足以支持本ASV的异养或水解功能判断。
5. **N026/N045**：分别获得midas_g_29983近邻（97.037%）与midas_g_171全片段匹配。L12/L13分别提供污水系统的代码出现背景；未把N026等同原图ASV，也未把N045的样本分散后相对比例上升当培养/生长证据。ZRK33和Ch128a分别只有79.506%和84.906%，相关光合/固碳、蛋白分解/亚硝酸盐代谢仅远缘背景。
6. **N072**：实际MiDAS为Ca_Vicinibacter / midas_s_177，6条100%并列、近0.5/1个百分点仍同谱系。它属于原研究中与旧OLB8其他分支不同的参考组，不能套用Ca_Brachybacter/Parvibacillus的糖原结论。两个实际下载的Vicinibacter参考MAG，各有两份424bp匹配100%的16S片段，仍不能选择唯一种或菌株。

## 近缘参考基因组与代谢审核

{references}

N072对**GCA_016714365.1（EsbW_18-Q3-R4-48_MAXAC.074；Ca_Vicinibacter affinis）**和**GCA_016713905.1（Fred_18-Q3-R57-64_BAT3C.331；Ca_Vicinibacter proximus）**均为424/424bp、100% query coverage，各两份16S拷贝同样匹配。NCBI原始assembly/isolate记录和完整参考MAG已归档；两物种不能由本片段区分，ASV的真实基因组归属为NOT_VERIFIED。

因此只对这两个近缘**参考MAG**审核论文Fig5对应列，不重新做基因注释：报道phaABC、nosZ及若干多糖/氨基酸利用相关标注；对应narGHI、glgB/glgC为0，不能称完整反硝化或典型GAO。草图/注释中未见不等于物种永远缺失。原研究Table1的Vicinibacter原位细胞有PHA而未检出糖原或poly-P；Fig6有附着于其他细胞的观察。这里的基因、储存聚合物和附着证据分别来自参考MAG与参考原位细胞，**均不是本项目ASV实测**；附着不等于已证明产生EPS、促进成粒、共生或物质交换。

补充表S9存在可回查的编号歧义：type-MAG格印GCA_016714365.1，MAG/SAG accession格为GCA_016713905.1；正文参考isolate及实际NCBI记录分别把它们对应到affinis与proximus。本次保留这一不一致，按真实assembly/isolate核对，不从错误单元格强配物种。S10及正文给出的EsbW isolate可回查；原补充PDF和Fig5原图均在参考证据包中。

其余7目标的近缘基因组门控停止，不强制寻找/补造基因或通路；已知背景株的存在不代表可靠近缘。C01/C03仅复用/复核GAO关联原研究，不由MiDAS短片段种标签扩大为具体反硝化、PAO或菌株基因组身份。

## 文献证据层级及核实范围

证据表区分：1本ASV的真实16S/组成；2可靠参考谱系或代码出现背景；3特定近缘参考MAG；4远缘/分类歧义背景；5没有可可靠关联的功能证据。数据库分类匹配另在分类表，不以文献替代序列比对。每条原文标题、DOI、对象、核实日期、可访问摘要/全文/图表范围和禁止外推已记录。L11/L12图中代码仅由可访问的原论文图文索引核实，未重新下载该文参考16S或绑定其MAG；L01–L03等全文未读部分为NOT_VERIFIED。文献快照是本日人工核验，不把脚本重放当再次联网核实。

{bibliography}

## 潜在生态角色、未知对象与后续问题

**适合优先作为潜在辅助类群的是N072**：可以提出“Vicinibacter相关异养底物利用/PHA暂存及絮体或附着生态背景，可能与群落共同演替相伴”的有限假设。后续若只复用现有16S，应在同反应器实际采样节点中描述它与C01/C03等的组成变化；不得把共同升降写成协作、竞争或交叉营养，也不能验证PHA通量、EPS生成、硝态氮利用、去除贡献或温度/DO机制。本阶段未计算任何共同演替关系或网络。

**C02、C04、C05、C10、C09、N026、N045的具体功能仍为UNKNOWN。** C02/N045及N026近邻已有污泥/污水代码出现背景，适合在固定范围内作为组成生态伴随对象；C04/C05/C10的原命名属生理不能直接套用，C09即使100%匹配也无法选属。它们可以保留在共同演替描述中，但不能预先分配“辅助去除”“EPS生产”“储存菌”或“氮转化菌”角色。未知不等于无功能。

目前支持的是组成生态学与N072参考谱系层面的代谢潜力假设，不能建立本研究特异的碳—氮—EPS机制路径。G4初始差异、纵向依赖、不平衡节点、共享谱系及温度/反应器混杂均未消除；提取/PCR/测序子批次效应、扩增和16S拷贝偏倚未分离。相对丰度不等于绝对菌量或VSS/MLVSS归一化的严格绝对丰度。

## 尚未核实的项目（明确保留）

- 全部10对象的物种/菌株身份、真实全基因组、项目功能基因/表达/活性：NOT_VERIFIED或not_measured。
- 7个未知功能目标的可靠近缘基因组：门控STOP；不把未找到当作不存在，不强制推断。
- 部分文献全文、全部原始实验数据及所有补充基因注释明细：仅核实上文列明范围。N072使用Fig5实际两MAG列，未重新运行KEGG/基因组注释或逐基因验证。
- MiDAS页面知识卡的动态功能内容、其他参考库交叉核实、全长16S系统树、精确扩增通用坐标：NOT_VERIFIED/未执行。C02/C04代码是否已有更新命名亦未确认。
- 原补充表S9编号印刷歧义、原L04摘要与正文采样地不一致保留，不影响本研究原始metadata。

## 实际检查、产物与复现

{md(['状态','检查','实际依据'], checks)}

最终九文件：四张candidate_*.tsv、[analysis_report.md](analysis_report.md)、[run.log](run.log)、[reference_alignments_v2.tsv.gz](reference_alignments_v2.tsv.gz)、[reference_sequences_v2.fasta.gz](reference_sequences_v2.fasta.gz)、[reference_evidence_v2.zip](reference_evidence_v2.zip)。压缩比对表共{nhits}条，含真实查询/subject对齐、坐标、低identity背景、并列；匹配参考序列包不冒充完整MiDAS。参考原件ZIP含六条16S、三个GenBank、两个完整MAG下载包、原论文补充PDF/代谢图（按6个源文件条目归档）。没有中间检查图表；本次临时索引随成功运行清理。

入口：[candidate_ecology_validation_v2.py](../../../scripts/candidate_ecology_validation_v2.py)。Python标准库，现有BLAST，无安装或随机步骤。先按MiDAS_URL下载并核对完整SHA256；从参考证据ZIP解出type16S.fasta、genome_records.gb、vicinibacter_1.zip、vicinibacter_2.zip、supplement.pdf、metabolic_figure.webp至本次临时目录，再运行：

```bash
python3 scripts/candidate_ecology_validation_v2.py --midas-fasta /path/to/MiDAS_5.3.fa --type-fasta /path/to/type16S.fasta --genbank /path/to/genome_records.gb --vicinibacter-zips /path/to/vicinibacter_1.zip /path/to/vicinibacter_2.zip --supplement-pdf /path/to/supplement.pdf --metabolic-figure /path/to/metabolic_figure.webp --output-dir results/candidate_ecology/new_date_v2
```

默认正式目录已存在时非零拒绝；必须指定新_v2目录。正式运行可复用本日实际MiDAS检索的`--precomputed-midas`结果以避免重复检索，仍对每条HSP与完整参考库逐碱基核验，原命令/文件指纹写入run.log；从头复现省略该参数即重新检索。文献事实是脚本内冻结的人工审核记录；未来增量证据需新版本，不覆盖本次。输入保护SHA256在运行前后实际比较，必要失败非零，不保存失败步骤为成功报告。

### 项目输入指纹

{manifest}

### 外部参考原件指纹

{ext}

正式命令、软件版本、脚本指纹、实际输入/输出SHA256、起止时间及参数见run.log。三份项目总文档随后更新不改写本次输入历史指纹。**0 FAIL仅代表交付必要条件通过，不能理解为功能未知或科研前提已解决。**
'''


if __name__ == '__main__':
    main()
