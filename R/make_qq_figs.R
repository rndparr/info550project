#! /usr/local/bin/Rscript

args <- (commandArgs(TRUE))

if(length(args)==0) {
    stop("Error: No arguments supplied!")
} else {
    twas <- args[[1]]
}

source('./R/functions.R')

# get plot data for specific twas
plot_data <- read.table(paste0('./clean_data/plot_data_', twas, '.txt'), header = TRUE)

# make, save qq plot
plot <- make_qq_plot(plot_data[['PVALUE']])
ggsave(paste0('./figs/qq_', twas, '.png'), 
	width = 1.75,
	height = 1.75)

## OUTPUT
# ./figs/qq_breast.png
# ./figs/qq_ovary.png
