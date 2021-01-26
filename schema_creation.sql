-- CREATE TABLE statements for the py-dango project (movie theater reservation system)

--account TABLE

CREATE TABLE account(
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    zip_code INTEGER(5) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created DATETIME DEFAULT NOW(),
    updated DATETIME ON UPDATE NOW()
);

-- INSERT FIRST ROW

INSERT INTO account (email, password, zip_code, first_name, last_name)
VALUES
('abby@gmail.com', SHA1('123abby'), 89123, 'Abby', 'Lee');

-- Verify
SELECT * FROM account;

-- Verify that the updated field works
UPDATE account
SET email = 'abbi@gmail.com'
WHERE email = 'abby@gmail.com';






