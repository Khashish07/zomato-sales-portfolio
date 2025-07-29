create database zomata;
use zomata;

select * from zomat;
describe zomat;

alter table zomat add column Country varchar (255);

#Q1
set sql_safe_updates = 0;

update zomat set Country= case CountryCode
when 1 then "India"
when 14 then "Australia"
when 30 then "Brazil"
when 37 then "Canada"
when 94 then "Indonesia"
when 148 then "New Zealand"
when 162 then "Phillipines"
when 166 then "Qatar"
when 184 then "Singapore"
when 189 then "South Africa"
when 191 then "Sri Lanka"
when 208 then "Turkey"
when 214 then "United Arab Emirates"
when 215 then "United Kingdom"
when 216 then "United States"
end;

select * from zomat;

#Q2 
select * from dates;
alter table dates add column Years int;
update dates set Years= year(datekey);

alter table dates add column Monthnumber int;
update dates set Monthnumber= month(datekey);

alter table dates add column Month_name varchar(255);
update dates set Month_name= monthname(datekey);

alter table dates add column Quarters int;
update dates set Quarters= quarter(datekey);

alter table dates add column Week_day int;
update dates set Week_day= weekday(datekey);

alter table dates add column Week_dayname varchar (255);
update dates set Week_dayname= dayname(datekey);

alter table dates add column yearmonth varchar (255);
update dates set yearmonth= date_format(datekey, '%Y-%b');

alter table dates add column fm varchar (255);
update dates set fm= concat('FM',((month(datekey)+8) % 12) +1);

alter table dates add column fq varchar (255);
update dates set fq= case
when month(datekey) between 4 and 6 then "FQ1"
when month(datekey) between 7 and 9 then "FQ2"
when month(datekey) between 10 and 12 then "FQ3"
when month(datekey) between 1 and 3 then "FQ4"
end;

#Q3
select count(RestaurantId) as Restaurant_Count, City, Country from zomat group by City, Country;

#Q4
select count(RestaurantID), Years, Quarters, Monthnumber from dates group by Years, Quarters, Monthnumber;

#Q5
alter table zomat add column Rating_bucket varchar (255);

update zomat set Rating_bucket = case 
when Rating<=1 then "0-1"
when Rating<=2 then "1-2"
when Rating<=3 then "2-3"
when Rating<=4 then "3-4"
else "4-5" 
end;
select count(RestaurantID), Rating_bucket from zomat group by Rating_bucket;

#without creating another column
select count(RestaurantID),
case
when Rating<=1 then "0-1"
when Rating<=2 then "1-2"
when Rating<=3 then "2-3"
when Rating<=4 then "3-4"
else "4-5" end as Rating_buckets
from zomat
group by Rating_buckets;

select count(RestaurantID), Rating from zomat group by rating;

#Q6
alter table zomat add column Cost_bucket varchar (255);

update zomat set Cost_bucket= case
when Average_Cost_for_two<=500 then "0-500"
when Average_Cost_for_two<=1000 then "501-1000"
when Average_Cost_for_two<=1500 then "1001-1500"
when Average_Cost_for_two<=2000 then "1501-2000"
when Average_Cost_for_two<=2500 then "2001-2500"
when Average_Cost_for_two<=3000 then "2501-3000"
when Average_Cost_for_two<=3500 then "3001-3500"
when Average_Cost_for_two<=4000 then "3501-4000"
when Average_Cost_for_two<=4500 then "4001-4500"
when Average_Cost_for_two<=5000 then "4501-5000"
else "5000+" end;
select count(RestaurantID), Cost_bucket from zomat group by Cost_bucket;

#without creating another column
select count(RestaurantId),
case 
when Average_Cost_for_two<=500 then "0-500"
when Average_Cost_for_two<=1000 then "501-1000"
when Average_Cost_for_two<=1500 then "1001-1500"
when Average_Cost_for_two<=2000 then "1501-2000"
when Average_Cost_for_two<=2500 then "2001-2500"
when Average_Cost_for_two<=3000 then "2501-3000"
when Average_Cost_for_two<=3500 then "3001-3500"
when Average_Cost_for_two<=4000 then "3501-4000"
when Average_Cost_for_two<=4500 then "4001-4500"
when Average_Cost_for_two<=5000 then "4501-5000"
else "5000+" end as "Cost_Buckets"
from zomat
group by Cost_Buckets;

#Q7
select Has_Table_booking, round(count(RestaurantID)*100.0/ (select count(RestaurantID) from zomat),2) as Percentage from zomat group by Has_Table_booking;

#Q8
select Has_Online_delivery, round(count(RestaurantID) * 100.0/ (select count(RestaurantID) from zomat),2) as Percentage from zomat group by Has_Online_delivery;

#Q9- TOP 10 CUISINES- RATING WISE
select * from (select Cuisines, Rating, row_number() over(order by Rating desc) as "Ranks" from zomat) as Top_Cuisines where ranks<=10;

#Q9- TOP 10 CITY- RATING WISE
select * from (select Cuisines, City, Rating, row_number() over(order by Rating desc) as "Ranks1" from zomat) as Top_City where ranks1<=10;

#Q9- TOP 5 CUISINES- CITY WISE WHICH HAS THE HIGHEST RATING
select * from (select City, Cuisines, Rating, row_number() over(partition by City order by Rating desc) as "Ranks2" from zomat) as Top_C where ranks2<=5;
