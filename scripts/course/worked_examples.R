# Numbers used in the course's worked examples. Run: Rscript scripts/course/worked_examples.R
cat("== Ch3 design effect ==\n")
m <- 100; icc <- 0.3; k <- 4
de <- 1 + (m - 1) * icc; cat("DE =", de, " n_eff per group =", k*m/de, "\n")

cat("== Ch4 randomisation ==\n")
set.seed(42); print(sample(rep(c("Control", "Drug"), each = 6)))
set.seed(7); ids <- sprintf("M%02d", 1:12); print(data.frame(mouse = ids, group = sample(rep(c("Control","Drug"), each = 6))))
cat("block randomisation (4 litters of 2):\n"); set.seed(11)
print(t(sapply(1:4, function(i) sample(c("Control","Drug")))))

cat("== Ch5 paired vs unpaired (litter-matched) ==\n")
ctrl <- c(12.1, 15.3, 9.8, 18.2, 11.5, 14.9); drug <- c(13.4, 16.9, 10.6, 19.9, 12.8, 16.1)
print(round(drug - ctrl, 2))
cat("unpaired p =", signif(t.test(drug, ctrl, var.equal = TRUE)$p.value, 3), "\n")
cat("paired   p =", signif(t.test(drug, ctrl, paired = TRUE)$p.value, 3), "\n")
cat("mean diff =", mean(drug - ctrl), " sd diff =", round(sd(drug - ctrl), 3), " sd ctrl =", round(sd(ctrl), 2), "\n")

cat("== Ch7 2x2 factorial ==\n")
means <- matrix(c(10, 14, 12, 24), 2, dimnames = list(genotype = c("WT", "KO"), treatment = c("Vehicle", "Drug")))
print(means)
cat("drug effect in WT =", means["WT","Drug"] - means["WT","Vehicle"], "; in KO =", means["KO","Drug"] - means["KO","Vehicle"],
    "; interaction =", (means["KO","Drug"] - means["KO","Vehicle"]) - (means["WT","Drug"] - means["WT","Vehicle"]), "\n")

cat("== Ch8 power ==\n")
for (d in c(0.5, 0.8, 1.2, 2)) cat("d =", d, " n/group =", ceiling(power.t.test(delta = d, sd = 1, power = 0.8)$n), "\n")
cat("power with n=3, d=1:", round(power.t.test(n = 3, delta = 1, sd = 1)$power, 3), "\n")
cat("power with n=5, d=1:", round(power.t.test(n = 5, delta = 1, sd = 1)$power, 3), "\n")
cat("example: SD=15 mg/dL, delta=20 -> n =", ceiling(power.t.test(delta = 20, sd = 15, power = 0.8)$n), "\n")
cat("proportions 0.30 vs 0.15:", ceiling(power.prop.test(p1 = 0.30, p2 = 0.15, power = 0.8)$n), "\n")
cat("paired, sd_diff=0.6, delta=1.0:", ceiling(power.t.test(delta = 1.0, sd = 0.6, power = 0.8, type = "paired")$n), "\n")
cat("cluster: 20 per cluster, ICC 0.05 DE =", 1 + 19*0.05, "\n")

cat("== Ch12 leakage simulation (pure noise) ==\n")
set.seed(1)
n <- 40; p <- 2000; X <- matrix(rnorm(n * p), n); y <- rep(0:1, each = n / 2)
topk <- function(X, y, k = 20) order(-abs(apply(X, 2, function(v) t.test(v[y == 1], v[y == 0])$statistic)))[1:k]
centroid <- function(Xtr, ytr, Xte) { c1 <- colMeans(Xtr[ytr == 1, , drop = FALSE]); c0 <- colMeans(Xtr[ytr == 0, , drop = FALSE])
  as.integer(rowSums((Xte - rep(c1, each = nrow(Xte)))^2) < rowSums((Xte - rep(c0, each = nrow(Xte)))^2)) }
folds <- sample(rep(1:5, length.out = n))
leaky_sel <- topk(X, y); acc_leak <- acc_ok <- c()
for (f in 1:5) { tr <- folds != f; te <- !tr
  acc_leak <- c(acc_leak, mean(centroid(X[tr, leaky_sel], y[tr], X[te, leaky_sel]) == y[te]))
  s <- topk(X[tr, ], y[tr]); acc_ok <- c(acc_ok, mean(centroid(X[tr, s], y[tr], X[te, s]) == y[te])) }
