# Batch_01 模块1.3：Alpha/Beta多样性与变化幅度（有效v2）

当前输出：results/diversity/2026-11-04_v2。上游仅使用community_composition/2026-11-03_v2与functional_guilds/2026-11-03_v2；原始count/对象经其报告指纹验证。
用户已撤回并要求删除此前模块1.3目录，当前结果为从指定输入实际计算，未复制旧模块1.3结果。其他模块历史版本不作处理。
运行：2026-11-04 15:53:04–2026-11-04 15:53:31（Asia/Shanghai）。状态：40 PASS / 6 WARNING / 0 FAIL；PASS仅限描述性计算，推断门控关闭。

## 数据与方法

33样本、5510 ASV；G1–G5=8/2/4/15/4。原count与RDS逐格核对，原14列metadata与v2派生表及对象逐值一致，按已确认设计名单核对分组。复用上游QC，不重跑DADA2、SILVA、导出或功能丰度计算；未改写原始输入、metadata、实验设计和既有v2结果。
RDS及派生metadata中保留历史metadata_version标签，但内容与有效v2逐值及指纹一致；标签不作为选择旧版本结果的依据，原对象不修改。G4基线按最新设计解释为切换前恢复基线，继承的分析DO=NA/design_document=3差异原样保留，不以设置当实测。

### Alpha定义与Chao1适用性

