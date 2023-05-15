### variable significance
library(leaps)
library(ROCR)

### regsubsets ###
h1_regsub <- regsubsets(h1n1_vaccine ~ h1n1_concern + h1n1_knowledge + behavioral_antiviral_meds + 
                          behavioral_avoidance + behavioral_face_mask + behavioral_wash_hands + 
                          behavioral_large_gatherings + behavioral_outside_home + behavioral_touch_face + 
                          doctor_recc_h1n1 + doctor_recc_seasonal + chronic_med_condition + 
                          child_under_6_months + health_worker + health_insurance + 
                          opinion_h1n1_vacc_effective + opinion_h1n1_risk + opinion_h1n1_sick_from_vacc + 
                          opinion_seas_vacc_effective + opinion_seas_risk + opinion_seas_sick_from_vacc + 
                          age_group + education + race + sex + income_poverty + marital_status + 
                          rent_or_own + employment_status + hhs_geo_region + census_msa + 
                          household_adults + employment_industry, really.big = T,
                        data=h1)

summary(h1_regsub)

### lasso regression

### train and test
library(caTools)
library(glmnet)
set.seed(123)

train <- sample(1:nrow(h1), nrow(h1) / 2) 
test <- (-train)
y.test <- y[test]


x <- model.matrix(h1n1_vaccine ~ ., h1)[, -1]
y <- as.numeric(h1$h1n1_vaccine)
grid <- 10^seq(10, -2, length = 100)
lasso.mod <- glmnet(x[train, ], y[train], alpha = 1, lambda = grid)

plot(lasso.mod)

### cv lasso
set.seed(1)

cv.out <- cv.glmnet(x[train, ], y[train], alpha = 1)
plot(cv.out)
bestlam <- cv.out$lambda.min

out <- glmnet(x, y, alpha = 1, lambda = grid)
lasso.coef <- predict(out, type = "coefficients", s = bestlam)[1:20, ]

lasso.coef