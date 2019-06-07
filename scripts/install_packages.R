##################################################################################################
################################ INSTALL PACKAGES   ##############################################
packages_list <- c('readxl',
                   'clustrd',
                   'lubridate',
                   'caretEnsemble',
                   'ggrepel',
                   'arm',
                   'rpart.plot',
                   'rpart',
                   'MLmetrics',
                   'ROCR',
                   'tidyr',
                   'ggplot2',
                   'corrplot',
                   'InformationValue',
                   'GGally',
                   'gridExtra',
                   'tree',
                   'leaflet',
                   'jtools',
                   'lattice',
                   'car',
                   'caret',
                   'MASS',
                   'ggthemes',
                   'RColorBrewer',
                   'reshape',
                   'tidyverse',
                   'glmnet',
                   'dummies',
                   'fastDummies',
                   'e1071',
                   'dplyr',
                   'anchors',
                   'mlbench',
                   'boot',
                   'gridExtra',
                   'datasets',
                   'scales',
                   'ggplot2',
                   'fpc',
                   'gbm',
                   'data.table',
                   'grid',
                   'proj4',
                   'mapproj',
                   'ggmap',
                   'ggplot2',
                   'maps',
                   'geosphere',
                   'leaderCluster'
)

for (i in packages_list){
  if(!i%in%installed.packages()){
    install.packages(i, dependencies = TRUE)
    library(i, character.only = TRUE)
    print(paste0(i, ' has been installed'))
  } else {
    print(paste0(i, ' is already installed'))
    library(i, character.only = TRUE)
  }
}

# Palette Colour
color1 = 'black'
color2 = 'white'
color3 = 'gold1'
color4 = 'darkorchid3'
font1 = 'Impact'
font2 = 'Helvetica'
