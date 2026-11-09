#!/usr/bin/env Rscript
# Batch_01 stage 1: read existing exports; never denoise, classify, filter or infer groups.
# Run: Rscript --vanilla scripts/stage1_pipeline.R [--project-root PATH]
# Metadata-only review: add --review-metadata; never reads ASV/FASTA/QZA or builds RDS.
# Confirmed design plan: --review-design reads only ASV header, never count values.
# Add --compact-report to append check evidence without repeating the sample table.
# Outputs are fixed beneath project root. Reports append; RDS is never overwritten.
# Exit 0: stage-1 gates passed; 1: runtime/input/object failure; 2: design blocked.

stage1_review_design <- function(args = character(), compact_report = FALSE, return_design = FALSE) {
  started <- Sys.time()
  script_arg <- grep("^--file=", commandArgs(), value = TRUE)
  stopifnot(length(script_arg) == 1L, requireNamespace("digest", quietly = TRUE))
  script <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
  root <- dirname(dirname(script))
  if (length(args)) {
    stopifnot(length(args) == 2L, args[1L] == "--project-root")
    root <- normalizePath(args[2L], mustWork = TRUE)
  }
  meta_path <- file.path(root, "metadata/source_sample_metadata.tsv")
  design_path <- file.path(root, "docs/batch_01/experiment_design.md")
  plan_path <- file.path(root, "docs/batch_01/analysis_plan.md")
  asv_path <- file.path(root, "data/asv_table.tsv")
  report <- file.path(root, "results/qc/stage1_report.md")
  stopifnot(all(file.exists(c(meta_path, design_path, plan_path, asv_path, report))))
  sha <- function(path) digest::digest(file = path, algo = "sha256")
  input_files <- c(metadata = meta_path, design = design_path, plan = plan_path)
  before <- vapply(input_files, sha, "")
  report_before <- readBin(report, "raw", n = file.info(report)$size)
  checks <- data.frame(status = character(), item = character(), evidence = character())
  add <- function(status, item, evidence) {
    checks[nrow(checks) + 1L, ] <<- c(status, item, evidence)
  }
  need <- function(ok, item, evidence) {
    add(if (isTRUE(ok)) "PASS" else "FAIL", item, evidence)
    if (!isTRUE(ok)) stop(item, call. = FALSE)
  }
  md <- function(x) {
    x[is.na(x)] <- "NA"
    gsub("[\r\n]+", " / ", gsub("|", "\\|", as.character(x), fixed = TRUE))
  }
  proposed <- NULL
  group_table <- NULL
  setting_table <- NULL
  phase_key <- character()
  tryCatch({
    design <- readLines(design_path, warn = FALSE, encoding = "UTF-8")
    need(any(grepl('<a id="2026-11-02-design-correction">', design, fixed = TRUE)),
         "当前设计来源", "定位2026-11-02用户确认修正及完整五模块清单；保留历史记录。")
    mapping_lines <- grep("^\\| G[1-5] \\|.*Batch_01_", design, value = TRUE)
    parts <- lapply(mapping_lines, function(line) trimws(strsplit(
      substring(line, 2L, nchar(line) - 1L), "|", fixed = TRUE)[[1L]]))
    need(length(parts) == 5L && all(lengths(parts) == 4L), "五模块名单可解析",
         paste0("明确名单行数=", length(parts), "；每行含模块、定义、记录数、完整ID清单。"))
    group_table <- as.data.frame(do.call(rbind, parts), stringsAsFactors = FALSE)
    names(group_table) <- c("group", "definition", "expected_n", "sample_ids")
    ids <- unlist(strsplit(group_table$sample_ids, ",", fixed = TRUE), use.names = FALSE)
    assigned <- rep(group_table$group, lengths(strsplit(group_table$sample_ids, ",", fixed = TRUE)))
    need(length(ids) == 33L && !anyDuplicated(ids) &&
           identical(group_table$group, paste0("G", 1:5)) &&
           identical(as.integer(group_table$expected_n), c(8L, 2L, 4L, 15L, 4L)),
         "明确名单唯一且完整", paste0("名单条数=", length(ids), "；重复=", sum(duplicated(ids)), "；预期模块记录数=8/2/4/15/4。"))
    meta <- read.delim(meta_path, check.names = FALSE, colClasses = "character",
                      na.strings = c("NA", ""), quote = "", comment.char = "", fileEncoding = "UTF-8")
    required <- c("sample-id", "supplier_sample_id", "reactor_id", "operation_phase",
                  "phase_days", "timepoint", "phase_day_basis", "particle_size_fraction_um")
    need(all(required %in% names(meta)) && nrow(meta) == 33L &&
           !anyNA(meta[["sample-id"]]) && !anyDuplicated(meta[["sample-id"]]) &&
           !anyNA(meta$supplier_sample_id) && !anyDuplicated(meta$supplier_sample_id),
         "原始样本名称一一对应", paste0("metadata行数=", nrow(meta), "；原ASV样本名与supplier_sample_id均无缺失或重复；不改名。"))
    # Deliberately read only the two header lines, not any abundance cells.
    head <- readLines(asv_path, n = 2L, warn = FALSE)
    header <- if (identical(head[1L], "# Constructed from biom file")) head[2L] else head[1L]
    header <- strsplit(header, "\t", fixed = TRUE)[[1L]]
    asv_ids <- header[-1L]
    need(header[1L] %in% c("#OTU ID", "Feature ID", "feature-id") && length(asv_ids) == 33L &&
           !anyDuplicated(asv_ids) && setequal(asv_ids, meta[["sample-id"]]) && setequal(asv_ids, ids),
         "33个ASV样本与五模块/原样本映射一致", paste0("ASV表头样本=", length(asv_ids),
           "；metadata及模块名单无漏样、无额外样本；仅读前两行，未读取计数。"))
    need(identical(sub("^Batch_01_", "", meta[["sample-id"]]), meta$supplier_sample_id),
         "现有ID与原样本名逐行对应", "逐行比对现有Batch_01_后缀与原表supplier_sample_id；不是据前缀构造分组。")
    group <- assigned[match(meta[["sample-id"]], ids)]
    allowed_phases <- list(G1 = c("low_cn_startup", "low_cn_end"), G2 = "do_5", G3 = "do_3",
                          G4 = "low_do_long_term", G5 = "low_do_size_fractionation")
    phase_ok <- vapply(seq_len(nrow(meta)), function(i) meta$operation_phase[i] %in% allowed_phases[[group[i]]], TRUE)
    need(all(phase_ok), "模块与原运行阶段不冲突", "用户明确名单与原operation_phase逐行核对；G1包含启动前/后两类，仍保留六类原编码。")
    rname <- c(Reactor_01 = "R1", Reactor_02 = "R2", Reactor_03 = "R3", Reactor_04 = "R4")
    need(all(meta$reactor_id %in% names(rname)) && length(unique(meta$reactor_id)) == 4L,
         "四个反应器标签", "原表Reactor_01–04全部保留；R1–R4设计称谓与轮次另列，不据标签认定独立实验。")
    day <- suppressWarnings(as.numeric(meta$phase_days))
    need(all(is.finite(day)), "相对采样日可追溯", "读取原phase_days，约120和推算163通过独立状态保留，不生成日历日期。")
    source <- "docs/batch_01/experiment_design.md#2026-11-02-design-correction"
    setting_source <- "docs/batch_01/experiment_design.md#2026-11-03-DO-settings"
    setting_lines <- grep("^\\| (G[1235]_all|G4_baseline|G4_post_adaptation) \\|", design, value = TRUE)
    setting_parts <- lapply(setting_lines, function(line) trimws(strsplit(
      substring(line, 2L, nchar(line) - 1L), "|", fixed = TRUE)[[1L]]))
    need(length(setting_parts) == 6L && all(lengths(setting_parts) == 8L), "用户报告阶段DO设置可解析",
         "读取最新DO表的6个阶段层；区分G1范围、恢复基线、低DO后期与设定/实测。")
    setting_table <- as.data.frame(do.call(rbind, setting_parts), stringsAsFactors = FALSE)
    names(setting_table) <- c("phase_key", "start_day", "end_day", "nominal_mg_L", "lower_mg_L",
                             "upper_mg_L", "setting_text", "setting_context")
    setting_table[setting_table == "NA"] <- NA_character_
    lower <- suppressWarnings(as.numeric(setting_table$lower_mg_L))
    upper <- suppressWarnings(as.numeric(setting_table$upper_mg_L))
    nominal <- suppressWarnings(as.numeric(setting_table$nominal_mg_L))
    has_nominal <- !is.na(setting_table$nominal_mg_L)
    need(identical(setting_table$phase_key, c("G1_all", "G2_all", "G3_all", "G4_baseline", "G4_post_adaptation", "G5_all")) &&
           all(is.finite(lower)) && all(is.finite(upper)) && all(lower >= 0 & lower <= upper) &&
           all(is.finite(nominal[has_nominal])) &&
           all(nominal[has_nominal] >= lower[has_nominal] & nominal[has_nominal] <= upper[has_nominal]),
         "DO阶段与范围结构", "6个阶段键唯一；算术下界不大于上界；范围不是采样实测值或统计误差。")
    phase_key <- paste0(group, "_all")
    phase_key[group == "G4" & day == 1] <- "G4_baseline"
    phase_key[group == "G4" & day >= 25 & day <= 145] <- "G4_post_adaptation"
    need(all(phase_key %in% setting_table$phase_key), "采样节点有明确的设置记录层",
         "G4四个day1基线与30/76/145d后期分层，适应期间没有额外样本行；不对未知节点插值。")
    settings <- setting_table[match(phase_key, setting_table$phase_key), , drop = FALSE]
    baseline <- phase_key == "G4_baseline"
    later <- phase_key == "G4_post_adaptation"
    round <- c(G1 = "G1_original", G2 = "G2G3_postmix", G3 = "G2G3_postmix",
               G4 = "G4G5_low_DO", G5 = "G4G5_low_DO")[group]
    extra_names <- c("group", "group_source", "stage_subphase", "reactor_round", "reactor_instance_id",
                     "continuous_run_id", "sludge_type_design", "pool_id", "pool_source_reactors",
                     "pool_split_recipients", "source_sample_id", "phase_start_day", "phase_end_day",
                     "sampling_day_status", "DO_setpoint_mg_L", "DO_measured_mg_L", "DO_measured_status",
                     "fractionation_event_id", "mother_sample_id", "metadata_source", "condition_source",
                     "DO_setting_text", "DO_setting_lower_mg_L", "DO_setting_upper_mg_L", "DO_setting_context",
                     "sampling_position_relative_to_DO_switch", "steady_state_evidence_status")
    need(!any(extra_names %in% names(meta)), "方案不覆盖原列", paste0("新增", length(extra_names), "个方案字段均与原列不同；仅在内存组合，不写回metadata。"))
    extra <- as.data.frame(matrix(NA_character_, nrow(meta), length(extra_names),
                                  dimnames = list(NULL, extra_names)), stringsAsFactors = FALSE)
    extra$group <- group
    extra$group_source <- source
    extra$reactor_round <- unname(round)
    extra$reactor_instance_id <- paste(round, meta$reactor_id, sep = "::")
    extra$continuous_run_id <- extra$reactor_instance_id
    extra$sludge_type_design <- ifelse(rname[meta$reactor_id] %in% c("R1", "R2"), "flocculent", "granular")
    extra$stage_subphase[group == "G1"] <- meta$operation_phase[group == "G1"]
    extra$stage_subphase[group %in% c("G2", "G3")] <- "stage_end"
    extra$stage_subphase[baseline] <- "recovered_baseline_before_low_DO_switch"
    extra$stage_subphase[later] <- "design_stable_low_DO_period"
    extra$stage_subphase[group == "G5"] <- "same_mother_size_fractionation"
    mixed <- group %in% c("G2", "G3")
    first_pool <- rname[meta$reactor_id] %in% c("R1", "R2")
    extra$pool_id[mixed] <- ifelse(first_pool[mixed], "post_G1_pool_R1_R2", "post_G1_pool_R3_R4")
    extra$pool_source_reactors[mixed] <- ifelse(first_pool[mixed], "G1:R1;G1:R2", "G1:R3;G1:R4")
    extra$pool_split_recipients[mixed] <- ifelse(first_pool[mixed], "new_R1;new_R2", "new_R3;new_R4")
    extra$phase_start_day <- settings$start_day
    extra$phase_end_day <- settings$end_day
    extra$sampling_day_status <- "recorded_relative_day"
    extra$sampling_day_status[grepl("约", meta$timepoint)] <- "approximate_recorded"
    extra$sampling_day_status[grepl("推算", meta$phase_day_basis)] <- "derived_in_original_record"
    extra$sampling_day_status[mixed] <- "user_confirmed_stage_end"
    extra$DO_setpoint_mg_L <- settings$nominal_mg_L
    extra$DO_setting_text <- settings$setting_text
    extra$DO_setting_lower_mg_L <- settings$lower_mg_L
    extra$DO_setting_upper_mg_L <- settings$upper_mg_L
    extra$DO_setting_context <- settings$setting_context
    extra$sampling_position_relative_to_DO_switch[baseline] <- "before_switch"
    extra$sampling_position_relative_to_DO_switch[later | group == "G5"] <- "after_switch"
    extra$steady_state_evidence_status[later] <- "not_reviewed"
    extra$DO_measured_status <- "unknown"
    prior <- c(E1 = "A2", F1 = "B3", G1 = "C2", H1 = "D3")
    start_rows <- which(group == "G4" & meta$supplier_sample_id %in% names(prior))
    extra$source_sample_id[start_rows] <- meta[["sample-id"]][match(prior[meta$supplier_sample_id[start_rows]], meta$supplier_sample_id)]
    extra$fractionation_event_id[group == "G5"] <- "G5_R1_single_mother"
    extra$metadata_source <- paste("metadata/source_sample_metadata.tsv", source, sep = ";")
    extra$condition_source <- setting_source
    proposed <- cbind(meta, extra)
    need(identical(proposed[, names(meta), drop = FALSE], meta), "全部原metadata字段保留",
         paste0("内存方案保留原", ncol(meta), "列、33行原值和行序；新增", ncol(extra), "列；源文件不写入。"))
    sample_row <- function(id) match(id, meta$supplier_sample_id)
    need(all(day[group == "G2"] == 21) && all(day[group == "G3"] == 56) &&
           all(!day[mixed] %in% 22) &&
           identical(extra$continuous_run_id[sample_row("B2")], extra$continuous_run_id[sample_row("B3")]) &&
           identical(extra$continuous_run_id[sample_row("D2")], extra$continuous_run_id[sample_row("D3")]) &&
           all(extra$reactor_round[mixed] == "G2G3_postmix") &&
           any(grepl("| 过渡及稳定过程 | 22 |", design, fixed = TRUE)),
         "G2/G3连续阶段及第22天", "B2/D2=21d，A2/B3/C2/D3=56d；B2→B3、D2→D3各共用运行键；第22天仅过程记录，无该日稳定样本。")
    need(setequal(meta$supplier_sample_id[extra$pool_id %in% "post_G1_pool_R1_R2"], c("A2", "B2", "B3")) &&
           setequal(meta$supplier_sample_id[extra$pool_id %in% "post_G1_pool_R3_R4"], c("C2", "D2", "D3")) &&
           all(is.na(extra$pool_id[!mixed])), "两次混合与均分接种关系",
         "A2/B2/B3共享原R1+R2混合来源；C2/D2/D3共享原R3+R4混合来源；不向G4虚填新的混合操作。")
    need(length(start_rows) == 4L && all(day[start_rows] == 1) &&
           all(extra$DO_setpoint_mg_L[start_rows] == "3") &&
           all(extra$DO_setting_context[start_rows] == "recovery_original_G3_setting") &&
           all(extra$sampling_position_relative_to_DO_switch[start_rows] == "before_switch") &&
           all(extra$stage_subphase[start_rows] == "recovered_baseline_before_low_DO_switch") &&
           all(is.na(extra$DO_measured_mg_L[start_rows])),
         "G4初始前源及切换前基线", "E1←A2、F1←B3、原样本G1←C2、H1←D3；4℃保存59天、原G3条件恢复结束后且低DO切换前取样；设置3、实测NA。")
    need(sum(later) == 11L && all(day[later] %in% c(30, 76, 145)) &&
           all(extra$DO_setpoint_mg_L[later] == "0.5") &&
           all(extra$phase_start_day[later] == "25") && all(extra$phase_end_day[later] == "145") &&
           all(extra$steady_state_evidence_status[later] == "not_reviewed"),
         "G4适应期后设计稳定运行期", "30d=3、76d=4、145d=4，共11个样本，均在25–145d；设置0.5±0.2。可按设计标稳定期，运行性能稳态证据另行审阅；仍是纵向相关记录。")
    expected_fraction <- c(S1 = "<100", S2 = "100–200", S3 = "200–500", S4 = ">500")
    fraction <- which(group == "G5")
    need(length(fraction) == 4L && all(meta$reactor_id[fraction] == "Reactor_01") &&
           identical(unname(expected_fraction[meta$supplier_sample_id[fraction]]), meta$particle_size_fraction_um[fraction]) &&
           length(unique(extra$fractionation_event_id[fraction])) == 1L &&
           all(is.na(extra$mother_sample_id[fraction])) && all(day[fraction] == 145 + 18) &&
           all(extra$reactor_instance_id[fraction] == extra$reactor_instance_id[sample_row("E3")]),
         "G5同一母样及G4-R1延续", "S1<100、S2=100–200、S3=200–500、S4>500 μm；同一事件、同一G4-R1实体；163为原表145+18推算；母样原始编号NA。")
    need(sum(!is.na(extra$DO_setpoint_mg_L)) == 25L && all(is.na(extra$DO_measured_mg_L)) &&
           all(extra$DO_setpoint_mg_L[group == "G2"] == "5") && all(extra$DO_setpoint_mg_L[group == "G3"] == "3") &&
           all(is.na(extra$DO_setpoint_mg_L[group == "G1"])) &&
           all(extra$DO_setting_lower_mg_L[group == "G1"] == "5") && all(extra$DO_setting_upper_mg_L[group == "G1"] == "7") &&
           all(extra$DO_setpoint_mg_L[group == "G5"] == "0.5") &&
           all(extra$DO_setting_lower_mg_L[later | group == "G5"] == "0.3") &&
           all(extra$DO_setting_upper_mg_L[later | group == "G5"] == "0.7"), "DO设置、范围与实测严格区分",
         "G1八行只记5–7范围，不取中点6；G2=5，G3及G4切换前恢复基线=3；G4后期11行及G5四行=0.5±0.2，界限仅表达设置。25行有标称设置、8行仅范围；33行实测NA。")
    add("WARNING", "重复与共享来源", "G1为同反应器前后采样；G2/G3为连续阶段，DO与时间/阶段混杂，两个混合来源块不等于已确认独立生物重复；G4沿前源继承相关性。")
    add("WARNING", "不平衡时间点", paste0("G2/G3记录数2/4；G4各记录日：",
      paste(names(table(day[group == "G4"])), as.integer(table(day[group == "G4"])), sep = "d=", collapse = "；"), "；不补造缺失同期样本。"))
    add("WARNING", "粒径组分层级", "G5为一个母样的4个组分；不能作为4份独立生物重复，不能自动称技术重复；原始母样编号和边界处理仍未知。")
    add("WARNING", "设置已知与稳态证据边界", "阶段DO设置已经补充；没有采样瞬时具体值，实测字段NA。0.5±0.2不是实测均值±标准差；11个后期样本按设计归稳定期，运行性能证据未审阅，不据此断定不稳。日历/恢复时长等缺口仍保留。")
    if (!return_design) add("WARNING", "当前交付门控", "仅交付设计及metadata映射方案；不回写原始metadata，不构建最终phyloseq，不执行任何显著性检验；模块映射通过不代表统计适用性通过。")
  }, error = function(e) {
    if (!nrow(checks) || tail(checks$status, 1L) != "FAIL" || tail(checks$item, 1L) != conditionMessage(e)) {
      add("FAIL", "设计梳理异常", conditionMessage(e))
    }
  })
  unchanged <- identical(vapply(input_files, sha, ""), before)
  add(if (unchanged) "PASS" else "FAIL", "输入文档及metadata保持不变", "比较本入口运行前后metadata/设计/计划SHA-256；不对ASV计数或Artifact重新计算校验。")
  exit_code <- if (any(checks$status == "FAIL")) 1L else 0L
  if (return_design) return(list(metadata = proposed, checks = checks, exit_code = exit_code))
  rows <- if (!compact_report && !is.null(proposed) && exit_code == 0L) vapply(seq_len(nrow(proposed)), function(i) {
    relation <- if (!is.na(proposed$pool_id[i])) proposed$pool_id[i] else if (!is.na(proposed$source_sample_id[i]))
      paste0("前源:", proposed$source_sample_id[i]) else if (!is.na(proposed$fractionation_event_id[i]))
      proposed$fractionation_event_id[i] else "NA"
    paste0("| ", paste(md(c(proposed[["sample-id"]][i], proposed$supplier_sample_id[i], proposed$group[i],
      paste(proposed$operation_phase[i], proposed$stage_subphase[i], sep = "/"), proposed$reactor_instance_id[i], proposed$sludge_type_design[i],
      paste(proposed$phase_days[i], proposed$sampling_day_status[i], sep = "/"),
      paste(md(proposed$DO_setting_text[i]), "NA", sep = "/"), relation)), collapse = " | "), " |")
  }, "") else "未形成通过核验的映射方案，见上方FAIL。"
  setting_view <- if (!is.null(setting_table) && exit_code == 0L) paste0("| ",
    setting_table$phase_key, " | ", as.integer(table(factor(phase_key, levels = setting_table$phase_key))),
    " | ", setting_table$setting_text, " | NA |") else "设置方案未通过，详见FAIL。"
  lines <- c("", paste0("## 已确认设计修正与映射方案：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai"), "（Asia/Shanghai）"), "",
    "来源：用户已确认五模块、来源与连续阶段，并于2026-11-03补充G1/G4/G5阶段DO设置，明确G4四个初始样本在恢复结束、切换低DO之前取样。以设计文档最新阶段DO补充为准；历史设置未知和初始位置待确认只代表当时记录。此前基础QC沿用，不重跑。", "",
    paste0("本次设计方案检查：PASS=", sum(checks$status == "PASS"), "；WARNING=", sum(checks$status == "WARNING"), "；FAIL=", sum(checks$status == "FAIL"), "；退出码=", exit_code, "。对象和统计仍按用户要求暂缓，映射检查状态不等同全阶段验收。"), "",
    "| 状态 | 本次检查 | 实际依据 |", "|---|---|---|",
    apply(checks, 1L, function(x) paste0("| ", paste(md(x), collapse = " | "), " |")), "",
    "### 五模块及统计边界", "",
    "| 模块 | 记录数 | 当前目标与限制 |", "|---|---:|---|",
    "| G1 | 8 | 低C/N启动前后，保留四个原反应器的前后关联；不能作8个独立重复 |",
    "| G2 | 2 | DO设定5的21d阶段末，只有B2/D2 |",
    "| G3 | 4 | DO设定3的56d阶段末，与G2同轮连续；仅两对匹配阶段末记录，不能分离DO与时间/阶段效应 |",
    "| G4 | 15 | 4个切换前恢复基线（设置3）+11个适应期后设计稳定期（设置0.5±0.2）；记录日4/3/4/4行，仍相关且不平衡 |",
    "| G5 | 4 | G4-R1延长18天后同一母样四个粒径组分，设置0.5±0.2；母样事件数1，不估计跨母样重复变异 |", "",
    "G1旧反应器→原R1+R2/原R3+R4各自混合→均分至各自两个新反应器→G2(0–21d,设定5)→第22天过渡/稳定→G3(23–56d,设定3)。两个已记录来源块不能直接充当独立重复数；B2→B3及D2→D3分别共用连续运行实体。", "",
    "G4的初始前源为E1←A2、F1←B3、原样本G1←C2、H1←D3，经过4℃59天保存及恢复后开始新的时间轴；相关来源结构不能因进入新实验而忽略。G5与G4-R1共享运行实体和一个母样事件，四级分不构成四次独立采样。", "",
    "### 33样本metadata映射方案（未写入原表）", "",
    "原metadata的全部列和值保持不变；本入口在内存附加27个字段，包括设置表达式/上下界/情境、切换前后位置和稳态证据状态。完整定义及数值来源见[设计文档](../../docs/batch_01/experiment_design.md#2026-11-03-DO-settings)。下面只展示核查视图；内部实体/事件键是关系标识，不是原始实验编号。", "",
    "| ASV sample-id | 原样本名 | 模块group | 原operation_phase/方案子阶段 | 轮次::反应器 | 污泥设计类型 | 相对日/状态 | DO设置表达式/实测 | 混合来源/直接前源/分级事件 |",
    "|---|---|---|---|---|---|---|---|---|", rows, "",
    "字段边界：group与原operation_phase保留；G4初始基线before_switch、后期设计稳定期after_switch；G2为0/21、G3为23/56、G4后期为25/145。G1仅范围5–7不取中点；G4基线设置3为恢复原G3情境，非实测。稳态证据未审阅不等于反应器不稳。G5共享母样事件，原母样编号NA；粒径原值保留。", "",
    "### 当前阶段DO设置", "", "| 阶段层 | 样本数 | 用户报告设置 | 采样实测 |", "|---|---:|---|---|", setting_view, "",
    "### 尚需后续核查（已解决的问题不再索取）", "",
    "- 用户明确没有采样瞬间DO具体数值，实测字段保持NA；已知阶段设置用于设计标签，不再将G1/G4后期/G5设置列为未知。G4基线记录恢复阶段设置3，与实测分开。",
    "- 采样日历日期、约120d的精确性、恢复时长；163仅为原记录145+18推算，不自动生成统一连续时间轴。",
    "- 原始混合比例和接种量、原始母样编号、筛分边界及处理细节；上述细节未知不改变已确认的两次混合及同一母样事实。",
    "- G2未记录新R1/新R3的同期样本、G4第30天未记录R1样本的原因；保留本批实际不平衡取样，不插补样本。",
    "- 任何推断前再核验具体比较的独立实验单位、谱系/重复结构、可识别性、有效样本量和方法前提；本轮只有方案，不生成最终对象。", "",
    "### 复现与数据保护", "",
    paste0("- 命令：`", file.path(R.home("bin"), "Rscript"), " --vanilla ", script, " --review-design --project-root ", shQuote(root), "`。"),
    paste0("- 版本：", R.version.string, "；digest ", utils::packageVersion("digest"), "。新增入口不加载phyloseq，不读取ASV计数或taxonomy/FASTA/BIOM/QZA；仅前两行ASV表头用于本次明确要求的ID核对。"),
    "- 仅读文档与原始metadata；报告仅追加；未建立新文件或临时文件。原报告中的14列metadata输入指纹继续对应当前未改写源文件。", "",
    "| 本次完整读取输入 | SHA-256 |", "|---|---|",
    paste0("| ", names(before), " | ", before, " |"), "",
    paste0("- 本次脚本SHA-256：", sha(script), "。历史脚本指纹对应各自运行版本，未改写。"),
    sprintf("- 用时：%.3f秒；退出码%d。", as.numeric(difftime(Sys.time(), started, units = "secs")), exit_code), "")
  if (compact_report) {
    lines <- c("", paste0("## 阶段DO设置与G4分层复核（简版）：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai"), "（Asia/Shanghai）"), "",
      "用户补充阶段DO设置，并确认E1/F1/原样本G1/H1在原条件恢复结束、切换低DO之前取样。本节取代历史“G4初始样本已处适应期”“G1/G4后期/G5设置未知”的结论；五模块归属不变。原metadata保留，27个附加字段仅在内存形成方案。以下仅核对metadata/设计与ASV表头，基础QC不重跑，历史报告不改写。", "",
      paste0("本次检查：PASS=", sum(checks$status == "PASS"), "；WARNING=", sum(checks$status == "WARNING"),
        "；FAIL=", sum(checks$status == "FAIL"), "；退出码=", exit_code, "。仅表示本次映射方案检查状态，不代表统计适用性或完整阶段验收。"), "",
      "| 状态 | 检查 | 实际依据 |", "|---|---|---|",
      apply(checks, 1L, function(x) paste0("| ", paste(md(x), collapse = " | "), " |")), "",
      "### 阶段设置与样本层", "", "| 阶段层 | 样本数 | 用户报告设置 | 采样实测 |", "|---|---:|---|---|", setting_view, "",
      "G4的15行继续用于完整时间序列：四份恢复后初始基线，设置3 mg/L（原G3恢复条件）；11份30/76/145d样本属于25–145d、设置0.5±0.2的设计稳定运行期（适应期后）。可以单独描述这11份后期样本；不能把含不同设置基线的15份统一标成低DO稳定条件。11份仍是重复采样，运行性能证据是否已证明稳态与阶段命名分开。", "",
      "G1的5–7范围不取中点；0.5±0.2仅是用户报告的设置，0.3–0.7为其算术表达，不是实测极值、标准差或置信区间。用户明确没有采样瞬时DO数值，33行实测均NA，不要求凭空补齐。第1天的3只写恢复阶段设置；原day1编号不当成低DO已暴露1天。", "",
      "G1–G5仍为8/2/4/15/4；混合来源、G2/G3时间/阶段混杂和纵向相关不变；G5同一母样不作4份独立生物重复。原metadata不回写，不构建对象或运行统计检验。待审阅运行稳态性能记录，精确时间/恢复时长、接种量及母样处理等缺口仍保留；已明确的设置与取样位置不再索取。", "",
      "### 复现与输入记录", "",
      paste0("- 命令：`", file.path(R.home("bin"), "Rscript"), " --vanilla ", script,
        " --review-design --compact-report --project-root ", shQuote(root), "`。"),
      paste0("- 工具：", R.version.string, "；digest ", utils::packageVersion("digest"), "；不加载phyloseq。"),
      "- ASV仅读取前两行表头；不扫描或重新校验计数。完整读取的metadata/设计/计划指纹如下，原科研数据不改写。", "",
      "| 输入 | SHA-256 |", "|---|---|", paste0("| ", names(before), " | ", before, " |"), "",
      paste0("- 当前脚本SHA-256：", sha(script), "。"),
      sprintf("- 用时：%.3f秒；退出码%d。", as.numeric(difftime(Sys.time(), started, units = "secs")), exit_code), "")
  }
  stopifnot(identical(readBin(report, "raw", n = file.info(report)$size), report_before))
  con <- file(report, open = "at", encoding = "UTF-8")
  tryCatch(writeLines(lines, con, useBytes = TRUE), finally = close(con))
  cat(sprintf("%s: design plan PASS=%d WARNING=%d FAIL=%d; report=%s; metadata unchanged; no phyloseq; exit=%d\n",
    if (exit_code == 0L) "PASS" else "FAIL", sum(checks$status == "PASS"), sum(checks$status == "WARNING"),
    sum(checks$status == "FAIL"), report, exit_code))
  exit_code
}

