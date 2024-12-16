-- 2. Транзакции. Точки сохранения
-- Создадим процедуру, которая добавляет несколько строк данных в таблицу appointment. 
-- При каждом добавлении строки проверяется, не превышает ли общее количество активных записей 
-- (со статусом на лечении) допустимый порог. Если условие не выполнено, 
-- происходит откат добавления этой строки до последней точки сохранения (SAVEPOINT).

use polyclinic

DELIMITER //

CREATE PROCEDURE AddAppointments(
    IN patient_id INT,
    IN doctor_id INT,
    IN start_date DATETIME,
    IN description TEXT,
    IN status ENUM('на лечении', 'здоров') ,
    IN finish_date DATE,
    IN max_doctor_id_sum INT
)
BEGIN
    DECLARE current_sum INT DEFAULT 0;
    DECLARE savepoint_name VARCHAR(50);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Отмена, откатик';
    END;
	
	START TRANSACTION;

    SET savepoint_name = 'savepoint_before_insert';
    SAVEPOINT savepoint_before_insert;

    INSERT INTO polyclinic.appointment (patient_id, doctor_id, start_date, description, status, finish_date)
    VALUES (patient_id, doctor_id, start_date, description, status, finish_date);

    -- Рассчитать сумму doctor_id
    SELECT SUM(doctor_id) INTO current_sum FROM polyclinic.appointment;

    -- условие
    IF current_sum > max_doctor_id_sum THEN
        ROLLBACK TO SAVEPOINT savepoint_before_insert;
    END IF;

    RELEASE SAVEPOINT savepoint_before_insert;
END;
//

DELIMITER ;

--меням patient_id
CALL polyclinic.AddAppointments(4, 1, '2024-11-18 10:00:00', 'Annual checkup', 'здоров', '2024-11-18', 3);

CALL polyclinic.AddAppointments(1, 9999, '2024-11-18 10:00:00', 'Emergency checkup', 'здоров', '2024-11-18', 100);

DROP PROCEDURE IF EXISTS polyclinic.AddAppointments;

select * from polyclinic.appointment;

truncate polyclinic.appointment;
