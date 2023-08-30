
# Flu Shot Learning: Predict H1N1 and Seasonal Flu Vaccines

Introduction
This project is based on the DrivenData competition focused on predicting the likelihood of individuals receiving their H1N1 and seasonal flu vaccines. The survey collected data from respondents who participated in the National 2009 H1N1 Flu Survey. The challenge is to predict the probabilities of individuals getting the H1N1 vaccine and the seasonal flu vaccine based on various features.

# Objective
Our goal is to predict the probabilities of individuals receiving the h1n1_vaccine and seasonal_vaccine labels using the provided dataset.

The results of the project will be evaluated using the area under the receiver operating characteristic curve (ROC AUC) for both h1n1_vaccine and seasonal_vaccine predictions. The mean of these two scores will determine the overall performance.

# Dataset Description
The dataset consists of 36 columns, with the first column "respondent_id" being a unique identifier. The remaining 35 features provide information about respondents' characteristics and opinions related to the flu vaccines.

# Features
Here are some of the features available in the dataset:

h1n1_concern: Level of concern about the H1N1 flu.
h1n1_knowledge: Level of knowledge about H1N1 flu.
behavioral_antiviral_meds: Whether the respondent has taken antiviral medications.
behavioral_avoidance: Whether the respondent has avoided close contact with others with flu-like symptoms.
behavioral_face_mask: Whether the respondent has bought a face mask.
behavioral_wash_hands - Has frequently washed hands or used hand sanitizer. (binary)
behavioral_large_gatherings - Has reduced time at large gatherings. (binary)
behavioral_outside_home - Has reduced contact with people outside of own household. (binary)
behavioral_touch_face - Has avoided touching eyes, nose, or mouth. (binary)
doctor_recc_h1n1 - H1N1 flu vaccine was recommended by doctor. (binary)
doctor_recc_seasonal - Seasonal flu vaccine was recommended by doctor. (binary)
chronic_med_condition - Has any of the following chronic medical conditions: asthma or an other lung condition, diabetes, a heart condition, a kidney condition, sickle cell anemia or other anemia, a neurological or neuromuscular condition, a liver condition, or a weakened immune system caused by a chronic illness or by medicines taken for a chronic illness. (binary)
child_under_6_months - Has regular close contact with a child under the age of six months. (binary)
health_worker - Is a healthcare worker. (binary)
health_insurance - Has health insurance. (binary)
opinion_h1n1_vacc_effective - Respondent's opinion about H1N1 vaccine effectiveness.
1 = Not at all effective; 2 = Not very effective; 3 = Don't know; 4 = Somewhat effective; 5 = Very effective.
opinion_h1n1_risk - Respondent's opinion about risk of getting sick with H1N1 flu without vaccine.
1 = Very Low; 2 = Somewhat low; 3 = Don't know; 4 = Somewhat high; 5 = Very high.
opinion_h1n1_sick_from_vacc - Respondent's worry of getting sick from taking H1N1 vaccine.
1 = Not at all worried; 2 = Not very worried; 3 = Don't know; 4 = Somewhat worried; 5 = Very worried.
opinion_seas_vacc_effective - Respondent's opinion about seasonal flu vaccine effectiveness.
1 = Not at all effective; 2 = Not very effective; 3 = Don't know; 4 = Somewhat effective; 5 = Very effective.
opinion_seas_risk - Respondent's opinion about risk of getting sick with seasonal flu without vaccine.
1 = Very Low; 2 = Somewhat low; 3 = Don't know; 4 = Somewhat high; 5 = Very high.
opinion_seas_sick_from_vacc - Respondent's worry of getting sick from taking seasonal flu vaccine.
1 = Not at all worried; 2 = Not very worried; 3 = Don't know; 4 = Somewhat worried; 5 = Very worried.
age_group - Age group of respondent.
education - Self-reported education level.
race - Race of respondent.
sex - Sex of respondent.
income_poverty - Household annual income of respondent with respect to 2008 Census poverty thresholds.
marital_status - Marital status of respondent.
rent_or_own - Housing situation of respondent.
employment_status - Employment status of respondent.
hhs_geo_region - Respondent's residence using a 10-region geographic classification defined by the U.S. Dept. of Health and Human Services. Values are represented as short random character strings.
census_msa - Respondent's residence within metropolitan statistical areas (MSA) as defined by the U.S. Census.
household_adults - Number of other adults in household, top-coded to 3.
household_children - Number of children in household, top-coded to 3.
employment_industry - Type of industry respondent is employed in. Values are represented as short random character strings.
employment_occupation - Type of occupation of respondent. Values are represented as short random character strings.



# Exploratory Data Analysis (EDA)
Our EDA will involve understanding the distribution of the target variables (h1n1_vaccine and seasonal_vaccine) and their relationships with the various features. We will also explore any patterns or correlations that might impact vaccine uptake.

To determine sufficient optimization of our model, I ran a backwards optimization algorythm. It firt evaluates model strength against a null model and then revaluates the model with one less variables. The model that performed the best contained 6 variables:
      
doctor_recc_h1n1, 
opinion_h1n1_vacc_effective, 
health_worker, 
opinion_h1n1_risk,
age_group, 
h1n1_vaccine         


# Model and Approach
For this project, we will utilize a classification approach to predict the binary outcomes for h1n1_vaccine and seasonal_vaccine. As a performance metric, we will use the ROC AUC score, which provides insights into the model's ability to distinguish between positive and negative cases.

For both target labels I used the below models:
1) Logit model as a baseline
2) Random Forest Model
3) Cross Validation Tree Model

# Proof of Submission
![image](https://github.com/jconns/Predict-H1N1-And-Seasonal-Flu/assets/48659723/1d143a82-0e7a-438b-bce2-092732d098d6)

