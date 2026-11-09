#!/usr/bin/env python3
"""Batch_01 module 2.6: frozen v2 observations and ecological evidence, offline.

Python standard library; R base graphics only. No upstream recalculation.
An existing output directory is never reused or overwritten.
"""
import argparse
import collections
import csv
import hashlib
import json
import math
from pathlib import Path
import platform
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from datetime import datetime
from zoneinfo import ZoneInfo
import zlib

ROOT = Path(__file__).resolve().parents[1]
B21 = 'results/asv_contributions/2026-11-05_v2'
B24 = 'results/ecological_candidates/2026-11-07_v2'
B25 = 'results/candidate_ecology/2026-11-08_v2'
B23 = 'results/operational_performance/2026-11-06_design_recipe_v2'
TARGETS = ['C02', 'C04', 'C05', 'C10', 'C09', 'N026', 'N045', 'N072', 'C01', 'C03']
UNITS = {'A': ['C01', 'C02', 'C10', 'C09', 'N072'],
         'B': ['C03', 'C04', 'C05', 'N026', 'N045', 'N072'],
         'C': ['C01', 'C03', 'N026', 'N045', 'N072']}
ACTORS = {'A': ['R1', 'R2'], 'B': ['R3'], 'C': ['R2', 'R4']}
NAMES = {'A': 'R1/R2分化', 'B': 'R3后期', 'C': 'R2/R4趋近'}
# Fixed before examining module 2.6 abundance results; no substitution if gated.
RATIOS = [('A', 'R1', 'C02', 'C10', [76, 145]),
          ('B', 'R3', 'C04', 'C03', [30, 76, 145]),
          ('C', 'R2', 'N072', 'C01', [1, 30, 76, 145]),
          ('C', 'R4', 'N072', 'C01', [1, 30, 76, 145])]
SHORT = {'C01': 'Ca_Competibacter lineage', 'C02': 'Sphingobacteriales; midas_g_9646 code',
         'C03': 'Defluviicoccus lineage', 'C04': 'Cytophagales; midas_g_85782 code',
         'C05': 'Blastocatellaceae; genus unresolved',
         'C10': 'Cytophagales; Microscillaceae candidate',
         'C09': 'Rhodobacterales; genus unresolved',
         'N026': 'Anaerolineae; near midas_g_29983',
         'N045': 'Ignavibacteria / SJA-28; midas_g_171 code',
         'N072': 'Ca_Vicinibacter lineage; no species'}
REPORTS = [
 'results/community_composition/2026-11-03_v2/analysis_report.md',
 'results/functional_guilds/2026-11-03_v2/analysis_report.md',
 'results/diversity/2026-11-04_v2/analysis_report.md',
 'results/diversity/2026-11-04_v2/module12_review.md',
 f'{B21}/analysis_report.md',
 'results/candidate_asvs/2026-11-05_v2/analysis_report.md',
 f'{B23}/analysis_report.md', f'{B24}/candidate_screening_report.md',
 f'{B25}/analysis_report.md']
DATA = ['data/asv_table.tsv', 'data/taxonomy.tsv',
        'data/exported_sequences/dna-sequences.fasta',
        'metadata/source_sample_metadata.tsv',
        f'{B21}/analysis_metadata_addendum.tsv', f'{B23}/analysis_metadata.tsv',
        f'{B21}/focal_asv_abundance_trajectories.tsv',
        f'{B21}/focal_pairwise_asv_contributions.tsv',
        f'{B21}/focal_temporal_asv_changes.tsv', f'{B21}/focal_distance_summary.tsv',
        f'{B24}/all_asv_ecological_features.tsv', f'{B24}/candidate_priority_table.tsv',
        *[f'{B25}/{x}.tsv' for x in ['candidate_taxonomy_validation',
          'candidate_ecological_roles', 'candidate_literature_evidence',
          'candidate_reference_genomes']]]
DOCS = ['AGENTS.md', 'docs/research_context.md', 'docs/batch_01/experiment_design.md',
        'docs/batch_01/analysis_plan.md', 'docs/batch_01/analysis_log.md']


def now():
    return datetime.now(ZoneInfo('Asia/Shanghai')).isoformat(timespec='seconds')


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def read(path):
    with open(ROOT / path, newline='') as f:
        r = csv.DictReader(f, delimiter='\t')
        rows = list(r)
        if not r.fieldnames or len(set(r.fieldnames)) != len(r.fieldnames):
            raise ValueError(f'Invalid header: {path}')
        if any(None in x or any(v is None for v in x.values()) for x in rows):
            raise ValueError(f'Invalid row width: {path}')
        return rows


def index(rows, key):
    d = {x[key]: x for x in rows}
    if len(d) != len(rows):
        raise ValueError(f'Duplicate {key}')
    return d


def fmt(v):
    if v is None:
        return 'NA'
    if isinstance(v, float):
        if not math.isfinite(v):
            raise ValueError('Nonfinite output')
        return format(v, '.16g')
    return str(v)


def write_tsv(path, rows):
    fields = list(dict.fromkeys(k for row in rows for k in row))
    with open(path, 'x', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields, delimiter='\t', lineterminator='\n')
        w.writeheader()
        w.writerows({k: fmt(row.get(k)) for k in fields} for row in rows)
    with open(path, newline='') as f:
        back = list(csv.DictReader(f, delimiter='\t'))
    expected = [{k: fmt(row.get(k)) for k in fields} for row in rows]
    if back != expected:
        raise ValueError(f'Serialization mismatch: {path}')


def mdtable(headers, rows):
    return '\n'.join(['| ' + ' | '.join(headers) + ' |',
                      '|' + '|'.join(['---'] * len(headers)) + '|'] +
                     ['| ' + ' | '.join(str(v).replace('|', '/') for v in row) + ' |'
                      for row in rows]) + '\n'


