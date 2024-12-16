-- Заполнение данными
-- Добавление / редактирование / удаление данных
-- Написать запросы добавления данных в таблицы.

-- Написать запросы изменения данных в таблицах (по идентификатору).

-- Написать запросы удаления данных в таблицах (по идентификатору, всех).

INSERT INTO parks_management.parks
       (name, area)
VALUES
       ('Central Park', 3.41),
       ('Green Valley Park', 5.50);

-- UPDATE parks_management.parks 
-- SET name = 'Updated Park Name' 
-- WHERE park_id = 1;

-- DELETE FROM parks_management.parks 
-- WHERE park_id = 2;

-- select * from parks_management.parks;

-----------------------------------------------------------------------
INSERT INTO parks_management.tree_species
       (common_name, scientific_name, lifespan)
VALUES
       ('Oak', 'Quercus', 100),
       ('Pine', 'Pinus', 150);

-- UPDATE parks_management.tree_species 
-- SET lifespan = 120 
-- WHERE species_id = 1;

-- DELETE FROM parks_management.tree_species 
-- WHERE species_id = 2;

-- select * from parks_management.tree_species;

-----------------------------------------------------------------------
INSERT INTO parks_management.trees
       (park_id, species_id, planting_date, lat, lon)
VALUES
       (1, 1, '2020-05-15', 40.785091, -73.968285),
       (3, 1, '2021-06-20', 34.015136, -118.491191);

-- UPDATE parks_management.trees 
-- SET lat = 40.789456, lon = -73.960876 
-- WHERE tree_id = 1;

-- DELETE FROM parks_management.trees 
-- WHERE tree_id = 1;

select *
from parks_management.trees;
------------------------------------------------------------------------
INSERT INTO parks_management.volunteers
       (first_name, last_name, phone)
VALUES
       ('John', 'Doe', '555-1234'),
       ('Jane', 'Smith', '555-5678');

-- UPDATE parks_management.volunteers 
-- SET phone = '555-9999' 
-- WHERE volunteer_id = 1;

-- DELETE FROM parks_management.volunteers 
-- WHERE volunteer_id = 1;

-- select * from parks_management.volunteers;
-----------------------------------------------------------------------
INSERT INTO parks_management.maintenance
       (tree_id, volunteer_id, maintenance_date, work_notes)
VALUES
       (1, 1, '2023-08-10', JSON_OBJECT('work', 'Watering', 'duration', '2 hours')),
       (2, 2, '2023-09-12', JSON_OBJECT('work', 'Pruning', 'tools', 'shears'));


-- UPDATE parks_management.maintenance 
-- SET work_notes = JSON_OBJECT('work', 'Fertilizing', 'amount', '5kg') 
-- WHERE maintenance_id = 1;

-- DELETE FROM parks_management.maintenance;

-- select * from parks_management.maintenance;
