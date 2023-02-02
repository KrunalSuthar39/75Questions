------------------------------------(1) create database syntax-----------------------------------------
CREATE DATABASE SYNTAX;
------------------------------------(2) create schema syntax-----------------------------------------

CREATE SCHEMA SYNTAX;

---(3)create table name test and test1 (with column id,  first_name, last_name, school, percentage, status (pass or fail),pin, created_date, updated_date)
---define constraints in it such as Primary Key, Foreign Key, Noit Null...
---apart from this take default value for some column such as cretaed_date"

CREATE TABLE test(id bigserial PRIMARY KEY NOT NULL,
				  first_name VARCHAR(10) NOT NULL, 
				  last_name VARCHAR(10) NOT NULL , 
				  school VARCHAR(50), 
				  percentage FLOAT, 
				  status VARCHAR(4) CHECK(status='pass' OR status='fail'), 
				  pin INT ,
				  created_date DATE DEFAULT CURRENT_DATE, 
				  updated_date DATE
				 );
				 
				 
CREATE TABLE test1(id bigserial PRIMARY KEY NOT NULL,
				   test1_id serial not null,
				  first_name VARCHAR(10) NOT NULL, 
				  last_name VARCHAR(10) NOT NULL , 
				  school VARCHAR(50), 
				  percentage FLOAT, 
				  status VARCHAR(4) CHECK(status='pass' OR status='fail'), 
				  pin INT ,
				  created_date DATE DEFAULT CURRENT_DATE, 
				  updated_date DATE,
				  constraint fk_test foreign key(test1_id) references test(id)
				 );	
				 
----(4) Create film_cast table with film_id,title,first_name and last_name of the actor.. (create table from other table)-------

create table film_cast as
select film_id, title, first_name, last_name 
from film_actor 
join film using (film_id)
join actor using(actor_id);

select * from film_cast;


--------drop table test1-------------------------------------------------------
DROP TABLE test1;

---------------------------------------------------------------
create temp table temporeryKrunal as
select * from city
where city like 'a%';

select * from temporeryKrunal;
----------------------------------------------------------------
7
----------rename test table to student table-------------------------------------------------------

alter table test
rename to student;
select * from student;

----------add column in test table named city -------------------------------------------------------
alter table student
add column city varchar(10);

--------------------change data type of one of the column of test table---------------------
alter table student
alter column percentage type INT;

--------------------drop column pin from test table --------------------
alter table student
drop column pin;

--------------------rename column city to location in test table --------------------
alter table student
rename column city to location;

--------------------Create a Role with read only rights on the database.--------------------
create role SutharKrunal;
GRANT CONNECT ON DATABASE SYNTAX TO SutharKrunal;
GRANT USAGE ON SCHEMA public TO SutharKrunal;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO SutharKrunal;

---------------------Create a role with all the write permission on the database.-----------------------
create role SutharKrunal1;
GRANT ALL ON DATABASE SYNTAX to SutharKrunal1;

-----------------Create a database user who can only read the data from the database.---------------------
create role Sutharkrunal2
grant select on all tables in schema public to SutharKrunal2;

--------------------------Create a database user who can read as well as write data into database.-------------------
create role Sutharkrunal3
grant select,insert on all tables in schema public to SutharKrunal3;

-------------------------------Create an admin role who is not superuser but can create database and  manage roles.------------------
create role adminkrunal
with CREATEDB;
grant adminkrunal to current_role with admin option;

---------------------------Create user whoes login credentials can last until 1st June 2023-------------
CREATE ROLE SutharKrunal6 WITH
LOGIN
PASSWORD 'Krunal2123'
VALID UNTIL '2023-06-01';

---------------------------List all unique film’s name. ---------------
select distinct title from film;

----------------------------list top 100 customer details-----------------
select * from customer
limit 100;

--List top 10 inventory details starting from the 5th one.----------------------------------------------------
select * from inventory
offset 4
limit 10;

-----find the customer's name who paid an amount between 1.99 and 5.99.----------------------------------------------
select first_namework with Json data in postgres  https://www.postgresql.org/docs/12/functions-json.html  

