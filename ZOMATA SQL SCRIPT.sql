create database zomato_project;
use zomato_project;

UPDATE zomato SET Datekey_Opening = REPLACE(Datekey_Opening, '-', '/') WHERE Datekey_Opening LIKE '%-%';
alter table zomato modify column Datekey_Opening date;
select * from zomato;

#2.
create view calender_view as select year(Datekey_Opening) years,
month(Datekey_Opening)  months_no,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday_no,
dayname(datekey_opening)weekday_name, 

case when monthname(datekey_opening) in ('October' ,'November' ,'December' )then 'Q3'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM-10' 
when monthname(datekey_opening)='January' then 'FM-10'
when monthname(datekey_opening)='February' then 'FM-11'
when monthname(datekey_opening)='March' then 'FM-12'
when monthname(datekey_opening)='April'then'FM-1'
when monthname(datekey_opening)='May' then 'FM-2'
when monthname(datekey_opening)='June' then 'FM-3'
when monthname(datekey_opening)='July' then 'FM-4'
when monthname(datekey_opening)='August' then 'FM-5'
when monthname(datekey_opening)='September' then 'FM-6'
when monthname(datekey_opening)='October' then 'FM-7'
when monthname(datekey_opening)='November' then 'FM-8'
when monthname(datekey_opening)='December'then 'FM-9'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'FQ-4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'FQ-1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'FQ-2'
else  'FQ-3' end as financial_quarters

from zomato;
select * from calender_view;

#3.Find the Numbers of Resturants based on City and Country.
select country.country_name,zomato.city,count(restaurantid)no_of_restaurants
from zomato inner join country
on zomato.country_code=country.countryid 
group by country.country_name,zomato.city;

#4.Numbers of Resturants opening based on Year , Quarter , Month.
select year(datekey_opening)year,quarter(datekey_opening)quarter,monthname(datekey_opening)monthname,count(restaurantid)as no_of_restaurants 
from zomato group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) ;

#5. Count of Resturants based on Average Ratings.
select case when rating <=2 then "0-2" when rating <=3 then "2-3" when rating <=4 then "3-4" when Rating<=5 then "4-5" end rating_range,count(restaurantid) 
from zomato
group by rating_range 
order by rating_range;


#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select case when price_range=1 then "0-500" when price_range=2 then "500-3000" when Price_range=3 then "3000-10000" when Price_range=4 then ">10000" end price_range,count(restaurantid)
from zomato
group by price_range
order by Price_range;

#7.Percentage of Resturants based on "Has_Table_booking"
select has_online_delivery,concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from zomato
group by has_online_delivery;

#8.Percentage of Resturants based on "Has_Online_delivery"
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage from zomato group by has_table_booking;

select count(*) from zomato;
select * from zomato;

# 9 extra kpi

# top 5 cuisines who has more number of votes
select  cuisines , votes from zomato
order by votes desc limit 5;