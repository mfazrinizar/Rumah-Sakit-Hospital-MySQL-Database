USE rumah_sakit;

DELIMITER $$

CREATE FUNCTION generate_salted_password(input_password VARCHAR(255)) 
RETURNS VARCHAR(255) 
DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(8);
    SET salt = LEFT(SHA2(RAND(), 256), 8);  
    RETURN CONCAT(salt, SHA2(CONCAT(salt, input_password), 256)); 
END$$

CREATE FUNCTION verify_salted_password(stored_hash VARCHAR(255), input_password VARCHAR(255)) 
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(8);
    DECLARE computed_hash VARCHAR(255);
    
    SET salt = LEFT(stored_hash, 8);

    SET computed_hash = SHA2(CONCAT(salt, input_password), 256);

    IF stored_hash = CONCAT(salt, computed_hash) THEN
        RETURN 1;  
    ELSE
        RETURN 0;  
    END IF;
END$$

DELIMITER ;