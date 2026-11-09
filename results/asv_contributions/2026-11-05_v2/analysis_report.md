> 当前有效版本：**2026-11-05_v2**。依据用户要求统一命名；计算输入已确认来自有效v2，数值与图件沿用，未重新分析。历史路径和指纹保留并在文末记录迁移关系；v1不作当前入口。

# 模块2.1：G4条件补充与ASV群落趋近、分化及贡献（2026-11-05）

当前输出：results/asv_contributions/2026-11-05_v2。运行起点：2026-11-05 15:56:46 CST。本报告只支持描述性组成分析，统计/因果推断门控关闭。

## 检查报告、设计差异及数据边界

已先完成[g4_design_addendum.md](g4_design_addendum.md)差异审核，随后正式设计仅追加2026-11-05节。以有效组成/功能2026-11-03_v2和多样性2026-11-04_v2为基础。33样本、5510 ASV、G1–G5=8/2/4/15/4保持。原count、taxonomy、原metadata、RDS及三个有效v2均不覆盖。未重跑DADA2、SILVA、测序QC、Alpha/Beta全流程或功能映射。

R1/R3为G4 30℃保温运行标签，R2/R4为室温运行，实际室温及所有采样实测温度未知。G4四份起始污泥性状与菌群均不同是用户确认；具体编号、性状记录为NA，不能用测序样本号/絮状颗粒设计类型替代。温度字段不外推其他模块或恢复阶段实测。

四个初始样本E1/F1/原G1/H1对应R1/R2/R3/R4，均在低DO切换前。后期11样本DO阶段设置0.5±0.2 mg/L。旧派生表全部45列保留；旧分析基线DO=NA与design_document=3差异不改写，新字段单独引用2026-11-03恢复设置3。全部瞬时DO未知。混合均分、4℃59天保存恢复及来源块由新字段追踪，起始状态不同并不消除历史依赖。

[analysis_metadata_addendum.tsv](analysis_metadata_addendum.tsv)新增18列，33行。具体起始污泥编号/性状、室温实测记录、基线/恢复期温度范围和运行性能稳态证据待人工补充；这些未知项不阻断本次描述性贡献计算。

## 方法与预先固定规则

以全部ASV原count/各样本全部reads得p，不过滤、不稀释、不改taxonomy。每对样本每ASV贡献c_i=|pAi−pBi|/(ΣpA+ΣpB)=|pAi−pBi|/2；贡献份额=c_i/Bray。所有5510 ASV含双零行保存，完整原taxonomy及分类置信度并列。共享相同ASV组成量=Σmin(pAi,pBi)=1−Bray。该共享量是读数比例重叠，不代表共同来源或活菌转移。

属汇总算法A=Σ属内|pAi−pBi|/2；算法B=|Σ属内pAi−Σ属内pBi|/2。A才是ASV距离在该属的贡献，B是另一个分辨率的属级距离贡献；A≥B，差额揭示属内正负丰度变化抵消。按完整祖先谱系分组，未分类保留原父谱系，不能将所有未知属混成一个生物属。属标签相似不自动等于相同ASV相似。

跨时段差额Δc=c_late−c_early，负值为端点差缩小、正值扩大；同时输出两反应器各自有符号丰度变化，不能把贡献变化当因果。反应器内转移另列为|p_to−p_from|/2，不混作跨反应器距离差。R1缺30d，不插补，不把端点距离当累计周转或除以天数当真实速率。

Top N=10，按绝对贡献/绝对贡献变化排序并以完整ASV ID打破并列。共同高丰度=两端均≥1%；明显升降=变化≥1个百分点，仅为描述性筛选，不是统计显著性。三目标属主要ASV=该属G4全部15个记录等权均值Top5；完整轨迹与功能连接仍保留5510 ASV。后期阶段均值不按时间积分，也不当独立重复均值。

## A. 已计算的距离与ASV贡献

所有下列距离从模块1.3复用；不同单位不直接比较绝对大小。

| pair_id | day_a | day_b | Bray_Curtis | Jaccard_binary | Hellinger | CLR_pc05_at_min_depth | CLR_pc1_at_min_depth |
|---|---|---|---|---|---|---|---|
| R2_R4_d1 | 1 | 1 | 0.874510 | 0.802326 | 1.114807 | 63.82331 | 52.52668 |
| R2_R4_d30 | 30 | 30 | 0.820961 | 0.774775 | 1.136893 | 74.21089 | 61.94436 |
| R2_R4_d76 | 76 | 76 | 0.804296 | 0.795014 | 1.026748 | 72.33272 | 59.51358 |
| R2_R4_d145 | 145 | 145 | 0.435510 | 0.773684 | 0.706211 | 67.45977 | 54.29139 |
| R1_R2_d1 | 1 | 1 | 0.426713 | 0.776886 | 0.711308 | 64.28567 | 52.41273 |
| R1_R2_d76 | 76 | 76 | 0.480549 | 0.725594 | 0.780109 | 68.67068 | 56.02453 |
| R1_R2_d145 | 145 | 145 | 0.777441 | 0.752000 | 1.089697 | 68.31332 | 55.61492 |
| R3_d30_d76 | 30 | 76 | 0.364409 | 0.694181 | 0.580588 | 53.58059 | 41.77059 |
| R3_d76_d145 | 76 | 145 | 0.219243 | 0.682243 | 0.384525 | 48.93511 | 37.22477 |
| R2_d76_d145 | 76 | 145 | 0.605949 | 0.675567 | 0.846946 | 62.31221 | 50.62635 |

### Q1/Q2：R2–R4趋近与R1–R2分化的数学来源

下表分别加总全部ASV端点差缩小和扩大项，两者抵消得到距离净变化。负项表示对距离下降的数学贡献，不称生态驱动因子。
守恒摘要：
| comparison | shrinking_sum | expanding_sum | net_Bray_change |
|---|---|---|---|
| R2_R4_1_to_30 | -0.443668 | 0.390118 | -0.053549 |
| R2_R4_30_to_76 | -0.370449 | 0.353784 | -0.016665 |
| R2_R4_76_to_145 | -0.558551 | 0.189765 | -0.368787 |
| R1_R2_1_to_76 | -0.278007 | 0.331843 | 0.053836 |
| R1_R2_76_to_145 | -0.205756 | 0.502648 | 0.296892 |

#### R2_R4 76→145d：端点差缩小ASV（Top10）

| ASV | genus | A_early_pct | B_early_pct | A_late_pct | B_late_pct | delta_Bray | A_delta_pp | B_delta_pp |
|---|---|---|---|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 5.145362 | 55.395734 | 44.705311 | 38.904260 | -0.222247 | 39.559949 | -16.491474 |
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 6.499895 | 1.336153 | 0.000000 | 0.000000 | -0.025819 | -6.499895 | -1.336153 |
| b45dc3d21bfd0b6968e3baf5c5a3c883 | Candidatus_Competibacter | 4.818968 | 0.000000 | 0.608609 | 0.016436 | -0.021134 | -4.210359 | 0.016436 |
| f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | 0.410323 | 9.627271 | 0.488155 | 5.845775 | -0.019297 | 0.077832 | -3.781497 |
| 3b387d0f00c00f016a9c8aed15d5fa74 | Candidatus_Kapaibacterium | 3.515725 | 0.000000 | 0.378268 | 0.000000 | -0.015687 | -3.137458 | 0.000000 |
| cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 3.459772 | 0.164986 | 0.355022 | 0.095877 | -0.015178 | -3.104750 | -0.069109 |
| f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | 2.818642 | 0.494957 | 0.000000 | 0.000000 | -0.011618 | -2.818642 | -0.494957 |
| 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 2.454946 | 0.209137 | 0.000000 | 0.000000 | -0.011229 | -2.454946 | -0.209137 |
| 87206ae071ee47ee82d60398b551c3b7 | Incertae_Sedis | 1.895414 | 0.000000 | 0.000000 | 0.000000 | -0.009477 | -1.895414 | 0.000000 |
| 50b7f9ff4b0b0982cd6d774ae12c979c | OLB8 | 0.000000 | 1.598736 | 0.000000 | 0.000000 | -0.007994 | 0.000000 | -1.598736 |

#### R2_R4 76→145d：端点差扩大ASV（Top10）

| ASV | genus | A_early_pct | B_early_pct | A_late_pct | B_late_pct | delta_Bray | A_delta_pp | B_delta_pp |
|---|---|---|---|---|---|---|---|---|
| a582a45cc296a1d3b0c246a7d7611c78 | Chryseotalea | 0.687758 | 0.548404 | 4.243359 | 0.189015 | 0.019575 | 3.555601 | -0.359388 |
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.258783 | 2.932565 | 1.942055 | 7.840022 | 0.016121 | 1.683272 | 4.907457 |
| 8412dda0621215ae8fc8fb832616106e | Dechloromonas | 0.314737 | 0.467073 | 2.531646 | 0.145186 | 0.011171 | 2.216909 | -0.321887 |
| e5bf038beab1833287d740ff5edfbf53 | Phototrophicus | 0.018651 | 0.620440 | 0.107775 | 2.911930 | 0.011012 | 0.089123 | 2.291490 |
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 1.475765 | 1.222289 | 0.834725 | 3.007807 | 0.009598 | -0.641041 | 1.785518 |
| 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 0.142214 | 1.384951 | 0.139473 | 2.873579 | 0.007457 | -0.002741 | 1.488628 |
| be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.072273 | 0.206813 | 0.221889 | 1.364197 | 0.005039 | 0.149616 | 1.157383 |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.097918 | 0.027885 | 0.243021 | 1.254623 | 0.004708 | 0.145103 | 1.226738 |
| 1dca1ecb147e4cc7af6154eeb4627fe4 | Defluviicoccus | 0.144546 | 0.239346 | 0.090869 | 0.767018 | 0.002907 | -0.053677 | 0.527673 |
| 1061f034d9e9c9880bf2febf607da036 | Defluviicoccus | 0.058285 | 0.090626 | 0.000000 | 0.605397 | 0.002865 | -0.058285 | 0.514771 |

末期仍存差异的属/原谱系Top10（ASV贡献与属总量差分开）：

