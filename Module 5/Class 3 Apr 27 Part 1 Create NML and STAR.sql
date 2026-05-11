-- ============================================================
-- ACTIVITY: Normalized vs Star Schema
-- ============================================================
-- We will build a normalized schema, run a reporting query,
-- then create a star schema via ETL and run the same report. Same data generated into two different schemas (one star and one normalized)
-- ============================================================

USE ROLE RACCOON_ROLE;
USE WAREHOUSE ANIMAL_TASK_WH;
USE DATABASE Z_DB_RACCOON;
USE SCHEMA PUBLIC;

-- ============================================================
-- PART 1: CREATE NORMALIZED SCHEMA (NML prefix)
-- ============================================================

CREATE OR REPLACE TABLE NML_REGIONS (
    REGION_ID       INT PRIMARY KEY,
    REGION_NAME     VARCHAR(50)
);

CREATE OR REPLACE TABLE NML_STATES (
    STATE_ID        INT PRIMARY KEY,
    STATE_NAME      VARCHAR(50),
    STATE_ABBR      CHAR(2),
    REGION_ID       INT REFERENCES NML_REGIONS(REGION_ID)
);

CREATE OR REPLACE TABLE NML_CITIES (
    CITY_ID         INT PRIMARY KEY,
    CITY_NAME       VARCHAR(100),
    STATE_ID        INT REFERENCES NML_STATES(STATE_ID)
);

CREATE OR REPLACE TABLE NML_CUSTOMERS (
    CUSTOMER_ID     INT PRIMARY KEY,
    FIRST_NAME      VARCHAR(50),
    LAST_NAME       VARCHAR(50),
    EMAIL           VARCHAR(100),
    CITY_ID         INT REFERENCES NML_CITIES(CITY_ID),
    CREATED_DATE    DATE
);

CREATE OR REPLACE TABLE NML_CATEGORIES (
    CATEGORY_ID     INT PRIMARY KEY,
    CATEGORY_NAME   VARCHAR(50)
);

CREATE OR REPLACE TABLE NML_PRODUCTS (
    PRODUCT_ID      INT PRIMARY KEY,
    PRODUCT_NAME    VARCHAR(100),
    CATEGORY_ID     INT REFERENCES NML_CATEGORIES(CATEGORY_ID),
    UNIT_PRICE      DECIMAL(10,2)
);

CREATE OR REPLACE TABLE NML_WAREHOUSES (
    WAREHOUSE_ID    INT PRIMARY KEY,
    WAREHOUSE_NAME  VARCHAR(100),
    CITY_ID         INT REFERENCES NML_CITIES(CITY_ID)
);

CREATE OR REPLACE TABLE NML_INVENTORY (
    INVENTORY_ID    INT PRIMARY KEY,
    PRODUCT_ID      INT REFERENCES NML_PRODUCTS(PRODUCT_ID),
    WAREHOUSE_ID    INT REFERENCES NML_WAREHOUSES(WAREHOUSE_ID),
    QTY_ON_HAND     INT,
    REORDER_LEVEL   INT,
    LAST_RESTOCK_DATE DATE
);

CREATE OR REPLACE TABLE NML_ORDERS (
    ORDER_ID        INT PRIMARY KEY,
    CUSTOMER_ID     INT REFERENCES NML_CUSTOMERS(CUSTOMER_ID),
    ORDER_DATE      DATE,
    SHIP_DATE       DATE,
    STATUS          VARCHAR(20)
);

CREATE OR REPLACE TABLE NML_ORDER_ITEMS (
    ORDER_ITEM_ID   INT PRIMARY KEY,
    ORDER_ID        INT REFERENCES NML_ORDERS(ORDER_ID),
    PRODUCT_ID      INT REFERENCES NML_PRODUCTS(PRODUCT_ID),
    QUANTITY         INT,
    UNIT_PRICE       DECIMAL(10,2),
    DISCOUNT_PCT     DECIMAL(5,2)
);

-- ============================================================
-- PART 2: INSERT SYNTHETIC DATA
-- ============================================================