def validate_png(path):
    b = path.read_bytes()
    if b[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError('PNG signature')
    off, dat, dims = 8, bytearray(), None
    while off < len(b):
        n = struct.unpack('>I', b[off:off+4])[0]
        tag, chunk = b[off+4:off+8], b[off+8:off+8+n]
        crc = struct.unpack('>I', b[off+8+n:off+12+n])[0]
        if zlib.crc32(tag + chunk) != crc:
            raise ValueError('PNG CRC')
        if tag == b'IHDR':
            dims = struct.unpack('>II', chunk[:8])
        if tag == b'IDAT':
            dat.extend(chunk)
        off += n + 12
        if tag == b'IEND':
            break
    if off != len(b) or not zlib.decompress(dat):
        raise ValueError('PNG stream')
    return dims


class Run:
    def __init__(self, out):
        self.out, self.checks = out, []
        self.log = open(out / 'run.log', 'x', buffering=1)

    def check(self, ok, name, evidence, status='PASS'):
        state = status if ok else 'FAIL'
        self.checks.append((state, name, evidence))
        self.log.write(f'{now()} {state} {name}: {evidence}\n')
        if not ok:
            raise ValueError(f'{name}: {evidence}')

    def warn(self, name, evidence):
        self.check(True, name, evidence, 'WARNING')


def analyse(run):
    inputs = list(dict.fromkeys(DATA + REPORTS + DOCS + [f'{B24}/run.log', f'{B25}/run.log']))
    run.check(all((ROOT / p).is_file() for p in inputs), '输入存在', f'{len(inputs)}个指定输入')
    fingerprints = {p: sha(ROOT / p) for p in inputs}
    for p, h in fingerprints.items():
        run.log.write(f'INPUT_SHA256 {p} {h}\n')
    texts = {p: (ROOT / p).read_text() for p in REPORTS + DOCS}
    # Verify frozen source files using upstream reports and final delivery manifests.
    alltext = '\n'.join(texts.values())
    for p in DATA:
        if p.startswith(B25):
            lines = (ROOT / B25 / 'run.log').read_text().splitlines()
            hs = [h for l in lines if l.startswith(('OUTPUT_SHA256 ', 'DELIVERY_SHA256 ', 'OUTPUT '))
                  and Path(p).name in l for h in re.findall(r'\b[0-9a-f]{64}\b', l)]
        elif p.startswith(B24):
            lines = (ROOT / B24 / 'run.log').read_text().splitlines()
            hs = [h for l in lines if l.startswith(('OUTPUT_SHA256 ', 'DELIVERY_SHA256 ', 'OUTPUT '))
                  and Path(p).name in l for h in re.findall(r'\b[0-9a-f]{64}\b', l)]
        else:
            hs = [h for line in alltext.splitlines() if p in line
                  for h in re.findall(r'\b[0-9a-f]{64}\b', line)]
        run.check(fingerprints[p] in hs, '有效v2指纹/' + Path(p).name,
                  p + '; SHA256=' + fingerprints[p])
    for p in REPORTS[:3] + REPORTS[4:6] + REPORTS[6:8]:
        run.check(any(p in line and fingerprints[p] in line
                      for line in alltext.splitlines()), '报告来源/' + p.split('/')[1], p)

    tax = index(read(f'{B25}/candidate_taxonomy_validation.tsv'), 'candidate_id')
    roles = index(read(f'{B25}/candidate_ecological_roles.tsv'), 'candidate_id')
    lit = read(f'{B25}/candidate_literature_evidence.tsv')
    genomes = read(f'{B25}/candidate_reference_genomes.tsv')
    run.check(set(tax) == set(roles) == set(TARGETS), '固定十对象', ';'.join(TARGETS))
    fid = {c: tax[c]['feature_id'] for c in TARGETS}
    run.check(len(set(fid.values())) == 10 and all(roles[c]['feature_id'] == fid[c] for c in TARGETS),
              'ASV映射唯一', '8目标+2对照，不重筛')
    rev = {v: k for k, v in fid.items()}
    raw = index(read('metadata/source_sample_metadata.tsv'), 'sample-id')
    meta = index(read(f'{B23}/analysis_metadata.tsv'), 'sample-id')
    m21 = index(read(f'{B21}/analysis_metadata_addendum.tsv'), 'sample-id')
    run.check(len(meta) == 33 and set(raw) == set(meta) == set(m21), '33样本身份', '原表与有效2.1/2.3一一对应')
    run.check(all(all(m[k] == meta[s][k] for k in m) for src in [raw, m21] for s, m in src.items()),
              '原metadata保留', '原14列及模块2.1全部63列逐值保留')
    # Match authoritative design table, never infer group from sample name.
    design = texts['docs/batch_01/experiment_design.md']
    for g, n in zip(['G1', 'G2', 'G3', 'G4', 'G5'], [8, 2, 4, 15, 4]):
        lines = [x for x in design.splitlines() if x.startswith('| ' + g + ' |') and 'Batch_01_' in x]
        run.check(len(lines) == 1, '设计名单/' + g, '权威完整名单唯一')
        expected = set(re.findall(r'Batch_01_[A-Z][0-9]+', lines[0]))
        actual = {s for s, m in meta.items() if m['group'] == g}
        run.check(actual == expected and len(actual) == n, '分组/' + g, f'{n}行逐ID一致')
    g4 = [s for s, m in meta.items() if m['group'] == 'G4']
    reactor = {s: 'R' + m['reactor_id'][-1] for s, m in meta.items()}
    nodes = {r: sorted([s for s in g4 if reactor[s] == r], key=lambda s: int(meta[s]['phase_days']))
             for r in ['R1', 'R2', 'R3', 'R4']}
    run.check([[int(meta[s]['phase_days']) for s in nodes[r]] for r in nodes]
              == [[1, 76, 145], [1, 30, 76, 145], [1, 30, 76, 145], [1, 30, 76, 145]],
              'G4实际节点', '3/4/4/4；基线4+后期11；R1-30d不插补')
    run.check(all(meta[s]['reactor_round'] == 'G4G5_low_DO' and
                  meta[s]['G4_historical_storage_days'] == '59' and
                  meta[s]['G4_initial_sludge_distinctness'] != 'NA' and
                  meta[s]['temperature_regime'] == ('controlled_30C' if reactor[s] in ['R1', 'R3'] else 'ambient_unmeasured')
                  for s in g4), 'G4实体/保存/温度/初始差异', '四不同起始状态；30℃与室温标签不用于因果估计')
    run.check(all(m['DO_measured_mg_L'] == m['temperature_measured_C'] == 'NA'
                  and m['influent_data_type'] == 'design_recipe'
                  and m['performance_association_gate'] == 'closed_missing_measured_performance' for m in meta.values()),
              '实测与性能门控', '共同名义配方；无瞬时DO/温度及可匹配性能')
    run.check(len({m['influent_recipe_id'] for m in meta.values()}) == 1 and
              len({m['fractionation_event_id'] for m in meta.values() if m['group'] == 'G5'}) == 1,
              '配方及G5层级', '一设计配方；G5一母样四级分')
    run.check(all(meta[s]['sampling_position_relative_to_DO_switch'] == ('before_switch' if int(meta[s]['phase_days']) == 1 else 'after_switch')
                  for s in g4), '基线与后期', '恢复后切换前与设计稳定期分列，性能稳态未验证')
    source_map = {'Batch_01_E1':'Batch_01_A2', 'Batch_01_F1':'Batch_01_B3',
                  'Batch_01_G1':'Batch_01_C2', 'Batch_01_H1':'Batch_01_D3'}
    run.check(all(meta[s]['source_sample_id']==src and
                  meta[s]['G4_baseline_recovery_DO_setpoint_mg_L']=='3' and
                  meta[s]['DO_setpoint_mg_L']=='NA' and
                  meta[s]['reactor_instance_id']!=meta[src]['reactor_instance_id']
                  for s,src in source_map.items()), '保存恢复与基线来源', '四条直接前源逐ID；新G4实体；旧分析NA与恢复设置3分列')
    run.check(all(meta[a]['continuous_run_id']==meta[b]['continuous_run_id']
                  for a,b in [('Batch_01_B2','Batch_01_B3'),('Batch_01_D2','Batch_01_D3')]) and
              meta['Batch_01_A2']['pool_id']==meta['Batch_01_B3']['pool_id']!='NA' and
              meta['Batch_01_C2']['pool_id']==meta['Batch_01_D3']['pool_id']!='NA' and
              meta['Batch_01_A2']['pool_id']!=meta['Batch_01_C2']['pool_id'] and
              all(meta[s]['continuous_run_id']==meta['Batch_01_E3']['continuous_run_id']
                  for s,m in meta.items() if m['group']=='G5'),
              '混合/连续/纵向层级', 'G2/G3同轮、两共享混合块、G4另轮；G5延续R1但四级分仅一母样')
    # Reuse all 33 sample proportions; stream existing large tables without copying them.
    features = {}
    with open(ROOT / B24 / 'all_asv_ecological_features.tsv') as f:
        r = csv.DictReader(f, delimiter='\t')
        allids = set()
        for row in r:
            if row['feature_id'] in allids:
                raise ValueError('Duplicate ASV in module 2.4')
            allids.add(row['feature_id'])
            if row['feature_id'] in rev:
                features[rev[row['feature_id']]] = row
    run.check(len(allids) == 5510 and len(features) == 10, '原ASV范围', '5510个ID中只提取10目标；不改变筛选')
    p = {(c, s): float(features[c]['relative_abundance__' + s]) for c in TARGETS for s in meta}
    counts = {}
    with open(ROOT / 'data/asv_table.tsv') as f:
        next(f)
        r = csv.DictReader(f, delimiter='\t')
        countids, depths = set(), {s: 0 for s in meta}
        run.check(set(r.fieldnames[1:]) == set(meta), '计数样本ID', '只核验本模块计算必需条件')
        for row in r:
            a = row['#OTU ID']
            if a in countids:
                raise ValueError('Duplicate count ASV')
            countids.add(a)
            for s in meta:
                x = float(row[s])
                if not math.isfinite(x) or x < 0 or not x.is_integer():
                    raise ValueError('Noninteger or missing count')
                depths[s] += int(x)
                if a in rev:
                    counts[rev[a], s] = int(x)
    run.check(countids == allids and all(n > 0 for n in depths.values()), '计数必要条件',
              '非负整数/无NA/无空样本；不重复深度异常QC')
    run.check(all(0 <= v <= 1 and abs(v - counts[c, s]/depths[s]) < 1e-13 for (c, s), v in p.items()),
              '330个原比例复用', '全部reads分母；模块2.4比例与原计数一致，不重新归一化目标子集')
    original_tax = index(read('data/taxonomy.tsv'), 'Feature ID')
    with open(ROOT / 'data/exported_sequences/dna-sequences.fasta') as f:
        seqids = [line[1:].strip().split()[0] for line in f if line.startswith('>')]
    run.check(len(seqids) == len(set(seqids)) == 5510 and set(seqids) == set(original_tax) == allids,
              '上游Feature ID', '原taxonomy/FASTA/ASV表一致；序列QC沿用不变指纹')
    run.check(all(tax[c]['original_SILVA_Taxon'] == original_tax[fid[c]]['Taxon'] and
                  tax[c]['original_SILVA_Confidence'] == original_tax[fid[c]]['Confidence'] and
                  tax[c]['reliable_interpretation'] == roles[c]['conservative_taxonomic_conclusion']
                  for c in TARGETS), '分类原值与保守解释', '原SILVA及MiDAS审核逐字符复用，不覆盖taxonomy')
    run.check(all(roles[c]['functional_status'] == 'FUNCTION_UNKNOWN' and
                  all(roles[c][k] == 'UNKNOWN' for k in ['organic_substrate_use', 'storage_metabolism', 'nitrogen_transformation', 'EPS_biofilm'])
                  for c in TARGETS[:7]) and roles['N072']['functional_status'] == 'REFERENCE_SUPPORTED_POTENTIAL_NOT_ASV_VALIDATED'
                  and all(roles[c]['functional_status'] == 'GAO_RELATED_CONTROL_ONLY' for c in ['C01', 'C03']),
              '功能证据门控', '7 UNKNOWN；N072只参考潜力；2 GAO关联对照；项目功能均未测')
    trajectory = {}
    with open(ROOT / B21 / 'focal_asv_abundance_trajectories.tsv') as f:
        for row in csv.DictReader(f, delimiter='\t'):
            if row['feature_id'] in rev:
                k = rev[row['feature_id']], row['sample_id']
                if k in trajectory:
                    raise ValueError('Duplicate G4 trajectory')
                trajectory[k] = row
    run.check(len(trajectory) == 150 and all(int(x['count']) == counts[k] and abs(float(x['relative_abundance'])-p[k]) < 1e-13
                  and x['reactor'] == reactor[k[1]] and int(x['day']) == int(meta[k[1]]['phase_days']) for k, x in trajectory.items()),
              '2.1轨迹复用', '150个真实G4节点值/count/实体与2.4一致')
    distances = index(read(f'{B21}/focal_distance_summary.tsv'), 'pair_id')
    contrib, sums = {}, collections.defaultdict(float)
    with open(ROOT / B21 / 'focal_pairwise_asv_contributions.tsv') as f:
        for x in csv.DictReader(f, delimiter='\t'):
            sums[x['pair_id']] += float(x['bray_contribution'])
            if x['feature_id'] in rev:
                key = x['pair_id'], rev[x['feature_id']]
                if key in contrib:
                    raise ValueError('Duplicate contribution')
                contrib[key] = x
    run.check(len(contrib) == 100 and len(sums) == 10 and all(abs(sums[k]-float(distances[k]['Bray_Curtis'])) < 1e-12 for k in sums),
              '既有贡献守恒', '只汇总原10对贡献核对原Bray，不重新计算Alpha/Beta')
    run.check(all(abs(float(x['bray_contribution'])-float(features[c]['bray_'+pair])) < 1e-13
                  and abs(float(x['relative_abundance_a'])-p[c,x['sample_a']]) < 1e-13
                  and abs(float(x['relative_abundance_b'])-p[c,x['sample_b']]) < 1e-13
                  for (pair,c),x in contrib.items()), '贡献与原比例连接', '100个目标贡献与2.4原列/2.1端点一致')
    temporal = {}
    with open(ROOT / B21 / 'focal_temporal_asv_changes.tsv') as f:
        for x in csv.DictReader(f, delimiter='\t'):
            if x['feature_id'] in rev:
                k = x['comparison_id'], rev[x['feature_id']]
                if k in temporal:
                    raise ValueError('Duplicate temporal contribution')
                temporal[k] = x
    run.check(len(temporal) == 160, '既有时间贡献', '10目标×16段；只提取指定比较，不复制全表')

    rows = []
    def base(kind, unit, c):
        return dict(version='module2.6_2026-11-09_v2', record_type=kind, study_unit=unit,
                    candidate_id=c, feature_id=fid[c], original_SILVA_label=roles[c]['original_label'],
                    original_SILVA_Taxon=tax[c]['original_SILVA_Taxon'],
                    MiDAS_review=tax[c]['reliable_interpretation'], functional_status=roles[c]['functional_status'])

    # One observation per target/sample. Membership is explicit and may include A and C.
    for c in TARGETS:
        for s, m in meta.items():
            membership = [u for u in UNITS if m['group'] == 'G4' and c in UNITS[u] and reactor[s] in ACTORS[u]]
            x = base('observation', ';'.join(membership) or 'context_' + m['group'], c)
            x.update(sample_id=s, reactor=reactor[s], day=m['phase_days'], group=m['group'],
                     reactor_instance_id=m['reactor_instance_id'], reactor_round=m['reactor_round'],
                     stage_subphase=m['stage_subphase'], sampling_day_status=m['sampling_day_status'],
                     particle_size_fraction_um=m['particle_size_fraction_um'],
                     count=counts[c,s], sample_reads=depths[s], relative_abundance=p[c,s],
                     temperature_regime=m['temperature_regime'], DO_analysis_setpoint=m['DO_setpoint_mg_L'],
                     DO_design_setpoint=m['design_document_DO_setpoint_mg_L'],
                     DO_G4_baseline_recovery_setpoint=m['G4_baseline_recovery_DO_setpoint_mg_L'],
                     DO_measured_mg_L=m['DO_measured_mg_L'],
                     source=f'{B24}/all_asv_ecological_features.tsv' + (f';{B21}/focal_asv_abundance_trajectories.tsv' if s in g4 else ''))
            rows.append(x)
    for u, cs in UNITS.items():
        pairs = ([f'R1_R2_d{d}' for d in [1,76,145]] if u == 'A' else
                 ['R3_d30_d76', 'R3_d76_d145'] if u == 'B' else
                 [f'R2_R4_d{d}' for d in [1,30,76,145]])
        for pair in pairs:
            for c in cs:
                q = contrib[pair,c]
                x = base('pair_comparison', u, c)
                x.update(comparison_id=pair, sample_a=q['sample_a'], sample_b=q['sample_b'],
                         day_a=q['day_a'], day_b=q['day_b'],
                         relative_abundance_a=q['relative_abundance_a'], relative_abundance_b=q['relative_abundance_b'],
                         delta_abundance_b_minus_a=q['signed_difference_b_minus_a'],
                         bray_contribution=q['bray_contribution'], share_of_pair_Bray=q['share_of_pair_Bray'],
                         shared_ASV_overlap=q['shared_ASV_overlap'], pair_Bray=distances[pair]['Bray_Curtis'],
                         pair_Jaccard=distances[pair]['Jaccard_binary'], source=f'{B21}/focal_pairwise_asv_contributions.tsv')
                rows.append(x)
        if u != 'B':
            intervals = [(1,76), (76,145)] if u == 'A' else [(1,30),(30,76),(76,145)]
            stem = 'R1_R2' if u == 'A' else 'R2_R4'
            for a,b in intervals:
                for c in cs:
                    key = f'{stem}_{a}_to_{b}'
                    q = temporal[key,c]
                    delta = float(q['delta_bray_contribution'])
                    expected = float(contrib[f'{stem}_d{b}',c]['bray_contribution'])-float(contrib[f'{stem}_d{a}',c]['bray_contribution'])
                    if abs(delta-expected) > 1e-13:
                        raise ValueError('Existing temporal contribution mismatch')
                    x = base('gap_change', u, c)
                    x.update(comparison_id=key, day_from=a, day_to=b,
                             **{k:q[k] for k in ['sample_a_from','sample_b_from','sample_a_to','sample_b_to',
                               'abundance_a_from','abundance_b_from','abundance_a_to','abundance_b_to',
                               'delta_abundance_a','delta_abundance_b','absolute_gap_from','absolute_gap_to',
                               'delta_bray_contribution','gap_direction']},
                             source=f'{B21}/focal_temporal_asv_changes.tsv')
                    rows.append(x)
    ratio_summary = []
    for u,r,num,den,days in RATIOS:
        samples = [s for s in nodes[r] if int(meta[s]['phase_days']) in days]
        run.check(len(samples) == len(days), '预定比值节点/' + r + '/' + num, str(days))
        minimum = min(counts[c,s] for s in samples for c in [num,den])
        passed = minimum >= 5
        ratio_summary.append((u,r,num,den,samples,minimum,passed))
        for s in samples:
            x = base('log_ratio', u, num)
            x.update(sample_id=s, reactor=r, day=meta[s]['phase_days'], group='G4',
                     ratio_numerator=num, ratio_denominator=den, denominator_feature_id=fid[den],
                     numerator_count=counts[num,s], denominator_count=counts[den,s],
                     log_ratio=math.log(p[num,s]/p[den,s]) if passed else None,
                     log_ratio_gate='PASS_ALL_PRESET_NODES_GE5' if passed else 'NA_INSUFFICIENT_PRESET_SERIES',
                     zero_handling='no_pseudocount;any_preset_node_either_count_lt5_gates_entire_series',
                     source=f'{B24}/all_asv_ecological_features.tsv;data/asv_table.tsv')
            rows.append(x)
        if not passed:
            run.warn('log-ratio支持不足/' + r, f'{num}/{den}全序列NA；最小count={minimum}；不替换')
        elif minimum < 20:
            run.warn('log-ratio低计数敏感/' + r,
                     f'{num}/{den}虽满足预定≥5 reads，最小count={minimum}；只保留探索性数值，不称稳健比值或独立支持')
    run.check(len({(x['candidate_id'],x['sample_id']) for x in rows if x['record_type']=='observation'}) == 330,
              '观测完整性', '330行；全33上下文不参与独立重复或相关分析')
    run.check(sum(x['record_type']=='pair_comparison' for x in rows)==47 and
              sum(x['record_type']=='gap_change' for x in rows)==25,
              '固定单元比较覆盖', '47个ASV比较+25个已有差额；没有扩大研究单元')

    def trajectory_text(c,r):
        return ' → '.join(f"{s.removeprefix('Batch_01_')}@{meta[s]['phase_days']}d={p[c,s]*100:.4f}%" for s in nodes[r])

    evidence = []
    for u,cs in UNITS.items():
        for c in cs:
            references = [l for l in lit if l['candidate_id']==c and l['evidence_id'].startswith('L')]
            genome = [g for g in genomes if g['candidate_id']==c]
            observation = '；'.join(r+': '+trajectory_text(c,r) for r in ACTORS[u])
            comp = ([contrib[k,c] for k in ['R3_d30_d76','R3_d76_d145']] if u=='B' else
                    [temporal[('R1_R2' if u=='A' else 'R2_R4')+'_76_to_145',c]])
            keytext = ('；'.join(q['pair_id']+': c='+q['bray_contribution']+'; share='+q['share_of_pair_Bray'] for q in comp)
                       if u=='B' else '76→145d Δc='+comp[0]['delta_bray_contribution']+'; '+comp[0]['gap_direction'])
            if c == 'N072':
                hypothesis = '检验Vicinibacter关联ASV的组成轨迹是否跨Batch重现；参考异养/PHA及附着生态背景仅用于提出假设，本ASV具体功能未测。'
                forbidden = '不能认定本ASV的PHA、EPS、反硝化活性、底物交换、协作/竞争或功能互作；不能移用旧OLB8其他分支糖原结论。'
                tier = 'OBSERVED_16S + CONSERVATIVE_LINEAGE + NEAR_REFERENCE_POTENTIAL_ONLY'
            elif c in ['C01','C03']:
                hypothesis = 'GAO关联对照的ASV组成持续或重排可作跨Batch描述性参照。'
                forbidden = '不能确证本ASV糖原/PHA活性、碳竞争、反硝化、除磷损失或与其他ASV的功能互作。'
                tier = 'OBSERVED_16S + CONSERVATIVE_LINEAGE + GAO_REFERENCE_ASSOCIATION'
            else:
                hypothesis = '具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。'
                forbidden = '不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。'
                tier = 'OBSERVED_16S + CONSERVATIVE_TAXONOMY; FUNCTION_UNKNOWN'
            evidence.append(dict(version='module2.6_2026-11-09_v2',study_unit=u,question=NAMES[u],candidate_id=c,feature_id=fid[c],
                original_SILVA_label=roles[c]['original_label'],original_SILVA_Taxon=tax[c]['original_SILVA_Taxon'],
                original_SILVA_Confidence=tax[c]['original_SILVA_Confidence'],
                level1_direct_16S_observation=observation,level1_existing_contribution=keytext,
                level2_MiDAS_conservative=tax[c]['reliable_interpretation'],
                MiDAS_best_identity_pct=tax[c]['best_identity_pct'],MiDAS_query_coverage_pct=tax[c]['query_coverage_pct'],
                MiDAS_best_tie_n=tax[c]['best_identity_tie_n'],
                level3_verified_reference='；'.join(l['evidence_id']+': '+l['reference_organism']+'；'+l['supported_conclusion']+'；局限='+l['relevance_to_ASV'] for l in references) or 'NA_NO_RELIABLE_REFERENCE_FUNCTION',
                reference_verification_scope='；'.join(l['evidence_id']+': '+l['verification_status']+' / '+l['inspected_scope'] for l in references) or 'NA',
                reference_genome_gate='；'.join(g['reference_organism']+': '+g['reference_lineage_gate']+'; ASV_genome='+g['genome_identity_of_ASV'] for g in genome),
                level4_ecological_hypothesis=hypothesis,level5_prohibited_mechanisms=forbidden,
                evidence_tier=tier,functional_status=roles[c]['functional_status'],
                organic_substrate_use=roles[c]['organic_substrate_use'],storage_metabolism=roles[c]['storage_metabolism'],
                nitrogen_transformation=('UNKNOWN_FOR_ASV; module2.6不用于氮转化机制' if c=='N072' else roles[c]['nitrogen_transformation']),
                EPS_biofilm=roles[c]['EPS_biofilm'],
                project_function_validation=roles[c]['project_function_validation'],
                evidence_ids=roles[c]['evidence_ids'],reference_doi=';'.join(dict.fromkeys(l['doi'] for l in references)) or 'NA',
                reference_url=';'.join(dict.fromkeys(l['url'] for l in references)) or 'NA',
                inference_gate='CLOSED_NONINDEPENDENCE_CONFOUNDING_NO_PERFORMANCE_OR_FUNCTION',
                source=f'{B25}/candidate_taxonomy_validation.tsv;{B25}/candidate_ecological_roles.tsv;{B25}/candidate_literature_evidence.tsv;{B25}/candidate_reference_genomes.tsv'))
    run.check(len(evidence)==16 and all(e['project_function_validation']=='not_measured' for e in evidence),
              '五层证据覆盖', 'A/B/C=5/6/5行；逐对象原16S/保守分类/参考/假设/禁止机制分列')
    run.warn('分类证据差异', '100%短片段也不能唯一物种；代码/跨属并列/远缘背景按2.5原结论保留')
    run.warn('组成与零值', '比例不是绝对菌量；log-ratio无伪计数，仅预定≥5 reads序列，不消除16S拷贝或扩增偏倚')
    run.warn('设计与批次限制', '不同初始污泥、混合均分、保存恢复、纵向依赖、温度/DO/时间混杂及提取/PCR/测序子批次不可分离')
    run.warn('功能及性能推断关闭', '无同期实测出水/去除率；同配方不是实测；不支持温度/DO独立因果及功能互作')
    for filename, table in [('focal_asv_cosuccession.tsv',rows), ('ecological_evidence_synthesis.tsv',evidence)]:
        write_tsv(run.out/filename,table)
        run.check(True,'回读/'+filename,f'{len(table)}行；所有字段逐值回读一致')
    plot(run, roles)
    run.check(all(sha(ROOT/p)==h for p,h in fingerprints.items()), '运行输入保护', '所有输入SHA256不变')
    report(run, fingerprints, tax, roles, nodes, meta, p, contrib, temporal, distances,
           ratio_summary, trajectory_text, evidence)
    for f in sorted(run.out.iterdir()):
        if f.name!='run.log':
            run.log.write(f'OUTPUT_SHA256 {f.name} {sha(f)}\n')


def plot(run, roles):
    rscript = shutil.which('Rscript') or '/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript'
    with tempfile.TemporaryDirectory(prefix='batch01_module26_plot_') as tmp:
        code = Path(tmp)/'plot.R'
        code.write_text(R_PLOT)
        args = [rscript,'--vanilla',str(code),str(run.out)]
        run.log.write('PLOT_COMMAND '+json.dumps(args)+'\n')
        result = subprocess.run(args, capture_output=True, text=True)
        run.log.write(result.stdout+result.stderr)
        run.check(result.returncode==0,'绘图执行','R base graphics；原比例实际节点，图层数据断言')
    dims = validate_png(run.out/'focal_asv_trajectory_comparison.png')
    pdf = (run.out/'focal_asv_trajectory_comparison.pdf').read_bytes()
    run.check(pdf.startswith(b'%PDF') and b'%%EOF' in pdf[-1024:], 'PDF完整', '矢量PDF头尾完整')
    run.check(dims==(3600,2600),'PNG完整',f'{dims[0]}×{dims[1]}；逐块CRC及像素流解压通过')


R_PLOT = r'''
args <- commandArgs(TRUE)
out <- args[1]
d <- read.delim(file.path(out,'focal_asv_cosuccession.tsv'), check.names=FALSE, na.strings='NA')
o <- d[d$record_type=='observation',]
t <- d[d$record_type=='gap_change' & d$day_from==76 & d$day_to==145,]
units <- list(A=c('C01','C02','C10','C09','N072'), B=c('C03','C04','C05','N026','N045','N072'), C=c('C01','C03','N026','N045','N072'))
actors <- list(A=c('R1','R2'), B='R3', C=c('R2','R4'))
short <- c(C01='Ca_Competibacter lineage', C02='Sphingobacteriales; midas_g_9646 code', C03='Defluviicoccus lineage', C04='Cytophagales; midas_g_85782 code', C05='Blastocatellaceae; genus unresolved', C10='Cytophagales; Microscillaceae candidate', C09='Rhodobacterales; genus unresolved', N026='Anaerolineae; near midas_g_29983', N045='Ignavibacteria / SJA-28; midas_g_171 code', N072='Ca_Vicinibacter lineage; no species')
cols <- c(R1='#0072B2',R2='#D55E00',R3='#009E73',R4='#CC79A7')
titles <- c(A='A | R1/R2 divergence',B='B | R3 later period',C='C | R2/R4 convergence')
draw <- function() {
 par(mfrow=c(3,6), mar=c(4.2,4.0,7.0,0.8), oma=c(7.5,0.5,4.3,0.5), family='sans', xaxs='i', yaxs='i')
 for (u in names(units)) {
  for (c in units[[u]]) {
   q <- o[o$candidate_id==c & o$group=='G4' & o$reactor %in% actors[[u]],]
   stopifnot(nrow(q)==if(u=='A')7 else if(u=='B')4 else 8)
   yy <- q$relative_abundance*100
   top <- max(yy)*1.16; if(top==0)top <- 1
   plot(NA, xlim=c(-3,150), ylim=c(0,top), axes=FALSE, xlab='G4 recorded day (1B = baseline)', ylab='ASV / all reads (%)', cex.lab=.82)
   rect(1,0,24,top,col='#eeeeee',border=NA)
   abline(h=pretty(c(0,top)),col='#ececec',lwd=.8)
   axis(1,at=c(1,30,76,145),labels=c('1B','30','76','145'),cex.axis=.85)
   axis(2,las=1,cex.axis=.8); box(col='#999999')
   for(r in actors[[u]]) {
    v <- q[q$reactor==r,]; v <- v[order(v$day),]
    stopifnot(!anyDuplicated(v$day),all(is.finite(v$relative_abundance)),all(v$relative_abundance>=0))
    # R1 has no 30d observation: split the line across that absent scheduled node.
    if(r=='R1') {
     lines(v$day[v$day>=76],100*v$relative_abundance[v$day>=76],col=cols[r],lwd=2)
    } else lines(v$day,100*v$relative_abundance,col=cols[r],lwd=2)
    points(v$day,100*v$relative_abundance,col=cols[r],bg=cols[r],pch=21,cex=1.1)
   }
   label <- unique(q$original_SILVA_label); if(is.na(label))label <- 'unassigned (Paracoccaceae)'
   mtext(paste(u,c,if(c %in% c('C01','C03'))'[GAO-related]' else '[target]'),side=3,line=5.45,adj=0,font=2,cex=.93)
   mtext(paste('SILVA:',label),side=3,line=4.05,adj=0,cex=.75)
   st <- strwrap(paste('MiDAS review:',short[c]),width=35)
   for(i in seq_along(st))mtext(st[i],side=3,line=2.85-(i-1)*.88,adj=0,cex=.75)
   legend('topright',legend=actors[[u]],col=cols[actors[[u]]],pch=16,lty=1,bty='n',cex=.82)
  }
  if(u!='B') {
   q <- t[t$study_unit==u,]; q <- q[match(units[[u]],q$candidate_id),]
   val <- q$delta_bray_contribution
   par(mar=c(4.2,4.0,7.0,.8))
   lim <- range(c(0,val)) + c(-1,1)*max(abs(val))*.18
   bp <- barplot(val,names.arg=q$candidate_id,col=ifelse(val>=0,'#c5523c','#427d9d'),ylim=lim,cex.names=.8,ylab='Change in ASV Bray contribution',cex.lab=.8,border=NA)
   abline(h=0,col='#666666')
   text(bp,val,labels=sprintf('%+.4f',val),pos=ifelse(val>=0,3,1),cex=.7)
   mtext(paste(u,'| gap change, 76 -> 145d'),side=3,line=5.4,adj=0,font=2,cex=.9)
   mtext('Original module 2.1 contributions',side=3,line=3.9,adj=0,cex=.75)
   mtext('+ expands gap; - narrows gap',side=3,line=2.8,adj=0,cex=.75)
  }
 }
 mtext('Batch_01 | Module 2.6 | Fixed focal ASV trajectories and comparisons | V2',outer=TRUE,side=3,line=2,font=2,cex=1.3)
 mtext('A: R1/R2 divergence     B: R3 later period     C: R2/R4 convergence  |  Each ASV panel has its own y scale',outer=TRUE,side=3,line=.6,cex=.94)
 mtext('Dots are actual samples; lines are visual guides. R1 d30 is absent: no dot or line through that scheduled node. No interpolation.',outer=TRUE,side=1,line=5.5,cex=.85)
 mtext('1B = recovered baseline before low-DO switch; grey = days 1-24 adjustment interval. Later setpoint: 0.5 +/- 0.2 mg/L; instantaneous DO unknown.',outer=TRUE,side=1,line=4,cex=.85)
 mtext('G4 only: distinct starting sludges; R1/R3 at 30 C, R2/R4 room temperature unknown. G1/G2G3 rounds and G5 fractions remain separate in TSV/report.',outer=TRUE,side=1,line=2.5,cex=.85)
 mtext('Taxonomy review is inherited from module 2.5; reference physiology is not ASV activity. No significance, interaction, temperature or DO causal inference.',outer=TRUE,side=1,line=1,cex=.85)
}
pdf(file.path(out,'focal_asv_trajectory_comparison.pdf'),width=18,height=13,onefile=TRUE)
draw(); dev.off()
png(file.path(out,'focal_asv_trajectory_comparison.png'),width=3600,height=2600,res=200,type='cairo')
draw(); dev.off()
cat(R.version.string,'\n')
cat('Base graphics; 16 trajectory panels and 2 gap summaries; source observations checked; no fitted curves.\n')
'''


def report(run, hashes, tax, roles, nodes, meta, p, contrib, temporal, distances, ratios, trtext, evidence):
    text = ['# 模块2.6：重点候选ASV共同演替及生态证据综合分析（V2）\n',
            f'运行开始：{run.started}（Asia/Shanghai）；输出：`{run.out.relative_to(ROOT) if run.out.is_relative_to(ROOT) else run.out}`。\n',
            '**三个固定单元的描述性分析完成；功能、性能、互作及温度/DO因果推断门控保持关闭。** 本文共同演替指同一已记录运行实体中多个ASV的组成变化并列，不代表统计相关、共现网络或相互作用。\n',
            '## 检查报告、有效输入及方法\n',
            '先阅读AGENTS、背景/设计/计划/执行日志及模块1.1–2.5有效v2报告，核对真实文件、格式和ID后固定方案。33样本、G1–G5=8/2/4/15/4；10个对象及A/B/C=5/6/5不重筛。全部33样本相对丰度直接提取模块2.4已有列，G4的150个目标观测与模块2.1已有轨迹/count逐值核对；原整数计数只用于比例一致性、测序分母与预定log-ratio支持检查，沿用旧深度QC，不新增异常筛查。taxonomy/ASV/FASTA的5510个ID一致，既有指纹完整；不重新运行DADA2、SILVA、功能映射、Alpha/Beta、筛选或MiDAS比对。\n',
            '贡献及差额直接复用模块2.1：单ASV c=|pA−pB|/2，跨反应器Δc=c晚−c早；正为端点差扩大，负为缩小。单ASV份额=c/既有Bray。以下固定子集求和仅是数学份额，不能当机制解释率。净Δ份额可能因缩小/扩大相抵超过100%，不是概率或独立证据。R3两个相邻区间长度不同（46/69d），距离不除天数、不当累计周转或动力学速率。\n',
            '图为16个独立纵轴轨迹面板及2个末段Δc摘要；百分比以全部ASV reads为分母。实际节点有点；R1第30天无点，1→76d处断线，未插补；其余连线仅帮助阅读端点。SILVA旧属标签与MiDAS保守审核并列，代码定位不是新命名属；完整解释见下表与证据表。G1/G2G3、G4及G5不连成统一时间轴。\n',
            '## 分类与功能证据边界\n',
            mdtable(['对象','原SILVA标签','MiDAS保守解释（模块2.5原文）','最佳identity/coverage%；并列数','功能状态'],
                    [(c,roles[c]['original_label'],tax[c]['reliable_interpretation'],
                      f"{tax[c]['best_identity_pct']}/{tax[c]['query_coverage_pct']}; n={tax[c]['best_identity_tie_n']}",roles[c]['functional_status']) for c in TARGETS]),
            'C02/C04/C05/C10/C09/N026/N045七个目标的具体功能全部UNKNOWN；C01/C03是GAO关联对照，不能当本ASV已测活性。N072只能引用Vicinibacter近缘参考谱系的异养/PHA及附着生态背景，本ASV的PHA、EPS、反硝化均未测，不能认定这些活性。旧OLB8不与Vicinibacter不同分支生理混用。\n']
    for u,cs in UNITS.items():
        text.append(f'## {u}. {NAMES[u]}\n')
        text.append(mdtable(['对象']+[r+'实际节点轨迹（全部reads百分比）' for r in ACTORS[u]],
                            [(c,*[trtext(c,r) for r in ACTORS[u]]) for c in cs]))
        if u=='B':
            pairids=['R3_d30_d76','R3_d76_d145']
            text.append(mdtable(['既有比较','Bray','Jaccard','指定6ASV贡献和','占原Bray份额'],
                [(pair,distances[pair]['Bray_Curtis'],distances[pair]['Jaccard_binary'],
                  f"{sum(float(contrib[pair,c]['bray_contribution']) for c in cs):.6f}",
                  f"{sum(float(contrib[pair,c]['bray_contribution']) for c in cs)/float(distances[pair]['Bray_Curtis'])*100:.2f}%") for pair in pairids]))
            text.append(mdtable(['ASV','30→76d变化pp','76→145d变化pp','既有c(30,76)','既有c(76,145)','末段贡献份额'],
              [(c,f"{(p[c,nodes['R3'][2]]-p[c,nodes['R3'][1]])*100:+.4f}",f"{(p[c,nodes['R3'][3]]-p[c,nodes['R3'][2]])*100:+.4f}",
                f"{float(contrib[pairids[0],c]['bray_contribution']):.6f}",f"{float(contrib[pairids[1],c]['bray_contribution']):.6f}",
                f"{float(contrib[pairids[1],c]['share_of_pair_Bray'])*100:.2f}%") for c in cs]))
            text.append('**具体发现。** C03在30/76/145d保持约13–15%的ASV比例，但其末段下降；C04连续升高，N045也在后期两段升高；N026由基线至30d下降，但在30→76→145d两段均升高。C05在30→76d小幅升、末段明显降，N072在后期先升后降。C04与N045的同向变化不等于协作，C04与C05末段反向也不等于竞争。六对象并非同步稳定：较小整体Bray与内部替换共存，Jaccard仍较高。C03只是Defluviicoccus中的一个ASV，不能用该属总量24%左右替代本ASV比例。\n')
            text.append('**不能回答。** 不能判断群落成员、代谢或运行性能已稳态，不能由C04/C05原属标签推断水解或硝酸盐利用，不能据N026/N045认定光合、DNRA或氮循环互作。\n')
        else:
            stem='R1_R2' if u=='A' else 'R2_R4'
            days=[1,76,145] if u=='A' else [1,30,76,145]
            text.append(mdtable(['实际日','既有Bray','既有Jaccard','指定子集贡献和','子集占当日Bray'],
                [(d,distances[f'{stem}_d{d}']['Bray_Curtis'],distances[f'{stem}_d{d}']['Jaccard_binary'],
                  f"{sum(float(contrib[f'{stem}_d{d}',c]['bray_contribution']) for c in cs):.6f}",
                  f"{sum(float(contrib[f'{stem}_d{d}',c]['share_of_pair_Bray']) for c in cs)*100:.2f}%") for d in days]))
            key=stem+'_76_to_145'
            net=float(distances[stem+'_d145']['Bray_Curtis'])-float(distances[stem+'_d76']['Bray_Curtis'])
            subtotal=sum(float(temporal[key,c]['delta_bray_contribution']) for c in cs)
            text.append(mdtable(['ASV','76d差距pp','145d差距pp','已有Δc','方向'],
                [(c,f"{float(temporal[key,c]['absolute_gap_from'])*100:.4f}",f"{float(temporal[key,c]['absolute_gap_to'])*100:.4f}",
                  f"{float(temporal[key,c]['delta_bray_contribution']):+.6f}",temporal[key,c]['gap_direction']) for c in cs]))
            text.append(f'76→145d全群落既有Bray净变化={net:+.6f}；固定5对象Δc和={subtotal:+.6f}，其余ASV净和={net-subtotal:+.6f}。子集/整体净变化比={subtotal/net*100:.2f}%，仅为有符号分解；剩余成分未删除。\n')
            if u=='A':
                text.append('**具体发现。** R2的C01末段增加39.5599个百分点，R1的C02增加18.6671个百分点，均指读数比例，两者形成不同的末期组成。C10在R1 76d已较高、145d仍较高，R1/R2间该ASV差距末段略缩，不能把所有R1候选都称为末段扩大的来源。C09在R2由基线高比例持续下降；N072在R1/R2末段都下降，二者端点差缩小。固定目标中存在相反方向的贡献，分化不是所有目标同步分离。\n')
                text.append('**不能回答。** C02/C10能否利用某碳源、二者是否协作，C01是否因竞争而占优，温度或DO是否导致分化均不能回答；高比例/Δc不是活性或机制。\n')
            else:
                c01=float(temporal[key,'C01']['delta_bray_contribution'])
                text.append(f'**具体发现。** C01在R2上升、R4下降，同一ASV的端点差明显缩小，Δc={c01:+.6f}，占全群落Bray净下降幅度的{c01/net*100:.2f}%（数学比值）。N072在两者都下降且差缩小，比例变得更接近可以来自共同降低。C03、N026与N045的差距末段均扩大；总体趋近不代表全部重点类群趋同。C01是A/C共有信号，R2的同一次重排同时关联两项距离变化，不是两次独立复现。\n')
                text.append('**不能回答。** 同为室温运行标签且有共同名义进水，仍不能排除初始污泥/谱系/个体/时间混杂，也不能证明环境筛选、GAO与辅助类群互作或去除功能趋同。N026/N045仍具体功能未知。\n')
        text.append('### 本单元五层证据整合\n')
        text.append(mdtable(['对象','1 本研究16S','2 MiDAS','3 已核实参考层级','4 允许的生态假设','5 不允许机制'],
            [(e['candidate_id'],'上方实际比例/既有贡献',SHORT[e['candidate_id']],
              ('近缘Vicinibacter参考MAG/原位细胞异养、PHA、附着背景' if e['candidate_id']=='N072' else
               'GAO参考谱系关联' if e['candidate_id'] in ['C01','C03'] else
               '出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN'),
              e['level4_ecological_hypothesis'],e['level5_prohibited_mechanisms']) for e in evidence if e['study_unit']==u]))

    text.append('## 预定log-ratio：支持门控、零值及组成局限\n')
    text.append('仅预定三种ASV配对/四个实体序列，不扫描全群落配对、不做相关性、p值或网络。自然log(p分子/p分母)=同样本log(count分子/count分母)；样本总reads在该比值中消去。每个预定序列全部节点两ASV均≥5 reads才描述；任何节点0或1–4 reads则该序列全部NA，不用伪计数、不替换节点。阈值是描述支持约定，非统计检出限、可靠性概率或独立生物学重复。该比值减弱对其他成分闭合变化的依赖，但不能证明分子绝对增加/分母绝对减少，也不消除测序误差、16S拷贝/扩增偏倚或纵向混杂。\n')
    rrows=[]
    for u,r,num,den,samples,minimum,passed in ratios:
        vals=' → '.join(f"{s.removeprefix('Batch_01_')}={math.log(p[num,s]/p[den,s]):+.4f}" for s in samples) if passed else 'NA（整个预定序列支持不足）'
        rrows.append((u,r,num+'/'+den,minimum,vals))
    text.append(mdtable(['单元','实体','预定比值','两ASV跨节点最小reads','自然log比值（实际节点）'],rrows))
    text.append('WARNING：R4序列最小为8 reads（H2的N072），虽超过事先固定的5 reads门槛，仍对低计数/检出误差敏感，只保留探索性数值，不把它当稳健比值、趋势确证或额外独立证据；不因结果调整阈值或另换配对。\n')
    text.append('R1比值只比较76/145d的C02相对C10组成比；R3比值只描述C04相对C03的重排；R2/R4比值只描述N072相对C01的重排。相反方向或比值改变均不命名为协作、竞争、交叉营养或代谢替代。\n')
    text.append('## G1–G3轮次上下文与G5独立描述\n')
    text.append('330条观测包含全33样本、原轮次/实体/阶段和采样日依据。G1 day120为约数；G2/G3是混合均分后的同轮连续21→56d，不能补造R1/R3的21d或把G4跨4℃59d保存恢复接成连续运行。这里不把G1–G3数据并入G4轨迹/平均值/比值或估计独立重复。G4中未属于该对象固定研究单元的观测仅作上下文，不扩展单元。\n')
    # Show focal starting states across round boundaries without connecting them.
    mapping=[('R1','Batch_01_A2','Batch_01_E1'),('R2','Batch_01_B3','Batch_01_F1'),
             ('R3','Batch_01_C2','Batch_01_G1'),('R4','Batch_01_D3','Batch_01_H1')]
    text.append(mdtable(['G4实体','保存前来源','恢复后基线','本单元对象：来源% / 基线%（非连续运行差值）'],
        [(r,s.removeprefix('Batch_01_'),b.removeprefix('Batch_01_'),
          '；'.join(f'{c}: {p[c,s]*100:.3f} / {p[c,b]*100:.3f}' for c in TARGETS
                    if any(c in UNITS[u] and r in ACTORS[u] for u in UNITS))) for r,s,b in mapping]))
    g5=[s for s in meta if meta[s]['group']=='G5']
    text.append('G5只有G4-R1结束后延长18d的一次母样采样（163d来自原表推算），四个级分各一份。下表仅列固定10对象，不做级分均值、母样重建、显著性或跨反应器外推；G4温度标签不外推G5。\n')
    text.append(mdtable(['对象']+[s.removeprefix('Batch_01_')+' '+meta[s]['particle_size_fraction_um']+' μm %' for s in g5],
                        [(c,*[f'{p[c,s]*100:.4f}' for s in g5]) for c in TARGETS]))
    text.append('G5中C02在S1–S4均为7.38%–13.03%，C10为1.21%–4.97%；N072在S1–S3为0 reads，S4仅9 reads（0.0201%）。这是ASV层面结果，不能把模块1.1中旧OLB8属标签在较大级分中的较高总比例当作N072的粒径富集；属标签包含其他ASV/谱系。N072本次分级记录不能确认其附着、成粒、PHA或EPS活性，也不能把C02等未知对象的级分比例改称具体功能。\n')
    text.append('## 可用于跨Batch核查的固定假设与不能回答的问题\n')
    text.append('后续仅利用可获得的批次16S及可靠设计记录核查以下组成假设，不新增功能验证实验任务。需先核对相同片段/ASV可比性、分类版本、轮次/实体与采样阶段；若片段不同不宣称同一ASV。跨Batch尚未执行，本批筛选后形成的假设不能冒称外部验证。\n')
    text.append('1. A：能否重现R1中C02相对C10增大，以及R2中C01份额增加的不同组成方向；C09/N072的下降是否同样出现。\n'
                '2. B：能否重现C03保持较高比例、C04/N045上升与C05末段下降并存；N026/N072允许不同步。优先核查各对象实际方向，不要求“共同稳定”。\n'
                '3. C：同一C01的差距缩小是否再次构成丰度加权趋近的主要数学来源，同时C03/N045可保留或扩大差异；N072的共同下降型趋近是否重现。\n'
                '4. N072：在可比16S谱系与阶段中描述其与GAO关联对照的组成重排，参考异养/PHA及附着背景仅辅助生态假设，不将其升级为本ASV机制或新功能验证任务。\n')
    text.append('所有单元均不能识别温度或DO的独立因果效应、证明功能互作或代谢机制、评价COD/氮磷去除贡献或性能稳态。G4四份不同起始污泥、共享混合来源、保存恢复与不平衡纵向记录不构成独立重复；R1/R3=30℃、R2/R4室温实际未知，与个体/历史混杂。G1–G5统一名义配方不能充当同期进出水或去除率，也不能消除混杂。采样瞬时DO/温度全NA；恢复设置3与旧分析NA及design_document字段并列保留。提取/PCR/测序子批次效应、组成闭合、16S拷贝和检测偏倚尚不能分离；ASV比例不是绝对菌量，不乘VSS/MLVSS。\n')
    text.append('## PASS / WARNING / FAIL与实际产物\n')
    counts=collections.Counter(c[0] for c in run.checks)
    text.append(f"**本次必要交付检查：{counts['PASS']} PASS / {counts['WARNING']} WARNING / {counts['FAIL']} FAIL。** 0 FAIL只表示描述性交付必需条件通过，功能/性能/独立因果及互作前提未通过；这些未执行步骤明确关闭。必要格式、设计、连接或保护检查失败返回非零退出码，不保存成功报告。\n")
    text.append(mdtable(['状态','实际检查','依据'],run.checks))
    text.append('最小成果（全部位于新V2目录，不覆盖历史）：\n\n'
                '- [focal_asv_cosuccession.tsv](focal_asv_cosuccession.tsv)：330个原观测、47个原贡献比较、25个原Δc和13个预定比值位置，record_type区分；不适用字段NA。observation.study_unit可为A;C，其他为context_G*；不得把不同行型合并作独立样本。\n'
                '- [focal_asv_trajectory_comparison.pdf](focal_asv_trajectory_comparison.pdf) / [PNG](focal_asv_trajectory_comparison.png)：16个实际节点面板和2个已有Δc摘要，独立纵轴；G5不连入时间轴。\n'
                '- [ecological_evidence_synthesis.tsv](ecological_evidence_synthesis.tsv)：16个单元×ASV证据条目，五层证据、原分类/审核解释、参考核实范围/DOI、禁止外推及功能状态。\n'
                '- 本中文综合报告和[run.log](run.log)：命令、参数、工具版本、输入/输出SHA256与实际检查。\n')
    text.append('## 参考证据复用与复现\n')
    text.append(f'仅复用模块2.5冻结审核快照，没有重新联网检索、比对或扩大文献主张。逐条参考生理/基因组支持、实际摘要/全文/图表核实范围和禁止外推见[模块2.5文献表](../../candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv)、[基因组表](../../candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv)及本次证据表。缺失或NOT_VERIFIED项目不自动补全。参考强证据不等于本项目ASV功能实证。\n')
    text.append('复现入口：[focal_asv_cosuccession_v2.py](../../../scripts/focal_asv_cosuccession_v2.py)。\n\n'
                '```bash\npython3 scripts/focal_asv_cosuccession_v2.py --output-dir results/focal_asv_cosuccession/NEW_DATE_v2\n```\n\n'
                '目标必须不存在且以_v2结尾；默认正式路径已存在会非零拒绝，不能指定覆盖。Python标准库+现有R base graphics，无安装、无随机步骤；绘图临时脚本仅在本次TemporaryDirectory，成功后清理。三份总文档在实际交付后同步，不由脚本自动改写。\n')
    text.append(f'Python：{platform.python_version()}；平台：{platform.platform()}；R版本记录在run.log；脚本SHA256：`{sha(Path(__file__))}`。输入清单及每个SHA256同时记录如下与run.log；不复制大规模中间表。\n')
    text.append(mdtable(['输入路径','SHA256'],hashes.items()))
    text.append(f'描述分析结束：{now()}（Asia/Shanghai）。\n')
    with open(run.out/'analysis_report.md','x') as f:
        f.write('\n'.join(text))
    run.log.write('CHECK_COUNTS '+json.dumps(dict(counts))+'\n')


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output-dir',default='results/focal_asv_cosuccession/2026-11-09_v2')
    a=ap.parse_args()
    out=Path(a.output_dir)
    if not out.is_absolute():
        out=ROOT/out
    out=out.resolve()
    if not out.name.endswith('_v2') or out.exists():
        print('FAIL: 目标须为尚不存在的_v2目录，禁止覆盖已有结果',file=sys.stderr)
        return 1
    out.mkdir(parents=True)
    run=Run(out)
    run.started=now()
    start=time.monotonic()
    run.log.write('START '+run.started+'\nCOMMAND '+json.dumps(sys.argv,ensure_ascii=False)+'\n')
    run.log.write(f'PYTHON {platform.python_version()}\nPLATFORM {platform.platform()}\nSCRIPT_SHA256 {sha(Path(__file__))}\n')
    run.log.write('PARAMETERS fixed_units=A5_B6_C5; reuse_v2; ratio_min_each_count=5; natural_log; no_pseudocount; no_tests; no_interpolation; no_random_steps\n')
    try:
        analyse(run)
    except Exception as e:
        run.log.write(f'{now()} FAIL {type(e).__name__}: {e}\n')
        print(f'FAIL: {e}',file=sys.stderr)
        return 1
    finally:
        run.log.write(f'END {now()} elapsed_seconds={time.monotonic()-start:.3f}\n')
        run.log.close()
    print('PASS',out,dict(collections.Counter(c[0] for c in run.checks)))
    return 0


if __name__=='__main__':
    sys.exit(main())
