# Figures for the main course (chapters/). Run from the project root:
#   Rscript scripts/course/figures.R
# Every number shown in a figure is computed here; chapters quote the same values.
suppressPackageStartupMessages({ library(ggplot2); library(patchwork); library(ragg) })
options(warn = 1)
out <- "assets/course"; dir.create(out, recursive = TRUE, showWarnings = FALSE)
set.seed(20261002)

# ---- shared style -----------------------------------------------------------------------
blue <- "#2a78d6"; orange <- "#eb6834"; aqua <- "#1baf7a"; yellow <- "#eda100"
violet <- "#4a3aa7"; red <- "#e34948"; ink <- "#0b0b0b"; ink2 <- "#52514e"; grid_col <- "#e6e5e0"
theme_course <- function(base = 13) {
  theme_minimal(base_size = base) +
    theme(text = element_text(colour = ink), axis.text = element_text(colour = ink2),
          panel.grid.major = element_line(colour = grid_col, linewidth = 0.35),
          panel.grid.minor = element_blank(), plot.title = element_text(face = "bold", size = base + 1),
          plot.title.position = "plot", plot.subtitle = element_text(colour = ink2),
          legend.position = "top", legend.justification = "left", legend.title = element_blank(),
          plot.tag = element_text(face = "bold"), plot.background = element_rect(fill = "white", colour = NA))
}
theme_set(theme_course())
wrap_labels <- function(p, w) {                       # wrap long titles/subtitles to the figure width
  width <- floor(w * 10.5)
  wrapit <- function(x) if (is.null(x) || is.expression(x)) x else paste(strwrap(gsub("\n", " ", x), width), collapse = "\n")
  if (inherits(p, "patchwork")) {
    p$patches$annotation$title <- wrapit(p$patches$annotation$title)
    p$patches$annotation$subtitle <- wrapit(p$patches$annotation$subtitle)
  } else {
    p$labels$title <- wrapit(p$labels$title); p$labels$subtitle <- wrapit(p$labels$subtitle)
  }
  p
}
save <- function(p, name, w = 9, h = 4.6) {
  p <- wrap_labels(p, w)
  ggsave(file.path(out, paste0(name, ".png")), p, width = w, height = h, dpi = 170, device = ragg::agg_png, bg = "white")
  cat("saved", name, "\n")
}
tile_theme <- theme(axis.text = element_blank(), axis.title = element_blank(), panel.grid = element_blank())

# ===================================================================== Chapter 1
# Monday problem: no drug effect; afternoon adds +4. Confounded vs balanced designs.
mk <- function(design) {
  n <- 6
  grp <- rep(c("Vehicle", "Drug"), each = n)
  session <- if (design == "confounded") rep(c("Mon AM", "Fri PM"), each = n) else rep(rep(c("Mon AM", "Fri PM"), each = 3), 2)
  y <- 20 + 4 * (session == "Fri PM") + rnorm(2 * n, 0, 1.5)
  data.frame(design, grp = factor(grp, c("Vehicle", "Drug")), session, y)
}
d1 <- rbind(mk("confounded"), mk("balanced"))
d1$design <- factor(d1$design, c("confounded", "balanced"),
                    c("Confounded: groups processed on different days", "Balanced: both groups on both days"))
p <- ggplot(d1, aes(grp, y, colour = session)) +
  geom_point(size = 3.2, position = position_jitter(width = 0.12, seed = 1)) +
  stat_summary(aes(group = 1), fun = mean, geom = "crossbar", width = 0.45, colour = ink, linewidth = 0.4) +
  facet_wrap(~ design) + scale_colour_manual(values = c("Mon AM" = blue, "Fri PM" = orange), breaks = c("Mon AM", "Fri PM")) +
  labs(x = NULL, y = "Hormone level", title = "The Monday problem: the drug has NO effect in either panel",
       subtitle = "Left: the afternoon effect masquerades as a drug effect. Right: it affects both groups equally.")
save(p, "ch01-monday-problem")

# Bias vs precision: confounded design with growing n -> CI shrinks around the WRONG value (true effect 0)
bp <- do.call(rbind, lapply(c(6, 12, 24, 48, 96), function(n) {
  y0 <- 20 + rnorm(n, 0, 1.5); y1 <- 24 + rnorm(n, 0, 1.5)
  tt <- t.test(y1, y0); data.frame(n, est = unname(diff(rev(tt$estimate))) * -1, lo = tt$conf.int[1], hi = tt$conf.int[2])
}))
bp$est <- with(bp, (lo + hi) / 2)
p <- ggplot(bp, aes(factor(n), est)) +
  geom_hline(yintercept = 0, colour = aqua, linewidth = 1) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.15, colour = orange, linewidth = 0.8) +
  geom_point(size = 3, colour = orange) +
  annotate("text", x = 0.6, y = 0.35, label = "true drug effect = 0", colour = aqua, hjust = 0, size = 4) +
  labs(x = "Mice per group (still processed on different days)", y = "Estimated drug effect (95% CI)",
       title = "More mice make a biased estimate more precise, not more correct")
save(p, "ch01-bias-vs-precision", h = 4.2)

