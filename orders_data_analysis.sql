select * from orders;

#Find top 10 highest revenue generating products 
select product_id, round(sum(sale_price),2) as total_sales
from orders
group by product_id
order by total_sales desc
limit 10;

# find top 5 highest selling products in each region.
with cte as (
select region,product_id, sum(sale_price) as total_sales
from orders
group by region,product_id
order by region,total_sales desc)
select region,product_id,round(total_sales,2),rn from(
select *,
row_number() over(partition by region) as rn
from cte)x
where x.rn<=5;


-- Find Month over month growth comparision for 2022 and 2023 sales eg:- jan 2022 and jan 2023
with cte as(
select year(order_date) as year,
month(order_date) as month,
round(sum(sale_price),2)  as sales
from orders
group by year(order_date),month(order_date)
) 
select month,
sum(case when year = 2022 then sales end)as 2022_sales,
sum(case when year = 2023 then sales end) as 2023_sales
from cte
group by month
order by month;


-- for each category which month has highest sales

with cte as(
Select category, monthname(order_date) as month, round(sum(sale_price),2) as sales 
from orders
group by category, monthname(order_date)
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte)x
where x.rn=1;


#which sub category has the highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as yr, sum(sale_price) as sale_price
from orders
group by sub_category,year(order_date)
),
cte2 as(
select sub_category,
round(sum(case when yr = 2022 then sale_price end),2) as 2022_sale,
round(sum(case when yr = 2023 then sale_price end),2) as 2023_sale
from cte
group by sub_category)
select *,
(2023_sale - 2022_sale)/2022_sale*100 as net_sale
from cte2
order by net_sale desc
limit 1;







