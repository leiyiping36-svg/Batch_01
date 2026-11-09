#!/usr/bin/env python3
"""模块2.3：人工进水设计配方确认、图片来源审核及性能匹配门控。

仅使用Python标准库。拒绝覆盖目录，拒绝把新候选原始文件静默忽略。
不执行任何上游16S分析、插补、相关检验或候选ASV重新筛选。
"""
import argparse
import csv
import hashlib
import io
import json
import os
import platform
import re
import shlex
import sys
from decimal import Decimal, localcontext, ROUND_HALF_UP
from collections import Counter
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

PARAMETERS = ['COD', 'NH4-N', 'NO2-N', 'NO3-N', 'TN', 'PO4-P', 'TP',
              'DO', 'temperature', 'pH', 'HRT', 'SRT', 'MLSS', 'MLVSS']
UNITS = {p: 'NA' for p in PARAMETERS}  # 无原始测量表；不替原文件指定单位。
ALIASES = {
    'COD': r'\bCOD\b|化学需氧量', 'NH4-N': r'NH[₄4][+＋]?[-_－–— ]?N|氨氮',
    'NO2-N': r'NO[₂2][-_－–— ]?N|亚硝酸', 'NO3-N': r'NO[₃3][-_－–— ]?N|硝酸',
    'TN': r'\bTN\b|总氮', 'PO4-P': r'PO[₄4][-_－–— ]?P|磷酸盐',
    'TP': r'\bTP\b|总磷', 'DO': r'(?<![A-Za-z])DO(?![A-Za-z])|溶解氧',
    'temperature': r'temperature|温度|室温|℃|°C', 'pH': r'(?<![A-Za-z])pH(?![A-Za-z])',
    'HRT': r'\bHRT\b|水力停留', 'SRT': r'\bSRT\b|污泥龄',
    'MLSS': r'\bMLSS\b', 'MLVSS': r'\bMLVSS\b',
}
MISSING = 'project_raw_measurement_record_not_found'
INFLUENT_SOURCE = 'data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv'
INFLUENT_KIND = 'document_reported_common_influent_condition'
DESIGN_RECIPE_SOURCE = 'data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv'
DESIGN_RECIPE_OUTPUT = 'results/operational_performance/2026-11-06_design_recipe_v2'
DESIGN = 'docs/batch_01/experiment_design.md'
BASE = 'metadata/source_sample_metadata.tsv'
ADDENDUM = 'results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv'
RANKING = 'results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv'
EVIDENCE = 'results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv'
REVIEW = 'results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv'
REPORTS = [
    'results/community_composition/2026-11-03_v2/analysis_report.md',
    'results/functional_guilds/2026-11-03_v2/analysis_report.md',
    'results/diversity/2026-11-04_v2/analysis_report.md',
    'results/asv_contributions/2026-11-05_v2/analysis_report.md',
    'results/candidate_asvs/2026-11-05_v2/analysis_report.md',
]
RAW_FIELDS = ['record_id', 'source_id', 'source_file', 'source_sha256', 'worksheet',
              'source_row', 'original_column', 'parameter', 'raw_value', 'value',
              'original_unit', 'unit', 'unit_conversion', 'sample_id', 'reactor_id',
              'reactor_instance_id', 'reactor_round', 'operation_phase', 'stage_subphase',
              'measurement_date', 'measurement_time', 'relative_day', 'day_basis',
              'cycle_id', 'stream_type', 'measurement_type', 'window_start_date',
              'window_end_date', 'window_start_day', 'window_end_day',
              'aggregation_method', 'n_underlying_observations', 'missing_reason',
              'audit_status', 'source_table', 'source_label', 'concentration_basis',
              'measurement_basis', 'applicable_groups', 'applicable_reactors',
              'scope_confirmation_source', 'image_archival_status']


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def table(path):
    with path.open(encoding='utf-8-sig', newline='') as f:
        reader = csv.DictReader(f, delimiter='\t')
        fields = reader.fieldnames
        require(fields and len(set(fields)) == len(fields), f'重复/缺失表头: {path}')
        rows = list(reader)
    require(all(None not in r and all(v is not None for v in r.values()) for r in rows),
            f'列数不一致: {path}')
    return fields, rows


def write_table(path, fields, rows):
    require(len(fields) == len(set(fields)), f'重复输出字段: {path}')
    with path.open('x', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fields, delimiter='\t', lineterminator='\n')
        writer.writeheader()
        for row in rows:
            writer.writerow({k: str(row.get(k, 'NA')) for k in fields})
    back_fields, back_rows = table(path)
    require(back_fields == fields and back_rows ==
            [{k: str(r.get(k, 'NA')) for k in fields} for r in rows], f'回读不一致: {path}')


def markdown_table(fields, rows):
    def clean(value):
        return str(value).replace('|', '\\|').replace('\n', ' ')
    return '\n'.join(['| ' + ' | '.join(fields) + ' |',
                      '| ' + ' | '.join(['---'] * len(fields)) + ' |'] +
                     ['| ' + ' | '.join(clean(r.get(k, 'NA')) for k in fields) + ' |'
                      for r in rows])


def project_files(root, output):
    files = []
    for base, dirs, names in os.walk(root, followlinks=False):
        dirs[:] = sorted(d for d in dirs if d != '.git' and Path(base, d) != output)
        require(not any(Path(base, d).is_symlink() for d in dirs), '发现目录软链接，需另审范围')
        for name in sorted(names):
            p = Path(base, name)
            require(not p.is_symlink(), f'发现软链接，需审核: {p}')
            if p != Path(__file__).resolve():
                files.append(p)
    return sorted(files)


