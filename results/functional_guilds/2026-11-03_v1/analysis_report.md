# Batch_01 模块1.2：传统功能相关类群识别与相对丰度

运行时间：2026-11-03 19:30:28–2026-11-03 19:30:40（Asia/Shanghai）。
状态：PASS（描述性、文献关联层面）；49 PASS / 6 WARNING / 0 FAIL。

## 数据与证据含义

复用模块1.1有效v2的原始count phyloseq及33行派生metadata；5,510 ASV全部保留，G1–G5为8/2/4/15/4。主29行与G5四级分分开解释，样本顺序直接来自v2矩阵表头，并逐反应器断言确认。没有重跑QC、DADA2、SILVA、对象构建、筛选、稀释或功能预测工具。

本报告的“功能相关”是文献中参考类群与功能的关联，所有项目ASV只有16S分类证据。即使literature_strength为strong，也不能称本项目ASV已测得功能、功能基因拷贝数或活性；taxonomy_classifier_confidence只是分类器置信度，不能当功能可信度。没有qPCR、功能基因测量或绝对丰度。

## 规则、证据分级与互斥性

1. literature_supported_related_taxon：仅预定义的Nitrosomonas(AOB)、Nitrobacter(NOB)、精确Brocadia(AnAOB)、Accumulibacter(PAO)、Competibacter/Contendibacter/Defluviicoccus(GAO)可进入对应保守关联代理。这个小面板故意不等于所有功能成员。
2. genus_level_candidate_only：参考种/菌株或基因组有相关证据，但不能外推整个属，单列候选，不计保守汇总。
3. taxonomic_information_insufficient：缺失/未定属标签、Incertae_Sedis及--other等分类不足；Brocadia--other保留为AnAOB分类受限候选，不强改为Brocadia。
4. functional_ambiguity：Nitrospira(NOB/comammox)、Dechloromonas/Acinetobacter(PAO相关主张有属内/生理歧义)、Amaricoccus(GAO历史主张)独立记录。
5. unverified_pending_research及named_taxon_function_not_assigned：目标功能未核实或不在本面板；保留待研究，不能解释为无功能。

