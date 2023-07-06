-- KyleGalwayDBAS32100Assignment3-5.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 5. Return the product count for all categories using the function
-- created in question 3.

SET SERVEROUTPUT ON;
SET VER OFF;

DECLARE
    no_categories_found EXCEPTION;
    CURSOR c_category_data IS
    SELECT
        category_name
      , nvl(count_category_products(category_name)
            , 0) AS product_count
    FROM
        ot.product_categories
    GROUP BY
        category_name;

BEGIN
    OPEN c_category_data;
    IF c_category_data%notfound THEN
        RAISE no_categories_found;
    END IF;
    CLOSE c_category_data;
    FOR category_data IN c_category_data LOOP
        dbms_output.put_line(category_data.category_name
                             || ': '
                             || category_data.product_count);
    END LOOP;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Error: Category does not exist!');
    WHEN no_categories_found THEN
        dbms_output.put_line('Error: No categories found!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error' || sqlerrm);
END;
/