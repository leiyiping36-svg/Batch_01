# Batch_01 阶段 1 综合质量报告

## 运行：2026-11-02 19:37:31 CST

- 项目目录：`/home/leiyiping/Batch_01`
- 开始/结束（Asia/Shanghai）：2026-11-02 19:37:31 / 2026-11-02 19:37:35
- 用时：4.245 秒；退出码：2。
- 阶段 1 状态：FAIL；未生成 RDS。
- 固定参数：样本数=33；五组字段=group；预期组数=5；异常标记=Tukey 1.5×IQR；无过滤、无稀释、无归一化、无统计检验。
- 门控：input/runtime/design/object 的 FAIL 阻断 RDS；inference 检查仅控制后续统计适用性。WARNING 不删除、不自动修正数据。
- taxonomy 只按显式d__/k__/p__/c__/o__/f__/g__/s__前缀解析阶元，缺失为NA；完整原始Taxon、Confidence及其他字段保存在对象stage1_taxonomy属性。
- 相对丰度不代表绝对丰度；16S分类不代表功能基因或活性。

### 实际检查

| 状态 | 门控范围 | 检查 | 实际依据 |
|---|---|---|---|
| PASS | runtime | 依赖：phyloseq | 1.54.0 |
| PASS | runtime | 依赖：Biostrings | 2.78.0 |
| PASS | runtime | 依赖：biomformat | 1.38.0 |
| PASS | runtime | 依赖：digest | 0.6.39 |
| PASS | input | 输入文件存在 | 必需输入=8；缺失或非文件：无 |
| PASS | input | 输入 SHA-256 已计算 | 8 个文件；详见输入清单。 |
| PASS | input | asv_table.tsv行列结构 | 表头及数据行=5511；不等宽行=0 |
| PASS | input | asv_table.tsv列名唯一且非空 | ID数=34；缺失=0；重复=0；首尾空白=0 |
| PASS | input | ASV 表首列 | 实际首列=#OTU ID |
| PASS | input | ASV Feature ID唯一且非空 | ID数=5510；缺失=0；重复=0；首尾空白=0 |
| PASS | input | Batch_01 样本数 | 实际=33；预期=33 |
| PASS | input | 原始计数数值合法 | 单元格=181830；缺失/非数值/非有限/负值/非整数/超过R整数范围=0；未舍入、过滤或变换。 |
| PASS | input | ASV 矩阵方向 | ASV为行=5510；样本为列=33 |
| PASS | input | 无空样本 | 零深度样本：无 |
| PASS | input | 测序深度异常筛查 | 总reads=1364804；min=31457；Q1=36956.0；median=42004；Q3=44760.0；max=53307；Tukey 1.5×IQR界限=[25250.0, 56466.0]；异常=无；仅标记，不过滤。 |
| PASS | input | 全零 ASV | 全零特征=0；保留原始数据。 |
| PASS | input | taxonomy.tsv行列结构 | 表头及数据行=5511；不等宽行=0 |
| PASS | input | taxonomy.tsv列名唯一且非空 | ID数=3；缺失=0；重复=0；首尾空白=0 |
| PASS | input | taxonomy 字段 | 实际字段：Feature ID, Taxon, Confidence |
| PASS | input | taxonomy Feature ID唯一且非空 | ID数=5510；缺失=0；重复=0；首尾空白=0 |
| PASS | input | 分类置信度范围 | 非缺失且无法解析或超出[0,1]=0 |
| PASS | input | 保留原始分类注释 | Taxon缺失=0；Confidence缺失=0；不填补未知分类。 |
| PASS | input | 分类阶元显式解析 | 分别保留d__/k__，未知阶元为NA；各阶元非缺失数：Domain=5510；Kingdom=5260；Phylum=4927；Class=4763；Order=4437；Family=4224；Genus=3664；Species=0；完整原始注释与Confidence随对象保留。 |
| PASS | input | FASTA 结构 | 文本行数=11020；首行为标题且无空行。 |
| PASS | input | FASTA Feature ID（完整标题）唯一且非空 | ID数=5510；缺失=0；重复=0；首尾空白=0 |
| PASS | input | FASTA 标题无隐式截断 | 使用完整标题匹配，不截断或自动改名。 |
| PASS | input | DNA 序列字符 | 仅接受IUPAC DNA字符；未删除非法字符。 |
| PASS | input | FASTA 实际解析 | 序列=5510；长度min=333、max=453；无空序列。 |
| PASS | input | source_sample_metadata.tsv行列结构 | 表头及数据行=34；不等宽行=0 |
| PASS | input | source_sample_metadata.tsv列名唯一且非空 | ID数=14；缺失=0；重复=0；首尾空白=0 |
| PASS | input | metadata ID 字段 | 实际字段：sample-id, supplier_sample_id, reactor_id, batch_id, sample_type, operation_phase, timepoint, sample_order, phase_days, phase_day_basis, particle_size_fraction_um, biological_replicate, metadata_review_notes, directory_group |
| PASS | input | metadata 样本 ID唯一且非空 | ID数=33；缺失=0；重复=0；首尾空白=0 |
| PASS | input | metadata 样本数 | 实际=33；预期=33 |
| WARNING | input | metadata 缺失值盘点 | sample-id=0；supplier_sample_id=0；reactor_id=0；batch_id=0；sample_type=0；operation_phase=0；timepoint=0；sample_order=33；phase_days=0；phase_day_basis=0；particle_size_fraction_um=29；biological_replicate=33；metadata_review_notes=29；directory_group=0；NA保持不变。 |
| PASS | input | table_qza数据成员 | 匹配成员数=1 |
| PASS | input | table_qza与导出文件逐字节对应 | Artifact数据SHA-256=331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905；导出SHA-256=331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905 |
| PASS | input | sequences_qza数据成员 | 匹配成员数=1 |
| PASS | input | sequences_qza与导出文件逐字节对应 | Artifact数据SHA-256=a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b；导出SHA-256=a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| PASS | input | taxonomy_qza数据成员 | 匹配成员数=1 |
| PASS | input | taxonomy_qza与导出文件逐字节对应 | Artifact数据SHA-256=b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867；导出SHA-256=b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| PASS | input | BIOM Feature ID唯一且非空 | ID数=5510；缺失=0；重复=0；首尾空白=0 |
| PASS | input | BIOM 样本 ID唯一且非空 | ID数=33；缺失=0；重复=0；首尾空白=0 |
| PASS | input | ASV 与 BIOM Feature ID | 仅左侧：无；仅右侧：无 |
| PASS | input | ASV 与 BIOM 样本 ID | 仅左侧：无；仅右侧：无 |
| PASS | input | TSV 与 Artifact 原始计数一致 | 逐单元格比对=181830；不稀释、不归一化。 |
| PASS | input | ASV 与 taxonomy Feature ID | 仅左侧：无；仅右侧：无 |
| PASS | input | ASV 与 FASTA Feature ID | 仅左侧：无；仅右侧：无 |
| PASS | input | ASV 与 metadata 样本 ID | 仅左侧：无；仅右侧：无 |
| PASS | design | 科研设计字段：reactor_id | 非缺失=33/33 |
| PASS | design | 科研设计字段：operation_phase | 非缺失=33/33 |
| PASS | design | 科研设计字段：phase_days | 非缺失=33/33 |
| PASS | design | 科研设计字段：phase_day_basis | 非缺失=33/33 |
| PASS | design | 科研设计字段：timepoint | 非缺失=33/33 |
| FAIL | design | 五组权威映射 | metadata不存在group字段；不从operation_phase、directory_group或样本名称推断。 |
| FAIL | design | 原始记录来源：group_source或metadata_source | 有来源指向的样本=0/33；缺少来源：Batch_01_A0, Batch_01_A1, Batch_01_A2, Batch_01_E1, Batch_01_E2, Batch_01_E3, Batch_01_S1, Batch_01_S2, Batch_01_S3, Batch_01_S4, Batch_01_B0, Batch_01_B1, Batch_01_B2, Batch_01_B3, Batch_01_F1, Batch_01_F2, Batch_01_F3, Batch_01_F4, Batch_01_C0, Batch_01_C1, Batch_01_C2, Batch_01_G1, Batch_01_G2, Batch_01_G3, Batch_01_G4, Batch_01_D0, Batch_01_D1, Batch_01_D2, Batch_01_D3, Batch_01_H1, Batch_01_H2, Batch_01_H3, Batch_01_H4；来源字段是可追溯的必要条件，真实性仍需原始记录审阅。 |
| FAIL | design | 原始记录来源：metadata_source或condition_source | 有来源指向的样本=0/33；缺少来源：Batch_01_A0, Batch_01_A1, Batch_01_A2, Batch_01_E1, Batch_01_E2, Batch_01_E3, Batch_01_S1, Batch_01_S2, Batch_01_S3, Batch_01_S4, Batch_01_B0, Batch_01_B1, Batch_01_B2, Batch_01_B3, Batch_01_F1, Batch_01_F2, Batch_01_F3, Batch_01_F4, Batch_01_C0, Batch_01_C1, Batch_01_C2, Batch_01_G1, Batch_01_G2, Batch_01_G3, Batch_01_G4, Batch_01_D0, Batch_01_D1, Batch_01_D2, Batch_01_D3, Batch_01_H1, Batch_01_H2, Batch_01_H3, Batch_01_H4；来源字段是可追溯的必要条件，真实性仍需原始记录审阅。 |
| WARNING | design | 运行阶段与实验分组分别记录 | do_3=4；do_5=2；low_cn_end=4；low_cn_startup=4；low_do_long_term=15；low_do_size_fractionation=4 |
| WARNING | inference | 同一反应器重复采样 | Reactor_01=10；Reactor_02=8；Reactor_03=7；Reactor_04=8；不能默认各行独立。 |
| PASS | design | 目录分组与反应器记录相符 | 不一致样本：无 |
| PASS | design | 采样日数值可解析 | 缺失或无法解析：无 |
| WARNING | inference | 同反应器/时间依据/采样日重复记录 | 涉及：Batch_01_S1, Batch_01_S2, Batch_01_S3, Batch_01_S4；粒径分级或技术重复不能作为独立反应器重复。 |
| WARNING | inference | 时间坐标依据 | 不同说明=4；低C/N第一阶段接种日为第1天；启动结束日编号沿用用户填写120（文献约120 d）；R1/R2、R3/R4分别混合后均分，低C/N运行并设DO=5 mg/L为第0天；DO=5为0–21 d，DO=3为23–56 d；共用此时间坐标；DO=3阶段结束污泥经4℃封存59 d后，在原条件恢复活力；恢复后污泥接种启动低DO为第1天；DO=3阶段结束污泥经4℃封存59 d后，在原条件恢复活力；恢复后污泥接种启动低DO为第1天；持续运行至第145天后18天采样，第163天由145+18推算；未构造统一连续时间轴。 |
| WARNING | inference | 共享接种/混合来源 | 涉及样本：Batch_01_A2, Batch_01_B2, Batch_01_B3, Batch_01_C2, Batch_01_D2, Batch_01_D3；需原始来源及谱系核验，不能据反应器标签推断独立性。 |
| WARNING | design | 证据完整性：biological_replicate | 非缺失=0/33；内容真实性仍需原始记录核验。 |
| WARNING | design | 证据完整性：metadata_source | 字段不存在；不生成或填补。 |
| WARNING | design | 证据完整性：group_source | 字段不存在；不生成或填补。 |
| WARNING | design | 证据完整性：DO_mg_L | 字段不存在；不生成或填补。 |
| WARNING | design | 证据完整性：DO_status | 字段不存在；不生成或填补。 |
| WARNING | design | 待确认采样条件 | Batch_01_E1: 低DO第1天标为DO=3，但是否为恢复条件或取样时DO待确认；暂不填DO字段；Batch_01_F1: 低DO第1天标为DO=3，但是否为恢复条件或取样时DO待确认；暂不填DO字段；Batch_01_G1: 低DO第1天标为DO=3，但是否为恢复条件或取样时DO待确认；暂不填DO字段；Batch_01_H1: 低DO第1天标为DO=3，但是否为恢复条件或取样时DO待确认；暂不填DO字段；不把设定值或恢复条件当作采样实测值。 |
| WARNING | inference | 统计分析门控关闭 | 本阶段不运行统计检验。五组定义及来源、独立实验单位、混合/分样谱系、重复类型、时间起点、组内独立样本量和组别/反应器/阶段混杂尚需针对具体方法验证；记录存在不等于真实性已确认。 |
| WARNING | object | 对象保存被门控阻断 | 存在输入/运行环境/阶段1必需设计检查FAIL；已完成可独立进行的基础核查。已有RDS（若存在）保持不变，不代表适用于当前输入。 |

