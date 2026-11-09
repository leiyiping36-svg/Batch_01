# Batch_01 模块1.1：主要微生物群落组成与演替

运行：2026-11-03 15:06:10 至 2026-11-03 15:06:23（Asia/Shanghai）。
状态：PASS；本模块检查 33 PASS / 4 WARNING / 0 FAIL。对象构建明细另见results/qc/stage1_report.md新增节。

## 输入、授权范围及已有结果复用

沿用5,510 ASV × 33样本原始count、taxonomy和代表序列；生成results/phyloseq/batch_01_phyloseq.rds。没有稀释、过滤、删除ASV或重跑Cutadapt/DADA2/分类器。8项原科研输入指纹匹配历史完整QC，深度/异常筛查沿用，不重复运行。
执行前项目results内没有组成结果或RDS；技术日志指向的历史外部目录不可访问，因此本次图均为首次可获得产物，没有声称复用不存在的图。原metadata为14列、没有group（不是直接复用六类operation_phase）；派生metadata保留原14列并附加明确的五模块映射及来源。

本次请求明确授权构建缺失对象，取代此前文档的暂缓交付范围。G4初始DO设置按本次请求为不确定；设计文档此前确认的恢复设置3保留在design_document_DO_setpoint_mg_L/design_document_DO_setting_text，分析DO字段为NA。原始metadata中的旧备注完整保留，以新增字段表达版本差异；不修改AGENTS.md或实验设计。

## 实际检查

| status | item | evidence |
|---|---|---|
| PASS | 环境依赖 | phyloseq, Biostrings, digest, ggplot2, scales |
| PASS | 模块数量 | G1/G2/G3/G4/G5=8/2/4/15/4；完整SampleID由原始metadata与明确名单核对。 |
| PASS | 主分析边界 | G1–G4=29样本；G5=4个同一母样级分，独立展示。 |
| PASS | G4分层与DO边界 | 4个初始设置不确定、11个后期设计稳定期，全部33样本采样实测DO未知。 |
| PASS | R1实际采样顺序 | A0@1 → A1@120 → A2@56 → E1@1 → E2@76 → E3@145 |
| PASS | R2实际采样顺序 | B0@1 → B1@120 → B2@21 → B3@56 → F1@1 → F2@30 → F3@76 → F4@145 |
| PASS | R3实际采样顺序 | C0@1 → C1@120 → C2@56 → G1@1 → G2@30 → G3@76 → G4@145 |
| PASS | R4实际采样顺序 | D0@1 → D1@120 → D2@21 → D3@56 → H1@1 → H2@30 → H3@76 → H4@145 |
| PASS | 排序覆盖 | 全部29主分析样本各出现一次；轮次分面，日数不跨保存/混合拼接。 |
| PASS | ASV相对丰度闭合 | 33个样本最大偏差=0；分母为全部原始reads。 |
| PASS | Phylum丰度矩阵闭合 | 51条完整谱系；每样本和最大偏差1.44e-15；未分类谱系保留。 |
| PASS | Class丰度矩阵闭合 | 114条完整谱系；每样本和最大偏差1.11e-15；未分类谱系保留。 |
| PASS | Genus丰度矩阵闭合 | 633条完整谱系；每样本和最大偏差2.22e-16；未分类谱系保留。 |
| PASS | Phylum图中比例守恒 | Top N + Others（其余已命名类群）+ Unclassified（全部未分类）=1。 |
| PASS | Class图中比例守恒 | Top N + Others（其余已命名类群）+ Unclassified（全部未分类）=1。 |
| PASS | Genus图中比例守恒 | Top N + Others（其余已命名类群）+ Unclassified（全部未分类）=1。 |
| PASS | main_composition不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | main_composition图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | R1_community_succession不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | R1_community_succession图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | R2_community_succession不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | R2_community_succession图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | R3_community_succession不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | R3_community_succession图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | R4_community_succession不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | R4_community_succession图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | G5_size_fraction_composition不覆盖 | 新版本目录，图文件尚不存在。 |
| PASS | G5_size_fraction_composition图输出 | PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。 |
| PASS | 优势属汇总覆盖 | 33个样本分别列出已命名属Top3；按反应器×模块×子阶段汇总，未知属比例单列；G5均值仅描述四级分。 |
| PASS | PhylumTSV回读核验 | 写出后的全部数值、样本顺序及闭合性通过。 |
| PASS | ClassTSV回读核验 | 写出后的全部数值、样本顺序及闭合性通过。 |
| PASS | GenusTSV回读核验 | 写出后的全部数值、样本顺序及闭合性通过。 |
| PASS | 原始输入与设计保护 | 所有输入指纹不变；AGENTS.md、研究背景、实验设计、分析计划未改写。 |
| WARNING | 重复及混杂 | G1前后、G2/G3连续运行、G4纵向及共享混合谱系均相关；DO与阶段/时间混杂，不做独立样本检验、网络或因果推断。 |
| WARNING | 不平衡与未知 | G2仅R2/R4；G4第30天缺R1；约120d及推算163d非精确日历日期；恢复时长、混合量及稳态性能证据未核验。 |
| WARNING | DO来源差异 | 初始E1/F1/原G1/H1分析DO设置NA，文档恢复阶段设置3另列；四个初始不标为稳定0.5。后期11样本按设计稳定期，实测均NA。 |
| WARNING | 16S解释边界 | 读数比例不等于细胞绝对丰度、功能基因、活性或DO因果效应；分类数据库名称按原注释保留。 |

