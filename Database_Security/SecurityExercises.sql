show user;

// Exericse 12.1

CREATE USER galwayk_user1 
IDENTIFIED BY changesthis 
DEFAULT TABLESPACE users 
TEMPORARY TABLESPACE temp 
QUOTA UNLIMITED ON users;  

// Exercise 12.2

ALTER USER galwayk_user1
QUOTA 250M ON users;

ALTER USER galwayk_user1
IDENTIFIED BY secret;

// Exercise 12.3

GRANT CREATE TABLE, CREATE SESSION, CREATE USER to galwayk_user1 WITH ADMIN OPTION;

CREATE TABLE security_exercise_table 
(
    id number PRIMARY KEY
);

CREATE USER galwayk_user2
IDENTIFIED BY secret;

REVOKE CREATE TABLE, CREATE USER FROM galwayk_user1;

// Exercise 12.4

CREATE TABLE employee
(
    e_name VARCHAR(255), 
    salary NUMBER(6, 2)
);

INSERT INTO employee VALUES 
(
    'Bob', 4769
);

GRANT SELECT, UPDATE ON employee TO galwayk_user1 WITH GRANT OPTION;

REVOKE SELECT ON employee FROM galwayk_user1;

REVOKE UPDATE ON employee FROM galwayk_user1;
