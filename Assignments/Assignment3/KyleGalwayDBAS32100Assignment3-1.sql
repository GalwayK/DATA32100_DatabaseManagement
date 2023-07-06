-- KyleGalwayDBAS32100Assignment3-1.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 1. Create a stored procedure that can be used to find the order 
-- count and the total money a customer has spent on all of their orders.

SET SERVEROUTPUT ON;
SET VER OFF;

CREATE OR REPLACE PROCEDURE count_customer_orders (
    pl_customer_name IN VARCHAR2
  , total_orders     OUT NUMBER
  , total_price      OUT NUMBER
) AS
BEGIN
    SELECT
        COUNT(DISTINCT o.order_id)
      , SUM(oi.unit_price)
    INTO
        total_orders
    , total_price
    FROM
             ot.orders o
        INNER JOIN ot.order_items oi
        ON o.order_id = oi.order_id
        INNER JOIN ot.customers   c
        ON o.customer_id = c.customer_id
    WHERE
        lower(name) = lower(pl_customer_name)
    GROUP BY
        name;

END;
/

ACCEPT p_customer_name PROMPT 'Please enter your name: ';
variable q_customer_name VARCHAR(255);

DECLARE
    -- v_customer_name VARCHAR2(255) := '&p_customer_name';
    v_total_orders NUMBER;
    v_total_price  NUMBER;
BEGIN
    :q_customer_name := '&p_customer_name';
    count_customer_orders(:q_customer_name, v_total_orders, v_total_price);
    dbms_output.put_line('Customer: '
                         || :q_customer_name
                         || chr(9)
                         || 'Total Orders: '
                         || v_total_orders
                         || '    '
                         || 'Total Price: '
                         || v_total_price);

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('The customer '
                             || :q_customer_name
                             || ' has placed no orders!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || sqlerrm);
END;
/