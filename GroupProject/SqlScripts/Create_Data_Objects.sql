DROP TYPE arr_volunteers; 

DROP TYPE r_volunteer;

DROP TYPE arr_addresses;

DROP TYPE r_address;

DROP TYPE arr_donors; 

DROP TYPE r_donor; 

DROP TYPE arr_dates;

DROP TYPE r_date;

DROP TYPE arr_donations;

DROP TYPE r_donation;

CREATE OR REPLACE TYPE r_volunteer IS OBJECT (
        volunteer_id NUMBER(38, 0), 
        volunteer_name VARCHAR(50), 
        leader_id NUMBER(38, 0), 
        leader_name VARCHAR(50)
);
/

CREATE OR REPLACE TYPE arr_volunteers IS TABLE OF r_volunteer;
/

CREATE OR REPLACE TYPE r_address IS OBJECT (
        address_id NUMBER, 
        unit_number VARCHAR2(6 BYTE),
        street_number NUMBER,
        street_name VARCHAR2(24 BYTE),
        street_type VARCHAR2(12 BYTE),
        street_direction CHAR(1 BYTE),
        postal_code CHAR(7 BYTE),
        city VARCHAR2(16 BYTE),
        province CHAR(2 BYTE)
);
/

CREATE OR REPLACE TYPE arr_addresses IS TABLE OF r_address;
/

CREATE OR REPLACE TYPE r_donor IS OBJECT (
    donor_id NUMBER,
    donor_name VARCHAR(50), 
    donation_date VARCHAR(10)
);
/

CREATE OR REPLACE TYPE arr_donors IS TABLE OF r_donor;
/

CREATE OR REPLACE TYPE r_date IS OBJECT (
    date_id NUMBER,
    donation_date DATE
);
/

CREATE OR REPLACE TYPE arr_dates IS TABLE OF r_date;
/

CREATE OR REPLACE TYPE r_donation iS OBJECT 
(
    donation_id NUMBER, 
    donor_name VARCHAR2(32), 
    donation_date DATE, 
    donation_amount NUMBER(7, 2), 
    type_of_donation VARCHAR2(12), 
    address_id NUMBER, 
    volunteer_id NUMBER
);
/

CREATE OR REPLACE TYPE arr_donations IS TABLE OF r_donation;
/

COMMIT;
