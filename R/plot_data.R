#! /usr/local/bin/Rscript

args <- (commandArgs(TRUE))

if(length(args)==0) {
    stop("Error: No arguments supplied!")
} else {
    twas <- args[[1]]
}

data <- read.table('./clean_data/clean_data.txt', header = TRUE)
# twas_name <- paste0(substr(twas,1,1), substr(twas,2,nchar(twas)))

# get data for specific twas
twas_data <- data[data$TWAS == twas, c(2:5,7)]

# data for plots
plot_data <- twas_data[, c(1,2,4,5)]
colnames(plot_data) <- c('CHR','POS','ID','PVALUE')
write.table(plot_data, paste0('./clean_data/plot_data_', twas, '.txt'), col.names = TRUE, row.names = FALSE)

## OUTPUT
# ./clean_data/plot_data_breast.txt
# ./clean_data/plot_data_ovary.txt

