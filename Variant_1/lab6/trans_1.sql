-- 1. Транзакции. Добавление связанных данных
-- Создадим процедуру, которая добавляет связанные данные в несколько таблиц. 
-- В случае, если вставка данных в одну из таблиц невозможна, все изменения будут откатываться. 
-- Например, мы добавим данные о пациенте, докторе и записи на прием.

USE polyclinic;

DELIMITER //
CREATE PROCEDURE polyclinic.add_appointment_with_transaction(
    IN p_patient_passport VARCHAR(20),
    IN p_patient_first_name VARCHAR(50),
    IN p_patient_last_name VARCHAR(50),
    IN p_patient_birthday DATE,
    IN p_doctor_passport VARCHAR(20),
    IN p_doctor_first_name VARCHAR(50),
    IN p_doctor_last_name VARCHAR(50),
    IN p_specialization_id INT,
    IN p_employment_date DATE,
    IN p_start_date DATETIME,
    IN p_description TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Отмена, откатик';
    END;

    START TRANSACTION;

    INSERT INTO patients (passport, first_name, last_name, birthday)
    VALUES (p_patient_passport, p_patient_first_name, p_patient_last_name, p_patient_birthday);

    INSERT INTO doctors (passport, first_name, last_name, specialization_id, employment_date)
    VALUES (p_doctor_passport, p_doctor_first_name, p_doctor_last_name, p_specialization_id, p_employment_date);

    INSERT INTO appointment (patient_id, doctor_id, start_date, description)
    VALUES (
        (SELECT patient_id FROM patients WHERE passport = p_patient_passport),
        (SELECT doctor_id FROM doctors WHERE passport = p_doctor_passport),
        p_start_date,
        p_description
    );

    COMMIT;
END;
//

DELIMITER ;




------------------------------------
CALL polyclinic.add_appointment_with_transaction(
    'P12345679',           -- passport пациента
    'Иван',                -- имя пациента
    'Иванов',              -- фамилия пациента
    '1990-05-15',          -- дата рождения пациента
    'D87654322',           -- passport доктора
    'Петр',                -- имя доктора
    'Петров',              -- фамилия доктора
    1,                     -- идентификатор специализации
    '2015-03-12',          -- дата начала работы доктора
    '2024-11-15 10:00:00', -- дата и время начала приема
    'Первичный осмотр'     -- описание приема
);


DROP PROCEDURE IF EXISTS polyclinic.add_appointment_with_transaction;

select * from polyclinic.patients