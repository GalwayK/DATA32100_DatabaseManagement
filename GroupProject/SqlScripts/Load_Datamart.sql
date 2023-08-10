DECLARE
    CURSOR c_donations IS
    SELECT
        *
    FROM
             prc.donation do
        INNER JOIN prc.address   ad
        ON ad.address_id = do.address_id
        INNER JOIN prc.volunteer vo
        ON do.volunteer_id = vo.volunteer_id;

    p_arr_volunteers arr_volunteers;
BEGIN
    dbms_output.put_line('Loading all data');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || sqlerrm);
        SELECT
            r_volunteer(vo.volunteer_id, vo.first_name
             || ' '
             || vo.last_name, vo.group_leader, le.first_name
               || ' '
               || le.last_name)
        BULK COLLECT
        INTO p_arr_volunteers
        FROM
            c_donations vo
            LEFT JOIN c_donations le
            ON vo.group_leader = le.volunteer_id;

END;
/

BEGIN
SELECT
    COUNT(*)
FROM
    prc.address;

SELECT
    COUNT(*)
FROM
    prc.donation;

SELECT
    COUNT(*)
FROM
    prc.volunteer;

SELECT
    *
FROM
         prc.donation do
    INNER JOIN prc.address   ad
    ON ad.address_id = do.address_id
    INNER JOIN prc.volunteer vo
    ON do.volunteer_id = vo.volunteer_id;