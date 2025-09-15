library(ape)
library(phangorn)
args = commandArgs(trailingOnly=TRUE)
argsLen <- length(args);
if (argsLen == 0){
  cat("Syntax: Rscript treescreen.R [reference tree file] [path to loci folder]\n")
  cat("Example: Rscript treescreen.R tree.tre ./dna/\n")
  quit()
}

mltreepath <- args[1]
gtreespath <- args[2]
gtreenames <- args[3]

print("processing constraint trees...")
# read all trees from the constraint trees file
concat_trees <- read.tree(mltreepath)
# create list of all unique tip labels:
all_tips <- unique(unlist(lapply(concat_trees, function(t) t$tip.label)))

# extract branch lengths per tip label from each constraint tree (NA if tip is not present in tree)
concat_trees_data <- lapply(concat_trees, function(tree) {
  # map each tip in this tree to its terminal edge length
  tip_lengths <- setNames(
    tree$edge.length[
      sapply(1:length(tree$tip.label),
             function(x,y) which(y==x), 
             y=tree$edge[,2])
    ],
    tree$tip.label
  )
  
  # align with master list of taxa
  out <- rep(NA, length(all_tips))
  names(out) <- all_tips
  out[names(tip_lengths)] <- tip_lengths
  
  return(out)
})

names(concat_trees_data) <- paste0("t",1:length(concat_trees))

concat_trees_data <- as.data.frame(concat_trees_data)
concat_trees_meanBL <- rowMeans(concat_trees_data, na.rm = TRUE)

write(x="locname,slope,Rsq",file="screening_output.csv")

gene_trees <- read.tree(gtreespath)
gene_names <- readLines(gtreenames)

print("process gene trees")
for (i in 1:length(gene_trees)){
        print (gene_names[i])
        gtree <- gene_trees[[i]]
        # extract branch lengths for this gene tree
        gtreeBL <- setNames(
          gtree$edge.length[
            sapply(1:length(gtree$tip.label),
               function(x,y) which(y==x), 
               y=gtree$edge[,2])
          ],
          gtree$tip.label
        )
        # align gene tree branch lengths with master tip set
        gtreeBL_full <- rep(NA, length(all_tips))
        names(gtreeBL_full) <- all_tips
        gtreeBL_full[names(gtreeBL)] <- gtreeBL
        # align and combine
        combolengths <- cbind(concat_trees_meanBL, gtreeBL = gtreeBL_full[names(concat_trees_meanBL)])
        regress <- lm(combolengths[,1] ~ combolengths[,2], na.action = na.omit)
        # get slope
        slope <- coef(regress)[2]
        # get r-squared
        Rsquared <- summary(regress)$r.squared

        output <- paste(gene_names[i],slope,Rsquared,sep=",")
        write(x=output,file="screening_output.csv", append=T)
}
