### h1n1 full data random forest prediction
rf_full <- randomForest(h1n1_vaccine ~ ., data=h1, mtry=12, importance=T)

h1n1_rf_prob <- predict(rf_full, type="prob")

h1n1_rf_prob <- h1n1_rf_prob[, 2]
###

### random forest for seasonal vax
rf_seas <- randomForest(seasonal_vaccine ~ ., data=seas, mtry=12, importance=T)

rf_seas_prob <- predict(rf_seas, type="prob")

rf_seas_pred <- predict(rf_seas, newdata=seas_test)


caret::confusionMatrix(rf_seas_pred, seas_test$seasonal_vaccine, 
                       positive="1")

rf_seas_prob <- rf_seas_prob[, 2]

rf_final <- data.frame(h1n1_rf_prob, rf_seas_prob)

colnames(rf_final) <- c("h1n1_vaccine", "seasonal_vaccine")

write.csv(rf_final, "rf_final.csv")
###

### model 3 ###
### cv tree ###
### h1n1 vax ###
### train and test
set.seed(123)
tree_train <- sample(1:nrow(h1), 1300)
tree_h1_test <- h1[-tree_train, ]

h1n1_tree_test <- tree_h1_test$h1n1_vaccine

### tree regression
library(tree)
h1n1_tree <- tree(h1n1_vaccine ~ h1n1_knowledge + behavioral_face_mask + behavioral_large_gatherings +
                    doctor_recc_h1n1 + doctor_recc_seasonal + chronic_med_condition + child_under_6_months +
                    health_worker + health_insurance + opinion_h1n1_vacc_effective + opinion_h1n1_risk +
                    age_group + education + race + income_poverty + rent_or_own + hhs_geo_region +
                    employment_industry + household_adults, data = h1, 
                  subset = tree_train)

### plot h1n1 tree
plot(h1n1_tree)
text(h1n1_tree, pretty = 0)

### h1n1 tree pred
h1n1_tree_pred <- predict(h1n1_tree, tree_h1_test, type = "class")

table(h1n1_tree_pred, h1n1_tree_test)

### confusion matrix tree
confusionMatrix(h1n1_tree_pred, h1n1_tree_test, positive="1")

### cv prune
set.seed(7)

h1n1_cv_tree <- cv.tree(h1n1_tree, FUN = prune.misclass)

h1n1_cv_tree$size
h1n1_cv_tree$dev

### plot
par(mfrow = c(1, 2))
plot(h1n1_cv_tree$size, h1n1_cv_tree$dev, type = "b") 
plot(h1n1_cv_tree$k, h1n1_cv_tree$dev, type = "b")

dev.off() 
### prune to get the tree w optimal nodes ###
### 2 nodes only creates credit history as the predictor ###
h1n1_prune_tree <- prune.misclass(h1n1_tree, best = 3)

plot(h1n1_prune_tree)
text(h1n1_prune_tree, pretty = 0)

### test pruned tree
### test accuracy rate is 81% which is our best test error yet
tree_pred <- predict(h1n1_prune_tree, tree_h1_test, type = "class")
table(tree_pred, h1n1_tree_test)

confusionMatrix(tree_pred, h1n1_tree_test, positive="1")

### pruned tree wins again so let's use it on all h1n1 data
h1n1_tree_full <- tree(h1n1_vaccine ~ h1n1_knowledge + behavioral_face_mask + behavioral_large_gatherings +
                         doctor_recc_h1n1 + doctor_recc_seasonal + chronic_med_condition + child_under_6_months +
                         health_worker + health_insurance + opinion_h1n1_vacc_effective + opinion_h1n1_risk +
                         age_group + education + race + income_poverty + rent_or_own + hhs_geo_region +
                         employment_industry + household_adults, data = h1)


h1n1_cv_tree_full <- cv.tree(h1n1_tree_full, FUN = prune.misclass)

h1n1_cv_tree_full$size
h1n1_cv_tree_full$dev

### prune to get the tree w optimal nodes ###
### 2 nodes only creates credit history as the predictor ###
h1n1_prune_tree_full <- prune.misclass(h1n1_tree_full, best = 7)

### test pruned tree
### test accuracy rate is 81% which is our best test error yet
h1_tree_pred_full <- predict(h1n1_prune_tree_full, type = "vector")[,2]


seasonal_tree_full <- tree(seasonal_vaccine ~ h1n1_knowledge + behavioral_face_mask + behavioral_large_gatherings +
                             doctor_recc_h1n1 + doctor_recc_seasonal + chronic_med_condition + child_under_6_months +
                             health_worker + health_insurance + opinion_h1n1_vacc_effective + opinion_h1n1_risk +
                             age_group + education + race + income_poverty + rent_or_own + hhs_geo_region +
                             employment_industry + household_adults, data = seas)


seas_cv_tree_full <- cv.tree(seasonal_tree_full, FUN = prune.misclass)

h1n1_cv_tree_full$size
h1n1_cv_tree_full$dev

### prune to get the tree w optimal nodes ###
### 2 nodes only creates credit history as the predictor ###
seas_prune_tree_full <- prune.misclass(seasonal_tree_full, best = 7)

### test pruned tree
### test accuracy rate is 81% which is our best test error yet
seas_tree_pred_full <- predict(seas_prune_tree_full, type = "vector")[,2]

tree_final <- data.frame(h1_tree_pred_full ,seas_tree_pred_full)
colnames(tree_final) <- c("h1n1_vaccine", "seasonal_vaccine")
write.csv(tree_final, "tree_final.csv")

library(tree)
h1n1_lasso_vars_tree <- tree(h1n1_vaccine ~ health_insurance + health_worker + 
                               doctor_recc_h1n1 + h1n1_knowledge, data=train)

plot(h1n1_lasso_vars_tree)
text(h1n1_lasso_vars_tree, pretty=0)

### cv tree
set.seed(7)

h1n1_lasso_vars_cv_tree <- cv.tree(h1n1_lasso_vars_tree, FUN = prune.misclass)

h1n1_lasso_vars_cv_tree$size
h1n1_lasso_vars_cv_tree$dev

### plot
par(mfrow = c(1, 2))
plot(h1n1_lasso_vars_cv_tree$size, h1n1_lasso_vars_cv_tree$dev, type = "b") 
plot(h1n1_lasso_vars_cv_tree$k, h1n1_lasso_vars_cv_tree$dev, type = "b")

dev.off() 
### prune to get the tree w optimal nodes ###
### 2 nodes only creates credit history as the predictor ###
h1n1_lasso_cv_prune_tree <- prune.misclass(h1n1_lasso_vars_tree, best = 3)

plot(h1n1_lasso_cv_prune_tree)
text(h1n1_lasso_cv_prune_tree, pretty = 0)

### test pruned tree
### test accuracy rate is 81% which is our best test error yet
lasso_vars_tree_pred <- predict(h1n1_lasso_cv_prune_tree, test, type = "class")
table(lasso_vars_tree_pred, test$h1n1_vaccine)

confusionMatrix(lasso_vars_tree_pred, test$h1n1_vaccine, positive="1")

