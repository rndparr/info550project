#! /usr/local/bin/Rscript

args <- (commandArgs(TRUE))

if(length(args)==0) {
    stop("Error: No arguments supplied!")
} else {
    twas <- args[[1]]
}

data <- read.table('./clean_data/clean_data.txt', header = TRUE)

# get data for specific twas
twas_data <- data[data$TWAS == twas, c(2:5,7)]

# data for significant genes table
sig_data <- twas_data[twas_data$PVALUE <= 2.5e-6, c(4,1:3,5)]
colnames(sig_data) <- c('Gene','Chrom','Start','End','Pvalue')

# format pvalues
sig_data['Pvalue'] <- format(sig_data[['Pvalue']], scientific = TRUE, digits = 3)

# save data
write.table(sig_data, paste0('./clean_data/sig_data_', twas, '.txt'), col.names = TRUE, row.names = FALSE)

## OUTPUT
# ./clean_data/sig_data_breast.txt
# ./clean_data/sig_data_ovary.txt
