use parks_management;

-- Задание 5
-- Триггер автоматического заполнения поля таблицы
-- Создать триггер, автоматически заполняющий дату выполнения работ (устанавливая текущую дату) 
-- при создании новой записи об уходе за деревьями.

-- Примечание: менять разделитель команд (DELIMITER //) в отправляемом решении не требуется.

CREATE TRIGGER before_insert_maintenance
BEFORE INSERT ON maintenance
FOR EACH ROW
BEGIN
    IF NEW.maintenance_date IS NULL THEN
        SET NEW.maintenance_date = CURDATE();
    END IF;
END;

-- Задание 6
-- Триггер проверки целостности данных
-- Создать триггер, который осуществляет проверку целостности данных: запрещает создание новой записи о 
-- работах по уходу за деревьями для несуществующего дерева.

CREATE TRIGGER before_insert_maintenance_check
BEFORE INSERT ON maintenance
FOR EACH ROW
BEGIN
    -- Проверка существования дерева с указанным tree_id
    IF NOT EXISTS (SELECT 1 FROM trees WHERE tree_id = NEW.tree_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Tree with specified tree_id does not exist.';
    END IF;
END;

-- Задание 7
-- Триггер протоколирования операций
-- Создать триггер, осуществляющие протоколирование операции удаления данных из таблицы работ по уходу за деревьями. 

-- Триггер должен записывать операции в таблицу logs, содержащую следующие поля: имя пользователя 
-- баз данных, от которого выполнялся запрос (столбец username); время удаления (столбец timestamp); 
-- удаленные данные, объединенные в одну текстовую строку (столбец data).

CREATE TRIGGER after_delete_maintenance
AFTER DELETE ON maintenance
FOR EACH ROW
BEGIN
    INSERT INTO logs (username, timestamp, data)
    VALUES (
        USER(), -- Имя пользователя
        NOW(),  -- Текущее время
        CONCAT(
            'maintenance_id: ', OLD.maintenance_id, ', ',
            'tree_id: ', OLD.tree_id, ', ',
            'volunteer_id: ', OLD.volunteer_id, ', ',
            'maintenance_date: ', OLD.maintenance_date, ', ',
            'work_notes: ', OLD.work_notes
        ) -- Объединение удаленных данных в строку
    );
END;