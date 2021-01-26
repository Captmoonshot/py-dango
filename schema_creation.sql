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


-- Insert more actor data
INSERT INTO actor (first_name, last_name, birth_day)
VALUES
('Matthew', 'McConaughey', '1969-11-04'),
('Sigourney', 'Weaver', '1949-10-08'),
('Matt', 'Damon', '1970-10-08'),
('Bruce', 'Willis', '1955-03-19'),
('Samuel', 'Jackson', '1948-12-21'),
('Macolm', 'McDowell', '1943-06-13');

-- Here we make a Many-To-Many Relation so I'm adding more data
-- Insert more movie data
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
('The Wolf of Wall Street', '2013', 'R', 180, 'Wall Street, Scam Artist, Drugs, Sex',
1, 1, '2020-04-06', '2021-01-01'),
('The Dark Knight', '2008', 'PG-13', 152, 'SuperHero, DC Comic, Gotham City, Dark',
5, 2, '2020-07-04', '2022-01-01'),
('Dunkirk', '2017', 'PG-13', 106, 'WW2, Evacuation, Winston Churchill, Fighter Pilots, Navy',
5, 1, '2020-04-06', '2022-01-01'),
('Inception', '2010', 'PG-13', 140, 'Dream, Sleep, Corporate Espionage, Faith, Uncertainty',
5, 1, '2020-04-06', '2022-01-01');


-- Create movie_actor TABLE is a Junction Table to connect the movie TABLE and actor TABLE 
-- in Many-To-Many Relationship

CREATE TABLE movie_actor (
    movie_id INT NOT NULL,
    actor_id INT NOT NULL,
    role VARCHAR(20),
    PRIMARY KEY(movie_id, actor_id),
    FOREIGN KEY(movie_id) REFERENCES movie(movie_id)
    ON DELETE CASCADE,
    FOREIGN KEY(actor_id) REFERENCES actor(actor_id)
    ON DELETE CASCADE
);

-- Insert movie and actor data
INSERT INTO movie_actor (movie_id, actor_id, role)
VALUES
(1, 5, 'Supporting'),
(1, 9, 'Primary'),
(1, 11, 'Supporting'),
(2, 11, 'Primary'),
(3, 12, 'Primary'),
(3, 13, 'Primary'),
(4, 13, 'Supporting'),
(5, 14, 'Primary'),
(6, 10, 'Primary'),
(7, 9, 'Supporting'),
(8, 5, 'Supporting'),
(9, 3, 'Primary'),
(10, 3, 'Supporting'),
(10, 7, 'Supporting'),
(10, 8, 'Supporting');

-- Use two INNER JOINs to with the movie_actor TABLE to see which actors were in
-- which movies

SELECT m.movie_id, m.title, a.actor_id, a.first_name, a.last_name, role
FROM movie m
INNER JOIN movie_actor
ON m.movie_id = movie_actor.movie_id
INNER JOIN actor a
ON a.actor_id = movie_actor.actor_id;

-- Result

-- +----------+-------------------------+----------+------------+-------------+------------+
-- | movie_id | title                   | actor_id | first_name | last_name   | role       |
-- +----------+-------------------------+----------+------------+-------------+------------+
-- |        1 | Interstellar            |        5 | Anne       | Hathaway    | Supporting |
-- |        1 | Interstellar            |        9 | Matthew    | McConaughey | Primary    |
-- |        1 | Interstellar            |       11 | Matt       | Damon       | Supporting |
-- |        2 | The Departed            |       11 | Matt       | Damon       | Primary    |
-- |        3 | Pulp Fiction            |       12 | Bruce      | Willis      | Primary    |
-- |        3 | Pulp Fiction            |       13 | Samuel     | Jackson     | Primary    |
-- |        4 | Jurassic Park           |       13 | Samuel     | Jackson     | Supporting |
-- |        5 | A Clockwork Orange      |       14 | Macolm     | McDowell    | Primary    |
-- |        6 | Aliens                  |       10 | Sigourney  | Weaver      | Primary    |
-- |        7 | The Wolf of Wall Street |        9 | Matthew    | McConaughey | Supporting |
-- |        8 | The Dark Knight         |        5 | Anne       | Hathaway    | Supporting |
-- |        9 | Dunkirk                 |        3 | Tom        | Hardy       | Primary    |
-- |       10 | Inception               |        3 | Tom        | Hardy       | Supporting |
-- |       10 | Inception               |        7 | Marion     | Cotillard   | Supporting |
-- |       10 | Inception               |        8 | Joseph     | Levitt      | Supporting |
-- +----------+-------------------------+----------+------------+-------------+------------+