# ===================================================================== Chapter 3
icc_grid <- expand.grid(m = c(1, 2, 5, 10, 20, 50, 100, 200, 500), icc = c(0.05, 0.1, 0.3, 0.5))
icc_grid$neff <- 4 * icc_grid$m / (1 + (icc_grid$m - 1) * icc_grid$icc)
p <- ggplot(icc_grid, aes(m, neff, colour = factor(icc))) +
  geom_line(linewidth = 1) + geom_point(size = 2) +
  scale_x_log10(breaks = c(1, 5, 10, 50, 100, 500)) +
  scale_colour_manual(values = c(blue, aqua, orange, violet), labels = function(x) paste0("ICC = ", x)) +
  geom_hline(yintercept = 4, linetype = "22", colour = ink2) +
  annotate("label", x = 500, y = 4, label = "4 animals = 4 truly independent units", vjust = -0.35, hjust = 1,
           colour = ink2, size = 3.8, fill = "white", label.size = 0, label.padding = unit(0.12, "lines")) +
  labs(x = "Cells measured per animal (log scale)", y = "Effective sample size",
       title = "Measuring more cells per animal soon stops adding information",
       subtitle = "4 animals per group; effective n = 4m/(1 + (m - 1) ICC)")
save(p, "ch03-design-effect")

# SuperPlot: 3 independent experiments x ~40 cells per condition, no true effect
# no true treatment effect, but each experiment's treated wells drift by chance (day-specific response)
set.seed(31)
sp <- do.call(rbind, lapply(1:3, function(e) {
  shift <- rnorm(1, 0, 3); exp_trt <- rnorm(1, 0, 2.5)
  data.frame(experiment = paste("Experiment", e), condition = rep(c("Control", "Treated"), each = 60),
             value = 50 + shift + c(rep(0, 60), rep(exp_trt, 60)) + rnorm(120, 0, 6))
}))
spm <- aggregate(value ~ experiment + condition, sp, mean)
# false-positive rates over many such experiments (no true effect, day-specific responses)
fp_sp <- t(replicate(2000, {
  d <- do.call(rbind, lapply(1:3, function(e) data.frame(e, cond = rep(0:1, each = 60),
          v = rnorm(1, 0, 3) + c(rep(0, 60), rep(rnorm(1, 0, 2.5), 60)) + rnorm(120, 0, 6))))
  m <- aggregate(v ~ e + cond, d, mean)
  c(t.test(v ~ cond, data = d)$p.value < 0.05,
    t.test(m$v[m$cond == 1], m$v[m$cond == 0], paired = TRUE)$p.value < 0.05)
}))
p_cells <- t.test(value ~ condition, data = sp)$p.value
p_exp <- t.test(spm$value[spm$condition == "Treated"], spm$value[spm$condition == "Control"], paired = TRUE)$p.value
p <- ggplot(sp, aes(condition, value, colour = experiment)) +
  geom_point(alpha = 0.35, size = 1.6, position = position_jitter(width = 0.18, seed = 2)) +
  geom_point(data = spm, size = 6, shape = 21, fill = "white", stroke = 1.6) +
  geom_line(data = spm, aes(group = experiment), linewidth = 0.8) +
  scale_colour_manual(values = c(blue, orange, aqua)) +
  labs(x = NULL, y = "Measurement per cell",
       title = "A SuperPlot: small dots = cells, big circles = independent experiments",
       subtitle = sprintf("No true treatment effect. Over 2,000 simulated experiments like this one, testing cells as n gives a false positive %.0f%% of the time; testing the 3 experiment means gives %.0f%%.",
                    100 * mean(fp_sp[, 1]), 100 * mean(fp_sp[, 2])))
save(p, "ch03-superplot")

# ===================================================================== Chapter 4
# Haphazard selection: catching mice -> slower (heavier) mice caught first and put in control
hap <- t(replicate(4000, {
  w <- rnorm(12, 25, 2)
  catch_order <- order(w + rnorm(12, 0, 1.5), decreasing = TRUE)        # heavier caught first
  haph <- mean(w[catch_order[7:12]]) - mean(w[catch_order[1:6]])        # first 6 -> control
  rnd <- sample(12); random <- mean(w[rnd[7:12]]) - mean(w[rnd[1:6]])
  c(haphazard = haph, randomized = random)
}))
hd <- data.frame(diff = c(hap[, 1], hap[, 2]), method = rep(c("Haphazard: first six caught -> control", "Randomized with software"), each = nrow(hap)))
p <- ggplot(hd, aes(diff, fill = method)) +
  geom_histogram(bins = 60, position = "identity", alpha = 0.65, colour = "white", linewidth = 0.2) +
  geom_vline(xintercept = 0, colour = ink, linewidth = 0.5) +
  scale_fill_manual(values = c(orange, blue)) +
  labs(x = "Baseline weight difference, Drug - Control group (g)", y = "Simulated experiments",
       title = "Haphazard allocation builds in a systematic difference before treatment starts",
       subtitle = sprintf("Mean baseline difference: haphazard %.2f g, randomized %.2f g (4,000 simulated experiments)",
                          mean(hap[, 1]), mean(hap[, 2])))
save(p, "ch04-haphazard-vs-random")

