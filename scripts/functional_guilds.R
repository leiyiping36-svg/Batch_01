#!/usr/bin/env Rscript
# Module 1.2. Curated literature associations are genus proxies, never measured functions.
# Run: Rscript --vanilla scripts/functional_guilds.R [--output-dir NEW_DIRECTORY]

functional_rules <- function() {
  refs <- list(
    AOB = c("Chain et al. 2003", "Complete genome sequence of the ammonia-oxidizing bacterium and obligate chemolithoautotroph Nitrosomonas europaea", "10.1128/JB.185.9.2759-2773.2003", "https://pubmed.ncbi.nlm.nih.gov/12700255/"),
    NOB = c("Starkenburg et al. 2006", "Genome sequence of the chemolithoautotrophic nitrite-oxidizing bacterium Nitrobacter winogradskyi Nb-255", "10.1128/AEM.72.3.2050-2063.2006", "https://pubmed.ncbi.nlm.nih.gov/16517654/"),
    COM = c("Daims et al. 2015", "Complete nitrification by Nitrospira bacteria", "10.1038/nature16461", "https://doi.org/10.1038/nature16461"),
    ANA = c("Strous et al. 1999", "Missing lithotroph identified as new planctomycete", "10.1038/22749", "https://pubmed.ncbi.nlm.nih.gov/10440372/"),
    ACC = c("Hesselmann et al. 1999", "Enrichment, phylogenetic analysis and detection of a bacterium that performs enhanced biological phosphate removal in activated sludge", "10.1016/S0723-2020(99)80055-1", "https://pubmed.ncbi.nlm.nih.gov/10553298/"),
    TET = c("Kristiansen et al. 2013", "A metabolic model for members of the genus Tetrasphaera involved in enhanced biological phosphorus removal", "10.1038/ismej.2012.136", "https://pubmed.ncbi.nlm.nih.gov/23178666/"),
    COMP = c("McIlroy et al. 2014 (online 2013)", "Candidatus Competibacter-lineage genomes retrieved from metagenomes reveal functional metabolic diversity", "10.1038/ismej.2013.162", "https://vbn.aau.dk/en/publications/candidatus-competibacter-lineage-genomes-retrieved-from-metagenom/"),
    DEF = c("Burow et al. 2007", "Abundance and ecophysiology of Defluviicoccus spp., glycogen-accumulating organisms in full-scale wastewater treatment processes", "10.1099/mic.0.2006/001032-0", "https://pubmed.ncbi.nlm.nih.gov/17185546/"),
    PROP = c("Albertsen et al. 2016", "Candidatus Propionivibrio aalborgensis: A Novel Glycogen Accumulating Organism Abundant in Full-Scale Enhanced Biological Phosphorus Removal Plants", "10.3389/fmicb.2016.01033", "https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2016.01033/full"),
    DECH = c("Petriglieri et al. 2021", "Candidatus Dechloromonas phosphoritropha and Ca. D. phosphorivorans, novel polyphosphate accumulating organisms abundant in wastewater treatment systems", "10.1038/s41396-021-01029-2", "https://pmc.ncbi.nlm.nih.gov/articles/PMC8630035/"),
    ACIN = c("Tandoi et al. 1998", "The behaviour of polyphosphate accumulating acinetobacter isolates in an anaerobic-aerobic chemostat", "10.1016/S0043-1354(98)00079-7", "https://www.sciencedirect.com/science/article/pii/S0043135498000797"),
    OBS = c("Soo et al. 2014", "An Expanded Genomic Representation of the Phylum Cyanobacteria", "10.1093/gbe/evu073", "https://doi.org/10.1093/gbe/evu073"),
    THAU = c("Wang and He 2020", "Complete nitrogen removal via simultaneous nitrification and denitrification by a novel phosphate accumulating Thauera sp. strain SND5", "10.1016/j.watres.2020.116300", "https://pubmed.ncbi.nlm.nih.gov/32823196/"),
    AMAR = c("Falvo et al. 2001", "Synthesis of intracellular storage polymers by Amaricoccus kaplicensis, a tetrad forming bacterium present in activated sludge", "10.1046/j.1365-2672.2001.01384.x", "https://pubmed.ncbi.nlm.nih.gov/11473594/"),
    NITS = c("Okubo et al. 2021", "The physiological potential of anammox bacteria as revealed by their core genome structure", "10.1093/dnares/dsaa028", "https://pubmed.ncbi.nlm.nih.gov/33367889/")
  )
  rule <- function(id, aliases, guild, bucket, category, strength, ref, reason, resolution = "exact_genus", verification = "primary_abstract_or_indexed_primary_text_verified", alias_url = NA_character_) {
    x <- if (is.na(ref)) rep(NA_character_, 4) else refs[[ref]]
    data.frame(rule_id = id, match_aliases = aliases, proposed_guild = guild, exclusive_partition = bucket,
      evidence_category = category, literature_strength = strength, conservative_guild = if (endsWith(bucket, "_supported")) guild else NA_character_,
      match_rule = "exact equality after whitespace/underscore normalization; never strip --other", taxonomic_resolution = resolution,
      citation = x[1], reference_title = x[2], doi = x[3], reference_url = x[4], alias_source_url = alias_url,
      evidence_verified = verification, verification_date = "2026-11-03", assignment_reason = reason,
      asv_function_confidence = "indirect_16S_only_not_functionally_validated", functional_validation_in_this_project = "not_measured",
      required_validation = "guild-specific genes/genomes and/or cell-specific phenotype/activity; not available here", stringsAsFactors = FALSE)
  }
  supported <- "literature_supported_related_taxon"
  candidate <- "genus_level_candidate_only"
  ambiguous <- "functional_ambiguity"
  do.call(rbind, list(
    rule("R01", "Nitrosomonas", "AOB", "AOB_supported", supported, "strong_for_reference_taxon", "AOB", "Ammonia oxidation demonstrated in reference Nitrosomonas; project ASVs remain genus proxies."),
    rule("R02", "Nitrobacter", "NOB", "NOB_supported", supported, "strong_for_reference_taxon", "NOB", "Reference Nitrobacter oxidizes nitrite; this limited panel is not an exhaustive NOB catalogue."),
    rule("R03", "Nitrospira", "NOB_or_comammox", "Nitrospira_ambiguous", ambiguous, "strong_evidence_of_ambiguity", "COM", "16S genus cannot separate canonical NOB and complete ammonia oxidizers; count once, in neither core AOB nor core NOB."),
    rule("R04", "Brocadia;Candidatus_Brocadia", "AnAOB", "AnAOB_supported", supported, "strong_for_reference_lineage", "ANA", "Exact Brocadia genus marker is an indirect anammox-related proxy, not proof of activity."),
    rule("R05", "Candidatus_Brocadia--other;Brocadia--other", "AnAOB_candidate", "AnAOB_taxonomy_candidate", "taxonomic_information_insufficient", "parent_lineage_supported_label_unresolved", "ANA", "Retain --other verbatim; database suffix definition not verified; do not silently convert to exact Brocadia.", "explicit_unresolved_genus_label"),
    rule("R06", "Accumulibacter;Candidatus_Accumulibacter", "PAO", "PAO_supported", supported, "strong_for_reference_taxon", "ACC", "Polyphosphate/PHA phenotype linked to the Accumulibacter reference lineage; no phenotype measured for these ASVs."),
    rule("R07", "Tetrasphaera", "PAO_candidate", "PAO_genus_candidate", candidate, "reference_species_supported_genus_extrapolation_limited", "TET", "Reference Tetrasphaera physiology is diverse; exclude genus-only assignment from conservative PAO aggregate."),
    rule("R08", "Competibacter;Candidatus_Competibacter", "GAO", "GAO_supported", supported, "strong_for_reference_lineage", "COMP", "Reference enrichment genomes and physiology support GAO association; presence is not evidence of P-removal failure."),
    rule("R09", "Contendibacter;Candidatus_Contendibacter;Contendobacter;Candidatus_Contendobacter", "GAO", "GAO_supported", supported, "strong_for_reference_lineage_verified_alias", "COMP", "Current Contendibacter and historical Contendobacter synonym verified separately; no spelling-based guess.", alias_url = "https://ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?command=show&id=1400859&lvl=3&mode=node"),
    rule("R10", "Defluviicoccus", "GAO", "GAO_supported", supported, "strong_for_reference_lineage", "DEF", "FISH-linked storage physiology supports GAO-related genus proxy; do not confuse Defluviimonas with Defluviicoccus."),
    rule("R11", "Propionivibrio;Candidatus_Propionivibrio;Propionivibrio--other;Candidatus_Propionivibrio--other", "GAO_candidate", "GAO_genus_candidate", candidate, "species_evidence_only_unresolved_local_label", "PROP", "GAO demonstrated for P. aalborgensis, not all genus members; --other retained and excluded from conservative GAO.", "genus_or_explicit_unresolved_label"),
    rule("R12", "Dechloromonas;Candidatus_Dechloromonas", "PAO_or_other", "PAO_ambiguous", ambiguous, "species_specific_PAO_evidence", "DECH", "FISH/Raman evidence concerns specific species; genus-level project ASVs are not all PAOs."),
    rule("R13", "Acinetobacter", "PAO_historical_claim_unresolved", "PAO_ambiguous", ambiguous, "genus_assignment_not_supported_as_EBPR_PAO", "ACIN", "Poly-P storage in some isolates does not establish canonical EBPR physiology; no Acinetobacter ASV enters PAO aggregate.", verification = "primary_abstract_verified_full_text_access_blocked"),
    rule("R14", "Obscuribacter;Candidatus_Obscuribacter", "PAO_candidate", "PAO_genus_candidate", candidate, "reference_genome_potential_only", "OBS", "Reference genome has polyphosphate-related genes; genus match cannot demonstrate an EBPR phenotype or project functional genes."),
    rule("R15", "Thauera", "PAO_candidate", "PAO_genus_candidate", candidate, "single_strain_evidence_only", "THAU", "PAO phenotype reported for SND5; do not generalize to every Thauera or count these ASVs as AOB."),
    rule("R16", "Amaricoccus", "GAO_historical_claim_unresolved", "GAO_ambiguous", ambiguous, "reference_strain_does_not_meet_classical_GAO_model", "AMAR", "Storage polymers alone are insufficient; reference pure-culture physiology differs from classical GAO."),
    rule("R17", "Nitrosymbiomonas;Candidatus_Nitrosymbiomonas", NA_character_, "Evidence_unverified", "unverified_pending_research", "insufficient_for_target_guild_assignment", "NITS", "Nomenclatural/reference link verified, but target-guild claim not verified; never infer nitrification from the genus name.", verification = "bibliography_verified_target_guild_evidence_not_verified", alias_url = "https://lpsn.dsmz.de/genus/nitrosymbiomonas"),
    rule("R18", "CCM19a", NA_character_, "Evidence_unverified", "unverified_pending_research", "direct_primary_function_evidence_not_verified", NA_character_, "Secondary literature suggests GAO association; no direct primary evidence verified in this run, so no guild assignment.", verification = "unverified_no_primary_reference_assigned")
  ))
}