## 方法与图表读法

每个ASV相对丰度=该样本原始count/该样本全部ASV count之和。按Phylum、Class、Genus完整祖先谱系求和，每个矩阵33列样本，前三列为taxon_id、taxon_label、is_unclassified；列顺序为R1至R4各自轮次/采样顺序，最后G5。重复属名若上级谱系不同保留并加谱系，不跨谱系静默合并。

目标阶元空值、unknown/unassigned/unidentified/unclassified/uncultured/metagenome及其常见后缀归未分类，保留原taxon_id谱系；数据库给出的其他命名（包括候选类群代码）原样保留。不使用上一级名称假充已鉴定属。矩阵保留每条未分类谱系；图中合并为Unclassified。

Top N只由29主分析样本的等样本权重平均相对丰度选取：Phylum=10、Class=10、Genus=15，分别使用固定类别和配色覆盖全部图，G5不参与Top N筛选。Others仅合并未展示的已命名类群，Unclassified独立保留；全部比例不因隐藏类群而重新归一化。优势属定义为每样本或反应器×模块×子阶段均值的已命名正丰度Top3（平局按完整谱系排序），不代表预先设定的生态功能。

dominant_genera_summary.tsv中scope=sample给出逐样本Top3，scope=reactor_phase给出按原始相对丰度逐样本等权均值的Top3，含最小/最大、记录数及进入样本Top3的次数；范围不是置信区间。G4后期均值包含不等间隔的纵向采样，既不是时间积分也不是独立重复均值。G5四组分均值仅为无权描述，不是母样重建（缺少各级分生物量/体积权重）。

| 层级 | Top N | 主分析Top N覆盖范围 | G5 Top N覆盖范围 |
|---|---|---|---|
| Phylum | 10 | 93.77–99.53% | 86.49–95.04% |
| Class | 10 | 82.07–98.65% | 76.67–89.91% |
| Genus | 15 | 48.00–95.07% | 32.82–64.47% |

未分类比例（按样本、以全部reads作分母）：

| 层级 | 未分类ASV数 | 最低样本比例 | 最高样本比例 |
|---|---|---|---|
| Phylum | 583 | 0.03% | 6.34% |
| Class | 747 | 0.07% | 6.68% |
| Genus | 1846 | 0.97% | 22.19% |

图中使用英文/ASCII标签以保证本地字体完整；PNG为160 dpi，PDF为矢量。main_composition和G5的PDF分别为门、纲、属三页，PNG为三层级纵向拼版；四张R1–R4图聚焦属水平演替。全图共享各阶元Top N配色。

