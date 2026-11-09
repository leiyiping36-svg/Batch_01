# 模块2.6：重点候选ASV共同演替及生态证据综合分析（V2）

运行开始：2026-11-09T09:55:35+08:00（Asia/Shanghai）；输出：`results/focal_asv_cosuccession/2026-11-09_v2`。

**三个固定单元的描述性分析完成；功能、性能、互作及温度/DO因果推断门控保持关闭。** 本文共同演替指同一已记录运行实体中多个ASV的组成变化并列，不代表统计相关、共现网络或相互作用。

## 检查报告、有效输入及方法

先阅读AGENTS、背景/设计/计划/执行日志及模块1.1–2.5有效v2报告，核对真实文件、格式和ID后固定方案。33样本、G1–G5=8/2/4/15/4；10个对象及A/B/C=5/6/5不重筛。全部33样本相对丰度直接提取模块2.4已有列，G4的150个目标观测与模块2.1已有轨迹/count逐值核对；原整数计数只用于比例一致性、测序分母与预定log-ratio支持检查，沿用旧深度QC，不新增异常筛查。taxonomy/ASV/FASTA的5510个ID一致，既有指纹完整；不重新运行DADA2、SILVA、功能映射、Alpha/Beta、筛选或MiDAS比对。

贡献及差额直接复用模块2.1：单ASV c=|pA−pB|/2，跨反应器Δc=c晚−c早；正为端点差扩大，负为缩小。单ASV份额=c/既有Bray。以下固定子集求和仅是数学份额，不能当机制解释率。净Δ份额可能因缩小/扩大相抵超过100%，不是概率或独立证据。R3两个相邻区间长度不同（46/69d），距离不除天数、不当累计周转或动力学速率。

图为16个独立纵轴轨迹面板及2个末段Δc摘要；百分比以全部ASV reads为分母。实际节点有点；R1第30天无点，1→76d处断线，未插补；其余连线仅帮助阅读端点。SILVA旧属标签与MiDAS保守审核并列，代码定位不是新命名属；完整解释见下表与证据表。G1/G2G3、G4及G5不连成统一时间轴。

## 分类与功能证据边界

| 对象 | 原SILVA标签 | MiDAS保守解释（模块2.5原文） | 最佳identity/coverage%；并列数 | 功能状态 |
|---|---|---|---|---|
| C02 | Incertae_Sedis | 保守命名层级Sphingobacteriales目；MiDAS操作定位AKYH767/midas_g_9646（全片段100%）；SILVA科名与MiDAS不一致，非已鉴定属，功能未知。 | 100.0/100.0; n=1 | FUNCTION_UNKNOWN |
| C04 | Chryseotalea | 保守命名层级Cytophagales目；MiDAS操作定位Microscillaceae/midas_g_85782（全片段100%）；不支持套用Chryseotalea Ys生理。 | 100.0/100.0; n=1 | FUNCTION_UNKNOWN |
| C05 | Aridibacter | 保守到Blastocatellaceae科；MiDAS最佳Blastocatella，1个百分点近邻跨Blastocatella/Aridibacter；短16S不能裁定属或定种。 | 98.762/100.0; n=9 | FUNCTION_UNKNOWN |
| C10 | Chryseosolibacter | 保守命名层级Cytophagales目；MiDAS候选Microscillaceae，最佳93.617%且跨多个代码属并列；不确认Chryseosolibacter属。 | 93.617/100.0; n=2 | FUNCTION_UNKNOWN |
| C09 | NA | 保守命名层级Rhodobacterales目；原Paracoccaceae与MiDAS Rhodobacteraceae版本名称并列保留；7条100%跨Rhodobacter/Tabrizicola，不能改善为唯一属。 | 100.0/100.0; n=7 | FUNCTION_UNKNOWN |
| N026 | Phototrophicus | 保守到Anaerolineae纲；MiDAS近邻SBR1031/Flexifilaceae/midas_g_29983（97.037%）；与Phototrophicus ZRK33仅79.506%，不支持光合身份。 | 97.037/100.0; n=2 | FUNCTION_UNKNOWN |
| N045 | Candidatus_Tepidaquicella | 保留Ignavibacteria/SJA-28关联；MiDAS操作定位midas_f_31/midas_g_171（全片段100%）；不确认Tepidaquicella命名属或Ch128a功能。 | 100.0/100.0; n=1 | FUNCTION_UNKNOWN |
| N072 | OLB8 | 支持Ca_Vicinibacter参考谱系关联（MiDAS midas_s_177），不定种；与affinis和proximus两参考MAG各两份16S拷贝全片段100%，不能仅凭旧OLB8代码套用其他分支。 | 100.0/100.0; n=6 | REFERENCE_SUPPORTED_POTENTIAL_NOT_ASV_VALIDATED |
| C01 | Candidatus_Competibacter | 支持Ca_Competibacter属谱系关联；MiDAS种标签仅记录命中，不作denitrificans种/菌株鉴定或本研究反硝化证据。 | 100.0/100.0; n=3 | GAO_RELATED_CONTROL_ONLY |
| C03 | Defluviicoccus | 支持Defluviicoccus属谱系关联；99.257%短片段匹配不确定参考cluster或物种，沿用GAO关联对照。 | 99.257/100.0; n=4 | GAO_RELATED_CONTROL_ONLY |

