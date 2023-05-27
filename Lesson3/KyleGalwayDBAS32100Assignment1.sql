-- Find name of John Chen's manager 
SELECT
    first_name
    || ' '
    || last_name AS "Manager Name"
FROM
    hr.employees
WHERE
    employee_id = (
        SELECT
            manager_id
        FROM
            hr.employees
        WHERE
            first_name || last_name = 'JohnChen'
    );
    
-- With Self Join 
SELECT
    *
FROM
         hr.employees em
    INNER JOIN hr.employees ma
    ON em.manager_id = ma.employee_id
WHERE
    lower(em.first_name || em.last_name) = 'johnchen';

WITH managers AS (
    SELECT
        first_name
      , last_name
      , employee_id
    FROM
        hr.employees
)
SELECT
    em.first_name
  , em.last_name
  , em.employee_id
  , ma.first_name
  , ma.last_name
FROM
         hr.employees em
    JOIN managers ma
    ON em.manager_id = ma.employee_id;

SELECT
    first_name
  , last_name
  , level
FROM
    hr.employees
START WITH
    first_name || last_name = 'JohnChen'
CONNECT BY
    PRIOR manager_id = employee_id;

SELECT
    employee_id
  , first_name
  , last_name
  , manager_id
  , level
FROM
    hr.employees
START WITH
    first_name
    || ' '
    || last_name = 'Lex De Haan'
CONNECT BY
    PRIOR employee_id = manager_id;

SELECT
    employee_id
  , department_id
  , COUNT(*)
      OVER(PARTITION BY department_id
           ORDER BY
               employee_id ASC
      ) AS department_count
FROM
    hr.employees
WHERE
    department_id IN ( 20, 30 );

SELECT
    prod_id
  , unit_cost
  , MAX(unit_cost)
      OVER() AS "Max Cost"
FROM
    sh.costs
WHERE
    time_id = '29_JAN_00';

SELECT DISTINCT
    prod_id
  , time_id
  , unit_cost
  , MIN(unit_cost)
      OVER(PARTITION BY prod_id) AS "Min Cost of Product"
FROM
    sh.costs
WHERE
    time_id = '29_JAN_00'
ORDER BY
    prod_id;
    
-- Common table expression using select as table 
WITH managers AS (
    SELECT
        employee_id
      , first_name
      , last_name
    FROM
        hr.employees
)
SELECT
    m.first_name
  , m.last_name
FROM
         hr.employees e
    JOIN managers m
    ON e.manager_id = m.employee_id
WHERE
    lower(e.first_name || e.last_name) = 'johnchen';

-- Hierarchal queries 
SELECT
    first_name
  , last_name
  , level
FROM
    hr.employees e
START WITH
    lower(first_name || last_name) = 'johnchen'
CONNECT BY
    PRIOR manager_id = employee_id;

SELECT
    employee_id
  , department_id
  , COUNT(department_id)
      OVER(PARTITION BY department_id) AS "Department Count"
FROM
    hr.employees
WHERE
    department_id IN ( 20, 30 );

SELECT
    p.prod_name
  , p.prod_id
  , c.unit_cost
  , to_char(c.time_id, 'DD-MON-YY HH:MM::SS')
  , round(c.unit_cost * 100 / SUM(c.unit_cost)
    OVER(
        ORDER BY time_id NULLS LAST
    RANGE BETWEEN INTERVAL '5' DAY PRECEDING AND CURRENT ROW
    ), 2) as "Unit Cost Percent"
FROM
         sh.costs c
    INNER JOIN sh.products p
    ON c.prod_id = p.prod_id;
    
SELECT 
    s.prod_id, 
    p.prod_name, 
    s.unit_cost, 
    s.time_id,
    sum(s.unit_cost)
    OVER 
    (
        PARTITION BY s.time_id
        ORDER BY p.prod_name
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as "SUM"
FROM 
    sh.products p
INNER JOIN 
    sh.costs s
ON 
    p.prod_id = s.prod_id;
    
WITH salaries AS (SELECT 
    department_id, 
    last_name, 
    salary, 
    DENSE_RANK()
        OVER (PARTITION BY 
            department_id
        ORDER BY 
            salary 
        DESC) AS salary_rank
FROM    
    hr.employees 
WHERE 
    department_id = 60
ORDER BY 
    salary_rank, 
    last_name
)
SELECT 
    * 
FROM 
    salaries;
    
WITH product_ranks AS (SELECT DISTINCT
    c.prod_id,
    p.prod_name,
    c.unit_price, 
    DENSE_RANK()
    OVER(
    partition by c.prod_id 
    order by c.unit_price) as product_rank
FROM 
    sh.costs c
INNER JOIN 
    sh.products p
ON 
    c.prod_id = p.prod_id)
SELECT 
    * 
FROM 
    product_ranks
WHERE 
    product_rank <= 5
ORDER BY 
    product_ranks.prod_id, product_ranks.product_rank;
    
WITH recent_transactions AS (SELECT 
    c.prod_id, 
    p.prod_name, 
    c.time_id,
    row_number() OVER (
        PARTITION BY time_id
        ORDER BY time_id DESC ) 
    AS row_order
FROM 
    sh.costs c
INNER JOIN 
    sh.products p 
ON 
    p.prod_id = c.prod_id
)
SELECT 
    * 
FROM 
    recent_transactions
WHERE
    row_order <= 500;
    
SELECT
    first_name, 
    last_name,
    employee_id, 
    hire_date,
    department_id,
    floor((sysdate - hire_date) / 365) as years_experienced,
    floor((hire_date - first_value(hire_date)
        OVER 
            (PARTITION BY department_id 
            ORDER BY hire_date)) / 365) 
        AS difference_from_max_experience
FROM 
    hr.employees em
WHERE 
    department_id IS NOT NULL
ORDER BY 
    department_id, years_experienced
DESC;