## 样本映射、排序与条件

排序依据为已确认轮次先后及原metadata.phase_days，实际与逐反应器明确清单断言相符；绝不以metadata行号或字母排序当作采样时间。G1 day120保留约数。G2/G3共用同一时间轴（21→56），22d无本批样本。G4另起时间轴（1、30、76、145），day1只作初始编号，不是低DO暴露1天。混合均分及4℃59天保存/恢复在分面边界说明，柱间距相等不代表时间等距。

主总览按反应器×轮次分面，各列坐标可共享实际样本位置；空位表示未采样，不插补。四张反应器图各自仅含该反应器实际采样节点。G5按粒径S1→S4单列，不接到纵向轴上。

| sample-id | supplier_sample_id | group | reactor_label | reactor_round | phase_days | sampling_day_status | stage_subphase | DO_setting_text | particle_size_fraction_um |
|---|---|---|---|---|---|---|---|---|---|
| Batch_01_A0 | A0 | G1 | R1 | G1_original | 1 | recorded_relative_day | low_cn_startup | 5–7 mg/L | NA |
| Batch_01_A1 | A1 | G1 | R1 | G1_original | 120 | approximate_recorded | low_cn_end | 5–7 mg/L | NA |
| Batch_01_A2 | A2 | G3 | R1 | G2G3_postmix | 56 | user_confirmed_stage_end | stage_end | 3 mg/L | NA |
| Batch_01_E1 | E1 | G4 | R1 | G4G5_low_DO | 1 | recorded_relative_day | recovered_baseline_before_low_DO_switch | NA | NA |
| Batch_01_E2 | E2 | G4 | R1 | G4G5_low_DO | 76 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_E3 | E3 | G4 | R1 | G4G5_low_DO | 145 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_B0 | B0 | G1 | R2 | G1_original | 1 | recorded_relative_day | low_cn_startup | 5–7 mg/L | NA |
| Batch_01_B1 | B1 | G1 | R2 | G1_original | 120 | approximate_recorded | low_cn_end | 5–7 mg/L | NA |
| Batch_01_B2 | B2 | G2 | R2 | G2G3_postmix | 21 | user_confirmed_stage_end | stage_end | 5 mg/L | NA |
| Batch_01_B3 | B3 | G3 | R2 | G2G3_postmix | 56 | user_confirmed_stage_end | stage_end | 3 mg/L | NA |
| Batch_01_F1 | F1 | G4 | R2 | G4G5_low_DO | 1 | recorded_relative_day | recovered_baseline_before_low_DO_switch | NA | NA |
| Batch_01_F2 | F2 | G4 | R2 | G4G5_low_DO | 30 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_F3 | F3 | G4 | R2 | G4G5_low_DO | 76 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_F4 | F4 | G4 | R2 | G4G5_low_DO | 145 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_C0 | C0 | G1 | R3 | G1_original | 1 | recorded_relative_day | low_cn_startup | 5–7 mg/L | NA |
| Batch_01_C1 | C1 | G1 | R3 | G1_original | 120 | approximate_recorded | low_cn_end | 5–7 mg/L | NA |
| Batch_01_C2 | C2 | G3 | R3 | G2G3_postmix | 56 | user_confirmed_stage_end | stage_end | 3 mg/L | NA |
| Batch_01_G1 | G1 | G4 | R3 | G4G5_low_DO | 1 | recorded_relative_day | recovered_baseline_before_low_DO_switch | NA | NA |
| Batch_01_G2 | G2 | G4 | R3 | G4G5_low_DO | 30 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_G3 | G3 | G4 | R3 | G4G5_low_DO | 76 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_G4 | G4 | G4 | R3 | G4G5_low_DO | 145 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_D0 | D0 | G1 | R4 | G1_original | 1 | recorded_relative_day | low_cn_startup | 5–7 mg/L | NA |
| Batch_01_D1 | D1 | G1 | R4 | G1_original | 120 | approximate_recorded | low_cn_end | 5–7 mg/L | NA |
| Batch_01_D2 | D2 | G2 | R4 | G2G3_postmix | 21 | user_confirmed_stage_end | stage_end | 5 mg/L | NA |
| Batch_01_D3 | D3 | G3 | R4 | G2G3_postmix | 56 | user_confirmed_stage_end | stage_end | 3 mg/L | NA |
| Batch_01_H1 | H1 | G4 | R4 | G4G5_low_DO | 1 | recorded_relative_day | recovered_baseline_before_low_DO_switch | NA | NA |
| Batch_01_H2 | H2 | G4 | R4 | G4G5_low_DO | 30 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_H3 | H3 | G4 | R4 | G4G5_low_DO | 76 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_H4 | H4 | G4 | R4 | G4G5_low_DO | 145 | recorded_relative_day | design_stable_low_DO_period | 0.5±0.2 mg/L | NA |
| Batch_01_S1 | S1 | G5 | R1 | G4G5_low_DO | 163 | derived_in_original_record | same_mother_size_fractionation | 0.5±0.2 mg/L | <100 |
| Batch_01_S2 | S2 | G5 | R1 | G4G5_low_DO | 163 | derived_in_original_record | same_mother_size_fractionation | 0.5±0.2 mg/L | 100–200 |
| Batch_01_S3 | S3 | G5 | R1 | G4G5_low_DO | 163 | derived_in_original_record | same_mother_size_fractionation | 0.5±0.2 mg/L | 200–500 |
| Batch_01_S4 | S4 | G5 | R1 | G4G5_low_DO | 163 | derived_in_original_record | same_mother_size_fractionation | 0.5±0.2 mg/L | >500 |