C02/C04/C05/C10/C09/N026/N045七个目标的具体功能全部UNKNOWN；C01/C03是GAO关联对照，不能当本ASV已测活性。N072只能引用Vicinibacter近缘参考谱系的异养/PHA及附着生态背景，本ASV的PHA、EPS、反硝化均未测，不能认定这些活性。旧OLB8不与Vicinibacter不同分支生理混用。

## A. R1/R2分化

| 对象 | R1实际节点轨迹（全部reads百分比） | R2实际节点轨迹（全部reads百分比） |
|---|---|---|
| C01 | E1@1d=0.0544% → E2@76d=0.0000% → E3@145d=0.0190% | F1@1d=1.8374% → F2@30d=0.1667% → F3@76d=5.1454% → F4@145d=44.7053% |
| C02 | E1@1d=0.0733% → E2@76d=9.4429% → E3@145d=28.1100% | F1@1d=0.1144% → F2@30d=0.1786% → F3@76d=0.7810% → F4@145d=0.2029% |
| C10 | E1@1d=0.3666% → E2@76d=10.1683% → E3@145d=9.5842% | F1@1d=0.0000% → F2@30d=0.0000% → F3@76d=0.0933% → F4@145d=0.2198% |
| C09 | E1@1d=0.0355% → E2@76d=0.0216% → E3@145d=0.0000% | F1@1d=11.4601% → F2@30d=3.3116% → F3@76d=1.5224% → F4@145d=0.1648% |
| N072 | E1@1d=3.9616% → E2@76d=4.5446% → E3@145d=0.0486% | F1@1d=0.8361% → F2@30d=2.2093% → F3@76d=3.4598% → F4@145d=0.3550% |

| 实际日 | 既有Bray | 既有Jaccard | 指定子集贡献和 | 子集占当日Bray |
|---|---|---|---|---|
| 1 | 0.426712837997813 | 0.776886035313002 | 0.083704 | 19.62% |
| 76 | 0.480549036484111 | 0.725593667546174 | 0.132339 | 27.54% |
| 145 | 0.777441138909923 | 0.752 | 0.412145 | 53.01% |

| ASV | 76d差距pp | 145d差距pp | 已有Δc | 方向 |
|---|---|---|---|---|
| C01 | 5.1454 | 44.6863 | +0.197705 | expanding |
| C02 | 8.6619 | 27.9071 | +0.096226 | expanding |
| C10 | 10.0750 | 9.3644 | -0.003553 | shrinking |
| C09 | 1.5008 | 0.1648 | -0.006680 | shrinking |
| N072 | 1.0848 | 0.3064 | -0.003892 | shrinking |

76→145d全群落既有Bray净变化=+0.296892；固定5对象Δc和=+0.279806，其余ASV净和=+0.017086。子集/整体净变化比=94.25%，仅为有符号分解；剩余成分未删除。

**具体发现。** R2的C01末段增加39.5599个百分点，R1的C02增加18.6671个百分点，均指读数比例，两者形成不同的末期组成。C10在R1 76d已较高、145d仍较高，R1/R2间该ASV差距末段略缩，不能把所有R1候选都称为末段扩大的来源。C09在R2由基线高比例持续下降；N072在R1/R2末段都下降，二者端点差缩小。固定目标中存在相反方向的贡献，分化不是所有目标同步分离。

**不能回答。** C02/C10能否利用某碳源、二者是否协作，C01是否因竞争而占优，温度或DO是否导致分化均不能回答；高比例/Δc不是活性或机制。

### 本单元五层证据整合

| 对象 | 1 本研究16S | 2 MiDAS | 3 已核实参考层级 | 4 允许的生态假设 | 5 不允许机制 |
|---|---|---|---|---|---|
| C01 | 上方实际比例/既有贡献 | Ca_Competibacter lineage | GAO参考谱系关联 | GAO关联对照的ASV组成持续或重排可作跨Batch描述性参照。 | 不能确证本ASV糖原/PHA活性、碳竞争、反硝化、除磷损失或与其他ASV的功能互作。 |
| C02 | 上方实际比例/既有贡献 | Sphingobacteriales; midas_g_9646 code | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| C10 | 上方实际比例/既有贡献 | Cytophagales; Microscillaceae candidate | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| C09 | 上方实际比例/既有贡献 | Rhodobacterales; genus unresolved | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N072 | 上方实际比例/既有贡献 | Ca_Vicinibacter lineage; no species | 近缘Vicinibacter参考MAG/原位细胞异养、PHA、附着背景 | 检验Vicinibacter关联ASV的组成轨迹是否跨Batch重现；参考异养/PHA及附着生态背景仅用于提出假设，本ASV具体功能未测。 | 不能认定本ASV的PHA、EPS、反硝化活性、底物交换、协作/竞争或功能互作；不能移用旧OLB8其他分支糖原结论。 |

## B. R3后期

| 对象 | R3实际节点轨迹（全部reads百分比） |
|---|---|
| C03 | G1@1d=3.6544% → G2@30d=14.0900% → G3@76d=15.0196% → G4@145d=13.1484% |
| C04 | G1@1d=0.0564% → G2@30d=0.1671% → G3@76d=5.9966% → G4@145d=11.9159% |
| C05 | G1@1d=17.6038% → G2@30d=5.4720% → G3@76d=6.0203% → G4@145d=1.2175% |
| N026 | G1@1d=2.4848% → G2@30d=1.1190% → G3@76d=2.2320% → G4@145d=2.8964% |
| N045 | G1@1d=0.5295% → G2@30d=1.1740% → G3@76d=7.0370% → G4@145d=8.2860% |
| N072 | G1@1d=1.2521% → G2@30d=0.5672% → G3@76d=2.5640% → G4@145d=1.7803% |

