# Telecom_Churn_Analysis

## Table of Contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Project Workflow](#project-workflow)

### Introduction
- Introduction to Churn Analysis

In the competitive world of business, keeping customers is essential for long-term success. Churn analysis helps businesses understand why customers leave and how to prevent it. By examining customer data, companies can find patterns and reasons behind these departures. Using advanced data analytics and machine learning, businesses can predict which customers are likely to leave and identify the main reasons behind their decision. This insight allows companies to take action to increase customer satisfaction and build loyalty.

- Who is the Target Audience

While this project focuses on churn analysis for a telecom company, the techniques and insights can be used in many other industries. Whether it's retail, finance, healthcare, or any business that aims to keep its customers, churn analysis can be valuable. We will cover the methods, tools, and best practices to reduce churn and boost customer loyalty, turning data into practical steps for lasting success.

### Project Overview

Project Target
The goal of this project is to create a complete ETL (Extract, Transform, Load) process in a database and design a Power BI dashboard using customer data to achieve the following:

Visualize and Analyze Customer Data at different levels:

- Demographic Information
- Geographic Information
- Payment and Account Details
- Service Usage
- Study Churner Profiles and identify areas for implementing marketing campaigns.
- **Develop a Method to Predict Future Churners**

### Key Metrics to Track
- Total Customers
- Total Churn and Churn Rate
- New Joiners

### Dataset

The dataset used in this project is titled as customer_data.csv and is attached in this repo. Along with this the file to sql queries and the PowerBI dashboard file is also attached. You can check it out to understad the project's query and visual part.

### Project Workflow

### Step 1: ETL Process in SQL Server
The first step in churn analysis is loading the data from our source file. We will use Microsoft SQL Server because it is a reliable solution for handling recurring data loads and maintaining data integrity compared to using Excel files.

- 1. Creating the Database:
  Open SMSS, click on the NEW QUERY button and run the following command to create a new database named churn_db:
  ```SQL
  create database churn_db;
  ```
- 2. Import CSV Data into SQL Server:
- Right-click on the newly created database (db_Churn) and go to: Tasks → Import → Flat file → Browse CSV file.
- Set the customerId as the primary key and allow null values for other columns to avoid errors during data load.
- Change the data type of any field labeled as BIT to Varchar(50) since the import wizard handles Varchar(50) better.

