accept subId prompt 'Enter region ID: '

SELECT 
    *
FROM 
    hr.countries 
WHERE 
    region_id = '&subId';
    
HELP INDEX;

VARIABLE bindName varchar2(30)
BEGIN 
    :bindName := '&gloName';
END;
/
SELECT 
    * 
FROM 
    oe.customers 
WHERE 
    cust_first_name = :bindName;

VARIABLE bindCreditLimit varchar2(30)
BEGIN 
    :bindCreditLimit := '&subCreditLimit';
END; 
/ 
SELECT 
    customer_id, 
    cust_first_name, 
    cust_last_name, 
    credit_limit
FROM 
    oe.customers 
WHERE 
    credit_limit = &bindCreditLimit;
    
SET VER OFF 
accept subCreditLimit prompt 'Center credit limit: '
SELECT 
    customer_id, 
    cust_first_name, 
    cust_last_name, 
    credit_limit
FROM 
    oe.customers 
WHERE 
    credit_limit = &subCreditLimit;
    
SET ver OFF
SET serveroutput ON 
ACCEPT p_name PROMPT 'Please enter your name: ';

DECLARE
    v_name varchar2(10);
BEGIN 
    v_name := '&p_name';
    DBMS_OUTPUT.PUT_LINE('Your name is :' || CHR(9) || v_name);
END;

SET serveroutput ON 
DECLARE 
    v_number NUMBER;
BEGIN 
    v_number := 10;
    DECLARE 
        v_number NUMBER;
    BEGIN 
        v_number := 20;
        DBMS_OUTPUT.PUT_LINE('Inner Number is: ' || v_number);
    END; 
    DBMS_OUTPUT.PUT_LINE('Outer Number is: ' || v_number);
END; 
/

SET serveroutput ON ;
accept p_number_one prompt 'Please enter number one: '
accept p_number_two prompt 'Please enter number two: '
DECLARE 
    v_number_one NUMBER := '&p_number_one';
    v_number_two NUMBER := '&p_number_two';
    v_sum NUMBER;
BEGIN 
    v_sum := (v_number_one + v_number_two);
    DBMS_OUTPUT.put_line('The sum of ' || v_number_one || ' and ' || v_number_two || 
        ' is ' || v_sum);
END;
/

SET SERVEROUTPUT ON
ACCEPT p_num1 PROMPT 'Enter the first number: '
ACCEPT p_num2 PROMPT 'Enter the second number: '
DECLARE
v_num1 NUMBER := '&p_num1';
v_num2 NUMBER := '&p_num2';
v_avg NUMBER;
BEGIN
v_avg := (v_num1 + v_num2) / 2;
DBMS_OUTPUT.PUT_LINE('The average of ' || v_num1 ||
' and ' || v_num2 || ' is ' || v_avg);
END;
/


SET serveroutput ON 
ACCEPT p_number PROMPT 'Enter any integer: ';
DECLARE 
    v_number NUMBER := '&p_number';
    v_output_string VARCHAR(255);
    v_remainder NUMBER;
BEGIN 
    v_remainder := v_number MOD 2;
    DBMS_OUTPUT.PUT_line('The remainder is: ' || v_remainder);
    IF v_remainder = 1 THEN 
        v_output_string := v_number || ' is odd.';
    ELSIF v_remainder = 0 THEN 
        v_output_string := v_number || ' is even.';
    END IF;
    DBMS_OUTPUT.put_line(v_output_string);
END;
/
        
SET serveroutput ON 
ACCEPT p_number PROMPT 'Enter any integer: ';
DECLARE 
    v_number NUMBER := '&p_number';
    v_output_string VARCHAR(255);
    v_remainder NUMBER;
BEGIN 
    v_remainder := v_number MOD 2;
    DBMS_OUTPUT.PUT_line('The remainder is: ' || v_remainder);
    CASE v_remainder
        WHEN 1 THEN
        v_output_string := v_number || ' is odd.';
        WHEN 0 THEN
        v_output_string := v_number || ' is even.';
    END CASE;
    DBMS_OUTPUT.put_line(v_output_string);
END;
/
        
    
SET serveroutput ON 
ACCEPT p_number PROMPT 'Enter a number: ';
DECLARE 
    v_number NUMBER := '&p_number';
BEGIN
    FOR num_loops IN 1..v_number LOOP 
        DBMS_OUTPUT.PUT_LINE('We are on loop: ' || num_loops);
    END LOOP;
END;
/