| 既有比较 | Bray | Jaccard | 指定6ASV贡献和 | 占原Bray份额 |
|---|---|---|---|---|
| R3_d30_d76 | 0.364409149712605 | 0.694181326116374 | 0.081400 | 22.34% |
| R3_d76_d145 | 0.219242704636518 | 0.682242990654206 | 0.076452 | 34.87% |

| ASV | 30→76d变化pp | 76→145d变化pp | 既有c(30,76) | 既有c(76,145) | 末段贡献份额 |
|---|---|---|---|---|---|
| C03 | +0.9295 | -1.8712 | 0.004648 | 0.009356 | 4.27% |
| C04 | +5.8295 | +5.9193 | 0.029147 | 0.029597 | 13.50% |
| C05 | +0.5483 | -4.8028 | 0.002741 | 0.024014 | 10.95% |
| N026 | +1.1130 | +0.6644 | 0.005565 | 0.003322 | 1.52% |
| N045 | +5.8630 | +1.2490 | 0.029315 | 0.006245 | 2.85% |
| N072 | +1.9968 | -0.7838 | 0.009984 | 0.003919 | 1.79% |

**具体发现。** C03在30/76/145d保持约13–15%的ASV比例，但其末段下降；C04连续升高，N045也在后期两段升高；N026由基线至30d下降，但在30→76→145d两段均升高。C05在30→76d小幅升、末段明显降，N072在后期先升后降。C04与N045的同向变化不等于协作，C04与C05末段反向也不等于竞争。六对象并非同步稳定：较小整体Bray与内部替换共存，Jaccard仍较高。C03只是Defluviicoccus中的一个ASV，不能用该属总量24%左右替代本ASV比例。

**不能回答。** 不能判断群落成员、代谢或运行性能已稳态，不能由C04/C05原属标签推断水解或硝酸盐利用，不能据N026/N045认定光合、DNRA或氮循环互作。

### 本单元五层证据整合

| 对象 | 1 本研究16S | 2 MiDAS | 3 已核实参考层级 | 4 允许的生态假设 | 5 不允许机制 |
|---|---|---|---|---|---|
| C03 | 上方实际比例/既有贡献 | Defluviicoccus lineage | GAO参考谱系关联 | GAO关联对照的ASV组成持续或重排可作跨Batch描述性参照。 | 不能确证本ASV糖原/PHA活性、碳竞争、反硝化、除磷损失或与其他ASV的功能互作。 |
| C04 | 上方实际比例/既有贡献 | Cytophagales; midas_g_85782 code | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| C05 | 上方实际比例/既有贡献 | Blastocatellaceae; genus unresolved | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N026 | 上方实际比例/既有贡献 | Anaerolineae; near midas_g_29983 | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N045 | 上方实际比例/既有贡献 | Ignavibacteria / SJA-28; midas_g_171 code | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N072 | 上方实际比例/既有贡献 | Ca_Vicinibacter lineage; no species | 近缘Vicinibacter参考MAG/原位细胞异养、PHA、附着背景 | 检验Vicinibacter关联ASV的组成轨迹是否跨Batch重现；参考异养/PHA及附着生态背景仅用于提出假设，本ASV具体功能未测。 | 不能认定本ASV的PHA、EPS、反硝化活性、底物交换、协作/竞争或功能互作；不能移用旧OLB8其他分支糖原结论。 |

## C. R2/R4趋近

| 对象 | R2实际节点轨迹（全部reads百分比） | R4实际节点轨迹（全部reads百分比） |
|---|---|---|
| C01 | F1@1d=1.8374% → F2@30d=0.1667% → F3@76d=5.1454% → F4@145d=44.7053% | H1@1d=70.6425% → H2@30d=30.1928% → H3@76d=55.3957% → H4@145d=38.9043% |
| C03 | F1@1d=1.2589% → F2@30d=1.6475% → F3@76d=1.4758% → F4@145d=0.8347% | H1@1d=0.4724% → H2@30d=1.6931% → H3@76d=1.2223% → H4@145d=3.0078% |
| N026 | F1@1d=0.0127% → F2@30d=0.0000% → F3@76d=0.0256% → F4@145d=0.4818% | H1@1d=1.7111% → H2@30d=1.2286% → H3@76d=0.6971% → H4@145d=1.5970% |
| N045 | F1@1d=0.0000% → F2@30d=0.0167% → F3@76d=0.1422% → F4@145d=0.1395% | H1@1d=0.6784% → H2@30d=0.7017% → H3@76d=1.3850% → H4@145d=2.8736% |
| N072 | F1@1d=0.8361% → F2@30d=2.2093% → F3@76d=3.4598% → F4@145d=0.3550% | H1@1d=0.0528% → H2@30d=0.0200% → H3@76d=0.1650% → H4@145d=0.0959% |

| 实际日 | 既有Bray | 既有Jaccard | 指定子集贡献和 | 子集占当日Bray |
|---|---|---|---|---|
| 1 | 0.874510400073655 | 0.802325581395349 | 0.363758 | 41.60% |
| 30 | 0.820961059765558 | 0.774774774774775 | 0.170873 | 20.81% |
| 76 | 0.804296484963175 | 0.795013850415512 | 0.278564 | 34.63% |
| 145 | 0.435509854839156 | 0.773684210526316 | 0.060413 | 13.87% |

