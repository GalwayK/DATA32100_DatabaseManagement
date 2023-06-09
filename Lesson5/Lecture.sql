SET SERVEROUTPUT ON;
accept p_salary prompt 'Please enter a salary: ';
DECLARE 
    TYPE table_employees IS TABLE OF hr.employees%ROWTYPE;
    v_table_employees table_employees;
    v_salary hr.employees.salary%TYPE;
    v_output VARCHAR(10);
    INVALID_SALARY EXCEPTION;
    NO_RESULTS_FOUND EXCEPTION;
BEGIN 
v_salary := 1 / 0;
--    v_salary := '&p_salary';
    IF v_salary < 0 THEN 
        raise INVALID_SALARY;
    END IF;
    SELECT
        *
    BULK COLLECT INTO v_table_employees
    FROM 
        hr.employees
    WHERE 
        salary = v_salary;
    IF v_table_employees.count = 0 THEN 
        RAISE NO_RESULTS_FOUND;
    ELSIF v_table_employees.count = 1 THEN 
        v_output := ' employee';
    ELSE 
        v_output := ' employees';
    END IF;
    DBMS_OUTPUT.PUT_LINE('Found ' || v_table_employees.count || v_output || ' with salary of ' || v_salary || '!');
    for i in 1..v_table_employees.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_table_employees(i).first_name || ' ' || v_table_employees(i).last_name || ' has a salary of ' || v_salary || '!');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Finished displaying employees!');

EXCEPTION 
    WHEN NO_DATA_FOUND OR NO_RESULTS_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No employee found!');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Too many employees found!');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN INVALID_SALARY THEN 
        DBMS_OUTPUT.PUT_LINE('Salary cannot be negative!');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('Message: Salary must be a number!');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' Error Detected!');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK());
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        DBMS_OUTPUT.NEW_LINE();
END;
/

--SET SERVEROUTPUT ON 
--accept p_salary prompt 'Please enter a salary: ';
--DECLARE 
--    NUMBER_NEGATIVE EXCEPTION;
--    v_employee hr.employees%ROWTYPE;
--    v_salary hr.employees.salary%TYPE := '&p_salary';
--BEGIN 
--    IF v_salary < 0 THEN 
--        RAISE NUMBER_NEGATIVE;
--    END IF;
--    SELECT
--        *
--    INTO 
--        v_employee
--    FROM 
--        hr.employees
--    WHERE 
--        salary = v_salary;
--    DBMS_OUTPUT.PUT_LINE('Found an Employee!');
--    
--    DBMS_OUTPUT.PUT_LINE(v_employee.first_name || ' ' || v_employee.last_name || ' has a salary of ' || v_salary);
-- 
--    DBMS_OUTPUT.PUT_LINE('Finished displaying employees!');
--
--EXCEPTION 
--    WHEN NO_DATA_FOUND THEN 
--        DBMS_OUTPUT.PUT_LINE('No employee found!');
--    WHEN TOO_MANY_ROWS THEN 
--        DBMS_OUTPUT.PUT_LINE('Too many employees found!');
--    WHEN NUMBER_NEGATIVE THEN 
--        DBMS_OUTPUT.PUT_LINE('You cannot search for a negative salary!');
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('Well, something went wrong!');
--END;
--/

SELECT salary FROM hr.employees;

--SET SERVEROUTPUT ON 
--accept p_salary prompt 'Please enter a salary: ';
--DECLARE 
--    TYPE table_employees IS TABLE OF hr.employees%ROWTYPE;
--    v_table_employees table_employees;
--    v_salary hr.employees.salary%TYPE := '&p_salary';
--BEGIN 
--    SELECT
--        *
--    BULK COLLECT INTO v_table_employees
--    FROM 
--        hr.employees
--    WHERE 
--        salary = v_salary;
--    DBMS_OUTPUT.PUT_LINE('Found ' || v_table_employees.count || ' Employees!');
--    for i in 1..v_table_employees.count LOOP
--        DBMS_OUTPUT.PUT_LINE(v_table_employees(i).first_name || ' ' || v_table_employees(i).last_name || ' has a salary of ' || v_salary);
--    END LOOP;
--    DBMS_OUTPUT.PUT_LINE('Finished displaying employees!');
--
--EXCEPTION 
--    WHEN NO_DATA_FOUND THEN 
--        DBMS_OUTPUT.PUT_LINE('No employee found!');
--    WHEN TOO_MANY_ROWS THEN 
--        DBMS_OUTPUT.PUT_LINE('Too many employees found!');
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('Too many employees found!');
--END;
--/
--
--SELECT salary FROM hr.employees;

--CREATE TABLE 
--    employees 
--AS SELECT 
--    * 
--FROM 
--    hr.employees
--WHERE 1 = 2;

--SET SERVEROUTPUT ON 
--DECLARE 
--    TYPE type_table_countries IS TABLE OF hr.countries%ROWTYPE;
--    v_countries type_table_countries;
--    v_country_id hr.countries.country_id%TYPE;
--BEGIN 
--    SELECT  c.*
--    BULK COLLECT INTO v_countries
--    FROM
--    hr.countries c
--    INNER JOIN 
--    hr.regions r
--    ON 
--    r.region_id = c.region_id
--    WHERE 
--        lower(region_name) = 'americas';
--        
--    for i IN 1..v_countries.COUNT LOOP
--        DBMS_OUTPUT.PUT_LINE(v_countries(i).country_id || CHR(10) || v_countries(i).country_name);
--    END LOOP;
--END;
--/

