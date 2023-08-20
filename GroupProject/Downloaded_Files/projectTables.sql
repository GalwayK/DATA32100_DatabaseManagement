/******************************************************************************************
* projectTables.sql                                                                       *
* H.D.                                                                                    *
* s6                                                                                      *
* This script creates tables that will be used for the group project of DBAS32100 course  *
*******************************************************************************************/

--execute the commented out drop to drop the tables first if the tables have been created before
--DROP TABLE donation PURGE;
--DROP TABLE address PURGE;
--DROP TABLE volunteer PURGE;

/* 1. Address Table
This is an address lookup table. It has a list of all the known addresses */
CREATE TABLE address(
    address_id          NUMBER PRIMARY KEY
    ,unit_num           VARCHAR2(6)
    ,street_number      NUMBER NOT NULL
    ,street_name        VARCHAR2(24)NOT NULL
    ,street_type        VARCHAR2(12)NOT NULL
    ,street_direction   CHAR(1)
    ,postal_code        CHAR(7)
    ,city               VARCHAR2(16)NOT NULL
    ,province           CHAR(2)NOT NULL
    ,CONSTRAINT st_dir CHECK(street_direction IN('E' ,'W' ,'N' ,'S'))
);

/*2. Volunteer Table
This table has information on the volunteers */
CREATE TABLE volunteer(
    volunteer_id    NUMBER PRIMARY KEY
    ,first_name     VARCHAR2(16)
    ,last_name      VARCHAR2(16)
    ,group_leader
    ,CONSTRAINT fk_vol_lead FOREIGN KEY(group_leader)
        REFERENCES volunteer(volunteer_id)
);

/*3.	Donation table
Every row in this table is a donation made by a donor. Below is the script that creates donation table */
CREATE TABLE donation(
    don_id              NUMBER PRIMARY KEY
    ,donor_first_name   VARCHAR2(16)
    ,donor_last_name    VARCHAR2(16)
    ,donation_date      DATE NOT NULL
    ,donation_amount    NUMBER(7,2)NOT NULL
    ,type_of_donation   VARCHAR2(12)
    ,address_id NOT NULL
    ,volunteer_id NOT NULL
    ,CONSTRAINT fk_don_add FOREIGN KEY(address_id)
        REFERENCES address(address_id)
    ,CONSTRAINT fk_don_vol FOREIGN KEY(volunteer_id)
        REFERENCES volunteer(volunteer_id)
);

/*4 Insert data in volunteer table */
INSERT INTO volunteer
VALUES (100, 'Alexander', 'Hunold', null);

INSERT INTO volunteer
VALUES (111, 'Tommie', 'Ware', 100);

INSERT INTO volunteer
VALUES (112, 'Jami', 'Lee', 100);

INSERT INTO volunteer
VALUES (113, 'Jayne', 'Robinson', 100);

INSERT INTO volunteer
VALUES (114, 'Ethan', 'Sharp', 100);

INSERT INTO volunteer
VALUES (115, 'Kasey', 'Stuart', 100);

INSERT INTO volunteer
VALUES (200, 'Ismael', 'Sciarra', null);

INSERT INTO volunteer
VALUES (221, 'Eugenia', 'Kerr', 200);

INSERT INTO volunteer
VALUES (222, 'Ronald', 'Walls', 200);

INSERT INTO volunteer
VALUES (223, 'Elliott', 'Oconnell', 200);

INSERT INTO volunteer
VALUES (224, 'Dorian', 'Dunn', 200);

INSERT INTO volunteer
VALUES (225, 'Elijah', 'Snyder', 200);

INSERT INTO volunteer
VALUES (300, 'Anastasia', 'Taylor', null);

INSERT INTO volunteer
VALUES (331, 'Buster', 'Hogan', 300);

INSERT INTO volunteer
VALUES (332, 'Brendan', 'Obrien', 300);

INSERT INTO volunteer
VALUES (333, 'Elvis', 'Brewer', 300);

INSERT INTO volunteer
VALUES (334, 'Monroe', 'Fischer', 300);

INSERT INTO volunteer
VALUES (335, 'Karina', 'Haney', 300);

INSERT INTO volunteer
VALUES (400, 'Chrystal', 'Barnes', null);

INSERT INTO volunteer
VALUES (441, 'Ned', 'Maxwell', 400);

INSERT INTO volunteer
VALUES (442, 'Kareem', 'Fry', 400);

INSERT INTO volunteer
VALUES (443, 'Saundra', 'Oneal', 400);

INSERT INTO volunteer
VALUES (444, 'Keith', 'Houston', 400);

INSERT INTO volunteer
VALUES (445, 'Melva', 'Roy', 400);

COMMIT;