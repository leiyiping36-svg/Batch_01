# 模块2.4第一阶段：非传统候选生态ASV补充筛选与候选清单（v2）

实际执行：2026-11-07T17:46:40+08:00 至 2026-11-07T17:46:42+08:00（Asia/Shanghai）；Python 3.14.7，标准库，无随机步骤。

**描述性筛选交付PASS：42 PASS / 4 WARNING / 0 FAIL。** 推断、性能关联及功能确证门控保持关闭；0 FAIL仅指本次交付必要条件。

## 检查报告与复用范围

已先阅读项目约定、背景/设计/计划/日志与模块1.1–2.3当前有效v2报告，核对输入文件、字段和样本ID后固定规则。本次不使用历史v1计算结果。模块2.2全5510行排名已包含主29/全33/G4/后期检出、平均/最大比例、实际节点持续性、10对Bray及模块1.2原16列，本次原列逐字符保留。只新算33样本逐ASV比例、跨反应器/丰度节点计数、规则与得分。原15候选及所有既有证据、序列审核字段保留在新候选表，原文件不改。

5510 ASV、33样本；G1–G5=8/2/4/15/4，主分析29。G4四份初始污泥不同，R1/R3为30℃运行标签，R2/R4室温实际未知；15节点中4为恢复后切换前基线，11为设计后期，R1缺30d。G1结束后混合均分、4℃59d保存恢复及纵向结构不变。共同人工进水是design_recipe，所有采样瞬时DO/温度未知；同配方不消除混杂。G5单母样四粒径级分仅提供单列比例，不参与规则、主均值或推荐排名。

本次未重跑Cutadapt/DADA2/SILVA、深度QC、功能映射或Alpha/Beta；Bray贡献直接复用2.1并逐ASV核对2.2，不重算距离。原对象不更新。

## 四类探索性规则与候选数

- A高丰度：任一主29样本比例≥1%。
- B持续性：同一G4反应器≥3个实际节点检出，且≥2节点比例≥1%；以≥1 read为检出，包含基线。不要求连续，节点间未采样时段未知；原连续已观测节点/后期指标仍保留。
- C跨反应器：≥3个G4反应器至少一次检出，且≥2反应器曾达到≥0.5%；不要求同日，不等同独立生物学复现。
- D高贡献：模块2.1固定10对重点比较中任一单ASV Bray贡献≥0.005。c=|pA−pB|/2，无量纲，不是Bray距离份额或p值；比较名称逐项保留在D_pairs。

任一命中即入池，无名额上限；A/B/C/D重叠，不可相加。每种规则的TRUE/FALSE、触发样本、反应器和比较均写入全表，未入池5510行也完整保留。

| 场景 | A | B | C | D | 并集 | 重叠原15 | 新增 |
|---|---|---|---|---|---|---|---|
| loose | 177 | 67 | 99 | 103 | 189 | 15 | 174 |
| primary | 103 | 39 | 58 | 60 | 106 | 15 | 91 |
| strict | 55 | 26 | 16 | 38 | 55 | 15 | 40 |

主候选池106个，与原15重叠15个，新增91个；候选优先表是主池∪原15，共106行。旧selected/selected_order仍专指模块2.2，module22_candidate_id为原C01–C15；新增N编号按完整ASV ID升序分配，不是优先顺序。

规则依赖需明确：B的高比例条件已经蕴含A；对这些主29内样本的Bray贡献，D≥0.005也必然蕴含任一端比例≥1%，因此D同样被A覆盖。四个规则并非四份独立支持，保留B/D是为解释持续性和变化来源。主池超出A的3个ASV仅由C补入：N006 / 078950af1d2894df2fe2e8f95e0313d2 / NA; N086 / f472b119f8c6da7eed0add3b99588890 / Sanyastnella; N020 / 29050e55ca42dadb6c2997c7c1161c79 / NA。

## 四类组织与证据层级

采用互斥组织：模块1.2 literature_supported_related_taxon→传统功能相关；functional_ambiguity与genus_level_candidate_only→功能歧义（后者为菌株/属候选，具体原级别另保留）；taxonomic_information_insufficient与unverified_pending_research→分类受限或功能未知；named_taxon_function_not_assigned→非传统候选生态类群。最后一类表示有原属标签但目标功能未分配；全表类别只是组织字段，是否入池以primary_candidate为准。非传统不等于新功能或从未研究。

