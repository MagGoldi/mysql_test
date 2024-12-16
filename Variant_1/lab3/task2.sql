-- Заполнение данными
-- Добавление / редактирование / удаление данных

-- Написать запросы добавления данных в таблицы.

-- Написать запросы изменения данных в таблицах (по идентификатору).

-- Написать запросы удаления данных в таблицах (по идентификатору, всех).

INSERT INTO polyclinic.patients (passport, first_name, last_name, birthday) VALUES 
('2282282R28', 'Владимир', 'Владимиров', '2000-05-15'),
('123456789', 'Мирон', 'Фёдоров', '1985-01-31'),
('282828284', 'Виктор', 'Цой', '1962-06-21');

UPDATE polyclinic.patients
SET passport = '4235-0954'
WHERE patient_id = 2;

DELETE FROM polyclinic.patients
WHERE patient_id = 1

DELETE FROM polyclinic.patients
WHERE 1=1

select * from polyclinic.patients;

-------------------------------------------------------------------------------------

INSERT INTO polyclinic.specializations (title) VALUES 
('лор'),
('][ирург'),
('Батюшка');

UPDATE polyclinic.specializations
SET title = '][ИРУРГ'
WHERE specialization_id = 2;

DELETE FROM polyclinic.specializations
WHERE specialization_id = 2

DELETE FROM polyclinic.specializations
WHERE 1=1

select * from polyclinic.specializations;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.doctors (passport, first_name, last_name, specialization_id, employment_date) VALUES 
('555555555', 'Елена', 'Малышева', 1, '2020-08-01'),
('666666666', 'Томас', 'Шелби', 1, '2019-04-15'),
('777777777', 'Владимир', 'Батюшка', 3, '2021-06-10');


UPDATE polyclinic.doctors
SET last_name = 'test'
WHERE doctor_id = 16;

DELETE FROM polyclinic.doctors
WHERE 1=1;

select * from polyclinic.doctors;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.appointment (patient_id, doctor_id, start_date, description) VALUES 
(1, 1, '2024-10-11 16:00:00', 'Консультация'),
(9, 2, '2024-10-12 10:00:00', 'Лечение');

UPDATE polyclinic.appointment
SET status = 'здоров', finish_date = '2024-10-20'
WHERE appointment_id = 7;

DELETE FROM polyclinic.appointment
WHERE 1=1;

SELECT * FROM polyclinic.appointment;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.clinics (title, lat, lon, notes) VALUES 
('Central Clinic', 55.751244, 37.618423, '{"services": "Cardiology, Neurology", "rating": 4.7}'),
('East Clinic', 55.753564, 37.609218, '{"services": "Dermatology, Pediatrics", "rating": 4.4}');

UPDATE polyclinic.clinics
SET title = 'West Clinic', notes = '{"services": "General, Surgery", "rating": 4.9}'
WHERE clinic_id = 1;

DELETE FROM polyclinic.clinics
WHERE 1=1;

SELECT * FROM polyclinic.clinics;

-------------------------------------------------------------------------------------