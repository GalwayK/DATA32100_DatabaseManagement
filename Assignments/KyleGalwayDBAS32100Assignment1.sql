set sqlformat ansiconsole;
SET PAGESIZE 200;
SET ECHO ON;
SPOOL KyleGalwayDBAS32100Assignment1.txt;
-- KyleGalwayDBAS32100Assignment1.sql
-- Kyle Galway 
-- s6_galwayk
-- Question 1. Create a view called customer_contacts that would contain  
-- the sales person's full name, the customer name, and their contacts.
-- Question 2. Write a statement that uses the view created in the previous 
-- question to show the information for Minnesota customers.
-- Question 3. Using an outer join query, show the names and addresses of the 
-- customers from Minnestota that have never placed any orders.
-- Question 4. Show the product name, total amount, the average amount (rounded 
-- to 2 floating points), as well as the number o orders that are placed for 
-- products that contain the World, "Kingston" in their product name. The names 
-- for each individual product name must be shown separately. 
-- Question 5. The salesperson performances are evaluated into categeories as 
-- follows: Low for less than 7 orders, Medium for between 7 and 10 order, and 
-- high for greater than 10 orders. Display the first name, lastname, number of 
-- sales, and category of performance of the salespeople. 
-- Question 6. Using SET operations, show the location ID, address, postal code,
-- and state of those locations from region 2 which do not have warehouses.
-- Question 7. Using advanced grouping, find out the number of orders for 
-- each customer that have a credit limit of 600. Show the customer name, credit 
-- limit, and subcounts for each customer name. 

-- Question 1.
CREATE OR REPLACE view 
    customer_contacts 
AS SELECT DISTINCT
    em.first_name || ' ' || em.last_name as "employee_name",
    cu.name as "customer_name", 
    cu.address as "customer_address",
    co.first_name || ' ' || co.last_name as "contact_name", 
    co.phone as "contact_phone"
FROM 
    ot.customers cu
INNER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
INNER JOIN 
    ot.employees em 
ON 
    em.employee_id = od.salesman_id
INNER JOIN 
    ot.contacts co 
ON
    co.customer_id = cu.customer_id;

SELECT
    *
FROM
    customer_contacts;

-- Question 2.
SELECT 
    *
FROM 
    customer_contacts cc
WHERE 
    upper(substr("customer_address", -2)) = 'MN';
    
-- Question 3. a) With aggregate grouping
SELECT
    cu.name, 
    cu.address
FROM 
    ot.customers cu
LEFT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
WHERE 
    upper(substr(address, -2)) = 'MN'
HAVING 
    count(od.customer_id) = 0
GROUP BY 
    (cu.name, cu.address)
ORDER BY 
    cu.name;
    
-- Question 3. b) With MINUS set operation
SELECT 
    cu.name as "name", 
    cu.address as "address"
FROM 
    ot.customers cu
LEFT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
WHERE 
    upper(substr(cu.address, -2)) = 'MN'
MINUS SELECT 
    cu.name, 
    cu.address
FROM 
    ot.customers cu
RIGHT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
ORDER BY
"name";

-- Question 4. 
SELECT
    pr.product_name
  , SUM(pr.list_price * oi.quantity) AS "Total Value Sold"
  , round(AVG(oi.unit_price)
          , 2)                             AS "Average Sold Price"
  , SUM(oi.quantity)                 AS "Number of Products Sold"
  , COUNT(oi.product_id)             AS "Number of Orders Placed"
FROM
         ot.products pr
    INNER JOIN ot.order_items oi
    ON oi.product_id = pr.product_id
WHERE
    lower(pr.product_name) LIKE '%kingston%'
GROUP BY
    pr.product_name;
    
-- Question 5. 
SELECT
    em.first_name
    || ' '
       || em.last_name AS "Employee Name"
  , em.employee_id
  , CASE
        WHEN COUNT(od.salesman_id) < 7              THEN
            'Low'
        WHEN COUNT(od.salesman_id) BETWEEN 7 AND 10 THEN
            'Medium'
        WHEN COUNT(od.salesman_id) > 10             THEN
            'High'
      END             AS "Performance Level"
FROM
         ot.employees em
    INNER JOIN ot.orders od
    ON em.employee_id = od.salesman_id
GROUP BY (
    em.first_name
  , em.last_name
  , em.employee_id
)
ORDER BY
    COUNT(od.salesman_id);

-- Question 6.
SELECT
    location_id
  , address
  , postal_code
  , state
FROM
         ot.locations
    INNER JOIN ot.countries
    USING ( country_id )
    INNER JOIN ot.regions
    USING ( region_id )
WHERE
    region_id = 2
MINUS
SELECT
    location_id
  , address
  , postal_code
  , state
FROM
         ot.locations
    INNER JOIN ot.countries
    USING ( country_id )
    INNER JOIN ot.regions
    USING ( region_id )
    INNER JOIN ot.warehouses
    USING ( location_id )
WHERE
    region_id = 2;

-- Question 7.
SELECT
    cu.name
  , cu.credit_limit
  , COUNT(od.customer_id) AS "NUMBER_OF_ORDERS"
FROM
         ot.customers cu
    INNER JOIN ot.orders od
    ON od.customer_id = cu.customer_id
WHERE
    cu.credit_limit = 600
GROUP BY
    ROLLUP(cu.name
         , cu.credit_limit)
HAVING
    GROUPING_ID(cu.name, cu.credit_limit) != 1;

SPOOL OFF;
SET ECHO OFF;