INSERT INTO NML_REGIONS VALUES
(1, 'Northeast'), (2, 'Southeast'), (3, 'Midwest'), (4, 'West');

INSERT INTO NML_STATES VALUES
(1, 'New York',      'NY', 1), (2, 'Massachusetts', 'MA', 1),
(3, 'Florida',       'FL', 2), (4, 'Georgia',       'GA', 2),
(5, 'Illinois',      'IL', 3), (6, 'Ohio',          'OH', 3),
(7, 'California',    'CA', 4), (8, 'Washington',    'WA', 4);

INSERT INTO NML_CITIES VALUES
(1, 'New York City', 1), (2, 'Boston',        2),
(3, 'Miami',         3), (4, 'Atlanta',       4),
(5, 'Chicago',       5), (6, 'Columbus',      6),
(7, 'Los Angeles',   7), (8, 'Seattle',       8),
(9, 'Buffalo',       1), (10,'San Francisco', 7);

INSERT INTO NML_CUSTOMERS VALUES
(1,  'Alice',   'Johnson',  'alice@email.com',   1, '2023-01-15'),
(2,  'Bob',     'Smith',    'bob@email.com',     3, '2023-02-20'),
(3,  'Carol',   'Williams', 'carol@email.com',   5, '2023-03-10'),
(4,  'David',   'Brown',    'david@email.com',   7, '2023-04-05'),
(5,  'Eve',     'Davis',    'eve@email.com',     2, '2023-05-12'),
(6,  'Frank',   'Miller',   'frank@email.com',   4, '2023-06-18'),
(7,  'Grace',   'Wilson',   'grace@email.com',   8, '2023-07-22'),
(8,  'Henry',   'Moore',    'henry@email.com',   6, '2023-08-30'),
(9,  'Ivy',     'Taylor',   'ivy@email.com',     9, '2023-09-14'),
(10, 'Jack',    'Anderson', 'jack@email.com',    10,'2023-10-01'),
(11, 'Karen',   'Thomas',   'karen@email.com',   1, '2023-11-05'),
(12, 'Leo',     'Jackson',  'leo@email.com',     3, '2024-01-10'),
(13, 'Mia',     'White',    'mia@email.com',     5, '2024-02-14'),
(14, 'Noah',    'Harris',   'noah@email.com',    7, '2024-03-20'),
(15, 'Olivia',  'Martin',   'olivia@email.com',  2, '2024-04-25');

INSERT INTO NML_CATEGORIES VALUES
(1, 'Electronics'), (2, 'Clothing'), (3, 'Home & Garden'),
(4, 'Sports'), (5, 'Books');

INSERT INTO NML_PRODUCTS VALUES
(1,  'Laptop',          1, 999.99),
(2,  'Smartphone',      1, 699.99),
(3,  'Headphones',      1, 149.99),
(4,  'Winter Jacket',   2, 189.99),
(5,  'Running Shoes',   2,  99.99),
(6,  'Garden Hose',     3,  34.99),
(7,  'Patio Set',       3, 499.99),
(8,  'Basketball',      4,  29.99),
(9,  'Yoga Mat',        4,  24.99),
(10, 'SQL Textbook',    5,  59.99),
(11, 'Tablet',          1, 449.99),
(12, 'Backpack',        4,  79.99);

INSERT INTO NML_WAREHOUSES VALUES
(1, 'East Coast Hub',    1),
(2, 'Southeast Depot',   4),
(3, 'Midwest Center',    5),
(4, 'West Coast Hub',    7);

INSERT INTO NML_INVENTORY VALUES
(1,  1,  1, 150, 20, '2024-03-01'),
(2,  1,  4, 200, 25, '2024-03-05'),
(3,  2,  1, 300, 50, '2024-02-15'),
(4,  2,  3, 180, 30, '2024-02-20'),
(5,  3,  1,  60, 75, '2024-01-10'),
(6,  4,  2, 100, 15, '2024-03-10'),
(7,  5,  3, 250, 40, '2024-02-28'),
(8,  6,  2,   8, 10, '2024-01-20'),
(9,  7,  4,   3,  5, '2024-03-15'),
(10, 8,  3, 120, 20, '2024-02-01'),
(11, 9,  3, 200, 30, '2024-01-25'),
(12, 10, 1, 350, 50, '2024-03-20'),
(13, 11, 4,  20, 25, '2024-03-08'),
(14, 12, 2, 160, 20, '2024-02-10'),
(15, 3,  4, 400, 60, '2024-03-12');

