SET SERVEROUTPUT ON;

SELECT 
    * 
FROM 
    region_log_midterm;
    
SELECT 
    * 
FROM 
    region_midterm;

PROMPT p_region_id ACCEPT 'Please enter region ID to update: ';
PROMPT p_region_name ACCEPT 'Please enter new region name: ';

DECLARE 
    v_region_id hr.regions.region_id%TYPE := '&p_region_id';
    v_region_name hr.regions.region_name%TYPE := '&p_region_name';
    
    v_region hr.regions%ROWTYPE;
    
    TYPE arr_regions IS VARRAY(4) OF hr.regions%ROWTYPE;
    v_arr_regions arr_regions;
    
    CURSOR regions IS 
    SELECT 
        * 
    FROM 
        hr.regions;
BEGIN 
    delete_region('1');
    delete_region(2);
    delete_region(3);
    delete_region(4);

DBMS_OUTPUT.PUT_LINE('I hate PL SQL');

    FOR region IN regions LOOP 
        insert_region(region);
    END LOOP;

    UPDATE_REGION(v_region_id, v_region_name);
    COMMIT;
    v_arr_regions := arr_regions();
    
    FOR i IN 1..v_arr_regions.LIMIT LOOP
        v_arr_regions.extend;
        v_arr_regions(i) := get_region(i);
    END LOOP;
    
    FOR i IN 1..v_arr_regions.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('Region Name: ' || v_arr_regions(i).region_name
            || ' Region ID: ' || v_arr_regions(i).region_id);
    END LOOP;

EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('NO data found!');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Something went wrong: ' || SQLERRM);
END;
/


CREATE OR REPLACE FUNCTION 
    get_region(pl_region_id hr.regions.region_id%TYPE)
RETURN hr.regions%ROWTYPE
AS 
    v_region hr.regions%ROWTYPE;
BEGIN
    SELECT 
        *
    INTO
        v_region
    FROM 
        region_midterm
    WHERE 
        region_id = pl_region_id;
    return v_region;
END;
/

CREATE OR REPLACE PROCEDURE update_region
(pl_region_id hr.regions.region_id%TYPE,
pl_region_name hr.regions.region_name%TYPE)
AS
BEGIN 
    UPDATE 
        region_midterm 
    SET 
        region_name = pl_region_name
    WHERE 
        region_id = pl_region_id;
END;
/

CREATE OR REPLACE PROCEDURE delete_region
(pl_region_id hr.regions.region_id%TYPE)
AS
BEGIN 
    DELETE FROM 
        region_midterm 
    WHERE 
        region_id = pl_region_id;
END;
/

CREATE OR REPLACE PROCEDURE insert_region
(
    pl_region hr.regions%ROWTYPE
)
AS 
BEGIN 
    INSERT INTO 
        region_midterm
    VALUES 
        (pl_region.region_id, pl_region.region_name);
END;
/

CREATE OR REPLACE TRIGGER 
    on_insert_region 
BEFORE INSERT ON 
    region_midterm
FOR EACH ROW 
BEGIN 
    :NEW.region_name := UPPER(:NEW.region_name);
    INSERT INTO 
    region_log_midterm 
VALUES 
    ('INSERT', USER, SYSDATE, :NEW.region_id, :NEW.region_name);
END;
/

CREATE OR REPLACE TRIGGER 
    on_update_region 
BEFORE UPDATE OR DELETE ON 
    region_midterm
FOR EACH ROW 
DECLARE
    v_operation VARCHAR2(20) := 'DELETE';
BEGIN 
    IF UPDATING THEN 
        :NEW.region_name := UPPER(:NEW.region_name);
        v_operation := 'UPDATE';
    END IF; 
    
    INSERT INTO 
        region_log_midterm 
    VALUES 
        (v_operation, USER, SYSDATE, 
        :OLD.REGION_ID, :OLD.REGION_NAME);
END;
/

DROP TABLE region_log_midterm;

CREATE TABLE region_log_midterm
(
    operation VARCHAR2(20), 
    username VARCHAR2(20), 
    opdate DATE, 
    region_id NUMBER, 
    region_name VARCHAR2(40)
);


--CREATE OR REPLACE FUNCTION
--    print_highest_number(pl_number_one IN NUMBER, 
--        pl_number_two IN NUMBER)
--RETURN NUMBER
--AS
--v_number NUMBER;
--BEGIN 
--    v_number := pl_number_two;
--    IF pl_number_one > pl_number_two THEN
--        v_number := pl_number_one;
--    END IF;
--    RETURN v_number;
--END;
--/
--
--DECLARE 
--    v_number NUMBER;
--BEGIN 
--    v_number := print_highest_number(1, 2);
--    DBMS_OUTPUT.PUT_LINE('Highest number: ' || v_number || '.');
--END;
--/