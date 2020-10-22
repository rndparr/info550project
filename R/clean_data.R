#! /usr/local/bin/Rscript

data <- read.table('./raw_data/TWAS_data.txt', 
	header = TRUE, sep = '\t', row.names = 1, skipNul = TRUE,
	col.names = c('TWAS','CHROM','GeneStart',
		'GeneEnd', 'TargetID', 'GeneName',
		'n_snps','ZScore', 'PVALUE'),
	colClasses = c('integer','character', 'integer', 
		'integer', 'integer', 'NULL', 
		'character', 'NULL', 'numeric', 'NULL'))

data['PVALUE'] <- exp(pchisq(data[['ZScore']]^2, 1, lower.tail=FALSE, log.p = TRUE))

# sort by TWAS, pvalue, chrom
data <- data[order(data$TWAS, data$PVALUE, data$CHROM), ]

# lower case
data$TWAS <- tolower(data$TWAS)

write.table(data, './clean_data/clean_data.txt', col.names = TRUE, row.names = FALSE)