## 每个反应器的实际优势属演替

以下每节点为已命名属中最高相对丰度者；不因某样本未分类占比更高而宣称其为总体最大类群。仅沿记录顺序描述，跨分面不连接成连续运行。

- **R1**：
  - G1_original：A0（d1）：Defluviicoccus 25.55% → A1（d约120）：Acinetobacter 23.31%。
  - G2G3_postmix：A2（d56）：Acinetobacter 43.12%。
  - G4G5_low_DO：E1（d1）：Acinetobacter 39.61% → E2（d76）：Acinetobacter 18.49% → E3（d145）：Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 28.12%。
- **R2**：
  - G1_original：B0（d1）：Defluviicoccus 26.60% → B1（d约120）：Acinetobacter 28.10%。
  - G2G3_postmix：B2（d21）：Acinetobacter 38.98% → B3（d56）：Acinetobacter 42.58%。
  - G4G5_low_DO：F1（d1）：Acinetobacter 39.23% → F2（d30）：Acinetobacter 36.38% → F3（d76）：Acinetobacter 16.56% → F4（d145）：Candidatus_Competibacter 50.35%。
- **R3**：
  - G1_original：C0（d1）：Candidatus_Competibacter 42.49% → C1（d约120）：Candidatus_Competibacter 39.59%。
  - G2G3_postmix：C2（d56）：Candidatus_Competibacter 19.11%。
  - G4G5_low_DO：G1（d1）：Aridibacter 17.60% → G2（d30）：Defluviicoccus 24.27% → G3（d76）：Defluviicoccus 24.41% → G4（d145）：Defluviicoccus 24.77%。
- **R4**：
  - G1_original：D0（d1）：Candidatus_Competibacter 34.63% → D1（d约120）：Candidatus_Competibacter 56.11%。
  - G2G3_postmix：D2（d21）：Candidatus_Competibacter 55.49% → D3（d56）：Candidatus_Competibacter 91.06%。
  - G4G5_low_DO：H1（d1）：Candidatus_Competibacter 73.45% → H2（d30）：Candidatus_Competibacter 43.59% → H3（d76）：Candidatus_Competibacter 68.99% → H4（d145）：Candidatus_Competibacter 54.16%。

## 反应器与阶段优势属汇总