cat("leaky CV accuracy =", mean(acc_leak), "; proper CV accuracy =", mean(acc_ok), "\n")
# repeat to get stable averages
reps <- replicate(50, { X <- matrix(rnorm(n * p), n); folds <- sample(rep(1:5, length.out = n)); ls <- topk(X, y); a <- b <- 0
  for (f in 1:5) { tr <- folds != f; te <- !tr; a <- a + mean(centroid(X[tr, ls], y[tr], X[te, ls]) == y[te]) / 5
    s <- topk(X[tr, ], y[tr]); b <- b + mean(centroid(X[tr, s], y[tr], X[te, s]) == y[te]) / 5 }; c(a, b) })
write.csv(data.frame(design = rep(c("Feature selection BEFORE CV (leaky)", "Feature selection INSIDE CV (correct)"), each = ncol(reps)),
                     accuracy = c(reps[1, ], reps[2, ])), "data/course_leakage_sim.csv", row.names = FALSE)
cat("over 50 noise datasets: leaky mean =", round(mean(reps[1, ]), 3), " proper mean =", round(mean(reps[2, ]), 3), "\n")

cat("== Ch13 2^3 factorial ==\n")
d <- expand.grid(Temp = c(-1, 1), pH = c(-1, 1), Glucose = c(-1, 1))
d$Yield <- c(52, 60, 54, 70, 50, 62, 56, 80)
print(d); fit <- lm(Yield ~ Temp * pH * Glucose, d); print(round(2 * coef(fit)[-1], 2))

cat("== Ch14 Z prime ==\n")
pos <- c(980, 1010, 1050, 990, 970, 1000); neg <- c(105, 98, 112, 95, 101, 89)
zp <- 1 - 3 * (sd(pos) + sd(neg)) / abs(mean(pos) - mean(neg)); cat("mean pos", round(mean(pos),1), "sd", round(sd(pos),1), "mean neg", round(mean(neg),1), "sd", round(sd(neg),1), "Z' =", round(zp, 3), "\n")
pos2 <- c(700, 1100, 1300, 850, 600, 1250)
cat("noisy Z' =", round(1 - 3 * (sd(pos2) + sd(neg)) / abs(mean(pos2) - mean(neg)), 3), " sd pos2", round(sd(pos2),1), "mean", round(mean(pos2),1), "\n")
cat("expected false positives in 20000 null genes at p<0.05:", 20000 * 0.05, "\n")

cat("== Ch15 Bland-Altman ==\n")
a <- c(5.1, 6.3, 7.8, 4.9, 9.2, 6.7, 8.1, 5.5, 7.0, 6.1); b <- c(5.6, 6.9, 8.1, 5.6, 10.0, 7.1, 8.9, 6.0, 7.4, 6.8)
dd <- b - a; cat("r =", round(cor(a, b), 3), " bias =", round(mean(dd), 3), " LoA =", round(mean(dd) - 1.96 * sd(dd), 3), "to", round(mean(dd) + 1.96 * sd(dd), 3), "\n")

cat("== Ch24 correlation n ==\n")
r <- 0.1; cat("n for r=0.1:", ceiling(((qnorm(0.975) + qnorm(0.8)) / atanh(r))^2 + 3), "\n")
r <- 0.3; cat("n for r=0.3:", ceiling(((qnorm(0.975) + qnorm(0.8)) / atanh(r))^2 + 3), "\n")
cat("== Ch20 RNA-seq budget ==\n")
sim <- read.csv("data/sim_replicates_vs_depth.csv"); print(sim)
cat("== Ch19 RCBD vs CRD (simulated field gradient) ==\n")
set.seed(3); nb <- 4; ng <- 10
blk <- rep(1:nb, each = ng); g <- unlist(lapply(1:nb, function(i) sample(1:ng)))
gen <- rnorm(ng, 0, 1); y <- gen[g] + c(-3, -1, 1, 3)[blk] + rnorm(nb * ng, 0, 1)
dd2 <- data.frame(y, g = factor(g), blk = factor(blk))
crd <- anova(lm(y ~ g, dd2)); rcbd <- anova(lm(y ~ blk + g, dd2))
cat("residual MS CRD-analysis =", round(crd["Residuals", "Mean Sq"], 3), " RCBD =", round(rcbd["Residuals", "Mean Sq"], 3),
    " p(genotype) CRD =", signif(crd["g", "Pr(>F)"], 3), " RCBD =", signif(rcbd["g", "Pr(>F)"], 3), "\n")