def confirm_design_recipe(root, output_dir):
    """只读既有v2、写新正式配方派生metadata；不运行性能或16S计算。"""
    root = root.resolve()
    output = (root / output_dir).resolve()
    require(not output.exists(), f'FAIL: 输出目录已存在，拒绝覆盖: {output}')
    require(output.is_relative_to(root / 'results/operational_performance'), '输出须位于模块2.3目录')
    require(not re.search(r'(?:^|_)v1(?:$|_)', output.name), 'FAIL: 禁止向v1输出，当前使用新v2目录')
    start = datetime.now(ZoneInfo('Asia/Shanghai'))
    checks = []

    def check(status, name, evidence):
        checks.append(dict(status=status, check=name, evidence=evidence))

    prior = 'results/operational_performance/2026-11-06_influent_v2/'
    source_anchor = DESIGN + '#2026-11-06-uniform-influent-design-recipe'
    input_paths = list(dict.fromkeys(['AGENTS.md', 'docs/research_context.md', DESIGN,
        'docs/batch_01/analysis_plan.md', 'docs/batch_01/analysis_log.md', BASE, ADDENDUM,
        DESIGN_RECIPE_SOURCE, INFLUENT_SOURCE, RANKING, EVIDENCE, REVIEW] + REPORTS +
        [prior + 'sample_performance_match.tsv', prior + 'parameter_completeness.tsv',
         prior + 'source_inventory.tsv', prior + 'analysis_report.md']))
    require(all((root / f).is_file() for f in input_paths), '正式配方审核必需输入缺失')
    fingerprints = {f: sha(root / f) for f in input_paths}
    # 本次正式设计节是新增确认，不要求旧报告的设计文档指纹等于追加后版本。
    for f in ['AGENTS.md', 'docs/research_context.md', DESIGN, 'docs/batch_01/analysis_plan.md',
              'docs/batch_01/analysis_log.md'] + REPORTS:
        (root / f).read_text()
    _, old_inventory = table(root / (prior + 'source_inventory.tsv'))
    old_fingerprints = {r['source_file']: r['sha256'] for r in old_inventory if r['inventory_row_type'] == 'file'}
    require(all(old_fingerprints.get(f) == fingerprints[f] for f in REPORTS +
                [ADDENDUM, RANKING, EVIDENCE, REVIEW, BASE, INFLUENT_SOURCE]), 'v2输入或原源表指纹变化')
    check('PASS', '输入及v2链', '9项上游有效v2、原metadata及旧图片源表指纹与上次审计一致；设计新增节另记新指纹')

    base_fields, base = table(root / BASE)
    old_fields, old_meta = table(root / ADDENDUM)
    base_ids = [r['sample-id'] for r in base]
    old_map = {r['sample-id']: r for r in old_meta}
    require(len(base) == len(set(base_ids)) == 33 and len(base_fields) == 14 and
            len(old_meta) == len(old_map) == 33 and set(old_map) == set(base_ids), '样本基准或派生ID不一致')
    require(all(old_map[r['sample-id']][k] == r[k] for r in base for k in base_fields), '原14列发生变化')
    require(Counter(r['group'] for r in old_meta) == dict(zip(['G1','G2','G3','G4','G5'],[8,2,4,15,4])),
            '五组数量变化')
    design = (root / DESIGN).read_text()
    confirmed_groups = {}
    for line in design.splitlines():
        if line.startswith('| G') and 'Batch_01_' in line:
            cells = [x.strip() for x in line.strip('|').split('|')]
            for sid in cells[3].split(','):
                require(sid not in confirmed_groups, '设计样本ID重复')
                confirmed_groups[sid] = cells[0]
    require(set(confirmed_groups) == set(base_ids) and
            all(old_map[s]['group'] == confirmed_groups[s] for s in base_ids), '设计逐ID分组不一致')
    check('PASS', '33样本基准及分组', '原metadata33×14，逐ID确认8/2/4/15/4；保留全部2.1派生字段')

    _, recipe = table(root / DESIGN_RECIPE_SOURCE)
    _, image_rows = table(root / INFLUENT_SOURCE)
    image_map = {r['record_id']: r for r in image_rows}
    expected = {'COD':'230','NH4-N':'50','TP':'3.3','KHCO3':'250','EDTA':'5',
        'FeCl3·6H2O':'0.9','KI':'0.18','ZnSO4·7H2O':'0.12','CuSO4·5H2O':'0.03',
        'Na2MoO4·2H2O':'0.06','H3BO3':'0.15','CoCl2·6H2O':'0.15','MnCl2·4H2O':'0.06'}
    require(len(recipe) == len({r['record_id'] for r in recipe}) == 13 and
            {r['parameter']: r['value'] for r in recipe} == expected and
            len({r['recipe_id'] for r in recipe}) == 1, '配方13项浓度/ID/共用配方异常')
    quote = '表2.1和表2.2的人工进水配方适用于Batch_01全部G1–G5实验过程，33个样本均共享该名义进水设计条件。'
    require('id="2026-11-06-uniform-influent-design-recipe"' in design and quote in design,
            '实验设计未保存正式确认或锚点')
    for r in recipe:
        require(r['data_type'] == r['measurement_type'] == 'design_recipe' and
                r['sample_measured'] == 'FALSE' and r['measurement_basis'] == 'nominal_design_concentration',
                '设计配方不能标为sample_measured或未知类型')
        require(r['formal_confirmation_quote'] == quote and r['formal_confirmation_source'] == source_anchor and
                r['applicable_groups'] == 'G1;G2;G3;G4;G5' and
                r['applicable_reactors'] == 'Reactor_01;Reactor_02;Reactor_03;Reactor_04', '确认来源/适用范围不一致')
        require(r['unit'] == r['original_unit'] == 'mg/L' and r['unit_conversion'] == 'none' and
                Decimal(r['value']).is_finite() and Decimal(r['value']) > 0, '配方单位/有限性/值异常')
        source = image_map[r['image_transcription_record_id']]
        require(all(r[k] == source[k] for k in ['parameter','original_label','value','raw_value',
                    'original_unit','concentration_basis','image_table_number','image_data_row','image_side']) and
                r['image_transcription_sha256'] == fingerprints[INFLUENT_SOURCE], '旧图片原值/化学式或来源未保留')
        require(r['measurement_date'] == r['cycle_id'] == r['n_underlying_measurements'] == 'NA' and
                r['independent_water_quality_observations_added'] == '0', '设计配方伪造了测量日期或重复数')
    check('PASS', '正式配方性质及来源', '13项均design_recipe、sample_measured=FALSE；用户确认与设计锚点可回查')
    check('PASS', '图片原值保留', '全部原标签/化学式/值/单位/位置与旧图片转录一致；只有性质确认层发生变化')
    with localcontext() as context:
        context.prec = 28
        cn = Decimal(expected['COD']) / Decimal(expected['NH4-N'])
        cp = Decimal(expected['COD']) / Decimal(expected['TP'])
        cp_round = cp.quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
    require(cn == Decimal('4.6') and cp_round == Decimal('69.70'), '名义浓度比计算异常')
    check('PASS', '名义比值', f'COD/NH4-N={cn}；COD/TP={cp}，保留2位小数{cp_round}；非实测比或去除率')

    _, old_matches = table(root / (prior + 'sample_performance_match.tsv'))
    _, completeness = table(root / (prior + 'parameter_completeness.tsv'))
    match_map = {r['sample_id']: r for r in old_matches}
    require(len(old_matches) == len(match_map) == 33 and set(match_map) == set(base_ids) and
            len(completeness) == 14 and {r['parameter'] for r in completeness} == set(PARAMETERS), '旧性能门控来源不完整')
    require(all(match_map[s][p + '_value'] == 'NA' and match_map[s][p + '_match_class'] == 'D'
                for s in base_ids for p in PARAMETERS), '发现实测匹配变化，须先重新审核性能门控')
    require(all(float(r['measured_coverage_pct']) == 0 and int(r['n_D']) == 33 and
                all(int(r[k]) == 0 for k in ['n_A','n_B','n_C','n_verified_measurement_records'])
                for r in completeness), '实测缺失结论已变化，不得沿用关闭门控')
    check('PASS', '性能门控事实复核', '14参数覆盖仍0/33；462个NA/D，A/B/C各0，不把名义设计当水质观测')

    metadata = []
    for source in base:
        row = dict(old_map[source['sample-id']])
        row.update(uniform_influent_design='TRUE', influent_recipe_id=recipe[0]['recipe_id'],
            influent_data_type='design_recipe', influent_sample_measured='FALSE',
            influent_design_source=DESIGN_RECIPE_SOURCE, influent_design_confirmation_source=source_anchor,
            influent_design_scope='Batch_01_all_G1_G5_all_reactors_33_samples',
            influent_recipe_component_record_ids=';'.join(r['record_id'] for r in recipe),
            influent_design_concentration_unit='mg/L',
            influent_design_independent_water_quality_observations_added='0',
            influent_nominal_COD_NH4_N_ratio=str(cn), influent_nominal_COD_TP_ratio=str(cp),
            influent_nominal_COD_TP_ratio_rounded=str(cp_round),
            performance_measurement_match_class='D', performance_association_gate='closed_missing_measured_performance',
            influent_design_covariate_status='constant_design_condition_not_estimable_as_sample_covariate',
            influent_recipe_metadata_version='module2.3_design_recipe_2026-11-06_v2')
        for par, value in expected.items():
            row[f'influent_design_{par}_mg_L'] = value
        metadata.append(row)
    require([r['sample-id'] for r in metadata] == base_ids and
            all(r[k] == old_map[r['sample-id']][k] for r in metadata for k in old_fields),
            '派生metadata增删/重排样本或改变旧字段')
    require(all(len({r[f'influent_design_{p}_mg_L'] for r in metadata}) == 1 for p in expected) and
            len({r['influent_recipe_id'] for r in metadata}) == 1, '共同配方不应构造样本间设计变异')
    check('PASS', '派生metadata', f'33行保留原{len(old_fields)}列，新增设计字段/13名义浓度/2名义比；同一recipe_id共享')
    check('WARNING', '独立性与常数条件', '33份设计属性链接不是33条独立水质观测；13项设计浓度均为单一水平')
    check('WARNING', '实测与科研限制', '实际进出水、运行测量/时间窗仍缺；同配方不解除起始污泥/谱系/反应器/温度混杂')
    check('FAIL', '后续性能关联门控', '按原模块2.3结论继续关闭；没有新增sample_measured或独立配对性能观测')

    output.parent.mkdir(parents=True, exist_ok=True)
    output.mkdir(exist_ok=False)
    with (output / 'run.log').open('x') as log:
        log.write(f'START {start.isoformat()}\ncommand: {shlex.join([sys.executable] + sys.argv)}\n')
        log.write(f'Python: {platform.python_version()}\nscript_sha256: {sha(Path(__file__).resolve())}\n')
        try:
            write_table(output / 'analysis_metadata.tsv', list(metadata[0]), metadata)
            check('PASS', '输出序列化回读', f'analysis_metadata.tsv为33×{len(metadata[0])}；全部字段/值回读一致')
            require(all(sha(root / f) == h for f,h in fingerprints.items()), '运行中输入指纹变化')
            check('PASS', '输入保护', f'{len(input_paths)}项实际读取输入运行前后SHA-256一致；原metadata/旧结果不写入')
            end = datetime.now(ZoneInfo('Asia/Shanghai'))
            totals = Counter(r['status'] for r in checks)
            recipe_rows = [dict(parameter=r['parameter'], nominal_mg_L=r['value'],
                data_type=r['data_type'], source_record_id=r['record_id']) for r in recipe]
            report = f'''# Batch_01 人工进水设计配方正式确认与派生metadata审核

实际执行：{start.isoformat()} 至 {end.isoformat()}（Asia/Shanghai）。当前版本：`{output.relative_to(root)}`。

**设计配方及metadata交付PASS；实测缺口WARNING；后续性能关联门控FAIL（关闭）。** 程序实际{totals['PASS']} PASS / {totals['WARNING']} WARNING / {totals['FAIL']} FAIL，退出0表示本次设计确认交付成功；必要条件断言失败非零退出。FAIL只针对未执行的后续性能关联。

## 当前确认与历史替代

用户正式确认：{quote} 所有13项为`design_recipe`，均非`sample_measured`。本报告取代[前轮图片性质未说明的当前状态](../2026-11-06_influent_v2/analysis_report.md)；原源表、旧报告和历史有效v2全部保留，不回写既往记录。测量性质已解决，不再要求重复确认配方性质或范围；缺少的仍为实际测量数据。

## 正式配方与名义比值

源表：[{Path(DESIGN_RECIPE_SOURCE).name}](../../../{DESIGN_RECIPE_SOURCE})，13行且仅1个recipe_id：`{recipe[0]['recipe_id']}`。来源包括旧图片转录指纹与[实验设计正式确认节](../../../{source_anchor})；原图本地二进制缺失的历史边界保留，不虚构原图路径/指纹。

{markdown_table(['parameter','nominal_mg_L','data_type','source_record_id'], recipe_rows)}

适用全部Batch_01 G1–G5、R1–R4已区分的轮次及33样本的名义进水设计；不赋值为保存液组成或样本瞬时浓度。微量配方原值/水合化学式/单位与表2.2完全一致，浓度单位均mg/L；不换算盐类为元素/碱度，EDTA形式不补，NH4-N不替TN，TP不替PO4-P。

- 名义COD/NH4-N=230/50=**{cn}**。
- 名义COD/TP=230/3.3=**{cp}**，保留两位小数为**{cp_round}**（约69.70）。Decimal精度28位，显示舍入ROUND_HALF_UP。

两者都是设计配方比，非样本实测比、COD/TN、去除率、实际负荷或碳限制证据，不计算处理性能或推断ASV功能。

## 新派生metadata与原始数据保护

[analysis_metadata.tsv](analysis_metadata.tsv)为33行、{len(metadata[0])}列，使用原`sample-id`列名并保留原metadata顺序；原始14列及2.1派生表全部{len(old_fields)}列逐值保留。新增`uniform_influent_design=TRUE`、`influent_data_type=design_recipe`、`influent_sample_measured=FALSE`、共享recipe_id/源表/正式确认出处、13项`influent_design_*_mg_L`及两个名义比字段（COD/TP另有两位小数展示）。原33×14 metadata、旧派生表、RDS、ASV、taxonomy及功能注释不修改。

所有33样本关联同一份设计配方，13种组分不是13次采样，33份属性链接不是33条独立水质观测；独立水质观测新增数明确为0。共同配方各参数在样本间仅1个水平，不能作为可估计的连续样本协变量。单独保存派生metadata，不把设计值写入sample_measured字段，不生成虚假的33份原始性能记录。

## 模块2.3性能门控与科研边界

程序实际读取前轮33行匹配与14行完整性，复核全部462个实测位置仍NA/D、A/B/C均0、各参数实测覆盖仍0/33（0%）。本次正式配方确认不增加同日/周期实测、采样前窗口或阶段实测平均。派生metadata明确`performance_association_gate=closed_missing_measured_performance`，后续性能关联继续关闭，不执行相关检验、机器学习、网络或因果推断。

五组8/2/4/15/4不变；原63列保留意味着G4四份起始来源/不同初始状态、混合谱系/4℃59d保存恢复、G2/G3同轮连续、G4另起时间轴、R1缺30d、G5同一母样四级分等事实不改。R1/R3=30℃、R2/R4室温未知和原DO设定/实测边界保留；同一人工进水设计不消除反应器、初始污泥、历史、温度或纵向混杂，也不证明性能稳态或温度效应。16S相对丰度不是绝对丰度，分类关联不是功能基因/活性。

本轮只做设计确认、来源审核、字段派生及两个名义比值计算；不运行DADA2、taxonomy、功能映射、群落多样性或距离计算，不重筛候选，不更新现有对象。

## 实际检查

{markdown_table(['status','check','evidence'], checks)}

## 文件、复现与输入指纹

必要产物仅正式源配方表、新派生metadata、本综合报告及[run.log](run.log)。输出目录仅3文件；不重出完整模块2.3六表，不创建功能重复总结或逐项检查文件。实验设计/README/累计解释/分析日志按本次确认追加或更新当前状态，旧证据保留。

命令：`{shlex.join([sys.executable] + sys.argv)}`。复现：`python3 scripts/operational_performance_audit.py --mode design-recipe`，为默认模式；默认输出本新v2目录，已有目录在任何写入前拒绝覆盖，需重现时指定尚不存在的新v2目录。历史图片性质未说明模式保留为`--mode image-audit`，其旧源表/旧结果不更新。

Python {platform.python_version()}；仅标准库；脚本SHA-256：`{sha(Path(__file__).resolve())}`。下表为本次运行实际输入指纹，实验设计含本次新增确认，旧报告的旧设计指纹保持历史属性。运行后按规则同步三文档不改写运行时指纹。

{markdown_table(['path','sha256'], [dict(path=f,sha256=fingerprints[f]) for f in input_paths])}

后续不再询问已确认配方性质/适用范围；实际进出水和运行测量、采样日期/周期/窗口、相应方法和底层重复数仍需原记录，当前缺失保持NA。设计确认不能替代独立性能观测或统计前提审阅。
'''
            with (output / 'analysis_report.md').open('x') as h:
                h.write(report)
            for c in checks:
                log.write(f"{c['status']} {c['check']}: {c['evidence']}\n")
            for f,h in fingerprints.items():
                log.write(f'INPUT_SHA256 {h}  {f}\n')
            for f in ['analysis_metadata.tsv','analysis_report.md']:
                log.write(f'OUTPUT_SHA256 {sha(output/f)}  {f}\n')
            log.write(f'END {end.isoformat()}\nexit_code: 0; performance_association_gate: CLOSED\n')
        except Exception as exc:
            log.write(f'FAIL {type(exc).__name__}: {exc}\n')
            raise
    require(len(list(output.iterdir())) == 3, '正式配方目录应仅3文件')
    print(f'正式配方确认完成: {output}; {dict(totals)}; metadata=33x{len(metadata[0])}; COD/NH4-N={cn}; COD/TP≈{cp_round}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project-root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--mode', choices=['design-recipe','image-audit'], default='design-recipe')
    parser.add_argument('--output-dir')
    parser.add_argument('--influent-source', default=INFLUENT_SOURCE)
    parser.add_argument('--supersedes', help='本次经用户授权替代的已归档历史目录；仅引用，不修改')
    args = parser.parse_args()
    root = args.project_root.resolve()
    if args.mode == 'design-recipe':
        return confirm_design_recipe(root, args.output_dir or DESIGN_RECIPE_OUTPUT)
    args.output_dir = args.output_dir or 'results/operational_performance/2026-11-06_influent_v2'
    output = (root / args.output_dir).resolve()
    # 任何读取/创建运行日志之前检查；拒绝原地重跑与写到项目外。
    require(not output.exists(), f'FAIL: 输出目录已存在，拒绝覆盖: {output}')
    require(output.is_relative_to(root / 'results/operational_performance'), '输出须位于指定模块目录')
    require(not re.search(r'(?:^|_)v1(?:$|_)', output.name),
            'FAIL: v1仅作历史记录，当前模块2.3禁止向v1输出；请使用v2或后续新版本')
    supersession = ''
    if args.supersedes:
        previous = (root / args.supersedes).resolve()
        require(previous != output and previous.is_relative_to(root / 'results/operational_performance') and
                (previous / 'analysis_report.md').is_file(), '被替代历史目录缺失或越界')
        previous_link = os.path.relpath(previous / 'analysis_report.md', output)
        supersession = (f'本次依据用户2026-11-06“重新进行本条指令，替换昨天生成的内容”重新执行模块2.3。'
                        f'当前报告取代[2026-11-05草稿]({previous_link})；草稿六文件完整归档，'
                        f'原报告SHA-256为`{sha(previous / "analysis_report.md")}`，未把草稿数据当新测量。')
    start = datetime.now(ZoneInfo('Asia/Shanghai'))
    checks = []

    def check(status, name, detail):
        checks.append({'status': status, 'check': name, 'evidence': detail})

    require(args.influent_source == INFLUENT_SOURCE, '新进水来源须先显式审核，不能自动替换已核查来源')
    files = project_files(root, output)
    fingerprints = {str(p.relative_to(root)): sha(p) for p in files}
    required = ['AGENTS.md', 'docs/research_context.md', DESIGN, 'docs/batch_01/analysis_plan.md',
                'docs/batch_01/analysis_log.md', 'README.md', 'docs/batch_01/results_interpretation.md',
                BASE, ADDENDUM, RANKING, EVIDENCE, REVIEW, INFLUENT_SOURCE,
                'results/qc/stage1_report.md'] + REPORTS
    require(all(f in fingerprints for f in required), '必需来源缺失')
    texts = {f: (root / f).read_text() for f in required if f.endswith('.md')}
    require(all('v2' in texts[f] for f in REPORTS), '有效报告版本标记缺失')
    check('PASS', '必需文档与有效v2来源', f'{len(required)}项存在；5份有效报告完整读取并记录指纹')
    prior_inventory_path = root / 'results/operational_performance/2026-11-06_v2/source_inventory.tsv'
    _, prior_inventory = table(prior_inventory_path)
    prior_fingerprints = {r['source_file']: r['sha256'] for r in prior_inventory if r['inventory_row_type'] == 'file'}
    v2_inputs = REPORTS + [ADDENDUM, RANKING, EVIDENCE, REVIEW]
    require(all(prior_fingerprints.get(f) == fingerprints[f] for f in v2_inputs + [BASE]),
            '上游v2或原33样本metadata指纹与已审核基线不一致')
    check('PASS', 'v2输入指纹锁定', '9项上游v2输入及唯一原metadata与上一有效模块2.3来源清单一致')

    fields, base_rows = table(root / BASE)
    add_fields, add_rows = table(root / ADDENDUM)
    ids = [r['sample-id'] for r in base_rows]
    require(len(ids) == len(set(ids)) == 33 and len(fields) == 14, '原metadata不为33唯一样本×14列')
    amap = {r['sample-id']: r for r in add_rows}
    require(len(add_rows) == len(amap) == 33 and set(amap) == set(ids), '2.1 metadata样本不一致')
    require(all(amap[r['sample-id']][k] == r[k] for r in base_rows for k in fields), '原14列不一致')
    groups = Counter(r['group'] for r in add_rows)
    require(groups == dict(zip(['G1', 'G2', 'G3', 'G4', 'G5'], [8, 2, 4, 15, 4])), '五组数量变化')
    # 从已确认设计表读取逐样本分组，而非通过阶段/样本名猜测。
    design_groups = {}
    for line in texts[DESIGN].splitlines():
        if line.startswith('| G') and 'Batch_01_' in line:
            cells = [c.strip() for c in line.strip('|').split('|')]
            for sid in cells[3].split(','):
                require(sid not in design_groups, f'设计中样本重复: {sid}')
                design_groups[sid] = cells[0]
    require(set(design_groups) == set(ids) and all(amap[s]['group'] == design_groups[s] for s in ids),
            '设计逐ID分组不一致')
    check('PASS', '33样本唯一基准及五组映射', '原metadata行序/14列逐值保留；设计逐ID核对8/2/4/15/4')
    g4 = [r for r in add_rows if r['group'] == 'G4']
    baseline = [r for r in g4 if r['phase_days'] == '1']
    post = [r for r in g4 if r['phase_days'] != '1']
    expected_nodes = {'Reactor_01': [1, 76, 145], 'Reactor_02': [1, 30, 76, 145],
                      'Reactor_03': [1, 30, 76, 145], 'Reactor_04': [1, 30, 76, 145]}
    for rid, nodes in expected_nodes.items():
        require(sorted(int(r['phase_days']) for r in g4 if r['reactor_id'] == rid) == nodes,
                f'G4节点变化: {rid}')
    require(len(baseline) == 4 and len(post) == 11, 'G4分层不一致')
    check('PASS', 'G4不平衡取样', '4个基线+11个后期；R1=1/76/145d；R2–R4=1/30/76/145d，不补30d')
    source_pairs = {'Batch_01_E1': 'Batch_01_A2', 'Batch_01_F1': 'Batch_01_B3',
                    'Batch_01_G1': 'Batch_01_C2', 'Batch_01_H1': 'Batch_01_D3'}
    require(all(amap[b]['G4_pre_storage_source_sample_id'] == s for b, s in source_pairs.items()),
            'G4起始来源不一致')
    require(all(r['G4_initial_sludge_id'] == r['G4_initial_sludge_characteristics'] == 'NA' and
                r['G4_initial_sludge_distinctness'] ==
                'different_per_reactor_user_confirmed_characteristics_and_initial_community' for r in g4),
            'G4起始污泥边界不一致')
    require(all(r['G4_historical_storage_temperature_C'] == '4' and
                r['G4_historical_storage_days'] == '59' for r in g4), '保存历史不一致')
    require(all(r['temperature_setpoint_C'] == ('30' if r['reactor_id'] in
                ['Reactor_01', 'Reactor_03'] else 'NA') for r in g4), '温度设置不一致')
    require(all(r['temperature_measured_C'] == r['DO_measured_mg_L'] == 'NA' for r in add_rows),
            '发现实测环境字段，必须新增来源审核，不能继续空数据分支')
    require(all(r['temperature_regime'] == 'NA' for r in add_rows if r['group'] != 'G4'),
            '非G4温度范围发生变化')
    require(all(r['G4_baseline_recovery_DO_setpoint_mg_L'] == '3' and
                r['DO_setpoint_mg_L'] == 'NA' for r in baseline), '基线DO来源版本变化')
    check('PASS', '起始状态、保存及温度范围', '4条前源、4℃59d、不同起始污泥与30℃/室温未知；实测全NA')
    g5 = [r for r in add_rows if r['group'] == 'G5']
    require(len({r['reactor_instance_id'] for r in g5}) == 1 and
            all(r['reactor_instance_id'] == amap['Batch_01_E3']['reactor_instance_id'] and
                r['phase_days'] == '163' and r['sampling_day_status'] == 'derived_in_original_record' and
                r['mother_sample_id'] == 'NA' for r in g5) and
            len({r['fractionation_event_id'] for r in g5}) == 1, 'G5母样关系变化')
    for a, b in [('B2', 'B3'), ('D2', 'D3')]:
        require(amap['Batch_01_' + a]['continuous_run_id'] ==
                amap['Batch_01_' + b]['continuous_run_id'], 'G2/G3连续实体变化')
    require(all(r['reactor_round'] == ('G1_original' if r['group'] == 'G1' else
                'G2G3_postmix' if r['group'] in ['G2', 'G3'] else 'G4G5_low_DO') for r in add_rows),
            '轮次边界变化')
    check('PASS', '连续实体与母样', 'G2/G3同轮；G4另起时间轴；G5与E3同实体、共1母样事件，163d为推算')

    _, ranking = table(root / RANKING)
    _, evidence = table(root / EVIDENCE)
    _, review = table(root / REVIEW)
    candidates = sorted([r for r in ranking if r['selected'] == 'TRUE'], key=lambda r: int(r['selected_order']))
    cids = [r['feature_id'] for r in candidates]
    require(len(ranking) == len({r['feature_id'] for r in ranking}) == 5510 and len(set(cids)) == 15,
            '有效2.2候选来源不一致')
    require(set(cids) == {r['feature_id'] for r in evidence} == {r['feature_id'] for r in review},
            '候选证据ID不一致')
    check('PASS', '既有候选集复用', '读取5510行既有排名的selected字段，15候选与证据/分类审核一致；没有重新筛选')

    _, influent = table(root / INFLUENT_SOURCE)
    expected = {'COD': '230', 'NH4-N': '50', 'TP': '3.3', 'KHCO3': '250', 'EDTA': '5',
                'FeCl3·6H2O': '0.9', 'KI': '0.18', 'ZnSO4·7H2O': '0.12', 'CuSO4·5H2O': '0.03',
                'Na2MoO4·2H2O': '0.06', 'H3BO3': '0.15', 'CoCl2·6H2O': '0.15', 'MnCl2·4H2O': '0.06'}
    require(len(influent) == 13 and len({r['record_id'] for r in influent}) == 13 and
            {r['parameter']: r['value'] for r in influent} == expected,
            '图片13项转录与已人工辨认数值不一致')
    for r in influent:
        require(r['raw_value'] == r['value'] and Decimal(r['value']).is_finite() and Decimal(r['value']) > 0,
                '原值/规范值不一致或非有限正值')
        require(r['unit'] == r['original_unit'] == 'mg/L' and r['unit_conversion'] == 'none', '来源单位异常')
        require(r['stream_type'] == 'influent' and r['measurement_type'] == INFLUENT_KIND and
                r['measurement_basis'] == 'not_specified' and r['measurement_date'] == r['cycle_id'] ==
                r['n_underlying_measurements'] == 'NA', '测量性质或时间证据变化，须重新审核')
        require(r['applicability_status'] == 'user_confirmed_all_stages_and_reactors' and
                r['applicable_groups'] == 'G1;G2;G3;G4;G5' and
                r['applicable_reactors'] == 'Reactor_01;Reactor_02;Reactor_03;Reactor_04' and
                r['scope_confirmation_quote'] == '所有阶段和反应器的进水水质参数都是这样', '适用范围缺少确认')
    inflow_by_parameter = {r['parameter']: r for r in influent}
    check('PASS', '图片转录与适用范围', '13项原表达/单位/有限正值及用户全阶段全反应器确认实际核对；未指定实测性质')
    check('WARNING', '图片来源证据层级', '会话图片已目视转录；本地无原图二进制，原图路径/指纹NA；原论文/测量日志未提供')

    inventory = []
    unknown = []
    scientific_suffixes = {'.tsv', '.qza', '.fasta', '.biom', '.rds', '.pdf', '.png', '.md', '.log'}
    product_roots = {str(Path(f).parent) for f in REPORTS} | {
        'results/community_composition/2026-11-03_v1',
        'results/functional_guilds/2026-11-03_v1', 'results/phyloseq', 'results/qc'}
    known_tsv_names = set(('G4_same_day_between_reactors G4_within_reactor_changes alpha_diversity '
        'analysis_metadata analysis_metadata_addendum bray_curtis_distance candidate_asv_evidence '
        'candidate_asv_ranking candidate_asv_taxonomy_review class_relative_abundance '
        'continuous_run_transitions dominant_genera_summary focal_asv_abundance_trajectories '
        'focal_asv_function_annotations focal_distance_summary focal_pairwise_asv_contributions '
        'focal_pairwise_genus_contributions focal_temporal_asv_changes functional_asv_annotation '
        'functional_guild_abundance functional_mapping_evidence functional_taxa_abundance '
        'genus_relative_abundance jaccard_distance pairwise_sensitivity pcoa_coordinates '
        'pcoa_eigenvalues phylum_relative_abundance sensitivity_summary').split())
    prior_audit_roots = set()
    audit_names = {'source_inventory.tsv', 'performance_raw_long.tsv', 'sample_performance_match.tsv',
                   'parameter_completeness.tsv', 'analysis_report.md', 'run.log'}
    for p in files:
        if p.name == 'analysis_report.md' and p.parent.parent == root / 'results/operational_performance':
            if 'scripts/operational_performance_audit.py' in p.read_text():
                prior_raw = p.parent / 'performance_raw_long.tsv'
                prior_fields, prior_rows = table(prior_raw)
                require(prior_fields in [RAW_FIELDS, RAW_FIELDS[:-8]], f'历史长表格式变化须审核: {prior_raw}')
                require(all(r['measurement_type'] == INFLUENT_KIND and r['source_file'] == INFLUENT_SOURCE and
                            r['record_id'] in {s['record_id'] for s in influent} and
                            r['value'] == expected.get(r['parameter']) for r in prior_rows),
                        f'既有性能长表出现未审核观测，必须新增来源审核: {prior_raw}')
                prior_audit_roots.add(p.parent)
    for p in files:
        rel = str(p.relative_to(root))
        suffix = p.suffix.lower()
        original_columns = 'NA'
        text = ''
        if suffix in {'.tsv', '.csv'}:
            with p.open(encoding='utf-8-sig') as f:
                line = f.readline()
                if line.startswith('# Constructed from biom'):
                    line = f.readline()
                delimiter = '\t' if suffix == '.tsv' else ','
                columns = next(csv.reader([line], delimiter=delimiter))
                original_columns = json.dumps(columns, ensure_ascii=False)
                text = '\t'.join(columns)
        elif suffix in {'.md', '.log', '.json', '.sh', '.r', '.py', '.txt'}:
            text = p.read_text(encoding='utf-8')
        if rel == BASE:
            role, decision = 'sample_identity_reference', 'identity_only_no_measurement_columns'
        elif rel == DESIGN:
            role, decision = 'user_confirmed_design_record', 'documented_settings_only_not_measurements'
        elif rel == ADDENDUM:
            role, decision = 'derived_design_metadata', 'setting_fields_and_all_NA_measured_fields'
        elif rel == INFLUENT_SOURCE:
            role, decision = 'user_image_transcribed_primary_condition_source', '13_reported_influent_conditions_not_verified_measurements'
        elif p.parent in prior_audit_roots and p.name in audit_names:
            role, decision = 'previous_operational_audit_product', 'historical_audit_not_reimported_as_independent_observations'
        elif str(Path(rel).parent) in product_roots and suffix in scientific_suffixes and (
                suffix != '.tsv' or p.stem in known_tsv_names):
            role, decision = 'existing_16S_analysis_product', 'excluded_as_primary_performance_source'
        elif rel.startswith('logs/') and suffix in {'.json', '.sh'}:
            role, decision = '16S_processing_log', 'excluded_not_reactor_operation_log'
        elif rel in {'input/qiime2/table.qza', 'input/qiime2/taxonomy.qza',
                     'input/qiime2/rep-seqs.qza', 'input/qiime2/denoising-stats.qza',
                     'data/asv_table.tsv', 'data/taxonomy.tsv',
                     'data/exported_sequences/dna-sequences.fasta',
                     'data/exported_table/feature-table.biom'}:
            role, decision = '16S_scientific_input', 'excluded_no_reexport_or_reanalysis'
        elif rel.startswith('scripts/') and suffix in {'.r', '.py'}:
            role, decision = 'analysis_software', 'excluded_not_measurement_source'
        elif rel in required or rel == 'results/asv_contributions/2026-11-05_v2/g4_design_addendum.md':
            role, decision = 'project_documentation', 'secondary_context_not_primary_performance'
        else:
            role, decision = 'unreviewed_potential_source', 'FAIL_requires_explicit_source_review'
            unknown.append(rel)
        mentions = [key for key, pattern in ALIASES.items() if re.search(pattern, text, re.I)]
        inventory.append(dict(inventory_row_type='file', source_id=f'S{len(inventory)+1:03}',
            source_file=rel, bytes=p.stat().st_size, sha256=fingerprints[rel],
            file_format=suffix, worksheet='NA', source_locator='header' if suffix == '.tsv' else 'whole_file',
            original_column=original_columns, parameter_mentions=';'.join(mentions) or 'NA',
            parameter='NA', original_unit='NA', reactor_id='NA', reactor_instance_id='NA',
            measurement_date='NA', window_start_day='NA', window_end_day='NA',
            raw_expression='NA', stream_type='NA', measurement_type='NA',
            source_role=role, audit_decision=decision, provenance_level='local_file_read_and_hashed',
            missing_reason='no_primary_performance_observation'))
    require(not unknown, '发现未审核来源，受影响提取/匹配已停止: ' + ';'.join(unknown))
    check('PASS', '递归来源盘点', f'{len(files)}个既有文件含隐藏/忽略文件，排除.git和本脚本；无软链接/未审核来源')
    check('WARNING', '原始测量数据缺口', '新增进水图片来源13条；仍无可回查逐日/周期实测、出水序列或阶段实测均值')

    # 逐条引用设计文档中的原表表达，不把设定值制造为性能原始观测。
    lines = texts[DESIGN].splitlines()
    for index, line in enumerate(lines, 1):
        cells = [x.strip() for x in line.strip('|').split('|')]
        if line.startswith('| G') and len(cells) == 8 and cells[0] in {
                'G1_all', 'G2_all', 'G3_all', 'G4_baseline', 'G4_post_adaptation', 'G5_all'}:
            inventory.append(dict(inventory_row_type='documented_setting', source_id=f'DO_{cells[0]}',
                source_file=DESIGN, bytes=(root / DESIGN).stat().st_size, sha256=fingerprints[DESIGN],
                file_format='.md', worksheet='NA', source_locator=f'line:{index};phase_key:{cells[0]}',
                original_column='setting_text', parameter_mentions='DO', parameter='DO',
                original_unit='mg/L', reactor_id='Reactor_01' if cells[0] == 'G5_all' else
                'Reactor_02;Reactor_04' if cells[0] == 'G2_all' else
                'Reactor_01;Reactor_02;Reactor_03;Reactor_04', reactor_instance_id='NA',
                measurement_date='NA', window_start_day=cells[1], window_end_day=cells[2],
                raw_expression=cells[6], stream_type='reactor_operating_setting',
                measurement_type='setpoint_not_mean', source_role='user_confirmed_design_record',
                audit_decision='background_only_not_A_B_C', provenance_level='user_confirmation_transcribed_in_design',
                missing_reason='measured_DO_and_calendar_window_not_provided'))
        if line.startswith('| R') and len(cells) == 6 and '运行' in cells[3]:
            rid = 'Reactor_0' + cells[0][1:]
            inventory.append(dict(inventory_row_type='documented_setting', source_id=f'TEMP_{cells[0]}',
                source_file=DESIGN, bytes=(root / DESIGN).stat().st_size, sha256=fingerprints[DESIGN],
                file_format='.md', worksheet='NA', source_locator=f'line:{index};G4:{cells[0]}',
                original_column='G4温度运行条件;标称恒温设置（℃）;采样实测温度（℃）',
                parameter_mentions='temperature', parameter='temperature', original_unit='℃',
                reactor_id=rid, reactor_instance_id='G4G5_low_DO::' + rid, measurement_date='NA',
                window_start_day='NA', window_end_day='NA', raw_expression=cells[3],
                stream_type='reactor_operating_setting', measurement_type='regime_not_measurement',
                source_role='user_confirmed_design_record', audit_decision='G4_background_only_not_A_B_C',
                provenance_level='user_confirmation_transcribed_in_design',
                missing_reason='instantaneous_temperature_and_baseline_scope_unknown'))
    require(sum(r['inventory_row_type'] == 'documented_setting' for r in inventory) == 10,
            '设计设置来源表未准确解析6条DO/4条温度')
    check('PASS', '设置来源原位置', '6条DO设置及4条G4温度条件，保存原表达、单位、文档行号；不计原始观测')

    raw = []
    for source_row, r in enumerate(influent, 2):
        raw_row = {k: 'NA' for k in RAW_FIELDS}
        raw_row.update(record_id=r['record_id'], source_id=r['document_id'], source_file=INFLUENT_SOURCE,
            source_sha256=fingerprints[INFLUENT_SOURCE], source_row=source_row, original_column=r['original_column'],
            parameter=r['parameter'], raw_value=r['raw_value'], value=r['value'], original_unit=r['original_unit'],
            unit=r['unit'], unit_conversion='none', reactor_id=r['applicable_reactors'],
            reactor_round='G1_original;G2G3_postmix;G4G5_low_DO', stream_type='influent',
            measurement_type=INFLUENT_KIND, missing_reason=r['missing_reason'],
            audit_status='PASS_transcription_and_scope_ONLY_not_verified_measurement', source_table=r['image_table_number'],
            source_label=r['original_label'], concentration_basis=r['concentration_basis'],
            measurement_basis=r['measurement_basis'], applicable_groups=r['applicable_groups'],
            applicable_reactors=r['applicable_reactors'], scope_confirmation_source=r['source_reference'],
            image_archival_status=r['image_archival_status'])
        raw.append(raw_row)
        inv_row = {k: 'NA' for k in inventory[0]}
        inv_row.update(inventory_row_type='document_reported_influent', source_id=r['record_id'],
            source_file=INFLUENT_SOURCE, bytes=(root / INFLUENT_SOURCE).stat().st_size,
            sha256=fingerprints[INFLUENT_SOURCE], file_format='.tsv',
            source_locator=f"TSV_row:{source_row};image_table:{r['image_table_number']};image_row:{r['image_data_row']};side:{r['image_side']}",
            original_column=r['original_column'], parameter_mentions=r['parameter'], parameter=r['parameter'],
            original_unit=r['original_unit'], reactor_id=r['applicable_reactors'], raw_expression=r['raw_value'],
            stream_type='influent', measurement_type=INFLUENT_KIND,
            source_role='user_image_plus_all_scope_confirmation', audit_decision='common_condition_only_not_A_B_C_measurement',
            provenance_level=r['source_reference'], missing_reason=r['missing_reason'])
        inventory.append(inv_row)
    require(len(raw) == 13 and len({r['record_id'] for r in raw}) == 13, '进水来源被重复或丢失')
    check('PASS', '13条来源长表', '13项浓度仅各保存一次；原单位和盐类水合化学式保留，不换算元素或碱度')
    matches = []
    parameter_fields = []
    for par in PARAMETERS:
        parameter_fields.extend(par + '_' + k for k in ['value', 'unit', 'match_class', 'record_ids', 'missing_reason'])
    for source_row, base_row in enumerate(base_rows, 2):
        row = dict(amap[base_row['sample-id']])
        row['sample_id'] = row.pop('sample-id')
        row.update(metadata_source_row=source_row, sampling_date='NA', sampling_cycle_id='NA',
                   performance_match_class='D', performance_record_ids='NA', matched_parameter_n=0,
                   match_basis='sample_id/reactor_id/instance/phase/day_audited_no_raw_records_or_calendar_anchor',
                   match_missing_reason=MISSING, match_window_start='NA', match_window_end='NA',
                   design_background_not_performance='TRUE', independent_performance_observation_n=0,
                   steady_state_performance_audit='not_assessable_no_raw_performance_records',
                   sampling_date_missing_reason='not_recorded_in_source_metadata_or_confirmed_design')
        row.update(common_influent_condition_record_ids=';'.join(r['record_id'] for r in influent),
                   common_influent_condition_source=INFLUENT_SOURCE,
                   common_influent_condition_match_status='confirmed_all_stages_and_reactors',
                   common_influent_condition_measurement_basis='not_specified',
                   common_influent_condition_unique_source_n=1,
                   common_influent_condition_independent_measurement_n=0)
        for condition in influent:
            par = condition['parameter']
            row.update({f'influent_{par}_reported_value': condition['value'],
                        f'influent_{par}_reported_unit': condition['unit'],
                        f'influent_{par}_condition_record_id': condition['record_id']})
        if row['group'] in ['G4', 'G5']:
            rid = row['reactor_id']
            initial = next(b for b in baseline if b['reactor_id'] == rid)
            row.update(lineage_initial_16S_sample_id=initial['sample-id'],
                       lineage_pre_storage_16S_sample_id=initial['G4_pre_storage_source_sample_id'],
                       lineage_inherited_pool_id=initial['G4_inherited_pool_id'],
                       historical_boundary='post_G1_mix_split;G2G3_continuous;4C_storage_59d;recovery;new_G4_axis',
                       history_source=DESIGN + '#2026-11-02-design-correction')
        else:
            row.update(lineage_initial_16S_sample_id='NA', lineage_pre_storage_16S_sample_id='NA',
                       lineage_inherited_pool_id=row['pool_id'],
                       historical_boundary='G1_original_before_mix' if row['group'] == 'G1' else
                       'post_G1_mix_split;G2G3_continuous_before_storage',
                       history_source=DESIGN + '#2026-11-02-design-correction')
        row['observation_event_id'] = row['fractionation_event_id'] if row['group'] == 'G5' else row['sample_id']
        row['observation_event_id_status'] = 'internal_key_not_original_mother_or_cycle_registration'
        for par in PARAMETERS:
            row.update({par + '_value': 'NA', par + '_unit': 'NA', par + '_match_class': 'D',
                        par + '_record_ids': 'NA', par + '_missing_reason': MISSING +
                        (';only_operating_setpoint_or_regime_available' if par in ['DO', 'temperature'] else '')})
            if par in inflow_by_parameter:
                row[par + '_missing_reason'] = 'common_influent_condition_available_but_measurement_basis_date_window_unknown'
                row[par + '_influent_condition_record_id'] = inflow_by_parameter[par]['record_id']
            else:
                row[par + '_influent_condition_record_id'] = 'NA'
        matches.append(row)
    require([r['sample_id'] for r in matches] == ids and len(matches) == 33, '匹配表增删或重排样本')
    require(len({r['observation_event_id'] for r in matches}) == 30, '共享母样事件去重异常')
    require(all(r[p + '_value'] == 'NA' and r[p + '_match_class'] == 'D' for r in matches for p in PARAMETERS),
            '无来源性能值或匹配等级异常')
    check('PASS', '逐样本逐参数匹配与NA', '33行×14参数=462个参数位置均D/NA；30个内部采样事件键不等于30独立观测')
    require(all(r[f'influent_{p}_reported_value'] == value for r in matches for p, value in expected.items()),
            '共同进水条件未准确链接至33样本')
    check('PASS', '共同进水条件映射', '13条记录链接33样本；COD/NH4-N/TP条件覆盖均33/33，与A/B/C实测覆盖分列')
    require(all(len({r[f'influent_{p}_reported_value'] for r in matches}) == 1 for p in expected),
            '已确认共同进水条件不应出现样本间变异')
    cod_nh4_ratio = Decimal(expected['COD']) / Decimal(expected['NH4-N'])
    require(cod_nh4_ratio == Decimal('4.6'), '报告浓度比值计算异常')
    check('PASS', '常数协变量与浓度比', '13项共同条件在33行均只有1水平；图示COD/NH4-N=4.6，不作COD/TN或去除率')
    completeness = []
    for par in PARAMETERS:
        background_n = sum(r['design_document_DO_setting_text'] != 'NA' for r in matches) if par == 'DO' else \
            sum(r['temperature_regime'] != 'NA' for r in matches) if par == 'temperature' else 0
        nominal_n = sum(r['design_document_DO_setpoint_mg_L'] != 'NA' for r in matches) if par == 'DO' else \
            sum(r['temperature_setpoint_C'] != 'NA' for r in matches) if par == 'temperature' else 0
        param_raw = [r for r in raw if r['parameter'] == par]
        row = dict(parameter=par, raw_record_n=len(param_raw), raw_source_file_n=len({r['source_file'] for r in param_raw}),
                   original_unit='mg/L' if param_raw else 'NA',
                   n_samples=33, n_matched_samples=0, measured_coverage_pct=0,
                   n_A=0, n_B=0, n_C=0, n_D=33, n_unique_matched_records=0,
                   n_independent_matched_observations=0, n_influent=0, n_effluent=0,
                   n_cycle_measurement=0, n_instantaneous=0, n_phase_measured_mean=0,
                   n_samples_with_design_background=background_n,
                   design_background_coverage_pct=f'{background_n / 33 * 100:.6f}',
                   n_samples_with_numeric_nominal_setting_context=nominal_n,
                   measured_same_day_usable='FALSE', pre_sample_window_usable='FALSE',
                   phase_mean_usable='FALSE', correlation_gate='FAIL_no_matched_observations',
                   missing_reason=MISSING, background_source=DESIGN if background_n else 'NA',
                   n_document_reported_influent_records=len(param_raw), n_verified_measurement_records=0,
                   n_samples_with_influent_condition=sum(r[par + '_influent_condition_record_id'] != 'NA' for r in matches),
                   influent_condition_coverage_pct=100 if param_raw else 0,
                   influent_condition_reported_value=param_raw[0]['value'] if param_raw else 'NA',
                   influent_condition_measurement_basis='not_specified' if param_raw else 'NA',
                   influent_condition_source=INFLUENT_SOURCE if param_raw else 'NA',
                   n_unique_influent_condition_levels=len({r['value'] for r in param_raw}))
        if param_raw:
            row['missing_reason'] = 'reported_influent_exists_but_measurement_basis_date_window_and_effluent_missing'
        if par == 'DO':
            row['missing_reason'] += ';settings_not_measurements;G1_range_no_midpoint;baseline_recovery_3_separate_from_old_analysis_NA'
        if par == 'temperature':
            row['missing_reason'] += ';G4_only;ambient_unknown;numeric_setting_context_includes_baseline_not_measured_temperature'
        completeness.append(row)
    require(sum(r['n_samples_with_influent_condition'] for r in completeness) == 99,
            '14参数范围内应有COD/NH4-N/TP三项×33条件链接')
    check('PASS', '参数覆盖率计算', 'COD/NH4-N/TP进水条件100%；14参数可核实测覆盖仍0%；不将99个条件链接当99次测量')
    check('WARNING', '时间锚点与测量口径', '33行日历/周期ID未知；进水条件已确认，实测性质/窗口及出水仍缺，未自动标C类均值')
    check('WARNING', '设计与推断局限', '纵向相关、共享谱系、不同初始污泥、温度/反应器混杂、G5单母样；有效独立性能观测0')
    check('FAIL', '性能关联分析门控（受影响步骤）', '14项参数无可审核匹配观测，15候选均暂不能进入性能相关检验；本轮审计继续交付')

    output.parent.mkdir(parents=True, exist_ok=True)
    output.mkdir(exist_ok=False)
    with (output / 'run.log').open('x', encoding='utf-8') as log:
        log.write(f'模块2.3 START {start.isoformat()}\ncommand: {shlex.join([sys.executable] + sys.argv)}\n')
        log.write(f'Python: {platform.python_version()}\nplatform: {platform.platform()}\nstdlib_only: TRUE\n')
        log.write(f'script_sha256: {sha(Path(__file__).resolve())}\noutput: {output}\n')
        try:
            write_table(output / 'source_inventory.tsv', list(inventory[0]), inventory)
            write_table(output / 'performance_raw_long.tsv', RAW_FIELDS, raw)
            match_fields = ['sample_id'] + [k for k in matches[0] if k != 'sample_id']
            require(set(match_fields) == set(matches[0]), '匹配字段遗漏')
            write_table(output / 'sample_performance_match.tsv', match_fields, matches)
            write_table(output / 'parameter_completeness.tsv', list(completeness[0]), completeness)
            check('PASS', '四表序列化回读', f'来源{len(inventory)}行，来源长表{len(raw)}行，匹配33行，完整性14行；字段/值逐一回读一致')
            require(all(sha(root / f) == h for f, h in fingerprints.items()), '既有文件指纹变化')
            check('PASS', '本次脚本输入保护', f'{len(fingerprints)}个既有文件运行前后SHA-256一致；不写原始metadata/历史报告')
            end = datetime.now(ZoneInfo('Asia/Shanghai'))
            totals = Counter(c['status'] for c in checks)
            data_counts = [dict(parameter=r['parameter'], raw_record_n=r['raw_record_n'],
                                measured_coverage='0/33 (0%)', A_B_C_D='0 / 0 / 0 / 33',
                                background_n=r['n_samples_with_design_background']) for r in completeness]
            cand_rows = []
            emap = {r['feature_id']: r for r in evidence}
            for r in candidates:
                cand_rows.append(dict(candidate='C' + str(int(r['selected_order'])).zfill(2),
                    feature_id=r['feature_id'], original_genus=r['genus'],
                    existing_evidence=r['evidence_category'], G4_detected=r['G4_detected_n_ge1'] + '/15',
                    matched_performance_records=0, next_step='HOLD_no_matched_performance',
                    functional_validation=emap[r['feature_id']]['project_function_validation']))
            condition_rows = [dict(parameter=r['parameter'], original_label=r['original_label'], value=r['value'],
                unit=r['unit'], record_id=r['record_id'], table=r['image_table_number']) for r in influent]
            coverage_rows = [dict(parameter=r['parameter'], source_records=r['raw_record_n'],
                common_influent_n=r['n_samples_with_influent_condition'], common_influent_pct=r['influent_condition_coverage_pct'],
                measured_pct=r['measured_coverage_pct'], A_B_C_D='0/0/0/33',
                design_background_n=r['n_samples_with_design_background']) for r in completeness]
            report = f'''# 模块2.3：进水图片来源录入、共同条件及16S样本匹配

当前版本：`{output.relative_to(root)}`。执行：{start.isoformat()} 至 {end.isoformat()}（Asia/Shanghai）。新增进水来源后的实际重新审核；保留此前[无进水图片时的v2报告](../2026-11-06_v2/analysis_report.md)和昨日草稿，不覆盖历史六文件。

**审计与共同条件匹配PASS；测量性质及时间证据WARNING；性能相关检验门控FAIL（关闭）。** 实际检查{totals['PASS']} PASS / {totals['WARNING']} WARNING / {totals['FAIL']} FAIL。退出0表示本模块审计交付成功，FAIL针对尚未开展的后续推断；必需数据/来源/设计断言失败仍非零退出。

## 执行前检查、来源与用户确认

已阅读AGENTS、研究背景、设计、计划、日志及模块1.1–2.2五份有效v2报告；按唯一原metadata `{BASE}`核对33样本、8/2/4/15/4，原表14列及旧派生字段逐值保留。9项上游v2报告/派生metadata/候选表及原metadata指纹与上一有效模块2.3来源清单完全一致。先报告图片性质/范围歧义与计划，再录入。

本次图为用户会话提供的“表2.1 进水中各组分浓度”“表2.2 进水中微量元素组成及含量”。随后用户明确确认：**“所有阶段和反应器的进水水质参数都是这样”**。因此共同进水条件适用于本批已确认五模块和四反应器（含其已区分的轮次），可关联全部33个16S样本；不再把范围列为未知或重复索取名单。

图片未说明是配水设定值、单次实测还是阶段实测均值；用户范围确认也没有补充测量性质、方法、采样日期、周期、重复数或均值窗口。因此统一记录`document_reported_common_influent_condition`及`measurement_basis=not_specified`，既不擅自当配水理论值，也不当作已核实测量。用户确认资料不等于原始实验日志已独立验证。

新增源数据为[{INFLUENT_SOURCE.split('/')[-1]}](../../../{INFLUENT_SOURCE})，仅写新文件，原始sample metadata、ASV、taxonomy、功能注释和对象不修改。源表包含13项原标签/原值/单位、图片表号/行/左右位置、共同适用范围、用户原话及来源层级。会话图片已经目视读取，但未取得本地附件二进制，故原图本地路径/图像SHA-256为NA，不虚构文件名或假称归档原图；转录TSV本身具有真实SHA-256并被逐行核查。

项目递归盘点{len(files)}个既有文件（包括此前盘点，不含本次新输出及脚本），source_inventory共{len(inventory)}行：逐文件记录，加10条已确认DO/温度设置来源及13条新增进水来源定位。未发现其他未审核来源；没有新增可回查的出水/逐日/周期实测或阶段实测均值。历史盘点表不再次导入为原始测量。

## 图片13项原值与数据边界

{markdown_table(['record_id', 'table', 'original_label', 'parameter', 'value', 'unit'], condition_rows)}

- 表2.1四项：COD 230、NH₄⁺-N 50、TP 3.3、KHCO₃ 250 mg/L。表2.2九项完整保留，EDTA具体化学形式未写明，不自行改为二钠盐。
- NH₄⁺-N仅规范化参数名为NH4-N，数值不换算为NH₄⁺质量；TP不等于PO4-P，NH4-N不等于TN。未报告的NO2-N/NO3-N/TN/PO4-P等仍NA，不能认为为0。
- 所有盐类按原完整化学式及水合状态的mg/L浓度记录，不把FeCl₃·6H₂O浓度称为Fe元素浓度，不把KHCO₃ 250直接称为碱度（以CaCO₃计），不为Cu/Zn/Co/Mn/Mo给出元素转换或毒性/效应判断。
- 图示COD/NH4-N浓度比为230/50={cod_nh4_ratio}，仅是同表报告数值的算术比；不是COD/TN、不是样本实测比、不是运行负荷或去除率，也不足以证明实际碳限制。缺少出水与流量/体积等依据，不计算去除效率、氮磷质量平衡或体积负荷。

## 长表与33样本对应

[performance_raw_long.tsv](performance_raw_long.tsv)有**13条来源记录**，每项一次，stream_type=influent；保留原文件/TSV行号/图片表号/原标签/原列名/单位、来源指纹和测量性质。日期、周期、测量时间窗、底层测量数均NA；没有人为添加单一样本ID，因为来源是全范围共同条件。新增记录不是13次采样、更不是13份独立反应器观测。

[sample_performance_match.tsv](sample_performance_match.tsv)严格33行，保持原metadata行序。`influent_<parameter>_reported_value/unit/condition_record_id`明确显示所有13项共同条件；`common_influent_condition_record_ids`链接同一组IF001–IF013和同一文档。每个样本同一数值只是来源共享的条件映射，不复制成原始测量，`common_influent_condition_independent_measurement_n=0`。G5四级分共享同一母样、同一来源记录，绝不当四次独立进水测量。

原有`<parameter>_value/unit/match_class/record_ids`仍专用于可审核的性能测量，33×14=462个位置为NA/D；共同进水字段与其分开，避免把正确的条件覆盖误读为实测覆盖。14参数范围内COD/NH4-N/TP共99个样本条件链接，实际独特来源记录仅3条，来源文档1份。KHCO₃及九项微量组分作为14项之外的10个参数同样完整保留在源数据、长表和样本条件字段中，不混入14参数覆盖率分母。

| 分类 | 证据要求及本次判定 |
| --- | --- |
| A | 同运行实体且同日或明确同一采样周期；本次0，未知实测性质/日期不能凭共同进水条件判A |
| B | 同实体且明确位于采样前窗口；本次0，没有窗口和底层时序，不任定7/14/30天 |
| C | 仅阶段实测平均且有来源/阶段/窗口依据；本次0，共同条件和范围确认不是阶段实测平均 |
| D | 缺可核实测量/日期/窗口；14参数各33/33；不表示没有可用设计/进水背景 |
| 共同进水条件 | 用户确认全阶段全反应器，COD/NH4-N/TP及额外10项均关联33/33；性质单列，不冒充A/B/C |

## 14项参数覆盖率与缺失原因

{markdown_table(['parameter', 'source_records', 'common_influent_n', 'common_influent_pct', 'measured_pct', 'A_B_C_D', 'design_background_n'], coverage_rows)}

[parameter_completeness.tsv](parameter_completeness.tsv)逐项计算来源记录、共同条件/设计背景与可核实测覆盖。COD/NH4-N/TP各有1条文档进水记录、33/33条件覆盖（100%），各参数可核实测覆盖仍0/33（0%）。`raw_record_n`计来源记录，不再一律为0；`n_influent`仍计核实测量，进水文档条数由`n_document_reported_influent_records`另列，不能混用。其余11项无新增图片测量：DO设置33行、G4温度设计标签15行继续单列，其余缺口不填补。各参数缺失原因区分“没有来源值”和“有进水共同条件，但测量性质/时间/出水未提供”。

## 历史、重复与混杂约束

G1旧反应器前后配对及约120d属性保留；G1后R1/R2、R3/R4混合均分的来源块保留。G2/G3同轮连续，22d为过渡过程；G3末4℃保存59d、恢复后G4另起时间轴，不能跨保存恢复拼接。四起始E1←A2、F1←B3、原G1←C2、H1←D3完整追踪，起始状态不同但来源不自动独立。原样本G1属于模块G4，不与模块G1混淆。

G4 day1为恢复后低DO切换前基线；旧分析DO=NA/文档恢复3及新增恢复设置字段原样保留。后期11行按设计稳定运行期，DO设置0.5±0.2；设置不是均值±SD，运行性能稳态仍不能由进水条件或群落距离证明。R1缺30d不插值。G4 R1/R3=30℃运行、R2/R4室温未知；恢复/基线瞬时温度仍未知，非G4温度不外推。G5仍同一R1母样四粒径级分，163d保留原表推算；共同进水确认不改变实验实体、时间、原样本列表或重复结构。

## 科研可行性逐项审核

1. **同期描述：** 可将13项已确认共同进水浓度作为样本/阶段背景并列描述；无同期出水及可审核A类测量，不能描述处理成效或ASV与同期实际水质的相关。
2. **采样前时间窗口：** 无B类原始时序/窗口，不能计算采样前均值或滞后响应。
3. **阶段背景：** 共同进水条件已明确覆盖所有阶段/反应器，DO与G4温度设计背景继续有效；没有C类阶段实测均值。不能因进水条件恒定就断言运行稳态。
4. **相关检验：** 程序实际核对13项在33样本均只有1个报告浓度水平，零样本间变异；即使范围全覆盖，也不能把这些常数作ASV相关、回归或机器学习解释变量。没有独立测量配对，可核实独立性能观测0，相关检验门控FAIL。未来补齐测量仍须审核单位、变异、实体/谱系相关、重复及可识别性；不能由33行条件链接增加独立样本量。
5. **温度效应：** 共同进水相同减少了一个已报告条件差异，但没有随机化或控制不同起始污泥、反应器个体、共享谱系/保存恢复与纵向历史。不能由相同进水认定温度是唯一原因，也不能分离温度/起始污泥效应；室温数值仍NA。
6. **候选ASV：** 十五候选完整沿用模块2.2有效v2，新增共同进水条件后仍0个获准进入性能关联。可保留为后续反应器内描述对象，不能从共同COD/N/TP、GAO关联或比值4.6推出碳竞争、反硝化、除磷失败或任何ASV活性。

{markdown_table(['candidate', 'feature_id', 'original_genus', 'existing_evidence', 'G4_detected', 'matched_performance_records', 'next_step', 'functional_validation'], cand_rows)}

6个GAO类群关联、4个Acinetobacter功能歧义、5个功能未知/未分配均不改变。短16S不能验证功能基因或活性，相对丰度不是绝对量，不乘MLSS/MLVSS/VSS转为严格绝对丰度。不重新筛选候选，不重跑DADA2、QIIME2分类、深度QC、功能映射或群落距离；未运行相关检验、机器学习、网络、因果或差异显著性检验。

## 实际核验、复现与保护

{markdown_table(['status', 'check', 'evidence'], checks)}

输出仅指定6文件：[source_inventory.tsv](source_inventory.tsv)、[performance_raw_long.tsv](performance_raw_long.tsv)、[sample_performance_match.tsv](sample_performance_match.tsv)、[parameter_completeness.tsv](parameter_completeness.tsv)、本报告、[run.log](run.log)。额外新增的13行源转录文件属于原始来源数据，不是中间结果。无性能曲线，因为未提供时序测量；没有为常数条件制作误导性相关图。

命令：`{shlex.join([sys.executable] + sys.argv)}`。Python {platform.python_version()}，{platform.platform()}，仅标准库。脚本SHA-256：`{sha(Path(__file__).resolve())}`。默认输出`results/operational_performance/2026-11-06_influent_v2`；已有目录和v1输出均在写入前拒绝，需复现时指定尚不存在的新v2目录。不覆盖之前有效v2或原始metadata。脚本检测新未审核来源时非零停止，不用固定空数据结论忽略新增资料。

关键输入SHA-256如下；全部文件及源表逐记录定位见source_inventory。文档维护随后发生的README/累计解释/日志更新不改写本次运行时指纹。

{markdown_table(['path', 'sha256'], [dict(path=f, sha256=fingerprints[f]) for f in required])}

## 尚待补充的科研信息

全阶段/全反应器适用范围已解决，无须重报33样本清单或进水数值。仍需说明图片浓度是配水设定、单次实测或阶段均值；若为实测/均值，提供采样日期/周期、方法、底层记录数及窗口。后续性能审核重点为出水COD/氮磷、逐日/周期运行记录、DO/温度实测及16S日历或周期锚点；恢复时长、起始污泥登记/性状、流量/体积、HRT/SRT、MLSS/MLVSS等缺口不填补。缺失不等于0，共同进水条件覆盖100%不等于实测匹配通过或具备独立统计观测。
'''
            with (output / 'analysis_report.md').open('x', encoding='utf-8') as f:
                f.write(report)
            for c in checks:
                log.write(f"{c['status']} {c['check']}: {c['evidence']}\n")
            for f, h in fingerprints.items():
                log.write(f'INPUT_SHA256 {h}  {f}\n')
            for p in sorted(output.iterdir()):
                if p.name != 'run.log':
                    log.write(f'OUTPUT_SHA256 {sha(p)}  {p.name}\n')
            log.write(f'END {end.isoformat()}\nexit_code: 0 (audit_completed; downstream_statistics_gate=FAIL)\n')
        except Exception as exc:
            log.write(f'FAIL exception: {type(exc).__name__}: {exc}\n')
            raise
    require(len(list(output.iterdir())) == 6, '输出文件数非6')
    print(f'审计完成: {output}\n{dict(totals)}; documented_influent_records={len(raw)}; verified_measurements=0; samples=33; parameters=14; downstream_gate=FAIL')


if __name__ == '__main__':
    try:
        main()
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)
