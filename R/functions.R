#! /usr/local/bin/Rscript

library(ggplot2)
library(kableExtra)

# generates qq plot of gene p-values
make_qq_plot <- function(pvector, size=8) {
    pvector = pvector[!is.na(pvector)]
    o = -log10(sort(pvector, decreasing=F))
    e = -log10( 1:length(o)/length(o) )
    max_lim <- max(c(max(e), max(o[o<Inf])))
    qplot(e, o) + xlim(c(0, max_lim)) + ylim(c(0, max_lim)) + 
        labs(x = "Expected", y = "Observed") + 
        geom_abline(intercept = 0, slope = 1, colour = "red") + 
    theme(text = element_text(size = size))
}

# generates manhattan plot of gene log p-values, line drawn at genome-wide significance level
make_man_plot <- function(manPlot_dt, chr_vec = 1:22, ntop = 3, 
		sig_level = 2.5e-6, size=10, chrGAP = 500, 
		colors=c('#44B5AD', '#3A948E', '#36807A', '#2f615d')){

    sig_label = paste0('-log(',sig_level,')')
    endPos = 0;
    plotPos = NULL; temp_dt = NULL; 
    chrEnd = NULL; LabBreaks = NULL; xlabels = NULL;
    for (chr in chr_vec) {
        temp = manPlot_dt[manPlot_dt$CHR == chr, ]
        temp$POS = order(temp$POS)
        if(nrow(temp)>0){
            temp_dt = rbind(temp_dt, temp)  
            chrPos = (temp$POS - min(temp$POS, na.rm = TRUE) ) + endPos + 1
            endPos = max(chrPos, na.rm = TRUE) + chrGAP
            plotPos = c(plotPos, chrPos)
            yline_pos = max(chrPos, na.rm = TRUE) + chrGAP/2
            chrEnd = c(chrEnd, yline_pos)
            LabBreaks = c(LabBreaks, mean(chrPos, na.rm = TRUE) )
            xlabels = c(xlabels, chr)
        }
    }
    manPlot_dt_sort = data.frame(plotPos = plotPos, temp_dt)
    ggplot(manPlot_dt_sort, 
    	aes(plotPos, -log10(PVALUE), color=factor(CHR), label=ID)) + 
    geom_point(size=2,alpha=0.9) + 
    guides(color = FALSE) + 
    scale_color_manual(values = rep(colors, 22)) +
    geom_hline(yintercept = -log10(sig_level), 
    	linetype="dashed", size=1, color = "black") +
    labs(x = "Chromosome", y = "-log10(PVALUE)") + 
    scale_x_continuous(breaks = LabBreaks, 
    	labels = xlabels, expand=c(0.01, 0)) + 
    coord_cartesian(clip = 'off') +
    scale_y_continuous(expand = c(0.01, 0)) +
    theme(text = element_text(size = size), 
        axis.text.x = element_text(face = "bold", 
        	size=size-1, angle=-90, vjust=0.5, hjust=0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank()
        )
}

# generate table of significant genes from provided twas
make_sig_table <- function(sig_data){
	return(scroll_box(
		kable_paper(
			kable_styling(
				kbl(sig_data, row.names = FALSE), 
				full_width = F, position = 'center',
				bootstrap_options = c('striped','hover')), 
			full_width = F), 
		fixed_thead = T, width = '400px', height = '500px'))
}

