SET SERVEROUTPUT ON; 

// Master Code Block to Run All Procedures 
DECLARE
    p_arr_volunteers ETLUser.arr_volunteers;
    p_arr_donors ETLUser.arr_donors;
    p_arr_addresses ETLUser.arr_addresses;
    p_arr_dates ETLUser.arr_dates;
    p_arr_donations ETLUser.arr_donations;
BEGIN

    -- Volunteer Data
    dbms_output.put_line(CHR(10) || 'Loading volunteer data...');
    p_arr_volunteers := prc.load_volunteer_data();
    dbms_output.put_line('Volunteer data found!');
    dbms_output.put_line('Loading volunteer database into Data Mart...');
    datamart.insert_volunteer_data(p_arr_volunteers);
    dbms_output.put_line('Volunteer data insertion successful!');

    -- Donor Data
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Loading donor data...');
    p_arr_donors := prc.load_donor_data();
    DBMS_OUTPUT.PUT_LINE('Donor data found!');
    DBMS_OUTPUT.PUT_LINE('Inserting Donor data into Data Mart...');
    datamart.insert_donor_data(p_arr_donors);
    DBMS_OUTPUT.PUT_LINE('Donor data insertion successful!');
    
    -- Address Data
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Loading address data...');
    p_arr_addresses := prc.load_address_data();
    DBMS_OUTPUT.PUT_LINE('Address data found!');
    DBMS_OUTPUT.PUT_LINE('Inserting Address data into Data Mart...');
    datamart.insert_address_data(p_arr_addresses);
    DBMS_OUTPUT.PUT_LINE('Address data insertion successful!');
    
    -- Date Data 
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Loading date data...');
     p_arr_dates := prc.load_date_data();
    DBMS_OUTPUT.PUT_LINE('Date data found!');
    DBMS_OUTPUT.PUT_LINE('Inserting Date data into Data Mart...');
    datamart.insert_date_data(p_arr_dates);
    DBMS_OUTPUT.PUT_LINE('Date data insertion successful!');
    
    -- Donation Data 
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Loading donation data...');
    p_arr_donations := prc.load_donation_data();
    DBMS_OUTPUT.PUT_LINE('Donation data found!');
    DBMS_OUTPUT.PUT_LINE('Inserting Donation data into Data Mart...');
    datamart.insert_donation_data(p_arr_donations);
    DBMS_OUTPUT.PUT_LINE('Donation data insertion successful!');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

COMMIT;