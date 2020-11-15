FROM thomasweise/docker-pandoc-r

# install R packages
RUN Rscript -e 'install.packages(c("ggplot2", "knitr", "kableExtra"))'

# make project, output directory for mounting
RUN mkdir /project
RUN mkdir /project/output

# copy contents of local folder to project folder in container
COPY ./ /project/

# set an environment variable; since dockerfile comes with pandoc, pandoc-citeproc not worried about the bibliography ruining the whole report generation process
ENV biblio='y'

# make container entry point bash
CMD make -C project report