SET serveroutput ON;
DECLARE 
    v_number NUMBER;
BEGIN 
    v_number := 1;
    WHILE v_number <= 5 LOOP 
        DBMS_OUTPUT.PUT_LINE('We are on loop: ' || v_number || '.');
        v_number := v_number + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('The loop has ended!');
END;
/

SET serveroutput ON 
ACCEPT p_number PROMPT 'Please enter a positive integer: ';
DECLARE 
    v_number NUMBER := '&p_number'; 
    v_factorial NUMBER := 1;
BEGIN 
    DBMS_OUTPUT.PUT('The factorial of ' || v_number || ' is: ');
    while v_number != 1 LOOP 
        v_factorial := v_factorial + v_number;
        v_number := v_number - 1;
    END LOOP;
    DBMS_OUTPUT.PUT(v_factorial);
    DBMS_OUTPUT.NEW_LINE();
END;
/
        

SET serveroutput ON;
ACCEPT p_number PROMPT 'Please enter a positive integer: ';
DECLARE 
    v_number NUMBER := '&p_number'; 
    v_factorial NUMBER := 0;
BEGIN 
    DBMS_OUTPUT.PUT('The factorial of ' || v_number || ' is: ');
    FOR num_loop IN 1..v_number LOOP 
        v_factorial := v_factorial + num_loop;
    END LOOP;
    DBMS_OUTPUT.PUT(v_factorial);
    DBMS_OUTPUT.NEW_LINE();
END;
/

SET SERVEROUTPUT ON;
SET VER OFF;
ACCEPT p_id PROMPT 'Enter employee id: ';
   
DECLARE
    v_first_name  VARCHAR2(20);
    v_last_name   VARCHAR2(25);
    v_email       VARCHAR2(25);
    v_phone       VARCHAR2(20);
    v_salary      NUMBER(8,2);
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

SET serveroutput ON 
SET ver off
ACCEPT p_department_id Prompt 'Enter department ID: ';

DECLARE
    v_department_id     VARCHAR(255);
    v_department_name VARCHAR(255);
    v_manager_id        NUMBER;
    v_location_id       NUMBER;
BEGIN
    SELECT
        department_id
      , department_name
      , manager_id
      , location_id
       into v_department_id
      , v_department_name
      , v_manager_id
      , v_location_id
    FROM
        hr.departments
    WHERE
        department_id = &p_department_id;
    DBMS_OUTPUT.put_LINE('Department Name: ' || CHR(9) || v_department_name || CHR(10) ||
    'Department ID: ' || CHR(9) || v_department_id || CHR(10) ||
    'Manager ID: ' || CHR(9) || v_manager_id || CHR(10) ||
    'Location ID: ' || CHR(9) || v_location_id || CHR(10));
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

select * from hr.departments;
SET serveroutput ON 
SET ver off
ACCEPT p_department_id Prompt 'Enter department ID: ';

DECLARE
    v_department_id hr.departments.department_id%TYPE;
    v_department_name hr.departments.department_name%TYPE;
    v_manager_id hr.departments.manager_id%TYPE;
    v_location_id hr.departments.location_id%TYPE;
BEGIN
    SELECT
        department_id
      , department_name
      , manager_id
      , location_id
       into v_department_id
      , v_department_name
      , v_manager_id
      , v_location_id
    FROM
        hr.departments
    WHERE
        department_id = &p_department_id;
    DBMS_OUTPUT.put_LINE('Department Name: ' || CHR(9) || v_department_name || CHR(10) ||
    'Department ID: ' || CHR(9) || v_department_id || CHR(10) ||
    'Manager ID: ' || CHR(9) || v_manager_id || CHR(10) ||
    'Location ID: ' || CHR(9) || v_location_id || CHR(10));
END;
/

SET SERVEROUTPUT ON;
SET VER OFF;
ACCEPT p_id PROMPT 'Enter employee id: ';
    
DECLARE
    v_employee 	hr.employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_employee
    FROM hr.employees
    WHERE employee_id = &p_id;
    
    DBMS_OUTPUT.PUT_LINE(v_employee.first_name || CHR(32) || v_employee.last_name ||                
    CHR(10) || 'Email: ' || v_employee.email ||         
    CHR(10) || 'Phone No: ' || v_employee.phone_number || 
    CHR(10) || 'Salary: ' || v_employee.salary);
END;
/


SET serveroutput ON 
SET ver off
ACCEPT p_department_id Prompt 'Enter department ID: ';

DECLARE
    v_department hr.departments%ROWTYPE;