-- Create theater TABLE

CREATE TABLE theater (
    theater_id INT AUTO_INCREMENT PRIMARY KEY,
    theater_name VARCHAR(50),
    ticket_price json,
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code INT,
    open TIME,
    close TIME
);

-- Insert theater data

INSERT INTO theater (theater_name, ticket_price, address, city, state, zip_code, open, close)
VALUES
('AMC Rainbow', '{"child": 5.99, "adult": 9.99}', '1234 Rainbow Rd.',
'Las Vegas', 'NV', 89123, '9:00:00', '21:00:00');

-- Insert more theater data
INSERT INTO theater (theater_name, ticket_price, address, city, state, zip_code, open, close)
VALUES
('AMC Town Square', '{"child": 6.99, "adult": 11.99}', '1234 Las Vegas Blvd',
'Las Vegas', 'NV', 89123, '8:00:00', '23:00:00'),
('Red Rock Movies', '{"child": 3.99, "adult": 7.99}', '1234 Red Rock Dr',
'Las Vegas', 'NV', 89128, '12:00:00', '23:00:00');


-- Create a theater_movie Junction TABLE that will allow Many-to-Many Relation between
-- theater and movie TABLES

CREATE TABLE theater_movie (
    theater_id INT NOT NULL,
    movie_id INT NOT NULL,
    num_of_screens INT,
    PRIMARY KEY(theater_id, movie_id),
    FOREIGN KEY(theater_id) REFERENCES theater(theater_id)
    ON DELETE CASCADE,
    FOREIGN KEY(movie_id) REFERENCES movie(movie_id)
    ON DELETE CASCADE
);

-- Insert data into theater_movie Junction TABLE

INSERT INTO theater_movie (theater_id, movie_id, num_of_screens)
VALUES
(1, 1, 3),
(1, 2, 2),
(1, 5, 1),
(1, 6, 2),
(1, 8, 2),
(2, 1, 3),
(2, 8, 3),
(2, 9, 3),
(2, 10, 3),
(3, 1, 1),
(3, 2, 1),
(3, 3, 1),
(3, 4, 1),
(3, 5, 1),
(3, 6, 1),
(3, 7, 1),
(3, 8, 1),
(3, 9, 1),
(3, 10, 1);

-- Just as we did before we can use theater_movie Junction TABLE to connect
-- The theater and movie TABLES to see which movie theaters are playing which movies

SELECT theater_name, title, num_of_screens
FROM theater
INNER JOIN theater_movie
ON theater.theater_id = theater_movie.theater_id
INNER JOIN movie
ON movie.movie_id = theater_movie.movie_id;

-- +-----------------+-------------------------+----------------+
-- | theater_name    | title                   | num_of_screens |
-- +-----------------+-------------------------+----------------+
-- | AMC Rainbow     | Interstellar            |              3 |
-- | AMC Rainbow     | The Departed            |              2 |
-- | AMC Rainbow     | A Clockwork Orange      |              1 |
-- | AMC Rainbow     | Aliens                  |              2 |
-- | AMC Rainbow     | The Dark Knight         |              2 |
-- | AMC Town Square | Interstellar            |              3 |
-- | AMC Town Square | The Dark Knight         |              3 |
-- | AMC Town Square | Dunkirk                 |              3 |
-- | AMC Town Square | Inception               |              3 |
-- | Red Rock Movies | Interstellar            |              1 |
-- | Red Rock Movies | The Departed            |              1 |
-- | Red Rock Movies | Pulp Fiction            |              1 |
-- | Red Rock Movies | Jurassic Park           |              1 |
-- | Red Rock Movies | A Clockwork Orange      |              1 |
-- | Red Rock Movies | Aliens                  |              1 |
-- | Red Rock Movies | The Wolf of Wall Street |              1 |
-- | Red Rock Movies | The Dark Knight         |              1 |
-- | Red Rock Movies | Dunkirk                 |              1 |
-- | Red Rock Movies | Inception               |              1 |
-- +-----------------+-------------------------+----------------+