每个ASV只有一条annotation和一个exclusive_partition。proposed_guild可记录歧义/候选文字，不能据此把同一ASV重复加进互斥功能组。Contendibacter/Contendobacter别名由[NCBI分类记录](https://ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?command=show&id=1400859&lvl=3&mode=node)核实，依据原研究GAO谱系证据归入关联代理；不会按Defluviimonas或Nitrosymbiomonas名称相似性推断功能。

文献核实方式：2026-11-03通过在线检索读取原研究摘要、出版信息或索引的原研究正文片段，核对题名、DOI及支撑论点。不是全文系统综述；PMC验证码、出版社403/重定向导致部分全文未取得，不声称通读全文。Acinetobacter明确为摘要核实/全文受限；CCM19a未核实直接原研究，reference为NA；Nitrosymbiomonas仅核实书目信息/分类来源，目标功能不予赋值。每条规则的来源、核实层级及理由均在functional_mapping_evidence.tsv。

## 实际检查

| status | item | evidence |
|---|---|---|
| PASS | 环境 | 复用现有R环境，不安装软件或更新注释。 |
| PASS | 输入存在 | results/phyloseq/batch_01_phyloseq.rds; data/asv_table.tsv; data/taxonomy.tsv; metadata/source_sample_metadata.tsv; results/community_composition/2026-11-03_v2/analysis_metadata.tsv; results/community_composition/2026-11-03_v2/analysis_report.md; results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv; docs/batch_01/experiment_design.md; docs/batch_01/analysis_plan.md; AGENTS.md; docs/research_context.md |
| PASS | 原始count对象复用 | 5510 ASV × 33样本；原ASV与taxonomy指纹和对象来源一致，无需重跑测序QC或阶段1构建。 |
| PASS | 本模块输入计算断言 | 原始非负整数、无空样本；只检查本次计算必需条件，不重复深度异常筛查。 |
| PASS | ASV与原taxonomy一致 | 使用原Taxon及Confidence，不重新分类、不改变注释或筛除ASV。 |
| PASS | 样本身份 | 完整SampleID与原始metadata/对象逐行匹配，不拼造前缀。 |
| PASS | metadata原值及对象一致 | 原14列全部值保留；模块1.1派生表与RDS一致，G4基线分析DO NA/文档3分列沿用。 |
| PASS | 五模块数量 | G1/G2/G3/G4/G5=8/2/4/15/4；主29样本，G5四级分。 |
| PASS | 模块1.1排序复用 | 直接读取有效v2矩阵表头，沿用其33样本已确认顺序。 |
| PASS | R1排序与轮次 | A0 → A1 → A2 → E1 → E2 → E3 |
| PASS | R2排序与轮次 | B0 → B1 → B2 → B3 → F1 → F2 → F3 → F4 |
| PASS | R3排序与轮次 | C0 → C1 → C2 → G1 → G2 → G3 → G4 |
| PASS | R4排序与轮次 | D0 → D1 → D2 → D3 → H1 → H2 → H3 → H4 |
| PASS | DO与实验层级 | 保留4初始基线和11后期设计稳定期；全部实测NA，未按组整体填DO。 |
| PASS | 规则无重叠 | 明确列出的属别名只对应一个规则；不做子字符串/模糊匹配，不删除--other。 |
| PASS | ASV互斥分配 | 5510 ASV各一行、一个汇总类别；候选功能为注释文字，不另累计到互斥组。 |
| PASS | 保守汇总证据门控 | 只累计预定义强文献关联属标记；所有ASV仍仅有16S间接证据。 |
| PASS | 关键歧义不泄漏 | Nitrospira不计AOB/NOB；Acinetobacter/Dechloromonas不计PAO；--other不自动转为已鉴定功能属。 |
| PASS | 已核实别名与相似名区分 | Contendibacter别名有NCBI记录；Defluviimonas不误配Defluviicoccus。 |
| PASS | 全reads守恒 | 功能相关/候选/歧义/未分类/未映射的互斥分区之和=全部原始reads；未对功能子集重新归一化。 |
| PASS | 属级相对丰度 | 保留所有原始属标签及未分类行，分母始终为每样本全部ASV reads。 |
| PASS | Batch_01 / functional-associated composition / 33 samples图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | all_samples_functional_composition不覆盖 | 新目录首次生成图。 |
| PASS | all_samples_functional_composition输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | R1 / functional-associated succession图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | R1_functional_succession不覆盖 | 新目录首次生成图。 |
| PASS | R1_functional_succession输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | R2 / functional-associated succession图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | R2_functional_succession不覆盖 | 新目录首次生成图。 |
| PASS | R2_functional_succession输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | R3 / functional-associated succession图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | R3_functional_succession不覆盖 | 新目录首次生成图。 |
| PASS | R3_functional_succession输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | R4 / functional-associated succession图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | R4_functional_succession不覆盖 | 新目录首次生成图。 |
| PASS | R4_functional_succession输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | G5分级层级 | S1–S4按粒径排序，共用一个母样事件，不称为技术或独立生物重复。 |
| PASS | G5_functional_composition不覆盖 | 新目录首次生成图。 |
| PASS | G5 / functional-associated size fractions图层 | 全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。 |
| PASS | G5_functional_composition输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | G4逐属趋势覆盖 | 13个已检出的已审阅属标签×15条G4记录；含4基线和11后期。 |
| PASS | G4_functional_taxa_trends不覆盖 | 新目录首次生成图。 |
| PASS | G4_functional_taxa_trends输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | PAO/GAO对照覆盖 | 33样本×2个保守关联代理；零值保留，不计算可能误导的竞争或性能指标。 |
| PASS | PAO_GAO_descriptive_comparison不覆盖 | 新目录首次生成图。 |
| PASS | PAO_GAO_descriptive_comparison输出 | 矢量PDF和160dpi PNG均生成。 |
| PASS | functional_guild_abundance.tsv回读 | 全部样本列数值与内存计算一致，并保持全部reads分母。 |
| PASS | functional_taxa_abundance.tsv回读 | 全部样本列数值与内存计算一致，并保持全部reads分母。 |
| PASS | 历史数据与结果保护 | 55个原输入、既有结果与设计文件SHA-256不变；原RDS及模块1.1 v1/v2未改写。 |
| WARNING | 功能推断边界 | 强文献支持的是参考类群关联，不是本项目ASV功能确证、功能基因测定或代谢活性；16S拷贝数/扩增偏倚未校正。 |
| WARNING | NOB与AnAOB零值边界 | 保守面板无匹配ASV时为0，仅表示该显式面板未检出；Nitrospira/--other候选另列，不能称NOB或AnAOB不存在。 |
| WARNING | 未核实文献与分类 | CCM19a直接原研究功能证据未核实；Nitrosymbiomonas目标功能未核实；--other语义未确认。不强制分配功能或删除后缀。 |
| WARNING | 来源/时间与样本量 | 主29行含前后/纵向记录及共享混合来源；G2两节点、G4缺R1-30d、G5单母样四级分；不独立，不作显著性、网络或因果分析。 |
| WARNING | DO及稳态 | 初始4样本DO设置分析NA/文档恢复3的差异沿用，全部实测DO未知；后11样本按设计稳定期，性能稳态未核验。 |
| WARNING | 文献检索覆盖 | 人工目标面板并非全功能注释或穷尽文献；若未映射不等于无功能。部分出版社/PMC全文访问受限，逐规则记录实际核实层级。 |

## 映射面板与实际命中

| rule_id | match_aliases | proposed_guild | exclusive_partition | n_matched_asvs | evidence_verified |
|---|---|---|---|---|---|
| R01 | Nitrosomonas | AOB | AOB_supported | 21 | primary_abstract_or_indexed_primary_text_verified |
| R02 | Nitrobacter | NOB | NOB_supported | 0 | primary_abstract_or_indexed_primary_text_verified |
| R03 | Nitrospira | NOB_or_comammox | Nitrospira_ambiguous | 18 | primary_abstract_or_indexed_primary_text_verified |
| R04 | Brocadia;Candidatus_Brocadia | AnAOB | AnAOB_supported | 0 | primary_abstract_or_indexed_primary_text_verified |
| R05 | Candidatus_Brocadia--other;Brocadia--other | AnAOB_candidate | AnAOB_taxonomy_candidate | 3 | primary_abstract_or_indexed_primary_text_verified |
| R06 | Accumulibacter;Candidatus_Accumulibacter | PAO | PAO_supported | 28 | primary_abstract_or_indexed_primary_text_verified |
| R07 | Tetrasphaera | PAO_candidate | PAO_genus_candidate | 0 | primary_abstract_or_indexed_primary_text_verified |
| R08 | Competibacter;Candidatus_Competibacter | GAO | GAO_supported | 217 | primary_abstract_or_indexed_primary_text_verified |
| R09 | Contendibacter;Candidatus_Contendibacter;Contendobacter;Candidatus_Contendobacter | GAO | GAO_supported | 4 | primary_abstract_or_indexed_primary_text_verified |
| R10 | Defluviicoccus | GAO | GAO_supported | 156 | primary_abstract_or_indexed_primary_text_verified |
| R11 | Propionivibrio;Candidatus_Propionivibrio;Propionivibrio--other;Candidatus_Propionivibrio--other | GAO_candidate | GAO_genus_candidate | 1 | primary_abstract_or_indexed_primary_text_verified |
| R12 | Dechloromonas;Candidatus_Dechloromonas | PAO_or_other | PAO_ambiguous | 4 | primary_abstract_or_indexed_primary_text_verified |
| R13 | Acinetobacter | PAO_historical_claim_unresolved | PAO_ambiguous | 171 | primary_abstract_verified_full_text_access_blocked |
| R14 | Obscuribacter;Candidatus_Obscuribacter | PAO_candidate | PAO_genus_candidate | 4 | primary_abstract_or_indexed_primary_text_verified |
| R15 | Thauera | PAO_candidate | PAO_genus_candidate | 7 | primary_abstract_or_indexed_primary_text_verified |
| R16 | Amaricoccus | GAO_historical_claim_unresolved | GAO_ambiguous | 1 | primary_abstract_or_indexed_primary_text_verified |
| R17 | Nitrosymbiomonas;Candidatus_Nitrosymbiomonas | NA | Evidence_unverified | 1 | bibliography_verified_target_guild_evidence_not_verified |
| R18 | CCM19a | NA | Evidence_unverified | 5 | unverified_no_primary_reference_assigned |

## 丰度定义与全reads分母

每个功能相关属或互斥证据分区的丰度 = 该样本所含ASV原始reads之和 / 该样本全部ASV reads之和。未按已映射功能子集重新归一化。functional_guild_abundance.tsv的14个互斥分区（含未分类/未映射）之和≈1；五个保守功能关联代理的和通常小于1。functional_taxa_abundance.tsv保留所有原始属标签及其规则/证据/分区；属标签相同的ASV在此求和，完整谱系仍在ASV注释中，未改写原taxonomy。

所有TSV比例均为0–1；报告及图中乘100显示百分比。保守NOB或AnAOB为0时，只表示该显式精确属面板没有匹配，不能称相应功能菌或过程不存在；Nitrospira与Brocadia--other均在独立行。未命中某参考属也不证明完全未检出该功能。

## 功能关联、歧义及未知比例

| 类别 | ASV数 | 主29样本等记录均值 | 样本范围 |
|---|---|---|---|
| AOB_supported | 21 | 0.4220% | 0.0000–2.8183% |
| NOB_supported | 0 | 0.0000% | 0.0000–0.0000% |
| AnAOB_supported | 0 | 0.0000% | 0.0000–0.0000% |
| PAO_supported | 28 | 0.1861% | 0.0000–1.8990% |
| GAO_supported | 377 | 36.9059% | 5.5715–91.5505% |
| Nitrospira_ambiguous | 18 | 0.6760% | 0.0000–4.6001% |
| AnAOB_taxonomy_candidate | 3 | 0.0010% | 0.0000–1.2243% |
| PAO_genus_candidate | 11 | 0.0068% | 0.0000–20.8664% |
| GAO_genus_candidate | 1 | 0.0003% | 0.0000–0.0100% |
| PAO_ambiguous | 175 | 14.7868% | 0.1501–43.1215% |
| GAO_ambiguous | 1 | 0.0069% | 0.0000–0.0449% |
| Evidence_unverified | 6 | 0.1369% | 0.0000–0.8007% |
| Taxonomy_insufficient | 3051 | 18.3251% | 2.5125–45.6836% |
| Unmapped_named_taxa | 1818 | 28.5462% | 5.6566–54.9923% |

主29样本均值对记录等权，受反应器/时间不平衡影响；不是等反应器均值、时间积分或独立重复总体估计。范围只是本批样本最小/最大值，不是置信区间。

## 单个已审阅属标签

| genus_label | n_asvs | rule_id | evidence_category | exclusive_partition | 主29均值 | 全33最高 |
|---|---|---|---|---|---|---|
| Acinetobacter | 171 | R13 | functional_ambiguity | PAO_ambiguous | 14.0867% | A2 43.1215% |
| Amaricoccus | 1 | R16 | functional_ambiguity | GAO_ambiguous | 0.0069% | E1 0.0449% |
| Candidatus_Accumulibacter | 28 | R06 | literature_supported_related_taxon | PAO_supported | 0.1861% | S4 1.8990% |
| Candidatus_Brocadia--other | 3 | R05 | taxonomic_information_insufficient | AnAOB_taxonomy_candidate | 0.0010% | S4 1.2243% |
| Candidatus_Competibacter | 217 | R08 | literature_supported_related_taxon | GAO_supported | 24.6450% | D3 91.0633% |
| Candidatus_Contendibacter | 4 | R09 | literature_supported_related_taxon | GAO_supported | 0.1558% | D0 2.2698% |
| Candidatus_Nitrosymbiomonas | 1 | R17 | unverified_pending_research | Evidence_unverified | 0.0002% | S3 0.0075% |
| Candidatus_Obscuribacter | 4 | R14 | genus_level_candidate_only | PAO_genus_candidate | 0.0000% | S4 0.1832% |
| CCM19a | 5 | R18 | unverified_pending_research | Evidence_unverified | 0.1367% | A0 0.8007% |
| Dechloromonas | 4 | R12 | functional_ambiguity | PAO_ambiguous | 0.7000% | C1 5.0398% |
| Defluviicoccus | 156 | R10 | literature_supported_related_taxon | GAO_supported | 12.1051% | B0 26.6001% |
| Nitrosomonas | 21 | R01 | literature_supported_related_taxon | AOB_supported | 0.4220% | S1 2.8183% |
| Nitrospira | 18 | R03 | functional_ambiguity | Nitrospira_ambiguous | 0.6760% | D2 4.6001% |
| Propionivibrio--other | 1 | R11 | genus_level_candidate_only | GAO_genus_candidate | 0.0003% | H2 0.0100% |
| Thauera | 7 | R15 | genus_level_candidate_only | PAO_genus_candidate | 0.0068% | S2 20.8413% |

## 各反应器G4实际轨迹

下表同时保留初始基线和后期节点；全部比例用相同分母，未做检验。

| 反应器 | 实际样本顺序 | 功能关联代理/歧义类别比例（与样本顺序对应） |
|---|---|---|
| R1 | E1 → E2 → E3 | PAO_supported: 0.0000% → 0.0000% → 0.0000%；GAO_supported: 14.5810% → 11.0194% → 11.3049%；AOB_supported: 0.5534% → 2.6005% → 1.3740%；Nitrospira_ambiguous: 0.2909% → 0.0315% → 0.0000%；AnAOB_taxonomy_candidate: 0.0000% → 0.0000% → 0.0190% |
| R2 | F1 → F2 → F3 → F4 | PAO_supported: 0.1431% → 0.0881% → 0.1166% → 0.1268%；GAO_supported: 20.7172% → 26.5737% → 29.8813% → 62.4818%；AOB_supported: 0.3497% → 1.2046% → 2.6881% → 2.2189%；Nitrospira_ambiguous: 0.0413% → 0.8666% → 0.0443% → 0.7037%；AnAOB_taxonomy_candidate: 0.0000% → 0.0000% → 0.0000% → 0.0000% |
| R3 | G1 → G2 → G3 → G4 | PAO_supported: 0.0304% → 0.1165% → 0.0385% → 0.0000%；GAO_supported: 7.9751% → 38.5635% → 32.4816% → 35.0967%；AOB_supported: 0.0304% → 0.0220% → 0.1186% → 0.1820%；Nitrospira_ambiguous: 0.8984% → 0.9519% → 0.4387% → 0.1163%；AnAOB_taxonomy_candidate: 0.0000% → 0.0000% → 0.0000% → 0.0113% |
| R4 | H1 → H2 → H3 → H4 | PAO_supported: 0.0528% → 0.0325% → 0.0000% → 0.0000%；GAO_supported: 74.9139% → 50.4670% → 71.5411% → 60.9643%；AOB_supported: 0.0000% → 0.0000% → 0.0116% → 0.0520%；Nitrospira_ambiguous: 0.1658% → 0.0150% → 0.0697% → 0.8054%；AnAOB_taxonomy_candidate: 0.0000% → 0.0000% → 0.0000% → 0.0000% |

- R1的G4 GAO关联保守代理：E1 14.58% → E2 11.02% → E3 11.30%。
- R2的G4 GAO关联保守代理：F1 20.72% → F2 26.57% → F3 29.88% → F4 62.48%。
- R3的G4 GAO关联保守代理：G1 7.98% → G2 38.56% → G3 32.48% → G4 35.10%。
- R4的G4 GAO关联保守代理：H1 74.91% → H2 50.47% → H3 71.54% → H4 60.96%。

## G5单一母样粒径组分

| 级分 | 粒径um | PAO_supported | GAO_supported | AOB_supported | Nitrospira_ambiguous | AnAOB_taxonomy_candidate |
|---|---|---|---|---|---|---|
| S1 | <100 | 0.0000% | 14.1682% | 2.8183% | 0.0070% | 0.0278% |
| S2 | 100–200 | 0.5158% | 5.5715% | 1.9652% | 3.0403% | 0.1529% |
| S3 | 200–500 | 0.8564% | 12.3628% | 0.9012% | 1.0655% | 0.3809% |
| S4 | >500 | 1.8990% | 9.1711% | 0.1854% | 0.3932% | 1.2243% |

G5四组分不作为四份独立生物重复；筛分边界和处理细节未知，不加权重建母样、不做粒径差异显著性检验。

## 图表与解释限制

- all_samples_functional_composition：33样本全reads互斥证据分区堆叠，按启动、混合后、保存恢复后、G5分面；G5仅为粒径顺序。
- R1–R4_functional_succession：各自实际采样顺序，轮次间分面；约120d保留近似属性，不跨混合或4℃59天保存/恢复拼接统一日数。
- G4_functional_taxa_trends：所有已检出的、已审阅功能相关/候选/歧义属分别展示；面板纵轴独立，灰区为初始/调试间隔，1d为切换前基线，30/76/145d属设计稳定运行期。线仅连接实际取样点，不意味着未采样日有观测或已验证连续趋势；R1缺30d。
- G5_functional_composition：同一母样四个粒径组分，独立展示，非时间序列。
- PAO_GAO_descriptive_comparison：保守PAO关联代理与GAO关联代理分面描述，纵轴独立；不计算PAO:GAO比值、竞争系数或显著性，不把GAO较高等同除磷失败。Acinetobacter/Dechloromonas不计PAO保守值，候选见逐属图。
- 每图PDF为矢量，PNG为160dpi；图内使用ASCII/英文以保证字体完整，绘图比例视窗不删除浮点累加略超1的顶段。

## 科学边界与待验证问题

- 读数比例不同只说明本批16S分类组成不同；本项目未测功能基因、细胞内poly-P/糖原、qPCR或类群特异活性。不能从PAO/GAO代理推断真实磷摄取、碳竞争、氨/亚硝酸盐转化或代谢速率。
- 属内种/菌株多样性、16S片段分辨率、拷贝数和提取/扩增偏倚限制功能外推。Nitrospira须功能基因/基因组等证据区分NOB与comammox；AnAOB候选也需进一步验证。
- 主29记录存在前后/纵向相关、两个混合来源块与反应器/时间/设置混杂，不作为独立重复。G2/G3 DO与时间共同变化；G4保存恢复不能视为前轮连续运行。
- 保留G4四基线分析DO NA与文档历史恢复设置3的差异；后期11行设置0.5±0.2仅为阶段设置，所有瞬时DO未知，运行性能稳态证据未审阅。不编造DO相关趋势或效应。
- 单批次不能排除提取/PCR/测序批次效应，缺少恢复时长、接种量、母样编号及运行性能等证据；不做差异显著性、网络或因果推断。
- 未来假设可以是不同来源/运行经历伴随功能相关类群的组成差别；本次描述不足以验证适应机制、真实代谢贡献或过程性能。

## 文献来源（原研究为主；并非本项目测量）

- Chain et al. 2003. [Complete genome sequence of the ammonia-oxidizing bacterium and obligate chemolithoautotroph Nitrosomonas europaea](https://pubmed.ncbi.nlm.nih.gov/12700255/). DOI: 10.1128/JB.185.9.2759-2773.2003.
- Starkenburg et al. 2006. [Genome sequence of the chemolithoautotrophic nitrite-oxidizing bacterium Nitrobacter winogradskyi Nb-255](https://pubmed.ncbi.nlm.nih.gov/16517654/). DOI: 10.1128/AEM.72.3.2050-2063.2006.
- Daims et al. 2015. [Complete nitrification by Nitrospira bacteria](https://doi.org/10.1038/nature16461). DOI: 10.1038/nature16461.
- Strous et al. 1999. [Missing lithotroph identified as new planctomycete](https://pubmed.ncbi.nlm.nih.gov/10440372/). DOI: 10.1038/22749.
- Hesselmann et al. 1999. [Enrichment, phylogenetic analysis and detection of a bacterium that performs enhanced biological phosphate removal in activated sludge](https://pubmed.ncbi.nlm.nih.gov/10553298/). DOI: 10.1016/S0723-2020(99)80055-1.
- Kristiansen et al. 2013. [A metabolic model for members of the genus Tetrasphaera involved in enhanced biological phosphorus removal](https://pubmed.ncbi.nlm.nih.gov/23178666/). DOI: 10.1038/ismej.2012.136.
- McIlroy et al. 2014 (online 2013). [Candidatus Competibacter-lineage genomes retrieved from metagenomes reveal functional metabolic diversity](https://vbn.aau.dk/en/publications/candidatus-competibacter-lineage-genomes-retrieved-from-metagenom/). DOI: 10.1038/ismej.2013.162.
- Burow et al. 2007. [Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes](https://pubmed.ncbi.nlm.nih.gov/17185546/). DOI: 10.1099/mic.0.2006/001032-0.
- Albertsen et al. 2016. [Candidatus Propionivibrio aalborgensis: A Novel Glycogen Accumulating Organism Abundant in Full-Scale Enhanced Biological Phosphorus Removal Plants](https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2016.01033/full). DOI: 10.3389/fmicb.2016.01033.
- Petriglieri et al. 2021. [Candidatus Dechloromonas phosphoritropha and Ca. D. phosphorivorans, novel polyphosphate accumulating organisms abundant in wastewater treatment systems](https://pmc.ncbi.nlm.nih.gov/articles/PMC8630035/). DOI: 10.1038/s41396-021-01029-2.
- Tandoi et al. 1998. [The behaviour of polyphosphate accumulating acinetobacter isolates in an anaerobic-aerobic chemostat](https://www.sciencedirect.com/science/article/pii/S0043135498000797). DOI: 10.1016/S0043-1354(98)00079-7.
- Soo et al. 2014. [An Expanded Genomic Representation of the Phylum Cyanobacteria](https://doi.org/10.1093/gbe/evu073). DOI: 10.1093/gbe/evu073.
- Wang and He 2020. [Complete nitrogen removal via simultaneous nitrification and denitrification by a novel phosphate accumulating Thauera sp. strain SND5](https://pubmed.ncbi.nlm.nih.gov/32823196/). DOI: 10.1016/j.watres.2020.116300.
- Falvo et al. 2001. [Synthesis of intracellular storage polymers by Amaricoccus kaplicensis, a tetrad forming bacterium present in activated sludge](https://pubmed.ncbi.nlm.nih.gov/11473594/). DOI: 10.1046/j.1365-2672.2001.01384.x.
- Okubo et al. 2021. [The physiological potential of anammox bacteria as revealed by their core genome structure](https://pubmed.ncbi.nlm.nih.gov/33367889/). DOI: 10.1093/dnares/dsaa028.

## 复现与交付

命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla scripts/functional_guilds.R --output-dir NEW_VERSION_DIRECTORY`。默认results/functional_guilds/2026-11-03_v1，已存在即非零退出，不覆盖。规则与书目信息内置于同一脚本，可离线复现本次已审阅快照；后续文献变化需另建版本。
工具：R version 4.5.2 (2025-10-31)；phyloseq 1.54.0；digest 0.6.39；ggplot2 4.0.3；scales 1.4.0；无随机步骤。

| 输入 | SHA256 |
|---|---|
| results/phyloseq/batch_01_phyloseq.rds | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| data/asv_table.tsv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/community_composition/2026-11-03_v2/analysis_metadata.tsv | f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv | 4f1477feb2bdd702c0b72a44154069bfaa65f82dd84eff4e2ea78221ea19a0ad |
| docs/batch_01/experiment_design.md | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| docs/batch_01/analysis_plan.md | 0d4d7f9b3b3f1d8a9fc604cff29f7724c3dd4f248cc3470ea81511516ffa734f |
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |

脚本SHA-256：2bcfebb7d46720515b107d6a6e2b8d00bb5293166fabde373684e83c88fd4110。原始输入、原metadata、既有RDS、模块1.1及AGENTS/设计/计划均不改写；本模块不新增metadata副本或RDS。

文件：

- `all_samples_functional_composition.pdf`
- `all_samples_functional_composition.png`
- `analysis_report.md`
- `functional_asv_annotation.tsv`
- `functional_guild_abundance.tsv`
- `functional_mapping_evidence.tsv`
- `functional_taxa_abundance.tsv`
- `G4_functional_taxa_trends.pdf`
- `G4_functional_taxa_trends.png`
- `G5_functional_composition.pdf`
- `G5_functional_composition.png`
- `PAO_GAO_descriptive_comparison.pdf`
- `PAO_GAO_descriptive_comparison.png`
- `R1_functional_succession.pdf`
- `R1_functional_succession.png`
- `R2_functional_succession.pdf`
- `R2_functional_succession.png`
- `R3_functional_succession.pdf`
- `R3_functional_succession.png`
- `R4_functional_succession.pdf`
- `R4_functional_succession.png`
- `run.log`

用时：12.461秒。

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



## 2026-11-03 模块1.2：主要观察与交付复核

**直接观察。** 本次保守关联面板命中426个ASV：Nitrosomonas 21个、Accumulibacter 28个，以及GAO关联的Competibacter 217个、Defluviicoccus 156个、Contendibacter 4个。主29样本等记录均值分别为AOB关联0.4220%、PAO关联0.1861%、GAO关联36.9059%。Nitrospira的18个ASV单列，主29均值0.6760%、最高D2 4.6001%；Brocadia--other的3个ASV为分类受限AnAOB候选，最高S4 1.2243%。这是所选16S标记的丰度，不是功能过程总量。

**反应器差异。** G4中R1的GAO关联代理为14.58%→11.02%→11.30%，R2为20.72%→26.57%→29.88%→62.48%；R3为7.98%→38.56%→32.48%→35.10%，R4为74.91%→50.47%→71.54%→60.96%。R1/R2的Nitrosomonas在76d分别2.6005%/2.6881%，同日R3/R4分别0.1186%/0.0116%。仅描述这些取样记录，不能称显著差异、DO效应或类群活性差异。

**G5观察。** 同母样S1–S4的Accumulibacter为0%、0.5158%、0.8564%、1.8990%，Nitrosomonas为2.8183%、1.9652%、0.9012%、0.1854%；Brocadia--other为0.0278%、0.1529%、0.3809%、1.2243%。这些相对组成差异不能解释成粒径导致的功能或活性变化，四级分也不提供跨母样重复证据。S2的Thauera虽为20.8413%，仍只列属水平PAO候选；不因其丰度较高就并入确定PAO。

**解释边界。** 保守NOB和AnAOB面板均为0，是精确属标记未匹配，不是相关功能不存在；Nitrospira和Brocadia受限标签已另列。Dechloromonas 4个、Acinetobacter 171个ASV均未计PAO核心。CCM19a 5个ASV与Nitrosymbiomonas 1个ASV保持文献/目标功能未核实，不强配；本次没有测到功能基因、qPCR或代谢活性。GAO关联读数较高也不能证明除磷失败。

**交付复核（主流程49 PASS/6 WARNING/0 FAIL之外另列）。**

- PASS：独立Python从原始ASV count重算全部功能分区及378个原始属标签，两个丰度表与独立结果最大偏差4.996×10^-16；各样本全分区和≈1。5510个ASV的原始taxonomy与分类置信度逐项保持，18规则无别名重叠，关键歧义排除及每规则ASV数一致。
- PASS：原始数据、原metadata、RDS、模块1.1 v1/v2、AGENTS.md及实验设计等55个保护文件指纹不变；分析日志旧字节前缀保留。README和累计解释的当前状态已更新至模块1.2，并保留已有详细结果与历史日志。
- PASS：全部8个PNG通过CRC与像素流解压检查，8个PDF文件头及结束标记完整；R2演替、G4逐属趋势、G5组成图已实际打开检查，图例与分面可读、柱高完整。G4全零Obscuribacter面板的自动坐标包含负刻度，数据点实际均为0；没有负丰度，不作变化解释。
- PASS：已有输出目录再次执行返回非零，22个结果文件逐字节未改；README和累计解释本地文件链接可解析。没有重复生成新版本或新图。

结果目录：results/functional_guilds/2026-11-03_v1，共4个TSV、8组PDF/PNG、analysis_report.md和run.log。独立复核未重跑上游QC或分类器。主要结果属于文献关联的描述性证据，后续功能测量、性能/DO关联及推断统计仍未开展。


<a id="community-v2-analysis-baseline"></a>

## 2026-11-03 用户确认：后续分析以群落组成v2为基础

- 当前有效的模块1.1基线为 `results/community_composition/2026-11-03_v2/`。群落组成 `2026-11-03_v1/` 仅保留历史与追溯，不用于后续分析输入或当前科研结论。
- 模块1.2已经使用群落v2：派生metadata、采样顺序和组成解释均引用群落v2；功能类群丰度仍从对应的原始ASV count与原taxonomy计算，分母为样本全部reads。
- `results/functional_guilds/2026-11-03_v1/` 是**模块1.2自身的首次结果版本**，并不表示基于群落组成v1。它是当前有效功能分析结果；不同模块的版本号分别管理。
- 本次来源复核通过，现有结果直接沿用，无需重复分析或仅为统一版本号复制/重命名结果。后续以群落v2及其可追溯原始输入作为基础；如另有新版本，须明确记录新的有效依据。

### 本次来源核验（不重算）

| 状态 | 实际依据 |
|---|---|
| PASS | results/community_composition/2026-11-03_v2/analysis_metadata.tsv，当前SHA-256与本报告原输入记录相同：`f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd`。 |
| PASS | results/community_composition/2026-11-03_v2/analysis_report.md，当前SHA-256与本报告原输入记录相同：`d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3`。 |
| PASS | results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv，当前SHA-256与本报告原输入记录相同：`4f1477feb2bdd702c0b72a44154069bfaa65f82dd84eff4e2ea78221ea19a0ad`。 |
| PASS | results/phyloseq/batch_01_phyloseq.rds，当前SHA-256与本报告原输入记录相同：`b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30`。 |
| PASS | functional_guilds.R计算输入列表只引用群落v2；功能丰度表33样本列顺序与群落v2属矩阵完全一致，分组8/2/4/15/4。 |
| PASS | 四份功能TSV和全部PDF/PNG不改写、不重算；群落v1/v2文件及原始输入不改写。 |

本次补充不改变原49 PASS/6 WARNING/0 FAIL运行记录；分析计划后续追加版本政策，原报告的计划文件指纹仍对应原运行时版本，不回改历史指纹。


## 2026-11-03 历史标记：本功能分析v1已由v2替代

按用户最新要求，模块1.2已从群落组成v2对应输入重新复现，当前有效结果统一为 [../2026-11-03_v2/analysis_report.md](../2026-11-03_v2/analysis_report.md)。本目录保留历史，不再作为当前入口；此前“功能v1仍有效”的说明由本条取代。四份数值/证据TSV复现一致，原始输入不变；新v2新增基线锁定检查并修正全零趋势面板的负坐标显示。
