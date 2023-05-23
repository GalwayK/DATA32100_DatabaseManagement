-- QUESTION 1. Find salary categories. 

SELECT
    first_name
    || ' '
    || last_name AS "Name",
    salary,
    CASE
        WHEN salary < 6000                 THEN
            'Low Salary'
        WHEN salary BETWEEN 6000 AND 10000 THEN
            'Medium Salary'
        ELSE
            'High Salary'
    END          AS "Salary_Category"
FROM
    hr.employees
ORDER BY
    salary DESC;

-- QUESTION 2. Show a list of employees and all jobs they have had. 

SELECT
    first_name,
    last_name,
    employee_id,
    jo.job_id,
    job_title
FROM
    hr.employees em
    INNER JOIN hr.jobs jo ON em.job_id = jo.job_id
UNION
SELECT
    first_name,
    last_name,
    em.employee_id,
    em.job_id,
    jo.job_title
FROM
         hr.job_history jh
    INNER JOIN hr.jobs      jo ON jo.job_id = jh.job_id
    INNER JOIN hr.employees em ON em.employee_id = jh.employee_id;

SELECT
    *
FROM
    hr.job_history;
    
SELECT
    first_name,
    last_name,
    employee_id,
    de.department_id,
    de.department_name
FROM 
    hr.employees em 
LEFT JOIN 
    hr.departments de
ON 
    em.department_id = de.department_id
ORDER BY 
    employee_id
DESC;

SELECT
    first_name,
    last_name,
    em.employee_id,
    jh.department_id,
    de.department_name
FROM 
    hr.employees em 
LEFT JOIN 
    hr.departments de 
on 
    de.department_id = em.department_id
INNER JOIN 
    hr.job_history jh 
ON 
    jh.employee_id = em.employee_id
    
MINUS 

SELECT
    first_name,
    last_name,
    employee_id,
    em.department_id,
    de.department_name
FROM 
    hr.employees em 
LEFT JOIN 
    hr.departments de
ON 
    em.department_id = de.department_id
ORDER BY 
    employee_id;

SELECT * FROM hr.job_history;

-- How many employees from eac department have a salary of more than 12000

SELECT 
   de.department_id, de.department_name, count(salary) as "high_paid"
FROM 
    hr.departments de
INNER JOIN 
    hr.employees em
ON 
    de.department_id = em.department_id
WHERE 
    salary > 12000
GROUP BY 
    (de.department_id, de.department_name)
HAVING 
    count(salary) > 1
ORDER BY 
    "high_paid";
    
SELECT 
    country_name, country_id, count(location_id)
FROM 
    hr.countries co
INNER JOIN 
    hr.locations lo 
USING 
    (country_id)
GROUP BY 
    (country_name, country_id)
HAVING 
    count(location_id) > 1;
    
SELECT
    region_id,
    region_name
FROM
    hr.regions;
    
SELECT 
    region_id, region_name
FROM 
    hr.regions
UNION 

SELECT 
    region_id, null 
FROM 
    hr.regions 
    
UNION 

SELECT 
    null, region_name 
FROM 
    hr.regions

UNION 
    
SELECT
    NULL,
    NULL 
FROM
    hr.regions;
    
SELECT
    department_name,
    job_title,
    AVG(salary), 
    CASE grouping(department_name)
        WHEN 1 then 'No' 
        ELSE 'Yes'
    END AS "Department Subtotal ?",
    CASE grouping(job_title)
        WHEN 1 THEN 'No'
        ELSE 'Yes'
    END AS "Job Subtotal ?",
    CASE 
        WHEN 
            grouping(department_name) = 1 AND grouping(job_title) = 1 
        THEN 
            'Yes'
        ELSE 
            'No'
        END AS "Overall Total?"
FROM 
    hr.employees em 
INNER JOIN 
    hr.jobs jo 
ON 
    em.job_id = jo.job_id
INNER JOIN 
    hr.departments de
ON 
    em.department_id = de.department_id
GROUP BY CUBE (
    department_name, job_title)
ORDER BY 
    department_name, job_title;
    
    
SELECT 
    de.department_name, co.country_name, re.region_id, round(avg(em.salary), 2)
FROM 
    hr.employees em 
INNER JOIN 
    hr.departments de 
ON 
    em.department_id = de.department_id
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
    co.region_id = re.region_id
GROUP BY GROUPING SETS (de.department_name, co.country_name, re.region_id);

CREATE OR REPLACE VIEW customer_sales_history AS
SELECT 
    cu.cust_first_name, cu.cust_last_name, sum(quantity_sold) as "Quantity_Purchased"
FROM   
    sh.customers cu 
INNER JOIN
    sh.sales sa
ON 
    cu.cust_id = sa.cust_id
GROUP BY 
    cu.cust_first_name, cu.cust_last_name
HAVING 
    sum(quantity_sold) > 5
ORDER BY 
    "Quantity_Purchased";
    
SELECT * FROM customer_sales_history;
    