-- theater_schedule TABLE
-- theater_schedule is weak entity relationship that is derived from the theater entity
-- because there is no theater_schedule without theater

CREATE TABLE theater_schedule (
    theater_id INT NOT NULL,
    movie_id INT NOT NULL,
    time TIME NOT NULL,
    seats_available INT,
    PRIMARY KEY(theater_id, movie_id, time),
    FOREIGN KEY(theater_id) REFERENCES theater(theater_id)
    ON DELETE CASCADE,
    FOREIGN KEY(movie_id) REFERENCES movie(movie_id)
    ON DELETE CASCADE
);

-- Insert theater_schedule data
INSERT INTO theater_schedule (theater_id, movie_id, time, seats_available)
VALUES
(1, 1, '11:00:00', 100),
(1, 2, '12:00:00', 100),
(1, 5, '13:00:00', 100),
(1, 6, '14:00:00', 100),
(1, 8, '14:00:00', 100),
(2, 1, '14:00:00', 100),
(2, 8, '13:00:00', 100),
(2, 9, '17:00:00', 100),
(2, 10, '14:00:00', 100),
(3, 1, '12:00:00', 100),
(3, 2, '13:00:00', 100),
(3, 3, '14:00:00', 100),
(3, 4, '15:00:00', 100),
(3, 5, '16:00:00', 100),
(3, 6, '17:00:00', 100),
(3, 7, '18:00:00', 100),
(3, 8, '19:00:00', 100),
(3, 9, '12:00:00', 100),
(3, 10, '13:00:00', 100);


-- Connect theater and movie TABLEs with theater_schedule junction TABLE

SELECT theater.theater_name, movie.title, time, seats_available
FROM theater
INNER JOIN theater_schedule
ON theater.theater_id = theater_schedule.theater_id
INNER JOIN movie
ON movie.movie_id = theater_schedule.movie_id;

-- Result

-- +-----------------+-------------------------+----------+-----------------+
-- | theater_name    | title                   | time     | seats_available |
-- +-----------------+-------------------------+----------+-----------------+
-- | AMC Rainbow     | Interstellar            | 11:00:00 |             100 |
-- | AMC Rainbow     | The Departed            | 12:00:00 |             100 |
-- | AMC Rainbow     | A Clockwork Orange      | 13:00:00 |             100 |
-- | AMC Rainbow     | Aliens                  | 14:00:00 |             100 |
-- | AMC Rainbow     | The Dark Knight         | 14:00:00 |             100 |
-- | AMC Town Square | Interstellar            | 14:00:00 |             100 |
-- | AMC Town Square | The Dark Knight         | 13:00:00 |             100 |
-- | AMC Town Square | Dunkirk                 | 17:00:00 |             100 |
-- | AMC Town Square | Inception               | 14:00:00 |             100 |
-- | Red Rock Movies | Interstellar            | 12:00:00 |             100 |
-- | Red Rock Movies | The Departed            | 13:00:00 |             100 |
-- | Red Rock Movies | Pulp Fiction            | 14:00:00 |             100 |
-- | Red Rock Movies | Jurassic Park           | 15:00:00 |             100 |
-- | Red Rock Movies | A Clockwork Orange      | 16:00:00 |             100 |
-- | Red Rock Movies | Aliens                  | 17:00:00 |             100 |
-- | Red Rock Movies | The Wolf of Wall Street | 18:00:00 |             100 |
-- | Red Rock Movies | The Dark Knight         | 19:00:00 |             100 |
-- | Red Rock Movies | Dunkirk                 | 12:00:00 |             100 |
-- | Red Rock Movies | Inception               | 13:00:00 |             100 |
-- +-----------------+-------------------------+----------+-----------------+

