work with Json data in SQL server  https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16   from customer 
join payment using(customer_id)
where amount between 1.99 and 5.99;
------- List film's name which is staring from the A.---------------------------------------------------------
select title from film 
where title like'A%'
----------List film's name which is end with "a"------------------------
select title from film 
where title like'%a'
-----------List film's name which is start with "M" and ends with "a"------------------------------
select title from film 
where title like'M%a'
---------List all customer details which payment amount is greater than 40. (USING EXISTs)----------------------------
select customer_id, first_name,last_name 
from customer
join payment using(customer_id)
where exists(
			select 1
			from payment
			where amount>40);
--------------List Staff details order by first_name.-----------------------------------		
select * from staff
order by first_name;
---------------List customer's payment details (customer_id,payment_id,first_name,last_name,payment_date)--------------------------------------
select customer_id,payment_id, first_name, last_name, payment_date
from customer
join payment using(customer_id);
---------------Display title and it's actor name.-----------------------------------------------------
select first_name||'  '||last_name as actor_name,title
from actor
join film_actor using(actor_id)
join film using(film_id);
------------------List all actor name and find corresponding film id--------------------------------------
select first_name||'  '||last_name as actor_name,film_id
from actor
join film_actor using(actor_id)
join film using(film_id);
------------------List all addresses and find corresponding customer's name and phone.--------------------------
select first_name||'  '||last_name as customer_name,phone,address
from customer
join address using(address_id);
----------------Find Customer's payment (include null values if not matched from both tables)(customer_id,payment_id,first_name,last_name,payment_date)---------------------------------------------------
select customer_id,payment_id, first_name, last_name, payment_date
from customer
left join payment using(customer_id)
where payment_id is null;
-----------List customer's address_id. (Not include duplicate id )----------------------------------------------------
select distinct address_id 
from customer;
-----------List customer's address_id. (Include duplicate id )---------------------------------------------------
select address_id 
from customer;
-----------List Individual Customers' Payment total.--------------------------------------------------------
select customer_id, SUM(amount) as total
from payment
group by customer_id;
--------------List Customer whose payment is greater than 80.-----------------------------------------------------
select customer_id, SUM(amount) as total
from payment
group by customer_work with Json data in postgres  https://www.postgresql.org/docs/12/functions-json.html  

work with Json data in SQL server  https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16  id
having SUM(amount)>80;
-----------------Shop owners decided to give  5 extra days to keep  their dvds to all the rentees who rent the movie before June 15th 2005 make according changes in db--------------------------------------------------
update rental
set return_date = return_date + interval'5 day'
where rental_date < '2005-06-15';
------------Remove the records of all the inactive customers from the Database-------------------------------------------------------
delete from customer 
where activebool = false;
-------------count the number of special_features category wise.... total no.of deleted scenes, Trailers etc....------------------------------------------------
select unnest(special_features), count(*)
from film
group by unnest(special_features);
-----------count the numbers of records in film table--------------------------------------------------------
select count(*)
from film;
-------------count the no.of special fetures which have Trailers alone, Trailers and Deleted Scened both etc....------------------------------------------------------
select special_features, count(*)
from film
group by special_features;
select * from film;
update film
set special_features = Array['Commentaries','Trailers','Deleted Scenes']
where film_id =15;

--------------use CASE expression with the SUM function to calculate the number of films in each rating:-----------------------------------------------------
SELECT
       SUM(CASE rating
             WHEN 'G' THEN 1 
		     ELSE 0 
		   END) "General Audiences",
       SUM(CASE rating
             WHEN 'PG' THEN 1 
		     ELSE 0 
		   END) "Parental Guidance Suggested",
       SUM(CASE rating
             WHEN 'PG-13' THEN 1 
		     ELSE 0 
		   END) "Parents Strongly Cautioned",
       SUM(CASE rating
             WHEN 'R' THEN 1 
		     ELSE 0 
		   END) "Restricted",
       SUM(CASE rating
             WHEN 'NC-17' THEN 1 
		     ELSE 0 
		   END) "Adults Only"
