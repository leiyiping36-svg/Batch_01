#!/usr/bin/env Rscript
# Module 1.1: original-count composition; descriptive analysis only.
# Rscript --vanilla scripts/community_composition.R [--output-dir NEW_DIRECTORY]
main <- function() {
  started <- Sys.time()
  script <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)))
  root <- dirname(dirname(script))
  args <- commandArgs(trailingOnly = TRUE)
  out <- file.path(root, "results/community_composition/2026-11-03_v2")
  if (length(args)) {
    stopifnot(length(args) == 2L, args[1] == "--output-dir")
    out <- args[2]
  }
  if (dir.exists(out) || file.exists(out)) stop("输出目录已存在；请指定新的版本目录，禁止覆盖。", call. = FALSE)
  stopifnot(dir.create(out, recursive = TRUE))
  out <- normalizePath(out)
  log_con <- file(file.path(out, "run.log"), "wt", encoding = "UTF-8")
  sink(log_con, split = TRUE)
  sink(log_con, type = "message")
  previous_warn <- getOption("warn")
  options(warn = 1)
  on.exit({options(warn = previous_warn); sink(type = "message"); sink(); close(log_con)}, add = TRUE)
  stamp <- function() format(Sys.time(), "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai")
  cat("START", stamp(), "Asia/Shanghai\nCommand:", paste(commandArgs(), collapse = " "), "\nOutput:", out, "\n")
  checks <- data.frame(status = character(), item = character(), evidence = character())
  add <- function(status, item, evidence) {
    checks[nrow(checks) + 1L, ] <<- c(status, item, evidence)
    cat(status, item, ":", evidence, "\n")
  }
  need <- function(ok, item, evidence) {
    add(if (isTRUE(ok)) "PASS" else "FAIL", item, evidence)
    if (!isTRUE(ok)) stop(paste(item, evidence, sep = ": "), call. = FALSE)
  }
  append_progress <- function(lines) {
    con <- file(file.path(root, "docs/batch_01/analysis_log.md"), "at", encoding = "UTF-8")
    tryCatch(writeLines(c("", lines), con, useBytes = TRUE), finally = close(con))
  }
  report_path <- file.path(out, "analysis_report.md")
  tryCatch({
    deps <- c("phyloseq", "Biostrings", "digest", "ggplot2", "scales")
    need(all(vapply(deps, requireNamespace, TRUE, quietly = TRUE)), "环境依赖", paste(deps, collapse = ", "))
    sha <- function(p) digest::digest(file = p, algo = "sha256")
    protected <- c("AGENTS.md", "docs/research_context.md", "docs/batch_01/experiment_design.md", "docs/batch_01/analysis_plan.md")
    protected_before <- vapply(file.path(root, protected), sha, "")
    source(file.path(root, "scripts/stage1_pipeline.R"), local = TRUE)
    append_progress(c(paste0("### 2026-11-03 / 模块1.1开始执行（", stamp(), "）"),
      "- 执行前已阅读AGENTS.md、研究背景、实验设计、分析计划和历史日志，并核对真实目录、metadata全33行和ASV表头。初次执行前无RDS或组成图；历史外部结果路径不存在。v2修正v1图例/浮点边界和Incertae_Sedis占位分类，保留v1历史产物，复用已建立对象。",
      "- 用户本次明确授权补充缺失phyloseq，取代历史暂缓对象的交付范围；不改写AGENTS.md或实验设计。通过stage1_pipeline.R复用已确认映射与基础QC，新增派生metadata，未知值NA。",
      paste0("- 命令：", file.path(R.home("bin"), "Rscript"), " --vanilla scripts/community_composition.R；输出：", out, "；状态RUNNING。"),
      "- 本次请求称G4初始四样本DO设定不确定，与设计文档恢复设置3存在差异。分析DO字段按最新请求设NA，文档历史设置另列保留；后期11样本按设计稳定期处理。"))
    built <- stage1_build_confirmed(root, out)
    append_progress(c(paste0("### 2026-11-03 / 模块1.1对象构建完成（", stamp(), "）"),
      paste0("- ", built$outcome, "；原始metadata不变，派生文件：", out, "/analysis_metadata.tsv。"),
      "- 8个既有科研输入的大小与SHA-256匹配历史QC，未重复运行测序/深度QC。原始计数、全部Feature/Sample ID、完整taxonomy/metadata/代表序列及RDS序列化往返核验通过，未删除ASV或稀释。阶段1实际核验追加到results/qc/stage1_report.md。",
      "- 本对象仅支持已授权描述性分析，不表示重复、独立性、混杂或推断方法前提通过。后续组成分析RUNNING。"))
    ps <- built$ps
    counts <- as(phyloseq::otu_table(ps), "matrix")
    taxa <- as(phyloseq::tax_table(ps), "matrix")
    meta <- built$metadata
    need(identical(as.integer(table(factor(meta$group, levels = paste0("G", 1:5)))), c(8L, 2L, 4L, 15L, 4L)),
      "模块数量", "G1/G2/G3/G4/G5=8/2/4/15/4；完整SampleID由原始metadata与明确名单核对。")
    main_ids <- meta[["sample-id"]][meta$group != "G5"]
    fraction_ids <- meta[["sample-id"]][meta$group == "G5"]
    need(length(main_ids) == 29L && length(fraction_ids) == 4L, "主分析边界", "G1–G4=29样本；G5=4个同一母样级分，独立展示。")
    need(all(is.na(meta$DO_measured_mg_L)) && sum(meta$stage_subphase == "design_stable_low_DO_period") == 11L,
      "G4分层与DO边界", "4个初始设置不确定、11个后期设计稳定期，全部33样本采样实测DO未知。")
    meta$reactor_label <- unname(c(Reactor_01 = "R1", Reactor_02 = "R2", Reactor_03 = "R3", Reactor_04 = "R4")[meta$reactor_id])
    meta$plot_round <- unname(c(G1_original = "1  Startup", G2G3_postmix = "2  After mixing / splitting", G4G5_low_DO = "3  After storage / recovery")[meta$reactor_round])
    phase_day <- as.numeric(meta$phase_days)
    expected_order <- list(R1 = c("A0", "A1", "A2", "E1", "E2", "E3"),
      R2 = c("B0", "B1", "B2", "B3", "F1", "F2", "F3", "F4"),
      R3 = c("C0", "C1", "C2", "G1", "G2", "G3", "G4"),
      R4 = c("D0", "D1", "D2", "D3", "H1", "H2", "H3", "H4"))
    order_ids <- character()
    for (r in names(expected_order)) {
      idx <- which(meta$reactor_label == r & meta$group != "G5")
      idx <- idx[order(match(meta$reactor_round[idx], c("G1_original", "G2G3_postmix", "G4G5_low_DO")), phase_day[idx])]
      need(identical(meta$supplier_sample_id[idx], expected_order[[r]]) &&
        all(vapply(split(phase_day[idx], meta$reactor_round[idx]), function(x) all(diff(x) > 0), TRUE)),
        paste0(r, "实际采样顺序"), paste(meta$supplier_sample_id[idx], phase_day[idx], sep = "@", collapse = " → "))
      order_ids <- c(order_ids, meta[["sample-id"]][idx])
    }
    need(!anyDuplicated(order_ids) && setequal(order_ids, main_ids), "排序覆盖", "全部29主分析样本各出现一次；轮次分面，日数不跨保存/混合拼接。")
    fraction_ids <- meta[["sample-id"]][match(c("S1", "S2", "S3", "S4"), meta$supplier_sample_id)]
    order_ids <- c(order_ids, fraction_ids)
    meta$plot_label <- paste0(meta$supplier_sample_id, "\n", meta$group, " | d", ifelse(meta$sampling_day_status == "approximate_recorded", "~", ""), meta$phase_days)
    b <- meta$group == "G4" & meta$phase_days == "1"
    meta$plot_label[b] <- paste0(meta$supplier_sample_id[b], "\nG4 | baseline\nDO setting: NA")
    stable <- meta$group == "G4" & !b
    meta$plot_label[stable] <- paste0(meta$supplier_sample_id[stable], "\nG4 | d", meta$phase_days[stable], "\nDO set: 0.5+/-0.2")
    g5 <- meta$group == "G5"
    # Use ASCII only in figures so no unavailable CJK fonts silently remove labels.
    meta$plot_label[g5] <- paste0(meta$supplier_sample_id[g5], "\n", gsub("–", "-", meta$particle_size_fraction_um[g5]), " um")
    rel_asv <- sweep(counts, 2, colSums(counts), "/")
    need(max(abs(colSums(rel_asv) - 1)) < 1e-12, "ASV相对丰度闭合", sprintf("33个样本最大偏差=%.3g；分母为全部原始reads。", max(abs(colSums(rel_asv) - 1))))
    unknown <- function(x) is.na(x) | trimws(x) == "" | grepl("^(uncultured|unclassified|unidentified|unknown|unassigned|metagenome|incertae[ _]sedis)([ _-].*)?$", x, ignore.case = TRUE)
    ranks <- c("Phylum", "Class", "Genus")
    codes <- c(Domain = "d", Kingdom = "k", Phylum = "p", Class = "c", Order = "o", Family = "f", Genus = "g")
    matrices <- list()
    labels <- list()
    unclassified <- list()
    for (rank in ranks) {
      upto <- names(codes)[seq_len(match(rank, names(codes)))]
      lineage <- apply(taxa[, upto, drop = FALSE], 1, function(x) paste(paste0(codes[upto], "__", ifelse(is.na(x) | x == "", "Unclassified", x)), collapse = ";"))
      raw_name <- taxa[, rank]
      is_unknown <- unknown(raw_name)
      agg <- rowsum(rel_asv, lineage, reorder = TRUE)
      first <- match(rownames(agg), lineage)
      lab <- raw_name[first]
      u <- is_unknown[first]
      lab[u] <- "Unclassified"
      # Keep homonyms distinct by full ancestry, never merge different lineages silently.
      ambiguous <- !u & (duplicated(lab) | duplicated(lab, fromLast = TRUE))
      lab[ambiguous] <- paste0(lab[ambiguous], " [", rownames(agg)[ambiguous], "]")
      names(lab) <- rownames(agg)
      names(u) <- rownames(agg)
      matrices[[rank]] <- agg
      labels[[rank]] <- lab
      unclassified[[rank]] <- u
      need(ncol(agg) == 33L && max(abs(colSums(agg) - 1)) < 1e-12 && all(agg >= 0),
        paste0(rank, "丰度矩阵闭合"), sprintf("%d条完整谱系；每样本和最大偏差%.3g；未分类谱系保留。", nrow(agg), max(abs(colSums(agg) - 1))))
      exported <- data.frame(taxon_id = rownames(agg), taxon_label = unname(lab), is_unclassified = unname(u), agg[, order_ids, drop = FALSE], check.names = FALSE)
      write.table(exported, file.path(out, paste0(tolower(rank), "_relative_abundance.tsv")), sep = "\t", quote = FALSE, row.names = FALSE, na = "NA")
    }
    # Plot Top N selected only on the 29 main samples; identical palette in every figure.
    top_n <- c(Phylum = 10L, Class = 10L, Genus = 15L)
    top_keys <- list()
    plot_data <- list()
    palettes <- list()
    legend_labels <- list()
    coverage <- character()
    for (rank in ranks) {
      a <- matrices[[rank]]
      named <- which(!unclassified[[rank]])
      score <- rowMeans(a[named, main_ids, drop = FALSE])
      selected <- named[head(order(-score, rownames(a)[named]), top_n[rank])]
      top_keys[[rank]] <- rownames(a)[selected]
      category <- ifelse(unclassified[[rank]], "Unclassified", ifelse(rownames(a) %in% top_keys[[rank]], labels[[rank]], "Others"))
      plotted <- rowsum(a, category, reorder = FALSE)
      levels <- c(unname(labels[[rank]][top_keys[[rank]]]), "Others", "Unclassified")
      for (missing in setdiff(levels, rownames(plotted))) {
        plotted <- rbind(plotted, matrix(0, 1, ncol(a), dimnames = list(missing, colnames(a))))
      }
      if (nrow(plotted) != length(levels)) stop("绘图类别错误")
      plotted <- plotted[levels, , drop = FALSE]
      need(max(abs(colSums(plotted) - 1)) < 1e-12, paste0(rank, "图中比例守恒"), "Top N + Others（其余已命名类群）+ Unclassified（全部未分类）=1。")
      d <- data.frame(sample_id = rep(colnames(plotted), each = nrow(plotted)),
        taxon = factor(rep(rownames(plotted), times = ncol(plotted)), levels = levels),
        abundance = as.vector(plotted), stringsAsFactors = FALSE)
      midx <- match(d$sample_id, meta[["sample-id"]])
      d <- cbind(d, meta[midx, c("reactor_label", "plot_round", "plot_label"), drop = FALSE])
      d$sample_id <- factor(d$sample_id, levels = order_ids)
      d$plot_round <- factor(d$plot_round, levels = unique(meta$plot_round[match(order_ids, meta[["sample-id"]])]))
      plot_data[[rank]] <- d
      named_colors <- if (length(selected) <= 12) grDevices::hcl.colors(length(selected), "Set 3") else grDevices::hcl.colors(length(selected), "Dynamic")
      palettes[[rank]] <- setNames(c(named_colors, "#BBBBBB", "#505050"), levels)
      display <- levels
      for (i in seq_along(top_keys[[rank]])) {
        if (nchar(display[i]) > 45) {
          lineage_parts <- strsplit(top_keys[[rank]][i], ";", fixed = TRUE)[[1]]
          display[i] <- paste0(sub(" \\[.*$", "", display[i]), " [", lineage_parts[length(lineage_parts) - 1L], "]")
        }
      }
      if (anyDuplicated(display)) display <- make.unique(display, sep = " #")
      legend_labels[[rank]] <- setNames(vapply(display, function(x) paste(strwrap(x, width = 40), collapse = "\n"), ""), levels)
      cover <- colSums(a[selected, , drop = FALSE])
      coverage <- c(coverage, sprintf("| %s | %d | %.2f–%.2f%% | %.2f–%.2f%% |", rank, length(selected),
        min(cover[main_ids]) * 100, max(cover[main_ids]) * 100, min(cover[fraction_ids]) * 100, max(cover[fraction_ids]) * 100))
    }
    library(ggplot2)
    make_plot <- function(rank, ids, title, subtitle, facet = FALSE, overview = FALSE) {
      d <- plot_data[[rank]][as.character(plot_data[[rank]]$sample_id) %in% ids, , drop = FALSE]
      labs <- setNames(meta$plot_label, meta[["sample-id"]])
      p <- ggplot(d, aes(sample_id, abundance, fill = taxon)) + geom_col(width = 0.8) +
        scale_y_continuous(labels = scales::label_percent(), expand = expansion(mult = c(0, 0))) +
        coord_cartesian(ylim = c(0, 1)) +
        scale_fill_manual(values = palettes[[rank]], labels = legend_labels[[rank]], drop = FALSE) +
        scale_x_discrete(labels = labs, drop = TRUE) +
        labs(title = title, subtitle = subtitle, x = "Recorded sampling order within each run (equal bar spacing)", y = "Relative abundance", fill = rank,
          caption = "Original counts; no rarefaction/filtering. Stage DO settings are not measured DO. G4 baseline setting is uncertain.") +
        theme_bw(base_size = 11, base_family = "DejaVu Sans") +
        theme(panel.grid.major.x = element_blank(), panel.grid.minor = element_blank(),
          axis.text.x = element_text(size = if (overview) 7 else 9), legend.position = "bottom", legend.text = element_text(size = 9),
          strip.text = element_text(face = "bold"), plot.caption = element_text(size = 8, hjust = 0)) +
        guides(fill = guide_legend(ncol = 3, byrow = TRUE))
      if (overview) p <- p + facet_grid(rows = vars(reactor_label), cols = vars(plot_round), scales = "free_x", space = "free_x")
      else if (facet) p <- p + facet_grid(cols = vars(plot_round), scales = "free_x", space = "free_x")
      layer <- ggplot_build(p)$data[[1]]
      totals <- aggregate(layer$ymax - layer$ymin, list(panel = layer$PANEL, position = layer$x), sum)$x
      need(nrow(layer) == nrow(d) && all(is.finite(layer$ymin)) && all(is.finite(layer$ymax)) &&
        max(abs(totals - 1)) < 1e-12, paste0(title, "绘图层守恒"), "ggplot实际图层保留全部类别，各实际样本堆叠高度≈1，无越界删除。")
      p
    }
    save_pair <- function(plots, stem, width, height) {
      need(!any(file.exists(file.path(out, paste0(stem, c(".pdf", ".png"))))), paste0(stem, "不覆盖"), "新版本目录，图文件尚不存在。")
      grDevices::cairo_pdf(file.path(out, paste0(stem, ".pdf")), width = width, height = height, onefile = TRUE, family = "DejaVu Sans")
      tryCatch(for (p in plots) print(p), finally = grDevices::dev.off())
      grDevices::png(file.path(out, paste0(stem, ".png")), width = width, height = height * length(plots), units = "in", res = 160, type = "cairo")
      tryCatch({
        grid::grid.newpage()
        grid::pushViewport(grid::viewport(layout = grid::grid.layout(length(plots), 1)))
        for (i in seq_along(plots)) print(plots[[i]], newpage = FALSE, vp = grid::viewport(layout.pos.row = i))
      }, finally = grDevices::dev.off())
      need(all(file.info(file.path(out, paste0(stem, c(".pdf", ".png"))))$size > 1000), paste0(stem, "图输出"), "PDF/PNG均已生成；多层级PDF每层一页，PNG纵向拼版。")
    }
    overview <- lapply(ranks, function(rank) make_plot(rank, main_ids, paste("Batch_01 main composition |", rank),
      "29 samples (G1-G4); run-specific day axes; empty positions are unsampled observations", overview = TRUE))
    save_pair(overview, "main_composition", 17, 9)
    for (r in names(expected_order)) {
      ids <- meta[["sample-id"]][meta$reactor_label == r & meta$group != "G5"]
      p <- make_plot("Genus", ids, paste(r, "| community succession"),
        "Separate runs: startup -> mixing / splitting -> 4 C storage (59 d) and recovery; no continuous global day axis", facet = TRUE)
      save_pair(list(p), paste0(r, "_community_succession"), 15, 7.5)
    }
    fplots <- lapply(ranks, function(rank) make_plot(rank, fraction_ids, paste("G5 | R1 size fractions |", rank),
      "One mother sample; 145 + 18 d (derived); DO stage setting 0.5+/-0.2 mg/L; no biological replication"))
    save_pair(fplots, "G5_size_fraction_composition", 13, 7.5)
    # Dominance: positive, assigned top 3 per sample; summary means give every sample equal weight.
    genus <- matrices$Genus
    glabel <- labels$Genus
    assigned <- !unclassified$Genus
    top3 <- function(v) head(which(assigned & v > 0)[order(-v[assigned & v > 0], names(v)[assigned & v > 0])], 3)
    summary_rows <- list()
    emit <- function(scope, ids, reactor, group, phase) {
      a <- genus[, ids, drop = FALSE]
      m <- rowMeans(a)
      candidates <- top3(m)
      selected_per_sample <- lapply(seq_len(ncol(a)), function(j) rownames(a)[top3(a[, j])])
      for (k in seq_along(candidates)) {
        i <- candidates[k]
        summary_rows[[length(summary_rows) + 1L]] <<- data.frame(scope = scope, reactor = reactor, group = group, phase = phase,
          n_sample_records = length(ids), sample_ids = paste(ids, collapse = ";"), rank = k,
          taxon_id = rownames(a)[i], genus = glabel[i], mean_relative_abundance = m[i],
          min_relative_abundance = min(a[i, ]), max_relative_abundance = max(a[i, ]),
          n_sample_top3 = sum(vapply(selected_per_sample, function(x) rownames(a)[i] %in% x, TRUE)),
          unclassified_mean_relative_abundance = mean(colSums(a[!assigned, , drop = FALSE])),
          biological_unit_note = if (group == "G5") "one_mother_sample_size_components" else "longitudinal_records_shared_lineage_not_independent_replicates", stringsAsFactors = FALSE)
      }
    }
    phase <- ifelse(meta$group == "G1", meta$operation_phase, ifelse(meta$group == "G4", meta$stage_subphase, ifelse(meta$group == "G5", "same_mother_size_fractionation", "stage_end")))
    for (id in order_ids) {
      i <- match(id, meta[["sample-id"]])
      emit("sample", id, meta$reactor_label[i], meta$group[i], phase[i])
    }
    # Do not average across rounds as if reactors were one continuous experimental entity.
    keys <- unique(paste(meta$reactor_label, meta$group, phase, sep = "|"))
    for (key in keys) {
      idx <- which(paste(meta$reactor_label, meta$group, phase, sep = "|") == key)
      emit("reactor_phase", meta[["sample-id"]][idx], meta$reactor_label[idx[1]], meta$group[idx[1]], phase[idx[1]])
    }
    summ <- do.call(rbind, summary_rows)
    write.table(summ, file.path(out, "dominant_genera_summary.tsv"), sep = "\t", row.names = FALSE, quote = FALSE, na = "NA")
    need(setequal(summ$sample_ids[summ$scope == "sample"], meta[["sample-id"]]) && all(summ$mean_relative_abundance > 0),
      "优势属汇总覆盖", "33个样本分别列出已命名属Top3；按反应器×模块×子阶段汇总，未知属比例单列；G5均值仅描述四级分。")
    md_table <- function(df) {
      values <- lapply(df, function(x) { x <- as.character(x); x[is.na(x)] <- "NA"; gsub("|", "/", x, fixed = TRUE) })
      df <- as.data.frame(values, check.names = FALSE)
      c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
        apply(df, 1, function(x) paste0("| ", paste(x, collapse = " | "), " |")))
    }
    # Shared dominant genera: top3 of the equal-timepoint mean in each reactor, separately per stage.
    common_lines <- character()
    phase_sets <- list(G1_start = which(meta$operation_phase == "low_cn_startup"), G1_end = which(meta$operation_phase == "low_cn_end"),
      G2 = which(meta$group == "G2"), G3 = which(meta$group == "G3"), G4_baseline = which(b), G4_post = which(stable))
    for (nm in names(phase_sets)) {
      idx <- phase_sets[[nm]]
      blocks <- split(meta[["sample-id"]][idx], meta$reactor_label[idx])
      top <- lapply(blocks, function(ids) rownames(genus)[top3(rowMeans(genus[, ids, drop = FALSE]))])
      common <- Reduce(intersect, top)
      common_lines <- c(common_lines, paste0("- ", nm, "（实际", length(blocks), "个反应器标签）：各反应器该阶段等权均值Top3的共同属为",
        if (length(common)) paste(glabel[common], collapse = "、") else "无", "。"))
    }
    stage_lines <- character()
    rs <- summ[summ$scope == "reactor_phase" & summ$group != "G5", ]
    for (key in unique(paste(rs$reactor, rs$group, rs$phase))) {
      d <- rs[paste(rs$reactor, rs$group, rs$phase) == key, ]
      stage_lines <- c(stage_lines, paste0("| ", d$reactor[1], " | ", d$group[1], "/", d$phase[1], " | ", d$n_sample_records[1], " | ",
        paste(sprintf("%s %.2f%%", d$genus, d$mean_relative_abundance * 100), collapse = "；"), " |"))
    }
    sequence_lines <- character()
    for (r in names(expected_order)) {
      sequence_lines <- c(sequence_lines, paste0("- **", r, "**："))
      for (round in c("G1_original", "G2G3_postmix", "G4G5_low_DO")) {
        idx <- match(order_ids, meta[["sample-id"]])
        idx <- idx[meta$reactor_label[idx] == r & meta$group[idx] != "G5" & meta$reactor_round[idx] == round]
        desc <- vapply(idx, function(i) {
          id <- meta[["sample-id"]][i]
          v <- genus[, id]
          k <- top3(v)[1]
          sprintf("%s（d%s%s）：%s %.2f%%", meta$supplier_sample_id[i], ifelse(meta$sampling_day_status[i] == "approximate_recorded", "约", ""), meta$phase_days[i], glabel[k], v[k] * 100)
        }, "")
        sequence_lines <- c(sequence_lines, paste0("  - ", round, "：", paste(desc, collapse = " → "), "。"))
      }
    }
    fraction_lines <- vapply(fraction_ids, function(id) {
      i <- match(id, meta[["sample-id"]]); v <- genus[, id]; top <- top3(v)
      paste0("- ", meta$supplier_sample_id[i], "（", meta$particle_size_fraction_um[i], " μm）：",
        paste(sprintf("%s %.2f%%", glabel[top], v[top] * 100), collapse = "；"), "。")
    }, "")
    for (rank in ranks) {
      x <- read.delim(file.path(out, paste0(tolower(rank), "_relative_abundance.tsv")), check.names = FALSE)
      values <- as.matrix(x[, order_ids, drop = FALSE])
      need(identical(x$taxon_id, rownames(matrices[[rank]])) && max(abs(values - matrices[[rank]][, order_ids])) < 1e-12 &&
        max(abs(colSums(values) - 1)) < 1e-12, paste0(rank, "TSV回读核验"), "写出后的全部数值、样本顺序及闭合性通过。")
    }
    need(identical(vapply(built$inputs, sha, ""), built$fingerprints) &&
      identical(vapply(file.path(root, protected), sha, ""), protected_before), "原始输入与设计保护", "所有输入指纹不变；AGENTS.md、研究背景、实验设计、分析计划未改写。")
    add("WARNING", "重复及混杂", "G1前后、G2/G3连续运行、G4纵向及共享混合谱系均相关；DO与阶段/时间混杂，不做独立样本检验、网络或因果推断。")
    add("WARNING", "不平衡与未知", "G2仅R2/R4；G4第30天缺R1；约120d及推算163d非精确日历日期；恢复时长、混合量及稳态性能证据未核验。")
    add("WARNING", "DO来源差异", "初始E1/F1/原G1/H1分析DO设置NA，文档恢复阶段设置3另列；四个初始不标为稳定0.5。后期11样本按设计稳定期，实测均NA。")
    add("WARNING", "16S解释边界", "读数比例不等于细胞绝对丰度、功能基因、活性或DO因果效应；分类数据库名称按原注释保留。")
    versions <- paste(deps, vapply(deps, function(x) as.character(utils::packageVersion(x)), ""), collapse = "；")
    fingerprints <- c(built$fingerprints, community_script = sha(script), stage1_script = sha(file.path(root, "scripts/stage1_pipeline.R")), phyloseq = sha(file.path(root, "results/phyloseq/batch_01_phyloseq.rds")))
    urows <- lapply(ranks, function(rank) {
      u <- colSums(matrices[[rank]][unclassified[[rank]], , drop = FALSE])
      data.frame(层级 = rank, 未分类ASV数 = sum(unknown(taxa[, rank])), 最低样本比例 = sprintf("%.2f%%", min(u) * 100), 最高样本比例 = sprintf("%.2f%%", max(u) * 100))
    })
    mapping_view <- meta[match(order_ids, meta[["sample-id"]]), c("sample-id", "supplier_sample_id", "group", "reactor_label", "reactor_round", "phase_days", "sampling_day_status", "stage_subphase", "DO_setting_text", "particle_size_fraction_um")]
    files <- list.files(out)
    lines <- c("# Batch_01 模块1.1：主要微生物群落组成与演替", "",
      paste0("运行：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai"), " 至 ", stamp(), "（Asia/Shanghai）。"),
      paste0("状态：PASS；本模块检查 ", sum(checks$status == "PASS"), " PASS / ", sum(checks$status == "WARNING"), " WARNING / ", sum(checks$status == "FAIL"), " FAIL。对象构建明细另见results/qc/stage1_report.md新增节。"), "",
      "## 输入、授权范围及已有结果复用", "",
      paste0("沿用5,510 ASV × 33样本原始count、taxonomy和代表序列；", built$outcome, "。没有稀释、过滤、删除ASV或重跑Cutadapt/DADA2/分类器。8项原科研输入指纹匹配历史完整QC，深度/异常筛查沿用，不重复运行。"),
      "执行前项目results内没有组成结果或RDS；技术日志指向的历史外部目录不可访问，因此本次图均为首次可获得产物，没有声称复用不存在的图。原metadata为14列、没有group（不是直接复用六类operation_phase）；派生metadata保留原14列并附加明确的五模块映射及来源。", "",
      "本次请求明确授权构建缺失对象，取代此前文档的暂缓交付范围。G4初始DO设置按本次请求为不确定；设计文档此前确认的恢复设置3保留在design_document_DO_setpoint_mg_L/design_document_DO_setting_text，分析DO字段为NA。原始metadata中的旧备注完整保留，以新增字段表达版本差异；不修改AGENTS.md或实验设计。", "",
      "## 实际检查", "", md_table(checks), "",
      "## 方法与图表读法", "",
      "每个ASV相对丰度=该样本原始count/该样本全部ASV count之和。按Phylum、Class、Genus完整祖先谱系求和，每个矩阵33列样本，前三列为taxon_id、taxon_label、is_unclassified；列顺序为R1至R4各自轮次/采样顺序，最后G5。重复属名若上级谱系不同保留并加谱系，不跨谱系静默合并。", "",
      "目标阶元空值、unknown/unassigned/unidentified/unclassified/uncultured/metagenome、Incertae_Sedis及其常见后缀归未分类，保留原taxon_id谱系；Incertae_Sedis表示分类位置未定，不作为已鉴定属。数据库给出的其他命名（包括候选类群代码）原样保留。不使用上一级名称假充已鉴定属。矩阵保留每条未分类谱系；图中合并为Unclassified。", "",
      "Top N只由29主分析样本的等样本权重平均相对丰度选取：Phylum=10、Class=10、Genus=15，分别使用固定类别和配色覆盖全部图，G5不参与Top N筛选。Others仅合并未展示的已命名类群，Unclassified独立保留；全部比例不因隐藏类群而重新归一化。优势属定义为每样本或反应器×模块×子阶段均值的已命名正丰度Top3（平局按完整谱系排序），不代表预先设定的生态功能。", "",
      "dominant_genera_summary.tsv中scope=sample给出逐样本Top3，scope=reactor_phase给出按原始相对丰度逐样本等权均值的Top3，含最小/最大、记录数及进入样本Top3的次数；范围不是置信区间。G4后期均值包含不等间隔的纵向采样，既不是时间积分也不是独立重复均值。G5四组分均值仅为无权描述，不是母样重建（缺少各级分生物量/体积权重）。", "",
      "| 层级 | Top N | 主分析Top N覆盖范围 | G5 Top N覆盖范围 |", "|---|---|---|---|", coverage, "",
      "未分类比例（按样本、以全部reads作分母）：", "", md_table(do.call(rbind, urows)), "",
      "图中使用英文/ASCII标签以保证本地字体完整；PNG为160 dpi，PDF为矢量。main_composition和G5的PDF分别为门、纲、属三页，PNG为三层级纵向拼版；四张R1–R4图聚焦属水平演替。全图共享各阶元Top N配色；超长图例用直接上级谱系缩写，完整谱系见矩阵taxon_id。比例坐标用视窗裁切，保留浮点累加略超1的顶段，不由刻度限制删除数据。", "",
      "## 样本映射、排序与条件", "",
      "排序依据为已确认轮次先后及原metadata.phase_days，实际与逐反应器明确清单断言相符；绝不以metadata行号或字母排序当作采样时间。G1 day120保留约数。G2/G3共用同一时间轴（21→56），22d无本批样本。G4另起时间轴（1、30、76、145），day1只作初始编号，不是低DO暴露1天。混合均分及4℃59天保存/恢复在分面边界说明，柱间距相等不代表时间等距。", "",
      "主总览按反应器×轮次分面，各列坐标可共享实际样本位置；空位表示未采样，不插补。四张反应器图各自仅含该反应器实际采样节点。G5按粒径S1→S4单列，不接到纵向轴上。", "", md_table(mapping_view), "",
      "## 每个反应器的实际优势属演替", "",
      "以下每节点为已命名属中最高相对丰度者；不因某样本未分类占比更高而宣称其为总体最大类群。仅沿记录顺序描述，跨分面不连接成连续运行。", "", sequence_lines, "",
      "## 反应器与阶段优势属汇总", "",
      "| 反应器标签 | 模块/子阶段 | 采样记录数 | 已命名优势属Top3（等样本权重均值） |", "|---|---|---|---|", stage_lines, "",
      "## 跨反应器共同优势属", "",
      "共同优势属操作定义：分别求每个反应器在同一子阶段的等记录权重平均相对丰度Top3，取所有实际有样本反应器的交集。只描述本批已采样标签；G2只有R2、R4，G4后期取样不平衡且来源相关，不称跨独立重复验证。", "", common_lines, "",
      "## G5同一母样粒径组分", "", fraction_lines, "",
      "四级分共享同一R1母样（145d后18d，163为原表推算），每粒径仅1份记录，不能估计独立生物重复间变异。筛分边界闭开和处理细节未知；未作级分显著性检验或按四份样本加权重建母样。", "",
      "## 局限与待人工核查", "",
      "- 16S分类不等同功能基因、活性或绝对细胞量；报告仅针对原始扩增子读数相对组成，不乘VSS/MLVSS。",
      "- G1配对、G2/G3连续运行及G4纵向采样不能当独立观测；R1/R2与R3/R4在G1后各自混合均分，前源相关性跨保存恢复保留。反应器、污泥设计类型、来源块、时间及DO阶段混杂，无法从本描述分离DO因果效应。",
      "- G2缺R1/R3、G4第30天缺R1，记录数不等于独立样本量。不插补缺采样，不做显著性检验、共现网络或因果推断。",
      "- E1/F1/原G1/H1分析使用的设置不确定，本次请求与文档恢复设置3的差异已显式保留；若后续解释依赖该值，需要人工统一来源。全部瞬时DO为NA；后期11样本按设计稳定期，运行性能是否证明稳态尚未审阅。",
      "- 日历日期、恢复时长、约120d精确性、混合比例/接种量、母样原始编号、粒径处理细节和取样不平衡原因仍未核验。阶段DO与实测分列，未知条件未填补。",
      "- 只分析Batch_01。既有上游产物沿用，同批测序/处理不能消除DNA提取、存放、PCR或测序批次潜在效应；没有足够实验批次信息评估这些效应，不能据此声称无批次效应。", "",
      "## 复现与交付", "",
      "版本说明：v1保留为首轮历史结果，存在图例裁切、浮点边界删去柱顶段及Incertae_Sedis误作命名属的问题；本v2修正上述问题，是本次有效交付。矩阵原始谱系丰度数值未变；未分类标记、Top N和优势属汇总已更新。没有覆盖v1、原始数据或既有RDS。", "",
      paste0("命令：`", file.path(R.home("bin"), "Rscript"), " --vanilla scripts/community_composition.R --output-dir NEW_DIRECTORY`；默认路径为results/community_composition/2026-11-03_v2，已存在则失败，重跑须新版本目录。"),
      "对象固定results/phyloseq/batch_01_phyloseq.rds；已有对象仅在全部内容/输入指纹一致时复用，否则FAIL且不覆盖。对象构建由stage1_pipeline.R入口执行，不重复上游QC。", "",
      paste0("工具：", R.version.string, "；", versions, "。无随机步骤。"), "",
      "| 输入/脚本/对象 | SHA-256 |", "|---|---|", paste0("| ", names(fingerprints), " | ", fingerprints, " |"), "",
      paste0("输入路径按stage1综合报告记录；metadata与设计版本见analysis_metadata.tsv。运行总耗时", round(as.numeric(difftime(Sys.time(), started, units = "secs")), 3), "秒。"), "",
      "文件：", "", paste0("- `", sort(c(files, "analysis_report.md")), "`"), "",
      "```text", capture.output(sessionInfo()), "```", "")
    writeLines(lines, report_path, useBytes = TRUE)
    append_progress(c(paste0("### 2026-11-03 / 模块1.1组成与演替完成（", stamp(), "）"),
      paste0("- 程序scripts/community_composition.R；原始count不稀释不筛选，按全部reads计算相对丰度，Phylum/Class/Genus按完整祖先谱系聚合。输出：", out, "。"),
      paste0("- 实际核验：", sum(checks$status == "PASS"), " PASS / ", sum(checks$status == "WARNING"), " WARNING / ", sum(checks$status == "FAIL"), " FAIL；G1–G5=8/2/4/15/4，主29、G5独立4；ASV及三阶元各样本和≈1，TSV全部数值回读一致；R1–R4采样顺序断言通过。"),
      "- 产物：三阶元相对丰度矩阵、逐样本/反应器阶段Top3属汇总、派生metadata、主分析三阶元总览、四反应器属水平演替和G5三阶元组成（每图PDF/PNG），中文analysis_report.md及run.log。报告记录Top N、Others/Unclassified规则、实际优势属及跨反应器交集、输入和脚本指纹、版本/时间。",
      paste0("- 已计算的跨反应器共同优势属：", paste(common_lines, collapse = " ")),
      "- G4初始四样本DO分析设置NA，历史文档恢复设置3另列；后期11样本按设计划定稳定期，稳态性能未核验。保存/恢复前后和混合轮次分面，不拼接统一连续天数；G5同母样不作独立重复。",
      "- 限制：共享混合谱系、纵向重复、不平衡节点、阶段/时间/DO混杂及批次信息不足；16S相对组成不代表绝对丰度/功能/活性。本次不做显著性检验、网络或因果推断。全部原始输入及AGENTS/设计/计划指纹不变，历史报告仅追加。状态PASS（描述性分析范围）。"))
    cat("END", stamp(), "PASS; elapsed_seconds=", as.numeric(difftime(Sys.time(), started, units = "secs")), "\n")
    0L
  }, error = function(e) {
    message("FAIL: ", conditionMessage(e))
    if (!file.exists(report_path)) writeLines(c("# 模块1.1运行失败", "", paste0("FAIL：", conditionMessage(e)), "", "受影响步骤已停止；已有产物不覆盖，不得视为完整结果。详见run.log。"), report_path)
    append_progress(c(paste0("### 2026-11-03 / 模块1.1异常（", stamp(), "）"), paste0("- FAIL：", conditionMessage(e)), paste0("- 输出保留：", out, "；受影响步骤已停止，详见run.log。")))
    1L
  })
}
# Add an independently selected G5 view without replacing the main-selected comparison.
# Rscript --vanilla scripts/community_composition.R --g5-detail --output-dir EXISTING_RUN
g5_detail <- function(out) {
  stopifnot(dir.exists(out), requireNamespace("ggplot2", quietly = TRUE), requireNamespace("digest", quietly = TRUE))
  script <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)))
  root <- dirname(dirname(script))
  logcon <- file(file.path(out, "run.log"), "at", encoding = "UTF-8")
  sink(logcon, split = TRUE)
  sink(logcon, type = "message")
  on.exit({sink(type = "message"); sink(); close(logcon)}, add = TRUE)
  cat("G5_DETAIL START", format(Sys.time(), tz = "Asia/Shanghai"), "\n")
  meta <- read.delim(file.path(out, "analysis_metadata.tsv"), check.names = FALSE, colClasses = "character", na.strings = "NA")
  mids <- meta[["sample-id"]][meta$group != "G5"]
  idx <- match(c("S1", "S2", "S3", "S4"), meta$supplier_sample_id)
  ids <- meta[["sample-id"]][idx]
  stopifnot(length(mids) == 29, !anyNA(idx), all(meta$group[idx] == "G5"), length(unique(meta$fractionation_event_id[idx])) == 1L)
  targets <- file.path(out, paste0("G5_independent_top_taxa", c(".pdf", ".png")))
  stopifnot(!any(file.exists(targets)))
  ranks <- c("Phylum", "Class", "Genus")
  limits <- c(10L, 10L, 15L)
  plots <- list()
  selected_lines <- character()
  library(ggplot2)
  for (j in seq_along(ranks)) {
    rank <- ranks[j]
    t <- read.delim(file.path(out, paste0(tolower(rank), "_relative_abundance.tsv")), check.names = FALSE)
    a <- as.matrix(t[, c(mids, ids), drop = FALSE])
    assigned <- which(!t$is_unclassified)
    top <- function(sample_ids) assigned[head(order(-rowMeans(a[assigned, sample_ids, drop = FALSE]), t$taxon_id[assigned]), limits[j])]
    main_top <- top(mids)
    local_top <- top(ids)
    cats <- ifelse(t$is_unclassified, "Unclassified", ifelse(seq_len(nrow(t)) %in% local_top, t$taxon_label, "Others"))
    z <- rowsum(a[, ids, drop = FALSE], cats, reorder = FALSE)
    levels <- c(t$taxon_label[local_top], "Others", "Unclassified")
    for (name in setdiff(levels, rownames(z))) z <- rbind(z, matrix(0, 1, 4, dimnames = list(name, ids)))
    z <- z[levels, , drop = FALSE]
    stopifnot(max(abs(colSums(z) - 1)) < 1e-12)
    base_colors <- if (length(main_top) <= 12) grDevices::hcl.colors(length(main_top), "Set 3") else grDevices::hcl.colors(length(main_top), "Dynamic")
    colors <- setNames(base_colors, t$taxon_label[main_top])
    extra <- setdiff(t$taxon_label[local_top], names(colors))
    if (length(extra)) colors <- c(colors, setNames(grDevices::hcl.colors(length(extra), "Dark 3"), extra))
    colors <- c(colors, Others = "#BBBBBB", Unclassified = "#505050")
    d <- data.frame(sample_id = factor(rep(ids, each = nrow(z)), levels = ids),
      taxon = factor(rep(rownames(z), 4), levels = levels), abundance = as.vector(z))
    xlabels <- setNames(paste0(meta$supplier_sample_id[idx], "\n", gsub("–", "-", meta$particle_size_fraction_um[idx]), " um"), ids)
    p <- ggplot(d, aes(sample_id, abundance, fill = taxon)) + geom_col(width = 0.75) +
      scale_x_discrete(labels = xlabels) + scale_y_continuous(labels = scales::label_percent(), expand = expansion(mult = c(0, 0))) +
      coord_cartesian(ylim = c(0, 1)) + scale_fill_manual(values = colors, drop = FALSE) +
      labs(title = paste("G5 | R1 size fractions |", rank), subtitle = paste0("Top ", limits[j], " selected within G5; one mother sample; stage DO setting: 0.5+/-0.2 mg/L"),
        x = "Particle size fraction (um); ordered by sieve class, not by sampling time", y = "Relative abundance", fill = rank,
        caption = "Same mother sample, four components. No independent biological replication. Unclassified includes Incertae_Sedis.") +
      theme_bw(base_size = 11, base_family = "DejaVu Sans") + theme(legend.position = "bottom", panel.grid.major.x = element_blank(),
        legend.text = element_text(size = 9), plot.caption = element_text(hjust = 0, size = 8)) + guides(fill = guide_legend(ncol = 3, byrow = TRUE))
    layer <- ggplot_build(p)$data[[1]]
    totals <- aggregate(layer$ymax - layer$ymin, list(position = layer$x), sum)$x
    stopifnot(nrow(layer) == nrow(d), max(abs(totals - 1)) < 1e-12)
    plots[[j]] <- p
    selected_lines <- c(selected_lines, paste0("- ", rank, " Top", length(local_top), "（G5四级分等权均值）：", paste(t$taxon_label[local_top], collapse = "、"), "。"))
    cat("PASS G5 independent", rank, ": 4 samples; Top", length(local_top), "+ Others + Unclassified = 1; actual plotting layer verified\n")
  }
  grDevices::cairo_pdf(targets[1], width = 13, height = 7.5, onefile = TRUE, family = "DejaVu Sans")
  tryCatch(for (p in plots) print(p), finally = grDevices::dev.off())
  grDevices::png(targets[2], width = 13, height = 22.5, units = "in", res = 160, type = "cairo")
  tryCatch({
    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout = grid::grid.layout(3, 1)))
    for (i in 1:3) print(plots[[i]], newpage = FALSE, vp = grid::viewport(layout.pos.row = i))
  }, finally = grDevices::dev.off())
  stopifnot(all(file.info(targets)$size > 1000))
  for (path in c(file.path(out, "analysis_report.md"), file.path(root, "docs/batch_01/analysis_log.md"))) {
    con <- file(path, "at", encoding = "UTF-8")
    tryCatch(writeLines(c("", "## 2026-11-03 / G5独立Top N补充（最终G5展示）", "",
      "S2的Thauera为20.84%，在主分析Top15视图中并入Others。新增G5_independent_top_taxa.pdf/png，按G5自身四个级分的等权均值选门/纲Top10、属Top15；Others和Unclassified独立保留。主要G5组成请使用此图；原G5_size_fraction_composition保留为主分析Top N的统一配色对照，其横轴泛用文案不表示G5为时间序列。新增图横轴明确为粒径级分。", "",
      "- PASS：33样本派生metadata中核对同一母样4个G5级分，独立选择类群后4样本比例闭合，实际绘图层无删除且柱高≈1，PDF三页/PNG拼版均生成。共有类群沿用主图颜色，新出现类群单独配色；不会将各级分等权均值解释为母样重建或独立重复均值。",
      selected_lines, "",
      paste0("- 复现：Rscript --vanilla scripts/community_composition.R --g5-detail --output-dir ", out),
      paste0("- 当前脚本SHA-256：", digest::digest(file = script, algo = "sha256"), "；此前报告指纹对应主分析执行版本。补充仅读派生metadata/丰度矩阵，未重算ASV、未修改原产物。")), con, useBytes = TRUE), finally = close(con))
  }
  cat("G5_DETAIL END PASS\n")
  0L
}
if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  status <- if (length(args) && args[1] == "--g5-detail") {
    stopifnot(length(args) == 3L, args[2] == "--output-dir")
    g5_detail(normalizePath(args[3], mustWork = TRUE))
  } else main()
  quit(status = status, save = "no")
}
