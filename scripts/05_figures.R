# Course figures: the design simulations and the bibliometric map of the literature survey.
# Run from project root:  Rscript scripts/05_figures.R
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(tidyr); library(patchwork); library(lme4); library(MASS)
})
set.seed(20261002)
dir.create("assets", showWarnings = FALSE)

# Reference palette (light mode): categorical slots 1-3, sequential blue ramp, ink tokens.
blue <- "#2a78d6"; orange <- "#eb6834"; aqua <- "#1baf7a"
ink <- "#0b0b0b"; ink2 <- "#52514e"; grid_col <- "#e6e5e0"
seq_ramp <- c("#f2f6fc", "#c9dcf5", "#8fb6ea", "#4f8ddc", "#2a78d6", "#1b4f99")

theme_paper <- function(base = 8.5) {
  theme_minimal(base_size = base, base_family = "Helvetica") +
    theme(text = element_text(colour = ink), axis.text = element_text(colour = ink2),
          panel.grid.major = element_line(colour = grid_col, linewidth = 0.3),
          panel.grid.minor = element_blank(), plot.title = element_text(face = "bold", size = base + 1),
          plot.title.position = "plot", legend.position = "top", legend.justification = "left",
          legend.title = element_blank(), legend.key.size = unit(8, "pt"),
          plot.tag = element_text(face = "bold", size = base + 2))
}

# ---------------------------------------------------------------- Bibliometric map
yc <- read.csv("data/field_year_counts.csv", check.names = FALSE)
tot <- read.csv("data/field_totals.csv", check.names = FALSE)
ord <- tot %>% arrange(total) %>% pull(field)
heat <- yc %>% group_by(field) %>% mutate(rel = hits / max(hits)) %>% ungroup() %>%
  mutate(field = factor(field, levels = ord))
p2a <- ggplot(heat, aes(year, field, fill = rel)) +
  geom_tile(colour = "white", linewidth = 0.4) +
  scale_fill_gradientn(colours = seq_ramp, limits = c(0, 1), labels = scales::percent,
                       name = "Share of field's peak year") +
  scale_x_continuous(breaks = seq(2000, 2025, 5), expand = c(0, 0)) +
  labs(x = NULL, y = NULL, title = "Growth of design-focused literature, 2000-2025") +
  theme_paper() + theme(panel.grid = element_blank(), legend.title = element_text(size = 7.5),
                        legend.key.width = unit(26, "pt"))
bars <- tot %>% pivot_longer(c(non_reviews, reviews), names_to = "type", values_to = "n") %>%
  mutate(field = factor(field, levels = ord),
         type = factor(type, levels = c("reviews", "non_reviews"),
                       labels = c("Reviews", "Primary")))
p2b <- ggplot(bars, aes(n, field, fill = type)) +
  geom_col(width = 0.72, colour = "white", linewidth = 0.4) +
  scale_fill_manual(values = c(orange, blue)) +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale()), breaks = c(0, 40000, 80000),
                     expand = expansion(mult = c(0, 0.04))) +
  labs(x = "Records, 2000-2026", y = NULL, title = "Volume by field") +
  theme_paper() + theme(axis.text.y = element_blank(), panel.grid.major.y = element_blank())
fig2 <- (p2a + p2b + plot_layout(widths = c(2.1, 1))) + plot_annotation(tag_levels = "a")
ggsave("assets/fig_bibliometrics.png", fig2, width = 7.2, height = 4.4, dpi = 220)

# ---------------------------------------------------------------- Simulation a: pseudoreplication
# Two groups x 4 animals; m cells per animal; NO true effect. Naive t-test on cells vs.
# t-test on animal means vs. linear mixed model (animal random intercept).
sim_pr <- function(m, icc, nsim = 2000, k = 4) {
  rej <- c(naive = 0, means = 0)
  for (s in seq_len(nsim)) {
    a <- rnorm(2 * k, 0, sqrt(icc))
    y <- rep(a, each = m) + rnorm(2 * k * m, 0, sqrt(1 - icc))
    g <- rep(rep(0:1, each = k), each = m); id <- rep(seq_len(2 * k), each = m)
    rej["naive"] <- rej["naive"] + (t.test(y[g == 0], y[g == 1], var.equal = TRUE)$p.value < 0.05)
    mu <- tapply(y, id, mean); gg <- rep(0:1, each = k)
    rej["means"] <- rej["means"] + (t.test(mu[gg == 0], mu[gg == 1], var.equal = TRUE)$p.value < 0.05)
  }
  rej / nsim
}
grid_pr <- expand.grid(m = c(1, 3, 10, 30, 100), icc = c(0.1, 0.3))
pr <- do.call(rbind, lapply(seq_len(nrow(grid_pr)), function(i) {
  r <- sim_pr(grid_pr$m[i], grid_pr$icc[i])
  data.frame(m = grid_pr$m[i], icc = grid_pr$icc[i], naive = r["naive"], means = r["means"])
}))
write.csv(pr, "data/sim_pseudoreplication.csv", row.names = FALSE)
prl <- bind_rows(
  pr %>% filter(icc == 0.1) %>% transmute(m, rate = naive, series = "Cells as n (ICC = 0.1)"),
  pr %>% filter(icc == 0.3) %>% transmute(m, rate = naive, series = "Cells as n (ICC = 0.3)"),
  pr %>% filter(icc == 0.3) %>% transmute(m, rate = means, series = "Animal as n (ICC = 0.3)")) %>%
  mutate(series = factor(series, levels = c("Cells as n (ICC = 0.3)", "Cells as n (ICC = 0.1)", "Animal as n (ICC = 0.3)")))
