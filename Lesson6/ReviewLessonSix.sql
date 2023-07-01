SET SERVEROUTPUT ON

-- Procedures 
BEGIN 
    -- add_region(02, 'Americas');
    get_accountants();
END;
/

CREATE OR REPLACE PROCEDURE get_accountants
AS 
    v_employee hr.employees%ROWTYPE;
    CURSOR c_accountants IS 
        SELECT 
            e.*
        FROM 
            hr.employees e 
        INNER JOIN 
            hr.jobs j 
        ON 
            e.job_id = j.job_id
        WHERE 
            lower(job_title) = 'accountant';
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Printing accountants!');
    for v_accountant IN c_accountants LOOP
        get_employee(v_employee, v_accountant.employee_id);
        DBMS_OUTPUT.PUT_LINE(v_employee.employee_id || ' ' 
            || v_employee.first_name || ' '
            || v_employee.last_name);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE
    add_region
    (
        pl_region_id regions.region_id%TYPE, 
        pl_region_name regions.region_name%TYPE
    )
AS BEGIN 
    INSERT INTO 
        regions (region_id, region_name)
    VALUES 
        (pl_region_id, 
        pl_region_name);
END;
/

CREATE OR REPLACE PROCEDURE 
    get_employee (pl_employee OUT employees%ROWTYPE,
        pl_employee_id IN employees.employee_id%TYPE)
AS BEGIN 
    SELECT 
        * 
    INTO 
        pl_employee
    FROM 
        hr.employees 
    WHERE
        employee_id = pl_employee_id;
END;
/

SELECT 
    * 
FROM 
    hr.jobs;