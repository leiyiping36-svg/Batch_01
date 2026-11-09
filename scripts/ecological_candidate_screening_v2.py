#!/usr/bin/env python3
"""Module 2.4 stage 1: reuse v2 ecological metrics; add explicit screening.

Offline, standard library only. Never replaces an existing output directory.
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
import sys
import time
from datetime import datetime
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
B22 = 'results/candidate_asvs/2026-11-05_v2'
B21 = 'results/asv_contributions/2026-11-05_v2'
B12 = 'results/functional_guilds/2026-11-03_v2'
B23 = 'results/operational_performance/2026-11-06_design_recipe_v2'
TRAD = '传统功能相关'
ECO = '非传统候选生态类群'
AMB = '功能歧义'
UNK = '分类受限或功能未知'
SCENARIOS = {
    'loose': dict(ab=.005, nodes=2, high_nodes=2, b_ab=.005, reactors=2, high_reactors=2, c_ab=.0025, bray=.0025),
    'primary': dict(ab=.01, nodes=3, high_nodes=2, b_ab=.01, reactors=3, high_reactors=2, c_ab=.005, bray=.005),
    'strict': dict(ab=.02, nodes=3, high_nodes=2, b_ab=.02, reactors=4, high_reactors=3, c_ab=.01, bray=.01),
}


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def read_tsv(p, skip=0):
    with p.open(encoding='utf-8', newline='') as h:
        for _ in range(skip):
            next(h)
        reader = csv.DictReader(h, delimiter='\t', quoting=csv.QUOTE_NONE)
        rows = list(reader)
        if len(set(reader.fieldnames)) != len(reader.fieldnames):
            raise ValueError(f'Duplicate columns: {p}')
    if any(None in r or None in r.values() for r in rows):
        raise ValueError(f'Malformed TSV: {p}')
    return rows


def keyed(rows, key):
    result = {r[key]: r for r in rows}
    if len(result) != len(rows):
        raise ValueError(f'Duplicate IDs: {key}')
    return result


def close(a, b):
    return math.isclose(float(a), float(b), abs_tol=1e-12, rel_tol=1e-12)


def md(headers, rows):
    def cell(x):
        return str(x).replace('|', '/').replace('\n', ' ')
    return '\n'.join(['| ' + ' | '.join(headers) + ' |', '|' + '|'.join(['---'] * len(headers)) + '|'] +
                     ['| ' + ' | '.join(map(cell, row)) + ' |' for row in rows])


def stamp():
    return datetime.now(ZoneInfo('Asia/Shanghai')).isoformat(timespec='seconds')


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output-dir', default='results/ecological_candidates/2026-11-07_v2')
    args = ap.parse_args()
    out = Path(args.output_dir)
    if not out.is_absolute():
        out = ROOT / out
    if not out.name.endswith('_v2'):
        raise ValueError('当前输出目录必须以_v2结尾；v1仅为历史。')
    if out.exists():
        raise FileExistsError(f'拒绝覆盖已有目录: {out}')
    paths = {
        'counts': 'data/asv_table.tsv', 'taxonomy': 'data/taxonomy.tsv',
        'sequences': 'data/exported_sequences/dna-sequences.fasta',
        'source_metadata': 'metadata/source_sample_metadata.tsv',
        'ranking22': B22 + '/candidate_asv_ranking.tsv',
        'evidence22': B22 + '/candidate_asv_evidence.tsv',
        'taxonomy22': B22 + '/candidate_asv_taxonomy_review.tsv',
        'annotation12': B12 + '/functional_asv_annotation.tsv',
        'evidence12': B12 + '/functional_mapping_evidence.tsv',
        'contribution21': B21 + '/focal_pairwise_asv_contributions.tsv',
        'distance21': B21 + '/focal_distance_summary.tsv',
        'metadata21': B21 + '/analysis_metadata_addendum.tsv',
        'metadata23': B23 + '/analysis_metadata.tsv',
        'report11': 'results/community_composition/2026-11-03_v2/analysis_report.md',
        'report12': B12 + '/analysis_report.md',
        'report13': 'results/diversity/2026-11-04_v2/analysis_report.md',
        'report21': B21 + '/analysis_report.md', 'report22': B22 + '/analysis_report.md',
        'report23': B23 + '/analysis_report.md',
        'log23': B23 + '/run.log',
        'rules': 'AGENTS.md', 'context': 'docs/research_context.md',
        'design': 'docs/batch_01/experiment_design.md', 'plan': 'docs/batch_01/analysis_plan.md',
        'log_at_start': 'docs/batch_01/analysis_log.md',
    }
    for p in paths.values():
        if not (ROOT / p).is_file():
            raise FileNotFoundError(p)
    protected = {p: sha(p) for base in ['data', 'input', 'metadata', 'results', 'scripts']
                 for p in (ROOT / base).rglob('*') if p.is_file()}
    fingerprints = {k: sha(ROOT / p) for k, p in paths.items()}
    started, start = stamp(), time.monotonic()
    out.mkdir(parents=True, exist_ok=False)
    log = (out / 'run.log').open('x', encoding='utf-8')
    checks = []

    def check(ok, item, detail):
        status = 'PASS' if ok else 'FAIL'
        checks.append((status, item, detail))
        log.write(f'{stamp()} {status} {item}: {detail}\n'); log.flush()
        if not ok:
            raise ValueError(f'{item}: {detail}')

    def warning(item, detail):
        checks.append(('WARNING', item, detail))
        log.write(f'{stamp()} WARNING {item}: {detail}\n'); log.flush()

    def write_tsv(name, rows):
        fields = list(rows[0])
        with (out / name).open('x', encoding='utf-8', newline='') as h:
            wr = csv.DictWriter(h, fieldnames=fields, delimiter='\t', lineterminator='\n')
            wr.writeheader(); wr.writerows(rows)
        reread = read_tsv(out / name)
        check(reread == [{k: str(v) for k, v in r.items()} for r in rows], name + '回读', f'{len(rows)}行×{len(fields)}列逐值一致')

    try:
        log.write(f'START {started}\nCOMMAND {sys.executable} {Path(__file__).relative_to(ROOT)} --output-dir {out}\n'
                  f'Python {platform.python_version()} / {platform.platform()}\nPARAMETERS {json.dumps(SCENARIOS)}\n')
        r22 = (ROOT / paths['report22']).read_text()
        r23 = (ROOT / paths['report23']).read_text()
        for k in ['counts', 'taxonomy', 'sequences', 'source_metadata', 'annotation12', 'evidence12',
                  'contribution21', 'distance21', 'report11', 'report12', 'report13', 'report21']:
            check(any(paths[k] in line and fingerprints[k] in line for line in r22.splitlines()),
                  '有效v2指纹/' + k, paths[k])
        for k in ['ranking22', 'evidence22', 'taxonomy22']:
            check(any(Path(paths[k]).name in line and fingerprints[k] in line for line in r22.splitlines()),
                  '模块2.2产物指纹/' + k, paths[k])
        check(any('analysis_metadata.tsv' in line and fingerprints['metadata23'] in line for line in r23.splitlines()) or
              f"OUTPUT_SHA256 {fingerprints['metadata23']}  analysis_metadata.tsv" in (ROOT / paths['log23']).read_text(),
              '模块2.3当前metadata来源', paths['metadata23'])
        ranks = read_tsv(ROOT / paths['ranking22']); rank = keyed(ranks, 'feature_id')
        ann = keyed(read_tsv(ROOT / paths['annotation12']), 'feature_id')
        tax = keyed(read_tsv(ROOT / paths['taxonomy']), 'Feature ID')
        evidence = keyed(read_tsv(ROOT / paths['evidence22']), 'feature_id')
        reviews = keyed(read_tsv(ROOT / paths['taxonomy22']), 'feature_id')
        meta_rows = read_tsv(ROOT / paths['metadata23']); meta = keyed(meta_rows, 'sample-id')
        meta21 = keyed(read_tsv(ROOT / paths['metadata21']), 'sample-id')
        source = keyed(read_tsv(ROOT / paths['source_metadata']), 'sample-id')
        raw = read_tsv(ROOT / paths['counts'], skip=1); counts = keyed(raw, '#OTU ID')
        samples = list(raw[0])[1:]; ids = list(rank)
        check(len(ids) == 5510 and set(ids) == set(counts) == set(ann) == set(tax),
              '全ASV身份', '5510唯一ID与原count、分类、模块1.2和2.2一致')
        with (ROOT / paths['sequences']).open() as h:
            seq_ids = [line[1:].strip() for line in h if line.startswith('>')]
        check(len(seq_ids) == 5510 and set(seq_ids) == set(ids), '代表序列身份复用', '仅核对ID与既有指纹，不重复序列质量检查')
        check(len(samples) == len(set(samples)) == 33 and set(samples) == set(meta) == set(source) == set(meta21),
              '样本身份', '33唯一样本ID；原metadata和有效v2一一对应')
        check(all(all(meta[s][k] == v for k, v in row.items()) for s, row in meta21.items()) and
              all(all(meta[s][k] == v for k, v in row.items()) for s, row in source.items()),
              '原metadata与2.1继承', '原14列、2.1全部63列逐字符保留')
        design = (ROOT / paths['design']).read_text()
        for g, n in zip(['G1', 'G2', 'G3', 'G4', 'G5'], [8, 2, 4, 15, 4]):
            line = [line for line in design.splitlines() if line.startswith('| ' + g + ' |') and 'Batch_01_' in line]
            check(len(line) == 1 and set(re.findall(r'Batch_01_[A-Z][0-9]', line[0])) ==
                  {s for s in samples if meta[s]['group'] == g} and sum(meta[s]['group'] == g for s in samples) == n,
                  '设计映射/' + g, f'{n}条记录，逐ID匹配正式设计')
        main_samples = [s for s in samples if meta[s]['group'] != 'G5']
        g4 = [s for s in samples if meta[s]['group'] == 'G4']
        g5 = [s for s in samples if meta[s]['group'] == 'G5']
        reactors = {r: sorted([s for s in g4 if meta[s]['reactor_id'] == f'Reactor_0{r[-1]}'],
                               key=lambda s: int(meta[s]['phase_days'])) for r in ['R1', 'R2', 'R3', 'R4']}
        check([[int(meta[s]['phase_days']) for s in ss] for ss in reactors.values()] ==
              [[1, 76, 145], [1, 30, 76, 145], [1, 30, 76, 145], [1, 30, 76, 145]],
              'G4实际节点', 'R1为3节点，其余4节点；基线4/后期11，不插补')
        check(all(meta[s]['temperature_regime'] == ('controlled_30C' if r in ['R1', 'R3'] else 'ambient_unmeasured')
                  and meta[s]['temperature_setpoint_C'] == ('30' if r in ['R1', 'R3'] else 'NA')
                  and meta[s]['G4_initial_sludge_distinctness'] == 'different_per_reactor_user_confirmed_characteristics_and_initial_community'
                  for r, ss in reactors.items() for s in ss) and
              all(meta[s]['DO_measured_mg_L'] == meta[s]['temperature_measured_C'] == 'NA' for s in samples),
              '温度/初始状态与实测边界', '四起始状态不同，30℃/室温未知分列，全部瞬时DO/温度NA')
        check(all(meta[s]['stage_subphase'] == ('recovered_baseline_before_low_DO_switch' if meta[s]['phase_days'] == '1' else 'design_stable_low_DO_period')
                  and meta[s]['G4_historical_storage_days'] == '59' and meta[s]['G4_historical_storage_temperature_C'] == '4'
                  for s in g4) and len({meta[s]['fractionation_event_id'] for s in g5}) == 1 and
              meta[g5[0]]['fractionation_event_id'] != 'NA', '阶段/保存/G5层级', '4切换前基线、11设计后期；4℃59d历史；G5单母样')
        check(all(meta[s]['influent_data_type'] == 'design_recipe' and meta[s]['influent_sample_measured'] == 'FALSE'
                  and meta[s]['performance_association_gate'] == 'closed_missing_measured_performance' for s in samples)
              and len({meta[s]['influent_recipe_id'] for s in samples}) == 1, '共同配方与性能门控', '仅共享名义配方，性能关联保持关闭')
        x = {i: {s: float(counts[i][s]) for s in samples} for i in ids}
        depths = {s: sum(x[i][s] for i in ids) for s in samples}
        check(all(math.isfinite(v) and v >= 0 and v.is_integer() for row in x.values() for v in row.values())
              and all(v > 0 for v in depths.values()), '计算必要计数条件', '非负整数/无NA/无空样本；沿用既有深度异常QC，不重跑')
        p = {i: {s: x[i][s] / depths[s] for s in samples} for i in ids}
        check(all(close(sum(p[i][s] for i in ids), 1) for s in samples), '33样本比例闭合', '分母始终每样本全部5510 ASV reads，无稀释/过滤')
        check(all(all(row[k] == rank[i][k] for k in row if k != 'feature_id') and
                      row['original_taxonomy'] == tax[i]['Taxon'] and close(row['taxonomy_classifier_confidence'], tax[i]['Confidence'])
                  for i, row in ann.items()), '功能/分类原值复用', '模块1.2全部16列与2.2逐字符一致；原Taxon/Confidence保留')
        check(all(close(rank[i]['main29_mean_relative_abundance'], sum(p[i][s] for s in main_samples) / 29) and
                      close(rank[i]['main29_max_relative_abundance'], max(p[i][s] for s in main_samples)) and
                      int(rank[i]['main29_detected_n_ge1']) == sum(x[i][s] >= 1 for s in main_samples)
                  for i in ids), '既有主29指标一致性', '原2.2均值/最大/检出直接复用，和本次比例核对')
        co = read_tsv(ROOT / paths['contribution21'])
        pairs = collections.defaultdict(dict)
        for row in co:
            q, i = row['pair_id'], row['feature_id']
            if i in pairs[q]:
                raise ValueError('Duplicate contribution row')
            pairs[q][i] = float(row['bray_contribution'])
        ds = keyed(read_tsv(ROOT / paths['distance21']), 'pair_id')
        check(len(co) == 55100 and len(pairs) == 10 and set(pairs) == set(ds) and
              all(set(v) == set(ids) and close(sum(v.values()), ds[q]['Bray_Curtis']) and
                  all(math.isfinite(c) and c >= 0 and close(c, rank[i]['bray_' + q]) for i, c in v.items()) for q, v in pairs.items()) and
              all(close(max(v[i] for v in pairs.values()), rank[i]['max_bray_contribution']) for i in ids),
              '既有Bray贡献复用', '55100行/10对与2.2逐ASV一致，贡献和等于既有Bray；未重算距离')
        original = {i: f'C{int(r["selected_order"]):02d}' for i, r in rank.items() if r['selected'] == 'TRUE'}
        check(set(original.values()) == {f'C{n:02d}' for n in range(1, 16)} and set(original) == set(evidence) == set(reviews),
              '原15候选/证据身份', 'C01–C15完整保留，旧清单/证据/分类审核不覆盖')
        focus_ids = [i for c in ['C02', 'C04', 'C05', 'C10'] for i, v in original.items() if v == c]
        categories = {'literature_supported_related_taxon': TRAD, 'functional_ambiguity': AMB,
                      'genus_level_candidate_only': AMB, 'taxonomic_information_insufficient': UNK,
                      'unverified_pending_research': UNK, 'named_taxon_function_not_assigned': ECO}

        def screening(i, cfg, reads=1):
            detected = {r: sum(x[i][s] >= reads for s in ss) for r, ss in reactors.items()}
            bn = {r: sum(p[i][s] >= cfg['b_ab'] for s in ss) for r, ss in reactors.items()}
            cr = [r for r, ss in reactors.items() if max(p[i][s] for s in ss) >= cfg['c_ab']]
            br = [r for r in reactors if detected[r] >= cfg['nodes'] and bn[r] >= cfg['high_nodes']]
            aa = [s for s in main_samples if p[i][s] >= cfg['ab']]
            dd = [q for q in sorted(pairs) if pairs[q][i] >= cfg['bray']]
            flags = [bool(aa), bool(br), sum(v > 0 for v in detected.values()) >= cfg['reactors'] and len(cr) >= cfg['high_reactors'], bool(dd)]
            return ''.join(k for k, yes in zip('ABCD', flags) if yes) or 'none', aa, br, cr, dd

        features = []
        for i in ids:
            f = dict(rank[i])  # Every existing metric retained verbatim.
            f['module24_version'] = '2026-11-07_v2'
            f['module22_candidate_id'] = original.get(i, 'NA')
            f['ecological_category'] = categories[f['evidence_category']]
            f['functional_evidence_tier'] = {'literature_supported_related_taxon': 'reference_taxon_association_only',
                'functional_ambiguity': 'ambiguous_reference_function', 'genus_level_candidate_only': 'strain_or_genus_candidate_only',
                'taxonomic_information_insufficient': 'taxonomy_limited', 'unverified_pending_research': 'unverified',
                'named_taxon_function_not_assigned': 'target_function_unknown'}[f['evidence_category']]
            lineage = {a.strip().split('__', 1)[0]: a.strip().split('__', 1)[1] for a in tax[i]['Taxon'].split(';') if '__' in a}
            for prefix, level in zip('dkpcofgs', ['domain', 'kingdom', 'phylum', 'class', 'order', 'family', 'genus', 'species']):
                f['lineage_' + level] = lineage.get(prefix) or 'NA'
            f['original_Confidence_text'] = tax[i]['Confidence']
            limitations = []
            if f['genus_resolution'] != 'genus_label_present': limitations.append(f['genus_resolution'])
            if '--other' in tax[i]['Taxon']: limitations.append('lineage_other_suffix_unverified')
            if 'Incertae_Sedis' in tax[i]['Taxon']: limitations.append('incertae_sedis_not_named_genus')
            genus = f['genus']
            if genus != 'NA' and (re.search(r'\d', genus) or genus.isupper()): limitations.append('database_code_or_numbered_label_requires_review')
            if float(f['taxonomy_classifier_confidence']) < .9: limitations.append('confidence_below_0.90_review_flag_only')
            f['taxonomy_limitations'] = ';'.join(limitations) or 'original_label_not_independently_aligned'
            f['MiDAS_review_status'] = 'not_performed_stage2_pending'
            f['project_function_evidence'] = '16S_only_functional_gene_and_activity_not_measured'
            for s in samples: f['relative_abundance__' + s] = p[i][s]
            f['G4_reactors_detected_ge1'] = sum(int(f[r + '_detected_n_ge1']) > 0 for r in reactors)
            f['G4_reactors_detected_ge5'] = sum(int(f[r + '_detected_n_ge5']) > 0 for r in reactors)
            for r, ss in reactors.items():
                for threshold, label in [(.0025, '0_25pct'), (.005, '0_5pct'), (.01, '1pct'), (.02, '2pct')]:
                    f[r + '_nodes_ge' + label] = sum(p[i][s] >= threshold for s in ss)
                f[r + '_max_relative_abundance'] = max(p[i][s] for s in ss)
                f[r + '_nodes_detected_days_ge1'] = ','.join(meta[s]['phase_days'] for s in ss if x[i][s] >= 1) or 'none'
                f[r + '_days_ge1pct'] = ','.join(meta[s]['phase_days'] for s in ss if p[i][s] >= .01) or 'none'
                if int(f[r + '_detected_n_ge1']) != sum(x[i][s] >= 1 for s in ss):
                    raise ValueError('Existing within-reactor detection mismatch')
            for scenario, cfg in SCENARIOS.items():
                rules, aa, br, cr, dd = screening(i, cfg)
                f[scenario + '_rules'] = rules
                f[scenario + '_candidate'] = 'TRUE' if rules != 'none' else 'FALSE'
                for rule in 'ABCD': f[scenario + '_rule_' + rule] = 'TRUE' if rule in rules and rules != 'none' else 'FALSE'
                f[scenario + '_A_samples'] = ';'.join(aa) or 'none'
                f[scenario + '_B_reactors'] = ';'.join(br) or 'none'
                f[scenario + '_C_reactors_ever_high'] = ';'.join(cr) or 'none'
                f[scenario + '_D_pairs'] = ';'.join(dd) or 'none'
            f['detection_ge5_primary_rules'] = screening(i, SCENARIOS['primary'], reads=5)[0]
            f['score_abundance'] = min(float(f['main29_max_relative_abundance']) / .1, 1)
            f['score_bray'] = min(float(f['max_bray_contribution']) / .05, 1)
            f['score_prevalence'] = float(f['main29_detection_frequency_ge1'])
            f['score_persistence'] = max(f[r + '_nodes_ge1pct'] / len(ss) for r, ss in reactors.items())
            f['score_cross_reactor'] = sum(f[r + '_max_relative_abundance'] >= .005 for r in reactors) / 4
            f['ecological_score_0_100'] = 20 * sum(f['score_' + k] for k in ['abundance', 'bray', 'prevalence', 'persistence', 'cross_reactor'])
            features.append(f)
        byid = keyed(features, 'feature_id')
        pools = {sc: {f['feature_id'] for f in features if f[sc + '_candidate'] == 'TRUE'} for sc in SCENARIOS}
        check(pools['strict'] <= pools['primary'] <= pools['loose'], '敏感性集合嵌套', '严格池⊆主池⊆宽松池；全5510原样保留')
        check(all(i in pools['primary'] for i in focus_ids), '四重点资格', 'C02/C04/C05/C10均实际满足主规则；不是无条件入池')
        eligible = [f for f in features if f['feature_id'] in pools['primary'] and f['ecological_category'] in [ECO, UNK]]
        ordered = sorted(eligible, key=lambda f: (-f['ecological_score_0_100'], f['feature_id']))
        # Design-directed four plus four highest scoring remaining eligible ASVs.
        recommended = focus_ids + [f['feature_id'] for f in ordered if f['feature_id'] not in focus_ids][:4]
        controls = [i for i, c in original.items() if c in ['C01', 'C03']]
        check(5 <= len(recommended) <= 10 and len(recommended) == len(set(recommended)) and
              set(recommended) <= pools['primary'] and not set(recommended) & set(controls),
              '下一阶段推荐资格', f'{len(recommended)}个生态审核目标；C01/C03另列对照')
        union = pools['primary'] | set(original)
        new_ids = {i: f'N{j:03d}' for j, i in enumerate(sorted(union - set(original)), 1)}
        union_order = sorted(union, key=lambda i: (-byid[i]['ecological_score_0_100'], i))
        eco_order = {f['feature_id']: j for j, f in enumerate(ordered, 1)}
        for f in features:
            i = f['feature_id']
            f['candidate_id'] = original.get(i, new_ids.get(i, 'NA'))
            f['ecological_target_rank'] = eco_order.get(i, 'NA')
            f['recommended_next_stage'] = 'TRUE' if i in recommended else 'FALSE'
            f['recommendation_order'] = recommended.index(i) + 1 if i in recommended else 'NA'
            f['review_role'] = ('focus_ecological_review' if i in focus_ids else 'additional_ecological_review' if i in recommended
                                else 'known_function_related_control' if i in controls else 'retained_previous_candidate' if i in original else 'candidate_pool' if i in union else 'outside_primary_pool')
            f['module22_evidence_path'] = paths['evidence22'] if i in original else 'NA'
            f['module22_taxonomy_path'] = paths['taxonomy22'] if i in original else 'NA'
        table = []
        core = ['candidate_id', 'feature_id', 'module22_candidate_id', 'ecological_category', 'review_role',
                'recommended_next_stage', 'recommendation_order', 'ecological_target_rank', 'ecological_score_0_100',
                'score_abundance', 'score_bray', 'score_prevalence', 'score_persistence', 'score_cross_reactor',
                'primary_candidate', 'primary_rules', 'primary_A_samples', 'primary_B_reactors', 'primary_C_reactors_ever_high', 'primary_D_pairs',
                'loose_rules', 'strict_rules', 'detection_ge5_primary_rules',
                'main29_detected_n_ge1', 'main29_detection_frequency_ge1', 'main29_mean_relative_abundance', 'main29_max_relative_abundance',
                'G4_detected_n_ge1', 'G4_reactors_detected_ge1', 'G4_reactors_detected_ge5', 'max_bray_contribution', 'max_bray_pair',
                'genus', 'original_taxonomy', 'original_Confidence_text', 'taxonomy_limitations',
                'functional_evidence_tier', 'MiDAS_review_status', 'module22_evidence_path', 'module22_taxonomy_path']
        core += [r + suffix for r in reactors for suffix in ['_detected_n_ge1', '_n_nodes', '_nodes_ge1pct', '_nodes_ge0_5pct',
                                                            '_max_relative_abundance', '_nodes_detected_days_ge1', '_days_ge1pct', '_post_detected_n_ge1', '_post_n_nodes', '_post_all_ge1pct']]
        core += [k for k in next(iter(ann.values())) if k not in core and k != 'feature_id']
        old_evidence_keys = [k for k in next(iter(evidence.values())) if k != 'feature_id']
        old_tax_keys = [k for k in next(iter(reviews.values())) if k != 'feature_id']
        for j, i in enumerate(union_order, 1):
            row = {'pool_score_rank': j, **{k: byid[i][k] for k in core}}
            row.update({'module22_evidence__' + k: evidence.get(i, {}).get(k, 'NA') for k in old_evidence_keys})
            row.update({'module22_taxonomy__' + k: reviews.get(i, {}).get(k, 'NA') for k in old_tax_keys})
            table.append(row)
        check(all(all(t['module22_evidence__' + k] == evidence[t['feature_id']][k] for k in old_evidence_keys) and
                      all(t['module22_taxonomy__' + k] == reviews[t['feature_id']][k] for k in old_tax_keys)
                  for t in table if t['feature_id'] in original), '原候选证据完整保留', '15条原证据与分类审核所有字段逐字符复制，含真实序列；不新增功能主张')
        warning('阈值与得分', '探索性筛选与确定性优先级，非显著性/置信区间；A与D部分重叠，不是独立生态证据。')
        warning('实验设计/批次', '重复节点、不同初始污泥、共享混合谱系/保存恢复、温度与反应器混杂；提取/PCR/测序子批次及16S拷贝偏倚未分离。跨反应器检出不等于独立复现。')
        warning('分类/功能证据', '沿用SILVA及模块1.2/2.2证据快照；MiDAS与新增文献审核未执行，功能未知不是无功能，所有5510 ASV功能基因/活性未测。')
        warning('性能/因果门控', '无可匹配的实测出水、去除率或功能基因数据；性能关联、DO/温度因果、功能确证、共现网络均关闭且未执行。')
        write_tsv('all_asv_ecological_features.tsv', features)
        write_tsv('candidate_priority_table.tsv', table)
        check(all(sha(p) == before for p, before in protected.items()), '原输入/既有结果保护', f'{len(protected)}个既有科研输入、结果、脚本SHA-256不变')
        counts_status = collections.Counter(s for s, _, _ in checks)
        summary = []
        for sc in SCENARIOS:
            ff = [f for f in features if f['feature_id'] in pools[sc]]
            summary.append([sc] + [sum(f[sc + '_rule_' + rule] == 'TRUE' for f in features) for rule in 'ABCD'] +
                           [len(ff), len(pools[sc] & set(original)), len(pools[sc] - set(original))])
        rec_rows = []
        for i in recommended + controls:
            f = byid[i]
            rec_rows.append([f['candidate_id'], i, f['genus'], f['ecological_category'], f['primary_rules'],
                            f"{100*float(f['main29_max_relative_abundance']):.3f}%", f['main29_detected_n_ge1'] + '/29',
                            f['G4_reactors_detected_ge1'], f['primary_B_reactors'],
                            f"{float(f['max_bray_contribution']):.6f}", f"{f['ecological_score_0_100']:.2f}", f['strict_rules'], f['review_role']])
        sensitivity = []
        for sc in ['loose', 'strict']:
            sensitivity.append([sc, len(pools[sc]), len(pools[sc] & pools['primary']) / len(pools[sc] | pools['primary']),
                                len(pools[sc] - pools['primary']), len(pools['primary'] - pools[sc]),
                                ';'.join(byid[i]['candidate_id'] for i in recommended if i not in pools[sc]) or 'none'])
        lines = [
            '# 模块2.4第一阶段：非传统候选生态ASV补充筛选与候选清单（v2）', '',
            f'实际执行：{started} 至 {stamp()}（Asia/Shanghai）；Python {platform.python_version()}，标准库，无随机步骤。', '',
            f"**描述性筛选交付PASS：{counts_status['PASS']} PASS / {counts_status['WARNING']} WARNING / {counts_status['FAIL']} FAIL。** 推断、性能关联及功能确证门控保持关闭；0 FAIL仅指本次交付必要条件。", '',
            '## 检查报告与复用范围', '',
            '已先阅读项目约定、背景/设计/计划/日志与模块1.1–2.3当前有效v2报告，核对输入文件、字段和样本ID后固定规则。本次不使用历史v1计算结果。模块2.2全5510行排名已包含主29/全33/G4/后期检出、平均/最大比例、实际节点持续性、10对Bray及模块1.2原16列，本次原列逐字符保留。只新算33样本逐ASV比例、跨反应器/丰度节点计数、规则与得分。原15候选及所有既有证据、序列审核字段保留在新候选表，原文件不改。', '',
            '5510 ASV、33样本；G1–G5=8/2/4/15/4，主分析29。G4四份初始污泥不同，R1/R3为30℃运行标签，R2/R4室温实际未知；15节点中4为恢复后切换前基线，11为设计后期，R1缺30d。G1结束后混合均分、4℃59d保存恢复及纵向结构不变。共同人工进水是design_recipe，所有采样瞬时DO/温度未知；同配方不消除混杂。G5单母样四粒径级分仅提供单列比例，不参与规则、主均值或推荐排名。', '',
            '本次未重跑Cutadapt/DADA2/SILVA、深度QC、功能映射或Alpha/Beta；Bray贡献直接复用2.1并逐ASV核对2.2，不重算距离。原对象不更新。', '',
            '## 四类探索性规则与候选数', '',
            '- A高丰度：任一主29样本比例≥1%。',
            '- B持续性：同一G4反应器≥3个实际节点检出，且≥2节点比例≥1%；以≥1 read为检出，包含基线。不要求连续，节点间未采样时段未知；原连续已观测节点/后期指标仍保留。',
            '- C跨反应器：≥3个G4反应器至少一次检出，且≥2反应器曾达到≥0.5%；不要求同日，不等同独立生物学复现。',
            '- D高贡献：模块2.1固定10对重点比较中任一单ASV Bray贡献≥0.005。c=|pA−pB|/2，无量纲，不是Bray距离份额或p值；比较名称逐项保留在D_pairs。', '',
            '任一命中即入池，无名额上限；A/B/C/D重叠，不可相加。每种规则的TRUE/FALSE、触发样本、反应器和比较均写入全表，未入池5510行也完整保留。', '',
            md(['场景', 'A', 'B', 'C', 'D', '并集', '重叠原15', '新增'], summary), '',
            f"主候选池{len(pools['primary'])}个，与原15重叠{len(pools['primary'] & set(original))}个，新增{len(pools['primary']-set(original))}个；候选优先表是主池∪原15，共{len(union)}行。旧selected/selected_order仍专指模块2.2，module22_candidate_id为原C01–C15；新增N编号按完整ASV ID升序分配，不是优先顺序。", '',
            '规则依赖需明确：B的高比例条件已经蕴含A；对这些主29内样本的Bray贡献，D≥0.005也必然蕴含任一端比例≥1%，因此D同样被A覆盖。四个规则并非四份独立支持，保留B/D是为解释持续性和变化来源。主池超出A的3个ASV仅由C补入：' + '; '.join(f"{f['candidate_id']} / {f['feature_id']} / {f['genus']}" for f in features if f['primary_candidate'] == 'TRUE' and f['primary_rule_A'] == 'FALSE') + '。', '',
            '## 四类组织与证据层级', '',
            '采用互斥组织：模块1.2 literature_supported_related_taxon→传统功能相关；functional_ambiguity与genus_level_candidate_only→功能歧义（后者为菌株/属候选，具体原级别另保留）；taxonomic_information_insufficient与unverified_pending_research→分类受限或功能未知；named_taxon_function_not_assigned→非传统候选生态类群。最后一类表示有原属标签但目标功能未分配；全表类别只是组织字段，是否入池以primary_candidate为准。非传统不等于新功能或从未研究。', '',
            md(['类别', '全部ASV', '主池', '原15'], [[c, sum(f['ecological_category'] == c for f in features),
                sum(byid[i]['ecological_category'] == c for i in pools['primary']), sum(byid[i]['ecological_category'] == c for i in original)] for c in [TRAD, ECO, AMB, UNK]]), '',
            '证据明确仅指参考类群关联：C01/C03等沿用GAO文献关联；Acinetobacter保留功能歧义，不能确证PAO。C02/C09分类受限；C04/C05/C10已有参考株分类/培养背景不赋予本ASV目标功能。原模块1.2 literature_strength/evidence_verified及原15逐条参考/禁止外推完整保留，未作新增文献核验。所有5510 ASV项目功能测定均not_measured。', '',
            '## 优先级与下一阶段定向审核', '',
            '生态得分=20×五个0–1分量之和：min(主29最大比例/0.1,1)、min(max Bray/0.05,1)、主29检出率、max反应器(≥1%节点数/实际节点数)、曾≥0.5%反应器数/4。等权、确定性、无训练；0.1/0.05为封顶尺度，不影响入池。节点数不平衡、max和高丰度偏好仍存在，A与D部分同源，分数不是独立证据数量或机制重要性。taxonomy不作功能概率加分，分类限制决定审核任务；不能让高分类置信度排除未定属ASV。', '',
            '推荐为研究问题指定的C02/C04/C05/C10（均须实际入主池）加其余非传统/分类未知主池按生态得分降序前4；同分按完整ASV ID升序。属于公开的定向优先方案，不冒称全盲全局Top8；全池得分与ecological_target_rank允许复查取舍。C01/C03另作已知功能关联对照，不占8个目标。其他原候选即便未推荐也不删除。', '',
            md(['编号', 'ASV', '原属', '类别', '规则', '主最大', '主检出', 'G4反应器数', 'B反应器', 'max Bray', '得分', '严格规则', '角色'], rec_rows), '',
        ]
        for i in recommended + controls:
            f = byid[i]
            nodes = '；'.join(f"{r}检出{f[r+'_detected_n_ge1']}/{len(ss)}、≥1%节点{f[r+'_nodes_ge1pct']}、最高{100*f[r+'_max_relative_abundance']:.3f}%" for r, ss in reactors.items())
            task = ('已知GAO参考类群对照，保留属内差异和未测功能边界' if i in controls else
                    '优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究')
            lines += [f"- **{f['candidate_id']} / {i}**：直接观察：主29平均{100*float(f['main29_mean_relative_abundance']):.3f}%，最大{100*float(f['main29_max_relative_abundance']):.3f}%，max贡献{float(f['max_bray_contribution']):.6f}（{f['max_bray_pair']}）；{nodes}。原分类限制：{f['taxonomy_limitations']}；证据层级{f['functional_evidence_tier']}。下一步：{task}。", '']
        lines += ['C02的Incertae_Sedis不是已鉴定属，应按Sphingobacteriaceae及完整谱系定位；C04 Chryseotalea与C05 Aridibacter原Confidence约0.852/0.824，优先审核分类匹配；C10 Chryseosolibacter原Confidence较高仍需定向审核，局部高比例不代表广泛持续。原参考株硝酸盐利用/好氧培养等不能转作本ASV反硝化、COD降解或氮磷去除事实。新增对象没有借用同属旧候选的菌株文献确证其功能。', '',
            '## 阈值敏感性', '',
            '宽松：A≥0.5%；B≥2检出节点且≥2节点≥0.5%；C≥2检出反应器且≥2曾≥0.25%；D≥0.0025。主规则如上。严格：A≥2%；B≥3检出节点且≥2节点≥2%；C四反应器检出且≥3曾≥1%；D≥0.01。检出主定义≥1 read，另比较≥5 reads（只改变检出部分）。主阈值和得分不随结果调整。', '',
            md(['场景', '并集', '与主池Jaccard', '相对主新增', '相对主丢失', '丢失推荐ID'], sensitivity), '',
            f"原15在宽松/主/严格池中分别为{'/'.join(str(len(pools[sc] & set(original))) for sc in SCENARIOS)}；推荐8个在严格池保留{sum(i in pools['strict'] for i in recommended)}个。检出≥5 reads时主池{sum(f['detection_ge5_primary_rules'] != 'none' for f in features)}个；相对≥1 read规则组合改变{sum(f['detection_ge5_primary_rules'] != f['primary_rules'] for f in features)}个ASV。逐ASV阈值成员和触发组合均保存在两表，可直接定位边界对象。", '',
            '## 直接观察、分类关联与潜在生态假设', '',
            '直接观察为reads相对比例、检出节点及已有Bray的数学贡献。传统功能相关只表示参考类群文献关联，分类受限/未映射不是无功能。持续较高比例或跨反应器检出可提出“在这些已观测运行背景中具有持续出现的生态信号”等待验证假设；不能认定低DO/温度选择、代谢通路、碳源竞争、功能冗余、性能稳态或氮磷去除。没有匹配出水/去除率/功能基因，不做性能相关性、因果分析、功能确证或共现网络。相对丰度不是绝对丰度，不乘VSS/MLVSS。', '',
            'G1–G4不同轮次/模块并非独立同质组；29行和G4多节点不是独立重复。共享谱系、四起始状态、反应器个体、温度/DO/时间与批次偏倚未分离。跨反应器规则包括不同日期，可能只反映历史检出。G5四级分逐列独立描述，不作粒径显著性或母样重建。本次未下载MiDAS、未运行参考比对或新增文献综述；后续须记录版本/来源/日期、真实query及区域、匹配歧义、原研究证据作用层级，短16S比对通过也不等于功能确证。', '',
            '## 文件与字段约定', '',
            '- [all_asv_ecological_features.tsv](all_asv_ecological_features.tsv)：5510行，原2.2全部列原样保留；relative_abundance__完整样本ID是0–1比例，四个S样本仅G5描述。lineage_*为原SILVA完整各阶元，缺失NA；taxonomy_limitations保留不足/代码/后缀/低置信标记，0.90仅审核提示。',
            '- [candidate_priority_table.tsv](candidate_priority_table.tsv)：主池∪原15；pool_score_rank为全池生态分排序，ecological_target_rank仅非传统/分类未知主池排序，recommendation_order为下一阶段审核顺序。module22_evidence__*及module22_taxonomy__*逐字符保留原15所有字段；新增ASV对应原15证据字段为NA，不冒称已审。',
            '- *_nodes_ge*、*_max_relative_abundance及*_days_ge1pct按各G4实体实际节点；原*_post_*只限后期。*_rules记录全部触发，none为无，*_candidate为成员标记；A_samples/B_reactors/C_reactors_ever_high/D_pairs给出触发位置，C另须满足检出反应器数。G4_reactors_detected_*范围0–4，G4_detected_n_*范围0–15，二者不同。',
            '- [run.log](run.log)：命令、版本、参数、输入/输出SHA-256、实际检查及时间；本报告为唯一综合报告，无另存中间文件或逐检查表。', '',
            '复现：`python3 scripts/ecological_candidate_screening_v2.py --output-dir results/ecological_candidates/NEW_DATE_v2`。目标目录必须不存在且以_v2结尾；默认当前路径已存在时非零拒绝覆盖。脚本不自动改三份总文档，交付时按实际结果同步。', '',
            f'脚本SHA-256：`{sha(Path(__file__))}`；耗时{time.monotonic()-start:.3f}秒。输入指纹为本次运行时快照，日志随后合法追加不改变历史指纹意义。', '',
            md(['输入', '路径', 'bytes', 'SHA-256'], [[k, pth, (ROOT / pth).stat().st_size, fingerprints[k]] for k, pth in paths.items()]), '',
            '## 程序实际门控', '', md(['状态', '检查', '依据'], checks), '',
            '必需断言失败返回非零退出码，并保留本次run.log的FAIL；只有全部必要条件通过才交付报告。本次描述性门控通过不表示独立性或后续统计前提通过。', '']
        (out / 'candidate_screening_report.md').write_text('\n'.join(lines), encoding='utf-8')
        for k, pth in paths.items(): log.write(f'INPUT {k} {pth} SHA256 {fingerprints[k]}\n')
        log.write(f'SCRIPT SHA256 {sha(Path(__file__))}\n')
        for name in ['all_asv_ecological_features.tsv', 'candidate_priority_table.tsv', 'candidate_screening_report.md']:
            log.write(f'OUTPUT {name} SHA256 {sha(out / name)}\n')
        log.write(f'END {stamp()} ELAPSED {time.monotonic()-start:.3f} STATUS {dict(counts_status)}\n')
        print(json.dumps({'status': dict(counts_status), 'output': str(out), 'candidate_pools': {k: len(v) for k, v in pools.items()},
                          'recommended': [byid[i]['candidate_id'] for i in recommended], 'controls': [original[i] for i in controls]}, ensure_ascii=False))
    except Exception as exc:
        log.write(f'{stamp()} FAIL {type(exc).__name__}: {exc}\n'); log.flush()
        raise
    finally:
        log.close()


if __name__ == '__main__':
    main()
