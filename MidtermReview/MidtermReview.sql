SET SERVEROUTPUT ON;
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE 
    p_insert_location (pl_location_id locations.location_id%type, 
        pl_street_address locations.street_address%type, 
        pl_postal_code locations.postal_code%type, 
        pl_city locations.city%type, 
        pl_state_province locations.state_province%type, 
        pl_country_id locations.country_id%type)
AS
    v_greeting VARCHAR2(255) := 'Hello there!';
BEGIN 
    DBMS_OUTPUT.PUT_LINE(v_greeting);
    INSERT INTO 
        location_midterm
    VALUES
        (pl_location_id, 
        pl_street_address, 
        pl_postal_code, 
        pl_city, 
        pl_state_province, 
        pl_country_id);
END;
/

--CREATE TABLE countries_midterm_log (operation VARCHAR2(20), 
--        username VARCHAR2(20), 
--        opdate DATE, 
--        country_id char(2), 
--        country_name VARCHAR2(40), 
--        region_id NUMBER);

--CREATE TABLE locations_midterm_log (operation VARCHAR2(20), 
--        username VARCHAR2(20), 
--        opdate DATE, 
--        location_id VARCHAR2(20), 
--        street_address VARCHAR2(255), 
--        postal_code VARCHAR2(255), 
--        city VARCHAR2(255), 
--        state_province VARCHAR2(255), 
--        country_id VARCHAR2(255));

SELECT 
    * 
FROM 
    locations_midterm_log;

CREATE OR REPLACE FUNCTION 
    f_get_location (pl_location_id hr.locations.location_id%type)
RETURN 
    hr.locations%ROWTYPE
AS 
    v_location hr.locations%ROWTYPE;
BEGIN 
    SELECT 
        * 
    INTO 
        v_location
    FROM 
        hr.locations
    WHERE 
        location_id = pl_location_id;
    RETURN v_location;
END;
/

PROMPT p_location_id ACCEPT 'Please enter the location ID';

CREATE OR REPLACE TRIGGER 
    validate_province
BEFORE DELETE OR INSERT OR UPDATE ON 
    location_midterm
FOR EACH ROW 
--    WHEN (NEW.state_province NOT IN ('AB', 'BC', 'MB', 'NB', 'NT', 'NS', 'NU', 
--        'ON', 'PE', 'QC', 'SK', 'YT'))
DECLARE 
    invalid_province EXCEPTION;
BEGIN 
    IF INSERTING THEN 
        INSERT INTO locations_midterm_log VALUES ('INSERT', USER, SYSDATE, 
            :NEW.location_id, :NEW.street_address, :NEW.postal_code, :NEW.city, 
            :NEW.state_province, :NEW.country_id);
    ELSIF UPDATING THEN 
    INSERT INTO locations_midterm_log VALUES ('UPDATE', USER, SYSDATE, 
            :OLD.location_id, :OLD.street_address, :OLD.postal_code, :OLD.city, 
            :OLD.state_province, :OLD.country_id);
    ELSIF DELETING THEN 
    INSERT INTO locations_midterm_log VALUES('DELETE', USER, SYSDATE, 
            :OLD.location_id, :OLD.street_address, :OLD.postal_code, :OLD.city, 
            :OLD.state_province, :OLD.country_id);
    END IF;
EXCEPTION
    WHEN invalid_province THEN 
        DBMS_OUTPUT.PUT_LINE('Invalid province, insertion cancelled!!');
END;
/

DECLARE 
    v_location_id hr.locations.location_id%TYPE := '&p_location_id';
    v_location hr.locations%ROWTYPE;
BEGIN 
    v_location := f_get_location(v_location_id);
    
    p_insert_location(v_location.location_id, 
        v_location.street_address, 
        v_location.postal_code, 
        v_location.city, 
        v_location.state_province, 
        v_location.country_id);
        
    DBMS_OUTPUT.PUT_LINE('Successfully inserted!');
END;
/

CREATE OR REPLACE PROCEDURE delete_location
    (pl_location_id locations.location_id%TYPE)
AS BEGIN 
    DELETE FROM location_midterm 
    WHERE location_id = pl_location_id;
END;
/

DECLARE 
    v_location_id hr.locations.location_id%TYPE := '&p_location_id';
    v_location hr.locations%ROWTYPE;
BEGIN 
--    v_location := f_get_location(v_location_id);
--    
--    p_insert_location(v_location.location_id, 
--        v_location.street_address, 
--        v_location.postal_code, 
--        v_location.city, 
--        v_location.state_province, 
--        v_location.country_id);

    delete_location(v_location_id);
        
    DBMS_OUTPUT.PUT_LINE('Success!');
END;
/

--SELECT 
--    *
--FROM 
--    location_midterm;
--    
--SELECT 
--    *
--FROM 
--    locations_midterm_log;

CREATE OR REPLACE FUNCTION count_countries_by_region 
    (pl_region_id hr.regions.region_id%TYPE)
RETURN NUMBER
AS 
    v_count NUMBER;
BEGIN 
    SELECT 
        count(c.region_id)
    INTO 
        v_count
    FROM 
        hr.countries c 
    INNER JOIN 
        hr.regions r 
    ON 
        c.region_id = r.region_id
    WHERE 
        c.region_id = pl_region_id;
    RETURN v_count;
END;
/

PROMPT p_region_id ACCEPT 'Please enter a region ID: ';
CREATE OR REPLACE PROCEDURE 
    impl_country_count 
AS 
    v_region_id hr.regions.region_id%TYPE := '&p_region_id';
    v_count NUMBER;
BEGIN 
    SELECT NVL(count_countries_by_region(region_id), 999)
    INTO v_count
    FROM hr.regions 
    WHERE region_id = v_region_id;

--    v_count := count_countries_by_region(v_region_id);
    
    DBMS_OUTPUT.PUT_LINE('The count is: ' || v_count);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error, no data found!');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN 
    impl_country_count();
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error, no data found!');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SHOW ERRORS;

SELECT 
    * 
FROM 
    hr.regions;

    