| 类别 | 全部ASV | 主池 | 原15 |
|---|---|---|---|
| 传统功能相关 | 426 | 16 | 6 |
| 非传统候选生态类群 | 1818 | 45 | 3 |
| 功能歧义 | 206 | 13 | 4 |
| 分类受限或功能未知 | 3060 | 32 | 2 |

证据明确仅指参考类群关联：C01/C03等沿用GAO文献关联；Acinetobacter保留功能歧义，不能确证PAO。C02/C09分类受限；C04/C05/C10已有参考株分类/培养背景不赋予本ASV目标功能。原模块1.2 literature_strength/evidence_verified及原15逐条参考/禁止外推完整保留，未作新增文献核验。所有5510 ASV项目功能测定均not_measured。

## 优先级与下一阶段定向审核

生态得分=20×五个0–1分量之和：min(主29最大比例/0.1,1)、min(max Bray/0.05,1)、主29检出率、max反应器(≥1%节点数/实际节点数)、曾≥0.5%反应器数/4。等权、确定性、无训练；0.1/0.05为封顶尺度，不影响入池。节点数不平衡、max和高丰度偏好仍存在，A与D部分同源，分数不是独立证据数量或机制重要性。taxonomy不作功能概率加分，分类限制决定审核任务；不能让高分类置信度排除未定属ASV。

推荐为研究问题指定的C02/C04/C05/C10（均须实际入主池）加其余非传统/分类未知主池按生态得分降序前4；同分按完整ASV ID升序。属于公开的定向优先方案，不冒称全盲全局Top8；全池得分与ecological_target_rank允许复查取舍。C01/C03另作已知功能关联对照，不占8个目标。其他原候选即便未推荐也不删除。

| 编号 | ASV | 原属 | 类别 | 规则 | 主最大 | 主检出 | G4反应器数 | B反应器 | max Bray | 得分 | 严格规则 | 角色 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| C02 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 分类受限或功能未知 | ABCD | 28.110% | 13/29 | 3 | R1 | 0.139536 | 72.30 | ABD | focus_ecological_review |
| C04 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 非传统候选生态类群 | ABCD | 11.916% | 18/29 | 4 | R3 | 0.029597 | 64.25 | ABD | focus_ecological_review |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 非传统候选生态类群 | ABCD | 17.604% | 20/29 | 4 | R3 | 0.024014 | 73.40 | ABD | focus_ecological_review |
| C10 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | 非传统候选生态类群 | ABD | 10.168% | 6/29 | 2 | R1 | 0.050375 | 62.47 | ABD | focus_ecological_review |
| C09 | a578dfb348f923c17e372f94df5716ef | NA | 分类受限或功能未知 | ABCD | 11.460% | 26/29 | 4 | R2 | 0.057123 | 82.93 | ABD | additional_ecological_review |
| N026 | 3c495f2e6a55da9e059579e82a2dfc39 | Phototrophicus | 非传统候选生态类群 | ABCD | 9.543% | 27/29 | 4 | R3;R4 | 0.008492 | 71.10 | AB | additional_ecological_review |
| N045 | 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 非传统候选生态类群 | ABCD | 8.286% | 22/29 | 4 | R3;R4 | 0.029315 | 68.47 | ABD | additional_ecological_review |
| N072 | cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 非传统候选生态类群 | ABCD | 4.545% | 29/29 | 4 | R1;R2;R3 | 0.016474 | 65.68 | ABCD | additional_ecological_review |
| C01 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 传统功能相关 | ABCD | 86.928% | 27/29 | 4 | R2;R4 | 0.344025 | 93.62 | ABCD | known_function_related_control |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 传统功能相关 | ABCD | 15.020% | 29/29 | 4 | R1;R2;R3;R4 | 0.010865 | 84.35 | ABCD | known_function_related_control |

