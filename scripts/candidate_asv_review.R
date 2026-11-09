#!/usr/bin/env Rscript
# Module 2.2. Offline reproducible calculations plus explicitly dated literature snapshot.
# Rscript --vanilla scripts/candidate_asv_review.R [--output-dir NEW_DIRECTORY]
main <- function() {
  Sys.setenv(TZ="Asia/Shanghai"); options(warn=1)
  started <- Sys.time()
  script <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value=TRUE)))
  setwd(dirname(dirname(script)))
  out <- "results/candidate_asvs/2026-11-05_v2"
  args <- commandArgs(trailingOnly=TRUE)
  if(length(args)) { stopifnot(length(args)==2, args[1]=="--output-dir"); out<-args[2] }
  if(grepl("_v1(/|$)",out)) stop("v1仅作历史；当前模块2.2统一为v2，禁止向v1输出。")
  if(file.exists(out)) stop("输出路径已存在，拒绝覆盖；请指定尚不存在的新版本目录。")
  stopifnot(dir.create(out,recursive=TRUE))
  log <- file(file.path(out,"run.log"),"wt",encoding="UTF-8")
  sink(log,split=TRUE); sink(log,type="message")
  on.exit({sink(type="message");sink();close(log)},add=TRUE)
  stamp <- function()format(Sys.time(),"%Y-%m-%d %H:%M:%S %Z")
  cat("START",stamp(),"\nCOMMAND",paste(commandArgs(),collapse=" "),"\n")
  checks <- data.frame(status=character(),item=character(),evidence=character())
  add <- function(s,i,e) {checks[nrow(checks)+1L,]<<-c(s,i,e);cat(s,i,":",e,"\n")}
  need <- function(ok,i,e) {add(if(isTRUE(ok))"PASS" else "FAIL",i,e);if(!isTRUE(ok))stop(i)}
  rd <- function(p,...)read.delim(p,check.names=FALSE,quote="",comment.char="",na.strings="NA",...)
  md <- function(d,digits=6) {
    if(!nrow(d))return("（无）")
    d[]<-lapply(d,function(v){if(is.numeric(v))v<-format(round(v,digits),trim=TRUE,scientific=FALSE)
      v<-as.character(v);v[is.na(v)]<-"NA";gsub("|","/",v,fixed=TRUE)})
    c(paste0("| ",paste(names(d),collapse=" | ")," |"),paste0("|",paste(rep("---",ncol(d)),collapse="|"),"|"),
      apply(d,1,function(v)paste0("| ",paste(v,collapse=" | ")," |")))
  }
  put <- function(d,n) {
    p<-file.path(out,n);stopifnot(!file.exists(p));write.table(d,p,sep="\t",quote=FALSE,row.names=FALSE,na="NA")
    z<-rd(p);stopifnot(nrow(z)==nrow(d),identical(names(z),names(d)))
    for(nm in names(d)[vapply(d,is.numeric,logical(1))])
      stopifnot(isTRUE(all.equal(as.numeric(d[[nm]]),as.numeric(z[[nm]]),tolerance=1e-12)))
    need(TRUE,paste(n,"回读"),paste(nrow(d),"行；字段和全部数值列往返一致。"))
  }
  tryCatch({
    need(all(vapply(c("digest","ggplot2","Biostrings"),requireNamespace,logical(1),quietly=TRUE)),"环境","复用现有R/digest/ggplot2/Biostrings，不安装软件。")
    suppressPackageStartupMessages(library(ggplot2))
    b21<-"results/asv_contributions/2026-11-05_v2";b12<-"results/functional_guilds/2026-11-03_v2"
    stopifnot(all(grepl("_v2$",c(b21,b12))))
    paths<-c(counts="data/asv_table.tsv",taxonomy="data/taxonomy.tsv",sequences="data/exported_sequences/dna-sequences.fasta",
      object="results/phyloseq/batch_01_phyloseq.rds",source_metadata="metadata/source_sample_metadata.tsv",
      metadata=file.path(b21,"analysis_metadata_addendum.tsv"),trajectory=file.path(b21,"focal_asv_abundance_trajectories.tsv"),
      contribution=file.path(b21,"focal_pairwise_asv_contributions.tsv"),temporal=file.path(b21,"focal_temporal_asv_changes.tsv"),
      distance=file.path(b21,"focal_distance_summary.tsv"),annotation21=file.path(b21,"focal_asv_function_annotations.tsv"),
      annotation=file.path(b12,"functional_asv_annotation.tsv"),evidence=file.path(b12,"functional_mapping_evidence.tsv"),
      report11="results/community_composition/2026-11-03_v2/analysis_report.md",report12=file.path(b12,"analysis_report.md"),
      report13="results/diversity/2026-11-04_v2/analysis_report.md",report21=file.path(b21,"analysis_report.md"),
      design="docs/batch_01/experiment_design.md",plan="docs/batch_01/analysis_plan.md",rules="AGENTS.md",context="docs/research_context.md")
    need(all(file.exists(paths)),"输入存在","原始count/taxonomy/FASTA、有效1.1/1.2/1.3/2.1和设计均存在。")
    sha<-function(p)digest::digest(file=p,algo="sha256")
    fingerprints<-vapply(paths,sha,character(1));script_sha<-sha(script)
    upstream<-readLines(paths["report21"],warn=FALSE)
    for(n in c("counts","taxonomy","sequences","object","source_metadata","annotation","evidence","report11","report12","report13","design"))
      stopifnot(any(grepl(paths[n],upstream,fixed=TRUE)&grepl(fingerprints[n],upstream,fixed=TRUE)))
    need(TRUE,"有效基线与既有QC复用","原输入/对象/功能v2/有效报告/设计指纹匹配2.1报告。只做本模块必需断言，不重复测序QC、分类或完整距离。")
    protected<-unique(c(paths,script,unlist(lapply(c("data","input","metadata","results","scripts"),list.files,recursive=TRUE,full.names=TRUE))))
    protected<-protected[!dir.exists(protected)&!startsWith(protected,paste0(out,"/"))]
    before<-vapply(protected,sha,character(1))
    raw<-rd(paths["counts"],skip=1);ids<-raw[[1]];x<-as.matrix(raw[,-1]);storage.mode(x)<-"double";rownames(x)<-ids
    need(identical(dim(x),c(5510L,33L))&&!anyDuplicated(ids)&&!anyDuplicated(colnames(x))&&!anyNA(x)&&
      all(is.finite(x))&&all(x>=0&x==floor(x))&&all(colSums(x)>0),"计数输入必需条件","5510×33原整数计数，ID唯一，无缺失/负值/空样本；深度异常QC不重跑。")
    p<-sweep(x,2,colSums(x),"/");stopifnot(max(abs(colSums(p)-1))<1e-12)
    meta<-rd(paths["metadata"],colClasses="character");src<-rd(paths["source_metadata"],colClasses="character")
    stopifnot(!anyDuplicated(meta[[1]]),setequal(meta[[1]],colnames(x)),!anyDuplicated(src[[1]]),setequal(src[[1]],colnames(x)))
    meta<-meta[match(colnames(x),meta[[1]]),];src<-src[match(colnames(x),src[[1]]),];rownames(meta)<-rownames(src)<-NULL
    stopifnot(identical(meta[,names(src)],src),all(!is.na(meta$group_source)),all(!is.na(meta$condition_source)))
    design<-readLines(paths["design"],warn=FALSE)
    for(g in paste0("G",1:5)) {
      ln<-grep(paste0("^\\| ",g," \\|.*Batch_01_"),design,value=TRUE);stopifnot(length(ln)==1)
      listed<-regmatches(ln,gregexpr("Batch_01_[A-Z][0-9]",ln))[[1]];stopifnot(setequal(listed,meta[[1]][meta$group==g]))
    }
    stopifnot(identical(as.integer(table(factor(meta$group,levels=paste0("G",1:5)))),c(8L,2L,4L,15L,4L)))
    g4<-which(meta$group=="G4");main29<-which(meta$group!="G5");post<-g4[as.numeric(meta$phase_days[g4])>1]
    reactor<-setNames(c(Reactor_01="R1",Reactor_02="R2",Reactor_03="R3",Reactor_04="R4")[meta$reactor_id],colnames(x))
    day<-setNames(as.numeric(meta$phase_days),colnames(x))
    expected<-list(R1=c(E1=1,E2=76,E3=145),R2=c(F1=1,F2=30,F3=76,F4=145),R3=c(G1=1,G2=30,G3=76,G4=145),R4=c(H1=1,H2=30,H3=76,H4=145))
    for(r in names(expected)) {
      ii<-g4[reactor[g4]==r];stopifnot(setequal(meta$supplier_sample_id[ii],names(expected[[r]])),all(day[ii]==expected[[r]][meta$supplier_sample_id[ii]]))
      stopifnot(all(meta$temperature_regime[ii]==if(r%in%c("R1","R3"))"controlled_30C" else "ambient_unmeasured"))
      stopifnot(all(meta$G4_initial_sludge_distinctness[ii]=="different_per_reactor_user_confirmed_characteristics_and_initial_community"))
      if(r%in%c("R1","R3"))stopifnot(all(meta$temperature_setpoint_C[ii]=="30")) else stopifnot(all(is.na(meta$temperature_setpoint_C[ii])))
    }
    basei<-g4[day[g4]==1]
    stopifnot(length(post)==11,length(basei)==4,all(meta$stage_subphase[basei]=="recovered_baseline_before_low_DO_switch"),
      all(meta$G4_baseline_recovery_DO_setpoint_mg_L[basei]=="3"),all(meta$DO_setpoint_mg_L[post]=="0.5"),
      all(meta$DO_setting_lower_mg_L[post]=="0.3"),all(meta$DO_setting_upper_mg_L[post]=="0.7"),
      all(is.na(meta$DO_measured_mg_L)),all(is.na(meta$temperature_measured_C)),all(is.na(meta$G4_initial_sludge_id)),
      all(is.na(meta$G4_initial_sludge_characteristics)),length(unique(meta$fractionation_event_id[meta$group=="G5"]))==1)
    stopifnot(all(meta$G4_historical_storage_days[g4]=="59"),all(meta$G4_historical_storage_temperature_C[g4]=="4"),
      identical(meta$G4_pre_storage_source_sample_id[basei],paste0("Batch_01_",c("A2","B3","C2","D3"))))
    need(TRUE,"样本级设计门控","原14列保留，33样本/8-2-4-15-4逐ID匹配；G4真实3/4/4/4节点、温度/基线/11后期/保存恢复和G5单母样核对。")
    tax<-rd(paths["taxonomy"]);ann<-rd(paths["annotation"],colClasses="character");a21<-rd(paths["annotation21"],colClasses="character")
    stopifnot(!anyDuplicated(tax[[1]]),!anyDuplicated(ann$feature_id),!anyDuplicated(a21$feature_id),
      setequal(ids,tax[[1]]),setequal(ids,ann$feature_id),setequal(ids,a21$feature_id))
    tax<-tax[match(ids,tax[[1]]),];ann<-ann[match(ids,ann$feature_id),];a21<-a21[match(ids,a21$feature_id),]
    stopifnot(identical(ann,a21[,names(ann)]),identical(tax$Taxon,ann$original_taxonomy),
      max(abs(tax$Confidence-as.numeric(ann$taxonomy_classifier_confidence)))<1e-12,all(is.finite(tax$Confidence)&tax$Confidence>=0&tax$Confidence<=1))
    seqs<-Biostrings::readDNAStringSet(paths["sequences"])
    stopifnot(!anyDuplicated(names(seqs)),setequal(ids,names(seqs)))
    need(TRUE,"分类及功能连接","全部5510 IDs与原FASTA/taxonomy一致，2.1原16列功能逐值等于1.2 v2；完整谱系/Confidence原值复用，不更新分类/功能。")
    tr<-rd(paths["trajectory"]);co<-rd(paths["contribution"]);tm<-rd(paths["temporal"]);ds<-rd(paths["distance"])
    stopifnot(nrow(tr)==5510L*15L,!anyDuplicated(paste(tr$feature_id,tr$sample_id)),
      setequal(tr$feature_id,ids),setequal(tr$sample_id,colnames(x)[g4]))
    ti<-match(tr$feature_id,ids);sj<-match(tr$sample_id,colnames(x));at<-cbind(ti,sj)
    stopifnot(!anyNA(at),identical(as.numeric(tr$count),as.numeric(x[at])),max(abs(tr$relative_abundance-p[at]))<1e-12,
      all(tr$reactor==reactor[tr$sample_id]),all(tr$day==day[tr$sample_id]))
    need(TRUE,"完整轨迹复用","82650行逐格核对既有count/比例/节点，G4指标及绘图直接复用2.1轨迹；全33上下文指标仅从原count汇总。")
    stopifnot(nrow(co)==55100,!anyDuplicated(paste(co$feature_id,co$pair_id)),setequal(co$feature_id,ids),
      length(unique(co$pair_id))==10,!anyDuplicated(ds$pair_id),setequal(co$pair_id,ds$pair_id))
    for(q in ds$pair_id) {
      z<-co[co$pair_id==q,];stopifnot(nrow(z)==5510,setequal(z$feature_id,ids),all(z$bray_contribution>=0),
        abs(sum(z$bray_contribution)-ds$Bray_Curtis[match(q,ds$pair_id)])<1e-12)
    }
    stopifnot(nrow(tm)==88160,!anyDuplicated(paste(tm$feature_id,tm$comparison_id)),setequal(tm$feature_id,ids))
    need(TRUE,"贡献复用与守恒","55100行10对贡献和等于2.1已有Bray；88160行16段时间变化完整保留，仅汇总原表，不重复计算距离。")
    fixed<-c("3cae56af0b082bba9c858d1844913fc3","d1725130559823512a63bbc2c1bab523","78c2842bcb5d089b057f231ddd53b8e1",
      "be9af24f8e82484720783bcb4df4f6de","54089b19ce1b3690c1e03d4d34a0162c")
    stopifnot(all(fixed%in%ids))
    rank<-data.frame(feature_id=ids,user_priority=ids%in%fixed,stringsAsFactors=FALSE)
    for(scope in c("all33","main29","G4","G4_post")) {
      ii<-switch(scope,all33=seq_len(ncol(x)),main29=main29,G4=g4,G4_post=post)
      rank[[paste0(scope,"_n_records")]]<-length(ii)
      for(th in c(1,5)) {
        rank[[paste0(scope,"_detected_n_ge",th)]]<-rowSums(x[,ii,drop=FALSE]>=th)
        rank[[paste0(scope,"_detection_frequency_ge",th)]]<-rowMeans(x[,ii,drop=FALSE]>=th)
      }
      rank[[paste0(scope,"_mean_relative_abundance")]]<-rowMeans(p[,ii,drop=FALSE])
      rank[[paste0(scope,"_max_relative_abundance")]]<-apply(p[,ii,drop=FALSE],1,max)
    }
    stopifnot(max(abs(rank$G4_mean_relative_abundance-as.numeric(a21$G4_mean_relative_abundance)))<1e-12)
    longest<-function(v) {z<-rle(v);if(!any(z$values))0L else max(z$lengths[z$values])}
    for(r in names(expected)) {
      ii<-g4[reactor[g4]==r];ii<-ii[order(day[ii])];late<-ii[day[ii]>1]
      rank[[paste0(r,"_actual_days")]]<-paste(day[ii],collapse=",")
      rank[[paste0(r,"_n_nodes")]]<-length(ii);rank[[paste0(r,"_post_n_nodes")]]<-length(late)
      for(th in c(1,5)) {
        det<-x[,ii,drop=FALSE]>=th;detlate<-x[,late,drop=FALSE]>=th
        rank[[paste0(r,"_detected_n_ge",th)]]<-rowSums(det)
        rank[[paste0(r,"_detection_frequency_ge",th)]]<-rowMeans(det)
        rank[[paste0(r,"_longest_consecutive_observed_nodes_ge",th)]]<-apply(det,1,longest)
        rank[[paste0(r,"_adjacent_both_detected_ge",th)]]<-rowSums(det[,-ncol(det),drop=FALSE]&det[,-1,drop=FALSE])
        rank[[paste0(r,"_post_detected_n_ge",th)]]<-rowSums(detlate)
        rank[[paste0(r,"_post_all_detected_ge",th)]]<-rowSums(detlate)==length(late)
      }
      rank[[paste0(r,"_post_min_relative_abundance")]]<-apply(p[,late,drop=FALSE],1,min)
      rank[[paste0(r,"_post_all_ge1pct")]]<-apply(p[,late,drop=FALSE],1,min)>=0.01
    }
    rank$max_bray_contribution<-0;rank$sum_bray_contribution_10_pairs<-0;rank$max_pair_Bray_share<-0;rank$top10_pair_count<-0L
    rank$max_bray_pair<-NA_character_
    # Stable tie order: pair_id then feature_id. No taxonomy/function enters the sort.
    for(q in sort(ds$pair_id)) {
      z<-co[co$pair_id==q,];z<-z[match(ids,z$feature_id),]
      ismax<-z$bray_contribution>rank$max_bray_contribution
      rank$max_bray_pair[ismax]<-q;rank$max_bray_contribution<-pmax(rank$max_bray_contribution,z$bray_contribution)
      rank$sum_bray_contribution_10_pairs<-rank$sum_bray_contribution_10_pairs+z$bray_contribution
      rank$max_pair_Bray_share<-pmax(rank$max_pair_Bray_share,z$share_of_pair_Bray)
      rank$top10_pair_count<-rank$top10_pair_count+(z$contribution_rank<=10)
      rank[[paste0("bray_",q)]]<-z$bray_contribution
      rank[[paste0("share_",q)]]<-z$share_of_pair_Bray
    }
    for(q in c("R2_R4_76_to_145","R1_R2_76_to_145")) {
      z<-tm[tm$comparison_id==q,];stopifnot(nrow(z)==5510);rank[[paste0("delta_bray_",q)]]<-z$delta_bray_contribution[match(ids,z$feature_id)]
    }
    sortidx<-order(-rank$max_bray_contribution,rank$feature_id,method="radix")
    rank$contribution_rank<-integer(nrow(rank));rank$contribution_rank[sortidx]<-seq_along(sortidx)
    choose<-function(th=0.005,k=10L) {
      extra<-sortidx[!rank$user_priority[sortidx]&rank$max_bray_contribution[sortidx]>=th]
      c(fixed,rank$feature_id[head(extra,k)])
    }
    selected<-choose();rank$selected<-rank$feature_id%in%selected
    rank$selection_reason<-ifelse(rank$user_priority,"user_priority",ifelse(rank$selected,"max_Bray_ge0.005_top10_remaining","not_selected"))
    rank$selected_order<-match(ids,selected)
    fields<-setdiff(names(ann),"feature_id");rank<-cbind(rank,ann[,fields])
    need(length(selected)==15L&&sum(rank$selected)==15L,"预定筛选规则","指定5+非指定max贡献≥0.005前10，共15；全部5510 ASV排名保留，分类/功能不参与选择。")
    sensitivity<-do.call(rbind,lapply(c(0.0025,0.005,0.01),function(th)do.call(rbind,lapply(c(5L,10L,15L),function(k) {
      ss<-choose(th,k);data.frame(threshold=th,extra_cap=k,eligible_remaining=sum(!rank$user_priority&rank$max_bray_contribution>=th),
        selected_total=length(ss),overlap_primary=sum(ss%in%selected),lost_primary=paste(setdiff(selected,ss),collapse=";"),
        added=paste(setdiff(ss,selected),collapse=";"))
    }))))
    need(all(fixed%in%choose(0.01,5))&&identical(choose(),selected),"阈值敏感性","3个贡献阈值×3个补充名额，全部9种输出在报告内；不更改主规则。检出≥1/5不作为筛选门槛。")
    rank<-rank[sortidx,];rownames(rank)<-NULL
    cand<-rank[match(selected,rank$feature_id),];ci<-match(selected,ids)
    seqtxt<-as.character(seqs[match(selected,names(seqs))])
    review<-data.frame(candidate_order=seq_along(selected),feature_id=selected,original_taxonomy=tax$Taxon[ci],
      original_Confidence=tax$Confidence[ci],original_Confidence_text=rd(paths["taxonomy"],colClasses="character")$Confidence[match(selected,rd(paths["taxonomy"],colClasses="character")[[1]])],
      original_genus=ann$genus[ci],module12_genus_resolution=ann$genus_resolution[ci],sequence_length_bp=nchar(seqtxt),
      non_ACGT_bases=nchar(gsub("[ACGT]","",seqtxt)),sequence_md5=vapply(seqtxt,digest::digest,character(1),algo="md5",serialize=FALSE),
      sequence_sha256=vapply(seqtxt,digest::digest,character(1),algo="sha256",serialize=FALSE),stringsAsFactors=FALSE)
    review$feature_id_matches_sequence_md5<-review$feature_id==review$sequence_md5
    rankpart<-function(t,prefix) {v<-trimws(strsplit(t,";",fixed=TRUE)[[1]]);v<-v[startsWith(v,prefix)];if(length(v))sub(prefix,"",v[1],fixed=TRUE) else NA_character_}
    for(nm in c(domain="d__",kingdom="k__",phylum="p__",class="c__",order="o__",family="f__",genus="g__",species="s__")) {
      name<-names(c(domain="d__",kingdom="k__",phylum="p__",class="c__",order="o__",family="f__",genus="g__",species="s__"))[match(nm,c("d__","k__","p__","c__","o__","f__","g__","s__"))]
      review[[paste0("lineage_",name)]]<-vapply(review$original_taxonomy,rankpart,character(1),prefix=nm)
    }
    unresolved<-is.na(review$lineage_genus)|grepl("Incertae_Sedis|uncultured|unclassified|unidentified|unknown|--other",review$lineage_genus,ignore.case=TRUE)
    unresolved[is.na(unresolved)]<-TRUE
    review$genus_interpretation_status<-ifelse(unresolved,"insufficient_for_named_genus", "original_genus_label_only_unaligned")
    review$confidence_review_flag<-ifelse(review$original_Confidence<0.9,"below_0.90_review_priority_only","ge0.90_not_functional_probability")
    review$lineage_contains_other_suffix<-grepl("--other",review$original_taxonomy,fixed=TRUE)
    review$alignment_status<-"pending_no_local_reference_database_or_BLAST_available_in_project_PATH"
    review$reference_database<-NA_character_;review$reference_accession<-NA_character_;review$percent_identity<-NA_real_;review$query_coverage<-NA_real_
    review$species_identification<-NA_character_;review$amplicon_region<-"short_16S_historical_338F_806R_exact_coordinates_not_aligned"
    review$review_conclusion<-ifelse(unresolved,"仅支持原已命名父谱系；不得按已鉴定属赋功能", "保留原属标签；短16S尚无独立参考匹配，不能定种/菌株")
    review$sequence<-unname(seqtxt)
    need(all(review$sequence_length_bp>0)&all(review$non_ACGT_bases==0)&all(review$feature_id_matches_sequence_md5),"15候选代表序列身份","实际核对长度、ACGT和序列MD5与ASV ID；全谱系及原Confidence数值/原字符串并列。")
    need(all(is.na(review$reference_accession))&&all(is.na(review$percent_identity))&&all(is.na(review$query_coverage))&&all(is.na(review$species_identification)),"无虚构参考匹配","本次不运行BLAST/系统发育/重分类；匹配、覆盖率及物种结论均NA，序列直接列于审核表供后续定向比对。")
    add("WARNING","分类分辨率",paste(sum(unresolved),"候选属级不足；",sum(review$original_Confidence<0.9),"候选Confidence<0.90。0.90仅审核标记、不删样、不等于功能置信度；上级--other语义未确认。"))
    # Dated human-verified bibliographic snapshot. No web-derived ASV identity is asserted.
    refs<-list(
      E01=list(genus="Candidatus_Competibacter",citation="McIlroy et al. 2014 (online 2013)",
        title="Candidatus Competibacter-lineage genomes retrieved from metagenomes reveal functional metabolic diversity",doi="10.1038/ismej.2013.162",
        url="https://pubmed.ncbi.nlm.nih.gov/24173461/",verification="primary_abstract_and_indexed_primary_text_verified",
        level="known_taxon_function_association",model="参考富集谱系及其基因组",
        support="参考谱系支持糖原/PHA碳储存的GAO关联；谱系间代谢潜力有差异。",limit="不能把本ASV定为具体物种或反硝化菌；不能证明碳竞争、活性或除磷失败。"),
      E02=list(genus="Defluviicoccus",citation="Burow et al. 2007",
        title="Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes",doi="10.1099/mic.0.2006/001032-0",
        url="https://pubmed.ncbi.nlm.nih.gov/17185546/",verification="primary_abstract_verified",
        level="known_taxon_function_association",model="污水系统中FISH/MAR区分的参考类群",
        support="参考Defluviicoccus类群有GAO相关碳摄取/储存表型证据。",limit="未将项目ASV比对到参考cluster；不能由检出持续性证明GAO活性或过程贡献。"),
      E03=list(genus="Acinetobacter",citation="Tandoi et al. 1998",
        title="The behaviour of polyphosphate accumulating acinetobacter isolates in an anaerobic-aerobic chemostat",doi="10.1016/S0043-1354(98)00079-7",
        url="https://www.sciencedirect.com/science/article/pii/S0043135498000797",verification="primary_indexed_abstract_excerpt_verified_full_text_403",
        level="specific_isolate_evidence_function_ambiguous",model="特定Acinetobacter分离株",
        support="个别参考分离株存在储磷/储存聚合物现象；保持既有PAO歧义。",limit="不能扩展为全属典型EBPR-PAO、氮去除菌或本项目除磷活性；全文本次受限。"),
      E04=list(genus="Chryseotalea",citation="Maejima et al. 2020 (online 2019)",
        title="Chryseotalea sanaruensis gen. nov., sp., nov., a Member of the Family Cytophagaceae, Isolated from a Brackish Lake in Hamamatsu Japan",doi="10.1007/s00284-019-01823-4",
        url="https://pubmed.ncbi.nlm.nih.gov/31792570/",verification="primary_indexed_abstract_excerpt_and_bibliography_verified_open_recaptcha",
        level="specific_type_strain_context_only",model="Chryseotalea sanaruensis参考模式株",
        support="原分类描述报告参考株为好氧菌；只能提供分类与培养背景。",limit="项目ASV未鉴定到该种；不能据此声称COD降解、反硝化、PAO或GAO功能已支持。"),
      E05=list(genus="Aridibacter",citation="Huber et al. 2017",
        title="Aridibacter nitratireducens sp. nov., a member of the family Blastocatellaceae, class Blastocatellia, isolated from an African soil",doi="10.1099/ijsem.0.002318",
        url="https://www.microbiologyresearch.org/content/journal/ijsem/10.1099/ijsem.0.002318",verification="primary_publisher_abstract_verified",
        level="specific_type_strain_hypothesis_only",model="A. nitratireducens A24_SHP_-5_238T参考株",
        support="该参考株可在无氧条件下以硝酸盐为替代电子受体。",limit="不能由属注释把项目ASV定为该株，也不能等同完整反硝化、TN去除或本批活性。"),
      E06=list(genus="Chryseosolibacter",citation="Octaviana et al. 2022",
        title="Four new members of the family Cytophagaceae: Chryseosolibacter histidini gen. nov., sp. nov., Chryseosolibacter indicus gen. nov., sp. nov., Dawidia cretensis, gen. nov., sp. nov., and Dawidia soli, gen. nov., sp. nov. isolated from diverse habitat",doi="10.1007/s10482-022-01756-2",
        url="https://pmc.ncbi.nlm.nih.gov/articles/PMC9296434/",verification="primary_abstract_and_relevant_results_sections_verified",
        level="genus_context_specific_reference_isolates_only",model="参考模式株PWU4T/PWU20T",
        support="参考分离株的好氧生长和有机底物利用可形成一般异养背景假设。",limit="不能把参考株培养结果转成本项目COD降解能力、低DO适应或氮磷去除实证。"))
    ev<-do.call(rbind,lapply(seq_along(selected),function(j) {
      a<-cand[j,];gn<-a$genus;key<-which(vapply(refs,function(v)!is.na(gn)&&identical(v$genus,gn),logical(1)))
      ref<-if(length(key))refs[[key]] else NULL
      data.frame(candidate_order=j,feature_id=selected[j],original_genus=gn,
        module12_rule_id=a$rule_id,module12_evidence_category=a$evidence_category,module12_literature_strength=a$literature_strength,
        module12_evidence_verified=a$evidence_verified,module12_conservative_guild=a$conservative_guild,module12_proposed_guild=a$proposed_guild,
        module12_reference_url=a$reference_url,module12_function_confidence=a$asv_function_confidence,
        evidence_id=if(is.null(ref))"E00" else names(refs)[key],
        evidence_level=if(is.null(ref))"taxonomy_limited_no_functional_claim_supported" else ref$level,
        citation=if(is.null(ref))NA_character_ else ref$citation,reference_title=if(is.null(ref))NA_character_ else ref$title,
        doi=if(is.null(ref))NA_character_ else ref$doi,reference_url=if(is.null(ref))NA_character_ else ref$url,
        verification_status=if(is.null(ref))"pending_ASV_specific_primary_evidence_not_identified" else ref$verification,
        verification_date="2026-11-05",reference_model=if(is.null(ref))NA_character_ else ref$model,
        supported_scope=if(is.null(ref))"重要但功能未知的生态ASV；仅保留原父谱系。" else ref$support,
        prohibited_extrapolation=if(is.null(ref))"不能从父科、Incertae_Sedis或高Confidence强配属/功能；NA不等于无功能。" else ref$limit,
        project_evidence="16S_taxonomy_only_no_functional_gene_or_activity_measurement",project_function_validation="not_measured",
        alignment_status=review$alignment_status[j],functional_mapping_changed=FALSE,stringsAsFactors=FALSE)
    }))
    evidence_up<-rd(paths["evidence"],colClasses="character")
    for(g in c("Candidatus_Competibacter","Defluviicoccus","Acinetobacter")) {
      a<-ev[ev$original_genus==g&!is.na(ev$original_genus),];r<-evidence_up[match(unique(a$module12_rule_id),evidence_up$rule_id),]
      stopifnot(nrow(r)==1,all(a$doi==r$doi))
    }
    need(setequal(ev$feature_id,selected)&&!anyDuplicated(ev$feature_id)&&all(!ev$functional_mapping_changed),"逐ASV文献边界","15候选均有证据行；6条核实原研究、2个分类受限候选文献NA待核实。旧功能证据完整保留，新背景不改映射。")
    add("WARNING","参考比对待核实","项目无本地参考比对库，PATH未提供blastn/makeblastdb；只列真实序列，未运行BLAST或给出相似度/物种鉴定。")
    add("WARNING","文献获取层级","6篇原研究按实际摘要/索引片段/相关结果核实，非系统综述；Chryseotalea直接打开验证码，Acinetobacter全文403；分类受限候选的直接功能文献仍待核实。")
    add("WARNING","科研推断门控关闭","G4四份起始状态各异；共享谱系/保存恢复、纵向重复、温度与反应器/初始群落混杂。室温/瞬时DO/温度未知，G5单母样；不做推断、因果或功能确证。")
    # Persist the three requested final data tables only.
    put(rank,"candidate_asv_ranking.tsv");put(review,"candidate_asv_taxonomy_review.tsv");put(ev,"candidate_asv_evidence.tsv")
    plotdata<-tr[tr$feature_id%in%selected,];j<-match(plotdata$feature_id,selected)
    labs<-paste0(sprintf("C%02d",seq_along(selected))," ",selected,"\n",ifelse(is.na(cand$genus),"Unclassified genus",cand$genus))
    plotdata$label<-factor(labs[j],levels=labs);plotdata$reactor<-factor(plotdata$reactor,levels=names(expected))
    plotdata$position<-factor(ifelse(plotdata$day==1,"Pre-switch baseline","Post-adaptation"),levels=c("Pre-switch baseline","Post-adaptation"))
    plotdata<-plotdata[order(plotdata$label,plotdata$reactor,plotdata$day),]
    fig<-ggplot(plotdata,aes(day,100*relative_abundance,color=reactor,group=reactor))+
      geom_line(linewidth=0.48)+geom_point(aes(shape=position),size=1.8)+
      facet_wrap(~label,ncol=3,scales="free_y")+
      scale_x_continuous(breaks=c(1,30,76,145),expand=expansion(mult=c(0.04,0.05)))+
      scale_y_continuous(limits=c(0,NA),expand=expansion(mult=c(0.02,0.10)))+
      scale_shape_manual(values=c(1,16))+scale_color_manual(values=c(R1="#D55E00",R2="#0072B2",R3="#009E73",R4="#CC79A7"))+
      labs(title="Module 2.2 | 15 candidate ASVs at actual G4 sampling nodes",x="Recorded G4 day (day 1 = recovered pre-switch baseline)",
        y="Relative abundance (% of all ASV reads; independent panel scales)",color="Reactor",shape="Sampling position",
        caption=paste("R1: 1,76,145; R2/R3/R4: 1,30,76,145. Lines connect observations only; no imputed nodes.",
          "G4 operating labels: R1/R3 = 30 C; R2/R4 = ambient, unmeasured. Different initial sludge states.",
          "Closed compositional data; persistence is detection at sampled nodes, not viability, function or continuous residence.",sep="\n"))+
      theme_bw(base_size=10)+theme(strip.text=element_text(size=7.7),legend.position="bottom",panel.grid.minor=element_blank(),
        plot.title=element_text(size=14),plot.caption=element_text(hjust=0,size=9),plot.margin=margin(12,18,12,12))
    built<-ggplot_build(fig);stopifnot(nrow(built$data[[1]])==15L*15L,nrow(built$data[[2]])==15L*15L,
      all(is.finite(built$data[[2]]$y)),all(built$data[[2]]$y>=0))
    for(ext in c("pdf","png"))ggsave(file.path(out,paste0("candidate_asv_trajectories.",ext)),fig,width=16,height=16,units="in",dpi=160,limitsize=FALSE)
    need(TRUE,"轨迹图实际节点","15候选×15实际G4节点=225点，图层数值/非负/完整ID核验；独立纵轴，不补R1-30d。G5不连入G4时间轴。")
    need(identical(before,vapply(protected,sha,character(1))),"原输入及历史结果保护",paste(length(protected),"个科研输入/旧结果/脚本SHA-256不变；未改原metadata、taxonomy、功能映射或RDS。"))
    # Main report: all checks, sensitivity, evidence, reproducibility and Q1-Q5 together.
    summary<-data.frame(candidate=sprintf("C%02d",seq_along(selected)),ASV=selected,genus=cand$genus,
      selection=cand$selection_reason,detected_all33=cand$all33_detected_n_ge1,detected_G4=cand$G4_detected_n_ge1,
      G4_mean_pct=100*cand$G4_mean_relative_abundance,G4_max_pct=100*cand$G4_max_relative_abundance,
      max_Bray=cand$max_bray_contribution,max_pair=cand$max_bray_pair,evidence=cand$evidence_category)
    persistent<-do.call(rbind,lapply(seq_along(selected),function(j)do.call(rbind,lapply(names(expected),function(r) {
      a<-cand[j,];data.frame(candidate=sprintf("C%02d",j),ASV=selected[j],reactor=r,actual_days=a[[paste0(r,"_actual_days")]],
        detected_ge1=a[[paste0(r,"_detected_n_ge1")]],detected_ge5=a[[paste0(r,"_detected_n_ge5")]],
        longest_observed_run=a[[paste0(r,"_longest_consecutive_observed_nodes_ge1")]],post_nodes=a[[paste0(r,"_post_n_nodes")]],
        post_detected_ge1=a[[paste0(r,"_post_detected_n_ge1")]],post_all_ge1pct=a[[paste0(r,"_post_all_ge1pct")]])
    }))))
    paircoverage<-do.call(rbind,lapply(ds$pair_id,function(q){z<-co[co$pair_id==q,];data.frame(pair=q,
      existing_Bray=ds$Bray_Curtis[match(q,ds$pair_id)],selected_contribution_sum=sum(z$bray_contribution[z$feature_id%in%selected]),
      selected_share=sum(z$share_of_pair_Bray[z$feature_id%in%selected]))}))
    detection_sens<-data.frame(ASV=selected,all33_ge1=cand$all33_detected_n_ge1,all33_ge5=cand$all33_detected_n_ge5,
      G4_ge1=cand$G4_detected_n_ge1,G4_ge5=cand$G4_detected_n_ge5)
    lastmetrics<-function(id,r) {z<-tr[tr$feature_id==id&tr$reactor==r&tr$day>1,];z<-z[order(z$day),];paste(sprintf("%dd %.4f%%",z$day,100*z$relative_abundance),collapse=" → ")}
    focus_text<-c(
      paste0("- **3cae56af0b082bba9c858d1844913fc3（Competibacter关联）**：G4检出",cand$G4_detected_n_ge1[1],"/15；R2后期",lastmetrics(fixed[1],"R2"),"；R4后期",lastmetrics(fixed[1],"R4"),"。末段R2/R4 Δ贡献",sprintf("%.6f",cand$delta_bray_R2_R4_76_to_145[1]),"、R1/R2 Δ贡献+",sprintf("%.6f",cand$delta_bray_R1_R2_76_to_145[1]),"；两种现象由同一ASV份额重排共同关联，非两份独立生态证据。"),
      paste0("- **d1725130559823512a63bbc2c1bab523**：R1后期",lastmetrics(fixed[2],"R1"),"；Sphingobacteriaceae / Incertae_Sedis，Confidence=",sprintf("%.6f",review$original_Confidence[2]),"仍不能命名属。末段R1/R2 Δ贡献+",sprintf("%.6f",cand$delta_bray_R1_R2_76_to_145[2]),"，是优先研究的功能未知生态ASV。"),
      paste0("- **78c2842bcb5d089b057f231ddd53b8e1（Defluviicoccus关联）**：R3后期",lastmetrics(fixed[3],"R3"),"；按实际后期节点持续≥1%，优先用于描述相同ASV的丰度持续性；仅保留GAO类群关联。"),
      paste0("- **be9af24f8e82484720783bcb4df4f6de（Chryseotalea原属标签）**：R3后期",lastmetrics(fixed[4],"R3"),"；Confidence=",sprintf("%.6f",review$original_Confidence[4]),"，参考株分类/培养背景不足以支持项目目标功能；保持未分配。"),
      paste0("- **54089b19ce1b3690c1e03d4d34a0162c（Aridibacter原属标签）**：R3后期",lastmetrics(fixed[5],"R3"),"；Confidence=",sprintf("%.6f",review$original_Confidence[5]),"。特定参考株硝酸盐利用仅形成待验证假设，不升级为本ASV反硝化/除氮。"))
    refmd<-unlist(lapply(seq_along(refs),function(i){r<-refs[[i]];paste0("- ",names(refs)[i],"：",r$citation,". [",r$title,"](",r$url,"). DOI: ",r$doi,"。核实层级：",r$verification,"；",r$support," ",r$limit)}))
    countstatus<-table(factor(checks$status,levels=c("PASS","WARNING","FAIL")))
    report<-c("# 模块2.2：重点候选ASV筛选与分类学证据审核（2026-11-05）","",
      paste0("当前目录：",out,"。实际运行：",format(started,"%Y-%m-%d %H:%M:%S %Z"),"–",stamp(),"。"),
      paste0("**描述性计算完成：",countstatus[1]," PASS / ",countstatus[2]," WARNING / ",countstatus[3]," FAIL。15个候选；完整5510 ASV保留。** 推断和功能确证门控关闭。"),"",
      "## 检查报告、歧义及执行规则","",
      "先阅读AGENTS、研究背景、最新实验设计、分析计划/日志及有效1.1/1.2/1.3/2.1报告并核对真实文件；筛选前已在日志及用户进度消息固定规则。基线为组成/功能2026-11-03_v2、多样性2026-11-04_v2和ASV贡献2026-11-05_v2。原QC由输入指纹复用。33样本/8-2-4-15-4不变；G4四份起始状态不同，R1/R3=30℃运行，R2/R4=室温未知；保留混合均分谱系、4℃59d保存恢复、纵向重复及G5单母样。","",
      "歧义：Incertae_Sedis不是已鉴定属，高Confidence不解除分类限制；上级--other与数据库代码语义未核实。历史338F/806R信息不能替代参考坐标比对。没有项目本地参考数据库/BLAST可用组合，不编造命中、相似度或物种。未知值NA不为通过门控填补。","",
      "1. 主候选=用户指定5个全纳入，再在其余ASV中取max(10对既有Bray贡献)≥0.005的前10；最大贡献降序、完整ID升序解并列。选15个。功能、分类、检出率不参与资格或排序。5个指定候选为研究问题指定，不能冒称全盲筛选。",
      "2. 贡献阈值0.005是无量纲Bray贡献（单ASV对应两端相对丰度差≥1个百分点），不是Bray份额0.5%、不是显著性。max优先捕捉局部大差异，可能偏向基线差异和高丰度；10对共享样本，贡献之和仅重复比较的描述评分，不是10次独立复现。",
      "3. 全5510排名给全33/主29/G4全15/G4后期11的检出（≥1和≥5 reads）、等记录平均/最大相对丰度；比例分母始终每样本全部ASV reads。全33均值受G5四级分和不平衡时间权重影响，故主29、G4单列，不作独立总体均值。",
      "4. 持续性仅按同一G4运行实体的实际节点。R1全3/后2，其他全4/后3；最长连续是连续已观测节点个数，相邻两端检出不代表间隔全程存在。后期持续≥1%仅作补充丰度描述，不计天数、不补30d、不跨保存恢复拼接。",
      "5. 阈值敏感性预设0.0025/0.005/0.01×额外名额5/10/15及检出≥1/5；不依预期功能修改主规则。Confidence<0.90仅标记定向分类审核优先，不是重新分类阈值、删ASV规则或功能概率。","",
      "## 1. 最值得研究的ASV及入选依据","",md(summary),"",focus_text,"",
      "补充10个是固定全比较规则的结果，包含较高基线差异的Acinetobacter、多个Competibacter、另一Defluviicoccus、未定属Paracoccaceae和Chryseosolibacter。不能将它们全部称为低DO末段变化特异标记；每项最大比较及全10对贡献见全量排名表。","",
      "### 候选覆盖的既有Bray贡献","",md(paircoverage),"",
      "selected_share为候选在该对距离中的算术份额，不是过程解释率/机制解释率。未入选ASV的剩余贡献始终保留于模块2.1。","",
      "## 2. 哪些可合理关联已知功能","",
      paste0("15候选中",sum(ev$module12_conservative_guild=="GAO",na.rm=TRUE),"个沿用GAO文献关联（Competibacter/Defluviicoccus），",sum(ev$module12_evidence_category=="functional_ambiguity"),"个Acinetobacter保留PAO歧义。所有项目ASV均只有间接16S证据；不新增AOB/NOB/AnAOB/PAO确认。"),"",
      "属标签仅支持与已知类群关联；本项目不能验证糖原/PHA代谢、碳竞争、除磷失败或氮转换速率。参考论文的强证据与本ASV功能未测量必须同时阅读。Acinetobacter个别分离株文献不支持整个属的典型EBPR功能或特定ASV活性。原模块1.2四表及所有分区完全不变。","",
      "## 3. 重要但功能未知的生态ASV","",
      "d172…代表R1后期大幅份额上升的未定属谱系；a578dfb348f923c17e372f94df5716ef代表Paracoccaceae未定属高贡献候选。二者应保留为独立ASV研究对象，不能借父科常见功能强配反硝化。Chryseotalea、Aridibacter及Chryseosolibacter也有重要组成信号，但本项目目标功能仍未知/未分配。","",
      "Aridibacter参考株硝酸盐利用、Chryseosolibacter参考株一般异养生长、Chryseotalea参考株培养背景分别属于特定菌株文献或属级背景假设；不能移植成项目ASV的COD去除、完整反硝化或除磷事实。未分配不是无功能。","",
      "## 4. 分类是否足以支持属级解释","",
      md(review[,c("feature_id","original_genus","original_Confidence","sequence_length_bp","non_ACGT_bases","feature_id_matches_sequence_md5","genus_interpretation_status","confidence_review_flag")]),"",
      "两个属级不足候选为d172…（Sphingobacteriaceae / Incertae_Sedis）与a578…（止于Paracoccaceae科）；均只可按真实父谱系描述。Chryseotalea和Aridibacter置信度低于本次0.90审核标记，应优先定向比对；其余高置信属标签也不是独立比对确证，不能定种/菌株。Defluviicoccus上级order含--other，不擅自改原谱系，也不将上级后缀直接解释为属标签缺失。","",
      paste0("15个序列实际长度",min(review$sequence_length_bp),"–",max(review$sequence_length_bp)," bp，ACGT及MD5身份检查通过。审核表同时提供完整序列、SHA-256、原Confidence字符串和各阶元，不另重复导出FASTA。所有reference_accession/identity/coverage/species均NA。"),"",
      "后续定向比对方案（本次未执行）：以审核表真实序列为query，准备可追溯版本/下载日期/校验和的参考16S及模式株或高质量长序列；记录query/subject长度、方向、覆盖、identity、并列最佳匹配及数据库分类体系。对齐同一扩增区域后评估谱系一致性；短片段即使高相似也不自动定种或导出功能。暂不安装/下载全库或重跑完整分类器。","",
      "## 文献证据审核（2026-11-05快照）","",
      "下列原研究题名、DOI及可访问摘要/索引原文片段已检索；核实层级不等同全文审阅。在线读取部分受验证码/403限制，未取得内容不声称已核实。E00是分类受限且ASV直接功能证据待核实，文献和DOI均NA；未伪造来源。每ASV与对应文献的映射、支持范围、禁止外推和旧证据均在candidate_asv_evidence.tsv。","",refmd,"",
      "## 固定阈值敏感性","",md(sensitivity[,1:5]),"",
      "具体丢失/新增候选ID（相对主规则）：",md(sensitivity[,c("threshold","extra_cap","lost_primary","added")]),"",
      "检出定义敏感性（只影响检出指标，主候选集不以检出过滤，因此不变）：",md(detection_sens),"",
      "全量排名中的两套指标及下表节点持续性反映低reads检出敏感性；不把≥1 reads和≥5 reads任一口径认作真实活细胞存在阈值。持续性未作生存率、时间积分或重复独立性估计。","",
      "### 每候选×反应器实际节点持续性","",md(persistent),"",
      "## 5. 与COD、氮磷去除及温度背景的衔接","",
      "本次没有导入/核验COD、氮磷进出水性能或同日温度连续记录，也没有运行性能关联计算。下一步先查现有原始记录，以sample_id、反应器运行实体、采样日期/相对日与处理阶段建立可回查对应；区分测序取样瞬间、周期内进出水和此前时间窗口。不得把G2/G3与G4跨保存恢复连成一个连续过程，也不得复制同一性能值给G5四级分并当四个独立点。","",
      "- COD：并列候选相对份额与对应COD进出水、去除率/负荷记录，并说明可溶/总COD、采样口径、单位与对齐窗口；未提供流量/体积时不编造负荷。GAO关联只能提出碳储存假设，不能把Bray贡献称为COD去除贡献。",
      "- 氮：先核对NH4-N、NO2-N、NO3-N、TN进出水和运行时序；Aridibacter菌株文献只能提出待验证线索。未入选的Nitrosomonas/Nitrospira及其他类群不能因本候选清单而被忽略；Nitrospira的NOB/comammox歧义继续沿用模块1.2。",
      "- 磷：核对PO4-P/TP进出水及周期释放/摄取证据，PAO/GAO文献关联可并列描述；高GAO比例不等于除磷失败，Acinetobacter不升级为保守PAO。",
      "- 温度：只用已确认G4运行标签（R1/R3=30℃，R2/R4=室温未知）；不能推算温差、外推基线/其他模块或拟合温度响应。先保留每反应器实际轨迹及初始状态；室温数值、初始污泥性状、性能稳态和批次记录未核验时不估计独立温度效应。","",
      "未来可行工作是同一反应器、同一运行实体内的描述性对照与明确的待验证假设。是否可作相关/重复测量统计须另行核验独立单位、来源块、时间相关、混杂与模型可识别性；本次不输出p值、共现网络、因果或新实验结果。","",
      "## 局限及待人工核查","",
      "候选受预指定5个、10对重点比较和max贡献规则限制，偏重高丰度及局部差异，并非功能微生物全目录；低贡献稳定功能类群可未入选。33/29/15/11是记录数，不是独立重复数。G4重复与历史混合块、起始污泥/反应器/温度混杂，G5单母样，16S拷贝数/提取/PCR/测序子批次偏倚未分离。没有绝对丰度或活性证据，不乘VSS/MLVSS。","",
      "待核查为定向参考比对及数据库后缀语义、候选ASV与参考菌株的对应关系、可追溯COD/氮磷/温度记录与采样窗口、起始污泥登记编号和具体性状及运行性能稳态证据。已确认的33样本名单、8/2/4/15/4和G4阶段标签不再列为待确认。","",
      "## 文件、运行参数与版本","",
      "- [全5510 ASV排名与分层指标](candidate_asv_ranking.tsv)：selected=TRUE为15候选，selected_order为C01–C15；相对丰度0–1、Bray贡献无量纲、检出率0–1。",
      "- [15候选分类/真实代表序列审核](candidate_asv_taxonomy_review.tsv)、[逐ASV文献证据](candidate_asv_evidence.tsv)。",
      "- [候选G4实际节点轨迹PDF](candidate_asv_trajectories.pdf) / [PNG](candidate_asv_trajectories.png)；独立纵轴，不能跨面板比曲线高度。",
      "- [run.log](run.log)及本中文综合报告。共7个最终文件；不增加项目中间数据或对象。","",
      "命令：`/home/leiyiping/miniconda3/envs/rachis-qiime2-2026.7/bin/Rscript --vanilla scripts/candidate_asv_review.R`；新版本复现加`--output-dir 尚不存在的新目录`。默认路径已存在即非零退出；脚本仅计算/交付本模块，科研总文档由本次收尾单独更新。文献核实快照内置脚本，复现不联网、不重新分类、不重做QC/距离。无随机步骤。","",
      paste0("脚本SHA-256：",script_sha),paste0("实际耗时：",round(as.numeric(difftime(Sys.time(),started,units="secs")),3),"秒。"),"",
      md(data.frame(input=names(paths),path=unname(paths),bytes=file.info(paths)$size,sha256=fingerprints)),"",
      md(data.frame(tool=c("R","digest","ggplot2","Biostrings"),version=c(R.version.string,as.character(packageVersion("digest")),as.character(packageVersion("ggplot2")),as.character(packageVersion("Biostrings"))))),"",
      "## 程序实际检查","",md(checks),"","```",capture.output(sessionInfo()),"```", "",
      paste0("主流程合计：",countstatus[1]," PASS / ",countstatus[2]," WARNING / ",countstatus[3]," FAIL；独立交付核验随后追加，不混入主流程计数。"))
    writeLines(report,file.path(out,"analysis_report.md"),useBytes=TRUE)
    cat("END",stamp(),"elapsed_sec",as.numeric(difftime(Sys.time(),started,units="secs")),"\n");print(sessionInfo())
  },error=function(e) {
    cat("FAIL",conditionMessage(e),"\n")
    writeLines(c("# 模块2.2运行失败（保留已产生文件，不自动覆盖或清理）","",conditionMessage(e),"",md(checks)),file.path(out,"analysis_report.md"),useBytes=TRUE)
    stop(e)
  })
}
main()
