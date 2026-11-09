> 当前有效版本：**2026-11-05_v2**。依据用户要求统一命名；计算输入已确认来自有效v2，数值与图件沿用，未重新分析。历史路径和指纹保留并在文末记录迁移关系；v1不作当前入口。

# 模块2.2：重点候选ASV筛选与分类学证据审核（2026-11-05）

当前目录：results/candidate_asvs/2026-11-05_v2。实际运行：2026-11-05 16:37:30 CST–2026-11-05 16:37:39 CST。
**描述性计算完成：18 PASS / 4 WARNING / 0 FAIL。15个候选；完整5510 ASV保留。** 推断和功能确证门控关闭。

## 检查报告、歧义及执行规则

先阅读AGENTS、研究背景、最新实验设计、分析计划/日志及有效1.1/1.2/1.3/2.1报告并核对真实文件；筛选前已在日志及用户进度消息固定规则。基线为组成/功能2026-11-03_v2、多样性2026-11-04_v2和ASV贡献2026-11-05_v2。原QC由输入指纹复用。33样本/8-2-4-15-4不变；G4四份起始状态不同，R1/R3=30℃运行，R2/R4=室温未知；保留混合均分谱系、4℃59d保存恢复、纵向重复及G5单母样。

歧义：Incertae_Sedis不是已鉴定属，高Confidence不解除分类限制；上级--other与数据库代码语义未核实。历史338F/806R信息不能替代参考坐标比对。没有项目本地参考数据库/BLAST可用组合，不编造命中、相似度或物种。未知值NA不为通过门控填补。

1. 主候选=用户指定5个全纳入，再在其余ASV中取max(10对既有Bray贡献)≥0.005的前10；最大贡献降序、完整ID升序解并列。选15个。功能、分类、检出率不参与资格或排序。5个指定候选为研究问题指定，不能冒称全盲筛选。
2. 贡献阈值0.005是无量纲Bray贡献（单ASV对应两端相对丰度差≥1个百分点），不是Bray份额0.5%、不是显著性。max优先捕捉局部大差异，可能偏向基线差异和高丰度；10对共享样本，贡献之和仅重复比较的描述评分，不是10次独立复现。
3. 全5510排名给全33/主29/G4全15/G4后期11的检出（≥1和≥5 reads）、等记录平均/最大相对丰度；比例分母始终每样本全部ASV reads。全33均值受G5四级分和不平衡时间权重影响，故主29、G4单列，不作独立总体均值。
4. 持续性仅按同一G4运行实体的实际节点。R1全3/后2，其他全4/后3；最长连续是连续已观测节点个数，相邻两端检出不代表间隔全程存在。后期持续≥1%仅作补充丰度描述，不计天数、不补30d、不跨保存恢复拼接。
5. 阈值敏感性预设0.0025/0.005/0.01×额外名额5/10/15及检出≥1/5；不依预期功能修改主规则。Confidence<0.90仅标记定向分类审核优先，不是重新分类阈值、删ASV规则或功能概率。

## 1. 最值得研究的ASV及入选依据

| candidate | ASV | genus | selection | detected_all33 | detected_G4 | G4_mean_pct | G4_max_pct | max_Bray | max_pair | evidence |
|---|---|---|---|---|---|---|---|---|---|---|
| C01 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | user_priority | 31 | 14 | 16.660668 | 70.642478 | 0.344025 | R2_R4_d1 | literature_supported_related_taxon |
| C02 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | user_priority | 17 | 8 | 2.593918 | 28.110005 | 0.139536 | R1_R2_d145 | taxonomic_information_insufficient |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | user_priority | 33 | 15 | 4.266996 | 15.019564 | 0.010865 | R2_R4_d145 | literature_supported_related_taxon |
| C04 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | user_priority | 22 | 12 | 1.346087 | 11.915883 | 0.029597 | R3_d76_d145 | named_taxon_function_not_assigned |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | user_priority | 23 | 12 | 2.168273 | 17.603785 | 0.024014 | R3_d76_d145 | named_taxon_function_not_assigned |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | max_Bray_ge0.005_top10_remaining | 22 | 12 | 3.191386 | 21.188458 | 0.105081 | R2_R4_d30 | functional_ambiguity |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | max_Bray_ge0.005_top10_remaining | 23 | 11 | 3.408088 | 15.983724 | 0.075484 | R2_R4_d1 | functional_ambiguity |
| C08 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | max_Bray_ge0.005_top10_remaining | 33 | 15 | 5.616776 | 15.362823 | 0.067088 | R2_R4_d30 | literature_supported_related_taxon |
| C09 | a578dfb348f923c17e372f94df5716ef | NA | max_Bray_ge0.005_top10_remaining | 27 | 14 | 1.361001 | 11.460088 | 0.057123 | R1_R2_d1 | taxonomic_information_insufficient |
| C10 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | max_Bray_ge0.005_top10_remaining | 10 | 5 | 1.362139 | 10.168259 | 0.050375 | R1_R2_d76 | named_taxon_function_not_assigned |
| C11 | f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | max_Bray_ge0.005_top10_remaining | 21 | 9 | 1.389954 | 9.627271 | 0.046085 | R2_R4_d76 | literature_supported_related_taxon |
| C12 | b815668a1e362dc6a897d2895c351449 | Acinetobacter | max_Bray_ge0.005_top10_remaining | 23 | 12 | 0.850017 | 8.506141 | 0.041316 | R1_R2_d145 | functional_ambiguity |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | max_Bray_ge0.005_top10_remaining | 31 | 15 | 1.703204 | 8.088199 | 0.039917 | R2_R4_d30 | literature_supported_related_taxon |
| C14 | 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | max_Bray_ge0.005_top10_remaining | 33 | 15 | 2.323214 | 12.625863 | 0.030923 | R3_d30_d76 | literature_supported_related_taxon |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | max_Bray_ge0.005_top10_remaining | 22 | 11 | 1.645281 | 7.629905 | 0.029887 | R2_R4_d1 | functional_ambiguity |