# Plate layouts and an edge effect
plate <- expand.grid(col = 1:12, row = 1:8)
plate$edge <- with(plate, row %in% c(1, 8) | col %in% c(1, 12))
plate$signal <- 100 - 12 * plate$edge - 1.2 * plate$col + rnorm(96, 0, 1.5)   # edge loss + left-to-right drift
plate$by_column <- ifelse(plate$col <= 6, "Control", "Drug")
set.seed(5); inner <- which(!plate$edge)
plate$randomized <- "buffer"; plate$randomized[inner] <- sample(rep(c("Control", "Drug"), length.out = length(inner)))
pl <- function(fill, title, pal) ggplot(plate, aes(col, -row, fill = .data[[fill]])) + geom_tile(colour = "white", linewidth = 0.8) +
  coord_equal() + scale_fill_manual(values = pal) + labs(title = title) + tile_theme + theme(legend.position = "bottom")
p_heat <- ggplot(plate, aes(col, -row, fill = signal)) + geom_tile(colour = "white", linewidth = 0.8) + coord_equal() +
  scale_fill_gradient(low = "#fdeee7", high = blue, name = "signal") + labs(title = "Hidden plate effects") +
  tile_theme + theme(legend.position = "bottom", legend.title = element_text())
p <- p_heat + pl("by_column", "Layout A: by column", c(Control = blue, Drug = orange)) +
  pl("randomized", "Layout B: randomized, no edges", c(Control = blue, Drug = orange, buffer = "grey85")) +
  plot_annotation(title = "Position on a plate is a nuisance factor", subtitle = "Layout A aligns treatment with edge and gradient effects; Layout B breaks the link.")
save(p, "ch04-plate-layouts", w = 11, h = 4.4)

# ===================================================================== Chapter 5
# Batch layouts as tiles
bl <- expand.grid(pos = 1:8, batch = c("Batch 1", "Batch 2"), design = c("Confounded", "Blocked and randomized"))
bl$group <- ifelse(bl$design == "Confounded", ifelse(bl$batch == "Batch 1", "Control", "Treated"), NA)
set.seed(8); for (b in c("Batch 1", "Batch 2")) bl$group[bl$design != "Confounded" & bl$batch == b] <- sample(rep(c("Control", "Treated"), 4))
p <- ggplot(bl, aes(pos, batch, fill = group)) + geom_tile(colour = "white", linewidth = 2, height = 0.85) +
  facet_wrap(~ design, ncol = 1) + scale_fill_manual(values = c(Control = blue, Treated = orange)) +
  labs(title = "Sixteen samples, two processing batches", subtitle = "Top: batch = treatment, so they cannot be separated. Bottom: every batch contains both groups.") +
  theme(axis.text.x = element_blank(), axis.title = element_blank(), panel.grid = element_blank(), strip.text = element_text(face = "bold", hjust = 0))
save(p, "ch05-batch-layouts", h = 4)

# Litter pairing (worked example data)
ctrl <- c(12.1, 15.3, 9.8, 18.2, 11.5, 14.9); drug <- c(13.4, 16.9, 10.6, 19.9, 12.8, 16.1)
lp <- data.frame(litter = factor(rep(1:6, 2)), group = factor(rep(c("Vehicle", "Drug"), each = 6), c("Vehicle", "Drug")), y = c(ctrl, drug))
pu <- signif(t.test(drug, ctrl, var.equal = TRUE)$p.value, 2); pp <- signif(t.test(drug, ctrl, paired = TRUE)$p.value, 2)
p1 <- ggplot(lp, aes(group, y)) + geom_point(size = 3.5, colour = ink2, position = position_jitter(width = 0.08, seed = 3)) +
  labs(x = NULL, y = "Blood marker", title = "Ignoring litters", subtitle = sprintf("unpaired t-test: p = %s", pu))
p2 <- ggplot(lp, aes(group, y, group = litter, colour = litter)) + geom_line(linewidth = 1) + geom_point(size = 3.5) +
  scale_colour_manual(values = c(blue, orange, aqua, yellow, violet, red)) + guides(colour = "none") +
  labs(x = NULL, y = NULL, title = "Comparing within litters", subtitle = sprintf("paired t-test: p = %s", pp))
p <- p1 + p2 + plot_annotation(title = "Same 12 animals: every line goes up, but litters differ a lot",
                                subtitle = "Blocking (pairing) removes litter-to-litter variation from the comparison.")
save(p, "ch05-litter-pairing", h = 4.4)

# ===================================================================== Chapter 7
# Anatomy of a dose-response curve: what each part of the curve needs in order to be estimated
ec50 <- 1; hill <- 1.2; bottom <- 2; top <- 100
curve4pl <- function(x) bottom + (top - bottom) / (1 + (ec50 / x)^hill)
dr_line <- data.frame(x = 10^seq(-3, 3, length.out = 400)); dr_line$y <- curve4pl(dr_line$x)
dr_pts <- data.frame(x = 10^seq(-2.5, 2.5, by = 5/6)); dr_pts$y <- curve4pl(dr_pts$x)   # 7 log-spaced doses
p <- ggplot(dr_line, aes(x, y)) +
  annotate("rect", xmin = 10^-3, xmax = 10^-1.4, ymin = -Inf, ymax = Inf, fill = blue, alpha = 0.07) +
  annotate("rect", xmin = 10^1.4, xmax = 10^3, ymin = -Inf, ymax = Inf, fill = orange, alpha = 0.07) +
  geom_line(linewidth = 1.2, colour = ink2) +
  geom_point(data = dr_pts, size = 3.4, colour = violet) +
  geom_segment(x = log10(ec50), xend = log10(ec50), y = 0, yend = curve4pl(ec50), linetype = "22", colour = aqua) +
  annotate("text", x = 10^-2.2, y = top * 0.93, label = "lower plateau\n(no effect)", colour = blue, size = 3.9, hjust = 0.5) +
  annotate("text", x = 10^2.2, y = top * 0.35, label = "upper plateau\n(maximal effect)", colour = orange, size = 3.9, hjust = 0.5) +
  annotate("text", x = ec50 * 1.25, y = 8, label = "EC50", colour = aqua, size = 4, hjust = 0) +
  scale_x_log10(breaks = 10^(-3:3), labels = c("0.001", "0.01", "0.1", "1", "10", "100", "1000")) +
  labs(x = "Concentration (log scale, arbitrary units)", y = "Response (% of maximum)",
       title = "A dose-response curve has four features to estimate",
       subtitle = "Lower plateau, upper plateau, slope and EC50. Points show 7 log-spaced doses spanning no effect to maximal effect; a single concentration estimates none of them.")