BEGIN
    SELECT
        *
    INTO 
        v_department
    FROM
        hr.departments
    WHERE
        department_id = &p_department_id;
    DBMS_OUTPUT.put_LINE('Department Name: ' || CHR(9) || v_department.department_name || CHR(10) ||
    'Department ID: ' || CHR(9) || v_department.department_id || CHR(10) ||
    'Manager ID: ' || CHR(9) || v_department.manager_id || CHR(10) ||
    'Location ID: ' || CHR(9) || v_department.location_id || CHR(10));
END;
/

SET SERVEROUTPUT ON;
ACCEPT p_ord_id PROMPT 'Enter Order No: '
  
DECLARE
    TYPE cust_ord_record IS RECORD
         (name oe.customers.cust_first_name%TYPE,
         email oe.customers.cust_email%TYPE,
         status oe.orders.order_status%TYPE);
    r_cust_ord cust_ord_record;
BEGIN
    SELECT cust_first_name || CHR(32) || cust_last_name, cust_email, order_status 
    INTO r_cust_ord
    FROM oe.customers c JOIN oe.orders o 
    ON c.customer_id = o.customer_id
    WHERE order_id = &p_ord_id;
  
    DBMS_OUTPUT.PUT_LINE('Customer name: ' || r_cust_ord.name || 
                         CHR(10) || 'Customer email: ' || r_cust_ord.email || 
                         CHR(10) || 'Order status: ' || r_cust_ord.status);
END;
/

SET serveroutput ON 
SET ver off
ACCEPT p_department_id Prompt 'Enter department ID: ';

DECLARE
    TYPE department_record IS RECORD 
    (
        department_name hr.departments.department_name%TYPE, 
        department_id hr.departments.department_id%TYPE, 
        manager_id hr.departments.manager_id%TYPE, 
        location_id hr.departments.location_id%TYPE
    ); v_department department_record;
BEGIN
    SELECT
        department_name,
        department_id, 
        manager_id, 
        location_id
    INTO 
        v_department
    FROM
        hr.departments
    WHERE
        department_id = &p_department_id;
    DBMS_OUTPUT.put_LINE('Department Name: ' || CHR(9) || v_department.department_name || CHR(10) ||
    'Department ID: ' || CHR(9) || v_department.department_id || CHR(10) ||
    'Manager ID: ' || CHR(9) || v_department.manager_id || CHR(10) ||
    'Location ID: ' || CHR(9) || v_department.location_id || CHR(10));
END;
/

SET serveroutput ON;
SET ver OFF;

DECLARE 
    TYPE employee_record IS RECORD 
    (full_name hr.employees.first_name%TYPE, 
    employee_id hr.employees.employee_id%TYPE, 
    hire_date hr.employees.hire_date%TYPE);
    employee employee_record;
BEGIN 
     WITH employees_hire_rank AS (SELECT 
        first_name || ' ' || last_name as full_name, 
        employee_id, 
        hire_date, 
        DENSE_RANK() OVER (
            ORDER BY hire_date) as hire_rank
    FROM 
        hr.employees)
    SELECT 
        full_name, 
        employee_id, 
        hire_date
    INTO 
        employee
    FROM 
        employees_hire_rank 
    WHERE 
        hire_rank = 1;
        
    DBMS_OUTPUT.PUT_LINE('The first hired employee was: ' || employee.full_name);
END;
/


 WITH employees_hire_rank AS (SELECT 
        first_name || ' ' || last_name as full_name, 
        employee_id, 
        hire_date, 
        DENSE_RANK() OVER (
            ORDER BY hire_date) as hire_rank
    FROM 
        hr.employees)
    SELECT 
        full_name, 
        employee_id, 
        hire_date, 
        hire_rank
    FROM 
        employees_hire_rank 
    WHERE 
        hire_rank = 1;
        
SET SERVEROUTPUT ON
DECLARE
v_first_name hr.employees.first_name%TYPE;
v_last_name hr.employees.last_name%TYPE;
v_hire_date hr.employees.hire_date%TYPE;
BEGIN
SELECT first_name, last_name, hire_date
INTO v_first_name ,v_last_name, v_hire_date
FROM hr.employees
WHERE hire_date = ( SELECT
MIN(hire_date)
FROM hr.employees);
DBMS_OUTPUT.PUT_LINE(v_first_name || CHR(9) || v_last_name ||
CHR(9) || v_hire_date);
END;
/
45
DAS32100 – Database Management