- **3cae56af0b082bba9c858d1844913fc3（Competibacter关联）**：G4检出14/15；R2后期30d 0.1667% → 76d 5.1454% → 145d 44.7053%；R4后期30d 30.1928% → 76d 55.3957% → 145d 38.9043%。末段R2/R4 Δ贡献-0.222247、R1/R2 Δ贡献+0.197705；两种现象由同一ASV份额重排共同关联，非两份独立生态证据。
- **d1725130559823512a63bbc2c1bab523**：R1后期76d 9.4429% → 145d 28.1100%；Sphingobacteriaceae / Incertae_Sedis，Confidence=0.984092仍不能命名属。末段R1/R2 Δ贡献+0.096226，是优先研究的功能未知生态ASV。
- **78c2842bcb5d089b057f231ddd53b8e1（Defluviicoccus关联）**：R3后期30d 14.0900% → 76d 15.0196% → 145d 13.1484%；按实际后期节点持续≥1%，优先用于描述相同ASV的丰度持续性；仅保留GAO类群关联。
- **be9af24f8e82484720783bcb4df4f6de（Chryseotalea原属标签）**：R3后期30d 0.1671% → 76d 5.9966% → 145d 11.9159%；Confidence=0.851623，参考株分类/培养背景不足以支持项目目标功能；保持未分配。
- **54089b19ce1b3690c1e03d4d34a0162c（Aridibacter原属标签）**：R3后期30d 5.4720% → 76d 6.0203% → 145d 1.2175%；Confidence=0.823897。特定参考株硝酸盐利用仅形成待验证假设，不升级为本ASV反硝化/除氮。

补充10个是固定全比较规则的结果，包含较高基线差异的Acinetobacter、多个Competibacter、另一Defluviicoccus、未定属Paracoccaceae和Chryseosolibacter。不能将它们全部称为低DO末段变化特异标记；每项最大比较及全10对贡献见全量排名表。

### 候选覆盖的既有Bray贡献

| pair | existing_Bray | selected_contribution_sum | selected_share |
|---|---|---|---|
| R2_R4_d1 | 0.874510 | 0.604663 | 0.691430 |
| R2_R4_d30 | 0.820961 | 0.415829 | 0.506515 |
| R2_R4_d76 | 0.804296 | 0.432205 | 0.537371 |
| R2_R4_d145 | 0.435510 | 0.159162 | 0.365461 |
| R1_R2_d1 | 0.426713 | 0.144910 | 0.339596 |
| R1_R2_d76 | 0.480549 | 0.180370 | 0.375341 |
| R1_R2_d145 | 0.777441 | 0.503467 | 0.647596 |
| R3_d30_d76 | 0.364409 | 0.095721 | 0.262676 |
| R3_d76_d145 | 0.219243 | 0.081128 | 0.370036 |
| R2_d76_d145 | 0.605949 | 0.291125 | 0.480445 |

selected_share为候选在该对距离中的算术份额，不是过程解释率/机制解释率。未入选ASV的剩余贡献始终保留于模块2.1。

## 2. 哪些可合理关联已知功能

15候选中6个沿用GAO文献关联（Competibacter/Defluviicoccus），4个Acinetobacter保留PAO歧义。所有项目ASV均只有间接16S证据；不新增AOB/NOB/AnAOB/PAO确认。

属标签仅支持与已知类群关联；本项目不能验证糖原/PHA代谢、碳竞争、除磷失败或氮转换速率。参考论文的强证据与本ASV功能未测量必须同时阅读。Acinetobacter个别分离株文献不支持整个属的典型EBPR功能或特定ASV活性。原模块1.2四表及所有分区完全不变。

## 3. 重要但功能未知的生态ASV

d172…代表R1后期大幅份额上升的未定属谱系；a578dfb348f923c17e372f94df5716ef代表Paracoccaceae未定属高贡献候选。二者应保留为独立ASV研究对象，不能借父科常见功能强配反硝化。Chryseotalea、Aridibacter及Chryseosolibacter也有重要组成信号，但本项目目标功能仍未知/未分配。

Aridibacter参考株硝酸盐利用、Chryseosolibacter参考株一般异养生长、Chryseotalea参考株培养背景分别属于特定菌株文献或属级背景假设；不能移植成项目ASV的COD去除、完整反硝化或除磷事实。未分配不是无功能。

## 4. 分类是否足以支持属级解释

| feature_id | original_genus | original_Confidence | sequence_length_bp | non_ACGT_bases | feature_id_matches_sequence_md5 | genus_interpretation_status | confidence_review_flag |
|---|---|---|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.993310 | 429 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 0.984092 | 425 | 0 | TRUE | insufficient_for_named_genus | ge0.90_not_functional_probability |
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 0.999886 | 404 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.851623 | 423 | 0 | TRUE | original_genus_label_only_unaligned | below_0.90_review_priority_only |
| 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 0.823897 | 404 | 0 | TRUE | original_genus_label_only_unaligned | below_0.90_review_priority_only |
| 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 0.999879 | 430 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 0.999968 | 430 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.999816 | 404 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| a578dfb348f923c17e372f94df5716ef | NA | 0.999949 | 404 | 0 | TRUE | insufficient_for_named_genus | ge0.90_not_functional_probability |
| c32a06324874a524e422813afbe86397 | Chryseosolibacter | 0.983126 | 423 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | 0.997133 | 429 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.999972 | 430 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.991101 | 429 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 0.961975 | 429 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |
| f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | 0.999922 | 430 | 0 | TRUE | original_genus_label_only_unaligned | ge0.90_not_functional_probability |