### 每样本测序深度

| 样本 ID | reads |
|---|---:|
| Batch_01_A0 | 38340 |
| Batch_01_A1 | 36611 |
| Batch_01_A2 | 33074 |
| Batch_01_B0 | 33436 |
| Batch_01_B1 | 32430 |
| Batch_01_B2 | 44563 |
| Batch_01_B3 | 37840 |
| Batch_01_C0 | 40535 |
| Batch_01_C1 | 47303 |
| Batch_01_C2 | 49428 |
| Batch_01_D0 | 43792 |
| Batch_01_D1 | 41174 |
| Batch_01_D2 | 36956 |
| Batch_01_D3 | 35304 |
| Batch_01_E1 | 42281 |
| Batch_01_E2 | 50874 |
| Batch_01_E3 | 47307 |
| Batch_01_F1 | 31457 |
| Batch_01_F2 | 42004 |
| Batch_01_F3 | 42893 |
| Batch_01_F4 | 47321 |
| Batch_01_G1 | 46081 |
| Batch_01_G2 | 45486 |
| Batch_01_G3 | 33736 |
| Batch_01_G4 | 53307 |
| Batch_01_H1 | 39799 |
| Batch_01_H2 | 40046 |
| Batch_01_H3 | 43034 |
| Batch_01_H4 | 36505 |
| Batch_01_S1 | 43146 |
| Batch_01_S2 | 43812 |
| Batch_01_S3 | 40169 |
| Batch_01_S4 | 44760 |

### 输入清单及可复现性

| 输入 | 字节数 | SHA-256 |
|---|---:|---|
| data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| data/exported_table/feature-table.biom | 387981 | 331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905 |
| input/qiime2/table.qza | 250475 | aa1a6bac46ebccce26827d71433d85b09b01254ea694eb53c86fd7c7344ba1ce |
| input/qiime2/rep-seqs.qza | 549940 | 9266608e6381cdffa1bf582d798902cd6121c4b04c1e0b8d3c353fac8880d20e |
| input/qiime2/taxonomy.qza | 418386 | 76e0fe74f88e1448804dd6565551650e5fa0b62fd4393d72bc85c6c5e1621604 |

- 脚本：`/home/leiyiping/Batch_01/scripts/stage1_pipeline.R`；SHA-256：ae4202ebc121fe9afa9ea59bfb57179f8083aa5e0f125154de8b97a892dc72f4
- 复现命令：`Rscript --vanilla scripts/stage1_pipeline.R --project-root '/home/leiyiping/Batch_01'`。
- 重跑在本报告追加完整记录；已有对象仅在输入指纹及全部内容相同后复用。

### 工具版本

```text
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

loaded via a namespace (and not attached):
 [1] generics_0.1.4      stringi_1.8.7       lattice_0.22-9     
 [4] digest_0.6.39       magrittr_2.0.5      grid_4.5.2         
 [7] RColorBrewer_1.1-3  iterators_1.0.14    foreach_1.5.2      
[10] plyr_1.8.9          jsonlite_2.0.0      Matrix_1.7-5       
[13] ape_5.8-1           survival_3.8-9      mgcv_1.9-4         
[16] scales_1.4.0        permute_0.9-10      Biostrings_2.78.0  
[19] codetools_0.2-20    ade4_1.7-24         cli_3.6.6          
[22] rlang_1.3.0         crayon_1.5.3        XVector_0.50.0     
[25] Biobase_2.70.0      splines_4.5.2       vegan_2.7-3        
[28] tools_4.5.2         parallel_4.5.2      reshape2_1.4.5     
[31] phyloseq_1.54.0     dplyr_1.2.1         Rhdf5lib_1.32.0    
[34] ggplot2_4.0.3       multtest_2.66.0     BiocGenerics_0.56.0
[37] vctrs_0.7.3         R6_2.6.1            stats4_4.5.2       
[40] lifecycle_1.0.5     rhdf5_2.54.1        Seqinfo_1.0.0      
[43] stringr_1.6.0       biomformat_1.38.0   S4Vectors_0.48.0   
[46] IRanges_2.44.0      MASS_7.3-66         cluster_2.1.8.2    
[49] pkgconfig_2.0.3     pillar_1.11.1       gtable_0.3.6       
[52] glue_1.8.1          data.table_1.18.4   Rcpp_1.1.2         
[55] tibble_3.3.1        tidyselect_1.2.1    rhdf5filters_1.22.0
[58] farver_2.1.2        igraph_2.3.3        nlme_3.1-170       
[61] compiler_4.5.2      S7_0.2.2           
```

