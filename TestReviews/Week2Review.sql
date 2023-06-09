-- Part One: Case Expressions
-- Keywords: CASE, WHEN, THEN, ELSE, END AS, Simple Case, Searched CASE.
-- Fact 1: Simple CASE functons are used to examine a specific value (switch). 
-- Fact 2: Searched CASE functions are used to examine an expression (if-else).

SELECT 
    prod_id, 
    cust_id, 
    channel_id, 
    CASE channel_id
        WHEN 1 THEN 'channel_one'
        WHEN 2 THEN 'channel_two'
        ELSE 'channel three'
    END AS channel
FROM 
    sh.sales
WHERE 
    ROWNUM < 300;

WITH customer_data AS (
SELECT 
    cust_id, 
    cust_first_name,
    cust_last_name, 
    cust_year_of_birth, 
    CASE 
        WHEN cust_year_of_birth < 1944 THEN 'Silent Generation'
        WHEN cust_year_of_birth <= 1964 THEN 'Baby Boomer'
        WHEN cust_year_of_birth <= 1979 THEN 'Generation X'
        WHEN cust_year_of_birth <= 1994 THEN 'Generation Y'
        ELSE 'Millenial'
    END AS generation
FROM 
    sh.customers
WHERE 
    rownum < 1000)
SELECT 
    cust_id, 
    cust_first_name,
    cust_last_name, 
    cust_year_of_birth, 
    generation
FROM 
    customer_data
ORDER BY 
    cust_last_name;
    
-- Part Two: Set Operations 
-- Keywords: MINUS, INTERSECT, UNION, UNION ALL
-- Fact 1: When using sets, both combined tables must have the same data type 
-- for all combining columns. 
-- Fact 2: Combined columns must have the same number of columns and the column 
-- names are derived from the first SELECT statement in the set. 
-- Fact 3: When using an ORDER BY, it comes after the SET operation.

SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (101, 102, 103);
    
SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (102, 103, 104);

SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id 
IN 
    (101, 102, 103)
UNION SELECT 
    cust_id, cust_first_name, cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id in (102, 103, 104);
    
SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (101, 102, 103)
UNION ALL SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (102, 103, 104);
    
SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id 
IN 
    (101, 102, 103)
UNION SELECT 
    cust_id, cust_first_name, cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id in (102, 103, 104);
    
SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (101, 102, 103)
MINUS SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (102, 103, 104);
    
SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id 
IN 
    (101, 102, 103)
UNION SELECT 
    cust_id, cust_first_name, cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id in (102, 103, 104);
    
SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (102, 103, 104)
MINUS SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (101, 102, 103);
    
SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id 
IN 
    (101, 102, 103)
UNION SELECT 
    cust_id, cust_first_name, cust_last_name
FROM 
    sh.customers 
WHERE 
    cust_id in (102, 103, 104);
    
SELECT 
    cust_id,
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (101, 102, 103)
INTERSECT SELECT 
    cust_id, 
    cust_first_name, 
    cust_last_name
FROM 
    sh.customers
WHERE 
    cust_id IN (102, 103, 104);
    
-- Part Three: Aggregate Functions 
-- Keywords: SUM, MAX, MIN, AVG, HAVING, GROUP BY 
-- Fact 1: We cannot put a field in a GROUP BY clause that is not included in the 
-- SELECT clause.
-- Fact 2: The HAVING clause is used to check a condition after an aggregate 
-- function. It is substantially slower than the WHERE clause, which is used to 
-- check the results of a query before the aggregate function. 
-- Fact 3: HAVING clauses can function as WHERE clauses, but the inverse is not 
-- true. Despite this, a HAVING clause should never be used as a WHERE clause.

SELECT 
    dp.department_id, 
    count(employee_id) as employee_count
FROM 
    hr.employees em 
RIGHT JOIN 
    hr.departments dp 
ON 
    em.department_id = dp.department_id
GROUP BY 
    dp.department_id;

WITH department_employee_count AS (SELECT 
    department_name, 
    count(employee_id) AS number_of_employees
FROM 
    hr.employees em
RIGHT JOIN 
    hr.departments dp
ON 
    em.department_id = dp.department_id
GROUP BY 
    department_name
HAVING 
    count(employee_id) > 0)
SELECT 
    * 
FROM 
    department_employee_count;
    
SELECT 
    dp.department_id, 
    count(employee_id) as employee_count
FROM 
    hr.employees em 
RIGHT JOIN 
    hr.departments dp 
ON 
    em.department_id = dp.department_id
GROUP BY 
    dp.department_id;

WITH department_employee_count AS (SELECT 
    department_name, 
    count(employee_id) AS number_of_employees
FROM 
    hr.employees em
RIGHT JOIN 
    hr.departments dp
ON 
    em.department_id = dp.department_id
GROUP BY 
    department_name)
SELECT 
    * 
FROM 
    department_employee_count
WHERE 
    number_of_employees > 0;
    
-- Part Four: Advanced Grouping 
-- Keywords: ROLLUP, CUBE
-- Fact 1: Rollup will rollup a value in levels as specified in the parameters. 
-- Fact 2: Cube will display all possible subtotal combinations of values.
-- Fact 3: Grouping Sets will group the returning values into sets.
-- Fact 4: Cube is mostly significant when dealing with more than one column.