两个属级不足候选为d172…（Sphingobacteriaceae / Incertae_Sedis）与a578…（止于Paracoccaceae科）；均只可按真实父谱系描述。Chryseotalea和Aridibacter置信度低于本次0.90审核标记，应优先定向比对；其余高置信属标签也不是独立比对确证，不能定种/菌株。Defluviicoccus上级order含--other，不擅自改原谱系，也不将上级后缀直接解释为属标签缺失。

15个序列实际长度404–430 bp，ACGT及MD5身份检查通过。审核表同时提供完整序列、SHA-256、原Confidence字符串和各阶元，不另重复导出FASTA。所有reference_accession/identity/coverage/species均NA。

后续定向比对方案（本次未执行）：以审核表真实序列为query，准备可追溯版本/下载日期/校验和的参考16S及模式株或高质量长序列；记录query/subject长度、方向、覆盖、identity、并列最佳匹配及数据库分类体系。对齐同一扩增区域后评估谱系一致性；短片段即使高相似也不自动定种或导出功能。暂不安装/下载全库或重跑完整分类器。

## 文献证据审核（2026-11-05快照）

下列原研究题名、DOI及可访问摘要/索引原文片段已检索；核实层级不等同全文审阅。在线读取部分受验证码/403限制，未取得内容不声称已核实。E00是分类受限且ASV直接功能证据待核实，文献和DOI均NA；未伪造来源。每ASV与对应文献的映射、支持范围、禁止外推和旧证据均在candidate_asv_evidence.tsv。

