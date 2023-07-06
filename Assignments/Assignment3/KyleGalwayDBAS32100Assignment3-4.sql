-- KyleGalwayDBAS32100Assignment3-4.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 4. Write an anonymous block that will prompt a category name and use
-- the function in question 3 to print the number of products in the category.

SET SERVEROUTPUT ON;
SET VER OFF;

ACCEPT p_category_name PROMPT 'Please enter a category name: ';

DECLARE
    v_category_name  ot.product_categories.category_name%TYPE := '&p_category_name';
    v_category_count NUMBER;
BEGIN
    SELECT
        nvl(count_category_products(category_name)
          , 0)
    INTO v_category_count
    FROM
        ot.product_categories
    WHERE
        lower(category_name) = lower(v_category_name);

    dbms_output.put_line('Category '
                         || v_category_name
                         || ' contains '
                         || v_category_count
                         || ' products.');

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Error: Category does not exist!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error' || sqlerrm);
END;
/