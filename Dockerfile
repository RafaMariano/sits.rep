FROM rafaelmariano/sits:1.12.6
RUN mkdir -p /usr/bin
RUN mkdir -p sits-rep
ADD ./ sits-rep
RUN rm sits-rep/Dockerfile
RUN R -e " install.packages('devtools');devtools::install_version('magrittr',version='1.5',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('caret',version='6.0-84',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('config',version='0.3',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('data.table',version='1.12.2',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('dendextend',version='1.12.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('e1071',version='1.7-2',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('ensurer',version='1.1',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_github('e-sensing/EOCubes',ref='893805526e3bbd782a7c026a37f878a071021a12');devtools::install_version('dplyr',version='0.8.3',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('dtw',version='1.20-1',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('dtwclust',version='5.5.4',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('dtwSat',version='0.2.5',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('flexclust',version='1.4-0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('ggplot2',version='3.2.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('Hmisc',version='4.2-0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('keras',version='2.2.4.1',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('kohonen',version='3.0.8',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('imputeTS',version='3.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('log4r',version='0.3.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('lubridate',version='1.7.4',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('MASS',version='7.3-51.4',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('mgcv',version='1.8-29',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('NbClust',version='3.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('nnet',version='7.3-12',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('openxlsx',version='4.1.0.1',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('proxy',version='0.4-23',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('purrr',version='0.3.2',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('ranger',version='0.11.2',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('raster',version='2.9-23',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('readr',version='1.3.1',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('reshape2',version='1.4.3',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('Rcpp',version='1.0.2',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('RCurl',version='1.95-4.12',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('rgdal',version='1.4-4',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('scales',version='1.0.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('sf',version='0.7-7',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('signal',version='0.7-6',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('stringr',version='1.4.0',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('tibble',version='2.1.3',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_github('e-sensing/wtss',ref='6e9c8e629c19001ea0fd162aa655e77bf3e598a6');devtools::install_version('zoo',version='1.8-6',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('magrittr',version='1.5',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_version('tibble',version='2.1.3',force=TRUE,upgrade=FALSE,repos='http://cloud.r-project.org/');devtools::install_github('e-sensing/inSitu',ref='287af9cde2969cb522b3c271d016b15d21196f4b'); "
RUN cd sits-rep && Rscript script-rep.R
