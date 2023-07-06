-- KyleGalwayDBAS32100Assignment3-3.sql
-- Kyle Galway 
-- s6_galwayk

-- Question 3. Write a fuction that takes a category name as a parameter and 
-- number of products which are contained in that category.

SET SERVEROUTPUT ON;
SET VER OFF;

CREATE OR REPLACE FUNCTION count_category_products (
    pl_category_name VARCHAR2
) RETURN NUMBER AS
    v_category_count NUMBER;
BEGIN
    SELECT
        COUNT(category_name)
    INTO v_category_count
    FROM
             ot.product_categories c
        INNER JOIN ot.products p
        ON c.category_id = p.category_id
    WHERE
        lower(category_name) = lower(pl_category_name);

    RETURN v_category_count;
END;
/