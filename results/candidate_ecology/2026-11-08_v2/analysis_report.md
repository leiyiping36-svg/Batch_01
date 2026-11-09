# 模块2.5第一阶段：重点非传统候选ASV分类核实与潜在生态证据调查（V2）

实际分析运行：2026-11-08T16:09:31+08:00 至 2026-11-08T16:09:50+08:00（Asia/Shanghai）。外部检索/下载及初步比对发生在同日、正式脚本前，阶段记录见项目分析日志；不把正式运行时间冒充整个检索耗时。Python 3.14.7；blastn: 2.17.0+。

**交付PASS：90 PASS / 4 WARNING / 0 FAIL。** 此计数仅针对实际交付必要检查；功能、性能及因果门控均未因此通过。七个重点对象仍保留功能未知；N072仅获得近缘参考谱系的潜在生态角色支持，C01/C03为原GAO关联对照。

## 执行前检查、依据与范围

已阅读AGENTS及背景/设计/计划/日志、模块1.1–2.4当前有效v2报告。先检查真实文件与ID、报告歧义和计划，再处理数据。固定C02/C04/C05/C10/C09/N026/N045/N072共8目标，另有C01/C03两个对照；没有扩大项目候选。原始代表序列实际取自现有FASTA，并只读核对原rep-seqs.qza内部相同序列；7条已有C编号复用模块2.2审核，3条N编号本次首次提取。原SILVA完整Taxon、原字符串Confidence、真实查询序列与指纹均写入分类表，不覆盖taxonomy。

保持33样本及G1–G5=8/2/4/15/4，主29与G5单母样四粒径级分边界不变。G4四份初始污泥不同、四反应器纵向采样；R1/R3=30℃运行标签，R2/R4室温数值未知；R1缺30d；前期混合均分、4℃59d保存恢复及轮次依赖仍在。G1–G5共享名义人工进水配方，不能当同期实测、独立水质重复或样本间协变量。无可靠同期出水、去除率、功能基因/活性；温度与DO因果、处理性能关联、网络、PICRUSt2均未执行。未重复DADA2/SILVA/深度QC/Alpha-Beta或ASV筛选，也未更新RDS。

## 数据库、实际比对与解释规则