| 反应器标签 | 模块/子阶段 | 采样记录数 | 已命名优势属Top3（等样本权重均值） |
|---|---|---|---|
| R1 | G1/low_cn_startup | 1 | Defluviicoccus 25.55%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Acidobacteriota;c__Blastocatellia;o__DS-100;f__Incertae_Sedis;g__Incertae_Sedis] 8.42%；Acinetobacter 6.48% |
| R1 | G1/low_cn_end | 1 | Acinetobacter 23.31%；Defluviicoccus 18.45%；Candidatus_Kapaibacterium 5.02% |
| R1 | G3/stage_end | 1 | Acinetobacter 43.12%；Defluviicoccus 19.56%；Hassallia 2.52% |
| R2 | G1/low_cn_startup | 1 | Defluviicoccus 26.60%；Acinetobacter 8.69%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Saprospiria;o__Saprospirales;f__Lewinellaceae;g__Incertae_Sedis] 5.22% |
| R2 | G1/low_cn_end | 1 | Acinetobacter 28.10%；Defluviicoccus 15.43%；Candidatus_Competibacter 10.08% |
| R2 | G2/stage_end | 1 | Acinetobacter 38.98%；Defluviicoccus 15.30%；Candidatus_Competibacter 4.43% |
| R2 | G3/stage_end | 1 | Acinetobacter 42.58%；Defluviicoccus 18.39%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Saprospiria;o__Saprospirales;f__Lewinellaceae;g__Incertae_Sedis] 2.49% |
| R3 | G1/low_cn_startup | 1 | Candidatus_Competibacter 42.49%；Phototrophicus 17.57%；Candidatus_Tepidaquicella 7.28% |
| R3 | G1/low_cn_end | 1 | Candidatus_Competibacter 39.59%；Phototrophicus 16.92%；Dechloromonas 5.04% |
| R3 | G3/stage_end | 1 | Candidatus_Competibacter 19.11%；Phototrophicus 18.53%；Acinetobacter 17.33% |
| R4 | G1/low_cn_startup | 1 | Candidatus_Competibacter 34.63%；Phototrophicus 20.09%；Candidatus_Tepidaquicella 4.58% |
| R4 | G1/low_cn_end | 1 | Candidatus_Competibacter 56.11%；Phototrophicus 15.56%；Acinetobacter 2.66% |
| R4 | G2/stage_end | 1 | Candidatus_Competibacter 55.49%；Phototrophicus 9.48%；Acinetobacter 6.99% |
| R4 | G3/stage_end | 1 | Candidatus_Competibacter 91.06%；Phototrophicus 1.93%；Defluviicoccus 0.49% |
| R1 | G4/recovered_baseline_before_low_DO_switch | 1 | Acinetobacter 39.61%；Defluviicoccus 14.38%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Saprospiria;o__Saprospirales;f__Lewinellaceae;g__Incertae_Sedis] 4.19% |
| R1 | G4/design_stable_low_DO_period | 2 | Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 18.81%；Acinetobacter 13.72%；Chryseosolibacter 9.89% |
| R2 | G4/recovered_baseline_before_low_DO_switch | 1 | Acinetobacter 39.23%；Defluviicoccus 17.40%；Candidatus_Competibacter 3.32% |
| R2 | G4/design_stable_low_DO_period | 3 | Candidatus_Competibacter 23.89%；Acinetobacter 17.73%；Defluviicoccus 15.74% |
| R3 | G4/recovered_baseline_before_low_DO_switch | 1 | Aridibacter 17.60%；Acinetobacter 13.16%；Phototrophicus 7.39% |
| R3 | G4/design_stable_low_DO_period | 3 | Defluviicoccus 24.48%；Candidatus_Competibacter 10.88%；Phototrophicus 9.44% |
| R4 | G4/recovered_baseline_before_low_DO_switch | 1 | Candidatus_Competibacter 73.45%；Phototrophicus 7.08%；Acinetobacter 2.59% |
| R4 | G4/design_stable_low_DO_period | 3 | Candidatus_Competibacter 55.58%；Phototrophicus 6.70%；Defluviicoccus 5.41% |

