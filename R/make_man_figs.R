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

# make, save manhattan plot
plot <- make_man_plot(plot_data)
ggsave(paste0('./figs/man_', twas, '.png'), 
	width = 5,
	height = 3)


## OUTPUT
# ./figs/man_breast.png
# ./figs/man_ovary.png