- E01：McIlroy et al. 2014 (online 2013). [Candidatus Competibacter-lineage genomes retrieved from metagenomes reveal functional metabolic diversity](https://pubmed.ncbi.nlm.nih.gov/24173461/). DOI: 10.1038/ismej.2013.162。核实层级：primary_abstract_and_indexed_primary_text_verified；参考谱系支持糖原/PHA碳储存的GAO关联；谱系间代谢潜力有差异。 不能把本ASV定为具体物种或反硝化菌；不能证明碳竞争、活性或除磷失败。
- E02：Burow et al. 2007. [Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes](https://pubmed.ncbi.nlm.nih.gov/17185546/). DOI: 10.1099/mic.0.2006/001032-0。核实层级：primary_abstract_verified；参考Defluviicoccus类群有GAO相关碳摄取/储存表型证据。 未将项目ASV比对到参考cluster；不能由检出持续性证明GAO活性或过程贡献。
- E03：Tandoi et al. 1998. [The behaviour of polyphosphate accumulating acinetobacter isolates in an anaerobic-aerobic chemostat](https://www.sciencedirect.com/science/article/pii/S0043135498000797). DOI: 10.1016/S0043-1354(98)00079-7。核实层级：primary_indexed_abstract_excerpt_verified_full_text_403；个别参考分离株存在储磷/储存聚合物现象；保持既有PAO歧义。 不能扩展为全属典型EBPR-PAO、氮去除菌或本项目除磷活性；全文本次受限。
- E04：Maejima et al. 2020 (online 2019). [Chryseotalea sanaruensis gen. nov., sp., nov., a Member of the Family Cytophagaceae, Isolated from a Brackish Lake in Hamamatsu Japan](https://pubmed.ncbi.nlm.nih.gov/31792570/). DOI: 10.1007/s00284-019-01823-4。核实层级：primary_indexed_abstract_excerpt_and_bibliography_verified_open_recaptcha；原分类描述报告参考株为好氧菌；只能提供分类与培养背景。 项目ASV未鉴定到该种；不能据此声称COD降解、反硝化、PAO或GAO功能已支持。
- E05：Huber et al. 2017. [Aridibacter nitratireducens sp. nov., a member of the family Blastocatellaceae, class Blastocatellia, isolated from an African soil](https://www.microbiologyresearch.org/content/journal/ijsem/10.1099/ijsem.0.002318). DOI: 10.1099/ijsem.0.002318。核实层级：primary_publisher_abstract_verified；该参考株可在无氧条件下以硝酸盐为替代电子受体。 不能由属注释把项目ASV定为该株，也不能等同完整反硝化、TN去除或本批活性。
- E06：Octaviana et al. 2022. [Four new members of the family Cytophagaceae: Chryseosolibacter histidini gen. nov., sp. nov., Chryseosolibacter indicus gen. nov., sp. nov., Dawidia cretensis, gen. nov., sp. nov., and Dawidia soli, gen. nov., sp. nov. isolated from diverse habitat](https://pmc.ncbi.nlm.nih.gov/articles/PMC9296434/). DOI: 10.1007/s10482-022-01756-2。核实层级：primary_abstract_and_relevant_results_sections_verified；参考分离株的好氧生长和有机底物利用可形成一般异养背景假设。 不能把参考株培养结果转成本项目COD降解能力、低DO适应或氮磷去除实证。

## 固定阈值敏感性

| threshold | extra_cap | eligible_remaining | selected_total | overlap_primary |
|---|---|---|---|---|
| 0.0025 | 5 | 98 | 10 | 10 |
| 0.0025 | 10 | 98 | 15 | 15 |
| 0.0025 | 15 | 98 | 20 | 15 |
| 0.0050 | 5 | 55 | 10 | 10 |
| 0.0050 | 10 | 55 | 15 | 15 |
| 0.0050 | 15 | 55 | 20 | 15 |
| 0.0100 | 5 | 33 | 10 | 10 |
| 0.0100 | 10 | 33 | 15 | 15 |
| 0.0100 | 15 | 33 | 20 | 15 |

具体丢失/新增候选ID（相对主规则）：
| threshold | extra_cap | lost_primary | added |
|---|---|---|---|
| 0.0025 | 5 | f0e953dd2a7892838f44fea2495a408f;b815668a1e362dc6a897d2895c351449;f23e2ebe64cf70326440deb743f4bf85;3e1088366bf860effa27b1322906df56;f23982138e4d5ed3fcb068cbac95af41 |  |
| 0.0025 | 10 |  |  |
| 0.0025 | 15 |  | 80225eb15f3521f7cc5b5c36e3afdf15;b45dc3d21bfd0b6968e3baf5c5a3c883;a21463e7f09e30cd1a22ddb77596a3a7;d1a24fd7f12ac5dd5f767a56cfdd46cd;a582a45cc296a1d3b0c246a7d7611c78 |
| 0.0050 | 5 | f0e953dd2a7892838f44fea2495a408f;b815668a1e362dc6a897d2895c351449;f23e2ebe64cf70326440deb743f4bf85;3e1088366bf860effa27b1322906df56;f23982138e4d5ed3fcb068cbac95af41 |  |
| 0.0050 | 10 |  |  |
| 0.0050 | 15 |  | 80225eb15f3521f7cc5b5c36e3afdf15;b45dc3d21bfd0b6968e3baf5c5a3c883;a21463e7f09e30cd1a22ddb77596a3a7;d1a24fd7f12ac5dd5f767a56cfdd46cd;a582a45cc296a1d3b0c246a7d7611c78 |
| 0.0100 | 5 | f0e953dd2a7892838f44fea2495a408f;b815668a1e362dc6a897d2895c351449;f23e2ebe64cf70326440deb743f4bf85;3e1088366bf860effa27b1322906df56;f23982138e4d5ed3fcb068cbac95af41 |  |
| 0.0100 | 10 |  |  |
| 0.0100 | 15 |  | 80225eb15f3521f7cc5b5c36e3afdf15;b45dc3d21bfd0b6968e3baf5c5a3c883;a21463e7f09e30cd1a22ddb77596a3a7;d1a24fd7f12ac5dd5f767a56cfdd46cd;a582a45cc296a1d3b0c246a7d7611c78 |

检出定义敏感性（只影响检出指标，主候选集不以检出过滤，因此不变）：
| ASV | all33_ge1 | all33_ge5 | G4_ge1 | G4_ge5 |
|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | 31 | 31 | 14 | 14 |
| d1725130559823512a63bbc2c1bab523 | 17 | 16 | 8 | 7 |
| 78c2842bcb5d089b057f231ddd53b8e1 | 33 | 33 | 15 | 15 |
| be9af24f8e82484720783bcb4df4f6de | 22 | 22 | 12 | 12 |
| 54089b19ce1b3690c1e03d4d34a0162c | 23 | 21 | 12 | 10 |
| 3b91d8fd7dc57a941d49bed1b084064d | 22 | 22 | 12 | 12 |
| 9d94363a8ab81a79ecf766644aa45b23 | 23 | 23 | 11 | 11 |
| 82c70888e3f2436874633b4285a188e9 | 33 | 33 | 15 | 15 |
| a578dfb348f923c17e372f94df5716ef | 27 | 27 | 14 | 14 |
| c32a06324874a524e422813afbe86397 | 10 | 10 | 5 | 5 |
| f0e953dd2a7892838f44fea2495a408f | 21 | 21 | 9 | 9 |
| b815668a1e362dc6a897d2895c351449 | 23 | 23 | 12 | 12 |
| f23e2ebe64cf70326440deb743f4bf85 | 31 | 31 | 15 | 15 |
| 3e1088366bf860effa27b1322906df56 | 33 | 33 | 15 | 15 |
| f23982138e4d5ed3fcb068cbac95af41 | 22 | 22 | 11 | 11 |

全量排名中的两套指标及下表节点持续性反映低reads检出敏感性；不把≥1 reads和≥5 reads任一口径认作真实活细胞存在阈值。持续性未作生存率、时间积分或重复独立性估计。

### 每候选×反应器实际节点持续性

| candidate | ASV | reactor | actual_days | detected_ge1 | detected_ge5 | longest_observed_run | post_nodes | post_detected_ge1 | post_all_ge1pct |
|---|---|---|---|---|---|---|---|---|---|
| C01 | 3cae56af0b082bba9c858d1844913fc3 | R1 | 1,76,145 | 2 | 2 | 1 | 2 | 1 | FALSE |
| C01 | 3cae56af0b082bba9c858d1844913fc3 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C01 | 3cae56af0b082bba9c858d1844913fc3 | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C01 | 3cae56af0b082bba9c858d1844913fc3 | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C02 | d1725130559823512a63bbc2c1bab523 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | TRUE |
| C02 | d1725130559823512a63bbc2c1bab523 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C02 | d1725130559823512a63bbc2c1bab523 | R3 | 1,30,76,145 | 1 | 0 | 1 | 3 | 1 | FALSE |
| C02 | d1725130559823512a63bbc2c1bab523 | R4 | 1,30,76,145 | 0 | 0 | 0 | 3 | 0 | FALSE |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | TRUE |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C04 | be9af24f8e82484720783bcb4df4f6de | R1 | 1,76,145 | 2 | 2 | 2 | 2 | 2 | FALSE |
| C04 | be9af24f8e82484720783bcb4df4f6de | R2 | 1,30,76,145 | 3 | 3 | 3 | 3 | 3 | FALSE |
| C04 | be9af24f8e82484720783bcb4df4f6de | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C04 | be9af24f8e82484720783bcb4df4f6de | R4 | 1,30,76,145 | 3 | 3 | 3 | 3 | 3 | FALSE |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | R1 | 1,76,145 | 1 | 0 | 1 | 2 | 1 | FALSE |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | R2 | 1,30,76,145 | 3 | 2 | 3 | 3 | 3 | FALSE |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | R1 | 1,76,145 | 2 | 2 | 2 | 2 | 1 | FALSE |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | R2 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | R4 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | R1 | 1,76,145 | 2 | 2 | 2 | 2 | 1 | FALSE |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | R2 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | R3 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | R4 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C08 | 82c70888e3f2436874633b4285a188e9 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | TRUE |
| C08 | 82c70888e3f2436874633b4285a188e9 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C08 | 82c70888e3f2436874633b4285a188e9 | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C08 | 82c70888e3f2436874633b4285a188e9 | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C09 | a578dfb348f923c17e372f94df5716ef | R1 | 1,76,145 | 2 | 2 | 2 | 2 | 1 | FALSE |
| C09 | a578dfb348f923c17e372f94df5716ef | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C09 | a578dfb348f923c17e372f94df5716ef | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C09 | a578dfb348f923c17e372f94df5716ef | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C10 | c32a06324874a524e422813afbe86397 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | TRUE |
| C10 | c32a06324874a524e422813afbe86397 | R2 | 1,30,76,145 | 2 | 2 | 2 | 3 | 2 | FALSE |
| C10 | c32a06324874a524e422813afbe86397 | R3 | 1,30,76,145 | 0 | 0 | 0 | 3 | 0 | FALSE |
| C10 | c32a06324874a524e422813afbe86397 | R4 | 1,30,76,145 | 0 | 0 | 0 | 3 | 0 | FALSE |
| C11 | f0e953dd2a7892838f44fea2495a408f | R1 | 1,76,145 | 0 | 0 | 0 | 2 | 0 | FALSE |
| C11 | f0e953dd2a7892838f44fea2495a408f | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C11 | f0e953dd2a7892838f44fea2495a408f | R3 | 1,30,76,145 | 1 | 1 | 1 | 3 | 1 | FALSE |
| C11 | f0e953dd2a7892838f44fea2495a408f | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C12 | b815668a1e362dc6a897d2895c351449 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | FALSE |
| C12 | b815668a1e362dc6a897d2895c351449 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C12 | b815668a1e362dc6a897d2895c351449 | R3 | 1,30,76,145 | 3 | 3 | 3 | 3 | 3 | FALSE |
| C12 | b815668a1e362dc6a897d2895c351449 | R4 | 1,30,76,145 | 2 | 2 | 2 | 3 | 2 | FALSE |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | FALSE |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C14 | 3e1088366bf860effa27b1322906df56 | R1 | 1,76,145 | 3 | 3 | 3 | 2 | 2 | FALSE |
| C14 | 3e1088366bf860effa27b1322906df56 | R2 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C14 | 3e1088366bf860effa27b1322906df56 | R3 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | TRUE |
| C14 | 3e1088366bf860effa27b1322906df56 | R4 | 1,30,76,145 | 4 | 4 | 4 | 3 | 3 | FALSE |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | R1 | 1,76,145 | 2 | 2 | 2 | 2 | 1 | FALSE |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | R2 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | R3 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | R4 | 1,30,76,145 | 3 | 3 | 3 | 3 | 2 | FALSE |

## 5. 与COD、氮磷去除及温度背景的衔接

本次没有导入/核验COD、氮磷进出水性能或同日温度连续记录，也没有运行性能关联计算。下一步先查现有原始记录，以sample_id、反应器运行实体、采样日期/相对日与处理阶段建立可回查对应；区分测序取样瞬间、周期内进出水和此前时间窗口。不得把G2/G3与G4跨保存恢复连成一个连续过程，也不得复制同一性能值给G5四级分并当四个独立点。

- COD：并列候选相对份额与对应COD进出水、去除率/负荷记录，并说明可溶/总COD、采样口径、单位与对齐窗口；未提供流量/体积时不编造负荷。GAO关联只能提出碳储存假设，不能把Bray贡献称为COD去除贡献。
- 氮：先核对NH4-N、NO2-N、NO3-N、TN进出水和运行时序；Aridibacter菌株文献只能提出待验证线索。未入选的Nitrosomonas/Nitrospira及其他类群不能因本候选清单而被忽略；Nitrospira的NOB/comammox歧义继续沿用模块1.2。
- 磷：核对PO4-P/TP进出水及周期释放/摄取证据，PAO/GAO文献关联可并列描述；高GAO比例不等于除磷失败，Acinetobacter不升级为保守PAO。
- 温度：只用已确认G4运行标签（R1/R3=30℃，R2/R4=室温未知）；不能推算温差、外推基线/其他模块或拟合温度响应。先保留每反应器实际轨迹及初始状态；室温数值、初始污泥性状、性能稳态和批次记录未核验时不估计独立温度效应。

未来可行工作是同一反应器、同一运行实体内的描述性对照与明确的待验证假设。是否可作相关/重复测量统计须另行核验独立单位、来源块、时间相关、混杂与模型可识别性；本次不输出p值、共现网络、因果或新实验结果。

## 局限及待人工核查

候选受预指定5个、10对重点比较和max贡献规则限制，偏重高丰度及局部差异，并非功能微生物全目录；低贡献稳定功能类群可未入选。33/29/15/11是记录数，不是独立重复数。G4重复与历史混合块、起始污泥/反应器/温度混杂，G5单母样，16S拷贝数/提取/PCR/测序子批次偏倚未分离。没有绝对丰度或活性证据，不乘VSS/MLVSS。

待核查为定向参考比对及数据库后缀语义、候选ASV与参考菌株的对应关系、可追溯COD/氮磷/温度记录与采样窗口、起始污泥登记编号和具体性状及运行性能稳态证据。已确认的33样本名单、8/2/4/15/4和G4阶段标签不再列为待确认。

## 文件、运行参数与版本

- [全5510 ASV排名与分层指标](candidate_asv_ranking.tsv)：selected=TRUE为15候选，selected_order为C01–C15；相对丰度0–1、Bray贡献无量纲、检出率0–1。
- [15候选分类/真实代表序列审核](candidate_asv_taxonomy_review.tsv)、[逐ASV文献证据](candidate_asv_evidence.tsv)。
- [候选G4实际节点轨迹PDF](candidate_asv_trajectories.pdf) / [PNG](candidate_asv_trajectories.png)；独立纵轴，不能跨面板比曲线高度。
- [run.log](run.log)及本中文综合报告。共7个最终文件；不增加项目中间数据或对象。

命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/candidate_asv_review.R`；新版本复现加`--output-dir 尚不存在的新目录`。默认路径已存在即非零退出；脚本仅计算/交付本模块，科研总文档由本次收尾单独更新。文献核实快照内置脚本，复现不联网、不重新分类、不重做QC/距离。无随机步骤。

脚本SHA-256：f7374c179360826e323c3e52440723ca5639e6e8202501993fbd5dde9aeddbc9
实际耗时：9.495秒。

以下表格为首次计算时的历史输入路径与指纹，原记录保留；其中旧目录现已迁移，当前路径/指纹见文末“v2命名统一记录”。这不是重新运行记录。

| input | path | bytes | sha256 |
|---|---|---|---|
| counts | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| object | results/phyloseq/batch_01_phyloseq.rds | 1031084 | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| metadata | results/asv_contributions/2026-11-05_v1/analysis_metadata_addendum.tsv | 37537 | 3cee9ca213d715772744ebf89ba315ac73dc1b97cafcc597cdb382a41776dfc6 |
| trajectory | results/asv_contributions/2026-11-05_v1/focal_asv_abundance_trajectories.tsv | 20593787 | 7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 |
| contribution | results/asv_contributions/2026-11-05_v1/focal_pairwise_asv_contributions.tsv | 19724729 | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e |
| temporal | results/asv_contributions/2026-11-05_v1/focal_temporal_asv_changes.tsv | 17008007 | dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 |
| distance | results/asv_contributions/2026-11-05_v1/focal_distance_summary.tsv | 3052 | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b |
| annotation21 | results/asv_contributions/2026-11-05_v1/focal_asv_function_annotations.tsv | 2415489 | 079b43a1d5a1546ee0f7145fc43a232d0c5cffcba32e77b2194cc37456ab81b9 |
| annotation | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| report13 | results/diversity/2026-11-04_v2/analysis_report.md | 32226 | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| report21 | results/asv_contributions/2026-11-05_v1/analysis_report.md | 67928 | 829b771ca2ac67886c6b42d0e706480bfde816f802a79e8422585a4e9e108c95 |
| design | docs/batch_01/experiment_design.md | 17995 | 6ba285b5b071b81af0a9223359a526eb83a91f1d73abe46594d0ba39363344ba |
| plan | docs/batch_01/analysis_plan.md | 11043 | 93135a524706432a24f23ab637c410883f540ecfc5449e92c7940b13cba456a5 |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |

| tool | version |
|---|---|
| R | R version 4.5.2 (2025-10-31) |
| digest | 0.6.39 |
| ggplot2 | 4.0.3 |
| Biostrings | 2.78.0 |

## 程序实际检查

| status | item | evidence |
|---|---|---|
| PASS | 环境 | 复用现有R/digest/ggplot2/Biostrings，不安装软件。 |
| PASS | 输入存在 | 原始count/taxonomy/FASTA、有效1.1/1.2/1.3/2.1和设计均存在。 |
| PASS | 有效基线与既有QC复用 | 原输入/对象/功能v2/有效报告/设计指纹匹配2.1报告。只做本模块必需断言，不重复测序QC、分类或完整距离。 |
| PASS | 计数输入必需条件 | 5510×33原整数计数，ID唯一，无缺失/负值/空样本；深度异常QC不重跑。 |
| PASS | 样本级设计门控 | 原14列保留，33样本/8-2-4-15-4逐ID匹配；G4真实3/4/4/4节点、温度/基线/11后期/保存恢复和G5单母样核对。 |
| PASS | 分类及功能连接 | 全部5510 IDs与原FASTA/taxonomy一致，2.1原16列功能逐值等于1.2 v2；完整谱系/Confidence原值复用，不更新分类/功能。 |
| PASS | 完整轨迹复用 | 82650行逐格核对既有count/比例/节点，G4指标及绘图直接复用2.1轨迹；全33上下文指标仅从原count汇总。 |
| PASS | 贡献复用与守恒 | 55100行10对贡献和等于2.1已有Bray；88160行16段时间变化完整保留，仅汇总原表，不重复计算距离。 |
| PASS | 预定筛选规则 | 指定5+非指定max贡献≥0.005前10，共15；全部5510 ASV排名保留，分类/功能不参与选择。 |
| PASS | 阈值敏感性 | 3个贡献阈值×3个补充名额，全部9种输出在报告内；不更改主规则。检出≥1/5不作为筛选门槛。 |
| PASS | 15候选代表序列身份 | 实际核对长度、ACGT和序列MD5与ASV ID；全谱系及原Confidence数值/原字符串并列。 |
| PASS | 无虚构参考匹配 | 本次不运行BLAST/系统发育/重分类；匹配、覆盖率及物种结论均NA，序列直接列于审核表供后续定向比对。 |
| WARNING | 分类分辨率 | 2 候选属级不足； 2 候选Confidence<0.90。0.90仅审核标记、不删样、不等于功能置信度；上级--other语义未确认。 |
| PASS | 逐ASV文献边界 | 15候选均有证据行；6条核实原研究、2个分类受限候选文献NA待核实。旧功能证据完整保留，新背景不改映射。 |
| WARNING | 参考比对待核实 | 项目无本地参考比对库，PATH未提供blastn/makeblastdb；只列真实序列，未运行BLAST或给出相似度/物种鉴定。 |
| WARNING | 文献获取层级 | 6篇原研究按实际摘要/索引片段/相关结果核实，非系统综述；Chryseotalea直接打开验证码，Acinetobacter全文403；分类受限候选的直接功能文献仍待核实。 |
| WARNING | 科研推断门控关闭 | G4四份起始状态各异；共享谱系/保存恢复、纵向重复、温度与反应器/初始群落混杂。室温/瞬时DO/温度未知，G5单母样；不做推断、因果或功能确证。 |
| PASS | candidate_asv_ranking.tsv 回读 | 5510 行；字段和全部数值列往返一致。 |
| PASS | candidate_asv_taxonomy_review.tsv 回读 | 15 行；字段和全部数值列往返一致。 |
| PASS | candidate_asv_evidence.tsv 回读 | 15 行；字段和全部数值列往返一致。 |
| PASS | 轨迹图实际节点 | 15候选×15实际G4节点=225点，图层数值/非负/完整ID核验；独立纵轴，不补R1-30d。G5不连入G4时间轴。 |
| PASS | 原输入及历史结果保护 | 159 个科研输入/旧结果/脚本SHA-256不变；未改原metadata、taxonomy、功能映射或RDS。 |

```
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
 [1] crayon_1.5.3        vctrs_0.7.3         cli_3.6.6          
 [4] rlang_1.3.0         generics_0.1.4      textshaping_1.0.5  
 [7] S7_0.2.2            labeling_0.4.3      glue_1.8.1         
[10] S4Vectors_0.48.0    Biostrings_2.78.0   ragg_1.5.2         
[13] stats4_4.5.2        scales_1.4.0        grid_4.5.2         
[16] Seqinfo_1.0.0       tibble_3.3.1        IRanges_2.44.0     
[19] lifecycle_1.0.5     compiler_4.5.2      dplyr_1.2.1        
[22] RColorBrewer_1.1-3  pkgconfig_2.0.3     XVector_0.50.0     
[25] systemfonts_1.3.2   farver_2.1.2        digest_0.6.39      
[28] R6_2.6.1            tidyselect_1.2.1    pillar_1.11.1      
[31] magrittr_2.0.5      withr_3.0.3         tools_4.5.2        
[34] gtable_0.3.6        BiocGenerics_0.56.0
```

主流程合计：18 PASS / 4 WARNING / 0 FAIL；独立交付核验随后追加，不混入主流程计数。


## 2026-11-05 16:41:23 Asia/Shanghai 独立交付核验与历史分类来源

- PASS：独立Python从原count核对全部5510行分层检出、均值/最大值、R1–R4两种检出口径的节点持续性，并逐项比对10对既有贡献及2段Δ贡献、全部原功能列；592,164项数值核对，最大误差1.776e-15。没有重复计算已有距离矩阵。
- PASS：15个候选、三种贡献阈值的固定名额结果、15条真实序列/长度/MD5/SHA-256、全谱系各阶元及原Confidence字符串核验；参考匹配/物种字段均NA。序列404–430 bp，2个属级不足候选保留。
- PASS：PNG为2560×2560，逐块CRC与像素流解压通过；PDF头尾完整。实际打开PNG检查全部15个面板，完整ASV ID、独立非负纵轴、图例/图注可读，225个实际节点不插补。
- PASS：原目录重跑在写入前退出1并明确拒绝覆盖，7个产物SHA-256不变；任务前157个科研输入/旧结果/脚本/设计文件均未改变。原metadata、taxonomy、功能映射与RDS保持。
- 核验实现说明：独立核验初版曾假设R与Python对并列比较ID使用相同排序；两语言collation不同，仅调整临时核验为检查所记比较确为最大值，数值/主排序/候选集均未改写，最终全部通过。

历史SILVA来源只转述[原分类输入参数](../../../logs/taxonomy/inputs.json)：分类器文件名`silva144-2026.7-full-length.qza`，原记录classifier SHA-256 `e6a6ac57b880c4f9e92baf8c4050483a6deed2615a9c001a7251c01dfe32a047`；confidence=0.7、read_orientation=same、n_jobs=1、reads_per_batch=100。该文件名不替代数据库训练来源核验；外部路径记录不是本次已加载的原始参考序列库。本次未打开/重跑分类器，完整谱系继续用原Taxon。参数日志自身SHA-256：`2937d9b59781f252688bdbbd9812a8cc5f904b44afc1aff039d64e1e3709df9c`。本次Confidence<0.90只是审核标记，与历史分类器0.7参数含义不同。

最终交付7文件及`scripts/candidate_asv_review.R`；README、累计结果解释及执行日志同步。主流程仍为18 PASS / 4 WARNING / 0 FAIL；参考比对、目标功能实证及COD/氮磷/温度数据关联仍待后续核查。

最终归档 2026-11-05 16:42:04 Asia/Shanghai：211本地链接可解析，7产物齐全，脚本SHA-256匹配；157个任务前科研文件未变，日志历史前缀完整，累计解释仅更新顶部日期/导航状态后追加新模块，其余历史原文保留。仅清理本任务创建的3个/tmp核验文件。


## v2命名统一记录（2026-11-05，当前有效）

用户明确要求v1仅作历史，若实际输入为v2则名称全部统一v2。本次核对两模块44项历史输入指纹，确认使用组成/功能2026-11-03_v2和多样性2026-11-04_v2，模块2.2沿用相同有效链；执行命名迁移，不删除或重新计算科学分析。

| 迁移前历史路径 | 当前有效路径 |
|---|---|
| results/asv_contributions/2026-11-05_v1 | results/asv_contributions/2026-11-05_v2 |
| results/candidate_asvs/2026-11-05_v1 | results/candidate_asvs/2026-11-05_v2 |

迁移时间：2026-11-05 16:54:58 Asia/Shanghai。当前入口为results/candidate_asvs/2026-11-05_v2；上文报告当前路径及项目导航已更新，首次运行的时间与历史输入指纹表原样保留。历史表内v1路径按本映射回查，不能再将其作为当前输入。旧目录已迁移，不留两个可混淆的当前副本。

**实际核验范围：**9份非metadata TSV和8个PDF/PNG逐字节一致，数值、样本/ASV ID、候选名单、阈值与科学结论未改；模块2.1派生metadata仅33个版本标签及30个审核文件路径单元格变化，原45列完整不变。原count、taxonomy、FASTA、原metadata、RDS、模块1.1–1.3历史及有效v2结果均未改。

脚本只更新默认目录、当前来源及版本标签，并显式锁定v2、禁止向v1输出。两个脚本语法解析通过；两脚本现有目录/旧v1输出共4项拒绝写入检查通过，23个产物保持不变。这些是路径维护核验，不是新的科研计算PASS。

旧脚本运行指纹保留在原计算记录；当前维护后脚本`scripts/candidate_asv_review.R` SHA-256：`482464e3164ff11834cb76126b5a13547a568b55a79e3c3a8193348cb8ba97b8`。本次未声称新脚本重新执行了此前的科学计算。

### 当前输入路径与指纹（命名维护后的快照）

下表供新路径复现和下游来源核验；它与上方首次运行的历史指纹表分别保留。设计/计划变动只涉及版本政策和链接维护，审核为追加状态，派生metadata变动只涉及来源/版本文本。

| input | path | bytes | sha256 |
|---|---|---|---|
| counts | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| object | results/phyloseq/batch_01_phyloseq.rds | 1031084 | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| metadata | results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | 37537 | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| trajectory | results/asv_contributions/2026-11-05_v2/focal_asv_abundance_trajectories.tsv | 20593787 | 7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 |
| contribution | results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv | 19724729 | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e |
| temporal | results/asv_contributions/2026-11-05_v2/focal_temporal_asv_changes.tsv | 17008007 | dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 |
| distance | results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv | 3052 | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b |
| annotation21 | results/asv_contributions/2026-11-05_v2/focal_asv_function_annotations.tsv | 2415489 | 079b43a1d5a1546ee0f7145fc43a232d0c5cffcba32e77b2194cc37456ab81b9 |
| annotation | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| report13 | results/diversity/2026-11-04_v2/analysis_report.md | 32226 | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| report21 | results/asv_contributions/2026-11-05_v2/analysis_report.md | 76934 | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| design | docs/batch_01/experiment_design.md | 18558 | 59113eaaea346995e649000d562b647e3fd65d3690e93083b164dbcfbb31b755 |
| plan | docs/batch_01/analysis_plan.md | 11784 | 65f7406f2e4b650503f24d3c0f3e1787d9d5d9bac4e98160cfa60c4c02534b44 |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |

### 本模块产物迁移核验

| 当前文件 | 迁移前SHA-256 | 当前SHA-256 | 核验说明 |
|---|---|---|---|
| candidate_asv_evidence.tsv | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e | 逐字节不变 |
| candidate_asv_ranking.tsv | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 | 逐字节不变 |
| candidate_asv_taxonomy_review.tsv | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 | 逐字节不变 |
| candidate_asv_trajectories.pdf | c1c61036536630b835a11a81e438d21d749272e14fb194a5ca86ff72b2c0054e | c1c61036536630b835a11a81e438d21d749272e14fb194a5ca86ff72b2c0054e | 逐字节不变 |
| candidate_asv_trajectories.png | 65f41d31446c2a39a10888da6770458225358a402281658d4fea90c912c07d17 | 65f41d31446c2a39a10888da6770458225358a402281658d4fea90c912c07d17 | 逐字节不变 |

原日志字节前缀完整保留，尾部追加迁移记录；报告新增明确的当前v2声明、历史指纹说明和本节。科研结论与局限不变；不将命名统一当作修复了未验证的功能/温度因果或图件展示限制。
