-- Транзакции. Незафиксированные изменения
-- Продемонстрировать возможность чтения незафиксированных изменений при 
-- использовании уровня изоляции READ UNCOMMITTED и отсутствие такой возможности 
-- при уровне изоляции READ COMMITTED.

SELECT * FROM polyclinic.appointment;

----------------------------------------------------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

INSERT INTO polyclinic.appointment (patient_id, doctor_id, start_date, description, status, finish_date)
VALUES (3, 2, '2024-11-20 15:00:00', 'Consultation', 'здоров', '2024-11-21');

SELECT * FROM polyclinic.appointment;
----------------------------------------------------------------------------------------------------------------
commit;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM polyclinic.appointments;

