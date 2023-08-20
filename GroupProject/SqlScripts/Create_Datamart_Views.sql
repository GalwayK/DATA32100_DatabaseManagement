CREATE OR REPLACE VIEW donations_hierarchy_view AS
    SELECT
        postal_code,
        address,
        concat('$',
               SUM(donation_amount)) AS total_donation,
        COUNT(*)                     AS number_of_donation,
        concat('$',
               round(AVG(donation_amount),
                     2))             AS average_donation
    FROM
             fact_donation f
        JOIN dim_address a ON f.dim_address_id = a.dim_address_id
    GROUP BY
        CUBE(address,
             postal_code)
    HAVING ( ( GROUPING(address) = 0
               AND GROUPING(postal_code) = 0 )
             OR ( GROUPING(address) = 1
                  AND GROUPING(postal_code) = 1 )
             OR ( GROUPING(address) = 1
                  AND GROUPING(postal_code) = 0 ) );




CREATE OR REPLACE VIEW donations_date_view AS
SELECT
    year,
    month_name,
    day_of_week,
    COUNT(*)                     AS number_of_donation,
    concat('$',
           SUM(donation_amount)) AS total_donation
FROM
         fact_donation f
    JOIN dim_donation_date d ON f.dim_date_id = d.dim_date_id
GROUP BY
    CUBE(year,
         month_name,
         day_of_week)
HAVING ( GROUPING(year) = 0
         AND GROUPING(month_name) = 1
         AND GROUPING(day_of_week) = 1 )
       OR ( GROUPING(year) = 1
            AND GROUPING(month_name) = 0
            AND GROUPING(day_of_week) = 1 )
       OR ( GROUPING(year) = 1
            AND GROUPING(month_name) = 1
            AND GROUPING(day_of_week) = 0 )
       OR ( GROUPING(year) = 1
            AND GROUPING(month_name) = 1
            AND GROUPING(day_of_week) = 1 )
ORDER BY
    1,
    EXTRACT(MONTH FROM TO_DATE(month_name, 'Month')),
    3 ASC;


CREATE OR REPLACE VIEW donations_volunteers_view AS
    SELECT
        leader_name,
        volunteer_name,
        COUNT(*)                     AS number_of_donation,
        concat('$',
               SUM(donation_amount)) AS total_donation_amount,
        concat('$',
               round(AVG(donation_amount),
                     2))             AS average_donation
    FROM
             fact_donation f
        JOIN (
            SELECT
                v.dim_volunteer_id,
                vl.volunteer_name AS leader_name,
                v.volunteer_name
            FROM
                     dim_volunteer v
                JOIN dim_volunteer vl ON v.leader_id = vl.volunteer_id
        ) sum_v ON f.dim_volunteer_id = sum_v.dim_volunteer_id
    GROUP BY
        ROLLUP(leader_name,
               volunteer_name);