###### READ FILES
df_train <- readRDS('data/train.rda')
df_test <- readRDS('data/test.rda')

###### KEEP NUMERIC AS COMMON DATA TYPE
for (i in colnames(df_train)){
  df_train[,i] <- as.numeric(df_train[,i])
}
for (i in colnames(df_test)){
  df_test[,i] <- as.numeric(df_test[,i])
}

###### READ SCIRPTS
source('scripts/install_packages.R')
source('scripts/fct_plot_correlation.R')
source('scripts/split_process.R')
source('scripts/param_grid.R')
source('scripts/model_glm.R')
 

# ###### CALCULATE CORRELATIONS
# train_corr <- readRDS('data/train_corr.rds')
# train_corr <- as.data.frame(train_corr)
# test_corr  <- readRDS('data/test_corr.rds')
# test_corr  <- as.data.frame(test_corr)
# 
# ###### TRY REMOVING CORRELATION (not helpful totally uncorrelated)
# findCorrelation(train_corr, cutoff = 0.1, verbose = FALSE, names = FALSE,exact = ncol(train_corr) < 100)
# 
# ###### RFE ON SAMPLE TO DETERMINE VARIMP
# calculate <- TRUE
# source('scripts/rfe_selection.R')
# 
# ###### CLUSTERING WITH KMEANS
# ## Need to change the variables to take into account
# calculate <- TRUE
# source('scripts/fe_clustering.R')


# Baseline Logistic Regression ----
pipeline_glm(target = 'target', train_set = df_train_A_proc,
             valid_set = df_train_B_proc, test_set = df_test_proc,
             trControl = fitControl, tuneGrid = glmnet_grid,
             suffix = 'baseline', calculate = FALSE, seed = seed,
             n_cores = detectCores()-1)
