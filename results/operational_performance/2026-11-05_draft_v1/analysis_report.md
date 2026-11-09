# 模块2.3：运行性能数据盘点、来源审核及16S样本匹配

实际执行：2026-11-05T17:24:05.723551+08:00 至 2026-11-05T17:24:06.204483+08:00（Asia/Shanghai）。用户指定版本目录为`2026-11-06_v1`；目录日期不代表未来日期已执行。输出目录：`results/operational_performance/2026-11-06_v1`。

**审计交付PASS；数据可用性WARNING；后续性能关联门控FAIL（关闭）。** 本次程序检查12 PASS / 3 WARNING / 1 FAIL。FAIL仅指受影响的后续分析前提未满足，盘点/匹配表正常完成，退出码0表示审计交付成功；必需输入、样本映射或保护断言失败均非零退出。

## 执行前检查与范围

先阅读AGENTS及研究背景、实验设计、分析计划、执行日志，完整读取5份有效v2报告并核对实际文件/表头，向用户给出检查发现、歧义及执行规则。唯一33样本基准为`metadata/source_sample_metadata.tsv`；原表没有group，按已确认设计名单逐ID核对既有2.1派生分组，G1–G5=8/2/4/15/4，不从operation_phase推测分组。匹配表保持原metadata行序。

递归盘点项目根目录`/home/leiyiping/Batch_01`，包括隐藏/忽略文件，排除.git内部、本模块新结果和本脚本；共174个既有文件，文件类型统计：{'.md': 17, '.tsv': 41, '.fasta': 1, '.biom': 1, '.qza': 4, '.sh': 1, '.json': 5, '.pdf': 45, '.png': 45, '.log': 7, '.rds': 1, '.R': 6}。未发现Excel（xls/xlsx/xlsm）、CSV、ODS、原始水质表或反应器运行测量日志。7个run.log均为16S分析日志；logs/dada2及logs/taxonomy为测序处理记录。41个TSV属于ASV、taxonomy、样本身份或既有16S派生结果。既有PDF/PNG均为这些模块的图件，不冒充原始实验记录。所有文件列入[source_inventory.tsv](source_inventory.tsv)，逐文件记录格式、大小、SHA-256、实际表头、参数文字提及及纳入/排除原因；文字提及不等于有测量值。

本结论仅限当前项目可访问内容，不宣称研究者从未测量或项目外没有记录；未遍历用户其他目录、联网寻找私人实验数据或将历史外部测序路径当成水质来源。新候选原始文件出现时脚本非零停止并要求新增来源审核，不能继续沿用本次空数据结论。未重新运行测序QC、DADA2、QIIME2分类、群落距离、功能映射或2.2筛选；既有上游计数/分类/序列QC按历史报告沿用，本次仅记录文件指纹。

## 来源审计与数据类型

未发现任何可提取的14项性能原始观测，故[performance_raw_long.tsv](performance_raw_long.tsv)仅有表头、0数据行。没有制造全NA伪原始行，也没有把文件修改时间当测量日期。表头预留原文件/工作表/行/列、原值/原单位、转换、反应器实体、相对日/日历/周期、进出水口径、测量类型、窗口及均值底层观测数等来源字段；无记录时不存在可声称已核实的单位、反应器或窗口，均不推定。

来源表另有10条`documented_setting`记录（6条DO、4条G4温度），逐条引用`docs/batch_01/experiment_design.md`实际行号、原表列名、原始表达及单位。Markdown没有工作表，worksheet为NA；文档转录的用户确认是证据层级，并非独立审阅原实验测量单。DO设定适用区间与实测平均时间窗分别处理：G2 0–21d、G3 23–56d、G4后期25–145d；第22天为过渡，无本批样本。G1/G4恢复/G5未确认完整区间，不补起止日。

- **进水/出水浓度：** 未找到，COD、各氮磷参数单位/方法/过滤口径均NA，不能计算去除率、氮磷平衡或负荷。
- **周期测量：** 未找到周期ID、周期内位置或测量记录；无法确认同一采样周期。
- **瞬时测量：** 所有样本DO/温度实测NA，其他参数也无可审核记录。
- **阶段实测平均：** 无原始序列或可回查均值、时间窗及底层观测数，C类记录为0；不把设置或0.5±0.2解释为实测均值±SD。
- **设计背景：** DO设置可覆盖33行（100%），其中G1八行保留5–7 mg/L范围、不取中点；25行有名义设置上下文（含四基线恢复设置3）。旧分析基线DO=NA、design_document=3及2.1新增恢复设置3全部原样分列。G4后期十一行及G5设置0.5±0.2，0.3/0.7仅为表达式算术界限。
- **温度背景：** G4运行标签15/33（45.454545%），其中R1/R3合7行有30℃运行设置上下文，R2/R4合8行室温数值NA。7行含E1/原G1两基线，不能认为这些采样瞬间/恢复阶段温度已确认为30℃；后期明确处于恒温运行阶段的采样有5行。非G4包括G5温度不外推。保存4℃只作历史条件，不计反应温度或实测覆盖率。

