SELECT * FROM Bank_churn.customer;
select distinct customerid from customer
where customerid is null;
select distinct customerid 
from customer;


#creating a staging table#
create table customer_new
like Bank_churn.customer
;

insert into customer_new
select * FROM Bank_churn.customer;

SELECT * FROM Bank_churn.customer_new;
select distinct customerid 
from Bank_churn.customer_new;
 #checking for duplicates#

  select customerid,count(CustomerId) as count
  from Bank_churn.customer_new
  group by customerid
 having count(CustomerId)>1
;

# used this method but it tends to delete both customerid instead of just the duplicate#
delete from bank_churn.customer_new
where customerid in(
select customerid
from(
select customerid,count(CustomerId)
  from Bank_churn.customer_new
  group by customerid
 having count(CustomerId)>1
)as delete_row
  );
  
  select distinct customerid
  from bank_churn.customer_new;
  
 drop table bank_churn.customer_new;
 
select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.customer_new;
 
#creating cte#
with duplicate_cte as
(
select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.customer_new
)
select* from duplicate_cte
where row_num>1;

#creating a new table to delete duplicate row#
CREATE TABLE `customer_new1` (
  `CustomerId` int DEFAULT NULL,
  `Surname` text,
  `CreditScore` int DEFAULT NULL,
  `Geography` text,
  `Gender` text,
  `Age` text,
  `Tenure` int DEFAULT NULL,
  `EstimatedSalary` text,
  `FIELD9` text,
  `FIELD10` text,
  `row_num`int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into customer_new1
select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.customer_new;

select * from customer_new1;

select* from customer_new1
where row_num>1;
 #deleting duplicate row#
delete from customer_new1
where row_num>1;

select * from customer_new1;

select surname
from customer_new1;
#checking the max count of surname
select surname,count(CustomerId) count
  from Bank_churn.customer_new1
  group by surname
 having count>1
 order by count desc 
 limit 1; 
 
 select surname 
 from Bank_churn.customer_new1
 where surname is null;
 select surname 
 from Bank_churn.customer_new1
 where Surname like '%?' or 
 length(surname)=1 or length(surname)=2;
 
 UPDATE Bank_churn.customer_new1
 set surname='Smith'
 where Surname like '%?' or 
 length(surname)=1 or length(surname)=2
 AND RAND() < 0.4;
 
 UPDATE Bank_churn.customer_new1
 set surname='Unknown'
 where Surname like '%?' or 
 length(surname)=1 or length(surname)=2
and surname !='Smith';

select surname 
 from Bank_churn.customer_new1
 where surname='unknown';
 
select creditscore 
 from Bank_churn.customer_new1 
 where creditscore is null;
 
 select geography
 from Bank_churn.customer_new1 ;

 select distinct geography
from Bank_churn.customer_new1 ;

select geography
from Bank_churn.customer_new1 
where geography ='fra';
 
 update Bank_churn.customer_new1
 set geography='France'
 where geography ='fra';
 
  update Bank_churn.customer_new1
 set geography='France'
 where geography ='french';
 
 -- Analysis--
 
 select distinct gender 
 from Bank_churn.customer_new1
 ;
 
 select tenure 
 from Bank_churn.customer_new1
 where tenure is null;
 
 select estimatedsalary
 from customer_new1
 order by 1;
 
 select max(estimatedsalary),min(estimatedsalary)
 from customer_new1;
 
 select estimatedsalary
 from customer_new1
 where estimatedsalary=0;
 
 -- replacing € with''. removing currncy sign.--
 UPDATE  Bank_churn.customer_new1
SET estimatedsalary = REPLACE(estimatedsalary, '€', '');
 

-- changing datatype from text to decimal--
 alter table Bank_churn.customer_new1
 modify column estimatedsalary decimal(8,2);
 
 -- droping columns --
 select field9 from 
 customer_new1 where field9='';
 
 alter table customer_new1
 drop column FIELD9;
 
 select field10 from 
 customer_new1 where field10='';
 
 alter table customer_new1
 drop column FIELD10;
 
 alter table customer_new1
 drop column row_num;
 
 select* from customer_new1; 
 
 

select*from account;

select distinct customerid from account
where customerid is null;
select distinct customerid 
from customer;


-- creating a staging table --
create table account_new
like Bank_churn.account
;

insert into account_new
select * FROM Bank_churn.account;

SELECT * FROM Bank_churn.account_new;
select distinct customerid 
from Bank_churn.customer_new;


 select customerid,count(CustomerId) as count
  from Bank_churn.account_new
  group by customerid
 having count(CustomerId)>1
;

select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.account_new;
 
-- creating cte --
with duplicate_cte as
(
select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.account_new
)
select* from duplicate_cte
where row_num>1;

-- creating a new table to delete duplicate row --
CREATE TABLE `account_new1` (
  `CustomerId` int DEFAULT NULL,
  `Balance` text,
  `NumOfProducts` int DEFAULT NULL,
  `HasCrCard` text,
  `Tenure` int DEFAULT NULL,
  `IsActiveMember` text,
  `Exited` int DEFAULT NULL,
  `FIELD8` text,
  `FIELD9` text,
  `row_num`int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

drop table account_new1;
insert into account_new1
select * ,row_number()over(partition by customerid) row_num from 
 bank_churn.account_new;

select * from account_new1;

select* from account_new1
where row_num>1;
delete from account_new1
where row_num>1;

select * from account_new1;

select balance 
from account_new1;
select max(balance),min(balance)
from account_new1;

 UPDATE  Bank_churn.account_new1
SET balance = REPLACE(balance, '€', '');
 
 alter table Bank_churn.account_new1
 modify column balance decimal(8,2);
 select balance 
from account_new1
order by balance desc;

select NumOfProducts 
from account_new1
where NumOfProducts is null;

select isactivemember from account_new1;
update account_new1
set isactivemember  =
case
when isactivemember ='yes' then 1
when isactivemember  ='no'then 0
else null
end;

select tenure from account_new1
where tenure is null;

 select field8 from 
account_new1 where field8='';
 
 alter table account_new1
 drop column FIELD8;
 
 select field9 from 
account_new1 where field9='';
 
 alter table account_new1
 drop column FIELD9;
 
 alter table account_new1
 drop column row_num;

select* from account_new1; 


