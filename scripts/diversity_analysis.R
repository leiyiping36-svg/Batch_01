#!/usr/bin/env Rscript
# Valid module 1.1/1.2 v2 inputs only; module 1.3 output defaults to v2.
# Rscript --vanilla scripts/diversity_analysis.R [--output-dir NEW_DIRECTORY]
main <- function() {
  Sys.setenv(TZ="Asia/Shanghai"); started <- Sys.time()
  script <- normalizePath(sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE)))
  root <- dirname(dirname(script)); setwd(root)
  args <- commandArgs(trailingOnly=TRUE); out <- "results/diversity/2026-11-04_v2"
  if(length(args)) {stopifnot(length(args)==2,args[1]=="--output-dir"); out<-args[2]}
  if(grepl("_v1(/|$)",out)) stop("用户已撤回模块1.3 v1；禁止向v1输出。")
  if(file.exists(out)) stop("输出目录已存在，禁止覆盖；请指定尚不存在的新版本。")
  stopifnot(dir.create(out,recursive=TRUE)); out<-normalizePath(out)
  log <- file(file.path(out,"run.log"),"wt",encoding="UTF-8")
  sink(log,split=TRUE); sink(log,type="message"); options(warn=1)
  on.exit({sink(type="message");sink();close(log)},add=TRUE)
  stamp <- function() format(Sys.time(),"%Y-%m-%d %H:%M:%S",tz="Asia/Shanghai")
  cat("START",stamp(),"Asia/Shanghai\n",paste(commandArgs(),collapse=" "),"\n")
  checks<-data.frame(status=character(),item=character(),evidence=character())
  add<-function(s,i,e) {checks[nrow(checks)+1L,]<<-c(s,i,e);cat(s,i,":",e,"\n")}
  need<-function(ok,i,e) {add(if(isTRUE(ok)) "PASS" else "FAIL",i,e);if(!isTRUE(ok))stop(paste(i,e,sep=": "))}
  rd<-function(p,...)read.delim(p,check.names=FALSE,quote="",comment.char="",...)
  append<-function(p,lines) {con<-file(p,"at",encoding="UTF-8");tryCatch(writeLines(c("",lines),con,useBytes=TRUE),finally=close(con))}
  md<-function(d,digits=5) {
    if(!nrow(d))return("（无）")
    d[]<-lapply(d,function(v){if(is.numeric(v))v<-format(round(v,digits),trim=TRUE,scientific=FALSE);v<-as.character(v);v[is.na(v)]<-"NA";gsub("|","/",v,fixed=TRUE)})
    c(paste0("| ",paste(names(d),collapse=" | ")," |"),paste0("|",paste(rep("---",ncol(d)),collapse="|"),"|"),
      apply(d,1,function(v)paste0("| ",paste(v,collapse=" | ")," |")))
  }
  put<-function(d,name) {
    p<-file.path(out,name);stopifnot(!file.exists(p));write.table(d,p,sep="\t",quote=FALSE,row.names=FALSE,na="NA")
    z<-rd(p);stopifnot(nrow(z)==nrow(d),identical(names(z),names(d)))
    for(nm in names(d)[vapply(d,is.numeric,logical(1))])stopifnot(isTRUE(all.equal(as.numeric(d[[nm]]),as.numeric(z[[nm]]),tolerance=1e-12)))
    need(TRUE,paste(name,"回读"),"行数/字段/全部数值列往返一致。")
  }
  report_path<-file.path(out,"analysis_report.md")
  tryCatch({
    packages<-c("phyloseq","vegan","ggplot2","digest")
    need(all(vapply(packages,requireNamespace,logical(1),quietly=TRUE)),"环境","复用现有R环境，不安装/更新软件。")
    suppressPackageStartupMessages(library(ggplot2))
    b11<-"results/community_composition/2026-11-03_v2";b12<-"results/functional_guilds/2026-11-03_v2"
    paths<-c(object="results/phyloseq/batch_01_phyloseq.rds",asv="data/asv_table.tsv",taxonomy="data/taxonomy.tsv",
      sequences="data/exported_sequences/dna-sequences.fasta",source_metadata="metadata/source_sample_metadata.tsv",
      metadata=file.path(b11,"analysis_metadata.tsv"),genus=file.path(b11,"genus_relative_abundance.tsv"),
      report11=file.path(b11,"analysis_report.md"),annotation=file.path(b12,"functional_asv_annotation.tsv"),
      evidence=file.path(b12,"functional_mapping_evidence.tsv"),taxa=file.path(b12,"functional_taxa_abundance.tsv"),
      guild=file.path(b12,"functional_guild_abundance.tsv"),report12=file.path(b12,"analysis_report.md"),
      functional_script="scripts/functional_guilds.R",design="docs/batch_01/experiment_design.md",plan="docs/batch_01/analysis_plan.md",
      context="docs/research_context.md",rules="AGENTS.md",taxonomy_parameters="logs/taxonomy/inputs.json")
    need(all(file.exists(paths)),"输入存在",paste(paths,collapse="; "))
    sha<-function(p)digest::digest(file=p,algo="sha256");fingerprints<-vapply(paths,sha,character(1))
    upstream_report<-readLines(paths["report12"],warn=FALSE)
    linked<-c("object","asv","taxonomy","source_metadata","metadata","genus")
    for(nm in linked)stopifnot(any(grepl(paths[nm],upstream_report,fixed=TRUE)&grepl(fingerprints[nm],upstream_report,fixed=TRUE)))
    need(TRUE,"v2基线锁定","计算输入仅取群落v2/功能v2；RDS、原count/taxonomy、原metadata、派生metadata及属矩阵SHA-256均匹配功能v2报告。没有读取被删除模块1.3结果。")
    protected<-unique(c(paths,script,list.files(b11,full.names=TRUE),list.files(b12,full.names=TRUE),
      list.files("data",recursive=TRUE,full.names=TRUE),list.files("input",recursive=TRUE,full.names=TRUE),list.files("metadata",recursive=TRUE,full.names=TRUE)))
    protected<-protected[!dir.exists(protected)];before<-vapply(protected,sha,character(1))
    ps<-readRDS(paths["object"]);prov<-attr(ps,"stage1_provenance")
    need(identical(prov$counts_transform,"none")&&all(prov$inputs_sha256[c("asv","taxonomy","sequences")]==fingerprints[c("asv","taxonomy","sequences")]),
      "已有对象来源","对象原count未变换，三个原输入指纹匹配；按v2报告核验兼容复用，不重建对象。")
    x<-as(phyloseq::otu_table(ps),"matrix");if(!phyloseq::taxa_are_rows(ps))x<-t(x)
    raw<-rd(paths["asv"],skip=1,row.names=1)
    need(identical(dim(x),c(5510L,33L))&&identical(dimnames(x),dimnames(raw))&&all(x==as.matrix(raw))&&
      !anyNA(x)&&all(is.finite(x))&&all(x>=0&x==floor(x))&&all(colSums(x)>0)&&!anyDuplicated(colnames(x))&&!anyDuplicated(rownames(x)),
      "计算输入断言","5510×33原始非负整数count与RDS逐格一致；ID唯一、无NA和空样本；不重复上游深度异常筛查。")
    meta<-rd(paths["metadata"],colClasses="character",na.strings="NA");meta<-meta[match(colnames(x),meta[["sample-id"]]),];rownames(meta)<-meta[["sample-id"]]
    sm<-rd(paths["source_metadata"],colClasses="character",na.strings="NA");sm<-sm[match(rownames(meta),sm[["sample-id"]]),];rownames(sm)<-sm[["sample-id"]]
    need(nrow(meta)==33&&!anyNA(meta[["sample-id"]])&&!anyDuplicated(meta[["sample-id"]])&&identical(meta[,names(sm),drop=FALSE],sm)&&
      identical(meta,data.frame(phyloseq::sample_data(ps),check.names=FALSE)),"metadata身份","v2派生表与现有对象一致；原33×14列逐值保留。")
    design<-readLines(paths["design"],warn=FALSE)
    for(g in paste0("G",1:5)) {
      ln<-grep(paste0("^\\| ",g," \\|.*Batch_01_"),design,value=TRUE);stopifnot(length(ln)==1)
      ids<-regmatches(ln,gregexpr("Batch_01_[A-Z][0-9]",ln))[[1]];stopifnot(setequal(ids,rownames(meta)[meta$group==g]))
    }
    need(identical(as.integer(table(factor(meta$group,levels=paste0("G",1:5)))),c(8L,2L,4L,15L,4L)),
      "设计名单门控","与设计文档逐模块核对33个完整ID，8/2/4/15/4；来源字段回查已确认文档，不按名称/目录猜组。")
    meta$reactor<-c(Reactor_01="R1",Reactor_02="R2",Reactor_03="R3",Reactor_04="R4")[meta$reactor_id]
    meta$day<-as.numeric(meta$phase_days);meta$short<-meta$supplier_sample_id;ids<-rownames(meta)
    stopifnot(!anyNA(meta$reactor),!anyNA(meta$day),all(!is.na(meta$group_source)),all(!is.na(meta$metadata_source)),all(is.na(meta$DO_measured_mg_L)))
    g4<-meta[meta$group=="G4",];g5<-meta[meta$group=="G5",]
    stopifnot(identical(as.integer(table(factor(g4$day,levels=c(1,30,76,145)))),c(4L,3L,4L,4L)),
      all(g4$stage_subphase[g4$day==1]=="recovered_baseline_before_low_DO_switch"),all(g4$stage_subphase[g4$day>1]=="design_stable_low_DO_period"),
      length(unique(g5$fractionation_event_id))==1,!is.na(g5$fractionation_event_id[1]),length(unique(g5$reactor_instance_id))==1)
    need(TRUE,"时间/单位门控","G4四基线+11后期，R1缺30d；G5同母样；保留已确认轮次、混合谱系、保存恢复和重复时间点。")
    add("WARNING","推断门控关闭","主29记录不独立、共享来源与重复测量、DO/阶段/时间混杂；G5一母样四级分。只描述，不做显著性/网络/因果分析。")
    add("WARNING","DO与稳态","设计确认G4基线是恢复设置3且切换低DO前；继承v2分析字段NA、design_document字段3差异保留。全部瞬时实测NA；后期设计稳定运行期不等于性能稳态已验证。")

    # Targeted review of existing module 1.2; never change its mappings/abundances.
    ann<-rd(paths["annotation"]);ann<-ann[match(rownames(x),ann$feature_id),];ev<-rd(paths["evidence"])
    ft<-rd(paths["taxa"]);fg<-rd(paths["guild"]);tax<-rd(paths["taxonomy"]);tax<-tax[match(rownames(x),tax[["Feature ID"]]),]
    need(identical(ann$feature_id,rownames(x))&&identical(ann$original_taxonomy,tax$Taxon)&&
      isTRUE(all.equal(ann$taxonomy_classifier_confidence,tax$Confidence,tolerance=1e-12)),"定向分类来源","全部5510 ASV原谱系/置信度与taxonomy一致；四份功能v2表均实际读取。")
    genus<-function(nm)colSums(as.matrix(ft[ft$genus_label==nm,ids,drop=FALSE]))
    guild<-function(nm)as.numeric(as.matrix(fg[fg$exclusive_partition==nm,ids,drop=FALSE]))
    comp<-genus("Candidatus_Competibacter");def<-genus("Defluviicoccus");gao<-guild("GAO_supported")
    need(sum(ann$rule_id=="R05",na.rm=TRUE)==3&&sum(ann$rule_id=="R03",na.rm=TRUE)==18&&
      all(is.na(ann$conservative_guild[ann$rule_id%in%c("R03","R05","R12","R13","R15")]))&&ev$literature_strength[ev$rule_id=="R15"]=="single_strain_evidence_only",
      "功能边界","Thauera/Acinetobacter/Dechloromonas不进保守PAO，Nitrospira功能歧义、Brocadia--other分类受限；原映射不变。")
    contribution<-data.frame(sample_id=ids,group=meta$group,reactor=meta$reactor,day=meta$day,Competibacter_percent=100*comp,
      Defluviicoccus_percent=100*def,GAO_proxy_percent=100*gao,C_share_GAO_percent=100*comp/gao,D_share_GAO_percent=100*def/gao)
    target<-ft[!is.na(ft$rule_id),];maxima<-apply(as.matrix(target[,rownames(g4),drop=FALSE]),1,max)
    s2<-match("Batch_01_S2",ids)
    review<-c("# 模块1.2定向解释复核（基于有效v2，2026-11-04）","",
      "仅审核functional_guilds/2026-11-03_v2四表、原taxonomy/count及绘图代码；未修改功能映射或重新计算功能丰度。结论如下，ASV证据列于附录。","",
      sprintf("- S2 Thauera=%.4f%%，PAO_genus_candidate=%.4f%%（其余候选合计%.4f个百分点）。Thauera证据来自SND5特定菌株，不能当成本批已确认PAO，也不能据该文归入确定AOB。[Wang & He 2020原研究摘要](https://pubmed.ncbi.nlm.nih.gov/32823196/)。",100*genus("Thauera")[s2],100*guild("PAO_genus_candidate")[s2],100*(guild("PAO_genus_candidate")[s2]-genus("Thauera")[s2])),
      "- 三个Brocadia--other ASV的完整原谱系、置信度及原始reads分布见附录A。参数日志记录分类confidence阈值0.7及silva144-2026.7-full-length.qza；未重新读取外部分类库，--other语义及参考序列匹配未核实。高分类器置信度不能消除原标签的限制：当前只保留相关谱系候选，不升级为无后缀Brocadia属确证或AnAOB活性。",
      "- 18个Nitrospira ASV完整分类信息见附录B。保留NOB/comammox歧义，不计入保守AOB/NOB。[Daims et al. 2015原研究](https://doi.org/10.1038/nature16461)。",
      "- Acinetobacter 171个ASV、Dechloromonas 4个ASV继续单列PAO_ambiguous。Acinetobacter部分储磷分离株不符合典型EBPR生理模型，但不能反向断言该属毫无除磷能力（[原研究摘要](https://iris.uniroma1.it/handle/11573/78628)）；Dechloromonas的FISH-Raman/基因组证据针对研究物种，不支持由短16S属注释确证本批所有ASV功能（[原研究](https://www.nature.com/articles/s41396-021-01029-2)）。",
      "- 文献于本次2026-11-04定向检索原研究摘要或可访问原文内容；非系统综述、非本批功能测定，未编造新功能。",
      "- G4图代码facet_wrap(scales='free_y')：每面板独立纵轴。不能跨面板按曲线高度判断丰度/变化幅度；下列实际最大百分比可避免放大极低丰度的误读，零值面板不作变化解释。","",
      md(data.frame(genus=target$genus_label,G4_max_percent=100*maxima)[order(maxima),]),"",
      "## Competibacter与Defluviicoccus的反应器/样本贡献","",
      "百分比的分母为全部ASV reads；C_share_GAO和D_share_GAO分母为已有GAO关联保守代理，仅为读数比例贡献，不是过程贡献。逐样本列出以保留轮次和不同节点，不混合算独立重复均值。","",md(contribution),"",
      "## 附录A：三个Brocadia--other ASV（未列样本reads=0）","")
    for(i in which(ann$rule_id%in%"R05")) {
      nz<-which(x[i,]>0)
      review<-c(review,paste0("- `",ann$feature_id[i],"`；分类置信度=",format(ann$taxonomy_classifier_confidence[i],digits=16),"；总reads=",sum(x[i,]),"；检出样本数=",length(nz),"。"),
        paste0("  原谱系：`",ann$original_taxonomy[i],"`。"),paste0("  原始reads：",paste(paste0(meta$short[nz],"=",x[i,nz]),collapse="; "),"。"))
    }
    ni<-which(ann$rule_id%in%"R03")
    review<-c(review,"","## 附录B：18个Nitrospira ASV","",md(data.frame(feature_id=ann$feature_id[ni],original_taxonomy=ann$original_taxonomy[ni],
      classifier_confidence=ann$taxonomy_classifier_confidence[ni],total_reads=rowSums(x[ni,,drop=FALSE]),detected_samples=rowSums(x[ni,,drop=FALSE]>0)),12),"",
      "审核结论：PASS（原映射边界保持）；WARNING（菌株/功能证据及--other语义不足、图轴独立）；不新增功能赋值。")
    writeLines(review,file.path(out,"module12_review.md"),useBytes=TRUE)
    append("docs/batch_01/analysis_log.md",c(paste0("### 2026-11-04 / 模块1.2定向复核（v2输出，",stamp(),"）"),
      paste0("- 命令：Rscript --vanilla scripts/diversity_analysis.R；输入限定有效群落/功能v2、原count及对应对象；先完成定向复核再开始多样性，输出",out,"/module12_review.md。"),
      "- 已实际检查S2候选PAO、三Brocadia完整谱系/原置信度/原始reads、18 Nitrospira、Acinetobacter/Dechloromonas限制及逐样本两GAO属贡献、独立图轴。原功能映射/丰度四表未改写；不升级功能确证。"))

    # Primary alpha and beta use all unrarefied ASVs.
    counts<-t(x);depth<-rowSums(counts);rel<-counts/depth
    calc_alpha<-function(z)data.frame(Observed_ASVs=rowSums(z>0),Shannon=vegan::diversity(z,"shannon"),Simpson=vegan::diversity(z,"simpson"),row.names=rownames(z))
    a<-calc_alpha(counts);f1<-rowSums(counts==1);f2<-rowSums(counts==2);chao<-a$Observed_ASVs+f1*(f1-1)/(2*(f2+1))
    need(all(is.finite(as.matrix(a)))&&all(abs(chao-vegan::estimateR(counts)["S.chao1",])<1e-9),"Alpha公式","Observed=count>0；Shannon自然log；Simpson=1−Σp²；Chao1偏差校正与vegan接口一致。")
    add("WARNING","Chao1适用性",sprintf("原去噪count的f1=%d–%d、f2=%d–%d；可以计算但单例贫化，不能可靠估计真实总丰富度，不以接近Observed证明取样饱和。",min(f1),max(f1),min(f2),max(f2)))
    bray<-as.matrix(vegan::vegdist(rel,"bray"));jac<-as.matrix(vegan::vegdist(counts,"jaccard",binary=TRUE))
    bin<-1*(counts>0);intersection<-tcrossprod(bin);union<-outer(rowSums(bin),rowSums(bin),"+")-intersection
    need(max(abs(bray-as.matrix(dist(rel,"manhattan"))/2))<1e-12&&max(abs(jac-(1-intersection/union)))<1e-12&&
      all(is.finite(bray))&&all(is.finite(jac))&&all(diag(bray)==0)&&all(diag(jac)==0)&&
      max(abs(bray-t(bray)))<1e-12&&max(abs(jac-t(jac)))<1e-12&&all(bray>=0&bray<=1)&&all(jac>=0&jac<=1),
      "Beta独立公式","Bray=相对组成L1/2、二元Jaccard=1−交集/并集；完整33×33、对称、零对角、范围[0,1]。")
    seed<-20261104L;reps<-100L;nmin<-min(depth);set.seed(seed)
    pair_index<-t(combn(1:33,2));pv<-function(m)m[pair_index]
    ar<-array(NA_real_,c(33,3,reps));rb<-rj<-matrix(NA_real_,528,reps)
    for(k in 1:reps) {
      z<-vegan::rrarefy(counts,nmin);stopifnot(all(rowSums(z)==nmin),all(z<=counts),all(z>=0))
      ar[,,k]<-as.matrix(calc_alpha(z));rb[,k]<-pv(as.matrix(vegan::vegdist(z/nmin,"bray")))
      rj[,k]<-pv(as.matrix(vegan::vegdist(z,"jaccard",binary=TRUE)))
    }
    need(all(is.finite(ar))&&all(is.finite(rb))&&all(is.finite(rj)),"等深度敏感性",sprintf("仅内存不放回子抽样：%d reads×%d次，seed=%d；全部33样本保留，主分析不抽稀。",nmin,reps,seed))
    alpha<-cbind(meta[,c("sample-id","short","group","reactor","reactor_round","reactor_instance_id","day","phase_day_basis",
      "sampling_day_status","stage_subphase","pool_id","fractionation_event_id","particle_size_fraction_um")],
      data.frame(reads=depth,a,Chao1_bias_corrected=chao,singleton_ASVs=f1,doubleton_ASVs=f2,
      Chao1_status="computable_but_singleton_depleted_not_reliable_total_richness",Competibacter_fraction=comp,Defluviicoccus_fraction=def,
      GAO_proxy_fraction=gao,PAO_proxy_fraction=guild("PAO_supported"),AOB_proxy_fraction=guild("AOB_supported"),
      Thauera_fraction=genus("Thauera"),PAO_genus_candidate_fraction=guild("PAO_genus_candidate"),Acinetobacter_fraction=genus("Acinetobacter")))
    for(j in 1:3) {
      alpha[[paste0(names(a)[j],"_rarefied_mean")]]<-rowMeans(ar[,j,])
      alpha[[paste0(names(a)[j],"_rarefied_p025")]]<-apply(ar[,j,],1,quantile,.025)
      alpha[[paste0(names(a)[j],"_rarefied_p975")]]<-apply(ar[,j,],1,quantile,.975)
    }
    alpha$Observed_expected_at_min_depth<-as.numeric(vegan::rarefy(counts,nmin))
    hell<-as.matrix(dist(sqrt(rel)))
    clr<-function(pc){z<-log(rel*nmin+pc);as.matrix(dist(z-rowMeans(z)))}
    clr05<-clr(.5);clr1<-clr(1);keep<-colSums(counts)>=10
    bf<-as.matrix(vegan::vegdist(counts[,keep]/rowSums(counts[,keep]),"bray"));j5<-as.matrix(vegan::vegdist(counts>=5,"jaccard",binary=TRUE))
    pd<-data.frame(sample_a=ids[pair_index[,1]],sample_b=ids[pair_index[,2]],group_a=meta$group[pair_index[,1]],group_b=meta$group[pair_index[,2]],
      Bray_Curtis=pv(bray),Jaccard_binary=pv(jac),Bray_rarefied_mean=rowMeans(rb),Bray_rarefied_p025=apply(rb,1,quantile,.025),
      Bray_rarefied_p975=apply(rb,1,quantile,.975),Jaccard_rarefied_mean=rowMeans(rj),Jaccard_rarefied_p025=apply(rj,1,quantile,.025),
      Jaccard_rarefied_p975=apply(rj,1,quantile,.975),Hellinger=pv(hell),CLR_pc05_at_min_depth=pv(clr05),CLR_pc1_at_min_depth=pv(clr1),
      Bray_global_reads_ge10=pv(bf),Jaccard_per_sample_reads_ge5=pv(j5))
    need(nrow(pd)==528&&!anyNA(pd)&&all(is.finite(as.matrix(pd[,5:ncol(pd)]))),"敏感性完整性","保存全部528对主/敏感性距离及子抽样分位数；可恢复任意子集矩阵。")
    ss<-do.call(rbind,lapply(c("main29","G4","G5"),function(scope){
      use_ids<-ids[if(scope=="main29")meta$group!="G5" else meta$group==scope];use<-pd$sample_a%in%use_ids&pd$sample_b%in%use_ids
      compare<-function(nm,ref)data.frame(scope=scope,method=nm,reference=ref,pairs=sum(use),
        Spearman_rho=cor(pd[[nm]][use],pd[[ref]][use],method="spearman"),
        mean_absolute_difference=if(nm%in%c("Bray_rarefied_mean","Jaccard_rarefied_mean","Bray_global_reads_ge10","Jaccard_per_sample_reads_ge5"))mean(abs(pd[[nm]][use]-pd[[ref]][use]))else NA_real_)
      rbind(compare("Bray_rarefied_mean","Bray_Curtis"),compare("Jaccard_rarefied_mean","Jaccard_binary"),compare("Hellinger","Bray_Curtis"),
        compare("CLR_pc05_at_min_depth","Bray_Curtis"),compare("CLR_pc1_at_min_depth","Bray_Curtis"),compare("CLR_pc05_at_min_depth","CLR_pc1_at_min_depth"),
        compare("Bray_global_reads_ge10","Bray_Curtis"),compare("Jaccard_per_sample_reads_ge5","Jaccard_binary"))
    }))
    # PCoA separately for main29 and G5; preserve all positive axes and spectra.
    pcs<-eigs<-list();oi<-list()
    for(scope in c("main29","G5")) {
      use<-ids[if(scope=="main29")meta$group!="G5" else meta$group=="G5"];d<-bray[use,use];n<-length(use);J<-diag(n)-matrix(1/n,n,n)
      re<-eigen(-.5*J%*%(d^2)%*%J,symmetric=TRUE,only.values=TRUE)$values;tol<-max(abs(re))*1e-10;neg<-re[re< -tol]
      pc<-vegan::wcmdscale(as.dist(d),eig=TRUE,add=if(length(neg))"lingoes" else FALSE);ac<-if(length(neg))pc$ac else 0
      target_dist<-sqrt(d^2+2*ac);diag(target_dist)<-0
      need(max(abs(as.matrix(dist(pc$points))-target_dist))<1e-8,paste(scope,"PCoA全轴重构"),
        sprintf("原负特征值%d、Lingoes常数%.12g；全部正轴重构校正距离误差<1e-8。",length(neg),ac))
      coords<-matrix(NA_real_,n,28,dimnames=list(use,paste0("PCoA",1:28)));coords[,seq_len(ncol(pc$points))]<-pc$points[use,,drop=FALSE]
      pcs[[scope]]<-cbind(data.frame(basis=scope,sample_id=use,short=meta[use,"short"],group=meta[use,"group"],reactor=meta[use,"reactor"],day=meta[use,"day"],
        correction=if(length(neg))"Lingoes" else "none",additive_constant=ac),as.data.frame(coords))
      eigs[[scope]]<-rbind(data.frame(basis=scope,spectrum="raw",axis=seq_along(re),eigenvalue=re,positive_inertia_fraction=ifelse(re>tol,re/sum(re[re>tol]),NA_real_)),
        data.frame(basis=scope,spectrum="ordination",axis=seq_along(pc$eig),eigenvalue=pc$eig,positive_inertia_fraction=pc$eig/sum(pc$eig)))
      oi[[scope]]<-data.frame(basis=scope,negative_eigenvalues=length(neg),negative_absolute_inertia_fraction=sum(abs(neg))/sum(abs(re)),
        Lingoes_constant=ac,PCoA1_percent=100*pc$eig[1]/sum(pc$eig),PCoA2_percent=100*pc$eig[2]/sum(pc$eig))
    }
    pcs<-do.call(rbind,pcs);eigs<-do.call(rbind,eigs);oi<-do.call(rbind,oi)
    distrow<-function(from,to,type) {
      z<-pd[(pd$sample_a==from&pd$sample_b==to)|(pd$sample_a==to&pd$sample_b==from),];stopifnot(nrow(z)==1)
      cbind(data.frame(comparison=type,sample_from=from,sample_to=to,reactor_from=meta[from,"reactor"],reactor_to=meta[to,"reactor"],
        day_from=meta[from,"day"],day_to=meta[to,"day"],interval_days=meta[to,"day"]-meta[from,"day"],
        same_continuous_run=meta[from,"continuous_run_id"]==meta[to,"continuous_run_id"]),z[,5:ncol(z),drop=FALSE])
    }
    within<-trans<-between<-list()
    for(r in paste0("R",1:4)) {
      z<-g4[g4$reactor==r,];z<-z[order(z$day),];use<-rownames(z)
      stopifnot(!anyDuplicated(z$day),length(unique(z$continuous_run_id))==1)
      for(i in 1:(nrow(z)-1))within[[length(within)+1]]<-distrow(use[i],use[i+1],"adjacent_observed")
      for(i in 2:nrow(z))within[[length(within)+1]]<-distrow(use[1],use[i],"baseline_to_post")
      for(run in c("G1_original","G2G3_postmix")) {
        v<-meta[meta$reactor==r&meta$reactor_round==run,];v<-v[order(v$day),]
        if(nrow(v)>1)for(i in 1:(nrow(v)-1))trans[[length(trans)+1]]<-distrow(rownames(v)[i],rownames(v)[i+1],run)
      }
    }
    for(day in sort(unique(g4$day))) {
      pp<-combn(rownames(g4)[g4$day==day],2)
      for(i in 1:ncol(pp))between[[length(between)+1]]<-distrow(pp[1,i],pp[2,i],"same_day_between_reactors")
    }
    within<-do.call(rbind,within);between<-do.call(rbind,between);trans<-do.call(rbind,trans)
    need(nrow(within)==22&&sum(within$comparison=="adjacent_observed")==11&&all(within$same_continuous_run)&&
      nrow(between)==21&&all(between$interval_days==0)&&all(trans$same_continuous_run),"变化幅度门控",
      "G4 11个相邻实际节点+11个基线至后期、21个同期反应器对；仅同轮时间转移，不插补，不跨保存恢复连接。")
    put(alpha,"alpha_diversity.tsv");put(data.frame(sample_id=ids,bray,check.names=FALSE),"bray_curtis_distance.tsv")
    put(data.frame(sample_id=ids,jac,check.names=FALSE),"jaccard_distance.tsv");put(pcs,"pcoa_coordinates.tsv");put(eigs,"pcoa_eigenvalues.tsv")
    put(within,"G4_within_reactor_changes.tsv");put(between,"G4_same_day_between_reactors.tsv");put(trans,"continuous_run_transitions.tsv")
    put(pd,"pairwise_sensitivity.tsv");put(ss,"sensitivity_summary.tsv")

    # Export publication-friendly standalone PDF/PNG figures.
    pal<-c(R1="#0072B2",R2="#D55E00",R3="#009E73",R4="#CC79A7")
    theme_set(theme_bw(base_size=11)+theme(panel.grid.minor=element_blank(),plot.title.position="plot"))
    plot_pair<-function(p,name,w,h) {
      need(length(ggplot_build(p)$data)>0,paste(name,"图层"),"实际构建绘图层，仅真实观测；无检验标记。")
      ggsave(file.path(out,paste0(name,".pdf")),p,width=w,height=h,device=grDevices::cairo_pdf)
      ggsave(file.path(out,paste0(name,".png")),p,width=w,height=h,dpi=180,bg="white")
    }
    metrics<-c("Observed_ASVs","Shannon","Simpson","Chao1_bias_corrected")
    long<-do.call(rbind,lapply(metrics,function(nm)data.frame(alpha,metric=nm,value=alpha[[nm]])))
    for(r in paste0("R",1:4)) {
      z<-long[long$group!="G5"&long$reactor==r,];z$metric<-factor(z$metric,levels=metrics)
      z$block<-factor(z$reactor_round,levels=c("G1_original","G2G3_postmix","G4G5_low_DO"),labels=c("G1: original startup","G2/G3: after mixing/splitting","G4: after storage/recovery"))
      p<-ggplot(z,aes(day,value,group=interaction(metric,reactor_instance_id)))+geom_line(color=pal[r])+geom_point(color=pal[r],size=2)+
        geom_text(aes(label=short),vjust=-.65,size=2.8,check_overlap=TRUE)+facet_grid(rows=vars(metric),cols=vars(block),scales="free")+
        scale_x_continuous(breaks=c(1,21,30,56,76,120,145),guide=guide_axis(check.overlap=TRUE))+scale_y_continuous(expand=expansion(mult=c(.08,.2)))+
        labs(title=paste(r,"| Alpha trajectories"),subtitle="Run day axes reset between columns; G1 end ~120 d; G4 day 1 = recovered pre-switch baseline",
          x="Recorded day within run; lines connect observed nodes only",y=NULL,caption="No cross-run lines or tests. Chao1 is unreliable as total richness after singleton depletion.")
      plot_pair(p,paste0(r,"_alpha_trajectories"),13,10)
    }
    p<-ggplot(alpha[alpha$group=="G4",],aes(day,Shannon,color=reactor,group=reactor))+geom_line()+geom_point(size=2)+
      geom_text(aes(label=short),vjust=-.7,size=3)+scale_color_manual(values=pal)+scale_x_continuous(breaks=c(1,30,76,145))+
      labs(title="G4 | Shannon diversity",subtitle="Common y axis; day 1 = pre-low-DO baseline; no R1 day-30 sample",x="Recorded day",y="Shannon (natural log)",
        caption="Lines connect observed nodes only; no interpolation or independent-sample tests.")
    plot_pair(p,"G4_shannon_trajectories",10,6)
    for(scope in c("main29","G5")) {
      z<-pcs[pcs$basis==scope,];info<-oi[oi$basis==scope,];p<-ggplot(z,aes(PCoA1,PCoA2))
      if(scope=="main29") {
        zz<-z[z$group=="G4",];zz<-zz[order(zz$reactor,zz$day),]
        p<-p+geom_path(data=zz,aes(color=reactor,group=reactor),arrow=grid::arrow(length=grid::unit(.08,"inches")),linewidth=.5)+
          geom_point(aes(color=reactor,shape=group),size=3)+scale_color_manual(values=pal)
      }else p<-p+geom_point(size=3,color=pal[1])
      p<-p+geom_text(aes(label=short),vjust=-.7,size=3)+coord_equal()+scale_x_continuous(expand=expansion(mult=.16))+
        scale_y_continuous(expand=expansion(mult=.16))+labs(title=paste(scope,"| Bray-Curtis PCoA"),
          subtitle=if(scope=="main29")"29 main records; arrows connect only G4 observed nodes within reactor"else"Four size fractions of one mother sample; separate ordination; no replication",
          x=sprintf("PCoA1 (%.2f%% of positive ordination inertia)",info$PCoA1_percent),y=sprintf("PCoA2 (%.2f%%)",info$PCoA2_percent),
          caption=sprintf("Correction: %s; constant %.8g. Distance matrices keep original Bray values.",if(info$negative_eigenvalues)"Lingoes"else"none",info$Lingoes_constant))
      plot_pair(p,paste0(scope,"_bray_pcoa"),if(scope=="main29")11 else 8,if(scope=="main29")8 else 6)
    }
    adj<-within[within$comparison=="adjacent_observed",];adj$interval<-paste0(adj$day_from," -> ",adj$day_to," d (",adj$interval_days," d)")
    p<-ggplot(adj,aes(interval,Bray_Curtis,fill=reactor_from))+geom_col()+geom_text(aes(label=sprintf("%.3f",Bray_Curtis)),vjust=-.5)+
      facet_wrap(vars(reactor_from),scales="free_x",nrow=1)+scale_fill_manual(values=pal,guide="none")+scale_y_continuous(limits=c(0,1),expand=expansion(mult=c(0,.02)))+
      theme(axis.text.x=element_text(angle=45,hjust=1))+labs(title="G4 | Adjacent observed-node community change",x=NULL,y="ASV relative-abundance Bray-Curtis",
        subtitle="Unequal intervals; endpoint distance is not cumulative turnover or a kinetic rate")
    plot_pair(p,"G4_adjacent_changes",13,5)
    p<-ggplot(between,aes(day_from,Bray_Curtis,group=interaction(reactor_from,reactor_to),color=interaction(reactor_from,reactor_to)))+
      geom_point(size=2)+geom_line()+scale_x_continuous(breaks=c(1,30,76,145))+scale_y_continuous(limits=c(0,1))+
      labs(title="G4 | Between-reactor distances on actual sampling days",x="Recorded day",y="Bray-Curtis",color="Reactor pair",subtitle="No R1 pair at day 30; connections only between observed nodes")
    plot_pair(p,"G4_between_reactor_distances",11,6)
    p<-ggplot(long[long$group=="G5",],aes(short,value))+geom_col(fill=pal[1],width=.65)+facet_wrap(vars(metric),scales="free_y",nrow=1)+
      labs(title="G5 | Alpha diversity of four fractions from one mother sample",x="S1 <100; S2 100-200; S3 200-500; S4 >500 um",y=NULL,
        subtitle="Each metric has its own y axis; no biological replication; Chao1 exploratory")
    plot_pair(p,"G5_alpha_diversity",13,4)
    p<-ggplot(alpha[alpha$group=="G4",],aes(100*Competibacter_fraction,Shannon,color=reactor))+geom_point(size=3)+
      geom_text(aes(label=short),vjust=-.6,size=3)+scale_color_manual(values=pal)+labs(title="G4 | Competibacter proportion and ASV Shannon",
        x="Competibacter (% of all ASV reads)",y="Shannon",subtitle="Dependent observations; no fitted model, p-value or functional conclusion")
    plot_pair(p,"G4_function_diversity_comparison",10,6)
    z<-do.call(rbind,lapply(names(a),function(nm)data.frame(metric=nm,reactor=meta$reactor,raw=alpha[[nm]],rarefied=alpha[[paste0(nm,"_rarefied_mean")]])))
    p<-ggplot(z,aes(raw,rarefied,color=reactor))+geom_abline(slope=1,intercept=0,linetype=2,color="grey50")+geom_point()+
      facet_wrap(vars(metric),scales="free",nrow=1)+scale_color_manual(values=pal)+labs(title="Sequencing depth sensitivity",x="Unrarefied primary estimate",y="Mean of 100 equal-depth subsamples",
        subtitle=sprintf("%d reads; seed %d; dashed line = equality; sensitivity only",nmin,seed))
    plot_pair(p,"depth_sensitivity",12,4.5)

    # Compute report narrative directly from the current v2 analysis.
    fmt<-function(v,d=3)paste(formatC(v,format="f",digits=d),collapse=" → ")
    text<-c("## 四个反应器：主要特征（直接观察）","")
    for(r in paste0("R",1:4)) {
      text<-c(text,paste0("### ",r),"")
      for(run in c("G1_original","G2G3_postmix","G4G5_low_DO")) {
        z<-alpha[alpha$reactor==r&alpha$reactor_round==run&alpha$group!="G5",];z<-z[order(z$day),]
        text<-c(text,sprintf("- %s：%s；Observed %s；Shannon %s；Simpson %s。",run,paste0(z$short,"(",z$day,"d)",collapse=" → "),fmt(z$Observed_ASVs,0),fmt(z$Shannon),fmt(z$Simpson)))
      }
    }
    r2<-distrow("Batch_01_F3","Batch_01_F4","R2_late");changes<-abs(rel["Batch_01_F4",]-rel["Batch_01_F3",])/2
    cc<-sum(changes[ann$genus%in%"Candidatus_Competibacter"]);ca<-sum(changes[ann$genus%in%"Acinetobacter"])
    late<-adj[adj$day_from>=30,];r3late<-late[late$reactor_from=="R3",]
    h<-alpha[alpha$group=="G4"&alpha$reactor=="R4",];z5<-alpha[alpha$group=="G5",];p5<-pd[pd$group_a=="G5"&pd$group_b=="G5",]
    endpoints<-within[within$comparison=="baseline_to_post"&within$day_to==145,]
    means<-aggregate(Bray_Curtis~day_from,between,mean);common<-between[between$reactor_from!="R1"&between$reactor_to!="R1",];common_means<-aggregate(Bray_Curtis~day_from,common,mean)
    r24<-between[between$reactor_from=="R2"&between$reactor_to=="R4",];r12<-between[between$reactor_from=="R1"&between$reactor_to=="R2",]
    rho<-function(scope,method,ref)ss$Spearman_rho[ss$scope==scope&ss$method==method&ss$reference==ref]
    getmad<-function(scope,method)ss$mean_absolute_difference[ss$scope==scope&ss$method==method]
    text<-c(text,"","## 与模块1.1/1.2的一致与不一致","",
      sprintf("- R4 G4 Competibacter为%s%%，Shannon为%s。优势属集中与较低Alpha的描述相容，但R4不是各日最低：30d R2=%.4f低于R4=%.4f，145d R2=%.4f低于R4=%.4f；1d与76d的R4最低。G3末D3的Shannon=%.4f、Observed=%d，对应Competibacter %.2f%%。属级集中与ASV多样性并非同一分辨率，不作因果解释。",fmt(100*h$Competibacter_fraction,2),fmt(h$Shannon),alpha["Batch_01_F2","Shannon"],alpha["Batch_01_H2","Shannon"],alpha["Batch_01_F4","Shannon"],alpha["Batch_01_H4","Shannon"],alpha["Batch_01_D3","Shannon"],alpha["Batch_01_D3","Observed_ASVs"],100*alpha["Batch_01_D3","Competibacter_fraction"]),
      sprintf("- R2 F3→F4（76→145d，69d间隔）ASV Bray=%.4f、Jaccard=%.4f；Shannon %.4f→%.4f。Competibacter %.2f%%→%.2f%%、Acinetobacter %.2f%%→%.2f%%，与组成v2的属更替一致。ASV Bray加和分解中这两属分别贡献%.4f（%.2f%%）和%.4f（%.2f%%），不是全部变化；该分解先对每ASV取绝对差，再按原属标签求和，非仅属总量之差。",r2$Bray_Curtis,r2$Jaccard_binary,alpha["Batch_01_F3","Shannon"],alpha["Batch_01_F4","Shannon"],100*alpha["Batch_01_F3","Competibacter_fraction"],100*alpha["Batch_01_F4","Competibacter_fraction"],100*alpha["Batch_01_F3","Acinetobacter_fraction"],100*alpha["Batch_01_F4","Acinetobacter_fraction"],cc,100*cc/r2$Bray_Curtis,ca,100*ca/r2$Bray_Curtis),
      sprintf("- R3后期Defluviicoccus为%s%%，30→76d及76→145d整体Bray为%s、Jaccard为%s。30→76d的Bray低于同期R2/R4；76→145d低于四反应器其他三者，支持这些端点间丰度加权组成相对较小变化。但Jaccard仍较高，30→76d的R3 Jaccard反而高于R2/R4；不能称整个群落成员稳定或性能稳态。",fmt(100*alpha[alpha$group=="G4"&alpha$reactor=="R3"&alpha$day>1,"Defluviicoccus_fraction"],2),fmt(r3late$Bray_Curtis,4),fmt(r3late$Jaccard_binary,4)),
      "- R1的G4 Shannon先升后降，末期属级未分类比例较高并不阻断ASV Alpha/Beta计算；较高Observed不意味着均匀度更高，未分类ASV也不自动获得功能。",
      "- GAO/PAO/AOB关联比例沿用功能v2并列入Alpha表，未重新计算功能丰度或修改映射。高GAO代理不能解释为功能增强、竞争或除磷失败；S2 PAO候选由特定菌株文献引出，仍不确证。见[module12_review.md](module12_review.md)。","",
      "## G4运行阶段的群落变化幅度","",
      "1d是保存恢复后、切换低DO前基线；后期30/76/145d为设计稳定运行期，跨基线变化还包含适应与时间效应。基线至145d均为144d间隔：","",
      md(endpoints[,c("reactor_from","day_from","day_to","interval_days","Bray_Curtis","Jaccard_binary","Bray_rarefied_mean","Hellinger","CLR_pc05_at_min_depth")]),"",
      "相邻实际节点如下：R1没有30d，1→76为75d；其他反应器1→30为29d、30→76为46d；所有76→145为69d。不插补，不把距离/天数当动力学速率或累计周转。","",
      md(adj[,c("reactor_from","day_from","day_to","interval_days","Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth")]),"",
      "### 同期反应器之间的距离","",md(between[,c("day_from","reactor_from","reactor_to","Bray_Curtis","Jaccard_binary")]),"",
      sprintf("R2–R4 Bray在1/30/76/145d为%s，支持末段丰度加权组成趋近；但Jaccard为%s，不支持相同程度的成员趋同。R1–R2在1/76/145d Bray为%s，末段分化。不能宣称所有反应器总体趋同。",fmt(r24$Bray_Curtis,4),fmt(r24$Jaccard_binary,4),fmt(r12$Bray_Curtis,4)),"",
      "当日所有已观测对均值（30d只有3对，其他6对，不能直接视为相同覆盖）：","",md(means),"",
      "所有日均可用的R2/R3/R4三对Bray均值：","",md(common_means),"",
      "距离共享样本，均值不是独立重复的统计量；不同指标给出的趋近/分化含义必须限定。","",
      "## G5：同母样四个粒径级分","",
      md(z5[,c("short","particle_size_fraction_um","reads","Observed_ASVs","Shannon","Simpson","Chao1_bias_corrected","Observed_ASVs_rarefied_mean","Shannon_rarefied_mean")]),"",
      sprintf("S1–S4 Shannon为%s；S3与S4只差%.5f，不能将细微排序解释为普遍粒径效应。Observed最高为S3（%d），并非随粒径单调增加。",fmt(z5$Shannon,5),abs(z5$Shannon[4]-z5$Shannon[3]),z5$Observed_ASVs[3]),"",
      md(p5[,c("sample_a","sample_b","Bray_Curtis","Jaccard_binary","Bray_rarefied_mean","Hellinger","CLR_pc05_at_min_depth")]),"",
      "Bray最近为S3–S4、最远为S1–S2，仅指这次母样四组分。G5单独PCoA，坐标与主29不能直接叠加；不能由级分等权均值重建母样。无母样间重复，不做粒径显著性检验，也不能分离筛分处理和18d延长运行的作用。","",
      "## 敏感性结论与适用范围","",
      sprintf("主29等深度敏感性与原Bray的Spearman=%.6f，平均绝对距离差=%.6f；与原Jaccard的Spearman=%.6f、平均差=%.6f。当前深度范围内大尺度结论对该子抽样较稳健，但这不证明无测序/扩增偏倚。",rho("main29","Bray_rarefied_mean","Bray_Curtis"),getmad("main29","Bray_rarefied_mean"),rho("main29","Jaccard_rarefied_mean","Jaccard_binary"),getmad("main29","Jaccard_rarefied_mean")),
      sprintf("主29 Hellinger与Bray秩相关%.4f，而CLR伪计数0.5/1与Bray只有%.4f/%.4f；两个CLR方案之间为%.4f。组成权重改变后全局距离排序明显不同，不能把Bray稳定性泛化为对所有组成方法稳健。G4对应Hellinger/Bray=%.4f、CLR0.5/Bray=%.4f。",rho("main29","Hellinger","Bray_Curtis"),rho("main29","CLR_pc05_at_min_depth","Bray_Curtis"),rho("main29","CLR_pc1_at_min_depth","Bray_Curtis"),rho("main29","CLR_pc05_at_min_depth","CLR_pc1_at_min_depth"),rho("G4","Hellinger","Bray_Curtis"),rho("G4","CLR_pc05_at_min_depth","Bray_Curtis")),
      "R3后期Bray较小主要反映丰度加权组成；成员检出或log-ratio距离下不能直接得出同样稳定排名。G5 S3/S4 Shannon细微差异也不应被写成有重复支持的结论。子抽样2.5%/97.5%是抽样随机性范围，不是生物学置信区间。","",
      "## 直接观察、未验证假设与下一步非典型候选筛选","",
      "直接观察为ASV检出数、比例、Alpha及端点距离。低DO选择、粒径微环境、碳储存竞争和功能冗余只是未经验证假设；单属持续、Bray较小或PCoA靠近均不证明性能稳态、代谢活性或因果机制。",
      "下一步可从原ASV的检出率、相对比例及同一运行实体实际节点持续性提出候选；阈值须事先说明并做敏感性，不按预期功能调筛选结果。保留未分类ASV和标签不确定性；回查代表序列区域/长度、参考数据库后缀语义、参考序列比对与系统发育、物种/菌株功能原研究，以及可追溯的运行性能/采样处理证据。",
      "短16S仍不能证明项目功能基因或活性；没有基因组/细胞特异表型/活性等证据则维持候选。跨轮次相关记录和单母样不算独立复现；当前不安排新独立实验，不能补造验证。分类相对比例不等同绝对生物量。")
    depth_diag<-data.frame(metric=names(a),Spearman_with_reads=vapply(a,function(v)cor(v,depth,method="spearman"),numeric(1)),
      Spearman_primary_vs_rarefied=vapply(names(a),function(nm)cor(alpha[[nm]],alpha[[paste0(nm,"_rarefied_mean")]],method="spearman"),numeric(1)))
    add("WARNING","组成与检出敏感性","CLR与Bray的全局秩一致性仅中等，成员Jaccard和丰度Bray可给不同稳定描述；CLR零值处理仍是分析假设，不宣称全方法稳健。")
    add("WARNING","距离与功能边界","距离共享样本、前两轴仅投影、端点差非累计周转；功能属比例与ASV多样性分辨率不同，不能做功能活性/因果/绝对丰度解释。")
    add("WARNING","批次与抽样限制","本批未知提取/PCR/测序子批次效应不能分离；子抽样范围非生物置信区间，不能消除扩增与16S拷贝数偏倚。")
    need(identical(vapply(protected,sha,character(1)),before),"输入及有效结果保护",sprintf("%d个原始输入、设计、有效v2产物和脚本指纹不变；RDS/metadata/旧结果均不覆盖。",length(protected)))
    status<-table(factor(checks$status,levels=c("PASS","WARNING","FAIL")))
    relout<-sub(paste0(root,"/"),"",out,fixed=TRUE)
    report<-c("# Batch_01 模块1.3：Alpha/Beta多样性与变化幅度（有效v2）","",
      paste0("当前输出：",relout,"。上游仅使用community_composition/2026-11-03_v2与functional_guilds/2026-11-03_v2；原始count/对象经其报告指纹验证。"),
      "用户已撤回并要求删除此前模块1.3目录，当前结果为从指定输入实际计算，未复制旧模块1.3结果。其他模块历史版本不作处理。",
      sprintf("运行：%s–%s（Asia/Shanghai）。状态：%d PASS / %d WARNING / %d FAIL；PASS仅限描述性计算，推断门控关闭。",format(started,tz="Asia/Shanghai"),stamp(),status[1],status[2],status[3]),"",
      "## 数据与方法","",
      "33样本、5510 ASV；G1–G5=8/2/4/15/4。原count与RDS逐格核对，原14列metadata与v2派生表及对象逐值一致，按已确认设计名单核对分组。复用上游QC，不重跑DADA2、SILVA、导出或功能丰度计算；未改写原始输入、metadata、实验设计和既有v2结果。",
      "RDS及派生metadata中保留历史metadata_version标签，但内容与有效v2逐值及指纹一致；标签不作为选择旧版本结果的依据，原对象不修改。G4基线按最新设计解释为切换前恢复基线，继承的分析DO=NA/design_document=3差异原样保留，不以设置当实测。","",
      "### Alpha定义与Chao1适用性","",
      "主分析不抽稀、不滤ASV：Observed=每样本count>0的ASV数；Shannon=−Σp ln p；Simpson=1−Σp²（非倒数）。偏差校正Chao1=Sobs+f1(f1−1)/[2(f2+1)]，与vegan::estimateR核对；单例/双例来自原整数count。ASV不是物种，去噪后单例贫化，Chao1仅探索性数值，不作为可靠总丰富度估计，不能用其接近Observed证明取样饱和。[vegan定义](https://vegandevs.github.io/vegan/reference/diversity.html)。",
      sprintf("实际深度%d–%d，中位%.0f（上游已QC，未重做异常筛查）；f1=%d–%d、f2=%d–%d，%d样本f1=0；Observed范围%d–%d，Shannon %.5f–%.5f，Simpson %.5f–%.5f。",min(depth),max(depth),median(depth),min(f1),max(f1),min(f2),max(f2),sum(f1==0),min(a$Observed_ASVs),max(a$Observed_ASVs),min(a$Shannon),max(a$Shannon),min(a$Simpson),max(a$Simpson)),"",
      "### Beta与PCoA","",
      "Bray以每样本ASV相对丰度计算；Jaccard明确为存在/缺失二元距离，检出=count>0。完整33×33原始距离矩阵保留。Bray与L1/2、Jaccard与1−交集/并集独立公式核对。[距离文档](https://vegandevs.github.io/vegan/reference/vegdist.html)。",
      "主29与G5四组分分别PCoA，避免单母样级分影响主29轴权重。对−0.5 JD²J求原特征值；负值判断容差=max|λ|×1e−10。存在负特征值时使用vegan::wcmdscale(add='lingoes')，c=−最小负特征值，非对角d'=sqrt(d²+2c)，原对角保持0。保存原/校正谱及全部正轴坐标，全轴重构误差<1e−8；变化幅度和距离矩阵仍用原Bray。前两轴只是投影，不把截断坐标距离当完整群落距离。[Lingoes文档](https://vegandevs.github.io/vegan/reference/wcmdscale.html)。","",md(oi,8),"",
      "### 固定的敏感性参数","",
      sprintf("1. 深度：seed=%d，%d reads（最小深度）不放回子抽样%d次，全部33样本保留，仅内存计算。Alpha与Bray/Jaccard均保存均值和2.5%%/97.5%%子抽样分位数；Observed另给解析抽样期望。非默认主分析、非生物学置信区间，不产生抽稀count文件。[抽样文档](https://vegandevs.github.io/vegan/reference/rarefy.html)。",seed,nmin,reps),
      sprintf("2. 低检出：敏感性Bray保留全33样本总reads≥10的ASV（%d/%d，重新闭合），敏感性Jaccard使用每样本count≥5定义检出。固定阈值不调参，主分析不删除ASV。",sum(keep),ncol(counts)),
      "3. Hellinger=sqrt相对丰度后Euclidean距离；CLR=Aitchison的log-ratio Euclidean距离。将相对组成缩放到共同最小深度的期望count后统一加0.5或1，log后逐样本中心化，所有5510列保留。这样不会直接给不同原始深度加同一伪计数；零值处理仍有假设，因此比较两个方案。不同单位的距离不直接比较数值大小。",
      "4. Spearman仅描述样本或距离的数值排序一致性，不给p值，不作Mantel、相关显著性或独立样本推断；距离共享样本。","",md(depth_diag),"",md(ss),"",text,"",
      "## 实际程序检查","",md(checks),"",
      "## 最终文件与图件","",
      "- alpha_diversity.tsv：33行Alpha、reads、单/双例、功能关联比例及深度敏感性。",
      "- bray_curtis_distance.tsv / jaccard_distance.tsv：完整33×33原始矩阵，sample_id列为行标识。",
      "- pcoa_coordinates.tsv / pcoa_eigenvalues.tsv：主29/G5分基底，全部正轴和原/校正谱，不适用高轴为NA。",
      "- G4_within_reactor_changes.tsv：11相邻实际节点+11基线至后期及真实间隔；G4_same_day_between_reactors.tsv：21个同期反应器对。",
      "- continuous_run_transitions.tsv：4个G1前后及2个G2→G3同轮比较；pairwise_sensitivity.tsv：528对完整主/敏感性距离；sensitivity_summary.tsv：主29/G4/G5分别汇总。",
      "- R1–R4_alpha_trajectories、G4_shannon_trajectories、main29_bray_pcoa、G5_bray_pcoa、G4_adjacent_changes、G4_between_reactor_distances、G5_alpha_diversity、G4_function_diversity_comparison、depth_sensitivity：12组PDF/PNG。",
      "- module12_review.md：简短解释审核及ASV证据附录；analysis_report.md及run.log：综合报告与实际运行记录。","",
      "## 科学局限","",
      "G1、G2/G3和G4的轮次不同，混合均分、保存59d和恢复构成来源依赖；不跨轮次当连续独立序列。G4缺R1-30d、不平衡取样且有重复测量；G5一母样每级分一份。采样瞬时环境未知，提取/PCR/测序子批次效应不可分离，阶段DO/时间/接种历史混杂，稳态性能记录未审阅。16S扩增、拷贝数和检测差异仍在。",
      "未执行无约束PERMANOVA、ANOVA、共现网络、因果或未经设计支持的独立样本检验。相对比例不是绝对生物量；功能关联不是活性证据。描述性PASS不表示推断前提通过。","",
      "## 复现及输入指纹","",
      "命令：`Rscript --vanilla scripts/diversity_analysis.R`；默认输出results/diversity/2026-11-04_v2。重跑须以`--output-dir 尚不存在的新版本目录`指定，已有目录拒绝覆盖，禁止输出到已撤回v1。无需磁盘中间文件。",
      paste0("脚本SHA-256：",sha(script)),"",md(data.frame(input=names(paths),path=unname(paths),bytes=file.info(paths)$size,sha256=unname(fingerprints)),0),"",
      md(data.frame(package=packages,version=vapply(packages,function(p)as.character(packageVersion(p)),character(1)))),"",
      "```",R.version.string,paste("RNGkind:",paste(RNGkind(),collapse=" / ")),capture.output(sessionInfo()),"```",
      paste0("完成时间：",stamp(),"；计时秒：",round(as.numeric(difftime(Sys.time(),started,units="secs")),3)))
    writeLines(report,report_path,useBytes=TRUE)
    cat("STATUS",paste(names(status),status,collapse=" / "),"\nEND",stamp(),"\n")
    append("docs/batch_01/analysis_log.md",c(paste0("### 2026-11-04 / 模块1.3有效v2计算完成（",stamp(),"）"),
      paste0("- 命令：",paste(commandArgs(),collapse=" "),"；当前输出：",out,"。"),
      sprintf("- 程序检查：%d PASS/%d WARNING/%d FAIL；输入锁定v2并匹配上游SHA-256，原count与对象逐格相同，设计名单/metadata、Alpha/Beta独立公式、PCoA全轴重构和10个TSV回读通过。",status[1],status[2],status[3]),
      sprintf("- 参数：未抽稀主分析，Shannon自然log、Simpson=1−Σp²、偏差校正Chao1；相对Bray、二元Jaccard；深度敏感性%d×%d、seed=%d；Hellinger、CLR伪计数0.5/1及固定低检出敏感性。",nmin,reps,seed),
      paste0("- 版本：",R.version.string,"；",paste(paste0(packages," ",vapply(packages,function(p)as.character(packageVersion(p)),character(1))),collapse="；"),"。完整时间/输入/脚本指纹在报告。"),
      sprintf("- 输出10份TSV、12组PDF/PNG、定向review、综合报告及run.log；%d个输入/设计/有效v2产物指纹不变。未改原metadata、RDS、实验设计及功能映射，未重跑上游QC。",length(protected)),
      "- 独立交付核验、图件目视及README/累计解释同步继续进行；所有结果仅描述，Chao1单例贫化、组成指标不一致和重复来源/单母样限制详见报告。"))
  },error=function(e){cat("FAIL",conditionMessage(e),"\n");append(report_path,c("# 运行未完成",paste0("FAIL：",conditionMessage(e)),md(checks)));stop(e)})
}
main()
