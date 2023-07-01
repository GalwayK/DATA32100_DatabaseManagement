--SET SERVEROUTPUT ON
--DECLARE
--    v_count NUMBER(2) := 0;
--BEGIN
--    WHILE(v_count < 5)
--    LOOP
--      DBMS_OUTPUT.PUT(v_count || CHR(9));
--    END LOOP;
--    DBMS_OUTPUT.NEW_LINE();
--END;
--/

SELECT 
    first_name, 
    last_name,
    count(employee_id) as emp_count
FROM 
    hr.employees
WHERE 
    last_name != 'King'
GROUP BY 
    (first_name, last_name)
HAVING 
    (count(employee_id) != 1);
    
    SELECT
    region_name
  , country_name
  , location_id
  , COUNT(*)
FROM
         hr.regions r
    JOIN hr.countries    c ON r.region_id = c.region_id
    JOIN hr.locations    l ON c.country_id = l.country_id
GROUP BY
    ROLLUP(region_name
       , country_name
       , location_id)
HAVING 
    GROUPING_ID(region_name, country_name, location_id) = 3
ORDER BY
    1
  , 2;