| genus | genus_key | abundance_a | abundance_b | asv_sum_bray_contribution | genus_aggregated_bray_contribution | within_genus_cancellation |
|---|---|---|---|---|---|---|
| Candidatus_Competibacter | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Candidatus_Competibacterales;f__Candidatus_Competibacteraceae;g__Candidatus_Competibacter | 0.503476 | 0.541570 | 0.103230 | 0.019047 | 0.084183 |
| Defluviicoccus | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Alphaproteobacteria;o__Rhodospirillales--other;f__Defluviicoccaceae;g__Defluviicoccus | 0.120982 | 0.068073 | 0.068821 | 0.026455 | 0.042367 |
| Phototrophicus | d__Bacteria;k__Bacillati;p__Chloroflexota--other;c__Anaerolineae;o__Phototrophicales;f__Phototrophicaceae;g__Phototrophicus | 0.041081 | 0.097165 | 0.043039 | 0.028042 | 0.014998 |
| Chryseotalea | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Cytophagia;o__Cytophagales;f__Chryseotaleaceae;g__Chryseotalea | 0.046491 | 0.016436 | 0.026779 | 0.015027 | 0.011752 |
| Candidatus_Tepidaquicella | d__Bacteria;k__Pseudomonadati--other;p__Chlorobiota;c__Ignavibacteria--other;o__Candidatus_Tepidaquicellales;f__Candidatus_Tepidaquicellaceae;g__Candidatus_Tepidaquicella | 0.015131 | 0.029119 | 0.020456 | 0.006994 | 0.013462 |
| Dechloromonas | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Rhodocyclales;f__Azonexaceae;g__Dechloromonas | 0.025316 | 0.001452 | 0.011932 | 0.011932 | 0.000000 |
| Nitrosomonas | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Spirillales--other;f__Nitrosomonadaceae;g__Nitrosomonas | 0.022189 | 0.000520 | 0.010834 | 0.010834 | 0.000000 |
| Incertae_Sedis | d__Bacteria;k__Pseudomonadati;p__Myxococcota;c__Polyangiia;o__Haliangiales;f__Kofleriaceae;g__Incertae_Sedis | 0.021048 | 0.004657 | 0.008379 | 0.008195 | 0.000183 |
| Acinetobacter | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Pseudomonadales;f__Moraxellaceae;g__Acinetobacter | 0.002430 | 0.016107 | 0.006839 | 0.006839 | 0.000000 |
| SC-I-84 | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Burkholderiales--other;f__Incertae_Sedis;g__SC-I-84 | 0.005896 | 0.010464 | 0.005922 | 0.002284 | 0.003638 |

#### R1_R2 76→145d：端点差缩小ASV（Top10）

| ASV | genus | A_early_pct | B_early_pct | A_late_pct | B_late_pct | delta_Bray | A_delta_pp | B_delta_pp |
|---|---|---|---|---|---|---|---|---|
| b45dc3d21bfd0b6968e3baf5c5a3c883 | Candidatus_Competibacter | 0.235877 | 4.818968 | 0.300167 | 0.608609 | -0.021373 | 0.064290 | -4.210359 |
| 87206ae071ee47ee82d60398b551c3b7 | Incertae_Sedis | 0.000000 | 1.895414 | 0.000000 | 0.000000 | -0.009477 | 0.000000 | -1.895414 |
| 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 0.338090 | 2.345371 | 0.298053 | 0.486042 | -0.009096 | -0.040037 | -1.859329 |
| 8f515894604634120cb1a11157f1452a | Candidatus_Competibacter | 0.324331 | 2.186837 | 2.046209 | 1.570127 | -0.006932 | 1.721878 | -0.616710 |
| a578dfb348f923c17e372f94df5716ef | Unclassified_genus | 0.021622 | 1.522393 | 0.000000 | 0.164832 | -0.006680 | -0.021622 | -1.357561 |
| d21385f158525246156144c1df740c6d | Exiguobacterium | 1.187247 | 0.000000 | 0.000000 | 0.000000 | -0.005936 | -1.187247 | 0.000000 |
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 7.571648 | 6.499895 | 0.000000 | 0.000000 | -0.005359 | -7.571648 | -6.499895 |
| 2c5b844d921fe7862f8b9a693dd58f59 | Defluviicoccus | 0.725321 | 1.897746 | 0.784239 | 0.938273 | -0.005092 | 0.058918 | -0.959473 |
| 085af8a51a3c352e28a08d6180215af7 | Unclassified_genus | 0.000000 | 1.016483 | 0.000000 | 0.023245 | -0.004966 | 0.000000 | -0.993237 |
| 970dc81d56d7471f2ea104c119ad2e35 | Candidatus_Tepidaquicella | 0.355781 | 1.872100 | 0.276915 | 0.974198 | -0.004095 | -0.078866 | -0.897903 |

#### R1_R2 76→145d：端点差扩大ASV（Top10）

| ASV | genus | A_early_pct | B_early_pct | A_late_pct | B_late_pct | delta_Bray | A_delta_pp | B_delta_pp |
|---|---|---|---|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.000000 | 5.145362 | 0.019025 | 44.705311 | 0.197705 | 0.019025 | 39.559949 |
| d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 9.442937 | 0.781013 | 28.110005 | 0.202870 | 0.096226 | 18.667067 | -0.578143 |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.782325 | 0.097918 | 8.506141 | 0.243021 | 0.037894 | 7.723816 | 0.145103 |
| 631a21ea0d9fb92c96cd9a0a34785968 | Unclassified_genus | 0.037347 | 0.000000 | 1.989135 | 0.000000 | 0.009759 | 1.951788 | 0.000000 |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 5.796674 | 9.852423 | 4.138922 | 10.101224 | 0.009533 | -1.657752 | 0.248800 |
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.009828 | 0.258783 | 0.019025 | 1.942055 | 0.008370 | 0.009196 | 1.683272 |
| a582a45cc296a1d3b0c246a7d7611c78 | Chryseotalea | 2.482604 | 0.687758 | 0.927981 | 4.243359 | 0.007603 | -1.554623 | 3.555601 |
| 990eb3ec99027baf8ba545570a53ef7e | OLB8 | 0.102213 | 0.011657 | 1.989135 | 0.401513 | 0.007485 | 1.886921 | 0.389856 |
| 8412dda0621215ae8fc8fb832616106e | Dechloromonas | 0.171011 | 0.314737 | 0.959689 | 2.531646 | 0.007141 | 0.788678 | 2.216909 |
| 155db310d24817c07222e509926a1078 | Incertae_Sedis | 0.416716 | 0.300748 | 1.135139 | 0.099322 | 0.004599 | 0.718423 | -0.201427 |

末期仍存差异的属/原谱系Top10（ASV贡献与属总量差分开）：

| genus | genus_key | abundance_a | abundance_b | asv_sum_bray_contribution | genus_aggregated_bray_contribution | within_genus_cancellation |
|---|---|---|---|---|---|---|
| Candidatus_Competibacter | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Candidatus_Competibacterales;f__Candidatus_Competibacteraceae;g__Candidatus_Competibacter | 0.027734 | 0.503476 | 0.242695 | 0.237871 | 0.004824 |
| Incertae_Sedis | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Sphingobacteriia;o__Sphingobacteriales;f__Sphingobacteriaceae;g__Incertae_Sedis | 0.281248 | 0.003719 | 0.140370 | 0.138764 | 0.001606 |
| Chryseosolibacter | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Cytophagia;o__Cytophagales;f__Chryseotaleaceae;g__Chryseosolibacter | 0.095842 | 0.002198 | 0.046822 | 0.046822 | 0.000000 |
| Defluviicoccus | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Alphaproteobacteria;o__Rhodospirillales--other;f__Defluviicoccaceae;g__Defluviicoccus | 0.085315 | 0.120982 | 0.043689 | 0.017834 | 0.025855 |
| Acinetobacter | d__Bacteria;k__Pseudomonadati;p__Pseudomonadota;c__Gammaproteobacteria;o__Pseudomonadales;f__Moraxellaceae;g__Acinetobacter | 0.089564 | 0.002430 | 0.043567 | 0.043567 | 0.000000 |
| Phototrophicus | d__Bacteria;k__Bacillati;p__Chloroflexota--other;c__Anaerolineae;o__Phototrophicales;f__Phototrophicaceae;g__Phototrophicus | 0.049232 | 0.041081 | 0.022458 | 0.004075 | 0.018383 |
| Chryseotalea | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Cytophagia;o__Cytophagales;f__Chryseotaleaceae;g__Chryseotalea | 0.011732 | 0.046491 | 0.019155 | 0.017380 | 0.001776 |
| Unclassified_genus | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Saprospiria;o__Saprospirales;f__Lewinellaceae | 0.020906 | 0.003466 | 0.011340 | 0.008720 | 0.002620 |
| Incertae_Sedis | d__Bacteria;k__Pseudomonadati;p__Myxococcota;c__Polyangiia;o__Haliangiales;f__Kofleriaceae;g__Incertae_Sedis | 0.000909 | 0.021048 | 0.010978 | 0.010069 | 0.000909 |
| OLB8 | d__Bacteria;k__Pseudomonadati--other;p__Bacteroidota;c__Saprospiria;o__Saprospirales;f__Lewinellaceae;g__OLB8 | 0.020526 | 0.009129 | 0.010326 | 0.005698 | 0.004628 |

### 共同高丰度ASV：与差缩小/扩大分开列出

下表只按两端均≥1%筛选，再按最小端点丰度排序取前10；并不要求差异贡献高。全部共同高丰度标记保存在贡献表中。

**R2_R4_d145**

| feature_id | genus | relative_abundance_a | relative_abundance_b | bray_contribution | shared_ASV_overlap |
|---|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.447053 | 0.389043 | 0.029005 | 0.389043 |
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.019421 | 0.078400 | 0.029490 | 0.019421 |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.101012 | 0.014299 | 0.043356 | 0.014299 |

**R1_R2_d145**

| feature_id | genus | relative_abundance_a | relative_abundance_b | bray_contribution | shared_ASV_overlap |
|---|---|---|---|---|---|
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.041389 | 0.101012 | 0.029812 | 0.041389 |
| 8f515894604634120cb1a11157f1452a | Candidatus_Competibacter | 0.020462 | 0.015701 | 0.002380 | 0.015701 |
| 2c5ff56e8821afc1034d4169457f4c15 | Nitrosomonas | 0.011816 | 0.017265 | 0.002724 | 0.011816 |

**R3_d30_d76**

| feature_id | genus | relative_abundance_a | relative_abundance_b | bray_contribution | shared_ASV_overlap |
|---|---|---|---|---|---|
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 0.140900 | 0.150196 | 0.004648 | 0.140900 |
| 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 0.126259 | 0.064412 | 0.030923 | 0.064412 |
| 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 0.054720 | 0.060203 | 0.002741 | 0.054720 |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.037726 | 0.036104 | 0.000811 | 0.036104 |
| e5bf038beab1833287d740ff5edfbf53 | Phototrophicus | 0.020732 | 0.036519 | 0.007894 | 0.020732 |
| 3b387d0f00c00f016a9c8aed15d5fa74 | Candidatus_Kapaibacterium | 0.020688 | 0.028189 | 0.003751 | 0.020688 |
| 1dca1ecb147e4cc7af6154eeb4627fe4 | Defluviicoccus | 0.016862 | 0.016955 | 0.000046 | 0.016862 |
| 1061f034d9e9c9880bf2febf607da036 | Defluviicoccus | 0.016708 | 0.013131 | 0.001789 | 0.013131 |
| 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 0.011740 | 0.070370 | 0.029315 | 0.011740 |
| 4f94d1e38fabc2d3d55b8b1f652dbdf3 | Incertae_Sedis | 0.011542 | 0.038238 | 0.013348 | 0.011542 |

