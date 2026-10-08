# Knit hands-on sub-courses: subcourses/<name>/rmd/*.Rmd -> .build/subcourses/<name>/*.md (+ figures/)
# .build/ holds intermediate Markdown only; the finished files are written by 07_build_course.py.
# Figures are written to subcourses/<name>/figures/; citations are resolved afterwards by 07_build_course.py.
# Run from the project root: Rscript scripts/08_knit_subcourses.R [name]
args <- commandArgs(trailingOnly = TRUE)
root <- normalizePath(".")
subs <- if (length(args)) args else basename(list.dirs(file.path(root, "subcourses"), recursive = FALSE))
for (s in subs) {
  rmd_dir <- file.path(root, "subcourses", s, "rmd")
  # Markdown-only sub-courses (sources in course_src/subcourses/) have nothing to knit.
  if (!dir.exists(rmd_dir)) next
  out_dir <- file.path(root, ".build", "subcourses", s)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  for (f in sort(list.files(rmd_dir, pattern = "\\.Rmd$", full.names = TRUE))) {
    stem <- sub("\\.Rmd$", "", basename(f))
    owd <- setwd(file.path(root, "subcourses", s))          # figure paths relative to the final .md
    knitr::opts_chunk$set(dev = "ragg_png", dpi = 144, fig.width = 7.5, fig.height = 4.5, comment = "#>",
                          message = FALSE, warning = FALSE, error = FALSE, fig.path = paste0("figures/", stem, "-"),
                          fig.align = "center", out.width = "100%")
    knitr::opts_knit$set(root.dir = file.path(root, "subcourses", s))
    set.seed(2026)
    knitr::knit(f, output = file.path(out_dir, paste0(stem, ".md")), quiet = TRUE, envir = new.env())
    setwd(owd)
    cat("knitted", s, stem, "\n")
  }
}