| ASV | 76d差距pp | 145d差距pp | 已有Δc | 方向 |
|---|---|---|---|---|
| C01 | 50.2504 | 5.8011 | -0.222247 | shrinking |
| C03 | 0.2535 | 2.1731 | +0.009598 | expanding |
| N026 | 0.6715 | 1.1152 | +0.002219 | expanding |
| N045 | 1.2427 | 2.7341 | +0.007457 | expanding |
| N072 | 3.2948 | 0.2591 | -0.015178 | shrinking |

76→145d全群落既有Bray净变化=-0.368787；固定5对象Δc和=-0.218151，其余ASV净和=-0.150635。子集/整体净变化比=59.15%，仅为有符号分解；剩余成分未删除。

**具体发现。** C01在R2上升、R4下降，同一ASV的端点差明显缩小，Δc=-0.222247，占全群落Bray净下降幅度的60.26%（数学比值）。N072在两者都下降且差缩小，比例变得更接近可以来自共同降低。C03、N026与N045的差距末段均扩大；总体趋近不代表全部重点类群趋同。C01是A/C共有信号，R2的同一次重排同时关联两项距离变化，不是两次独立复现。

**不能回答。** 同为室温运行标签且有共同名义进水，仍不能排除初始污泥/谱系/个体/时间混杂，也不能证明环境筛选、GAO与辅助类群互作或去除功能趋同。N026/N045仍具体功能未知。

### 本单元五层证据整合

| 对象 | 1 本研究16S | 2 MiDAS | 3 已核实参考层级 | 4 允许的生态假设 | 5 不允许机制 |
|---|---|---|---|---|---|
| C01 | 上方实际比例/既有贡献 | Ca_Competibacter lineage | GAO参考谱系关联 | GAO关联对照的ASV组成持续或重排可作跨Batch描述性参照。 | 不能确证本ASV糖原/PHA活性、碳竞争、反硝化、除磷损失或与其他ASV的功能互作。 |
| C03 | 上方实际比例/既有贡献 | Defluviicoccus lineage | GAO参考谱系关联 | GAO关联对照的ASV组成持续或重排可作跨Batch描述性参照。 | 不能确证本ASV糖原/PHA活性、碳竞争、反硝化、除磷损失或与其他ASV的功能互作。 |
| N026 | 上方实际比例/既有贡献 | Anaerolineae; near midas_g_29983 | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N045 | 上方实际比例/既有贡献 | Ignavibacteria / SJA-28; midas_g_171 code | 出现背景/远缘或歧义生理，不能转移；具体功能UNKNOWN | 具体功能UNKNOWN；可跨Batch检验该固定ASV或可比片段谱系的组成伴随/替换模式，未知不等于无功能。 | 不能赋予该ASV储存、EPS、COD去除、光合/固碳、DNRA、反硝化或氮磷去除功能；远缘/歧义参考生理不转移。 |
| N072 | 上方实际比例/既有贡献 | Ca_Vicinibacter lineage; no species | 近缘Vicinibacter参考MAG/原位细胞异养、PHA、附着背景 | 检验Vicinibacter关联ASV的组成轨迹是否跨Batch重现；参考异养/PHA及附着生态背景仅用于提出假设，本ASV具体功能未测。 | 不能认定本ASV的PHA、EPS、反硝化活性、底物交换、协作/竞争或功能互作；不能移用旧OLB8其他分支糖原结论。 |

## 预定log-ratio：支持门控、零值及组成局限

仅预定三种ASV配对/四个实体序列，不扫描全群落配对、不做相关性、p值或网络。自然log(p分子/p分母)=同样本log(count分子/count分母)；样本总reads在该比值中消去。每个预定序列全部节点两ASV均≥5 reads才描述；任何节点0或1–4 reads则该序列全部NA，不用伪计数、不替换节点。阈值是描述支持约定，非统计检出限、可靠性概率或独立生物学重复。该比值减弱对其他成分闭合变化的依赖，但不能证明分子绝对增加/分母绝对减少，也不消除测序误差、16S拷贝/扩增偏倚或纵向混杂。

| 单元 | 实体 | 预定比值 | 两ASV跨节点最小reads | 自然log比值（实际节点） |
|---|---|---|---|---|
| A | R1 | C02/C10 | 4534 | E2=-0.0740 → E3=+1.0760 |
| B | R3 | C04/C03 | 76 | G2=-4.4347 → G3=-0.9182 → G4=-0.0984 |
| C | R2 | N072/C01 | 70 | F1=-0.7874 → F2=+2.5845 → F3=-0.3969 → F4=-4.8357 |
| C | R4 | N072/C01 | 8 | H1=-7.1995 → H2=-7.3208 → H3=-5.8164 → H4=-6.0058 |

WARNING：R4序列最小为8 reads（H2的N072），虽超过事先固定的5 reads门槛，仍对低计数/检出误差敏感，只保留探索性数值，不把它当稳健比值、趋势确证或额外独立证据；不因结果调整阈值或另换配对。

R1比值只比较76/145d的C02相对C10组成比；R3比值只描述C04相对C03的重排；R2/R4比值只描述N072相对C01的重排。相反方向或比值改变均不命名为协作、竞争、交叉营养或代谢替代。

## G1–G3轮次上下文与G5独立描述