stage1_review_metadata <- function(args = character()) {
  started <- Sys.time()
  script_arg <- grep("^--file=", commandArgs(), value = TRUE)
  stopifnot(length(script_arg) == 1L)
  script <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
  root <- dirname(dirname(script))
  if (length(args)) {
    stopifnot(length(args) == 2L, args[1L] == "--project-root")
    root <- normalizePath(args[2L], mustWork = TRUE)
  }
  current_design <- file.path(root, "docs/batch_01/experiment_design.md")
  if (file.exists(current_design) && any(grepl('<a id="2026-11-02-design-correction">',
      readLines(current_design, warn = FALSE, encoding = "UTF-8"), fixed = TRUE))) {
    return(stage1_review_design(args))
  }
  report <- file.path(root, "results/qc/stage1_report.md")
  input_paths <- c(metadata = "metadata/source_sample_metadata.tsv",
                   design = "docs/batch_01/experiment_design.md",
                   id_log = "logs/dada2/sample-id-update.json",
                   annotation_log = "logs/taxonomy/inputs.json")
  paths <- setNames(file.path(root, input_paths), names(input_paths))
  stopifnot(file.exists(report), all(file.exists(paths)),
            requireNamespace("digest", quietly = TRUE), requireNamespace("jsonlite", quietly = TRUE))
  report_before <- readBin(report, "raw", n = file.info(report)$size)
  historical <- readLines(report, warn = FALSE, encoding = "UTF-8")
  cached_items <- c("ASV 与 taxonomy Feature ID", "ASV 与 FASTA Feature ID",
                    "原始计数数值合法", "测序深度异常筛查")
  for (item in cached_items) stopifnot(any(grepl(paste0("| PASS | input | ", item, " |"), historical, fixed = TRUE)))
  sha <- function(path) digest::digest(file = path, algo = "sha256")
  fingerprints <- vapply(paths, sha, "")
  meta <- read.delim(paths[["metadata"]], check.names = FALSE, colClasses = "character",
                     na.strings = c("NA", ""), quote = "", comment.char = "", fileEncoding = "UTF-8")
  required <- c("sample-id", "supplier_sample_id", "reactor_id", "timepoint", "phase_days",
                "phase_day_basis", "operation_phase", "particle_size_fraction_um", "metadata_review_notes")
  stopifnot(nrow(meta) == 33L, all(required %in% names(meta)),
            !anyNA(meta[["sample-id"]]), !anyDuplicated(meta[["sample-id"]]),
            !anyNA(meta$supplier_sample_id), !anyDuplicated(meta$supplier_sample_id))
  design <- readLines(paths[["design"]], warn = FALSE, encoding = "UTF-8")
  lineage_line <- grep("来源分别与", design)
  stopifnot(length(lineage_line) == 1L)
  matched <- regmatches(design[lineage_line], regexec(
    "涉及 ([A-Za-z0-9/]+)，来源分别与 ([A-Za-z0-9/]+)", design[lineage_line]))[[1L]]
  stopifnot(length(matched) == 3L)
  descendants <- strsplit(matched[2L], "/", fixed = TRUE)[[1L]]
  ancestors <- strsplit(matched[3L], "/", fixed = TRUE)[[1L]]
  stopifnot(length(descendants) == length(ancestors), !anyDuplicated(descendants),
            all(c(descendants, ancestors) %in% meta$supplier_sample_id))
  lineage <- setNames(ancestors, descendants)
  known_lines <- grep("^-[[:space:]]", design[seq_len(match("## 严格禁止的推断", design) - 1L)])
  stopifnot(length(known_lines) > 0L)
  norm_log <- jsonlite::fromJSON(paths[["id_log"]], simplifyVector = FALSE)
  annot_log <- jsonlite::fromJSON(paths[["annotation_log"]], simplifyVector = FALSE)
  stopifnot(setequal(unlist(annot_log$sample_ids), meta[["sample-id"]]))
  mapping_path <- norm_log$sample_id_mapping
  stopifnot(is.character(mapping_path), length(mapping_path) == 1L)
  mapping_exists <- file.exists(mapping_path)
  miss <- function(x) is.na(x) | !nzchar(trimws(x))
  md <- function(x) {
    x[is.na(x)] <- "NA"
    gsub("[\r\n]+", " / ", gsub("|", "\\|", x, fixed = TRUE))
  }
  source_link <- function(line) paste0("[M:", line, "](../../metadata/source_sample_metadata.tsv#L", line, ")")
  design_link <- function(line) paste0("[D:", line, "](../../docs/batch_01/experiment_design.md#L", line, ")")
  basis <- unique(meta$phase_day_basis)
  stopifnot(!anyNA(basis))
  basis_id <- paste0("T", match(meta$phase_day_basis, basis))
  do_values <- vapply(seq_len(nrow(meta)), function(i) {
    x <- regmatches(meta$timepoint[i], regexec("DO设定([0-9]+(?:\\.[0-9]+)?) mg/L", meta$timepoint[i], perl = TRUE))[[1L]]
    if (length(x)) paste0("实测NA；记录设定", x[2L]) else if (meta$supplier_sample_id[i] %in% descendants)
      "实测NA；第1天DO待确认" else "实测NA；未记录采样DO"
  }, "")
  phase_counts <- table(meta$operation_phase)
  reactor_counts <- table(meta$reactor_id)
  notes <- which(!miss(meta$metadata_review_notes))
  fraction <- which(!miss(meta$particle_size_fraction_um))
  days <- meta$phase_days
  days[grepl("约", meta$timepoint)] <- paste0(days[grepl("约", meta$timepoint)], "（约）")
  days[grepl("推算", meta$phase_day_basis)] <- paste0(days[grepl("推算", meta$phase_day_basis)], "（原表推算）")
  table_rows <- vapply(seq_len(nrow(meta)), function(i) {
    prior <- if (meta$supplier_sample_id[i] %in% descendants) unname(lineage[meta$supplier_sample_id[i]]) else "NA"
    status <- if (prior != "NA") paste0("前源：已确认文档线索；其余待确认；", source_link(i + 1L), "、", design_link(lineage_line)) else
      paste0("已记录待确认；", source_link(i + 1L))
    paste0("| ", paste(md(c(meta[["sample-id"]][i], meta$supplier_sample_id[i], meta$reactor_id[i],
        meta$timepoint[i], paste0(days[i], " / ", basis_id[i]), meta$operation_phase[i], do_values[i],
        meta$particle_size_fraction_um[i], prior, status)), collapse = " | "), " |")
  }, "")
  stopifnot(length(table_rows) == 33L)
  known_rows <- vapply(known_lines, function(i) paste0("- ", sub("^- ", "", design[i]), "（", design_link(i), "；已确认限既往讨论/文档层级，不等于原始记录独立复核。）"), "")
  stamp <- format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai")
  lines <- c("", paste0("## 记录补充：", stamp, "（Asia/Shanghai；仅 metadata/文档梳理）"), "",
    "本次按用户最新说明执行：五组准确映射尚未最终确认，不创建分组、不修改 metadata；不重新运行 ASV、taxonomy、rep-seqs 或测序深度检查，不构建 phyloseq，不作组间推断统计。上文原始检查记录及其 54 PASS / 14 WARNING / 3 FAIL 原样保留，本节不作为一次新的全流程 QC。", "",
    "### 证据状态与当前门控", "",
    "- **已确认**：仅限用户明确说明和 experiment_design.md 中标为既往讨论已确认的线索；标注具体来源，不扩大到未列出的样本或实验条件。",
    "- **待确认**：metadata 已填的样本—反应器、阶段、相对采样日等记录可被逐行引用，但尚未回查原始实验记录；文字一致或字段非空不代表科学真实性已核验。",
    "- **未知**：现有记录没有具体值或用户明确尚未最终确定的信息，保持 NA；未知不等于 0，也不据名称、阶段或前序条件填补。", "",
    "| 状态 | 本次工作/门控 | 实际依据 |", "|---|---|---|",
    "| PASS | 沿用既有基础 QC | 已定位上文四项 PASS：整数计数、ASV-taxonomy ID、ASV-FASTA ID、深度异常筛查；本次不读取 ASV/FASTA/BIOM/QZA，不重复计算。 |",
    paste0("| PASS | 逐样本记录梳理 | metadata 实际读取 ", nrow(meta), " 行；33 条样本记录全部进入下表，保留原 sample-id、supplier_sample_id 与原表行顺序。 |"),
    paste0("| PASS | 现有技术日志衔接 | taxonomy inputs.json 的 sample_ids 与 metadata 样本集合相同；仅核对记录编号，不重复验证丰度或注释。 |"),
    "| WARNING | 科研来源状态 | 上文两个来源字段 FAIL 指指定来源列缺失，并不表示项目内毫无可用记录。本节已定位设计文档、metadata 自带时间依据及技术日志；原始记录出处仍未完整串联，不回写占位来源或修改既往判定。 |",
    paste0("| WARNING | 上游编号映射 | sample-id-update.json 指向 `", mapping_path, "`；当前", if (mapping_exists) "存在，但它仅是编号转换记录，不能证明科研分组或独立性。" else "文件不存在，无法在此环境回查该表；日志内声明不能代替原表审阅。", " |"),
    "| FAIL | 五组对象及组间推断门控 | 用户最新确认：五组准确映射尚未最终确认；metadata 无 group，六类 operation_phase 不等于五组。相关对象与推断继续暂停，不影响本次记录整理。 |", "",
    "### 设计文档中已有的信息", "",
    "设计文档没有列出完整 33 行样本表；以下为直接提取的已确认线索，33 条逐样本详情来自现有 metadata，未根据样本命名重建实验设计。", "", known_rows, "",
    "R1–R4（设计文档称谓）与 Reactor_01–04（metadata 称谓）的精确对应及混合前后实体连续性尚未由原始记录核验；本节不据数字相同向样本回填接种类型。", "",
    "### 33 个样本的现有记录（报告视图，不是修订版 metadata）", "",
    "原始列名 operation_phase 与 timepoint 均保留其记录意义；日数是 phase_days，绝非统一连续运行日或日历日期。DO 列中的数字仅转述 timepoint 明写的设定值，所有采样实测 DO 均为 NA，未写入 metadata。前源仅列设计文档逐一指明的四对关系，其他样本前源未推断。", "",
    "| sample-id | 原样本号 | reactor_id（原表） | timepoint（原表） | phase_days / 时间依据 | operation_phase（原表） | DO现有情况（mg/L） | 粒径分级（μm） | 文档指定前源 | 证据状态与定位 |",
    "|---|---|---|---|---|---|---|---|---|---|", table_rows, "",
    "### 时间依据与字段边界", "",
    vapply(seq_along(basis), function(i) paste0("- **T", i, "**：", basis[i], "（原文来自 metadata.phase_day_basis；说明文本不同不等于独立时间轴数目相同）。"), ""),
    "- T1 的启动终点文字为约 120 d；不把 phase_days=120 当作已核实的精确采样日。T4 在原表已注明 163=145+18，为推算坐标，不是本次补填的测量。",
    "- T3/T4 均描述储存恢复后低 DO 第 1 天起算；T4 加入筛分日推算说明。因此四种依据文本不能解释为四条互不相关时间轴。日期、储存起止时刻、恢复时长及跨阶段换算仍未知。",
    "- low_do_long_term 是原表编码，包含低 DO 第 1 天样本；结合设计文档第 1–24 天为调试/适应期，不能据该编码把所有 15 个样本解释为稳定长期运行。",
    paste0("- 六类 operation_phase 的记录行数：", paste(names(phase_counts), as.integer(phase_counts), sep = "=", collapse = "；"), "。仅描述记录，不合并为五组。"),
    paste0("- 四个 reactor_id 的记录行数：", paste(names(reactor_counts), as.integer(reactor_counts), sep = "=", collapse = "；"), "。不是独立反应器重复数。"),
    "- group、DO_mg_L、DO_status、metadata_source、group_source、condition_source 在当前原表均不存在；sample_order 与 biological_replicate 均为 NA。表行序不得充当采样顺序，来源信息可引用本节文档位置而不虚构原始记录编号。", "",
    "### 重复、来源及混杂风险", "",
    "- **反应器重复采样**：同一 reactor_id 横跨多个时点和阶段，存在纵向相关性；原表行数不是独立生物重复数。阶段、时间和运行条件可能共同变化，不能将阶段差异直接归因于单个 DO 条件。",
    "- **混合后均分**：metadata 的 DO 阶段时间依据写有 R1/R2、R3/R4 分别混合再均分。共享混合来源可能使不同标签样本相关，且混合前后反应器标签不自动代表同一实验单位；需谱系和分样记录后才能确定独立单位。",
    paste0("- **保存恢复及继承来源**：设计文档明确 ", paste(paste0(ancestors, "→", descendants), collapse = "、"), "；4°C 保存 59 天并恢复后进入新实验。前源与后续样本不能默认独立；储存、恢复、调试和稳定运行不能拼接成不间断稳定时间序列。未将这四对关系外推到全部后续样本。"),
    paste0("- **同次粒径分级**：", paste(meta$supplier_sample_id[fraction], meta$particle_size_fraction_um[fraction], sep = "=", collapse = "；"), " μm；原表均为 Reactor_01、phase_days=163，并明写同次采样筛分。四个粒径级分不是四个独立反应器重复，也不能自动称为技术重复；完整采样/分级层级待原记录核验。"),
    "- **不平衡阶段记录**：do_5 只记录 B2/D2，两行不代表两份已确认独立重复；不补造 A/C 同期样本。低 DO 第 30 天只记录 F2/G2/H2，第 76、145 天各四个样本；时间点覆盖不完全，不能默认均衡重复测量设计。", "",
    "### 仅需回查的缺口（无需重复提供上表已有值）", "",
    "| 优先级 | 已有依据 | 尚需定位的内容 | 影响 |", "|---|---|---|---|",
    "| 阻断 | 用户确认五组尚未定稿；六类阶段已列出 | 将来定稿后的五组定义、逐样本映射及批准/原始依据；当前不要求临时指定 | 分组对象、组间推断继续暂停 |",
    "| 阻断推断 | 原表已有 reactor_id，文档已有混合/均分说明 | 原始记录的位置/编号；R1–R4 与 Reactor_01–04 对照、混合前后接种谱系和独立实验单位；不需重抄全部样本记录 | 配对、相关结构、有效样本量和可交换性 |",
    "| 待确认 | 已记录 day 1、约120、21、56、30、76、145和推算163，以及各起点说明 | 约120的精确采样时间（如有）；日历日期、恢复时长、各阶段起点衔接；不自行统一时间轴 | 纵向分析及阶段比较 |",
    "| 待确认 | 第1–24天适应期、DO=3/5设定线索及保存恢复过程已明确 | E1/F1/G1/H1 取样瞬间 DO；第25–145天逐反应器设定/实测与变更节点；无实测则继续NA | DO关联及环境解释 |",
    "| 待确认 | S1–S4 的粒径范围、同次分级及原表推算日已记录 | 同次采样事件/母样编号、分级份数及是否另有独立采样重复；不需再次提供已列粒径范围 | 避免把级分当独立生物重复 |",
    "| 待确认 | do_5仅B2/D2，低DO第30天仅F2/G2/H2 | 其余对应点是未采样、不在本批还是记录缺漏；仅回查缺口，不补造样本 | 不平衡设计与可比较范围 |", "",
    "当前可继续：基于现有记录的逐样本信息整理、来源定位和描述性清单维护。当前不执行：修改 metadata、创建分组、构建项目 phyloseq、组间检验或将分类注释解释为功能/活性。", "",
    "### 本次复现与保护记录", "",
    paste0("- 命令：`", file.path(R.home("bin"), "Rscript"), " --vanilla ", script, " --review-metadata --project-root ", shQuote(root), "`。"),
    paste0("- 工具：", R.version.string, "；digest ", utils::packageVersion("digest"), "；jsonlite ", utils::packageVersion("jsonlite"), "。本入口不加载 phyloseq 或执行完整 stage1_main。"),
    "- 只对本节读取的 metadata、设计文档、两份技术日志记录指纹；不重新读取/校验 ASV、taxonomy、代表序列、BIOM 或 QZA。", "",
    "| 本节输入 | SHA-256 |", "|---|---|",
    paste0("| ", input_paths, " | ", fingerprints, " |"),
    paste0("- 本次脚本 SHA-256：", sha(script), "。上文历史脚本指纹对应此前 QC 版本；本次仅增加独立记录梳理入口，历史结果不被改写。"),
    paste0("- 用时：", sprintf("%.3f", as.numeric(difftime(Sys.time(), started, units = "secs"))), " 秒；记录梳理已完成，但设计门控仍未通过，退出码2。"), "")
  # Do not silently update records that changed while the report was being prepared.
  stopifnot(identical(vapply(paths, sha, ""), fingerprints),
            identical(readBin(report, "raw", n = file.info(report)$size), report_before))
  con <- file(report, open = "at", encoding = "UTF-8")
  tryCatch(writeLines(lines, con, useBytes = TRUE), finally = close(con))
  stopifnot(identical(vapply(paths, sha, ""), fingerprints))
  cat("PASS: 33条样本记录和来源层级已追加至", report,
      "；未重跑基础QC，未修改metadata，未构建对象。\nFAIL: 五组设计门控保持关闭；exit=2\n")
  2L
}