- **C02 / d1725130559823512a63bbc2c1bab523**：直接观察：主29平均1.468%，最大28.110%，max贡献0.139536（R1_R2_d145）；R1检出3/3、≥1%节点2、最高28.110%；R2检出4/4、≥1%节点0、最高0.781%；R3检出1/4、≥1%节点0、最高0.006%；R4检出0/4、≥1%节点0、最高0.000%。原分类限制：genus_unassigned_or_placeholder;lineage_other_suffix_unverified;incertae_sedis_not_named_genus；证据层级taxonomy_limited。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **C04 / be9af24f8e82484720783bcb4df4f6de**：直接观察：主29平均0.739%，最大11.916%，max贡献0.029597（R3_d76_d145）；R1检出2/3、≥1%节点0、最高0.068%；R2检出3/4、≥1%节点0、最高0.222%；R3检出4/4、≥1%节点2、最高11.916%；R4检出3/4、≥1%节点1、最高1.364%。原分类限制：lineage_other_suffix_unverified;confidence_below_0.90_review_flag_only；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **C05 / 54089b19ce1b3690c1e03d4d34a0162c**：直接观察：主29平均1.432%，最大17.604%，max贡献0.024014（R3_d76_d145）；R1检出1/3、≥1%节点0、最高0.006%；R2检出3/4、≥1%节点0、最高0.057%；R3检出4/4、≥1%节点4、最高17.604%；R4检出4/4、≥1%节点0、最高0.913%。原分类限制：lineage_other_suffix_unverified;confidence_below_0.90_review_flag_only；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **C10 / c32a06324874a524e422813afbe86397**：直接观察：主29平均0.705%，最大10.168%，max贡献0.050375（R1_R2_d76）；R1检出3/3、≥1%节点2、最高10.168%；R2检出2/4、≥1%节点0、最高0.220%；R3检出0/4、≥1%节点0、最高0.000%；R4检出0/4、≥1%节点0、最高0.000%。原分类限制：lineage_other_suffix_unverified；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **C09 / a578dfb348f923c17e372f94df5716ef**：直接观察：主29平均1.191%，最大11.460%，max贡献0.057123（R1_R2_d1）；R1检出2/3、≥1%节点0、最高0.035%；R2检出4/4、≥1%节点3、最高11.460%；R3检出4/4、≥1%节点0、最高0.122%；R4检出4/4、≥1%节点1、最高2.385%。原分类限制：genus_unassigned_or_placeholder；证据层级taxonomy_limited。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **N026 / 3c495f2e6a55da9e059579e82a2dfc39**：直接观察：主29平均2.230%，最大9.543%，max贡献0.008492（R2_R4_d1）；R1检出3/3、≥1%节点0、最高0.169%；R2检出3/4、≥1%节点0、最高0.482%；R3检出4/4、≥1%节点4、最高2.896%；R4检出4/4、≥1%节点3、最高1.711%。原分类限制：lineage_other_suffix_unverified；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **N045 / 80225eb15f3521f7cc5b5c36e3afdf15**：直接观察：主29平均1.085%，最大8.286%，max贡献0.029315（R3_d30_d76）；R1检出1/3、≥1%节点0、最高0.025%；R2检出3/4、≥1%节点0、最高0.142%；R3检出4/4、≥1%节点3、最高8.286%；R4检出4/4、≥1%节点2、最高2.874%。原分类限制：lineage_other_suffix_unverified；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **N072 / cfb0a32a7a0d5e6c513509147a75da65**：直接观察：主29平均1.073%，最大4.545%，max贡献0.016474（R2_R4_d76）；R1检出3/3、≥1%节点2、最高4.545%；R2检出4/4、≥1%节点2、最高3.460%；R3检出4/4、≥1%节点3、最高2.564%；R4检出4/4、≥1%节点0、最高0.165%。原分类限制：lineage_other_suffix_unverified;database_code_or_numbered_label_requires_review；证据层级target_function_unknown。下一步：优先以真实代表序列定向核对MiDAS可用版本、参考谱系及同区域比对，记录覆盖/identity/并列匹配与数据库差异；再检索对应谱系原研究。

- **C01 / 3cae56af0b082bba9c858d1844913fc3**：直接观察：主29平均19.882%，最大86.928%，max贡献0.344025（R2_R4_d1）；R1检出2/3、≥1%节点0、最高0.054%；R2检出4/4、≥1%节点3、最高44.705%；R3检出4/4、≥1%节点1、最高1.251%；R4检出4/4、≥1%节点4、最高70.642%。原分类限制：original_label_not_independently_aligned；证据层级reference_taxon_association_only。下一步：已知GAO参考类群对照，保留属内差异和未测功能边界。

- **C03 / 78c2842bcb5d089b057f231ddd53b8e1**：直接观察：主29平均2.817%，最大15.020%，max贡献0.010865（R2_R4_d145）；R1检出3/3、≥1%节点3、最高2.510%；R2检出4/4、≥1%节点3、最高1.647%；R3检出4/4、≥1%节点4、最高15.020%；R4检出4/4、≥1%节点3、最高3.008%。原分类限制：lineage_other_suffix_unverified；证据层级reference_taxon_association_only。下一步：已知GAO参考类群对照，保留属内差异和未测功能边界。