**R3_d76_d145**

| feature_id | genus | relative_abundance_a | relative_abundance_b | bray_contribution | shared_ASV_overlap |
|---|---|---|---|---|---|
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 0.150196 | 0.131484 | 0.009356 | 0.131484 |
| 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 0.070370 | 0.082860 | 0.006245 | 0.070370 |
| 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 0.064412 | 0.073593 | 0.004590 | 0.064412 |
| be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.059966 | 0.119159 | 0.029597 | 0.059966 |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.036104 | 0.035624 | 0.000240 | 0.035624 |
| e5bf038beab1833287d740ff5edfbf53 | Phototrophicus | 0.036519 | 0.034048 | 0.001235 | 0.034048 |
| 052174b1cb33ba8d4407c41833125e5f | Terricaulis | 0.034325 | 0.026826 | 0.003750 | 0.026826 |
| 3b387d0f00c00f016a9c8aed15d5fa74 | Candidatus_Kapaibacterium | 0.028189 | 0.025550 | 0.001320 | 0.025550 |
| 3c495f2e6a55da9e059579e82a2dfc39 | Phototrophicus | 0.022320 | 0.028964 | 0.003322 | 0.022320 |
| cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 0.025640 | 0.017803 | 0.003919 | 0.017803 |

### 单一反应器明显升/降ASV：不以属总量代替

分别列R1/R2/R3/R4末段76→145d；变化按相对丰度百分点，≥1个百分点且方向正/负才列出。全11段全部ASV在时间变化表中。

**R1 上升（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 9.442937 | 28.110005 | 18.667067 |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.782325 | 8.506141 | 7.723816 |
| 631a21ea0d9fb92c96cd9a0a34785968 | NA | 0.037347 | 1.989135 | 1.951788 |
| 990eb3ec99027baf8ba545570a53ef7e | OLB8 | 0.102213 | 1.989135 | 1.886921 |
| 8f515894604634120cb1a11157f1452a | Candidatus_Competibacter | 0.324331 | 2.046209 | 1.721878 |

**R1 下降（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 7.571648 | 0.000000 | -7.571648 |
| cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 4.544561 | 0.048619 | -4.495942 |
| f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | 3.211857 | 0.000000 | -3.211857 |
| 3b387d0f00c00f016a9c8aed15d5fa74 | Candidatus_Kapaibacterium | 4.493454 | 2.037753 | -2.455701 |
| d1a24fd7f12ac5dd5f767a56cfdd46cd | Acinetobacter | 2.170067 | 0.000000 | -2.170067 |
| 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 1.753351 | 0.000000 | -1.753351 |
| 517922b53a55ff0cf7c8003d92894107 | Acinetobacter | 1.716004 | 0.000000 | -1.716004 |
| 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 5.796674 | 4.138922 | -1.657752 |
| a582a45cc296a1d3b0c246a7d7611c78 | Chryseotalea | 2.482604 | 0.927981 | -1.554623 |
| 65cec2df56c73456e1c3add61ec09286 | Candidatus_Desulfobacillus | 1.688485 | 0.361469 | -1.327017 |

**R2 上升（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 5.145362 | 44.705311 | 39.559949 |
| a582a45cc296a1d3b0c246a7d7611c78 | Chryseotalea | 0.687758 | 4.243359 | 3.555601 |
| 8412dda0621215ae8fc8fb832616106e | Dechloromonas | 0.314737 | 2.531646 | 2.216909 |
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.258783 | 1.942055 | 1.683272 |

**R2 下降（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 6.499895 | 0.000000 | -6.499895 |
| b45dc3d21bfd0b6968e3baf5c5a3c883 | Candidatus_Competibacter | 4.818968 | 0.608609 | -4.210359 |
| 3b387d0f00c00f016a9c8aed15d5fa74 | Candidatus_Kapaibacterium | 3.515725 | 0.378268 | -3.137458 |
| cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 3.459772 | 0.355022 | -3.104750 |
| f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | 2.818642 | 0.000000 | -2.818642 |
| 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 2.454946 | 0.000000 | -2.454946 |
| 87206ae071ee47ee82d60398b551c3b7 | Incertae_Sedis | 1.895414 | 0.000000 | -1.895414 |
| 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 2.345371 | 0.486042 | -1.859329 |
| d1a24fd7f12ac5dd5f767a56cfdd46cd | Acinetobacter | 1.823141 | 0.000000 | -1.823141 |
| 517922b53a55ff0cf7c8003d92894107 | Acinetobacter | 1.398830 | 0.000000 | -1.398830 |

**R3 上升（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 5.996562 | 11.915883 | 5.919322 |
| 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 7.036993 | 8.285966 | 1.248973 |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.044463 | 1.116176 | 1.071713 |

**R3 下降（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 6.020275 | 1.217476 | -4.802799 |
| 4f94d1e38fabc2d3d55b8b1f652dbdf3 | Incertae_Sedis | 3.823808 | 1.765247 | -2.058562 |
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 15.019564 | 13.148367 | -1.871197 |

**R4 上升（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 2.932565 | 7.840022 | 4.907457 |
| e5bf038beab1833287d740ff5edfbf53 | Phototrophicus | 0.620440 | 2.911930 | 2.291490 |
| 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | 1.222289 | 3.007807 | 1.785518 |
| 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 1.384951 | 2.873579 | 1.488628 |
| b815668a1e362dc6a897d2895c351449 | Acinetobacter | 0.027885 | 1.254623 | 1.226738 |
| be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.206813 | 1.364197 | 1.157383 |

**R4 下降（Top10）**

| feature_id | genus | from_pct | to_pct | delta_pp |
|---|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 55.395734 | 38.904260 | -16.491474 |
| f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | 9.627271 | 5.845775 | -3.781497 |
| 50b7f9ff4b0b0982cd6d774ae12c979c | OLB8 | 1.598736 | 0.000000 | -1.598736 |
| 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 1.336153 | 0.000000 | -1.336153 |

### Q3：R3后期较小变化的组成支撑及相邻间隔比较

共同高丰度ASV可以维持较大共享量，低丰度或成员检出仍可更替；下面使用全部ASV的共享量1−Bray及Top10贡献份额核对。不存在凭低距离证明运行稳态的推断。

| pair_id | shared_identical_ASV_overlap | common_high_ASVs | common_high_shared_overlap | Top10_Bray_share |
|---|---|---|---|---|
| R3_d30_d76 | 0.635591 | 11 | 0.402022 | 0.542957 |
| R3_d76_d145 | 0.780757 | 14 | 0.548316 | 0.460437 |

同区间其他反应器对照（复用模块1.3，R1缺30d）：

| reactor_from | day_from | day_to | interval_days | Bray_Curtis | Jaccard_binary | Hellinger | CLR_pc05_at_min_depth |
|---|---|---|---|---|---|---|---|
| R1 | 76 | 145 | 69 | 0.481130 | 0.621212 | 0.738401 | 56.69747 |
| R2 | 30 | 76 | 46 | 0.474600 | 0.681690 | 0.668447 | 58.57834 |
| R2 | 76 | 145 | 69 | 0.605949 | 0.675567 | 0.846946 | 62.31221 |
| R3 | 30 | 76 | 46 | 0.364409 | 0.694181 | 0.580588 | 53.58059 |
| R3 | 76 | 145 | 69 | 0.219243 | 0.682243 | 0.384525 | 48.93511 |
| R4 | 30 | 76 | 46 | 0.443766 | 0.638838 | 0.573146 | 50.52609 |
| R4 | 76 | 145 | 69 | 0.343384 | 0.722397 | 0.531619 | 57.15861 |

### Q4/Q5：关键贡献ASV与已审阅功能连接

下表为各指定对Top3贡献ASV（全Top10及全量见TSV）。功能原样连接模块1.2，不把距离贡献叫作功能过程贡献。未命中既有功能规则的ASV继续未分配；未知属照常计入ASV距离。

| pair_id | feature_id | genus | contribution | share | exclusive_partition | proposed_guild |
|---|---|---|---|---|---|---|
| R2_R4_d1 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.344025 | 0.393392 | GAO_supported | GAO |
| R2_R4_d1 | 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 0.075484 | 0.086316 | PAO_ambiguous | PAO_historical_claim_unresolved |
| R2_R4_d1 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.062424 | 0.071382 | GAO_supported | GAO |
| R2_R4_d30 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.150131 | 0.182872 | GAO_supported | GAO |
| R2_R4_d30 | 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 0.105081 | 0.127997 | PAO_ambiguous | PAO_historical_claim_unresolved |
| R2_R4_d30 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.067088 | 0.081719 | GAO_supported | GAO |
| R2_R4_d76 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.251252 | 0.312387 | GAO_supported | GAO |
| R2_R4_d76 | f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | 0.046085 | 0.057298 | GAO_supported | GAO |
| R2_R4_d76 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.045951 | 0.057132 | GAO_supported | GAO |
| R2_R4_d145 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | 0.043356 | 0.099553 | GAO_supported | GAO |
| R2_R4_d145 | f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | 0.029490 | 0.067713 | GAO_supported | GAO |
| R2_R4_d145 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.029005 | 0.066601 | GAO_supported | GAO |
| R1_R2_d1 | a578dfb348f923c17e372f94df5716ef | NA | 0.057123 | 0.133868 | Taxonomy_insufficient | NA |
| R1_R2_d1 | 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 0.031516 | 0.073858 | PAO_ambiguous | PAO_historical_claim_unresolved |
| R1_R2_d1 | 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | 0.015700 | 0.036794 | PAO_ambiguous | PAO_historical_claim_unresolved |
| R1_R2_d76 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | 0.050375 | 0.104828 | Unmapped_named_taxa | NA |
| R1_R2_d76 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 0.043310 | 0.090125 | Taxonomy_insufficient | NA |
| R1_R2_d76 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.025727 | 0.053536 | GAO_supported | GAO |
| R1_R2_d145 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.223431 | 0.287393 | GAO_supported | GAO |
| R1_R2_d145 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 0.139536 | 0.179481 | Taxonomy_insufficient | NA |
| R1_R2_d145 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | 0.046822 | 0.060226 | Unmapped_named_taxa | NA |
| R3_d30_d76 | 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | 0.030923 | 0.084859 | GAO_supported | GAO |
| R3_d30_d76 | 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 0.029315 | 0.080445 | Unmapped_named_taxa | NA |
| R3_d30_d76 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.029147 | 0.079985 | Unmapped_named_taxa | NA |
| R3_d76_d145 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 0.029597 | 0.134995 | Unmapped_named_taxa | NA |
| R3_d76_d145 | 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 0.024014 | 0.109532 | Unmapped_named_taxa | NA |
| R3_d76_d145 | 4f94d1e38fabc2d3d55b8b1f652dbdf3 | Incertae_Sedis | 0.010293 | 0.046947 | Taxonomy_insufficient | NA |
| R2_d76_d145 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | 0.197800 | 0.326430 | GAO_supported | GAO |
| R2_d76_d145 | 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | 0.032499 | 0.053634 | PAO_ambiguous | PAO_historical_claim_unresolved |
| R2_d76_d145 | b45dc3d21bfd0b6968e3baf5c5a3c883 | Candidatus_Competibacter | 0.021052 | 0.034742 | GAO_supported | GAO |

