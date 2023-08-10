// Create a user named ETLUser with the following permission: 
// 1. Give the user permissions to read all Central Donation Repository data. 
// 2. Give the user write and update permissions to the DataMart tables.

CREATE USER etluser IDENTIFIED BY extracttransformload32100; 
    
// Create User Role

CREATE ROLE extract_transform_load_user;

GRANT connect TO extract_transform_load_user;

GRANT
    CREATE SESSION
TO extract_transform_load_user;

GRANT resource TO extract_transform_load_user;

GRANT
    EXECUTE ANY TYPE
TO extract_transform_load_user; 

// Create Task Role

CREATE ROLE read_repository_data;

GRANT
    SELECT ANY TABLE
TO read_repository_data;

GRANT SELECT ON prc.address TO read_repository_data;

GRANT SELECT ON prc.donation TO read_repository_data;

GRANT SELECT ON prc.volunteer TO read_repository_data;

CREATE ROLE update_insert_data_mart;

GRANT UPDATE, INSERT ON datamart.dim_address TO update_insert_data_mart;

GRANT UPDATE, INSERT ON datamart.fact_donation TO update_insert_data_mart;

GRANT UPDATE, INSERT ON datamart.dim_donation_date TO update_insert_data_mart;

GRANT UPDATE, INSERT ON datamart.dim_donor TO update_insert_data_mart;

GRANT UPDATE, INSERT ON datamart.dim_volunteer TO update_insert_data_mart;

// Assign Object Permissions to Users

CREATE ROLE execute_datamart_functions;

GRANT EXECUTE ON datamart.insert_address_data TO execute_datamart_functions;

GRANT EXECUTE ON datamart.insert_volunteer_data TO execute_datamart_functions;

GRANT EXECUTE ON datamart.insert_donor_data TO execute_datamart_functions;

GRANT EXECUTE ON datamart.insert_date_data TO execute_datamart_functions;

GRANT EXECUTE ON datamart.insert_donation_data TO execute_datamart_functions;

GRANT EXECUTE ON datamart.combine_address_fields TO execute_datamart_functions;

CREATE ROLE execute_datamart_sequences;

GRANT SELECT, ALTER ON datamart.volunteer_id TO etluser;

GRANT SELECT, ALTER ON datamart.donation_id TO etluser;

GRANT SELECT, ALTER ON datamart.date_id TO etluser;

GRANT SELECT, ALTER ON datamart.donor_id TO etluser;

GRANT SELECT, ALTER ON datamart.address_id TO etluser;

CREATE ROLE execute_prc_functions;

GRANT EXECUTE ON prc.load_address_data TO execute_prc_functions;

GRANT EXECUTE ON prc.load_volunteer_data TO execute_prc_functions;

GRANT EXECUTE ON prc.load_donor_data TO execute_prc_functions;

GRANT EXECUTE ON prc.load_date_data TO execute_prc_functions;

GRANT EXECUTE ON prc.load_donation_data TO execute_prc_functions;

CREATE ROLE extract_transform_load_objects;

GRANT EXECUTE ON etluser.r_donation TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.arr_donations TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.r_address TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.arr_addresses TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.r_volunteer TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.arr_volunteers TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.r_donor TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.arr_donors TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.r_date TO extract_transform_load_objects;

GRANT EXECUTE ON etluser.arr_dates TO extract_transform_load_objects;

// Assign Task Roles to User Role 

GRANT read_repository_data TO extract_transform_load_user;

GRANT update_insert_data_mart TO extract_transform_load_user;

GRANT execute_datamart_functions TO extract_transform_load_user;

GRANT execute_prc_functions TO extract_transform_load_user;

GRANT extract_transform_load_objects TO datamart;

GRANT extract_transform_load_objects TO prc;

// Assign User Role to User 

-- Grant other users access to ETLUser's Necessary Objects
-- Assigned directly to allow use in functions and procedures

GRANT extract_transform_load_user TO etluser; 

GRANT EXECUTE ON etluser.r_donation TO datamart;

GRANT EXECUTE ON etluser.arr_donations TO datamart;

GRANT EXECUTE ON etluser.r_address TO datamart;

GRANT EXECUTE ON etluser.arr_addresses TO datamart;

GRANT EXECUTE ON etluser.r_volunteer TO datamart;

GRANT EXECUTE ON etluser.arr_volunteers TO datamart;

GRANT EXECUTE ON etluser.r_donor TO datamart;

GRANT EXECUTE ON etluser.arr_donors TO datamart;

GRANT EXECUTE ON etluser.r_date TO datamart;

GRANT EXECUTE ON etluser.arr_dates TO datamart;

GRANT EXECUTE ON etluser.r_donation TO prc;

GRANT EXECUTE ON etluser.arr_donations TO prc;

GRANT EXECUTE ON etluser.r_address TO prc;

GRANT EXECUTE ON etluser.arr_addresses TO prc;

GRANT EXECUTE ON etluser.r_volunteer TO prc;

GRANT EXECUTE ON etluser.arr_volunteers TO prc;

GRANT EXECUTE ON etluser.r_donor TO prc;

GRANT EXECUTE ON etluser.arr_donors TO prc;

GRANT EXECUTE ON etluser.r_date TO prc;

GRANT EXECUTE ON etluser.arr_dates TO prc;

--REVOKE  SELECT ON prc.address FROM ETLUser; 
--
--REVOKE  SELECT ON prc.donation FROM ETLUser; 
--
--REVOKE  SELECT ON prc.volunteer FROM ETLUser; 
--
--REVOKE  INSERT ON datamart.address FROM ETLUser; 
--
--REVOKE  INSERT ON datamart.donation FROM ETLUser; 
--
--REVOKE  INSERT ON datamart.donation_date FROM ETLUser;
--
--REVOKE  INSERT ON datamart.donor FROM ETLUser; 
--
--REVOKE  INSERT ON datamart.volunteer FROM ETLUser; 
--
--REVOKE  UPDATE ON datamart.address FROM ETLUser; 
--
--REVOKE UPDATE ON datamart.donation FROM ETLUser; 
--
--REVOKE UPDATE ON datamart.donation_date FROM ETLUser; 
--
--REVOKE UPDATE ON datamart.donor FROM ETLUser; 
--
--REVOKE UPDATE ON datamart.volunteer FROM ETLUser; 
--
--REVOKE SELECT ON datamart.donor FROM ETLUser;
--
--REVOKE SELECT ON datamart.donation_date FROM ETLUser;
--
--REVOKE SELECT ON datamart.address FROM ETLUser;
--
--REVOKE SELECT ON datamart.volunteer FROM ETLUser;
--
--REVOKE SELECT ON datamart.donation FROM ETLUser;
--
--REVOKE DELETE ON datamart.donor FROM ETLUser;
--
--REVOKE DELETE ON datamart.donation_date FROM ETLUser;
--
--REVOKE DELETE ON datamart.address FROM ETLUser;
--
--REVOKE DELETE ON datamart.volunteer FROM ETLUser;
--
--REVOKE DELETE ON datamart.donation FROM ETLUser;

COMMIT;