330条观测包含全33样本、原轮次/实体/阶段和采样日依据。G1 day120为约数；G2/G3是混合均分后的同轮连续21→56d，不能补造R1/R3的21d或把G4跨4℃59d保存恢复接成连续运行。这里不把G1–G3数据并入G4轨迹/平均值/比值或估计独立重复。G4中未属于该对象固定研究单元的观测仅作上下文，不扩展单元。

| G4实体 | 保存前来源 | 恢复后基线 | 本单元对象：来源% / 基线%（非连续运行差值） |
|---|---|---|---|
| R1 | A2 | E1 | C02: 0.073 / 0.073；C10: 0.027 / 0.367；C09: 0.054 / 0.035；N072: 0.287 / 3.962；C01: 0.000 / 0.054 |
| R2 | B3 | F1 | C02: 0.714 / 0.114；C10: 0.000 / 0.000；C09: 7.727 / 11.460；N026: 0.024 / 0.013；N045: 0.000 / 0.000；N072: 0.103 / 0.836；C01: 0.425 / 1.837；C03: 1.131 / 1.259 |
| R3 | C2 | G1 | C04: 0.000 / 0.056；C05: 5.329 / 17.604；N026: 9.543 / 2.485；N045: 4.441 / 0.530；N072: 0.237 / 1.252；C03: 0.745 / 3.654 |
| R4 | D3 | H1 | N026: 0.768 / 1.711；N045: 0.184 / 0.678；N072: 0.037 / 0.053；C01: 86.928 / 70.642；C03: 0.139 / 0.472 |

G5只有G4-R1结束后延长18d的一次母样采样（163d来自原表推算），四个级分各一份。下表仅列固定10对象，不做级分均值、母样重建、显著性或跨反应器外推；G4温度标签不外推G5。

| 对象 | S1 <100 μm % | S2 100–200 μm % | S3 200–500 μm % | S4 >500 μm % |
|---|---|---|---|---|
| C02 | 7.3796 | 7.6783 | 13.0250 | 11.1282 |
| C04 | 0.1182 | 0.0502 | 0.0373 | 0.0156 |
| C05 | 0.0000 | 0.0114 | 0.0523 | 0.0223 |
| C10 | 4.9692 | 3.2366 | 1.2074 | 1.8923 |
| C09 | 0.0209 | 0.0000 | 0.0000 | 0.0000 |
| N026 | 0.0765 | 0.1894 | 0.1419 | 0.1966 |
| N045 | 0.0394 | 0.0548 | 0.0573 | 0.1072 |
| N072 | 0.0000 | 0.0000 | 0.0000 | 0.0201 |
| C01 | 1.1635 | 0.3447 | 1.8820 | 0.0290 |
| C03 | 2.6677 | 0.4314 | 0.9186 | 1.3963 |

G5中C02在S1–S4均为7.38%–13.03%，C10为1.21%–4.97%；N072在S1–S3为0 reads，S4仅9 reads（0.0201%）。这是ASV层面结果，不能把模块1.1中旧OLB8属标签在较大级分中的较高总比例当作N072的粒径富集；属标签包含其他ASV/谱系。N072本次分级记录不能确认其附着、成粒、PHA或EPS活性，也不能把C02等未知对象的级分比例改称具体功能。

## 可用于跨Batch核查的固定假设与不能回答的问题

后续仅利用可获得的批次16S及可靠设计记录核查以下组成假设，不新增功能验证实验任务。需先核对相同片段/ASV可比性、分类版本、轮次/实体与采样阶段；若片段不同不宣称同一ASV。跨Batch尚未执行，本批筛选后形成的假设不能冒称外部验证。

1. A：能否重现R1中C02相对C10增大，以及R2中C01份额增加的不同组成方向；C09/N072的下降是否同样出现。
2. B：能否重现C03保持较高比例、C04/N045上升与C05末段下降并存；N026/N072允许不同步。优先核查各对象实际方向，不要求“共同稳定”。
3. C：同一C01的差距缩小是否再次构成丰度加权趋近的主要数学来源，同时C03/N045可保留或扩大差异；N072的共同下降型趋近是否重现。
4. N072：在可比16S谱系与阶段中描述其与GAO关联对照的组成重排，参考异养/PHA及附着背景仅辅助生态假设，不将其升级为本ASV机制或新功能验证任务。

所有单元均不能识别温度或DO的独立因果效应、证明功能互作或代谢机制、评价COD/氮磷去除贡献或性能稳态。G4四份不同起始污泥、共享混合来源、保存恢复与不平衡纵向记录不构成独立重复；R1/R3=30℃、R2/R4室温实际未知，与个体/历史混杂。G1–G5统一名义配方不能充当同期进出水或去除率，也不能消除混杂。采样瞬时DO/温度全NA；恢复设置3与旧分析NA及design_document字段并列保留。提取/PCR/测序子批次效应、组成闭合、16S拷贝和检测偏倚尚不能分离；ASV比例不是绝对菌量，不乘VSS/MLVSS。

## PASS / WARNING / FAIL与实际产物

**本次必要交付检查：69 PASS / 5 WARNING / 0 FAIL。** 0 FAIL只表示描述性交付必需条件通过，功能/性能/独立因果及互作前提未通过；这些未执行步骤明确关闭。必要格式、设计、连接或保护检查失败返回非零退出码，不保存成功报告。

