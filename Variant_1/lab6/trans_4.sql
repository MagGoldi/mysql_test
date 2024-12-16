-- Транзакции 4
-- Транзакции. Запись в прочитанные данные
-- Продемонстрировать возможность записи в уже прочитанные данные при использовании уровня изоляции 
-- READ COMMITTED и отсутствие такой возможности при уровне изоляции REPEATABLE READ.


-- Установим уровень изоляции REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Транзакция 1
START TRANSACTION;
SELECT * FROM appointments WHERE appointment_id = 1;
------------------------------------------------------------------------------------------

-- В новой сессии:
-- Транзакция 2
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
UPDATE appointments SET description = 'здоров' WHERE appointment_id = 1;
COMMIT;

-- Вернемся к Транзакции 1
SELECT * FROM appointments WHERE appointment_id = 1;
COMMIT;

-- Увидим, что данные остались неизменными в Транзакции 1.