#### R2/R4末期：相同ASV重叠与仅属标签重叠

同ASV重叠=属内Σmin(pF4_i,pH4_i)，属标签重叠=min(ΣpF4_i,ΣpH4_i)；后者可掩盖属内ASV替换。不是同一物种/菌株或独立生态复现的证明。

| genus | abundance_a | abundance_b | shared_identical_ASV_overlap | genus_label_overlap | asv_sum_bray_contribution | genus_aggregated_bray_contribution | within_genus_cancellation |
|---|---|---|---|---|---|---|---|
| Candidatus_Competibacter | 0.503476 | 0.541570 | 0.419293 | 0.503476 | 0.103230 | 0.019047 | 0.084183 |
| Defluviicoccus | 0.120982 | 0.068073 | 0.025706 | 0.068073 | 0.068821 | 0.026455 | 0.042367 |
| Acinetobacter | 0.002430 | 0.016107 | 0.002430 | 0.002430 | 0.006839 | 0.006839 | 0.000000 |

**Candidatus_Competibacter：末期相同ASV共享量Top5（全reads百分比）**

| feature_id | F4_pct | H4_pct | identical_ASV_overlap_pct |
|---|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | 44.705311 | 38.904260 | 38.904260 |
| f23e2ebe64cf70326440deb743f4bf85 | 1.942055 | 7.840022 | 1.942055 |
| f0e953dd2a7892838f44fea2495a408f | 0.488155 | 5.845775 | 0.488155 |
| 3e1088366bf860effa27b1322906df56 | 0.486042 | 1.079304 | 0.486042 |
| 8f515894604634120cb1a11157f1452a | 1.570127 | 0.032872 | 0.032872 |

**Defluviicoccus：末期相同ASV共享量Top5（全reads百分比）**

| feature_id | F4_pct | H4_pct | identical_ASV_overlap_pct |
|---|---|---|---|
| 82c70888e3f2436874633b4285a188e9 | 10.101224 | 1.429941 | 1.429941 |
| 78c2842bcb5d089b057f231ddd53b8e1 | 0.834725 | 3.007807 | 0.834725 |
| 2c5b844d921fe7862f8b9a693dd58f59 | 0.938273 | 0.164361 | 0.164361 |
| 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.090869 | 0.767018 | 0.090869 |
| 04d049f97a33adaae3128cb935e40acb | 0.040151 | 0.232845 | 0.040151 |

**Acinetobacter：末期相同ASV共享量Top5（全reads百分比）**

| feature_id | F4_pct | H4_pct | identical_ASV_overlap_pct |
|---|---|---|---|
| b815668a1e362dc6a897d2895c351449 | 0.243021 | 1.254623 | 0.243021 |
| 01f67510c9467e6977f78ada7fe518be | 0.000000 | 0.000000 | 0.000000 |
| 02f9466a555a33981d76faca9db4b19c | 0.000000 | 0.000000 | 0.000000 |
| 0394bf1cd766ac4d52fa9865ac40e1a2 | 0.000000 | 0.000000 | 0.000000 |
| 051f8e7ecff2478e781d0af627e72bc9 | 0.000000 | 0.000000 | 0.000000 |

#### 三目标属内主要ASV：各反应器/基线与后期的比例

主要ASV固定每属G4全15记录均值Top5。下表ASV_pct是全部reads比例均值，within_genus_pct是该阶段ASV均值/属均值；后期包含R1两记录、其他三记录，非独立重复均值、非按天数加权。逐节点及全ASV见轨迹表。

**Candidatus_Competibacter / R1**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R1 | baseline | 1 | 3cae56af0b082bba9c858d1844913fc3 | 0.0544 | 0.1963 | 27.7108 |
| R1 | baseline | 1 | 3e1088366bf860effa27b1322906df56 | 0.0828 | 0.1963 | 42.1687 |
| R1 | baseline | 1 | f23e2ebe64cf70326440deb743f4bf85 | 0.0166 | 0.1963 | 8.4337 |
| R1 | baseline | 1 | f0e953dd2a7892838f44fea2495a408f | 0.0000 | 0.1963 | 0.0000 |
| R1 | baseline | 1 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0237 | 0.1963 | 12.0482 |
| R1 | post_adaptation | 2 | 3cae56af0b082bba9c858d1844913fc3 | 0.0095 | 1.8889 | 0.5036 |
| R1 | post_adaptation | 2 | 3e1088366bf860effa27b1322906df56 | 0.3181 | 1.8889 | 16.8389 |
| R1 | post_adaptation | 2 | f23e2ebe64cf70326440deb743f4bf85 | 0.0144 | 1.8889 | 0.7637 |
| R1 | post_adaptation | 2 | f0e953dd2a7892838f44fea2495a408f | 0.0000 | 1.8889 | 0.0000 |
| R1 | post_adaptation | 2 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.2680 | 1.8889 | 14.1893 |

**Candidatus_Competibacter / R2**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R2 | baseline | 1 | 3cae56af0b082bba9c858d1844913fc3 | 1.8374 | 3.3188 | 55.3640 |
| R2 | baseline | 1 | 3e1088366bf860effa27b1322906df56 | 0.1780 | 3.3188 | 5.3640 |
| R2 | baseline | 1 | f23e2ebe64cf70326440deb743f4bf85 | 1.1889 | 3.3188 | 35.8238 |
| R2 | baseline | 1 | f0e953dd2a7892838f44fea2495a408f | 0.0381 | 3.3188 | 1.1494 |
| R2 | baseline | 1 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0540 | 3.3188 | 1.6284 |
| R2 | post_adaptation | 3 | 3cae56af0b082bba9c858d1844913fc3 | 16.6724 | 23.8937 | 69.7776 |
| R2 | post_adaptation | 3 | 3e1088366bf860effa27b1322906df56 | 1.5533 | 23.8937 | 6.5008 |
| R2 | post_adaptation | 3 | f23e2ebe64cf70326440deb743f4bf85 | 0.7685 | 23.8937 | 3.2165 |
| R2 | post_adaptation | 3 | f0e953dd2a7892838f44fea2495a408f | 0.3146 | 23.8937 | 1.3165 |
| R2 | post_adaptation | 3 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 2.5528 | 23.8937 | 10.6839 |

**Candidatus_Competibacter / R3**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R3 | baseline | 1 | 3cae56af0b082bba9c858d1844913fc3 | 0.7487 | 1.2174 | 61.4973 |
| R3 | baseline | 1 | 3e1088366bf860effa27b1322906df56 | 0.3233 | 1.2174 | 26.5597 |
| R3 | baseline | 1 | f23e2ebe64cf70326440deb743f4bf85 | 0.0911 | 1.2174 | 7.4866 |
| R3 | baseline | 1 | f0e953dd2a7892838f44fea2495a408f | 0.0000 | 1.2174 | 0.0000 |
| R3 | baseline | 1 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0000 | 1.2174 | 0.0000 |
| R3 | post_adaptation | 3 | 3cae56af0b082bba9c858d1844913fc3 | 0.6993 | 10.8807 | 6.4271 |
| R3 | post_adaptation | 3 | 3e1088366bf860effa27b1322906df56 | 8.8088 | 10.8807 | 80.9580 |
| R3 | post_adaptation | 3 | f23e2ebe64cf70326440deb743f4bf85 | 0.4224 | 10.8807 | 3.8822 |
| R3 | post_adaptation | 3 | f0e953dd2a7892838f44fea2495a408f | 0.0175 | 10.8807 | 0.1609 |
| R3 | post_adaptation | 3 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0044 | 10.8807 | 0.0402 |

**Candidatus_Competibacter / R4**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R4 | baseline | 1 | 3cae56af0b082bba9c858d1844913fc3 | 70.6425 | 73.4516 | 96.1756 |
| R4 | baseline | 1 | 3e1088366bf860effa27b1322906df56 | 0.1533 | 73.4516 | 0.2087 |
| R4 | baseline | 1 | f23e2ebe64cf70326440deb743f4bf85 | 1.7890 | 73.4516 | 2.4356 |
| R4 | baseline | 1 | f0e953dd2a7892838f44fea2495a408f | 0.3040 | 73.4516 | 0.4139 |
| R4 | baseline | 1 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0000 | 73.4516 | 0.0000 |
| R4 | post_adaptation | 3 | 3cae56af0b082bba9c858d1844913fc3 | 41.4976 | 55.5820 | 74.6601 |
| R4 | post_adaptation | 3 | 3e1088366bf860effa27b1322906df56 | 0.7962 | 55.5820 | 1.4324 |
| R4 | post_adaptation | 3 | f23e2ebe64cf70326440deb743f4bf85 | 6.2869 | 55.5820 | 11.3111 |
| R4 | post_adaptation | 3 | f0e953dd2a7892838f44fea2495a408f | 6.5036 | 55.5820 | 11.7010 |
| R4 | post_adaptation | 3 | b45dc3d21bfd0b6968e3baf5c5a3c883 | 0.0055 | 55.5820 | 0.0099 |

**Defluviicoccus / R1**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R1 | baseline | 1 | 82c70888e3f2436874633b4285a188e9 | 9.7845 | 14.3847 | 68.0204 |
| R1 | baseline | 1 | 78c2842bcb5d089b057f231ddd53b8e1 | 1.5941 | 14.3847 | 11.0819 |
| R1 | baseline | 1 | 2c5b844d921fe7862f8b9a693dd58f59 | 1.7407 | 14.3847 | 12.1013 |
| R1 | baseline | 1 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.4636 | 14.3847 | 3.2226 |
| R1 | baseline | 1 | 1061f034d9e9c9880bf2febf607da036 | 0.0000 | 14.3847 | 0.0000 |
| R1 | post_adaptation | 2 | 82c70888e3f2436874633b4285a188e9 | 4.9678 | 9.2732 | 53.5714 |
| R1 | post_adaptation | 2 | 78c2842bcb5d089b057f231ddd53b8e1 | 2.4430 | 9.2732 | 26.3452 |
| R1 | post_adaptation | 2 | 2c5b844d921fe7862f8b9a693dd58f59 | 0.7548 | 9.2732 | 8.1394 |
| R1 | post_adaptation | 2 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.4682 | 9.2732 | 5.0493 |
| R1 | post_adaptation | 2 | 1061f034d9e9c9880bf2febf607da036 | 0.0000 | 9.2732 | 0.0000 |