## 33样本匹配规则与实际覆盖率

[sample_performance_match.tsv](sample_performance_match.tsv)严格33行，sample_id对应原sample-id；保留原14列及2.1全部其余派生字段值，新增审核字段，未改写metadata。按sample_id、reactor_id、reactor_instance_id/轮次、stage_subphase、phase_days及其依据核对；日历日期和周期ID33/33缺失。每参数分别有value/unit/match_class/record_ids/missing_reason，实际462个参数位置均NA/D，文件包含的设计设置字段不能作为这462个位置的实测替代。

| 等级 | 必需证据 | 本次结果 |
|---|---|---|
| A | 同实体且同日，或明确同一采样周期；保留具体采样口径和原始记录ID | 0样本、0记录 |
| B | 同实体且明确位于采样前的时间窗；记录起止、相对采样位置、底层测量及汇总方法 | 0样本、0记录 |
| C | 有来源可回查的阶段实测均值及对应阶段/窗口，无法作同期或前窗口匹配 | 0样本、0记录 |
| D | 无可审核性能记录或身份/实体/日期/窗口不能匹配 | 33样本；每参数33/33 |

没有默认±天容差、最近邻自动匹配或任意7/14/30天窗口。即使以后有阶段均值，也只能链接其唯一record_id；不能复制给多个样本当作新的独立测量。当前同日与前窗口描述可用参数均为空，C类阶段平均参数也为空；仅DO设置及G4温度可作阶段设计背景。

| parameter | raw_record_n | measured_coverage | A_B_C_D | background_n |
| --- | --- | --- | --- | --- |
| COD | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| NH4-N | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| NO2-N | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| NO3-N | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| TN | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| PO4-P | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| TP | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| DO | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 33 |
| temperature | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 15 |
| pH | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| HRT | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| SRT | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| MLSS | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |
| MLVSS | 0 | 0/33 (0%) | 0 / 0 / 0 / 33 | 0 |

覆盖率分母固定33；完整逐参数计数、进出水/测量类型、设计背景覆盖率及缺失原因见[parameter_completeness.tsv](parameter_completeness.tsv)。此处background_n不进入A/B/C实测覆盖率。

## 实验单位、来源与历史边界

G1四个原反应器前后成对，约120d保留近似属性；G1结束后R1/R2、R3/R4各混合均分到新同名反应器，实体分轮次。G2/G3同一新轮次连续运行；B2→B3、D2→D3共用连续实体。G3末污泥4℃保存59天并恢复，再进入G4，不能把G2/G3与G4拼接连续轴；未提供的保存日历起止、恢复时长保持NA。原样本G1属于模块G4，与模块G1严格区分；“G1保存恢复”如指原样本G1，则其C2来源沿此边界；若指模块G1，本项目未确认该模块额外的保存恢复步骤，不自行增加。

| G4标签 | 恢复后基线（16S样本号） | 保存前来源 | 继承混合块 | G4温度运行条件 |
|---|---|---|---|---|
| R1 | E1 | A2 | post_G1_pool_R1_R2 | 30℃设置 |
| R2 | F1 | B3 | post_G1_pool_R1_R2 | 室温未知 |
| R3 | 原G1 | C2 | post_G1_pool_R3_R4 | 30℃设置 |
| R4 | H1 | D3 | post_G1_pool_R3_R4 | 室温未知 |

四份G4起始污泥状态/初始菌群各不相同；具体起始污泥登记编号、实测性状仍NA，基线测序样本号不当作污泥登记号。“不同”不能消除共享谱系。匹配表另列来源继承字段，并为G5通过同一R1运行实体保留E1←A2/混合块的继承关系，未改既有G5字段。

G4实际节点R1=1/76/145d，R2–R4=1/30/76/145d；R1没有30d，不插值。day1在切换前，后期11样本为按设计划定的稳定运行期；运行性能稳态本次因无原记录而无法评价，不能因此断言稳态或不稳。G5 S1–S4为R1同一母样四级分，163d保留145+18原表推算性质，不新增反应器。内部事件键共30个（33行减去同母样重复的3行），仅作匹配去重，不是30份独立生物观测。独立性能观测为0，缺失生物重复信息不补齐。