主分析不抽稀、不滤ASV：Observed=每样本count>0的ASV数；Shannon=−Σp ln p；Simpson=1−Σp²（非倒数）。偏差校正Chao1=Sobs+f1(f1−1)/[2(f2+1)]，与vegan::estimateR核对；单例/双例来自原整数count。ASV不是物种，去噪后单例贫化，Chao1仅探索性数值，不作为可靠总丰富度估计，不能用其接近Observed证明取样饱和。[vegan定义](https://vegandevs.github.io/vegan/reference/diversity.html)。
实际深度31457–53307，中位42004（上游已QC，未重做异常筛查）；f1=0–6、f2=23–118，7样本f1=0；Observed范围198–693，Shannon 0.91595–4.71496，Simpson 0.24333–0.97228。

### Beta与PCoA

Bray以每样本ASV相对丰度计算；Jaccard明确为存在/缺失二元距离，检出=count>0。完整33×33原始距离矩阵保留。Bray与L1/2、Jaccard与1−交集/并集独立公式核对。[距离文档](https://vegandevs.github.io/vegan/reference/vegdist.html)。
主29与G5四组分分别PCoA，避免单母样级分影响主29轴权重。对−0.5 JD²J求原特征值；负值判断容差=max|λ|×1e−10。存在负特征值时使用vegan::wcmdscale(add='lingoes')，c=−最小负特征值，非对角d'=sqrt(d²+2c)，原对角保持0。保存原/校正谱及全部正轴坐标，全轴重构误差<1e−8；变化幅度和距离矩阵仍用原Bray。前两轴只是投影，不把截断坐标距离当完整群落距离。[Lingoes文档](https://vegandevs.github.io/vegan/reference/wcmdscale.html)。

| basis | negative_eigenvalues | negative_absolute_inertia_fraction | Lingoes_constant | PCoA1_percent | PCoA2_percent |
|---|---|---|---|---|---|
| main29 | 3 | 0.00507789 | 0.02099164 | 36.60028 | 13.90222 |
| G5 | 0 | 0.00000000 | 0.00000000 | 64.40587 | 27.38490 |

### 固定的敏感性参数

1. 深度：seed=20261104，31457 reads（最小深度）不放回子抽样100次，全部33样本保留，仅内存计算。Alpha与Bray/Jaccard均保存均值和2.5%/97.5%子抽样分位数；Observed另给解析抽样期望。非默认主分析、非生物学置信区间，不产生抽稀count文件。[抽样文档](https://vegandevs.github.io/vegan/reference/rarefy.html)。
2. 低检出：敏感性Bray保留全33样本总reads≥10的ASV（1731/5510，重新闭合），敏感性Jaccard使用每样本count≥5定义检出。固定阈值不调参，主分析不删除ASV。
3. Hellinger=sqrt相对丰度后Euclidean距离；CLR=Aitchison的log-ratio Euclidean距离。将相对组成缩放到共同最小深度的期望count后统一加0.5或1，log后逐样本中心化，所有5510列保留。这样不会直接给不同原始深度加同一伪计数；零值处理仍有假设，因此比较两个方案。不同单位的距离不直接比较数值大小。
4. Spearman仅描述样本或距离的数值排序一致性，不给p值，不作Mantel、相关显著性或独立样本推断；距离共享样本。

| metric | Spearman_with_reads | Spearman_primary_vs_rarefied |
|---|---|---|
| Observed_ASVs | 0.10078 | 0.99825 |
| Shannon | 0.04846 | 1.00000 |
| Simpson | 0.04679 | 1.00000 |

| scope | method | reference | pairs | Spearman_rho | mean_absolute_difference |
|---|---|---|---|---|---|
| main29 | Bray_rarefied_mean | Bray_Curtis | 406 | 0.99999 | 0.00028 |
| main29 | Jaccard_rarefied_mean | Jaccard_binary | 406 | 0.99984 | 0.00136 |
| main29 | Hellinger | Bray_Curtis | 406 | 0.97586 | NA |
| main29 | CLR_pc05_at_min_depth | Bray_Curtis | 406 | 0.56137 | NA |
| main29 | CLR_pc1_at_min_depth | Bray_Curtis | 406 | 0.58709 | NA |
| main29 | CLR_pc05_at_min_depth | CLR_pc1_at_min_depth | 406 | 0.99821 | NA |
| main29 | Bray_global_reads_ge10 | Bray_Curtis | 406 | 0.99995 | 0.00284 |
| main29 | Jaccard_per_sample_reads_ge5 | Jaccard_binary | 406 | 0.98018 | 0.05112 |
| G4 | Bray_rarefied_mean | Bray_Curtis | 105 | 0.99997 | 0.00037 |
| G4 | Jaccard_rarefied_mean | Jaccard_binary | 105 | 0.99943 | 0.00178 |
| G4 | Hellinger | Bray_Curtis | 105 | 0.94313 | NA |
| G4 | CLR_pc05_at_min_depth | Bray_Curtis | 105 | 0.56317 | NA |
| G4 | CLR_pc1_at_min_depth | Bray_Curtis | 105 | 0.58543 | NA |
| G4 | CLR_pc05_at_min_depth | CLR_pc1_at_min_depth | 105 | 0.99762 | NA |
| G4 | Bray_global_reads_ge10 | Bray_Curtis | 105 | 0.99995 | 0.00233 |
| G4 | Jaccard_per_sample_reads_ge5 | Jaccard_binary | 105 | 0.97452 | 0.05315 |
| G5 | Bray_rarefied_mean | Bray_Curtis | 6 | 1.00000 | 0.00086 |
| G5 | Jaccard_rarefied_mean | Jaccard_binary | 6 | 1.00000 | 0.00219 |
| G5 | Hellinger | Bray_Curtis | 6 | 1.00000 | NA |
| G5 | CLR_pc05_at_min_depth | Bray_Curtis | 6 | 0.94286 | NA |
| G5 | CLR_pc1_at_min_depth | Bray_Curtis | 6 | 0.94286 | NA |
| G5 | CLR_pc05_at_min_depth | CLR_pc1_at_min_depth | 6 | 1.00000 | NA |
| G5 | Bray_global_reads_ge10 | Bray_Curtis | 6 | 1.00000 | 0.00313 |
| G5 | Jaccard_per_sample_reads_ge5 | Jaccard_binary | 6 | 0.94286 | 0.06393 |

## 四个反应器：主要特征（直接观察）

### R1

- G1_original：A0(1d) → A1(120d)；Observed 632 → 595；Shannon 4.651 → 4.488；Simpson 0.971 → 0.957。
- G2G3_postmix：A2(56d)；Observed 451；Shannon 3.324；Simpson 0.850。
- G4G5_low_DO：E1(1d) → E2(76d) → E3(145d)；Observed 458 → 447 → 463；Shannon 3.997 → 4.181 → 3.694；Simpson 0.956 → 0.962 → 0.899。
### R2

- G1_original：B0(1d) → B1(120d)；Observed 693 → 646；Shannon 4.715 → 4.524；Simpson 0.972 → 0.964。
- G2G3_postmix：B2(21d) → B3(56d)；Observed 535 → 451；Shannon 3.954 → 3.258；Simpson 0.926 → 0.854。
- G4G5_low_DO：F1(1d) → F2(30d) → F3(76d) → F4(145d)；Observed 304 → 417 → 519 → 473；Shannon 3.517 → 3.707 → 4.432 → 3.074；Simpson 0.930 → 0.921 → 0.972 → 0.785。
### R3

- G1_original：C0(1d) → C1(120d)；Observed 557 → 423；Shannon 3.335 → 3.294；Simpson 0.831 → 0.846。
- G2G3_postmix：C2(56d)；Observed 507；Shannon 3.769；Simpson 0.931。
- G4G5_low_DO：G1(1d) → G2(30d) → G3(76d) → G4(145d)；Observed 545 → 482 → 483 → 504；Shannon 4.365 → 4.006 → 3.989 → 3.943；Simpson 0.957 → 0.950 → 0.952 → 0.949。
### R4

- G1_original：D0(1d) → D1(120d)；Observed 634 → 421；Shannon 3.805 → 2.578；Simpson 0.886 → 0.683。
- G2G3_postmix：D2(21d) → D3(56d)；Observed 376 → 198；Shannon 2.684 → 0.916；Simpson 0.726 → 0.243。
- G4G5_low_DO：H1(1d) → H2(30d) → H3(76d) → H4(145d)；Observed 314 → 399 → 351 → 459；Shannon 1.905 → 3.736 → 2.545 → 3.309；Simpson 0.498 → 0.895 → 0.681 → 0.834。

## 与模块1.1/1.2的一致与不一致

- R4 G4 Competibacter为73.45 → 43.59 → 68.99 → 54.16%，Shannon为1.905 → 3.736 → 2.545 → 3.309。优势属集中与较低Alpha的描述相容，但R4不是各日最低：30d R2=3.7069低于R4=3.7360，145d R2=3.0742低于R4=3.3090；1d与76d的R4最低。G3末D3的Shannon=0.9160、Observed=198，对应Competibacter 91.06%。属级集中与ASV多样性并非同一分辨率，不作因果解释。
- R2 F3→F4（76→145d，69d间隔）ASV Bray=0.6059、Jaccard=0.6756；Shannon 4.4318→3.0742。Competibacter 16.21%→50.35%、Acinetobacter 16.56%→0.24%，与组成v2的属更替一致。ASV Bray加和分解中这两属分别贡献0.2468（40.73%）和0.0830（13.71%），不是全部变化；该分解先对每ASV取绝对差，再按原属标签求和，非仅属总量之差。
- R3后期Defluviicoccus为24.27 → 24.41 → 24.77%，30→76d及76→145d整体Bray为0.3644 → 0.2192、Jaccard为0.6942 → 0.6822。30→76d的Bray低于同期R2/R4；76→145d低于四反应器其他三者，支持这些端点间丰度加权组成相对较小变化。但Jaccard仍较高，30→76d的R3 Jaccard反而高于R2/R4；不能称整个群落成员稳定或性能稳态。
- R1的G4 Shannon先升后降，末期属级未分类比例较高并不阻断ASV Alpha/Beta计算；较高Observed不意味着均匀度更高，未分类ASV也不自动获得功能。
- GAO/PAO/AOB关联比例沿用功能v2并列入Alpha表，未重新计算功能丰度或修改映射。高GAO代理不能解释为功能增强、竞争或除磷失败；S2 PAO候选由特定菌株文献引出，仍不确证。见[module12_review.md](module12_review.md)。

## G4运行阶段的群落变化幅度

1d是保存恢复后、切换低DO前基线；后期30/76/145d为设计稳定运行期，跨基线变化还包含适应与时间效应。基线至145d均为144d间隔：

| reactor_from | day_from | day_to | interval_days | Bray_Curtis | Jaccard_binary | Bray_rarefied_mean | Hellinger | CLR_pc05_at_min_depth |
|---|---|---|---|---|---|---|---|---|
| R1 | 1 | 145 | 144 | 0.76234 | 0.75203 | 0.76277 | 1.09662 | 69.07009 |
| R2 | 1 | 145 | 144 | 0.79081 | 0.80093 | 0.79099 | 1.10887 | 71.36227 |
| R3 | 1 | 145 | 144 | 0.68366 | 0.73767 | 0.68444 | 0.92527 | 67.03078 |
| R4 | 1 | 145 | 144 | 0.46900 | 0.75121 | 0.46889 | 0.65755 | 60.88940 |

相邻实际节点如下：R1没有30d，1→76为75d；其他反应器1→30为29d、30→76为46d；所有76→145为69d。不插补，不把距离/天数当动力学速率或累计周转。

| reactor_from | day_from | day_to | interval_days | Bray_Curtis | Jaccard_binary | Hellinger | CLR_pc05_at_min_depth |
|---|---|---|---|---|---|---|---|
| R1 | 1 | 76 | 75 | 0.48651 | 0.69784 | 0.70779 | 58.55801 |
| R1 | 76 | 145 | 69 | 0.48113 | 0.62121 | 0.73840 | 56.69747 |
| R2 | 1 | 30 | 29 | 0.49954 | 0.67219 | 0.65402 | 51.93646 |
| R2 | 30 | 76 | 46 | 0.47460 | 0.68169 | 0.66845 | 58.57834 |
| R2 | 76 | 145 | 69 | 0.60595 | 0.67557 | 0.84695 | 62.31221 |
| R3 | 1 | 30 | 29 | 0.49515 | 0.64868 | 0.65177 | 53.32651 |
| R3 | 30 | 76 | 46 | 0.36441 | 0.69418 | 0.58059 | 53.58059 |
| R3 | 76 | 145 | 69 | 0.21924 | 0.68224 | 0.38452 | 48.93510 |
| R4 | 1 | 30 | 29 | 0.47387 | 0.64706 | 0.59221 | 49.49746 |
| R4 | 30 | 76 | 46 | 0.44377 | 0.63884 | 0.57315 | 50.52609 |
| R4 | 76 | 145 | 69 | 0.34338 | 0.72240 | 0.53162 | 57.15861 |

### 同期反应器之间的距离

| day_from | reactor_from | reactor_to | Bray_Curtis | Jaccard_binary |
|---|---|---|---|---|
| 1 | R1 | R2 | 0.42671 | 0.77689 |
| 1 | R1 | R3 | 0.71518 | 0.84314 |
| 1 | R1 | R4 | 0.90619 | 0.88761 |
| 1 | R2 | R3 | 0.75288 | 0.82573 |
| 1 | R2 | R4 | 0.87451 | 0.80233 |
| 1 | R3 | R4 | 0.82713 | 0.75867 |
| 30 | R2 | R3 | 0.75534 | 0.81242 |
| 30 | R2 | R4 | 0.82096 | 0.77477 |
| 30 | R3 | R4 | 0.79254 | 0.74680 |
| 76 | R1 | R2 | 0.48055 | 0.72559 |
| 76 | R1 | R3 | 0.78146 | 0.83166 |
| 76 | R1 | R4 | 0.89005 | 0.85509 |
| 76 | R2 | R3 | 0.76456 | 0.80856 |
| 76 | R2 | R4 | 0.80430 | 0.79501 |
| 76 | R3 | R4 | 0.81654 | 0.77353 |
| 145 | R1 | R2 | 0.77744 | 0.75200 |
| 145 | R1 | R3 | 0.78252 | 0.79426 |
| 145 | R1 | R4 | 0.85867 | 0.81338 |
| 145 | R2 | R3 | 0.80077 | 0.76485 |
| 145 | R2 | R4 | 0.43551 | 0.77368 |
| 145 | R3 | R4 | 0.65083 | 0.72112 |

R2–R4 Bray在1/30/76/145d为0.8745 → 0.8210 → 0.8043 → 0.4355，支持末段丰度加权组成趋近；但Jaccard为0.8023 → 0.7748 → 0.7950 → 0.7737，不支持相同程度的成员趋同。R1–R2在1/76/145d Bray为0.4267 → 0.4805 → 0.7774，末段分化。不能宣称所有反应器总体趋同。

当日所有已观测对均值（30d只有3对，其他6对，不能直接视为相同覆盖）：

| day_from | Bray_Curtis |
|---|---|
| 1 | 0.75043 |
| 30 | 0.78961 |
| 76 | 0.75624 |
| 145 | 0.71762 |

所有日均可用的R2/R3/R4三对Bray均值：

| day_from | Bray_Curtis |
|---|---|
| 1 | 0.81817 |
| 30 | 0.78961 |
| 76 | 0.79513 |
| 145 | 0.62904 |

距离共享样本，均值不是独立重复的统计量；不同指标给出的趋近/分化含义必须限定。

## G5：同母样四个粒径级分

| short | particle_size_fraction_um | reads | Observed_ASVs | Shannon | Simpson | Chao1_bias_corrected | Observed_ASVs_rarefied_mean | Shannon_rarefied_mean |
|---|---|---|---|---|---|---|---|---|
| S1 | <100 | 43146 | 403 | 3.85581 | 0.92294 | 403.00 | 399.70 | 3.85394 |
| S2 | 100–200 | 43812 | 465 | 4.23788 | 0.95278 | 465.00 | 460.61 | 4.23587 |
| S3 | 200–500 | 40169 | 497 | 4.34086 | 0.96100 | 497.00 | 494.60 | 4.33861 |
| S4 | >500 | 44760 | 491 | 4.34413 | 0.96280 | 491.04 | 487.48 | 4.34161 |

S1–S4 Shannon为3.85581 → 4.23788 → 4.34086 → 4.34413；S3与S4只差0.00327，不能将细微排序解释为普遍粒径效应。Observed最高为S3（497），并非随粒径单调增加。

| sample_a | sample_b | Bray_Curtis | Jaccard_binary | Bray_rarefied_mean | Hellinger | CLR_pc05_at_min_depth |
|---|---|---|---|---|---|---|
| Batch_01_S1 | Batch_01_S2 | 0.61974 | 0.68085 | 0.62036 | 0.92763 | 64.26721 |
| Batch_01_S1 | Batch_01_S3 | 0.58187 | 0.64048 | 0.58235 | 0.84218 | 59.21565 |
| Batch_01_S1 | Batch_01_S4 | 0.61423 | 0.66964 | 0.61490 | 0.91260 | 65.15238 |
| Batch_01_S2 | Batch_01_S3 | 0.38300 | 0.54902 | 0.38404 | 0.49799 | 48.10986 |
| Batch_01_S2 | Batch_01_S4 | 0.43464 | 0.55589 | 0.43570 | 0.58395 | 52.83430 |
| Batch_01_S3 | Batch_01_S4 | 0.25762 | 0.53846 | 0.25888 | 0.43055 | 47.56167 |

Bray最近为S3–S4、最远为S1–S2，仅指这次母样四组分。G5单独PCoA，坐标与主29不能直接叠加；不能由级分等权均值重建母样。无母样间重复，不做粒径显著性检验，也不能分离筛分处理和18d延长运行的作用。

## 敏感性结论与适用范围

主29等深度敏感性与原Bray的Spearman=0.999994，平均绝对距离差=0.000279；与原Jaccard的Spearman=0.999837、平均差=0.001357。当前深度范围内大尺度结论对该子抽样较稳健，但这不证明无测序/扩增偏倚。
主29 Hellinger与Bray秩相关0.9759，而CLR伪计数0.5/1与Bray只有0.5614/0.5871；两个CLR方案之间为0.9982。组成权重改变后全局距离排序明显不同，不能把Bray稳定性泛化为对所有组成方法稳健。G4对应Hellinger/Bray=0.9431、CLR0.5/Bray=0.5632。
R3后期Bray较小主要反映丰度加权组成；成员检出或log-ratio距离下不能直接得出同样稳定排名。G5 S3/S4 Shannon细微差异也不应被写成有重复支持的结论。子抽样2.5%/97.5%是抽样随机性范围，不是生物学置信区间。

## 直接观察、未验证假设与下一步非典型候选筛选

直接观察为ASV检出数、比例、Alpha及端点距离。低DO选择、粒径微环境、碳储存竞争和功能冗余只是未经验证假设；单属持续、Bray较小或PCoA靠近均不证明性能稳态、代谢活性或因果机制。
下一步可从原ASV的检出率、相对比例及同一运行实体实际节点持续性提出候选；阈值须事先说明并做敏感性，不按预期功能调筛选结果。保留未分类ASV和标签不确定性；回查代表序列区域/长度、参考数据库后缀语义、参考序列比对与系统发育、物种/菌株功能原研究，以及可追溯的运行性能/采样处理证据。
短16S仍不能证明项目功能基因或活性；没有基因组/细胞特异表型/活性等证据则维持候选。跨轮次相关记录和单母样不算独立复现；当前不安排新独立实验，不能补造验证。分类相对比例不等同绝对生物量。

## 实际程序检查

| status | item | evidence |
|---|---|---|
| PASS | 环境 | 复用现有R环境，不安装/更新软件。 |
| PASS | 输入存在 | results/phyloseq/batch_01_phyloseq.rds; data/asv_table.tsv; data/taxonomy.tsv; data/exported_sequences/dna-sequences.fasta; metadata/source_sample_metadata.tsv; results/community_composition/2026-11-03_v2/analysis_metadata.tsv; results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv; results/community_composition/2026-11-03_v2/analysis_report.md; results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv; results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv; results/functional_guilds/2026-11-03_v2/functional_taxa_abundance.tsv; results/functional_guilds/2026-11-03_v2/functional_guild_abundance.tsv; results/functional_guilds/2026-11-03_v2/analysis_report.md; scripts/functional_guilds.R; docs/batch_01/experiment_design.md; docs/batch_01/analysis_plan.md; docs/research_context.md; AGENTS.md; logs/taxonomy/inputs.json |
| PASS | v2基线锁定 | 计算输入仅取群落v2/功能v2；RDS、原count/taxonomy、原metadata、派生metadata及属矩阵SHA-256均匹配功能v2报告。没有读取被删除模块1.3结果。 |
| PASS | 已有对象来源 | 对象原count未变换，三个原输入指纹匹配；按v2报告核验兼容复用，不重建对象。 |
| PASS | 计算输入断言 | 5510×33原始非负整数count与RDS逐格一致；ID唯一、无NA和空样本；不重复上游深度异常筛查。 |
| PASS | metadata身份 | v2派生表与现有对象一致；原33×14列逐值保留。 |
| PASS | 设计名单门控 | 与设计文档逐模块核对33个完整ID，8/2/4/15/4；来源字段回查已确认文档，不按名称/目录猜组。 |
| PASS | 时间/单位门控 | G4四基线+11后期，R1缺30d；G5同母样；保留已确认轮次、混合谱系、保存恢复和重复时间点。 |
| WARNING | 推断门控关闭 | 主29记录不独立、共享来源与重复测量、DO/阶段/时间混杂；G5一母样四级分。只描述，不做显著性/网络/因果分析。 |
| WARNING | DO与稳态 | 设计确认G4基线是恢复设置3且切换低DO前；继承v2分析字段NA、design_document字段3差异保留。全部瞬时实测NA；后期设计稳定运行期不等于性能稳态已验证。 |
| PASS | 定向分类来源 | 全部5510 ASV原谱系/置信度与taxonomy一致；四份功能v2表均实际读取。 |
| PASS | 功能边界 | Thauera/Acinetobacter/Dechloromonas不进保守PAO，Nitrospira功能歧义、Brocadia--other分类受限；原映射不变。 |
| PASS | Alpha公式 | Observed=count>0；Shannon自然log；Simpson=1−Σp²；Chao1偏差校正与vegan接口一致。 |
| WARNING | Chao1适用性 | 原去噪count的f1=0–6、f2=23–118；可以计算但单例贫化，不能可靠估计真实总丰富度，不以接近Observed证明取样饱和。 |
| PASS | Beta独立公式 | Bray=相对组成L1/2、二元Jaccard=1−交集/并集；完整33×33、对称、零对角、范围[0,1]。 |
| PASS | 等深度敏感性 | 仅内存不放回子抽样：31457 reads×100次，seed=20261104；全部33样本保留，主分析不抽稀。 |
| PASS | 敏感性完整性 | 保存全部528对主/敏感性距离及子抽样分位数；可恢复任意子集矩阵。 |
| PASS | main29 PCoA全轴重构 | 原负特征值3、Lingoes常数0.0209916448741；全部正轴重构校正距离误差<1e-8。 |
| PASS | G5 PCoA全轴重构 | 原负特征值0、Lingoes常数0；全部正轴重构校正距离误差<1e-8。 |
| PASS | 变化幅度门控 | G4 11个相邻实际节点+11个基线至后期、21个同期反应器对；仅同轮时间转移，不插补，不跨保存恢复连接。 |
| PASS | alpha_diversity.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | bray_curtis_distance.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | jaccard_distance.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | pcoa_coordinates.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | pcoa_eigenvalues.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | G4_within_reactor_changes.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | G4_same_day_between_reactors.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | continuous_run_transitions.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | pairwise_sensitivity.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | sensitivity_summary.tsv 回读 | 行数/字段/全部数值列往返一致。 |
| PASS | R1_alpha_trajectories 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | R2_alpha_trajectories 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | R3_alpha_trajectories 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | R4_alpha_trajectories 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G4_shannon_trajectories 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | main29_bray_pcoa 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G5_bray_pcoa 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G4_adjacent_changes 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G4_between_reactor_distances 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G5_alpha_diversity 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | G4_function_diversity_comparison 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| PASS | depth_sensitivity 图层 | 实际构建绘图层，仅真实观测；无检验标记。 |
| WARNING | 组成与检出敏感性 | CLR与Bray的全局秩一致性仅中等，成员Jaccard和丰度Bray可给不同稳定描述；CLR零值处理仍是分析假设，不宣称全方法稳健。 |
| WARNING | 距离与功能边界 | 距离共享样本、前两轴仅投影、端点差非累计周转；功能属比例与ASV多样性分辨率不同，不能做功能活性/因果/绝对丰度解释。 |
| WARNING | 批次与抽样限制 | 本批未知提取/PCR/测序子批次效应不能分离；子抽样范围非生物置信区间，不能消除扩增与16S拷贝数偏倚。 |
| PASS | 输入及有效结果保护 | 60个原始输入、设计、有效v2产物和脚本指纹不变；RDS/metadata/旧结果均不覆盖。 |

## 最终文件与图件

- alpha_diversity.tsv：33行Alpha、reads、单/双例、功能关联比例及深度敏感性。
- bray_curtis_distance.tsv / jaccard_distance.tsv：完整33×33原始矩阵，sample_id列为行标识。
- pcoa_coordinates.tsv / pcoa_eigenvalues.tsv：主29/G5分基底，全部正轴和原/校正谱，不适用高轴为NA。
- G4_within_reactor_changes.tsv：11相邻实际节点+11基线至后期及真实间隔；G4_same_day_between_reactors.tsv：21个同期反应器对。
- continuous_run_transitions.tsv：4个G1前后及2个G2→G3同轮比较；pairwise_sensitivity.tsv：528对完整主/敏感性距离；sensitivity_summary.tsv：主29/G4/G5分别汇总。
- R1–R4_alpha_trajectories、G4_shannon_trajectories、main29_bray_pcoa、G5_bray_pcoa、G4_adjacent_changes、G4_between_reactor_distances、G5_alpha_diversity、G4_function_diversity_comparison、depth_sensitivity：12组PDF/PNG。
- module12_review.md：简短解释审核及ASV证据附录；analysis_report.md及run.log：综合报告与实际运行记录。

## 科学局限

G1、G2/G3和G4的轮次不同，混合均分、保存59d和恢复构成来源依赖；不跨轮次当连续独立序列。G4缺R1-30d、不平衡取样且有重复测量；G5一母样每级分一份。采样瞬时环境未知，提取/PCR/测序子批次效应不可分离，阶段DO/时间/接种历史混杂，稳态性能记录未审阅。16S扩增、拷贝数和检测差异仍在。
未执行无约束PERMANOVA、ANOVA、共现网络、因果或未经设计支持的独立样本检验。相对比例不是绝对生物量；功能关联不是活性证据。描述性PASS不表示推断前提通过。

## 复现及输入指纹

命令：`Rscript --vanilla scripts/diversity_analysis.R`；默认输出results/diversity/2026-11-04_v2。重跑须以`--output-dir 尚不存在的新版本目录`指定，已有目录拒绝覆盖，禁止输出到已撤回v1。无需磁盘中间文件。
脚本SHA-256：480388c82ff45e82ce1097b15b8b7c5057d7cd5ddedecc4583f48d82485a335d

| input | path | bytes | sha256 |
|---|---|---|---|
| object | results/phyloseq/batch_01_phyloseq.rds | 1031084 | b357e780aff2b9dcfb4c716c89c359de235eb98c165d3cf50d547af6be3eaa30 |
| asv | data/asv_table.tsv | 919190 | 3c4a93ba2b1b020bf9890cb37d1a47fc8b3698a241aeeb50e1988d07e72e3006 |
| taxonomy | data/taxonomy.tsv | 884530 | b990e48bc72a21928e0d74f179603994ff6a1a1a2014f499484b3afb95dbb867 |
| sequences | data/exported_sequences/dna-sequences.fasta | 2489323 | a81b33262ea18ab421aa8dfbb2fcb0ac1eef892dc9a1b48a3e6c3f3abf240b7b |
| source_metadata | metadata/source_sample_metadata.tsv | 8918 | dc506a05f5a3b836da45afc3cb744feeddf763aa4455551dd80bddc44668a59a |
| metadata | results/community_composition/2026-11-03_v2/analysis_metadata.tsv | 27015 | f3660d665c80c980fd2ded9f4f7080af2cbe6a7bdaab6d5f46ce2cd5d393bdbd |
| genus | results/community_composition/2026-11-03_v2/genus_relative_abundance.tsv | 252609 | 4f1477feb2bdd702c0b72a44154069bfaa65f82dd84eff4e2ea78221ea19a0ad |
| report11 | results/community_composition/2026-11-03_v2/analysis_report.md | 32050 | d3e544e04a0e406257e38a3a3d3a15d3d567e7a459348c3d3b8112c969ef4cc3 |
| annotation | results/functional_guilds/2026-11-03_v2/functional_asv_annotation.tsv | 2204115 | 05d9a986426e1054eabb0093870dc9078dbd98ac5361f55e7dc0e5ff147240b2 |
| evidence | results/functional_guilds/2026-11-03_v2/functional_mapping_evidence.tsv | 14112 | a7e1ba4d01fe23716f68460b471c08212d9ff646e54301cca78aa76f40fc7036 |
| taxa | results/functional_guilds/2026-11-03_v2/functional_taxa_abundance.tsv | 120604 | c1f3bf03023cf5387012a27c921e1ec17d1da320726ab9d7d038b144077048fd |
| guild | results/functional_guilds/2026-11-03_v2/functional_guild_abundance.tsv | 6313 | 54ac8837215565f008f017b07691af35633d796cbc1be600f15dd421204ca63e |
| report12 | results/functional_guilds/2026-11-03_v2/analysis_report.md | 31499 | ee3315294b322075ec8cecaa6161d2a9fdb8b9924e1d5f5ee20dc661e61d4ea1 |
| functional_script | scripts/functional_guilds.R | 56135 | e66afaa7e27d5d92e9b6a79fa4f50260aa0ec6207455accd481c2300ace9d957 |
| design | docs/batch_01/experiment_design.md | 15084 | 9d018483c04f68ec156a0a378ca75c7be1406587cb936d7b6983909abd1e75a9 |
| plan | docs/batch_01/analysis_plan.md | 11043 | 93135a524706432a24f23ab637c410883f540ecfc5449e92c7940b13cba456a5 |
| context | docs/research_context.md | 1332 | 68604f079bba630e322104e2383f088ac51ae02431a953be8aa2f98ba6bf2017 |
| rules | AGENTS.md | 8741 | 0768e5bfefcb71305748f24772e12f60c42ada52f5197b821dd314cf044a183c |
| taxonomy_parameters | logs/taxonomy/inputs.json | 1427 | 2937d9b59781f252688bdbbd9812a8cc5f904b44afc1aff039d64e1e3709df9c |

| package | version |
|---|---|
| phyloseq | 1.54.0 |
| vegan | 2.7.3 |
| ggplot2 | 4.0.3 |
| digest | 0.6.39 |

```
R version 4.5.2 (2025-10-31)
RNGkind: Mersenne-Twister / Inversion / Rejection
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
 [1] generics_0.1.4      stringi_1.8.7       lattice_0.22-9     
 [4] digest_0.6.39       magrittr_2.0.5      grid_4.5.2         
 [7] RColorBrewer_1.1-3  iterators_1.0.14    foreach_1.5.2      
[10] plyr_1.8.9          jsonlite_2.0.0      Matrix_1.7-5       
[13] ape_5.8-1           survival_3.8-9      mgcv_1.9-4         
[16] scales_1.4.0        permute_0.9-10      Biostrings_2.78.0  
[19] textshaping_1.0.5   codetools_0.2-20    ade4_1.7-24        
[22] cli_3.6.6           rlang_1.3.0         crayon_1.5.3       
[25] XVector_0.50.0      Biobase_2.70.0      splines_4.5.2      
[28] withr_3.0.3         vegan_2.7-3         tools_4.5.2        
[31] parallel_4.5.2      reshape2_1.4.5      phyloseq_1.54.0    
[34] dplyr_1.2.1         Rhdf5lib_1.32.0     multtest_2.66.0    
[37] BiocGenerics_0.56.0 vctrs_0.7.3         R6_2.6.1           
[40] stats4_4.5.2        lifecycle_1.0.5     rhdf5_2.54.1       
[43] Seqinfo_1.0.0       stringr_1.6.0       biomformat_1.38.0  
[46] S4Vectors_0.48.0    IRanges_2.44.0      MASS_7.3-66        
[49] ragg_1.5.2          cluster_2.1.8.2     pkgconfig_2.0.3    
[52] pillar_1.11.1       gtable_0.3.6        glue_1.8.1         
[55] data.table_1.18.4   Rcpp_1.1.2          systemfonts_1.3.2  
[58] tibble_3.3.1        tidyselect_1.2.1    rhdf5filters_1.22.0
[61] farver_2.1.2        igraph_2.3.3        nlme_3.1-170       
[64] labeling_0.4.3      compiler_4.5.2      S7_0.2.2           
```
完成时间：2026-11-04 15:53:31；计时秒：27.432


## 2026-11-04 交付独立核验（主流程40/6/0之外另列）

- PASS：Python标准库从原ASV count独立实现33样本Observed/Shannon/Simpson/偏差校正Chao1及全部Bray/Jaccard距离，与R结果最大偏差4.55×10^-13；未重跑上游QC/分类器。
- PASS：从导出的PCoA所有有效坐标轴独立重构两套校正距离，最大偏差1.67×10^-15；核对G4 22项反应器内、21项同期距离和6项同轮转移的ID、距离及真实日数间隔。
- PASS：全部528对Hellinger及两种共同深度CLR距离独立复核，最大误差<1×10^-9。主分析未抽稀，功能丰度/映射直接沿用v2。
- PASS：全部12 PNG通过逐块CRC及IDAT像素流解压，12 PDF文件头/EOF完整。已实际打开主29 PCoA、R2 Alpha、G4相邻变化/G4 Shannon、G5 Alpha/PCoA；此前也已打开有效功能v2 G4独立纵轴图。
- WARNING（展示）：主29 PCoA部分相近点标签重叠，G4 Shannon的30d F2/H2标签接近；全部精确ID和坐标/Alpha可查TSV。没有据标签拥挤删除样本、修改数值或更改分组。PCoA二维邻近不能代替完整距离。
- PASS：已有v2目录再次执行在创建/写入前非零退出，原37文件指纹全部不变。任务前102个原始输入、上游各版本、对象、既有脚本及设计文件SHA-256全部保持；按用户授权删除的仅是本次模块1.3初次v1目录。
- PASS：README、累计结果解释和分析日志已同步v2入口、实际发现与局限。历史日志保留并追加撤回/删除记录，旧模块1.3不再作为有效结果。
- 软件提示：执行器stderr中观察到Fontconfig初始化提示（`using without calling FcInit()`），R的sink未捕获该底层提示，现按实际执行输出补录到run.log；本次未观察到timedatectl提示。计算与文件核验通过，无软件安装或更新。

交付时间：2026-11-04 15:58:06（Asia/Shanghai）；最终脚本SHA-256仍为480388c82ff45e82ce1097b15b8b7c5057d7cd5ddedecc4583f48d82485a335d。