save(p, "ch07-dose-response-anatomy", w = 9, h = 4.8)

fx <- data.frame(genotype = rep(c("WT", "KO"), 2), treatment = factor(rep(c("Vehicle", "Drug"), each = 2), c("Vehicle", "Drug")),
                 y = c(10, 14, 12, 24))
p <- ggplot(fx, aes(treatment, y, colour = genotype, group = genotype)) + geom_line(linewidth = 1.3) + geom_point(size = 4) +
  scale_colour_manual(values = c(WT = blue, KO = orange)) +
  annotate("text", x = 2.08, y = 12, label = "+2", colour = blue, hjust = 0, size = 5) +
  annotate("text", x = 2.08, y = 24, label = "+10", colour = orange, hjust = 0, size = 5) +
  labs(x = NULL, y = "Tumour growth (mm³/day)", title = "Interaction = difference of differences = 10 - 2 = 8",
       subtitle = "Parallel lines would mean no interaction; diverging lines mean the drug works differently by genotype.")
save(p, "ch07-interaction", w = 7.5, h = 4.6)

fx2 <- data.frame(genotype = rep(c("WT", "KO"), 2), treatment = factor(rep(c("Vehicle", "Drug"), each = 2), c("Vehicle", "Drug")), y = c(5, 5, 9, 6))
p <- ggplot(fx2, aes(treatment, y, colour = genotype, group = genotype)) + geom_line(linewidth = 1.3) + geom_point(size = 4) +
  scale_colour_manual(values = c(WT = blue, KO = orange)) +
  labs(x = NULL, y = "Outcome", title = "Q3: WT effect +4, KO effect +1, interaction = -3")
save(p, "ch07-answer-q3", w = 6, h = 3.6)

sig <- function(x) 100 / (1 + (1 / x)^1.2)                          # EC50 = 1 uM
curve_df <- data.frame(x = 10^seq(-3, 3, length.out = 300)); curve_df$y <- sig(curve_df$x)
pts <- rbind(data.frame(design = "Linear spacing: 0.5, 1, 1.5, 2 uM", x = c(0.5, 1, 1.5, 2)),
             data.frame(design = "Log spacing: 0.01 to 30 uM", x = c(0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30)))
pts$y <- sig(pts$x)
p <- ggplot(curve_df, aes(x, y)) + geom_line(colour = "grey70", linewidth = 1) +
  geom_point(data = pts, aes(colour = design), size = 3.5) + facet_wrap(~ design) +
  scale_x_log10(labels = function(b) format(b, scientific = FALSE, drop0trailing = TRUE)) +
  scale_colour_manual(values = c(orange, blue)) + guides(colour = "none") +
  labs(x = "Concentration (uM, log scale)", y = "Response (%)", title = "Only log spacing reveals the bottom, top and slope of the curve")
save(p, "ch07-dose-spacing", h = 4)

# ===================================================================== Chapter 8
pw <- expand.grid(n = 2:60, d = c(0.5, 0.8, 1.2))
pw$power <- mapply(function(n, d) power.t.test(n = n, delta = d)$power, pw$n, pw$d)
p <- ggplot(pw, aes(n, power, colour = factor(d))) + geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.8, linetype = "22", colour = ink2) +
  scale_colour_manual(values = c(orange, blue, aqua), labels = function(x) paste0("d = ", x)) +
  scale_y_continuous(labels = scales::percent) +
  annotate("text", x = 3, y = 0.17, label = sprintf("n = 3: %.0f%% power even for d = 1.2", 100 * power.t.test(n = 3, delta = 1.2)$power), hjust = 0, size = 3.8) +
  labs(x = "Units per group", y = "Power", title = "How power grows with sample size", subtitle = "Two-group comparison, alpha = 0.05; dashed line = 80%")
save(p, "ch08-power-curves")

