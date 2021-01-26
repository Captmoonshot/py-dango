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
--      Make sure to use the SHA1 hashing algorithm to protect passwords
INSERT INTO account (email, password, zip_code, first_name, last_name)
VALUES
('abby@gmail.com', SHA1('123abby'), 89123, 'Abby', 'Lee');

-- Verify
SELECT * FROM account;

-- Verify that the updated field works
UPDATE account
SET email = 'abbi@gmail.com'
WHERE email = 'abby@gmail.com';

-- Insert more account data
INSERT INTO account (email, password, zip_code, first_name, last_name)
VALUES
('bobbi@gmail.com', SHA1('123bobbi'), 89123, 'Bobbi', 'Lee'),
('cathi@gmail.com', SHA1('123cathi'), 89123, 'Cathi', 'Lee'),
('dicki@gmail.com', SHA1('123dicki'), 89128, 'Dicki', 'Lee'),
('Eeri@gmail.com', SHA1('123eeri'), 89128, 'Eeri', 'Lee'),
('Fendi@gmail.com', SHA1('123fendi'), 89128, 'Fendi', 'Lee');


-- director TABLE

CREATE TABLE director (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- INSERT data

INSERT INTO director (first_name, last_name)
VALUES
('Martin', 'Scorsese'),
('Quentin', 'Tarantino'),
('Steven', 'Spielberg'),
('Stanley', 'Kubrick'),
('Christopher', 'Nolan'),
('Ridley', 'Scott');

SELECT * FROM director;

-- Results
-- +-------------+-------------+-----------+
-- | director_id | first_name  | last_name |
-- +-------------+-------------+-----------+
-- |           1 | Martin      | Scorsese  |
-- |           2 | Quentin     | Tarantino |
-- |           3 | Steven      | Spielberg |
-- |           4 | Stanley     | Kubrick   |
-- |           5 | Christopher | Nolan     |
-- |           6 | Ridley      | Scott     |
-- +-------------+-------------+-----------+

-- actor TABLE

CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_day DATE,
    age INT
);

-- Create a Trigger for to automatically calculate age from the birth_day attribute

DELIMITER $$

CREATE TRIGGER before_actor_insert
BEFORE INSERT ON actor
FOR EACH ROW
BEGIN
    SET NEW.age = ROUND(DATEDIFF(CURDATE(), NEW.birth_day) / 365.25, 0);
END $$

DELIMITER ;

-- Verify the trigger exists
SHOW TRIGGERS;

-- Verify the trigger works
INSERT INTO actor (first_name, last_name, birth_day)
VALUES
('Tom', 'Hardy', '1977-09-15');

SELECT * FROM actor;

-- RESULT
-- +----------+------------+-----------+------------+------+
-- | actor_id | first_name | last_name | birth_day  | age  |
-- +----------+------------+-----------+------------+------+
-- |        3 | Tom        | Hardy     | 1977-09-15 |   43 |
-- +----------+------------+-----------+------------+------+


-- Insert more actors

INSERT INTO actor (first_name, last_name, birth_day)
VALUES
('Christian', 'Bale', '1974-01-30'),
('Anne', 'Hathaway', '1982-11-12'),
('Cillian', 'Murphy', '1976-05-25'),
('Marion', 'Cotillard', '1975-09-30'),
('Joseph', 'Levitt', '1981-02-17');

-- Results
-- +----------+------------+-----------+------------+------+
-- | actor_id | first_name | last_name | birth_day  | age  |
-- +----------+------------+-----------+------------+------+
-- |        3 | Tom        | Hardy     | 1977-09-15 |   43 |
-- |        4 | Christian  | Bale      | 1974-01-30 |   47 |
-- |        5 | Anne       | Hathaway  | 1982-11-12 |   38 |
-- |        6 | Cillian    | Murphy    | 1976-05-25 |   45 |
-- |        7 | Marion     | Cotillard | 1975-09-30 |   45 |
-- |        8 | Joseph     | Levitt    | 1981-02-17 |   40 |
-- +----------+------------+-----------+------------+------+


-- movie_category TABLE

CREATE TABLE movie_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50)
);

INSERT INTO movie_category (category_name)
VALUES
('Drama'),
('Action'),
('Horror'),
('Scifi'),
('Romance'),
('Comedy');

SELECT * FROM movie_category;

-- Results
-- +-------------+---------------+
-- | category_id | category_name |
-- +-------------+---------------+
-- |           1 | Drama         |
-- |           2 | Action        |
-- |           3 | Horror        |
-- |           4 | Scifi         |
-- |           5 | Romance       |
-- |           6 | Comedy        |
-- +-------------+---------------+

-- movie TABLE

CREATE TABLE movie (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    year VARCHAR(5),
    rating VARCHAR(5),
    length_min INT(5),
    description TEXT,
    director_id INT,
    category_id INT,
    start_date DATE,
    end_date DATE,
    active BOOLEAN,
    FOREIGN KEY (director_id) REFERENCES director(director_id)
    ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES movie_category(category_id)
    ON DELETE RESTRICT
);

-- Create a Trigger for `active` field based on start_date and end_date
-- if NOW() within start_date and end_date, then true, else false

DELIMITER $$

CREATE TRIGGER before_movie_insert
BEFORE INSERT ON movie
FOR EACH ROW
BEGIN
    IF NOW() BETWEEN NEW.start_date AND NEW.end_date
    THEN SET NEW.active = true;
    ELSE SET NEW.active = false;

    END IF;
END $$

DELIMITER ;

-- Insert a movie

INSERT INTO movie (
    title,
    year,
    rating,
    length_min,
    description,
    director_id,
    category_id,
    start_date,
    end_date
)
VALUES
('Interstellar', '2014', 'PG-13', 169, 'Apocalypse, Black Hole, Time Travel, Astronauts',
5, 4, '2021-1-7', '2021-07-07');

-- Verify
SELECT * FROM movie;

-- Insert  more movie data
INSERT INTO movie (
    title,
    year,
    rating,
    length_min,
    description,
    director_id,
    category_id,
    start_date,
    end_date
)
VALUES
('The Departed', '2006', 'R', 151, 'Irish Gangsters, Boston, Betrayal, Cops, Revenge',
1, 1, '2020-11-1', '2021-01-01'),
('Pulp Fiction', '1994', 'R', 178, 'Boxing, Robbery, Hitmen, Samuel L. Jackson',
2, 1, '2020-12-25', '2021-12-15'),
('Jurassic Park', '1993', 'PG-13', 127, 'Dinosaurs, DNA, T-Rex, Velociraptor, Chaos',
3, 4, '2020-11-15', '2021-07-04'),
('A Clockwork Orange', '1971', 'R', 136, 'Crazy, Crime, Future, Dystopian',
4, 4, '2021-01-01', '2021-05-05'),
('Aliens', '1986', 'R', 137, 'Aliens, Eat People, Spaceship, Future',
6, 3, '2021-01-01', '2021-05-05');