stage1_main <- function(args = commandArgs(trailingOnly = TRUE)) {
  previous_tz <- Sys.getenv("TZ", unset = NA_character_)
  Sys.setenv(TZ = "Asia/Shanghai")
  on.exit(if (is.na(previous_tz)) Sys.unsetenv("TZ") else Sys.setenv(TZ = previous_tz), add = TRUE)
  started <- Sys.time()
  script_arg <- grep("^--file=", commandArgs(), value = TRUE)
  script <- if (length(script_arg)) normalizePath(sub("^--file=", "", script_arg[1L]),
                                                mustWork = TRUE) else NA_character_
  root <- if (!is.na(script)) dirname(dirname(script)) else getwd()
  if (length(args)) {
    if (length(args) != 2L || args[1L] != "--project-root") {
      cat("FAIL: usage: Rscript --vanilla scripts/stage1_pipeline.R [--project-root PATH]\n")
      return(1L)
    }
    root <- args[2L]
  }
  root <- normalizePath(root, mustWork = TRUE)
  report <- file.path(root, "results/qc/stage1_report.md")
  rds <- file.path(root, "results/phyloseq/batch_01_phyloseq.rds")
  paths <- c(asv = "data/asv_table.tsv", taxonomy = "data/taxonomy.tsv",
             sequences = "data/exported_sequences/dna-sequences.fasta",
             metadata = "metadata/source_sample_metadata.tsv",
             biom = "data/exported_table/feature-table.biom",
             table_qza = "input/qiime2/table.qza",
             sequences_qza = "input/qiime2/rep-seqs.qza",
             taxonomy_qza = "input/qiime2/taxonomy.qza")
  inputs <- setNames(file.path(root, paths), names(paths))
  checks <- data.frame(status = character(), gate = character(), item = character(),
                       evidence = character(), stringsAsFactors = FALSE)
  details <- character()
  fingerprint <- NULL
  outcome <- "未生成 RDS。"
  escape <- function(x) gsub("[\r\n]+", " / ", gsub("|", "\\|", x, fixed = TRUE))
  check <- function(ok, gate, item, evidence, fatal = TRUE, severity = "FAIL") {
    ok <- isTRUE(ok)
    status <- if (ok) "PASS" else severity
    checks[nrow(checks) + 1L, ] <<- c(status, gate, item, escape(evidence))
    if (!ok && fatal && severity == "FAIL") stop(item, call. = FALSE)
    invisible(ok)
  }
  warn <- function(gate, item, evidence) check(FALSE, gate, item, evidence, FALSE, "WARNING")
  section <- function(gate, fun) {
    tryCatch(withCallingHandlers(fun(), warning = function(w) {
      warn(gate, "R 运行警告", conditionMessage(w))
      invokeRestart("muffleWarning")
    }), error = function(e) {
      if (!nrow(checks) || tail(checks$status, 1L) != "FAIL" ||
          tail(checks$item, 1L) != conditionMessage(e)) {
        check(FALSE, gate, "步骤异常", conditionMessage(e), FALSE)
      }
      NULL
    })
  }
  missing <- function(x) is.na(x) | !nzchar(trimws(x))
  show_ids <- function(x) if (length(x)) paste(x, collapse = ", ") else "无"
  valid_ids <- function(x, label) {
    check(length(x) > 0L && !any(missing(x)) && !anyDuplicated(x) &&
            all(x == trimws(x)), "input", paste0(label, "唯一且非空"),
          sprintf("ID数=%d；缺失=%d；重复=%d；首尾空白=%d", length(x),
                  sum(missing(x)), sum(duplicated(x)), sum(x != trimws(x), na.rm = TRUE)))
  }
  same_ids <- function(x, y, label) {
    check(setequal(x, y), "input", label,
          paste0("仅左侧：", show_ids(setdiff(x, y)), "；仅右侧：", show_ids(setdiff(y, x))))
  }
  read_tsv <- function(path, skip = 0L) {
    widths <- count.fields(path, sep = "\t", quote = "", comment.char = "",
                           skip = skip, blank.lines.skip = FALSE)
    check(length(widths) >= 2L && !anyNA(widths) && all(widths == widths[1L]),
          "input", paste0(basename(path), "行列结构"),
          sprintf("表头及数据行=%d；不等宽行=%d", length(widths),
                  sum(widths != widths[1L], na.rm = TRUE)))
    tab <- read.delim(path, skip = skip, header = TRUE, sep = "\t", quote = "",
                      comment.char = "", check.names = FALSE, colClasses = "character",
                      na.strings = c("NA", ""), fill = FALSE, blank.lines.skip = FALSE,
                      fileEncoding = "UTF-8")
    valid_ids(names(tab), paste0(basename(path), "列名"))
    tab
  }
  verify_object <- function(ps, counts, taxa, meta, seqs, annotation) {
    stopifnot(inherits(ps, "phyloseq"), isTRUE(methods::validObject(ps)),
              phyloseq::taxa_are_rows(ps), phyloseq::nsamples(ps) == ncol(counts),
              phyloseq::ntaxa(ps) == nrow(counts),
              identical(phyloseq::sample_names(ps), colnames(counts)),
              identical(phyloseq::taxa_names(ps), rownames(counts)))
    stored_counts <- as(phyloseq::otu_table(ps), "matrix")
    # as(..., "data.frame") normalizes sample-id to sample.id in this phyloseq
    # version; explicitly preserve stored column names during verification.
    stored_meta <- data.frame(phyloseq::sample_data(ps), check.names = FALSE)
    stopifnot(identical(dimnames(stored_counts), dimnames(counts)),
              all(stored_counts == counts),
              identical(as(phyloseq::tax_table(ps), "matrix"), taxa),
              identical(attr(ps, "stage1_taxonomy"), annotation),
              identical(names(stored_meta), names(meta)),
              identical(stored_meta[, names(meta), drop = FALSE], meta),
              identical(as.character(phyloseq::refseq(ps)), as.character(seqs)),
              identical(names(phyloseq::refseq(ps)), names(seqs)),
              all(phyloseq::sample_sums(ps) == colSums(counts)))
    TRUE
  }

  section("runtime", function() {
    deps <- c("phyloseq", "Biostrings", "biomformat", "digest")
    for (pkg in deps) {
      ok <- requireNamespace(pkg, quietly = TRUE)
      check(ok, "runtime", paste0("依赖：", pkg),
            if (ok) as.character(utils::packageVersion(pkg)) else "未安装；不自动安装或修改环境。")
    }
    absent <- paths[!file.exists(inputs) | dir.exists(inputs)]
    check(!length(absent), "input", "输入文件存在", paste0("必需输入=", length(paths),
          "；缺失或非文件：", show_ids(absent)))
    fingerprint <<- vapply(inputs, function(p) digest::digest(file = p, algo = "sha256"), "")
    check(TRUE, "input", "输入 SHA-256 已计算", paste0(length(fingerprint), " 个文件；详见输入清单。"))
  })

  # Parse independent components independently; stop only their dependent steps on error.
  counts <- taxonomy <- meta <- seqs <- taxa <- NULL
  if (!is.null(fingerprint)) {
    counts <- section("input", function() {
      first <- readLines(inputs[["asv"]], n = 1L, warn = FALSE)
      skip <- as.integer(identical(first, "# Constructed from biom file"))
      tab <- read_tsv(inputs[["asv"]], skip)
      check(names(tab)[1L] %in% c("#OTU ID", "Feature ID", "feature-id"),
            "input", "ASV 表首列", paste0("实际首列=", names(tab)[1L]))
      valid_ids(tab[[1L]], "ASV Feature ID")
      check(ncol(tab) == 34L, "input", "Batch_01 样本数", paste0("实际=", ncol(tab) - 1L, "；预期=33"))
      raw <- as.matrix(tab[-1L])
      num <- suppressWarnings(matrix(as.numeric(raw), nrow = nrow(raw), dimnames = dimnames(raw)))
      bad <- is.na(num) | !is.finite(num) | num < 0 | num != floor(num) | num > .Machine$integer.max
      check(!any(bad), "input", "原始计数数值合法", sprintf(
        "单元格=%d；缺失/非数值/非有限/负值/非整数/超过R整数范围=%d；未舍入、过滤或变换。", length(num), sum(bad)))
      storage.mode(num) <- "integer"
      rownames(num) <- tab[[1L]]
      check(TRUE, "input", "ASV 矩阵方向", sprintf("ASV为行=%d；样本为列=%d", nrow(num), ncol(num)))
      depths <- colSums(num)
      check(all(depths > 0), "input", "无空样本", paste0("零深度样本：", show_ids(names(depths)[depths == 0])))
      q <- stats::quantile(depths, c(.25, .5, .75), names = FALSE)
      lower <- q[1L] - 1.5 * (q[3L] - q[1L]); upper <- q[3L] + 1.5 * (q[3L] - q[1L])
      outliers <- names(depths)[depths < lower | depths > upper]
      check(!length(outliers), "input", "测序深度异常筛查", sprintf(
        "总reads=%.0f；min=%.0f；Q1=%.1f；median=%.0f；Q3=%.1f；max=%.0f；Tukey 1.5×IQR界限=[%.1f, %.1f]；异常=%s；仅标记，不过滤。",
        sum(depths), min(depths), q[1L], q[2L], q[3L], max(depths), lower, upper, show_ids(outliers)),
        fatal = FALSE, severity = "WARNING")
      zero <- rownames(num)[rowSums(num) == 0]
      check(!length(zero), "input", "全零 ASV", paste0("全零特征=", length(zero), "；保留原始数据。"),
            FALSE, "WARNING")
      details <<- c(details, "### 每样本测序深度", "", "| 样本 ID | reads |", "|---|---:|",
                    paste0("| ", names(depths), " | ", format(depths, scientific = FALSE, trim = TRUE), " |"), "")
      num
    })
    taxonomy <- section("input", function() {
      tab <- read_tsv(inputs[["taxonomy"]])
      check(all(c("Feature ID", "Taxon", "Confidence") %in% names(tab)), "input", "taxonomy 字段",
            paste0("实际字段：", paste(names(tab), collapse = ", ")))
      valid_ids(tab[["Feature ID"]], "taxonomy Feature ID")
      conf <- suppressWarnings(as.numeric(tab$Confidence))
      invalid <- !missing(tab$Confidence) & (!is.finite(conf) | conf < 0 | conf > 1)
      check(!any(invalid), "input", "分类置信度范围", sprintf("非缺失且无法解析或超出[0,1]=%d", sum(invalid)))
      check(!any(missing(tab$Taxon)) && !any(missing(tab$Confidence)), "input", "保留原始分类注释",
            sprintf("Taxon缺失=%d；Confidence缺失=%d；不填补未知分类。", sum(missing(tab$Taxon)), sum(missing(tab$Confidence))), FALSE, "WARNING")
      ranks <- c(d = "Domain", k = "Kingdom", p = "Phylum", c = "Class", o = "Order", f = "Family", g = "Genus", s = "Species")
      rank_table <- matrix(NA_character_, nrow(tab), length(ranks), dimnames = list(tab[["Feature ID"]], unname(ranks)))
      for (i in which(!missing(tab$Taxon))) {
        tokens <- trimws(strsplit(tab$Taxon[i], ";", fixed = TRUE)[[1L]])
        keys <- sub("__.*$", "", tokens)
        if (any(!grepl("^[dkpcofgs]__", tokens)) || anyDuplicated(keys)) {
          check(FALSE, "input", "分类阶元前缀", paste0("Feature ID=", tab[["Feature ID"]][i], "；未知或重复阶元：", tab$Taxon[i]))
        }
        labels <- substring(tokens, 4L)
        labels[!nzchar(labels)] <- NA_character_
        rank_table[i, unname(ranks[keys])] <- labels
      }
      taxa <<- rank_table
      check(TRUE, "input", "分类阶元显式解析", paste0("分别保留d__/k__，未知阶元为NA；各阶元非缺失数：",
            paste(colnames(rank_table), colSums(!is.na(rank_table)), sep = "=", collapse = "；"), "；完整原始注释与Confidence随对象保留。"))
      tab
    })
    seqs <- section("input", function() {
      lines <- readLines(inputs[["sequences"]], warn = FALSE)
      check(length(lines) > 0L && startsWith(lines[1L], ">") && !any(!nzchar(lines)),
            "input", "FASTA 结构", paste0("文本行数=", length(lines), "；首行为标题且无空行。"))
      ids <- substring(lines[startsWith(lines, ">")], 2L)
      valid_ids(ids, "FASTA Feature ID（完整标题）")
      check(!any(grepl("[[:space:]]", ids)), "input", "FASTA 标题无隐式截断", "使用完整标题匹配，不截断或自动改名。")
      body <- lines[!startsWith(lines, ">")]
      check(all(grepl("^[ACGTRYSWKMBDHVNacgtryswkmbdhvn]+$", body)), "input", "DNA 序列字符", "仅接受IUPAC DNA字符；未删除非法字符。")
      dna <- Biostrings::readDNAStringSet(inputs[["sequences"]], format = "fasta", use.names = TRUE)
      check(identical(names(dna), ids) && all(BiocGenerics::width(dna) > 0L),
            "input", "FASTA 实际解析", sprintf("序列=%d；长度min=%d、max=%d；无空序列。", length(dna),
                    min(BiocGenerics::width(dna)), max(BiocGenerics::width(dna))))
      dna
    })
    meta <- section("input", function() {
      tab <- read_tsv(inputs[["metadata"]])
      check("sample-id" %in% names(tab), "input", "metadata ID 字段", paste0("实际字段：", paste(names(tab), collapse = ", ")))
      valid_ids(tab[["sample-id"]], "metadata 样本 ID")
      check(nrow(tab) == 33L, "input", "metadata 样本数", paste0("实际=", nrow(tab), "；预期=33"))
      rownames(tab) <- tab[["sample-id"]]
      nmissing <- vapply(tab, function(x) sum(missing(x)), 0L)
      check(!any(nmissing), "input", "metadata 缺失值盘点",
            paste0(paste(names(nmissing), nmissing, sep = "=", collapse = "；"), "；NA保持不变。"), FALSE, "WARNING")
      tab
    })
    section("input", function() {
      # Match embedded Artifact bytes to existing exports, without extracting files.
      for (pair in list(c("table_qza", "biom"), c("sequences_qza", "sequences"), c("taxonomy_qza", "taxonomy"))) {
        z <- utils::unzip(inputs[[pair[1L]]], list = TRUE)
        member <- z$Name[grepl(paste0("^[^/]+/data/", basename(inputs[[pair[2L]]]), "$"), z$Name)]
        check(length(member) == 1L, "input", paste0(pair[1L], "数据成员"), paste0("匹配成员数=", length(member)))
        con <- unz(inputs[[pair[1L]]], member, open = "rb")
        bytes <- tryCatch(readBin(con, what = "raw", n = z$Length[match(member, z$Name)]), finally = close(con))
        sha <- digest::digest(bytes, algo = "sha256", serialize = FALSE)
        check(identical(sha, fingerprint[[pair[2L]]]), "input", paste0(pair[1L], "与导出文件逐字节对应"),
              paste0("Artifact数据SHA-256=", sha, "；导出SHA-256=", fingerprint[[pair[2L]]]))
      }
    })
    if (!is.null(counts)) section("input", function() {
      con <- file(inputs[["biom"]], "rb")
      magic <- tryCatch(readBin(con, "raw", n = 8L), finally = close(con))
      is_hdf <- identical(magic, as.raw(c(137, 72, 68, 70, 13, 10, 26, 10)))
      biom <- if (is_hdf) biomformat::biom(biomformat::read_hdf5_biom(inputs[["biom"]])) else biomformat::read_biom(inputs[["biom"]])
      bm <- as.matrix(biomformat::biom_data(biom))
      valid_ids(rownames(bm), "BIOM Feature ID"); valid_ids(colnames(bm), "BIOM 样本 ID")
      same_ids(rownames(counts), rownames(bm), "ASV 与 BIOM Feature ID")
      same_ids(colnames(counts), colnames(bm), "ASV 与 BIOM 样本 ID")
      check(!anyNA(bm) && all(bm[rownames(counts), colnames(counts), drop = FALSE] == counts),
            "input", "TSV 与 Artifact 原始计数一致", sprintf("逐单元格比对=%d；不稀释、不归一化。", length(counts)))
    })
    if (!is.null(counts) && !is.null(taxonomy)) section("input", function() {
      same_ids(rownames(counts), taxonomy[["Feature ID"]], "ASV 与 taxonomy Feature ID")
    })
    if (!is.null(counts) && !is.null(seqs)) section("input", function() {
      same_ids(rownames(counts), names(seqs), "ASV 与 FASTA Feature ID")
    })
    if (!is.null(counts) && !is.null(meta)) section("input", function() {
      same_ids(colnames(counts), rownames(meta), "ASV 与 metadata 样本 ID")
    })
  }

  if (!is.null(meta)) section("design", function() {
    # These are structural checks on supplied records, not confirmation of their truth.
    for (field in c("reactor_id", "operation_phase", "phase_days", "phase_day_basis", "timepoint")) {
      present <- field %in% names(meta)
      check(present && !any(missing(meta[[field]])), "design", paste0("科研设计字段：", field),
            if (present) paste0("非缺失=", sum(!missing(meta[[field]])), "/", nrow(meta)) else "字段不存在。", FALSE)
    }
    group_ok <- "group" %in% names(meta) && !any(missing(meta$group)) && length(unique(meta$group)) == 5L
    check(group_ok, "design", "五组权威映射", if ("group" %in% names(meta))
      paste0("group缺失=", sum(missing(meta$group)), "；非缺失组数=", length(unique(stats::na.omit(meta$group)))) else
        "metadata不存在group字段；不从operation_phase、directory_group或样本名称推断。", FALSE)
    for (source_set in list(c("group_source", "metadata_source"), c("metadata_source", "condition_source"))) {
      present <- intersect(source_set, names(meta))
      covered <- rep(FALSE, nrow(meta))
      for (field in present) covered <- covered | !missing(meta[[field]])
      check(all(covered), "design", paste0("原始记录来源：", paste(source_set, collapse = "或")),
            paste0("有来源指向的样本=", sum(covered), "/", nrow(meta), "；缺少来源：", show_ids(rownames(meta)[!covered]),
                   "；来源字段是可追溯的必要条件，真实性仍需原始记录审阅。"), FALSE)
    }
    if ("operation_phase" %in% names(meta)) {
      phases <- table(meta$operation_phase, useNA = "ifany")
      warn("design", "运行阶段与实验分组分别记录", paste(names(phases), as.integer(phases), sep = "=", collapse = "；"))
    }
    if ("group" %in% names(meta)) {
      groups <- table(meta$group, useNA = "ifany")
      warn("inference", "组内样本量仅作描述", paste0(paste(names(groups), as.integer(groups), sep = "=", collapse = "；"),
           "；行数不等于独立生物重复数，未指定检验不能判定充分样本量。"))
    }
    if ("reactor_id" %in% names(meta)) {
      reactors <- table(meta$reactor_id, useNA = "ifany")
      check(!any(reactors > 1L), "inference", "同一反应器重复采样", paste0(
        paste(names(reactors), as.integer(reactors), sep = "=", collapse = "；"),
        "；不能默认各行独立。"), FALSE, "WARNING")
      if ("directory_group" %in% names(meta)) {
        neq <- !missing(meta$directory_group) & !missing(meta$reactor_id) & meta$directory_group != meta$reactor_id
        check(!any(neq), "design", "目录分组与反应器记录相符", paste0("不一致样本：", show_ids(rownames(meta)[neq])), FALSE)
      }
    }
    if ("phase_days" %in% names(meta)) {
      day <- suppressWarnings(as.numeric(meta$phase_days))
      bad <- missing(meta$phase_days) | !is.finite(day)
      check(!any(bad), "design", "采样日数值可解析", paste0("缺失或无法解析：", show_ids(rownames(meta)[bad])), FALSE)
      if (all(c("reactor_id", "phase_day_basis") %in% names(meta))) {
        key <- paste(meta$reactor_id, meta$phase_day_basis, meta$phase_days, sep = "\r")
        dup <- duplicated(key) | duplicated(key, fromLast = TRUE)
        check(!any(dup), "inference", "同反应器/时间依据/采样日重复记录", paste0("涉及：", show_ids(rownames(meta)[dup]),
              "；粒径分级或技术重复不能作为独立反应器重复。"), FALSE, "WARNING")
      }
    }
    if ("phase_day_basis" %in% names(meta)) {
      basis <- unique(stats::na.omit(meta$phase_day_basis))
      check(length(basis) == 1L, "inference", "时间坐标依据", paste0("不同说明=", length(basis), "；",
            paste(basis, collapse = "；"), "；未构造统一连续时间轴。"), FALSE, "WARNING")
      pooling <- grepl("混合|均分|pool", meta$phase_day_basis, ignore.case = TRUE)
      check(!any(pooling, na.rm = TRUE), "inference", "共享接种/混合来源", paste0(
        "涉及样本：", show_ids(rownames(meta)[which(pooling)]), "；需原始来源及谱系核验，不能据反应器标签推断独立性。"), FALSE, "WARNING")
    }
    for (field in c("biological_replicate", "metadata_source", "group_source", "DO_mg_L", "DO_status")) {
      warn("design", paste0("证据完整性：", field), if (field %in% names(meta))
        paste0("非缺失=", sum(!missing(meta[[field]])), "/", nrow(meta), "；内容真实性仍需原始记录核验。") else "字段不存在；不生成或填补。")
    }
    if ("metadata_review_notes" %in% names(meta)) {
      notes <- which(!missing(meta$metadata_review_notes))
      check(!length(notes), "design", "待确认采样条件", paste0(
        if (length(notes)) paste(rownames(meta)[notes], meta$metadata_review_notes[notes], sep = ": ", collapse = "；") else "无非缺失备注。",
        "；不把设定值或恢复条件当作采样实测值。"), FALSE, "WARNING")
    }
    warn("inference", "统计分析门控关闭", "本阶段不运行统计检验。五组定义及来源、独立实验单位、混合/分样谱系、重复类型、时间起点、组内独立样本量和组别/反应器/阶段混杂尚需针对具体方法验证；记录存在不等于真实性已确认。")
  })

  blockers <- function() any(checks$status == "FAIL" & checks$gate != "inference")
  if (!blockers() && all(vapply(list(counts, taxonomy, meta, seqs), function(x) !is.null(x), TRUE))) {
    section("object", function() {
      current_fingerprint <- vapply(inputs, function(p) digest::digest(file = p, algo = "sha256"), "")
      check(identical(current_fingerprint, fingerprint), "input", "构建前输入未改变", "重新计算全部8个输入SHA-256并与运行开始时逐项比对。")
      taxonomy <- taxonomy[match(rownames(counts), taxonomy[["Feature ID"]]), , drop = FALSE]
      meta <- meta[colnames(counts), , drop = FALSE]
      seqs <- seqs[rownames(counts)]
      taxa <- taxa[rownames(counts), , drop = FALSE]
      provenance <- list(inputs_sha256 = fingerprint, expected_samples = 33L,
                         expected_groups = 5L, counts_transform = "none",
                         statistics = "not run; independent design review required")
      ps <- phyloseq::phyloseq(phyloseq::otu_table(counts, taxa_are_rows = TRUE),
                              phyloseq::tax_table(taxa), phyloseq::sample_data(meta), seqs)
      attr(ps, "stage1_taxonomy") <- taxonomy
      check(verify_object(ps, counts, taxa, meta, seqs, taxonomy), "object", "内存对象完整核验",
            sprintf("nsamples=%d；ntaxa=%d；方向、全部计数、ID顺序、完整注释、metadata、代表序列及深度均与输入一致。", ncol(counts), nrow(counts)))
      attr(ps, "stage1_provenance") <- provenance
      if (file.exists(rds)) {
        previous <- readRDS(rds)
        check(identical(attr(previous, "stage1_provenance"), provenance) &&
                verify_object(previous, counts, taxa, meta, seqs, taxonomy), "object", "已有 RDS 安全复用",
              "要求已有对象输入指纹、参数及全部内容与当前输入一致；从不覆盖旧对象。")
        outcome <<- "复用已有 RDS；通过完整内容核验，未覆盖。"
      } else {
        dir.create(dirname(rds), recursive = TRUE, showWarnings = FALSE)
        temp_dir <- tempfile(".stage1-", tmpdir = dirname(rds))
        stopifnot(dir.create(temp_dir))
        on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
        temp_rds <- file.path(temp_dir, "candidate.rds")
        saveRDS(ps, temp_rds, version = 3, compress = "gzip")
        check(verify_object(readRDS(temp_rds), counts, taxa, meta, seqs, taxonomy), "object", "序列化往返核验", "候选 RDS 重新读取后逐项核验一致。")
        # Hard link within the same directory filesystem: atomic create, no overwrite.
        check(file.link(temp_rds, rds), "object", "最终 RDS 安全提交", "仅在目标不存在时原子创建；若目标已出现则失败，保留已有文件。")
        outcome <<- "已生成 RDS；输入、必要设计字段与对象往返核验通过；统计适用性仍未确认。"
      }
    })
  } else {
    warn("object", "对象保存被门控阻断", "存在输入/运行环境/阶段1必需设计检查FAIL；已完成可独立进行的基础核查。已有RDS（若存在）保持不变，不代表适用于当前输入。")
  }

  ended <- Sys.time()
  exit_code <- if (any(checks$status == "FAIL" & checks$gate != "design")) 1L else if (blockers()) 2L else 0L
  report_lines <- c(if (!file.exists(report)) "# Batch_01 阶段 1 综合质量报告" else character(), "",
    paste0("## 运行：", format(started, "%Y-%m-%d %H:%M:%S %Z", tz = "Asia/Shanghai")), "",
    paste0("- 项目目录：`", root, "`"),
    paste0("- 开始/结束（Asia/Shanghai）：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai"), " / ", format(ended, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai")),
    sprintf("- 用时：%.3f 秒；退出码：%d。", as.numeric(difftime(ended, started, units = "secs")), exit_code),
    paste0("- 阶段 1 状态：", if (exit_code == 0L) "PASS" else "FAIL", "；", outcome),
    "- 固定参数：样本数=33；五组字段=group；预期组数=5；异常标记=Tukey 1.5×IQR；无过滤、无稀释、无归一化、无统计检验。",
    "- 门控：input/runtime/design/object 的 FAIL 阻断 RDS；inference 检查仅控制后续统计适用性。WARNING 不删除、不自动修正数据。",
    "- taxonomy 只按显式d__/k__/p__/c__/o__/f__/g__/s__前缀解析阶元，缺失为NA；完整原始Taxon、Confidence及其他字段保存在对象stage1_taxonomy属性。",
    "- 相对丰度不代表绝对丰度；16S分类不代表功能基因或活性。", "",
    "### 实际检查", "", "| 状态 | 门控范围 | 检查 | 实际依据 |", "|---|---|---|---|",
    apply(checks, 1L, function(row) paste0("| ", paste(row, collapse = " | "), " |")), "", details,
    "### 输入清单及可复现性", "", "| 输入 | 字节数 | SHA-256 |", "|---|---:|---|",
    vapply(seq_along(inputs), function(i) paste0("| ", paths[i], " | ", file.info(inputs[i])$size, " | ",
      if (is.null(fingerprint)) "未计算" else fingerprint[i], " |"), ""), "",
    paste0("- 脚本：`", script, "`；SHA-256：", if (!is.na(script) && requireNamespace("digest", quietly = TRUE)) digest::digest(file = script, algo = "sha256") else "未计算"),
    paste0("- 复现命令：`Rscript --vanilla scripts/stage1_pipeline.R --project-root ", shQuote(root), "`。"),
    "- 重跑在本报告追加完整记录；已有对象仅在输入指纹及全部内容相同后复用。", "",
    "### 工具版本", "", "```text", capture.output(sessionInfo()), "```", "",
    "实现参考：[Bioconductor phyloseq 官方文档](https://www.bioconductor.org/packages/devel/bioc/vignettes/phyloseq/inst/doc/phyloseq-basics.html)。", "")
  dir.create(dirname(report), recursive = TRUE, showWarnings = FALSE)
  tryCatch({
    con <- file(report, open = "at", encoding = "UTF-8")
    tryCatch(writeLines(report_lines, con, useBytes = TRUE), finally = close(con))
  }, error = function(e) {
    cat("FAIL: 无法追加综合报告：", conditionMessage(e), "\n")
    exit_code <<- 1L
  })
  cat(sprintf("%s: PASS=%d WARNING=%d FAIL=%d；report=%s；exit=%d\n",
      if (exit_code == 0L) "PASS" else "FAIL", sum(checks$status == "PASS"),
      sum(checks$status == "WARNING"), sum(checks$status == "FAIL"), report, exit_code))
  cat(outcome, "\n")
  exit_code
}

# Build only the missing object from fingerprint-matched, previously checked inputs.
# Explicit opt-in for module 1.1; the original full-QC and review entries remain available.
stage1_build_confirmed <- function(root, analysis_dir) {
  started <- Sys.time()
  report <- file.path(root, "results/qc/stage1_report.md")
  old_report <- readBin(report, "raw", n = file.info(report)$size)
  checks <- data.frame(status = character(), item = character(), evidence = character())
  outcome <- "未保存对象"
  sha <- function(p) digest::digest(file = p, algo = "sha256")
  need <- function(ok, item, evidence) {
    checks[nrow(checks) + 1L, ] <<- c(if (isTRUE(ok)) "PASS" else "FAIL", item, evidence)
    if (!isTRUE(ok)) stop(paste(item, evidence, sep = ": "), call. = FALSE)
  }
  warn <- function(item, evidence) {
    checks[nrow(checks) + 1L, ] <<- c("WARNING", item, evidence)
  }
  inputs <- c(asv = "data/asv_table.tsv", taxonomy = "data/taxonomy.tsv",
    sequences = "data/exported_sequences/dna-sequences.fasta", metadata = "metadata/source_sample_metadata.tsv",
    biom = "data/exported_table/feature-table.biom", table_qza = "input/qiime2/table.qza",
    sequences_qza = "input/qiime2/rep-seqs.qza", taxonomy_qza = "input/qiime2/taxonomy.qza",
    design = "docs/batch_01/experiment_design.md", plan = "docs/batch_01/analysis_plan.md")
  fingerprints <- character()
  on.exit({
    lines <- c("", paste0("## 模块1.1授权的缺失对象构建：", format(started, "%Y-%m-%d %H:%M:%S", tz = "Asia/Shanghai")), "",
      "本次请求明确授权构建缺失phyloseq，取代此前暂缓对象交付的任务范围；沿用既有基础QC，未执行DADA2、分类器、Artifact解包或重复深度异常筛查。", "",
      paste0("结果：", outcome, "。构建通过仅允许描述性组成分析，不表示统计推断前提通过。"), "",
      "| 状态 | 核验 | 实际依据 |", "|---|---|---|",
      apply(checks, 1, function(x) paste0("| ", paste(gsub("|", "/", x, fixed = TRUE), collapse = " | "), " |")), "",
      "| 输入 | SHA-256 |", "|---|---|", paste0("| ", inputs[names(fingerprints)], " | ", fingerprints, " |"), "",
      paste0("- 派生metadata：", analysis_dir, "/analysis_metadata.tsv；原14列原值保留，新增分组和来源，不改写原表。"),
      "- 本次最新请求称G4四个初始样本DO设置不确定：分析字段设NA，设计文档曾记录的恢复设置3另列design_document_DO_*；全部采样实测DO为NA。未修改实验设计。",
      paste0("- 入口：scripts/stage1_pipeline.R --build-confirmed-design --analysis-dir ", analysis_dir),
      paste0("- 脚本SHA-256：", sha(file.path(root, "scripts/stage1_pipeline.R"))),
      paste0("- 工具：", R.version.string, "；phyloseq ", utils::packageVersion("phyloseq"),
        "；Biostrings ", utils::packageVersion("Biostrings"), "；digest ", utils::packageVersion("digest")),
      sprintf("- 用时：%.3f秒。", as.numeric(difftime(Sys.time(), started, units = "secs"))), "")
    stopifnot(identical(old_report, readBin(report, "raw", n = file.info(report)$size)))
    con <- file(report, "at", encoding = "UTF-8")
    tryCatch(writeLines(lines, con, useBytes = TRUE), finally = close(con))
  }, add = TRUE)
  need(all(vapply(c("phyloseq", "Biostrings", "digest"), requireNamespace, TRUE, quietly = TRUE)),
    "构建依赖", "使用现有R环境，不安装或更新软件。")
  paths <- file.path(root, inputs)
  names(paths) <- names(inputs)
  need(all(file.exists(paths)), "输入存在", paste(inputs, collapse = "; "))
  fingerprints <- vapply(paths, sha, "")
  previous_lines <- readLines(report, warn = FALSE)
  for (k in names(inputs)[1:8]) {
    expected <- paste0("| ", inputs[k], " | ", file.info(paths[k])$size, " | ", fingerprints[k], " |")
    need(any(previous_lines == expected), paste0("复用既有QC：", k),
      "当前大小及SHA-256与既有完整QC输入清单逐项一致；不重新解包或比较BIOM/QZA。")
  }
  design <- stage1_review_design(c("--project-root", root), return_design = TRUE)
  checks <- rbind(checks, design$checks)
  need(design$exit_code == 0L, "必需设计门控", "复用明确名单与设计断言，不由名称或operation_phase推断group。")
  meta <- design$metadata
  baseline <- meta$group == "G4" & meta$supplier_sample_id %in% c("E1", "F1", "G1", "H1")
  meta$design_document_DO_setpoint_mg_L <- meta$DO_setpoint_mg_L
  meta$design_document_DO_setting_text <- meta$DO_setting_text
  meta$analysis_metadata_version <- "module1.1_2026-11-03_v1"
  meta$DO_setting_review_status <- "documented_stage_setting"
  meta$DO_setting_review_status[baseline] <- "latest_request_uncertain_conflicts_with_design_document"
  for (field in c("DO_setpoint_mg_L", "DO_setting_text", "DO_setting_lower_mg_L", "DO_setting_upper_mg_L")) meta[baseline, field] <- NA_character_
  meta$DO_setting_context[baseline] <- "initial_recovered_baseline_setting_uncertain_latest_request"
  meta$condition_source[baseline] <- paste(meta$condition_source[baseline], "用户2026-11-03模块1.1请求：初期设置不确定", sep = ";")
  warn("初始设置来源冲突", "E1/F1/原G1/H1：本次请求设置不确定，分析值NA；文档历史恢复设置3保留于design_document_DO_*，不用于图中条件标签。")
  tab <- read.delim(paths["asv"], skip = 1, check.names = FALSE, quote = "", comment.char = "", row.names = 1)
  counts <- as.matrix(tab)
  need(is.numeric(counts) && !anyNA(counts) && all(is.finite(counts)) && all(counts >= 0) &&
    all(counts == floor(counts)) && !anyDuplicated(rownames(counts)) && !anyDuplicated(colnames(counts)) &&
    all(colSums(counts) > 0), "对象组装计数断言", "非负整数、无缺失、唯一ID及非空样本；不筛选、不稀释、不删除ASV；既有深度异常QC沿用。")
  annotation <- read.delim(paths["taxonomy"], check.names = FALSE, quote = "", comment.char = "", stringsAsFactors = FALSE)
  seqs <- Biostrings::readDNAStringSet(paths["sequences"])
  need(!anyDuplicated(annotation[["Feature ID"]]) && !anyDuplicated(names(seqs)) &&
    setequal(rownames(counts), annotation[["Feature ID"]]) && setequal(rownames(counts), names(seqs)) &&
    setequal(colnames(counts), meta[["sample-id"]]), "对象组装ID对齐", "count/taxonomy/FASTA的全部Feature ID及metadata全部SampleID一致。")
  annotation <- annotation[match(rownames(counts), annotation[["Feature ID"]]), , drop = FALSE]
  seqs <- seqs[rownames(counts)]
  meta <- meta[match(colnames(counts), meta[["sample-id"]]), , drop = FALSE]
  rownames(meta) <- meta[["sample-id"]]
  ranks <- c(d = "Domain", k = "Kingdom", p = "Phylum", c = "Class", o = "Order", f = "Family", g = "Genus", s = "Species")
  taxa <- matrix(NA_character_, nrow(counts), length(ranks), dimnames = list(rownames(counts), unname(ranks)))
  for (i in seq_len(nrow(annotation))) {
    tokens <- trimws(strsplit(annotation$Taxon[i], ";", fixed = TRUE)[[1]])
    keys <- sub("__.*$", "", tokens)
    stopifnot(all(keys %in% names(ranks)), !anyDuplicated(keys))
    labels <- substring(tokens, 4)
    labels[labels == ""] <- NA_character_
    taxa[i, ranks[keys]] <- labels
  }
  provenance <- list(inputs_sha256 = fingerprints, counts_transform = "none", metadata_version = unique(meta$analysis_metadata_version),
    builder = "stage1_build_confirmed_v1", statistics = "not run; descriptive analysis only")
  verify <- function(ps) {
    stored_meta <- data.frame(phyloseq::sample_data(ps), check.names = FALSE)
    isTRUE(methods::validObject(ps)) && phyloseq::taxa_are_rows(ps) &&
      identical(as(phyloseq::otu_table(ps), "matrix"), counts) &&
      identical(as(phyloseq::tax_table(ps), "matrix"), taxa) && identical(stored_meta, meta) &&
      identical(as.character(phyloseq::refseq(ps)), as.character(seqs)) &&
      identical(attr(ps, "stage1_taxonomy"), annotation) && identical(attr(ps, "stage1_provenance"), provenance)
  }
  ps <- phyloseq::phyloseq(phyloseq::otu_table(counts, taxa_are_rows = TRUE), phyloseq::tax_table(taxa), phyloseq::sample_data(meta), seqs)
  attr(ps, "stage1_taxonomy") <- annotation
  attr(ps, "stage1_provenance") <- provenance
  need(verify(ps), "对象全部内容核验", sprintf("%d个ASV × %d个样本，原始计数、全部分类、metadata及代表序列一致。", nrow(counts), ncol(counts)))
  need(identical(fingerprints, vapply(paths, sha, "")), "构建前输入保护", "全部输入SHA-256与运行开始一致。")
  rds <- file.path(root, "results/phyloseq/batch_01_phyloseq.rds")
  if (file.exists(rds)) {
    existing <- readRDS(rds)
    need(verify(existing), "已有对象兼容性", "逐项比较全部内容与来源；不兼容即FAIL，绝不覆盖。")
    ps <- existing
    outcome <- "复用已有兼容对象"
  } else {
    dir.create(dirname(rds), recursive = TRUE, showWarnings = FALSE)
    td <- tempfile(".stage1-module11-", tmpdir = dirname(rds))
    stopifnot(dir.create(td))
    on.exit(unlink(td, recursive = TRUE), add = TRUE)
    candidate <- file.path(td, "candidate.rds")
    saveRDS(ps, candidate, version = 3, compress = "gzip")
    need(verify(readRDS(candidate)), "序列化往返核验", "重读候选对象，逐项比较全部内容与来源。")
    need(file.link(candidate, rds), "安全提交对象", "目标不存在才创建硬链接，绝不覆盖。")
    outcome <- "生成results/phyloseq/batch_01_phyloseq.rds"
  }
  metadata_out <- file.path(analysis_dir, "analysis_metadata.tsv")
  need(!file.exists(metadata_out), "派生metadata不覆盖", metadata_out)
  write.table(meta, metadata_out, sep = "\t", row.names = FALSE, quote = FALSE, na = "NA", fileEncoding = "UTF-8")
  cat(outcome, "; derived metadata=", metadata_out, "\n")
  list(ps = ps, metadata = meta, checks = checks, inputs = paths, fingerprints = fingerprints, outcome = outcome)
}

if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  compact_report <- "--compact-report" %in% args
  if (compact_report && !"--review-design" %in% args) {
    stop("--compact-report requires --review-design", call. = FALSE)
  }
  args <- args[args != "--compact-report"]
  if ("--build-confirmed-design" %in% args) {
    status <- tryCatch({
      rest <- args[args != "--build-confirmed-design"]
      stopifnot(length(rest) == 2L, rest[1] == "--analysis-dir")
      root <- dirname(dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)))))
      out <- normalizePath(rest[2], mustWork = TRUE)
      stage1_build_confirmed(root, out)
      0L
    }, error = function(e) { message("FAIL: ", conditionMessage(e)); 1L })
  } else if ("--review-design" %in% args) {
    status <- stage1_review_design(args[args != "--review-design"], compact_report = compact_report)
  } else if ("--review-metadata" %in% args) {
    status <- stage1_review_metadata(args[args != "--review-metadata"])
  } else {
    status <- stage1_main(args)
  }
  quit(status = status, save = "no")
}
