
# if biblio variable defined, the bibliography will be generated
ifeq ($(origin biblio),undefined)
biblio=n
endif

ifeq ($(biblio),n)
report_command="rmarkdown::render('report.Rmd', output_format = rmarkdown::html_document(pandoc_args = NULL), params = list(usebiblio = 0), output_file = '../output/report.html')"
else
report_command="rmarkdown::render('report.Rmd', quiet = TRUE, output_file = '../output/report.html')"	
endif

## report : generate final analysis report.
.PHONY: report
report: output/report.html

## install : install R packages "ggplot2", "knitr", "kableExtra" if not already installed
.PHONY: install
install: 
	Rscript -e 'installed_pkgs <- row.names(installed.packages()); pkgs <- c("ggplot2", "knitr", "kableExtra"); for(p in pkgs){ if(!(p %in% installed_pkgs)){install.packages(p)}}'

# PHONY rule for help
.PHONY: help
help: Makefile
	@sed -n 's/^##//p' $<

## clean : remove cleaned data files, report
.PHONY: clean
clean: 
	rm -f output/report.html clean_data/clean_data.txt clean_data/plot_data_*.txt clean_data/sig_data_*.txt figs/*.png

## build : build Docker image
.PHONY: build
build:
	docker build -t twasproject .

## report.html : using cleaned data, generate the report without bibliography
output/report.html: R/report.Rmd R/functions.R figs/man_breast.png figs/man_ovary.png figs/qq_breast.png figs/qq_ovary.png clean_data/sig_data_breast.txt clean_data/sig_data_ovary.txt
	cd R && Rscript -e $(report_command)


## figs/man_%.png : Make Manhattan plots
figs/man_%.png: R/make_man_figs.R clean_data/plot_data_%.txt
	chmod +x $< && \
	Rscript $< $*

## figs/man_%.png : Make QQ plots
figs/qq_%.png: R/make_qq_figs.R R/functions.R clean_data/plot_data_%.txt
	chmod +x $< && \
	Rscript $< $*

## clean_data/sig_data_%.txt : filter data for table of significant genes
clean_data/sig_data_%.txt: R/sig_data.R clean_data/clean_data.txt
	chmod +x $< && \
	Rscript $< $*

## clean_data/plot_data_%.txt : create data for plotting
clean_data/plot_data_%.txt: R/plot_data.R clean_data/clean_data.txt
	chmod +x $< && \
	Rscript $< $*

## clean_data/clean_data.txt : clean raw data
clean_data/clean_data.txt: R/clean_data.R raw_data/TWAS_data.txt
	chmod +x $< && \
	Rscript $<

# rule for figs
.PHONY: figs
figs: figs/man_breast.png figs/man_ovary.png figs/qq_breast.png figs/qq_ovary.png

# rule for plot data, significant gene table data
.PHONY: plot_sigdat
plot_sigdat: clean_data/plot_data_breast.txt clean_data/plot_data_ovary.txt clean_data/sig_data_breast.txt clean_data/sig_data_ovary.txt


# FILES
# ./figs/qq_breast.png
# ./figs/qq_ovary.png
# ./figs/man_breast.png
# ./figs/man_ovary.png
# ./clean_data/plot_data_breast.txt
# ./clean_data/plot_data_ovary.txt
# ./clean_data/sig_data_breast.txt
# ./clean_data/sig_data_ovary.txt
# ./clean_data/clean_data.txt
# ./raw_data/TWAS_data.txt
# ./biblio.bib
# ./citestyle.csl
