
create table sales (
   year   integer,
   month  integer,
   sales  decimal);

insert into sales values
   (2011, 1,  50000),
   (2011, 2,  45000),
   (2011, 3, 60000),
   (2011, 4, 58000),
   (2011, 5, 49500),
   (2011, 6, 50000),
   (2011, 7, 62000),
   (2011, 8, 59000),
   (2011, 9, 45000),
   (2011, 10, 50000),
   (2011, 11, 63000),
   (2011, 12, 61500),
   (2012, 1,  51000),
   (2012, 2,  47000),
   (2012, 3, 63000),
   (2012, 4, 55000),
   (2012, 5, 48500),
   (2012, 6, 53000),
   (2012, 7, 65000),
   (2012, 8, 52000),
   (2012, 9, 48000),
   (2012, 10, 53000),
   (2012, 11, 61000),
   (2012, 12, 60500);
   
select year, month, 
       sum(sales) over(partition by year) as cumsales
  from sales;

select year, month, 
       sum(sales) over(partition by year order by month) as cumsales
  from sales;

select year, month, sales,
       rank() over(partition by year order by sales desc) as rank
  from sales;

select *
  from (select year, month, sales,
               rank() over(partition by year order by sales desc) as rank
          from sales) t
 where rank < 4
order by year, rank;

select year, month, sales,
       avg(sales) over(partition by year order by month) as mvgavg
  from sales;

select year, month, sales,
       avg(sales) over(partition by year order by month rows between 1 preceding and 1 following) as mvgavg
  from sales;

select year, month, sales,
       lag(sales, 1, sales) over(partition by year order by month) as prev,
       sales -
       lag(sales, 1, sales) over(partition by year order by month) as diff
  from sales;

select year, month, sales,
       cast(cume_dist() over(partition by year order by sales desc) as decimal(10,2)) as dist
  from sales;

select year, month, sales,
       ntile(3) over(partition by year order by sales desc) as HML
  from sales;



