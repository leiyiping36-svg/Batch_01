#!/usr/bin/env Rscript
# Module 2.1: descriptive ASV decomposition; never rerun diversity or guild mapping.
# Rscript --vanilla scripts/g4_asv_contributions.R [--output-dir NEW_DIRECTORY]
main <- function() {
  Sys.setenv(TZ="Asia/Shanghai"); started <- Sys.time(); options(warn=1)
  script <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value=TRUE)))
  setwd(dirname(dirname(script)))
  out <- "results/asv_contributions/2026-11-05_v2"
  args <- commandArgs(trailingOnly=TRUE)
  if(length(args)) { stopifnot(length(args)==2, args[1]=="--output-dir"); out<-args[2] }
  if(grepl("_v1(/|$)",out)) stop("v1仅作历史；当前模块2.1统一为v2，禁止向v1输出。")
  audit_basis <- "results/asv_contributions/2026-11-05_v2/g4_design_addendum.md"
  if(dir.exists(out) && length(setdiff(list.files(out,all.files=TRUE,no..=TRUE),"g4_design_addendum.md")))
    stop("输出目录已有产物；拒绝覆盖，请指定新版本目录。")
  stopifnot(file.exists(audit_basis))
  if(!dir.exists(out)) stopifnot(dir.create(out,recursive=TRUE))
  if(!file.exists(file.path(out,"g4_design_addendum.md"))) {
    stopifnot(file.copy(audit_basis,file.path(out,"g4_design_addendum.md"),overwrite=FALSE))
    cat("\n复现说明：本文件为2026-11-05正式设计修改前审核的历史副本；本次复现不修改正式设计。\n",
        file=file.path(out,"g4_design_addendum.md"),append=TRUE)
  }
  log <- file(file.path(out,"run.log"),"wt",encoding="UTF-8")
  sink(log,split=TRUE); sink(log,type="message")
  on.exit({sink(type="message");sink();close(log)},add=TRUE)
  stamp<-function()format(Sys.time(),"%Y-%m-%d %H:%M:%S %Z")
  cat("START",stamp(),"\n",paste(commandArgs(),collapse=" "),"\n")
  checks<-data.frame(status=character(),item=character(),evidence=character())
  add<-function(s,i,e){checks[nrow(checks)+1L,]<<-c(s,i,e);cat(s,i,":",e,"\n")}
  need<-function(ok,i,e){add(if(isTRUE(ok))"PASS" else "FAIL",i,e);if(!isTRUE(ok))stop(i)}
  rd<-function(p,...)read.delim(p,check.names=FALSE,quote="",comment.char="",na.strings="NA",...)
  md<-function(d,digits=6){
    if(!nrow(d))return("（无）")
    d[]<-lapply(d,function(v){if(is.numeric(v))v<-format(round(v,digits),trim=TRUE,scientific=FALSE)
      v<-as.character(v);v[is.na(v)]<-"NA";gsub("|","/",v,fixed=TRUE)})
    c(paste0("| ",paste(names(d),collapse=" | ")," |"),paste0("|",paste(rep("---",ncol(d)),collapse="|"),"|"),
      apply(d,1,function(v)paste0("| ",paste(v,collapse=" | ")," |")))
  }
  put<-function(d,n){
    p<-file.path(out,n);stopifnot(!file.exists(p));write.table(d,p,sep="\t",quote=FALSE,row.names=FALSE,na="NA")
    z<-rd(p);stopifnot(nrow(z)==nrow(d),identical(names(z),names(d)))
    for(nm in names(d)[vapply(d,is.numeric,logical(1))])
      stopifnot(isTRUE(all.equal(as.numeric(d[[nm]]),as.numeric(z[[nm]]),tolerance=1e-12)))
    need(TRUE,paste(n,"回读"),paste(nrow(d),"行；字段及全部数值列往返一致。"))
  }
  tryCatch({
    need(all(vapply(c("digest","ggplot2"),requireNamespace,logical(1),quietly=TRUE)),"环境","仅复用现有R/digest/ggplot2，不安装软件。")
    suppressPackageStartupMessages(library(ggplot2))
    b11<-"results/community_composition/2026-11-03_v2";b12<-"results/functional_guilds/2026-11-03_v2";b13<-"results/diversity/2026-11-04_v2"
    stopifnot(all(grepl("_v2$",c(b11,b12,b13))))
    paths<-c(counts="data/asv_table.tsv",taxonomy="data/taxonomy.tsv",sequences="data/exported_sequences/dna-sequences.fasta",
      object="results/phyloseq/batch_01_phyloseq.rds",source_metadata="metadata/source_sample_metadata.tsv",
      metadata=file.path(b11,"analysis_metadata.tsv"),genus=file.path(b11,"genus_relative_abundance.tsv"),
      report11=file.path(b11,"analysis_report.md"),annotation=file.path(b12,"functional_asv_annotation.tsv"),
      evidence=file.path(b12,"functional_mapping_evidence.tsv"),functional_taxa=file.path(b12,"functional_taxa_abundance.tsv"),
      report12=file.path(b12,"analysis_report.md"),report13=file.path(b13,"analysis_report.md"),
      sensitivity=file.path(b13,"pairwise_sensitivity.tsv"),bray=file.path(b13,"bray_curtis_distance.tsv"),
      jaccard=file.path(b13,"jaccard_distance.tsv"),within=file.path(b13,"G4_within_reactor_changes.tsv"),
      between=file.path(b13,"G4_same_day_between_reactors.tsv"),sensitivity_summary=file.path(b13,"sensitivity_summary.tsv"),
      design="docs/batch_01/experiment_design.md",context="docs/research_context.md",plan="docs/batch_01/analysis_plan.md",rules="AGENTS.md",audit=audit_basis)
    need(all(file.exists(paths)),"输入存在","原始count/taxonomy、三个有效v2及设计/审核均存在。")
    sha<-function(p)digest::digest(file=p,algo="sha256")
    fingerprints<-vapply(paths,sha,character(1));script_sha<-sha(script)
    up<-readLines(paths["report13"],warn=FALSE)
    for(n in c("counts","taxonomy","sequences","object","source_metadata","metadata","genus","annotation","evidence","functional_taxa"))
      stopifnot(any(grepl(paths[n],up,fixed=TRUE)&grepl(fingerprints[n],up,fixed=TRUE)))
    need(TRUE,"有效版本来源","原输入、RDS及组成/功能v2输入SHA-256逐项匹配模块1.3有效v2报告；不使用历史v1。")
    protected<-unique(c(paths,script,list.files(b11,full.names=TRUE),list.files(b12,full.names=TRUE),list.files(b13,full.names=TRUE),
      list.files("data",recursive=TRUE,full.names=TRUE),list.files("input",recursive=TRUE,full.names=TRUE),list.files("metadata",recursive=TRUE,full.names=TRUE)))
    protected<-protected[!dir.exists(protected)];before<-vapply(protected,sha,character(1))
    raw<-rd(paths["counts"],skip=1);features<-raw[[1]];x<-as.matrix(raw[,-1]);storage.mode(x)<-"double";rownames(x)<-features
    need(identical(dim(x),c(5510L,33L))&&!anyDuplicated(features)&&!anyDuplicated(colnames(x))&&!anyNA(x)&&
      all(is.finite(x))&&all(x>=0&x==floor(x))&&all(colSums(x)>0),"分析输入格式","5510×33非负整数count、ID唯一、无NA/空样本；已有深度QC由指纹复用，不重新筛查异常。")
    meta<-rd(paths["metadata"],colClasses="character");source<-rd(paths["source_metadata"],colClasses="character")
    stopifnot(!anyDuplicated(meta[[1]]),!anyDuplicated(source[[1]]),setequal(meta[[1]],colnames(x)),setequal(source[[1]],colnames(x)))
    meta<-meta[match(colnames(x),meta[[1]]),];source<-source[match(colnames(x),source[[1]]),];rownames(meta)<-rownames(source)<-colnames(x)
    need(identical(meta[,names(source),drop=FALSE],source),"原metadata完整性","原33行14列逐值保留；派生表只追加字段。")
    design<-readLines(paths["design"],warn=FALSE)
    for(g in paste0("G",1:5)){
      ln<-grep(paste0("^\\| ",g," \\|.*Batch_01_"),design,value=TRUE);stopifnot(length(ln)==1)
      ids<-regmatches(ln,gregexpr("Batch_01_[A-Z][0-9]",ln))[[1]];stopifnot(setequal(ids,meta[[1]][meta$group==g]))
    }
    stopifnot(identical(as.integer(table(factor(meta$group,levels=paste0("G",1:5)))),c(8L,2L,4L,15L,4L)))
    g4i<-which(meta$group=="G4");g4ids<-meta[[1]][g4i];short<-meta$supplier_sample_id;names(short)<-meta[[1]]
    reactor<-c(Reactor_01="R1",Reactor_02="R2",Reactor_03="R3",Reactor_04="R4")[meta$reactor_id];names(reactor)<-meta[[1]]
    day<-as.numeric(meta$phase_days);names(day)<-meta[[1]]
    baseline<-c(R1="Batch_01_E1",R2="Batch_01_F1",R3="Batch_01_G1",R4="Batch_01_H1")
    presource<-c(R1="Batch_01_A2",R2="Batch_01_B3",R3="Batch_01_C2",R4="Batch_01_D3")
    expected<-list(R1=c(E1=1,E2=76,E3=145),R2=c(F1=1,F2=30,F3=76,F4=145),R3=c(G1=1,G2=30,G3=76,G4=145),R4=c(H1=1,H2=30,H3=76,H4=145))
    for(r in names(expected)){
      ii<-g4i[reactor[g4i]==r];stopifnot(setequal(short[ii],names(expected[[r]])),all(day[ii]==expected[[r]][short[ii]]))
      bi<-match(baseline[r],meta[[1]]);stopifnot(meta$source_sample_id[bi]==presource[r],day[bi]==1,
        meta$stage_subphase[bi]=="recovered_baseline_before_low_DO_switch")
    }
    late<-g4i[day[g4i]>1]
    stopifnot(length(late)==11,all(meta$DO_setpoint_mg_L[late]=="0.5"),all(meta$DO_setting_lower_mg_L[late]=="0.3"),
      all(meta$DO_setting_upper_mg_L[late]=="0.7"),all(meta$sampling_position_relative_to_DO_switch[late]=="after_switch"),all(is.na(meta$DO_measured_mg_L)),
      all(is.na(meta$DO_setpoint_mg_L[match(baseline,meta[[1]])])),all(meta$design_document_DO_setpoint_mg_L[match(baseline,meta[[1]])]=="3"))
    need(TRUE,"样本级设计门控","33完整ID及8/2/4/15/4；15个G4节点/反应器/前源/阶段/设置逐项匹配。R1无30d不插补。")
    tax<-rd(paths["taxonomy"]);ann<-rd(paths["annotation"])
    stopifnot(!anyDuplicated(tax[[1]]),!anyDuplicated(ann$feature_id),setequal(features,tax[[1]]),setequal(features,ann$feature_id))
    tax<-tax[match(features,tax[[1]]),];ann<-ann[match(features,ann$feature_id),]
    need(identical(ann$feature_id,features)&&identical(tax$Taxon,ann$original_taxonomy)&&
      max(abs(tax$Confidence-ann$taxonomy_classifier_confidence))<1e-12,"taxonomy与功能连接","全部5510 ASV完整原谱系、原Confidence及功能v2逐项相符；不修改taxonomy或重映射功能。代表序列沿用已验证指纹。")
    stopifnot(all(is.na(ann$conservative_guild[ann$genus%in%c("Acinetobacter","Nitrospira","Dechloromonas","Thauera")])))
    p<-sweep(x,2,colSums(x),"/");stopifnot(max(abs(colSums(p)-1))<1e-12)
    # New fields only: preserve every previous column, including historical DO disagreement.
    old_meta<-meta;src<-"docs/batch_01/experiment_design.md#2026-11-05-G4-conditions;results/asv_contributions/2026-11-05_v2/g4_design_addendum.md"
    newfields<-c("temperature_regime","temperature_setpoint_C","temperature_measured_C","temperature_data_source","temperature_assignment_scope",
      "G4_initial_sludge_id","G4_initial_sludge_characteristics","G4_initial_sludge_distinctness","G4_initial_sludge_data_source",
      "G4_initial_sample_id","G4_pre_storage_source_sample_id","G4_inherited_pool_id","G4_historical_storage_temperature_C","G4_historical_storage_days",
      "G4_lineage_data_source","G4_baseline_recovery_DO_setpoint_mg_L","G4_baseline_recovery_DO_data_source","module21_metadata_version")
    stopifnot(!any(newfields%in%names(meta)))
    for(n in newfields)meta[[n]]<-NA_character_
    for(i in g4i){
      r<-reactor[i];heated<-r%in%c("R1","R3")
      meta$temperature_regime[i]<-if(heated)"controlled_30C" else "ambient_unmeasured"
      if(heated)meta$temperature_setpoint_C[i]<-"30"
      meta$temperature_data_source[i]<-src
      meta$temperature_assignment_scope[i]<-"G4_operating_regime_only_not_baseline_measurement_or_recovery_temperature"
      meta$G4_initial_sludge_distinctness[i]<-"different_per_reactor_user_confirmed_characteristics_and_initial_community"
      meta$G4_initial_sludge_data_source[i]<-src
      meta$G4_initial_sample_id[i]<-baseline[r];meta$G4_pre_storage_source_sample_id[i]<-presource[r]
      meta$G4_inherited_pool_id[i]<-if(r%in%c("R1","R2"))"post_G1_pool_R1_R2" else "post_G1_pool_R3_R4"
      meta$G4_historical_storage_temperature_C[i]<-"4";meta$G4_historical_storage_days[i]<-"59"
      meta$G4_lineage_data_source[i]<-"docs/batch_01/experiment_design.md#2026-11-02-design-correction"
      if(day[i]==1){meta$G4_baseline_recovery_DO_setpoint_mg_L[i]<-"3"
        meta$G4_baseline_recovery_DO_data_source[i]<-"docs/batch_01/experiment_design.md#2026-11-03-DO-settings"}
    }
    meta$module21_metadata_version<-"module2.1_2026-11-05_v2"
    stopifnot(identical(meta[,names(old_meta)],old_meta),all(is.na(meta$temperature_measured_C)),
      all(is.na(meta$G4_initial_sludge_id)),all(is.na(meta$G4_initial_sludge_characteristics)),
      all(is.na(meta$temperature_regime[-g4i])),sum(meta$temperature_setpoint_C=="30",na.rm=TRUE)==7)
    need(TRUE,"派生条件边界","保留全部旧45列；新增18列。G4恒温目标7行30℃，室温8行目标NA；全部实测/污泥编号/具体性状NA；前源和历史混合块保留。")
    put(meta,"analysis_metadata_addendum.tsv")
    add("WARNING","科研推断门控关闭","四份G4起始污泥不同、四反应器重复测量、混合谱系/保存恢复依赖，温度与个体/初始状态混杂；不拟合模型或做显著性/网络。")
    add("WARNING","温度/DO/稳态","室温数值与实测温度、瞬时DO未知；运行条件标签不回推恢复期实测。后期是设计稳定运行期，性能稳态记录未审阅。")
    pair<-data.frame(pair_id=c("R2_R4_d1","R2_R4_d30","R2_R4_d76","R2_R4_d145","R1_R2_d1","R1_R2_d76","R1_R2_d145","R3_d30_d76","R3_d76_d145","R2_d76_d145"),
      series=c(rep("R2_R4",4),rep("R1_R2",3),"R3_within","R3_within","R2_within"),
      a=paste0("Batch_01_",c("F1","F2","F3","F4","E1","E2","E3","G2","G3","F3")),
      b=paste0("Batch_01_",c("H1","H2","H3","H4","F1","F3","F4","G3","G4","F4")))
    stopifnot(all(pair$a%in%g4ids),all(pair$b%in%g4ids))
    pair$day_a<-day[pair$a];pair$day_b<-day[pair$b]
    sens<-rd(paths["sensitivity"]);bm<-rd(paths["bray"],row.names=1);jm<-rd(paths["jaccard"],row.names=1)
    key<-function(a,b)paste(pmin(a,b),pmax(a,b),sep="::")
    stopifnot(!anyDuplicated(key(sens$sample_a,sens$sample_b)))
    si<-match(key(pair$a,pair$b),key(sens$sample_a,sens$sample_b));stopifnot(!anyNA(si))
    metriccols<-setdiff(names(sens),c("sample_a","sample_b","group_a","group_b"))
    distances<-cbind(pair,sens[si,metriccols]);rownames(distances)<-NULL
    for(j in seq_len(nrow(pair))){
      stopifnot(abs(distances$Bray_Curtis[j]-bm[pair$a[j],pair$b[j]])<1e-12,
        abs(distances$Jaccard_binary[j]-jm[pair$a[j],pair$b[j]])<1e-12,
        abs(sum(abs(p[,pair$a[j]]-p[,pair$b[j]]))/2-distances$Bray_Curtis[j])<1e-12)
    }
    need(TRUE,"距离复用核验","10对Bray/Jaccard/Hellinger/两CLR/深度及低检出敏感性直接提取模块1.3；仅核对ASV贡献和=既有Bray，无全流程Beta重算。")
    put(distances,"focal_distance_summary.tsv")
    # Preserve complete ancestry when grouping; unresolved genus stays in its actual parent lineage.
    genuskey<-vapply(strsplit(ann$original_taxonomy,";",fixed=TRUE),function(v){
      gi<-grep("^g__",v);if(length(gi))paste(v[seq_len(gi[1])],collapse=";") else paste(v[!grepl("^s__",v)],collapse=";")
    },character(1))
    genuslabel<-ann$genus;genuslabel[is.na(genuslabel)]<-"Unclassified_genus"
    gkeys<-unique(genuskey);gidx<-match(genuskey,gkeys);glab<-genuslabel[match(gkeys,genuskey)]
    contr<-vector("list",nrow(pair));gencontr<-contr
    for(j in seq_len(nrow(pair))){
      a<-p[,pair$a[j]];b<-p[,pair$b[j]];d<-abs(a-b);bc<-distances$Bray_Curtis[j]
      rank<-integer(length(features));rank[order(-d,features)]<-seq_along(d)
      contr[[j]]<-data.frame(pair_id=pair$pair_id[j],sample_a=pair$a[j],sample_b=pair$b[j],day_a=pair$day_a[j],day_b=pair$day_b[j],
        feature_id=features,relative_abundance_a=a,relative_abundance_b=b,signed_difference_b_minus_a=b-a,absolute_difference=d,
        bray_contribution=d/2,share_of_pair_Bray=if(bc>0)d/(2*bc) else NA_real_,shared_ASV_overlap=pmin(a,b),
        common_high_abundance=a>=0.01&b>=0.01,contribution_rank=rank,genus=ann$genus,genus_key=genuskey,
        original_taxonomy=ann$original_taxonomy,taxonomy_classifier_confidence=ann$taxonomy_classifier_confidence)
      ga<-as.numeric(rowsum(a,gidx,reorder=FALSE));gb<-as.numeric(rowsum(b,gidx,reorder=FALSE));gc<-as.numeric(rowsum(d/2,gidx,reorder=FALSE))
      ov<-as.numeric(rowsum(pmin(a,b),gidx,reorder=FALSE));coarse<-abs(ga-gb)/2
      gencontr[[j]]<-data.frame(pair_id=pair$pair_id[j],sample_a=pair$a[j],sample_b=pair$b[j],genus=glab,genus_key=gkeys,
        abundance_a=ga,abundance_b=gb,signed_difference_b_minus_a=gb-ga,asv_absolute_difference_sum=2*gc,
        asv_sum_bray_contribution=gc,share_of_ASV_Bray=gc/bc,genus_aggregated_bray_contribution=coarse,
        within_genus_cancellation=gc-coarse,shared_identical_ASV_overlap=ov,genus_label_overlap=pmin(ga,gb))
      stopifnot(abs(sum(gc)-bc)<1e-12,all(gc-coarse> -1e-12),abs(sum(pmin(a,b))-(1-bc))<1e-12,
        max(abs((pmin(ga,gb)-ov)-(gc-coarse)))<1e-12)
    }
    contr<-do.call(rbind,contr);gencontr<-do.call(rbind,gencontr)
    need(TRUE,"ASV/属分解恒等式","10对各保留5510 ASV（含双零）；Σ|pA−pB|/2=原Bray。属内累计≥属总量先求差；差额=属标签共享量−同ASV共享量。未分类按原父谱系分别保留。")
    put(contr,"focal_pairwise_asv_contributions.tsv");put(gencontr,"focal_pairwise_genus_contributions.tsv")
    # Signed temporal gap changes and reactor changes in one necessary full-length table.
    temporal<-list();ti<-0L
    for(series in c("R2_R4","R1_R2")){
      jj<-which(pair$series==series)
      for(k in seq_len(length(jj)-1)){
        q0<-jj[k];q1<-jj[k+1];a0<-p[,pair$a[q0]];b0<-p[,pair$b[q0]];a1<-p[,pair$a[q1]];b1<-p[,pair$b[q1]]
        dc<-(abs(a1-b1)-abs(a0-b0))/2;ti<-ti+1L
        temporal[[ti]]<-data.frame(comparison_id=paste0(series,"_",pair$day_a[q0],"_to_",pair$day_a[q1]),comparison_type="between_reactors_gap_change",
          feature_id=features,genus=ann$genus,day_from=pair$day_a[q0],day_to=pair$day_a[q1],
          sample_a_from=pair$a[q0],sample_b_from=pair$b[q0],sample_a_to=pair$a[q1],sample_b_to=pair$b[q1],
          abundance_a_from=a0,abundance_b_from=b0,abundance_a_to=a1,abundance_b_to=b1,
          delta_abundance_a=a1-a0,delta_abundance_b=b1-b0,absolute_gap_from=abs(a0-b0),absolute_gap_to=abs(a1-b1),
          delta_bray_contribution=dc,within_reactor_bray_contribution=NA_real_,
          gap_direction=ifelse(dc< -1e-12,"shrinking",ifelse(dc>1e-12,"expanding","unchanged")),
          common_high_from=a0>=0.01&b0>=0.01,common_high_to=a1>=0.01&b1>=0.01,
          noticeable_a=abs(a1-a0)>=0.01,noticeable_b=abs(b1-b0)>=0.01)
        stopifnot(abs(sum(dc)-(distances$Bray_Curtis[q1]-distances$Bray_Curtis[q0]))<1e-12)
      }
    }
    for(r in names(expected)){
      ii<-g4i[reactor[g4i]==r];ii<-ii[order(day[ii])]
      for(k in seq_len(length(ii)-1)){
        u<-ii[k];v<-ii[k+1];a0<-p[,u];a1<-p[,v];ti<-ti+1L
        temporal[[ti]]<-data.frame(comparison_id=paste0(r,"_",day[u],"_to_",day[v]),comparison_type="within_reactor_abundance_change",
          feature_id=features,genus=ann$genus,day_from=day[u],day_to=day[v],
          sample_a_from=meta[[1]][u],sample_b_from=NA_character_,sample_a_to=meta[[1]][v],sample_b_to=NA_character_,
          abundance_a_from=a0,abundance_b_from=NA_real_,abundance_a_to=a1,abundance_b_to=NA_real_,delta_abundance_a=a1-a0,delta_abundance_b=NA_real_,
          absolute_gap_from=NA_real_,absolute_gap_to=NA_real_,delta_bray_contribution=NA_real_,within_reactor_bray_contribution=abs(a1-a0)/2,
          gap_direction=NA_character_,common_high_from=NA,common_high_to=a0>=0.01&a1>=0.01,noticeable_a=abs(a1-a0)>=0.01,noticeable_b=NA)
      }
    }
    temporal<-do.call(rbind,temporal);temporal$interval_days<-temporal$day_to-temporal$day_from
    need(nrow(temporal)==16L*5510L,"时间变化方向与守恒","5个同期跨时段差额+11个反应器内相邻转移，全ASV保留。差额=后贡献−前贡献；缩小负、扩大正。区间天数保留，不作因果/动力学速率。")
    put(temporal,"focal_temporal_asv_changes.tsv")
    targets<-c("Candidatus_Competibacter","Defluviicoccus","Acinetobacter")
    gmean<-rowMeans(p[,g4ids,drop=FALSE]);ann$G4_mean_relative_abundance<-gmean
    ann$G4_target_genus_rank<-NA_integer_
    for(g in targets){ii<-which(ann$genus%in%g);ann$G4_target_genus_rank[ii[order(-gmean[ii],features[ii])]]<-seq_along(ii)}
    ann$target_genus_top5<-!is.na(ann$G4_target_genus_rank)&ann$G4_target_genus_rank<=5
    ann$focal_pair_top10<-features%in%contr$feature_id[contr$contribution_rank<=10]
    ann$any_focal_pair_common_high<-features%in%contr$feature_id[contr$common_high_abundance]
    ann$any_within_change_ge1pp<-features%in%temporal$feature_id[temporal$comparison_type=="within_reactor_abundance_change"&temporal$noticeable_a]
    put(ann,"focal_asv_function_annotations.tsv")
    trajectories<-do.call(rbind,lapply(g4i,function(i){
      ga<-as.numeric(rowsum(p[,i],gidx,reorder=FALSE))[gidx]
      data.frame(feature_id=features,sample_id=meta[[1]][i],reactor=reactor[i],day=day[i],stage_subphase=meta$stage_subphase[i],
        count=x[,i],relative_abundance=p[,i],genus=ann$genus,genus_key=genuskey,genus_relative_abundance=ga,
        within_genus_fraction=ifelse(ga>0,p[,i]/ga,NA_real_),target_genus_top5=ann$target_genus_top5,
        temperature_regime=meta$temperature_regime[i])
    }))
    stopifnot(nrow(trajectories)==5510L*15L)
    put(trajectories,"focal_asv_abundance_trajectories.tsv")
    # Plot panels: imported distances, full-ID ASV contribution changes, endpoint abundance heatmaps.
    theme_set(theme_bw(base_size=10,base_family="DejaVu Sans")+theme(panel.grid.minor=element_blank(),plot.title.position="plot"))
    distance_plot<-function(ds,xcol,title){
      metrics<-c("Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth","CLR_pc1_at_min_depth")
      dd<-do.call(rbind,lapply(metrics,function(m)data.frame(x=ds[[xcol]],metric=m,value=ds[[m]])))
      ggplot(dd,aes(x,value))+geom_line(aes(group=1),colour="#2166ac")+geom_point(size=2)+
        geom_text(aes(label=sprintf("%.3f",value)),vjust=-0.6,size=2.8)+facet_wrap(~metric,scales="free_y",nrow=1)+
        scale_x_continuous(breaks=sort(unique(dd$x)))+scale_y_continuous(expand=expansion(mult=c(.15,.3)))+
        labs(title=title,x="G4 day (observed endpoints)",y="Distance (units differ by metric)")
    }
    labels_for<-function(ids)paste0(ids,"\n",genuslabel[match(ids,features)])
    rank10<-function(v)order(-abs(v),features)[seq_len(10)]
    heat<-function(ids,samples,title){
      hh<-trajectories[trajectories$feature_id%in%ids&trajectories$sample_id%in%samples,]
      hh$ASV<-factor(labels_for(hh$feature_id),levels=rev(labels_for(ids)))
      hh$sample<-factor(paste0(short[hh$sample_id]," (",day[hh$sample_id],"d)"),levels=paste0(short[samples]," (",day[samples],"d)"))
      ggplot(hh,aes(sample,ASV,fill=100*relative_abundance))+geom_tile(colour="white")+
        geom_text(aes(label=sprintf("%.2f",100*relative_abundance)),size=2.7)+scale_fill_gradient(low="#fff7ec",high="#b30000")+
        labs(title=title,x=NULL,y=NULL,fill="All reads (%)")+theme(axis.text.y=element_text(size=8),axis.text.x=element_text(size=9))
    }
    bar_delta<-function(tt,title){
      ii<-rank10(tt$delta_bray_contribution);dd<-tt[ii,];dd$ASV<-factor(labels_for(dd$feature_id),levels=rev(labels_for(dd$feature_id)))
      ggplot(dd,aes(delta_bray_contribution,ASV,fill=gap_direction))+geom_col()+geom_vline(xintercept=0)+
        scale_fill_manual(values=c(shrinking="#2166ac",expanding="#b2182b",unchanged="grey70"))+
        labs(title=title,x="Later contribution - earlier contribution (negative = shrinking)",y=NULL)+
        theme(axis.text.y=element_text(size=8),legend.position="bottom")
    }
    save_panels<-function(plots,name){
      for(pp in plots)stopifnot(length(ggplot_build(pp)$data)>0)
      draw<-function(){grid::grid.newpage();grid::pushViewport(grid::viewport(layout=grid::grid.layout(3,1,heights=grid::unit(c(3.0,6.3,6.7),"null"))))
        for(k in seq_along(plots))print(plots[[k]],vp=grid::viewport(layout.pos.row=k,layout.pos.col=1));grid::popViewport()}
      grDevices::cairo_pdf(file.path(out,paste0(name,".pdf")),width=15,height=16,family="DejaVu Sans");draw();grDevices::dev.off()
      grDevices::png(file.path(out,paste0(name,".png")),width=2400,height=2560,res=160,type="cairo");draw();grDevices::dev.off()
      need(TRUE,paste(name,"图层"),"三面板实际构建；PDF/PNG；ASV完整ID、百分比分母和有符号变化可读取。")
    }
    for(s in c("R2_R4","R1_R2")){
      ds<-distances[distances$series==s,];tt<-temporal[temporal$comparison_id==paste0(s,"_76_to_145"),];ii<-rank10(tt$delta_bray_contribution)
      sam<-unique(as.vector(t(as.matrix(ds[,c("a","b")]))))
      save_panels(list(distance_plot(ds,"day_a",paste(s,"- imported module 1.3 distances")),
        bar_delta(tt,paste(s,"76 to 145d: Top 10 by absolute change in Bray contribution")),
        heat(tt$feature_id[ii],sam,"Same Top 10 ASVs: abundance trajectories; selection uses all ASVs")),
        if(s=="R2_R4")"R2_R4_convergence" else "R1_R2_divergence")
    }
    tt<-contr[contr$pair_id=="R3_d76_d145",];ii<-order(-tt$bray_contribution,tt$feature_id)[1:10]
    dd<-tt[ii,];dd$ASV<-factor(labels_for(dd$feature_id),levels=rev(labels_for(dd$feature_id)))
    pp<-ggplot(dd,aes(bray_contribution,ASV))+geom_col(fill="#6a51a3")+
      labs(title="R3 76 to 145d: Top 10 ASV endpoint-difference contributions",x="|p145 - p76| / 2",y=NULL)+theme(axis.text.y=element_text(size=8))
    ids<-features[order(-rowMeans(p[,paste0("Batch_01_",c("G2","G3","G4"))]),features)[1:10]]
    ds<-distances[distances$series=="R3_within",]
    save_panels(list(distance_plot(ds,"day_b","R3 adjacent late intervals: 30-76d and 76-145d (different lengths)"),pp,
      heat(ids,paste0("Batch_01_",c("G2","G3","G4")),"R3 late-period Top 10 by mean relative abundance (all observed nodes)")),"R3_late_composition_persistence")
    # Tables for the Chinese report; every numeric statement comes from the objects above.
    report<-c("# 模块2.1：G4条件补充与ASV群落趋近、分化及贡献（2026-11-05）","",
      paste0("当前输出：",out,"。运行起点：",format(started,"%Y-%m-%d %H:%M:%S %Z"),"。本报告只支持描述性组成分析，统计/因果推断门控关闭。"),"",
      "## 检查报告、设计差异及数据边界","",
      "已先完成[g4_design_addendum.md](g4_design_addendum.md)差异审核，随后正式设计仅追加2026-11-05节。以有效组成/功能2026-11-03_v2和多样性2026-11-04_v2为基础。33样本、5510 ASV、G1–G5=8/2/4/15/4保持。原count、taxonomy、原metadata、RDS及三个有效v2均不覆盖。未重跑DADA2、SILVA、测序QC、Alpha/Beta全流程或功能映射。", "",
      "R1/R3为G4 30℃保温运行标签，R2/R4为室温运行，实际室温及所有采样实测温度未知。G4四份起始污泥性状与菌群均不同是用户确认；具体编号、性状记录为NA，不能用测序样本号/絮状颗粒设计类型替代。温度字段不外推其他模块或恢复阶段实测。", "",
      "四个初始样本E1/F1/原G1/H1对应R1/R2/R3/R4，均在低DO切换前。后期11样本DO阶段设置0.5±0.2 mg/L。旧派生表全部45列保留；旧分析基线DO=NA与design_document=3差异不改写，新字段单独引用2026-11-03恢复设置3。全部瞬时DO未知。混合均分、4℃59天保存恢复及来源块由新字段追踪，起始状态不同并不消除历史依赖。", "",
      "[analysis_metadata_addendum.tsv](analysis_metadata_addendum.tsv)新增18列，33行。具体起始污泥编号/性状、室温实测记录、基线/恢复期温度范围和运行性能稳态证据待人工补充；这些未知项不阻断本次描述性贡献计算。", "",
      "## 方法与预先固定规则","",
      "以全部ASV原count/各样本全部reads得p，不过滤、不稀释、不改taxonomy。每对样本每ASV贡献c_i=|pAi−pBi|/(ΣpA+ΣpB)=|pAi−pBi|/2；贡献份额=c_i/Bray。所有5510 ASV含双零行保存，完整原taxonomy及分类置信度并列。共享相同ASV组成量=Σmin(pAi,pBi)=1−Bray。该共享量是读数比例重叠，不代表共同来源或活菌转移。", "",
      "属汇总算法A=Σ属内|pAi−pBi|/2；算法B=|Σ属内pAi−Σ属内pBi|/2。A才是ASV距离在该属的贡献，B是另一个分辨率的属级距离贡献；A≥B，差额揭示属内正负丰度变化抵消。按完整祖先谱系分组，未分类保留原父谱系，不能将所有未知属混成一个生物属。属标签相似不自动等于相同ASV相似。", "",
      "跨时段差额Δc=c_late−c_early，负值为端点差缩小、正值扩大；同时输出两反应器各自有符号丰度变化，不能把贡献变化当因果。反应器内转移另列为|p_to−p_from|/2，不混作跨反应器距离差。R1缺30d，不插补，不把端点距离当累计周转或除以天数当真实速率。", "",
      "Top N=10，按绝对贡献/绝对贡献变化排序并以完整ASV ID打破并列。共同高丰度=两端均≥1%；明显升降=变化≥1个百分点，仅为描述性筛选，不是统计显著性。三目标属主要ASV=该属G4全部15个记录等权均值Top5；完整轨迹与功能连接仍保留5510 ASV。后期阶段均值不按时间积分，也不当独立重复均值。", "",
      "## A. 已计算的距离与ASV贡献","",
      "所有下列距离从模块1.3复用；不同单位不直接比较绝对大小。", "",
      md(distances[,c("pair_id","day_a","day_b","Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth","CLR_pc1_at_min_depth")]),"",
      "### Q1/Q2：R2–R4趋近与R1–R2分化的数学来源","",
      "下表分别加总全部ASV端点差缩小和扩大项，两者抵消得到距离净变化。负项表示对距离下降的数学贡献，不称生态驱动因子。","守恒摘要：")
    changesum<-do.call(rbind,lapply(unique(temporal$comparison_id[temporal$comparison_type=="between_reactors_gap_change"]),function(z){
      v<-temporal$delta_bray_contribution[temporal$comparison_id==z]
      data.frame(comparison=z,shrinking_sum=sum(v[v<0]),expanding_sum=sum(v[v>0]),net_Bray_change=sum(v))}))
    report<-c(report,md(changesum),"")
    delta_table<-function(t,dir,n=10){
      ii<-which(if(dir=="shrinking")t$delta_bray_contribution< -1e-12 else t$delta_bray_contribution>1e-12)
      ii<-ii[order(-abs(t$delta_bray_contribution[ii]),t$feature_id[ii])];ii<-head(ii,n)
      data.frame(ASV=t$feature_id[ii],genus=genuslabel[match(t$feature_id[ii],features)],
        A_early_pct=100*t$abundance_a_from[ii],B_early_pct=100*t$abundance_b_from[ii],A_late_pct=100*t$abundance_a_to[ii],B_late_pct=100*t$abundance_b_to[ii],
        delta_Bray=t$delta_bray_contribution[ii],A_delta_pp=100*t$delta_abundance_a[ii],B_delta_pp=100*t$delta_abundance_b[ii])
    }
    for(s in c("R2_R4","R1_R2")){
      tt<-temporal[temporal$comparison_id==paste0(s,"_76_to_145"),]
      report<-c(report,paste0("#### ",s," 76→145d：端点差缩小ASV（Top10）"),"",md(delta_table(tt,"shrinking")),"",
        paste0("#### ",s," 76→145d：端点差扩大ASV（Top10）"),"",md(delta_table(tt,"expanding")),"")
      gg<-gencontr[gencontr$pair_id==paste0(s,"_d145"),]
      gg<-gg[order(-gg$asv_sum_bray_contribution,gg$genus_key),]
      report<-c(report,"末期仍存差异的属/原谱系Top10（ASV贡献与属总量差分开）：","",
        md(head(gg[,c("genus","genus_key","abundance_a","abundance_b","asv_sum_bray_contribution","genus_aggregated_bray_contribution","within_genus_cancellation")],10)),"")
    }
    report<-c(report,"### 共同高丰度ASV：与差缩小/扩大分开列出","",
      "下表只按两端均≥1%筛选，再按最小端点丰度排序取前10；并不要求差异贡献高。全部共同高丰度标记保存在贡献表中。","")
    for(z in c("R2_R4_d145","R1_R2_d145","R3_d30_d76","R3_d76_d145")){
      tt<-contr[contr$pair_id==z&contr$common_high_abundance,];tt<-tt[order(-pmin(tt$relative_abundance_a,tt$relative_abundance_b),tt$feature_id),]
      report<-c(report,paste0("**",z,"**"),"",md(head(tt[,c("feature_id","genus","relative_abundance_a","relative_abundance_b","bray_contribution","shared_ASV_overlap")],10)),"")
    }
    report<-c(report,"### 单一反应器明显升/降ASV：不以属总量代替","",
      "分别列R1/R2/R3/R4末段76→145d；变化按相对丰度百分点，≥1个百分点且方向正/负才列出。全11段全部ASV在时间变化表中。","")
    for(r in paste0("R",1:4)){
      tt<-temporal[temporal$comparison_id==paste0(r,"_76_to_145"),]
      for(direction in c("上升","下降")){
        ii<-which(if(direction=="上升")tt$delta_abundance_a>=0.01 else tt$delta_abundance_a<= -0.01)
        ii<-head(ii[order(-abs(tt$delta_abundance_a[ii]),tt$feature_id[ii])],10)
        report<-c(report,paste0("**",r," ",direction,"（Top10）**"),"",md(data.frame(feature_id=tt$feature_id[ii],genus=tt$genus[ii],
          from_pct=100*tt$abundance_a_from[ii],to_pct=100*tt$abundance_a_to[ii],delta_pp=100*tt$delta_abundance_a[ii])),"")
      }
    }
    report<-c(report,"### Q3：R3后期较小变化的组成支撑及相邻间隔比较","",
      "共同高丰度ASV可以维持较大共享量，低丰度或成员检出仍可更替；下面使用全部ASV的共享量1−Bray及Top10贡献份额核对。不存在凭低距离证明运行稳态的推断。","")
    r3sum<-do.call(rbind,lapply(c("R3_d30_d76","R3_d76_d145"),function(z){
      tt<-contr[contr$pair_id==z,];data.frame(pair_id=z,shared_identical_ASV_overlap=sum(tt$shared_ASV_overlap),
        common_high_ASVs=sum(tt$common_high_abundance),common_high_shared_overlap=sum(tt$shared_ASV_overlap[tt$common_high_abundance]),
        Top10_Bray_share=sum(tt$bray_contribution[tt$contribution_rank<=10])/sum(tt$bray_contribution))}))
    report<-c(report,md(r3sum),"", "同区间其他反应器对照（复用模块1.3，R1缺30d）：","")
    within<-rd(paths["within"]);stopifnot(sum(within$comparison=="adjacent_observed"&within$day_from>=30)==7)
    report<-c(report,md(within[within$comparison=="adjacent_observed"&within$day_from>=30,
      c("reactor_from","day_from","day_to","interval_days","Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth")]),"")
    report<-c(report,"### Q4/Q5：关键贡献ASV与已审阅功能连接","",
      "下表为各指定对Top3贡献ASV（全Top10及全量见TSV）。功能原样连接模块1.2，不把距离贡献叫作功能过程贡献。未命中既有功能规则的ASV继续未分配；未知属照常计入ASV距离。","")
    tt<-contr[contr$contribution_rank<=3,];tt<-tt[order(match(tt$pair_id,pair$pair_id),tt$contribution_rank),]
    aa<-ann[match(tt$feature_id,ann$feature_id),]
    report<-c(report,md(data.frame(pair_id=tt$pair_id,feature_id=tt$feature_id,genus=tt$genus,contribution=tt$bray_contribution,
      share=tt$share_of_pair_Bray,exclusive_partition=aa$exclusive_partition,proposed_guild=aa$proposed_guild)),"",
      "#### R2/R4末期：相同ASV重叠与仅属标签重叠","",
      "同ASV重叠=属内Σmin(pF4_i,pH4_i)，属标签重叠=min(ΣpF4_i,ΣpH4_i)；后者可掩盖属内ASV替换。不是同一物种/菌株或独立生态复现的证明。","")
    gg<-gencontr[gencontr$pair_id=="R2_R4_d145"&gencontr$genus%in%targets,]
    report<-c(report,md(gg[,c("genus","abundance_a","abundance_b","shared_identical_ASV_overlap","genus_label_overlap","asv_sum_bray_contribution","genus_aggregated_bray_contribution","within_genus_cancellation")]),"")
    for(g in targets){
      ii<-which(ann$genus%in%g);ii<-head(ii[order(-pmin(p[ii,"Batch_01_F4"],p[ii,"Batch_01_H4"]),features[ii])],5)
      report<-c(report,paste0("**",g,"：末期相同ASV共享量Top5（全reads百分比）**"),"",
        md(data.frame(feature_id=features[ii],F4_pct=100*p[ii,"Batch_01_F4"],H4_pct=100*p[ii,"Batch_01_H4"],
          identical_ASV_overlap_pct=100*pmin(p[ii,"Batch_01_F4"],p[ii,"Batch_01_H4"]))),"")
    }
    report<-c(report,"#### 三目标属内主要ASV：各反应器/基线与后期的比例","",
      "主要ASV固定每属G4全15记录均值Top5。下表ASV_pct是全部reads比例均值，within_genus_pct是该阶段ASV均值/属均值；后期包含R1两记录、其他三记录，非独立重复均值、非按天数加权。逐节点及全ASV见轨迹表。","")
    for(g in targets){
      ii<-which(ann$genus%in%g&ann$target_genus_top5)
      for(r in paste0("R",1:4)){
        smry<-do.call(rbind,lapply(c("baseline","post_adaptation"),function(stage){
          ss<-g4i[reactor[g4i]==r & if(stage=="baseline")day[g4i]==1 else day[g4i]>1]
          av<-rowMeans(p[ii,ss,drop=FALSE]);gv<-mean(colSums(p[ann$genus%in%g,ss,drop=FALSE]))
          data.frame(reactor=r,stage=stage,n_records=length(ss),feature_id=features[ii],ASV_pct=100*av,genus_pct=100*gv,within_genus_pct=100*av/gv)
        }))
        report<-c(report,paste0("**",g," / ",r,"**"),"",md(smry,4),"")
      }
    }
    report<-c(report,"## 敏感性：各问题的支持与分歧","",
      "直接提取模块1.3全部所需敏感性，未再抽样或变换。Bray_rarefied_*沿用31457 reads×100次、seed=20261104；区间是读数子抽样范围，不是生物学置信区间。Hellinger=sqrt(p) Euclidean；CLR在共同最小深度期望count上加0.5/1、log后中心化。低检出Bray全样本总reads≥10、Jaccard每样本count≥5为原固定方案，仅敏感性，主分析全ASV。", "",
      md(distances[,c("pair_id","Bray_Curtis","Bray_rarefied_mean","Bray_rarefied_p025","Bray_rarefied_p975","Jaccard_binary","Jaccard_rarefied_mean","Bray_global_reads_ge10","Jaccard_per_sample_reads_ge5")]),"",
      "### 方法间方向与局部排序（按实际数值判断）","")
    for(s in c("R2_R4","R1_R2")){
      ds<-distances[distances$series==s&distances$day_a%in%c(76,145),]
      dd<-do.call(rbind,lapply(c("Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth","CLR_pc1_at_min_depth","Bray_rarefied_mean","Bray_global_reads_ge10","Jaccard_per_sample_reads_ge5"),function(m)
        data.frame(series=s,metric=m,d76=ds[[m]][1],d145=ds[[m]][2],delta=diff(ds[[m]]),direction=if(diff(ds[[m]])<0)"decrease" else "increase")))
      report<-c(report,md(dd),"")
    }
    adj<-within[within$comparison=="adjacent_observed"&within$day_from>=30,]
    rr<-do.call(rbind,lapply(c("30_to_76","76_to_145"),function(span){
      uv<-strsplit(span,"_to_",fixed=TRUE)[[1]];ss<-adj[adj$day_from==as.numeric(uv[1])&adj$day_to==as.numeric(uv[2]),]
      do.call(rbind,lapply(c("Bray_Curtis","Jaccard_binary","Hellinger","CLR_pc05_at_min_depth","CLR_pc1_at_min_depth"),function(m){
        rk<-rank(ss[[m]],ties.method="min");data.frame(interval=span,metric=m,R3_value=ss[[m]][ss$reactor_from=="R3"],R3_rank_smallest=rk[ss$reactor_from=="R3"],available_reactors=nrow(ss),
          smallest_reactor=ss$reactor_from[which.min(ss[[m]])])}))
    }))
    report<-c(report,"R3同区间距离由小到大排名（不是统计检验）：","",md(rr),"",
      "因此，R3丰度加权变化较小的描述必须限定指标和节点；较高Jaccard说明检出成员并未同等持续。CLR强调低丰度相对关系，不能把Bray结果泛化为log-ratio稳定。R2/R4末段不同指标即使方向相同，其全程幅度与单调性仍须逐列看，不能称成员全面趋同。", "",
      "## B. 已确认条件与来源依赖","",
      "R1/R3=30℃，R2/R4=室温未知数值；四份初始污泥均不同。各自经历的历史混合块及保存恢复均保留。G4各反应器为不平衡纵向记录，实际独立实验单位远少于15行，不能把四份起始状态不同当独立来源证明。全低DO后期相同设定不提供DO处理对照，也不提供温差定量信息。", "",
      "## C. 可能生态解释（待验证）","",
      "共享优势ASV比例变得接近可以解释丰度距离的算术下降；初始群落差异、运行选择与随机组成变化均可能形成这种轨迹。属内ASV更替与属总比例持续可以并存。R3若高丰度相同ASV维持，可与较小丰度加权距离相容；低丰度成员更替仍可较大。这里的‘解释’仅是组成层面的相容性，不能升级为温度选择、竞争或功能冗余机制的实证。", "",
      "## D. 本批不能验证的因果假设与局限","",
      "不能直接认定室温导致R2/R4趋同或30℃使R1/R2分化，也不能认定低DO造成分化。温度分配、反应器个体、初始污泥/群落、共享混合来源和重复测量共同限制效应识别；室温具体值未知，不量化温差，不拟合不可识别温度模型。无无约束PERMANOVA、ANOVA、相关显著性、共现网络。", "",
      "16S ASV读数比例不是绝对丰度、活菌量或功能活性；相同短扩增子ASV不保证同一菌株，未分类/--other不强赋功能。Competibacter/Defluviicoccus沿用GAO关联，Acinetobacter/Dechloromonas保留PAO歧义，Nitrospira保留NOB/comammox，Thauera保留特定菌株证据限制；不新增功能声称或重检索功能映射。", "",
      "未知提取/PCR/测序子批次、16S拷贝数与检测差异仍可能影响比例和Jaccard。共享相同ASV组成量不是独立重复或活性证明，距离端点分解无因果方向、没有推断性p值。运行稳态需性能记录核验。", "",
      "## 文件与复现","",
      "- [G4设计审核](g4_design_addendum.md)、[派生metadata](analysis_metadata_addendum.tsv)。",
      "- [10对完整ASV贡献](focal_pairwise_asv_contributions.tsv)、[属两算法贡献](focal_pairwise_genus_contributions.tsv)。",
      "- [完整15节点ASV轨迹](focal_asv_abundance_trajectories.tsv)、[原功能连接及选择标记](focal_asv_function_annotations.tsv)。",
      "- [全ASV时间变化/类别](focal_temporal_asv_changes.tsv)、[复用距离及敏感性](focal_distance_summary.tsv)。",
      "- [R2/R4图PDF](R2_R4_convergence.pdf) / [PNG](R2_R4_convergence.png)；[R1/R2图PDF](R1_R2_divergence.pdf) / [PNG](R1_R2_divergence.png)；[R3图PDF](R3_late_composition_persistence.pdf) / [PNG](R3_late_composition_persistence.png)。",
      "- [run.log](run.log)：实际运行及检查；本analysis_report.md为唯一综合计算报告。", "",
      "命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/g4_asv_contributions.R`。新版本复现加`--output-dir 尚不存在的新版本目录`。只允许既有目录内预先审核文件，其他任何产物存在即拒绝覆盖。新目录复用最初设计审核作为确认依据副本，不改正式文档。", "",
      paste0("脚本SHA-256：",script_sha),"","输入指纹（正式设计是追加补充后的版本；补充前指纹在设计审核中）：", "",
      md(data.frame(input=names(paths),path=unname(paths),bytes=unname(file.info(paths)$size),sha256=unname(fingerprints)),0),"",
      md(data.frame(tool=c("R","digest","ggplot2"),version=c(R.version.string,as.character(packageVersion("digest")),as.character(packageVersion("ggplot2"))))),"",
      "完整会话信息：","```",capture.output(sessionInfo()),"```","")
    need(identical(before,vapply(protected,sha,character(1))),"输入与历史结果保护",paste(length(protected),"个原输入/有效v2/设计/审核/脚本逐一SHA-256保持不变。"))
    report<-c(report,"## 程序实际检查","",md(checks),"",
      sprintf("本次主流程：%d PASS / %d WARNING / %d FAIL。",sum(checks$status=="PASS"),sum(checks$status=="WARNING"),sum(checks$status=="FAIL")),"",
      paste0("完成：",stamp(),"；用时",round(as.numeric(difftime(Sys.time(),started,units="secs")),3),"秒。独立交付核验后续追加，独立计数。"))
    writeLines(report,file.path(out,"analysis_report.md"),useBytes=TRUE)
    cat("END",stamp(),"PASS; outputs",length(list.files(out)),"\n")
  },error=function(e){
    cat("FAIL",conditionMessage(e),"\n")
    fail<-file.path(out,"analysis_report.md")
    if(!file.exists(fail))writeLines(c("# 模块2.1未完成","",paste("FAIL:",conditionMessage(e)),"",md(checks)),fail,useBytes=TRUE)
    stop(e)
  })
}
main()
