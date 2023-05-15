### logit regression
### train and test
library(caTools)
set.seed(123)

split <- sample.split(h1, SplitRatio = 0.8)
train <- subset(h1, split==T)
test <- subset(h1, split==F)
h1_mod <- glm(h1n1_vaccine ~ . , family="binomial", data=train)

# Predict probabilities using the imputed model
h1_prob <- predict(h1_mod, test, type="response")

h1_pred <- ifelse(h1_prob > 0.5, 1,0)

table(h1_pred, test$h1n1_vaccine)

### tpr = 70% fpr = ~ 13%
### 5935 data points
h1_logit_conf <- confusionMatrix(factor(h1_pred), test$h1n1_vaccine, positive="1")
h1_logit_conf

# Check the dimensions of the predicted probabilities
h1_labels <- h1$h1n1_vaccine[complete.cases(h1_prob)]
h1_pred <- ifelse(h1_prob > 0.5, 1,0)

### compute ROC curve
h2_pred <- prediction(h1_pred, h1[-train, ])
perf <- performance(h2_pred, "tpr", "fpr")
plot(perf)
warnings()

###
### seasonal vax ###
seas <- master_impute %>%
  select(-respondent_id, -h1n1_vaccine)

seas <- seas %>%
  mutate_if(is.integer, as.factor) %>%
  mutate_if(is.numeric, as.factor)

### Seasonal Vax Model 1 ###

### seasonal logit model
### tpr = 78 fpr = 21
### data = 5935

### train and test set
set.seed(123)
split_seas <- sample.split(seas, SplitRatio=0.8)
seas_train <- subset(seas, split==T)
seas_test <- subset(seas, split==F)

seas_mod <- glm(seasonal_vaccine ~ ., family="binomial", data=seas_train)

### probabilities
seas_prob <- predict(seas_mod, seas_test, type="response")

seas_pred <- ifelse(seas_prob > 0.5, 1, 0)


seas_logit_conf <- confusionMatrix(factor(seas_pred), seas_test$seasonal_vaccine, positive="1")
seas_logit_conf

### predict
seas_pred <- ifelse(seas_prob > 0.5, 1,0)

seas1_pred <- prediction(seas_pred, seas_test$seasonal_vaccine)

### performance
perf <- performance(seas1_pred, "tpr", "fpr")
plot(perf)
###

### combine both seas_prob & h1_prob
final <- cbind(h1_prob, seas_prob)
colnames(final) <- c("h1n1_vaccine", "seasonal_vaccine")

respondent_id <- seq(from= 26707, to=53414, by=1)

final <- cbind(final, respondent_id)

write.csv(final, "final.csv")