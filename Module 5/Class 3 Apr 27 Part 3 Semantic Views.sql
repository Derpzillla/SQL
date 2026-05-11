USE ROLE RACCOON_ROLE;
USE WAREHOUSE ANIMAL_TASK_WH;
USE DATABASE Z_DB_RACCOON;
USE SCHEMA PUBLIC;

-- ============================================================
-- SEMANTIC VIEW 1: Normalized Schema (NML tables)
-- ============================================================
CREATE OR REPLACE SEMANTIC VIEW NML_SEMANTIC_VIEW

  TABLES (
    regions     AS NML_REGIONS     PRIMARY KEY (REGION_ID),
    states      AS NML_STATES      PRIMARY KEY (STATE_ID),
    cities      AS NML_CITIES      PRIMARY KEY (CITY_ID),
    customers   AS NML_CUSTOMERS   PRIMARY KEY (CUSTOMER_ID),
    categories  AS NML_CATEGORIES  PRIMARY KEY (CATEGORY_ID),
    products    AS NML_PRODUCTS    PRIMARY KEY (PRODUCT_ID),
    warehouses  AS NML_WAREHOUSES  PRIMARY KEY (WAREHOUSE_ID),
    inventory   AS NML_INVENTORY   PRIMARY KEY (INVENTORY_ID),
    orders      AS NML_ORDERS      PRIMARY KEY (ORDER_ID),
    order_items AS NML_ORDER_ITEMS PRIMARY KEY (ORDER_ITEM_ID)
  )

  RELATIONSHIPS (
    states_to_regions      AS states      (REGION_ID)    REFERENCES regions,
    cities_to_states       AS cities      (STATE_ID)     REFERENCES states,
    customers_to_cities    AS customers   (CITY_ID)      REFERENCES cities,
    products_to_categories AS products    (CATEGORY_ID)  REFERENCES categories,
    warehouses_to_cities   AS warehouses  (CITY_ID)      REFERENCES cities,
    inventory_to_products  AS inventory   (PRODUCT_ID)   REFERENCES products,
    inventory_to_warehouses AS inventory  (WAREHOUSE_ID) REFERENCES warehouses,
    orders_to_customers    AS orders      (CUSTOMER_ID)  REFERENCES customers,
    items_to_orders        AS order_items (ORDER_ID)     REFERENCES orders,
    items_to_products      AS order_items (PRODUCT_ID)   REFERENCES products
  )

  FACTS (
    order_items.net_line_amount AS QUANTITY * UNIT_PRICE * (1 - DISCOUNT_PCT)
      COMMENT = 'Line item revenue after discount'
  )

  DIMENSIONS (
    regions.region_name       AS REGION_NAME     COMMENT = 'Geographic region',
    states.state_name         AS STATE_NAME      COMMENT = 'State name',
    states.state_abbr         AS STATE_ABBR      COMMENT = 'State abbreviation',
    cities.city_name          AS CITY_NAME       COMMENT = 'City name',
    customers.customer_name   AS FIRST_NAME || ' ' || LAST_NAME
      COMMENT = 'Full customer name',
    customers.email           AS EMAIL           COMMENT = 'Customer email',
    customers.created_date    AS CREATED_DATE    COMMENT = 'Date customer was created',
    categories.category_name  AS CATEGORY_NAME   COMMENT = 'Product category',
    products.product_name     AS PRODUCT_NAME    COMMENT = 'Product name',
    products.list_price       AS UNIT_PRICE      COMMENT = 'Product list price',
    warehouses.warehouse_name AS WAREHOUSE_NAME  COMMENT = 'Warehouse name',
    inventory.qty_on_hand     AS QTY_ON_HAND     COMMENT = 'Current quantity on hand',
    inventory.reorder_level   AS REORDER_LEVEL   COMMENT = 'Reorder threshold',
    inventory.last_restock    AS LAST_RESTOCK_DATE COMMENT = 'Last restock date',
    orders.order_date         AS ORDER_DATE      COMMENT = 'Date the order was placed',
    orders.ship_date          AS SHIP_DATE       COMMENT = 'Date the order shipped',
    orders.order_status       AS STATUS          COMMENT = 'Order status',
    order_items.quantity      AS QUANTITY         COMMENT = 'Quantity ordered',
    order_items.sold_price    AS UNIT_PRICE       COMMENT = 'Price at time of sale',
    order_items.discount_pct  AS DISCOUNT_PCT     COMMENT = 'Discount percentage'
  )

  METRICS (
    order_items.total_revenue AS SUM(order_items.net_line_amount)
      COMMENT = 'Total net revenue after discounts',
    order_items.total_qty_sold AS SUM(order_items.quantity)
      COMMENT = 'Total units sold',
    orders.order_count AS COUNT(ORDER_ID)
      COMMENT = 'Number of orders',
    inventory.total_inventory AS SUM(inventory.qty_on_hand)
      COMMENT = 'Total inventory across all warehouses'
  )

  COMMENT = 'Semantic view over normalized customers, orders, and inventory tables';