**Defluviicoccus / R2**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R2 | baseline | 1 | 82c70888e3f2436874633b4285a188e9 | 12.7889 | 17.3984 | 73.5063 |
| R2 | baseline | 1 | 78c2842bcb5d089b057f231ddd53b8e1 | 1.2589 | 17.3984 | 7.2355 |
| R2 | baseline | 1 | 2c5b844d921fe7862f8b9a693dd58f59 | 2.6067 | 17.3984 | 14.9826 |
| R2 | baseline | 1 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.2225 | 17.3984 | 1.2790 |
| R2 | baseline | 1 | 1061f034d9e9c9880bf2febf607da036 | 0.0000 | 17.3984 | 0.0000 |
| R2 | post_adaptation | 3 | 82c70888e3f2436874633b4285a188e9 | 11.7722 | 15.7359 | 74.8106 |
| R2 | post_adaptation | 3 | 78c2842bcb5d089b057f231ddd53b8e1 | 1.3193 | 15.7359 | 8.3841 |
| R2 | post_adaptation | 3 | 2c5b844d921fe7862f8b9a693dd58f59 | 2.0627 | 15.7359 | 13.1082 |
| R2 | post_adaptation | 3 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.1832 | 15.7359 | 1.1644 |
| R2 | post_adaptation | 3 | 1061f034d9e9c9880bf2febf607da036 | 0.0456 | 15.7359 | 0.2899 |

**Defluviicoccus / R3**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R3 | baseline | 1 | 82c70888e3f2436874633b4285a188e9 | 1.1393 | 6.7577 | 16.8593 |
| R3 | baseline | 1 | 78c2842bcb5d089b057f231ddd53b8e1 | 3.6544 | 6.7577 | 54.0784 |
| R3 | baseline | 1 | 2c5b844d921fe7862f8b9a693dd58f59 | 0.2886 | 6.7577 | 4.2710 |
| R3 | baseline | 1 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.5772 | 6.7577 | 8.5421 |
| R3 | baseline | 1 | 1061f034d9e9c9880bf2febf607da036 | 0.4253 | 6.7577 | 6.2942 |
| R3 | post_adaptation | 3 | 82c70888e3f2436874633b4285a188e9 | 3.6485 | 24.4806 | 14.9034 |
| R3 | post_adaptation | 3 | 78c2842bcb5d089b057f231ddd53b8e1 | 14.0860 | 24.4806 | 57.5394 |
| R3 | post_adaptation | 3 | 2c5b844d921fe7862f8b9a693dd58f59 | 0.5699 | 24.4806 | 2.3282 |
| R3 | post_adaptation | 3 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 1.7569 | 24.4806 | 7.1768 |
| R3 | post_adaptation | 3 | 1061f034d9e9c9880bf2febf607da036 | 1.4849 | 24.4806 | 6.0656 |

**Defluviicoccus / R4**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R4 | baseline | 1 | 82c70888e3f2436874633b4285a188e9 | 0.3040 | 1.4623 | 20.7904 |
| R4 | baseline | 1 | 78c2842bcb5d089b057f231ddd53b8e1 | 0.4724 | 1.4623 | 32.3024 |
| R4 | baseline | 1 | 2c5b844d921fe7862f8b9a693dd58f59 | 0.1005 | 1.4623 | 6.8729 |
| R4 | baseline | 1 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.1985 | 1.4623 | 13.5739 |
| R4 | baseline | 1 | 1061f034d9e9c9880bf2febf607da036 | 0.0000 | 1.4623 | 0.0000 |
| R4 | post_adaptation | 3 | 82c70888e3f2436874633b4285a188e9 | 1.3458 | 5.4087 | 24.8824 |
| R4 | post_adaptation | 3 | 78c2842bcb5d089b057f231ddd53b8e1 | 1.9744 | 5.4087 | 36.5036 |
| R4 | post_adaptation | 3 | 2c5b844d921fe7862f8b9a693dd58f59 | 0.1766 | 5.4087 | 3.2652 |
| R4 | post_adaptation | 3 | 1dca1ecb147e4cc7af6154eeb4627fe4 | 0.7067 | 5.4087 | 13.0658 |
| R4 | post_adaptation | 3 | 1061f034d9e9c9880bf2febf607da036 | 0.2961 | 5.4087 | 5.4745 |

**Acinetobacter / R1**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R1 | baseline | 1 | 3b91d8fd7dc57a941d49bed1b084064d | 8.9544 | 39.6064 | 22.6084 |
| R1 | baseline | 1 | 9d94363a8ab81a79ecf766644aa45b23 | 9.6805 | 39.6064 | 24.4417 |
| R1 | baseline | 1 | f23982138e4d5ed3fcb068cbac95af41 | 7.6299 | 39.6064 | 19.2643 |
| R1 | baseline | 1 | a21463e7f09e30cd1a22ddb77596a3a7 | 3.5619 | 39.6064 | 8.9932 |
| R1 | baseline | 1 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 6.0902 | 39.6064 | 15.3768 |
| R1 | post_adaptation | 2 | 3b91d8fd7dc57a941d49bed1b084064d | 0.8767 | 13.7216 | 6.3890 |
| R1 | post_adaptation | 2 | 9d94363a8ab81a79ecf766644aa45b23 | 3.7858 | 13.7216 | 27.5902 |
| R1 | post_adaptation | 2 | f23982138e4d5ed3fcb068cbac95af41 | 1.6059 | 13.7216 | 11.7036 |
| R1 | post_adaptation | 2 | a21463e7f09e30cd1a22ddb77596a3a7 | 0.2752 | 13.7216 | 2.0055 |
| R1 | post_adaptation | 2 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 1.0850 | 13.7216 | 7.9075 |

**Acinetobacter / R2**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R2 | baseline | 1 | 3b91d8fd7dc57a941d49bed1b084064d | 5.8143 | 39.2345 | 14.8193 |
| R2 | baseline | 1 | 9d94363a8ab81a79ecf766644aa45b23 | 15.9837 | 39.2345 | 40.7389 |
| R2 | baseline | 1 | f23982138e4d5ed3fcb068cbac95af41 | 6.4246 | 39.2345 | 16.3750 |
| R2 | baseline | 1 | a21463e7f09e30cd1a22ddb77596a3a7 | 1.7007 | 39.2345 | 4.3348 |
| R2 | baseline | 1 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 4.9560 | 39.2345 | 12.6317 |
| R2 | post_adaptation | 3 | 3b91d8fd7dc57a941d49bed1b084064d | 7.8811 | 17.7276 | 44.4570 |
| R2 | post_adaptation | 3 | 9d94363a8ab81a79ecf766644aa45b23 | 3.3760 | 17.7276 | 19.0440 |
| R2 | post_adaptation | 3 | f23982138e4d5ed3fcb068cbac95af41 | 1.2705 | 17.7276 | 7.1666 |
| R2 | post_adaptation | 3 | a21463e7f09e30cd1a22ddb77596a3a7 | 1.8724 | 17.7276 | 10.5621 |
| R2 | post_adaptation | 3 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 1.1783 | 17.7276 | 6.6467 |

**Acinetobacter / R3**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R3 | baseline | 1 | 3b91d8fd7dc57a941d49bed1b084064d | 2.1723 | 13.1594 | 16.5073 |
| R3 | baseline | 1 | 9d94363a8ab81a79ecf766644aa45b23 | 4.4617 | 13.1594 | 33.9050 |
| R3 | baseline | 1 | f23982138e4d5ed3fcb068cbac95af41 | 2.2764 | 13.1594 | 17.2988 |
| R3 | baseline | 1 | a21463e7f09e30cd1a22ddb77596a3a7 | 0.7400 | 13.1594 | 5.6234 |
| R3 | baseline | 1 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 1.8055 | 13.1594 | 13.7203 |
| R3 | post_adaptation | 3 | 3b91d8fd7dc57a941d49bed1b084064d | 1.5807 | 3.1678 | 49.8999 |
| R3 | post_adaptation | 3 | 9d94363a8ab81a79ecf766644aa45b23 | 0.2918 | 3.1678 | 9.2101 |
| R3 | post_adaptation | 3 | f23982138e4d5ed3fcb068cbac95af41 | 0.1126 | 3.1678 | 3.5548 |
| R3 | post_adaptation | 3 | a21463e7f09e30cd1a22ddb77596a3a7 | 0.3518 | 3.1678 | 11.1043 |
| R3 | post_adaptation | 3 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 0.1087 | 3.1678 | 3.4311 |

**Acinetobacter / R4**

| reactor | stage | n_records | feature_id | ASV_pct | genus_pct | within_genus_pct |
|---|---|---|---|---|---|---|
| R4 | baseline | 1 | 3b91d8fd7dc57a941d49bed1b084064d | 0.4096 | 2.5880 | 15.8252 |
| R4 | baseline | 1 | 9d94363a8ab81a79ecf766644aa45b23 | 0.8870 | 2.5880 | 34.2718 |
| R4 | baseline | 1 | f23982138e4d5ed3fcb068cbac95af41 | 0.4472 | 2.5880 | 17.2816 |
| R4 | baseline | 1 | a21463e7f09e30cd1a22ddb77596a3a7 | 0.2035 | 2.5880 | 7.8641 |
| R4 | baseline | 1 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 0.4171 | 2.5880 | 16.1165 |
| R4 | post_adaptation | 3 | 3b91d8fd7dc57a941d49bed1b084064d | 0.1271 | 1.6344 | 7.7796 |
| R4 | post_adaptation | 3 | 9d94363a8ab81a79ecf766644aa45b23 | 0.5111 | 1.6344 | 31.2747 |
| R4 | post_adaptation | 3 | f23982138e4d5ed3fcb068cbac95af41 | 0.1800 | 1.6344 | 11.0115 |
| R4 | post_adaptation | 3 | a21463e7f09e30cd1a22ddb77596a3a7 | 0.0158 | 1.6344 | 0.9677 |
| R4 | post_adaptation | 3 | d1a24fd7f12ac5dd5f767a56cfdd46cd | 0.1100 | 1.6344 | 6.7299 |

## 敏感性：各问题的支持与分歧

直接提取模块1.3全部所需敏感性，未再抽样或变换。Bray_rarefied_*沿用31457 reads×100次、seed=20261104；区间是读数子抽样范围，不是生物学置信区间。Hellinger=sqrt(p) Euclidean；CLR在共同最小深度期望count上加0.5/1、log后中心化。低检出Bray全样本总reads≥10、Jaccard每样本count≥5为原固定方案，仅敏感性，主分析全ASV。

