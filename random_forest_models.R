#### model 2 ####
### significant variables only ###
### lasso variables
### TPR = 62% 
h1n1_lasso_vars <- glm(h1n1_vaccine ~ health_insurance + health_worker + 
                         doctor_recc_h1n1 + h1n1_knowledge, data=train, family="binomial")

h1n1_lasso_vard_prob <- predict(h1n1_lasso_vars, test, type="response")

h1n1_lasso_vard_pred <- ifelse(h1n1_lasso_vard_prob > 0.5, 1,0)

confusionMatrix(factor(h1n1_lasso_vard_pred), test$h1n1_vaccine, positive="1")

### h1n1
### step function
library(leaps)
sig_model <- step(h1_mod, direction ="backward")

### stat sig model
sig_logit <- glm(sig_model, family="binomial", data=train)

### fit sig logit for final output
sig_logit_prob <- predict(sig_logit, test, type="response")

h1n1_sig_logit_pred <- ifelse(sig_logit_prob > 0.5, 1, 0)

h1n1_sig_conf <- confusionMatrix(factor(h1n1_sig_logit_pred), test$h1n1_vaccine, positive="1")
h1n1_sig_conf

### seasonal vaccine
seas_sig_model <- step(seas_mod, direction="backward")
summary(seas_sig_model)

seas_logit <- glm(seas_sig_model, family="binomial", data=seas_train)

seas_sig_prob <- predict(seas_logit, seas_test, type="response")

seas_sig_pred <- ifelse(seas_sig_prob > 0.5, 1,0)

confusionMatrix(factor(seas_sig_pred), seas_test$seasonal_vaccine, positive="1")


sig_final <- data.frame(sig_logit_prob, seas_sig_prob)

colnames(sig_final) <- c("h1n1_vaccine", "seasonal_vaccine")

write.csv(sig_final, "sig_final.csv")
##

### random forest model ###
library(randomForest)
library(caTools)
### h1n1
### partition data
set.seed(123)
split <- sample.split(h1, SplitRatio=0.8)

### train & test
train <- subset(h1, split==T)
test <- subset(h1, split==F)

### random forest model
rf <- randomForest(h1n1_vaccine ~ ., data=train, mtry=12, importance=T)

plot(rf)
### test bag_loan on test set
yhat_bag <- predict(rf, newdata = test)

## confusion matrix
rfcm <- caret::confusionMatrix(yhat_bag, test$h1n1_vaccine,
                               positive="1")

rfcm

### randomForest lasso optimal variables
### Does worse than the full randomForest Model
### TPR = 61%
rf_optimal <- randomForest(h1n1_vaccine ~ health_insurance + health_worker + doctor_recc_h1n1 +
                             h1n1_knowledge, data=train, mtry=4, importance=T)

yhat_bag_optimal <- predict(rf_optimal, newdata = test)

## confusion matrix
rfcm_optimal <- caret::confusionMatrix(yhat_bag_optimal, test$h1n1_vaccine,
                                       positive="1")

rfcm_optimal