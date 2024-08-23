library (ape)
args = commandArgs(trailingOnly=TRUE)
argsLen <- length(args);
if (argsLen == 0){
  cat("Syntax: Rscript trimConstraintTree.R [path to dna alignment] [path to tree file] [output tree path]\n")
  cat("Example: Rscript trimConstraintTree.R alignment.fasta constraint.tre trimmed_constraint.tre\n")
  quit()
}
alignment <- read.dna(args[1], format="fasta")
tree <- read.tree(args[2])
outtreename <- args[3]
taxapresent <- rownames(alignment)
treetips <-tree$tip.label
tipstoremove <- treetips[!(treetips %in% taxapresent)]
outtree <- drop.tip(tree, tipstoremove)
write.tree(outtree, outtreename)