| pair_id | Bray_Curtis | Bray_rarefied_mean | Bray_rarefied_p025 | Bray_rarefied_p975 | Jaccard_binary | Jaccard_rarefied_mean | Bray_global_reads_ge10 | Jaccard_per_sample_reads_ge5 |
|---|---|---|---|---|---|---|---|---|
| R2_R4_d1 | 0.874510 | 0.874588 | 0.873204 | 0.876040 | 0.802326 | 0.801972 | 0.873877 | 0.767045 |
| R2_R4_d30 | 0.820961 | 0.821501 | 0.819510 | 0.823376 | 0.774775 | 0.773925 | 0.819690 | 0.732777 |
| R2_R4_d76 | 0.804296 | 0.804475 | 0.801982 | 0.806722 | 0.795014 | 0.793512 | 0.802831 | 0.735354 |
| R2_R4_d145 | 0.435510 | 0.435911 | 0.433155 | 0.437904 | 0.773684 | 0.772094 | 0.429668 | 0.714563 |
| R1_R2_d1 | 0.426713 | 0.426948 | 0.424371 | 0.429795 | 0.776886 | 0.775324 | 0.421941 | 0.714988 |
| R1_R2_d76 | 0.480549 | 0.481817 | 0.478913 | 0.485623 | 0.725594 | 0.723534 | 0.476634 | 0.669725 |
| R1_R2_d145 | 0.777441 | 0.777997 | 0.775311 | 0.780867 | 0.752000 | 0.750392 | 0.776160 | 0.723519 |
| R3_d30_d76 | 0.364409 | 0.365266 | 0.362304 | 0.367936 | 0.694181 | 0.691354 | 0.356424 | 0.541568 |
| R3_d76_d145 | 0.219243 | 0.220477 | 0.216346 | 0.223687 | 0.682243 | 0.675671 | 0.209035 | 0.518605 |
| R2_d76_d145 | 0.605949 | 0.606770 | 0.603313 | 0.609691 | 0.675567 | 0.674159 | 0.602883 | 0.611111 |

### 方法间方向与局部排序（按实际数值判断）

| series | metric | d76 | d145 | delta | direction |
|---|---|---|---|---|---|
| R2_R4 | Bray_Curtis | 0.804296 | 0.435510 | -0.368787 | decrease |
| R2_R4 | Jaccard_binary | 0.795014 | 0.773684 | -0.021330 | decrease |
| R2_R4 | Hellinger | 1.026748 | 0.706211 | -0.320538 | decrease |
| R2_R4 | CLR_pc05_at_min_depth | 72.332725 | 67.459766 | -4.872960 | decrease |
| R2_R4 | CLR_pc1_at_min_depth | 59.513584 | 54.291389 | -5.222195 | decrease |
| R2_R4 | Bray_rarefied_mean | 0.804475 | 0.435911 | -0.368564 | decrease |
| R2_R4 | Bray_global_reads_ge10 | 0.802831 | 0.429668 | -0.373163 | decrease |
| R2_R4 | Jaccard_per_sample_reads_ge5 | 0.735354 | 0.714563 | -0.020790 | decrease |

| series | metric | d76 | d145 | delta | direction |
|---|---|---|---|---|---|
| R1_R2 | Bray_Curtis | 0.480549 | 0.777441 | 0.296892 | increase |
| R1_R2 | Jaccard_binary | 0.725594 | 0.752000 | 0.026406 | increase |
| R1_R2 | Hellinger | 0.780109 | 1.089697 | 0.309588 | increase |
| R1_R2 | CLR_pc05_at_min_depth | 68.670680 | 68.313318 | -0.357362 | decrease |
| R1_R2 | CLR_pc1_at_min_depth | 56.024526 | 55.614925 | -0.409602 | decrease |
| R1_R2 | Bray_rarefied_mean | 0.481817 | 0.777997 | 0.296180 | increase |
| R1_R2 | Bray_global_reads_ge10 | 0.476634 | 0.776160 | 0.299526 | increase |
| R1_R2 | Jaccard_per_sample_reads_ge5 | 0.669725 | 0.723519 | 0.053794 | increase |

R3同区间距离由小到大排名（不是统计检验）：

| interval | metric | R3_value | R3_rank_smallest | available_reactors | smallest_reactor |
|---|---|---|---|---|---|
| 30_to_76 | Bray_Curtis | 0.364409 | 1 | 3 | R3 |
| 30_to_76 | Jaccard_binary | 0.694181 | 3 | 3 | R4 |
| 30_to_76 | Hellinger | 0.580588 | 2 | 3 | R4 |
| 30_to_76 | CLR_pc05_at_min_depth | 53.580587 | 2 | 3 | R4 |
| 30_to_76 | CLR_pc1_at_min_depth | 41.770587 | 2 | 3 | R4 |
| 76_to_145 | Bray_Curtis | 0.219243 | 1 | 4 | R3 |
| 76_to_145 | Jaccard_binary | 0.682243 | 3 | 4 | R1 |
| 76_to_145 | Hellinger | 0.384525 | 1 | 4 | R3 |
| 76_to_145 | CLR_pc05_at_min_depth | 48.935105 | 1 | 4 | R3 |
| 76_to_145 | CLR_pc1_at_min_depth | 37.224774 | 1 | 4 | R3 |

因此，R3丰度加权变化较小的描述必须限定指标和节点；较高Jaccard说明检出成员并未同等持续。CLR强调低丰度相对关系，不能把Bray结果泛化为log-ratio稳定。R2/R4末段不同指标即使方向相同，其全程幅度与单调性仍须逐列看，不能称成员全面趋同。

## B. 已确认条件与来源依赖

R1/R3=30℃，R2/R4=室温未知数值；四份初始污泥均不同。各自经历的历史混合块及保存恢复均保留。G4各反应器为不平衡纵向记录，实际独立实验单位远少于15行，不能把四份起始状态不同当独立来源证明。全低DO后期相同设定不提供DO处理对照，也不提供温差定量信息。

## C. 可能生态解释（待验证）

共享优势ASV比例变得接近可以解释丰度距离的算术下降；初始群落差异、运行选择与随机组成变化均可能形成这种轨迹。属内ASV更替与属总比例持续可以并存。R3若高丰度相同ASV维持，可与较小丰度加权距离相容；低丰度成员更替仍可较大。这里的‘解释’仅是组成层面的相容性，不能升级为温度选择、竞争或功能冗余机制的实证。

## D. 本批不能验证的因果假设与局限

不能直接认定室温导致R2/R4趋同或30℃使R1/R2分化，也不能认定低DO造成分化。温度分配、反应器个体、初始污泥/群落、共享混合来源和重复测量共同限制效应识别；室温具体值未知，不量化温差，不拟合不可识别温度模型。无无约束PERMANOVA、ANOVA、相关显著性、共现网络。

16S ASV读数比例不是绝对丰度、活菌量或功能活性；相同短扩增子ASV不保证同一菌株，未分类/--other不强赋功能。Competibacter/Defluviicoccus沿用GAO关联，Acinetobacter/Dechloromonas保留PAO歧义，Nitrospira保留NOB/comammox，Thauera保留特定菌株证据限制；不新增功能声称或重检索功能映射。

未知提取/PCR/测序子批次、16S拷贝数与检测差异仍可能影响比例和Jaccard。共享相同ASV组成量不是独立重复或活性证明，距离端点分解无因果方向、没有推断性p值。运行稳态需性能记录核验。

## 文件与复现

- [G4设计审核](g4_design_addendum.md)、[派生metadata](analysis_metadata_addendum.tsv)。
- [10对完整ASV贡献](focal_pairwise_asv_contributions.tsv)、[属两算法贡献](focal_pairwise_genus_contributions.tsv)。
- [完整15节点ASV轨迹](focal_asv_abundance_trajectories.tsv)、[原功能连接及选择标记](focal_asv_function_annotations.tsv)。
- [全ASV时间变化/类别](focal_temporal_asv_changes.tsv)、[复用距离及敏感性](focal_distance_summary.tsv)。
- [R2/R4图PDF](R2_R4_convergence.pdf) / [PNG](R2_R4_convergence.png)；[R1/R2图PDF](R1_R2_divergence.pdf) / [PNG](R1_R2_divergence.png)；[R3图PDF](R3_late_composition_persistence.pdf) / [PNG](R3_late_composition_persistence.png)。
- [run.log](run.log)：实际运行及检查；本analysis_report.md为唯一综合计算报告。

命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/g4_asv_contributions.R`。新版本复现加`--output-dir 尚不存在的新版本目录`。只允许既有目录内预先审核文件，其他任何产物存在即拒绝覆盖。新目录复用最初设计审核作为确认依据副本，不改正式文档。

脚本SHA-256：3635424f5211a18f9692dec9d2f8aa2c2b48ded90f514fb2dce8d4bd60766f27

输入指纹（正式设计是追加补充后的版本；补充前指纹在设计审核中）：

以下表格为首次计算时的历史输入路径与指纹，原记录保留；其中旧目录现已迁移，当前路径/指纹见文末“v2命名统一记录”。这不是重新运行记录。

| input | path | bytes | sha256 |
|---|---|---|---|
| counts | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| object | results/phyloseq/batch_01_phyloseq.rds | 1031084 | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| metadata | results/community_composition/2026-11-03_v2/analysis_metadata.tsv | 27015 | f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd |
| genus | results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv | 252609 | 4f1477feb2bdd702c0b72a44154069bfaa65f82dd84eff4e2ea78221ea19a0ad |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| annotation | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| functional_taxa | results/functional_guilds/2026-11-03_v2/functional_taxa_abundance.tsv | 120604 | c1f3bf03023cf5387012a27c921e1ec17d1da320726ab9d7d038b144077048fd |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| report13 | results/diversity/2026-11-04_v2/analysis_report.md | 32226 | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| sensitivity | results/diversity/2026-11-04_v2/pairwise_sensitivity.tsv | 137200 | 1529011d0af4d090ce62326e185546bbfb9c5d3b3544c2f92b10b22c2dc43d4d |
| bray | results/diversity/2026-11-04_v2/bray_curtis_distance.tsv | 19754 | c3a4be200b5842ad4b45b1baa6e2ed7304c823aac74fc4a5162dc9f50ff672d6 |
| jaccard | results/diversity/2026-11-04_v2/jaccard_distance.tsv | 19626 | ef429af40b2139805c43d097e57b01515008147de9ea71c7c767a27a1f2bc0e9 |
| within | results/diversity/2026-11-04_v2/G4_within_reactor_changes.tsv | 6791 | b0b559356c5b47b27cc61e99077d39211e94064b201b6c4c00cc84b931b283ea |
| between | results/diversity/2026-11-04_v2/G4_same_day_between_reactors.tsv | 6639 | 027a9bfc5e469924fe8107bb3798f48204a16d73240c770827b49826fb06af26 |
| sensitivity_summary | results/diversity/2026-11-04_v2/sensitivity_summary.tsv | 1715 | cdaa90fb1bbc52ca290e6d38633a24f84e3e6d706624c91e41aca552c4b12e78 |
| design | docs/batch_01/experiment_design.md | 17995 | 6ba285b5b071b81af0a9223359a526eb83a91f1d73abe46594d0ba39363344ba |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| plan | docs/batch_01/analysis_plan.md | 11043 | 93135a524706432a24f23ab637c410883f540ecfc5449e92c7940b13cba456a5 |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| audit | results/asv_contributions/2026-11-05_v1/g4_design_addendum.md | 4255 | 76fb202933b4f36fce0545cf6d21288e320911454e5d359c5be7d1682fb08a89 |

| tool | version |
|---|---|
| R | R version 4.5.2 (2025-10-31) |
| digest | 0.6.39 |
| ggplot2 | 4.0.3 |

完整会话信息：
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
 [1] digest_0.6.39      labeling_0.4.3     RColorBrewer_1.1-3 R6_2.6.1          
 [5] tidyselect_1.2.1   farver_2.1.2       magrittr_2.0.5     gtable_0.3.6      
 [9] glue_1.8.1         tibble_3.3.1       pkgconfig_2.0.3    dplyr_1.2.1       
[13] generics_0.1.4     lifecycle_1.0.5    cli_3.6.6          S7_0.2.2          
[17] scales_1.4.0       grid_4.5.2         vctrs_0.7.3        withr_3.0.3       
[21] compiler_4.5.2     pillar_1.11.1      rlang_1.3.0       
```

