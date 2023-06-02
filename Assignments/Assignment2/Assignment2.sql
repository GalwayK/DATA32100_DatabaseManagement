SELECT 
    first_name, 
    last_name, 
    level 
FROM 
    ot.employees
WHERE 
    level != 1
START WITH 
    UPPER(first_name || last_name) = 'MOHAMMADPETERSON'
CONNECT BY PRIOR 
    manager_id = employee_id;