## 跨反应器共同优势属

共同优势属操作定义：分别求每个反应器在同一子阶段的等记录权重平均相对丰度Top3，取所有实际有样本反应器的交集。只描述本批已采样标签；G2只有R2、R4，G4后期取样不平衡且来源相关，不称跨独立重复验证。

- G1_start（实际4个反应器标签）：各反应器该阶段等权均值Top3的共同属为无。
- G1_end（实际4个反应器标签）：各反应器该阶段等权均值Top3的共同属为无。
- G2（实际2个反应器标签）：各反应器该阶段等权均值Top3的共同属为Acinetobacter、Candidatus_Competibacter。
- G3（实际4个反应器标签）：各反应器该阶段等权均值Top3的共同属为无。
- G4_baseline（实际4个反应器标签）：各反应器该阶段等权均值Top3的共同属为Acinetobacter。
- G4_post（实际4个反应器标签）：各反应器该阶段等权均值Top3的共同属为无。

## G5同一母样粒径组分

- S1（<100 μm）：Acinetobacter 30.13%；Defluviicoccus 8.86%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 7.39%。
- S2（100–200 μm）：Thauera 20.84%；Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 7.69%；OLB8 6.32%。
- S3（200–500 μm）：Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 13.03%；OLB8 9.70%；Candidatus_Competibacter 7.45%。
- S4（>500 μm）：Incertae_Sedis [d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis] 11.16%；OLB8 9.66%；Thauera 9.07%。

四级分共享同一R1母样（145d后18d，163为原表推算），每粒径仅1份记录，不能估计独立生物重复间变异。筛分边界闭开和处理细节未知；未作级分显著性检验或按四份样本加权重建母样。

## 局限与待人工核查

- 16S分类不等同功能基因、活性或绝对细胞量；报告仅针对原始扩增子读数相对组成，不乘VSS/MLVSS。
- G1配对、G2/G3连续运行及G4纵向采样不能当独立观测；R1/R2与R3/R4在G1后各自混合均分，前源相关性跨保存恢复保留。反应器、污泥设计类型、来源块、时间及DO阶段混杂，无法从本描述分离DO因果效应。
- G2缺R1/R3、G4第30天缺R1，记录数不等于独立样本量。不插补缺采样，不做显著性检验、共现网络或因果推断。
- E1/F1/原G1/H1分析使用的设置不确定，本次请求与文档恢复设置3的差异已显式保留；若后续解释依赖该值，需要人工统一来源。全部瞬时DO为NA；后期11样本按设计稳定期，运行性能是否证明稳态尚未审阅。
- 日历日期、恢复时长、约120d精确性、混合比例/接种量、母样原始编号、粒径处理细节和取样不平衡原因仍未核验。阶段DO与实测分列，未知条件未填补。
- 只分析Batch_01。既有上游产物沿用，同批测序/处理不能消除DNA提取、存放、PCR或测序批次潜在效应；没有足够实验批次信息评估这些效应，不能据此声称无批次效应。

## 复现与交付

