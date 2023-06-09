SET SQLFORMAT ansiconsole;
SET PAGESIZE 200;
SET ECHO ON;
SPOOL KyleGalwayDBAS32100Assignment2.txt;
-- KyleGalwayDBAS32100Assignment2.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 1.  Show the first name, last name, and level of all managers to 
-- whom Mohammad Peterson reports to, but not Mohammad Peterson himself. 
SELECT
    first_name
  , last_name
  , manager_id
  , level
FROM
    ot.employees
WHERE
    level != 1
START WITH
    lower(first_name || last_name) = 'mohammadpeterson'
CONNECT BY
    PRIOR manager_id = employee_id;

-- Question 2. For each product ID that has a value between 10 and 20, show the 
-- product name, category name, and the number of products from its category.
SELECT DISTINCT
    product_id
  , product_name
  , category_name
  , COUNT(product_name)
      OVER(PARTITION BY category_name) AS category_count
FROM
         ot.products p
    INNER JOIN ot.product_categories c
    ON p.category_id = c.category_id
WHERE
    product_id BETWEEN 10 AND 20
ORDER BY
    category_name;

-- Question 3. Show the customer name and order price of each order the customer
-- has placed, as well as the total cumulative order price for Oct 2nd, 2016.
SELECT
    cu.name
  , oi.quantity * oi.unit_price AS order_price
  , SUM(oi.quantity * oi.unit_price)
      OVER(
        ORDER BY
            cu.name
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      )                           AS cumulative_price
FROM
         ot.orders od
    INNER JOIN ot.customers   cu
    ON od.customer_id = cu.customer_id
    INNER JOIN ot.order_items oi
    ON oi.order_id = od.order_id
    INNER JOIN ot.products    pr
    ON pr.product_id = od.order_id
WHERE
    od.order_date = '02_OCT_2016';

-- Question 4. Select the first name, last name, and hire date of the employees
-- that come in third place in experience of the company.
WITH employee_hire_dates AS (
    SELECT
        first_name
      , last_name
      , hire_date
      , DENSE_RANK()
          OVER(
            ORDER BY
                hire_date
          ) AS date_rank
    FROM
        ot.employees
)
SELECT
    first_name
  , last_name
  , hire_date
FROM
    employee_hire_dates
WHERE
    date_rank = 3;
    
WITH employee_hire_dates AS (
    SELECT
        first_name
      , last_name
      , hire_date
      , NTH_VALUE(hire_date, 3) FROM FIRST
          OVER(ORDER BY hire_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS date_rank
    FROM
        ot.employees
)
SELECT
    first_name
  , last_name
  , hire_date
  , date_rank
FROM
    employee_hire_dates;

-- Question 5. Select the product ID, product name, and the list price of the 
-- second more expensive product.
WITH product_prices AS (
    SELECT
        product_id
      , product_name
      , list_price
      , RANK()
          OVER(
            ORDER BY
                list_price DESC
          ) AS price_rank
    FROM
        ot.products
)
SELECT
    product_id
  , product_name
  , list_price
FROM
    product_prices
WHERE
    price_rank = 2;
    
SPOOL OFF;
SET ECHO OFF;