## 程序实际检查

| status | item | evidence |
|---|---|---|
| PASS | 环境 | 仅复用现有R/digest/ggplot2，不安装软件。 |
| PASS | 输入存在 | 原始count/taxonomy、三个有效v2及设计/审核均存在。 |
| PASS | 有效版本来源 | 原输入、RDS及组成/功能v2输入SHA-256逐项匹配模块1.3有效v2报告；不使用历史v1。 |
| PASS | 分析输入格式 | 5510×33非负整数count、ID唯一、无NA/空样本；已有深度QC由指纹复用，不重新筛查异常。 |
| PASS | 原metadata完整性 | 原33行14列逐值保留；派生表只追加字段。 |
| PASS | 样本级设计门控 | 33完整ID及8/2/4/15/4；15个G4节点/反应器/前源/阶段/设置逐项匹配。R1无30d不插补。 |
| PASS | taxonomy与功能连接 | 全部5510 ASV完整原谱系、原Confidence及功能v2逐项相符；不修改taxonomy或重映射功能。代表序列沿用已验证指纹。 |
| PASS | 派生条件边界 | 保留全部旧45列；新增18列。G4恒温目标7行30℃，室温8行目标NA；全部实测/污泥编号/具体性状NA；前源和历史混合块保留。 |
| PASS | analysis_metadata_addendum.tsv 回读 | 33 行；字段及全部数值列往返一致。 |
| WARNING | 科研推断门控关闭 | 四份G4起始污泥不同、四反应器重复测量、混合谱系/保存恢复依赖，温度与个体/初始状态混杂；不拟合模型或做显著性/网络。 |
| WARNING | 温度/DO/稳态 | 室温数值与实测温度、瞬时DO未知；运行条件标签不回推恢复期实测。后期是设计稳定运行期，性能稳态记录未审阅。 |
| PASS | 距离复用核验 | 10对Bray/Jaccard/Hellinger/两CLR/深度及低检出敏感性直接提取模块1.3；仅核对ASV贡献和=既有Bray，无全流程Beta重算。 |
| PASS | focal_distance_summary.tsv 回读 | 10 行；字段及全部数值列往返一致。 |
| PASS | ASV/属分解恒等式 | 10对各保留5510 ASV（含双零）；Σ/pA−pB//2=原Bray。属内累计≥属总量先求差；差额=属标签共享量−同ASV共享量。未分类按原父谱系分别保留。 |
| PASS | focal_pairwise_asv_contributions.tsv 回读 | 55100 行；字段及全部数值列往返一致。 |
| PASS | focal_pairwise_genus_contributions.tsv 回读 | 6330 行；字段及全部数值列往返一致。 |
| PASS | 时间变化方向与守恒 | 5个同期跨时段差额+11个反应器内相邻转移，全ASV保留。差额=后贡献−前贡献；缩小负、扩大正。区间天数保留，不作因果/动力学速率。 |
| PASS | focal_temporal_asv_changes.tsv 回读 | 88160 行；字段及全部数值列往返一致。 |
| PASS | focal_asv_function_annotations.tsv 回读 | 5510 行；字段及全部数值列往返一致。 |
| PASS | focal_asv_abundance_trajectories.tsv 回读 | 82650 行；字段及全部数值列往返一致。 |
| PASS | R2_R4_convergence 图层 | 三面板实际构建；PDF/PNG；ASV完整ID、百分比分母和有符号变化可读取。 |
| PASS | R1_R2_divergence 图层 | 三面板实际构建；PDF/PNG；ASV完整ID、百分比分母和有符号变化可读取。 |
| PASS | R3_late_composition_persistence 图层 | 三面板实际构建；PDF/PNG；ASV完整ID、百分比分母和有符号变化可读取。 |
| PASS | 输入与历史结果保护 | 96 个原输入/有效v2/设计/审核/脚本逐一SHA-256保持不变。 |

本次主流程：22 PASS / 2 WARNING / 0 FAIL。

完成：2026-11-05 15:56:56 CST；用时9.869秒。独立交付核验后续追加，独立计数。


## 2026-11-05 独立复核后的科学结论（Q1–Q5）

### A. 直接计算的组成证据

**Q1，R2/R4末段趋近：**76→145d的Bray由0.804296降至0.435510，净变化−0.368787。所有ASV差缩小项合计−0.558551，差扩大项+0.189765；二者共同决定净变化，不能只挑缩小项。

最主要差缩小ASV为`3cae56af0b082bba9c858d1844913fc3`（Candidatus_Competibacter，沿用GAO关联）：R2/F3→F4为5.1454%→44.7053%，R4/H3→H4为55.3957%→38.9043%。两端绝对差由50.2504降至5.8011个百分点，对应ΔBray贡献−0.222247。它在R2上升、R4下降后接近；不是“两边都升高”。Acinetobacter ASV `9d94363a8ab81a79ecf766644aa45b23`两端均降至0，也使差距缩小（−0.025819），说明距离下降既可来自共同优势ASV，也可来自原差异ASV共同消退。Chryseotalea `a582a45cc296a1d3b0c246a7d7611c78`等差扩大项仍存在，不能宣称群落全面相同。

**Q2，R1/R2末段分化：**Bray 0.480549→0.777441，净增+0.296892；扩大项+0.502648，缩小项−0.205756。同一Competibacter ASV在R1/E2→E3仅0→0.0190%，在R2的变化为5.1454%→44.7053%（仅描述），使端点差扩大，对应Δ贡献+0.197705。故R2一次丰度重排同时关联“与R4趋近”和“与R1分化”，两种现象不矛盾。

第二大差扩大ASV `d1725130559823512a63bbc2c1bab523`的原属标签为Incertae_Sedis（Sphingobacteriaceae谱系，分类不足/未分配功能）：R1 9.4429%→28.1100%，R2 0.7810%→0.2029%，Δ贡献+0.096226。不能将Incertae_Sedis当作唯一明确生物属或强配功能。Acinetobacter `b815668a1e362dc6a897d2895c351449`在R1 0.7823%→8.5061%、R2 0.0979%→0.2430%，Δ贡献+0.037894；R1该属总量同期18.49%→8.96%下降，而此ASV上升，直接展示属总量不能替代属内ASV分析。

**Q3，R3较小丰度加权变化：**30→76d、76→145d Bray为0.364409、0.219243，相同ASV共享组成量分别0.635591、0.780757。末段有14个ASV两端均≥1%，其共享组成量合计0.548316。Defluviicoccus ASV `78c2842bcb5d089b057f231ddd53b8e1`为14.0900%→15.0196%→13.1484%，`82c70888e3f2436874633b4285a188e9`为3.7726%→3.6104%→3.5624%；这些相同ASV持续较高比例，与较小丰度距离相容。

R3仍有变化：Chryseotalea `be9af24f8e82484720783bcb4df4f6de`末段5.9966%→11.9159%，Aridibacter `54089b19ce1b3690c1e03d4d34a0162c`为6.0203%→1.2175%，分别贡献末段Bray 0.029597和0.024014；二者沿用功能未分配。不能由较小整体距离推断所有ASV不变、成员稳定或性能稳态。

**Q4/Q5，同属与相同ASV的区别：**R2/R4末期总共享组成量=1−Bray=0.564490。Competibacter属总比例50.3476%/54.1570%，同ASV共享量41.9293%，其中核心`3cae56af0b082bba9c858d1844913fc3`单独共享38.9043%；相似性确有同ASV支撑，不只是同属标签。但该属ASV累计Bray贡献0.103230，属总量先求差只有0.019047，属内差异仍大。

Defluviicoccus属总比例12.0982%/6.8073%，属标签共享量6.8073%，真正同ASV共享量仅2.5706%；ASV贡献0.068821，而属总量差贡献0.026455。R2末期该属主要为`82c70888e3f2436874633b4285a188e9`（10.1012%），R4该ASV1.4299%，R4另一主要ASV为`78c2842bcb5d089b057f231ddd53b8e1`（3.0078%）。不能把Defluviicoccus属标签一致称为相同属内群落。Acinetobacter末期同ASV共享量仅0.2430%，主要对应`b815668a1e362dc6a897d2895c351449`，不能用其解释主要趋近。

三目标属主要ASV已固定按每属G4全15记录等权均值Top5，分别列出四反应器的基线及后期比例、属内占比；全15节点和全部5510 ASV轨迹均保留。Competibacter/Defluviicoccus仅沿用GAO关联，Acinetobacter保持PAO歧义；Nitrospira、Dechloromonas、Thauera分别保留原功能歧义或菌株证据限制。贡献大的未映射类群不强行赋功能。

### 敏感性限定

- R2/R4末段Bray、Hellinger、两CLR和Jaccard均下降，但Jaccard仅0.795014→0.773684，且全程波动；CLR0.5基线63.82331、末期67.45977，末期仍大于基线。因此支持的是特定末段丰度趋近，不能推广为全程单调、成员全面或全方法同幅度趋同。
- R1/R2末段Bray和Hellinger增大，Jaccard0.725594→0.752000；两CLR却略降（0.5：68.67068→68.31332；1：56.02453→55.61492）。分化描述不在log-ratio尺度得到同方向支持。
- R3末段Bray、Hellinger、两CLR均为同期四反应器最小；30→76d只有Bray最小，Hellinger/CLR的R4更小。R3两段Jaccard0.694181/0.682243，排名分别为3/3和3/4（由小到大），不支持成员持续性最强。
- 深度和低检出结果直接复用模块1.3，未重跑全流程。距离共享样本，排名和方向为描述，不提供p值或温度效应估计。

### B. 条件、C. 生态解释与D. 因果边界

