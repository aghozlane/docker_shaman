FROM ubuntu:15.04

MAINTAINER Amine Ghozlane "amine.ghozlane@pasteur.fr"
#pandoc-citeproc   pandoc  sudo 

RUN apt-get update && apt-get install -y \
    r-base \
    wget \
    gdebi-core \
    libcurl4-openssl-dev\
    libcairo2-dev \
    libxt-dev \
    libxml2-dev \
    libxml2 \
    git \
    libssl-dev \
    libssh2-1-dev

#Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinythemes', 'shinyjs', 'Rcpp', 'rjson', 'devtools', 'psych', 'ggplot2', 'vegan', 'dendextend', 'plotly', 'circlize', 'googleVis', 'DT', 'RColorBrewer', 'ade4', 'scales', 'gplots'), repos='http://cran.rstudio.com/'); source('http://bioconductor.org/biocLite.R'); biocLite(c('BiocInstaller', 'genefilter', 'DESeq2')); options(download.file.method = 'wget'); devtools::install_github(c('aghozlane/biomformat', 'aghozlane/rNVD3', 'timelyportfolio/d3vennR', 'aghozlane/d3heatmap', 'aghozlane/scatterD3'))"""

COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf

RUN git clone https://github.com/aghozlane/shaman.git /srv/shiny-server/shaman && \
    mv /srv/shiny-server/shaman/* /srv/shiny-server/ && \
    rm -rf /srv/shiny-server/shaman && \
    chown -R shiny.shiny  /srv/shiny-server/

EXPOSE 80

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]