SELECT 
    department_name, 
    COUNT(employee_id) as employee_count, 
    SUM(salary) as salary_total
FROM 
    hr.employees em 
RIGHT JOIN 
    hr.departments dp 
ON 
    em.department_id = dp.department_id
GROUP BY    
    rollup(department_name)
HAVING 
    count(employee_id) > 0;
    
SELECT 
    region_name, 
    country_name, 
    location_id, 
    count(*) as location_count
FROM 
    hr.regions re
INNER JOIN 
    hr.countries co
ON 
    co.region_id = re.region_id 
INNER JOIN 
    hr.locations lo 
ON 
    lo.country_id = co.country_id
GROUP BY ROLLUP 
    (region_name, country_name, location_id)
ORDER BY 
    1, 2;
    
SELECT 
    department_name, 
    COUNT(employee_id) as employee_count, 
    SUM(salary) as salary_total
FROM 
    hr.employees em 
RIGHT JOIN 
    hr.departments dp 
ON 
    em.department_id = dp.department_id
GROUP BY CUBE 
    (department_name)
HAVING 
    count(employee_id) > 0;
    
SELECT 
    region_name, 
    country_name, 
    location_id, 
    count(location_id)
FROM 
    hr.regions re
INNER JOIN 
    hr.countries co
ON 
    co.region_id = re.region_id 
INNER JOIN 
    hr.locations lo 
ON 
    lo.country_id = co.country_id
GROUP BY CUBE 
    (region_name, 
    country_name, 
    location_id)
ORDER BY 1, 2;
    
-- Part Five: Grouping Functions 
-- Keywords: GROUPING, GROUPING ID, GROUPING SETS
-- Fact 1: Grouping replaces null values with 1 for NULL and 0 for non-NULL.
-- This allows us to return specific groups from advanced groupings.
-- Fact 2: Grouping breaks down the total possible combinations into group IDs. 
-- It allows a simpler syntax to return specific groups from advanced groupings.
-- Fact 3: Grouping ID goes through the GROUPING columns in binary order. 
-- 3 columns will have 2^3=8 combinations from 0 (no null) to 7 (all null).

SELECT region_name, 
    country_name, 
    location_id, 
    COUNT(*) AS locations_count,
       GROUPING(region_name) AS by_region,
       GROUPING(country_name) AS by_country,
       GROUPING(location_id) AS by_location
FROM 
  hr.regions r 
JOIN 
  hr.countries c 
ON 
    r.region_id = c.region_id
JOIN 
  hr.locations l
ON 
    c.country_id = l.country_id
GROUP BY CUBE
    (region_name, country_name, location_id)
HAVING 
    GROUPING(region_name) = 0 
AND 
    GROUPING(country_name) = 0 
AND 
    GROUPING(location_id) = 0
OR 
    GROUPING(region_name) = 1
AND 
    GROUPING(country_name) = 1
AND 
    GROUPING(location_id) = 1
ORDER BY 
    1,2;
    
SELECT region_name, 
    country_name, 
    location_id, 
    COUNT(*) AS locations_count,
       GROUPING(region_name) AS by_region,
       GROUPING(country_name) AS by_country,
       GROUPING(location_id) AS by_location
FROM 
  hr.regions r 
JOIN 
  hr.countries c 
ON 
    r.region_id = c.region_id
JOIN 
  hr.locations l
ON 
    c.country_id = l.country_id
GROUP BY CUBE
    (region_name, country_name, location_id)
HAVING 
    GROUPING_ID(region_name, country_name, location_id)
IN 
    (4, 5, 1)
ORDER BY 
    1,2;
    
SELECT region_name, 
    country_name, 
    location_id, 
    COUNT(*) AS locations_count,
       GROUPING(region_name) AS by_region,
       GROUPING(country_name) AS by_country,
       GROUPING(location_id) AS by_location
FROM 
  hr.regions r 
JOIN 
  hr.countries c 
ON 
    r.region_id = c.region_id
JOIN 
  hr.locations l
ON 
    c.country_id = l.country_id
GROUP BY GROUPING SETS
    ((region_name, country_name, location_id))
ORDER BY 
    1,2;
    
-- Part Six: Views 
-- Keywords: CREATE, OR REPLACE, VIEW AS, WITH, READ ONLY, CHECK OPTION, DROP

CREATE OR REPLACE VIEW 
    canadian_locations
AS SELECT 
    * 
FROM 
    hr.locations
WHERE 
    country_id = 'CA';
    
SELECT
    * 
FROM 
    canadian_locations;
    
CREATE OR REPLACE VIEW 
    department_locations 
AS SELECT 
    c.country_id, 
    c.country_name, 
    d.department_id, 
    d.department_name,
    l.city 
FROM 
    hr.departments d
INNER JOIN 
    hr.locations l
ON 
    d.location_id = l.location_id
INNER JOIN 
    hr.countries c
ON 
    l.country_id = c.country_id;
    
SELECT 
    *
FROM 
    department_locations
WHERE 
    country_id = 'US';