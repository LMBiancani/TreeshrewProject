# Install 'ape' package if not already installed
if (!requireNamespace("ape", quietly = TRUE)) {
  install.packages("ape", dependencies = TRUE, repos = "https://cloud.r-project.org")
}
library (ape)
