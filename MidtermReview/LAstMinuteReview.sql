SET SERVEROUTPUT ON;

SELECT * FROM midterm_employees;

SELECT * FROM employees_log;

CREATE OR REPLACE TRIGGER 
    log_employee_inserts
BEFORE INSERT ON 
    midterm_employees 
FOR EACH ROW 
BEGIN
    IF :NEW.first_name != UPPER(:NEW.first_name) THEN 
        :NEW.first_name := UPPER(:NEW.first_name);
    END IF;
    IF :NEW.last_name != UPPER(:NEW.last_name) THEN 
        :NEW.last_name := UPPER(:NEW.last_name);
    END IF;
    
    IF INSERTING THEN 
        INSERT INTO employees_log VALUES 
            ('INSERT', USER, SYSDATE, :NEW.employee_id,
                :NEW.FIRST_NAME, :NEW.LAST_NAME, :NEW.SALARY, :NEW.MANAGER_ID);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER 
    log_update_delete_employee
BEFORE UPDATE OR DELETE ON 
    midterm_employees
FOR EACH ROW 
DECLARE 
    v_operation VARCHAR(255) := 'DELETE';
BEGIN
    IF UPDATING THEN 
        v_operation := 'UPDATE';
        IF :NEW.first_name != UPPER(:NEW.first_name) THEN 
            :NEW.first_name := UPPER(:NEW.first_name);
        END IF;
        IF :NEW.last_name != UPPER(:NEW.last_name) THEN 
            :NEW.last_name := UPPER(:NEW.last_name);
        END IF;
    END IF;
    
    INSERT INTO employees_log VALUES (v_operation, USER, SYSDATE, :OLD.employee_id, 
        :OLD.first_name, :old.last_name, :OLD.salary, :OLD.manager_id);
END;
/

CREATE OR REPLACE PROCEDURE 
    delete_midterm_employees
AS 
BEGIN 
    DELETE FROM 
        midterm_employees 
    WHERE employee_id = 103;
END;
/

CREATE OR REPLACE PROCEDURE 
    update_midterm_employees 
AS 
BEGIN 
    UPDATE midterm_employees 
    SET first_name = 'Kyle', last_name = 'Galway'
    WHERE employee_id = 103;
End;
/

CREATE OR REPLACE PROCEDURE 
    insert_midterm_employees
AS 
    v_employee hr.employees%ROWTYPE;
BEGIN 
    SELECT 
        * 
    INTO 
        v_employee 
    FROM 
        hr.employees 
    WHERE 
        employee_id = 103;
    COMMIT;
        
    INSERT INTO midterm_employees VALUES 
        (v_employee.employee_id, v_employee.first_name, v_employee.last_name, 
        v_employee.email, v_employee.phone_number, v_employee.hire_date, 
        v_employee.job_id, v_employee.salary, v_employee.commission_pct, 
        v_employee.manager_id, v_employee.department_id);
    COMMIT;
END;
/

BEGIN 
--    insert_midterm_employees();
--    update_midterm_employees();
    delete_midterm_employees();
    COMMIT;
END;
/

CREATE OR REPLACE FUNCTION
    get_first_employee
RETURN hr.employees%ROWTYPE
AS
    v_employee hr.employees%ROWTYPE;
BEGIN 
    select 
        * 
    INTO 
        v_employee 
    FROM 
        hr.employees
    WHERE 
        hire_date = (select min(hire_date) from hr.employees);
    RETURN v_employee;
END;
/

DECLARE 
    CURSOR category_averages IS 
        SELECT 
            prod_category as fuckoff, 
            round(avg(prod_list_price), 2) as average
        FROM 
            sh.products
        GROUP BY   
            prod_category;
BEGIN
    FOR category_average IN category_averages LOOP
        DBMS_OUTPUT.PUT_LINE('Prod Category: ' || category_average.fuckoff || CHR(32) 
            ||'Category Average: '|| category_average.average);
    END LOOP; 

END;
/

DECLARE    
    TYPE students is RECORD 
    (first_name VARCHAR2(20), 
    last_name VARCHAR2(20),
    grade NUMBER);
    TYPE arr_students is VARRAY(4) of students;
    v_arr_students arr_students := arr_students();
BEGIN
    DBMS_OUTPUT.PUT_LINE('The worst language!');
    
    FOR i IN 1..v_arr_students.LIMIT LOOP 
        v_arr_students.extend();
        v_arr_students(i).first_name := 'Kyle';
        v_arr_students(i).last_name := 'Galway';
        v_arr_students(i).grade := 4.0;
    END LOOP;
    
     FOR i IN 1..v_arr_students.COUNT LOOP 
       DBMS_OUTPUT.PUT_LINE(chr(10) || 'Student ' || i);
       DBMS_OUTPUT.PUT_LINE('First Name: ' || v_arr_students(i).first_name);
       DBMS_OUTPUT.PUT_LINE('First Name: ' || v_arr_students(i).last_name);
       DBMS_OUTPUT.PUT_LINE('First Name: ' || v_arr_students(i).grade);
    END LOOP;
