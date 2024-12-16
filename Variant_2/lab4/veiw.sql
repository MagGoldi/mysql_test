use parks_management;

-- Задание 1
-- Создание необновляемого представления
-- Создать необновляемое представление с именем non_updated_view, возвращающее количество деревьев, 
-- посаженных в каждом парке. Представление должно возвращать следующие столбцы: название парка, количество деревьев (столбец назвать count).

CREATE VIEW non_updated_view AS
SELECT p.name, COUNT(t.tree_id) AS count
FROM parks p
LEFT JOIN trees t ON p.park_id = t.park_id
GROUP BY p.name;

-- Задание 2
-- Создание обновляемого представления, не допускающего добавление
-- Создать обновляемое представление с именем updated_view, не позволяющее выполнить команду INSERT, 
-- возвращающую информацию о видах деревьев, средняя продолжительность которых больше 100 лет. 
-- Представление должно возвращать следующие столбцы: идентификатор вида, общепринятое название.

CREATE VIEW updated_view AS
SELECT species_id, common_name
FROM tree_species
WHERE lifespan > 100
WITH CHECK OPTION;

-- Задание 3
-- Создание обновляемого представления, допускающего добавление
-- Создать обновляемое представление с именем inserted_view с проверкой ограничений, 
-- возвращающую информацию о деревьях вида species_id = 1. Представление должно позволять выполнить команду INSERT. 
-- Представление должно возвращать все столбцы из таблицы trees.

CREATE VIEW inserted_view AS
SELECT tree_id, park_id, species_id, planting_date, lat, lon
FROM trees
WHERE species_id = 1
WITH CHECK OPTION;

-- Задание 4
-- Создание вложенного обновляемого представления
-- Создать вложенное обновляемое представление с именем cascaded_view с проверкой ограничений, 
-- возвращающую информацию о деревьях вида с species_id = 1, посаженных позже 2011 г.. 
-- Представление cascaded_view должно использовать созданное представление inserted_view. 
-- Представление должно возвращать все столбцы из таблицы trees.

CREATE VIEW cascaded_view AS
SELECT tree_id, park_id, species_id, planting_date, lat, lon
FROM inserted_view
WHERE planting_date > '2011-01-01'
WITH CHECK OPTION;