FROM film;
-- select rating, count(film_id)
-- from film
-- group by rating
------------Display the discount on each product, if there is no discount on product Return 0-------------------------------------------------------
select name, COALESCE(discount,0)
from product pselect special_features, count(*)
from film
group by special_features;
join product_segment s on p.segment_id= s.id;
---------Return title and it's excerpt, if excerpt is empty or null display last 6 letters of respective body from posts table----------------------------------------------------------
select coalesce(excerpt, right(body,6)) from posts
-------------Can we know how many distinct users have rented each genre? if yes, name a category with highest and lowest rented number  ..------------------------------------------------------

select * from
(select * from
 (select name,count(distinct customer_id) as total from rental
join inventory using(inventory_id)
join film_category using(film_id)
join category using(category_id)
group by category_id
order by total
fetch first row select special_features, count(*)
from film
group by special_features;only)a )krunal
			
union

select * from
(select * from
(select name,count
 (distinct customer_id) as total from rental
join inventory using(inventory_id)
join film_category using(film_id)
join category using(category_id)
group by categoryselect special_features, count(*)
from film
group by special_features;_id
order by total desc
fetch first row only)b)suthar

------------"Return film_id,title,rental_date and rental_duration-
--according to rental_rate need to define rental_duration 
--such as 
--rental rate  = 0.99 --> rental_duration = 3
--rental rate  = 2.99 --> rental_duration = 4
----rental rate  = 4.99 --> rental_duration = 5
-----otherwise  6"-------------------------------------------------------
SELECT film_id, title,rental_date,
       CASE 
           WHEN rental_rate=0.99 THEN 3
           WHEN rental_rate=2.99 THEN 4
           WHEN rental_rate=4.99 THEN 5
           ELSE 6select special_features, count(*)
from film
group by special_features;
       END rental_duration
FROM rental
join inventory using(inventory_id)
join film using(film_id);

--------------------Find customers and their email that have rented movies at priced $9.99.------------------------------------------------
select customer_id, first_name||' '||last_name as customer_name, email
from customer
join payment usinselect special_features, count(*)
from film
group by special_features;g(customer_id)
where amount = 9.99;
-------------------Find customers in store #1 that spent less than $2.99 on individual rentals, but have spent a total higher than $5.--------------------------------------------------------------------------
select customer_id, sum(amount) from
(select customer_id, amount
from payment
where staff_id=1 and amount<2.99) a
group by customer_id
having sum(amountselect special_features, count(*)
from film
group by special_features;) > 5
order by customer_id;

--------------------Select the titles of the movies that have the highest replacement cost.-------------------------------------------------------------------------
select title from film
order by replacement_cost desc
limit 1;
----------------------list the cutomer who have rented maximum time movie and also display the count of that... (we can add limit here too---> list top 5 customer who rented maximum time)--------------------------------------------------------
select customer_id,count(*) 
from rental
join customer using(customer_id)
group by customer_id
order by count(*) desc
limit 5;

-----------------Display the max salary for each department---------------------------------------------------------
select dept_name, max(salary)
from employee
group by dept_name
order by max(salary) desc;

------------------"Display all the details of employee and add one extra column name max_salary (which shows max_salary dept wise) 

/*
emp_id	 emp_name   dept_name	salary   max_salary
120	     ""Monica""	""Admin""		5000	 5000
101		 ""Mohan""	""Admin""		4000	 5000
116		 ""Satya""	""Finance""	6500	 6500
118		 ""Tejaswi""	""Finance""	5500	 6500

--> like this way if emp is from admin dept then , max salary of admin dept is 5000, then in the max salary column 5000 will be shown for dept admin
*/"---------------------------------------------
select emp_id, emp_name, dept_name, salary, max(salary) over(partition by dept_name) as dept_salary
from employee;

------------"Assign a number to the all the employee department wise  
-- such as if admin dept have 8 emp then no. goes from 1 to 8, then if finance have 3 then it goes to 1 to 3

