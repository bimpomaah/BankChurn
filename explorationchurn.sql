 

-- Analysis--
-- joing tables with customerids--
select* from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid;

-- analysing no of churns with age group --
select age,exited,count(exited) 
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by age,exited
order by 1;

with age_cte as(
select age,exited,count(exited) as num_of_churns
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by age,exited
order by 1
)select age, num_of_churns
from age_cte
where exited=1
group by age
order by 2 desc;

create view age as

with age_cte as(
select age,exited,count(exited) as num_of_churns
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by age,exited
order by 1
)select age, num_of_churns
from age_cte
where exited=1
group by age
order by 2 desc;

-- relationship between gender and number of churns --
select gender,exited,count(exited) 
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by gender,exited
order by 1;

select gender,exited,count(exited) 
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by gender,exited
order by 1;

with rolling_cte as
(select gender,exited,count(exited) num_of_exits
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by gender,exited
order by 1),
percentage_cte as(
select *,sum(num_of_exits)over(partition by gender order by exited) rolling_total
from rolling_cte)

select*,( (num_of_exits/10000)*100) gender_percentage
from percentage_cte
order by 2 desc;

create view gender_churn as


with rolling_cte as
(select gender,exited,count(exited) num_of_exits
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by gender,exited
order by 1),
percentage_cte as(
select *,sum(num_of_exits)over(partition by gender order by exited) rolling_total
from rolling_cte)

select*,( (num_of_exits/10000)*100) gender_percentage
from percentage_cte
order by 2 desc;




-- relationship between geography and number of churns --
select geography,exited
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where exited=1;

select geography,count(exited ) total_churn_country
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where exited=1
group by geography
order by 1;

create table churn_country
select geography,count(exited ) total_churn_country
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where exited=1
group by geography
order by 1;

create table total_country
select geography,count(exited) total_customers
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
group by geography;


select* from churn_country cc
join total_country tc
on cc.geography=tc.geography;

select cc.geography,total_churn_country,total_customers,((total_churn_country/total_customers)*100 )percentage_churn
from churn_country cc
join total_country tc
on cc.geography=tc.geography;

create view percentagechurn as
select cc.geography,total_churn_country,total_customers,((total_churn_country/total_customers)*100 )percentage_churn
from churn_country cc
join total_country tc
on cc.geography=tc.geography;


-- teunure relationship with those who churned --

select ac.tenure,exited,count(exited ) total_churn_tenure
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where exited=1 or exited=0
group by ac.tenure,exited
order by 1;

with tenure_cte as(
select ac.tenure,exited,count(exited ) total_churn_tenure
from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where exited=1 or exited=0
group by ac.tenure,exited
order by 1
),

total_tenure_churn as
(select*,sum(total_churn_tenure)over(partition by tenure order by exited desc) rolling_total
from tenure_cte)

select *
 from total_tenure_churn
 where exited =1
 order by rolling_total desc;
 
 -- no pattern/relationship --

-- checking if there's negative balnace--
select * 
 from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
where balance like '-%'
;

 select max(balance),min(balance) 
 from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
order by  exited
;

select avg(balance) 
 from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid
order by  exited
;
select * 
 from customer_new1 cn
join account_new1 ac
on cn.customerid=ac.customerid;










