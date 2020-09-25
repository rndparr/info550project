
## R packages
To analyze the data you will need to install some `R` packages. The required packages can be installed using `R` commands.

``` r
installed_pkgs <- row.names(installed.packages())
pkgs <- c("ggplot2", "knitr", "kableExtra")
for(p in pkgs){
	if(!(p %in% install_pkgs)){
		install.packages(p)
	}
}
```

## pandoc-citeproc (optional)
Report generation with citations and bibliography requires installing pandoc-citeproc.

### Ubuntu
``` bash
sudo apt-get update -y
sudo apt-get install -y pandoc-citeproc
```

### macOS
``` bash
brew install pandoc-citeproc 
```


## Execute the analysis

### With Citations/Bibliography (optional)
To execute the analysis, from the project folder run:
``` bash
Rscript -e "rmarkdown::render('report.Rmd')"
```
### No Citations/Bibliography
To execute the analysis without parsing citations, from the project folder you can run: 
``` bash
Rscript -e "rmarkdown::render('report.Rmd', output_format = rmarkdown::html_document(pandoc_args = NULL), params = list(usebiblio = 0))"
```
Both commands will create a file called `report.html` output in your directory that contains the results.


