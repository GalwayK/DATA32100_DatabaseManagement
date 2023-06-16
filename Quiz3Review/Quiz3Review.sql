SET SERVEROUTPUT ON 
-- Question 1. Use a cursor to print the average list price of each product 
-- category in product information of the OE schema. 

-- Implicit Cursor 
--DECLARE 
--    TYPE r_category_record IS RECORD 
--    (category_id oe.product_information.category_id%TYPE, 
--    category_average NUMBER);
--    
--    TYPE arr_category_averages IS TABLE OF r_category_record;
--    v_arr_category_averages arr_category_averages;
--    v_current_element INTEGER;
--BEGIN 
--    SELECT 
--        category_id, 
--        round(avg(list_price), 2) as category_average
--    BULK COLLECT INTO 
--        v_arr_category_averages
--    FROM 
--        oe.product_information
--    GROUP BY
--        category_id;
--    v_current_element := v_arr_category_averages.FIRST;
--    DBMS_OUTPUT.PUT_LINE('Printing Resultss');
--    LOOP
--        EXIT WHEN v_current_element IS NULL;
--        DBMS_OUTPUT.PUT_LINE('Category ID: ' || 
--        v_arr_category_averages(v_current_element).category_id || 
--        ' Category Average: ' 
--        || v_arr_category_averages(v_current_element).category_average);
--        
--        v_current_element := v_arr_category_averages.NEXT(v_current_element);
--    END LOOP;
--        
--
--EXCEPTION
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('An error has occured:' || SQLERRM);
--END;
--/

-- Explicit Cursor Simple Loop
--DECLARE 
--    TYPE r_category_record IS RECORD 
--    (category_id oe.product_information.category_id%TYPE, 
--    category_average NUMBER);
--    
--    CURSOR c_category_averages IS 
--    SELECT 
--        category_id, 
--        round(avg(list_price), 2) as category_average
--    FROM 
--        oe.product_information
--    GROUP BY
--        category_id;
--    
--    TYPE arr_category_averages IS TABLE OF r_category_record;
--    v_current_element r_category_record;
--BEGIN 
--    DBMS_OUTPUT.PUT_LINE('Printing Results');
--    OPEN c_category_averages;
--    LOOP
--        FETCH c_category_averages INTO v_current_element;
--        EXIT WHEN c_category_averages%NOTFOUND;
--        DBMS_OUTPUT.PUT_LINE('Category ID: ' || 
--        v_current_element.category_id || 
--        ' Category Average: ' 
--        || v_current_element.category_average);
--    END LOOP;
--    CLOSE c_category_averages;
--
--EXCEPTION
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('An error has occured:' || SQLERRM);
--END;
--/
--
--DECLARE 
--    TYPE r_category_record IS RECORD 
--    (category_id oe.product_information.category_id%TYPE, 
--    category_average NUMBER);
--    
--    CURSOR c_category_averages IS 
--    SELECT 
--        category_id, 
--        round(avg(list_price), 2) as category_average
--    FROM 
--        oe.product_information
--    GROUP BY
--        category_id;
--    
--    TYPE arr_category_averages IS TABLE OF r_category_record;
--BEGIN 
--    DBMS_OUTPUT.PUT_LINE('Printing Results');
--    
--    FOR v_current_element IN c_category_averages LOOP
--        DBMS_OUTPUT.PUT_LINE('Category ID: ' || 
--        v_current_element.category_id || 
--        ' Category Average: ' 
--        || v_current_element.category_average);
--    END LOOP;
--
--EXCEPTION
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('An error has occured:' || SQLERRM);
--END;
--/


-- Question 2. Create a script that models students grades with 2 varrays 