C02的Incertae_Sedis不是已鉴定属，应按Sphingobacteriaceae及完整谱系定位；C04 Chryseotalea与C05 Aridibacter原Confidence约0.852/0.824，优先审核分类匹配；C10 Chryseosolibacter原Confidence较高仍需定向审核，局部高比例不代表广泛持续。原参考株硝酸盐利用/好氧培养等不能转作本ASV反硝化、COD降解或氮磷去除事实。新增对象没有借用同属旧候选的菌株文献确证其功能。

## 阈值敏感性

宽松：A≥0.5%；B≥2检出节点且≥2节点≥0.5%；C≥2检出反应器且≥2曾≥0.25%；D≥0.0025。主规则如上。严格：A≥2%；B≥3检出节点且≥2节点≥2%；C四反应器检出且≥3曾≥1%；D≥0.01。检出主定义≥1 read，另比较≥5 reads（只改变检出部分）。主阈值和得分不随结果调整。

| 场景 | 并集 | 与主池Jaccard | 相对主新增 | 相对主丢失 | 丢失推荐ID |
|---|---|---|---|---|---|
| loose | 189 | 0.5608465608465608 | 83 | 0 | none |
| strict | 55 | 0.5188679245283019 | 0 | 51 | none |

原15在宽松/主/严格池中分别为15/15/15；推荐8个在严格池保留8个。检出≥5 reads时主池106个；相对≥1 read规则组合改变1个ASV。逐ASV阈值成员和触发组合均保存在两表，可直接定位边界对象。

## 直接观察、分类关联与潜在生态假设

直接观察为reads相对比例、检出节点及已有Bray的数学贡献。传统功能相关只表示参考类群文献关联，分类受限/未映射不是无功能。持续较高比例或跨反应器检出可提出“在这些已观测运行背景中具有持续出现的生态信号”等待验证假设；不能认定低DO/温度选择、代谢通路、碳源竞争、功能冗余、性能稳态或氮磷去除。没有匹配出水/去除率/功能基因，不做性能相关性、因果分析、功能确证或共现网络。相对丰度不是绝对丰度，不乘VSS/MLVSS。

G1–G4不同轮次/模块并非独立同质组；29行和G4多节点不是独立重复。共享谱系、四起始状态、反应器个体、温度/DO/时间与批次偏倚未分离。跨反应器规则包括不同日期，可能只反映历史检出。G5四级分逐列独立描述，不作粒径显著性或母样重建。本次未下载MiDAS、未运行参考比对或新增文献综述；后续须记录版本/来源/日期、真实query及区域、匹配歧义、原研究证据作用层级，短16S比对通过也不等于功能确证。

## 文件与字段约定

- [all_asv_ecological_features.tsv](all_asv_ecological_features.tsv)：5510行，原2.2全部列原样保留；relative_abundance__完整样本ID是0–1比例，四个S样本仅G5描述。lineage_*为原SILVA完整各阶元，缺失NA；taxonomy_limitations保留不足/代码/后缀/低置信标记，0.90仅审核提示。
- [candidate_priority_table.tsv](candidate_priority_table.tsv)：主池∪原15；pool_score_rank为全池生态分排序，ecological_target_rank仅非传统/分类未知主池排序，recommendation_order为下一阶段审核顺序。module22_evidence__*及module22_taxonomy__*逐字符保留原15所有字段；新增ASV对应原15证据字段为NA，不冒称已审。
- *_nodes_ge*、*_max_relative_abundance及*_days_ge1pct按各G4实体实际节点；原*_post_*只限后期。*_rules记录全部触发，none为无，*_candidate为成员标记；A_samples/B_reactors/C_reactors_ever_high/D_pairs给出触发位置，C另须满足检出反应器数。G4_reactors_detected_*范围0–4，G4_detected_n_*范围0–15，二者不同。
- [run.log](run.log)：命令、版本、参数、输入/输出SHA-256、实际检查及时间；本报告为唯一综合报告，无另存中间文件或逐检查表。

复现：`python3 scripts/ecological_candidate_screening_v2.py --output-dir results/ecological_candidates/NEW_DATE_v2`。目标目录必须不存在且以_v2结尾；默认当前路径已存在时非零拒绝覆盖。脚本不自动改三份总文档，交付时按实际结果同步。