-- emp_id   emp_name       dept_name   salary  no_of_emp_dept_wsie
-- 120		""Monica""		""Admin""		5000	1
-- 101		""Mohan""		    ""Admin""		4000	2
-- 113		""Gautham""		""Admin""		2000	3
-- 108		""Maryam""		""Admin""		4000	4
-- 113		""Gautham""		""Admin""		2000	5
-- 120		""Monica""		""Admin""		5000	6
-- 101		""Mohan""		    ""Admin""		4000	7
-- 108		""Maryam""	    ""Admin""		4000	8
-- 116		""Satya""	      	""Finance""	6500	1
-- 118		""Tejaswi""		""Finance""	5500	2
-- 104		""Dorvin""		""Finance""	6500	3
-- 106		""Rajesh""		""Finance""	5000	4
-- 104		""Dorvin""		""Finance""	6500	5
-- 118		""Tejaswi""		""Finance""	5500	6"---------------------------------------------------
select emp_id, emp_name, dept_name, salary, row_number() over(partition by dept_name) as no_of_emp_dept_wise 
from employee;
----------------Fetch the first 2 employees from each department to join the company. (assume that emp_id assign in the order of joining)-----------------------------------------------
select * from(select emp_id, emp_name, dept_name, salary, row_number() over(partition by dept_name order by emp_id) as k 
from employee)krunal
where krunal.k<3;
--------------Fetch the top 3 employees in each department earning the max salary.-------------------------------------------------
select * from(select emp_id, emp_name, dept_name, salary, row_number() over(partition by dept_name order by salary desc) as krunal
from employee)k
where k.krunal<4;

--------------------write a query to display if the salary of an employee is higher, lower or equal to the previous employee.-------------------------------------------
select emp_id,salselect special_features, count(*)
from film
group by special_features;ary,
lag(salary) over (partition by dept_name order by emp_id)as prev,
		case when salary > lag(salary) over (partition by dept_name order by emp_id) then 'Higher than prev'
			 when salary < lag(salary) over (partition by dept_name order by emp_id) then 'Lower than prev'
			 when salary = lag(salary) over (partition by dept_name order by emp_id) then 'Equal'
		end as salary_diff
from employee;

---------------------Get all title names those are released on may DATE------------------------------------------
select * from(select title, extract(month from rental_date) as release_month
from film
join inventory using(film_id)
join rental using(inventory_id))k
where k.release_month = 05;

-------------------------get all Payments Related Details from Previous week---------------------

select * from payment where payment_date between '2007-03-19'::date - interval '7 days' and '2007-03-19'::date;

---------------------------Get all customer related Information from Previous Year------------------------------------
select * from customer 
join payment using(customer_id)
where payment_date between '2007-03-19 09:34:32.996577'::date - interval '365 days' and '2007-03-19'::date;

----------What is the number of rentals per month for each store?-----------------------------------------------------
select staff_id, extract(month from rental_date) as month, count(*)
from rental
group by staff_id, month
order by staff_id, month;

---------Replace Title 'Date speed' to 'Data speed' whose Language 'English'------------------------------------------------------
update film
set title='Data Speed'
where title='Date Speed' and language_id=1;
--------------Remove Starting Character "A" from Description Of film-------------------------------------------------
select film_id, substring(description,2,length(description))
from film;
-------------- if end Of string is 'Italian'then Remove word from Description of Title-------------------------------------------------
update film
set description = substring(description,0,(length(description)-length('italian')))
where description like '%italian';

-------------Who are the top 5 customers with email details per total sales--------------------------------------------------

select customer_id, email,sum(amount)
from customer
join payment using(customer_id)
group by customer_id
order by sum(amount) desc
limit 5;

-------------Display the movie titles of those movies offered in both stores at the same time.--------------------------------------------------
SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1

INTERSECT

SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 2

ORDER BY film_id;

---------Display the movies offered for rent in store_id 1 and not offered in store_id 2.------------------------------------------------------

SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1

EXCEPT

SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 2

ORDER BY film_id;


------------Show the number of movies each actor acted in---------------------------------------------------

select actor_id, count(film_id)
from film_actor
group by actor_id
order by actor_id;

-------------Find all customers with at least three payments whose amount is greater than 9 dollars--------------------------------------------------


select customer_id, count(amount), sum(amount)
from customer
join payment using(customer_id)
where amount > 9
group by customer_id
having count(amount)>3 
order by customer_id;

----------------find out the lastest payment date of each customer-----------------------------------------------


select customer_id, payment_date from(select customer_id, payment_date, row_number() over(partition by customer_id order by payment_date desc) as latest_date
from payment)k
where k.latest_date=1;

-------------Create a trigger that will delete a customer’s reservation record once the customer’s rents the DVD--------------------------------------------------

