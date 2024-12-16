-- Транзакции 2
-- Транзакции. Точки сохранения
-- Написать процедуру, которая добавляет в таблицу несколько строк данных. 
-- При каждом добавлении строки выполняется проверка выполнимости некоторого 
-- условия на агрегированных данных одного из столбцов данной таблицы (например, сумма всех значений по заданному столбцу не превышает заданного значения). \
-- При невыполнении данного условия выполняется откат добавления такой строки (используя оператор ROLLBACK TO SAVEPOINT).


USE parks_management;

-- Создаем процедуру с использованием точек сохранения

DELIMITER //
CREATE PROCEDURE AddMaintenanceWithCondition(
    IN p_tree_id INT,
    IN p_volunteer_id INT,
    IN p_maintenance_date DATE,
    IN p_work_notes JSON,
    IN max_maintenance_per_volunteer INT
)
BEGIN
    DECLARE maintenance_count INT DEFAULT 0;
    DECLARE savepoint_name VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: откат транзакции.';
    END;

    START TRANSACTION;

    -- Устанавливаем точку сохранения
    SET savepoint_name = 'savepoint_before_insert';
    SAVEPOINT savepoint_before_insert;

    -- Вставляем строку в таблицу maintenance
    INSERT INTO maintenance (tree_id, volunteer_id, maintenance_date, work_notes)
    VALUES (p_tree_id, p_volunteer_id, p_maintenance_date, p_work_notes);

    -- Проверяем количество обслуживаний, выполненных волонтёром
    SELECT COUNT(*) INTO maintenance_count
    FROM maintenance
    WHERE volunteer_id = p_volunteer_id;

    -- Если количество превышает максимальное значение, откатываем добавление строки
    IF maintenance_count > max_maintenance_per_volunteer THEN
        ROLLBACK TO SAVEPOINT savepoint_before_insert;
    END IF;

    -- Освобождаем точку сохранения
    RELEASE SAVEPOINT savepoint_before_insert;

    COMMIT;
END;
//

DELIMITER ;

-- Пример корректного вызова процедуры
CALL AddMaintenanceWithCondition(1, 1, '2024-11-27', '{"task":"Pruning"}', 20);

-- Пример некорректного вызова (превышение лимита обслуживаний волонтёром)
CALL AddMaintenanceWithCondition(2, 999, '2024-11-28', '{"task":"w"}', 0);


-- Проверка данных
SELECT * FROM maintenance
limit 100;

-- Удаляем процедуру
DROP PROCEDURE IF EXISTS AddMaintenanceWithCondition;

-- Очистка таблицы
TRUNCATE maintenance;
