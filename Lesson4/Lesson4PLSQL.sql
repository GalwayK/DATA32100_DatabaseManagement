SET VER OFF
ACCEPT p_id PROMPT 'Enter Employee ID: '

SELECT 
    *
FROM 
    hr.employees
WHERE 
    employee_id = &p_id;
    
SET VER OFF;
ACCEPT p_cust_id PROMPT 'Enter the customer ID';

SELECT 
    cust_last_name, 
    cust_first_name, 
    credit_limit
FROM 
    oe.customers
WHERE 
    customer_id = &p_cust_id;

SET serveroutput ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello');
END;
/

-- Part One: PL/SQL Variables
-- Keywords: Substitution variable, Bind variables, PL variables
-- Substitution Variables: Used by SqlPlus or PL block to access values. 
-- Substituion Variables start with p_ and are retrieved with &.
-- Bind Variables: Used by SqlPlus or PL block as global variables. 
-- Bind variables start with g_ and are retrieved with :.
-- PL Variables: Used by PL block only as local variables. 
-- PL Variables start with v_. 

ACCEPT p_id PROMPT 'Enter region ID: '

SELECT 
    country_id, 
    country_name,
    count(*)
FROM 
    hr.countries 
WHERE 
    region_id = &p_id
GROUP BY 
    country_id, country_name;
    
VARIABLE g_customer_name VARCHAR2(255)
BEGIN 
    :g_customer_name := '&p_name';
END; 
/
print g_customer_name 


SET SERVEROUTPUT ON 

DECLARE 
    v_name VARCHAR2(10);
BEGIN 
    v_name := '&p_name';
    DBMS_OUTPUT.PUT_LINE('Your name is ' || v_name);
END; 
/

SET serveroutput ON 
DECLARE    
    v_numOne NUMBER(10, 5) := &p_numOne;
    v_numTwo NUMBER(10, 5) := &p_numTwo;
    v_numAverage NUMBER(10, 5);
BEGIN 
    v_numAverage := (v_numOne + v_numTwo) / 2;
    dbms_output.put_line('The average was ' || v_numAverage);
END;
/

SET SERVEROUTPUT ON;
SET VER OFF;
ACCEPT p_id PROMPT 'Enter employee id: ';
    
DECLARE
    v_first_name 	hr.employees.first_name%TYPE;
    v_last_name 	hr.employees.last_name%TYPE;
    v_email 		hr.employees.email%TYPE;
    v_phone 		hr.employees.phone_number%TYPE;
    v_salary		hr.employees.salary%TYPE;
BEGIN
    SELECT first_name, last_name, email, phone_number, salary
    INTO v_first_name, v_last_name, v_email, v_phone, v_salary
    FROM hr.employees
    WHERE employee_id = &p_id;
    
    DBMS_OUTPUT.PUT_LINE(v_first_name || CHR(32) || v_last_name ||                
                        CHR(10) || 'Email: ' || v_email ||         
                        CHR(10) || 'Phone No: ' || v_phone || 
                        CHR(10) || 'Salary: ' || v_salary);
END;
/

WITH 
    employee_hire_dates 
AS (SELECT
    first_name
  , last_name
  , hire_date
  , DENSE_RANK()
      OVER(
        ORDER BY
            hire_date
      ) AS hire_date_rank
FROM
    hr.employees)
SELECT 
    * 
FROM 
    employee_hire_dates 
WHERE 
    hire_date_rank = 1;