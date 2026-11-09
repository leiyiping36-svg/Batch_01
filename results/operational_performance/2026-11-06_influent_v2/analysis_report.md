# 模块2.3：进水图片来源录入、共同条件及16S样本匹配

当前版本：`results/operational_performance/2026-11-06_influent_v2`。执行：2026-11-06T15:03:47.044408+08:00 至 2026-11-06T15:03:47.531096+08:00（Asia/Shanghai）。新增进水来源后的实际重新审核；保留此前[无进水图片时的v2报告](../2026-11-06_v2/analysis_report.md)和昨日草稿，不覆盖历史六文件。

**审计与共同条件匹配PASS；测量性质及时间证据WARNING；性能相关检验门控FAIL（关闭）。** 实际检查17 PASS / 4 WARNING / 1 FAIL。退出0表示本模块审计交付成功，FAIL针对尚未开展的后续推断；必需数据/来源/设计断言失败仍非零退出。

## 执行前检查、来源与用户确认

已阅读AGENTS、研究背景、设计、计划、日志及模块1.1–2.2五份有效v2报告；按唯一原metadata `metadata/source_sample_metadata.tsv`核对33样本、8/2/4/15/4，原表14列及旧派生字段逐值保留。9项上游v2报告/派生metadata/候选表及原metadata指纹与上一有效模块2.3来源清单完全一致。先报告图片性质/范围歧义与计划，再录入。

本次图为用户会话提供的“表2.1 进水中各组分浓度”“表2.2 进水中微量元素组成及含量”。随后用户明确确认：**“所有阶段和反应器的进水水质参数都是这样”**。因此共同进水条件适用于本批已确认五模块和四反应器（含其已区分的轮次），可关联全部33个16S样本；不再把范围列为未知或重复索取名单。

图片未说明是配水设定值、单次实测还是阶段实测均值；用户范围确认也没有补充测量性质、方法、采样日期、周期、重复数或均值窗口。因此统一记录`document_reported_common_influent_condition`及`measurement_basis=not_specified`，既不擅自当配水理论值，也不当作已核实测量。用户确认资料不等于原始实验日志已独立验证。

新增源数据为[2026-11-06_influent_image_transcription_v2.tsv](../../../data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv)，仅写新文件，原始sample metadata、ASV、taxonomy、功能注释和对象不修改。源表包含13项原标签/原值/单位、图片表号/行/左右位置、共同适用范围、用户原话及来源层级。会话图片已经目视读取，但未取得本地附件二进制，故原图本地路径/图像SHA-256为NA，不虚构文件名或假称归档原图；转录TSV本身具有真实SHA-256并被逐行核查。

项目递归盘点187个既有文件（包括此前盘点，不含本次新输出及脚本），source_inventory共210行：逐文件记录，加10条已确认DO/温度设置来源及13条新增进水来源定位。未发现其他未审核来源；没有新增可回查的出水/逐日/周期实测或阶段实测均值。历史盘点表不再次导入为原始测量。

## 图片13项原值与数据边界

| record_id | table | original_label | parameter | value | unit |
| --- | --- | --- | --- | --- | --- |
| IF001 | 2.1 | COD | COD | 230 | mg/L |
| IF002 | 2.1 | NH₄⁺-N | NH4-N | 50 | mg/L |
| IF003 | 2.1 | TP | TP | 3.3 | mg/L |
| IF004 | 2.1 | KHCO₃ | KHCO3 | 250 | mg/L |
| IF005 | 2.2 | EDTA | EDTA | 5 | mg/L |
| IF006 | 2.2 | FeCl₃·6H₂O | FeCl3·6H2O | 0.9 | mg/L |
| IF007 | 2.2 | KI | KI | 0.18 | mg/L |
| IF008 | 2.2 | ZnSO₄·7H₂O | ZnSO4·7H2O | 0.12 | mg/L |
| IF009 | 2.2 | CuSO₄·5H₂O | CuSO4·5H2O | 0.03 | mg/L |
| IF010 | 2.2 | Na₂MoO₄·2H₂O | Na2MoO4·2H2O | 0.06 | mg/L |
| IF011 | 2.2 | H₃BO₃ | H3BO3 | 0.15 | mg/L |
| IF012 | 2.2 | CoCl₂·6H₂O | CoCl2·6H2O | 0.15 | mg/L |
| IF013 | 2.2 | MnCl₂·4H₂O | MnCl2·4H2O | 0.06 | mg/L |