tm <- t(replicate(20000, { a <- rnorm(5); b <- rnorm(5, 0.5); tt <- t.test(b, a, var.equal = TRUE); c(diff(c(mean(a), mean(b))), tt$p.value) }))
tmd <- data.frame(est = tm[, 1], sig = ifelse(tm[, 2] < 0.05, "significant (p < 0.05)", "not significant"))
p <- ggplot(tmd, aes(est, fill = sig)) + geom_histogram(bins = 70, colour = "white", linewidth = 0.15) +
  geom_vline(xintercept = 0.5, colour = ink, linewidth = 0.8) +
  annotate("text", x = 0.55, y = Inf, label = "true effect = 0.5", vjust = 1.5, hjust = 0, size = 4) +
  scale_fill_manual(values = c("not significant" = "grey80", "significant (p < 0.05)" = orange)) +
  labs(x = "Estimated effect (n = 5 per group, true d = 0.5)", y = "Simulated studies",
       title = "The significance filter: small studies that 'work' overestimate the effect",
       subtitle = sprintf("Power %.0f%%; mean estimate among significant studies = %.2f (true 0.5); %.1f%% of them have the wrong sign",
                          100 * mean(tm[, 2] < 0.05), mean(tm[tm[, 2] < 0.05, 1]), 100 * mean(tm[tm[, 2] < 0.05, 1] < 0)))
save(p, "ch08-type-m")

# Three conclusions from a confidence interval, against pre-specified bounds of +/- 3 points
ci <- data.frame(
  case = factor(c("Inconclusive", "Practically small", "Meaningful reduction"),
                levels = c("Meaningful reduction", "Practically small", "Inconclusive")),
  est = c(-1, -0.2, -4), lo = c(-6, -1, -5), hi = c(4, 0.6, -3.2))
p <- ggplot(ci, aes(est, case)) +
  annotate("rect", xmin = -3, xmax = 3, ymin = -Inf, ymax = Inf, fill = aqua, alpha = 0.10) +
  geom_vline(xintercept = c(-3, 3), linetype = "22", colour = aqua) +
  geom_vline(xintercept = 0, colour = grid_col) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.18, linewidth = 1.1, colour = ink2) +
  geom_point(size = 3.6, colour = orange) +
  annotate("text", x = 0, y = 3.42, label = "bounds of practical importance", colour = aqua, size = 3.9) +
  scale_x_continuous(breaks = seq(-6, 4, 2)) +
  labs(x = "Change in liver fat (percentage points)", y = NULL,
       title = "Read the interval, not only whether it excludes zero",
       subtitle = "All three intervals contain effects below zero, but they support different conclusions once a smallest important change is fixed in advance.")
save(p, "ch08-ci-conclusions", w = 9, h = 3.9)

# ===================================================================== Chapter 9
cw <- data.frame(n = 20:1000); cw$half <- 1.96 * sqrt(0.25 / cw$n) * 100
p <- ggplot(cw, aes(n, half)) + geom_line(colour = blue, linewidth = 1.2) +
  geom_point(data = data.frame(n = c(97, 385), half = 1.96 * sqrt(0.25 / c(97, 385)) * 100), colour = orange, size = 3.5) +
  annotate("text", x = c(110, 400), y = c(10.6, 5.6), label = c("n = 97: +/- 10 points", "n = 385: +/- 5 points"), hjust = 0, size = 4) +
  labs(x = "Sample size", y = "Half-width of 95% CI (percentage points)", title = "Precision of a prevalence estimate (p = 0.5)",
       subtitle = "Halving the margin of error needs four times the sample")
save(p, "ch09-precision", w = 8, h = 4.2)

# ===================================================================== Chapter 11
# Collider bias: A and B independent; hospitalized if A + B high
n <- 4000; A <- rnorm(n); B <- rnorm(n); hosp <- (A + B + rnorm(n, 0, 0.5)) > 1.5
cd <- data.frame(A, B, group = ifelse(hosp, "hospitalized", "not hospitalized"))
r_all <- cor(A, B); r_h <- cor(A[hosp], B[hosp])
p <- ggplot(cd, aes(A, B, colour = group)) + geom_point(size = 0.8, alpha = 0.5) +
  geom_smooth(data = subset(cd, hosp), method = "lm", se = FALSE, colour = orange, linewidth = 1.2) +
  scale_colour_manual(values = c(hospitalized = orange, "not hospitalized" = "grey75")) +
  labs(x = "Disease A severity", y = "Disease B severity", title = "Collider bias: selecting on a common effect creates a fake association",
       subtitle = sprintf("Everyone: r = %.2f   |   hospitalized only: r = %.2f", r_all, r_h))
save(p, "ch11-collider", w = 8, h = 5)

# Immortal time timeline
it <- data.frame(id = factor(1:6, 6:1), start = 0, end = c(9, 12, 2, 1.5, 10, 11),
                 rx = c(3, 6, NA, NA, 4, NA), died = c(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE))
p <- ggplot(it) + geom_segment(aes(x = start, xend = end, y = id, yend = id), linewidth = 2, colour = "grey75") +
  geom_segment(data = subset(it, !is.na(rx)), aes(x = start, xend = rx, y = id, yend = id), linewidth = 2, colour = orange) +
  geom_point(data = subset(it, !is.na(rx)), aes(x = rx, y = id), size = 4, colour = blue) +
  geom_point(data = subset(it, died), aes(x = end, y = id), shape = 4, size = 5, stroke = 1.6, colour = red) +
  labs(x = "Months since hospital admission (time zero)", y = "Patient",
       title = "Immortal time: users had to survive until their first prescription",
       subtitle = "Orange = time before the prescription (blue dot) — counted as 'treated' survival; X = death. Early deaths can only be non-users.")
save(p, "ch11-immortal-time", w = 9, h = 4.2)

