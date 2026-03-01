-- Activity part 1 

-- suing modeule1_final_activity schema
-- use describe and show to identify structured data (key columns), semi-structured data and unstructured data

show tables;

describe table CARS;
describe table CARS_DEALERS;
describe table DEALERS;

select * 
from cars;

select * 
from cars_dealers;

select * 
from dealers;

-- Activity part 2

-- write a query that uses all of the following sql keywords SELECT, FROM, INNER JOIN, WHERE, ORDER BY 

-- What dealers have SUV cars in stock? 

select d.Dealer_id,
dealer_name,
location, 
dealer_rating,
c.category,
c.make,
c.model
from dealers d
inner join cars_dealers cd on cd.dealer_id = d.dealer_id 
inner join cars c on c.car_id = cd.car_id
where c.category = 'SUV'
order by d.dealer_rating desc;

-- Activity part 3
-- using module1_final_activity schema

-- Write one or more queries that use the following sql syntax
-- array_name[index] , variant_name:key::type

select dealer_id,
dealer_name,
specialties[0]::string as specialties_first,
contact_info:phone::string as phone_num
from dealers;


-- quiz example, lateral flatten

select *
from cars_dealers cd,
lateral flatten(input => special_offers) f     -- turns json value into a new key-value row for each value.
where cd.DEALER_ID =1 and cd.CAR_ID =1;

-- Activity part 4

select car_id,
make,
model,
ai_similarity(description, 'Car or truck that would be good in the snow') as similarity_score_snow
from cars
order by similarity_score_snow desc;

SHOW PRIMARY KEYS IN DATABASE;CREATE OR REPLACE TEMPORARY TABLE PK as SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));SHOW IMPORTED KEYS IN DATABASE;CREATE OR REPLACE TEMPORARY TABLE FK as SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));SHOW UNIQUE KEYS IN DATABASE;CREATE OR REPLACE TEMPORARY TABLE UK as SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));SELECT 'snowflake' AS dbms,c.TABLE_CATALOG,c.TABLE_SCHEMA,c.TABLE_NAME,c.COLUMN_NAME,c.ORDINAL_POSITION,CASE WHEN c.DATA_TYPE ILIKE 'NUMBER' THEN 'NUMBER(' || c.NUMERIC_PRECISION || ',' || c.NUMERIC_SCALE || ')' ELSE UPPER(c.DATA_TYPE)END AS DATA_TYPE,c.CHARACTER_MAXIMUM_LENGTH,LISTAGG(DISTINCT CASE WHEN pk."column_name" IS NOT NULL THEN 'PRIMARY KEY' WHEN fk."fk_column_name" IS NOT NULL THEN 'FOREIGN KEY' WHEN uk."column_name" IS NOT NULL THEN 'UNIQUE' ELSE NULL END,',')WITHIN GROUP(ORDER BY 1)AS CONSTRAINT_TYPE,fk."pk_schema_name" AS REFERENCED_TABLE_SCHEMA,fk."pk_table_name" AS REFERENCED_TABLE_NAME,fk."pk_column_name" AS REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS c LEFT JOIN pk ON c.TABLE_CATALOG=pk."database_name" AND c.TABLE_SCHEMA=pk."schema_name" AND c.TABLE_NAME=pk."table_name" AND c.COLUMN_NAME=pk."column_name" LEFT JOIN uk ON c.TABLE_CATALOG=uk."database_name" AND c.TABLE_SCHEMA=uk."schema_name" AND c.TABLE_NAME=uk."table_name" AND c.COLUMN_NAME=uk."column_name" LEFT JOIN fk ON c.TABLE_CATALOG=fk."fk_database_name" AND c.TABLE_SCHEMA=fk."fk_schema_name" AND c.TABLE_NAME=fk."fk_table_name" AND c.COLUMN_NAME=fk."fk_column_name" WHERE c.TABLE_SCHEMA NOT IN('INFORMATION_SCHEMA','ACCOUNT_USAGE')AND c.TABLE_NAME NOT IN('PK','UK','FK','C')GROUP BY c.TABLE_CATALOG,c.TABLE_SCHEMA,c.TABLE_NAME,c.COLUMN_NAME,c.ORDINAL_POSITION,c.DATA_TYPE,c.NUMERIC_PRECISION,c.NUMERIC_SCALE,c.CHARACTER_MAXIMUM_LENGTH,fk."pk_schema_name",fk."pk_table_name",fk."pk_column_name",REFERENCED_COLUMN_NAME ORDER BY c.TABLE_CATALOG,c.TABLE_SCHEMA,c.TABLE_NAME,c.ORDINAL_POSITION;