- 表2.1四项：COD 230、NH₄⁺-N 50、TP 3.3、KHCO₃ 250 mg/L。表2.2九项完整保留，EDTA具体化学形式未写明，不自行改为二钠盐。
- NH₄⁺-N仅规范化参数名为NH4-N，数值不换算为NH₄⁺质量；TP不等于PO4-P，NH4-N不等于TN。未报告的NO2-N/NO3-N/TN/PO4-P等仍NA，不能认为为0。
- 所有盐类按原完整化学式及水合状态的mg/L浓度记录，不把FeCl₃·6H₂O浓度称为Fe元素浓度，不把KHCO₃ 250直接称为碱度（以CaCO₃计），不为Cu/Zn/Co/Mn/Mo给出元素转换或毒性/效应判断。
- 图示COD/NH4-N浓度比为230/50=4.6，仅是同表报告数值的算术比；不是COD/TN、不是样本实测比、不是运行负荷或去除率，也不足以证明实际碳限制。缺少出水与流量/体积等依据，不计算去除效率、氮磷质量平衡或体积负荷。

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

| parameter | source_records | common_influent_n | common_influent_pct | measured_pct | A_B_C_D | design_background_n |
| --- | --- | --- | --- | --- | --- | --- |
| COD | 1 | 33 | 100 | 0 | 0/0/0/33 | 0 |
| NH4-N | 1 | 33 | 100 | 0 | 0/0/0/33 | 0 |
| NO2-N | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| NO3-N | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| TN | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| PO4-P | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| TP | 1 | 33 | 100 | 0 | 0/0/0/33 | 0 |
| DO | 0 | 0 | 0 | 0 | 0/0/0/33 | 33 |
| temperature | 0 | 0 | 0 | 0 | 0/0/0/33 | 15 |
| pH | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| HRT | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| SRT | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| MLSS | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |
| MLVSS | 0 | 0 | 0 | 0 | 0/0/0/33 | 0 |

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

| candidate | feature_id | original_genus | existing_evidence | G4_detected | matched_performance_records | next_step | functional_validation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| C01 | 3cae56af0b082bba9c858d1844913fc3 | Candidatus_Competibacter | literature_supported_related_taxon | 14/15 | 0 | HOLD_no_matched_performance | not_measured |
| C02 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | taxonomic_information_insufficient | 8/15 | 0 | HOLD_no_matched_performance | not_measured |
| C03 | 78c2842bcb5d089b057f231ddd53b8e1 | Defluviicoccus | literature_supported_related_taxon | 15/15 | 0 | HOLD_no_matched_performance | not_measured |
| C04 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | named_taxon_function_not_assigned | 12/15 | 0 | HOLD_no_matched_performance | not_measured |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | named_taxon_function_not_assigned | 12/15 | 0 | HOLD_no_matched_performance | not_measured |
| C06 | 3b91d8fd7dc57a941d49bed1b084064d | Acinetobacter | functional_ambiguity | 12/15 | 0 | HOLD_no_matched_performance | not_measured |
| C07 | 9d94363a8ab81a79ecf766644aa45b23 | Acinetobacter | functional_ambiguity | 11/15 | 0 | HOLD_no_matched_performance | not_measured |
| C08 | 82c70888e3f2436874633b4285a188e9 | Defluviicoccus | literature_supported_related_taxon | 15/15 | 0 | HOLD_no_matched_performance | not_measured |
| C09 | a578dfb348f923c17e372f94df5716ef | NA | taxonomic_information_insufficient | 14/15 | 0 | HOLD_no_matched_performance | not_measured |
| C10 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | named_taxon_function_not_assigned | 5/15 | 0 | HOLD_no_matched_performance | not_measured |
| C11 | f0e953dd2a7892838f44fea2495a408f | Candidatus_Competibacter | literature_supported_related_taxon | 9/15 | 0 | HOLD_no_matched_performance | not_measured |
| C12 | b815668a1e362dc6a897d2895c351449 | Acinetobacter | functional_ambiguity | 12/15 | 0 | HOLD_no_matched_performance | not_measured |
| C13 | f23e2ebe64cf70326440deb743f4bf85 | Candidatus_Competibacter | literature_supported_related_taxon | 15/15 | 0 | HOLD_no_matched_performance | not_measured |
| C14 | 3e1088366bf860effa27b1322906df56 | Candidatus_Competibacter | literature_supported_related_taxon | 15/15 | 0 | HOLD_no_matched_performance | not_measured |
| C15 | f23982138e4d5ed3fcb068cbac95af41 | Acinetobacter | functional_ambiguity | 11/15 | 0 | HOLD_no_matched_performance | not_measured |

