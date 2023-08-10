
CREATE OR REPLACE TRIGGER trigger_address_insert BEFORE
    INSERT ON address
    FOR EACH ROW
BEGIN 
    :NEW.street_name := INITCAP(:NEW.street_name);
    :NEW.street_type := INITCAP(:NEW.street_type);
    :NEW.street_direction := INITCAP(:new.street_direction);
    :NEW.city := INITCAP(:NEW.city);
    :NEW.province := UPPER(:NEW.province);
END ;
/

COMMIT;
