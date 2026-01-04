create database e_commerce;
use e_commerce;

--  TABLE CREATION
create table fact_table(
  payment_key varchar(15) ,
  coustomer_key  varchar(20) ,
  time_key varchar(20)  ,
  item_key varchar(20) ,
  store_key varchar(20) ,
  quantity  int,
  unit varchar(10),
  unit_price double ,
  total_price double
  );

  
  SHOW CREATE TABLE fact_table;
   describe fact_table;
  -- truncate table fact_table;
  select * from fact_table;
  
  create table customer_dim(
  customer_key varchar(15)  ,
  Name_of_customer varchar(20)  ,
  contact_no  bigint,
  nid  bigint 
  );
  

select * from customer_dim;
  
 create table trans_dim(
  payment_key varchar(15)   ,
  trans_type varchar(20)  ,
  bank_name varchar(100)
  );   
  select count(*) from Trans_dim;
  
  create table trans_dim1(
  payment_key varchar(15)   ,
  trans_type varchar(20)  ,
  bank_name varchar(100)
  );   
  
create table item_dim(
  item_key varchar(15)   ,
  item_name varchar(130)  ,
  describes varchar(130),
  unit_price float,
  man_country varchar(30),
  supplier varchar(130),
  unit varchar(25)
  ); 
  
  create table  time_dim(
  time_key varchar(15),
  dates DateTime,
  hours int,
  days int,
  weeks varchar(15),
  months int,
  quarters varchar(15),
  years int);
  
  select count( *) from time_dim;
  
  -- creating a Store table-- 
  
  create table  store_dim(
   store_key varchar(15),
   division varchar(15),
   district varchar(60),
   Upazilas varchar(60)
   );
select count(*) from time_dim;

-- Steps for Data Cleaning in FACT TABLE

select  count(*) from fact_table;
select * from fact_table where total_price is null;
select  count(*) from fact_table where total_price = '';
update fact_table set unit = 'unknown' where unit = '';
Alter table Fact_table rename  column coustomer_key to customer_key;

--  ADDING CONSTARINTS FOREIGN KEY  IN FACT TABLE

ALTER TABLE fact_table
ADD CONSTRAINT fk_fact_customer
FOREIGN KEY (customer_key)
REFERENCES customer_dim (customer_key);

ALTER TABLE fact_table
ADD CONSTRAINT fk_fact_itemtrans_dimtrans_dimtrans_dim
FOREIGN KEY (item_key)
REFERENCES item_dim (item_key);

ALTER TABLE fact_table
ADD CONSTRAINT fk_fact_store
FOREIGN KEY (store_key)
REFERENCES store_dim (store_key);

ALTER TABLE fact_table
ADD CONSTRAINT fk_fact_time
FOREIGN KEY (time_key)
REFERENCES time_dim (time_key);

ALTER TABLE fact_table
ADD CONSTRAINT fk_fact_trans
FOREIGN KEY (payment_key)
REFERENCES Trans_dim (payment_key);

-- FOR PAYMENT CLEANING table-----
select count(distinct f.payment_key)  from fact_table  f
left join trans_dim t
on 
f.payment_key = t.payment_key 
where 
t.payment_key is null;


delete f from fact_table f 
LEFT join trans_dim t 
on 
f.payment_key = t.payment_key 
where 
t.payment_key is null;
 

   
-- Steps for Data Cleaning in CUSTOMER TABLE

select * from customer_dim;
select count(distinct(customer_key)) from customer_dim;
UPDATE customer_dim
SET Name_of_customer = REGEXP_REPLACE(Name_of_customer, '[^A-Za-z ]', '');
select * from customer_dim where Name_of_customer = '';
delete  from customer_dim where nid is null;
update customer_dim  set  Name_of_customer ="Unknown user" where  Name_of_customer = '';
select * from customer_dim where Name_of_customer = "unknown user";

select * from fact_table where customer_key = 'C000036';
select * from item_dim where item_key = 'I00071';

-- Steps for Data Cleaning in store TABLE

select * from item_dim;

select * from item_dim  i left join fact_table f on i.item_key = f.item_key ;
select * from item_dim where unit is null;
select * from item_dim where supplier ='';
update item_dim  set unit ="unknown" where unit = '';

-- Steps for Data Cleaning in item TABLE
select * from item_dim;
select  count(Distinct(item_key)) from item_dim;
Alter table item_dim add constraint pk_item_key primary key (item_key);
select * from  item_dim
WHERE describes LIKE 'a.%';

UPDATE item_dim
SET describes = TRIM(REPLACE(describes, 'a.', ''))
WHERE describes LIKE 'a.%'; 
Update item_dim set describes ="Beverage - Sparkling Water" where describes="Beverage Sparkling Water";
Update item_dim set describes ="Beverage - Water" where describes="Beverage Water";
Update item_dim set describes ="Kitchen - Supplies" where describes="kitchen-supplies";
Update item_dim set describes ="Coffee - Sweetener" where describes="coffee - Sweetener";
Update item_dim set describes ="Coffee - Cream" where describes="coffee - Cream";
Update item_dim set describes ="Coffee - Hot Cocoa" where describes="coffee - Hot Cocoa";
Update item_dim set describes ="Coffee - Ground" where describes="coffee - Ground";
Update item_dim set describes ="Coffee - Creamer" where describes ="Coffee Creamer";
Update item_dim set describes ="Coffee - Stirrers" where describes="Coffee Stirrers";


-- Steps for Data Cleaning in STORE TABLE
select  * from store_dim;
select district from store_dim where district is null;
select   count(distinct(store_key) ) from store_dim;


-- Steps for Data Cleaning in TIME TABLEs
select  * from time_dim;
select count( Distinct(time_key)) from time_dim;
select quarters from time_dim where quarters = '';
alter table time_dim add constraint pk_time_key  primary key(time_key);


-- Steps for Data Cleaning in Trans TABLE
select payment_key from trans_dim;
select  count(*) from trans_dim;
select count( Distinct(payment_key)) from trans_dim;
select trans_type from trans_dim where trans_type is  null;

select count(distinct(customer_key)) from customer_dim;
select count(distinct(customer_key)) from fact_table;

SELect  count( DISTINCT f.customer_key)
FROM fact_table f
LEFT JOIN customer_dim c
  ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

delete  f from  fact_table f left  join customer_dim c on f.customer_key = c.customer_key where c.customer_key is null;










select * from customer_dim ;

SELECT
    c.customer_key,
    c.name_of_customer,
    SUM(f.total_price) AS customer_lifetime_value
FROM fact_table f
JOIN customer_dim c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.name_of_customer;
    
    select * from fact_table;























  
  
  
  
  
  

