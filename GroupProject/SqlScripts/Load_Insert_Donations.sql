SET SERVEROUTPUT ON;

DROP SEQUENCE datamart.donation_id;

CREATE SEQUENCE datamart.donation_id INCREMENT BY 1 START WITH 1;

ALTER SEQUENCE datamart.donation_id RESTART;

DROP FUNCTION load_donation_data;

DROP PROCEDURE insert_donation_data;

// Function to Retrieve Donation Data
CREATE OR REPLACE FUNCTION prc.load_donation_data RETURN etluser.arr_donations
    AUTHID current_user
AS
    p_arr_donations etluser.arr_donations;
BEGIN
    SELECT
        etluser.r_donation(do.don_id, do.donor_name, do.donation_date, do.donation_amount, do.type_of_donation
                         , do.address_id, do.volunteer_id)
    BULK COLLECT
    INTO p_arr_donations
    FROM
        (
            SELECT DISTINCT
                don_id
              , donor_first_name
                  || ' '
                  || donor_last_name AS donor_name
              , donation_date
              , donation_amount
              , type_of_donation
              , address_id
              , volunteer_id
            FROM
                prc.donation
            WHERE
                don_id IS NOT NULL
                AND donor_first_name IS NOT NULL
                AND donor_last_name IS NOT NULL
                AND donation_date IS NOT NULL
                AND donation_amount IS NOT NULL
                AND type_of_donation IS NOT NULL
                AND address_id IS NOT NULL
                AND volunteer_id IS NOT NULL
        ) do;

    RETURN p_arr_donations;
END;
/

// Procedure to Insert Donation Data
CREATE OR REPLACE PROCEDURE datamart.insert_donation_data (
    v_arr_donations etluser.arr_donations
)
    AUTHID current_user
AS
    v_dim_id       NUMBER;
    v_donor_id     NUMBER;
    v_date_id      NUMBER;
    v_volunteer_id NUMBER;
    v_address_id   NUMBER;
    v_match_count  NUMBER;
BEGIN
    FOR i IN 1..v_arr_donations.last LOOP
        SELECT
            dim_donor_id
        INTO v_donor_id
        FROM
            datamart.dim_donor
        WHERE
                to_char(v_arr_donations(i).donation_date
                      , 'HH:MI:DD') = donate_time
            AND upper(v_arr_donations(i).donor_name) = upper(name);

        SELECT
            dim_date_id
        INTO v_date_id
        FROM
            datamart.dim_donation_date
        WHERE
            to_char(v_arr_donations(i).donation_date) = donation_date;

        SELECT
            dim_volunteer_id
        INTO v_volunteer_id
        FROM
            datamart.dim_volunteer
        WHERE
            volunteer_id = v_arr_donations(i).volunteer_id;

        SELECT
            dim_address_id
        INTO v_address_id
        FROM
            datamart.dim_address
        WHERE
            address_id = v_arr_donations(i).address_id;

        SELECT
            nvl((
                SELECT
                    dim_donation_id
                FROM
                    datamart.fact_donation
                WHERE
                    donation_id = v_arr_donations(i).donation_id
            )
              , - 1)
        INTO v_dim_id
        FROM
            dual;

        IF v_dim_id = -1 THEN
            INSERT INTO datamart.fact_donation VALUES (
                datamart.donation_id.nextval
              , v_arr_donations(i).donation_id
              , v_arr_donations(i).donation_amount
              , v_arr_donations(i).type_of_donation
              , v_donor_id
              , v_volunteer_id
              , v_date_id
              , v_address_id
            );

        ELSE
            UPDATE datamart.fact_donation
            SET
                donation_amount = v_arr_donations(i).donation_amount
            , payment_type = v_arr_donations(i).type_of_donation
            , dim_donor_id = v_donor_id
            , dim_volunteer_id = v_volunteer_id
            , dim_date_id = v_date_id
            , dim_address_id = v_address_id
            WHERE
                dim_donation_id = v_dim_id;

        END IF;

    END LOOP;
END;
/

COMMIT;