# ===================================================================== Chapter 12
lk <- read.csv("data/course_leakage_sim.csv")
p <- ggplot(lk, aes(design, accuracy, fill = design)) + geom_boxplot(width = 0.5, outlier.shape = NA, alpha = 0.8) +
  geom_point(position = position_jitter(width = 0.12, seed = 1), size = 1.6, alpha = 0.6) +
  geom_hline(yintercept = 0.5, linetype = "22", colour = ink2) +
  scale_fill_manual(values = c(orange, blue)) + guides(fill = "none") + scale_y_continuous(labels = scales::percent) + coord_cartesian(ylim = c(0, 1)) +
  labs(x = NULL, y = "Cross-validated accuracy", title = "Leakage finds a classifier in pure noise",
       subtitle = sprintf("50 noise datasets: selection outside CV %.1f%%, inside CV %.1f%% (chance = 50%%)",
                          100 * mean(lk$accuracy[lk$design == "Feature selection BEFORE CV (leaky)"]), 100 * mean(lk$accuracy[lk$design == "Feature selection INSIDE CV (correct)"])))
save(p, "ch12-leakage", w = 8, h = 4.4)

gs <- expand.grid(sample = 1:4, patient = paste("Patient", LETTERS[1:6]))
set.seed(12); gs$random <- sample(rep(c("train", "test"), c(18, 6)))
gs$grouped <- ifelse(gs$patient %in% c("Patient B", "Patient E"), "test", "train")
gl <- rbind(data.frame(gs[, 1:2], split = "Random split of samples (leaky)", set = gs$random),
            data.frame(gs[, 1:2], split = "Grouped split by patient (correct)", set = gs$grouped))
p <- ggplot(gl, aes(sample, patient, fill = set)) + geom_tile(colour = "white", linewidth = 1.5) + facet_wrap(~ split) +
  scale_fill_manual(values = c(train = blue, test = orange)) + labs(x = "Sample from that patient", y = NULL,
  title = "Same patient in training and test = the model can memorize the patient") + theme(panel.grid = element_blank())
save(p, "ch12-grouped-split", h = 3.8)

# ===================================================================== Chapter 13
surf <- function(T, pH) { u <- (T - pH) / sqrt(2); v <- (T + pH) / sqrt(2) - 1.1; 75 - 14 * u^2 - 2.5 * v^2 }
sg <- expand.grid(T = seq(-1.5, 1.5, length.out = 150), pH = seq(-1.5, 1.5, length.out = 150)); sg$yield <- surf(sg$T, sg$pH)
lv <- seq(-1.5, 1.5, by = 0.25)
t1 <- lv[which.max(surf(lv, -1))]                 # step 1: vary T at the starting pH (-1)
p1 <- lv[which.max(surf(t1, lv))]                 # step 2: vary pH at that "best" T
ofat <- rbind(data.frame(T = lv, pH = -1, step = "1"), data.frame(T = t1, pH = lv, step = "2"))
ofat_end <- data.frame(T = t1, pH = p1); best <- sg[which.max(sg$yield), ]
ccd <- data.frame(T = c(-1, 1, -1, 1, 0, -1.41, 1.41, 0, 0), pH = c(-1, -1, 1, 1, 0, 0, 0, -1.41, 1.41))
p <- ggplot(sg, aes(T, pH)) + geom_raster(aes(fill = yield)) +
  geom_contour(aes(z = yield), colour = "white", alpha = 0.7, breaks = seq(0, 75, by = 5)) +
  scale_fill_gradient(low = "#fdeee7", high = blue, guide = "none") +
  geom_point(data = ccd, shape = 22, size = 4.5, fill = "white", colour = ink, stroke = 1.1) +
  geom_path(data = ofat, aes(group = step), colour = orange, linewidth = 1.1) +
  geom_point(data = ofat, colour = orange, size = 1.8) +
  geom_point(data = ofat_end, colour = orange, size = 5, shape = 21, fill = "white", stroke = 2) +
  geom_point(data = best, shape = 8, size = 6, colour = ink, stroke = 1.5) +
  annotate("label", x = ofat_end$T, y = ofat_end$pH, label = sprintf("OFAT stops here\n(yield %.0f)", surf(ofat_end$T, ofat_end$pH)),
           hjust = -0.12, vjust = 1.1, size = 3.6, colour = orange, label.size = 0) +
  annotate("label", x = best$T, y = best$pH, label = sprintf("true optimum\n(yield %.0f)", best$yield), hjust = 1.15, vjust = -0.2, size = 3.6, label.size = 0) +
  coord_equal(expand = FALSE) +
  labs(x = "Temperature (coded)", y = "pH (coded)", title = "OFAT gets stuck on a diagonal ridge",
       subtitle = "Orange: vary T at pH = -1, then pH at the best T. Squares: a central composite\ndesign that maps the whole region, including the interaction.")
save(p, "ch13-ofat-vs-doe", w = 7.5, h = 7.6)

# ===================================================================== Chapter 14
zp <- function(mp, sp, mn, sn) 1 - 3 * (sp + sn) / abs(mp - mn)
zd <- rbind(data.frame(assay = sprintf("Robust assay (Z' = %.2f)", zp(1000, 28.3, 100, 8)), control = rep(c("positive", "negative"), each = 400),
                       signal = c(rnorm(400, 1000, 28.3), rnorm(400, 100, 8))),
            data.frame(assay = sprintf("Noisy assay (Z' = %.2f)", zp(966.7, 292.7, 100, 8)), control = rep(c("positive", "negative"), each = 400),
                       signal = c(rnorm(400, 966.7, 292.7), rnorm(400, 100, 8))))