命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla scripts/community_composition.R --output-dir NEW_DIRECTORY`；默认路径为results/community_composition/2026-11-03_v1，已存在则失败，重跑须新版本目录。
对象固定results/phyloseq/batch_01_phyloseq.rds；已有对象仅在全部内容/输入指纹一致时复用，否则FAIL且不覆盖。对象构建由stage1_pipeline.R入口执行，不重复上游QC。

工具：R version 4.5.2 (2025-10-31)；phyloseq 1.54.0；Biostrings 2.78.0；digest 0.6.39；ggplot2 4.0.3；scales 1.4.0。无随机步骤。

| 输入/脚本/对象 | SHA-256 |
|---|---|
| asv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| metadata | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| biom | 331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905 |
| table_qza | aa1a6bac46ebccce26827d71433d85b09b01254ea694eb53c86fd7c7344ba1ce |
| sequences_qza | 9266608e6381cdffa1bf582d798902cd6121c4b04c1e0b8d3c353fac8880d20e |
| taxonomy_qza | 76e0fe74f88e1448804dd6565551650e5fa0b62fd4393d72bc85c6c5e1621604 |
| design | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| plan | 0d4d7f9b3b3f1d8a9fc604cff29f7724c3dd4f248cc3470ea81511516ffa734f |
| community_script | 86f9b5989ec062109b417f4f56cc6f042fee285d200f4af378ca2287364880a4 |
| stage1_script | a5ea632129420ce85dae9b21793ea576108af329b4e935f023f3c27b25d08489 |
| phyloseq | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |

输入路径按stage1综合报告记录；metadata与设计版本见analysis_metadata.tsv。运行总耗时13.047秒。

文件：

- `analysis_metadata.tsv`
- `analysis_report.md`
- `class_relative_abundance.tsv`
- `dominant_genera_summary.tsv`
- `G5_size_fraction_composition.pdf`
- `G5_size_fraction_composition.png`
- `genus_relative_abundance.tsv`
- `main_composition.pdf`
- `main_composition.png`
- `phylum_relative_abundance.tsv`
- `R1_community_succession.pdf`
- `R1_community_succession.png`
- `R2_community_succession.pdf`
- `R2_community_succession.png`
- `R3_community_succession.pdf`
- `R3_community_succession.png`
- `R4_community_succession.pdf`
- `R4_community_succession.png`
- `run.log`

```text
R version 4.5.2 (2025-10-31)
Platform: x86_64-conda-linux-gnu
Running under: Ubuntu 26.04.1 LTS

Matrix products: default
BLAS/LAPACK: /home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/libopenblasp-r0.3.33.so;  LAPACK version 3.12.0

locale:
 [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
 [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
 [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
[10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

time zone: Asia/Shanghai
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_4.0.3

loaded via a namespace (and not attached):
 [1] generics_0.1.4      stringi_1.8.7       lattice_0.22-9     
 [4] digest_0.6.39       magrittr_2.0.5      grid_4.5.2         
 [7] RColorBrewer_1.1-3  iterators_1.0.14    foreach_1.5.2      
[10] plyr_1.8.9          jsonlite_2.0.0      Matrix_1.7-5       
[13] ape_5.8-1           survival_3.8-9      mgcv_1.9-4         
[16] scales_1.4.0        permute_0.9-10      Biostrings_2.78.0  
[19] codetools_0.2-20    ade4_1.7-24         cli_3.6.6          
[22] rlang_1.3.0         crayon_1.5.3        XVector_0.50.0     
[25] Biobase_2.70.0      splines_4.5.2       withr_3.0.3        
[28] vegan_2.7-3         tools_4.5.2         parallel_4.5.2     
[31] reshape2_1.4.5      phyloseq_1.54.0     dplyr_1.2.1        
[34] Rhdf5lib_1.32.0     multtest_2.66.0     BiocGenerics_0.56.0
[37] vctrs_0.7.3         R6_2.6.1            stats4_4.5.2       
[40] lifecycle_1.0.5     rhdf5_2.54.1        Seqinfo_1.0.0      
[43] stringr_1.6.0       biomformat_1.38.0   S4Vectors_0.48.0   
[46] IRanges_2.44.0      MASS_7.3-66         cluster_2.1.8.2    
[49] pkgconfig_2.0.3     pillar_1.11.1       gtable_0.3.6       
[52] glue_1.8.1          data.table_1.18.4   Rcpp_1.1.2         
[55] tibble_3.3.1        tidyselect_1.2.1    rhdf5filters_1.22.0
[58] farver_2.1.2        igraph_2.3.3        nlme_3.1-170       
[61] labeling_0.4.3      compiler_4.5.2      S7_0.2.2           
```


## 后续复核：v1已被替代

2026-11-03图像复核发现图例过长裁切、浮点累加边界导致部分柱顶段被绘图刻度删除；Incertae_Sedis分类位置未定标记需要归未分类。v1图和优势属解释不作为最终交付；修正版见../2026-11-03_v2/analysis_report.md。历史计算与文件保留，原始输入不变。