----Every variable must be declared 
----Then whenw e want to read ata we must open the cursor. 
----We then go in a loop to fetc the rows one by one into variables to get and process the values. 
----We need to run a loop because the cursor is not one single row, it can have multile rows.
----We need to use explicit cursors because the implicit cursors have a maximum of one row. 
----A cursor allows us to return multiple rows. A cursor can hold a select statement temporarily. 
----The difference between a view and a cursor is that a cursor is temporary while a view is permanent until deleted. 
----
----To declare a cursor we use Cursor cursorName IS select statement
--
----To use a cursor we can then we must ierate through the cursor row by row. 
----This starts by opening the cursor and then fetching the data into some corresponding variables
----or rowype that matches the columns inside the curosr. We must match teh columns inside the cursor with the into statement. 
----After we have taken the values out of teh curosr we must close it with CLOSE cursorName.
----SET serveroutput ON;
----DECLARE 
----    CURSOR employee_cursor IS 
----        SELECT first_name, last_name 
----    FROM 
----        hr.employees;
----    first_name hr.employees.first_name%TYPE; 
----    last_name hr.employees.last_name%TYPE;
----BEGIN 
----    OPEN employee_cursor;
----    LOOP 
----        FETCH 
----            employee_cursor 
----        INTO 
----            first_name, 
----            last_name;
----        EXIT WHEN employee_cursor%NOTFOUND;
----        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || first_name || ' ' || last_name);
----    END LOOP;
----    CLOSE employee_cursor;
----END;
----/
--
--
--SET SERVEROUTPUT ON;
--    
--DECLARE 
--    CURSOR product_prices_cursor IS SELECT 
--    product_id,
--    round(avg(list_price) OVER(
--        PARTITION BY product_id), 2) as product_average,
--    category_id, 
--    round(avg(list_price) OVER(
--        PARTITION BY category_id), 2) as category_average
--    FROM 
--    oe.product_information;
--    
--    TYPE item_average_row IS RECORD (
--        product_id oe.product_information.product_id%TYPE, 
--        product_average oe.product_information.list_price%TYPE, 
--        category_id oe.product_information.category_id%TYPE, 
--        category_average oe.product_information.list_price%TYPE);
--        
--    item_average item_average_row;
--BEGIN
--    OPEN product_prices_cursor;
--    LOOP
--        FETCH product_prices_cursor INTO item_average;
--        EXIT WHEN product_prices_cursor%NOTFOUND;
--        DBMS_OUTPUT.PUT('Product ID: ' || item_average.product_id || CHR(9));
--        DBMS_OUTPUT.PUT('Product Average: ' || item_average.product_average || CHR(9));
--        DBMS_OUTPUT.PUT('Category ID: ' || item_average.category_id || CHR(9));
--        DBMS_OUTPUT.PUT('Category Average: ' || item_average.category_average || CHR(9));
--        DBMS_OUTPUT.NEW_LINE();
--    END LOOP;
--    CLOSE product_prices_cursor;
--END;
--/


--EXISTS checks if an element exists 
--COUNT checks the length of a collecition in PLSQL
--LIMIT can only be used the maximum size of arrays, but not the number of elements currently in the array
--Limit will return null when used on tables since nested tables don't have a size
--FIRST and LAST will return the first and last element of the array respectively. 
--
--PPRIOR returns the previous index. 
--NEXT will return the next index. 
--
--EXTEND will open up the space of an array to allow a new element to be inserted.
--varrays have a size, but you have to extend them to fit the number of elements when 
--you insert a new element. We can assign a maximum size of elements. 
--
--TRIM will remove a certain amount of elements. 
--
--DELETE has three fours. It can delete everything in teh array, a certain number of elements, 
--or will delete a certain amount of elements starting from a certain index. 

--SET SERVEROUTPUT ON;
--
--DECLARE 
--    TYPE arr_names IS VARRAY(5) OF VARCHAR(255);
--    TYPE arr_grades IS VARRAY(5) OF NUMBER(4, 2);
--    arr_student_names arr_names;
--    arr_student_grades arr_grades;
--BEGIN 
--    arr_student_grades := arr_grades(4.0, 2.1, 3.5, 1.4, 3.7);
--    arr_student_names := arr_names('Kyle', 'Liam', 'Neil', 'Terry', 'Shelly');
--    
--    for i IN 1..arr_student_grades.COUNT LOOP
--        dbms_output.PUT_LINE(arr_student_names(i) || CHR(39) || ' GPA: ' || TO_CHAR(arr_student_grades(i), 'fm99D00'));
--    END LOOP;
--END;
--/

--
--SET SERVEROUTPUT ON 
--DECLARE 
--    TYPE type_table_countries IS TABLE OF hr.countries%ROWTYPE;
--    table_countries type_table_countries;
--    v_country_id hr.countries.country_id%TYPE;
--BEGIN 
--    v_country_id := 'US';
--    SELECT  * 
--    BULK COLLECT INTO table_countries
--    FROM
--    hr.countries 
--    WHERE 
--        country_id = v_country_id;
--        
--    for i IN 1..table_countries LOOP
--        DBMS_OUTPUT.PUT_LINE(table_countries(i).country_id || ' ' || table_countries(i).country_name || ' ' || table_countries(i).region_id);
--    END LOOP;
--END;
--/