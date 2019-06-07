
####
#### THIS SCRIPT SPLIT THE TRAIN SET AND 
####

seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)

# Splitting Train Set into two parts ----
df_train[,'target'] <- ifelse(df_train[,'target'] == 0, 'No', 'Yes')

index <-
  createDataPartition(df_train$target,
                      p = 0.8,
                      list = FALSE,
                      times = 1)
df_train_A <- df_train[index,]
df_train_B <- df_train[-index,]

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ), 'm]: '), ''),
  'Train Set is split!'))


# Center and Scale Train Sets and Test Set ----
preProcValues <- preProcess(df_train_A[ ,!names(df_train_A) %in% c('ID_code','target')], method = c("range"), rangeBounds = c(0, 1) )
df_train_A_proc <- predict(preProcValues, df_train_A)
df_train_B_proc <- predict(preProcValues, df_train_B)
df_test_proc <- predict(preProcValues, df_test)

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ), 'm]: '), ''),
  'Data Sets are centered and scaled!'
))