p <- ggplot(zd, aes(signal, fill = control)) + geom_density(alpha = 0.7, colour = NA) + facet_wrap(~ assay, ncol = 1, scales = "free_y") +
  scale_fill_manual(values = c(positive = orange, negative = blue)) +
  labs(x = "Signal", y = NULL, title = "Z' compares the gap between controls with their spread",
       subtitle = "Same mean signal; the noisy assay's positive controls overlap the background region") + theme(axis.text.y = element_blank())
save(p, "ch14-zprime", w = 8.5, h = 5)

# ===================================================================== Chapter 15
a <- c(5.1, 6.3, 7.8, 4.9, 9.2, 6.7, 8.1, 5.5, 7.0, 6.1); b <- c(5.6, 6.9, 8.1, 5.6, 10.0, 7.1, 8.9, 6.0, 7.4, 6.8)
ba <- data.frame(a, b, m = (a + b) / 2, d = b - a); bias <- mean(ba$d); loa <- bias + c(-1.96, 1.96) * sd(ba$d)
p1 <- ggplot(ba, aes(a, b)) + geom_abline(slope = 1, intercept = 0, linetype = "22", colour = ink2) + geom_point(size = 3, colour = blue) +
  coord_equal(xlim = c(4.5, 10.5), ylim = c(4.5, 10.5)) + labs(x = "Lab analyser (A)", y = "New device (B)", title = sprintf("Correlation: r = %.3f", cor(a, b)), subtitle = "dashed = perfect agreement")
p2 <- ggplot(ba, aes(m, d)) + geom_hline(yintercept = 0, colour = ink2) +
  geom_hline(yintercept = bias, colour = orange, linewidth = 1) + geom_hline(yintercept = loa, colour = orange, linetype = "22") +
  geom_point(size = 3, colour = blue) +
  annotate("text", x = 9.6, y = c(bias, loa) + 0.05, label = sprintf(c("bias %.2f", "%.2f", "%.2f"), c(bias, loa)), hjust = 0, size = 3.8, colour = orange) +
  xlim(4.5, 10.6) + labs(x = "Mean of A and B", y = "Difference B - A", title = "Bland-Altman: B reads systematically higher", subtitle = "bias and 95% limits of agreement")
p <- p1 + p2 + plot_annotation(title = "High correlation is not agreement")
save(p, "ch15-bland-altman", w = 10, h = 4.6)

# ===================================================================== Chapter 16
# Positive induction_cycles equals -Delta-Delta-Ct under the treated-minus-control convention.
qe <- expand.grid(induction_cycles = seq(0, 8, 0.1), eff = c(0.90, 0.95))
qe$over <- 100 * (2^qe$induction_cycles / (1 + qe$eff)^qe$induction_cycles - 1)
p <- ggplot(qe, aes(induction_cycles, over, colour = factor(eff))) + geom_line(linewidth = 1.2) +
  scale_colour_manual(values = c(orange, blue), labels = c("true efficiency 90%", "true efficiency 95%")) +
  annotate("point", x = c(3, 6), y = 100 * (2^c(3, 6) / 1.9^c(3, 6) - 1), size = 3, colour = orange) +
  labs(x = "-Delta-Delta-Ct (cycles of induction)", y = "Overestimate of fold change (%)", title = "Assuming 100% efficiency inflates fold changes — more for bigger changes",
       subtitle = "Points: the worked example (17% at 3 cycles, 36% at 6 cycles)")
save(p, "ch16-qpcr-efficiency", w = 8, h = 4.4)

# ===================================================================== Chapter 17
cg <- data.frame(mpc = c(6, 3, 2, 1)); cg$cages <- 12 / cg$mpc; cg$neff <- 12 / (1 + (cg$mpc - 1) * 0.5)
cg$label <- sprintf("%d %s × %d cages", cg$mpc, ifelse(cg$mpc == 1, "mouse", "mice"), cg$cages)
p <- ggplot(cg, aes(reorder(label, neff), neff)) + geom_col(fill = blue, width = 0.6) +
  geom_text(aes(label = sprintf("%.1f", neff)), hjust = -0.2, size = 4.2) + coord_flip(ylim = c(0, 13.5)) +
  labs(x = NULL, y = "Effective sample size per diet (12 mice, ICC = 0.5)", title = "Same 12 mice per diet, very different information",
       subtitle = "Cage-mates share microbes; more cages beat more mice per cage")
save(p, "ch17-cage-neff", w = 8, h = 3.6)

# ===================================================================== Chapter 18
be <- data.frame(product = c("Generic A", "Generic B", "Generic C", "Generic D"), gmr = c(0.95, 1.10, 0.86, 0.99), lo = c(0.88, 0.97, 0.76, 0.83), hi = c(1.03, 1.26, 0.97, 1.18))
be$verdict <- ifelse(be$lo >= 0.8 & be$hi <= 1.25, "bioequivalent", "not shown")
p <- ggplot(be, aes(gmr, product, colour = verdict)) + annotate("rect", xmin = 0.8, xmax = 1.25, ymin = -Inf, ymax = Inf, fill = aqua, alpha = 0.12) +
  geom_vline(xintercept = c(0.8, 1.25), linetype = "22", colour = aqua) + geom_vline(xintercept = 1, colour = ink2) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.2, linewidth = 1) + geom_point(size = 3.5) +
  scale_colour_manual(values = c(bioequivalent = blue, "not shown" = orange)) + scale_x_log10(breaks = c(0.7, 0.8, 1, 1.25, 1.4)) +
  labs(x = "Geometric mean ratio Test/Reference (90% CI, log scale)", y = NULL, title = "Equivalence: the whole interval must sit inside 0.80-1.25",
       subtitle = "Illustrative results. B and D are not 'different' — they are simply not shown to be equivalent.")
