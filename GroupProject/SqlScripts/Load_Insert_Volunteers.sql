SET SERVEROUTPUT ON;

DROP SEQUENCE datamart.volunteer_id;

CREATE SEQUENCE datamart.volunteer_id INCREMENT BY 1 START WITH 1;

ALTER SEQUENCE datamart.volunteer_id RESTART;

DROP FUNCTION load_volunteer_data;

DROP PROCEDURE insert_volunteer_data;

// Function to Retrieve Volunteer Data
CREATE OR REPLACE FUNCTION prc.load_volunteer_data RETURN etluser.arr_volunteers
    AUTHID current_user
AS
    p_arr_volunteers etluser.arr_volunteers;
BEGIN
    SELECT
        etluser.r_volunteer(vo.volunteer_id, vo.first_name
                                             || ' '
                                             || vo.last_name, vo.group_leader, le.first_name
                                                                               || ' '
                                                                               || le.last_name)
    BULK COLLECT
    INTO p_arr_volunteers
    FROM
        prc.volunteer vo
        LEFT JOIN prc.volunteer le
        ON vo.group_leader = le.volunteer_id
        INNER JOIN prc.donation  do
        ON vo.volunteer_id = do.volunteer_id;

    RETURN p_arr_volunteers;
END;
/

// Procedure to Insert Volunteer Data
CREATE OR REPLACE PROCEDURE insert_volunteer_data (
    v_arr_volunteers etluser.arr_volunteers
)
    AUTHID current_user
AS
    v_dim_id NUMBER;
BEGIN
    FOR i IN 1..v_arr_volunteers.last LOOP
        SELECT
            nvl((
                SELECT
                    dim_volunteer_id
                FROM
                    datamart.dim_volunteer
                WHERE
                    volunteer_id = v_arr_volunteers(i).volunteer_id
            )
              , - 1)
        INTO v_dim_id
        FROM
            dual;

        IF v_dim_id != -1 THEN
            UPDATE datamart.dim_volunteer
            SET
                volunteer_name = v_arr_volunteers(i).volunteer_name
            , leader_id = v_arr_volunteers(i).leader_id
            , leader_name = v_arr_volunteers(i).leader_name
            WHERE
                dim_volunteer_id = v_arr_volunteers(i).volunteer_id;

        ELSE
            INSERT INTO datamart.dim_volunteer VALUES (
                datamart.volunteer_id.NEXTVAL
              , v_arr_volunteers(i).volunteer_id
              , v_arr_volunteers(i).volunteer_name
              , v_arr_volunteers(i).leader_id
              , v_arr_volunteers(i).leader_name
            );

        END IF;

    END LOOP;
END;
/

COMMIT;