## 科研可行性逐项结论

1. **16S同期描述：** 无参数通过A类来源匹配；不能给出“同期COD/氮磷表现”。DO与G4温度只能作已确认设置背景。
2. **采样前窗口分析：** 无参数通过B；缺原始时序、日期/周期锚点及窗口证据，不能计算先行性能均值或滞后关联。
3. **阶段背景：** 有DO设置及G4温度运行标签；无C类阶段实测均值。阶段设置本身不能证明性能稳态、去除率或过程活性。
4. **相关检验独立观测：** 实测原始记录0、可匹配记录0、独立配对性能观测0；全部相关检验门控FAIL。33行、G4十五行及后期十一行均不能当作独立观测数。未来有数据仍需按具体参数/口径核验变异、时间结构、来源相关、有效实体数及模型可识别性，不能仅凭“凑够行数”放行。
5. **温度效应：** R1/R3=30℃、R2/R4=室温未知，每条件仅两个反应器标签；来源块、四份不同起始污泥、反应器个体、历史与纵向结构均相关/混杂。温度在反应器内无已记录操纵变化且室温数值未知，不能从现有比较独立识别温度作用，不能算精确温差或剂量曲线。
6. **候选ASV：** 原2.2十五候选全保留为后续审核名单；本次0个获准进入性能关联。不能因性能缺失淘汰某ASV或重跑筛选。补齐来源后可先按同一实体实际节点描述；六个GAO文献关联仅为假设背景，四个Acinetobacter保留功能歧义，五个功能未知/未分配同样可以作生态候选，但不得强配COD、除氮/磷功能。

下表直接沿用2.2候选ID/原属标签/证据与检出字段；没有重新计算筛选或贡献。功能/文献边界直接引用2.2已有审核快照，本模块未增加文献结论。

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

其中C01 Competibacter、C02分类受限d172…、C03 Defluviicoccus、C04 Chryseotalea及C05 Aridibacter仍是既有优先对象；C09 a578…未定属同样保留。低Confidence审核标记、短16S未比对及功能未知不因盘点而解除。16S相对丰度不是绝对丰度，不乘MLSS/MLVSS/VSS推成绝对细胞量；分类关联不等于功能基因或活性。

## 实际程序核验与交付

| status | check | evidence |
| --- | --- | --- |
| PASS | 必需文档与有效v2来源 | 18项存在；5份有效报告完整读取并记录指纹 |
| PASS | 33样本唯一基准及五组映射 | 原metadata行序/14列逐值保留；设计逐ID核对8/2/4/15/4 |
| PASS | G4不平衡取样 | 4个基线+11个后期；R1=1/76/145d；R2–R4=1/30/76/145d，不补30d |
| PASS | 起始状态、保存及温度范围 | 4条前源、4℃59d、不同起始污泥与30℃/室温未知；实测全NA |
| PASS | 连续实体与母样 | G2/G3同轮；G4另起时间轴；G5与E3同实体、共1母样事件，163d为推算 |
| PASS | 既有候选集复用 | 读取5510行既有排名的selected字段，15候选与证据/分类审核一致；没有重新筛选 |
| PASS | 递归来源盘点 | 174个既有文件含隐藏/忽略文件，排除.git和本脚本；无软链接/未审核来源 |
| WARNING | 原始运行数据缺口 | 未发现原始水质表、Excel/CSV/ODS、周期/瞬时/阶段实测均值或反应器运行日志；只限当前项目范围 |
| PASS | 设置来源原位置 | 6条DO设置及4条G4温度条件，保存原表达、单位、文档行号；不计原始观测 |
| PASS | 逐样本逐参数匹配与NA | 33行×14参数=462个参数位置均D/NA；30个内部采样事件键不等于30独立观测 |
| PASS | 参数覆盖率计算 | 14参数均0/33(0%)；A/B/C=0、D=33；设置背景覆盖率单列 |
| WARNING | 时间锚点与测量口径 | 33行日历/周期ID未知；无进出水、周期、瞬时、阶段均值记录；未擅定窗口长度/最近日容差 |
| WARNING | 设计与推断局限 | 纵向相关、共享谱系、不同初始污泥、温度/反应器混杂、G5单母样；有效独立性能观测0 |
| FAIL | 性能关联分析门控（受影响步骤） | 14项参数无可审核匹配观测，15候选均暂不能进入性能相关检验；本轮审计继续交付 |
| PASS | 四表序列化回读 | 来源184行，原始性能0行，匹配33行，完整性14行；字段/值逐一回读一致 |
| PASS | 本次脚本输入保护 | 174个既有文件运行前后SHA-256一致；不写原始metadata/历史报告 |