| 状态 | 实际检查 | 依据 |
|---|---|---|
| PASS | 输入存在 | 32个指定输入 |
| PASS | 有效v2指纹/asv_table.tsv | data/asv_table.tsv; SHA256=3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| PASS | 有效v2指纹/taxonomy.tsv | data/taxonomy.tsv; SHA256=b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| PASS | 有效v2指纹/dna-sequences.fasta | data/exported_sequences/dna-sequences.fasta; SHA256=a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| PASS | 有效v2指纹/source_sample_metadata.tsv | metadata/source_sample_metadata.tsv; SHA256=dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| PASS | 有效v2指纹/analysis_metadata_addendum.tsv | results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv; SHA256=acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| PASS | 有效v2指纹/analysis_metadata.tsv | results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv; SHA256=16f6e91b40ace510588002e3aac002901ef6c95921165efb0aaa87447e489254 |
| PASS | 有效v2指纹/focal_asv_abundance_trajectories.tsv | results/asv_contributions/2026-11-05_v2/focal_asv_abundance_trajectories.tsv; SHA256=7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 |
| PASS | 有效v2指纹/focal_pairwise_asv_contributions.tsv | results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv; SHA256=842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e |
| PASS | 有效v2指纹/focal_temporal_asv_changes.tsv | results/asv_contributions/2026-11-05_v2/focal_temporal_asv_changes.tsv; SHA256=dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 |
| PASS | 有效v2指纹/focal_distance_summary.tsv | results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv; SHA256=09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b |
| PASS | 有效v2指纹/all_asv_ecological_features.tsv | results/ecological_candidates/2026-11-07_v2/all_asv_ecological_features.tsv; SHA256=139b97bf64cb5ba5db980cea8a3f2676c0e4bd561cf42e12ef737f8e5102f012 |
| PASS | 有效v2指纹/candidate_priority_table.tsv | results/ecological_candidates/2026-11-07_v2/candidate_priority_table.tsv; SHA256=f7ec055e410bfbe3b66f79a46954cb652701201b5a961a5ec441cfa69b19bdc2 |
| PASS | 有效v2指纹/candidate_taxonomy_validation.tsv | results/candidate_ecology/2026-11-08_v2/candidate_taxonomy_validation.tsv; SHA256=a5103fee036c141c16c8de54453623beafa2d6c5186d10315063ed490be0dff2 |
| PASS | 有效v2指纹/candidate_ecological_roles.tsv | results/candidate_ecology/2026-11-08_v2/candidate_ecological_roles.tsv; SHA256=43dedc20977c2a9999700622beb4d90a8777b9534ad5119e92007d0dccb4b46a |
| PASS | 有效v2指纹/candidate_literature_evidence.tsv | results/candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv; SHA256=18fbafdeda1ccc0b4c70a86829cf9d3a362da9ea6deb2eeb76239bfd87868347 |
| PASS | 有效v2指纹/candidate_reference_genomes.tsv | results/candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv; SHA256=1ecc37b913c8f6a4cafcfcf57c5245c01634ecb1b3c6e1bba161533e5009b8e4 |
| PASS | 报告来源/community_composition | results/community_composition/2026-11-03_v2/analysis_report.md |
| PASS | 报告来源/functional_guilds | results/functional_guilds/2026-11-03_v2/analysis_report.md |
| PASS | 报告来源/diversity | results/diversity/2026-11-04_v2/analysis_report.md |
| PASS | 报告来源/asv_contributions | results/asv_contributions/2026-11-05_v2/analysis_report.md |
| PASS | 报告来源/candidate_asvs | results/candidate_asvs/2026-11-05_v2/analysis_report.md |
| PASS | 报告来源/operational_performance | results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md |
| PASS | 报告来源/ecological_candidates | results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md |
| PASS | 固定十对象 | C02;C04;C05;C10;C09;N026;N045;N072;C01;C03 |
| PASS | ASV映射唯一 | 8目标+2对照，不重筛 |
| PASS | 33样本身份 | 原表与有效2.1/2.3一一对应 |
| PASS | 原metadata保留 | 原14列及模块2.1全部63列逐值保留 |
| PASS | 设计名单/G1 | 权威完整名单唯一 |
| PASS | 分组/G1 | 8行逐ID一致 |
| PASS | 设计名单/G2 | 权威完整名单唯一 |
| PASS | 分组/G2 | 2行逐ID一致 |
| PASS | 设计名单/G3 | 权威完整名单唯一 |
| PASS | 分组/G3 | 4行逐ID一致 |
| PASS | 设计名单/G4 | 权威完整名单唯一 |
| PASS | 分组/G4 | 15行逐ID一致 |
| PASS | 设计名单/G5 | 权威完整名单唯一 |
| PASS | 分组/G5 | 4行逐ID一致 |
| PASS | G4实际节点 | 3/4/4/4；基线4+后期11；R1-30d不插补 |
| PASS | G4实体/保存/温度/初始差异 | 四不同起始状态；30℃与室温标签不用于因果估计 |
| PASS | 实测与性能门控 | 共同名义配方；无瞬时DO/温度及可匹配性能 |
| PASS | 配方及G5层级 | 一设计配方；G5一母样四级分 |
| PASS | 基线与后期 | 恢复后切换前与设计稳定期分列，性能稳态未验证 |
| PASS | 保存恢复与基线来源 | 四条直接前源逐ID；新G4实体；旧分析NA与恢复设置3分列 |
| PASS | 混合/连续/纵向层级 | G2/G3同轮、两共享混合块、G4另轮；G5延续R1但四级分仅一母样 |
| PASS | 原ASV范围 | 5510个ID中只提取10目标；不改变筛选 |
| PASS | 计数样本ID | 只核验本模块计算必需条件 |
| PASS | 计数必要条件 | 非负整数/无NA/无空样本；不重复深度异常QC |
| PASS | 330个原比例复用 | 全部reads分母；模块2.4比例与原计数一致，不重新归一化目标子集 |
| PASS | 上游Feature ID | 原taxonomy/FASTA/ASV表一致；序列QC沿用不变指纹 |
| PASS | 分类原值与保守解释 | 原SILVA及MiDAS审核逐字符复用，不覆盖taxonomy |
| PASS | 功能证据门控 | 7 UNKNOWN；N072只参考潜力；2 GAO关联对照；项目功能均未测 |
| PASS | 2.1轨迹复用 | 150个真实G4节点值/count/实体与2.4一致 |
| PASS | 既有贡献守恒 | 只汇总原10对贡献核对原Bray，不重新计算Alpha/Beta |
| PASS | 贡献与原比例连接 | 100个目标贡献与2.4原列/2.1端点一致 |
| PASS | 既有时间贡献 | 10目标×16段；只提取指定比较，不复制全表 |
| PASS | 预定比值节点/R1/C02 | [76, 145] |
| PASS | 预定比值节点/R3/C04 | [30, 76, 145] |
| PASS | 预定比值节点/R2/N072 | [1, 30, 76, 145] |
| PASS | 预定比值节点/R4/N072 | [1, 30, 76, 145] |
| WARNING | log-ratio低计数敏感/R4 | N072/C01虽满足预定≥5 reads，最小count=8；只保留探索性数值，不称稳健比值或独立支持 |
| PASS | 观测完整性 | 330行；全33上下文不参与独立重复或相关分析 |
| PASS | 固定单元比较覆盖 | 47个ASV比较+25个已有差额；没有扩大研究单元 |
| PASS | 五层证据覆盖 | A/B/C=5/6/5行；逐对象原16S/保守分类/参考/假设/禁止机制分列 |
| WARNING | 分类证据差异 | 100%短片段也不能唯一物种；代码/跨属并列/远缘背景按2.5原结论保留 |
| WARNING | 组成与零值 | 比例不是绝对菌量；log-ratio无伪计数，仅预定≥5 reads序列，不消除16S拷贝或扩增偏倚 |
| WARNING | 设计与批次限制 | 不同初始污泥、混合均分、保存恢复、纵向依赖、温度/DO/时间混杂及提取/PCR/测序子批次不可分离 |
| WARNING | 功能及性能推断关闭 | 无同期实测出水/去除率；同配方不是实测；不支持温度/DO独立因果及功能互作 |
| PASS | 回读/focal_asv_cosuccession.tsv | 415行；所有字段逐值回读一致 |
| PASS | 回读/ecological_evidence_synthesis.tsv | 16行；所有字段逐值回读一致 |
| PASS | 绘图执行 | R base graphics；原比例实际节点，图层数据断言 |
| PASS | PDF完整 | 矢量PDF头尾完整 |
| PASS | PNG完整 | 3600×2600；逐块CRC及像素流解压通过 |
| PASS | 运行输入保护 | 所有输入SHA256不变 |