已确认R1/R3 30℃保温、R2/R4室温运行；四份G4起始污泥性状与初始菌群均不一致。可能的组成层面解释是优势ASV份额重排及属内更替；初始差异、条件选择和随机组成变化都可能产生观察轨迹，但这不是机制验证。历史混合均分、4℃59天保存恢复、反应器内重复测量及初始状态/个体差异使温度效应难以独立估计。实际室温未知，不量化温差，不认定温度导致趋近或低DO导致分化。16S比例不等于绝对丰度、活菌数、功能基因或活性。批次、扩增及拷贝数偏倚仍未分离，运行稳态证据待核验。


## 2026-11-05 独立交付核验（主流程22/2/0之外另列）

- PASS：Python标准库从原始count逐格复核全部55,100行ASV贡献、6,330行谱系属贡献、88,160行时间变化、82,650行轨迹；最大ASV数值误差4.996×10⁻¹⁶。全部ASV/样本唯一覆盖、贡献排序、两端高丰度/1个百分点阈值、属内Top5与份额均核对。
- PASS：模块1.2原16列功能注释逐字符保留（5510行）；旧派生metadata原45列逐值保留，新增18列33行；原metadata仍33×14。温度/起始污泥缺失边界和8/2/4/15/4分组再次核对。
- PASS：10对所有敏感性数值逐项与模块1.3原表相同；仅贡献计算，未重新生成Alpha/Beta距离全矩阵或功能映射。
- PASS：3 PNG逐块CRC及IDAT像素流解压、2400×2560尺寸，3 PDF头尾完整。实际打开全部3图检查，完整ASV ID和热图数字可读取。图第一行部分最左/最右距离数值标注被分面边界截断，曲线/点/刻度及ASV标签未丢失；精确距离以focal_distance_summary.tsv为准，不从截断标签读取数值。本次保留原图及其记录，不覆盖已产出的图件。
- PASS：重复执行入口在写入前非零退出，16个产物SHA-256均不变。任务前139个既有科研文件均不变，正式实验设计、analysis_log及results_interpretation的原字节前缀保留；设计仅按用户已确认内容追加。原始输入、历史/有效v2、对象及其他已有脚本不变。
- WARNING：底层Fontconfig提示using without calling FcInit()由执行器stderr观察，R sink未捕获，现如实追加run.log；数据、图层和文件完整性核验均通过。未安装软件。
- 交付16文件：7 TSV、3对PDF/PNG、设计审核、中文综合报告和run.log；无项目中间文件。具体起始污泥登记编号/性状、室温实测、恢复/基线温度适用范围和性能稳态记录待人工补充，无新增科研假设的实证。

最终归档 2026-11-05 16:03:19 Asia/Shanghai：201本地链接/锚点有效，16文件齐全，脚本指纹匹配；139既有科研文件未变，设计/日志/解释历史前缀保留。三份项目文档已同步；仅本次/tmp快照清理。


## v2命名统一记录（2026-11-05，当前有效）

用户明确要求v1仅作历史，若实际输入为v2则名称全部统一v2。本次核对两模块44项历史输入指纹，确认使用组成/功能2026-11-03_v2和多样性2026-11-04_v2，模块2.2沿用相同有效链；执行命名迁移，不删除或重新计算科学分析。

| 迁移前历史路径 | 当前有效路径 |
|---|---|
| results/asv_contributions/2026-11-05_v1 | results/asv_contributions/2026-11-05_v2 |
| results/candidate_asvs/2026-11-05_v1 | results/candidate_asvs/2026-11-05_v2 |

迁移时间：2026-11-05 16:54:58 Asia/Shanghai。当前入口为results/asv_contributions/2026-11-05_v2；上文报告当前路径及项目导航已更新，首次运行的时间与历史输入指纹表原样保留。历史表内v1路径按本映射回查，不能再将其作为当前输入。旧目录已迁移，不留两个可混淆的当前副本。

**实际核验范围：**9份非metadata TSV和8个PDF/PNG逐字节一致，数值、样本/ASV ID、候选名单、阈值与科学结论未改；模块2.1派生metadata仅33个版本标签及30个审核文件路径单元格变化，原45列完整不变。原count、taxonomy、FASTA、原metadata、RDS、模块1.1–1.3历史及有效v2结果均未改。

脚本只更新默认目录、当前来源及版本标签，并显式锁定v2、禁止向v1输出。两个脚本语法解析通过；两脚本现有目录/旧v1输出共4项拒绝写入检查通过，23个产物保持不变。这些是路径维护核验，不是新的科研计算PASS。

旧脚本运行指纹保留在原计算记录；当前维护后脚本`scripts/g4_asv_contributions.R` SHA-256：`8224e0cdc70a3de3e9b7e30cbd5472bbaee9a1912019fb3e1262d8d318548920`。本次未声称新脚本重新执行了此前的科学计算。

### 当前输入路径与指纹（命名维护后的快照）

下表供新路径复现和下游来源核验；它与上方首次运行的历史指纹表分别保留。设计/计划变动只涉及版本政策和链接维护，审核为追加状态，派生metadata变动只涉及来源/版本文本。

| input | path | bytes | sha256 |
|---|---|---|---|
| counts | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| object | results/phyloseq/batch_01_phyloseq.rds | 1031084 | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| metadata | results/community_composition/2026-11-03_v2/analysis_metadata.tsv | 27015 | f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd |
| genus | results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv | 252609 | 4f1477feb2bdd702c0b72a44154069bfaa65f82dd84eff4e2ea78221ea19a0ad |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| annotation | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| functional_taxa | results/functional_guilds/2026-11-03_v2/functional_taxa_abundance.tsv | 120604 | c1f3bf03023cf5387012a27c921e1ec17d1da320726ab9d7d038b144077048fd |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| report13 | results/diversity/2026-11-04_v2/analysis_report.md | 32226 | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| sensitivity | results/diversity/2026-11-04_v2/pairwise_sensitivity.tsv | 137200 | 1529011d0af4d090ce62326e185546bbfb9c5d3b3544c2f92b10b22c2dc43d4d |
| bray | results/diversity/2026-11-04_v2/bray_curtis_distance.tsv | 19754 | c3a4be200b5842ad4b45b1baa6e2ed7304c823aac74fc4a5162dc9f50ff672d6 |
| jaccard | results/diversity/2026-11-04_v2/jaccard_distance.tsv | 19626 | ef429af40b2139805c43d097e57b01515008147de9ea71c7c767a27a1f2bc0e9 |
| within | results/diversity/2026-11-04_v2/G4_within_reactor_changes.tsv | 6791 | b0b559356c5b47b27cc61e99077d39211e94064b201b6c4c00cc84b931b283ea |
| between | results/diversity/2026-11-04_v2/G4_same_day_between_reactors.tsv | 6639 | 027a9bfc5e469924fe8107bb3798f48204a16d73240c770827b49826fb06af26 |
| sensitivity_summary | results/diversity/2026-11-04_v2/sensitivity_summary.tsv | 1715 | cdaa90fb1bbc52ca290e6d38633a24f84e3e6d706624c91e41aca552c4b12e78 |
| design | docs/batch_01/experiment_design.md | 18558 | 59113eaaea346995e649000d562b647e3fd65d3690e93083b164dbcfbb31b755 |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| plan | docs/batch_01/analysis_plan.md | 11784 | 65f7406f2e4b650503f24d3c0f3e1787d9d5d9bac4e98160cfa60c4c02534b44 |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| audit | results/asv_contributions/2026-11-05_v2/g4_design_addendum.md | 5116 | 6f68f620cc13ea2076903ebfcd01074cfa413738e21c931ef833bf29a8c17d18 |

### 本模块产物迁移核验

| 当前文件 | 迁移前SHA-256 | 当前SHA-256 | 核验说明 |
|---|---|---|---|
| R1_R2_divergence.pdf | 0e30017ec7df88b97a15aa49dee2940d3958dd667ce41bb122e7f6dc13c528a2 | 0e30017ec7df88b97a15aa49dee2940d3958dd667ce41bb122e7f6dc13c528a2 | 逐字节不变 |
| R1_R2_divergence.png | 24eec31f2276107ea871f2db0fbaf0f1ede7550df15e54abed0262499fe87529 | 24eec31f2276107ea871f2db0fbaf0f1ede7550df15e54abed0262499fe87529 | 逐字节不变 |
| R2_R4_convergence.pdf | d9d792d841e863768d4681708b4b5d080830266cbd860a257b3c48f9e9d6dfa4 | d9d792d841e863768d4681708b4b5d080830266cbd860a257b3c48f9e9d6dfa4 | 逐字节不变 |
| R2_R4_convergence.png | e631d31dabf46409616e1282123834e2193740fe45beec9a54e6574fec7c5add | e631d31dabf46409616e1282123834e2193740fe45beec9a54e6574fec7c5add | 逐字节不变 |
| R3_late_composition_persistence.pdf | a915cea27aad7aae187c273d351e691a01425a2b715504dc69b61f20e1d1ed5f | a915cea27aad7aae187c273d351e691a01425a2b715504dc69b61f20e1d1ed5f | 逐字节不变 |
| R3_late_composition_persistence.png | 63f64f07533f62578860ad021a72522f74a869cb8df4e82f2b666c416051d3a2 | 63f64f07533f62578860ad021a72522f74a869cb8df4e82f2b666c416051d3a2 | 逐字节不变 |
| analysis_metadata_addendum.tsv | 3cee9ca213d715772744ebf89ba315ac73dc1b97cafcc597cdb382a41776dfc6 | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 | 仅63个来源/版本文本单元格 |
| focal_asv_abundance_trajectories.tsv | 7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 | 7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 | 逐字节不变 |
| focal_asv_function_annotations.tsv | 079b43a1d5a1546ee0f7145fc43a232d0c5cffcba32e77b2194cc37456ab81b9 | 079b43a1d5a1546ee0f7145fc43a232d0c5cffcba32e77b2194cc37456ab81b9 | 逐字节不变 |
| focal_distance_summary.tsv | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b | 逐字节不变 |
| focal_pairwise_asv_contributions.tsv | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e | 逐字节不变 |
| focal_pairwise_genus_contributions.tsv | e691efe6f04844db1c1dc6eff5c8e9b4fce9c348a687de05b48af94f97999bad | e691efe6f04844db1c1dc6eff5c8e9b4fce9c348a687de05b48af94f97999bad | 逐字节不变 |
| focal_temporal_asv_changes.tsv | dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 | dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 | 逐字节不变 |
| g4_design_addendum.md | 4a4f0caf88b6cd4070ca5e9746b3f6bf78215e9a5bc94f8f202ea3755b4db393 | 6f68f620cc13ea2076903ebfcd01074cfa413738e21c931ef833bf29a8c17d18 | 追加本次命名迁移记录，历史审核保留 |

原日志字节前缀完整保留，尾部追加迁移记录；报告新增明确的当前v2声明、历史指纹说明和本节。科研结论与局限不变；不将命名统一当作修复了未验证的功能/温度因果或图件展示限制。