仅输出指定6文件：[source_inventory.tsv](source_inventory.tsv)、[performance_raw_long.tsv](performance_raw_long.tsv)、[sample_performance_match.tsv](sample_performance_match.tsv)、[parameter_completeness.tsv](parameter_completeness.tsv)、本报告及[run.log](run.log)。无统计图：没有原始性能值可供绘制；既有16S图表不复制。README、累计结果解释与执行日志由本轮同步维护。

复现：`python3 scripts/operational_performance_audit.py`。默认输出本指定目录；目录存在即在任何写入之前非零退出。需重现时指定`--output-dir results/operational_performance/尚不存在的新版本`。脚本仅支持当前审核确认的空性能数据状态，发现新原始候选源或实测字段时立即停止受影响分支，须审核后扩展提取/匹配规则。未进行相关性检验、机器学习、共现网络、差异显著性或因果推断；统计门控关闭是审计结论。

Python 3.14.7；Linux-6.18.33.2-microsoft-standard-WSL2-x86_64-with-glibc2.43；仅标准库csv/pathlib/hashlib/json/re/os/datetime/zoneinfo等，无依赖安装。命令：`/home/leiyiping/miniconda3/bin/python3 scripts/operational_performance_audit.py`。脚本SHA-256：`a161a0de5436d42bc7c1e04afd060e518a8d352c6ff0f22eb87a0eecb42dd2a0`。详细全部输入指纹见来源盘点，关键来源如下。

| path | sha256 |
| --- | --- |
| AGENTS.md | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| docs/research_context.md | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| docs/batch_01/experiment_design.md | 59113eaaea346995e649000d562b647e3fd65d3690e93083b164dbcfbb31b755 |
| docs/batch_01/analysis_plan.md | 65f7406f2e4b650503f24d3c0f3e1787d9d5d9bac4e98160cfa60c4c02534b44 |
| docs/batch_01/analysis_log.md | 5b9d48ff15c7722496d20ee43872cd645eb8b08ad007a72942aed1e180cde92f |
| README.md | 3f86f29ce86096a6d48fb4a6dd8ba46686e0b018ccc556acff89d7b26330b3b9 |
| docs/batch_01/results_interpretation.md | ac78ec1a0cf2e522a844fe51edc5730362ba3121379c60378f4929ae444bb4ed |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv | acd60f59f7f295a6a5ca09e9c4b801f3e90f5b5adea5b6d70e9ab5eec65d5676 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv | 12becc2660ff4240abda87da0afdc49ab9030dc12cad4182f35c02b8704d4a38 |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv | ecebcd797735c18047dfff3de1d0e8595a623c1ba98c6c2aeb8d768e5999c25e |
| results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv | 635f8e72ce397c2a49300785c496febd457bc09bcd760b3b3125c6bf0c20b455 |
| results/qc/stage1_report.md | f3ad9a3d7a542ae9c5c9e1ebffe1638e07746c1a78ec0e6dbd4a7588c49bae73 |
| results/community_composition/2026-11-03_v2/analysis_report.md | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| results/functional_guilds/2026-11-03_v2/analysis_report.md | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| results/diversity/2026-11-04_v2/analysis_report.md | 170affb1d6559571f712ffa74124d72b05caf50704fd03bd84c21cf5b8df688a |
| results/asv_contributions/2026-11-05_v2/analysis_report.md | 275fc5b40f7b3d229da6d2bc1b7f76f0a1d79d9ba57075734615eb386587d7d6 |
| results/candidate_asvs/2026-11-05_v2/analysis_report.md | 3c855120dc89d8ba64da5e60d82cd039b1681082807125b6733418c3c7301037 |

## 待人工补充的最小资料

原始水质/运行文件及工作表（含原列名、单位、方法/检测限和缺失标记）；每条记录反应器实际实体/轮次、进出水或周期位置、测量日期/相对日和时间基准；16S采样日历日期或明确周期ID/实验日起点；若仅有均值须给阶段/窗口、底层观测数和来源，不能充作重复观测。DO/温度需分设定与实测，室温不推定；另补恢复/基线温度范围、起始污泥登记/性状与运行稳态原证据（如有）。不需要重新提交已确认33样本名单/分组。缺失原始资料不解释为生物学零值，也不影响已完成的16S描述结果。
