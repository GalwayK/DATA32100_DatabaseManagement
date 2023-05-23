
-- Question 1.
CREATE OR REPLACE view 
    customer_contacts 
as SELECT DISTINCT
    em.first_name || ' ' || em.last_name as "employee_name",
    cu.name as "customer_name", 
    cu.address as "customer_address",
    co.first_name || ' ' || co.last_name as "contact_name", 
    co.phone as "contact_phone"
FROM 
    ot.customers cu
INNER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
INNER JOIN 
    ot.employees em 
ON 
    em.employee_id = od.salesman_id
INNER JOIN 
    ot.contacts co 
ON
    co.customer_id = cu.customer_id;
    
-- Queston 2.
SELECT 
    *
FROM 
    customer_contacts cc
WHERE 
    upper(substr("customer_address", -2)) = 'MN';
    
-- Question 3. a) With aggregate grouping
SELECT
    cu.name, 
    cu.address
FROM 
    ot.customers cu
LEFT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
WHERE 
    upper(substr(address, -2)) = 'MN'
HAVING 
    count(od.customer_id) = 0
GROUP BY 
    (cu.name, cu.address)
ORDER BY 
    cu.name;
    
-- Question 3. b) With MINUS set operation
SELECT 
    cu.name as "name", 
    cu.address as "address"
FROM 
    ot.customers cu
LEFT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
WHERE 
    upper(substr(cu.address, -2)) = 'MN'
MINUS SELECT 
    cu.name, 
    cu.address
FROM 
    ot.customers cu
RIGHT OUTER JOIN 
    ot.orders od
ON 
    cu.customer_id = od.customer_id
ORDER BY 
    "name";

-- Question 4. 
SELECT 
    pr.product_name, 
    sum(pr.list_price * oi.quantity) as "Total Value Sold", 
    round(avg(oi.unit_price), 2) as "Average Sold Price",
    sum(oi.quantity) as "Number of Products Sold",
    count(oi.product_id) as "Number of Orders Placed"
FROM 
    ot.products pr
INNER JOIN 
    ot.order_items oi
ON  
    oi.product_id = pr.product_id
WHERE 
    lower(pr.product_name) 
LIKE 
    '%kingston%'
GROUP BY 
    pr.product_name;
    
-- Question 5. 
SELECT 
    em.first_name || ' ' || em.last_name as "Employee Name",
    em.employee_id,
    CASE 
        WHEN    
            count(od.salesman_id) < 7
        THEN 
            'Low'
        WHEN 
            count(od.salesman_id) BETWEEN 7 AND 10 
        THEN 
            'Medium'
        WHEN 
            count(od.salesman_id) > 10
        THEN 'High'
    END AS "Performance Level"
FROM 
    ot.employees em
INNER JOIN 
    ot.orders od 
ON 
    em.employee_id = od.salesman_id
GROUP BY 
    (em.first_name,
    em.last_name,
    em.employee_id)
ORDER BY 
    count(od.salesman_id);

    