INSERT INTO NML_ORDERS VALUES
(1,  1,  '2024-01-10', '2024-01-14', 'Shipped'),
(2,  2,  '2024-01-15', '2024-01-19', 'Shipped'),
(3,  3,  '2024-01-22', '2024-01-26', 'Shipped'),
(4,  4,  '2024-02-01', '2024-02-05', 'Shipped'),
(5,  5,  '2024-02-10', '2024-02-14', 'Shipped'),
(6,  1,  '2024-02-20', '2024-02-24', 'Shipped'),
(7,  6,  '2024-03-01', '2024-03-05', 'Shipped'),
(8,  7,  '2024-03-05', '2024-03-09', 'Shipped'),
(9,  3,  '2024-03-10', '2024-03-14', 'Shipped'),
(10, 8,  '2024-03-15', NULL,         'Processing'),
(11, 9,  '2024-03-18', '2024-03-22', 'Shipped'),
(12, 10, '2024-03-20', '2024-03-24', 'Shipped'),
(13, 2,  '2024-03-22', NULL,         'Processing'),
(14, 11, '2024-03-25', '2024-03-29', 'Shipped'),
(15, 12, '2024-03-28', NULL,         'Processing'),
(16, 4,  '2024-04-01', '2024-04-05', 'Shipped'),
(17, 13, '2024-04-05', '2024-04-09', 'Shipped'),
(18, 14, '2024-04-10', '2024-04-14', 'Shipped'),
(19, 5,  '2024-04-15', '2024-04-19', 'Shipped'),
(20, 15, '2024-04-20', NULL,         'Processing');

INSERT INTO NML_ORDER_ITEMS VALUES
(1,  1,  1,  1, 999.99, 0.00),
(2,  1,  3,  2, 149.99, 0.10),
(3,  2,  2,  1, 699.99, 0.00),
(4,  3,  10, 3,  59.99, 0.05),
(5,  3,  9,  1,  24.99, 0.00),
(6,  4,  7,  1, 499.99, 0.15),
(7,  5,  4,  1, 189.99, 0.00),
(8,  5,  5,  2,  99.99, 0.10),
(9,  6,  11, 1, 449.99, 0.05),
(10, 6,  3,  1, 149.99, 0.00),
(11, 7,  8,  3,  29.99, 0.00),
(12, 7,  12, 1,  79.99, 0.00),
(13, 8,  1,  1, 999.99, 0.10),
(14, 9,  5,  1,  99.99, 0.00),
(15, 9,  6,  2,  34.99, 0.00),
(16, 10, 2,  1, 699.99, 0.05),
(17, 11, 10, 2,  59.99, 0.00),
(18, 12, 4,  1, 189.99, 0.20),
(19, 13, 1,  1, 999.99, 0.00),
(20, 13, 8,  2,  29.99, 0.00),
(21, 14, 11, 1, 449.99, 0.00),
(22, 15, 3,  3, 149.99, 0.10),
(23, 16, 7,  1, 499.99, 0.00),
(24, 16, 9,  2,  24.99, 0.00),
(25, 17, 2,  1, 699.99, 0.05),
(26, 18, 12, 2,  79.99, 0.00),
(27, 18, 5,  1,  99.99, 0.10),
(28, 19, 6,  1,  34.99, 0.00),
(29, 19, 10, 1,  59.99, 0.00),
(30, 20, 4,  2, 189.99, 0.05);

-- ============================================================
-- PART 3: CREATE STAR SCHEMA VIA ETL (STAR prefix)
-- ============================================================

