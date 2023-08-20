SELECT * FROM dba_audit_trail
ORDER BY extended_timestamp;

AUDIT SELECT TABLE, INSERT TABLE, DELETE TABLE, EXECUTE PROCEDURE 
      BY ACCESS WHENEVER NOT SUCCESSFUL;
    
CREATE INDEX index_cust_name 
ON c_customers (cust_first_name, cust_last_name));