# Batch_01 人工进水设计配方正式确认与派生metadata审核

实际执行：2026-11-06T15:57:31.759082+08:00 至 2026-11-06T15:57:31.791297+08:00（Asia/Shanghai）。当前版本：`results/operational_performance/2026-11-06_design_recipe_v2`。

**设计配方及metadata交付PASS；实测缺口WARNING；后续性能关联门控FAIL（关闭）。** 程序实际9 PASS / 2 WARNING / 1 FAIL，退出0表示本次设计确认交付成功；必要条件断言失败非零退出。FAIL只针对未执行的后续性能关联。

## 当前确认与历史替代

用户正式确认：表2.1和表2.2的人工进水配方适用于Batch_01全部G1–G5实验过程，33个样本均共享该名义进水设计条件。 所有13项为`design_recipe`，均非`sample_measured`。本报告取代[前轮图片性质未说明的当前状态](../2026-11-06_influent_v2/analysis_report.md)；原源表、旧报告和历史有效v2全部保留，不回写既往记录。测量性质已解决，不再要求重复确认配方性质或范围；缺少的仍为实际测量数据。

## 正式配方与名义比值

源表：[2026-11-06_influent_design_recipe_v2.tsv](../../../data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv)，13行且仅1个recipe_id：`Batch_01_uniform_influent_design_20261106`。来源包括旧图片转录指纹与[实验设计正式确认节](../../../docs/batch_01/experiment_design.md#2026-11-06-uniform-influent-design-recipe)；原图本地二进制缺失的历史边界保留，不虚构原图路径/指纹。

| parameter | nominal_mg_L | data_type | source_record_id |
| --- | --- | --- | --- |
| COD | 230 | design_recipe | DR001 |
| NH4-N | 50 | design_recipe | DR002 |
| TP | 3.3 | design_recipe | DR003 |
| KHCO3 | 250 | design_recipe | DR004 |
| EDTA | 5 | design_recipe | DR005 |
| FeCl3·6H2O | 0.9 | design_recipe | DR006 |
| KI | 0.18 | design_recipe | DR007 |
| ZnSO4·7H2O | 0.12 | design_recipe | DR008 |
| CuSO4·5H2O | 0.03 | design_recipe | DR009 |
| Na2MoO4·2H2O | 0.06 | design_recipe | DR010 |
| H3BO3 | 0.15 | design_recipe | DR011 |
| CoCl2·6H2O | 0.15 | design_recipe | DR012 |
| MnCl2·4H2O | 0.06 | design_recipe | DR013 |

适用全部Batch_01 G1–G5、R1–R4已区分的轮次及33样本的名义进水设计；不赋值为保存液组成或样本瞬时浓度。微量配方原值/水合化学式/单位与表2.2完全一致，浓度单位均mg/L；不换算盐类为元素/碱度，EDTA形式不补，NH4-N不替TN，TP不替PO4-P。

- 名义COD/NH4-N=230/50=**4.6**。
- 名义COD/TP=230/3.3=**69.69696969696969696969696970**，保留两位小数为**69.70**（约69.70）。Decimal精度28位，显示舍入ROUND_HALF_UP。

两者都是设计配方比，非样本实测比、COD/TN、去除率、实际负荷或碳限制证据，不计算处理性能或推断ASV功能。

## 新派生metadata与原始数据保护

[analysis_metadata.tsv](analysis_metadata.tsv)为33行、93列，使用原`sample-id`列名并保留原metadata顺序；原始14列及2.1派生表全部63列逐值保留。新增`uniform_influent_design=TRUE`、`influent_data_type=design_recipe`、`influent_sample_measured=FALSE`、共享recipe_id/源表/正式确认出处、13项`influent_design_*_mg_L`及两个名义比字段（COD/TP另有两位小数展示）。原33×14 metadata、旧派生表、RDS、ASV、taxonomy及功能注释不修改。

所有33样本关联同一份设计配方，13种组分不是13次采样，33份属性链接不是33条独立水质观测；独立水质观测新增数明确为0。共同配方各参数在样本间仅1个水平，不能作为可估计的连续样本协变量。单独保存派生metadata，不把设计值写入sample_measured字段，不生成虚假的33份原始性能记录。

## 模块2.3性能门控与科研边界

程序实际读取前轮33行匹配与14行完整性，复核全部462个实测位置仍NA/D、A/B/C均0、各参数实测覆盖仍0/33（0%）。本次正式配方确认不增加同日/周期实测、采样前窗口或阶段实测平均。派生metadata明确`performance_association_gate=closed_missing_measured_performance`，后续性能关联继续关闭，不执行相关检验、机器学习、网络或因果推断。

五组8/2/4/15/4不变；原63列保留意味着G4四份起始来源/不同初始状态、混合谱系/4℃59d保存恢复、G2/G3同轮连续、G4另起时间轴、R1缺30d、G5同一母样四级分等事实不改。R1/R3=30℃、R2/R4室温未知和原DO设定/实测边界保留；同一人工进水设计不消除反应器、初始污泥、历史、温度或纵向混杂，也不证明性能稳态或温度效应。16S相对丰度不是绝对丰度，分类关联不是功能基因/活性。

本轮只做设计确认、来源审核、字段派生及两个名义比值计算；不运行DADA2、taxonomy、功能映射、群落多样性或距离计算，不重筛候选，不更新现有对象。

## 实际检查

| status | check | evidence |
| --- | --- | --- |
| PASS | 输入及v2链 | 9项上游有效v2、原metadata及旧图片源表指纹与上次审计一致；设计新增节另记新指纹 |
| PASS | 33样本基准及分组 | 原metadata33×14，逐ID确认8/2/4/15/4；保留全部2.1派生字段 |
| PASS | 正式配方性质及来源 | 13项均design_recipe、sample_measured=FALSE；用户确认与设计锚点可回查 |
| PASS | 图片原值保留 | 全部原标签/化学式/值/单位/位置与旧图片转录一致；只有性质确认层发生变化 |
| PASS | 名义比值 | COD/NH4-N=4.6；COD/TP=69.69696969696969696969696970，保留2位小数69.70；非实测比或去除率 |
| PASS | 性能门控事实复核 | 14参数覆盖仍0/33；462个NA/D，A/B/C各0，不把名义设计当水质观测 |
| PASS | 派生metadata | 33行保留原63列，新增设计字段/13名义浓度/2名义比；同一recipe_id共享 |
| WARNING | 独立性与常数条件 | 33份设计属性链接不是33条独立水质观测；13项设计浓度均为单一水平 |
| WARNING | 实测与科研限制 | 实际进出水、运行测量/时间窗仍缺；同配方不解除起始污泥/谱系/反应器/温度混杂 |
| FAIL | 后续性能关联门控 | 按原模块2.3结论继续关闭；没有新增sample_measured或独立配对性能观测 |
| PASS | 输出序列化回读 | analysis_metadata.tsv为33×93；全部字段/值回读一致 |
| PASS | 输入保护 | 21项实际读取输入运行前后SHA-256一致；原metadata/旧结果不写入 |

## 文件、复现与输入指纹

必要产物仅正式源配方表、新派生metadata、本综合报告及[run.log](run.log)。输出目录仅3文件；不重出完整模块2.3六表，不创建功能重复总结或逐项检查文件。实验设计/README/累计解释/分析日志按本次确认追加或更新当前状态，旧证据保留。

命令：`/home/leiyiping/miniconda3/bin/python3 scripts/operational_performance_audit.py --mode design-recipe`。复现：`python3 scripts/operational_performance_audit.py --mode design-recipe`，为默认模式；默认输出本新v2目录，已有目录在任何写入前拒绝覆盖，需重现时指定尚不存在的新v2目录。历史图片性质未说明模式保留为`--mode image-audit`，其旧源表/旧结果不更新。

Python 3.14.7；仅标准库；脚本SHA-256：`36e250b100cad64f10e0456cb1dabe26b07f5ab1df3e72ed2f24aac32530a335`。下表为本次运行实际输入指纹，实验设计含本次新增确认，旧报告的旧设计指纹保持历史属性。运行后按规则同步三文档不改写运行时指纹。

| path | sha256 |
| --- | --- |
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| docs/batch_01/experiment_design.md | d934ba097876772559a5e2658faf4f5cdbea5564167a6a164efdaf86a448d2b9 |
| docs/batch_01/analysis_plan.md | c7250e1440ef404a4df1f06e39abe458ce0743588cb2ed2e1c48b6dba2d1d1ad |
| docs/batch_01/analysis_log.md | 35eb4cfdab534599a6da8448577dbafb8ec8b11e44bdfc0de96eb514396eba46 |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv | 6a43dc622bfa78a8644892bfbb1a449e6e60138c745efcc37ee16f3c4bcf4db0 |
| data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv | e1a4ab1d329fb52fb8ccd9d4f15e12638d1d99a352b828a153372b69bfc1b3d6 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/functional_guilds/2026-11-03_v2/analysis_report.md | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| results/diversity/2026-11-04_v2/analysis_report.md | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| results/asv_contributions/2026-11-05_v2/analysis_report.md | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| results/candidate_asvs/2026-11-05_v2/analysis_report.md | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |
| results/operational_performance/2026-11-06_influent_v2/sample_performance_match.tsv | 637eb06f33377e2969cf915b8bb93d3f9177dbf3789b2f406edd2fb645d1f27b |
| results/operational_performance/2026-11-06_influent_v2/parameter_completeness.tsv | d28a04fc4de2022a3d39722f6a10bbf14e66e0dbcda5facdf26fb720a26604aa |
| results/operational_performance/2026-11-06_influent_v2/source_inventory.tsv | 6e4162ef13e3ca2b854a8ae224f9282e291054f983b352d6e7ad39d04799ff6b |
| results/operational_performance/2026-11-06_influent_v2/analysis_report.md | 94137c3ef87f5b16940960e0dfb2a8d251f61349dfda5244286652bc4c03ed03 |

后续不再询问已确认配方性质/适用范围；实际进出水和运行测量、采样日期/周期/窗口、相应方法和底层重复数仍需原记录，当前缺失保持NA。设计确认不能替代独立性能观测或统计前提审阅。


## 最终独立审核与修改文件清单

独立核验不混加主流程9 PASS / 2 WARNING / 1 FAIL：13项配方原值/化学式/单位、33×93 metadata旧63列/新类型标记和两个名义比值均通过；默认已有目录拒绝覆盖，临时项目复现及误标实测/范围改变/实测事实改变的阻断验证通过。189个既有科研/历史文件SHA-256不变；实验设计和日志原前缀、累计解释旧正文保留；265个本地链接/锚点有效。

新增4文件：

- `data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv`（13项正式设计源配方）。
- `results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv`（33×93新派生metadata）。
- 本`analysis_report.md`及同目录`run.log`。

更新5文件：`scripts/operational_performance_audit.py`、`docs/batch_01/experiment_design.md`、`README.md`、`docs/batch_01/results_interpretation.md`、`docs/batch_01/analysis_log.md`。未改原始metadata、旧源表、RDS或任何历史有效v2结果；未重跑上游或统计计算。

正式类型与范围已确认，无需再确认；实际水质/运行测量缺失和后续性能关联门控关闭保持。输入指纹对应运行当时，之后三文档同步不改写旧指纹。最终核验时间：2026-11-06T16:00:48.496362+08:00（Asia/Shanghai）。
