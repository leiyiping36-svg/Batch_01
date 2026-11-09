# 模块1.2定向解释复核（基于有效v2，2026-11-04）

仅审核functional_guilds/2026-11-03_v2四表、原taxonomy/count及绘图代码；未修改功能映射或重新计算功能丰度。结论如下，ASV证据列于附录。

- S2 Thauera=20.8413%，PAO_genus_candidate=20.8664%（其余候选合计0.0251个百分点）。Thauera证据来自SND5特定菌株，不能当成本批已确认PAO，也不能据该文归入确定AOB。[Wang & He 2020原研究摘要](https://pubmed.ncbi.nlm.nih.gov/32823196/)。
- 三个Brocadia--other ASV的完整原谱系、置信度及原始reads分布见附录A。参数日志记录分类confidence阈值0.7及silva144-2026.7-full-length.qza；未重新读取外部分类库，--other语义及参考序列匹配未核实。高分类器置信度不能消除原标签的限制：当前只保留相关谱系候选，不升级为无后缀Brocadia属确证或AnAOB活性。
- 18个Nitrospira ASV完整分类信息见附录B。保留NOB/comammox歧义，不计入保守AOB/NOB。[Daims et al. 2015原研究](https://doi.org/10.1038/nature16461)。
- Acinetobacter 171个ASV、Dechloromonas 4个ASV继续单列PAO_ambiguous。Acinetobacter部分储磷分离株不符合典型EBPR生理模型，但不能反向断言该属毫无除磷能力（[原研究摘要](https://iris.uniroma1.it/handle/11573/78628)）；Dechloromonas的FISH-Raman/基因组证据针对研究物种，不支持由短16S属注释确证本批所有ASV功能（[原研究](https://www.nature.com/articles/s41396-021-01029-2)）。
- 文献于本次2026-11-04定向检索原研究摘要或可访问原文内容；非系统综述、非本批功能测定，未编造新功能。
- G4图代码facet_wrap(scales='free_y')：每面板独立纵轴。不能跨面板按曲线高度判断丰度/变化幅度；下列实际最大百分比可避免放大极低丰度的误读，零值面板不作变化解释。

| genus | G4_max_percent |
|---|---|
| Candidatus_Obscuribacter | 0.00000 |
| Candidatus_Nitrosymbiomonas | 0.00714 |
| Propionivibrio--other | 0.00999 |
| Candidatus_Brocadia--other | 0.01902 |
| Candidatus_Contendibacter | 0.03592 |
| Amaricoccus | 0.04494 |
| Thauera | 0.08463 |
| Candidatus_Accumulibacter | 0.14305 |
| CCM19a | 0.23003 |
| Nitrospira | 0.95194 |
| Dechloromonas | 2.53165 |
| Nitrosomonas | 2.68808 |
| Defluviicoccus | 24.76785 |
| Acinetobacter | 39.60644 |
| Candidatus_Competibacter | 73.45159 |

## Competibacter与Defluviicoccus的反应器/样本贡献

百分比的分母为全部ASV reads；C_share_GAO和D_share_GAO分母为已有GAO关联保守代理，仅为读数比例贡献，不是过程贡献。逐样本列出以保留轮次和不同节点，不混合算独立重复均值。

| sample_id | group | reactor | day | Competibacter_percent | Defluviicoccus_percent | GAO_proxy_percent | C_share_GAO_percent | D_share_GAO_percent |
|---|---|---|---|---|---|---|---|---|
| Batch_01_A0 | G1 | R1 | 1 | 2.15962 | 25.54773 | 27.70736 | 7.79441 | 92.20559 |
| Batch_01_A1 | G1 | R1 | 120 | 1.19909 | 18.44528 | 19.64437 | 6.10400 | 93.89600 |
| Batch_01_A2 | G3 | R1 | 56 | 0.65006 | 19.56219 | 20.21225 | 3.21616 | 96.78384 |
| Batch_01_B0 | G1 | R2 | 1 | 2.93396 | 26.60007 | 29.53404 | 9.93418 | 90.06582 |
| Batch_01_B1 | G1 | R2 | 120 | 10.08017 | 15.43016 | 25.51033 | 39.51408 | 60.48592 |
| Batch_01_B2 | G2 | R2 | 21 | 4.42744 | 15.30193 | 19.72937 | 22.44086 | 77.55914 |
| Batch_01_B3 | G3 | R2 | 56 | 1.74683 | 18.39323 | 20.14006 | 8.67340 | 91.32660 |
| Batch_01_C0 | G1 | R3 | 1 | 42.48921 | 4.01382 | 48.62958 | 87.37317 | 8.25386 |
| Batch_01_C1 | G1 | R3 | 120 | 39.58523 | 4.66989 | 44.27203 | 89.41362 | 10.54818 |
| Batch_01_C2 | G3 | R3 | 56 | 19.11063 | 1.81476 | 20.92539 | 91.32747 | 8.67253 |
| Batch_01_D0 | G1 | R4 | 1 | 34.63418 | 1.95013 | 38.85413 | 89.13900 | 5.01910 |
| Batch_01_D1 | G1 | R4 | 120 | 56.10579 | 1.92840 | 58.03420 | 96.67713 | 3.32287 |
| Batch_01_D2 | G2 | R4 | 21 | 55.48761 | 1.47743 | 56.96504 | 97.40642 | 2.59358 |
| Batch_01_D3 | G3 | R4 | 56 | 91.06334 | 0.48720 | 91.55053 | 99.46784 | 0.53216 |
| Batch_01_E1 | G4 | R1 | 1 | 0.19631 | 14.38471 | 14.58102 | 1.34631 | 98.65369 |
| Batch_01_E2 | G4 | R1 | 76 | 1.00444 | 10.01494 | 11.01938 | 9.11523 | 90.88477 |
| Batch_01_E3 | G4 | R1 | 145 | 2.77337 | 8.53151 | 11.30488 | 24.53254 | 75.46746 |
| Batch_01_F1 | G4 | R2 | 1 | 3.31882 | 17.39835 | 20.71717 | 16.01964 | 83.98036 |
| Batch_01_F2 | G4 | R2 | 30 | 5.12570 | 21.43605 | 26.57366 | 19.28866 | 80.66655 |
| Batch_01_F3 | G4 | R2 | 76 | 16.20777 | 13.67356 | 29.88133 | 54.24046 | 45.75954 |
| Batch_01_F4 | G4 | R2 | 145 | 50.34763 | 12.09822 | 62.48177 | 80.57970 | 19.36280 |
| Batch_01_G1 | G4 | R3 | 1 | 1.21742 | 6.75767 | 7.97509 | 15.26531 | 84.73469 |
| Batch_01_G2 | G4 | R3 | 30 | 14.28571 | 24.26681 | 38.56351 | 37.04464 | 62.92686 |
| Batch_01_G3 | G4 | R3 | 76 | 8.05371 | 24.40716 | 32.48162 | 24.79467 | 75.14145 |
| Batch_01_G4 | G4 | R3 | 145 | 10.30259 | 24.76785 | 35.09670 | 29.35486 | 70.57031 |
| Batch_01_H1 | G4 | R4 | 1 | 73.45159 | 1.46235 | 74.91394 | 98.04796 | 1.95204 |
| Batch_01_H2 | G4 | R4 | 30 | 43.59487 | 6.87210 | 50.46696 | 86.38298 | 13.61702 |
| Batch_01_H3 | G4 | R4 | 76 | 68.99428 | 2.54682 | 71.54111 | 96.44006 | 3.55994 |
| Batch_01_H4 | G4 | R4 | 145 | 54.15696 | 6.80729 | 60.96425 | 88.83397 | 11.16603 |
| Batch_01_S1 | G5 | R1 | 163 | 5.31220 | 8.85598 | 14.16817 | 37.49387 | 62.50613 |
| Batch_01_S2 | G5 | R1 | 163 | 4.01260 | 1.35123 | 5.57153 | 72.01966 | 24.25236 |
| Batch_01_S3 | G5 | R1 | 163 | 7.44853 | 4.42630 | 12.36277 | 60.24970 | 35.80346 |
| Batch_01_S4 | G5 | R1 | 163 | 1.79178 | 7.35702 | 9.17113 | 19.53715 | 80.21924 |

## 附录A：三个Brocadia--other ASV（未列样本reads=0）

- `9435707aeca8730ac7a56389a42f6448`；分类置信度=0.794858128977309；总reads=651；检出样本数=3。
  原谱系：`d__Bacteria;k__Pseudomonadati--other;p__Planctomycetota;c__Candidatus_Brocadiia;o__Candidatus_Brocadiales;f__Candidatus_Brocadiaceae;g__Candidatus_Brocadia--other`。
  原始reads：S2=59; S3=124; S4=468。
- `3d0873bf99e94819008a4c5b23a8460e`；分类置信度=0.999953400182971；总reads=129；检出样本数=4。
  原谱系：`d__Bacteria;k__Pseudomonadati--other;p__Planctomycetota;c__Candidatus_Brocadiia;o__Candidatus_Brocadiales;f__Candidatus_Brocadiaceae;g__Candidatus_Brocadia--other`。
  原始reads：S1=12; S2=8; S3=29; S4=80。
- `681476f364273def25547ee1591fb0a4`；分类置信度=0.999945041686961；总reads=15；检出样本数=2。
  原谱系：`d__Bacteria;k__Pseudomonadati--other;p__Planctomycetota;c__Candidatus_Brocadiia;o__Candidatus_Brocadiales;f__Candidatus_Brocadiaceae;g__Candidatus_Brocadia--other`。
  原始reads：E3=9; G4=6。

## 附录B：18个Nitrospira ASV

| feature_id | original_taxonomy | classifier_confidence | total_reads | detected_samples |
|---|---|---|---|---|
| f81f63bb4135de8eabb5f63dfe46b8bf | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9999988 | 8820 | 31 |
| 2e2e790197ed90564a4caa7fdb740c9e | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9999991 | 766 | 11 |
| 5b0e6258f9d80d56b059e4b56d0ed942 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9999998 | 186 | 7 |
| 4815692bdc88b460eb377a39c42060ba | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9386019 | 11 | 1 |
| 02c871945a2486df2136c36b506cb639 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9921855 | 5 | 1 |
| 12dbe327d58faad656fefc79c899f587 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9610964 | 3 | 1 |
| f6c88bb1b9fb6a46c0a8fd813e44727c | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9996912 | 3 | 1 |
| a6911f4f5e580d019803735cf7d8fdf6 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9994273 | 3 | 1 |
| 9d6977d5fdd81b4c41d5b4fc99e8e27b | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9999425 | 3 | 1 |
| 60caa1b3386aefa7c738596b100e6bb3 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.8643665 | 3 | 1 |
| 73bce2b5de54b19748ecaa624402c581 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9999808 | 3 | 1 |
| fcce61e567177826aa37bb0e6729e70c | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9821883 | 3 | 1 |
| fd4ca7a2ac98934795ddec44bd2e3307 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.8204187 | 3 | 1 |
| 9387539b1255ff10d823a6c3a119bdc0 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9804238 | 2 | 1 |
| 39dcfb7fd1d19705a467e3d3584e048a | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9252393 | 2 | 1 |
| 1eba03019a9f005392cfe530fa0fb6b1 | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9850993 | 2 | 1 |
| add77f843fe870a59ccfbbc28af6e2ae | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.8145892 | 2 | 1 |
| e49dfceb1c6e67c9dbf233c13ac5926e | d__Bacteria;k__Pseudomonadati--other;p__Nitrospirota;c__Nitrospiria;o__Nitrospirales;f__Nitrospiraceae;g__Nitrospira | 0.9442062 | 2 | 1 |

审核结论：PASS（原映射边界保持）；WARNING（菌株/功能证据及--other语义不足、图轴独立）；不新增功能赋值。


补充展示说明：最大丰度表也列入CCM19a、Nitrosymbiomonas两个目标功能未核实标签作为背景；它们不是原G4逐属趋势图的13个已审阅面板之一，也未因此新赋功能。原图已实际打开核对；纵轴独立，极低丰度与全零面板不按图高解释。