## Data Exploration and Cleaning
- Step 1: Check Distinct Values
To understand the distribution of values in key columns, run the following queries:
- Gender Distribution:
```SQL
select gender, count(gender) as totalcount,
count(gender) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by gender;
```
- Contract Types:
```SQL
select contract, count(contract) as totalcount,
count(contract) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by contract;
```
- Customer Status and Revenue:
```SQL
select customer_status, count(customer_status) as totalcount, sum(total_revenue) as totalrev,
sum(total_revenue) / (select sum(total_revenue) from customer_data) * 100 as revpercentage
from customer_data
group by customer_status;
```
- State-wise Distribution:
```SQL
select state, count(state) as totalcount,
count(state) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by state
order by percentage desc;
```
- Step 2: Check for Null Values
To identify columns with missing values in the dataset, use this query:
```SQL
select 
    sum(case when customer_id is null then 1 else 0 end) as customer_id_null_count,
    sum(case when gender is null then 1 else 0 end) as gender_null_count,
    sum(case when age is null then 1 else 0 end) as age_null_count,
    sum(case when married is null then 1 else 0 end) as married_null_count,
    sum(case when state is null then 1 else 0 end) as state_null_count,
    sum(case when number_of_referrals is null then 1 else 0 end) as number_of_referrals_null_count,
    sum(case when tenure_in_months is null then 1 else 0 end) as tenure_in_months_null_count,
    sum(case when value_deal is null then 1 else 0 end) as value_deal_null_count,
    sum(case when phone_service is null then 1 else 0 end) as phone_service_null_count,
    sum(case when multiple_lines is null then 1 else 0 end) as multiple_lines_null_count,
    sum(case when internet_service is null then 1 else 0 end) as internet_service_null_count,
    sum(case when internet_type is null then 1 else 0 end) as internet_type_null_count,
    sum(case when online_security is null then 1 else 0 end) as online_security_null_count,
    sum(case when online_backup is null then 1 else 0 end) as online_backup_null_count,
    sum(case when device_protection_plan is null then 1 else 0 end) as device_protection_plan_null_count,
    sum(case when premium_support is null then 1 else 0 end) as premium_support_null_count,
    sum(case when streaming_tv is null then 1 else 0 end) as streaming_tv_null_count,
    sum(case when streaming_movies is null then 1 else 0 end) as streaming_movies_null_count,
    sum(case when streaming_music is null then 1 else 0 end) as streaming_music_null_count,
    sum(case when unlimited_data is null then 1 else 0 end) as unlimited_data_null_count,
    sum(case when contract is null then 1 else 0 end) as contract_null_count,
    sum(case when paperless_billing is null then 1 else 0 end) as paperless_billing_null_count,
    sum(case when payment_method is null then 1 else 0 end) as payment_method_null_count,
    sum(case when monthly_charge is null then 1 else 0 end) as monthly_charge_null_count,
    sum(case when total_charges is null then 1 else 0 end) as total_charges_null_count,
    sum(case when total_refunds is null then 1 else 0 end) as total_refunds_null_count,
    sum(case when total_extra_data_charges is null then 1 else 0 end) as total_extra_data_charges_null_count,
    sum(case when total_long_distance_charges is null then 1 else 0 end) as total_long_distance_charges_null_count,
    sum(case when total_revenue is null then 1 else 0 end) as total_revenue_null_count,
    sum(case when customer_status is null then 1 else 0 end) as customer_status_null_count,
    sum(case when churn_category is null then 1 else 0 end) as churn_category_null_count,
    sum(case when churn_reason is null then 1 else 0 end) as churn_reason_null_count
from customer_data;
```
- Step 3: Handle Null Values and Insert Clean Data into the Production Table
Clean the data by replacing null values with default values and insert the cleaned data into the production table:
```SQL
select 
    customer_id,
    gender,
    age,
    married,
    state,
    number_of_referrals,
    tenure_in_months,
    isnull(value_deal, 'None') as value_deal,
    phone_service,
    isnull(multiple_lines, 'No') as multiple_lines,
    internet_service,
    isnull(internet_type, 'None') as internet_type,
    isnull(online_security, 'No') as online_security,
    isnull(online_backup, 'No') as online_backup,
    isnull(device_protection_plan, 'No') as device_protection_plan,
    isnull(premium_support, 'No') as premium_support,
    isnull(streaming_tv, 'No') as streaming_tv,
    isnull(streaming_movies, 'No') as streaming_movies,
    isnull(streaming_music, 'No') as streaming_music,
    isnull(unlimited_data, 'No') as unlimited_data,
    contract,
    paperless_billing,
    payment_method,
    monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    customer_status,
    isnull(churn_category, 'Others') as churn_category,
    isnull(churn_reason , 'Others') as churn_reason
into prod_churn
from customer_data;
```
- Step 4. Creating Views for Power BI Integration
- Create a View for Churned and Stayed Customers:
```SQL
go
create view vw_churndata as
    select * from prod_churn where customer_status in ('Churned', 'Stayed');
```
- Create a View for New Customers:
```SQL
go
create view vw_joindata as
    select * from prod_churn where customer_status = 'Joined';
```
### Step 2: Power BI Transform

- Add a new column (Churn Status) in prod_churn
1.       Churn Status = if [customer_status] = "Churned" then 1 else 0
2.       Change Churn Status data type to numbers
3.       Monthly Charge Range = if [Monthly_Charge] < 20 then "< 20" else if [Monthly_Charge] < 50 then "20-50" else if [Monthly_Charge] < 100 then "50-100" else "> 100"

- Create a New Table Reference for mapping_agegrp
1. Keep only Age column and remove duplicates
2. Age Group = if [age] < 20 then "< 20" else if [age] < 36 then "20 - 35" else if [age] < 51 then "36 - 50" else "> 50"
3. AgeGrpSorting = if [Age Group] = "< 20" then 1 else if [Age Group] = "20 - 35" then 2 else if [Age Group] = "36 - 50" then 3 else 4
4. Change data type of AgeGrpSorting to Numbers.