p3a <- ggplot(prl, aes(m, rate, colour = series)) +
  geom_hline(yintercept = 0.05, linetype = "22", colour = ink2, linewidth = 0.4) +
  geom_line(linewidth = 0.7) + geom_point(size = 1.8, stroke = 0.6, fill = "white", shape = 21) +
  scale_x_log10(breaks = c(1, 3, 10, 30, 100)) +
  scale_y_continuous(labels = scales::percent, limits = c(0, NA)) +
  scale_colour_manual(values = c(orange, blue, aqua)) +
  annotate("text", x = 1.5, y = 0.05, label = "nominal 5%", vjust = 1.6, hjust = 0, size = 2.5, colour = ink2) +
  labs(x = "Cells measured per animal (log scale)", y = "False-positive rate",
       title = "Pseudoreplication") +
  guides(colour = guide_legend(ncol = 1)) + theme_paper()

# ---------------------------------------------------------------- Simulation b: replicates vs depth
# One gene, negative binomial counts, biological dispersion phi = 0.1, true fold change 1.5.
# Dispersion is treated as known (as when it is shrunk/borrowed across thousands of genes,
# e.g. DESeq2/edgeR), so the Wald test holds its nominal size even at n = 2.
sim_rd <- function(n, mu, phi = 0.1, fc = 1.5, nsim = 2000) {
  fam <- negative.binomial(theta = 1 / phi); g <- factor(rep(0:1, each = n)); hits <- 0
  for (s in seq_len(nsim)) {
    y <- c(rnbinom(n, mu = mu, size = 1 / phi), rnbinom(n, mu = mu * fc, size = 1 / phi))
    fit <- suppressWarnings(glm(y ~ g, family = fam))
    hits <- hits + (2 * pnorm(-abs(coef(summary(fit, dispersion = 1))[2, 3])) < 0.05)
  }
  hits / nsim
}
size_check <- sapply(c(2, 6, 12), function(n) sim_rd(n, 100, fc = 1))
cat("Type I error at fc = 1 (n = 2, 6, 12):", size_check, "\n")
grid_rd <- expand.grid(n = c(2, 3, 4, 6, 8, 10, 12), mu = c(10, 100, 1000))
grid_rd$power <- mapply(sim_rd, grid_rd$n, grid_rd$mu)
write.csv(grid_rd, "data/sim_replicates_vs_depth.csv", row.names = FALSE)
grid_rd$depth <- factor(grid_rd$mu, levels = c(1000, 100, 10),
                        labels = c("Mean count 1000 (deep)", "Mean count 100", "Mean count 10 (shallow)"))
p3b <- ggplot(grid_rd, aes(n, power, colour = depth)) +
  geom_hline(yintercept = 0.8, linetype = "22", colour = ink2, linewidth = 0.4) +
  geom_line(linewidth = 0.7) + geom_point(size = 1.8, stroke = 0.6, fill = "white", shape = 21) +
  scale_colour_manual(values = c(blue, orange, aqua)) +
  scale_x_continuous(breaks = c(2, 4, 6, 8, 10, 12)) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(x = "Biological replicates per group", y = "Power (1.5-fold change)",
       title = "Replicates vs. depth") +
  guides(colour = guide_legend(ncol = 1)) + theme_paper()

# ---------------------------------------------------------------- Simulation c: sample size vs effect size
d <- seq(0.2, 2, by = 0.05)
ss <- bind_rows(lapply(c(0.05, 0.005), function(a) data.frame(
  d = d, n = sapply(d, function(x) ceiling(power.t.test(delta = x, sd = 1, sig.level = a, power = 0.8)$n)),
  alpha = a)))
write.csv(ss, "data/sample_size_curve.csv", row.names = FALSE)
ss$alpha <- factor(ss$alpha, levels = c(0.005, 0.05), labels = c("alpha = 0.005", "alpha = 0.05"))
lab <- ss %>% filter(alpha == "alpha = 0.05", d %in% c(0.5, 0.8, 1.2))
p3c <- ggplot(ss, aes(d, n, colour = alpha)) +
  geom_line(linewidth = 0.7) +
  geom_point(data = lab, size = 1.8, shape = 21, fill = "white", stroke = 0.6) +
  scale_y_log10(breaks = c(5, 10, 20, 50, 100, 200, 400)) +
  scale_colour_manual(values = c(orange, blue)) +
  labs(x = "Standardised effect size (Cohen's d)", y = "n per group for 80% power (log)",
       title = "Sample size vs. effect") +
  guides(colour = guide_legend(ncol = 1)) + theme_paper()

fig3 <- (p3a | p3b | p3c) + plot_annotation(tag_levels = "a")
ggsave("assets/fig_simulations.png", fig3, width = 7.2, height = 3.5, dpi = 220)
print(pr); print(grid_rd[, c("n", "mu", "power")]); print(lab)
