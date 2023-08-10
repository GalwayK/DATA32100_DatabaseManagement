SET SERVEROUTPUT ON;

DROP SEQUENCE datamart.date_id;

CREATE SEQUENCE datamart.date_id INCREMENT BY 1 START WITH 1;

ALTER SEQUENCE datamart.date_id RESTART;

DROP FUNCTION load_date_data;

DROP PROCEDURE insert_date_data;

// Function to Retrieve Date Data
CREATE OR REPLACE FUNCTION prc.load_date_data RETURN  ETLUser.arr_dates
    AUTHID current_user
AS
    p_arr_dates  ETLUser.arr_dates;
BEGIN
    SELECT
         ETLUser.r_date(0, ad.donation_date)
    BULK COLLECT
    INTO p_arr_dates
    FROM
        (
            SELECT DISTINCT
                to_char(donation_date) AS donation_date
            FROM
                prc.donation
        ) ad;

    RETURN p_arr_dates;
END;
/

// Procedure to Insert Date Data
CREATE OR REPLACE PROCEDURE datamart.insert_date_data (
    v_arr_dates  ETLUser.arr_dates
)
    AUTHID current_user
AS

    v_day_of_week  VARCHAR(10);
    v_year         NUMBER;
    v_month_name   VARCHAR(255);
    v_month_number NUMBER;
    v_date         VARCHAR(20);
    v_date_id      NUMBER;
    TYPE arr_date_ids IS
        TABLE OF NUMBER;
    v_arr_date_ids arr_date_ids := arr_date_ids();
BEGIN
    FOR i IN 1..v_arr_dates.last LOOP
        SELECT
            nvl((
                SELECT
                    dim_date_id
                FROM
                    datamart.dim_donation_date
                WHERE
                    donation_date = to_char(v_arr_dates(i).donation_date)
            )
              , - 1)
        INTO v_date_id
        FROM
            dual;

        v_arr_date_ids.extend();
        v_arr_date_ids(i) := v_date_id;
    END LOOP;

    FOR i IN 1..v_arr_dates.last LOOP
        v_date := to_char(v_arr_dates(i).donation_date);
        v_month_name := to_char(v_arr_dates(i).donation_date, 'MONTH');
        v_month_number := TO_NUMBER ( to_char(v_arr_dates(i).donation_date
                                            , 'MM') );
        v_day_of_week := to_char(v_arr_dates(i).donation_date, 'DAY');
        v_year := TO_NUMBER ( to_char(v_arr_dates(i).donation_date
                                    , 'YYYY') );
        IF v_arr_date_ids(i) = -1 THEN
            INSERT INTO datamart.dim_donation_date VALUES (
                datamart.date_id.NEXTVAL
              , v_date
              , v_month_number
              , v_month_name
              , v_year
              , v_day_of_week
            );

        ELSE
            UPDATE datamart.dim_donation_date
            SET
                donation_date = v_date
            , month_number = v_month_number
            , month_name = v_month_name
            , year = v_year
            , day_of_week = v_day_of_week
            WHERE
                dim_date_id = v_arr_date_ids(i);

        END IF;

    END LOOP;

END;
/

COMMIT;