main <- function() {
  started <- Sys.time()
  Sys.setenv(TZ = "Asia/Shanghai")
  script <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)))
  root <- dirname(dirname(script))
  args <- commandArgs(trailingOnly = TRUE)
  baseline <- "results/community_composition/2026-11-03_v2"
  out <- file.path(root, "results/functional_guilds/2026-11-03_v2")
  if (length(args)) { stopifnot(length(args) == 2L, args[1] == "--output-dir"); out <- args[2] }
  if (file.exists(out) || dir.exists(out)) stop("输出目录已存在；禁止覆盖，请指定新版本。", call. = FALSE)
  stopifnot(dir.create(out, recursive = TRUE))
  out <- normalizePath(out)
  log <- file(file.path(out, "run.log"), "wt", encoding = "UTF-8")
  sink(log, split = TRUE); sink(log, type = "message")
  old_warn <- getOption("warn"); options(warn = 1)
  on.exit({options(warn = old_warn); sink(type = "message"); sink(); close(log)}, add = TRUE)
  stamp <- function() format(Sys.time(), "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai")
  cat("Module 1.2 START", stamp(), "Asia/Shanghai\n", paste(commandArgs(), collapse = " "), "\n")
  checks <- data.frame(status = character(), item = character(), evidence = character())
  add <- function(status, item, evidence) {
    checks[nrow(checks) + 1L, ] <<- c(status, item, evidence)
    cat(status, item, ":", evidence, "\n")
  }
  need <- function(ok, item, evidence) {
    add(if (isTRUE(ok)) "PASS" else "FAIL", item, evidence)
    if (!isTRUE(ok)) stop(paste(item, evidence, sep = ": "), call. = FALSE)
  }
  append_file <- function(path, lines) {
    con <- file(path, "at", encoding = "UTF-8")
    tryCatch(writeLines(c("", lines), con, useBytes = TRUE), finally = close(con))
  }
  progress <- function(lines) append_file(file.path(root, "docs/batch_01/analysis_log.md"), c(paste0("### 2026-11-03 / 模块1.2（", stamp(), "）"), lines))
  report_path <- file.path(out, "analysis_report.md")
  tryCatch({
    deps <- c("phyloseq", "digest", "ggplot2", "scales")
    need(all(vapply(deps, requireNamespace, TRUE, quietly = TRUE)), "环境", "复用现有R环境，不安装软件或更新注释。")
    sha <- function(p) digest::digest(file = p, algo = "sha256")
    inputs <- c(object = "results/phyloseq/batch_01_phyloseq.rds", asv = "data/asv_table.tsv", taxonomy = "data/taxonomy.tsv",
      source_metadata = "metadata/source_sample_metadata.tsv", analysis_metadata = file.path(baseline, "analysis_metadata.tsv"),
      module11_report = file.path(baseline, "analysis_report.md"), module11_genus = file.path(baseline, "genus_relative_abundance.tsv"),
      design = "docs/batch_01/experiment_design.md", plan = "docs/batch_01/analysis_plan.md", agents = "AGENTS.md", research_context = "docs/research_context.md")
    paths <- setNames(file.path(root, inputs), names(inputs))
    need(all(file.exists(paths)), "输入存在", paste(inputs, collapse = "; "))
    need(identical(baseline, "results/community_composition/2026-11-03_v2") &&
      all(dirname(inputs[c("analysis_metadata", "module11_report", "module11_genus")]) == baseline),
      "群落v2基线锁定", "metadata、采样顺序及解释来源全部显式锁定community_composition/2026-11-03_v2；群落v1不进入计算输入。")
    fingerprints <- vapply(paths, sha, "")
    protected <- unique(c(unlist(lapply(c("data", "input", "metadata", "results"), function(d) list.files(file.path(root, d), recursive = TRUE, full.names = TRUE))),
      file.path(root, c("AGENTS.md", "docs/research_context.md", "docs/batch_01/experiment_design.md", "docs/batch_01/analysis_plan.md"))))
    protected <- protected[file.exists(protected) & !file.info(protected)$isdir & !startsWith(protected, paste0(out, "/"))]
    protection_before <- vapply(protected, sha, "")
    progress(c("- 已阅读项目约定、背景/设计/计划/日志及模块1.1报告，核对真实输入、样本ID和目标属标签；先向用户报告分类歧义及执行计划。",
      paste0("- 命令：", file.path(R.home("bin"), "Rscript"), " --vanilla scripts/functional_guilds.R；输出：", out, "；RUNNING。"),
      "- 文献通过网页检索核实题名/DOI及原研究摘要或索引正文，全文访问受限者明确标记；Contendibacter/Contendobacter别名另核实，不根据字符串相似强配。全部功能赋值均为16S分类关联，非项目功能/活性验证。"))
    ps <- readRDS(paths["object"])
    counts <- as(phyloseq::otu_table(ps), "matrix")
    taxa <- as(phyloseq::tax_table(ps), "matrix")
    annotation <- attr(ps, "stage1_taxonomy")
    provenance <- attr(ps, "stage1_provenance")
    need(phyloseq::taxa_are_rows(ps) && phyloseq::nsamples(ps) == 33L && phyloseq::ntaxa(ps) == 5510L &&
      identical(unname(provenance$inputs_sha256["asv"]), unname(fingerprints["asv"])) &&
      identical(unname(provenance$inputs_sha256["taxonomy"]), unname(fingerprints["taxonomy"])),
      "原始count对象复用", "5510 ASV × 33样本；原ASV与taxonomy指纹和对象来源一致，无需重跑测序QC或阶段1构建。")
    need(isTRUE(methods::validObject(ps)) && is.numeric(counts) && !anyNA(counts) && all(is.finite(counts)) &&
      all(counts >= 0) && all(counts == floor(counts)) && all(colSums(counts) > 0),
      "本模块输入计算断言", "原始非负整数、无空样本；只检查本次计算必需条件，不重复深度异常筛查。")
    raw_tax <- read.delim(paths["taxonomy"], check.names = FALSE, quote = "", comment.char = "")
    raw_tax <- raw_tax[match(rownames(counts), raw_tax[["Feature ID"]]), , drop = FALSE]
    need(!anyDuplicated(rownames(counts)) && !anyDuplicated(colnames(counts)) && !anyNA(raw_tax[["Feature ID"]]) &&
      identical(raw_tax$Taxon, annotation$Taxon) && identical(raw_tax[["Feature ID"]], rownames(counts)) &&
      identical(rownames(taxa), rownames(counts)), "ASV与原taxonomy一致", "使用原Taxon及Confidence，不重新分类、不改变注释或筛除ASV。")
    meta <- read.delim(paths["analysis_metadata"], check.names = FALSE, colClasses = "character", na.strings = "NA", quote = "")
    source_meta <- read.delim(paths["source_metadata"], check.names = FALSE, colClasses = "character", na.strings = "NA", quote = "")
    need(nrow(meta) == 33L && !anyDuplicated(meta[["sample-id"]]) && setequal(meta[["sample-id"]], colnames(counts)), "样本身份", "完整SampleID与原始metadata/对象逐行匹配，不拼造前缀。")
    meta <- meta[match(colnames(counts), meta[["sample-id"]]), , drop = FALSE]
    rownames(meta) <- meta[["sample-id"]]
    source_meta <- source_meta[match(meta[["sample-id"]], source_meta[["sample-id"]]), , drop = FALSE]
    rownames(source_meta) <- rownames(meta)
    need(identical(meta[, names(source_meta), drop = FALSE], source_meta) &&
      identical(meta, data.frame(phyloseq::sample_data(ps), check.names = FALSE)), "metadata原值及对象一致", "原14列全部值保留；模块1.1派生表与RDS一致，G4基线分析DO NA/文档3分列沿用。")
    need(identical(as.integer(table(factor(meta$group, levels = paste0("G", 1:5)))), c(8L, 2L, 4L, 15L, 4L)),
      "五模块数量", "G1/G2/G3/G4/G5=8/2/4/15/4；主29样本，G5四级分。")
    order_ids <- names(read.delim(paths["module11_genus"], nrows = 0, check.names = FALSE))[-(1:3)]
    need(length(order_ids) == 33L && !anyDuplicated(order_ids) && setequal(order_ids, colnames(counts)),
      "模块1.1排序复用", "直接读取有效v2矩阵表头，沿用其33样本已确认顺序。")
    counts <- counts[, order_ids, drop = FALSE]
    meta <- meta[order_ids, , drop = FALSE]
    meta$reactor <- unname(c(Reactor_01 = "R1", Reactor_02 = "R2", Reactor_03 = "R3", Reactor_04 = "R4")[meta$reactor_id])
    meta$day <- as.numeric(meta$phase_days)
    expected <- list(R1 = c("A0", "A1", "A2", "E1", "E2", "E3"), R2 = c("B0", "B1", "B2", "B3", "F1", "F2", "F3", "F4"),
      R3 = c("C0", "C1", "C2", "G1", "G2", "G3", "G4"), R4 = c("D0", "D1", "D2", "D3", "H1", "H2", "H3", "H4"))
    for (r in names(expected)) {
      ii <- which(meta$reactor == r & meta$group != "G5")
      need(identical(meta$supplier_sample_id[ii], expected[[r]]) &&
        all(vapply(split(meta$day[ii], meta$reactor_round[ii]), function(x) all(diff(x) > 0), TRUE)), paste0(r, "排序与轮次"), paste(meta$supplier_sample_id[ii], collapse = " → "))
    }
    baseline <- meta$group == "G4" & meta$day == 1
    later <- meta$group == "G4" & meta$day >= 25
    need(sum(baseline) == 4 && sum(later) == 11 && all(is.na(meta$DO_measured_mg_L)) &&
      all(is.na(meta$DO_setpoint_mg_L[baseline])) && all(meta$DO_setpoint_mg_L[later] == "0.5"),
      "DO与实验层级", "保留4初始基线和11后期设计稳定期；全部实测NA，未按组整体填DO。")
    rules <- functional_rules()
    normalize <- function(x) gsub("[[:space:]]+", "_", trimws(x))
    alias_lists <- lapply(strsplit(rules$match_aliases, ";", fixed = TRUE), normalize)
    aliases <- unlist(alias_lists, use.names = FALSE)
    rule_idx <- rep(seq_len(nrow(rules)), lengths(alias_lists))
    need(!anyDuplicated(aliases) && !anyNA(rules$rule_id) && !anyDuplicated(rules$rule_id), "规则无重叠", "明确列出的属别名只对应一个规则；不做子字符串/模糊匹配，不删除--other。")
    genus <- taxa[, "Genus"]
    is_missing <- is.na(genus) | !nzchar(trimws(genus)) | grepl("^(uncultured|unclassified|unidentified|unknown|unassigned|metagenome|incertae[ _]sedis)([ _-].*)?$", genus, ignore.case = TRUE)
    has_other <- !is_missing & grepl("--other$", genus)
    a <- data.frame(feature_id = rownames(counts), original_taxonomy = raw_tax$Taxon, taxonomy_classifier_confidence = raw_tax$Confidence,
      genus = genus, genus_resolution = ifelse(is_missing, "genus_unassigned_or_placeholder", ifelse(has_other, "genus_label_unresolved_suffix", "genus_label_present")),
      stringsAsFactors = FALSE)
    mapped <- rule_idx[match(normalize(genus), aliases)]
    a$rule_id <- NA_character_
    a$exclusive_partition <- ifelse(is_missing | has_other, "Taxonomy_insufficient", "Unmapped_named_taxa")
    a$evidence_category <- ifelse(is_missing | has_other, "taxonomic_information_insufficient", "named_taxon_function_not_assigned")
    a$proposed_guild <- a$conservative_guild <- a$reference_url <- a$literature_strength <- a$evidence_verified <- NA_character_
    a$assignment_reason <- ifelse(is_missing | has_other, "Insufficient genus resolution; no function imputed from higher ranks", "Outside this curated target-guild panel; not evidence of absence of biological function")
    for (field in c("rule_id", "exclusive_partition", "evidence_category", "proposed_guild", "conservative_guild", "reference_url", "literature_strength", "evidence_verified", "assignment_reason")) {
      keep <- which(!is.na(mapped))
      a[keep, field] <- rules[mapped[keep], field]
    }
    a$asv_function_confidence <- ifelse(!is.na(mapped), "indirect_16S_only_not_functionally_validated", "not_assignable")
    a$functional_validation_in_this_project <- "not_measured"
    # Literature support for a genus never implies functional validation of this ASV.
    partition_levels <- c("AOB_supported", "NOB_supported", "AnAOB_supported", "PAO_supported", "GAO_supported",
      "Nitrospira_ambiguous", "AnAOB_taxonomy_candidate", "PAO_genus_candidate", "GAO_genus_candidate", "PAO_ambiguous", "GAO_ambiguous",
      "Evidence_unverified", "Taxonomy_insufficient", "Unmapped_named_taxa")
    need(nrow(a) == nrow(counts) && !anyDuplicated(a$feature_id) && all(a$exclusive_partition %in% partition_levels),
      "ASV互斥分配", "5510 ASV各一行、一个汇总类别；候选功能为注释文字，不另累计到互斥组。")
    core <- a$exclusive_partition %in% paste0(c("AOB", "NOB", "AnAOB", "PAO", "GAO"), "_supported")
    need(all(a$evidence_category[core] == "literature_supported_related_taxon") &&
      all(!is.na(a$reference_url[core])) && all(!is.na(a$conservative_guild[core])), "保守汇总证据门控", "只累计预定义强文献关联属标记；所有ASV仍仅有16S间接证据。")
    need(all(a$exclusive_partition[genus %in% "Nitrospira"] == "Nitrospira_ambiguous") &&
      all(is.na(a$conservative_guild[genus %in% c("Nitrospira", "Acinetobacter", "Dechloromonas", "Candidatus_Brocadia--other", "Propionivibrio--other")])),
      "关键歧义不泄漏", "Nitrospira不计AOB/NOB；Acinetobacter/Dechloromonas不计PAO；--other不自动转为已鉴定功能属。")
    need(all(a$exclusive_partition[genus %in% "Candidatus_Contendibacter"] == "GAO_supported") &&
      all(a$exclusive_partition[genus %in% "Defluviimonas"] == "Unmapped_named_taxa"), "已核实别名与相似名区分", "Contendibacter别名有NCBI记录；Defluviimonas不误配Defluviicoccus。")
    rules$n_matched_asvs <- vapply(seq_len(nrow(rules)), function(i) sum(a$rule_id %in% rules$rule_id[i]), 0L)
    rules$matched_raw_genus_labels <- vapply(seq_len(nrow(rules)), function(i) paste(sort(unique(genus[a$rule_id %in% rules$rule_id[i]])), collapse = ";"), "")
    progress(c(paste0("- 功能映射完成：", nrow(rules), "条显式规则；", sum(!is.na(mapped)), "个ASV命中（含候选/歧义/待研究）；全部5510 ASV保留且互斥。"),
      "- Nitrospira、Acinetobacter/Dechloromonas、--other及未核实类群的排除断言通过。保守汇总是文献关联属读数代理，不是功能确证。"))
    guild_counts <- matrix(0, length(partition_levels), ncol(counts), dimnames = list(partition_levels, colnames(counts)))
    for (p in partition_levels) guild_counts[p, ] <- colSums(counts[a$exclusive_partition == p, , drop = FALSE])
    guild_rel <- sweep(guild_counts, 2, colSums(counts), "/")
    need(all(colSums(guild_counts) == colSums(counts)) && max(abs(colSums(guild_rel) - 1)) < 1e-12,
      "全reads守恒", "功能相关/候选/歧义/未分类/未映射的互斥分区之和=全部原始reads；未对功能子集重新归一化。")
    taxa_key <- ifelse(is.na(genus) | genus == "", "Unclassified_genus", genus)
    taxa_counts <- rowsum(counts, taxa_key, reorder = TRUE)
    taxa_rel <- sweep(taxa_counts, 2, colSums(counts), "/")
    first <- match(rownames(taxa_counts), taxa_key)
    need(max(abs(colSums(taxa_rel) - 1)) < 1e-12, "属级相对丰度", "保留所有原始属标签及未分类行，分母始终为每样本全部ASV reads。")
    guild_df <- data.frame(exclusive_partition = partition_levels,
      n_asvs = as.integer(table(factor(a$exclusive_partition, levels = partition_levels))),
      is_conservative_guild_proxy = partition_levels %in% paste0(c("AOB", "NOB", "AnAOB", "PAO", "GAO"), "_supported"), guild_rel, check.names = FALSE)
    taxa_df <- data.frame(genus_label = rownames(taxa_rel), n_asvs = as.integer(table(factor(taxa_key, levels = rownames(taxa_rel)))),
      rule_id = a$rule_id[first], evidence_category = a$evidence_category[first], exclusive_partition = a$exclusive_partition[first],
      conservative_guild = a$conservative_guild[first], taxa_rel, check.names = FALSE)
    write_tsv <- function(x, name) {
      path <- file.path(out, name); stopifnot(!file.exists(path))
      write.table(x, path, sep = "\t", row.names = FALSE, quote = FALSE, na = "NA", fileEncoding = "UTF-8")
    }
    write_tsv(a, "functional_asv_annotation.tsv")
    write_tsv(guild_df, "functional_guild_abundance.tsv")
    write_tsv(taxa_df, "functional_taxa_abundance.tsv")
    write_tsv(rules, "functional_mapping_evidence.tsv")
    library(ggplot2)
    # Run facets preserve the reset day axes; sample order comes from module 1.1.
    round_labels <- c(G1_original = "Startup (old reactors)", G2G3_postmix = "After mixing / splitting", G4G5_low_DO = "After storage / recovery")
    meta$plot_block <- unname(round_labels[meta$reactor_round])
    meta$plot_block[meta$group == "G5"] <- "G5 | one mother sample"
    meta$plot_block <- factor(meta$plot_block, levels = c(unname(round_labels), "G5 | one mother sample"))
    meta$sample_label <- paste0(meta$supplier_sample_id, "\n", meta$group, " d", ifelse(meta$sampling_day_status == "approximate_recorded", "~", ""), meta$phase_days)
    meta$sample_label[baseline] <- paste0(meta$supplier_sample_id[baseline], "\nbaseline")
    meta$sample_label[meta$group == "G5"] <- paste0(meta$supplier_sample_id[meta$group == "G5"], "\n", gsub("–", "-", meta$particle_size_fraction_um[meta$group == "G5"]), " um")
    partition_labels <- c("AOB-related | supported", "NOB-related | supported", "AnAOB-related | supported", "PAO-related | supported", "GAO-related | supported",
      "Nitrospira | NOB/comammox unresolved", "AnAOB candidate | unresolved taxonomy", "PAO candidate | genus only", "GAO candidate | genus only", "PAO claim | function ambiguous", "GAO claim | function ambiguous",
      "Evidence unverified | pending", "Taxonomy insufficient", "Other named taxa | not assigned")
    names(partition_labels) <- partition_levels
    partition_colors <- setNames(c("#0072B2", "#009E73", "#56B4E9", "#CC79A7", "#E69F00", "#332288", "#88CCEE", "#DDCC77", "#AA4499", "#882255", "#44AA99", "#999933", "#555555", "#D9D9D9"), partition_levels)
    long <- function(mat) {
      d <- data.frame(series = rep(rownames(mat), ncol(mat)), sample_id = rep(colnames(mat), each = nrow(mat)), value = as.vector(mat))
      d$sample_id <- factor(d$sample_id, levels = order_ids)
      idx <- match(as.character(d$sample_id), rownames(meta))
      cbind(d, meta[idx, c("reactor", "day", "plot_block", "group"), drop = FALSE])
    }
    theme_common <- theme_bw(base_size = 11, base_family = "DejaVu Sans") + theme(panel.grid.major.x = element_blank(),
      legend.position = "bottom", legend.text = element_text(size = 9), plot.caption = element_text(size = 8, hjust = 0), strip.text = element_text(face = "bold"))
    labels <- setNames(meta$sample_label, rownames(meta))
    stack <- function(ids, title, subtitle, faceted = TRUE, fraction = FALSE) {
      d <- long(guild_rel[, ids, drop = FALSE]); d$series <- factor(d$series, levels = partition_levels)
      p <- ggplot(d, aes(sample_id, value, fill = series)) + geom_col(width = 0.8) +
        scale_fill_manual(values = partition_colors, labels = partition_labels, drop = FALSE) +
        scale_y_continuous(labels = scales::label_percent(), expand = expansion(mult = c(0, 0))) + coord_cartesian(ylim = c(0, 1)) +
        scale_x_discrete(labels = labels) + labs(title = title, subtitle = subtitle, y = "Fraction of ALL ASV reads", fill = "Exclusive evidence partition",
          x = if (fraction) "Particle size fraction (um); same mother sample" else "Recorded sample order within each run; day axes reset between facets",
          caption = "16S genus associations only. Nitrospira, ambiguous PAO/GAO claims and unassigned reads remain separate. No activity or absolute abundance inferred.") +
        theme_common + guides(fill = guide_legend(ncol = 3, byrow = TRUE))
      if (faceted) p <- p + facet_grid(cols = vars(plot_block), scales = "free_x", space = "free_x")
      layer <- ggplot_build(p)$data[[1]]
      sums <- aggregate(layer$ymax - layer$ymin, list(panel = layer$PANEL, position = layer$x), sum)$x
      need(nrow(layer) == nrow(d) && all(is.finite(layer$ymax)) && max(abs(sums - 1)) < 1e-12, paste0(title, "图层"), "全部互斥类别保留，每个实际样本堆叠高度≈1；没有比例刻度删除。")
      p
    }
    save_pair <- function(p, stem, width = 15, height = 8.5) {
      paths_out <- file.path(out, paste0(stem, c(".pdf", ".png")))
      need(!any(file.exists(paths_out)), paste0(stem, "不覆盖"), "新目录首次生成图。")
      grDevices::cairo_pdf(paths_out[1], width = width, height = height, family = "DejaVu Sans")
      tryCatch(print(p), finally = grDevices::dev.off())
      grDevices::png(paths_out[2], width = width, height = height, units = "in", res = 160, type = "cairo")
      tryCatch(print(p), finally = grDevices::dev.off())
      need(all(file.info(paths_out)$size > 1000), paste0(stem, "输出"), "矢量PDF和160dpi PNG均生成。")
    }
    allplot <- stack(order_ids, "Batch_01 | functional-associated composition | 33 samples", "Five modules: 8/2/4/15/4 records; G5 is one mother sample, not four replicates") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8))
    save_pair(allplot, "all_samples_functional_composition", 19, 8.5)
    for (r in names(expected)) {
      ids <- rownames(meta)[meta$reactor == r & meta$group != "G5"]
      p <- stack(ids, paste(r, "| functional-associated succession"), "Run boundaries: mixing/splitting; storage at 4 C for 59 d and recovery. No continuous global day axis.")
      save_pair(p, paste0(r, "_functional_succession"))
    }
    fraction_ids <- rownames(meta)[meta$group == "G5"]
    need(identical(meta$supplier_sample_id[meta$group == "G5"], paste0("S", 1:4)) &&
      length(unique(meta$fractionation_event_id[meta$group == "G5"])) == 1, "G5分级层级", "S1–S4按粒径排序，共用一个母样事件，不称为技术或独立生物重复。")
    save_pair(stack(fraction_ids, "G5 | functional-associated size fractions", "R1 one mother sample; 145+18 d (derived); stage DO setting 0.5+/-0.2 mg/L", FALSE, TRUE), "G5_functional_composition", 14, 8.5)
    observed_taxa <- rownames(taxa_rel)[rownames(taxa_rel) %in% unique(genus[!is.na(mapped) & !a$exclusive_partition %in% "Evidence_unverified"])]
    trend <- long(taxa_rel[observed_taxa, rownames(meta)[meta$group == "G4"], drop = FALSE])
    trend$series <- factor(trend$series, levels = observed_taxa)
    trend$reactor <- factor(trend$reactor, levels = paste0("R", 1:4))
    trend$is_baseline <- trend$day == 1
    rcolors <- c(R1 = "#0072B2", R2 = "#D55E00", R3 = "#009E73", R4 = "#CC79A7")
    trend_labels <- function(x) gsub("Candidatus_", "Ca. ", x, fixed = TRUE)
    p <- ggplot(trend, aes(day, value, color = reactor, group = reactor)) +
      annotate("rect", xmin = 1, xmax = 24, ymin = -Inf, ymax = Inf, fill = "#EEEEEE", color = NA) +
      geom_line(linewidth = 0.6) + geom_point(aes(shape = is_baseline), size = 2) +
      facet_wrap(vars(series), ncol = 3, scales = "free_y", labeller = labeller(series = trend_labels)) +
      scale_color_manual(values = rcolors) + scale_shape_manual(values = c(`TRUE` = 1, `FALSE` = 16), labels = c(`TRUE` = "Before-switch baseline", `FALSE` = "Post-adaptation sample")) +
      scale_x_continuous(breaks = c(1, 30, 76, 145)) +
      scale_y_continuous(labels = scales::label_percent(), limits = function(x) c(0, max(c(1e-5, x[is.finite(x)]))), expand = expansion(mult = c(0, 0.05))) +
      labs(title = "G4 | individual functional-associated taxa", subtitle = "Each panel has its own y scale. Grey: baseline / adjustment interval; later samples are design-stable period (DO setting 0.5+/-0.2).",
        x = "Recorded G4 day; lines join observed samples only (no interpolation)", y = "Fraction of ALL ASV reads", color = "Reactor", shape = "Sampling position",
        caption = "Candidates and ambiguous taxa are shown as taxa, not assigned functions. Baseline DO setting uncertain in analysis metadata. R1 has no d30 observation.") + theme_common
    need(nrow(ggplot_build(p)$data[[3]]) == nrow(trend), "G4逐属趋势覆盖", paste0(length(observed_taxa), "个已检出的已审阅属标签×15条G4记录；含4基线和11后期。"))
    save_pair(p, "G4_functional_taxa_trends", 16, max(10, ceiling(length(observed_taxa) / 3) * 2.7))
    compare <- long(guild_rel[c("PAO_supported", "GAO_supported"), , drop = FALSE])
    compare$series <- factor(compare$series, levels = c("PAO_supported", "GAO_supported"), labels = c("PAO-related | conservative proxy", "GAO-related | conservative proxy"))
    p <- ggplot(compare, aes(sample_id, value, fill = series)) + geom_col(width = 0.8) +
      facet_grid(rows = vars(series), cols = vars(plot_block), scales = "free", space = "free_x") +
      scale_x_discrete(labels = labels) + scale_y_continuous(labels = scales::label_percent()) +
      scale_fill_manual(values = c("#CC79A7", "#E69F00")) + labs(title = "PAO / GAO related taxa | descriptive comparison", subtitle = "Separate y scales; all 33 records retained; no PAO:GAO ratio or independent-sample test",
        x = "Recorded order; G5 ordered by particle size", y = "Fraction of ALL ASV reads", fill = "Evidence-supported genus proxy",
        caption = "PAO core: Accumulibacter. GAO core: Competibacter + Contendibacter + Defluviicoccus. Acinetobacter / Dechloromonas are excluded from PAO core.") +
      theme_common + theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8), legend.position = "none")
    need(nrow(ggplot_build(p)$data[[1]]) == 66L, "PAO/GAO对照覆盖", "33样本×2个保守关联代理；零值保留，不计算可能误导的竞争或性能指标。")
    save_pair(p, "PAO_GAO_descriptive_comparison", 19, 9)
    for (name in c("functional_guild_abundance.tsv", "functional_taxa_abundance.tsv")) {
      back <- read.delim(file.path(out, name), check.names = FALSE)
      expected_mat <- if (startsWith(name, "functional_guild")) guild_rel else taxa_rel
      actual <- as.matrix(back[, order_ids, drop = FALSE])
      need(identical(dim(actual), dim(expected_mat)) && max(abs(actual - expected_mat)) < 1e-12 && max(abs(colSums(actual) - 1)) < 1e-12,
        paste0(name, "回读"), "全部样本列数值与内存计算一致，并保持全部reads分母。")
    }
    need(identical(vapply(protected, sha, ""), protection_before), "历史数据与结果保护", paste0(length(protected), "个原输入、既有结果与设计文件SHA-256不变；原RDS及模块1.1 v1/v2未改写。"))
    add("WARNING", "功能推断边界", "强文献支持的是参考类群关联，不是本项目ASV功能确证、功能基因测定或代谢活性；16S拷贝数/扩增偏倚未校正。")
    add("WARNING", "NOB与AnAOB零值边界", "保守面板无匹配ASV时为0，仅表示该显式面板未检出；Nitrospira/--other候选另列，不能称NOB或AnAOB不存在。")
    add("WARNING", "未核实文献与分类", "CCM19a直接原研究功能证据未核实；Nitrosymbiomonas目标功能未核实；--other语义未确认。不强制分配功能或删除后缀。")
    add("WARNING", "来源/时间与样本量", "主29行含前后/纵向记录及共享混合来源；G2两节点、G4缺R1-30d、G5单母样四级分；不独立，不作显著性、网络或因果分析。")
    add("WARNING", "DO及稳态", "初始4样本DO设置分析NA/文档恢复3的差异沿用，全部实测DO未知；后11样本按设计稳定期，性能稳态未核验。")
    add("WARNING", "文献检索覆盖", "人工目标面板并非全功能注释或穷尽文献；若未映射不等于无功能。部分出版社/PMC全文访问受限，逐规则记录实际核实层级。")
    table_md <- function(df) {
      df[] <- lapply(df, function(x) { x <- as.character(x); x[is.na(x)] <- "NA"; gsub("|", "/", gsub("[\r\n]", " ", x), fixed = TRUE) })
      c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
        apply(df, 1, function(x) paste0("| ", paste(x, collapse = " | "), " |")))
    }
    main_ids <- rownames(meta)[meta$group != "G5"]
    overview <- data.frame(类别 = partition_levels, ASV数 = guild_df$n_asvs,
      主29样本等记录均值 = sprintf("%.4f%%", rowMeans(guild_rel[, main_ids, drop = FALSE]) * 100),
      样本范围 = apply(guild_rel, 1, function(x) sprintf("%.4f–%.4f%%", min(x) * 100, max(x) * 100)))
    taxa_review <- taxa_df[!is.na(taxa_df$rule_id), c("genus_label", "n_asvs", "rule_id", "evidence_category", "exclusive_partition")]
    taxa_review$主29均值 <- sprintf("%.4f%%", rowMeans(taxa_rel[taxa_review$genus_label, main_ids, drop = FALSE]) * 100)
    taxa_review$全33最高 <- vapply(taxa_review$genus_label, function(g) {
      x <- taxa_rel[g, ]; id <- names(x)[which.max(x)]; paste0(meta$supplier_sample_id[match(id, rownames(meta))], " ", sprintf("%.4f%%", max(x) * 100))
    }, "")
    per_reactor <- character()
    markers <- c("PAO_supported", "GAO_supported", "AOB_supported", "Nitrospira_ambiguous", "AnAOB_taxonomy_candidate")
    for (r in names(expected)) {
      ids <- rownames(meta)[meta$reactor == r & meta$group == "G4"]
      per_reactor <- c(per_reactor, paste0("| ", r, " | ", paste(meta$supplier_sample_id[match(ids, rownames(meta))], collapse = " → "), " | ",
        paste(vapply(markers, function(g) paste0(g, ": ", paste(sprintf("%.4f%%", guild_rel[g, ids] * 100), collapse = " → ")), ""), collapse = "；"), " |"))
    }
    # These observations are numeric summaries, not tests or causal claims.
    seq_lines <- character()
    for (r in names(expected)) {
      ids <- rownames(meta)[meta$reactor == r & meta$group == "G4"]
      seq_lines <- c(seq_lines, paste0("- ", r, "的G4 GAO关联保守代理：", paste(meta$supplier_sample_id[match(ids, rownames(meta))], sprintf("%.2f%%", guild_rel["GAO_supported", ids] * 100), collapse = " → "), "。"))
    }
    literature <- unique(rules[, c("citation", "reference_title", "doi", "reference_url")])
    literature <- literature[!is.na(literature$citation), , drop = FALSE]
    refs_md <- vapply(seq_len(nrow(literature)), function(i) paste0("- ", literature$citation[i], ". [", literature$reference_title[i], "](", literature$reference_url[i], "). DOI: ", literature$doi[i], "."), "")
    input_table <- data.frame(输入 = inputs, SHA256 = unname(fingerprints), check.names = FALSE)
    versions <- paste(deps, vapply(deps, function(x) as.character(utils::packageVersion(x)), ""), collapse = "；")
    g5table <- data.frame(级分 = meta$supplier_sample_id[meta$group == "G5"], 粒径um = meta$particle_size_fraction_um[meta$group == "G5"], check.names = FALSE)
    for (g in markers) g5table[[g]] <- sprintf("%.4f%%", guild_rel[g, fraction_ids] * 100)
    mapping_view <- rules[, c("rule_id", "match_aliases", "proposed_guild", "exclusive_partition", "n_matched_asvs", "evidence_verified")]
    lines <- c("# Batch_01 模块1.2：传统功能相关类群识别与相对丰度", "",
      "**当前有效结果：results/functional_guilds/2026-11-03_v2/。上游基线：results/community_composition/2026-11-03_v2/。功能分析旧v1仅作历史，后续引用本v2。**", "",
      paste0("运行时间：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai"), "–", stamp(), "（Asia/Shanghai）。"),
      paste0("状态：PASS（描述性、文献关联层面）；", sum(checks$status == "PASS"), " PASS / ", sum(checks$status == "WARNING"), " WARNING / ", sum(checks$status == "FAIL"), " FAIL。"), "",
      "## 数据与证据含义", "",
      "复用模块1.1有效v2的原始count phyloseq及33行派生metadata；5,510 ASV全部保留，G1–G5为8/2/4/15/4。主29行与G5四级分分开解释，样本顺序直接来自v2矩阵表头，并逐反应器断言确认。没有重跑QC、DADA2、SILVA、对象构建、筛选、稀释或功能预测工具。", "",
      "本报告的“功能相关”是文献中参考类群与功能的关联，所有项目ASV只有16S分类证据。即使literature_strength为strong，也不能称本项目ASV已测得功能、功能基因拷贝数或活性；taxonomy_classifier_confidence只是分类器置信度，不能当功能可信度。没有qPCR、功能基因测量或绝对丰度。", "",
      "## 规则、证据分级与互斥性", "",
      "1. literature_supported_related_taxon：仅预定义的Nitrosomonas(AOB)、Nitrobacter(NOB)、精确Brocadia(AnAOB)、Accumulibacter(PAO)、Competibacter/Contendibacter/Defluviicoccus(GAO)可进入对应保守关联代理。这个小面板故意不等于所有功能成员。",
      "2. genus_level_candidate_only：参考种/菌株或基因组有相关证据，但不能外推整个属，单列候选，不计保守汇总。",
      "3. taxonomic_information_insufficient：缺失/未定属标签、Incertae_Sedis及--other等分类不足；Brocadia--other保留为AnAOB分类受限候选，不强改为Brocadia。",
      "4. functional_ambiguity：Nitrospira(NOB/comammox)、Dechloromonas/Acinetobacter(PAO相关主张有属内/生理歧义)、Amaricoccus(GAO历史主张)独立记录。",
      "5. unverified_pending_research及named_taxon_function_not_assigned：目标功能未核实或不在本面板；保留待研究，不能解释为无功能。", "",
      "每个ASV只有一条annotation和一个exclusive_partition。proposed_guild可记录歧义/候选文字，不能据此把同一ASV重复加进互斥功能组。Contendibacter/Contendobacter别名由[NCBI分类记录](https://ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?command=show&id=1400859&lvl=3&mode=node)核实，依据原研究GAO谱系证据归入关联代理；不会按Defluviimonas或Nitrosymbiomonas名称相似性推断功能。", "",
      "文献核实方式：2026-11-03通过在线检索读取原研究摘要、出版信息或索引的原研究正文片段，核对题名、DOI及支撑论点。不是全文系统综述；PMC验证码、出版社403/重定向导致部分全文未取得，不声称通读全文。Acinetobacter明确为摘要核实/全文受限；CCM19a未核实直接原研究，reference为NA；Nitrosymbiomonas仅核实书目信息/分类来源，目标功能不予赋值。每条规则的来源、核实层级及理由均在functional_mapping_evidence.tsv。", "",
      "## 实际检查", "", table_md(checks), "",
      "## 映射面板与实际命中", "", table_md(mapping_view), "",
      "## 丰度定义与全reads分母", "",
      "每个功能相关属或互斥证据分区的丰度 = 该样本所含ASV原始reads之和 / 该样本全部ASV reads之和。未按已映射功能子集重新归一化。functional_guild_abundance.tsv的14个互斥分区（含未分类/未映射）之和≈1；五个保守功能关联代理的和通常小于1。functional_taxa_abundance.tsv保留所有原始属标签及其规则/证据/分区；属标签相同的ASV在此求和，完整谱系仍在ASV注释中，未改写原taxonomy。", "",
      "所有TSV比例均为0–1；报告及图中乘100显示百分比。保守NOB或AnAOB为0时，只表示该显式精确属面板没有匹配，不能称相应功能菌或过程不存在；Nitrospira与Brocadia--other均在独立行。未命中某参考属也不证明完全未检出该功能。", "",
      "## 功能关联、歧义及未知比例", "", table_md(overview), "",
      "主29样本均值对记录等权，受反应器/时间不平衡影响；不是等反应器均值、时间积分或独立重复总体估计。范围只是本批样本最小/最大值，不是置信区间。", "",
      "## 单个已审阅属标签", "", table_md(taxa_review), "",
      "## 各反应器G4实际轨迹", "",
      "下表同时保留初始基线和后期节点；全部比例用相同分母，未做检验。", "",
      "| 反应器 | 实际样本顺序 | 功能关联代理/歧义类别比例（与样本顺序对应） |", "|---|---|---|", per_reactor, "", seq_lines, "",
      "## G5单一母样粒径组分", "", table_md(g5table), "",
      "G5四组分不作为四份独立生物重复；筛分边界和处理细节未知，不加权重建母样、不做粒径差异显著性检验。", "",
      "## 图表与解释限制", "",
      "- all_samples_functional_composition：33样本全reads互斥证据分区堆叠，按启动、混合后、保存恢复后、G5分面；G5仅为粒径顺序。",
      "- R1–R4_functional_succession：各自实际采样顺序，轮次间分面；约120d保留近似属性，不跨混合或4℃59天保存/恢复拼接统一日数。",
      "- G4_functional_taxa_trends：所有已检出的、已审阅功能相关/候选/歧义属分别展示；面板纵轴独立，灰区为初始/调试间隔，1d为切换前基线，30/76/145d属设计稳定运行期。线仅连接实际取样点，不意味着未采样日有观测或已验证连续趋势；R1缺30d。",
      "- G5_functional_composition：同一母样四个粒径组分，独立展示，非时间序列。",
      "- PAO_GAO_descriptive_comparison：保守PAO关联代理与GAO关联代理分面描述，纵轴独立；不计算PAO:GAO比值、竞争系数或显著性，不把GAO较高等同除磷失败。Acinetobacter/Dechloromonas不计PAO保守值，候选见逐属图。",
      "- 每图PDF为矢量，PNG为160dpi；图内使用ASCII/英文以保证字体完整，绘图比例视窗不删除浮点累加略超1的顶段。", "",
      "## 科学边界与待验证问题", "",
      "- 读数比例不同只说明本批16S分类组成不同；本项目未测功能基因、细胞内poly-P/糖原、qPCR或类群特异活性。不能从PAO/GAO代理推断真实磷摄取、碳竞争、氨/亚硝酸盐转化或代谢速率。",
      "- 属内种/菌株多样性、16S片段分辨率、拷贝数和提取/扩增偏倚限制功能外推。Nitrospira须功能基因/基因组等证据区分NOB与comammox；AnAOB候选也需进一步验证。",
      "- 主29记录存在前后/纵向相关、两个混合来源块与反应器/时间/设置混杂，不作为独立重复。G2/G3 DO与时间共同变化；G4保存恢复不能视为前轮连续运行。",
      "- 保留G4四基线分析DO NA与文档历史恢复设置3的差异；后期11行设置0.5±0.2仅为阶段设置，所有瞬时DO未知，运行性能稳态证据未审阅。不编造DO相关趋势或效应。",
      "- 单批次不能排除提取/PCR/测序批次效应，缺少恢复时长、接种量、母样编号及运行性能等证据；不做差异显著性、网络或因果推断。",
      "- 未来假设可以是不同来源/运行经历伴随功能相关类群的组成差别；本次描述不足以验证适应机制、真实代谢贡献或过程性能。", "",
      "## 文献来源（原研究为主；并非本项目测量）", "", refs_md, "",
      "## 复现与交付", "",
      paste0("命令：`", file.path(R.home("bin"), "Rscript"), " --vanilla scripts/functional_guilds.R --output-dir NEW_VERSION_DIRECTORY`。默认results/functional_guilds/2026-11-03_v2，已存在即非零退出，不覆盖。规则与书目信息内置于同一脚本，沿用2026-11-03已审阅快照，本次未重新检索或新增文献证据；后续文献变化需另建版本。"),
      paste0("工具：", R.version.string, "；", versions, "；无随机步骤。"), "", table_md(input_table), "",
      paste0("脚本SHA-256：", sha(script), "。原始输入、原metadata、既有RDS、模块1.1及AGENTS/设计/计划均不改写；本模块不新增metadata副本或RDS。"), "",
      "文件：", "", paste0("- `", sort(c(list.files(out), "analysis_report.md")), "`"), "",
      paste0("用时：", round(as.numeric(difftime(Sys.time(), started, units = "secs")), 3), "秒。"), "",
      "```text", capture.output(sessionInfo()), "```", "")
    writeLines(lines, report_path, useBytes = TRUE)
    # Keep observations, hypotheses and questions separate in the cumulative documents.
    relative_out <- substring(out, nchar(root) + 2L)
    anchor <- "module12-functional-guilds-v2"
    interp <- c(paste0('<a id="', anchor, '"></a>'), "", "## 2026-11-03 模块1.2：传统功能相关类群（已完成；16S文献关联）", "",
      paste0("有效结果：[综合报告](../../", relative_out, "/analysis_report.md)、[映射证据](../../", relative_out, "/functional_mapping_evidence.tsv)、[ASV注释](../../", relative_out, "/functional_asv_annotation.tsv)、[功能分区丰度](../../", relative_out, "/functional_guild_abundance.tsv)、[逐属丰度](../../", relative_out, "/functional_taxa_abundance.tsv)。"), "",
      "**方法与状态。** 复用模块1.1原始count对象、33样本分组与采样顺序；每属/证据分区reads除以样本全部ASV reads。保守关联代理、属水平候选、分类不足、功能歧义和待研究分开，每ASV一个互斥汇总分区。原始taxonomy及分类器置信度保留，不把它当功能可信度。18条人工规则的原研究摘要/索引内容、DOI和实际核实状态记录于证据表；未核实不强配。没有重跑QC/注释、筛选、稀释或生成绝对丰度。", "",
      "**直接观察（本批读数代理）。**", "", table_md(overview), "", seq_lines, "",
      "Nitrospira单列NOB/comammox歧义，不计两组；Dechloromonas/Acinetobacter不计保守PAO；Brocadia--other保留分类受限候选。Contendibacter与文献Contendobacter的同义关系已经NCBI核实；Defluviimonas不误当Defluviicoccus。保守NOB/AnAOB为0只能说明本小面板的精确标记未匹配，不说明功能不存在。", "",
      paste0("[33样本组成图](../../", relative_out, "/all_samples_functional_composition.pdf)、[R1](../../", relative_out, "/R1_functional_succession.pdf)、[R2](../../", relative_out, "/R2_functional_succession.pdf)、[R3](../../", relative_out, "/R3_functional_succession.pdf)、[R4](../../", relative_out, "/R4_functional_succession.pdf)、[G4逐属趋势](../../", relative_out, "/G4_functional_taxa_trends.pdf)、[G5](../../", relative_out, "/G5_functional_composition.pdf)、[PAO/GAO对照](../../", relative_out, "/PAO_GAO_descriptive_comparison.pdf)；同目录均有PNG。"), "",
      "**合理假设。** 各运行谱系与阶段的组成差别可用于提出不同运行经历伴随功能相关类群差异的假设；这不证明功能分工、碳竞争、磷/氮转化贡献或DO适应。GAO关联比例较高不等于除磷失败。", "",
      "**待验证问题与限制。** 本项目没有功能基因或活性测量；功能参考类群的强证据不等于项目ASV功能确证。Nitrospira亚群、属内异质性、--other语义和未核实直接文献均有缺口。保留G4基线DO分析NA/文档3差异，全部实测NA，后期设计稳定期不等于性能稳态已核验。主29行及共享来源不独立，G5仅单母样；不做显著性、网络或因果推断，不将16S比例当绝对丰度。", "",
      "### 同步整理模块1.1：观察、假设和待验证问题", "",
      "**直接观察（沿用有效v2，非本次重新分析）。** R1/R2启动前最高已命名属Defluviicoccus分别25.55%/26.60%，结束时Acinetobacter为23.31%/28.10%；R4全部节点最高已命名属为Candidatus_Competibacter，G3末91.06%。R3的G4后期Defluviicoccus为24.27%/24.41%/24.77%；R2的145d Candidatus_Competibacter为50.35%。R1末期E3未分类属44.72%，最高已命名Chryseosolibacter仅9.58%。G5 S1 Acinetobacter 30.13%、S2 Thauera 20.84%、S3/S4 OLB8 9.70%/9.66%。详见[模块1.1 v2报告](../../results/community_composition/2026-11-03_v2/analysis_report.md)及本文件前述模块1.1结果。", "",
      "**合理假设。** 接种谱系和运行经历可能伴随群落轨迹不同，粒径微环境可能与组成差异相关；仅作为假设。", "",
      "**待验证。** 单属比例相近不证明整体群落或性能稳态；最高已命名属不一定占总体优势。需要匹配运行性能、来源和时间结构后再提具体问题，不能把组成观察直接升级成功能、活性或因果结论。", "")
    append_file(file.path(root, "docs/batch_01/results_interpretation.md"), interp)
    append_file(file.path(root, "README.md"), c("## 2026-11-03 模块1.2进度更新", "",
      paste0("传统功能相关类群识别与描述性相对丰度已完成，有效结果为[", relative_out, "](", relative_out, "/analysis_report.md)。33样本、5,510 ASV原始count全部保留，G1–G5=8/2/4/15/4，沿用模块1.1顺序与混合/保存恢复分面。"),
      paste0("本次 ", sum(checks$status == "PASS"), " PASS / ", sum(checks$status == "WARNING"), " WARNING / ", sum(checks$status == "FAIL"), " FAIL。Nitrospira、PAO/GAO歧义、分类不足及待研究类群单列；映射表有来源、规则和核实层级，所有功能标记仍是16S间接关联。"),
      paste0("[详细解释与实际比例](docs/batch_01/results_interpretation.md#", anchor, ")；[G4逐属趋势](", relative_out, "/G4_functional_taxa_trends.pdf)、[G5组成](", relative_out, "/G5_functional_composition.pdf)、[PAO/GAO对照](", relative_out, "/PAO_GAO_descriptive_comparison.pdf)。PDF/PNG均提供。无显著性检验、网络、因果、功能基因或活性结论。"), ""))
    progress(c(paste0("- 完成：", sum(checks$status == "PASS"), " PASS / ", sum(checks$status == "WARNING"), " WARNING / ", sum(checks$status == "FAIL"), " FAIL；全部ASV/全部reads互斥守恒，TSV回读、样本顺序/数量及旧数据保护通过。"),
      paste0("- 输出：", relative_out, "，4个TSV、8组PDF/PNG、中文综合报告和run.log。输入指纹、规则、文献、版本和运行时间见报告。"),
      paste0("- 工具：", R.version.string, "；", versions, "。"),
      "- 主要比例与轨迹已按实际计算追加到results_interpretation.md，README同步导航；模块1.1主要观察另按直接观察/合理假设/待验证问题整理。",
      "- 限制：16S属相关代理、Nitrospira和PAO/GAO歧义、分类不足与未核实文献；主29行不独立、来源/DO/时间混杂、G5单母样及批次信息不足。原始输入/原metadata/旧结果/AGENTS与实验设计未改写。"))
    cat("Module 1.2 END PASS", stamp(), "; elapsed_s=", as.numeric(difftime(Sys.time(), started, units = "secs")), "\n")
    0L
  }, error = function(e) {
    message("FAIL: ", conditionMessage(e))
    if (!file.exists(report_path)) writeLines(c("# 模块1.2运行失败", "", paste0("FAIL：", conditionMessage(e)), "受影响步骤已停止；现有文件保留，不视为完整交付。详见run.log。"), report_path)
    progress(c(paste0("- FAIL：", conditionMessage(e)), paste0("- 部分输出保留于", out, "；受影响步骤停止，不覆盖历史结果。")))
    1L
  })
}
if (sys.nframe() == 0L) quit(status = main(), save = "no")
