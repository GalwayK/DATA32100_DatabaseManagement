SELECT
    job_title AS "High Earning Job"
FROM
    hr.jobs
WHERE 
    max_salary = 16000;
    
SELECT 
    cust_first_name || ' ' || cust_last_name as "cust_name", credit_limit
FROM 
    oe.customers
WHERE
    lower(marital_status) = 'married' AND credit_limit = 5000;
    
    
SELECT
    substr('Kyle Galway', 6, 3)
FROM 
    dual;
    
SELECT 
    sysdate
FROM
    dual;
    
--    EXERCISE 1. a) Find Admit Banda's salary 

SELECT
    first_name || ' ' || last_name as "Employee Name", salary
FROM 
    hr.employees
WHERE 
    upper(concat(first_name, last_name)) = 'AMITBANDA';  

-- EXERCISE 1. B) Find he addresses of the company locations in Tokyo 

SELECT 
    street_address
FROM 
    hr.locations 
WHERE 
    upper(city) = 'TOKYO';
    
-- EXERCISE 1. c) Find difference between min and max salary of present.

SELECT
    min_salary - max_salary as "Salary Difference"
FROM 
    hr.jobs
WHERE 
    lower(job_title) = 'president';
    
-- EXERCISE 2 Show how many promotion categories there are in SH. 

SELECT count(distinct(promo_category_id)) as "Promo Category #" from sh.promotions;

-- EXERCISE 3. Find departments located in Toronto. 

-- IMPLICIT JOIN 

SELECT 
    *
FROM 
    hr.departments de, hr.locations lo
WHERE 
    de.location_id = lo.location_id 
AND 
    lower(lo.city) = 'toronto';
    
-- EXPLICIT JOIN 

SELECT
    * 
FROM 
    hr.departments de 
INNER JOIN 
    hr.locations lo 
ON 
    de.location_id = lo.location_id
WHERE 
    lower(city) = 'toronto'
ORDER BY 
    city
DESC;

-- NATURAL JOIN 

select 
    * 
from 
    hr.departments de
NATURAL JOIN 
    hr.locations lo
WHERE 
    lower(city) = 'toronto'
ORDER BY 
    city
DESC;

-- EQUIJOIN 

select 
    * 
from 
    hr.departments de
JOIN
    hr.locations lo 
USING 
    (location_id)
WHERE 
    lower(city) = 'toronto'
ORDER BY 
    city 
DESC;

-- EXERCISE 3 Show how many products with id 14 are under development. 

SELECT 
    * 
FROM 
    oe.product_information 
WHERE 
    category_id = 14 
AND 
    lower(product_status) = 'under development';
    
-- EXERCISE 5. Show the region in which all departments are located. 

-- IMPLICIT JOIN 
SELECT 
    department_name, region_name
FROM 
    hr.departments de, hr.locations lo, hr.regions re, hr.countries co
WHERE 
    de.location_id = lo.location_id
AND 
    lo.country_id = co.country_id
AND 
    co.region_id = re.region_id
ORDER BY 
    department_name
DESC;

-- EXPLICIT JOIN 
SELECT 
    department_name, region_name
FROM 
    hr.departments de
INNER JOIN 
    hr.locations lo 
ON 
    lo.location_id = de.location_id 
INNER JOIN 
    hr.countries co 
ON 
    lo.country_id = co.country_id
INNER JOIN 
    hr.regions re 
ON 
    re.region_id = co.region_id
ORDER BY 
    department_name 
DESC;

-- NATURAL JOIN 
SELECT 
    department_name, region_name
FROM 
    hr.departments de
NATURAL JOIN 
    hr.locations lo 
NATURAL JOIN 
    hr.countries co 
NATURAL JOIN 
    hr.regions re 
ORDER BY 
    department_name 
DESC;

-- EQUIJOINS 
SELECT 
    department_name, region_name 
FROM 
    hr.departments de 
INNER JOIN 
    hr.locations lo 
USING 
    (location_id)
INNER JOIN 
    hr.countries co 
USING 
    (country_id)
INNER JOIN 
    hr.regions re
USING 
    (region_id)
ORDER BY 
    department_name 
DESC;

-- FIND ALL EMPLOYEES AND THEIR APARTMENTS 
-- IMPLICIT JOIN 
SELECT 
    first_name || ' ' || last_name as "Employee_Name", department_name
FROM 
    hr.departments de, hr.employees em
WHERE 
    de.department_id = em.department_id
AND 
    em.department_id IS NOT NULL;
    
-- EXPLICIT JOIN 
SELECT 
    first_name || ' ' || last_name as "Employee_Name", department_name
FROM 
    hr.departments de
INNER JOIN 
    hr.employees em 
ON 
    de.department_id = em.department_id
ORDER BY 
    'Employee Name'
DESC;

-- EQUIJOIN
SELECT 
    first_name || ' ' || last_name as "Employee_Name", department_name
FROM 
    hr.departments de
INNER JOIN 
    hr.employees em
USING 
    (department_id)
ORDER BY 
    'Employee Name'
DESC;