-- ============================================================
-- SEMANTIC VIEW 2: Star Schema (STAR tables)
-- ============================================================
CREATE OR REPLACE SEMANTIC VIEW STAR_SEMANTIC_VIEW

  TABLES (
    dim_date      AS STAR_DIM_DATE      PRIMARY KEY (DATE_KEY),
    dim_customer  AS STAR_DIM_CUSTOMER  PRIMARY KEY (CUSTOMER_KEY),
    dim_product   AS STAR_DIM_PRODUCT   PRIMARY KEY (PRODUCT_KEY),
    dim_warehouse AS STAR_DIM_WAREHOUSE PRIMARY KEY (WAREHOUSE_KEY),
    fact_sales    AS STAR_FACT_SALES    PRIMARY KEY (SALE_KEY),
    fact_inv      AS STAR_FACT_INVENTORY PRIMARY KEY (INVENTORY_KEY)
  )

  RELATIONSHIPS (
    sales_to_date      AS fact_sales (DATE_KEY)      REFERENCES dim_date,
    sales_to_customer  AS fact_sales (CUSTOMER_KEY)  REFERENCES dim_customer,
    sales_to_product   AS fact_sales (PRODUCT_KEY)   REFERENCES dim_product,
    inv_to_product     AS fact_inv   (PRODUCT_KEY)   REFERENCES dim_product,
    inv_to_warehouse   AS fact_inv   (WAREHOUSE_KEY) REFERENCES dim_warehouse,
    inv_to_date        AS fact_inv   (DATE_KEY)      REFERENCES dim_date
  )

  DIMENSIONS (
    dim_date.full_date       AS FULL_DATE      COMMENT = 'Full calendar date',
    dim_date.year            AS YEAR           COMMENT = 'Calendar year',
    dim_date.quarter         AS QUARTER        COMMENT = 'Calendar quarter',
    dim_date.month_num       AS MONTH          COMMENT = 'Month number',
    dim_date.month_name      AS MONTH_NAME     COMMENT = 'Month name',
    dim_date.day_of_week     AS DAY_OF_WEEK    COMMENT = 'Day of week number',
    dim_date.day_name        AS DAY_NAME       COMMENT = 'Day name',
    dim_customer.customer_name AS FIRST_NAME || ' ' || LAST_NAME
      COMMENT = 'Full customer name',
    dim_customer.email       AS EMAIL          COMMENT = 'Customer email',
    dim_customer.city        AS CITY_NAME      COMMENT = 'Customer city',
    dim_customer.state       AS STATE_NAME     COMMENT = 'Customer state',
    dim_customer.state_abbr  AS STATE_ABBR     COMMENT = 'Customer state abbreviation',
    dim_customer.region      AS REGION_NAME    COMMENT = 'Customer region',
    dim_product.product_name AS PRODUCT_NAME   COMMENT = 'Product name',
    dim_product.list_price   AS LIST_PRICE     COMMENT = 'Product list price',
    dim_product.category     AS CATEGORY_NAME  COMMENT = 'Product category',
    dim_warehouse.warehouse_name AS WAREHOUSE_NAME COMMENT = 'Warehouse name',
    dim_warehouse.wh_city    AS CITY_NAME      COMMENT = 'Warehouse city',
    dim_warehouse.wh_state   AS STATE_NAME     COMMENT = 'Warehouse state',
    dim_warehouse.wh_region  AS REGION_NAME    COMMENT = 'Warehouse region',
    fact_inv.qty_on_hand     AS QTY_ON_HAND    COMMENT = 'Quantity on hand',
    fact_inv.reorder_level   AS REORDER_LEVEL  COMMENT = 'Reorder threshold',
    fact_inv.needs_reorder   AS NEEDS_REORDER  COMMENT = 'Whether item needs reorder'
  )

  METRICS (
    fact_sales.total_revenue AS SUM(NET_AMOUNT)
      COMMENT = 'Total net revenue after discounts',
    fact_sales.total_gross_revenue AS SUM(GROSS_AMOUNT)
      COMMENT = 'Total revenue before discounts',
    fact_sales.total_qty_sold AS SUM(QUANTITY)
      COMMENT = 'Total units sold',
    fact_sales.order_count AS COUNT(DISTINCT ORDER_ID)
      COMMENT = 'Number of distinct orders',
    fact_inv.total_inventory AS SUM(fact_inv.qty_on_hand)
      COMMENT = 'Total inventory across all warehouses'
  )

  COMMENT = 'Semantic view over star schema with fact and dimension tables';

-- ============================================================
-- PART 3: DEMONSTRATING THE VALUE OF SEMANTIC VIEWS
-- ============================================================
-- Semantic views power Cortex Analyst, which lets users ask
-- natural language questions instead of writing SQL.
--
-- HOW TO DEMO:
-- 1. Go to Snowsight > Cortex Analyst (or use the AI chat)
-- 2. Select one of the semantic views below
-- 3. Ask plain English questions - Cortex Analyst generates the SQL
--
-- Try these questions against NML_SEMANTIC_VIEW:
--   "What is the total revenue by region?"
--   "Which product category sold the most units?"
--   "Show me total revenue by category and region for Q1 2024"
--   "Who are the top 5 customers by total spend?"
--
-- Try these questions against STAR_SEMANTIC_VIEW:
--   "What is total revenue by quarter?"
--   "Which region has the most orders?"
--   "Show me products that need reorder"
--   "What is the average order value by region?"
--
-- KEY TEACHING POINTS:
-- ---------------------------------------------------------
-- WITHOUT semantic view: user must know all table names,
--   column names, join paths, and how to calculate metrics.
--   On the normalized schema, that is 7+ JOINs!
--
-- WITH semantic view: Cortex Analyst understands the
--   relationships, dimensions, and pre-defined metrics.
--   The user just asks a question in plain English.
-- ---------------------------------------------------------

-- You can also query the semantic view metadata to show
-- students what Cortex Analyst "sees":
DESCRIBE SEMANTIC VIEW Z_DB_INSTRUCTOR1.MODULE5.NML_SEMANTIC_VIEW;
DESCRIBE SEMANTIC VIEW Z_DB_INSTRUCTOR1.MODULE5.STAR_SEMANTIC_VIEW;
