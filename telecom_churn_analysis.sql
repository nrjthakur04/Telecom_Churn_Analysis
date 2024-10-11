create database churn_db;

use churn_db;

select * from customer_data;

-- Data Exploration – Check Distinct Values

select gender, count(gender) as totalcount,
count(gender) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by gender;

select contract, count(contract) as totalcount,
count(contract) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by contract;

select customer_status, count(customer_status) as totalcount, sum(total_revenue) as totalrev,
sum(total_revenue) / (select sum(total_revenue) from customer_data) * 100 as revpercentage
from customer_data
group by customer_status;

select state, count(state) as totalcount,
count(state) * 1.0 / (select count(*) from customer_data) as percentage
from customer_data
group by state
order by percentage desc;

-- Data Exploration – Check Nulls 

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

--  Create View for Power BI

go
create view vw_churndata as
    select * from prod_churn where customer_status in ('Churned', 'Stayed');

go
create view vw_joindata as
    select * from prod_churn where customer_status = 'Joined';