--SET SERVEROUTPUT ON 
--    
--DECLARE 
--    v_num_elements CONSTANT INTEGER := 5;
--    TYPE arr_grades is varray(5) OF number;
--    TYPE arr_names is varray(5) OF varchar(255);
--    v_arr_grades arr_grades;
--    v_arr_names arr_names;
--BEGIN 
--    v_arr_grades := arr_grades(4.0, 3.9, 2.0, 1.5, 3.5);
--    v_arr_names := arr_names('Kyle', 'Sayaka', 'Jenny', 'Vinz', 'Gavin');
--    FOR i in 1..v_arr_names.COUNT LOOP 
--        DBMS_OUTPUT.PUT_LINE(v_arr_names(i) || ': ' || v_arr_grades(i));
--    END LOOP;
--EXCEPTION
--    WHEN OTHERS THEN
--    DBMS_OUTPUT.PUT_LINE('Something went wrong!');
--END; 

--SELECT 
--    category_id, 
--    round(avg(list_price), 2) as category_average
--FROM 
--    oe.product_information
--GROUP BY
--    category_id;

-- Question 3. Create a table that can hold multiple rows of 
-- hr.countries%rowtype and fill it with data from the countries table. 
--DECLARE 
--    TYPE arr_countries IS TABLE of hr.countries%rowtype;
--    v_arr_countries arr_countries;
--BEGIN 
--   SELECT 
--        c.* 
--    BULK COLLECT INTO 
--        v_arr_countries
--    FROM 
--        hr.regions r
--    INNER JOIN 
--        hr.countries c
--    ON 
--        c.region_id = r.region_id
--    WHERE 
--        region_name = 'Americas';
--        
--    FOR I IN 1..v_arr_countries.count LOOP
--        DBMS_OUTPUT.PUT_LINE('Country Name: ' || CHR(9) || v_arr_countries(i).country_name || CHR(9) || v_arr_countries(i).region_id);
--    END LOOP;
--EXCEPTION 
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('I do not like PL/SQL!');
--END; 
--/
--
--
--SELECT 
--    * 
--FROM 
--    hr.regions r
--INNER JOIN 
--    hr.countries c
--ON 
--    c.region_id = r.region_id
--WHERE 
--    region_name = 'Americas';
prompt p_salary accept 'Please enter a salary: '

-- Question 4. Search for one employee with salary. 
--DECLARE 
--    v_employee hr.employees%ROWTYPE;
--    v_salary NUMBER := '&p_salary';
--BEGIN 
--    SELECT 
--        * 
--    INTO 
--        v_employee
--    FROM 
--        hr.employees 
--    WHERE
--        salary = v_salary;
--        
--    DBMS_OUTPUT.PUT_LINE(v_employee.first_name || CHR(32) || v_employee.last_name || ' has a salary of ' || v_salary);
--EXCEPTION 
--    WHEN TOO_MANY_ROWS THEN 
--        DBMS_OUTPUT.PUT_LINE('Error: Too many rows returned!');
--    WHEN NO_DATA_FOUND THEN 
--        DBMS_OUTPUT.PUT_LINE('Error: No employee with matching salary!');
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
--END;
--/

-- Question 5. Search for numerous employees with salary
prompt p_salary accept 'Please enter a salary: ';
DECLARE 
    TYPE arr_employees IS TABLE OF hr.employees%ROWTYPE;
    v_arr_employees arr_employees;
    v_salary NUMBER := '&p_salary';
    INVALID_INPUT EXCEPTION;
BEGIN 
    IF v_salary < 0 THEN 
        RAISE INVALID_INPUT;
    END IF;

    SELECT 
        * 
    BULK COLLECT INTO 
        v_arr_employees
    FROM 
        hr.employees 
    WHERE
        salary = v_salary;
    IF v_arr_employees.COUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Printing Employees with salary of ' || v_salary || '!');
    FOR i in 1..v_arr_employees.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(v_arr_employees(i).first_name || CHR(32) || v_arr_employees(i).last_name || ' has a salary of ' || v_salary);
    END LOOP;
    
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Too many rows returned!');
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error: No employee with matching salary!');
    WHEN INVALID_INPUT THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Salary must be positive!');
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Salary must be a number!');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/