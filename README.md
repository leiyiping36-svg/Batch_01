# AOA-AGS 16S 微生物群落研究

更新日期：2026-11-09（Asia/Shanghai）。本文件是贯穿项目的科研总览和导航；当前实际核查范围为 **Batch_01**，其他批次尚未在本目录核验。

**当前状态：模块2.6重点候选ASV共同演替与生态证据综合已完成（V2，69 PASS / 5 WARNING / 0 FAIL）。** 固定8目标与C01/C03两个GAO关联对照，三个研究单元分别展示R1/R2分化、R3后期及R2/R4趋近；只复用有效v2比例、已有贡献及模块2.5保守分类/证据，不重跑上游。R1/R2末段分化中C01/C02端点差扩大，R3中C04/N045上升与C05末段下降并存，R2/R4趋近以C01差缩小为主要数学来源；这些现象均不证明功能互作或温度/DO因果。详见[模块2.6报告](results/focal_asv_cosuccession/2026-11-09_v2/analysis_report.md)及[轨迹图](results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_trajectory_comparison.pdf)。模块2.5的7个目标功能UNKNOWN、N072仅近缘Vicinibacter异养/PHA及附着背景、C01/C03仅GAO关联对照均保持。33样本8/2/4/15/4、四不同G4起始污泥/纵向/温度标签及共同名义进水保持；无同期实测出水/去除率，原metadata、taxonomy、RDS及既有v2均不改。

文档整理期间工作区出现并行分析更新，以下进度已按新增报告及产物修订，不能继续沿用早期“对象暂缓”的状态。[模块1.1报告](results/community_composition/2026-11-03_v2/analysis_report.md)和日志记录该分析的授权及执行范围，本次仅引用这些记录。G4四个初始样本的设置存在版本差异：设计文档记录恢复设置3 mg/L，模块1.1分析字段按其报告记为NA，并在`design_document_DO_*`另保留3；不自行改写任一来源。

## 当前分析入口（模块1.1–1.3沿用有效v2）

| 分析模块 | 当前有效报告 |
|---|---|
| 模块1.1：群落组成与演替 | [community_composition/2026-11-03_v2](results/community_composition/2026-11-03_v2/analysis_report.md) |
| 模块1.2：传统功能相关类群 | [functional_guilds/2026-11-03_v2](results/functional_guilds/2026-11-03_v2/analysis_report.md) |
| 模块1.2：关键解释复核 | [定向review及ASV证据](results/diversity/2026-11-04_v2/module12_review.md) |
| 模块1.3：Alpha/Beta与变化幅度 | [diversity/2026-11-04_v2](results/diversity/2026-11-04_v2/analysis_report.md) |
| 模块2.1：G4条件与ASV趋近/分化贡献 | [asv_contributions/2026-11-05_v2](results/asv_contributions/2026-11-05_v2/analysis_report.md) |
| 模块2.2：候选ASV与分类学证据 | [candidate_asvs/2026-11-05_v2](results/candidate_asvs/2026-11-05_v2/analysis_report.md) |
| 模块2.3：正式人工进水配方及派生metadata | [operational_performance/2026-11-06_design_recipe_v2](results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md) |
| 模块2.4第一阶段：非传统生态ASV补充筛选 | [ecological_candidates/2026-11-07_v2](results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md) |
| 模块2.5第一阶段：定向分类核实与生态证据 | [candidate_ecology/2026-11-08_v2](results/candidate_ecology/2026-11-08_v2/analysis_report.md) |
| 模块2.6：重点ASV共同演替与生态证据综合 | [focal_asv_cosuccession/2026-11-09_v2](results/focal_asv_cosuccession/2026-11-09_v2/analysis_report.md) |

模块1.2已从群落v2的metadata、采样顺序和对应原始count重新复现。两模块的v1均为历史目录，不作为后续研究的当前入口；旧记录折叠保留。

模块1.3仅读取上述群落/功能v2及其指纹核对一致的原始count与既有对象。用户已明确撤回并要求删除模块1.3初次输出，`results/diversity/2026-11-04_v1/`已删除；当前多样性入口仅为v2。其他模块历史v1未作处理，原始数据及有效v2均未改写。

## 项目背景与研究目标

研究AOA-AGS系统不同运行阶段、污泥设计类型及粒径组分的16S rRNA扩增子群落特征；系统名称的具体展开以原始实验记录为准。目标是识别可重复的群落变化，在可靠设计与元数据支持下评估条件关联，再决定是否具备探索组装机制、功能类群或机器学习特征的条件。

项目涉及多批次、同一反应器多时间点和跨轮次接种关系。历史背景记录引物为338F/806R，仍须按批次原始材料复核；本目录没有原始FASTQ，不能据现存ASV反推全部测序前处理细节。研究背景和解释边界见[研究背景](docs/research_context.md)。

16S分类不等同于功能基因测定或活性证据；相对丰度不等同于绝对丰度，也不能简单乘以VSS/MLVSS后称为严格绝对丰度。现有研究条件不安排新的独立验证实验，未验证的机制应保留为假设。

## 已确认的实验设计与33样本