save(p, "ch18-bioequivalence", w = 8.5, h = 4)

# ===================================================================== Chapter 21
inj <- 1:60; drift <- -0.4 * inj
seq_design <- data.frame(order = inj, group = rep(c("Control", "Case"), each = 30), design = "Run in sequence")
set.seed(21); rand_design <- data.frame(order = inj, group = unlist(lapply(1:6, function(i) sample(rep(c("Control", "Case"), 5)))), design = "Block-randomized")
dd <- rbind(seq_design, rand_design); dd$design <- factor(dd$design, c("Run in sequence", "Block-randomized")); dd$signal <- 100 + drift[dd$order] + rnorm(nrow(dd), 0, 2)
qc <- data.frame(order = seq(0, 60, by = 10) + 0.5, signal = 100 + -0.4 * (seq(0, 60, by = 10) + 0.5))
p <- ggplot(dd, aes(order, signal)) + geom_line(data = qc, colour = ink2, linetype = "22") + geom_point(data = qc, shape = 18, size = 4, colour = ink2) +
  geom_point(aes(colour = group), size = 2.6) + facet_wrap(~ design, ncol = 1) +
  scale_colour_manual(values = c(Control = blue, Case = orange)) +
  labs(x = "Injection order", y = "Measured intensity", title = "Instrument drift: no true difference between cases and controls",
       subtitle = "Top: drift creates a fake group difference. Bottom: drift affects both groups; pooled QCs (diamonds) let you correct it.")
save(p, "ch21-run-order", w = 9, h = 5.4)

# ===================================================================== Chapter 23
ce <- expand.grid(m = c(5, 10, 20, 50, 100), icc = c(0.01, 0.05, 0.1)); ce$de <- 1 + (ce$m - 1) * ce$icc
p <- ggplot(ce, aes(m, de, colour = factor(icc))) + geom_line(linewidth = 1.2) + geom_point(size = 2.5) +
  scale_colour_manual(values = c(blue, orange, violet), labels = function(x) paste0("ICC = ", x)) +
  annotate("point", x = 20, y = 1.95, size = 5, shape = 21, colour = ink, stroke = 1.2) +
  annotate("text", x = 22, y = 1.95, label = "worked example: DE = 1.95", hjust = 0, vjust = 1.6, size = 3.8) +
  labs(x = "Patients per cluster", y = "Design effect (sample-size multiplier)", title = "Cluster trials need more patients — even when ICC is small")
save(p, "ch23-design-effect", w = 8, h = 4.4)

# ===================================================================== Chapter 24
wc <- do.call(rbind, lapply(c(20, 100, 800), function(n) {
  r <- replicate(6000, { x <- rnorm(n); y <- 0.1 * x + sqrt(1 - 0.01) * rnorm(n); ct <- cor.test(x, y); c(ct$estimate, ct$p.value) })
  data.frame(n = paste("n =", n), r = r[1, ], sig = ifelse(r[2, ] < 0.05 & r[1, ] > 0, "significant, positive", "other"))
}))
wc$n <- factor(wc$n, c("n = 20", "n = 100", "n = 800"))
p <- ggplot(wc, aes(r, fill = sig)) + geom_histogram(bins = 60, colour = "white", linewidth = 0.1) + facet_wrap(~ n, scales = "free_y") +
  geom_vline(xintercept = 0.1, colour = ink) + scale_fill_manual(values = c(other = "grey80", "significant, positive" = orange)) +
  labs(x = "Observed correlation (true r = 0.1)", y = "Simulated studies", title = "The winner's curse: published small studies report inflated correlations",
       subtitle = "Only the orange studies 'find' the effect. At n = 20 they all report r > 0.4.") + theme(axis.text.y = element_blank())
save(p, "ch24-winners-curse", w = 10, h = 4.2)

# ===================================================================== Chapter 25
fp <- data.frame(k = 1:12); fp$fpr <- 1 - (1 - 0.05)^fp$k
sim_fp <- sapply(c(1, 2, 4, 8, 12), function(k) mean(replicate(4000, min(sapply(1:k, function(i) t.test(rnorm(10), rnorm(10))$p.value)) < 0.05)))
p <- ggplot(fp, aes(k, fpr)) + geom_line(colour = orange, linewidth = 1.2) +
  geom_point(data = data.frame(k = c(1, 2, 4, 8, 12), fpr = sim_fp), colour = blue, size = 3.5) +
  geom_hline(yintercept = 0.05, linetype = "22", colour = ink2) + scale_y_continuous(labels = scales::percent) +
  labs(x = "Number of independent outcomes or analyses tried", y = "Chance of at least one p < 0.05\n(no true effects)",
       title = "Try enough analyses and something will be 'significant'", subtitle = "Line: 1 - 0.95^k. Points: simulation picking the best of k independent t-tests.")
save(p, "ch25-forking-paths", w = 8, h = 4.4)
cat("done\n")
