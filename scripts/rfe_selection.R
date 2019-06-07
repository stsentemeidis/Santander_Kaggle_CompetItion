####
#### THIS SCRIPT SELECTS FEATURE USING A RECURSIVE FEATURE ELIMINATION
####
start_time<-Sys.time()
plot_counter <- 44

set.seed(2019)

# Feature Selection with Recursive Feature Elimination ----
subsets <- c(20, 30, 40, 50, 80, 100, 150)

ctrl <- rfeControl(
  functions = rfFuncs,
  method = "cv",
  number = 5,
  verbose = TRUE,
  allowParallel = TRUE
)


# sample dataset
sample_size = 50000
set.seed(2019)
idxs <- sample(1:nrow(df_train),sample_size,replace=F)
subsample <- df_train[idxs,]
pvalues = list()
for (col in names(df_train)) {
  if (class(df_train[,col]) %in% c("numeric","integer")) {
    # Numeric variable. Using Kolmogorov-Smirnov test
    
    pvalues[[col]] = ks.test(subsample[[col]],df_train[[col]])$p.value
    
  } else {
    # Categorical variable. Using Pearson's Chi-square test
    
    probs = table(df_train[[col]])/nrow(df_train)
    pvalues[[col]] = chisq.test(table(subsample[[col]]),p=probs)$p.value
    
  }
}


# Calculating RFE
if (calculate == TRUE) {
  
  library(doParallel)
  cl <- makePSOCKcluster(7)
  clusterEvalQ(cl, library(foreach))
  registerDoParallel(cl)
  print(paste0('[',
               round(
                 difftime(Sys.time(), start_time, units = 'mins'), 1
               ),
               'm]: ',
               'Starting RFE...'))
  time_fit_start <- Sys.time()
  
  results_rfe <-
    rfe(
      x = subsample[,!names(subsample) %in% c('ID_code','target')],
      y = as.factor(subsample[, 'target']),
      sizes = subsets,
      rfeControl = ctrl,
      metric = 'Accuracy',
      maximize = FALSE
    )
  time_fit_end <- Sys.time()
  stopCluster(cl)
  registerDoSeq()
  time_fit_duration_rfe <- time_fit_end - time_fit_start
  saveRDS(results_rfe, 'data/results_rfe.rds')
  saveRDS(time_fit_duration_rfe,
          'data/time_fit_duration_rfe.rds')
}

results_rfe <- readRDS('models/results_rfe.rds')
time_fit_duration_rfe <- readRDS('models/time_fit_duration_rfe.rds')


# Visualizing variable importance
varImp_rfe <-
 data.frame(
   'Variables' = attr(results_rfe$fit$importance[, 2], which = 'names'),
   'Importance' = as.vector(round(results_rfe$fit$importance[, 2], 4))
 )
varImp_rfe <- varImp_rfe[order(varImp_rfe$Importance), ]
varImp_rfe$perc <-round(varImp_rfe$Importance / sum(varImp_rfe$Importance) * 100, 4)
var_sel_rfe <- varImp_rfe[varImp_rfe$perc > 0.1, ]
var_rej_rfe <- varImp_rfe[varImp_rfe$perc <= 0.1, ]

ggplot(tail(varImp_rfe,50), aes(x = reorder(Variables, Importance), y = Importance)) +
 geom_bar(stat = 'identity') +
 coord_flip()


print(
  paste0(
    '[',
    round(difftime(Sys.time(), start_time, units = 'mins'), 1),
    'm]: ',
    'Feature Selection with Recursive Feature Elimination is done!'
  )
)
