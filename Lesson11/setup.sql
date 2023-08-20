/* first - remove the tables - purging the recyclebin */

DROP TABLE c_products CASCADE CONSTRAINTS PURGE;
DROP TABLE c_customers CASCADE CONSTRAINTS PURGE;
DROP TABLE c_channels CASCADE CONSTRAINTS PURGE;
DROP TABLE c_countries CASCADE CONSTRAINTS PURGE;
DROP TABLE c_sales CASCADE CONSTRAINTS PURGE;
DROP TABLE c_costs CASCADE CONSTRAINTS PURGE;

/* next - copy the SH tables into our own schema - without any keys/indexes */

CREATE TABLE c_products
    AS
SELECT *
  FROM sh.products;

CREATE TABLE c_customers
    AS
SELECT *
  FROM sh.customers;

CREATE TABLE c_channels
    AS
SELECT *
  FROM sh.channels;

CREATE TABLE c_countries
    AS
SELECT *
  FROM sh.countries;

CREATE TABLE c_sales
    AS
SELECT *
  FROM sh.sales;

CREATE TABLE c_costs
    AS 
SELECT *
  FROM sh.costs;
