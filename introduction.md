# Diabetes Prediction Application

This is a Shiny application for predicting the presence of diabetes in a subset of patients. The application follows the flow of the data science lifecycle for a binary classification problem. It is interactive and allows the user to iterate through the steps to improve the performance of the model.

## About the Dataset:
This dataset is originally from the *National Institute of Diabetes and Digestive and Kidney Diseases*. The objective of the dataset is to diagnostically predict whether or not a patient has diabetes based on certain diagnostic measurements included in the dataset. Several constraints were placed on the selection of these instances from a larger database. In particular, all patients here are females at least 21 years old of Pima Indian heritage. Southwestern native Americans, including Navajo and Pueblo, have the highest rates of diabetes in the world. This is believed to be caused by genetic and environmental factors.

*(Sources: Kaggle Dataset, Genetics of Type II Diabetes)*


## About the columns:

| Field         | Definition |
| ------------- | ---------- |
| Pregnancies   | Number of times pregnant |
| Glucose       | Plasma glucose concentration |
| BloodPressure | Diastolic blood pressure (mm Hg) |
| SkinThickness | Triceps skin fold thickness (mm) |
| Insulin       | 2-Hour serum insulin (mu U/ml) |
| BMI           | Body mass index |
| DiabetesPedigreeFunction | Diabetes pedigree function |
| Age                      | Age (years) |
| Outcome                  | Class variable (0 or 1) 268 of 768 are 1, the others are 0 |

*(Source: Kaggle Dataset)*

## About the Algorithm:
This application uses a logistic regression model. Logistic regression is the go-to algorithm for binary classification problems because it is a simple and statistically convinient algorithm. 

Here are some basic characteristics of a logistic regression model:
- **Linear Classifier** ~ The model learns based on a linear combination of input variables.
- **Stochastic** ~ When testing, the model returns a conditional probability. The likelihood of Y given inputs X.
- **Interpretable** ~ The impact of each input variable in the model can be observed by the variable weights.

*(Source: Linear Regression)*

## Outcomes
The data exploration showed that several variables have zero values which may indicate missing measurements. These variables include `Glucose`, `BloodPressure`, `SkinThickness`, `Insulin`, and `BMI`. Since logistic regression models cannot handle missing values, I added the option to impute these missing values with the mean of the non-missing values in the column.

One outcome was to determine which input variables are most useful for diagnosising diabetes using backward elimination. I created a model using all available variables, and then removed the variable with the highest p-value until all variables had a p-value of less than 0.05. With this method, the significant variables are `Pregnancies`, `Glucose`, and `BMI`.

Based on F1 score, the best model I found had a score of 0.59 and used `Glucose`, `BMI`, `Age`, and `BloodPressure`. The missing values were imputed for `Glucose`.

The best model based only on only a single variable uses `Glucose` with mean imputation. The model had an F1 score of 0.54. 

The model I would recommend is trained on `Glucose`, `BMI`, and `Age` with mean imutation for `Glucose` and `BMI`. Although adding the `BloodPressure` feature improves performance, it may be overfitting the test data. The model has a weight of `-0.009028` which is strange because it is generally believed that there is a positive correlation between blood pressure and diabetes. Also, the p-value is `0.127` which is not statistically significant. The model I recommend has an F-score of 0.57.

## Sources:
 - Kaggle Dataset
     - https://www.kaggle.com/uciml/pima-indians-diabetes-database
 - Genetics of Type II Diabetes
     - https://web.archive.org/web/20060616041636/http://darwin.nmsu.edu/~molbio/diabetes/disease.html
 - Analysis Inspiration
     - https://www.kaggle.com/lbronchal/pima-indians-diabetes-database-analysis
 - Application framework
     - https://shiny.rstudio.com/
 - Logistic Regression
     - https://www.stat.cmu.edu/~cshalizi/uADA/12/lectures/ch12.pdf