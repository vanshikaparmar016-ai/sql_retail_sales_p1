/*---sql retail sales analysis---*/

create database sql_project;
use sql_project;
/* create table*/
create table retail_sales (
transactions_id int primary key ,
sale_date date,
sale_time time,
customer_id int, 
gender varchar(15),
age int,
category varchar(50),
quantity int,
price_per_unit float,
cogs float,
total_sale float);
INSERT INTO retail_sales VALUES
(1, '2023-11-05', '10:15:00', 101, 'Male', 34, 'Clothing', 3, 500, 300, 1500),
(2, '2023-11-06', '11:30:00', 102, 'Female', 28, 'Electronics', 1, 12000, 9000, 12000),
(3, '2023-11-06', '14:20:00', 103, 'Male', 45, 'Beauty', 2, 250, 150, 500),
(4, '2023-11-07', '09:45:00', 104, 'Female', 22, 'Clothing', 5, 400, 250, 2000),
(5, '2023-11-08', '16:05:00', 105, 'Male', 39, 'Electronics', 2, 8000, 6000, 16000),
(6, '2023-11-08', '18:30:00', 106, 'Female', 31, 'Grocery', 10, 60, 40, 600),
(7, '2023-11-09', '12:10:00', 107, 'Male', 27, 'Clothing', 2, 700, 450, 1400),
(8, '2023-11-09', '13:55:00', 108, 'Female', 50, 'Beauty', 1, 900, 600, 900),
(9, '2023-11-10', '10:40:00', 109, 'Male', 24, 'Electronics', 1, 15000, 11000, 15000),
(10, '2023-11-10', '17:15:00', 110, 'Female', 36, 'Grocery', 8, 80, 55, 640),
(11, '2023-11-11', '11:05:00', 111, 'Male', 42, 'Clothing', 4, 350, 220, 1400),
(12, '2023-11-11', '15:25:00', 112, 'Female', 29, 'Beauty', 3, 300, 180, 900),
(13, '2023-11-12', '09:20:00', 113, 'Male', 33, 'Electronics', 2, 5000, 3500, 10000),
(14, '2023-11-12', '19:00:00', 114, 'Female', 47, 'Grocery', 12, 50, 30, 600),
(15, '2023-11-13', '14:45:00', 115, 'Male', 26, 'Clothing', 1, 1200, 800, 1200);
select * from retail_sales;

select count(*) from retail_sales;

select * from retail_sales where transactions_id is null;
select * from retail_sales where
transactions_id is null or
sale_date is null or
sale_time is null or 
gender is null or
category is null or
quantity is null or
cogs is null or   total_sale is null;
/*------ data  exploartion----------*/
/* how many sales we have? */
 select count(*) as total_sales from retail_sales;
 -------------
 /*     how many unique customer  we have?     */
 select count(distinct customer_id) as total_sales from retail_sales;


-------------
/*    data analysis and business key problems and answers          */


/*  1. write a sql query to retrieve all columns for sales made 2023-11-10  */
select * from retail_sales  where sale_date = '2023-11-10';

-------------------------------------------
/*   2. write a sql query to retrieve all transaction where the category is'clothing' and the quantity sold 
is more than 10 in  the month of nov-2022     */
select  * from retail_sales where category='clothing'
and  sale_date between '2022-11-01' and '2022-11-30' and quantity>10;

-----------------------------------------
/* 3. write a sql query to calculate the total_sales(total_sale) for each category.    */

select category, sum(total_sale) as total_sales from retail_sales  group by category;
------------------------------------------
/* 4. write a sql query to find the average age of customer who purchased items from the beauty category    */
select category, avg(age) from retail_sales  where category='beauty' group by category;
------------------------------------------------------------
/* 5.write a sql query to find all transaction where the total_sale is greater than 1000  */
select  * from retail_sales where total_sale>1000;
--------------------------------------------------
/* 6. write a sql query to find the total number of transactions(transaction_id) made by each gender 
in each category.     */

select  category,gender,count(*) as total_transaction
from retail_sales 
group by  category,gender order by 1;

-----------------------------------------------------
/* 7. write a sql query to calculate the  average sale for each month .
 find out best selling month in each year.      */
 select * from (
select 
 extract(year from sale_date ) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
 from retail_sales  group by 1,2) 
 as t1
 where rnk=1;
 ---------------------------------------------------------
 /* 8. write a sql query  to find the top 5 customer based on the highest total sales */
 
 
 select customer_id, sum(total_sale) from retail_sales group by 1 order by 2 desc limit 5;
 
 
 /* 9. write a sql query to find the number of unique customers who purchased items from each category.*/
 select count( distinct customer_id), category from retail_sales  group by category;
 
 /* 10.  write a sql query to create  each shift and number of orders(example morning <=12, afternoon between 12 & 17,evening>17)    */
with hourly_sale
as
(
select *,
 case 
    when extract(hour FROM sale_time) < 12 then'morning'
    when extract(hour from sale_time) between 12 and 17 then'afternoon'
    else 'evening'
end as  shift
from retail_sales
)
select shift,count(*) as total_orders
from hourly_sale
group by shift;



/* end of project*/
 