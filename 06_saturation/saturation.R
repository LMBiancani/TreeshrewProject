library(ape)
args = commandArgs(trailingOnly=TRUE)
argsLen <- length(args);
if (argsLen == 0){
  cat("Syntax: Rscript saturation.R [path to loci folder]\n")
  cat("Example: Rscript saturation.R ./dna/\n")
  quit()
}

dnaseqpath <- args[1]

dnafiles <- list.files(path=dnaseqpath, pattern="\\.fasta$", full.names=FALSE, recursive=FALSE)

for (i in 1:length(dnafiles)){
	dnafile <- paste0(dnaseqpath,"/",dnafiles[i])

        # read
        alignment <- tryCatch(read.dna(dnafile, format = "fasta"), error = function(e) NULL)
  
        # check if empty or NULL
  	if (is.null(alignment) || nrow(alignment) == 0) {
    	message(paste("Skipping", dnafiles[i], "- file is empty or invalid"))
    	next
  	}

	#alignment <- read.dna(dnafile, format="fasta")
	
	rawdist <- dist.dna(alignment, model = "raw", pairwise.deletion = T, as.matrix = T)
	diag(rawdist) <- NA
	
	tn93dist <- dist.dna(alignment, model = "TN93", pairwise.deletion = T, as.matrix = T)
	diag(tn93dist) <- NA
	
	#check if there are non NA values
	if (length(rawdist[!is.na(rawdist)]) == 0 | length(tn93dist[!is.na(tn93dist)]) == 0) {
		#record as NA
		output <- paste(dnafiles[i],NA,NA,NA,NA,sep=",")
	} else {
		tn93dist2 <- tn93dist[lower.tri(tn93dist)]
		# get mean tn93 dist
		mean_dist <- mean(tn93dist2)
		sd_dist <- sd(tn93dist2)
		rawdist2 <- rawdist[lower.tri(rawdist)]
                
		# remove NA/NaN pairs and Inf vals
                valid_idx <- is.finite(tn93dist2) & is.finite(rawdist2) & !is.na(tn93dist2) & !is.na(rawdist2) & !is.nan(tn93dist2) & !is.nan(rawdist2)

                #subset to only pairs of values that do not have NAs or Inf
                tn93dist2_clean <- tn93dist2[valid_idx]
                rawdist2_clean <- rawdist2[valid_idx]

                #run regression
                regress <- lm(rawdist2_clean ~ tn93dist2_clean)
		# get slope
		slope <- coef(regress)[2]
		# get r-squared
		Rsquared <- summary(regress)$r.squared
		output <- paste(dnafiles[i],slope,Rsquared,mean_dist,sd_dist,sep=",")
	}
	write(x=output,file="saturation_output.csv", append=T)
}
