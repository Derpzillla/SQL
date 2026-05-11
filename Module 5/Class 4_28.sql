-- Activity part 1
-- Normalized
select *
from nml_customers;

select * 
from nml_products;

select * 
from nml_order_items;

select *
from nml_warehouses;

select *
from nml_inventory;

-- Star
select *
from star_fact_sales;

select *
from star_fact_inventory;

-- Activity part 3: (Snowflake Schema) TCPDS Snowflake_sample_data Schema, swap db and schema
-- First two tables are fact tables.
select *
from store_sales
limit 10;

select *
from store_returns
limit 10;
-- customer is a dim table
select * 
from customer
limit 10;
-- customer_address is a sub dim table.
select *
from customer_address
limit 10;