实现参考：[Bioconductor phyloseq 官方文档](https://www.bioconductor.org/packages/devel/bioc/vignettes/phyloseq/inst/doc/phyloseq-basics.html)。


## 记录补充：2026-11-02 19:50:49（Asia/Shanghai；仅 metadata/文档梳理）

本次按用户最新说明执行：五组准确映射尚未最终确认，不创建分组、不修改 metadata；不重新运行 ASV、taxonomy、rep-seqs 或测序深度检查，不构建 phyloseq，不作组间推断统计。上文原始检查记录及其 54 PASS / 14 WARNING / 3 FAIL 原样保留，本节不作为一次新的全流程 QC。

### 证据状态与当前门控

- **已确认**：仅限用户明确说明和 experiment_design.md 中标为既往讨论已确认的线索；标注具体来源，不扩大到未列出的样本或实验条件。
- **待确认**：metadata 已填的样本—反应器、阶段、相对采样日等记录可被逐行引用，但尚未回查原始实验记录；文字一致或字段非空不代表科学真实性已核验。
- **未知**：现有记录没有具体值或用户明确尚未最终确定的信息，保持 NA；未知不等于 0，也不据名称、阶段或前序条件填补。

| 状态 | 本次工作/门控 | 实际依据 |
|---|---|---|
| PASS | 沿用既有基础 QC | 已定位上文四项 PASS：整数计数、ASV-taxonomy ID、ASV-FASTA ID、深度异常筛查；本次不读取 ASV/FASTA/BIOM/QZA，不重复计算。 |
| PASS | 逐样本记录梳理 | metadata 实际读取 33 行；33 条样本记录全部进入下表，保留原 sample-id、supplier_sample_id 与原表行顺序。 |
| PASS | 现有技术日志衔接 | taxonomy inputs.json 的 sample_ids 与 metadata 样本集合相同；仅核对记录编号，不重复验证丰度或注释。 |
| WARNING | 科研来源状态 | 上文两个来源字段 FAIL 指指定来源列缺失，并不表示项目内毫无可用记录。本节已定位设计文档、metadata 自带时间依据及技术日志；原始记录出处仍未完整串联，不回写占位来源或修改既往判定。 |
| WARNING | 上游编号映射 | sample-id-update.json 指向 `/home/leiyiping/vscode-qiime2-/metadata/sample_id_mapping.tsv`；当前文件不存在，无法在此环境回查该表；日志内声明不能代替原表审阅。 |
| FAIL | 五组对象及组间推断门控 | 用户最新确认：五组准确映射尚未最终确认；metadata 无 group，六类 operation_phase 不等于五组。相关对象与推断继续暂停，不影响本次记录整理。 |

### 设计文档中已有的信息

设计文档没有列出完整 33 行样本表；以下为直接提取的已确认线索，33 条逐样本详情来自现有 metadata，未根据样本命名重建实验设计。

- 目标分析包含 **33 个样本、5 组设计**。这只是已确认的总量/组数，完整样本 ID → 组别表尚未导入本文件。（[D:4](../../docs/batch_01/experiment_design.md#L4)；已确认限既往讨论/文档层级，不等于原始记录独立复核。）
- R1、R2 在实验开始时**未加入颗粒污泥**；只有 R3、R4 在初始时加入颗粒污泥。具体接种比例和时间以原始实验记录为准。（[D:5](../../docs/batch_01/experiment_design.md#L5)；已确认限既往讨论/文档层级，不等于原始记录独立复核。）
- 一组低 DO 实验涉及 E1/F1/G1/H1，来源分别与 A2/B3/C2/D3 对应的 DO=3 mg/L 污泥有关；曾在 4°C 保存 59 天，恢复活性后进入新的实验。（[D:6](../../docs/batch_01/experiment_design.md#L6)；已确认限既往讨论/文档层级，不等于原始记录独立复核。）
- 新低 DO 实验第 1–24 天为 DO 调试/适应期；第 1 天采样的 DO 不确定，**不得标作 3 mg/L**。第 25–145 天的完整各反应器 DO 设定、节点信息，必须回查原始记录后填入。（[D:7](../../docs/batch_01/experiment_design.md#L7)；已确认限既往讨论/文档层级，不等于原始记录独立复核。）

R1–R4（设计文档称谓）与 Reactor_01–04（metadata 称谓）的精确对应及混合前后实体连续性尚未由原始记录核验；本节不据数字相同向样本回填接种类型。

### 33 个样本的现有记录（报告视图，不是修订版 metadata）

原始列名 operation_phase 与 timepoint 均保留其记录意义；日数是 phase_days，绝非统一连续运行日或日历日期。DO 列中的数字仅转述 timepoint 明写的设定值，所有采样实测 DO 均为 NA，未写入 metadata。前源仅列设计文档逐一指明的四对关系，其他样本前源未推断。

| sample-id | 原样本号 | reactor_id（原表） | timepoint（原表） | phase_days / 时间依据 | operation_phase（原表） | DO现有情况（mg/L） | 粒径分级（μm） | 文档指定前源 | 证据状态与定位 |
|---|---|---|---|---|---|---|---|---|---|
| Batch_01_A0 | A0 | Reactor_01 | 低C/N启动开始，第1天 | 1 / T1 | low_cn_startup | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:2](../../metadata/source_sample_metadata.tsv#L2) |
| Batch_01_A1 | A1 | Reactor_01 | 低C/N启动结束，约第120天 | 120（约） / T1 | low_cn_end | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:3](../../metadata/source_sample_metadata.tsv#L3) |
| Batch_01_A2 | A2 | Reactor_01 | DO设定3 mg/L阶段结束，共用时间坐标第56天 | 56 / T2 | do_3 | 实测NA；记录设定3 | NA | NA | 已记录待确认；[M:4](../../metadata/source_sample_metadata.tsv#L4) |
| Batch_01_E1 | E1 | Reactor_01 | 低DO第1天（储存后恢复活力并接种启动） | 1 / T3 | low_do_long_term | 实测NA；第1天DO待确认 | NA | A2 | 前源：已确认文档线索；其余待确认；[M:5](../../metadata/source_sample_metadata.tsv#L5)、[D:6](../../docs/batch_01/experiment_design.md#L6) |
| Batch_01_E2 | E2 | Reactor_01 | 低DO第76天 | 76 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:6](../../metadata/source_sample_metadata.tsv#L6) |
| Batch_01_E3 | E3 | Reactor_01 | 低DO第145天 | 145 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:7](../../metadata/source_sample_metadata.tsv#L7) |
| Batch_01_S1 | S1 | Reactor_01 | 低DO第145天后持续运行18天，同次采样按粒径筛分 | 163（原表推算） / T4 | low_do_size_fractionation | 实测NA；未记录采样DO | <100 | NA | 已记录待确认；[M:8](../../metadata/source_sample_metadata.tsv#L8) |
| Batch_01_S2 | S2 | Reactor_01 | 低DO第145天后持续运行18天，同次采样按粒径筛分 | 163（原表推算） / T4 | low_do_size_fractionation | 实测NA；未记录采样DO | 100–200 | NA | 已记录待确认；[M:9](../../metadata/source_sample_metadata.tsv#L9) |
| Batch_01_S3 | S3 | Reactor_01 | 低DO第145天后持续运行18天，同次采样按粒径筛分 | 163（原表推算） / T4 | low_do_size_fractionation | 实测NA；未记录采样DO | 200–500 | NA | 已记录待确认；[M:10](../../metadata/source_sample_metadata.tsv#L10) |
| Batch_01_S4 | S4 | Reactor_01 | 低DO第145天后持续运行18天，同次采样按粒径筛分 | 163（原表推算） / T4 | low_do_size_fractionation | 实测NA；未记录采样DO | >500 | NA | 已记录待确认；[M:11](../../metadata/source_sample_metadata.tsv#L11) |
| Batch_01_B0 | B0 | Reactor_02 | 低C/N启动开始，第1天 | 1 / T1 | low_cn_startup | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:12](../../metadata/source_sample_metadata.tsv#L12) |
| Batch_01_B1 | B1 | Reactor_02 | 低C/N启动结束，约第120天 | 120（约） / T1 | low_cn_end | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:13](../../metadata/source_sample_metadata.tsv#L13) |
| Batch_01_B2 | B2 | Reactor_02 | DO设定5 mg/L阶段结束，共用时间坐标第21天 | 21 / T2 | do_5 | 实测NA；记录设定5 | NA | NA | 已记录待确认；[M:14](../../metadata/source_sample_metadata.tsv#L14) |
| Batch_01_B3 | B3 | Reactor_02 | DO设定3 mg/L阶段结束，共用时间坐标第56天 | 56 / T2 | do_3 | 实测NA；记录设定3 | NA | NA | 已记录待确认；[M:15](../../metadata/source_sample_metadata.tsv#L15) |
| Batch_01_F1 | F1 | Reactor_02 | 低DO第1天（储存后恢复活力并接种启动） | 1 / T3 | low_do_long_term | 实测NA；第1天DO待确认 | NA | B3 | 前源：已确认文档线索；其余待确认；[M:16](../../metadata/source_sample_metadata.tsv#L16)、[D:6](../../docs/batch_01/experiment_design.md#L6) |
| Batch_01_F2 | F2 | Reactor_02 | 低DO第30天 | 30 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:17](../../metadata/source_sample_metadata.tsv#L17) |
| Batch_01_F3 | F3 | Reactor_02 | 低DO第76天 | 76 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:18](../../metadata/source_sample_metadata.tsv#L18) |
| Batch_01_F4 | F4 | Reactor_02 | 低DO第145天 | 145 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:19](../../metadata/source_sample_metadata.tsv#L19) |
| Batch_01_C0 | C0 | Reactor_03 | 低C/N启动开始，第1天 | 1 / T1 | low_cn_startup | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:20](../../metadata/source_sample_metadata.tsv#L20) |
| Batch_01_C1 | C1 | Reactor_03 | 低C/N启动结束，约第120天 | 120（约） / T1 | low_cn_end | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:21](../../metadata/source_sample_metadata.tsv#L21) |
| Batch_01_C2 | C2 | Reactor_03 | DO设定3 mg/L阶段结束，共用时间坐标第56天 | 56 / T2 | do_3 | 实测NA；记录设定3 | NA | NA | 已记录待确认；[M:22](../../metadata/source_sample_metadata.tsv#L22) |
| Batch_01_G1 | G1 | Reactor_03 | 低DO第1天（储存后恢复活力并接种启动） | 1 / T3 | low_do_long_term | 实测NA；第1天DO待确认 | NA | C2 | 前源：已确认文档线索；其余待确认；[M:23](../../metadata/source_sample_metadata.tsv#L23)、[D:6](../../docs/batch_01/experiment_design.md#L6) |
| Batch_01_G2 | G2 | Reactor_03 | 低DO第30天 | 30 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:24](../../metadata/source_sample_metadata.tsv#L24) |
| Batch_01_G3 | G3 | Reactor_03 | 低DO第76天 | 76 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:25](../../metadata/source_sample_metadata.tsv#L25) |
| Batch_01_G4 | G4 | Reactor_03 | 低DO第145天 | 145 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:26](../../metadata/source_sample_metadata.tsv#L26) |
| Batch_01_D0 | D0 | Reactor_04 | 低C/N启动开始，第1天 | 1 / T1 | low_cn_startup | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:27](../../metadata/source_sample_metadata.tsv#L27) |
| Batch_01_D1 | D1 | Reactor_04 | 低C/N启动结束，约第120天 | 120（约） / T1 | low_cn_end | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:28](../../metadata/source_sample_metadata.tsv#L28) |
| Batch_01_D2 | D2 | Reactor_04 | DO设定5 mg/L阶段结束，共用时间坐标第21天 | 21 / T2 | do_5 | 实测NA；记录设定5 | NA | NA | 已记录待确认；[M:29](../../metadata/source_sample_metadata.tsv#L29) |
| Batch_01_D3 | D3 | Reactor_04 | DO设定3 mg/L阶段结束，共用时间坐标第56天 | 56 / T2 | do_3 | 实测NA；记录设定3 | NA | NA | 已记录待确认；[M:30](../../metadata/source_sample_metadata.tsv#L30) |
| Batch_01_H1 | H1 | Reactor_04 | 低DO第1天（储存后恢复活力并接种启动） | 1 / T3 | low_do_long_term | 实测NA；第1天DO待确认 | NA | D3 | 前源：已确认文档线索；其余待确认；[M:31](../../metadata/source_sample_metadata.tsv#L31)、[D:6](../../docs/batch_01/experiment_design.md#L6) |
| Batch_01_H2 | H2 | Reactor_04 | 低DO第30天 | 30 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:32](../../metadata/source_sample_metadata.tsv#L32) |
| Batch_01_H3 | H3 | Reactor_04 | 低DO第76天 | 76 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:33](../../metadata/source_sample_metadata.tsv#L33) |
| Batch_01_H4 | H4 | Reactor_04 | 低DO第145天 | 145 / T3 | low_do_long_term | 实测NA；未记录采样DO | NA | NA | 已记录待确认；[M:34](../../metadata/source_sample_metadata.tsv#L34) |

### 时间依据与字段边界

- **T1**：低C/N第一阶段接种日为第1天；启动结束日编号沿用用户填写120（文献约120 d）（原文来自 metadata.phase_day_basis；说明文本不同不等于独立时间轴数目相同）。
- **T2**：R1/R2、R3/R4分别混合后均分，低C/N运行并设DO=5 mg/L为第0天；DO=5为0–21 d，DO=3为23–56 d；共用此时间坐标（原文来自 metadata.phase_day_basis；说明文本不同不等于独立时间轴数目相同）。
- **T3**：DO=3阶段结束污泥经4℃封存59 d后，在原条件恢复活力；恢复后污泥接种启动低DO为第1天（原文来自 metadata.phase_day_basis；说明文本不同不等于独立时间轴数目相同）。
- **T4**：DO=3阶段结束污泥经4℃封存59 d后，在原条件恢复活力；恢复后污泥接种启动低DO为第1天；持续运行至第145天后18天采样，第163天由145+18推算（原文来自 metadata.phase_day_basis；说明文本不同不等于独立时间轴数目相同）。
- T1 的启动终点文字为约 120 d；不把 phase_days=120 当作已核实的精确采样日。T4 在原表已注明 163=145+18，为推算坐标，不是本次补填的测量。
- T3/T4 均描述储存恢复后低 DO 第 1 天起算；T4 加入筛分日推算说明。因此四种依据文本不能解释为四条互不相关时间轴。日期、储存起止时刻、恢复时长及跨阶段换算仍未知。
- low_do_long_term 是原表编码，包含低 DO 第 1 天样本；结合设计文档第 1–24 天为调试/适应期，不能据该编码把所有 15 个样本解释为稳定长期运行。
- 六类 operation_phase 的记录行数：do_3=4；do_5=2；low_cn_end=4；low_cn_startup=4；low_do_long_term=15；low_do_size_fractionation=4。仅描述记录，不合并为五组。
- 四个 reactor_id 的记录行数：Reactor_01=10；Reactor_02=8；Reactor_03=7；Reactor_04=8。不是独立反应器重复数。
- group、DO_mg_L、DO_status、metadata_source、group_source、condition_source 在当前原表均不存在；sample_order 与 biological_replicate 均为 NA。表行序不得充当采样顺序，来源信息可引用本节文档位置而不虚构原始记录编号。

### 重复、来源及混杂风险

- **反应器重复采样**：同一 reactor_id 横跨多个时点和阶段，存在纵向相关性；原表行数不是独立生物重复数。阶段、时间和运行条件可能共同变化，不能将阶段差异直接归因于单个 DO 条件。
- **混合后均分**：metadata 的 DO 阶段时间依据写有 R1/R2、R3/R4 分别混合再均分。共享混合来源可能使不同标签样本相关，且混合前后反应器标签不自动代表同一实验单位；需谱系和分样记录后才能确定独立单位。
- **保存恢复及继承来源**：设计文档明确 A2→E1、B3→F1、C2→G1、D3→H1；4°C 保存 59 天并恢复后进入新实验。前源与后续样本不能默认独立；储存、恢复、调试和稳定运行不能拼接成不间断稳定时间序列。未将这四对关系外推到全部后续样本。
- **同次粒径分级**：S1=<100；S2=100–200；S3=200–500；S4=>500 μm；原表均为 Reactor_01、phase_days=163，并明写同次采样筛分。四个粒径级分不是四个独立反应器重复，也不能自动称为技术重复；完整采样/分级层级待原记录核验。
- **不平衡阶段记录**：do_5 只记录 B2/D2，两行不代表两份已确认独立重复；不补造 A/C 同期样本。低 DO 第 30 天只记录 F2/G2/H2，第 76、145 天各四个样本；时间点覆盖不完全，不能默认均衡重复测量设计。

### 仅需回查的缺口（无需重复提供上表已有值）

| 优先级 | 已有依据 | 尚需定位的内容 | 影响 |
|---|---|---|---|
| 阻断 | 用户确认五组尚未定稿；六类阶段已列出 | 将来定稿后的五组定义、逐样本映射及批准/原始依据；当前不要求临时指定 | 分组对象、组间推断继续暂停 |
| 阻断推断 | 原表已有 reactor_id，文档已有混合/均分说明 | 原始记录的位置/编号；R1–R4 与 Reactor_01–04 对照、混合前后接种谱系和独立实验单位；不需重抄全部样本记录 | 配对、相关结构、有效样本量和可交换性 |
| 待确认 | 已记录 day 1、约120、21、56、30、76、145和推算163，以及各起点说明 | 约120的精确采样时间（如有）；日历日期、恢复时长、各阶段起点衔接；不自行统一时间轴 | 纵向分析及阶段比较 |
| 待确认 | 第1–24天适应期、DO=3/5设定线索及保存恢复过程已明确 | E1/F1/G1/H1 取样瞬间 DO；第25–145天逐反应器设定/实测与变更节点；无实测则继续NA | DO关联及环境解释 |
| 待确认 | S1–S4 的粒径范围、同次分级及原表推算日已记录 | 同次采样事件/母样编号、分级份数及是否另有独立采样重复；不需再次提供已列粒径范围 | 避免把级分当独立生物重复 |
| 待确认 | do_5仅B2/D2，低DO第30天仅F2/G2/H2 | 其余对应点是未采样、不在本批还是记录缺漏；仅回查缺口，不补造样本 | 不平衡设计与可比较范围 |

当前可继续：基于现有记录的逐样本信息整理、来源定位和描述性清单维护。当前不执行：修改 metadata、创建分组、构建项目 phyloseq、组间检验或将分类注释解释为功能/活性。

### 本次复现与保护记录

- 命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla /home/leiyiping/Batch_01/scripts/stage1_pipeline.R --review-metadata --project-root '/home/leiyiping/Batch_01'`。
- 工具：R version 4.5.2 (2025-10-31)；digest 0.6.39；jsonlite 2.0.0。本入口不加载 phyloseq 或执行完整 stage1_main。
- 只对本节读取的 metadata、设计文档、两份技术日志记录指纹；不重新读取/校验 ASV、taxonomy、代表序列、BIOM 或 QZA。

| 本节输入 | SHA-256 |
|---|---|
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| docs/batch_01/experiment_design.md | 037db431ae6707082aa0f2b4c77c9d4bd4fa162db2b5ec09dd1bcefb5a702cd9 |
| logs/dada2/sample-id-update.json | 8e51ec9557ad1fab7fc38bba2427ce5e14080865e9fa75e1dc3ac75a4fdf590f |
| logs/taxonomy/inputs.json | 2937d9b59781f252688bdbbd9812a8cc5f904b44afc1aff039d64e1e3709df9c |
- 本次脚本 SHA-256：4b125039e953554741ad51bbc66b54473807ffbf9953c835749425f78ef9d2ff。上文历史脚本指纹对应此前 QC 版本；本次仅增加独立记录梳理入口，历史结果不被改写。
- 用时：0.027 秒；记录梳理已完成，但设计门控仍未通过，退出码2。


## 已确认设计修正与映射方案：2026-11-02 20:35:24（Asia/Shanghai）

来源：用户2026-11-02连续补充并逐项确认五模块清单、污泥设计类型、混合均分接种、G2/G3连续阶段与G5同一母样关系。当前以本节及experiment_design.md当日修正为准；上文历史“五组尚未确认”等结论保留为当时状态，相关确认问题已经解决，不再次索取。此前通过的DADA2/SILVA/ASV相关结果沿用，本次未重跑。

本次设计方案检查：PASS=17；WARNING=5；FAIL=0；退出码=0。对象和统计仍按用户要求暂缓，映射检查状态不等同全阶段验收。

| 状态 | 本次检查 | 实际依据 |
|---|---|---|
| PASS | 当前设计来源 | 定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。 |
| PASS | 五模块名单可解析 | 明确名单行数=5；每行含模块、定义、记录数、完整ID清单。 |
| PASS | 明确名单唯一且完整 | 名单条数=33；重复=0；预期模块记录数=8/2/4/15/4。 |
| PASS | 原始样本名称一一对应 | metadata行数=33；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。 |
| PASS | 33个ASV样本与五模块/原样本映射一致 | ASV表头样本=33；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。 |
| PASS | 现有ID与原样本名逐行对应 | 逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。 |
| PASS | 模块与原运行阶段不冲突 | 用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。 |
| PASS | 四个反应器标签 | 原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。 |
| PASS | 相对采样日可追溯 | 读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。 |
| PASS | 方案不覆盖原列 | 新增21个方案字段均与原列不同；仅在内存组合，不写回metadata。 |
| PASS | 全部原metadata字段保留 | 内存方案保留原14列、33行原值和行序；新增21列；源文件不写入。 |
| PASS | G2/G3连续阶段及第22天 | B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。 |
| PASS | 两次混合与均分接种关系 | A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。 |
| PASS | G4初始前源与适应期 | E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天和恢复后新实验；第1天未赋DO=3。 |
| PASS | G5同一母样及G4-R1延续 | S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。 |
| PASS | DO设定与实测严格区分 | 仅G2两行设定5、G3四行设定3；其他27行设定NA；33行实测DO均NA，不插补任何环境值。 |
| WARNING | 重复与共享来源 | G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。 |
| WARNING | 不平衡时间点 | G2/G3记录数2/4；G4各记录日：1d=4；30d=3；76d=4；145d=4；不补造缺失同期样本。 |
| WARNING | 粒径组分层级 | G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。 |
| WARNING | 环境和时间缺口 | G4逐反应器DO设定、全部采样实测DO、日历时间、恢复时长、混合比例和接种量等仍未知；120保留约值，163保留原表推算。 |
| WARNING | 当前交付门控 | 仅交付设计及metadata映射方案；不回写原始metadata，不构建最终phyloseq，不执行任何显著性检验；模块映射通过不代表统计适用性通过。 |
| PASS | 输入文档及metadata保持不变 | 比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。 |

### 五模块及统计边界

| 模块 | 记录数 | 当前目标与限制 |
|---|---:|---|
| G1 | 8 | 低C/N启动前后，保留四个原反应器的前后关联；不能作8个独立重复 |
| G2 | 2 | DO设定5的21d阶段末，只有B2/D2 |
| G3 | 4 | DO设定3的56d阶段末，与G2同轮连续；仅两对匹配阶段末记录，不能分离DO与时间/阶段效应 |
| G4 | 15 | 保存恢复后新低DO实验，1–24d适应期；各相对日4/3/4/4行，非独立或均衡重复 |
| G5 | 4 | G4-R1延长18天后同一母样四个粒径组分，独立母样事件数为1；不能检验跨母样粒径效应 |

G1旧反应器→原R1+R2/原R3+R4各自混合→均分至各自两个新反应器→G2(0–21d,设定5)→第22天过渡/稳定→G3(23–56d,设定3)。两个已记录来源块不能直接充当独立重复数；B2→B3及D2→D3分别共用连续运行实体。

G4的初始前源为E1←A2、F1←B3、原样本G1←C2、H1←D3，经过4℃59天保存及恢复后开始新的时间轴；相关来源结构不能因进入新实验而忽略。G5与G4-R1共享运行实体和一个母样事件，四级分不构成四次独立采样。

### 33样本metadata映射方案（未写入原表）

原metadata的全部列和值保持不变；本入口仅在内存附加21个字段。完整字段定义见[设计文档](../../docs/batch_01/experiment_design.md#2026-11-02-design-correction)。下面只展示核查所需视图；内部轮次/实体/混合池/事件键是关系追踪标识，不是原始实验登记编号或新增反应器。

| ASV sample-id | 原样本名 | 模块group | 原operation_phase | 轮次::反应器 | 污泥设计类型 | 相对日/状态 | DO设定/实测（mg/L） | 混合来源/直接前源/分级事件 |
|---|---|---|---|---|---|---|---|---|
| Batch_01_A0 | A0 | G1 | low_cn_startup | G1_original::Reactor_01 | flocculent | 1/recorded_relative_day | NA/NA | NA |
| Batch_01_A1 | A1 | G1 | low_cn_end | G1_original::Reactor_01 | flocculent | 120/approximate_recorded | NA/NA | NA |
| Batch_01_A2 | A2 | G3 | do_3 | G2G3_postmix::Reactor_01 | flocculent | 56/user_confirmed_stage_end | 3/NA | post_G1_pool_R1_R2 |
| Batch_01_E1 | E1 | G4 | low_do_long_term | G4G5_low_DO::Reactor_01 | flocculent | 1/recorded_relative_day | NA/NA | 前源:Batch_01_A2 |
| Batch_01_E2 | E2 | G4 | low_do_long_term | G4G5_low_DO::Reactor_01 | flocculent | 76/recorded_relative_day | NA/NA | NA |
| Batch_01_E3 | E3 | G4 | low_do_long_term | G4G5_low_DO::Reactor_01 | flocculent | 145/recorded_relative_day | NA/NA | NA |
| Batch_01_S1 | S1 | G5 | low_do_size_fractionation | G4G5_low_DO::Reactor_01 | flocculent | 163/derived_in_original_record | NA/NA | G5_R1_single_mother |
| Batch_01_S2 | S2 | G5 | low_do_size_fractionation | G4G5_low_DO::Reactor_01 | flocculent | 163/derived_in_original_record | NA/NA | G5_R1_single_mother |
| Batch_01_S3 | S3 | G5 | low_do_size_fractionation | G4G5_low_DO::Reactor_01 | flocculent | 163/derived_in_original_record | NA/NA | G5_R1_single_mother |
| Batch_01_S4 | S4 | G5 | low_do_size_fractionation | G4G5_low_DO::Reactor_01 | flocculent | 163/derived_in_original_record | NA/NA | G5_R1_single_mother |
| Batch_01_B0 | B0 | G1 | low_cn_startup | G1_original::Reactor_02 | flocculent | 1/recorded_relative_day | NA/NA | NA |
| Batch_01_B1 | B1 | G1 | low_cn_end | G1_original::Reactor_02 | flocculent | 120/approximate_recorded | NA/NA | NA |
| Batch_01_B2 | B2 | G2 | do_5 | G2G3_postmix::Reactor_02 | flocculent | 21/user_confirmed_stage_end | 5/NA | post_G1_pool_R1_R2 |
| Batch_01_B3 | B3 | G3 | do_3 | G2G3_postmix::Reactor_02 | flocculent | 56/user_confirmed_stage_end | 3/NA | post_G1_pool_R1_R2 |
| Batch_01_F1 | F1 | G4 | low_do_long_term | G4G5_low_DO::Reactor_02 | flocculent | 1/recorded_relative_day | NA/NA | 前源:Batch_01_B3 |
| Batch_01_F2 | F2 | G4 | low_do_long_term | G4G5_low_DO::Reactor_02 | flocculent | 30/recorded_relative_day | NA/NA | NA |
| Batch_01_F3 | F3 | G4 | low_do_long_term | G4G5_low_DO::Reactor_02 | flocculent | 76/recorded_relative_day | NA/NA | NA |
| Batch_01_F4 | F4 | G4 | low_do_long_term | G4G5_low_DO::Reactor_02 | flocculent | 145/recorded_relative_day | NA/NA | NA |
| Batch_01_C0 | C0 | G1 | low_cn_startup | G1_original::Reactor_03 | granular | 1/recorded_relative_day | NA/NA | NA |
| Batch_01_C1 | C1 | G1 | low_cn_end | G1_original::Reactor_03 | granular | 120/approximate_recorded | NA/NA | NA |
| Batch_01_C2 | C2 | G3 | do_3 | G2G3_postmix::Reactor_03 | granular | 56/user_confirmed_stage_end | 3/NA | post_G1_pool_R3_R4 |
| Batch_01_G1 | G1 | G4 | low_do_long_term | G4G5_low_DO::Reactor_03 | granular | 1/recorded_relative_day | NA/NA | 前源:Batch_01_C2 |
| Batch_01_G2 | G2 | G4 | low_do_long_term | G4G5_low_DO::Reactor_03 | granular | 30/recorded_relative_day | NA/NA | NA |
| Batch_01_G3 | G3 | G4 | low_do_long_term | G4G5_low_DO::Reactor_03 | granular | 76/recorded_relative_day | NA/NA | NA |
| Batch_01_G4 | G4 | G4 | low_do_long_term | G4G5_low_DO::Reactor_03 | granular | 145/recorded_relative_day | NA/NA | NA |
| Batch_01_D0 | D0 | G1 | low_cn_startup | G1_original::Reactor_04 | granular | 1/recorded_relative_day | NA/NA | NA |
| Batch_01_D1 | D1 | G1 | low_cn_end | G1_original::Reactor_04 | granular | 120/approximate_recorded | NA/NA | NA |
| Batch_01_D2 | D2 | G2 | do_5 | G2G3_postmix::Reactor_04 | granular | 21/user_confirmed_stage_end | 5/NA | post_G1_pool_R3_R4 |
| Batch_01_D3 | D3 | G3 | do_3 | G2G3_postmix::Reactor_04 | granular | 56/user_confirmed_stage_end | 3/NA | post_G1_pool_R3_R4 |
| Batch_01_H1 | H1 | G4 | low_do_long_term | G4G5_low_DO::Reactor_04 | granular | 1/recorded_relative_day | NA/NA | 前源:Batch_01_D3 |
| Batch_01_H2 | H2 | G4 | low_do_long_term | G4G5_low_DO::Reactor_04 | granular | 30/recorded_relative_day | NA/NA | NA |
| Batch_01_H3 | H3 | G4 | low_do_long_term | G4G5_low_DO::Reactor_04 | granular | 76/recorded_relative_day | NA/NA | NA |
| Batch_01_H4 | H4 | G4 | low_do_long_term | G4G5_low_DO::Reactor_04 | granular | 145/recorded_relative_day | NA/NA | NA |

字段边界：module用group、phase保留operation_phase；stage_subphase单列G1启动前后及G4适应期；reactor_round/instance/run区分G1原轮次、G2G3混合后同一轮次、G4G5低DO轮次。G2阶段界限0/21、G3为23/56，其他模块区间NA；G5 mother_sample_id为NA，共享fractionation_event_id=G5_R1_single_mother。原particle_size_fraction_um保留<100/100–200/200–500/>500；没有补定边界闭开。来源字段指向现有记录与已确认设计，不代表所有原表内容已独立复核。

### 尚需后续核查（已解决的问题不再索取）

- 全部样本采样实测DO、G4逐反应器DO设定/变更节点及其他环境实测值；第1天DO继续NA，不沿用前源3 mg/L。
- 采样日历日期、约120d的精确性、恢复时长；163仅为原记录145+18推算，不自动生成统一连续时间轴。
- 原始混合比例和接种量、原始母样编号、筛分边界及处理细节；上述细节未知不改变已确认的两次混合及同一母样事实。
- G2未记录新R1/新R3的同期样本、G4第30天未记录R1样本的原因；保留本批实际不平衡取样，不插补样本。
- 任何推断前再核验具体比较的独立实验单位、谱系/重复结构、可识别性、有效样本量和方法前提；本轮只有方案，不生成最终对象。

### 复现与数据保护

- 命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla /home/leiyiping/Batch_01/scripts/stage1_pipeline.R --review-design --project-root '/home/leiyiping/Batch_01'`。
- 版本：R version 4.5.2 (2025-10-31)；digest 0.6.39。新增入口不加载phyloseq，不读取ASV计数或taxonomy/FASTA/BIOM/QZA；仅前两行ASV表头用于本次明确要求的ID核对。
- 仅读文档与原始metadata；报告仅追加；未建立新文件或临时文件。原报告中的14列metadata输入指纹继续对应当前未改写源文件。

| 本次完整读取输入 | SHA-256 |
|---|---|
| metadata | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| design | 0d6da3c44fecfac0840459dde86de6d28e8460a1052011f0e0ab23e08a4d71c5 |
| plan | fa443ba3da369d11931a596cc54768a5b653d78d4f7a9f2d0cc284710a23e4ea |

- 本次脚本SHA-256：75c12dbd16221b739b62efb304abbd95bed677321cae74057d88e3d462260c45。历史脚本指纹对应各自运行版本，未改写。
- 用时：0.022秒；退出码0。


## 设计重申与映射复核（简版）：2026-11-03 14:14:48（Asia/Shanghai）

本次用户重申与现有已确认设计一致；完整五模块名单、33行映射及21个附加字段方案沿用上文和实验设计文档。以下重新执行的仅为metadata/设计与ASV表头核对，未运行DADA2、SILVA或ASV计数、taxonomy、代表序列、深度质量检查。报告保留历史内容，本节不重复输出样本表。

本次检查：PASS=17；WARNING=5；FAIL=0；退出码=0。仅表示本次映射方案检查状态，不代表统计适用性或完整阶段验收。

| 状态 | 检查 | 实际依据 |
|---|---|---|
| PASS | 当前设计来源 | 定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。 |
| PASS | 五模块名单可解析 | 明确名单行数=5；每行含模块、定义、记录数、完整ID清单。 |
| PASS | 明确名单唯一且完整 | 名单条数=33；重复=0；预期模块记录数=8/2/4/15/4。 |
| PASS | 原始样本名称一一对应 | metadata行数=33；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。 |
| PASS | 33个ASV样本与五模块/原样本映射一致 | ASV表头样本=33；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。 |
| PASS | 现有ID与原样本名逐行对应 | 逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。 |
| PASS | 模块与原运行阶段不冲突 | 用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。 |
| PASS | 四个反应器标签 | 原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。 |
| PASS | 相对采样日可追溯 | 读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。 |
| PASS | 方案不覆盖原列 | 新增21个方案字段均与原列不同；仅在内存组合，不写回metadata。 |
| PASS | 全部原metadata字段保留 | 内存方案保留原14列、33行原值和行序；新增21列；源文件不写入。 |
| PASS | G2/G3连续阶段及第22天 | B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。 |
| PASS | 两次混合与均分接种关系 | A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。 |
| PASS | G4初始前源与适应期 | E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天和恢复后新实验；第1天未赋DO=3。 |
| PASS | G5同一母样及G4-R1延续 | S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。 |
| PASS | DO设定与实测严格区分 | 仅G2两行设定5、G3四行设定3；其他27行设定NA；33行实测DO均NA，不插补任何环境值。 |
| WARNING | 重复与共享来源 | G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。 |
| WARNING | 不平衡时间点 | G2/G3记录数2/4；G4各记录日：1d=4；30d=3；76d=4；145d=4；不补造缺失同期样本。 |
| WARNING | 粒径组分层级 | G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。 |
| WARNING | 环境和时间缺口 | G4逐反应器DO设定、全部采样实测DO、日历时间、恢复时长、混合比例和接种量等仍未知；120保留约值，163保留原表推算。 |
| WARNING | 当前交付门控 | 仅交付设计及metadata映射方案；不回写原始metadata，不构建最终phyloseq，不执行任何显著性检验；模块映射通过不代表统计适用性通过。 |
| PASS | 输入文档及metadata保持不变 | 比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。 |

G1–G5记录数为8/2/4/15/4；G2/G3的DO与时间/阶段混杂，混合来源和纵向采样相关性必须保留。G4第1天不赋DO=3，G5一次母样事件的四个组分不作为四份独立生物重复。原metadata不变，当前仍为字段与映射方案；不构建phyloseq、不作显著性检验。

待回查：采样实测DO和G4设定/变化节点、精确日历时间和恢复时长、混合比例/接种量、原始母样编号和筛分边界细节、缺少同期取样的原因。未知信息保持NA，既有完整名单和已确认关系不再索取。

### 复现与输入记录

- 命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla /home/leiyiping/Batch_01/scripts/stage1_pipeline.R --review-design --compact-report --project-root '/home/leiyiping/Batch_01'`。
- 工具：R version 4.5.2 (2025-10-31)；digest 0.6.39；不加载phyloseq。
- ASV仅读取前两行表头；不扫描或重新校验计数。完整读取的metadata/设计/计划指纹如下，原科研数据不改写。

| 输入 | SHA-256 |
|---|---|
| metadata | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| design | 853b30163975e59275efcd20218b19ad0bd9a45aaf47c3b9337efd02a0a27aad |
| plan | 30b0c3c46c46921cda562b147d96bebd91d7967a4f31c200c30abe704fb75177 |

- 当前脚本SHA-256：42b1144c3e8b0dc5d480fbbc562dbdd7547e6dd94ab2b021869ec33e5e43717a。
- 用时：0.018秒；退出码0。


## 阶段DO设置与G4分层复核（简版）：2026-11-03 14:59:48（Asia/Shanghai）

用户补充阶段DO设置，并确认E1/F1/原样本G1/H1在原条件恢复结束、切换低DO之前取样。本节取代历史“G4初始样本已处适应期”“G1/G4后期/G5设置未知”的结论；五模块归属不变。原metadata保留，27个附加字段仅在内存形成方案。以下仅核对metadata/设计与ASV表头，基础QC不重跑，历史报告不改写。

本次检查：PASS=21；WARNING=5；FAIL=0；退出码=0。仅表示本次映射方案检查状态，不代表统计适用性或完整阶段验收。

| 状态 | 检查 | 实际依据 |
|---|---|---|
| PASS | 当前设计来源 | 定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。 |
| PASS | 五模块名单可解析 | 明确名单行数=5；每行含模块、定义、记录数、完整ID清单。 |
| PASS | 明确名单唯一且完整 | 名单条数=33；重复=0；预期模块记录数=8/2/4/15/4。 |
| PASS | 原始样本名称一一对应 | metadata行数=33；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。 |
| PASS | 33个ASV样本与五模块/原样本映射一致 | ASV表头样本=33；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。 |
| PASS | 现有ID与原样本名逐行对应 | 逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。 |
| PASS | 模块与原运行阶段不冲突 | 用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。 |
| PASS | 四个反应器标签 | 原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。 |
| PASS | 相对采样日可追溯 | 读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。 |
| PASS | 用户报告阶段DO设置可解析 | 读取最新DO表的6个阶段层；区分G1范围、恢复基线、低DO后期与设定/实测。 |
| PASS | DO阶段与范围结构 | 6个阶段键唯一；算术下界不大于上界；范围不是采样实测值或统计误差。 |
| PASS | 采样节点有明确的设置记录层 | G4四个day1基线与30/76/145d后期分层，适应期间没有额外样本行；不对未知节点插值。 |
| PASS | 方案不覆盖原列 | 新增27个方案字段均与原列不同；仅在内存组合，不写回metadata。 |
| PASS | 全部原metadata字段保留 | 内存方案保留原14列、33行原值和行序；新增27列；源文件不写入。 |
| PASS | G2/G3连续阶段及第22天 | B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。 |
| PASS | 两次混合与均分接种关系 | A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。 |
| PASS | G4初始前源及切换前基线 | E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天、原G3条件恢复结束后且低DO切换前取样；设置3、实测NA。 |
| PASS | G4适应期后设计稳定运行期 | 30d=3、76d=4、145d=4，共11个样本，均在25–145d；设置0.5±0.2。可按设计标稳定期，运行性能稳态证据另行审阅；仍是纵向相关记录。 |
| PASS | G5同一母样及G4-R1延续 | S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。 |
| PASS | DO设置、范围与实测严格区分 | G1八行只记5–7范围，不取中点6；G2=5，G3及G4切换前恢复基线=3；G4后期11行及G5四行=0.5±0.2，界限仅表达设置。25行有标称设置、8行仅范围；33行实测NA。 |
| WARNING | 重复与共享来源 | G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。 |
| WARNING | 不平衡时间点 | G2/G3记录数2/4；G4各记录日：1d=4；30d=3；76d=4；145d=4；不补造缺失同期样本。 |
| WARNING | 粒径组分层级 | G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。 |
| WARNING | 设置已知与稳态证据边界 | 阶段DO设置已经补充；没有采样瞬时具体值，实测字段NA。0.5±0.2不是实测均值±标准差；11个后期样本按设计归稳定期，运行性能证据未审阅，不据此断定不稳。日历/恢复时长等缺口仍保留。 |
| WARNING | 当前交付门控 | 仅交付设计及metadata映射方案；不回写原始metadata，不构建最终phyloseq，不执行任何显著性检验；模块映射通过不代表统计适用性通过。 |
| PASS | 输入文档及metadata保持不变 | 比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。 |

### 阶段设置与样本层

| 阶段层 | 样本数 | 用户报告设置 | 采样实测 |
|---|---:|---|---|
| G1_all | 8 | 5–7 mg/L | NA |
| G2_all | 2 | 5 mg/L | NA |
| G3_all | 4 | 3 mg/L | NA |
| G4_baseline | 4 | 3 mg/L（恢复原G3条件） | NA |
| G4_post_adaptation | 11 | 0.5±0.2 mg/L | NA |
| G5_all | 4 | 0.5±0.2 mg/L | NA |

G4的15行继续用于完整时间序列：四份恢复后初始基线，设置3 mg/L（原G3恢复条件）；11份30/76/145d样本属于25–145d、设置0.5±0.2的设计稳定运行期（适应期后）。可以单独描述这11份后期样本；不能把含不同设置基线的15份统一标成低DO稳定条件。11份仍是重复采样，运行性能证据是否已证明稳态与阶段命名分开。

G1的5–7范围不取中点；0.5±0.2仅是用户报告的设置，0.3–0.7为其算术表达，不是实测极值、标准差或置信区间。用户明确没有采样瞬时DO数值，33行实测均NA，不要求凭空补齐。第1天的3只写恢复阶段设置；原day1编号不当成低DO已暴露1天。

G1–G5仍为8/2/4/15/4；混合来源、G2/G3时间/阶段混杂和纵向相关不变；G5同一母样不作4份独立生物重复。原metadata不回写，不构建对象或运行统计检验。待审阅运行稳态性能记录，精确时间/恢复时长、接种量及母样处理等缺口仍保留；已明确的设置与取样位置不再索取。

### 复现与输入记录

- 命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/lib/R/bin/Rscript --vanilla /home/leiyiping/Batch_01/scripts/stage1_pipeline.R --review-design --compact-report --project-root '/home/leiyiping/Batch_01'`。
- 工具：R version 4.5.2 (2025-10-31)；digest 0.6.39；不加载phyloseq。
- ASV仅读取前两行表头；不扫描或重新校验计数。完整读取的metadata/设计/计划指纹如下，原科研数据不改写。

| 输入 | SHA-256 |
|---|---|
| metadata | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| design | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| plan | 0d4d7f9b3b3f1d8a9fc604cff29f7724c3dd4f248cc3470ea81511516ffa734f |

- 当前脚本SHA-256：b47b157bc55905b82e7e8d8b07e38309509f701dcc872107b24f17a371d2ee5b。
- 用时：0.024秒；退出码0。


## 模块1.1授权的缺失对象构建：2026-11-03 15:06:14

本次请求明确授权构建缺失phyloseq，取代此前暂缓对象交付的任务范围；沿用既有基础QC，未执行DADA2、分类器、Artifact解包或重复深度异常筛查。

结果：生成results/phyloseq/batch_01_phyloseq.rds。构建通过仅允许描述性组成分析，不表示统计推断前提通过。

| 状态 | 核验 | 实际依据 |
|---|---|---|
| PASS | 构建依赖 | 使用现有R环境，不安装或更新软件。 |
| PASS | 输入存在 | data/asv_table.tsv; data/taxonomy.tsv; data/exported_sequences/dna-sequences.fasta; metadata/source_sample_metadata.tsv; data/exported_table/feature-table.biom; input/qiime2/table.qza; input/qiime2/rep-seqs.qza; input/qiime2/taxonomy.qza; docs/batch_01/experiment_design.md; docs/batch_01/analysis_plan.md |
| PASS | 复用既有QC：asv | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：taxonomy | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：sequences | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：metadata | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：biom | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：table_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：sequences_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：taxonomy_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 当前设计来源 | 定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。 |
| PASS | 五模块名单可解析 | 明确名单行数=5；每行含模块、定义、记录数、完整ID清单。 |
| PASS | 明确名单唯一且完整 | 名单条数=33；重复=0；预期模块记录数=8/2/4/15/4。 |
| PASS | 原始样本名称一一对应 | metadata行数=33；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。 |
| PASS | 33个ASV样本与五模块/原样本映射一致 | ASV表头样本=33；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。 |
| PASS | 现有ID与原样本名逐行对应 | 逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。 |
| PASS | 模块与原运行阶段不冲突 | 用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。 |
| PASS | 四个反应器标签 | 原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。 |
| PASS | 相对采样日可追溯 | 读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。 |
| PASS | 用户报告阶段DO设置可解析 | 读取最新DO表的6个阶段层；区分G1范围、恢复基线、低DO后期与设定/实测。 |
| PASS | DO阶段与范围结构 | 6个阶段键唯一；算术下界不大于上界；范围不是采样实测值或统计误差。 |
| PASS | 采样节点有明确的设置记录层 | G4四个day1基线与30/76/145d后期分层，适应期间没有额外样本行；不对未知节点插值。 |
| PASS | 方案不覆盖原列 | 新增27个方案字段均与原列不同；仅在内存组合，不写回metadata。 |
| PASS | 全部原metadata字段保留 | 内存方案保留原14列、33行原值和行序；新增27列；源文件不写入。 |
| PASS | G2/G3连续阶段及第22天 | B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。 |
| PASS | 两次混合与均分接种关系 | A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。 |
| PASS | G4初始前源及切换前基线 | E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天、原G3条件恢复结束后且低DO切换前取样；设置3、实测NA。 |
| PASS | G4适应期后设计稳定运行期 | 30d=3、76d=4、145d=4，共11个样本，均在25–145d；设置0.5±0.2。可按设计标稳定期，运行性能稳态证据另行审阅；仍是纵向相关记录。 |
| PASS | G5同一母样及G4-R1延续 | S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。 |
| PASS | DO设置、范围与实测严格区分 | G1八行只记5–7范围，不取中点6；G2=5，G3及G4切换前恢复基线=3；G4后期11行及G5四行=0.5±0.2，界限仅表达设置。25行有标称设置、8行仅范围；33行实测NA。 |
| WARNING | 重复与共享来源 | G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。 |
| WARNING | 不平衡时间点 | G2/G3记录数2/4；G4各记录日：1d=4；30d=3；76d=4；145d=4；不补造缺失同期样本。 |
| WARNING | 粒径组分层级 | G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。 |
| WARNING | 设置已知与稳态证据边界 | 阶段DO设置已经补充；没有采样瞬时具体值，实测字段NA。0.5±0.2不是实测均值±标准差；11个后期样本按设计归稳定期，运行性能证据未审阅，不据此断定不稳。日历/恢复时长等缺口仍保留。 |
| PASS | 输入文档及metadata保持不变 | 比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。 |
| PASS | 必需设计门控 | 复用明确名单与设计断言，不由名称或operation_phase推断group。 |
| WARNING | 初始设置来源冲突 | E1/F1/原G1/H1：本次请求设置不确定，分析值NA；文档历史恢复设置3保留于design_document_DO_*，不用于图中条件标签。 |
| PASS | 对象组装计数断言 | 非负整数、无缺失、唯一ID及非空样本；不筛选、不稀释、不删除ASV；既有深度异常QC沿用。 |
| PASS | 对象组装ID对齐 | count/taxonomy/FASTA的全部Feature ID及metadata全部SampleID一致。 |
| PASS | 对象全部内容核验 | 5510个ASV × 33个样本，原始计数、全部分类、metadata及代表序列一致。 |
| PASS | 构建前输入保护 | 全部输入SHA-256与运行开始一致。 |
| PASS | 序列化往返核验 | 重读候选对象，逐项比较全部内容与来源。 |
| PASS | 安全提交对象 | 目标不存在才创建硬链接，绝不覆盖。 |
| PASS | 派生metadata不覆盖 | /home/leiyiping/Batch_01/results/community_composition/2026-11-03_v1/analysis_metadata.tsv |

| 输入 | SHA-256 |
|---|---|
| data/asv_table.tsv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| data/exported_sequences/dna-sequences.fasta | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| data/exported_table/feature-table.biom | 331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905 |
| input/qiime2/table.qza | aa1a6bac46ebccce26827d71433d85b09b01254ea694eb53c86fd7c7344ba1ce |
| input/qiime2/rep-seqs.qza | 9266608e6381cdffa1bf582d798902cd6121c4b04c1e0b8d3c353fac8880d20e |
| input/qiime2/taxonomy.qza | 76e0fe74f88e1448804dd6565551650e5fa0b62fd4393d72bc85c6c5e1621604 |
| docs/batch_01/experiment_design.md | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| docs/batch_01/analysis_plan.md | 0d4d7f9b3b3f1d8a9fc604cff29f7724c3dd4f248cc3470ea81511516ffa734f |

- 派生metadata：/home/leiyiping/Batch_01/results/community_composition/2026-11-03_v1/analysis_metadata.tsv；原14列原值保留，新增分组和来源，不改写原表。
- 本次最新请求称G4四个初始样本DO设置不确定：分析字段设NA，设计文档曾记录的恢复设置3另列design_document_DO_*；全部采样实测DO为NA。未修改实验设计。
- 入口：scripts/stage1_pipeline.R --build-confirmed-design --analysis-dir /home/leiyiping/Batch_01/results/community_composition/2026-11-03_v1
- 脚本SHA-256：a5ea632129420ce85dae9b21793ea576108af329b4e935f023f3c27b25d08489
- 工具：R version 4.5.2 (2025-10-31)；phyloseq 1.54.0；Biostrings 2.78.0；digest 0.6.39
- 用时：1.089秒。


## 模块1.1授权的缺失对象构建：2026-11-03 15:07:31

本次请求明确授权构建缺失phyloseq，取代此前暂缓对象交付的任务范围；沿用既有基础QC，未执行DADA2、分类器、Artifact解包或重复深度异常筛查。

结果：复用已有兼容对象。构建通过仅允许描述性组成分析，不表示统计推断前提通过。

| 状态 | 核验 | 实际依据 |
|---|---|---|
| PASS | 构建依赖 | 使用现有R环境，不安装或更新软件。 |
| PASS | 输入存在 | data/asv_table.tsv; data/taxonomy.tsv; data/exported_sequences/dna-sequences.fasta; metadata/source_sample_metadata.tsv; data/exported_table/feature-table.biom; input/qiime2/table.qza; input/qiime2/rep-seqs.qza; input/qiime2/taxonomy.qza; docs/batch_01/experiment_design.md; docs/batch_01/analysis_plan.md |
| PASS | 复用既有QC：asv | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：taxonomy | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：sequences | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：metadata | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：biom | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：table_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：sequences_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 复用既有QC：taxonomy_qza | 当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。 |
| PASS | 当前设计来源 | 定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。 |
| PASS | 五模块名单可解析 | 明确名单行数=5；每行含模块、定义、记录数、完整ID清单。 |
| PASS | 明确名单唯一且完整 | 名单条数=33；重复=0；预期模块记录数=8/2/4/15/4。 |
| PASS | 原始样本名称一一对应 | metadata行数=33；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。 |
| PASS | 33个ASV样本与五模块/原样本映射一致 | ASV表头样本=33；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。 |
| PASS | 现有ID与原样本名逐行对应 | 逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。 |
| PASS | 模块与原运行阶段不冲突 | 用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。 |
| PASS | 四个反应器标签 | 原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。 |
| PASS | 相对采样日可追溯 | 读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。 |
| PASS | 用户报告阶段DO设置可解析 | 读取最新DO表的6个阶段层；区分G1范围、恢复基线、低DO后期与设定/实测。 |
| PASS | DO阶段与范围结构 | 6个阶段键唯一；算术下界不大于上界；范围不是采样实测值或统计误差。 |
| PASS | 采样节点有明确的设置记录层 | G4四个day1基线与30/76/145d后期分层，适应期间没有额外样本行；不对未知节点插值。 |
| PASS | 方案不覆盖原列 | 新增27个方案字段均与原列不同；仅在内存组合，不写回metadata。 |
| PASS | 全部原metadata字段保留 | 内存方案保留原14列、33行原值和行序；新增27列；源文件不写入。 |
| PASS | G2/G3连续阶段及第22天 | B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。 |
| PASS | 两次混合与均分接种关系 | A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。 |
| PASS | G4初始前源及切换前基线 | E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天、原G3条件恢复结束后且低DO切换前取样；设置3、实测NA。 |
| PASS | G4适应期后设计稳定运行期 | 30d=3、76d=4、145d=4，共11个样本，均在25–145d；设置0.5±0.2。可按设计标稳定期，运行性能稳态证据另行审阅；仍是纵向相关记录。 |
| PASS | G5同一母样及G4-R1延续 | S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。 |
| PASS | DO设置、范围与实测严格区分 | G1八行只记5–7范围，不取中点6；G2=5，G3及G4切换前恢复基线=3；G4后期11行及G5四行=0.5±0.2，界限仅表达设置。25行有标称设置、8行仅范围；33行实测NA。 |
| WARNING | 重复与共享来源 | G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。 |
| WARNING | 不平衡时间点 | G2/G3记录数2/4；G4各记录日：1d=4；30d=3；76d=4；145d=4；不补造缺失同期样本。 |
| WARNING | 粒径组分层级 | G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。 |
| WARNING | 设置已知与稳态证据边界 | 阶段DO设置已经补充；没有采样瞬时具体值，实测字段NA。0.5±0.2不是实测均值±标准差；11个后期样本按设计归稳定期，运行性能证据未审阅，不据此断定不稳。日历/恢复时长等缺口仍保留。 |
| PASS | 输入文档及metadata保持不变 | 比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。 |
| PASS | 必需设计门控 | 复用明确名单与设计断言，不由名称或operation_phase推断group。 |
| WARNING | 初始设置来源冲突 | E1/F1/原G1/H1：本次请求设置不确定，分析值NA；文档历史恢复设置3保留于design_document_DO_*，不用于图中条件标签。 |
| PASS | 对象组装计数断言 | 非负整数、无缺失、唯一ID及非空样本；不筛选、不稀释、不删除ASV；既有深度异常QC沿用。 |
| PASS | 对象组装ID对齐 | count/taxonomy/FASTA的全部Feature ID及metadata全部SampleID一致。 |
| PASS | 对象全部内容核验 | 5510个ASV × 33个样本，原始计数、全部分类、metadata及代表序列一致。 |
| PASS | 构建前输入保护 | 全部输入SHA-256与运行开始一致。 |
| PASS | 已有对象兼容性 | 逐项比较全部内容与来源；不兼容即FAIL，绝不覆盖。 |
| PASS | 派生metadata不覆盖 | /home/leiyiping/Batch_01/results/community_composition/2026-11-03_v2/analysis_metadata.tsv |

| 输入 | SHA-256 |
|---|---|
| data/asv_table.tsv | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| data/taxonomy.tsv | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| data/exported_sequences/dna-sequences.fasta | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| metadata/source_sample_metadata.tsv | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| data/exported_table/feature-table.biom | 331b0b968123d6814b0bd9070e3a89e8b2819baa7369caa05837fe7afe826905 |
| input/qiime2/table.qza | aa1a6bac46ebccce26827d71433d85b09b01254ea694eb53c86fd7c7344ba1ce |
| input/qiime2/rep-seqs.qza | 9266608e6381cdffa1bf582d798902cd6121c4b04c1e0b8d3c353fac8880d20e |
| input/qiime2/taxonomy.qza | 76e0fe74f88e1448804dd6565551650e5fa0b62fd4393d72bc85c6c5e1621604 |
| docs/batch_01/experiment_design.md | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| docs/batch_01/analysis_plan.md | 0d4d7f9b3b3f1d8a9fc604cff29f7724c3dd4f248cc3470ea81511516ffa734f |

- 派生metadata：/home/leiyiping/Batch_01/results/community_composition/2026-11-03_v2/analysis_metadata.tsv；原14列原值保留，新增分组和来源，不改写原表。
- 本次最新请求称G4四个初始样本DO设置不确定：分析字段设NA，设计文档曾记录的恢复设置3另列design_document_DO_*；全部采样实测DO为NA。未修改实验设计。
- 入口：scripts/stage1_pipeline.R --build-confirmed-design --analysis-dir /home/leiyiping/Batch_01/results/community_composition/2026-11-03_v2
- 脚本SHA-256：a5ea632129420ce85dae9b21793ea576108af329b4e935f023f3c27b25d08489
- 工具：R version 4.5.2 (2025-10-31)；phyloseq 1.54.0；Biostrings 2.78.0；digest 0.6.39
- 用时：0.835秒。