当前依据为[2026-11-02设计修正](docs/batch_01/experiment_design.md#2026-11-02-design-correction)、[2026-11-03 DO与取样位置补充](docs/batch_01/experiment_design.md#2026-11-03-DO-settings)及[2026-11-05 G4起始污泥与温度补充](docs/batch_01/experiment_design.md#2026-11-05-G4-conditions)。五模块记录数固定为 **G1=8、G2=2、G3=4、G4=15、G5=4**；这些是取样行数，不是独立生物重复数。**8/6/4/11/4属于历史版本，不得用于当前分析**；旧数量只作历史追溯。

下表使用原样本名；对应ASV ID为`Batch_01_`加该原名（例如A0对应`Batch_01_A0`），与现有metadata及ASV表头对应。模块代码G1–G5与原样本G1/G2/G3/G4必须区分，后四者全部属于模块G4。

| 模块 | 科研问题与样本数 | 完整原样本清单 | 时间与DO阶段设置（mg/L） |
|---|---|---|---|
| G1 | 低C/N启动前后；8行 | A0、A1、B0、B1、C0、C1、D0、D1 | 四个原反应器前后；原表第1天与约120天；设置5–7，不取中点 |
| G2 | DO设置5阶段末；2行 | B2、D2 | 混合后新轮次0–21d，第21天采样；设置5 |
| G3 | DO设置3阶段末；4行 | A2、B3、C2、D3 | 与G2同轮连续，23–56d，第56天采样；设置3；第22天为过渡过程，无本批样本 |
| G4 | 保存恢复后低DO时间序列；15行 | E1、E2、E3、F1、F2、F3、F4、G1、G2、G3、G4、H1、H2、H3、H4 | 4个恢复结束、切换前基线设置3；后期30/76/145d共11行，阶段25–145d设置0.5±0.2 |
| G5 | 同一母样的粒径分级；4行 | S1、S2、S3、S4 | G4-R1延长18d后一次母样事件，原表145+18推算163d；设置0.5±0.2 |

R1/R2为絮状污泥设计类型，R3/R4为颗粒污泥设计类型，初始仅R3/R4加入颗粒污泥；不代表每次取样已有形态实测。原metadata编码`Reactor_01`–`Reactor_04`对应R1–R4，跨轮次不能只凭标签认定同一实验实体。

- G1结束后，原R1+R2混合再均分至新R1/R2；原R3+R4混合再均分至新R3/R4。共享来源与混合比例未知的限制必须保留，两个来源块不自动等于两份已验证独立重复。
- G2→G3中B2→B3、D2→D3分别为同一新反应器的阶段末记录。DO、时间和阶段共同变化，不能由此分离DO因果效应，也不能补造缺失的同期样本。
- G4初始来源为E1←A2、F1←B3、原G1←C2、H1←D3，经历4℃保存59d及恢复。低DO实验开启新的时间轴，不能跨保存恢复与G2/G3拼接连续运行日数。E1/F1/原G1/H1的day1是起始编号，取样在低DO切换前。
- G4各记录日1/30/76/145d分别4/3/4/4行；后期11行可称按实验设计划定的低DO稳定运行期，运行性能是否证明稳态另行核验。15行保留作完整序列，不能全部归为同一稳定条件。
- 2026-11-05确认G4的R1/R3为30℃保温、R2/R4为室温，实际室温未知；四份初始污泥性状与初始菌群均不同，具体编号及性状记录NA。混合来源依赖仍保留，不能分离温度、反应器个体和初始状态效应；温度标签不外推其他模块或基线/恢复期实测。
- G5为同一R1母样的S1<100、S2为100–200、S3为200–500、S4>500 μm四个组分，不是四份独立生物重复，也不自动称技术重复。

所有33个采样瞬间的实测DO均未知、保持NA。0.5±0.2是阶段设置，0.3–0.7仅为算术界限，不是实测范围或均值±标准差。日历日期、恢复时长、约120d精确性、混合比例/接种量、母样原始编号及筛分边界处理仍有缺口。

## 数据处理与科研分析流程

下表区分历史已完成、当前方案和未来步骤；未来方法与参数均须在设计门控后确定，表中列出的候选方法不表示已执行。现有导出、基础QC和分类结果沿用，不重复DADA2、SILVA或深度QC。

| 步骤与状态 | 分析目的、方法及关键参数 | 输入 | 输出与依据 |
|---|---|---|---|
| 1. 测序与前处理：本目录记录不全 | 核验测序批次、引物、裁剪及样本改名来源；338F/806R仅为背景线索，前处理完整命令与原FASTQ未收录 | 上游原始记录；现有`logs/dada2/` | 本地仅保留上游日志，不将外部绝对路径当作本地已有文件 |
| 2. DADA2去噪：历史已完成 | 双端去噪；trunc-len F/R=270/230，trim-left=0/0，max-ee=2/2，min-overlap=12，trunc-q=2；线程2，learn reads=1,000,000；independent pooling、consensus去嵌合体、hashed IDs、retain-all-samples | 历史`demux-trimmed.qza`（上游路径） | 现存`input/qiime2/table.qza`、`rep-seqs.qza`、`denoising-stats.qza`；[命令记录](logs/dada2/commands.sh)、[参数记录](logs/dada2/parameters.json)；本次不重跑，初始参数说明不替代实际命令 |
| 3. 分类注释：历史已完成 | 既有SILVA分类；日志所记分类器文件名为`silva144-2026.7-full-length.qza`，confidence=0.7，read_orientation=same，n_jobs=1，reads_per_batch=100；文件名不代替数据库训练来源验证 | 代表序列及外部分类器，路径/指纹见日志 | `input/qiime2/taxonomy.qza`、`data/taxonomy.tsv`；[输入参数](logs/taxonomy/inputs.json)、[版本](logs/taxonomy/versions.json)、[分类验证记录](logs/taxonomy/validation.json) |
| 4. 导出及基础核查：已完成并复用 | 统一R脚本验证格式、唯一ID、181,830个非负整数计数、ASV/分类/序列对应、BIOM逐格一致及QZA数据成员指纹；深度异常用Tukey 1.5×IQR仅标记；无过滤/稀释/归一化 | ASV TSV、taxonomy TSV、FASTA、BIOM、原metadata和3个对应QZA | 原始导出位于`data/`；[阶段1综合报告](results/qc/stage1_report.md)首轮完整记录；本次仅引用 |
| 5. 设计与metadata映射：已复核并形成派生表 | `--review-design --compact-report`读取明确名单、原metadata和ASV表头；原方案附加27字段，模块1.1另留版本/DO来源差异字段；原14列不变 | 原metadata、实验设计、分析计划、ASV表头 | 原表无`group`，分析表见`results/community_composition/2026-11-03_v2/analysis_metadata.tsv`；G4基线设置版本差异显式保留 |
| 6. 最终对象：已生成并复用 | 复用既有QC指纹，核验样本/特征数、方向、计数/分类/序列/metadata及序列化内容；不兼容即FAIL，不覆盖 | 原计数/分类/序列及分析metadata | `results/phyloseq/batch_01_phyloseq.rds`；实际构建/复用记录追加于阶段1报告，允许描述不代表统计门控通过 |
| 7a. 描述性组成/演替：模块1.1 v2已完成 | 原count除以各样本全部reads；按门/纲/属完整谱系求和，无筛选、稀释；主分析G1–G4共29样本等权选Top10/10/15，G5四组分独立展示；Others与Unclassified分开，逐节点及反应器×阶段取已命名属Top3 | 核验对象及派生metadata | `scripts/community_composition.R`；v2目录内三阶元矩阵、Top3汇总、主图、R1–R4轨迹图、G5图及综合报告；43 PASS/4 WARNING/0 FAIL |
| 7b. 多样性：模块1.3 v2描述性完成 | 未抽稀Observed、Shannon、Simpson及探索性Chao1；相对组成Bray、二元Jaccard；主29/G5分别PCoA，主29用Lingoes；等深度31457×100、Hellinger、CLR及低检出敏感性 | 原count、兼容对象、群落/功能v2及已确认设计 | [综合报告](results/diversity/2026-11-04_v2/analysis_report.md)；40 PASS/6 WARNING/0 FAIL。完整距离/坐标、G4变化表及PDF/PNG已生成；不含推断或系统发育多样性 |
| 7c. 重点ASV：模块2.2已完成 | 指定5+其余10对max Bray贡献≥0.005前10；≥1/5 reads分层检出、实际节点持续性、原分类/序列/文献审核；阈值0.0025/0.01敏感性 | 模块2.1完整轨迹/贡献、功能v2及原taxonomy/rep-seqs | [模块2.2报告](results/candidate_asvs/2026-11-05_v2/analysis_report.md)；5510全量排名、15候选分类/证据表、轨迹PDF/PNG；18 PASS/4 WARNING/0 FAIL |
| 8. 条件关联与差异分析：未开展且需方法门控 | 逐问题检查独立单位、配对/纵向结构、来源块、混杂、可交换性、有效样本量及可识别性；通过后才选择重复测量方法、受限置换或适配组成数据的差异方法及多重校正，参数待定 | 可靠设计、对象及可追溯环境记录 | 当前无p值、显著性或因果结果；G5不作级分间显著性检验，不以未知瞬时DO作连续协变量 |
| 9. 扩展生态研究：条件性规划 | 组装、功能类群、网络或机器学习仅按可行性逐项评估；机器学习须按反应器/来源等实际相关结构防泄漏，避免跨轮次相关样本进入训练与测试两端；不自动全部实施 | 足够且匹配问题的样本、环境与谱系证据 | 当前无对应结果；方法、阈值、模型及验证方案均未确定 |

### 执行入口与软件记录

统一脚本：[scripts/stage1_pipeline.R](scripts/stage1_pipeline.R)。以下是**需要复现映射时**的命令，本次文档任务没有执行；运行会向原综合报告追加一次复核记录。

```bash
cd /home/leiyiping/Batch_01
/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/stage1_pipeline.R --review-design --compact-report
```

`--review-metadata`检测到已确认设计后转入设计复核。默认全流程会读取原metadata并检查对象门控；当前原表仍缺少正式分组/来源列，不作为文档整理或恢复工作入口，也不重复执行。

模块1.1使用`stage1_pipeline.R`的`--build-confirmed-design --analysis-dir`分支构建/复用对象，随后由[community_composition.R](scripts/community_composition.R)分析。整理期间新增的日志与报告已记录实际执行，取代本次初检时“仅发现代码、尚无运行记录”的状态。本次不运行这些入口。需要复现组成结果时，应指定不存在的新版本目录：

```bash
/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/community_composition.R --output-dir results/community_composition/NEW_VERSION
```

v1保留为历史：图例裁切、浮点边界删除柱顶段和Incertae_Sedis误计命名属已在v2修正；v2新增实际绘图层比例守恒断言。原始谱系丰度未改变，未分类标记、Top N和优势属汇总发生更新，引用以v2为准。

v2还补充了[G5独立Top N图](results/community_composition/2026-11-03_v2/G5_independent_top_taxa.pdf)：按G5四级分自身等权均值选门/纲Top10、属Top15，作为G5主要展示；原`G5_size_fraction_composition`保留作主分析Top N的统一配色对照。该补充有单独PASS记录，不并入主分析43/4/0数量；四级分等权均值不代表母样重建。补充入口为`--g5-detail --output-dir EXISTING_RUN`，本次未执行。

历史分类日志：QIIME2 2026.7.0、scikit-learn 1.7.1、Python 3.12.13。首轮完整QC：R 4.5.2、phyloseq 1.54.0、Biostrings 2.78.0、biomformat 1.38.0、digest 0.6.39；设计复核仅需R与digest。模块1.1另用ggplot2 4.0.3、scales 1.4.0，无随机步骤。完整版本、时间、参数和对应输入/脚本SHA-256见各综合报告，各历史指纹只对应各自运行版本。

## 已完成工作的实际结果与科学意义

以下数值引用现有报告和技术日志，本次没有重读计数或重新计算科研QC。

| 实际结果 | 科学意义与解释限制 |
|---|---|
| 33个样本、5,510个ASV；总reads为1,364,804 | 形成可追踪的扩增子数据基础；ASV数不是物种数，也不代表独立实验单位数 |
| 样本深度31,457–53,307，中位数42,004；Tukey界限25,250–56,466，无被标记样本 | 未发现该规则下的深度异常或空样本；不证明测序饱和、覆盖充分或可忽略深度差异 |
| ASV、taxonomy、FASTA的5,510个Feature ID一致；33样本与metadata一致；原计数与BIOM一致 | 支持后续整合的身份与数值一致性，不替代实验记录真实性核验 |
| 显式分类前缀解析：门4,927、属3,664个ASV有注释，种为0；代表序列长度333–453 bp | 属级注释可支持待开展的描述，缺失阶元保留NA；不能据此解释功能或得出种水平组成结论 |
| 最新设计复核（2026-11-03 14:59:48）：21 PASS、5 WARNING、0 FAIL | 仅确认本次设计/映射方案断言通过；重复采样、不平衡、共享来源和G5层级限制仍在 |

首轮完整QC（2026-11-02）为54 PASS、14 WARNING、3 FAIL，当时因缺少分组及来源字段未生成RDS；后续模块1.1通过派生表完成对象构建，历史失败保留。最新映射21/5/0与组成43/4/0分别只表示各自检查范围通过，不能当作统计适用性验收。

v2实际描述发现：G1的R1/R2最高丰度已命名属由Defluviicoccus转为Acinetobacter，R3/R4前后均为Candidatus_Competibacter；G2/G3中R4该属由55.49%变为91.06%。G4后期按各反应器阶段均值Top3求交集，共同属为Defluviicoccus；各反应器最高属轨迹仍不同。G5最高已命名属依次为Acinetobacter（30.13%）、Thauera（20.84%）、OLB8（9.70%、9.66%）。这些是本批读数比例与排序描述，不能解释为显著性、绝对量变化、功能或DO因果效应。属级未分类比例为各样本2.41%–44.72%，最高已命名属不一定是全部类别中比例最高者。

详细数值、图表、解释及限制累计于[科研结果解释](docs/batch_01/results_interpretation.md)，原始方法与全量结果保留于[模块1.1 v2报告](results/community_composition/2026-11-03_v2/analysis_report.md)。

主29样本等记录权重平均相对丰度前三个已命名属为Candidatus_Competibacter 24.64%、Acinetobacter 14.09%、Defluviicoccus 12.11%（原报告最终复核）。这只是该不平衡取样集合的描述均值，不是独立重复总体估计；E3及G5较高的未分类比例也限制属级解释。

## 当前进度与下一步

- **已完成**：基础QC与33样本映射；最终对象、独立派生metadata、门/纲/属组成、四反应器轨迹和G5分级展示（模块1.1 v2）；总览、解释与日志维护机制已建立。
- **新增完成**：模块2.1固定10对ASV贡献、跨时间差缩小/扩大及反应器内升降、三目标属内ASV、功能连接和既有敏感性复用；不重跑Alpha/Beta或功能映射。详细数值见[模块2.1累计解释](docs/batch_01/results_interpretation.md#module21-g4-asv-contributions)。
- **历史字段差异**：G4基线设计恢复设置3与旧v2分析NA继续保留；模块2.1新字段单列恢复设置及2026-11-03来源，既有对象和45列派生表不改写。
- **模块2.2已完成**：指定5个加固定贡献规则补10个，共15候选；全5510排名及两种检出/真实节点持续性、原分类/序列和6篇文献证据审核见[模块2.2](results/candidate_asvs/2026-11-05_v2/analysis_report.md)。
- **模块2.3已完成**：13项配方正式标为design_recipe，新建33×93派生metadata，原63列完整保留；一份配方共享而非33条独立水质观测，名义比值4.6/约69.70。A/B/C实测各0、D=33、实测覆盖0%不变，15候选仍不进入性能关联。[正式配方解释](docs/batch_01/results_interpretation.md#module23-design-recipe-confirmation)。
- **后续待开展**：配方性质/数值/适用范围均已确认，无须再确认；需要实际进出水/运行测量及16S日期或周期锚点，才能审核同期/采样前窗口/阶段实测均值与具体方法。定向参考比对已由模块2.5完成，组成共同演替已由模块2.6完成；性能关联、显著性和机制推断未开展；G5单母样及各轮次/谱系/初始污泥/温度混杂继续限制推断。
- **按问题补证**：运行性能稳态证据、精确时间/恢复时长、接种量与筛分细节、不平衡取样原因及跨批次可比性。采样瞬时DO已明确无具体值，保留NA，不再将其作为已知阶段描述的阻断条件。后续批次尚未核查，批次效应也尚未评估。

## 文档与详细报告导航

| 文件 | 职责 |
|---|---|
| [项目工作约定](AGENTS.md) | 数据保护、科研门控与文档维护规则 |
| [研究背景](docs/research_context.md) | 全项目研究目标、条件和方法学边界 |
| [Batch_01实验设计](docs/batch_01/experiment_design.md) | 权威样本名单、用户确认、时间/谱系/DO来源与字段边界 |
| [Batch_01分析计划](docs/batch_01/analysis_plan.md) | 五模块问题、阶段验收及方法限制 |
| [Batch_01科研结果解释](docs/batch_01/results_interpretation.md) | 分模块累计实际数据、发现、图表、生态学解释与待验证假设 |
| [Batch_01执行日志](docs/batch_01/analysis_log.md) | 按日期保留命令、参数、输入输出、核验与决定 |
| [阶段1综合质量报告](results/qc/stage1_report.md) | 基础QC、映射与对象构建/复用记录，保留历史检查、指纹、版本与样本深度 |
| [模块1.1有效报告（v2）](results/community_composition/2026-11-03_v2/analysis_report.md) | 群落组成/演替方法、实际发现、43/4/0检查与版本修正 |
| [模块1.1历史报告（v1）](results/community_composition/2026-11-03_v1/analysis_report.md) | 首轮产物保留，已被v2修正，不作当前图表与优势属依据 |
| [最终phyloseq对象](results/phyloseq/batch_01_phyloseq.rds) | 未过滤原始计数、分类、序列与派生metadata；对象成功不等于统计前提通过 |
| [派生metadata（v2）](results/community_composition/2026-11-03_v2/analysis_metadata.tsv) | 保留原14列及附加映射/来源/版本，记录G4基线DO来源差异 |
| [原始metadata](metadata/source_sample_metadata.tsv) | 保留原33行14列；确认修正通过方案表达，不回写原表 |

不存在的未来报告不列为已交付链接。每完成一个科研分析步骤，同步更新执行日志、结果解释和本文件的日期、进度、主要发现及报告链接；本文件保持概括，详细解释集中在结果解释文档，机器核查证据仍集中于阶段综合报告。历史错误或被取代的设计标明日期、来源及替代关系，不静默删除。


## 2026-11-03 模块1.1最终交付补充

已完成原始count的门/纲/属相对组成、R1–R4实际采样顺序演替、同母样G5粒径组分描述；主分析29个样本，G5四个级分独立展示。有效产物为[2026-11-03_v2综合报告](results/community_composition/2026-11-03_v2/analysis_report.md)，首轮v1仅作历史保留。完整输入、版本、参数、实际检查与来源差异以报告为准。

- R4所有已采样节点最高丰度已命名属均为Candidatus_Competibacter；R3的G4后期30/76/145d以Defluviicoccus为最高丰度已命名属（24.27%/24.41%/24.77%）。
- G5的S1最高已命名属Acinetobacter为30.13%，S2的Thauera为20.84%，S3/S4的OLB8分别9.70%/9.66%。优先使用[G5独立Top N图](results/community_composition/2026-11-03_v2/G5_independent_top_taxa.pdf)，[PNG](results/community_composition/2026-11-03_v2/G5_independent_top_taxa.png)同步提供；原G5图作为主分析Top N配色对照。
- [优势属汇总](results/community_composition/2026-11-03_v2/dominant_genera_summary.tsv)包含逐样本与反应器阶段Top3；门/纲/属丰度矩阵、派生metadata及7组PDF/PNG位于同一目录。固定[phyloseq对象](results/phyloseq/batch_01_phyloseq.rds)包含全部5,510 ASV与33样本原始计数。
- 主分析43 PASS/4 WARNING/0 FAIL；三阶元独立重聚合误差<1e-12，重复执行不覆盖检查通过。未运行推断统计，不能分离DO、时间和来源效应。G4初始设置按本次请求为NA，文档历史恢复设置3另列；全部实测DO未知。

复现使用现有R环境依次运行（新目录避免覆盖）：

```bash
/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/community_composition.R --output-dir results/community_composition/NEW_VERSION
/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/community_composition.R --g5-detail --output-dir results/community_composition/NEW_VERSION
```

详细科学解释见[模块1.1交付说明](docs/batch_01/results_interpretation.md#module11-final)。原始输入、实验设计及AGENTS.md均未由本分析流程改写。

<details>
<summary>模块1.2旧版记录（v1，已被v2替代，仅供追溯）</summary>

## 2026-11-03 模块1.2进度更新

传统功能相关类群识别与描述性相对丰度已完成，有效结果为[results/functional_guilds/2026-11-03_v1](results/functional_guilds/2026-11-03_v1/analysis_report.md)。33样本、5,510 ASV原始count全部保留，G1–G5=8/2/4/15/4，沿用模块1.1顺序与混合/保存恢复分面。
本次 49 PASS / 6 WARNING / 0 FAIL。Nitrospira、PAO/GAO歧义、分类不足及待研究类群单列；映射表有来源、规则和核实层级，所有功能标记仍是16S间接关联。
[详细解释与实际比例](docs/batch_01/results_interpretation.md#module12-functional-guilds)；[G4逐属趋势](results/functional_guilds/2026-11-03_v1/G4_functional_taxa_trends.pdf)、[G5组成](results/functional_guilds/2026-11-03_v1/G5_functional_composition.pdf)、[PAO/GAO对照](results/functional_guilds/2026-11-03_v1/PAO_GAO_descriptive_comparison.pdf)。PDF/PNG均提供。无显著性检验、网络、因果、功能基因或活性结论。


模块1.2主要观察：主29样本GAO关联保守代理等记录均值36.9059%，AOB关联0.4220%、PAO关联0.1861%；这些均为16S属标记读数比例。G4-R2的GAO关联代理从初始20.72%至145d的62.48%，R4各节点50.47%–74.91%。Nitrospira和Brocadia受限标签单列，保守NOB/AnAOB为0不等于相应功能不存在。独立重算与输出不覆盖检查通过；没有功能基因/活性或DO因果结论。


<a id="community-v2-analysis-baseline"></a>

## 2026-11-03 用户确认：后续分析以群落组成v2为基础

- 当前有效的模块1.1基线为 `results/community_composition/2026-11-03_v2/`。群落组成 `2026-11-03_v1/` 仅保留历史与追溯，不用于后续分析输入或当前科研结论。
- 模块1.2已经使用群落v2：派生metadata、采样顺序和组成解释均引用群落v2；功能类群丰度仍从对应的原始ASV count与原taxonomy计算，分母为样本全部reads。
- `results/functional_guilds/2026-11-03_v1/` 是**模块1.2自身的首次结果版本**，并不表示基于群落组成v1。它是当前有效功能分析结果；不同模块的版本号分别管理。
- 本次来源复核通过，现有结果直接沿用，无需重复分析或仅为统一版本号复制/重命名结果。后续以群落v2及其可追溯原始输入作为基础；如另有新版本，须明确记录新的有效依据。

当前入口：[群落v2报告](results/community_composition/2026-11-03_v2/analysis_report.md)、[基于群落v2的模块1.2报告](results/functional_guilds/2026-11-03_v1/analysis_report.md)。


</details>

## 2026-11-03 模块1.2进度更新

传统功能相关类群识别与描述性相对丰度已完成，有效结果为[results/functional_guilds/2026-11-03_v2](results/functional_guilds/2026-11-03_v2/analysis_report.md)。33样本、5,510 ASV原始count全部保留，G1–G5=8/2/4/15/4，沿用模块1.1顺序与混合/保存恢复分面。
本次 50 PASS / 6 WARNING / 0 FAIL。Nitrospira、PAO/GAO歧义、分类不足及待研究类群单列；映射表有来源、规则和核实层级，所有功能标记仍是16S间接关联。
[详细解释与实际比例](docs/batch_01/results_interpretation.md#module12-functional-guilds-v2)；[G4逐属趋势](results/functional_guilds/2026-11-03_v2/G4_functional_taxa_trends.pdf)、[G5组成](results/functional_guilds/2026-11-03_v2/G5_functional_composition.pdf)、[PAO/GAO对照](results/functional_guilds/2026-11-03_v2/PAO_GAO_descriptive_comparison.pdf)。PDF/PNG均提供。无显著性检验、网络、因果、功能基因或活性结论。

## 2026-11-04 模块1.2复核及模块1.3 v2

有效产物：[多样性综合报告](results/diversity/2026-11-04_v2/analysis_report.md)、[定向review](results/diversity/2026-11-04_v2/module12_review.md)、[累计结果解释](docs/batch_01/results_interpretation.md#module13-diversity-v2)。计算入口为[scripts/diversity_analysis.R](scripts/diversity_analysis.R)；主流程 **40 PASS / 6 WARNING / 0 FAIL**，独立交付核验另记。已按用户要求删除模块1.3初次v1目录，保留日志中的撤回记录。

- 功能解释复核：S2 Thauera 20.8413%、PAO候选20.8664%，证据仍限于特定参考菌株；3个Brocadia--other共795 reads，完整谱系、原置信度及分布已列出，未升级属/功能确证；18 Nitrospira保留NOB/comammox歧义。原功能映射与丰度不变。
- G4基线至145d的Bray：R1 **0.7623**、R2 **0.7908**、R3 **0.6837**、R4 **0.4690**。相邻节点均记录真实间隔，R1缺30d不插补。
- R2的76→145d Bray **0.6059**，Shannon **4.4318→3.0742**；R3同期Bray **0.2192**、Jaccard **0.6822**，只能称丰度加权组成变化相对较小，不能称成员或运行性能稳定。
- R4的Competibacter优势与较低Shannon相容，但R4并非每个G4节点最低；不能由属级优势推断多样性因果关系。R2–R4末期Bray趋近、R1–R2分化，不能宣布全系统趋同。
- G5 S1–S4 Shannon **3.8558/4.2379/4.3409/4.3441**；S3–S4 Bray最近（**0.2576**）。四份都是同一母样级分，不提供粒径效应显著性或独立复现。
- 深度子抽样对Bray排序影响很小；CLR与Bray的主29距离秩相关仅约**0.56–0.59**，不宣称对所有组成方法稳健。Chao1受单例贫化限制；所有结果均为描述。

保存[Alpha表](results/diversity/2026-11-04_v2/alpha_diversity.tsv)、[Bray矩阵](results/diversity/2026-11-04_v2/bray_curtis_distance.tsv)、[Jaccard矩阵](results/diversity/2026-11-04_v2/jaccard_distance.tsv)、[PCoA全轴坐标](results/diversity/2026-11-04_v2/pcoa_coordinates.tsv)、[G4反应器内变化](results/diversity/2026-11-04_v2/G4_within_reactor_changes.tsv)、[同期反应器距离](results/diversity/2026-11-04_v2/G4_same_day_between_reactors.tsv)及敏感性结果。主图为[G4 Shannon](results/diversity/2026-11-04_v2/G4_shannon_trajectories.pdf)、[主29 PCoA](results/diversity/2026-11-04_v2/main29_bray_pcoa.pdf)、[G4相邻变化](results/diversity/2026-11-04_v2/G4_adjacent_changes.pdf)、[G5 PCoA](results/diversity/2026-11-04_v2/G5_bray_pcoa.pdf)，同目录含全部12组PDF/PNG及run.log。主PCoA局部样本标签重叠，精确定位应查询坐标表。



## 2026-11-05 模块2.1：G4条件与ASV贡献

[综合报告](results/asv_contributions/2026-11-05_v2/analysis_report.md)；[累计详细解释](docs/batch_01/results_interpretation.md#module21-g4-asv-contributions)；[设计差异审核](results/asv_contributions/2026-11-05_v2/g4_design_addendum.md)；[派生metadata](results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv)。计算入口为[scripts/g4_asv_contributions.R](scripts/g4_asv_contributions.R)，主流程22 PASS/2 WARNING/0 FAIL，独立全表复核另列。保留全部5,510 ASV及指定10对，不修改旧v2或原始输入。

- R2/R4在76→145d Bray **0.804296→0.435510**。同一Competibacter ASV `3cae56af0b082bba9c858d1844913fc3`在R2 **5.15%→44.71%**、R4 **55.40%→38.90%**，端点差缩小对应Δ贡献 **−0.222247**；存在相同ASV共享，并非只因属标签相同。
- R1/R2末段Bray **0.480549→0.777441**。上述ASV差扩大贡献 **+0.197705**，分类不足/功能未分配ASV `d1725130559823512a63bbc2c1bab523`贡献 **+0.096226**。两种CLR距离却略降，分化描述具有指标依赖。
- R3末段Bray **0.219243**、相同ASV共享组成量 **0.780757**，主要ASV持续较高比例；Jaccard仍 **0.682243**，不能称成员或运行性能稳定。30→76d只有Bray为同期最小，Hellinger/CLR的R4更小。
- R2/R4末期Competibacter属标签共享量50.35%，相同ASV共享量41.93%；Defluviicoccus分别6.81%与2.57%，属内差异不能忽略。GAO/PAO等关联原样沿用，Nitrospira/Dechloromonas/Thauera歧义不升级。
- G4 R1/R3=30℃、R2/R4=室温未知，四份起始污泥不同；混合均分、4℃59天保存恢复、纵向采样使温度效应难独立估计。不能认定温度导致趋近或低DO导致分化，无显著性/网络/温度因果模型。待补具体污泥编号/性状、室温实测、恢复/基线温度范围和稳态性能证据。

图件：[R2/R4趋近](results/asv_contributions/2026-11-05_v2/R2_R4_convergence.pdf)、[R1/R2分化](results/asv_contributions/2026-11-05_v2/R1_R2_divergence.pdf)、[R3后期组成](results/asv_contributions/2026-11-05_v2/R3_late_composition_persistence.pdf)，同目录含PNG及全量TSV。完整ASV ID可读；少量边缘距离数字截断，精确值查[focal_distance_summary.tsv](results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv)。7 TSV、3组PDF/PNG、设计审核、中文报告及run.log共16文件；最大独立数值误差约5×10⁻¹⁶，任务前139个科研文件未变，设计仅追加已确认信息。


## 模块2.2：重点候选ASV与分类证据（2026-11-05）

[中文综合报告](results/candidate_asvs/2026-11-05_v2/analysis_report.md)与[详细解释](docs/batch_01/results_interpretation.md#module22-candidate-asv-review)为当前入口。固定规则选15个候选，保留全部5,510个ASV的排名及33/29/G4分层指标；固定补10个时贡献阈值0.0025/0.005/0.01名单一致。主流程18 PASS/4 WARNING/0 FAIL，独立数值复核最大误差1.78×10⁻¹⁵；任务前157个科研文件未变。

- `3cae…`（Competibacter关联）同时关联R2/R4末段差缩小（Δ贡献−0.222247）及R1/R2差扩大（+0.197705）；不是独立的机制证据。
- `d172…`（Sphingobacteriaceae / Incertae_Sedis）在R1后期9.4429%→28.1100%，功能未知；`78c2…`（Defluviicoccus关联）在R3后期14.0900%→15.0196%→13.1484%，支持已采样节点持续检出。
- 6个候选仅沿用GAO文献关联、4个Acinetobacter保留PAO歧义，其余5个目标功能未知/未分配。`d172…`和`a578…`属级不足；Chryseotalea/Aridibacter置信度0.851623/0.823897应优先定向比对。
- 15条真实序列404–430 bp，MD5身份通过。未执行BLAST/物种鉴定，匹配字段NA；特定Aridibacter参考菌株的硝酸盐利用不等于本ASV反硝化。原功能映射不改。

产物：[全量排名](results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv)、[分类审核](results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv)、[文献证据](results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv)、[轨迹PDF](results/candidate_asvs/2026-11-05_v2/candidate_asv_trajectories.pdf) / [PNG](results/candidate_asvs/2026-11-05_v2/candidate_asv_trajectories.png)、[run.log](results/candidate_asvs/2026-11-05_v2/run.log)；可复现脚本[scripts/candidate_asv_review.R](scripts/candidate_asv_review.R)。共7个最终文件，不新增对象。性能/温度关联尚未开展；G4起始状态各异、30℃/室温标签与个体混杂，不能从相对丰度、共享ASV或Bray贡献推出活性或因果。


## 2026-11-05 当前版本统一

按用户要求，模块2.1和2.2均统一为2026-11-05_v2；v1仅为历史，不再作为当前结果入口。已按两份报告输入SHA-256复核44项记录，实际沿用组成/功能2026-11-03_v2及多样性2026-11-04_v2。本次是目录及来源指针统一，不是重新计算；数值、图件、15候选及科学结论不变。首次运行的时间/指纹记录保留，历史路径按各报告文末迁移关系回查。

## 2026-11-06 模块2.3重新执行与交付

按用户要求重新运行，当前[模块2.3报告](results/operational_performance/2026-11-06_v2/analysis_report.md)取代[2026-11-05草稿](results/operational_performance/2026-11-05_draft_v1/analysis_report.md)；草稿六文件完整归档。模块2.3当前统一使用`2026-11-06_v2`路径（取代此前v1命名），模块1.1–2.2的有效v2及原始科研资料保持不变。

实际盘点180个既有文件；[来源清单](results/operational_performance/2026-11-06_v2/source_inventory.tsv)为190行（180文件+10条DO/温度设计设置来源），[原始性能长表](results/operational_performance/2026-11-06_v2/performance_raw_long.tsv)为0行，[样本匹配](results/operational_performance/2026-11-06_v2/sample_performance_match.tsv)为33行，[参数完整性](results/operational_performance/2026-11-06_v2/parameter_completeness.tsv)为14行，另有报告及[运行日志](results/operational_performance/2026-11-06_v2/run.log)。脚本为[operational_performance_audit.py](scripts/operational_performance_audit.py)，已有目录拒绝覆盖。

主流程12 PASS / 3 WARNING / 1 FAIL；FAIL表示后续性能关联无可用观测，审计本身正常完成。14项参数实测覆盖率均0%，原始长表仅表头，缺失不当作零值。DO阶段设置覆盖33行、G4温度运行标签覆盖15行，均不计入A/B/C实测覆盖率；没有C类阶段实测均值。没有新增相关检验、机器学习、网络或因果分析。后续需要原始水质/运行文件、单位与进出水/周期口径及16S采样日期或周期对应依据；不重复索取已确认33样本名单。


## 2026-11-06 模块2.3当前名称统一v2

已将[模块2.3当前报告](results/operational_performance/2026-11-06_v2/analysis_report.md)及目录统一为2026-11-06_v2，取代此前同日v1命名。来源盘点与实际run.log的9项输入指纹核对确认：五份上游报告、模块2.1派生metadata和模块2.2三表均来自有效v2；原metadata仍是33样本唯一基准。四份TSV逐字节不变，没有重算或更改科学结论。脚本默认v2并拒绝向v1输出，历史运行时间/指纹保留；昨日草稿仅作历史。此条取代之前模块2.3按v1命名的约定。

## 2026-11-06 新增进水图片来源与模块2.3更新

最新[2026-11-06_influent_v2报告](results/operational_performance/2026-11-06_influent_v2/analysis_report.md)补充并取代上述新增进水前的当前状态，旧报告/数据保持不变。新增[13行进水源数据](data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv)，包含COD 230、NH4-N 50、TP 3.3、KHCO3 250 mg/L及九项微量组分；用户已确认所有阶段和反应器相同。记录图片表号/位置、原值/单位/完整化学式及确认原话；未取得本地原图二进制，源TSV不冒充原图文件。

新目录严格六产物：[来源盘点](results/operational_performance/2026-11-06_influent_v2/source_inventory.tsv)210行、[来源长表](results/operational_performance/2026-11-06_influent_v2/performance_raw_long.tsv)13行、[样本匹配](results/operational_performance/2026-11-06_influent_v2/sample_performance_match.tsv)33行、[参数覆盖](results/operational_performance/2026-11-06_influent_v2/parameter_completeness.tsv)14行、中文报告和[run.log](results/operational_performance/2026-11-06_influent_v2/run.log)。同一来源链接到33样本，不当作33份独立测量；429个条件链接不增加独立观测。原source_sample_metadata.tsv不回写。

主流程17 PASS / 4 WARNING / 1 FAIL：共同条件匹配通过，测量性质/时间仍未知，后续性能关联门控关闭。13项在33样本均只有一个浓度水平，不能作为解释样本间ASV差异的连续协变量。图示COD/NH4-N=4.6仅为浓度比，不等于COD/TN、负荷、去除率或实际碳限制；TP不替代PO4-P，NH4-N不替代TN，不换算盐类为元素/碱度。所有上游有效v2、旧模块2.3及原始科研资料保持不变；[累计解释](docs/batch_01/results_interpretation.md#module23-influent-conditions)记录具体可行性与待补资料。

## 2026-11-06 正式确认人工进水设计配方

用户正式确认表2.1/2.2属于统一人工进水名义设计，适用于全部G1–G5和33样本。当前[设计配方审核报告](results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md)取代前轮“性质未说明”的当前状态；旧报告保留历史，不覆盖任何既有v2。已将确认追加到[实验设计](docs/batch_01/experiment_design.md#2026-11-06-uniform-influent-design-recipe)，并建立[13项正式配方表](data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv)，全部`design_recipe`、`sample_measured=FALSE`。

[新派生metadata](results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv)为33×93，原始14列及旧派生63列逐值保留，新增共享recipe_id、统一设计标记、13项名义浓度和名义COD/NH4-N=4.6、COD/TP≈69.70；原source_sample_metadata.tsv和RDS不改。新目录仅metadata、报告与[run.log](results/operational_performance/2026-11-06_design_recipe_v2/run.log)，不重复输出既有六表。

审核9 PASS / 2 WARNING / 1 FAIL：设计/派生字段通过；实测缺口及混杂仍在，FAIL仅为继续关闭的后续性能关联门控。33份设计属性共享不构成33次独立测量；实测覆盖0/33、462个NA/D不变。未运行DADA2、taxonomy、功能映射、多样性、相关或其他模型。默认复现入口为`python3 scripts/operational_performance_audit.py --mode design-recipe`，新v2目录拒绝覆盖；[累计解释](docs/batch_01/results_interpretation.md#module23-design-recipe-confirmation)给出来源和科研边界。


## 2026-11-07 模块2.4第一阶段：生态候选清单定稿（v2）

[全ASV生态特征](results/ecological_candidates/2026-11-07_v2/all_asv_ecological_features.tsv)为5510×267，[候选优先表](results/ecological_candidates/2026-11-07_v2/candidate_priority_table.tsv)为106×150，另有[中文综合报告](results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md)与[run.log](results/ecological_candidates/2026-11-07_v2/run.log)。[复现脚本](scripts/ecological_candidate_screening_v2.py)锁定有效v2并拒绝覆盖，原15个编号、全部分类审核及证据保留；本次没有新分类/文献事实或Alpha/Beta重算。

主规则A：主29任一样本≥1%；B：同G4实体≥3节点检出且≥2节点≥1%；C：≥3反应器检出且≥2反应器曾≥0.5%；D：重点比较单ASV Bray贡献≥0.005。命中103/39/58/60，并集106；B/D被A覆盖，C补充3个，规则不是独立支持。主池传统关联16、非传统45、功能歧义13、分类受限或未知32；未知不等于无功能。宽松/主/严格池189/106/55，原15和推荐8个在三池均保留。

推荐C02、C04、C05、C10、C09、N026（Phototrophicus）、N045（Candidatus_Tepidaquicella）、N072（OLB8）供下一阶段定向MiDAS分类和原研究文献审核。前4是研究问题指定对象，后4按其余非传统/未知主池生态得分选取，非全盲Top8；C01/C03另列功能关联对照。完整ASV ID、节点、具体触发与审核任务见[累计解释](docs/batch_01/results_interpretation.md#module24-ecological-candidates-v2)。代码标签及高Confidence都不是功能确证。

本次42 PASS / 4 WARNING / 0 FAIL；独立整数交叉乘法核验至少413250项、两TSV在临时目录复现逐字节一致。G4基线/后期分层、不平衡纵向节点、四起始污泥、温度/反应器/来源与批次混杂仍限制解释；G5单母样四级分仅单列比例，不参与筛选。候选清单是待审核对象，不能声称功能活性、去除贡献、显著性或因果。


## 2026-11-08 模块2.5第一阶段：分类核实与生态证据（V2）

固定审核C02/C04/C05/C10/C09/N026/N045/N072，C01/C03为GAO关联对照；复用模块2.4组成指标和模块2.2序列审核，不重筛选。实际MiDAS5.3参考111037条、完整指纹固定；21643条MiDAS HSP与定向参考合计21793条，真实查询和每条匹配碱基/坐标均程序核对。

[分类核实表](results/candidate_ecology/2026-11-08_v2/candidate_taxonomy_validation.tsv)10行；[参考基因组表](results/candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv)14行；[分层文献证据](results/candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv)34行；[生态角色表](results/candidate_ecology/2026-11-08_v2/candidate_ecological_roles.tsv)10行；另有[中文报告](results/candidate_ecology/2026-11-08_v2/analysis_report.md)、[run.log](results/candidate_ecology/2026-11-08_v2/run.log)及3份压缩参考证据，结果目录共9文件。[可复现脚本](scripts/candidate_ecology_validation_v2.py)只向新_v2目录写入并拒绝覆盖；完整MiDAS按官方URL和SHA256复取，必要参考原件已归档。

C02定位到MiDAS AKYH767/midas_g_9646、C04到midas_g_85782，均不是已鉴定培养属。C05保守到Blastocatellaceae；C09有7条100%跨Rhodobacter/Tabrizicola并列，不能选属。N026/N045分别为midas_g_29983近邻/midas_g_171操作定位，原Phototrophicus/Tepidaquicella株生理不得套用。N072改按实际Ca_Vicinibacter/midas_s_177谱系审核，两个参考MAG各两份16S片段均100%，支持潜在辅助类群的参考背景；不是本ASV基因/活性确证，不沿用旧OLB8其他分支糖原结论。其余7目标仍为功能未知，C01/C03保留关联对照。

本阶段90 PASS / 4 WARNING / 0 FAIL仅为交付检查。文献明确区分本ASV组成、参考谱系、特定参考MAG、远缘背景及无功能证据，具体原始题名/DOI/核实范围见报告；近缘不足即停止代谢审核。详细解释见[累计结果](docs/batch_01/results_interpretation.md#module25-taxonomy-ecology-v2)。较早模块2.4中“MiDAS/新增文献尚未执行”保留当时历史状态，以本节及模块2.5为当前依据。


## 2026-11-09 模块2.6：重点ASV共同演替与生态证据综合（V2）

[中文报告](results/focal_asv_cosuccession/2026-11-09_v2/analysis_report.md)、[固定ASV观测/比较表](results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_cosuccession.tsv)、[五层证据综合表](results/focal_asv_cosuccession/2026-11-09_v2/ecological_evidence_synthesis.tsv)、[轨迹PDF](results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_trajectory_comparison.pdf) / [PNG](results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_trajectory_comparison.png)和[run.log](results/focal_asv_cosuccession/2026-11-09_v2/run.log)，共6文件；[复现脚本](scripts/focal_asv_cosuccession_v2.py)只向尚不存在的_v2目录写入。详细科研解释见[模块2.6累计结果](docs/batch_01/results_interpretation.md#module26-focal-asv-cosuccession-v2)。

- A：76→145d，R2的C01由5.1454%至44.7053%，R1的C02由9.4429%至28.1100%；两ASV差扩大Δc分别+0.197705/+0.096226。C10/C09/N072的差距缩小，固定5对象净Δc=+0.279806，占整体Bray净增幅的94.25%，仅数学分解。
- B：R3后期C03为14.0900%→15.0196%→13.1484%，C04为0.1671%→5.9966%→11.9159%；N045/N026后期连续升、C05末段降至1.2175%，N072先升后降。较小整体Bray与目标内部替换并存，不证明成员或性能稳态。
- C：R2/R4末段C01差距由50.2504缩至5.8011个百分点，Δc=−0.222247，占整体Bray净下降幅度60.26%；C03/N026/N045差扩大，N072差缩小来自两者共同下降。A/C共享R2的同一次重排，不是独立复现。

三组预定log-ratio只作自然log比值描述，无伪计数；R4最低8reads，明确低计数敏感。G5独立：N072在S1–S3零reads、S4仅9reads（0.0201%），不能用旧OLB8属总量代替该ASV或认定附着/EPS。七个非传统目标仍具体功能UNKNOWN，N072仅参考谱系背景；未新增功能实证、性能关联、全群落相关、网络、PERMANOVA或温度/DO因果结论。69/5/0仅描述性交付，独立700项数值、临时重现及拒绝覆盖另列；跨Batch组成验证假设已固定，尚未开展外部验证，不新增功能实验任务。

<a id="project-file-directory-guide"></a>

## 项目文档、文件夹与功能对应表（2026-11-09核对）

下表按现有文件与报告整理，路径均相对项目根目录；同一分析目录内的同类表格和PDF/PNG合并说明。当前结果使用各模块明确标记的v2，历史版本保留追溯。原始样本metadata、分析派生metadata和既有RDS分别列出，不能互相替代。

| 文档或文件夹 | 现有主要内容 | 功能作用 | 状态与使用说明 |
|---|---|---|---|
| [README.md](README.md) | 科研总览、当前进度、模块报告导航及本表 | 了解整个项目，定位当前结果与详细证据 | 项目总入口 |
| [AGENTS.md](AGENTS.md) | 数据保护、检查门控、科研解释和文档维护约定 | 约束后续代码、分析与文件操作 | 工作规范；历史任务状态需结合后续报告判断 |
| [docs/research_context.md](docs/research_context.md) | 研究背景、总体目标、已有条件和方法边界 | 明确16S研究能够回答的问题及解释范围 | 背景依据 |
| [docs/batch_01/experiment_design.md](docs/batch_01/experiment_design.md) | 33样本映射、G1–G5、运行轮次、接种谱系、DO/温度及进水配方确认 | 提供样本设计与条件来源，区分设置和实测、记录数和独立重复 | 按文内最新有效补充使用；历史段落保留 |
| [docs/batch_01/analysis_plan.md](docs/batch_01/analysis_plan.md) | 阶段1方案、各模块目标、统计限制与版本约定 | 说明执行顺序、设计门控和暂不适用的方法 | 计划与历史约定；实际完成状态查报告和日志 |
| [docs/batch_01/results_interpretation.md](docs/batch_01/results_interpretation.md) | 按模块累计的方法、结果、生态解释、局限和待验证假设 | 阅读科研发现与证据边界，回查实际表格和图件 | 详细科研解释入口 |
| [docs/batch_01/analysis_log.md](docs/batch_01/analysis_log.md) | 日期、命令、输入输出、软件版本、核验、失败与修正记录 | 追踪操作过程、授权范围和版本替代关系 | 累计执行日志，保留历史 |
| [input/qiime2/](input/qiime2/) | `table.qza`、`rep-seqs.qza`、`taxonomy.qza`、`denoising-stats.qza` | 保存既有QIIME2计数表、代表序列、分类和去噪统计Artifact | 原件保留；本目录未收录原始FASTQ |
| [data/asv_table.tsv](data/asv_table.tsv) | 5,510 ASV × 33样本的原始整数计数表 | 后续组成、比例、多样性和候选分析的计数输入 | 保留未稀释计数；不是相对丰度表 |
| [data/taxonomy.tsv](data/taxonomy.tsv) | 原SILVA分类谱系及Confidence | 为ASV提供分类标签和分类置信信息 | 上游分类保留；定向审核意见另存模块2.5 |
| [data/exported_table/](data/exported_table/) | `feature-table.biom` | 保存计数表的BIOM导出，支持跨软件读取及一致性回查 | 既有导出，沿用阶段1核查 |
| [data/exported_sequences/](data/exported_sequences/) | `dna-sequences.fasta` | 保存真实ASV代表序列，用于身份核对和定向参考比对 | 既有导出；不是参考数据库 |
| [data/operational_performance/](data/operational_performance/) | `2026-11-06_influent_image_transcription_v2.tsv`、`2026-11-06_influent_design_recipe_v2.tsv` | 分别保存图片表格转录来源与正式确认的13项人工进水设计配方 | 当前配方用`design_recipe_v2`；不是采样实测水质 |
| [metadata/](metadata/) | `source_sample_metadata.tsv`，33行×14列 | 保存原始样本身份、反应器及阶段记录，作为样本名单基准 | 原表保留，无`group`列；五模块来自已确认设计 |
| [logs/dada2/](logs/dada2/) | `commands.sh`、`parameters.json`、`sample-id-update.json` | 回查历史去噪命令、参数和样本编号调整 | 上游处理记录；不表示本次重跑DADA2 |
| [logs/taxonomy/](logs/taxonomy/) | `inputs.json`、`versions.json`、`validation.json` | 回查历史分类输入、工具版本和验证记录 | 分类来源证据；文件名本身不证明数据库训练来源 |
| [scripts/stage1_pipeline.R](scripts/stage1_pipeline.R) | 阶段1统一入口，含`--review-design`、`--review-metadata`及对象检查逻辑 | 核对既有数据、设计映射与对象门控，集中记录综合QC | 设计复核只读源表；报告追加，既有RDS不覆盖 |
| [scripts/community_composition.R](scripts/community_composition.R) | 模块1.1脚本 | 聚合门/纲/属相对丰度，生成群落组成、反应器演替及G5粒径图 | 默认结果为组成v2；已有输出拒绝覆盖 |
| [scripts/functional_guilds.R](scripts/functional_guilds.R) | 模块1.2脚本 | 按显式文献规则映射传统功能相关类群并汇总比例 | 分类关联层面，不是功能基因或活性测定 |
| [scripts/diversity_analysis.R](scripts/diversity_analysis.R) | 模块1.2定向复核及模块1.3脚本 | 计算Alpha/Beta、PCoA、真实时间节点变化及深度/方法敏感性 | 描述性分析，不执行组间显著性检验 |
| [scripts/g4_asv_contributions.R](scripts/g4_asv_contributions.R) | 模块2.1脚本 | 整理G4条件补充，分解重点比较的ASV/属贡献和时间变化 | 沿用有效v2及既有距离，不作温度或DO因果推断 |
| [scripts/candidate_asv_review.R](scripts/candidate_asv_review.R) | 模块2.2脚本 | 固定规则筛选15个候选，保留全ASV排名并审核分类/文献证据 | 候选身份与证据入口，不等于功能确证 |
| [scripts/operational_performance_audit.py](scripts/operational_performance_audit.py) | 模块2.3审核脚本；`--mode design-recipe`、`--mode image-audit` | 审核进水来源、共同配方和样本派生字段，保留性能实测缺口 | 当前默认正式配方模式；性能关联门控仍关闭 |
| [scripts/ecological_candidate_screening_v2.py](scripts/ecological_candidate_screening_v2.py) | 模块2.4脚本 | 补充非传统/未知功能ASV生态特征、筛选规则和候选优先级 | 描述性筛选，不增加分类或功能事实 |
| [scripts/candidate_ecology_validation_v2.py](scripts/candidate_ecology_validation_v2.py) | 模块2.5脚本 | 对固定目标核对真实序列、MiDAS/参考匹配和文献证据层级 | 复现需报告指定的外部参考输入及版本/指纹 |
| [scripts/focal_asv_cosuccession_v2.py](scripts/focal_asv_cosuccession_v2.py) | 模块2.6脚本 | 汇总固定对象的组成轨迹、已有贡献、预定log-ratio和五层生态证据 | 共同演替为并列描述，不代表统计相关或互作 |
| [results/qc/](results/qc/) | `stage1_report.md` | 集中保存基础格式、ID/计数一致性、设计映射及对象核验记录 | 阶段1综合质量报告，仅追加历史运行 |
| [results/phyloseq/](results/phyloseq/) | `batch_01_phyloseq.rds` | 保存已生成的原始计数phyloseq对象，供既有分析兼容复用 | 文件实际存在；不自动包含后续温度/配方新增字段 |
| [results/community_composition/2026-11-03_v2/](results/community_composition/2026-11-03_v2/) | 门/纲/属比例、`dominant_genera_summary.tsv`、33×45派生`analysis_metadata.tsv`；总览、R1–R4演替和G5图；报告/日志 | 模块1.1当前群落组成与演替结果，提供下游组成和样本顺序基线 | 当前有效v2；原metadata与派生表区分使用 |
| [results/community_composition/2026-11-03_v1/](results/community_composition/2026-11-03_v1/) | 早期组成表、派生metadata、图件和报告/日志 | 回查首次群落组成交付及后续修订来源 | 历史版本，后续分析入口为组成v2 |
| [results/functional_guilds/2026-11-03_v2/](results/functional_guilds/2026-11-03_v2/) | `functional_mapping_evidence.tsv`、`functional_asv_annotation.tsv`、`functional_guild_abundance.tsv`、`functional_taxa_abundance.tsv`及图件/报告/日志 | 模块1.2当前文献映射、ASV关联注释和类群比例结果 | 当前有效v2；GAO/PAO等保留歧义和证据等级 |
| [results/functional_guilds/2026-11-03_v1/](results/functional_guilds/2026-11-03_v1/) | 功能相关类群首次交付的表格、图件和报告/日志 | 追溯模块1.2首次结果与v2复现关系 | 历史版本，不作为当前入口 |
| [results/diversity/2026-11-04_v2/](results/diversity/2026-11-04_v2/) | `alpha_diversity.tsv`、Bray/Jaccard距离、PCoA坐标/特征值、G4/同轮变化、敏感性表及图件；`module12_review.md`、报告/日志 | 模块1.3当前多样性、变化幅度与敏感性结果，同时保留模块1.2定向复核 | 当前有效v2；Alpha/Beta图表均存此处 |
| [results/asv_contributions/2026-11-05_v2/](results/asv_contributions/2026-11-05_v2/) | `g4_design_addendum.md`、`analysis_metadata_addendum.tsv`、重点距离、ASV/属贡献、轨迹/时间变化/关联注释表，3组图及报告/日志 | 模块2.1：描述R1/R2分化、R2/R4趋近和R3后期组成的具体ASV来源 | 当前有效v2；条件补充metadata独立保存，不更新旧RDS |
| [results/candidate_asvs/2026-11-05_v2/](results/candidate_asvs/2026-11-05_v2/) | `candidate_asv_ranking.tsv`、`candidate_asv_taxonomy_review.tsv`、`candidate_asv_evidence.tsv`、候选轨迹图及报告/日志 | 模块2.2：保存全ASV排名、15候选身份和初步分类/文献审核 | 当前有效v2；后续定向分类意见查模块2.5 |
| [results/operational_performance/2026-11-05_draft_v1/](results/operational_performance/2026-11-05_draft_v1/) | 来源盘点、性能长表、样本匹配、参数完整性及报告/日志 | 保留模块2.3昨日草稿及原始执行证据 | 历史草稿，已被后续审核替代 |
| [results/operational_performance/2026-11-06_v2/](results/operational_performance/2026-11-06_v2/) | `source_inventory.tsv`、`performance_raw_long.tsv`、`sample_performance_match.tsv`、`parameter_completeness.tsv`及报告/日志 | 记录新增进水图片前的性能来源盘点、33样本匹配和实测缺口 | 前序审核；性能长表仅表头，空表不是零浓度 |
| [results/operational_performance/2026-11-06_influent_v2/](results/operational_performance/2026-11-06_influent_v2/) | 新增13条图片来源后的同名四表及报告/日志 | 回查共同进水条件录入与样本来源链接 | 前序审核；其中“测量性质未说明”已被正式配方确认取代 |
| [results/operational_performance/2026-11-06_design_recipe_v2/](results/operational_performance/2026-11-06_design_recipe_v2/) | 33×93派生`analysis_metadata.tsv`、`analysis_report.md`、`run.log` | 保存正式配方、G4条件与原字段衔接的当前派生metadata及来源审核 | 模块2.3当前配方入口；共享设计属性不增加独立实测记录 |
| [results/ecological_candidates/2026-11-07_v2/](results/ecological_candidates/2026-11-07_v2/) | `all_asv_ecological_features.tsv`、`candidate_priority_table.tsv`、`candidate_screening_report.md`、`run.log` | 模块2.4：保存5,510 ASV生态特征、106候选优先表及8个定向审核目标 | 当前有效v2；C01/C03另作GAO关联对照 |
| [results/candidate_ecology/2026-11-08_v2/](results/candidate_ecology/2026-11-08_v2/) | 分类核实、参考基因组、文献证据、生态角色4表；`reference_alignments_v2.tsv.gz`、`reference_sequences_v2.fasta.gz`、`reference_evidence_v2.zip`及报告/日志 | 模块2.5：固定10对象的MiDAS/参考分类核实、保守生态解释与必要参考原件归档 | 当前有效v2；完整MiDAS库未重复归档，短16S不直接确证功能 |
| [results/focal_asv_cosuccession/2026-11-09_v2/](results/focal_asv_cosuccession/2026-11-09_v2/) | `focal_asv_cosuccession.tsv`、`ecological_evidence_synthesis.tsv`、轨迹PDF/PNG、`analysis_report.md`、`run.log` | 模块2.6：三个固定研究单元的重点ASV轨迹、已有贡献、比值及分层证据综合 | 当前最新描述性结果；跨Batch验证尚未开展 |

各分析目录中的`analysis_report.md`（模块2.4为`candidate_screening_report.md`）用于解释问题、方法、结果和门控；`run.log`用于追溯运行参数、版本及输入输出指纹。TSV提供可复查数值，PDF/PNG用于阅读和展示，压缩参考证据用于回查实际比对与文献/基因组来源。

本次已用`rmdir`删除3个经核实为空的结果目录：`results/alpha_diversity/`、`results/beta_diversity/`、`results/figures/`。实际多样性结果与图件保留在上述各模块目录；`.git/`及环境配置目录`.agents/`、`.codex/`、`.aws/`保留，不纳入科研结果清理范围。此次仅整理导航和空目录，未重新分析或修改已有科研数据与结果。
