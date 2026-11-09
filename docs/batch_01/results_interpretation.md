# Batch_01 科研结果与解释

更新日期：2026-11-09（Asia/Shanghai）。本文件按科研模块累计详细结果，供论文写作和后续分析使用。项目总览见[README](../../README.md)，执行过程见[分析日志](analysis_log.md)，机器核查证据见[阶段1综合报告](../../results/qc/stage1_report.md)及各模块综合报告。模块1.1–2.2沿用有效v2；[正式人工进水设计配方确认](#module23-design-recipe-confirmation)已完成，13项均为design_recipe、33样本共享名义设计，新派生metadata33×93；名义比4.6/约69.70。前轮“性质未说明”已被正式确认取代；性能实测仍缺失、关联门控关闭，未运行统计检验。既有候选审核见[模块2.2](#module22-candidate-asv-review)。 2026-11-07新增[模块2.4第一阶段v2](#module24-ecological-candidates-v2)：106个主池候选、保留原15、8个推荐生态审核目标；当时MiDAS/新增文献审核尚未执行；2026-11-08已完成[模块2.5第一阶段V2](#module25-taxonomy-ecology-v2)，仅N072获近缘参考谱系潜力支持，7目标功能未知，未增加项目功能确证或统计推断。 2026-11-09已完成[模块2.6共同演替与生态证据综合V2](#module26-focal-asv-cosuccession-v2)，以固定三个单元描述组成重排；没有增加本ASV功能、互作或因果证据。

## 证据与当前状态

实验设计以[已确认五模块清单](experiment_design.md#2026-11-02-design-correction)及[最新DO/取样位置补充](experiment_design.md#2026-11-03-DO-settings)为准。G1–G5为8/2/4/15/4行；8/6/4/11/4仅属历史版本，不用于当前科研解释。本次在原有文件中未检出这一旧数量组合。

当前原metadata仍是33行14列；模块1.1已产生独立派生metadata、最终phyloseq对象和描述性组成/演替结果，以[模块1.1 v2报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)为当前依据，v1保留历史。模块1.2已复用上述输入完成[功能相关类群描述](../../results/functional_guilds/2026-11-03_v2/analysis_report.md)，映射区分文献关联、属水平候选、分类不足、功能歧义和待研究类群。显著性、机制及功能活性结论仍未产生；全部33行采样瞬时DO保持NA。

G4四个初始样本存在来源版本差异：设计文档确认恢复阶段设置3 mg/L，新增模块1.1报告称其分析请求将设置视为不确定，因此派生表的分析设置为NA，3另存`design_document_DO_setpoint_mg_L`/`design_document_DO_setting_text`。这里转述实际字段及报告，不自行裁定或改写实验设计；涉及该设置的后续解释须先统一来源。

## 模块0：数据基础、分类分辨率与设计可用性（已有结果）

**分析问题与方法。** 现有计数、taxonomy、序列和样本信息能否可靠对齐？采用统一脚本`../../scripts/stage1_pipeline.R`的历史完整QC，执行格式、ID、非负整数计数、空样本、Feature ID一致性、BIOM逐格对应及Artifact导出指纹检查；深度以Tukey 1.5×IQR标记异常，不过滤、不稀释、不归一化。设计方案另由`--review-design --compact-report`核对，不重跑基础QC。

**输入与证据。** 输入为`../../data/asv_table.tsv`、`../../data/taxonomy.tsv`、`../../data/exported_sequences/dna-sequences.fasta`、`../../data/exported_table/feature-table.biom`、`../../metadata/source_sample_metadata.tsv`及`../../input/qiime2/`下的table、rep-seqs、taxonomy QZA；完整输入指纹、版本、每样本深度及运行时间保留于综合报告。本节直接引用2026-11-02完整运行及2026-11-03 14:59:48设计复核，本次未重新执行。

### 实际数据与主要发现

| 指标 | 已记录结果 | 来源及意义 |
|---|---|---|
| 样本/特征规模 | 33样本、5,510 ASV，181,830个计数单元格 | 综合报告首轮完整QC；所有计数为非负整数，未做变换 |
| 总测序计数 | 1,364,804 reads | 原ASV计数总和的历史核查值，不是细胞数 |
| 样本测序深度 | min=31,457，Q1=36,956，中位数=42,004，Q3=44,760，max=53,307 | 综合报告“每样本测序深度”有完整33行；最小为Batch_01_F1，最大为Batch_01_G4（原样本G4，属于模块G4） |
| 深度异常 | Tukey界限[25,250, 56,466]，未标记异常；无空样本、无全零ASV | 仅表示该规则下未出现异常，不等于饱和度/覆盖度评估 |
| Feature ID与数值 | ASV/taxonomy/FASTA各5,510个Feature ID一致且唯一；33样本与metadata一致；TSV和BIOM逐格相同 | 支持数据整合，不能替代设计与实验记录审阅 |
| 导出对应 | BIOM、FASTA、taxonomy导出与相应QZA数据成员逐字节SHA-256一致 | 说明核查时导出链对应；不代表已复核全部上游实验流程 |
| 代表序列 | 5,510条，长度333–453 bp；无空序列 | 长度为既有核查结果，本次未重做合并率或序列质控 |
| 原metadata缺失 | sample_order与biological_replicate各33行缺失，particle_size_fraction_um与metadata_review_notes各29行缺失 | 缺失盘点不用于填补；只有G5有粒径字段，其余缺失不自动认定质量失败 |
| 最新映射复核 | 21 PASS、5 WARNING、0 FAIL；内存14原列+27新增字段 | 只针对设计方案；来源相关、重复测量、取样不平衡和当前交付门控仍须保留 |

历史分类使用日志所记`silva144-2026.7-full-length.qza`、confidence=0.7、read_orientation=same、n_jobs=1、reads_per_batch=100，详见[输入参数](../../logs/taxonomy/inputs.json)。以下为综合报告按显式分类前缀解析的**有注释ASV数量**，不是按reads加权的丰度：

| 阶元 | 有注释ASV数 |
|---|---:|
| Domain（d__） | 5,510 |
| Kingdom（k__） | 5,260 |
| Phylum | 4,927 |
| Class | 4,763 |
| Order | 4,437 |
| Family | 4,224 |
| Genus | 3,664 |
| Species | 0 |

**科学意义与生态学解释。** 数据身份、计数和导出对应关系支持后续群落整理；属级注释可作为描述性分析基础，种级没有显式标签，不能写种水平组成结论。ASV不直接等同物种，分类分辨率不证明功能或活性，也不说明某类群占优势。当前没有可解释的菌群变化方向。

**状态与局限。** 首轮完整QC为54 PASS、14 WARNING、3 FAIL，三项失败是当时原metadata缺少group及来源字段，对象未保存。完整五模块后来已确认；模块1.1用派生表完成对象构建和兼容复用，实际记录追加于阶段1报告。21/5/0只针对早先设计方案，43/4/0只针对组成模块，均不代表统计前提通过。历史版本和指纹保留，不用后来的成功改写历史FAIL。

**图表与待验证问题。** 本节仅有上述数据摘要表，尚无新图；逐样本深度沿用综合报告，不复制成新附件。后续需按具体方法评估测序深度处理及分类缺失对描述的影响，当前不能宣称测序已饱和。

## 模块1.1：组成与演替的共同方法及产物（已完成）

来源为[有效v2报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)，运行2026-11-03 15:07:27–15:07:41，43 PASS、4 WARNING、0 FAIL；对象构建细节在阶段1报告。本节和后续G1–G5仅解释已产出的描述性结果，不重复创建方法报告。

- **方法与参数**：每ASV count除以该样本全部ASV count，按完整祖先谱系聚合门/纲/属，分别51/114/633条谱系（包含未分类）。不筛选、不稀释、不删除ASV。主分析为G1–G4的29样本，G5四组分独立展示。
- **图中类别**：主图由29个主分析样本等权均值选择门Top10、纲Top10、属Top15，G5不参与选择，跨图固定配色。G5后续另按自身四级分均值选Top10/10/15，新增独立图作为其主要展示，共有类群保留主图颜色。其余已命名类群归Others，全部未分类归Unclassified，不重新归一化。空标签、unknown/unassigned等及Incertae_Sedis不作命名属；同名但不同上级谱系不静默合并。
- **优势属定义**：每样本或每反应器×模块×子阶段等记录权重均值的正丰度已命名属Top3，平局按谱系排序。阶段范围不是置信区间，后期均值不是时间积分；共同优势属是实际有记录反应器Top3交集，不是独立重复验证或“核心菌群”的证明。
- **实际数据**：主分析属Top15覆盖43.51%–95.14%，G5覆盖28.36%–57.18%；属级未分类比例按样本为2.41%–44.72%。最大已命名属不一定超过合并的未分类类别，不应把Top15图当完整已鉴定群落。
- **软件与复现**：R 4.5.2、phyloseq 1.54.0、Biostrings 2.78.0、digest 0.6.39、ggplot2 4.0.3、scales 1.4.0，无随机步骤。脚本为[community_composition.R](../../scripts/community_composition.R)，重跑需`--output-dir`指定不存在的新版本目录，本次没有重跑。
- **版本边界**：v1存在图例裁切、浮点边界删除柱顶段及Incertae_Sedis误作命名属的问题；v2修正并加入实际绘图层守恒断言。原始谱系丰度未变，未分类标记、Top N和优势属汇总已更新，以v2为准。

| 最终产物 | 相对路径 |
|---|---|
| 原始计数phyloseq | [batch_01_phyloseq.rds](../../results/phyloseq/batch_01_phyloseq.rds) |
| 分析metadata | [analysis_metadata.tsv](../../results/community_composition/2026-11-03_v2/analysis_metadata.tsv) |
| 门/纲/属相对丰度矩阵 | [Phylum](../../results/community_composition/2026-11-03_v2/phylum_relative_abundance.tsv)、[Class](../../results/community_composition/2026-11-03_v2/class_relative_abundance.tsv)、[Genus](../../results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv) |
| 逐样本与反应器阶段Top3 | [dominant_genera_summary.tsv](../../results/community_composition/2026-11-03_v2/dominant_genera_summary.tsv) |
| 主分析三阶元总览 | [PDF](../../results/community_composition/2026-11-03_v2/main_composition.pdf)、[PNG](../../results/community_composition/2026-11-03_v2/main_composition.png) |
| R1–R4属级轨迹 | [R1](../../results/community_composition/2026-11-03_v2/R1_community_succession.pdf)、[R2](../../results/community_composition/2026-11-03_v2/R2_community_succession.pdf)、[R3](../../results/community_composition/2026-11-03_v2/R3_community_succession.pdf)、[R4](../../results/community_composition/2026-11-03_v2/R4_community_succession.pdf)；同目录有PNG |
| G5三阶元组成（主要展示，自身选Top N） | [PDF](../../results/community_composition/2026-11-03_v2/G5_independent_top_taxa.pdf)、[PNG](../../results/community_composition/2026-11-03_v2/G5_independent_top_taxa.png) |
| G5与主图类别统一的对照视图 | [PDF](../../results/community_composition/2026-11-03_v2/G5_size_fraction_composition.pdf)、[PNG](../../results/community_composition/2026-11-03_v2/G5_size_fraction_composition.png) |

图中轮次分面不连接混合/保存恢复断点，柱间等距不代表时间等距。更多全部节点Top3、检查、输入指纹及版本细节见原综合报告；本文件仅选择有助科研解释的数据。

G5独立Top N补充单独记载三阶元比例及绘图层守恒PASS，不并入主分析43/4/0计数。它解决S2的Thauera 20.84%在主分析Top15中并入Others的展示限制；原报告G5属Top15覆盖28.36%–57.18%只对应主分析选类群的对照图，不套用于新图。补充仅读派生表及丰度矩阵，复现入口为`community_composition.R --g5-detail --output-dir EXISTING_RUN`。run.log保留一次补充尝试失败与随后成功的记录，未覆盖历史；本文件引用最终成功产物。

原报告“最终交付复核”另给出主29样本**等记录权重均值**Top5（排除未分类，分母仍为全部reads）：

| 阶元 | 已命名类群及平均相对丰度 |
|---|---|
| 门 | Pseudomonadota 66.46%；Bacteroidota 11.71%；Chloroflexota--other 8.81%；Chlorobiota 3.90%；Acidobacteriota 3.52% |
| 纲 | Gammaproteobacteria 46.49%；Alphaproteobacteria 19.96%；Anaerolineae 7.49%；Cytophagia 3.86%；Saprospiria 3.42% |
| 属 | Candidatus_Competibacter 24.64%；Acinetobacter 14.09%；Defluviicoccus 12.11%；Phototrophicus 6.69%；Candidatus_Tepidaquicella 2.21% |

该均值受各模块和反应器记录数不平衡影响，不是等反应器、等时间或独立重复总体估计。新增报告还记录了独立重聚合核验和视觉复核；本次仅引用，不声称由文档任务执行。主总览横轴较密，逐节点信息优先看反应器图及metadata。

## G1：低C/N启动前后（8行；描述性组成已完成）

**分析问题。** 四个原反应器启动前后群落组成如何变化？絮状与颗粒污泥设计类型的轨迹有何描述性异同？

**实际设计数据。** R1为A0→A1，R2为B0→B1，R3为C0→C1，R4为D0→D1；对应ASV ID均加`Batch_01_`。原表日数1与约120d，精确结束时间尚未核实。DO阶段设置5–7 mg/L，单一标称目标NA，不取6；实测NA。R1/R2为絮状、R3/R4为颗粒设计类型，初始仅后两者加入颗粒污泥，不替代形态实测。

**方法、输入与输出。** 使用模块1.1共同方法、派生metadata及对象，结果位于主组成图、四反应器轨迹及Top3表，路径见上表；未进行多样性或前后差异检验。

**实际数据与主要发现。** 以下为各节点最高丰度已命名属及其占全部reads的比例，直接引用v2报告：

| 反应器 | 初始 | 启动结束 |
|---|---|---|
| R1 | A0：Defluviicoccus 25.55% | A1：Acinetobacter 23.31% |
| R2 | B0：Defluviicoccus 26.60% | B1：Acinetobacter 28.10% |
| R3 | C0：Candidatus_Competibacter 42.49% | C1：Candidatus_Competibacter 39.59% |
| R4 | D0：Candidatus_Competibacter 34.63% | D1：Candidatus_Competibacter 56.11% |

**生态学解释与待验证假设。** R1/R2最高已命名属发生更替，R3/R4最高属名称维持但比例变化方向不同；这支持按反应器讨论组成轨迹差异。启动前与结束时，各自四反应器Top3交集均为空，不等于群落没有共有属。启动选择及污泥设计类型关联可作为待验证假设，不能据最高属排序归因于功能适应或证明类型效应。

**统计局限。** 8行不是8个独立重复；两种设计类型各对应两个反应器标签，来源独立性及时间/运行条件混杂需逐方法评估。不默认可做独立两组检验，也不凭前后变化推断机制或因果。

## G2/G3：同一轮次连续DO阶段（2+4行；描述性组成已完成）

**分析问题。** 连续运行两个阶段末的组成有何变化？哪些变化在可配对反应器中方向一致？G2与G3分别保留自己的模块标签，联合章节仅用于解释共享时间轴。

| 模块 | 实际样本与反应器 | 采样日与设置 | 可追踪关系 |
|---|---|---|---|
| G2（2行） | B2（新R2）、D2（新R4） | 21d；阶段0–21d设置5 mg/L | 分别与B3、D3配对；本批无新R1/R3该阶段样本 |
| G3（4行） | A2（新R1）、B3（新R2）、C2（新R3）、D3（新R4） | 56d；阶段23–56d设置3 mg/L | B2→B3、D2→D3同一连续运行实体 |

第22天为5→3的过渡及稳定过程，无本批样本。原R1+R2混合后均分至新R1/R2，原R3+R4混合后均分至新R3/R4；混合比例和实际接种量NA。全部实测DO为NA。

**方法、输入与输出。** 使用模块1.1共同方法，阶段末组成及两对反应器内轨迹见主图、R2/R4图和Top3表。没有补造A2/C2的前一阶段样本，没有运行统计检验。

**实际数据与主要发现。** R2的Acinetobacter由B2的38.98%变为B3的42.58%，均为最高已命名属；R4的Candidatus_Competibacter由D2的55.49%变为D3的91.06%，亦均为最高属。G3另外两节点：A2最高为Acinetobacter 43.12%，C2最高为Candidatus_Competibacter 19.11%。G2实际两反应器Top3共同属为Acinetobacter、Candidatus_Competibacter；G3四反应器Top3交集为空。

**生态学解释与待验证假设。** 阶段推进伴随各反应器读数组成的不同变化，R4出现较高的单一已命名属占比。可假设运行条件与来源背景共同关联这些轨迹，但DO、时间和阶段无法分离，不能把观察到的比例变化写成DO响应的因果证据或功能富集。

**统计局限。** DO与时间/阶段共同变化；两对前后记录、两个混合来源块均不自动构成充分独立重复。不能用2对4行的独立t检验、Wilcoxon或无约束置换分离DO效应；是否有可识别的推断问题仍待评估。

## G4：恢复后基线与低DO长期运行（15行；描述性组成已完成）

**分析问题。** 保存恢复后初始群落如何沿各反应器低DO运行变化？四个切换前基线与后期三个时间点应分别描述。

| 记录日 | 原样本清单 | 行数 | 已确认取样层及DO设置 |
|---|---|---:|---|
| 1d | E1、F1、原G1、H1 | 4 | 原G3条件恢复结束，切换低DO前基线；恢复阶段设置3 mg/L |
| 30d | F2、原G2、H2 | 3 | 适应期后，设计稳定运行期；0.5±0.2 mg/L |
| 76d | E2、F3、原G3、H3 | 4 | 同上 |
| 145d | E3、F4、原G4、H4 | 4 | 同上 |

E/F/原G/H在已确认名单中分别对应R1/R2/R3/R4，不由字母自行推断。初始前源E1←A2、F1←B3、原G1←C2、H1←D3；经历4℃保存59d和恢复，不能与前序实验构造连续日数。第1–24天为低DO调试适应过程，但上述day1取样在切换前，不能说已暴露低DO一天。25–145d设置0.5±0.2，后期11行属于按设计划定的稳定运行期；运行性能稳态证据状态为not_reviewed。

**方法、输入与输出。** 模块1.1按实体展示完整轨迹、以子阶段汇总Top3，四基线及11后期均保留；不补造30d的R1样本、不强制平衡。使用原报告和上表所列四反应器图；没有运行群落检验或拟合稳态模型。分析metadata的四基线设置为NA，文档恢复设置3另列，来源差异见本文开头。

**实际数据与主要发现。** 下表引用最高丰度已命名属的实际节点序列，比例分母为全部reads：

| 反应器 | 恢复基线→低DO后期序列 |
|---|---|
| R1 | E1：Acinetobacter 39.61% → E2（76d）：Acinetobacter 18.49% → E3（145d）：Chryseosolibacter 9.58% |
| R2 | F1：Acinetobacter 39.23% → F2（30d）：Acinetobacter 36.38% → F3（76d）：Acinetobacter 16.56% → F4（145d）：Candidatus_Competibacter 50.35% |
| R3 | 原G1：Aridibacter 17.60% → 原G2（30d）：Defluviicoccus 24.27% → 原G3（76d）：Defluviicoccus 24.41% → 原G4（145d）：Defluviicoccus 24.77% |
| R4 | H1：Candidatus_Competibacter 73.45% → H2（30d）：同属43.59% → H3（76d）：同属68.99% → H4（145d）：同属54.16% |

四反应器基线阶段均值Top3共同属为Acinetobacter；后期按各反应器等记录均值求Top3交集，共同属为Defluviicoccus。后期R1只有2节点，其余各3节点，不能把交集视为跨独立重复的稳健性证明。

**生态学解释与待验证假设。** 各轨迹并不同步：R3后期三个节点最高属及比例接近，R2末期最高属变化，R4最高属名称维持但比例波动。局部最高属维持不等于整体群落稳定，更不等于运行性能稳态。保存、恢复、适应、时间与设置变化都可能关联这些组成；尚不能确定主导过程或功能分工。待验证假设为反应器及来源背景可能影响后期群落轨迹，后续须用完整组成及可用运行证据评估。

**统计局限。** 15行与后期11行均为纵向相关记录，不是相应数量的独立生物重复；30d不平衡，继承的共享来源仍在。所有瞬时DO未知，不填补连续协变量。阶段命名不能替代稳态证据，前后变化不能单独归因于DO。精确日历时间、恢复时长及取样缺口原因待核。

E3未分类属比例44.72%，高于该样本最高已命名属Chryseosolibacter的9.58%；后者只是在已命名属中的排序第一，不能称为全部群落的绝对优势。

## G5：同一母样四个粒径组分（4行；描述性组成已完成）

**分析问题与实际数据。** G4的R1在145d后延长18d，由同一污泥母样分为S1<100、S2为100–200、S3为200–500、S4>500 μm；原表163d为145+18推算，非已知日历日期。设置0.5±0.2 mg/L，实测NA。母样原始编号未知；内部共享事件键`G5_R1_single_mother`只是关系标识。

**方法、输入与输出。** 模块1.1已展示门/纲/属组成，G5不参与主分析Top N筛选，三阶元图及原矩阵见产物表。每粒径仅一个组分，无独立母样重复，未计算显著性或母样加权重建。筛分100/200/500 μm边界的闭开及处理细节未记录，不自行补定。

**实际数据与主要发现。** v2已命名属Top3如下：

| 级分 | 已命名属Top3及占全部reads比例 |
|---|---|
| S1（<100 μm） | Acinetobacter 30.13%；Defluviicoccus 8.86%；Candidatus_Competibacter 5.31% |
| S2（100–200 μm） | Thauera 20.84%；OLB8 6.32%；Phototrophicus 4.33% |
| S3（200–500 μm） | OLB8 9.70%；Candidatus_Competibacter 7.45%；Thauera 7.40% |
| S4（>500 μm） | OLB8 9.66%；Thauera 9.07%；Defluviicoccus 7.36% |

**生态学解释与待验证假设。** 同一母样级分显示不同的已命名属排序，构成粒径相关组成异质性的描述性线索。粒径微环境可能参与分化只是待验证假设；不能把类群名称赋予具体功能、活性或称为跨反应器粒径特异富集。缺少级分生物量/体积权重，四级分无权均值不是母样整体组成。

**统计局限。** 四组分不构成四份独立生物重复，不自动归类技术重复，不做粒径组间显著性检验。G5与G4-R1共享运行实体且采样时间不同，不能当独立处理比较；相对丰度变化不能据此解释为绝对数量变化。

最终报告记录S1–S4属级未分类比例分别为29.24%、37.91%、41.84%、44.50%；四级分均有较大未分类部分，限制细分属的生态学解释。

## 跨模块解释边界与下一步

- 2026-11-03时已有描述性优势属和组成轨迹；2026-11-04新增模块1.3 v2描述性alpha/beta结果，取代此前“没有多样性结果”的状态。差异菌检验、组装、网络、功能活性或机器学习结果仍未产生，不用预期方向替代发现。
- 33个取样记录不能统一作五组独立样本；必须保留反应器轮次、混合来源、纵向结构、G4保存恢复断点及G5母样层级。模块不是五个可交换处理条件。
- 本目录仅核查Batch_01；其他批次、批次效应及跨批次处理差异尚未评估。分类器文件名不替代训练材料与批次可比性证据。
- 后续审阅各模块v2发现，再按问题评估候选筛选和推断方法。模块1.3按最新设计解释G4切换前基线，同时保留派生表历史设置差异；模型或置换不能自动解决小样本、来源相关和DO/时间混杂，无法满足前提时保留描述，不给显著性结论。
- 新增日志及报告已记录`--build-confirmed-design`分支的对象构建/复用与组成执行，取代本次初检“有代码但无记录”的状态。本任务只整理并行产生的结果，不声称由本次文档操作执行科研分析。

## 累计更新约定

每个科研步骤实际结束后，同步更新本文件、[执行日志](analysis_log.md)与[项目总览](../../README.md)。本文件每个新增结果单元均记录：日期与状态、分析问题、方法/关键参数/软件版本、可追溯输入与报告、图表相对路径、实际数据、主要发现、生态学解释、统计局限及待验证假设。没有产物时明确写“未开展”或“待核查”，不创建空图表链接。

实际发现与假设分开写；数字和显著性须能定位到脚本产物或综合报告。按模块累计完善，不为每步另建重复解释文档或重复质量附件。历史结论若被新证据取代，保留可追溯说明、日期及来源；实验设计和原metadata不因撰写解释被改写。


<a id="module11-final"></a>

## 2026-11-03 模块1.1：群落组成与演替（已完成，最终交付）

**状态修正与来源。** 本节依据15:06–15:10实际分析与复核结果，取代本文前期“对象未生成、组成未开展”的交付状态；历史设计及解释边界保留。当前对象已生成，原metadata未修改，独立[派生metadata](../../results/community_composition/2026-11-03_v2/analysis_metadata.tsv)已保存。v1的图例裁切、浮点边界和Incertae_Sedis解释已由v2修正，v1不作为当前结论依据。实际检查、完整33行排序及数据/脚本指纹见[综合报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)和[run.log](../../results/community_composition/2026-11-03_v2/run.log)。

**分析问题与方法。** 用全部原ASV reads作样本内分母，按完整祖先谱系聚合Phylum/Class/Genus，保留所有5,510 ASV；G1–G4主分析29行，G5单列4级分。主图按29样本等记录权重均值选门/纲Top10、属Top15；G5独立图按自身四级分选相同Top N。Others仅含其余命名类群；Unclassified包括缺失和Incertae_Sedis等未定占位标记，完整谱系在矩阵保留。优势属定义为已命名正丰度Top3，反应器阶段均值对采样记录等权，不是时间积分或独立重复均值。

**程序与核验。** 使用[scripts/community_composition.R](../../scripts/community_composition.R)，缺失对象构建由[stage1_pipeline.R](../../scripts/stage1_pipeline.R)执行。R 4.5.2、phyloseq 1.54.0、Biostrings 2.78.0、ggplot2 4.0.3、digest 0.6.39。主分析43 PASS/4 WARNING/0 FAIL；G5独立图三阶元实际图层均PASS。Python从原ASV及taxonomy独立核算与TSV最大差4.996×10^-16，所有样本比例和≈1，五模块8/2/4/15/4，已有目录拒绝覆盖。上游数据及既有测序深度QC沿用，没有重跑DADA2、分类器、筛选或稀释。

| 阶段/实体 | 已计算的主要描述性发现 | 数据与图表 |
|---|---|---|
| G1原R1/R2 | 启动前最高已命名属Defluviicoccus分别25.55%/26.60%；结束时Acinetobacter分别23.31%/28.10% | [R1演替](../../results/community_composition/2026-11-03_v2/R1_community_succession.pdf)、[R2演替](../../results/community_composition/2026-11-03_v2/R2_community_succession.pdf) |
| G1原R3/R4 | Candidatus_Competibacter为各自前后节点最高已命名属；R3为42.49%→39.59%，R4为34.63%→56.11% | [R3演替](../../results/community_composition/2026-11-03_v2/R3_community_succession.pdf)、[R4演替](../../results/community_composition/2026-11-03_v2/R4_community_succession.pdf) |
| G2/G3连续运行 | 新R2 Acinetobacter 38.98%→42.58%；新R4 Candidatus_Competibacter 55.49%→91.06%；仅两对实际阶段末记录 | 同上R2/R4图；DO与运行天数共同变化，不解释为DO因果响应 |
| G4-R1 | 初始及76d最高已命名属Acinetobacter为39.61%/18.49%；145d最高已命名属Chryseosolibacter为9.58%，未分类属44.72% | R1图；末期不能将最高已命名属称为总体绝对优势 |
| G4-R2 | Acinetobacter初始/30d/76d为39.23%/36.38%/16.56%；145d最高已命名属Candidatus_Competibacter为50.35% | R2图；描述命名优势属更替 |
| G4-R3 | 初始最高已命名属Aridibacter 17.60%；30/76/145d的Defluviicoccus分别24.27%/24.41%/24.77% | R3图；近似比例不等于整个群落或反应器性能已达稳态 |
| G4-R4 | 初始/30/76/145d最高已命名属均为Candidatus_Competibacter，73.45%/43.59%/68.99%/54.16% | R4图；不代表绝对数量、功能或活性稳定 |
| G5同母样级分 | S1最高已命名属Acinetobacter 30.13%；S2 Thauera 20.84%；S3/S4 OLB8为9.70%/9.66% | [G5独立Top N](../../results/community_composition/2026-11-03_v2/G5_independent_top_taxa.pdf)及[PNG](../../results/community_composition/2026-11-03_v2/G5_independent_top_taxa.png) |

**跨反应器共同优势属。** 按各反应器同一子阶段的等记录权重均值Top3取交集：G2两个实际反应器共同为Acinetobacter、Candidatus_Competibacter；G4四个基线共同为Acinetobacter；G4后期四反应器共同为Defluviicoccus。G1前、G1后、G3四反应器的Top3无共同交集。“无交集”不等于没有共享类群，结果依赖Top3定义；G2两反应器也不是充分独立验证。

**科学解释与待验证假设。** 本批显示反应器标签与阶段相关的命名类群轨迹差异，可作为后续提出“不同接种谱系/运行经历伴随不同群落组成”问题的描述依据。不能据此区分接种、保存恢复、时间、DO或污泥形态各自作用。R3后期Defluviicoccus比例相近只是一类群的读数比例事实，不证明整体群落稳定；需另外定义群落变化指标并核对运行性能后再评估。粒径微环境伴随组成差异可以保留为假设，本次只有一个母样事件，尚无跨母样重复或功能证据。

**局限与人工核查。** 四个G4初始样本设置按用户本次请求为NA，设计文档恢复设置3保留于design_document_DO_*；未改写实验设计，若未来解释依赖该值需统一来源。G4后期11样本按设计划定稳定期，运行性能稳态证据未审阅；全部采样瞬时DO未知。G1前后、G2/G3连续阶段、G4纵向记录和两次混合均分来源均相关；G2及G4不平衡取样不插补。G5四级分不是独立重复，等权均值不是母样组成重建；未分类属比例S1–S4为29.24%/37.91%/41.84%/44.50%，限制细分属解释。仅有Batch_01，无法排除或估计未记录的提取/PCR/测序批次效应。没有显著性检验、共现网络、因果推断或绝对丰度/功能活性结论。

**后续状态。** 描述性组成交付已完成；alpha/beta推断、差异丰度、组装、功能和机器学习仍未开展。未来每项方法先核验实验单位、谱系相关、时间/阶段混杂、独立样本量和可识别性；不因对象构建成功而自动放开统计门控。

<details>
<summary>模块1.2旧版解释及版本说明（历史v1，已被下方v2替代）</summary>

<a id="module12-functional-guilds"></a>

## 2026-11-03 模块1.2：传统功能相关类群（已完成；16S文献关联）

有效结果：[综合报告](../../results/functional_guilds/2026-11-03_v1/analysis_report.md)、[映射证据](../../results/functional_guilds/2026-11-03_v1/functional_mapping_evidence.tsv)、[ASV注释](../../results/functional_guilds/2026-11-03_v1/functional_asv_annotation.tsv)、[功能分区丰度](../../results/functional_guilds/2026-11-03_v1/functional_guild_abundance.tsv)、[逐属丰度](../../results/functional_guilds/2026-11-03_v1/functional_taxa_abundance.tsv)。

**方法与状态。** 复用模块1.1原始count对象、33样本分组与采样顺序；每属/证据分区reads除以样本全部ASV reads。保守关联代理、属水平候选、分类不足、功能歧义和待研究分开，每ASV一个互斥汇总分区。原始taxonomy及分类器置信度保留，不把它当功能可信度。18条人工规则的原研究摘要/索引内容、DOI和实际核实状态记录于证据表；未核实不强配。没有重跑QC/注释、筛选、稀释或生成绝对丰度。

**直接观察（本批读数代理）。**

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

- R1的G4 GAO关联保守代理：E1 14.58% → E2 11.02% → E3 11.30%。
- R2的G4 GAO关联保守代理：F1 20.72% → F2 26.57% → F3 29.88% → F4 62.48%。
- R3的G4 GAO关联保守代理：G1 7.98% → G2 38.56% → G3 32.48% → G4 35.10%。
- R4的G4 GAO关联保守代理：H1 74.91% → H2 50.47% → H3 71.54% → H4 60.96%。

Nitrospira单列NOB/comammox歧义，不计两组；Dechloromonas/Acinetobacter不计保守PAO；Brocadia--other保留分类受限候选。Contendibacter与文献Contendobacter的同义关系已经NCBI核实；Defluviimonas不误当Defluviicoccus。保守NOB/AnAOB为0只能说明本小面板的精确标记未匹配，不说明功能不存在。

[33样本组成图](../../results/functional_guilds/2026-11-03_v1/all_samples_functional_composition.pdf)、[R1](../../results/functional_guilds/2026-11-03_v1/R1_functional_succession.pdf)、[R2](../../results/functional_guilds/2026-11-03_v1/R2_functional_succession.pdf)、[R3](../../results/functional_guilds/2026-11-03_v1/R3_functional_succession.pdf)、[R4](../../results/functional_guilds/2026-11-03_v1/R4_functional_succession.pdf)、[G4逐属趋势](../../results/functional_guilds/2026-11-03_v1/G4_functional_taxa_trends.pdf)、[G5](../../results/functional_guilds/2026-11-03_v1/G5_functional_composition.pdf)、[PAO/GAO对照](../../results/functional_guilds/2026-11-03_v1/PAO_GAO_descriptive_comparison.pdf)；同目录均有PNG。

**合理假设。** 各运行谱系与阶段的组成差别可用于提出不同运行经历伴随功能相关类群差异的假设；这不证明功能分工、碳竞争、磷/氮转化贡献或DO适应。GAO关联比例较高不等于除磷失败。

**待验证问题与限制。** 本项目没有功能基因或活性测量；功能参考类群的强证据不等于项目ASV功能确证。Nitrospira亚群、属内异质性、--other语义和未核实直接文献均有缺口。保留G4基线DO分析NA/文档3差异，全部实测NA，后期设计稳定期不等于性能稳态已核验。主29行及共享来源不独立，G5仅单母样；不做显著性、网络或因果推断，不将16S比例当绝对丰度。

### 同步整理模块1.1：观察、假设和待验证问题

**直接观察（沿用有效v2，非本次重新分析）。** R1/R2启动前最高已命名属Defluviicoccus分别25.55%/26.60%，结束时Acinetobacter为23.31%/28.10%；R4全部节点最高已命名属为Candidatus_Competibacter，G3末91.06%。R3的G4后期Defluviicoccus为24.27%/24.41%/24.77%；R2的145d Candidatus_Competibacter为50.35%。R1末期E3未分类属44.72%，最高已命名Chryseosolibacter仅9.58%。G5 S1 Acinetobacter 30.13%、S2 Thauera 20.84%、S3/S4 OLB8 9.70%/9.66%。详见[模块1.1 v2报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)及本文件前述模块1.1结果。

**合理假设。** 接种谱系和运行经历可能伴随群落轨迹不同，粒径微环境可能与组成差异相关；仅作为假设。

**待验证。** 单属比例相近不证明整体群落或性能稳态；最高已命名属不一定占总体优势。需要匹配运行性能、来源和时间结构后再提具体问题，不能把组成观察直接升级成功能、活性或因果结论。



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

来源证据见[模块1.2报告的输入指纹与本次复核](../../results/functional_guilds/2026-11-03_v1/analysis_report.md)。本次只核实来源与记录用户版本选择，没有新增功能、DO或显著性结论。


</details>

<a id="module12-functional-guilds-v2"></a>

## 2026-11-03 模块1.2：传统功能相关类群（已完成；16S文献关联）

有效结果：[综合报告](../../results/functional_guilds/2026-11-03_v2/analysis_report.md)、[映射证据](../../results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv)、[ASV注释](../../results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv)、[功能分区丰度](../../results/functional_guilds/2026-11-03_v2/functional_guild_abundance.tsv)、[逐属丰度](../../results/functional_guilds/2026-11-03_v2/functional_taxa_abundance.tsv)。

**方法与状态。** 复用模块1.1原始count对象、33样本分组与采样顺序；每属/证据分区reads除以样本全部ASV reads。保守关联代理、属水平候选、分类不足、功能歧义和待研究分开，每ASV一个互斥汇总分区。原始taxonomy及分类器置信度保留，不把它当功能可信度。18条人工规则的原研究摘要/索引内容、DOI和实际核实状态记录于证据表；未核实不强配。没有重跑QC/注释、筛选、稀释或生成绝对丰度。

**直接观察（本批读数代理）。**

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

- R1的G4 GAO关联保守代理：E1 14.58% → E2 11.02% → E3 11.30%。
- R2的G4 GAO关联保守代理：F1 20.72% → F2 26.57% → F3 29.88% → F4 62.48%。
- R3的G4 GAO关联保守代理：G1 7.98% → G2 38.56% → G3 32.48% → G4 35.10%。
- R4的G4 GAO关联保守代理：H1 74.91% → H2 50.47% → H3 71.54% → H4 60.96%。

Nitrospira单列NOB/comammox歧义，不计两组；Dechloromonas/Acinetobacter不计保守PAO；Brocadia--other保留分类受限候选。Contendibacter与文献Contendobacter的同义关系已经NCBI核实；Defluviimonas不误当Defluviicoccus。保守NOB/AnAOB为0只能说明本小面板的精确标记未匹配，不说明功能不存在。

[33样本组成图](../../results/functional_guilds/2026-11-03_v2/all_samples_functional_composition.pdf)、[R1](../../results/functional_guilds/2026-11-03_v2/R1_functional_succession.pdf)、[R2](../../results/functional_guilds/2026-11-03_v2/R2_functional_succession.pdf)、[R3](../../results/functional_guilds/2026-11-03_v2/R3_functional_succession.pdf)、[R4](../../results/functional_guilds/2026-11-03_v2/R4_functional_succession.pdf)、[G4逐属趋势](../../results/functional_guilds/2026-11-03_v2/G4_functional_taxa_trends.pdf)、[G5](../../results/functional_guilds/2026-11-03_v2/G5_functional_composition.pdf)、[PAO/GAO对照](../../results/functional_guilds/2026-11-03_v2/PAO_GAO_descriptive_comparison.pdf)；同目录均有PNG。

**合理假设。** 各运行谱系与阶段的组成差别可用于提出不同运行经历伴随功能相关类群差异的假设；这不证明功能分工、碳竞争、磷/氮转化贡献或DO适应。GAO关联比例较高不等于除磷失败。

**待验证问题与限制。** 本项目没有功能基因或活性测量；功能参考类群的强证据不等于项目ASV功能确证。Nitrospira亚群、属内异质性、--other语义和未核实直接文献均有缺口。保留G4基线DO分析NA/文档3差异，全部实测NA，后期设计稳定期不等于性能稳态已核验。主29行及共享来源不独立，G5仅单母样；不做显著性、网络或因果推断，不将16S比例当绝对丰度。

### 同步整理模块1.1：观察、假设和待验证问题

**直接观察（沿用有效v2，非本次重新分析）。** R1/R2启动前最高已命名属Defluviicoccus分别25.55%/26.60%，结束时Acinetobacter为23.31%/28.10%；R4全部节点最高已命名属为Candidatus_Competibacter，G3末91.06%。R3的G4后期Defluviicoccus为24.27%/24.41%/24.77%；R2的145d Candidatus_Competibacter为50.35%。R1末期E3未分类属44.72%，最高已命名Chryseosolibacter仅9.58%。G5 S1 Acinetobacter 30.13%、S2 Thauera 20.84%、S3/S4 OLB8 9.70%/9.66%。详见[模块1.1 v2报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)及本文件前述模块1.1结果。

**合理假设。** 接种谱系和运行经历可能伴随群落轨迹不同，粒径微环境可能与组成差异相关；仅作为假设。

**待验证。** 单属比例相近不证明整体群落或性能稳态；最高已命名属不一定占总体优势。需要匹配运行性能、来源和时间结构后再提具体问题，不能把组成观察直接升级成功能、活性或因果结论。



## 2026-11-03 统一v2交付与复现核验

本目录是当前模块1.2唯一有效入口，明确基于 `results/community_composition/2026-11-03_v2/`。旧功能v1仅作历史。此次为实际脚本复现，不是只修改目录名称；原始count、taxonomy、metadata、对象及群落v2未改写，未重跑上游QC/DADA2/SILVA。

- 主流程50 PASS、6 WARNING、0 FAIL（比旧版增加“群落v2基线锁定”断言）；新增目录22个文件：4个TSV、8组PDF/PNG、报告及run.log。
- 四份ASV注释/功能丰度/逐属丰度/文献证据TSV与此前结果逐字节一致。科学结果未变：主29样本等记录均值GAO关联36.9059%、AOB关联0.4220%、PAO关联0.1861%，仍为16S间接关联。
- G4第145天GAO关联比例R1/R2/R3/R4分别11.3049%/62.4818%/35.0967%/60.9643%；仅描述取样记录，不是独立重复显著性或DO效应。
- G4全零趋势面板的坐标已限制为非负；不再显示旧版自动负刻度，所有数据点及功能映射规则未变。
- 原功能v1的报告/run.log只追加历史标记，数值表与图件不改写；原群落v1/v2及原始输入保持原字节。README当前导航和累计解释均指向新功能v2，旧版解释折叠为历史。
- 尚未核实的目标功能文献、Nitrospira/PAO歧义、--other标签、G4初始设置来源差异及重复/混杂限制均按原记录保留，不新增功能确证或活性结论。

<a id="module13-diversity-v2"></a>

## 2026-11-04 模块1.2定向解释复核与模块1.3多样性（有效v2）

**版本和范围。** 用户已撤回并要求删除模块1.3初次输出，`results/diversity/2026-11-04_v1/`已删除；日志保留撤回轨迹。本节仅引用新生成的[diversity v2综合报告](../../results/diversity/2026-11-04_v2/analysis_report.md)及其数值表。输入固定为群落v2/功能v2和其SHA-256核对相同的原始count、taxonomy、现有对象及派生metadata；不读取旧模块1.3结果作为输入。没有修改原metadata、实验设计、原始数据或既有v2结果，没有重做上游QC/分类和功能丰度计算。

### 模块1.2解释审核

[定向review](../../results/diversity/2026-11-04_v2/module12_review.md)提供逐样本Competibacter/Defluviicoccus及其在GAO代理中的比例、完整ASV证据和原研究链接。

- S2 Thauera为20.8413%，PAO_genus_candidate为20.8664%；Thauera依据为SND5特定菌株研究，不能确证本批ASV为PAO，也不据此计入确定AOB。
- 三Brocadia--other ASV分别651、129、15 reads，原分类置信度约0.794858、0.999953、0.999945。前两ASV只见于G5四级分中的部分样本，第三只在E3=9、原样本G4=6；全部共795 reads。原谱系均为Planctomycetota → Candidatus_Brocadiia → Candidatus_Brocadiales → Candidatus_Brocadiaceae → Candidatus_Brocadia--other，上级kingdom标签同样带--other。完整原始字符串及零/非零分布见review；高分类置信度不等于无后缀的属确证或厌氧氨氧化功能确证。
- 18 Nitrospira ASV保持NOB/comammox功能歧义。Acinetobacter 171及Dechloromonas 4 ASV不进入保守PAO；参考分离株/物种证据不能外推全部属成员。映射不变，不新增功能赋值。
- G4趋势图为每面板独立纵轴；G4最大Brocadia--other仅0.01902%、Amaricoccus 0.04494%、Thauera 0.08463%、Accumulibacter 0.14305%，Obscuribacter为0。不能把这些面板的放大曲线与Competibacter（最高73.45159%）按图高比较。
- G4-R1的GAO关联代理主要由Defluviicoccus贡献（占代理约98.65%→90.88%→75.47%）；R2从Defluviicoccus主导转为Competibacter主导，末期Competibacter占代理80.58%；R3后期Defluviicoccus占代理约62.93%/75.14%/70.57%；R4 Competibacter占代理约86.38%–98.05%。这是读数代理的组成贡献，非代谢过程贡献。

### 模块1.3问题、方法及实际产物

分析四反应器各自轨迹、G4端点及相邻节点变化、同期反应器趋近/分化和G5母样内部级分差异，仅作描述。计算[scripts/diversity_analysis.R](../../scripts/diversity_analysis.R)，R 4.5.2、phyloseq 1.54.0、vegan 2.7.3、ggplot2 4.0.3、digest 0.6.39。主流程40 PASS/6 WARNING/0 FAIL，独立核验另列于报告末尾及日志，不将两类计数混加。

全部5510 ASV、未抽稀主分析：Observed=count>0，Shannon=自然log，Simpson=1−Σp²；Chao1为偏差校正Sobs+f1(f1−1)/[2(f2+1)]。原count中每样本f1仅0–6、f2为23–118，7样本f1=0，Chao1不能可靠估计真实总丰富度，也不能凭其接近Observed声称测序饱和。全33样本Observed为198–693、Shannon为0.91595–4.71496。

Beta使用ASV相对丰度Bray及存在/缺失二元Jaccard。完整33×33矩阵均保存；主29与G5单独PCoA。主29原负特征值3个、负绝对惯量比例约0.00508，用Lingoes常数0.0209916448741校正；前两轴解释校正后正惯量36.6003%/13.9022%，不是原始Bray的未经校正解释率。G5无负特征值，前两轴64.4059%/27.3849%。全部正轴与原/校正谱保存，原始距离表不变。

| 产物 | 路径与用途 |
|---|---|
| Alpha及功能比例对照 | [alpha_diversity.tsv](../../results/diversity/2026-11-04_v2/alpha_diversity.tsv)：33行、指标/reads/单双例及子抽样敏感性，不是改写metadata |
| 全部Beta | [Bray](../../results/diversity/2026-11-04_v2/bray_curtis_distance.tsv)、[Jaccard](../../results/diversity/2026-11-04_v2/jaccard_distance.tsv) |
| 全部排序轴及谱 | [坐标](../../results/diversity/2026-11-04_v2/pcoa_coordinates.tsv)、[特征值](../../results/diversity/2026-11-04_v2/pcoa_eigenvalues.tsv) |
| G4反应器内变化 | [22项变化表](../../results/diversity/2026-11-04_v2/G4_within_reactor_changes.tsv)：11相邻实际节点+11基线至后期，包含4个基线至145d |
| G4同期反应器距离 | [21个实际配对](../../results/diversity/2026-11-04_v2/G4_same_day_between_reactors.tsv) |
| 同轮转移 | [G1及G2→G3](../../results/diversity/2026-11-04_v2/continuous_run_transitions.tsv)：不跨保存恢复连接 |
| 敏感性 | [全部528对](../../results/diversity/2026-11-04_v2/pairwise_sensitivity.tsv)、[分子集汇总](../../results/diversity/2026-11-04_v2/sensitivity_summary.tsv) |

### R1–R4的直接观察与组成/功能对照

下面的G4顺序为各反应器实际节点：R1为1/76/145d，其他为1/30/76/145d。基线至145d间隔统一144d，基线是切换低DO前恢复污泥；这段距离不是DO单独效应。

| 反应器 | G4 Observed轨迹 | G4 Shannon轨迹 | G4 Simpson轨迹 | 基线→145d Bray / Jaccard |
|---|---|---|---|---|
| R1 | 458→447→463 | 3.9973→4.1812→3.6939 | 0.9560→0.9616→0.8989 | 0.7623 / 0.7520 |
| R2 | 304→417→519→473 | 3.5169→3.7069→4.4318→3.0742 | 0.9303→0.9211→0.9716→0.7851 | 0.7908 / 0.8009 |
| R3 | 545→482→483→504 | 4.3649→4.0056→3.9886→3.9426 | 0.9565→0.9496→0.9521→0.9486 | 0.6837 / 0.7377 |
| R4 | 314→399→351→459 | 1.9047→3.7360→2.5447→3.3090 | 0.4981→0.8948→0.6813→0.8343 | 0.4690 / 0.7512 |

- **R1**：G1原反应器前后Shannon 4.651→4.488；混合后G3的A2为3.324。保存恢复后的G4先升后降，末期Observed并未同步下降，说明丰富度和均匀度可有不同轨迹。模块1.1末期较高未分类属比例不阻断ASV计算，也不能给未分类ASV补功能。
- **R2**：G1 Shannon 4.715→4.524，G2→G3为3.954→3.258。G4 F3→F4（76→145d）Bray 0.6059、Jaccard 0.6756；Shannon 4.4318→3.0742，与Competibacter 16.21%→50.35%、Acinetobacter 16.56%→0.24%的更替一致。对ASV Bray逐项分解再按属求和，两属分别解释40.73%和13.71%的距离贡献，仍有其他ASV变化。
- **R3**：G1 Shannon 3.335→3.294，G3 C2为3.769。G4后期Defluviicoccus 24.27%/24.41%/24.77%，同时30→76d和76→145d Bray为0.3644/0.2192；同期Bray分别低于R2/R4以及所有其他反应器，支持这些端点丰度加权变化相对较小。Jaccard却为0.6942/0.6822，30→76d还高于R2/R4，不能称群落成员或运行性能已稳定。
- **R4**：G1 Shannon 3.805→2.578，G2→G3 2.684→0.916，D3有198 ASV、Competibacter 91.06%。G4 Competibacter 73.45%/43.59%/68.99%/54.16%与较低Shannon的描述相容，但R4仅在1d与76d为同期最低，30d和145d的R2更低。属级优势与ASV Alpha不是同一层级，不能把对应关系解释为因果。

图件：[R1](../../results/diversity/2026-11-04_v2/R1_alpha_trajectories.pdf)、[R2](../../results/diversity/2026-11-04_v2/R2_alpha_trajectories.pdf)、[R3](../../results/diversity/2026-11-04_v2/R3_alpha_trajectories.pdf)、[R4](../../results/diversity/2026-11-04_v2/R4_alpha_trajectories.pdf)、[G4共同纵轴Shannon](../../results/diversity/2026-11-04_v2/G4_shannon_trajectories.pdf)、[功能比例对照](../../results/diversity/2026-11-04_v2/G4_function_diversity_comparison.pdf)、[主29 PCoA](../../results/diversity/2026-11-04_v2/main29_bray_pcoa.pdf)。全部有PNG。主PCoA局部标签重叠，精确定位须查询坐标表；不能按二维点距替代完整距离。

### G4相邻实际节点及同期反应器

| 反应器 | 节点与真实间隔 | Bray | Jaccard |
|---|---|---|---|
| R1 | 1→76d，75d | 0.4865 | 0.6978 |
| R1 | 76→145d，69d | 0.4811 | 0.6212 |
| R2 | 1→30d，29d | 0.4995 | 0.6722 |
| R2 | 30→76d，46d | 0.4746 | 0.6817 |
| R2 | 76→145d，69d | 0.6059 | 0.6756 |
| R3 | 1→30d，29d | 0.4952 | 0.6487 |
| R3 | 30→76d，46d | 0.3644 | 0.6942 |
| R3 | 76→145d，69d | 0.2192 | 0.6822 |
| R4 | 1→30d，29d | 0.4739 | 0.6471 |
| R4 | 30→76d，46d | 0.4438 | 0.6388 |
| R4 | 76→145d，69d | 0.3434 | 0.7224 |

R1缺30d，不插补。距离不是沿途累计周转量，不用距离除以天数冒充真实变化速率。[相邻幅度图](../../results/diversity/2026-11-04_v2/G4_adjacent_changes.pdf)保留实际间隔。

同期R2–R4的Bray 0.8745→0.8210→0.8043→0.4355，支持末段丰度加权趋近，但Jaccard 0.8023→0.7748→0.7950→0.7737不支持同等程度成员趋同。R1–R2在1/76/145d为0.4267→0.4805→0.7774，末段分化。[同期距离图](../../results/diversity/2026-11-04_v2/G4_between_reactor_distances.pdf)及21对表显示不同反应器对并非一致趋同。1/30/76/145d全已观测对Bray均值为0.7504/0.7896/0.7562/0.7176，但30d缺R1相关对；固定R2/R3/R4三对均值为0.8182/0.7896/0.7951/0.6290。两两距离共享样本，仅作描述，不作总体趋势检验。

### G5同母样粒径内部差异

| 级分 | Observed | Shannon | Simpson | 偏差校正Chao1（解释受限） |
|---|---|---|---|---|
| S1 <100 μm | 403 | 3.85581 | 0.92294 | 403.000 |
| S2 100–200 μm | 465 | 4.23788 | 0.95278 | 465.000 |
| S3 200–500 μm | 497 | 4.34086 | 0.96100 | 497.000 |
| S4 >500 μm | 491 | 4.34413 | 0.96280 | 491.040 |

S3–S4 Bray最近0.2576（Jaccard 0.5385），S1–S2 Bray最远0.6197（Jaccard 0.6809）；六对完整值见综合报告及528对表。S3/S4 Shannon只差约0.00327，不能据细微排序声称普遍粒径规律；Observed也不随粒径单调增加。图件：[Alpha](../../results/diversity/2026-11-04_v2/G5_alpha_diversity.pdf)、[独立PCoA](../../results/diversity/2026-11-04_v2/G5_bray_pcoa.pdf)。没有母样间重复，四级分不是四份独立生物重复；不将等权平均当母样重建，不分离筛分/18d延长运行/粒径各自效应。

### 敏感性、科学局限与下一步证据

深度敏感性在内存不放回抽样31457 reads×100次、seed=20261104，不替代主分析，不写出抽稀count。主29原/等深度Bray排序相关约1、平均距离差0.000279；Jaccard约0.9998、平均差0.001357。Observed另给解析抽样期望。子抽样分位数反映读数抽样随机性，不是生物学置信区间。[深度敏感性图](../../results/diversity/2026-11-04_v2/depth_sensitivity.pdf)与Alpha表保留结果。

预设低检出敏感性为全样本总reads≥10的ASV算Bray、每样本count≥5定义Jaccard，仅敏感性过滤。Hellinger与主29 Bray秩相关0.9759；共同深度后加0.5/1再CLR与Bray只有0.5614/0.5871，两个CLR方案彼此0.9982。G4 Hellinger/Bray=0.9431、CLR0.5/Bray=0.5632。对深度较稳健不能升级为对所有组成方法稳健，丰度、检出和log-ratio关注不同部分；零值处理仍有假设。

**直接观察**仅限实际检出、比例、Alpha及距离。**未经验证假设**包括DO选择、粒径微环境、碳储存竞争、功能冗余与性能稳态。G1/G2G3/G4跨轮次和混合均分/保存恢复依赖、G4重复采样及缺失节点、G5单母样、未知采样瞬时环境和不可分离提取/PCR/测序子批次效应均保留。无显著性、无约束PERMANOVA、ANOVA、共现或因果结论；相对比例不等于绝对生物量，功能关联不等于基因或活性。

下一步非典型候选筛选应先说明ASV检出率、相对丰度和同轮实际节点持续性阈值及敏感性，保留未分类/--other不确定标签；核对代表序列区域和长度、参考库语义、参考比对与系统发育、物种/菌株功能原研究及可追溯运行性能/处理记录。跨轮次相关记录不冒称独立复现；没有本项目基因组/细胞表型/活性证据时仅保留候选，不编造新功能或新增验证实验。


<a id="module21-g4-asv-contributions"></a>

## 模块2.1：G4条件补充与ASV贡献（2026-11-05）

已完成描述性分析，当前目录为[results/asv_contributions/2026-11-05_v2](../../results/asv_contributions/2026-11-05_v2/analysis_report.md)。复用群落/功能2026-11-03_v2和多样性2026-11-04_v2，保持33样本、5510 ASV及8/2/4/15/4。先存[G4条件差异审核](../../results/asv_contributions/2026-11-05_v2/g4_design_addendum.md)，再追加[正式设计补充](experiment_design.md#2026-11-05-G4-conditions)。原始metadata、旧结果及对象均保留。

分析问题为R2/R4末段为何丰度组成趋近、R1/R2为何分化、R3后期为何丰度加权变化较小，以及关键ASV/属和已审阅功能关联。方法为全ASV原count归一化后逐ASV |pA−pB|/2分解；属级同时保存ASV贡献加和及属总量先求差。10对固定比较，Top10、共同高丰度两端≥1%、升降≥1个百分点及每目标属G4均值Top5均在计算前固定；无推断统计。软件R 4.5.2、digest 0.6.39、ggplot2 4.0.3，脚本[scripts/g4_asv_contributions.R](../../scripts/g4_asv_contributions.R)。主流程22 PASS/2 WARNING/0 FAIL，独立核验另列。

实际产物：

- [派生metadata：33×63](../../results/asv_contributions/2026-11-05_v2/analysis_metadata_addendum.tsv)，保留旧45列，新增18列温度/起始污泥/谱系/恢复DO来源字段。非G4温度、室温数值、全部实测温度、具体污泥编号和性状均NA。
- [ASV贡献：55,100行](../../results/asv_contributions/2026-11-05_v2/focal_pairwise_asv_contributions.tsv)、[属两算法：6,330行](../../results/asv_contributions/2026-11-05_v2/focal_pairwise_genus_contributions.tsv)、[时间变化：88,160行](../../results/asv_contributions/2026-11-05_v2/focal_temporal_asv_changes.tsv)。
- [全ASV轨迹：82,650行](../../results/asv_contributions/2026-11-05_v2/focal_asv_abundance_trajectories.tsv)、[功能连接：5,510行](../../results/asv_contributions/2026-11-05_v2/focal_asv_function_annotations.tsv)、[复用10对距离与敏感性](../../results/asv_contributions/2026-11-05_v2/focal_distance_summary.tsv)。
- [R2/R4趋近图](../../results/asv_contributions/2026-11-05_v2/R2_R4_convergence.pdf)、[R1/R2分化图](../../results/asv_contributions/2026-11-05_v2/R1_R2_divergence.pdf)、[R3后期组成图](../../results/asv_contributions/2026-11-05_v2/R3_late_composition_persistence.pdf)，同目录均有PNG；完整ASV ID可读。第一行少量边缘距离数字截断，精确值查距离表；原图保留。

### 结果与解释边界（Q1–Q5）

#### A. 直接计算的组成证据

**Q1，R2/R4末段趋近：**76→145d的Bray由0.804296降至0.435510，净变化−0.368787。所有ASV差缩小项合计−0.558551，差扩大项+0.189765；二者共同决定净变化，不能只挑缩小项。

最主要差缩小ASV为`3cae56af0b082bba9c858d1844913fc3`（Candidatus_Competibacter，沿用GAO关联）：R2/F3→F4为5.1454%→44.7053%，R4/H3→H4为55.3957%→38.9043%。两端绝对差由50.2504降至5.8011个百分点，对应ΔBray贡献−0.222247。它在R2上升、R4下降后接近；不是“两边都升高”。Acinetobacter ASV `9d94363a8ab81a79ecf766644aa45b23`两端均降至0，也使差距缩小（−0.025819），说明距离下降既可来自共同优势ASV，也可来自原差异ASV共同消退。Chryseotalea `a582a45cc296a1d3b0c246a7d7611c78`等差扩大项仍存在，不能宣称群落全面相同。

**Q2，R1/R2末段分化：**Bray 0.480549→0.777441，净增+0.296892；扩大项+0.502648，缩小项−0.205756。同一Competibacter ASV在R1/E2→E3仅0→0.0190%，在R2的变化为5.1454%→44.7053%（仅描述），使端点差扩大，对应Δ贡献+0.197705。故R2一次丰度重排同时关联“与R4趋近”和“与R1分化”，两种现象不矛盾。

第二大差扩大ASV `d1725130559823512a63bbc2c1bab523`的原属标签为Incertae_Sedis（Sphingobacteriaceae谱系，分类不足/未分配功能）：R1 9.4429%→28.1100%，R2 0.7810%→0.2029%，Δ贡献+0.096226。不能将Incertae_Sedis当作唯一明确生物属或强配功能。Acinetobacter `b815668a1e362dc6a897d2895c351449`在R1 0.7823%→8.5061%、R2 0.0979%→0.2430%，Δ贡献+0.037894；R1该属总量同期18.49%→8.96%下降，而此ASV上升，直接展示属总量不能替代属内ASV分析。

**Q3，R3较小丰度加权变化：**30→76d、76→145d Bray为0.364409、0.219243，相同ASV共享组成量分别0.635591、0.780757。末段有14个ASV两端均≥1%，其共享组成量合计0.548316。Defluviicoccus ASV `78c2842bcb5d089b057f231ddd53b8e1`为14.0900%→15.0196%→13.1484%，`82c70888e3f2436874633b4285a188e9`为3.7726%→3.6104%→3.5624%；这些相同ASV持续较高比例，与较小丰度距离相容。

R3仍有变化：Chryseotalea `be9af24f8e82484720783bcb4df4f6de`末段5.9966%→11.9159%，Aridibacter `54089b19ce1b3690c1e03d4d34a0162c`为6.0203%→1.2175%，分别贡献末段Bray 0.029597和0.024014；二者沿用功能未分配。不能由较小整体距离推断所有ASV不变、成员稳定或性能稳态。

**Q4/Q5，同属与相同ASV的区别：**R2/R4末期总共享组成量=1−Bray=0.564490。Competibacter属总比例50.3476%/54.1570%，同ASV共享量41.9293%，其中核心`3cae56af0b082bba9c858d1844913fc3`单独共享38.9043%；相似性确有同ASV支撑，不只是同属标签。但该属ASV累计Bray贡献0.103230，属总量先求差只有0.019047，属内差异仍大。

Defluviicoccus属总比例12.0982%/6.8073%，属标签共享量6.8073%，真正同ASV共享量仅2.5706%；ASV贡献0.068821，而属总量差贡献0.026455。R2末期该属主要为`82c70888e3f2436874633b4285a188e9`（10.1012%），R4该ASV1.4299%，R4另一主要ASV为`78c2842bcb5d089b057f231ddd53b8e1`（3.0078%）。不能把Defluviicoccus属标签一致称为相同属内群落。Acinetobacter末期同ASV共享量仅0.2430%，主要对应`b815668a1e362dc6a897d2895c351449`，不能用其解释主要趋近。

三目标属主要ASV已固定按每属G4全15记录等权均值Top5，分别列出四反应器的基线及后期比例、属内占比；全15节点和全部5510 ASV轨迹均保留。Competibacter/Defluviicoccus仅沿用GAO关联，Acinetobacter保持PAO歧义；Nitrospira、Dechloromonas、Thauera分别保留原功能歧义或菌株证据限制。贡献大的未映射类群不强行赋功能。

#### 敏感性限定

- R2/R4末段Bray、Hellinger、两CLR和Jaccard均下降，但Jaccard仅0.795014→0.773684，且全程波动；CLR0.5基线63.82331、末期67.45977，末期仍大于基线。因此支持的是特定末段丰度趋近，不能推广为全程单调、成员全面或全方法同幅度趋同。
- R1/R2末段Bray和Hellinger增大，Jaccard0.725594→0.752000；两CLR却略降（0.5：68.67068→68.31332；1：56.02453→55.61492）。分化描述不在log-ratio尺度得到同方向支持。
- R3末段Bray、Hellinger、两CLR均为同期四反应器最小；30→76d只有Bray最小，Hellinger/CLR的R4更小。R3两段Jaccard0.694181/0.682243，排名分别为3/3和3/4（由小到大），不支持成员持续性最强。
- 深度和低检出结果直接复用模块1.3，未重跑全流程。距离共享样本，排名和方向为描述，不提供p值或温度效应估计。

#### B. 条件、C. 生态解释与D. 因果边界

已确认R1/R3 30℃保温、R2/R4室温运行；四份G4起始污泥性状与初始菌群均不一致。可能的组成层面解释是优势ASV份额重排及属内更替；初始差异、条件选择和随机组成变化都可能产生观察轨迹，但这不是机制验证。历史混合均分、4℃59天保存恢复、反应器内重复测量及初始状态/个体差异使温度效应难以独立估计。实际室温未知，不量化温差，不认定温度导致趋近或低DO导致分化。16S比例不等于绝对丰度、活菌数、功能基因或活性。批次、扩增及拷贝数偏倚仍未分离，运行稳态证据待核验。

独立Python全表复核最大误差4.996×10⁻¹⁶，3组图文件完整性/目视检查通过，任务前139文件指纹不变；设计/累计解释/日志均保留历史前缀。待补科研记录为起始污泥编号与具体性状、室温实测、恢复/基线温度适用范围及性能稳态证据。无新的功能验证、温度/DO因果或统计显著性结论。


<a id="module22-candidate-asv-review"></a>

## 模块2.2：重点候选ASV筛选与分类学证据审核（2026-11-05）

**状态与替代关系。** 本节依据实际[模块2.2报告](../../results/candidate_asvs/2026-11-05_v2/analysis_report.md)及产物，取代模块1.3和旧进度中的“下一步尚待制定候选筛选方案”状态。文件顶部仅更新导航日期/进度，其余历史原文保留；模块2.1及三个有效v2继续有效，原taxonomy/metadata/功能映射和既有对象均不改写。33样本和8/2/4/15/4保持。

**分析问题与方法。** 重点为组成信号值得追踪的ASV、功能证据边界和分类可靠性。先固定用户5个优先候选，再按模块2.1十对比较的最大单ASV Bray贡献排序，从其余max≥0.005者补10个，平局完整ID升序；分类/功能不参与筛选。全5,510行保留，输出全33/主29/G4十五行/后期十一行的检出≥1/5 reads、等记录均值/最大比例；G4各反应器实际3/4/4/4节点与后期2/3/3/3节点持续性单列，不插补、不计算持续天数、不跨保存恢复拼接。既有轨迹/贡献直接复用，不重新计算距离。

**实际数据与复现。** 新目录[results/candidate_asvs/2026-11-05_v2](../../results/candidate_asvs/2026-11-05_v2/analysis_report.md)，脚本[candidate_asv_review.R](../../scripts/candidate_asv_review.R)，软件R 4.5.2、digest 0.6.39、ggplot2 4.0.3、Biostrings 2.78.0。主流程18 PASS/4 WARNING/0 FAIL；独立Python592,164次数值核对最大误差1.776×10⁻¹⁵，157个任务前科研文件指纹不变。重新执行已有目录退出1并拒绝覆盖，7产物未变。

- [candidate_asv_ranking.tsv](../../results/candidate_asvs/2026-11-05_v2/candidate_asv_ranking.tsv)：5,510行完整指标/原功能等级，selected=TRUE为15候选，selected_order对应图C01–C15。
- [candidate_asv_taxonomy_review.tsv](../../results/candidate_asvs/2026-11-05_v2/candidate_asv_taxonomy_review.tsv)：15行完整原谱系/Confidence数值及字符串、各阶元、真实序列和长度/身份指纹；参考匹配字段NA。
- [candidate_asv_evidence.tsv](../../results/candidate_asvs/2026-11-05_v2/candidate_asv_evidence.tsv)：15行逐ASV原证据和6篇文献审核，区分已知类群关联、属背景/特定株、分类受限和待核实。
- [轨迹PDF](../../results/candidate_asvs/2026-11-05_v2/candidate_asv_trajectories.pdf) / [PNG](../../results/candidate_asvs/2026-11-05_v2/candidate_asv_trajectories.png)：225个实际G4节点，独立纵轴，完整ASV ID和基线/后期点型；图件完整性及目视检查通过。仅连接采样点，不代表间隔全程存在；G5未连入G4轴。

### 直接观察与优先研究对象

| ASV | 实际组成信号及研究价值 | 分类/功能边界 |
|---|---|---|
| 3cae56af0b082bba9c858d1844913fc3 | G4检出14/15，均值16.6607%、最大70.6425%；末段R2/R4差缩小Δ贡献−0.222247，R1/R2差扩大+0.197705 | Competibacter标签，仅GAO参考类群关联；两比较共享R2，不是独立机制证据 |
| d1725130559823512a63bbc2c1bab523 | G4检出8/15；R1 76→145d为9.4429%→28.1100%，R1/R2差扩大Δ贡献+0.096226 | Confidence0.984092仍为Sphingobacteriaceae / Incertae_Sedis，不可按已命名属解释；功能未知 |
| 78c2842bcb5d089b057f231ddd53b8e1 | 全33及G4十五节点均检出；R3后期14.0900%→15.0196%→13.1484%，三个节点均≥1% | Defluviicoccus参考GAO关联，检出和比例持续不证明活性、存活或连续居留 |
| be9af24f8e82484720783bcb4df4f6de | R3 30/76/145d为0.1671%→5.9966%→11.9159%，末段Bray贡献0.029597 | Chryseotalea标签，Confidence0.851623，需定向复核；本项目目标功能未分配 |
| 54089b19ce1b3690c1e03d4d34a0162c | R3 30/76/145d为5.4720%→6.0203%→1.2175%，末段Bray贡献0.024014 | Aridibacter标签，Confidence0.823897；特定参考株硝酸盐利用仅属待验证线索 |

另外10个按固定规则入选：4个Acinetobacter、3个Competibacter、1个Defluviicoccus、未定属Paracoccaceae的`a578dfb348f923c17e372f94df5716ef`及Chryseosolibacter的`c32a06324874a524e422813afbe86397`；完整ID和最大比较见排名表/报告。`a578…`G4均值1.3610%、最大11.4601%，是应保留的功能未知生态候选，不因未定属被丢弃。max规则会选到基线/早期差异，不能把全部15个称为末段低DO特异标记。

### 文献与分类证据的分层解释

15候选中6个沿用GAO关联（Competibacter4、Defluviicoccus2），4个Acinetobacter保留PAO歧义；其余5个目标功能未知/未分配，其中2个属级不足（d172…及止于Paracoccaceae科的a578…）。15条序列404–430 bp，全部MD5等于ASV ID，原完整SILVA谱系和Confidence保留。Chryseotalea/Aridibacter低于0.90仅标定向审核优先，不删除、不重分类；其他高Confidence也不能当物种/功能概率。

[Competibacter原研究](https://pubmed.ncbi.nlm.nih.gov/24173461/)与[Defluviicoccus原研究](https://pubmed.ncbi.nlm.nih.gov/17185546/)支撑参考类群关联；[Acinetobacter分离株研究](https://www.sciencedirect.com/science/article/pii/S0043135498000797)保留历史歧义。Chryseotalea的[参考株分类描述](https://pubmed.ncbi.nlm.nih.gov/31792570/)、Aridibacter的[特定株研究](https://www.microbiologyresearch.org/content/journal/ijsem/10.1099/ijsem.0.002318)及Chryseosolibacter的[参考株研究](https://pmc.ncbi.nlm.nih.gov/articles/PMC9296434/)只形成培养/一般异养或特定菌株假设，不支持把本批ASV直接称为COD降解菌、完整反硝化菌或PAO/GAO。实际摘要/索引片段/相关结果获取层级和全文限制逐条记录；2个分类受限候选的ASV直接功能文献及DOI仍NA待核实。

未运行BLAST/系统发育或物种鉴定；项目无可用本地参考比对库与PATH工具组合，全部命中、相似度、覆盖率、物种字段NA。参考原分类器日志只提供文件名silva144-2026.7-full-length.qza和confidence=0.7等历史来源，不代表本次已取得其训练序列库。后续定向比对应记录参考版本/来源/校验和、匹配覆盖与并列命中；不能由高短片段相似度自动导出功能。原模块1.2映射未改变。

### 阈值敏感性、统计局限与待验证假设

非指定候选达到max贡献≥0.0025/0.005/0.01者分别98/55/33个，但固定补10个时15名单一致；补5或15个时总数为10/20，具体增减ID见综合报告。≥1/5 reads仅改变检出/持续性指标，不改变主候选资格；不得把这一点误称候选对所有检出阈值稳健。候选占十对既有Bray的份额为26.2676%–69.1430%，仅为组成差异的算术份额，非机制或功能过程解释率。

G4四份起始状态不同、R1/R3=30℃和R2/R4室温未知数值均保留；混合来源/4℃59d保存恢复和同一实体纵向重复使初始状态、反应器、时间和温度混杂。33/29/15/11是记录数，G5为单母样；批次/提取/PCR/16S拷贝偏倚未分离。没有p值、温度效应估计、绝对丰度或活性测量，不乘VSS/MLVSS。

**衔接后续性能背景。** 先核对现有COD、NH4-N/NO2-N/NO3-N/TN、PO4-P/TP进出水及温度记录，以sample_id、运行实体和采样日期/相对日及周期内窗口对齐；核对单位、采样口径与负荷所需流量/体积，不填补未知值。可先在同一反应器内并列描述候选相对份额和性能，GAO碳储存、Aridibacter相关硝酸盐利用及一般异养仅保留为待验证假设。不得给G5四级分复制同一性能值并当四个独立点。是否允许进一步统计须另行核验来源块、时间结构和可识别性；本次性能关联尚未开展。待补为参考比对/数据库后缀、起始污泥编号/性状、室温实测及运行性能稳态证据。


### 2026-11-05 版本命名维护（取代模块2.1/2.2此前v1当前入口）

用户明确要求v1仅作历史、有效输入为v2时所有当前名称统一v2。44项历史输入指纹核对确认2.1/2.2均沿用有效v2数据链，因此迁移目录/版本标签及当前来源引用，不重新计算或删除科学分析。模块2.1现为results/asv_contributions/2026-11-05_v2，模块2.2现为results/candidate_asvs/2026-11-05_v2；上文当前链接已同步。数值、ASV/样本ID、功能边界、阈值、候选名单和图件不变，原运行时间/历史输入指纹保留，不能将命名统一解释为新增科研验证。

<a id="module23-operational-performance"></a>

## 模块2.3：运行性能数据来源与33样本匹配审核（2026-11-06）

**问题、状态与版本。** 目的为查明项目已有性能记录能否与16S同期/采样前窗口/阶段背景对应，不进行关联检验。按用户2026-11-06要求重新执行，当前[analysis_report.md](../../results/operational_performance/2026-11-06_v2/analysis_report.md)取代[昨日草稿](../../results/operational_performance/2026-11-05_draft_v1/analysis_report.md)；旧六文件完整归档，旧报告自述路径按日志迁移关系回查。模块2.3按用户最新要求统一v2路径，取代此前v1命名；其他模块有效v2继续沿用。审计交付PASS、数据可用性WARNING、后续性能关联门控FAIL；主流程12/3/1仅表示本模块实际审核，不改写既有科研结果。

**方法与来源。** 使用[operational_performance_audit.py](../../scripts/operational_performance_audit.py)，Python 3.14.7标准库；实际2026-11-06 13:02:35–13:02:36（Asia/Shanghai）运行，退出码0，完整命令/时间/指纹见run.log。递归盘点包括隐藏/忽略文件、排除.git内部和当前新结果；共180个既有文件，包括昨日草稿六文件。逐文件记录原路径、格式、表头、SHA-256、参数文字提及和来源排除理由。无Excel/CSV/ODS、原始水质表或反应器运行测量日志；已有日志属于16S处理/分析或昨日盘点，既有图件属于16S结果。结论只限本项目可访问内容，不代表研究者未曾测量。文字提及、参数设置与实际测量分开。

唯一样本基准为[原metadata](../../metadata/source_sample_metadata.tsv)，33行14列不变；逐ID对照已确认设计名单及模块2.1派生表，G1–G5仍8/2/4/15/4。匹配表保留原行序和全部既有字段值（sample-id仅在新表中命名sample_id），按运行轮次/实际实体、反应器、阶段、相对日及来源审核；采样日历日期和周期ID均未提供，不用文件修改日期或目录名代替。

**实际产物。** 新目录仅有指定六文件，无性能统计图或中间数据：

- [source_inventory.tsv](../../results/operational_performance/2026-11-06_v2/source_inventory.tsv)：190行，180条文件记录+6条DO设置/4条G4温度运行条件来源，原表达、单位和设计文档行号可回查；Markdown无工作表时为NA。
- [performance_raw_long.tsv](../../results/operational_performance/2026-11-06_v2/performance_raw_long.tsv)：0条原始性能观测，仅保留来源/单位/实体/日期/周期/窗口/测量类型等表头，不制造全NA伪原始观测。
- [sample_performance_match.tsv](../../results/operational_performance/2026-11-06_v2/sample_performance_match.tsv)：严格33行，每参数独立值/单位/等级/记录ID/缺失原因；33×14=462个参数位置均NA/D。保留DO设置和温度设计背景，不能当作已匹配实测。
- [parameter_completeness.tsv](../../results/operational_performance/2026-11-06_v2/parameter_completeness.tsv)：COD、NH4-N、NO2-N、NO3-N、TN、PO4-P、TP、DO、温度、pH、HRT、SRT、MLSS、MLVSS共14行，全部实测覆盖0/33（0%）、A/B/C各0、D各33；进水/出水/周期/瞬时/阶段实测均值记录数均0。
- [analysis_report.md](../../results/operational_performance/2026-11-06_v2/analysis_report.md)及[run.log](../../results/operational_performance/2026-11-06_v2/run.log)：中文来源审核、33样本匹配规则、逐项可行性、十五候选原证据及输入/软件/时间记录。

**匹配与可用背景。** A须同实体且同日或明确同一采样周期；B须明确同实体且采样前窗口；C须有可回查阶段实测均值和对应窗口；D为无法匹配。没有任意最近邻容差或7/14/30天窗口，A/B/C不合并。DO阶段设置可关联33行，但不是C类阶段均值；G1八行保留5–7范围、不取中点，其余25行有名义设置上下文，含四个恢复基线设置3，旧分析NA与文档3仍分列。G4温度运行标签15/33（45.45%），R1/R3七行有30℃设置上下文、R2/R4八行室温数值NA；七行包含两基线，不能反推其恢复期/瞬时温度。非G4包括G5温度不外推，4℃仅为历史保存条件。所有瞬时实测仍NA，缺失不等于生物学零值。

**设计与生态解释边界。** G4起始E1←A2、F1←B3、原G1←C2、H1←D3及两个继承混合来源块完整保留，四份起始状态不同不等于独立谱系，污泥原登记号/具体性状仍NA。G1原轮次、混合均分后G2/G3连续运行、4℃59d保存恢复后G4新时间轴分开；不跨保存恢复拼接。G4原样本G1与模块G1分开，不新增未确认的模块G1保存步骤。R1缺30d不插值；G5仍是同一R1母样四级分，163d保留推算属性。内部去重采样事件键30个不等于30份独立生物观测，实际独立性能观测0。G4后期十一行仍为按设计稳定运行期，性能稳态因无原始记录而无法评价，不据此断言稳或不稳。

**可行性与候选。** 同期描述、采样前窗口分析均无通过匹配的参数；没有C类阶段实测平均，只能使用上述设计背景。没有足够独立性能配对观测支持任何相关检验；温度缺实测/反应器内操纵，且与不同初始污泥、来源块、个体及历史混杂，不能单独识别温度效应。模块2.2原十五候选全保留，本次获准进入性能关联者为0；C01 Competibacter、C02分类受限d172…、C03 Defluviicoccus、C04 Chryseotalea、C05 Aridibacter及其余十个均只作待补资料后的探索名单。六个GAO文献关联、四个Acinetobacter歧义及五个功能未知/未分配不改变，不能强配COD/氮磷功能、功能基因或活性。没有重新筛选、相关性、机器学习、共现网络、因果推断或MLVSS换算绝对丰度。

**复核及后续。** 独立核对190条来源定位/指纹、原14列与全部2.1派生字段、462个D/NA、14条覆盖率、G5继承来源和15候选一致；已有目录重跑退出1、六文件不变。177个既有受保护文件按迁移映射保持SHA-256不变（含草稿六文件）；新来源CSV/TSV/Excel及旧性能长表出现记录的阻断验证通过。待补原始运行/水质文件、单位/方法/缺失标志、进出水/周期位置、实际运行实体和日期/相对日锚点，以及16S采样日期或明确周期ID。若只有阶段均值，需对应窗口、底层测量数和可回查来源，不能复制成多个独立观测。已有五组名单无须重新提交。先补来源与匹配，再审核具体方法是否可行，现有组成信号不产生新的生态机制结论。


### 2026-11-06 模块2.3统一v2名称（当前有效）

用户要求确认使用v2后统一当前名称。已通过source_inventory.tsv和实际run.log逐项核对9个有效输入SHA-256：模块1.1–2.2五份v2报告、模块2.1 v2派生metadata及模块2.2 v2排名/证据/分类三表均一致。原metadata仍为唯一33样本基准，历史v1文件仅盘点/追溯，不作当前分组或候选来源。

当前入口已迁移为[results/operational_performance/2026-11-06_v2](../../results/operational_performance/2026-11-06_v2/analysis_report.md)，同日旧v1目录不再存在；昨日草稿保留历史。四TSV逐字节一致，33样本、五组、缺失原因、0%实测覆盖及性能关联门控均不变。脚本默认v2、拒绝v1输出、已有目录不覆盖。报告/日志保留原运行时间和旧指纹并追加迁移映射；本次未重跑分析。上述当前v2约定取代此前本模块按v1交付的命名说明。

<a id="module23-influent-conditions"></a>

## 模块2.3补充：图片进水来源、共同条件与实测覆盖分离（2026-11-06）

**问题、来源与版本。** 用户提供图片“表2.1 进水中各组分浓度”“表2.2 进水中微量元素组成及含量”，随后确认“所有阶段和反应器的进水水质参数都是这样”。新增源表[2026-11-06_influent_image_transcription_v2.tsv](../../data/operational_performance/2026-11-06_influent_image_transcription_v2.tsv)保存13条图片转录、表号/行列位置、原标签/原值/单位/完整化学式、来源层级及确认原话。原图在会话中已读取，本地二进制不可用，原图路径/图像指纹NA，不伪造归档文件；源转录自身有真实指纹。测量性质未说明，记录为文档报告的共同进水条件，而非擅自认定配水设定或实测平均。适用范围已解决，不再重复索取名单。

本节依据最新[2026-11-06_influent_v2报告](../../results/operational_performance/2026-11-06_influent_v2/analysis_report.md)，取代前节新增图片前的“无进水数值来源”状态；原[2026-11-06_v2](../../results/operational_performance/2026-11-06_v2/analysis_report.md)、草稿和全部上游结果保留，不覆盖。原metadata仍33×14，五组8/2/4/15/4及既有派生字段原值不变，未更新RDS或功能注释。

**实际数据。** 表2.1为COD 230、NH₄⁺-N 50、TP 3.3、KHCO₃ 250 mg/L；表2.2为EDTA 5、FeCl₃·6H₂O 0.9、KI 0.18、ZnSO₄·7H₂O 0.12、CuSO₄·5H₂O 0.03、Na₂MoO₄·2H₂O 0.06、H₃BO₃ 0.15、CoCl₂·6H₂O 0.15、MnCl₂·4H₂O 0.06 mg/L。盐类浓度按原化合物保留，EDTA具体化学形式不补；TP不当PO4-P，NH4-N不当TN。未知其余氮磷参数不填零，不自行把盐浓度换成元素含量或碱度。

**方法与复现。** 扩展现有[operational_performance_audit.py](../../scripts/operational_performance_audit.py)，Python 3.14.7标准库；实际2026-11-06 15:03:47（Asia/Shanghai）运行，默认新目录拒绝覆盖且禁止v1输出。程序核对9项上游有效v2及原metadata指纹、13项原值/单位/有限性和范围确认、四起始来源/温度/保存边界/G5母样，并将共同条件与可审核性能测量分列。13条来源只保存一次，通过record_id链接33样本，不新增独立测量。所有13项条件在33行程序核验为常数；图示COD/NH4-N=230/50=4.6，不计算COD/TN、去除率或负荷。

**实际产物。** 新目录仅指定六文件，另新增一份源数据：

- [source_inventory.tsv](../../results/operational_performance/2026-11-06_influent_v2/source_inventory.tsv)：210行=187个文件记录+10条原DO/温度设计来源+13条图片进水来源定位，历史盘点不重新导入为测量。
- [performance_raw_long.tsv](../../results/operational_performance/2026-11-06_influent_v2/performance_raw_long.tsv)：13条文档进水条件，stream_type=influent，日期/周期/底层测量数NA；不是13次采样。
- [sample_performance_match.tsv](../../results/operational_performance/2026-11-06_influent_v2/sample_performance_match.tsv)：33行，保留全部原metadata及2.1字段；13项条件共429个来源链接，仍来自同一份图片资料。`influent_*_reported_value/unit/condition_record_id`明确给出数值与原来源；原性能测量列仍NA/D。
- [parameter_completeness.tsv](../../results/operational_performance/2026-11-06_influent_v2/parameter_completeness.tsv)：14项参数中COD/NH4-N/TP各1条文档记录、各33/33条件覆盖（100%），共99个条件链接；各参数可核实测覆盖仍0/33，A/B/C均0、D均33。额外10项化学组分保留在源表/长表/匹配条件列，不改变14参数分母。DO设置33行、G4温度15行仍为独立背景口径。
- [analysis_report.md](../../results/operational_performance/2026-11-06_influent_v2/analysis_report.md)及[run.log](../../results/operational_performance/2026-11-06_influent_v2/run.log)：17 PASS / 4 WARNING / 1 FAIL，含逐项可行性、十五候选沿用、输入/脚本指纹和实际时间。

**科研解释与可行性。** 可以在共同进水条件下描述不同反应器/阶段的16S组成，不能将恒定浓度作为解释样本间ASV差异的协变量；同一来源复制显示不增加独立观测或生物重复。图示浓度比4.6不足以验证实际碳限制、碳竞争、反硝化或除磷失败。没有出水和时序测量，不计算去除率、氮磷平衡/负荷、采样前均值或滞后作用；共同进水相同也不能证明温度是唯一原因或运行稳态。

A类须同日/周期实测，B类须明确采样前窗口，C类须可回查阶段实测平均；本次共同范围确认并未提供这些测量依据，不能将图片浓度自动归C。所有13项共同条件映射PASS；测量性质、日期/窗口及原日志缺失WARNING；可核实独立性能观测0、所有候选暂不进入性能相关检验FAIL。15候选全保留，原6个GAO关联、4个Acinetobacter歧义及5个功能未知/未分配不变；分类不是功能基因/活性，相对丰度不是严格绝对量，不乘MLVSS/VSS。未重算QC/分类/距离/筛选，未运行相关、学习、网络或因果模型。

**实验设计与待补信息。** G1旧轮次、混合均分后G2/G3连续轮次、4℃59d保存/恢复后G4新时间轴均保留；G4四起始污泥不同、R1/R3=30℃与R2/R4室温未知、R1无30d及G5同母样四级分不变。进水全范围确认不解除来源、初始状态、个体、历史和纵向混杂，也不证明性能稳态。仍需说明浓度为配水设定/单次实测/阶段均值，若属实测需日期/方法/底层数/窗口；后续重点补出水/实际运行序列及16S日期或周期锚点。进水数值和适用范围已确认，不再要求重复提供；未知HRT/SRT、MLSS/MLVSS、流量/体积等保持NA。

**独立核验。** 13项转录原值/化学式/单位、210来源、429个条件链接、462个D/NA、14参数覆盖及33原样本/旧派生字段通过；183个既有受保护文件SHA-256未变，含旧模块2.3和全部上游/原始资料。临时项目验证从源复现六文件、范围变更/测量性质变更/新未审核来源在写入前阻断；默认已有目录拒绝覆盖且六产物不变。历史日志前缀及累计解释原正文保留，本节新增结果不改写旧运行证据。

<a id="module23-design-recipe-confirmation"></a>

## 模块2.3正式确认：统一人工进水设计配方（2026-11-06）

**问题与证据更新。** 用户正式确认表2.1和表2.2为人工进水配方，适用于Batch_01全部G1–G5实验过程，33样本共享同一名义进水设计。此为配方性质的明确确认，解决前节`measurement_basis=not_specified`，当前应记为`design_recipe`，不再询问性质/范围。旧源表、旧报告及派生数据保留历史；本节据[新审核报告](../../results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md)更新当前解释，不覆盖任何历史有效v2。

**正式数据与设计依据。** [源配方表](../../data/operational_performance/2026-11-06_influent_design_recipe_v2.tsv)13行、1个recipe_id，每项`data_type=measurement_type=design_recipe`、`measurement_basis=nominal_design_concentration`、`sample_measured=FALSE`。保留表2.1/2.2全部原值/标签/单位/水合化学式、旧转录记录与SHA-256，并指向[实验设计正式确认节](experiment_design.md#2026-11-06-uniform-influent-design-recipe)及用户确认原话。主要值为COD230、NH4-N50、TP3.3、KHCO3 250 mg/L；微量配方沿用表2.2，未进行盐类元素/碱度换算，未把NH4-N代为TN或TP代为PO4-P。统一配方适用已确认轮次的实验运行，不被解释成保存液或采样瞬时实测。

**名义比值。** COD/NH4-N=230/50=**4.6**；COD/TP=230/3.3=69.696969…，约**69.70**。脚本使用Decimal精度28位、两位小数ROUND_HALF_UP，完整值与展示值记录在metadata和报告。它们是设计配方比，不是样本实测比、COD/TN、去除效率/负荷或实际碳限制证据，不能据此推断类群活性、碳竞争或氮磷去除。

**派生metadata与执行。** 使用原[operational_performance_audit.py](../../scripts/operational_performance_audit.py)新增默认`--mode design-recipe`，保留旧`--mode image-audit`逻辑；Python 3.14.7标准库，实际2026-11-06 15:57:31（Asia/Shanghai）运行，退出0。输出[analysis_metadata.tsv](../../results/operational_performance/2026-11-06_design_recipe_v2/analysis_metadata.tsv)33行93列，原`sample-id`与原表行序保留，原14列及2.1全部63列逐值保持。新增`uniform_influent_design=TRUE`、共享recipe_id/来源/确认出处、`influent_data_type=design_recipe`、`influent_sample_measured=FALSE`、13项名义浓度、两个名义比（COD/TP另有两位小数显示）及关联关闭标记。原始metadata和RDS不修改。

一份设计配方映射到33样本，仅作为设计属性共享，不等于33条独立水质观测；独立水质观测新增数明确为0。13组分不是13次采样。33样本每项设计浓度均1个水平，不能作为可估计的ASV连续协变量，不能用其“补齐”性能实测字段。

**模块2.3门控与科研局限。** 脚本实际复核旧匹配表和完整性：14项实测覆盖均0/33（0%）、462个性能位置NA/D、A/B/C均0。design_recipe既不是同期sample_measured，也不是采样前窗口或阶段实测平均，新增确认不放开性能关联门控。实际进出水/运行测量及日期/周期/窗口仍缺；15候选保持原证据，未开展关联、学习、网络、因果或显著性分析。

原63列保持G1旧轮次、混合均分后G2/G3连续轮次、4℃59d保存/恢复后G4新时间轴；四份不同起始污泥及共享谱系、R1/R3=30℃与R2/R4室温未知、R1无30d、G5同母样四级分等边界不变。同配方不解除反应器个体、初始状态、历史/时间和温度混杂，不证明运行稳态或功能活性；16S相对丰度也不成为绝对量。本次未运行DADA2、taxonomy、功能映射、群落多样性或距离计算。

**产物与审核。** 新目录`results/operational_performance/2026-11-06_design_recipe_v2`仅保存新metadata、[analysis_report.md](../../results/operational_performance/2026-11-06_design_recipe_v2/analysis_report.md)、[run.log](../../results/operational_performance/2026-11-06_design_recipe_v2/run.log)，另有正式源配方表；不重复输出旧六表。9 PASS / 2 WARNING / 1 FAIL中FAIL仅为后续性能关联关闭，设计确认交付PASS。独立校验源配方13项/两个比值/33×93全部旧列与新标记通过，默认重跑已有目录在写入前拒绝；临时项目验证设计值误标sample_measured、错误适用范围或性能实测事实变化均非零阻断。旧数据/报告保持字节，设计与日志仅追加，三文档同步当前入口。


<a id="module24-ecological-candidates-v2"></a>

## 2026-11-07 模块2.4第一阶段：非传统生态ASV补充筛选与候选清单（v2，已完成）

**分析问题与实际产物。** 从5510个ASV中补充较高比例、持续出现、跨反应器检出或较大组成变化贡献的非传统/未知生态对象，形成下一阶段分类和文献审核清单。当前[综合报告](../../results/ecological_candidates/2026-11-07_v2/candidate_screening_report.md)、[全ASV生态特征5510×267](../../results/ecological_candidates/2026-11-07_v2/all_asv_ecological_features.tsv)、[候选优先表106×150](../../results/ecological_candidates/2026-11-07_v2/candidate_priority_table.tsv)及[run.log](../../results/ecological_candidates/2026-11-07_v2/run.log)均实际生成，入口为[scripts/ecological_candidate_screening_v2.py](../../scripts/ecological_candidate_screening_v2.py)。本节补充模块2.2，不覆盖原15候选或已有证据；旧候选编号C01–C15不变，新N编号按完整ASV ID升序，数字不代表优先级。

**复用与设计边界。** 输入只取模块1.1/1.2/1.3/2.1/2.2和2.3正式配方当前有效v2及其匹配原始count/taxonomy/序列；模块2.2已有全5510行生态指标直接逐字符继承，仅补33样本ASV比例、跨反应器/丰度节点、完整各阶元/歧义、规则与优先级。55100行10对Bray贡献与既有排名逐项核对，距离未重算。未重跑Cutadapt/DADA2/SILVA、深度QC、功能映射或Alpha/Beta；原metadata、已有RDS及历史产物不改。

33样本G1–G5=8/2/4/15/4，主29；G4为4切换前基线+11设计后期、R1只有1/76/145d，其余1/30/76/145d。四份起始污泥不同，R1/R3=30℃运行标签，R2/R4实际室温未知，全部瞬时DO/温度未知；保存恢复及共享混合谱系保持。共同进水只是名义design_recipe。G5同一母样四粒径组分只在33比例列独立描述，不参与候选规则、主29均值或得分。节点检出不是独立重复或连续日数。

### 规则、直接观察与证据组织

检出主定义≥1 read。A：任一主29样本比例≥1%；B：同G4实体≥3实际节点检出且≥2节点比例≥1%；C：≥3反应器检出且≥2反应器曾≥0.5%；D：既有10重点比较单ASV Bray贡献≥0.005。B包括基线且不要求连续，不跨保存恢复拼接；C不要求同日，不能称独立复现；D是无量纲绝对贡献，不是Bray份额或显著性。任一满足即入池，无名额上限。

| 场景 | A | B | C | D | 并集 | 与原15重叠 |
|---|---:|---:|---:|---:|---:|---:|
| 宽松 | 177 | 67 | 99 | 103 | 189 | 15 |
| 主规则 | 103 | 39 | 58 | 60 | 106 | 15 |
| 严格 | 55 | 26 | 16 | 38 | 55 | 15 |

**直接观察：**主池106，原15全部保留，新增91。B及D被A覆盖，只有C另外补入3个ASV：N006 `078950af1d2894df2fe2e8f95e0313d2`（未定属）、N020 `29050e55ca42dadb6c2997c7c1161c79`（未定属）、N086 `f472b119f8c6da7eed0add3b99588890`（原Sanyastnella标签）。因此不能把多规则命中解释为多份相互独立证据；B/D用于说明持续性/变化数学来源。全ASV保留完整触发位置，候选表是主池∪原15，实际106行。

互斥组织完全依据既有模块1.2证据，不更改功能映射：传统功能相关426个/主池16，非传统候选生态类群1818/45，功能歧义206/13，分类受限或功能未知3060/32。原15分别6/3/4/2。菌株/属水平功能候选纳入“功能歧义”并保留原genus_level_candidate_only，未核实来源纳入未知；“非传统”只表示有原属标签且目标功能未分配，未入主池行的类别也不等于入选。所有5510项目ASV功能验证均not_measured，功能未知不等于无功能。原SILVA谱系、原Confidence、Incertae_Sedis/--other/代码/低置信标记完整保留。

### 八个重点生态审核对象与两个关联对照

生态分数为丰度、Bray、主29检出率、同反应器≥1%节点比例及跨反应器曾≥0.5%比例五项等权0–100，尺度和公式见综合报告。原分类证据作为并列审核轴，不当功能概率加分；低分类分辨率不能据此丢弃ASV。选取方案为研究问题指定C02/C04/C05/C10（均实际入池）+其余非传统/未知主池生态分前4；这是定向审核顺序，非全局盲选Top8。分类证据、触发规则、角色与全池排名一并保留。

| 审核编号 | 完整ASV ID | 原标签 | 主29检出 | 主29最大比例 | 最大Bray贡献 | 具体推荐依据及审核重点 |
|---|---|---|---|---|---|---|
| C02 | d1725130559823512a63bbc2c1bab523 | Incertae_Sedis | 13/29 | 28.110% | 0.139536 | R1三个节点均检出、两个≥1%，最大28.110%；原Incertae_Sedis不能当已鉴定属，先定位Sphingobacteriaceae真实谱系。 |
| C04 | be9af24f8e82484720783bcb4df4f6de | Chryseotalea | 18/29 | 11.916% | 0.029597 | R3四节点检出、两个≥1%，末段贡献0.029597；Confidence约0.852，优先核对Chryseotalea原标签。 |
| C05 | 54089b19ce1b3690c1e03d4d34a0162c | Aridibacter | 20/29 | 17.604% | 0.024014 | R3四节点均≥1%，跨四反应器检出；Confidence约0.824，参考株硝酸盐利用不能外推本ASV功能。 |
| C10 | c32a06324874a524e422813afbe86397 | Chryseosolibacter | 6/29 | 10.168% | 0.050375 | R1三节点检出、两个≥1%，局部最高10.168%；仅两个G4反应器检出，不满足C，仍满足ABD；需审核Chryseosolibacter标签。 |
| C09 | a578dfb348f923c17e372f94df5716ef | NA | 26/29 | 11.460% | 0.057123 | 主29检出26/29，G4四反应器检出，R2三个节点≥1%；原分类止于Paracoccaceae科，不能强配父科常见功能。 |
| N026 | 3c495f2e6a55da9e059579e82a2dfc39 | Phototrophicus | 27/29 | 9.543% | 0.008492 | 主29检出27/29，G4四反应器检出，R3/R4分别4/3节点≥1%；Phototrophicus仅为原标签，定向分类/功能文献未审核。 |
| N045 | 80225eb15f3521f7cc5b5c36e3afdf15 | Candidatus_Tepidaquicella | 22/29 | 8.286% | 0.029315 | G4四反应器检出，R3/R4分别3/2节点≥1%，R3 30→76d贡献0.029315；Candidatus_Tepidaquicella功能尚未知。 |
| N072 | cfb0a32a7a0d5e6c513509147a75da65 | OLB8 | 29/29 | 4.545% | 0.016474 | 主29全部检出，G4四反应器检出，R1/R2/R3分别2/2/3节点≥1%；OLB8为代码标签，须回查数据库分类语义和参考谱系。 |

C01 `3cae56af0b082bba9c858d1844913fc3`（Candidatus_Competibacter）与C03 `78c2842bcb5d089b057f231ddd53b8e1`（Defluviicoccus）另列GAO参考类群关联对照，不占上述8个生态目标。原15全部保留原证据和序列审核所有字段；Acinetobacter等仍保留PAO歧义。C04/C05/C10原参考株培养/分类背景是有限关联，不能声称已验证本ASV代谢或处理功能；新增ASV的MiDAS/原研究证据字段不伪填。

### 敏感性、潜在生态假设与未开展任务

宽松A0.5%、B≥2检出且≥2节点≥0.5%、C≥2检出反应器且≥2曾≥0.25%、D0.0025；严格A2%、B≥3检出且≥2节点≥2%、C四反应器检出且≥3曾≥1%、D0.01。严格⊆主⊆宽松；严格相对主丢失51、宽松新增83，Jaccard分别0.5189/0.5608。**原15及推荐8个均保留于三池。** 检出改为≥5 reads时主池仍106，仅1个ASV触发组合改变；这表示对这组探索阈值的成员稳定性，不能称生物学独立复现或统计稳健性。

**分类关联：**传统功能支持限于参考类群文献，不等于项目功能基因/活性。分类不足、代码标签和未映射功能不表示无功能；Confidence也不等于功能概率。**潜在生态假设：**较高相对份额、同反应器多节点或多反应器检出可提示这些已观测背景下有持续出现的生态信号，值得继续定向分类与文献核对；不能说明低DO适应、温度选择、代谢竞争或功能冗余已被证实。

G4初始污泥/反应器/温度与来源历史混杂、纵向重复、不平衡采样及未知提取/PCR/测序子批次效应保留；跨反应器检出不是独立实验复现，29样本不是29个独立单位。相对丰度不等于绝对量，最大丰度/最大贡献及重复特征的得分权重可能偏重优势ASV；分数只用来安排审核。无可匹配实测出水、去除率或功能基因，不开展性能相关、DO/温度因果、功能确证、共现网络或显著性检验。

**下一阶段：**对8个对象使用真实代表序列开展定向MiDAS/参考谱系审核，记录所用版本/日期/指纹、区域/覆盖/identity、并列匹配、SILVA与参考体系差异，再核实对应物种/菌株原研究及禁止外推范围。C02/C09重点解决未定属，C04/C05重点解决分类置信，C10检验局部信号，N026/N045补文献证据，N072先解决代码谱系。当前这些工作尚未执行；短16S分类通过仍不构成功能确证。

**实际核验：**42 PASS / 4 WARNING / 0 FAIL，仅指本次描述性交付；独立标准库以整数交叉乘法核对相对丰度阈值、全部5510×33比例、规则/触发位置/节点/得分与原15字段，至少413250项，比例最大误差0。临时目录复现两TSV逐字节相同；已有目录与v1路径均在写入前非零拒绝。详细检查和来源见综合报告；三份项目文档同步，不用本解释代替程序断言。


<a id="module25-taxonomy-ecology-v2"></a>

## 模块2.5第一阶段：重点非传统候选分类核实与潜在生态证据（2026-11-08，V2）

**问题与方法。** 以模块2.4当前有效候选优先表固定8个目标，C01/C03另作GAO关联对照；没有新增项目候选。只读提取现有FASTA真实序列并与原rep-seqs.qza及模块2.2已有审核逐项核对，保留原SILVA完整Taxon/Confidence。实际获取MiDAS5.3全库111037条，完整SHA256锁定；BLAST2.17.0+执行合理覆盖的短片段比对，记录所有最高identity并列及0.5/1个百分点邻近谱系。六条培养株16S、三个背景基因组及两个近缘Vicinibacter MAG定向比对；文献按实际可访问原文/摘要/图表核实，不作功能预测或统计检验。

**产物。** [综合报告](../../results/candidate_ecology/2026-11-08_v2/analysis_report.md)、[分类核实表](../../results/candidate_ecology/2026-11-08_v2/candidate_taxonomy_validation.tsv)10行、[参考基因组表](../../results/candidate_ecology/2026-11-08_v2/candidate_reference_genomes.tsv)14行、[文献证据](../../results/candidate_ecology/2026-11-08_v2/candidate_literature_evidence.tsv)34行、[生态角色表](../../results/candidate_ecology/2026-11-08_v2/candidate_ecological_roles.tsv)10行、run.log及3份压缩参考证据，共9文件；[脚本](../../scripts/candidate_ecology_validation_v2.py)记录参数/断言/指纹并拒绝已有目录。21643条MiDAS匹配及定向参考合计21793条HSP均保留并逐碱基核验。实际查询长404–429bp，不是全长16S，精确通用引物坐标仍未独立核定。

### 已核实的分类事实

| 对象 | 实际MiDAS匹配 | 保守解释 |
|---|---|---|
| C02 | 全片段100%，AKYH767/midas_g_9646 | 获可回查代码定位；跨体系保守命名到Sphingobacteriales目，非已命名属，功能未知。 |
| C04 | 全片段100%，Microscillaceae/midas_g_85782 | 原Chryseotalea标签不独立成立；对Ys仅91.726%，不可套用其生理。 |
| C05 | 98.762%，9条Blastocatella最佳并列；近1个百分点含Aridibacter | 保守Blastocatellaceae科；对两Aridibacter株均98.020%，不定种、不赋硝酸盐呼吸。 |
| C10 | 93.617%，多个Microscillaceae代码属 | 原Chryseosolibacter命名属未确认，对PWU4/PWU20仅88.416/90.566%。 |
| C09 | 7条全片段100%，跨Rhodobacter/Tabrizicola | 不能选唯一属；原Paracoccaceae与MiDAS Rhodobacteraceae科名按版本并列，保守到目。 |
| N026 | 97.037%，SBR1031/Flexifilaceae/midas_g_29983近邻 | 对ZRK33仅79.506%，不支持原Phototrophicus的光营养或固碳角色。 |
| N045 | 全片段100%，SJA-28/midas_g_171 | 对Ch128a仅84.906%，不转移Tepidaquicella蛋白/亚硝酸盐预测。 |
| N072 | 6条全片段100%，Ca_Vicinibacter/midas_s_177 | 可作该参考谱系关联；两个参考种片段相同，种/菌株未定。 |

C01为Ca_Competibacter相关对照（MiDAS最佳100%），C03为Defluviicoccus相关对照（99.257%）；不由命中种标签赋具体反硝化功能或cluster身份。原taxonomy和功能注释均未回写；本次附加分类意见不代表上游重注释完成。

### 参考研究、代谢潜力与生态解释

文献采用五层证据：本ASV真实组成、参考谱系、特定参考MAG、远缘背景、无可靠功能证据。所有15篇定向原研究/勘误的真实题名、DOI及实际核实范围在证据表/报告。C02同MiDAS代码在工业污水原图出现；N026近邻代码与N045代码有污水/活性污泥原研究记录，但不据此把它们指定为水解、产EPS或氮转化菌。C04/C05/C10的培养论文可追溯，但参考株身份/亲缘不足，维持功能未知。

**N072是本阶段唯一获得近缘参考代谢潜力支持的重点对象。** 本研究424bp片段与GCA_016714365.1（EsbW_18-Q3-R4-48_MAXAC.074，Ca_Vicinibacter affinis）和GCA_016713905.1（Fred_18-Q3-R57-64_BAT3C.331，Ca_Vicinibacter proximus）各两份16S拷贝全片段100%相同。基因组是丹麦污泥参考MAG，不是本研究基因组，短片段不能区分两个参考种。仅在这个近缘门控后审阅Kondrotaite等2022原文Fig5两MAG列（DOI 10.3389/fmicb.2022.917553）：参考phaABC、nosZ及底物利用相关标注；缺少narGHI和glgB/glgC，不能称完整反硝化或典型GAO。参考原位细胞的PHA与絮体/附着观察可提供有限生态背景，不能证明本ASV具备这些基因、产生EPS或发挥相同活性。不能套用旧OLB8其他分支的糖原结论。

原补充S9的type-MAG格与MAG/SAG accession格不一致，已用实际NCBI assembly/isolate及正文核对并保留歧义；不靠错误格定种。ZRK33原文基因组CP051151已由勘误10.1128/mbio.00657-22改为CP062983，已采用更正编号。原L04摘要与正文对参考株采样地亦有不一致，只作未裁定的来源限制，不回写本研究设计。

### 可支持的假设及未知边界

后续在固定10对象范围内，N072可优先作为**潜在异养/PHA及絮体附着相关辅助类群**；这只是参考谱系启发的共同演替假设。C02、C04、C05、C10、C09、N026、N045均保留功能未知，可作组成生态伴随对象，不能按预期功能分组。C01/C03保留GAO关联对照。未计算这些对象的共同演替关系、交叉营养或共现网络，不强行形成碳—氮—EPS机制路径。

当前支持组成生态学及N072参考谱系潜力，不能说明处理贡献、独立相互作用、低DO适应、温度选择或性能稳态。33样本8/2/4/15/4保持；四G4不同起始污泥、纵向重复、不平衡节点、混合保存恢复及温度/反应器混杂仍在，提取/PCR/测序子批次效应未分离。统一人工进水是名义配方，无可靠同期出水/去除率/本项目功能基因；相对丰度不等于绝对菌量。

**实际核验。** 正式流程90 PASS / 4 WARNING / 0 FAIL，仅指交付必要条件；基因组门控未过的7目标停止代谢外推，所有物种/菌株和本项目机制均未直接验证。报告列明未核实全文、数据库动态知识卡、全长树及精确引物坐标；这些NOT_VERIFIED不能当作否定功能的证据。原始输入、原metadata/分类/对象及模块1.1–2.4既有v2保持不变，未重跑上游。


<a id="module26-focal-asv-cosuccession-v2"></a>

## 模块2.6：重点候选ASV共同演替及生态证据综合（2026-11-09，V2）

**问题与方法。** 固定8个非传统/功能未知对象C02/C04/C05/C10/C09/N026/N045/N072，C01/C03为GAO关联对照。A=R1/R2的C01/C02/C10/C09/N072；B=R3的C03/C04/C05/N026/N045/N072；C=R2/R4的C01/C03/N026/N045/N072。直接提取模块2.4有效v2的33样本原比例，并与模块2.1的150个目标G4观测及原count核对；复用2.1已有贡献/差额及距离，不重算上游、taxonomy、功能映射、Alpha/Beta、筛选或MiDAS。比例分母为样本全部ASV reads，不按10对象重新闭合。

**实际产物。** [中文综合报告](../../results/focal_asv_cosuccession/2026-11-09_v2/analysis_report.md)、[观测及比较TSV](../../results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_cosuccession.tsv)415×64（330个原观测、47个原贡献比较、25个原Δc、13个预定比值位置，record_type分列）、[生态证据综合TSV](../../results/focal_asv_cosuccession/2026-11-09_v2/ecological_evidence_synthesis.tsv)16×31（A/B/C各5/6/5条）、[PDF](../../results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_trajectory_comparison.pdf) / [PNG](../../results/focal_asv_cosuccession/2026-11-09_v2/focal_asv_trajectory_comparison.png)及[run.log](../../results/focal_asv_cosuccession/2026-11-09_v2/run.log)。[单一复现脚本](../../scripts/focal_asv_cosuccession_v2.py)为Python标准库+现有R base graphics，无随机步骤。16个轨迹面板独立纵轴并列SILVA原标签与MiDAS审核；R1无30d点并在缺节点处断线，G4不与其他轮次拼接；G5单独列于表/报告。

### A：R1/R2分化的具体组成来源

76→145d，R2的C01（Ca_Competibacter谱系关联）从5.1454%至44.7053%，R1同ASV从0至0.0190%，两者差扩大Δc=+0.197705；R1的C02从9.4429%至28.1100%，R2从0.7810%至0.2029%，Δc=+0.096226。C02保守到Sphingobacteriales目/MiDAS AKYH767/midas_g_9646代码，不把Incertae_Sedis当已命名属或已知功能。

C10在R1从10.1683%至9.5842%，仍较高但两反应器差距略缩（Δc=−0.003553）；不能把所有R1候选都称为末段差扩大的来源。C09在R2从基线11.4601%持续降至末期0.1648%；N072在R1从4.5446%至0.0486%、R2从3.4598%至0.3550%，共同下降。固定五对象Δc净和+0.279806、其余ASV净和+0.017086，合为整体Bray净增+0.296892；94.25%仅是有符号数学分解，非生态机制解释率。

**能回答：**本批哪些相同ASV的比例差在实际末段扩大/缩小，以及不同组成轨迹并存。**不能回答：**C02/C10代谢能力、C01碳竞争或与它们的协作、温度或DO导致分化。跨Batch可核查C02相对C10增加及R2-C01增加是否重现，同时允许C09/N072下降；并非本批已外部验证。

### B：R3后期的持续高比例与内部替换并存

| ASV | 30d % | 76d % | 145d % | 描述性观察及证据边界 |
|---|---:|---:|---:|---|
| C03 | 14.0900 | 15.0196 | 13.1484 | 单ASV持续较高，末段下降；仅GAO关联对照，不用属总量替代。 |
| C04 | 0.1671 | 5.9966 | 11.9159 | 两段上升；MiDAS midas_g_85782代码，不转移原Chryseotalea株生理。 |
| C05 | 5.4720 | 6.0203 | 1.2175 | 末段下降；保守Blastocatellaceae科，具体功能UNKNOWN。 |
| N026 | 1.1190 | 2.2320 | 2.8964 | 后期两段上升；Anaerolineae/midas_g_29983近邻，不认定Phototrophicus光合。 |
| N045 | 1.1740 | 7.0370 | 8.2860 | 后期两段上升；SJA-28/midas_g_171代码，不赋Ch128a蛋白或氮代谢。 |
| N072 | 0.5672 | 2.5640 | 1.7803 | 先升后降；只引Vicinibacter近缘参考异养/PHA与附着背景。 |

30→76d/76→145d既有Bray为0.364409/0.219243，六对象贡献和0.081400/0.076452，分别占22.34%/34.87%；后段C04、C05贡献0.029597/0.024014，占后段Bray的13.50%/10.95%。C04/N045同向上升、C04/C05末段反向均是组成并列观察，不证明协作或竞争。后段Jaccard=0.682243，不能由较小Bray证明成员或性能稳态；两个区间46/69d也不作为同长度动态速率。跨Batch可核查C03高比例持续与C04/N045上升、C05末段下降是否共存，允许N072不同步；具体功能与互作仍不能回答。

### C：R2/R4趋近并非所有重点类群都趋同

末段整体Bray从0.804296降至0.435510。C01在R2从5.1454%增至44.7053%，R4从55.3957%降至38.9043%；同ASV差距50.2504→5.8011个百分点，Δc=−0.222247，占整体Bray净下降幅度60.26%（仅数学比值）。N072在R2/R4均下降，差距3.2948→0.2591个百分点，Δc=−0.015178；共同变低也可以使比例更接近。

相反，C03、N026、N045差扩大Δc分别+0.009598/+0.002219/+0.007457。固定五对象净Δc=−0.218151、其余ASV净和−0.150635，共同构成净Bray下降−0.368787；指定子集占净下降59.15%，不能当功能解释率。C01是A/C共有信号：R2的同一次重排同时关联与R1分化及与R4趋近，不是两次独立复现。跨Batch可核查C01差缩小是否仍为主要数学来源，同时保留N026/N045等差扩大；不能把室温标签或共同配方解释为独立环境因果、功能趋同或互作。

### 五层证据、比值与G5独立边界

五层证据逐单元×对象分列：本研究16S实际比例/既有贡献；模块2.5 MiDAS保守分类；已核实参考生理/基因组及核实范围；可提出的生态角色假设；禁止外推的机制。原SILVA Taxon/Confidence保留。C02/C04是代码定位，C05跨属近邻、C09有7条100%跨属并列、C10低于可确认属的亲缘支持，N026/N045原命名株生理不转移；七个对象具体功能全部UNKNOWN。

N072与两个Vicinibacter参考MAG的424bp片段匹配及原研究证据沿用模块2.5；原位PHA/附着和MAG潜力属于参考对象。模块2.6只用参考异养/PHA及附着生态背景，不能认定本ASV的PHA、EPS、反硝化活性、底物交换或互作；C01/C03仅GAO关联对照。未知不等于无功能；不新增无法完成的功能验证实验。

预先固定三种log-ratio：R1 76/145d C02/C10为−0.0740→+1.0760；R3 30/76/145d C04/C03为−4.4347→−0.9182→−0.0984；R2 N072/C01为−0.7874→+2.5845→−0.3969→−4.8357，R4为−7.1995→−7.3208→−5.8164→−6.0058。自然log，仅每预定序列各节点两ASV均≥5reads才报告，无伪计数/零值插补；否则全序列NA且不替换配对。R4最小8reads，单列WARNING，不能称稳健比值。比值消去总reads分母，不解决绝对量、拷贝/扩增偏倚、纵向依赖或因果。

G1/G2G3/G4保留轮次，G2/G3同轮连续，G4跨保存恢复另起时间轴。G5仍一母样四粒径级分，163d是原表推算，不作为四份独立重复或连到G4轨迹。C02在四级分7.38%–13.03%、C10为1.21%–4.97%；**N072在S1–S3为0reads、S4仅9reads（0.0201%）**。旧OLB8属总量中其他ASV的较高比例不能代替N072或证明其粒径富集/附着、PHA、EPS。

**局限及尚未开展。** 33行8/2/4/15/4不是独立重复；G4四份起始污泥各异，混合均分、4℃59d保存恢复与纵向依赖持续。R1/R3=30℃与R2/R4室温未知同个体/起始/历史混杂，不能识别温度或DO独立效应。统一名义进水不是同期实测出水、去除率或可估计水质协变量；采样瞬时DO/温度NA、运行稳态无性能证明。提取/PCR/测序子批次及组成偏倚未分离。未做全群落两两相关、网络、PERMANOVA、互作机制或功能确证；跨Batch核查只是固定组成假设，尚未实施外部验证。

**实际核验。** 主流程69 PASS / 5 WARNING / 0 FAIL，仅描述性交付；独立以Fraction/整数count核对700个比例、贡献、差额和自然log比值，415条记录及16个证据条目通过。临时复现两TSV及PNG逐字节相同，已有目录与v1输出均非零拒绝。图件逐块CRC/解压及PDF头尾通过，正式PNG已实际打开检查。原metadata、taxonomy、FASTA、RDS与210个受保护基线文件SHA256不变；三份总文档合法同步，旧日志前缀及历史科研正文保留。

### 2026-11-09 文档导航与空目录维护

项目总README末尾新增[文档、文件夹与功能对应表](../../README.md#project-file-directory-guide)，按实际文件说明原始输入、原metadata、派生metadata、脚本、当前v2及历史结果的用途。清理范围仅为3个空的结果目录（alpha_diversity、beta_diversity、figures），具体操作与核验见[执行日志](analysis_log.md)。已有多样性表和图件仍在有效模块目录中。本次为目录与文档维护，未新增科研分析、生态解释或统计结论；既有发现、未知条件与待验证假设保持。
