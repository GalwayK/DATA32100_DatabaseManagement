SET SERVEROUTPUT ON;
SET VER OFF;

CREATE OR REPLACE PROCEDURE greeting (
    pl_saluation VARCHAR2 := 'Hello',
    pl_name VARCHAR2
)
AS 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(pl_saluation || CHR(32) || pl_name);
END; 
/

CREATE OR REPLACE PROCEDURE 
    PRINT_TWO_NUMBERS(pl_greater_number NUMBER, 
        pl_lesser_number NUMBER)
AS BEGIN 
    DBMS_OUTPUT.PUT_LINE(pl_greater_number || ' is greater than ' 
            || pl_lesser_number || '.');
END;
/

CREATE OR REPLACE PROCEDURE 
    FIND_GREATEST_NUMBER(pl_number_one NUMBER, 
    pl_number_two NUMBER)
AS BEGIN
    IF pl_number_one > pl_number_two THEN
        print_two_numbers(pl_number_one, pl_number_two);
    ELSIF pl_number_two > pl_number_one THEN
        print_two_numbers(pl_number_two, pl_number_one);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('The two numbers are equal!');
    END IF;
END;
/

CALL find_greatest_number(1, 2);
CALL find_greatest_number(pl_number_two => 1, pl_number_one => 2);
CALL find_greatest_number(2, pl_number_two => 4);

CREATE OR REPLACE PROCEDURE 
    insert_into_region(pl_region_name regions.region_name%TYPE, 
        pl_region_id regions.region_id%TYPE)
AS BEGIN
    INSERT INTO 
        regions(region_id, region_name) 
    VALUES 
        (pl_region_id, pl_region_name);
END;
/

CREATE OR REPLACE PROCEDURE 
    update_region(pl_region_id regions.region_id%TYPE, 
    pl_region_name regions.region_name%TYPE)
AS BEGIN 
    UPDATE 
        regions 
    SET 
        region_name = pl_region_name 
    WHERE 
        region_id = pl_region_id;
END;
/

CREATE OR REPLACE PROCEDURE 
    delete_from_region(pl_region_id regions.region_id%TYPE)
AS BEGIN 
    DELETE FROM 
        regions 
    WHERE 
        region_id = pl_region_id;
END;
/

SELECT 
    * 
FROM 
    regions;
    
CALL delete_from_region(1);
CALL insert_into_region('Americas', 1);
CALL update_region(1, 'Europe');

SELECT 
    * 
FROM 
    regions;

CREATE OR REPLACE PROCEDURE 
    find_location(pl_location_id IN hr.locations.location_id%TYPE, 
        pl_location OUT hr.locations%ROWTYPE)
AS BEGIN 
    SELECT 
        *
    INTO 
        pl_location
    FROM 
        hr.locations 
    WHERE 
        location_id = pl_location_id;
END;
/
--
--PROMPT p_location_id ACCEPT 'Please enter a location ID: ';
--
--DECLARE 
--    v_location_id hr.locations.location_id%TYPE;
--    v_location hr.locations%ROWTYPE;
--BEGIN 
--    v_location_id := '&p_location_id';
--    
--    find_location(v_location_id, v_location);
--    DBMS_OUTPUT.PUT_LINE('Found location: ' || v_location.location_id 
--        || CHR(10) || 'Address: ' || v_location.street_address
--        || CHR(10) || 'Country: ' || v_location.country_id);
--EXCEPTION 
--    WHEN OTHERS THEN 
--        DBMS_OUTPUT.PUT_LINE('Error: No Location Found!');
--END;
--/

CREATE OR REPLACE FUNCTION 
    find_department_salary_average(
    pl_department_name hr.departments.department_name%TYPE)
RETURN 
    NUMBER
AS 
    v_average NUMBER;
BEGIN 
    SELECT 
        avg(salary)
    INTO 
        v_average
    FROM 
        hr.departments d
    INNER JOIN 
        hr.employees e
    ON e.department_id = d.department_id
    WHERE 
        UPPER(department_name) = UPPER(pl_department_name);
    RETURN v_average;
END;
/

CREATE OR REPLACE FUNCTION
    find_employees_by_hire_date(pl_hire_date hr.employees.hire_date%TYPE)
RETURN 
    NUMBER
IS 
    v_count_employees NUMBER;
BEGIN 
    SELECT 
        count(employee_id)
    INTO 
        v_count_employees
    FROM 
        hr.employees 
    WHERE 
        hire_date > pl_hire_date;
    return v_count_employees;
END;
/

CREATE OR REPLACE PROCEDURE 
    test_find_employee_by_date(v_hire_date hr.employees.hire_date%TYPE)
AS 
    v_count_employees NUMBER;
BEGIN 
    v_count_employees := find_employees_by_hire_date(v_hire_date);
    
    DBMS_OUTPUT.PUT_LINE(v_count_employees || ' were hired after ' || v_hire_date || '.');
END;
/

PROMPT p_hire_date ACCEPT 'Please enter a date: ';
CALL test_find_employee_by_date('&p_hire_date');

--CALL greeting(pl_name => 'Kyle Galway', pl_saluation => 'Go Away');
--
--BEGIN 
--    greeting('Hello there', 'Kyle Galway');
--END;
--/