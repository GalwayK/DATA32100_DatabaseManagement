SET SERVEROUTPUT ON;

DROP SEQUENCE datamart.donor_id;

CREATE SEQUENCE datamart.donor_id INCREMENT BY 1 START WITH 1;

ALTER SEQUENCE datamart.donor_id RESTART;

DROP FUNCTION load_donor_data;

DROP PROCEDURE insert_donor_data;

// Function to Retrieve Donor Data
CREATE OR REPLACE FUNCTION prc.load_donor_data RETURN  ETLUser.arr_donors
    AUTHID current_user
AS
    p_arr_donors  ETLUser.arr_donors;
BEGIN
    SELECT
         ETLUser.r_donor(0, do.donor_name, do.donation_time)
    BULK COLLECT
    INTO p_arr_donors
    FROM
        (
            SELECT DISTINCT
                donor_first_name
                || ' '
                || donor_last_name                 AS donor_name
              , to_char(donation_date, 'HH:MI:DD') AS donation_time
            FROM
                prc.donation
        ) do;

    RETURN p_arr_donors;
END;
/

// Procedure to Insert Donor Data
CREATE OR REPLACE PROCEDURE insert_donor_data (
    v_arr_donors  ETLUser.arr_donors
)
    AUTHID current_user
AS
    v_donor_id      NUMBER;
    TYPE arr_donor_ids IS
        TABLE OF NUMBER;
    v_arr_donor_ids arr_donor_ids := arr_donor_ids();
BEGIN
    FOR i IN 1..v_arr_donors.last LOOP
        SELECT
            nvl((
                SELECT
                    dim_donor_id
                FROM
                    datamart.dim_donor
                WHERE
                        upper(name) = upper(v_arr_donors(i).donor_name)
                    AND donate_time = v_arr_donors(i).donation_date
            )
              , - 1)
        INTO v_donor_id
        FROM
            dual;

        v_arr_donor_ids.extend();
        v_arr_donor_ids(i) := v_donor_id;
    END LOOP;

    FOR i IN 1..v_arr_donors.last LOOP
        IF v_arr_donor_ids(i) = -1 THEN
            INSERT INTO datamart.dim_donor VALUES (
                datamart.donor_id.NEXTVAL
              , v_arr_donors(i).donor_name
              , v_arr_donors(i).donation_date
            );

        ELSE
            UPDATE datamart.dim_donor
            SET
                name = v_arr_donors(i).donor_name
            , donate_time = v_arr_donors(i).donation_date
            WHERE
                dim_donor_id = v_arr_donor_ids(i);

        END IF;
    END LOOP;

END;
/

SELECT
    *
FROM
    datamart.donor;

COMMIT;