create trigger delete_reservation
after insert
on rental
for each row
execute procedure del_function()

create or replace function del_function()
returns trigger
language plpgsql
as
$$
begin 
	delete from reservation 
	where new.customer_id = reservation.customer_id and new.inventory_id = reservation.inventory_id;
	return null;
end;
$$

insert into rental(rental_date,inventory_id,customer_id,return_date,staff_id,last_update) values('2005-05-24 22:54:33'::date,12,1,'2005-05-28 19:40:33'::date,1,'2006-02-16 02:30:53'::date);
select * from reservation;

----------Create a trigger that will help me keep track of all operations performed on the reservation table. I want to record whether an insert, delete or update occurred on the reservation table and store that log in reservation_audit table.-----------------------------------------------------

CREATE OR REPLACE FUNCTION res_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN   
	IF TG_OP = 'INSERT' THEN
	INSERT INTO reservation_audit
	VALUES('I', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
	RETURN NULL;
			 ELSIF TG_OP = 'UPDATE' THEN
			 INSERT INTO reservation_audit
			 VALUES('U', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
			 RETURN NULL;
					ELSIF TG_OP = 'DELETE' THEN
					INSERT INTO reservation_audit
					VALUES('D', NOW(), OLD.customer_id, OLD.inventory_id, CURRENT_DATE);
					RETURN NULL;
END IF;
END;
$$

create trigger after_insert
after insert 
on reservation
for each row
execute procedure res_audit()

create trigger after_delete
after delete 
on reservation
for each row
execute procedure res_audit()

create trigger after_update
after update 
on reservation
for each row
execute procedure res_audit()

INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(10, 15, CURRENT_DATE);

DELETE FROM reservation
WHERE customer_id = 6;

select * from reservation_audit;

--------Create trigger to prevent a customer for reserving more than 3 DVD’s.-------------------------------------------------------


create trigger count_reservation
before insert 
on reservation
for each row
execute procedure dvd()

create or replace function dvd()
returns trigger
language plpgsql
as
$$
begin
if( select count(customer_id) from reservation where new.customer_id = reservation.customer_id)=3 
then 
	raise notice 'Already 3 can not insert more';
else
	return new;
end if;
end;
$$

insert into reservation(customer_id,inventory_id,reserve_date) values(1,12,current_date);
insert into reservation(customer_id,inventory_id,reserve_date) values(1,13,current_date);
insert into reservation(customer_id,inventory_id,reserve_date) values(1,14,current_date);
insert into reservation(customer_id,inventory_id,reserve_date) values(1,15,current_date);

---------create a function which takes year as a argument and return the concatenated result of title which contain 'ful' in it and release year like this (title:release_year) --> use cursor in function------------------------------------------------------------------------------------------------------------------------------------

create or replace function cursor_function(p_year integer)
returns text as $$
declare
	titles text default '';
	rec_film record;
	cur_films cursor(p_year integer)
			for select title, release_year
			from film
			where release_year=p_year;
begin 
	open cur_films(p_year);
	
	loop
		fetch cur_films into rec_film;
		exit when not found;
		
		if rec_film.title like '%ful%' then
			titles := titles|| ','||rec_film.title||':'||rec_film.release_year;
		end if;
	end loop;
	
close cur_films;
return titles;
end;
$$

language plpgsql;


select cursor_function(2006);

----------------------Find top 10 shortest movies using for loop----------------------------------------------------------------------------------------------------------------------
do
$$
declare
    f record;
begin
    for f in select title, length 
	       from film 
	       order by length , title
	       limit 10 
    loop 
	raise notice '%(% mins)', f.title, f.length;
    end loop;
end;
$$

----------------Write a function using for loop to derive value of 6th field in fibonacci series (fibonacci starts like this --> 1,1,.....)----------------------------------------------------------------------------------------------------------------------------

create or replace function fibonaci(k_num integer)
returns int
language plpgsql
as
$$
declare
	a integer := 0;
	b integer := 1;
	temp integer;
	n integer := k_num;
	i integer;
begin 
   raise notice 'fibonacci series is :';
   for i in 2..n
   loop
      temp:= a + b;
      a := b;
      b := temp;
   end loop;
   raise notice '%', b;
end;
$$

select fibonaci(6);

