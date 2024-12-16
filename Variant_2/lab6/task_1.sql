-- Транзакции 1
-- Транзакции. Добавление данных
-- Работа с транзакциями осуществляется в собственной БД, 
-- созданной в лабораторной работе № 3.

-- Написать процедуру, которая добавляет связанные данные в несколько таблиц. 
-- В том случае, если вставка данных в одну из таблиц по какой-либо причине невозможна, 
-- выполняется откат внесенных процедурой изменений.

USE parks_management;

DELIMITER //
CREATE PROCEDURE add_tree_with_transaction(
    IN p_park_name VARCHAR(100),
    IN p_park_area DECIMAL(5,2),
    IN p_species_common_name VARCHAR(100),
    IN p_species_scientific_name VARCHAR(150),
    IN p_species_lifespan INT,
    IN p_planting_date DATE,
    IN p_lat DECIMAL(10,7),
    IN p_lon DECIMAL(10,7),
    IN p_volunteer_first_name VARCHAR(50),
    IN p_volunteer_last_name VARCHAR(50),
    IN p_volunteer_phone VARCHAR(20),
    IN p_maintenance_date DATE,
    IN p_work_notes JSON
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction rolled back due to an error';
    END;

    START TRANSACTION;

    -- Add park if it doesn't exist
    INSERT INTO parks (name, area)
    VALUES (p_park_name, p_park_area)
    ON DUPLICATE KEY UPDATE park_id = LAST_INSERT_ID(park_id);

    -- Add tree species if it doesn't exist
    INSERT INTO tree_species (common_name, scientific_name, lifespan)
    VALUES (p_species_common_name, p_species_scientific_name, p_species_lifespan)
    ON DUPLICATE KEY UPDATE species_id = LAST_INSERT_ID(species_id);

    -- Add tree
    INSERT INTO trees (park_id, species_id, planting_date, lat, lon)
    VALUES (
        (SELECT park_id FROM parks WHERE name = p_park_name LIMIT 1),
        (SELECT species_id FROM tree_species WHERE common_name = p_species_common_name LIMIT 1),
        p_planting_date, p_lat, p_lon
    );

    -- Add volunteer if they don't exist
    INSERT INTO volunteers (first_name, last_name, phone)
    VALUES (p_volunteer_first_name, p_volunteer_last_name, p_volunteer_phone)
    ON DUPLICATE KEY UPDATE volunteer_id = LAST_INSERT_ID(volunteer_id);

    -- Add maintenance record
    INSERT INTO maintenance (tree_id, volunteer_id, maintenance_date, work_notes)
    VALUES (
        (SELECT tree_id FROM trees WHERE lat = p_lat AND lon = p_lon LIMIT 1),
        (SELECT volunteer_id FROM volunteers WHERE phone = p_volunteer_phone LIMIT 1),
        p_maintenance_date,
        p_work_notes
    );

    COMMIT;
END;
//
DELIMITER ;


CALL add_tree_with_transaction(
    'Central Park',          -- Название парка
    850.34,                  -- Площадь парка
    'Oak',                   -- Общее название дерева
    'Quercus robur',         -- Научное название дерева
    200,                     -- Продолжительность жизни дерева
    '2024-12-01',            -- Дата посадки
    40.785091,               -- Широта
    -73.968285,              -- Долгота
    'John',                  -- Имя волонтера
    'Doe',                   -- Фамилия волонтера
    '+123456789',            -- Телефон волонтера
    '2024-12-10',            -- Дата обслуживания
    JSON_OBJECT('task', 'Watering') -- Заметки о работе
);

select * from parks;

drop procedure if exists add_tree_with_transaction;

use parks_management;


-- Проверка данных
SELECT * FROM parks_management.maintenance
limit 10;

SELECT * FROM parks_management.parks;
limit 10;

SELECT * FROM parks_management.tree_species;
limit 10;

SELECT * FROM parks_management.trees;
limit 10;

SELECT * FROM parks_management.volunteers;
limit 10;

SELECT * FROM parks_management.maintenance;
limit 10;