6个GAO类群关联、4个Acinetobacter功能歧义、5个功能未知/未分配均不改变。短16S不能验证功能基因或活性，相对丰度不是绝对量，不乘MLSS/MLVSS/VSS转为严格绝对丰度。不重新筛选候选，不重跑DADA2、QIIME2分类、深度QC、功能映射或群落距离；未运行相关检验、机器学习、网络、因果或差异显著性检验。

## 实际核验、复现与保护

| status | check | evidence |
| --- | --- | --- |
| PASS | 必需文档与有效v2来源 | 19项存在；5份有效报告完整读取并记录指纹 |
| PASS | v2输入指纹锁定 | 9项上游v2输入及唯一原metadata与上一有效模块2.3来源清单一致 |
| PASS | 33样本唯一基准及五组映射 | 原metadata行序/14列逐值保留；设计逐ID核对8/2/4/15/4 |
| PASS | G4不平衡取样 | 4个基线+11个后期；R1=1/76/145d；R2–R4=1/30/76/145d，不补30d |
| PASS | 起始状态、保存及温度范围 | 4条前源、4℃59d、不同起始污泥与30℃/室温未知；实测全NA |
| PASS | 连续实体与母样 | G2/G3同轮；G4另起时间轴；G5与E3同实体、共1母样事件，163d为推算 |
| PASS | 既有候选集复用 | 读取5510行既有排名的selected字段，15候选与证据/分类审核一致；没有重新筛选 |
| PASS | 图片转录与适用范围 | 13项原表达/单位/有限正值及用户全阶段全反应器确认实际核对；未指定实测性质 |
| WARNING | 图片来源证据层级 | 会话图片已目视转录；本地无原图二进制，原图路径/指纹NA；原论文/测量日志未提供 |
| PASS | 递归来源盘点 | 187个既有文件含隐藏/忽略文件，排除.git和本脚本；无软链接/未审核来源 |
| WARNING | 原始测量数据缺口 | 新增进水图片来源13条；仍无可回查逐日/周期实测、出水序列或阶段实测均值 |
| PASS | 设置来源原位置 | 6条DO设置及4条G4温度条件，保存原表达、单位、文档行号；不计原始观测 |
| PASS | 13条来源长表 | 13项浓度仅各保存一次；原单位和盐类水合化学式保留，不换算元素或碱度 |
| PASS | 逐样本逐参数匹配与NA | 33行×14参数=462个参数位置均D/NA；30个内部采样事件键不等于30独立观测 |
| PASS | 共同进水条件映射 | 13条记录链接33样本；COD/NH4-N/TP条件覆盖均33/33，与A/B/C实测覆盖分列 |
| PASS | 常数协变量与浓度比 | 13项共同条件在33行均只有1水平；图示COD/NH4-N=4.6，不作COD/TN或去除率 |
| PASS | 参数覆盖率计算 | COD/NH4-N/TP进水条件100%；14参数可核实测覆盖仍0%；不将99个条件链接当99次测量 |
| WARNING | 时间锚点与测量口径 | 33行日历/周期ID未知；进水条件已确认，实测性质/窗口及出水仍缺，未自动标C类均值 |
| WARNING | 设计与推断局限 | 纵向相关、共享谱系、不同初始污泥、温度/反应器混杂、G5单母样；有效独立性能观测0 |
| FAIL | 性能关联分析门控（受影响步骤） | 14项参数无可审核匹配观测，15候选均暂不能进入性能相关检验；本轮审计继续交付 |
| PASS | 四表序列化回读 | 来源210行，来源长表13行，匹配33行，完整性14行；字段/值逐一回读一致 |
| PASS | 本次脚本输入保护 | 187个既有文件运行前后SHA-256一致；不写原始metadata/历史报告 |

