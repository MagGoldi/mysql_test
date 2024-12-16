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

select *
from parks_management.parks;

-----------------------------------------------------------------------
INSERT INTO parks_management.tree_species
    (common_name, scientific_name, lifespan)
VALUES
    ('Oak', 'Quercus', 100),
    ('Pine', 'Pinus', 150);

select *
from parks_management.tree_species;

-----------------------------------------------------------------------
INSERT INTO parks_management.trees
    (park_id, species_id, planting_date, lat, lon)
VALUES
    (1, 1, '2020-05-15', 40.785091, -73.968285),
    (3, 1, '2021-06-20', 34.015136, -118.491191);

select *
from parks_management.trees;
------------------------------------------------------------------------
INSERT INTO parks_management.volunteers
    (first_name, last_name, phone)
VALUES
    ('John', 'Doe', '555-1234'),
    ('Jane', 'Smith', '555-5678');

select *
from parks_management.volunteers;
-----------------------------------------------------------------------
INSERT INTO parks_management.maintenance
    (tree_id, volunteer_id, maintenance_date, work_notes)
VALUES
    (1, 1, '2023-08-10', JSON_OBJECT('work', 'Watering', 'duration', '2 hours')),
    (3, 2, '2023-09-12', JSON_OBJECT('work', 'Pruning', 'tools', 'shears'));


select *
from parks_management.maintenance;