MiDAS适用于污水/消化系统的依据为[MiDAS4原研究](https://www.nature.com/articles/s41467-022-29438-7)（DOI 10.1038/s41467-022-29438-7）与[MiDAS5原研究](https://www.nature.com/articles/s41467-024-49641-y)（DOI 10.1038/s41467-024-49641-y）。2026-11-08从[官方下载入口](https://www.midasfieldguide.org/guide/downloads)对应[5.3 SINTAX序列文件](https://www.midasfieldguide.org/files/downloads/taxonomies/SINTAX.fa%20MiDAS%205.3.fa)实际下载169354955 bytes、111037条参考，完整SHA256 `06e2fa3edc892676ef1356901d2bf0320520b3e79be6f73caf98955c0aecc00e`；版本由具体下载文件锁定，不声称已查遍所有参考库或全网最新版本。初次沙箱网络禁止、经权限工具访问；首段下载超时后续传，最终完整指纹/格式通过才使用。MiDAS动态网页属页面未可靠呈现，不将其空白页面当功能证据。

完整参考库建立临时BLAST索引，10条实际查询同时检索。blastn task=blastn、word_size=11、dust=no、evalue=1e-10、perc_identity=85、qcov_hsp_perc=90、max_target_seqs=200000（大于全部参考条数）、max_hsps=1、2线程。结果实际21643个MiDAS HSP，全部保留于压缩比对表。后续分类摘要只取查询覆盖≥99%的HSP，以identity优先、coverage/bit score/ID确定输出顺序；同最高identity与覆盖率者全部并列，**排序首位不代表唯一分类**。另审阅距最佳0.5/1.0个百分点内所有匹配的最近共同谱系，作为预设歧义检查，不是统计置信区间或通用物种界限。保留1个百分点结果较保守；跨属不强配属。blastn为启发式检索，未进行全长16S系统树或全库穷举动态规划，低相似未知分支仍可能欠覆盖。

查询404–429bp；MiDAS摘要匹配均覆盖查询100%。历史引物线索338F/806R，**精确引物切除及E. coli通用坐标未独立对齐核定**；按实际查询全片段相同/合理覆盖比较，不能写成已经核实统一全长V3–V4或全长16S。identity=匹配碱基/含gap对齐列数，coverage=HSP覆盖查询碱基/查询长度；逐HSP重算并与原查询/参考逐碱基断言核对，subject正/反向坐标保留。原Confidence是分类器分值，非功能概率。历史参数日志classifier文件名为silva144-2026.7-full-length.qza，记录的classifier SHA256为e6a6ac57b880c4f9e92baf8c4050483a6deed2615a9c001a7251c01dfe32a047；confidence=0.7、read_orientation=same。这里只转述可回查的旧日志，未加载该外部分类器，其文件名不替代训练数据库来源核实。

参考株/MAG定向比对不设85%截断，保留远缘证据；基因组最多10个HSP以保留拷贝。参考库之间的门/纲/目/科命名变化逐来源保留，例如原Paracoccaceae与MiDAS Rhodobacteraceae、原Lewinellaceae/OLB8与MiDAS Saprospiraceae/Ca_Vicinibacter。未独立重建命名体系或证明所有差异是生物学冲突；保守命名层级及数据库操作代码分开报告。`midas_s_*`是参考库标签，不是本ASV物种确证。

## 已核实的序列事实与分类结论

| 对象 | 长度bp | MiDAS最佳identity/coverage% | 并列数 | MiDAS最佳谱系共同部分 | 审核结论 |
|---|---|---|---|---|---|
| C02 | 425 | 100.000/100.0 | 1 | d:Bacteria;p:Bacteroidota;c:Bacteroidia;o:Sphingobacteriales;f:AKYH767;g:midas_g_9646;s:midas_s_9646 | 保守命名层级Sphingobacteriales目；MiDAS操作定位AKYH767/midas_g_9646（全片段100%）；SILVA科名与MiDAS不一致，非已鉴定属，功能未知。 |
| C04 | 423 | 100.000/100.0 | 1 | d:Bacteria;p:Bacteroidota;c:Bacteroidia;o:Cytophagales;f:Microscillaceae;g:midas_g_85782;s:midas_s_85782 | 保守命名层级Cytophagales目；MiDAS操作定位Microscillaceae/midas_g_85782（全片段100%）；不支持套用Chryseotalea Ys生理。 |
| C05 | 404 | 98.762/100.0 | 9 | d:Bacteria;p:Acidobacteriota;c:Blastocatellia;o:Blastocatellales;f:Blastocatellaceae;g:Blastocatella | 保守到Blastocatellaceae科；MiDAS最佳Blastocatella，1个百分点近邻跨Blastocatella/Aridibacter；短16S不能裁定属或定种。 |
| C10 | 423 | 93.617/100.0 | 2 | d:Bacteria;p:Bacteroidota;c:Bacteroidia;o:Cytophagales;f:Microscillaceae | 保守命名层级Cytophagales目；MiDAS候选Microscillaceae，最佳93.617%且跨多个代码属并列；不确认Chryseosolibacter属。 |
| C09 | 404 | 100.000/100.0 | 7 | d:Bacteria;p:Proteobacteria;c:Alphaproteobacteria;o:Rhodobacterales;f:Rhodobacteraceae | 保守命名层级Rhodobacterales目；原Paracoccaceae与MiDAS Rhodobacteraceae版本名称并列保留；7条100%跨Rhodobacter/Tabrizicola，不能改善为唯一属。 |
| N026 | 405 | 97.037/100.0 | 2 | d:Bacteria;p:Chloroflexi;c:Anaerolineae;o:SBR1031;f:Flexifilaceae;g:midas_g_29983;s:midas_s_29983 | 保守到Anaerolineae纲；MiDAS近邻SBR1031/Flexifilaceae/midas_g_29983（97.037%）；与Phototrophicus ZRK33仅79.506%，不支持光合身份。 |
| N045 | 421 | 100.000/100.0 | 1 | d:Bacteria;p:Bacteroidota;c:Ignavibacteria;o:SJA-28;f:midas_f_31;g:midas_g_171;s:midas_s_34290 | 保留Ignavibacteria/SJA-28关联；MiDAS操作定位midas_f_31/midas_g_171（全片段100%）；不确认Tepidaquicella命名属或Ch128a功能。 |
| N072 | 424 | 100.000/100.0 | 6 | d:Bacteria;p:Bacteroidota;c:Bacteroidia;o:Chitinophagales;f:Saprospiraceae;g:Ca_Vicinibacter;s:midas_s_177 | 支持Ca_Vicinibacter参考谱系关联（MiDAS midas_s_177），不定种；与affinis和proximus两参考MAG各两份16S拷贝全片段100%，不能仅凭旧OLB8代码套用其他分支。 |
| C01 | 429 | 100.000/100.0 | 3 | d:Bacteria;p:Proteobacteria;c:Gammaproteobacteria;o:Competibacterales;f:Competibacteraceae;g:Ca_Competibacter;s:Ca_Competibacter_denitrificans | 支持Ca_Competibacter属谱系关联；MiDAS种标签仅记录命中，不作denitrificans种/菌株鉴定或本研究反硝化证据。 |
| C03 | 404 | 99.257/100.0 | 4 | d:Bacteria;p:Proteobacteria;c:Alphaproteobacteria;o:Defluviicoccales;f:Defluviicoccaceae;g:Defluviicoccus;s:midas_s_3306 | 支持Defluviicoccus属谱系关联；99.257%短片段匹配不确定参考cluster或物种，沿用GAO关联对照。 |

1. **C02**：从Incertae_Sedis推进到MiDAS可回查的AKYH767 / midas_g_9646操作谱系，但这仍是代码类群。跨体系保守命名层级为Sphingobacteriales目，不再把旧Sphingobacteriaceae科标签视为独立确认。工业污水原图L11有同代码出现背景，未获得培养、近缘基因组或目标功能证据。
2. **C04/C05**：两者有真实可追溯的原标签培养文献，但可靠关联程度不足。C04对Ys仅91.726%，而MiDAS全片段匹配未知代码midas_g_85782，不能采用Ys生理。C05对两Aridibacter株同为98.020%，MiDAS最佳却为Blastocatella（9条并列、多个species代码），1个百分点近邻跨两属，保守到Blastocatellaceae；不列为硝酸盐还原菌。
3. **C09**：7条全片段100%并列包含Rhodobacter与Tabrizicola，不能改善到唯一属；即使最高identity=100%、原Confidence很高，仍保持功能未知。科名按两数据库并列保存，保守共识为Rhodobacterales目。
4. **C10**：MiDAS最佳93.617%且并列跨代码属，对PWU4/PWU20仅88.416/90.566%；原Chryseosolibacter培养背景不足以支持本ASV的异养或水解功能判断。
5. **N026/N045**：分别获得midas_g_29983近邻（97.037%）与midas_g_171全片段匹配。L12/L13分别提供污水系统的代码出现背景；未把N026等同原图ASV，也未把N045的样本分散后相对比例上升当培养/生长证据。ZRK33和Ch128a分别只有79.506%和84.906%，相关光合/固碳、蛋白分解/亚硝酸盐代谢仅远缘背景。
6. **N072**：实际MiDAS为Ca_Vicinibacter / midas_s_177，6条100%并列、近0.5/1个百分点仍同谱系。它属于原研究中与旧OLB8其他分支不同的参考组，不能套用Ca_Brachybacter/Parvibacillus的糖原结论。两个实际下载的Vicinibacter参考MAG，各有两份424bp匹配100%的16S片段，仍不能选择唯一种或菌株。

## 近缘参考基因组与代谢审核

| 对象 | 参考株/MAG | 实际序列编号 | identity% | coverage% | 代谢审核门控 |
|---|---|---|---|---|---|
| C04 | Chryseotalea sanaruensis YsT | LC349727.1 | 91.726 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C05 | Aridibacter famidurans A22_HD_4HT | KF245634.1 | 98.02 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C05 | Aridibacter nitratireducens A24_SHP_-5_238T | KX443571.1 | 98.02 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C10 | Chryseosolibacter histidini PWU4T | MW182516.1 | 88.416 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C10 | Chryseosolibacter indicus PWU20T | MW182517.1 | 90.566 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| N026 | Phototrophicus methaneseepsis ZRK33 | CP062983.1 | 79.506 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| N045 | Ca_Tepidaquicella proteinivorans Ch128a | CP054675.1 | 84.906 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| N072 | 旧OLB8/PAO1-tig00198536 | CP058702.1 | 90.094 | 100.0 | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| N072 | Ca_Vicinibacter affinis EsbW_18-Q3-R4-48_MAXAC.074 | JADJNH010000005.1 | 100.0 | 100.0 | PASS_NEAR_16S_REFERENCE_ONLY |
| N072 | Ca_Vicinibacter proximus Fred_18-Q3-R57-64_BAT3C.331 | JADJOE010000001.1 | 100.0 | 100.0 | PASS_NEAR_16S_REFERENCE_ONLY |
| C02 | NA | NA | NA | NA | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C09 | NA | NA | NA | NA | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C01 | NA | NA | NA | NA | STOP_NO_RELIABLE_NEAR_GENOME_LINK |
| C03 | NA | NA | NA | NA | STOP_NO_RELIABLE_NEAR_GENOME_LINK |

N072对**GCA_016714365.1（EsbW_18-Q3-R4-48_MAXAC.074；Ca_Vicinibacter affinis）**和**GCA_016713905.1（Fred_18-Q3-R57-64_BAT3C.331；Ca_Vicinibacter proximus）**均为424/424bp、100% query coverage，各两份16S拷贝同样匹配。NCBI原始assembly/isolate记录和完整参考MAG已归档；两物种不能由本片段区分，ASV的真实基因组归属为NOT_VERIFIED。

因此只对这两个近缘**参考MAG**审核论文Fig5对应列，不重新做基因注释：报道phaABC、nosZ及若干多糖/氨基酸利用相关标注；对应narGHI、glgB/glgC为0，不能称完整反硝化或典型GAO。草图/注释中未见不等于物种永远缺失。原研究Table1的Vicinibacter原位细胞有PHA而未检出糖原或poly-P；Fig6有附着于其他细胞的观察。这里的基因、储存聚合物和附着证据分别来自参考MAG与参考原位细胞，**均不是本项目ASV实测**；附着不等于已证明产生EPS、促进成粒、共生或物质交换。

补充表S9存在可回查的编号歧义：type-MAG格印GCA_016714365.1，MAG/SAG accession格为GCA_016713905.1；正文参考isolate及实际NCBI记录分别把它们对应到affinis与proximus。本次保留这一不一致，按真实assembly/isolate核对，不从错误单元格强配物种。S10及正文给出的EsbW isolate可回查；原补充PDF和Fig5原图均在参考证据包中。

其余7目标的近缘基因组门控停止，不强制寻找/补造基因或通路；已知背景株的存在不代表可靠近缘。C01/C03仅复用/复核GAO关联原研究，不由MiDAS短片段种标签扩大为具体反硝化、PAO或菌株基因组身份。

## 文献证据层级及核实范围

证据表区分：1本ASV的真实16S/组成；2可靠参考谱系或代码出现背景；3特定近缘参考MAG；4远缘/分类歧义背景；5没有可可靠关联的功能证据。数据库分类匹配另在分类表，不以文献替代序列比对。每条原文标题、DOI、对象、核实日期、可访问摘要/全文/图表范围和禁止外推已记录。L11/L12图中代码仅由可访问的原论文图文索引核实，未重新下载该文参考16S或绑定其MAG；L01–L03等全文未读部分为NOT_VERIFIED。文献快照是本日人工核验，不把脚本重放当再次联网核实。

- **L01** Maejima et al. 2020. [Chryseotalea sanaruensis gen. nov., sp., nov., a Member of the Family Cytophagaceae, Isolated from a Brackish Lake in Hamamatsu Japan](https://pubmed.ncbi.nlm.nih.gov/31792570/). DOI: 10.1007/s00284-019-01823-4。核实范围：primary_abstract_verified;full_text_NOT_VERIFIED；定位：abstract。研究对象：YsT/JCM30318，咸淡水湖分离株。支持：参考株好氧；原摘要报告不能代谢葡萄糖及相关糖。 限制：与C04仅91.726%片段identity；培养背景不能归于C04，尤其不能从Bacteroidota标签反推降糖能力。

- **L02** Huber et al. 2017. [Aridibacter nitratireducens sp. nov., a member of the family Blastocatellaceae, class Blastocatellia, isolated from an African soil](https://www.microbiologyresearch.org/content/journal/ijsem/10.1099/ijsem.0.002318?crawler=true). DOI: 10.1099/ijsem.0.002318。核实范围：primary_abstract_verified;full_text_NOT_VERIFIED；定位：abstract。研究对象：A24_SHP_-5_238T/DSM102177，非洲土壤分离株。支持：该参考株利用多种有机底物，缺氧时可用硝酸盐作替代电子受体。 限制：C05属有歧义且对famidurans/nitratireducens片段均98.020%；不赋予本ASV硝酸盐呼吸、完整反硝化或TN去除。

- **L03** Huber et al. 2014. [Aridibacter famidurans gen. nov., sp. nov. and Aridibacter kavangonensis sp. nov., two novel members of subdivision 4 of the Acidobacteria isolated from semiarid savannah soil](https://pubmed.ncbi.nlm.nih.gov/24573163/). DOI: 10.1099/ijs.0.060236-0。核实范围：primary_abstract_verified;full_text_NOT_VERIFIED；定位：abstract。研究对象：A22_HD_4HT/DSM26555和Ac_23_E3T/DSM26558，半干旱稀树草原土壤分离株。支持：有真实培养和分类学来源；本次仅采用土壤分离及分类背景。 限制：并非本项目污泥ASV的培养株，不据此推断储存、氮转化或EPS。

- **L04** Octaviana et al. 2022. [Four new members of the family Cytophagaceae: Chryseosolibacter histidini gen. nov., sp. nov., Chryseosolibacter indicus gen. nov., sp. nov., Dawidia cretensis, gen. nov., sp. nov., and Dawidia soli, gen. nov., sp. nov. isolated from diverse habitat](https://pmc.ncbi.nlm.nih.gov/articles/PMC9296434/). DOI: 10.1007/s10482-022-01756-2。核实范围：primary_abstract_and_relevant_full_text_verified；定位：abstract;species descriptions;sequence accession paragraphs。研究对象：PWU4T和PWU20T；论文包含其他Dawidia株，不能混用。支持：Chryseosolibacter参考株有好氧培养及有机底物利用背景；16S为MW182516/MW182517。 限制：C10与两株仅88.416/90.566%；不能把株特异底物谱或好氧性赋给C10。摘要PWU20采样地与正文描述不一致，本次不裁定、不用于项目来源。

- **L05** Zheng et al. 2022. [Characterization of the First Cultured Representative of “Candidatus Thermofonsia” Clade 2 within Chloroflexi Reveals Its Phototrophic Lifestyle](https://journals.asm.org/doi/10.1128/mbio.00287-22). DOI: 10.1128/mbio.00287-22。核实范围：primary_relevant_full_text_verified_with_erratum；定位：abstract;strain description;data availability;erratum L06。研究对象：Phototrophicus methaneseepsis ZRK33，深海冷泉分离株。支持：该培养株的光营养、混合营养及有机底物生长已有实验报道。 限制：N026对MN817941及更正后基因组仅79.506%；这是远缘背景，不支持本ASV光合、固碳或甲烷利用。

- **L06** Zheng et al. 2022 erratum. [Erratum for Zheng et al., “Characterization of the First Cultured Representative of ‘Candidatus Thermofonsia’ Clade 2 within Chloroflexi Reveals Its Phototrophic Lifestyle”](https://journals.asm.org/doi/10.1128/mbio.00657-22). DOI: 10.1128/mbio.00657-22。核实范围：primary_erratum_full_text_verified；定位：ERRATUM。研究对象：ZRK33。支持：基因组编号CP051151更正为CP062983，另更正图4A辅因子标签。 限制：原文旧编号不用于参考基因组身份；勘误不是本ASV功能证据。

- **L07** Kadnikov et al. 2020. [Microbial Life in the Deep Subsurface Aquifer Illuminated by Metagenomics](https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2020.572252/full). DOI: 10.3389/fmicb.2020.572252。核实范围：primary_relevant_full_text_verified；定位：Ignavibacteriae Bacterium Ch128a;Fig3;protologue。研究对象：Ch128a/CP054675，深部地下含水层MAG；原拼写Tepidiaquacella proteinivora。支持：蛋白底物利用、发酵及NrfAH型亚硝酸盐还原为该参考MAG的预测；并非分离株生理实测。 限制：N045与Ch128a仅84.906%，门控关闭；不把该预测转为N045蛋白降解、DNRA或反硝化证据。

- **L08** Kondrotaite et al. 2022. [Diversity and Ecophysiology of the Genus OLB8 and Other Abundant Uncultured Saprospiraceae Genera in Global Wastewater Treatment Systems](https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2022.917553/full). DOI: 10.3389/fmicb.2022.917553。核实范围：primary_relevant_full_text_Fig5_Table1_and_supplement_verified；定位：Fig4;Fig5;Table1;Fig6;Supplementary Tables S9/S10。研究对象：Ca_Vicinibacter proximus/affinis参考MAG和污泥原位细胞。支持：参考Vicinibacter有异养/水解及PHA潜力；原位检出PHA，糖原及poly-P未检出；观察到絮体内及附着分布。 限制：midas_s_177包含两个基因组种；不把旧OLB8其他分支糖原结果、附着关系或参考MAG基因当本ASV实测；附着不等于产EPS。

- **L09** McIlroy et al. 2014 (online 2013). [‘Candidatus Competibacter’-lineage genomes retrieved from metagenomes reveal functional metabolic diversity](https://pmc.ncbi.nlm.nih.gov/articles/PMC3930307/). DOI: 10.1038/ismej.2013.162。核实范围：primary_indexed_abstract_verified;live_full_text_recaptcha；定位：indexed primary abstract;module2.2 evidence reused。研究对象：Competibacter谱系参考基因组。支持：支持GAO相关糖原/PHA碳储存背景且谱系间代谢多样。 限制：C01为GAO关联对照；不由MiDAS denitrificans标签赋予物种、反硝化活性或竞争机制。

- **L10** Burow et al. 2007. [Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes](https://pubmed.ncbi.nlm.nih.gov/17185546/). DOI: 10.1099/mic.0.2006/001032-0。核实范围：primary_abstract_verified；定位：abstract;FISH-MAR results。研究对象：全规模EBPR系统Defluviicoccus cluster1/2参考细胞。支持：FISH-MAR支持参考类群底物摄取；cluster2表现与GAO储存模型相容。 限制：C03短片段不能定位这些cluster；不证明项目GAO活性、碳竞争或去除损失。

- **L11** Seguel Suazo et al. 2024. [Bacterial community and filamentous population of industrial wastewater treatment plants in Belgium](https://link.springer.com/content/pdf/10.1007/s00253-023-12822-8.pdf). DOI: 10.1007/s00253-023-12822-8。核实范围：primary_abstract_and_indexed_Fig4_excerpt_verified;full_text_NOT_VERIFIED；定位：Fig4b indexed original PDF excerpt。研究对象：29个工业污水厂；midas_g_9646代码。支持：原图出现midas_g_9646，提供污泥系统中的同代码出现背景。 限制：出现/分组比例不等于该代码为丝状菌、产EPS或引起膨胀；参考16S原序列未重比对。

- **L12** Bovio-Winkler et al. 2023. [Genome-centric metagenomic insights into the role of Chloroflexi in anammox, activated sludge and methanogenic reactors](https://link.springer.com/article/10.1186/s12866-023-02765-5). DOI: 10.1186/s12866-023-02765-5。核实范围：primary_full_text_and_indexed_Fig2_excerpt_verified；定位：Fig2 genus/species panels;Methods MiDAS3.7 V4 amplicons。研究对象：污水反应器Chloroflexi；midas_g_29983/midas_s_29983代码。支持：原图含该代码，支持污水背景中的近邻代码出现线索。 限制：N026仅97.037%近邻；该文其他Chloroflexi MAG的水解/EPS/氮功能不能转给该代码或N026，未建立MAG对应。

- **L13** Verhoeven et al. 2023. [Amplicon-guided isolation and cultivation of previously uncultured microbial species from activated sludge](https://pmc.ncbi.nlm.nih.gov/articles/PMC10734543/). DOI: 10.1128/aem.01151-23。核实范围：primary_relevant_full_text_verified；定位：Preparation of single cell suspensions;Fig1c;MiDAS5.1。研究对象：Aalborg West活性污泥；midas_g_171代码。支持：原研究在活性污泥及分散细胞制备比较中记录midas_g_171。 限制：不把样本制备后相对比例增加称为生长、富集培养成功、纯培养或已知代谢能力。

- **L14** Lawson et al. 2017. [Metabolic network analysis reveals microbial community interactions in anammox granules](https://pmc.ncbi.nlm.nih.gov/articles/PMC5460018/). DOI: 10.1038/ncomms15416。核实范围：primary_relevant_full_text_verified；定位：CHB1/OLB4 comparison;carbon metabolism;discussion。研究对象：UTCHB1/OLB4，anammox颗粒污泥MAG及转录。支持：参考CHB1/OLB4研究提出蛋白底物分解及硝酸盐/亚硝酸盐循环联系。 限制：相对于N045只是SJA-28相关远缘背景；未把N045比对到这些MAG，不建立本项目互作或氮转化路径。

- **L15** Arumugam et al. 2021. [Recovery of complete genomes and non-chromosomal replicons from activated sludge enrichment microbial communities with long read metagenome sequencing](https://www.nature.com/articles/s41522-021-00196-6). DOI: 10.1038/s41522-021-00196-6。核实范围：primary_abstract_Table1_and_data_availability_verified；定位：Table1 CP058702;data availability。研究对象：PAO1-tig00198536/CP058702，旧OLB8 sp001567405参考基因组。支持：存在可追溯的活性污泥富集系统参考基因组。 限制：N072对该旧OLB8参考仅90.094%最高；不能套用这个分支，改用实际Vicinibacter近缘MAG。

## 潜在生态角色、未知对象与后续问题

**适合优先作为潜在辅助类群的是N072**：可以提出“Vicinibacter相关异养底物利用/PHA暂存及絮体或附着生态背景，可能与群落共同演替相伴”的有限假设。后续若只复用现有16S，应在同反应器实际采样节点中描述它与C01/C03等的组成变化；不得把共同升降写成协作、竞争或交叉营养，也不能验证PHA通量、EPS生成、硝态氮利用、去除贡献或温度/DO机制。本阶段未计算任何共同演替关系或网络。

**C02、C04、C05、C10、C09、N026、N045的具体功能仍为UNKNOWN。** C02/N045及N026近邻已有污泥/污水代码出现背景，适合在固定范围内作为组成生态伴随对象；C04/C05/C10的原命名属生理不能直接套用，C09即使100%匹配也无法选属。它们可以保留在共同演替描述中，但不能预先分配“辅助去除”“EPS生产”“储存菌”或“氮转化菌”角色。未知不等于无功能。

目前支持的是组成生态学与N072参考谱系层面的代谢潜力假设，不能建立本研究特异的碳—氮—EPS机制路径。G4初始差异、纵向依赖、不平衡节点、共享谱系及温度/反应器混杂均未消除；提取/PCR/测序子批次效应、扩增和16S拷贝偏倚未分离。相对丰度不等于绝对菌量或VSS/MLVSS归一化的严格绝对丰度。

## 尚未核实的项目（明确保留）

- 全部10对象的物种/菌株身份、真实全基因组、项目功能基因/表达/活性：NOT_VERIFIED或not_measured。
- 7个未知功能目标的可靠近缘基因组：门控STOP；不把未找到当作不存在，不强制推断。
- 部分文献全文、全部原始实验数据及所有补充基因注释明细：仅核实上文列明范围。N072使用Fig5实际两MAG列，未重新运行KEGG/基因组注释或逐基因验证。
- MiDAS页面知识卡的动态功能内容、其他参考库交叉核实、全长16S系统树、精确扩增通用坐标：NOT_VERIFIED/未执行。C02/C04代码是否已有更新命名亦未确认。
- 原补充表S9编号印刷歧义、原L04摘要与正文采样地不一致保留，不影响本研究原始metadata。

## 实际检查、产物与复现

| 状态 | 检查 | 实际依据 |
|---|---|---|
| PASS | 外部命令退出 | 0 |
| PASS | MiDAS5.3完整文件指纹 | 06e2fa3edc892676ef1356901d2bf0320520b3e79be6f73caf98955c0aecc00e |
| PASS | 历史SILVA样本来源 | 旧参数日志33样本一致；不加载或重跑外部分类器 |
| PASS | 有效v2指纹链 | data/asv_table.tsv |
| PASS | 有效v2指纹链 | data/taxonomy.tsv |
| PASS | 有效v2指纹链 | data/exported_sequences/dna-sequences.fasta |
| PASS | 有效v2指纹链 | metadata/source_sample_metadata.tsv |
| PASS | 有效v2指纹链 | results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv |
| PASS | 有效v2指纹链 | results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv |
| PASS | 既有FASTA与原taxonomy ID | 5510个ID一致；不重做上游QC |
| PASS | 固定8目标 | C02;C04;C05;C10;C09;N026;N045;N072 |
| PASS | 10对象身份与既有主池 | 8目标+2对照；没有扩大候选 |
| PASS | C02真实序列 | d1725130559823512a63bbc2c1bab523; 425bp; SHA256=e1dfed676bae872dc2a1b0e565738aabd3c6b3dee7a231a67b4cd02455e3c48d |
| PASS | C02原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C02模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | C04真实序列 | be9af24f8e82484720783bcb4df4f6de; 423bp; SHA256=9ebcdc07a124c610bfbdb742ecb49ce2d19e76ef8b912102e57430fe9a83d984 |
| PASS | C04原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C04模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | C05真实序列 | 54089b19ce1b3690c1e03d4d34a0162c; 404bp; SHA256=cb16115f27f614a84d9b8370da6a6e82c728be96a2c5e03e1e0c933146963cb9 |
| PASS | C05原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C05模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | C10真实序列 | c32a06324874a524e422813afbe86397; 423bp; SHA256=33d4b4c95e878ab02cbf63cc645bd34484d4e5861a2c90a0dc64aca519a38997 |
| PASS | C10原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C10模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | C09真实序列 | a578dfb348f923c17e372f94df5716ef; 404bp; SHA256=f04644c38618397708588b2a922527d7ac328137f1680e66002ec30327fffb8f |
| PASS | C09原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C09模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | N026真实序列 | 3c495f2e6a55da9e059579e82a2dfc39; 405bp; SHA256=28f51316f4031193493baff9db96ca2d4b92f5e303f639091f1fdaeff691d29b |
| PASS | N026原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | N045真实序列 | 80225eb15f3521f7cc5b5c36e3afdf15; 421bp; SHA256=c396c4c9b68d7307e61f3cdce1c7bd6683a6661f527b8cc0ff6c389842b46d61 |
| PASS | N045原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | N072真实序列 | cfb0a32a7a0d5e6c513509147a75da65; 424bp; SHA256=c51d6776d4401c4fd06a4344a449210523f0e88301cc098d7a6376fe54089edc |
| PASS | N072原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C01真实序列 | 3cae56af0b082bba9c858d1844913fc3; 429bp; SHA256=9ddcb4164f48d1a893f9a409bb24feae72011ce13b5cde8ffda96b5b045dcccf |
| PASS | C01原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C01模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | C03真实序列 | 78c2842bcb5d089b057f231ddd53b8e1; 404bp; SHA256=32321ce3bc1c5aa0aeea88240fc0bbeb1eef8158788ad8a76d0ba04f99a22690 |
| PASS | C03原SILVA保留 | 完整Taxon和Confidence逐字符一致 |
| PASS | C03模块2.2复用 | 序列/完整谱系/原Confidence一致 |
| PASS | Artifact序列源唯一 | ['83a9e2a3-20c4-4d06-b927-9a9f557e9820/data/dna-sequences.fasta'] |
| PASS | 10序列与原QZA核对 | 只读zip内已有数据；无重复导出 |
| PASS | 33样本ID | 计数仅仅读表头，深度QC沿用历史指纹 |
| PASS | 分组 | 8/2/4/15/4 |
| PASS | 原metadata保留 | 33×14原值逐项一致 |
| PASS | G4设计 | 四不同起始污泥；R1/R3=30℃，R2/R4室温未知，纵向不独立 |
| PASS | 性能门控 | 统一名义配方不增加同期实测、出水或功能基因 |
| PASS | MiDAS参考ID唯一 | 完整官方SINTAX 5.3参考集111037条 |
| PASS | 定向参考集 | 6条培养株16S、3个文献基因组；编号含ZRK33勘误 |
| PASS | MAG原始记录 | GCA_016714365.1 |
| PASS | 参考MAG实际isolate与种名 | GCA_016714365.1;EsbW_18-Q3-R4-48_MAXAC.074;Candidatus Vicinibacter affinis |
| PASS | MAG完整序列文件唯一 | GCA_016714365.1 |
| PASS | MAG基因组长度 | GCA_016714365.1 |
| PASS | MAG原始记录 | GCA_016713905.1 |
| PASS | 参考MAG实际isolate与种名 | GCA_016713905.1;Fred_18-Q3-R57-64_BAT3C.331;Candidatus Vicinibacter proximus |
| PASS | MAG完整序列文件唯一 | GCA_016713905.1 |
| PASS | MAG基因组长度 | GCA_016713905.1 |
| PASS | 实际BLAST结果复用 | /tmp/batch01_midas_matches_20261108.tsv; SHA256=9a035956a46f0a621636fcc851e5b16380474a324c3295013d6488c067be2af8 |
| PASS | MiDAS5.3比对格式 | 21643 HSP |
| PASS | MiDAS5.3逐HSP核验 | qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致 |
| PASS | 外部命令退出 | 0 |
| PASS | INSDC_type16S比对格式 | 60 HSP |
| PASS | INSDC_type16S逐HSP核验 | qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致 |
| PASS | 外部命令退出 | 0 |
| PASS | INSDC_genome比对格式 | 50 HSP |
| PASS | INSDC_genome逐HSP核验 | qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致 |
| PASS | 外部命令退出 | 0 |
| PASS | GCA_016714365.1比对格式 | 20 HSP |
| PASS | GCA_016714365.1逐HSP核验 | qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致 |
| PASS | 外部命令退出 | 0 |
| PASS | GCA_016713905.1比对格式 | 20 HSP |
| PASS | GCA_016713905.1逐HSP核验 | qseq/sseq逐碱基与真实序列一致；identity/coverage/nident/gap重算一致 |
| PASS | C02合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C04合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C05合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C10合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C09合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | N026合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | N045合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | N072合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C01合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | C03合理覆盖MiDAS匹配 | 至少1个HSP覆盖查询≥99% |
| PASS | candidate_taxonomy_validation.tsv回读 | 10行×39列 |
| PASS | 参考原件归档 | 6个实际下载源文件；完整MiDAS不重复归档 |
| PASS | 全部匹配证据回读 | 21793行，原坐标/匹配碱基/并列及低identity均保留 |
| PASS | 证据覆盖与边界 | 10对象都有显式证据或NA/NOT_VERIFIED记录 |
| PASS | 代谢外推门控 | N072仅审核近缘参考MAG已报道潜力；全部项目ASV不作基因/通路赋值 |
| PASS | candidate_reference_genomes.tsv回读 | 14行×30列 |
| PASS | candidate_literature_evidence.tsv回读 | 34行×16列 |
| PASS | candidate_ecological_roles.tsv回读 | 10行×15列 |
| WARNING | 分类冲突及代码 | 原SILVA仅为标签；MiDAS代码不等于培养属，短片段匹配不得定种；原taxonomy不改 |
| WARNING | 参考株距离 | C04/C10/N026/N045/N072部分命名参考株距离大，文献降为远缘背景；C05同属参考也不支持定种 |
| WARNING | 文献可访问性 | 已核实范围按逐条记录；全文/补充表/近缘基因组/数据库命名映射未完成者NOT_VERIFIED，未检出不等于不存在 |
| WARNING | 科研设计与测量缺口 | 纵向/不同起始污泥/混合保存恢复/温度与反应器混杂、G5同母样、批次效应；无性能/功能基因或机制实证 |
| PASS | 既有科研文件保护 | 191文件SHA256不变 |

最终九文件：四张candidate_*.tsv、[analysis_report.md](analysis_report.md)、[run.log](run.log)、[reference_alignments_v2.tsv.gz](reference_alignments_v2.tsv.gz)、[reference_sequences_v2.fasta.gz](reference_sequences_v2.fasta.gz)、[reference_evidence_v2.zip](reference_evidence_v2.zip)。压缩比对表共21793条，含真实查询/subject对齐、坐标、低identity背景、并列；匹配参考序列包不冒充完整MiDAS。参考原件ZIP含六条16S、三个GenBank、两个完整MAG下载包、原论文补充PDF/代谢图（按6个源文件条目归档）。没有中间检查图表；本次临时索引随成功运行清理。

入口：[candidate_ecology_validation_v2.py](../../../scripts/candidate_ecology_validation_v2.py)。Python标准库，现有BLAST，无安装或随机步骤。先按MiDAS_URL下载并核对完整SHA256；从参考证据ZIP解出type16S.fasta、genome_records.gb、vicinibacter_1.zip、vicinibacter_2.zip、supplement.pdf、metabolic_figure.webp至本次临时目录，再运行：

```bash
python3 scripts/candidate_ecology_validation_v2.py --midas-fasta /path/to/MiDAS_5.3.fa --type-fasta /path/to/type16S.fasta --genbank /path/to/genome_records.gb --vicinibacter-zips /path/to/vicinibacter_1.zip /path/to/vicinibacter_2.zip --supplement-pdf /path/to/supplement.pdf --metabolic-figure /path/to/metabolic_figure.webp --output-dir results/candidate_ecology/new_date_v2
```

默认正式目录已存在时非零拒绝；必须指定新_v2目录。正式运行可复用本日实际MiDAS检索的`--precomputed-midas`结果以避免重复检索，仍对每条HSP与完整参考库逐碱基核验，原命令/文件指纹写入run.log；从头复现省略该参数即重新检索。文献事实是脚本内冻结的人工审核记录；未来增量证据需新版本，不覆盖本次。输入保护SHA256在运行前后实际比较，必要失败非零，不保存失败步骤为成功报告。

### 项目输入指纹

| 输入路径 | SHA256 |
|---|---|
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| docs/batch_01/experiment_design.md | d934ba097876772559a5e2658faf4f5cdbea5564167a6a164efdaf86a448d2b9 |
| docs/batch_01/analysis_plan.md | c7250e1440ef404a4df1f06e39abe458ce0743588cb2ed2e1c48b6dba2d1d1ad |
| docs/batch_01/analysis_log.md | e7719fc0b9631adfb313a10d2c9a84d7e5181674f8b7724b3ae8d287218ed550 |
| data/asv_table.tsv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| data/exported_sequences/dna-sequences.fasta | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| input/qiime2/rep-seqs.qza | 9266608e6381cdffa1bf582d798902cd6121c4b04c1e0b8d3c353fac8880d20e |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/ecological_candidates/2026-11-07_v2/candidate_priority_table.tsv | f7ec055e410bfbe3b66f79a46954cb652701201b5a961a5ec441cfa69b19bdc2 |
| results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md | 95a3023e5de35aee5163b715eaef28aa6aa04d067d6a5a37fa4753cf2da9682b |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e |
| results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv | 16f6e91b40ace510588002e3aac002901ef6c95921165efb0aaa87447e489254 |
| logs/taxonomy/inputs.json | 2937d9b59781f252688bdbbd9812a8cc5f904b44afc1aff039d64e1e3709df9c |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/functional_guilds/2026-11-03_v2/analysis_report.md | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| results/diversity/2026-11-04_v2/analysis_report.md | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| results/asv_contributions/2026-11-05_v2/analysis_report.md | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| results/candidate_asvs/2026-11-05_v2/analysis_report.md | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |
| results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md | e46bfffeb97352a600aeadd97245373b2a59876ea959dd92a4afe8bbf0a07dc2 |

### 外部参考原件指纹

| 实际外部输入（运行时临时路径） | SHA256 |
|---|---|
| /tmp/batch01_MiDAS_5.3_SINTAX_20261108.fa | 06e2fa3edc892676ef1356901d2bf0320520b3e79be6f73caf98955c0aecc00e |
| /tmp/batch01_type16S_panel_20261108.fasta | 7860fcd3c02accea08416ca5cbbfce5ebf5c3c0ce3cba8b964b86eb9132d1c0b |
| /tmp/batch01_genome_records_20261108.gb | 40583cdbb6c5521d58b87f437c7cb74a70b672db1997d107952dd2d482cef6a1 |
| /tmp/batch01_Vicinibacter_reference_20261108.zip | f4950c8b7c700cc55758bbfa6aad67007fd7089b73712d47a0d1fece7e08e77a |
| /tmp/batch01_Vicinibacter_proximus_reference_20261108.zip | fb889241e316c826b50dd4a25d68b8238a50e32a3c0ce1ca7f0c47acb49223f1 |
| /tmp/batch01_OLB8_supplement_20261108.pdf | 8967fe0683185e7c35c8efe22cd77098c54ce38a3e68064428d2b86c16a372ef |
| /tmp/batch01_Vicinibacter_metabolic_figure_20261108.webp | 6467d3ecacc121456b037a07bfad02873171ef61efd274dc4731cae4fd1ff50e |

正式命令、软件版本、脚本指纹、实际输入/输出SHA256、起止时间及参数见run.log。三份项目总文档随后更新不改写本次输入历史指纹。**0 FAIL仅代表交付必要条件通过，不能理解为功能未知或科研前提已解决。**


## 独立交付复核（2026-11-08T16:14:00+08:00，不混入正式90/4/0计数）

- PASS：从压缩原始比对表独立使用整数匹配数/有理数重算21793条HSP identity，核对10条真实query片段、21643条MiDAS来源及所有最高并列/近邻计数；C09跨属7并列、N072两个参考MAG各两拷贝全片段匹配均通过。
- PASS：4表分别10/14/34/10行，固定10个对象，7个FUNCTION_UNKNOWN、1个参考潜力目标、2个GAO关联对照；全部物种/菌株NOT_VERIFIED、全部项目功能not_measured、全部ASV基因/通路赋值NOT_PERFORMED。
- PASS：参考证据ZIP外层/两份NCBI原下载ZIP的CRC及NCBI内置md5sum均一致；6个归档源文件与实际下载原字节相同。原补充S9/S10原文本流实际读取，编号歧义已核实记录；Fig5原图已实际打开审阅。
- PASS：隔离预运行与正式运行4表所有共有科学列逐值相同，两份压缩序列/比对证据解压后逐字节相同。二者复用同一实际MiDAS检索，这是序列核验/汇总重现，不冒称两次全库独立检索；正式入口仍支持省略缓存从头运行。
- PASS：已有结果目录及非_v2目标均在读取虚拟输入前非零拒绝，9个产物SHA256不变，无v1目录创建。
- PASS：任务前203文件中仅获授权三份总文档更新，其余200文件SHA256不变；原日志前缀及三文档旧科研正文保留，294个本地Markdown链接可解析。新建仅1个脚本及9个结果文件，未改变任何原metadata/计数/分类/代表序列/对象/既有v2。

README当前状态/导航、累计结果解释module25-taxonomy-ecology-v2及执行日志均已同步。未知的7目标具体功能、全部项目物种/菌株/基因组身份和机制、部分原文全文、动态MiDAS知识卡及精确引物通用坐标仍保留不确定性；无需重新确认已确定的33样本、五组、温度标签或名义配方。后续共同演替尚未开展。