cat("== Ch8 extra checks ==\n")
cat("power n=6, d=0.8:", round(power.t.test(n = 6, delta = 0.8)$power, 3), "\n")
cat("n for delta=3, sd=4:", ceiling(power.t.test(delta = 3, sd = 4, power = 0.8)$n), "\n")
cat("power n=8/group, d=1.6:", round(power.t.test(n = 8, delta = 1.6)$power, 3), "\n")
cat("== Ch9 precision for a proportion ==\n")
nprop <- function(p, E) ceiling(qnorm(0.975)^2 * p * (1 - p) / E^2)
cat("p=0.5,E=0.05:", nprop(0.5, 0.05), " p=0.5,E=0.10:", nprop(0.5, 0.10), " p=0.2,E=0.05:", nprop(0.2, 0.05), "\n")
cat("with 10 isolates/farm, ICC=0.2: DE =", 1 + 9 * 0.2, " n =", ceiling(nprop(0.2, 0.05) * (1 + 9 * 0.2)), " farms =", ceiling(nprop(0.2, 0.05) * (1 + 9 * 0.2) / 10), "\n")
cat("with 3 isolates/farm, ICC=0.2: DE =", 1 + 2 * 0.2, " n =", ceiling(nprop(0.2, 0.05) * (1 + 2 * 0.2)), " farms =", ceiling(nprop(0.2, 0.05) * (1 + 2 * 0.2) / 3), "\n")
cat("== Ch11 Mendelian randomization Wald ratio ==\n")
bx <- 0.10; by <- 0.05; se_by <- 0.012; se_bx <- 0.005
cat("ratio (log OR per mmol/L) =", by / bx, " OR =", round(exp(by / bx), 3), " SE(first-order) =", se_by / bx,
    " 95% CI OR =", round(exp(by / bx - 1.96 * se_by / bx), 2), "-", round(exp(by / bx + 1.96 * se_by / bx), 2), " F =", (bx / se_bx)^2, "\n")
cat("== Ch14 CRISPR coverage ==\n")
cat("cells with guides =", 80000 * 500 / 1e6, "M; at measured 30% transduction =", round(80000 * 500 / 0.3 / 1e6), "M\n")
cat("at Poisson MOI 0.3, transduced fraction =", round(1 - exp(-0.3), 3),
    "; starting cells needed =", ceiling(80000 * 500 / (1 - exp(-0.3)) / 1e6), "M\n")
cat("Z' Q3:", 1 - 3 * (40 + 20) / (500 - 100), "\n")
cat("== Ch16 qPCR efficiency ==\n")
cat("ddCt = -3: assumed 100% ->", 2^3, "; true 90% ->", round(1.9^3, 2), "; overestimate =", round(100 * (2^3 / 1.9^3 - 1), 1), "%\n")
cat("ddCt = -6: assumed 100% ->", 2^6, "; true 90% ->", round(1.9^6, 1), "; overestimate =", round(100 * (2^6 / 1.9^6 - 1), 1), "%\n")
cat("== Ch17 cage design effect (ICC 0.5) ==\n")
for (m in c(6, 3, 2, 1)) cat("mice/cage =", m, " cages/diet =", 12 / m, " DE =", 1 + (m - 1) * 0.5, " n_eff/diet =", round(12 / (1 + (m - 1) * 0.5), 1), "\n")
cat("== Ch23 cluster RCT ==\n")
n_ind <- ceiling(power.prop.test(p1 = 0.30, p2 = 0.15, power = 0.8)$n); de <- 1 + 19 * 0.05
cat("individual n/arm =", n_ind, " DE =", de, " cluster n/arm =", ceiling(n_ind * de), " clinics/arm =", ceiling(ceiling(n_ind * de) / 20), "\n")
cat("== Ch24 winner's curse for correlations ==\n")
set.seed(24)
sim_r <- function(n, rho, nsim = 20000) {
  res <- replicate(nsim, { x <- rnorm(n); y <- rho * x + sqrt(1 - rho^2) * rnorm(n); ct <- cor.test(x, y); c(ct$estimate, ct$p.value) })
  sig <- res[2, ] < 0.05 & res[1, ] > 0
  c(power = mean(res[2, ] < 0.05), mean_r_sig = mean(res[1, sig]))
}
for (n in c(20, 100, 800)) { s <- sim_r(n, 0.1); cat("n =", n, " power =", round(s[1], 3), " mean r among significant positive =", round(s[2], 3), "\n") }

cat("== Revised planning checks ==\n")
cat("29 retained, 10% attrition: allocate", ceiling(29 / 0.90), "per group\n")
cat("16 retained cages, 10% cage loss: allocate", ceiling(16 / 0.90), "per group\n")
cat("2 mice/cage, ICC 0.05: cages/arm =", ceiling(29 * (1 + 0.05) / 2), "\n")
