use polyclinic;

-- Задание 5
-- Триггер автоматического заполнения поля таблицы
-- Создать триггер, автоматически заполняющий время приема (устанавливая текущую дату) 
-- при создании новой записи о приеме пациента.

-- Примечание: менять разделитель команд (DELIMITER //) в отправляемом решении не требуется.

CREATE TRIGGER set_start_date
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    SET NEW.start_date = NOW();
END;

-- Задание 6
-- Триггер проверки целостности данных
-- Создать триггер, который осуществляет проверку целостности данных: запрещает создание новой записи о приеме для несуществующего пациента.

CREATE TRIGGER check_patient_exists
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM patients WHERE patient_id = NEW.patient_id) = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Patient does not exist';
    END IF;
END;


-- Задание 7
-- Триггер протоколирования операций
-- Создать триггер, осуществляющие протоколирование операции удаления данных из таблицы приема пациентов. 

-- Триггер должен записывать операции в таблицу logs, содержащую следующие поля: имя пользователя баз данных, 
-- от которого выполнялся запрос (столбец username); 
-- время удаления (столбец timestamp); удаленные данные, объединенные в одну текстовую строку (столбец data).

CREATE TRIGGER log_delete_appointment
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    INSERT INTO logs (username, timestamp, data)
    VALUES (
        USER(), 
        NOW(), 
        CONCAT('Appointment ID: ', OLD.appointment_id, ', Patient ID: ', OLD.patient_id, ', Doctor ID: ', OLD.doctor_id, ', Start Date: ', OLD.start_date)
    );
END;
