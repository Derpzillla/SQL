-- submit chosen dataset for final project as assingment

-- Part 2: synthetic data generation

select *
from information_schema.views
where table_name ilike 'united_nations%';

use database z_db_raccoon;


CREATE OR REPLACE TABLE Z_DB_RACCOON.PUBLIC.EX_MENU_ITEMS (
    MENU_ITEM_ID INT PRIMARY KEY,
    ITEM_NAME VARCHAR(100) NOT NULL,
    CATEGORY VARCHAR(50) NOT NULL,
    PRICE DECIMAL(8,2) NOT NULL,
    IS_VEGETARIAN BOOLEAN NOT NULL
);

CREATE OR REPLACE TABLE Z_DB_RACCOON.PUBLIC.EX_CUSTOMERS (
    CUSTOMER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50) NOT NULL,
    LAST_NAME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL,
    PHONE VARCHAR(20)
);


CREATE OR REPLACE TABLE Z_DB_RACCOON.PUBLIC.EX_ORDERS (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT NOT NULL,
    MENU_ITEM_ID INT NOT NULL,
    ORDER_DATE DATE NOT NULL,
    QUANTITY INT NOT NULL,
    TOTAL_AMOUNT DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Z_DB_RACCOON.PUBLIC.EX_CUSTOMERS(CUSTOMER_ID),
    FOREIGN KEY (MENU_ITEM_ID) REFERENCES Z_DB_RACCOON.PUBLIC.EX_MENU_ITEMS(MENU_ITEM_ID)
);


INSERT INTO Z_DB_RACCOON.PUBLIC.EX_MENU_ITEMS (MENU_ITEM_ID, ITEM_NAME, CATEGORY, PRICE, IS_VEGETARIAN) VALUES
    (1, 'Classic Cheeseburger', 'Entree', 14.99, FALSE),
    (2, 'Margherita Pizza', 'Entree', 12.50, TRUE),
    (3, 'Grilled Salmon', 'Entree', 22.00, FALSE),
    (4, 'Caesar Salad', 'Appetizer', 9.75, TRUE),
    (5, 'Chicken Wings', 'Appetizer', 11.50, FALSE),
    (6, 'Mushroom Risotto', 'Entree', 16.00, TRUE),
    (7, 'Tiramisu', 'Dessert', 8.50, TRUE),
    (8, 'Chocolate Lava Cake', 'Dessert', 9.00, TRUE),
    (9, 'Iced Lemonade', 'Beverage', 4.50, TRUE),
    (10, 'Espresso', 'Beverage', 3.75, TRUE);


INSERT INTO Z_DB_RACCOON.PUBLIC.EX_CUSTOMERS (CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE) VALUES
    (1, 'Maria', 'Garcia', 'maria.garcia@email.com', '555-0101'),
    (2, 'James', 'Wilson', 'james.wilson@email.com', '555-0102'),
    (3, 'Aisha', 'Patel', 'aisha.patel@email.com', '555-0103'),
    (4, 'Robert', 'Chen', 'robert.chen@email.com', NULL),
    (5, 'Emily', 'Johnson', 'emily.johnson@email.com', '555-0105'),
    (6, 'David', 'Kim', 'david.kim@email.com', '555-0106'),
    (7, 'Sarah', 'Brown', 'sarah.brown@email.com', NULL),
    (8, 'Michael', 'Lopez', 'michael.lopez@email.com', '555-0108'),
    (9, 'Olivia', 'Nguyen', 'olivia.nguyen@email.com', '555-0109'),
    (10, 'Daniel', 'Martinez', 'daniel.martinez@email.com', '555-0110');


INSERT INTO Z_DB_RACCOON.PUBLIC.EX_ORDERS (ORDER_ID, CUSTOMER_ID, MENU_ITEM_ID, ORDER_DATE, QUANTITY, TOTAL_AMOUNT) VALUES
    (1, 1, 1, '2025-04-01', 2, 29.98),
    (2, 2, 3, '2025-04-02', 1, 22.00),
    (3, 3, 2, '2025-04-03', 3, 37.50),
    (4, 4, 5, '2025-04-05', 2, 23.00),
    (5, 5, 7, '2025-04-06', 4, 34.00),
    (6, 6, 4, '2025-04-08', 1, 9.75),
    (7, 7, 6, '2025-04-10', 2, 32.00),
    (8, 8, 8, '2025-04-12', 1, 9.00),
    (9, 9, 10, '2025-04-14', 3, 11.25),
    (10, 10, 9, '2025-04-15', 2, 9.00);


-- Activity part 3
select * from EX_ORDERS;

select * from ingest_example;