-- Part One: Common Table Expressions also known as with queries)
-- Keywords: WITH, AS

WITH managers AS (
SELECT 
    employee_id, 
    first_name, 
    last_name
FROM 
    hr.employees 
)
SELECT 
    em.employee_id, 
    em.first_name, 
    em.last_name, 
    ma.employee_id as manager_id, 
    ma.first_name, 
    ma.last_name 
FROM 
    hr.employees em 
INNER JOIN 
    managers ma 
ON 
    ma.employee_id = em.manager_id
ORDER BY 
    em.employee_id;
    
SELECT 
    first_name, 
    last_name, 
    employee_id, 
    manager_id
FROM 
    hr.employees 
WHERE 
    level NOT IN (1)
START WITH 
    lower(first_name || last_name) = 'stevenking'
CONNECT BY PRIOR 
    employee_id = manager_id;
    
-- Part Two: Hierarchical Queries 
-- Keywords: START WITH, CONNECT BY, LEVEL
WITH john_manager AS 
(
SELECT 
    employee_id, first_name, last_name, level
FROM 
    hr.employees 
START WITH
    upper(first_name || last_name) = 'JOHNCHEN'
CONNECT BY PRIOR 
    manager_id = employee_id
)
SELECT 
    * 
FROM 
    john_manager;
    
SELECT 
    first_name, 
    last_name, 
    employee_id,
    manager_id, 
    level
FROM
    hr.employees 
START WITH
    lower(first_name || ' ' || last_name) = 'lex de haan'
CONNECT BY PRIOR 
    employee_id = manager_id;
    
-- Part Three: Aggregate functions in analytical form. 
-- Keywords: OVER, PARTITION BY, ROWS BETWEEN, RANGE BETWEEN, UNBOUNDED, 
-- PRECEEDING, CURRENT ROW, FOLLOWING

SELECT 
    employee_id, 
    salary,
    department_id, 
    count(*) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS dept_count
FROM 
    hr.employees
WHERE 
    department_id IN (20, 30)
ORDER BY 
    department_id;
    
SELECT 
    employee_id, 
    department_id, 
    salary, 
    sum(salary) OVER(
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_salary
FROM
    hr.employees
WHERE 
    department_id NOT IN (10, 20);
    
SELECT 
    employee_id, 
    department_id, 
    salary, 
    round(avg(salary) OVER (
        PARTITION BY department_id), 2) as department_salary_average,
    round(salary - avg(salary) OVER (
        PARTITION BY department_id), 2) as salary_difference_from_average
FROM 
    hr.employees 
WHERE 
    department_id NOT IN (10, 20);
    
-- Part Four: Analytic Functions 
-- Keywords: LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE, RANK, DENSE_RANK, 
-- ROW_NUMBER, RATIO_TO_REPORT, PERCENT_RANK, NTILE
-- Fact 1: ROW_NUMBER, RANK, and DENSE_RANK require an ORDER BY clause.
-- Fact 2: ROW_NUMBER, RANK, AND DENSE_RANK do not support window frame clauses.
SELECT 
    department_id, 
    last_name, 
    salary,
    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC) as salary_rank, 
    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
            ORDER BY salary DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
            as highest_salary, 
    NTH_VALUE(salary, 2) FROM FIRST OVER(
        PARTITION BY department_id) as second_highest_salary,
    LAST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
        as lowest_salary, 
    NTH_VALUE(salary, 2) FROM LAST OVER(
        PARTITION BY department_id) as second_lowest_salary
FROM 
    hr.employees 
WHERE 
    department_id NOT IN (10, 20)
ORDER BY 
    department_id, salary_rank, last_name;
    
SELECT 
    department_id, 
    employee_id, 
    first_name, 
    last_name, 
    salary, 
    ROW_NUMBER() OVER (
        PARTITION BY department_id
        ORDER BY salary) as row_number_salary,
    RANK() OVER(
        PARTITION BY department_id 
        ORDER BY salary) as rank_salary, 
    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary) as dense_rank_salary
FROM 
    hr.employees
WHERE 
    department_id != 10;
