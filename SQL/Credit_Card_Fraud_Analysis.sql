create database credit_card_fraud;
use credit_card_fraud;

create table fraud_train (
    MyUnknownColumn INT,
    trans_date_trans_time TEXT,
    cc_num BIGINT,
    merchant TEXT,
    category TEXT,
    amt DOUBLE,
    first TEXT,
    last TEXT,
    gender TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip INT,
    lat DOUBLE,
    `long` DOUBLE,
    city_pop INT,
    job TEXT,
    dob TEXT,
    trans_num TEXT,
    unix_time BIGINT,
    merch_lat DOUBLE,
    merch_long DOUBLE,
    is_fraud INT
);
describe fraud_train;
show tables;

LOAD DATA LOCAL INFILE 'C:/Users/LAVINI/Desktop/DA Project Credit_Card_Fraud_Analysis/Dataset/fraudTrain.csv'
INTO TABLE fraud_train
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(MyUnknownColumn, trans_date_trans_time, cc_num, merchant, category,
amt, first, last, gender, street, city, state, zip, lat, `long`,
city_pop, job, dob, trans_num, unix_time, merch_lat, merch_long, is_fraud);

select COUNT(*) 
from fraud_train;

select *
from fraud_train
limit 5;

-- Count total transactions
select count(*) as total_transactions
from fraud_train;

-- Calculate total transaction amount.  
select sum(amt) as total_transactions_amount
from fraud_train;

-- Find fraudulent transactions.
select *
from fraud_train
where is_fraud = 1;

-- Calculate fraud percentage.
select 
is_fraud,
count(*) as total
from fraud_train
group by is_fraud;

select 
round((7506.0/1296675)*100,2) as fraud_percentage;

-- Find customers with the highest transaction value.
select cc_num,sum(amt) as total_transaction_value
from fraud_train
group by cc_num
order by total_transaction_value desc
limit 10;

-- Analyze transactions by merchant category.
select category,count(*)as total_transactions,sum(amt) as total_amount,sum(is_fraud) as fraud_transactions
from fraud_train
group by category
order by total_transactions desc;

-- Find hourly transaction trends.  
select hour(cast(trans_date_trans_time as datetime)) as transaction_hour,
count(*) as total_transactions,sum(is_fraud) as fraud_transactions
from fraud_train
group by transaction_hour
order by transaction_hour;

-- Rank customers by transaction amount.  
select cc_num,round(sum(amt),2)as total_transaction_amount,
rank()over(order by sum(amt) desc) as customer_rank
from fraud_train
group by cc_num
order by customer_rank
limit 20 ;

-- Calculate average transaction amount.
select round(avg(amt),2) as average_transaction_amount
from fraud_train;

-- Identify suspicious transaction locations.
select state,city,
count(*) as fraud_transactions,
sum(amt) as fraud_transaction_amount
from fraud_train
where is_fraud = 1
group by state , city
having count(*) >= 5
order by fraud_transactions desc
limit 20; 