最小成果（全部位于新V2目录，不覆盖历史）：

- [focal_asv_cosuccession.tsv](focal_asv_cosuccession.tsv)：330个原观测、47个原贡献比较、25个原Δc和13个预定比值位置，record_type区分；不适用字段NA。observation.study_unit可为A;C，其他为context_G*；不得把不同行型合并作独立样本。
- [focal_asv_trajectory_comparison.pdf](focal_asv_trajectory_comparison.pdf) / [PNG](focal_asv_trajectory_comparison.png)：16个实际节点面板和2个已有Δc摘要，独立纵轴；G5不连入时间轴。
- [ecological_evidence_synthesis.tsv](ecological_evidence_synthesis.tsv)：16个单元×ASV证据条目，五层证据、原分类/审核解释、参考核实范围/DOI、禁止外推及功能状态。
- 本中文综合报告和[run.log](run.log)：命令、参数、工具版本、输入/输出SHA256与实际检查。

## 参考证据复用与复现

仅复用模块2.5冻结审核快照，没有重新联网检索、比对或扩大文献主张。逐条参考生理/基因组支持、实际摘要/全文/图表核实范围和禁止外推见[模块2.5文献表](../../candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv)、[基因组表](../../candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv)及本次证据表。缺失或NOT_VERIFIED项目不自动补全。参考强证据不等于本项目ASV功能实证。

复现入口：[focal_asv_cosuccession_v2.py](../../../scripts/focal_asv_cosuccession_v2.py)。

```bash
python3 scripts/focal_asv_cosuccession_v2.py --output-dir results/focal_asv_cosuccession/NEW_DATE_v2
```

目标必须不存在且以_v2结尾；默认正式路径已存在会非零拒绝，不能指定覆盖。Python标准库+现有R base graphics，无安装、无随机步骤；绘图临时脚本仅在本次TemporaryDirectory，成功后清理。三份总文档在实际交付后同步，不由脚本自动改写。

Python：3.14.7；平台：Linux-6.18.33.2-microsoft-standard-WSL2-x86_64-with-glibc2.43；R版本记录在run.log；脚本SHA256：`548d9190a5a1cce92a4d6c44885503111f18a93bf83d2524c4fda6886fd8dee8`。输入清单及每个SHA256同时记录如下与run.log；不复制大规模中间表。

