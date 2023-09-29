-- a brief look at the data
select *
 from customer.`customer-churn-records`;
 
-- checking for missing values 
select * 
from customer.`customer-churn-records` 
where CustomerId is NULL
or Exited is NULL;

-- delete missing values
delete 
from customer.`customer-churn-records`
where RowNumber is NULL
or CustomerId is NULL
or Surname is NULL 
or CreditScore is NULL
or Geography is NULL
or Age is NULL
or Tenure is NULL
or Balance is NULL
or NumOfProducts is NULL
or HasCrCard is NULL
or IsActiveMember is NULL
or EstimatedSalary is NULL
or Exited is NULL 
or Complain is NULL 
or SatisfactionScore is NULl
or CardType is NULL
or PointEarned is NULL;

-- check for duplicate values (there are none)
select 
    (select distinct count(*) from customer.`customer-churn-records`) as distinct_values,
    (select count(*) from customer.`customer-churn-records` where count(*) 
    not in (select distinct count(*) from customer.`customer-churn-records`)) as non_distinct_values;


-- delete unneeded features
alter table customer.`customer-churn-records`
drop column RowNumber
, drop column CustomerId
, drop column Surname;

-- check for churn ratio
select Exited, count(*) as count
from customer.`customer-churn-records`
group by Exited;

-- checking on geographical correlation
select
    Geography
    , avg(Age) as Avg_Age
    , count(*) as Total_Customers
    , sum(EstimatedSalary) as Total_Salary
    , sum(Exited) as churned
from
    customer.`customer-churn-records`
group by
    Geography;
    
-- checking on gender's correlation
select
    Gender
    , avg(Age) as Avg_Age
    , count(*) as Total_Customers
    , sum(EstimatedSalary) as Total_Salary
    , sum(Exited) as churned
from
    customer.`customer-churn-records`
group by
    Gender;

-- checking on age groups' correlation
select
    case
        when Age < 30 then 'Under 30'
        when Age between 30 and 39 then '30-39'
        when Age between 40 and 49 then '40-49'
        when Age between 50 and 59 then '50-59'
        else '60 and Over'
    end as Age_Group,
    SUM(Exited) / COUNT(*) AS churned_ratio
FROM
    customer.`customer-churn-records`
GROUP BY
    age_group
ORDER BY
    churned_ratio;

    -- Add the Age_Segment column to the table and populate it using CASE statement
alter table customer.`customer-churn-records`
add column Age_Segment varchar(50) 
    generated always as (
        case 
            when Age < 30 then 'Under 30'
            when Age between 30 and 39 then '30-39'
            when Age between 40 and 49 then '40-49'
            when Age between 50 and 59 then '50-59'
            else '60 and Over'
        end
    ) stored;

-- Add the CreditScore_segment column to the table and populate it using CASE statement
alter table customer.`customer-churn-records`
add column CreditScore_segment varchar(50)
    generated always as (
        case 
            when creditscore < 500 then 'Very Low'
            when creditscore between 500 and 599 then 'Low'
            when creditscore between 600 and 699 then 'Medium'
            when creditscore between 700 and 799 then 'High'
            else 'Very High'
        end
    ) stored;

-- Add the EstimatedSalary_segment column to the table and populate it using CASE statement
alter table customer.`customer-churn-records`
add column Salary_segment varchar(50)
    generated always as (
        case 
		when EstimatedSalary <  60000 then 'Low Income'
        when EstimatedSalary between 60000 and 140000 then 'Middle Income'
        when EstimatedSalary > 140000 then 'High Income'
        end
    ) stored;
    
    
    