END;
/



SELECT 
    prod_category, 
    round(avg(prod_list_price), 2)
FROM 
    sh.products
GROUP BY   
    prod_category;













SELECT 
    employee_id, 
    first_name, 
    last_name, 
    salary, 
    CASE  
        WHEN salary <= 6000 THEN 
            'Low Salary'
        WHEN salary > 6000 AND salary <= 10000 THEN 
            'Medium Salary'
        WHEN salary > 10000 THEN 
            'High Salary'
        END AS salary_range
FROM 
    hr.employees;
    
    // COMMON TABLE EXPRESSION
WITH country_location_count AS(
SELECT 
    c.country_id, 
    count(l.location_id) as location_count
FROM 
    hr.locations l
INNER JOIN  
    hr.countries c
ON
    l.country_id = c.country_id
INNER JOIN 
    hr.regions r 
ON 
    c.region_id = r.region_id
WHERE c.COUNTRY_ID NOT IN ('CA')
GROUP BY 
    (c.country_id)
ORDER BY 
    location_count 
DESC
)
SELECT * FROM country_location_count
WHERE location_count > 1;
    
    SELECT * from hr.countries;
    
    SELECT * from hr.locations;
    
SELECT 
    null, null
FROM hr.regions
UNION ALL
SELECT 
    region_id, null
FROM hr.regions
UNION ALL 
select 
    null, region_name
FROM 
    hr.regions
UNION ALL
SELECT 
    region_id, region_name
FROM 
    hr.regions;
    
SELECT
    region_id, region_name
FROM 
    hr.regions
GROUP BY CUBE (region_id, region_name);

SELECT 
    j.job_title, 
    d.department_name, 
    r.region_name, 
    c.country_name
    , round(avg(e.salary), 2)
FROM 
    hr.departments d
INNER JOIN 
    hr.employees e
ON  
    e.department_id = d.department_id
INNER JOIN 
    hr.jobs j 
ON 
    e.job_id = j.job_id
INNER JOIN 
    hr.locations l
ON 
    d.location_id = l.location_id
INNER JOIN 
    hr.countries c
ON 
    l.country_id = c.country_id
INNER JOIN 
    hr.regions r
ON 
    r.region_id = c.region_id
GROUP BY GROUPING SETS
    (j.job_title, (d.department_name), (r.region_name), (c.country_name));

SELECT 
    d.department_name, 
    r.region_name, 
    c.country_name
FROM 
    hr.departments d
INNER JOIN 
    hr.locations l
ON 
    d.location_id = l.location_id
INNER JOIN 
    hr.regions r
ON 
    l.region_id = r.region_id
INNER JOIN 
    hr.countries c
ON 
    r.country_id = c.country_id;
    
CREATE OR REPLACE VIEW customer_sales AS 
SELECT 
    cust_first_name,
    cust_last_name, 
    SUM(quantity_sold) as total_quantity_purchased
FROM 
    sh.customers c 
INNER JOIN 
    sh.sales s
ON 
    c.cust_id = s.cust_id
WHERE 
    UPPER(c.country_id) = 'CANADA' 
GROUP BY 
    cust_first_name, cust_last_name
HAVING 
    sum(quantity_sold) > 5;
    
SELECT * FROM customer_sales;

SELECT 
    first_name, 
    last_name, 
    employee_id, 
    manager_id
FROM 
    hr.employees
WHERE 
    level < 5
START WITH 
    UPPER(first_name || ' ' || last_name) = 'LEX DE HAAN'
CONNECT BY PRIOR 
    employee_id = manager_id;

WITH sales_ranks AS (
SELECT 
    pi.product_id, 
    pi.product_name, 
    unit_price,
    DENSE_RANK() OVER(
        ORDER BY unit_price) as sales_rank
FROM 
    oe.product_information pi 
INNER JOin 
    oe.order_items oi
ON 
    pi.product_id = oi.product_id)
SELECT  
    * 
FROM sales_ranks
WHERE sales_rank = 1;
    
WITH sales_times As (
SELECT  
    prod_id, 
    time_id, 
    row_number() OVER (
        order by time_id DESC) as date_rank
FROM 
    sh.sales)
SELECT 
    * 
FROM 
    sales_times 
WHERE date_rank <= 500;
    


    SELECT * from hr.departments;
    
    SELECT * FROM HR.REGIONS;
    
    select * from hr.countries;
    
     select * from hr.jobs;
     
     select * from hr.locations;
     
     select * from hr.employees;