CREATE OR REPLACE TABLE STAR_DIM_DATE AS
SELECT DISTINCT
    TO_CHAR(o.ORDER_DATE, 'YYYYMMDD')::INT  AS DATE_KEY,
    o.ORDER_DATE                              AS FULL_DATE,
    YEAR(o.ORDER_DATE)                        AS YEAR,
    QUARTER(o.ORDER_DATE)                     AS QUARTER,
    MONTH(o.ORDER_DATE)                       AS MONTH,
    MONTHNAME(o.ORDER_DATE)                   AS MONTH_NAME,
    DAYOFWEEK(o.ORDER_DATE)                   AS DAY_OF_WEEK,
    DAYNAME(o.ORDER_DATE)                     AS DAY_NAME
FROM NML_ORDERS o;

CREATE OR REPLACE TABLE STAR_DIM_CUSTOMER AS
SELECT
    c.CUSTOMER_ID    AS CUSTOMER_KEY,
    c.FIRST_NAME,
    c.LAST_NAME,
    c.EMAIL,
    ci.CITY_NAME,
    s.STATE_NAME,
    s.STATE_ABBR,
    r.REGION_NAME
FROM NML_CUSTOMERS c
JOIN NML_CITIES    ci ON c.CITY_ID   = ci.CITY_ID
JOIN NML_STATES    s  ON ci.STATE_ID = s.STATE_ID
JOIN NML_REGIONS   r  ON s.REGION_ID = r.REGION_ID;

CREATE OR REPLACE TABLE STAR_DIM_PRODUCT AS
SELECT
    p.PRODUCT_ID     AS PRODUCT_KEY,
    p.PRODUCT_NAME,
    p.UNIT_PRICE     AS LIST_PRICE,
    cat.CATEGORY_NAME
FROM NML_PRODUCTS   p
JOIN NML_CATEGORIES cat ON p.CATEGORY_ID = cat.CATEGORY_ID;

CREATE OR REPLACE TABLE STAR_DIM_WAREHOUSE AS
SELECT
    w.WAREHOUSE_ID   AS WAREHOUSE_KEY,
    w.WAREHOUSE_NAME,
    ci.CITY_NAME,
    s.STATE_NAME,
    r.REGION_NAME
FROM NML_WAREHOUSES w
JOIN NML_CITIES     ci ON w.CITY_ID   = ci.CITY_ID
JOIN NML_STATES     s  ON ci.STATE_ID = s.STATE_ID
JOIN NML_REGIONS    r  ON s.REGION_ID = r.REGION_ID;

CREATE OR REPLACE TABLE STAR_FACT_SALES AS
SELECT
    oi.ORDER_ITEM_ID                                          AS SALE_KEY,
    TO_CHAR(o.ORDER_DATE, 'YYYYMMDD')::INT                   AS DATE_KEY,
    c.CUSTOMER_ID                                             AS CUSTOMER_KEY,
    oi.PRODUCT_ID                                             AS PRODUCT_KEY,
    o.ORDER_ID,
    oi.QUANTITY,
    oi.UNIT_PRICE,
    oi.DISCOUNT_PCT,
    oi.QUANTITY * oi.UNIT_PRICE                               AS GROSS_AMOUNT,
    oi.QUANTITY * oi.UNIT_PRICE * (1 - oi.DISCOUNT_PCT)       AS NET_AMOUNT
FROM NML_ORDER_ITEMS oi
JOIN NML_ORDERS      o ON oi.ORDER_ID   = o.ORDER_ID
JOIN NML_CUSTOMERS   c ON o.CUSTOMER_ID = c.CUSTOMER_ID;

CREATE OR REPLACE TABLE STAR_FACT_INVENTORY AS
SELECT
    i.INVENTORY_ID                   AS INVENTORY_KEY,
    i.PRODUCT_ID                     AS PRODUCT_KEY,
    i.WAREHOUSE_ID                   AS WAREHOUSE_KEY,
    TO_CHAR(i.LAST_RESTOCK_DATE, 'YYYYMMDD')::INT AS DATE_KEY,
    i.QTY_ON_HAND,
    i.REORDER_LEVEL,
    CASE WHEN i.QTY_ON_HAND <= i.REORDER_LEVEL THEN TRUE ELSE FALSE END AS NEEDS_REORDER
FROM NML_INVENTORY i;


