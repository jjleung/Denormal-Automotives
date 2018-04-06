DROP DATABASE IF EXISTS normal_cars;
DROP USER IF EXISTS normal_user;
CREATE USER normal_user;
CREATE DATABASE normal_cars
OWNER normal_user;
\c normal_cars;
\i scripts/denormal_data.sql;
DROP TABLE IF EXISTS make;
CREATE TABLE make
(
    make_id SERIAL NOT NULL PRIMARY KEY,
    make_code VARCHAR(125) NOT NULL,
    make_title VARCHAR(125) NOT NULL
)
;
DROP TABLE IF EXISTS model;
CREATE TABLE model
(
    model_id SERIAL NOT NULL PRIMARY KEY,
    model_code VARCHAR(125) NOT NULL,
    model_title VARCHAR(125) NOT NULL,
    make_id INTEGER REFERENCES make(make_id)
)
;
DROP TABLE IF EXISTS model_year;
CREATE TABLE model_year
(
    model_year_id SERIAL NOT NULL PRIMARY KEY,
    year INTEGER NOT NULL,
    model_id INTEGER REFERENCES model(model_id)
)
;
INSERT INTO make
    (make_code, make_title)
SELECT DISTINCT car_models.make_code, car_models.make_title
FROM car_models
;
INSERT INTO model
    (model_code, model_title, make_id)
SELECT DISTINCT car_models.model_code, car_models.model_title, make.make_id
FROM make INNER JOIN car_models ON car_models.make_code = make.make_code AND car_models.make_title = make.make_title
;
INSERT INTO model_year
    (year, model_id)
SELECT DISTINCT car_models.year, model.model_id
FROM model INNER JOIN car_models ON car_models.model_code = model.model_code AND car_models.model_title = model.model_title
;
SELECT DISTINCT model_title
FROM model JOIN make ON make.make_id = model.make_id
WHERE make_code = 'VOLKS'
;
SELECT DISTINCT make_code, model_code, model_title, year
FROM car_models
WHERE make_code = 'LAM'
;
SELECT DISTINCT *
FROM car_models
WHERE year BETWEEN '2010' AND '2015'
;