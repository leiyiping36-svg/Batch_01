# G4实验条件差异审核与补充（模块2.1，2026-11-05）

本记录先于正式实验设计文档追加和ASV贡献计算建立。依据：用户2026-11-05本次“模块2.1——G4实验条件补充”指令第二区七项明确确认；属于用户确认记录，尚无外部实验原始登记表附件，不等于独立验证。原设计全文与既有结果保留。

| 条件 | 现有设计/群落v2派生metadata | 本次确认与处理 |
|---|---|---|
| G4起始污泥 | 记录E1←A2、F1←B3、G1←C2、H1←D3及絮状/颗粒设计类型，未声称四份相同；没有具体G4起始编号和实测性状 | 四份初始污泥性状与初始菌群均不同；记录different_per_reactor_user_confirmed。不同起始状态不等于独立谱系。具体编号、性状定量值NA，不能把ASV样本号当污泥原始编号 |
| G4温度运行条件 | 没有temperature字段或30℃/室温设置记录；4℃仅为历史保存条件 | R1/R3恒温30℃，R2/R4室温；恒温目标30，室温目标NA。所有采样实测温度NA。温度只覆盖本次确认G4运行阶段，不追溯填G1/G2/G3/G5，也不反推低DO切换前恢复时刻温度 |
| 后期DO | 已确认0.5±0.2 mg/L，11个适应期后样本 | 一致，保持设置及上下界，不写作实测均值/SD |
| day1基线 | 正式设计已记录恢复结束、低DO切换前，恢复设置3；旧群落v2派生分析设置NA，design_document列3 | 取样位置一致。本次用户未新增基线DO数值，仅在新字段G4_baseline_recovery_DO_setpoint_mg_L记3并引用2026-11-03设计；旧分析DO列完整保留，差异不静默消除 |
| 初始样本对应反应器 | E1/F1/原样本G1/H1对应R1/R2/R3/R4 | 一致，不变更样本/模块 |
| 历史依赖 | G1后R1/R2和R3/R4分别混合均分，G4前4℃59d保存恢复 | 完整保留，用G4_inherited_pool_id连接前源来源块，不构造新的混合操作 |
| 五模块及对象 | 33样本，8/2/4/15/4；已有RDS和有效v2 | 全部沿用，本次仅新派生metadata，不更新RDS或原metadata |

## 字段边界与待补信息

新增temperature_regime、temperature_setpoint_C、temperature_measured_C、temperature_data_source、temperature_assignment_scope、G4_initial_sludge_id、G4_initial_sludge_characteristics、G4_initial_sludge_distinctness、G4_initial_sample_id、G4_pre_storage_source_sample_id、G4_inherited_pool_id及保存/来源字段。G4_initial_sludge_characteristics为NA；“性状均不同”单列定性确认，不能把既往絮状/颗粒设计类型冒作本次具体起始性状。G4_initial_sludge_id与temperature_measured_C全NA；非G4温度字段NA。G4温度是用户确认运行条件标签，基线实测/恢复期温度未确认。

待人工补充：四份起始污泥的实验登记编号、性状具体记录及测定方法/时间、室温实测序列、恢复期和基线时刻温度适用范围、运行性能稳态证据。采样瞬时DO无现成数值，保持NA。缺口不阻断描述性ASV贡献。

## 已确定执行计划与展示规则

只分析用户指定10对：F1/H1、F2/H2、F3/H3、F4/H4；E1/F1、E2/F3、E3/F4；G2/G3、G3/G4；F3/F4。全5510 ASV原count除以样本全部reads，不过滤不改taxonomy。每ASV Bray贡献=|pA−pB|/2；按属累计贡献和先聚合属后求差分列。相邻同期距离的变化=后时刻贡献−前时刻贡献，正值扩大、负值缩小。保留各反应器有符号丰度变化，避免把距离下降解读为任一固定方向。

预先固定Top N=10；并列按完整ASV ID字典序；共同高丰度=两端均≥1%；反应器内明显升降=绝对变化≥1个百分点，仅是描述阈值。三目标属内主要ASV=每属G4等记录均值Top5（基线/后期均值另列、不当重复均值）。全量分解和轨迹均保留，不按预期结论调整阈值。复用模块1.3全部所需距离/敏感性，不重跑Alpha/Beta或功能映射，无显著性/因果模型。

正式设计后续仅追加2026-11-05有效补充；本审核先存的原设计及派生metadata SHA-256如下。

- 原experiment_design.md：`9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9`
- 群落v2 metadata：`f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd`


## 2026-11-05 执行状态追加

审核先行后已在experiment_design.md追加2026-11-05有效设计节；新增analysis_metadata_addendum.tsv为33行63列，旧45列逐值保留。主流程22 PASS/2 WARNING/0 FAIL，独立复核全部ASV及历史保护通过。原metadata、RDS和三个有效v2均未修改。最终文件和待补科研问题见analysis_report.md。


## 2026-11-05 用户要求统一v2名称

本审核随模块2.1目录迁移至results/asv_contributions/2026-11-05_v2。原审核时间、实验条件、旧输入指纹及差异结论保留；派生metadata的temperature_data_source与G4_initial_sludge_data_source指向本新路径，module21_metadata_version统一module2.1_2026-11-05_v2。仅63个来源/版本文本单元格更新，全部原45列及数值列不变。v1不作当前入口，未新增实验事实或重新计算。