脚本SHA-256：`ecac31f157c6d520bddb7c373e5d0e93063d48a29457e8fee8d9f09a094ea625`；耗时2.028秒。输入指纹为本次运行时快照，日志随后合法追加不改变历史指纹意义。

| 输入 | 路径 | bytes | SHA-256 |
|---|---|---|---|
| counts | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| ranking22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv | 5716956 | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 |
| evidence22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv | 14140 | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e |
| taxonomy22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv | 18440 | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 |
| annotation12 | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence12 | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| contribution21 | results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv | 19724729 | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e |
| distance21 | results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv | 3052 | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b |
| metadata21 | results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | 37537 | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| metadata23 | results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv | 57392 | 16f6e91b40ace510588002e3aac002901ef6c95921165efb0aaa87447e489254 |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| report13 | results/diversity/2026-11-04_v2/analysis_report.md | 32226 | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| report21 | results/asv_contributions/2026-11-05_v2/analysis_report.md | 76934 | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| report22 | results/candidate_asvs/2026-11-05_v2/analysis_report.md | 46222 | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |
| report23 | results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md | 11919 | e46bfffeb97352a600aeadd97245373b2a59876ea959dd92a4afe8bbf0a07dc2 |
| log23 | results/operational_performance/2026-11-06_design_recipe_v2/run.log | 5454 | 738f950d4df02611ff1daa5b8b3fecb4cb4fe3ab6408be598a906139367e0b7b |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| design | docs/batch_01/experiment_design.md | 21358 | d934ba097876772559a5e2658faf4f5cdbea5564167a6a164efdaf86a448d2b9 |
| plan | docs/batch_01/analysis_plan.md | 12669 | c7250e1440ef404a4df1f06e39abe458ce0743588cb2ed2e1c48b6dba2d1d1ad |
| log_at_start | docs/batch_01/analysis_log.md | 112146 | 4942bce164f0336d90ae2fbbb5a9c2146cc09ad3000c2b12b547dbfac378a2f3 |

## 程序实际门控

| 状态 | 检查 | 依据 |
|---|---|---|
| PASS | 有效v2指纹/counts | data/asv_table.tsv |
| PASS | 有效v2指纹/taxonomy | data/taxonomy.tsv |
| PASS | 有效v2指纹/sequences | data/exported_sequences/dna-sequences.fasta |
| PASS | 有效v2指纹/source_metadata | metadata/source_sample_metadata.tsv |
| PASS | 有效v2指纹/annotation12 | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv |
| PASS | 有效v2指纹/evidence12 | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv |
| PASS | 有效v2指纹/contribution21 | results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv |
| PASS | 有效v2指纹/distance21 | results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv |
| PASS | 有效v2指纹/report11 | results/community_composition/2026-11-03_v2/analysis_report.md |
| PASS | 有效v2指纹/report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md |
| PASS | 有效v2指纹/report13 | results/diversity/2026-11-04_v2/analysis_report.md |
| PASS | 有效v2指纹/report21 | results/asv_contributions/2026-11-05_v2/analysis_report.md |
| PASS | 模块2.2产物指纹/ranking22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv |
| PASS | 模块2.2产物指纹/evidence22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv |
| PASS | 模块2.2产物指纹/taxonomy22 | results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv |
| PASS | 模块2.3当前metadata来源 | results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv |
| PASS | 全ASV身份 | 5510唯一ID与原count、分类、模块1.2和2.2一致 |
| PASS | 代表序列身份复用 | 仅核对ID与既有指纹，不重复序列质量检查 |
| PASS | 样本身份 | 33唯一样本ID；原metadata和有效v2一一对应 |
| PASS | 原metadata与2.1继承 | 原14列、2.1全部63列逐字符保留 |
| PASS | 设计映射/G1 | 8条记录，逐ID匹配正式设计 |
| PASS | 设计映射/G2 | 2条记录，逐ID匹配正式设计 |
| PASS | 设计映射/G3 | 4条记录，逐ID匹配正式设计 |
| PASS | 设计映射/G4 | 15条记录，逐ID匹配正式设计 |
| PASS | 设计映射/G5 | 4条记录，逐ID匹配正式设计 |
| PASS | G4实际节点 | R1为3节点，其余4节点；基线4/后期11，不插补 |
| PASS | 温度/初始状态与实测边界 | 四起始状态不同，30℃/室温未知分列，全部瞬时DO/温度NA |
| PASS | 阶段/保存/G5层级 | 4切换前基线、11设计后期；4℃59d历史；G5单母样 |
| PASS | 共同配方与性能门控 | 仅共享名义配方，性能关联保持关闭 |
| PASS | 计算必要计数条件 | 非负整数/无NA/无空样本；沿用既有深度异常QC，不重跑 |
| PASS | 33样本比例闭合 | 分母始终每样本全部5510 ASV reads，无稀释/过滤 |
| PASS | 功能/分类原值复用 | 模块1.2全部16列与2.2逐字符一致；原Taxon/Confidence保留 |
| PASS | 既有主29指标一致性 | 原2.2均值/最大/检出直接复用，和本次比例核对 |
| PASS | 既有Bray贡献复用 | 55100行/10对与2.2逐ASV一致，贡献和等于既有Bray；未重算距离 |
| PASS | 原15候选/证据身份 | C01–C15完整保留，旧清单/证据/分类审核不覆盖 |
| PASS | 敏感性集合嵌套 | 严格池⊆主池⊆宽松池；全5510原样保留 |
| PASS | 四重点资格 | C02/C04/C05/C10均实际满足主规则；不是无条件入池 |
| PASS | 下一阶段推荐资格 | 8个生态审核目标；C01/C03另列对照 |
| PASS | 原候选证据完整保留 | 15条原证据与分类审核所有字段逐字符复制，含真实序列；不新增功能主张 |
| WARNING | 阈值与得分 | 探索性筛选与确定性优先级，非显著性/置信区间；A与D部分重叠，不是独立生态证据。 |
| WARNING | 实验设计/批次 | 重复节点、不同初始污泥、共享混合谱系/保存恢复、温度与反应器混杂；提取/PCR/测序子批次及16S拷贝偏倚未分离。跨反应器检出不等于独立复现。 |
| WARNING | 分类/功能证据 | 沿用SILVA及模块1.2/2.2证据快照；MiDAS与新增文献审核未执行，功能未知不是无功能，所有5510 ASV功能基因/活性未测。 |
| WARNING | 性能/因果门控 | 无可匹配的实测出水、去除率或功能基因数据；性能关联、DO/温度因果、功能确证、共现网络均关闭且未执行。 |
| PASS | all_asv_ecological_features.tsv回读 | 5510行×267列逐值一致 |
| PASS | candidate_priority_table.tsv回读 | 106行×150列逐值一致 |
| PASS | 原输入/既有结果保护 | 186个既有科研输入、结果、脚本SHA-256不变 |

