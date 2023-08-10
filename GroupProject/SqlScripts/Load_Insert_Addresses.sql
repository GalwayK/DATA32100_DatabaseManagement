SET SERVEROUTPUT ON;

DROP SEQUENCE datamart.address_id;

CREATE SEQUENCE datamart.address_id INCREMENT BY 1 START WITH 1;

ALTER SEQUENCE datamart.address_id RESTART;

DROP FUNCTION load_address_data;

DROP PROCEDURE insert_address_data;

// Function to Retrieve Address Data
CREATE OR REPLACE FUNCTION prc.load_address_data RETURN etluser.arr_addresses
    AUTHID current_user
AS
    p_arr_addresses etluser.arr_addresses;
BEGIN
    SELECT
        etluser.r_address(adr.address_id, adr.unit_num, adr.street_number, adr.street_name, adr.street_type
                        , adr.street_direction, adr.postal_code, adr.city, adr.province)
    BULK COLLECT
    INTO p_arr_addresses
    FROM
        (
            SELECT DISTINCT
                ad.address_id
              , ad.unit_num
              , ad.street_number
              , ad.street_name
              , ad.street_type
              , ad.street_direction
              , ad.postal_code
              , ad.city
              , ad.province
            FROM
                     prc.address ad
                INNER JOIN prc.donation do
                ON do.address_id = ad.address_id
            WHERE 
                ad.street_number IS NOT NULL 
            AND 
                ad.street_name IS NOT NULL 
            AND 
                ad.postal_code IS NOT NULL 
            AND 
                ad.city IS NOT NULL 
            AND    
                ad.province IS NOT NULL
        ) adr;

    RETURN p_arr_addresses;
END;
/

// Function to Retrieve Address Data
CREATE OR REPLACE FUNCTION datamart.combine_address_fields (
    v_address etluser.r_address
) RETURN VARCHAR2
    AUTHID current_user
AS
    v_full_address     VARCHAR(255);
    v_street_type      VARCHAR2(50);
    v_street_direction VARCHAR2(50);
BEGIN
    v_full_address := '';
    IF v_address.street_type IS NULL THEN
        v_street_type := '';
    ELSE
        v_street_type := ' ' || v_address.street_type;
    END IF;

    IF v_address.street_direction IS NULL THEN
        v_street_direction := '';
    ELSE
        v_street_direction := ' ' || v_address.street_direction;
    END IF;

    v_full_address := trim(v_address.street_number
                           || ' '
                           || v_address.street_name
                           || v_street_type);

    v_full_address := trim(v_full_address
                           || ' '
                           || v_street_direction);
    v_full_address := v_full_address
                      || ' '
                      || v_address.city
                      || ' '
                      || v_address.province;

    RETURN v_full_address;
END;
/

// Procedure to Insert Address Data
CREATE OR REPLACE PROCEDURE datamart.insert_address_data (
    v_addresses etluser.arr_addresses
)
    AUTHID current_user
AS
    v_address_id   NUMBER;
    v_full_address VARCHAR(255);
    v_postal_code  CHAR(7);
    v_dim_id       NUMBER;
BEGIN
    FOR i IN 1..v_addresses.last LOOP
        v_address_id := v_addresses(i).address_id;
        v_postal_code := v_addresses(i).postal_code;
        v_full_address := combine_address_fields(v_addresses(i));
        SELECT
            nvl((
                SELECT
                    dim_address_id
                FROM
                    datamart.dim_address
                WHERE
                    address_id = v_addresses(i).address_id
            )
              , - 1)
        INTO 
            v_dim_id
        FROM
            dual;

        IF v_dim_id != -1 THEN
            UPDATE datamart.dim_address
            SET
            address = v_full_address
            , postal_code = v_postal_code
            WHERE
                address_id = v_address_id
            AND 
                dim_address_id = v_dim_id;

        ELSE
            INSERT INTO datamart.dim_address VALUES (
                datamart.address_id.NEXTVAL,
                v_address_id
              , v_full_address
              , v_postal_code
            );

        END IF;

    END LOOP;
END;
/

COMMIT;