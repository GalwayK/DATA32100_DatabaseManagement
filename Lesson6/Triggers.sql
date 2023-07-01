CREATE TABLE countries_log 
(
    operation varchar2(255), 
    username varchar(255), 
    operation_date DATE, 
    country_id CHAR(2), 
    country_name varchar2(255), 
    region_id NUMBER
);

CREATE OR REPLACE TRIGGER 
    insert_countries 
BEFORE INSERT ON 
    countries 
FOR EACH ROW 
    WHEN(NEW.country_id != UPPER(NEW.country_id))
BEGIN 
    :NEW.COUNTRY_ID := UPPER(:NEW.COUNTRY_ID);
END;
/

CREATE OR REPLACE TRIGGER 
    countries_insert_update_delete 
BEFORE DELETE OR INSERT OR UPDATE ON 
    countries 
FOR EACH ROW 
BEGIN 
    IF INSERTING THEN 
        INSERT INTO 
            countries_log 
        VALUES 
            ('INSERT', 
            user, 
            sysdate, 
            :NEW.country_id, 
            :new.country_name, 
            :new.region_id);
        ELSIF UPDATING THEN 
            INSERT INTO 
                countries_log 
            VALUES 
                ('UPDATE', 
                user, 
                sysdate, 
                :old.country_id, 
                :old.country_name, 
                :old.region_id);
        ELSE 
            INSERT INTO 
                countries_log 
            VALUES 
                ('DELETE', 
                user, 
                sysdate, 
                :old.country_id, 
                :old.country_name, 
                :old.region_id);
    END IF;
END;
/