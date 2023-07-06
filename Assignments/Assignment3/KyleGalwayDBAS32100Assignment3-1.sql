-- Question 1. Create a stored procedure that can be used to find the number of 
-- orders and the total money a customer has spent on all items per order. 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE count_customer_orders (
    pl_customer_name IN VARCHAR2
) AS
    TYPE r_order_details IS RECORD (
            customer_name VARCHAR2(255)
        , total_orders  NUMBER
        , total_price   NUMBER
    );
    v_order_details r_order_details;
BEGIN
    SELECT
        c.name                     AS customer_name
      , COUNT(DISTINCT o.order_id) AS total_orders
      , SUM(oi.unit_price)         AS "total_price"
    INTO 
        v_order_details
    FROM
             ot.orders o
        INNER JOIN ot.order_items oi
        ON o.order_id = oi.order_id
        INNER JOIN ot.customers   c
        ON o.customer_id = c.customer_id
    WHERE
        name = pl_customer_name 
    GROUP BY
        name;
        
    IF SQL%FOUND THEN
        dbms_output.put_line('Customer Name: ' || v_order_details.customer_name
             || CHR(32) || 'Number of Orders: ' || v_order_details.total_orders
             || chr(32) || 'Price of Orders: ' || '$' || v_order_details.total_price);
    ELSE 
        DBMS_OUTPUT.PUT_LINE(v_order_details.customer_name || ' has placed no orders.');
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE(v_order_details.customer_name || ' has placed no orders.');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

ACCEPT p_customer_name PROMPT 'Please enter your name: ';

DECLARE
    v_customer_name VARCHAR2(255) := '&p_customer_name';
    TYPE r_order_details IS RECORD (
            customer_name VARCHAR2(255)
        , total_orders  NUMBER
        , total_price   NUMBER
    );
    v_order_details r_order_details;
BEGIN
    count_customer_orders('&p_customer_name');
END;
/

ACCEPT p_state_initials PROMPT 'Please enter the intials of a state';
DECLARE 
    v_state_initials VARCHAR(20) := '&p_state_initials';
    TOO_MANY_CHARACTERS EXCEPTION;
    TYPE arr_customer_names IS TABLE OF ot.customers.name%TYPE;
    v_arr_customer_names arr_customer_names;
BEGIN 
    IF LENGTH(v_state_initials) > 2 THEN 
        RAISE TOO_MANY_CHARACTERS;
    END IF;

    SELECT DISTINCT 
        name 
    BULK COLLECT INTO 
        v_arr_customer_names 
    FROM 
        ot.customers c
    INNER JOIN 
        ot.orders o
    ON 
        c.customer_id = o.customer_id
    WHERE 
        substr(address, -2) = v_state_initials;
        
    FOR i IN 1..v_arr_customer_names.COUNT LOOP 
        count_customer_orders(v_arr_customer_names(i));
    END LOOP;
        
EXCEPTION 
    WHEN TOO_MANY_CHARACTERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Invalid State Initials');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SELECT
    customer_id, 
    name, 
    substr(address, -2) as state
FROM 
    ot.customers;