输出仅指定6文件：[source_inventory.tsv](source_inventory.tsv)、[performance_raw_long.tsv](performance_raw_long.tsv)、[sample_performance_match.tsv](sample_performance_match.tsv)、[parameter_completeness.tsv](parameter_completeness.tsv)、本报告、[run.log](run.log)。额外新增的13行源转录文件属于原始来源数据，不是中间结果。无性能曲线，因为未提供时序测量；没有为常数条件制作误导性相关图。

命令：`/home/leiyiping/miniconda3/bin/python3 scripts/operational_performance_audit.py`。Python 3.14.7，Linux-6.18.33.2-microsoft-standard-WSL2-x86_64-with-glibc2.43，仅标准库。脚本SHA-256：`253c9329a5114914bb14c5bb0545bd9b2fd4c38a25d9418d8adc6260405eca0d`。默认输出`results/operational_performance/2026-11-06_influent_v2`；已有目录和v1输出均在写入前拒绝，需复现时指定尚不存在的新v2目录。不覆盖之前有效v2或原始metadata。脚本检测新未审核来源时非零停止，不用固定空数据结论忽略新增资料。

关键输入SHA-256如下；全部文件及源表逐记录定位见source_inventory。文档维护随后发生的README/累计解释/日志更新不改写本次运行时指纹。

| path | sha256 |
| --- | --- |
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| docs/batch_01/experiment_design.md | 59113eaaea346995e649000d562b647e3fd65d3690e93083b164dbcfbb31b755 |
| docs/batch_01/analysis_plan.md | c7250e1440ef404a4df1f06e39abe458ce0743588cb2ed2e1c48b6dba2d1d1ad |
| docs/batch_01/analysis_log.md | 12b576f0c9745fc33c16d3651ee4563285f239fdef6824195c51f43feaf35a66 |
| README.md | 4cabd2dd83a9f6fc69cc4e9e984d2b98ae7c5206ef48c5ee83447e4e7ebbb5f9 |
| docs/batch_01/results_interpretation.md | 1c3ade01cdddc4f29b4a6c8d47dd85149b064199fe2a74e1892177206921f31d |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 |
| data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv | e1a4ab1d329fb52fb8ccd9d4f15e12638d1d99a352b828a153372b69bfc1b3d6 |
| results/qc/stage1_report.md | f3ad9a3d7a542ae9c5c9e1ebffe1638e07746c1a78ec0e6dbd4a7588c49bae73 |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/functional_guilds/2026-11-03_v2/analysis_report.md | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| results/diversity/2026-11-04_v2/analysis_report.md | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| results/asv_contributions/2026-11-05_v2/analysis_report.md | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| results/candidate_asvs/2026-11-05_v2/analysis_report.md | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |

## 尚待补充的科研信息

全阶段/全反应器适用范围已解决，无须重报33样本清单或进水数值。仍需说明图片浓度是配水设定、单次实测或阶段均值；若为实测/均值，提供采样日期/周期、方法、底层记录数及窗口。后续性能审核重点为出水COD/氮磷、逐日/周期运行记录、DO/温度实测及16S日历或周期锚点；恢复时长、起始污泥登记/性状、流量/体积、HRT/SRT、MLSS/MLVSS等缺口不填补。缺失不等于0，共同进水条件覆盖100%不等于实测匹配通过或具备独立统计观测。


## 最终交付独立核验（不混加主流程17/4/1）

- PASS：13项图片转录与源表/长表原值、单位、完整化学式一致；33样本原字段/五组及429个共同条件链接、462个D/NA、14项覆盖/常数性通过独立核对。来源长表13条，不作为重复测量。
- PASS：临时项目从源数据复现指定六文件，范围/测量性质改变和新未审核来源在写入前阻断；已有目录重跑拒绝且六文件指纹不变。
- PASS：183个既有受保护文件SHA-256一致，含全部上游、原metadata及两个旧模块2.3目录；旧报告未修改。README、累计解释及日志已同步，累计解释旧正文及日志历史前缀保留，255个本地链接/锚点有效。
- 来源时间说明：source_inventory及输入表记录本次运行时指纹；三份总文档在运行后按约定同步，未改写历史输入指纹。源TSV、脚本和科研输入指纹不变。只保留新增源数据一份、六个本阶段产物及必要脚本，不产生逐项检查文件。

最终核验时间：2026-11-06T15:07:18.615761+08:00（Asia/Shanghai）。共同条件匹配PASS；未说明测量性质/时间仍WARNING；性能相关门控FAIL不变，无统计检验。
