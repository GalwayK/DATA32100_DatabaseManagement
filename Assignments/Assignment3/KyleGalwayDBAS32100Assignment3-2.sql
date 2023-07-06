-- KyleGalwayDBAS32100Assignment3-2.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 2. Write an anonymous block that will prompt a user to enter the 
-- abbreviation of their state and then use the procedure in question 1 to 
-- display the customer name, number of orders, and total amount spent by 
-- each customer of that state ONLY IF that customer has placed any orders.

SET SERVEROUTPUT ON;
SET VER OFF;

ACCEPT p_state_initials PROMPT 'Please enter the intials of a state';

DECLARE
    v_state_initials     VARCHAR(20) := '&p_state_initials';
    too_many_characters EXCEPTION;
    no_customers_found EXCEPTION;
    TYPE arr_customer_names IS
        TABLE OF ot.customers.name%TYPE;
    v_arr_customer_names arr_customer_names;
    v_total_orders       NUMBER;
    v_total_price        NUMBER;
BEGIN
    IF length(v_state_initials) > 2 THEN
        RAISE too_many_characters;
    END IF;
    SELECT DISTINCT
        name
    BULK COLLECT
    INTO v_arr_customer_names
    FROM
             ot.customers c
        INNER JOIN ot.orders o
        ON c.customer_id = o.customer_id
    WHERE
        lower(address) LIKE lower('%' || v_state_initials);

    IF v_arr_customer_names.count = 0 THEN
        RAISE no_customers_found;
    END IF;
    FOR i IN 1..v_arr_customer_names.count LOOP
        count_customer_orders(v_arr_customer_names(i), v_total_orders, v_total_price);
        dbms_output.put_line('Customer: '
                             || v_arr_customer_names(i)
                             || chr(9)
                             || 'Total Orders: '
                             || v_total_orders
                             || '    '
                             || 'Total Price: '
                             || v_total_price);

    END LOOP;

EXCEPTION
    WHEN too_many_characters THEN
        dbms_output.put_line('Error: Invalid State Initials');
    WHEN no_customers_found THEN
        dbms_output.put_line('No customers have placed an order in the selected state!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || sqlerrm);
END;
/