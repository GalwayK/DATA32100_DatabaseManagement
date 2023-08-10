SHOW USER;

DROP TABLE fact_donation;

DROP TABLE dim_donor;

DROP TABLE dim_address;

DROP TABLE dim_volunteer;

DROP TABLE dim_donation_date;

CREATE TABLE dim_donor (
    dim_donor_id    INTEGER PRIMARY KEY
    , name        VARCHAR2(50) NOT NULL
    , donate_time VARCHAR(10) NOT NULL
);

CREATE TABLE dim_address (
    dim_address_id INTEGER PRIMARY KEY,
    address_id  INTEGER NOT NULL
    , address     VARCHAR2(80) NOT NULL
    , postal_code CHAR(7) NOT NULL
);

CREATE TABLE dim_volunteer (
    dim_volunteer_id INTEGER PRIMARY KEY,
    volunteer_id   INTEGER NOT NULL
    , volunteer_name VARCHAR2(50)
    , leader_id      INTEGER
    , leader_name    VARCHAR2(50)
);

CREATE TABLE dim_donation_date (
    dim_date_id       INTEGER PRIMARY KEY
    , donation_date VARCHAR2(20)
    , month_number  INTEGER
    , month_name    VARCHAR2(10)
    , year          INTEGER
    , day_of_week   VARCHAR2(10)
);

CREATE TABLE fact_donation (
    dim_donation_id INTEGER PRIMARY KEY,
    donation_id     INTEGER NOT NULL
    , donation_amount NUMBER(7, 2) NOT NULL
    , payment_type    VARCHAR2(10) NOT NULL
    , dim_donor_id        INTEGER NOT NULL
    , dim_volunteer_id    INTEGER NOT NULL
    , dim_date_id         INTEGER
    , dim_address_id      INTEGER
    , CONSTRAINT fk_donor FOREIGN KEY ( dim_donor_id )
        REFERENCES dim_donor ( dim_donor_id )
    , CONSTRAINT fk_volunteer FOREIGN KEY ( dim_volunteer_id )
        REFERENCES dim_volunteer ( dim_volunteer_id )
    , CONSTRAINT fk_time FOREIGN KEY ( dim_date_id )
        REFERENCES dim_donation_date ( dim_date_id )
    , CONSTRAINT fk_address FOREIGN KEY ( dim_address_id )
        REFERENCES dim_address ( dim_address_id )
);

DELETE FROM datamart.fact_donation;

DELETE FROM datamart.dim_volunteer;

DELETE FROM datamart.dim_donor;

DELETE FROM datamart.dim_address;

DELETE FROM datamart.dim_donation_date;

COMMIT;