| 输入路径 | SHA256 |
|---|---|
| data/asv_table.tsv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| data/exported_sequences/dna-sequences.fasta | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv | 16f6e91b40ace510588002e3aac002901ef6c95921165efb0aaa87447e489254 |
| results/asv_contributions/2026-11-05_v2/focal_asv_abundance_trajectories.tsv | 7a91be7eb68581298c568e0526e000a5a5606c3e242141ab6e4847ed50e28107 |
| results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv | 842db5e3ff628e8ec177dbd80fc666d50efbc46a296764da27e273f949a91d0e |
| results/asv_contributions/2026-11-05_v2/focal_temporal_asv_changes.tsv | dc70a8a051865336e05e585862d3ce18ff647027d258d2714e97b6d2dbfb4567 |
| results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv | 09196dc3fd33639365f93d9a99f766c4b0df364b301c61bec4b7b925a0d1a90b |
| results/ecological_candidates/2026-11-07_v2/all_asv_ecological_features.tsv | 139b97bf64cb5ba5db980cea8a3f2676c0e4bd561cf42e12ef737f8e5102f012 |
| results/ecological_candidates/2026-11-07_v2/candidate_priority_table.tsv | f7ec055e410bfbe3b66f79a46954cb652701201b5a961a5ec441cfa69b19bdc2 |
| results/candidate_ecology/2026-11-08_v2/candidate_taxonomy_validation.tsv | a5103fee036c141c16c8de54453623beafa2d6c5186d10315063ed490be0dff2 |
| results/candidate_ecology/2026-11-08_v2/candidate_ecological_roles.tsv | 43dedc20977c2a9999700622beb4d90a8777b9534ad5119e92007d0dccb4b46a |
| results/candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv | 18fbafdeda1ccc0b4c70a86829cf9d3a362da9ea6deb2eeb76239bfd87868347 |
| results/candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv | 1ecc37b913c8f6a4cafcfcf57c5245c01634ecb1b3c6e1bba161533e5009b8e4 |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/functional_guilds/2026-11-03_v2/analysis_report.md | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| results/diversity/2026-11-04_v2/analysis_report.md | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| results/diversity/2026-11-04_v2/module12_review.md | 6f0685fecad7a6d4ba4fa4baf03146ab2e831db03dbbc5158ee519e7f790367b |
| results/asv_contributions/2026-11-05_v2/analysis_report.md | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| results/candidate_asvs/2026-11-05_v2/analysis_report.md | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |
| results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md | e46bfffeb97352a600aeadd97245373b2a59876ea959dd92a4afe8bbf0a07dc2 |
| results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md | 95a3023e5de35aee5163b715eaef28aa6aa04d067d6a5a37fa4753cf2da9682b |
| results/candidate_ecology/2026-11-08_v2/analysis_report.md | ae4f3710bc3e2fc30ae6a6f3608c3e873418175bc482a5ce0956fabdb373dc59 |
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| docs/batch_01/experiment_design.md | d934ba097876772559a5e2658faf4f5cdbea5564167a6a164efdaf86a448d2b9 |
| docs/batch_01/analysis_plan.md | c7250e1440ef404a4df1f06e39abe458ce0743588cb2ed2e1c48b6dba2d1d1ad |
| docs/batch_01/analysis_log.md | 63304f5c26faba93720845e9a25b612513102b163b673adfa44c9d5ae7eea092 |
| results/ecological_candidates/2026-11-07_v2/run.log | 0c7b3293e5dee9ef0ebe6314737e0006197bbe701ce0481e639cb9d5873743ab |
| results/candidate_ecology/2026-11-08_v2/run.log | b79472f157c4a2dbf8460c6539fd137d8b2e180953e3f2a75143dee0449fe431 |

描述分析结束：2026-11-09T09:55:37+08:00（Asia/Shanghai）。


## 独立交付核验（2026-11-09T09:59:17+08:00；不混入主流程69/5/0）

- PASS：独立使用原整数count与Fraction核对700项目标比例、贡献、差额及自然log比值；415条记录类型/原分类/10对象、16条单元证据及7 UNKNOWN/1参考潜力/2 GAO关联边界一致。没有重算Alpha/Beta或新筛选。
- PASS：隔离临时目录从同一冻结v2输入重现两张TSV和PNG，均与正式文件逐字节相同；这属于复现核验，不是独立生物学验证。已有输出和v1目标均在写入前非零拒绝，正式6文件未变。
- PASS：正式3600×2600 PNG已实际打开检查；16轨迹/2差额摘要、完整SILVA原标签和MiDAS审核、非负比例、图注与小幅贡献标签均可读。PDF矢量输出头尾/PNG CRC及像素流校验通过。R1缺30d无点且断线；G5只作独立表格背景。
- PASS：210个受保护既有文件SHA256不变，包含原metadata/ASV/taxonomy/FASTA/RDS和全部旧结果；仅三份总文档获授权修改。日志原前缀、累计解释旧科研正文及README历史结果正文保留；当前316个本地文档链接/锚点有效。新增恰7文件=1脚本+6最终产物，无项目中间表。

README的2026-11-09当前状态/导航、累计解释module26-focal-asv-cosuccession-v2及analysis_log已同步。三单元的具体观察、可跨Batch核查的组成假设及不能回答的问题均已列明；跨Batch尚未执行、7目标功能未知、本ASV活性/互作/性能/温度和DO因果不能因此确证。最初输出SHA256保留于run.log，报告追加独立核验后的最终指纹另记DELIVERY_SHA256。
