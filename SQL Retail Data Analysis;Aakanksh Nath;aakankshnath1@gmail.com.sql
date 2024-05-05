--Create Database POS

select * from Customer;
select * from prod_cat_info;
select * from Transactions;


--Q1: 
--Ans: 
select 'Customer' as Table_Name ,COUNT(*) as Row_Num from Customer 
Union
select 'Product' , COUNT(*) as Row_Num_Product from prod_cat_info 
Union
select 'Transactions' , COUNT(*)  as Row_Num_Transactions from Transactions as Row_Num_Transactions
--Total rows in Customer: 5647
--Total rows in Prod_cat_info: 23
--Total rows in Transactions: 23,053


--Q2:
--Ans: 
select count(total_amt) from Transactions 
where total_amt < 0;
--Total Number: 2177


--Q3:
--Ans: 
select Convert(Date,DOB,103) from Customer
select Convert(Date,tran_date,103) from Transactions


--Q4:
--Ans:
select DATEDIFF(DAY,MIN (tran_date),max (tran_date)) as no_days,
DATEDIFF(MONTH,MIN(tran_date),max (tran_date)) as no_mon,
DATEDIFF(YEAR,MIN(tran_date),max (tran_date)) as no_years
from Transactions
--no_days  no_mon  no_years
--1130     37      3


--Q5:
--Ans:  
select prod_cat, prod_subcat from prod_cat_info
where prod_subcat = 'DIY'
--BOOKS


--DATA ANALYSIS:-


--Q1:
--Ans: 
select top 1 Store_type, COUNT(transaction_id) as No_of_transactions from Transactions
group by Store_type
order by No_of_transactions desc
---e-Shop  9311


--Q2:
--Ans: 
select count(gender)Male from Customer
group by gender
having gender = 'M'
-- 2892

select count(gender)Male from Customer
group by gender
having gender = 'F'
-- 2753


--Q3: 
--Ans: 
select city_code, max(customer_id) from customer
group by city_code
order by 2
--Since there are few NULL values in the table it has the highest number of customers: 268709
--But if we skip this then city_code = 3 has the highest customers i.e. 275265


--Q4:
--Ans: 
select prod_cat,count(prod_subcat) from prod_cat_info
where prod_cat = 'books'
group by prod_cat
--Total: 6


--Q5:
--Ans: 
SELECT TOP 1 prod_cat, sum(ABS(QTY))QTY from Transactions a
join prod_cat_info b on a.prod_cat_code = b.prod_cat_code
group by prod_cat
order by QTY desc
--max quatity ever ordered is books
--max quatity ever ordered - 108906


--Q6:
--Ans: 
select ROUND(sum(total_amt),2)TR, prod_cat from Transactions a
join prod_cat_info b on a.prod_cat_code = b.prod_cat_code
where prod_cat in ('Electronics' , 'Books')
group by prod_cat
---TR			Prod_cat
---76936164.23	Books
---53612318.2	Electronics


--Q7:
--Ans: 
select  COUNT(customer_id) No_of_Customer from Customer 
where customer_Id in (select cust_id  from Transactions
where qty>0
group by cust_id
having COUNT(cust_id)>10 )
---6


--Q8:
--Ans: 
select round(SUM(total_amt),2) as Total_revenue from Transactions as T
join prod_cat_info P 
on  P.prod_sub_cat_code = T.prod_subcat_code and T.prod_cat_code = P.prod_cat_code
where (prod_cat in ('Electronics' , 'Clothing')) and (Store_type = 'Flagship Store')
---3409559.27


--Q9:
--Ans: 
select prod_subcat  ,round(SUM(total_amt),2) AS Total_revenue from Customer C
join Transactions T
on C.customer_Id = T.cust_id 
join prod_cat_info P on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where Gender = 'M' and prod_cat = 'Electronics'
group by prod_subcat
----Personal Appliances	 1107593.43
----Mobiles	             1192413.24
----Computers	         1091417.34
----Audio and video	     1138983.17
----Cameras	             1172702.25


--Q10:
--Ans: 
select top 5 prod_subcat,
(sales/sum(sales) over()) * 100 as Percentage_of_sales,
(returns/sum(returns) over()) * 100 as Percentage_of_returns
from (
SELECT
p.prod_subcat,
(sum(case when total_amt >=0 then total_amt else '0' end)) as sales,
(sum(abs(case when total_amt < 0 then total_amt else '0' end))) as RETURNS
from Transactions as T
join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
group by p.prod_subcat) as T1
order by Percentage_of_sales DESC;
--prod_subcat  Percentage_of_sales  Percentage_of_returns
--Women	       12.891787897182624	14.519595781743211
--Mens	       12.682051741804221	12.487292934081275
--Kids	       8.82709848676735	    9.373525660560507
--Mobiles	   4.606922622279665	4.425275680312421
--Fiction	   4.578003923494898	4.4372773206620115


--Q11:
--Ans:  
select C.customer_id ,C.Dob ,T.tran_date ,  
sum(total_amt) as Revenue , 
datediff(day,dob,getdate())/365 as current_age
from Customer as C
join Transactions as T
on C.customer_ID = T.cust_id
join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where tran_date between dateadd(day,-30,(select max(tran_date) from Transactions)) and (select max(tran_date) from Transactions)
group by C.customer_ID,C.DOB,T.tran_date
having datediff(day,dob,getdate())/365 between 25 and 35; 


--Q12:
--Ans: 
select top 1 prod_cat ,  abs(sum(cast(Qty as int))) as No_of_units_returned from Transactions as T 
join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and P.prod_sub_cat_code = T.prod_subcat_code
where Qty<0 and tran_date between DATEADD(Month,-3,(select max(tran_date) from Transactions)) and (select MAX(tran_date) from Transactions)
group by prod_cat
order  by No_of_units_returned desc
--Books: 143
 

--Q13:
--Ans:  
select top 1 store_type ,  sum(total_amt) Sales_amount , sum(cast(Qty as int)) as QTY_SOLD from transactions
group by Store_type 
order by Sales_amount desc , QTY_SOLD desc
---e-Shop	19824816.0530701	22763


--Q14:
--Ans: 
select prod_cat,AVG(T.total_amt) Average, (select AVG(total_amt) from Transactions) as overall_avg from Transactions T
join prod_cat_info P 
on T.prod_subcat_code = P.prod_sub_cat_code and T.prod_cat_code = P.prod_cat_code
group by prod_cat
having AVG(T.total_amt) > (select AVG(total_amt) from Transactions)
---Books	    2112.82	2107.31      2107.3080019953964
---Clothing	    2111.87	2107.31      2107.3080019953964
---Electronics	2189.15	2107.31      2107.3080019953964


--Q15:
--Ans: 
select top 5 P.prod_cat,P.prod_subcat ,round(AVG(total_amt),2) as Avg_revenue , round(SUM(total_amt),2) as Total_revenue , SUM(QTY) as Qty_Sold from Transactions T
join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code  and T.prod_subcat_code = P.prod_sub_cat_code
group by prod_cat , prod_subcat
order by SUM(cast(qty as int)) desc
--Home and kitchen  Tools  2024.37  2149882.47  2589
--Electronics	Mobiles	   2181.09	2248702.63  2587
--Books	Fiction	           2140.22	2232250.28  2573
--Footwear	Kids	       2125.99	2145126.56  2527
--Books	Children	       2136.67	2211450.87  2487