- Create a new table reference for mapping_tenuregrp
1.       Keep only Tenure_in_Months and remove duplicates
2.       Tenure Group = if [tenure_in_months] < 6 then "< 6 Months" else if [tenure_in_months] < 12 then "6-12 Months" else if [tenure_in_months] < 18 then "12-18 Months" else if [tenure_in_months] < 24 then "18-24 Months" else ">= 24 Months"
3.       TenureGrpSorting = if [tenure_in_months] = "< 6 Months" then 1 else if [tenure_in_months] =  "6-12 Months" then 2 else if [tenure_in_months] = "12-18 Months" then 3 else if [tenure_in_months] = "18-24 Months " then 4 else 5
4.       Change data type of TenureGrpSorting  to Numbers

- Create a new table reference for prod_Services

1.       Unpivot services columns

2.       Rename Column – Attribute >> Services & Value >> Status

### STEP 3: Power BI Measure
Total Customers = Count(prod_churn[customer_id])

New Joiners = CALCULATE(COUNT(prod_churn[customer_iD]), prod_churn[customer_status] = "Joined")

Total Churn = SUM(prod_churn[Churn Status])

Churn Rate = [Total Churn] / [Total Customers]

![churn_analysis_summary](https://github.com/user-attachments/assets/8fd77b6a-937e-4921-b802-35454da141ea)


### STEP 4: Power BI Visualization
- Summary Page
1.  Top Card
a.       Total Customers
b.       New Joiners
c.       Total Churn
d.       Churn Rate%

2.  Demographic
a.       Gender – Churn Rate
b.       Age Group – Total Customer & Churn Rate

3.  Account Info
a.       Payment Method – Churn Rate
b.       Contract – Churn Rate
c.       Tenure Group - Total Customer & Churn Rate

4.  Geographic
a.       Top 5 State – Churn Rate

5.  Churn Distribution
a.       Churn Category – Total Churn
b.       Tooltip : Churn Reason – Total Churn

6.  Service Used
a.       Internet Type – Churn Rate
b.       prod_Service >> Services – Status – % RT Sum of Churn Status

Churn Reason Page (Tooltip)
1.  Churn Reason – Total Churn

### STEP 5: Predict Customer Churn
For predicting customer churn, we will be using a widely used Machine Learning algorithm called RANDOM FOREST.

**What is Random Forest?** A random forest is a machine learning algorithm that consists of multiple decision trees. Each decision tree is trained on a random subset of the data and features. The final prediction is made by averaging the predictions (in regression tasks) or taking the majority vote (in classification tasks) from all the trees in the forest. This ensemble approach improves the accuracy and robustness of the model by reducing the risk of overfitting compared to using a single decision tree.

- Data Preparation for ML model
Let us first import views in an Excel file.
o   Go to Data >> Get Data >> SQL Server Database
o   Enter the Server Name & Database name to connect to SQL Server
o   Import both vw_churndata & vw_joindata
o   Save the file as prediction_data

- Open Jupyter Notebook, create a new notebook and write below code:
```python
# Import Libraries
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.preprocessing import LabelEncoder
import joblib
```
```python
# Defife path to excel file
file_path=r"C:\Users\Neeraj Thakur\Desktop\Projects\Python\Data & Resources\prediction_data.xlsx"
```
```python
# Define the sheet name to read the data from
sheet_name="vw_churndata"
```
```python
# Read the data from specified sheet into pandas dataframe
data=pd.read_excel(file_path,sheet_name)
```
```python
# Define the sheet name to read the data from
sheet_name="vw_churndata"
```
```python
# Read the data from specified sheet into pandas dataframe
data=pd.read_excel(file_path,sheet_name)
```
```python
# Display the first few rows of the dataset
data.head()
```
#  Data Preprocessing

```python
# Data Processing
# Drop the columns that are not needed for the prediction
data=data.drop(['customer_id','churn_category','churn_reason'],axis=1)
```
```python
data.head()
```
```python
# List of columns to be label encoded
columns_to_encode=['gender', 'married', 'state','value_deal', 'phone_service', 'multiple_lines',
       'internet_service', 'internet_type', 'online_security', 'online_backup',
       'device_protection_plan', 'premium_support', 'streaming_tv',
       'streaming_movies', 'streaming_music', 'unlimited_data', 'contract',
       'paperless_billing', 'payment_method']
```
```python
# Encode catagorical variables except target variable
label_encoders = {}
for column in columns_to_encode:
    label_encoders[column]=LabelEncoder()
    data[column] = label_encoders[column].fit_transform(data[column])
```
```python
# Manually encode the target variable "Customer_status"
data['customer_status']=data['customer_status'].map({'Stayed':0,'Churned':1})
```
```python
# Split the data into features and target
X=data.drop('customer_status',axis=1)
y=data['customer_status']
```
```python
# Split the data into training and testing sets
X_train,X_test,y_train,y_test=train_test_split(X,y,test_size=0.2,random_state=42)
```
# Train Random Forest Model

```python
# Train Random Forest Model
# Initilize the Random Forest Classifier
rf_model= RandomForestClassifier(n_estimators=100,random_state=42)
```
```python
# Train the Model
rf_model.fit(X_train,y_train)
```
# Evaluate Model

```python
# Make Predictions
y_pred=rf_model.predict(X_test)
```
```python
# Evaluate Model
print("Confusion Matrix")
print(confusion_matrix(y_test,y_pred))
print("\nClassification Report:")
print(classification_report(y_test,y_pred))
```
```python
# Feature Selection using Feature Importance
importances=rf_model.feature_importances_
indices=np.argsort(importances)[::-1]
```
```python
# Plot the figure importances
plt.figure(figsize=(15,6))
sns.barplot(x=importances[indices],y=X.columns[indices])
plt.title('Feature Importances')
plt.xlabel('Relative Importance')
plt.ylabel('Feature Names')
plt.show()
```

# Prediction on new dataset

```python
# Define the path to the vw_joiner data excel file
file_path=r"C:\Users\Neeraj Thakur\Desktop\Projects\Python\Data & Resources\prediction_data.xlsx"
```
```python
# Define the sheet name to read the data from
sheet_name='vw_joindata'
```
```python
# Read the data from the specified sheet into pandas dataframe
new_data=pd.read_excel(file_path,sheet_name)
```
```python
# Display the first few rows of the fetched data
new_data.head()
```
```python
# Retain the original dataframe to preserve unencoded columns
original_data=new_data.copy()
```
```python
# Retain the customer_id column
customer_ids=new_data['customer_id']
```
```python
# Drop columns that won't be used for prediction in the encoded dataframe
new_data=new_data.drop(['customer_id','customer_status','churn_category','churn_reason'],axis=1)
```
```python
# Encode categorical variables using the saved label encoders
for column in new_data.select_dtypes(include=['object']).columns:
    new_data[column]=label_encoders[column].transform(new_data[column])
```
```python
# Make predictions
new_predictions=rf_model.predict(new_data)
```
```python
# Add predictions to the original dataframe
original_data['customer_status_predicted']=new_predictions
```
```python
# Filter the dataframe to include only records predicted as "Churned"
oroginal_data=original_data[original_data['customer_status_predicted']==1]
```
```python
# Save the results
original_data.to_csv(r"C:\Users\Neeraj Thakur\Desktop\Projects\Python\Data & Resources\predictions.csv",index=False)
```
### STEP 6: Power BI Visualization of Predicted Data
Import CSV Data or Load Predicted data in SQL server & connect to server

- Create Measures
  
Count Predicted Churner = COUNT(prediction_data[customer_id]) + 0

Title Predicted Churners = "COUNT OF PREDICTED CHURNERS : " & COUNT(prediction_data[customer_id])

- Churn Prediction Page (Using New Predicted Data)
1. Right Side Grid
- Customer ID
- Monthly Charge
- Total Revenue
- Total Refunds
- Number of Referrals

2. Demographic
- Gender – Churn Count
- Age Group – Churn Count
- Marital Status – Churn Count

3. Account Info
- Payment Method – Churn Count
- Contract – Churn Count
- Tenure Group - Churn Count

4.  Geographic
- State – Churn Count

 ![churn_analysis_prediction](https://github.com/user-attachments/assets/d98c8e3a-1a63-47d4-8758-2317a45005e2)


