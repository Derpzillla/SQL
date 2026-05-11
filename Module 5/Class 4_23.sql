-- Activity part 1: Generate items table
CREATE OR REPLACE TABLE Z_DB_RACCOON.PUBLIC.ITEMS (
    ITEM_ID INT PRIMARY KEY,
    ITEM_NAME VARCHAR(100) NOT NULL,
    ITEM_TYPE VARCHAR(20) NOT NULL,
    ITEM_COUNT INT NOT NULL,
    ITEM_NOTES VARCHAR(500)
);

INSERT INTO Z_DB_RACCOON.PUBLIC.ITEMS (ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_COUNT, ITEM_NOTES)
VALUES
    (1, 'Whole Milk', 'Perishable', 120, 'Gallon containers, keep refrigerated'),
    (2, 'White Bread', 'Perishable', 85, 'Sliced, 20oz loaves'),
    (3, 'Bananas', 'Perishable', 200, NULL),
    (4, 'Chicken Breast', 'Perishable', 60, 'Boneless skinless, sold by the pound'),
    (5, 'Canned Tomatoes', 'Non-Perishable', 150, NULL),
    (6, 'Paper Towels', 'Non-Perishable', 300, '6-roll packs'),
    (7, 'Strawberries', 'Perishable', 45, '1lb clamshell containers'),
    (8, 'Rice', 'Non-Perishable', 175, '5lb bags, long grain white'),
    (9, 'Greek Yogurt', 'Perishable', 90, 'Assorted flavors, single serve cups'),
    (10, 'Dish Soap', 'Non-Perishable', 110, NULL),
    (11, 'Ground Beef', 'Perishable', 55, '80/20 blend, 1lb packages'),
    (12, 'Pasta', 'Non-Perishable', 220, 'Spaghetti and penne varieties'),
    (13, 'Eggs', 'Perishable', 130, 'Large, dozen per carton'),
    (14, 'Batteries', 'Non-Perishable', 95, 'AA and AAA packs of 8'),
    (15, 'Fresh Salmon', 'Perishable', 30, 'Atlantic, sold by the pound'),
    (16, 'Olive Oil', 'Non-Perishable', 80, 'Extra virgin, 16oz bottles'),
    (17, 'Spinach', 'Perishable', 70, 'Pre-washed baby spinach, 5oz bags'),
    (18, 'Aluminum Foil', 'Non-Perishable', 140, NULL),
    (19, 'Cheddar Cheese', 'Perishable', 100, 'Sharp, 8oz blocks'),
    (20, 'Peanut Butter', 'Non-Perishable', 160, 'Creamy, 16oz jars'),
    (21, 'Avocados', 'Perishable', 75, NULL),
    (22, 'Laundry Detergent', 'Non-Perishable', 65, 'Liquid, 50oz bottles'),
    (23, 'Black Beans', 'Non-Perishable', 185, '15oz cans'),
    (24, 'Heavy Cream', 'Perishable', 40, 'Pint containers'),
    (25, 'Light Bulbs', 'Non-Perishable', 50, 'LED, 60W equivalent, 4-packs');

select * from items;

-- Activity part 2
insert into Z_DB_RACCOON.PUBLIC.items (item_id,item_name, item_type, item_count, item_notes)
values
(26, 'Lettuce', 'Perishable', 75,'Can be stored for up to two weeks');

select * from items;   

update items
set item_count = 70
where item_id = 26;

select *
from items;

delete
from items
where item_id = 26;

-- Activity part 3: Time travel (rollback)

SELECT query_id, query_text, user_name, role_name, warehouse_name,
       start_time, end_time, execution_status, total_elapsed_time
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%items%'
and user_name = 'RACCOON'
ORDER BY start_time DESC
LIMIT 50;

select *
from items at(statement => '01c3faf3-0208-abe2-001a-e4730146b686');


-- Clone
create or replace table items_clone
CLONE items before(statement => '01c3faf3-0208-abe2-001a-e4730146b686');

-- restore with swap 
alter table items swap with items_clone;

-- update items table after swap
select * from items;

delete items_clone

-- Delete items_clone
drop table items_clone;

select * from items_clone;

undrop table items_clone;
select *
from items_clone;

-- Data Dictionary for ITEMS table
WITH total AS (SELECT COUNT(*) AS total_rows FROM Z_DB_RACCOON.PUBLIC.ITEMS),

non_categorical AS (
    SELECT 1 AS col_pos, 'ITEM_ID' AS COLUMN_NAME, 'Unique identifier for each item' AS DESCRIPTION,
           NULL AS "VALUES",
           COUNT(ITEM_ID) AS N,
           ROUND(COUNT(ITEM_ID) * 100.0 / t.total_rows, 1) AS PCT,
           MIN(ITEM_ID)::VARCHAR AS MIN,
           MAX(ITEM_ID)::VARCHAR AS MAX
    FROM Z_DB_RACCOON.PUBLIC.ITEMS, total t
    GROUP BY t.total_rows

    UNION ALL

    SELECT 2, 'ITEM_NAME', 'Name of the item', NULL,
           COUNT(ITEM_NAME),
           ROUND(COUNT(ITEM_NAME) * 100.0 / t.total_rows, 1),
           MIN(LEN(ITEM_NAME))::VARCHAR,
           MAX(LEN(ITEM_NAME))::VARCHAR
    FROM Z_DB_RACCOON.PUBLIC.ITEMS, total t
    GROUP BY t.total_rows

    UNION ALL

    SELECT 4, 'ITEM_COUNT', 'Quantity of items in stock', NULL,
           COUNT(ITEM_COUNT),
           ROUND(COUNT(ITEM_COUNT) * 100.0 / t.total_rows, 1),
           MIN(ITEM_COUNT)::VARCHAR,
           MAX(ITEM_COUNT)::VARCHAR
    FROM Z_DB_RACCOON.PUBLIC.ITEMS, total t
    GROUP BY t.total_rows

    UNION ALL

    SELECT 5, 'ITEM_NOTES', 'Additional notes about the item', NULL,
           COUNT(ITEM_NOTES),
           ROUND(COUNT(ITEM_NOTES) * 100.0 / t.total_rows, 1),
           MIN(LEN(ITEM_NOTES))::VARCHAR,
           MAX(LEN(ITEM_NOTES))::VARCHAR
    FROM Z_DB_RACCOON.PUBLIC.ITEMS, total t
    GROUP BY t.total_rows
),

categorical AS (
    SELECT 3 AS col_pos, 'ITEM_TYPE' AS COLUMN_NAME, 'Category of the item' AS DESCRIPTION,
           ITEM_TYPE AS "VALUES",
           COUNT(*) AS N,
           ROUND(COUNT(*) * 100.0 / t.total_rows, 1) AS PCT,
           NULL AS MIN,
           NULL AS MAX
    FROM Z_DB_RACCOON.PUBLIC.ITEMS, total t
    GROUP BY ITEM_TYPE, t.total_rows
)

SELECT COLUMN_NAME, DESCRIPTION, "VALUES", N, PCT, MIN, MAX
FROM (
    SELECT col_pos, COLUMN_NAME, DESCRIPTION, "VALUES", N, PCT, MIN, MAX FROM non_categorical
    UNION ALL
    SELECT col_pos, COLUMN_NAME, DESCRIPTION, "VALUES", N, PCT, MIN, MAX FROM categorical
)
ORDER BY col_pos, "VALUES";