必需断言失败返回非零退出码，并保留本次run.log的FAIL；只有全部必要条件通过才交付报告。本次描述性门控通过不表示独立性或后续统计前提通过。

## 独立交付核验（2026-11-07T17:49:43+08:00）

以下独立核验不混入主流程42 PASS / 4 WARNING / 0 FAIL：

- PASS：标准库独立读取原整数count，以整数交叉乘法判断丰度边界，核对5510×33比例、三套规则及具体触发位置、反应器节点、得分，至少413250项；比例最大误差0。原模块2.2全部排名列、15条证据及分类审核全部字段逐字符保持。
- PASS：主池106（A/B/C/D=103/39/58/60）、宽松189/严格55及集合嵌套、C独自补入3、原15重叠、推荐8对象与另列C01/C03对照核对。8推荐均在严格池；新增N编号对应完整ASV ID。
- PASS：隔离临时目录执行同一脚本，两份科学TSV与正式结果逐字节相同；已有输出目录与v1目标分别非零拒绝且四产物不变，未创建v1目录。
- PASS：任务前198文件中仅三份科研总文档获授权修改，其余195个既有科研/历史文件SHA-256不变；原始metadata/计数/分类/代表序列/RDS与全部既有模块结果不变。日志原文前缀保留，README/累计解释除顶部当前状态外历史正文保持顺序。
- PASS：README、累计解释、设计、计划及本报告共277个本地文件/显式锚点链接有效；仅新增一个脚本和指定四产物，同步三份总文档，没有新增逐项检查文件或图件。

本次独立核验为临时脚本`python3 /tmp/batch01_module24_validate.py`；其检查方法与结果在此记录，临时文件随本次临时目录清理。必要分析断言均内置正式可复现脚本，不依赖该临时核验器。没有新增MiDAS匹配、物种鉴定、功能基因、活性、去除率、显著性或因果结果。待人工/后续科研审核仍为8对象的定向分类和原研究证据；无需重复确认已确认分组/温度标签/配方范围。
