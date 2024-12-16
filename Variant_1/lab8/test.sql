

INSERT INTO polyclinic.patients (passport, first_name, last_name, birthday) VALUES 
('228228R28', 'Владимир', 'Владимиров', '2000-05-15'),
('12345789', 'Мирон', 'Фёдоров', '1985-01-31'),
('28282884', 'Виктор', 'Цой', '1962-06-21');


select * from polyclinic.patients;

-------------------------------------------------------------------------------------

INSERT INTO polyclinic.specializations (title) VALUES 
('лор'),
('][ирург'),
('Батюшка');

select * from polyclinic.specializations;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.doctors (passport, first_name, last_name, specialization_id, employment_date) VALUES 
('55555555', 'Елена', 'Малышева', 1, '2020-08-01'),
('66666666', 'Томас', 'Шелби', 1, '2019-04-15'),
('77777777', 'Владимир', 'Батюшка', 3, '2021-06-10');


select * from polyclinic.doctors;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.appointment (patient_id, doctor_id, start_date, description) VALUES 
(1, 3, '2024-10-11 16:00:00', 'Консультация'),
(1, 4, '2024-10-12 10:00:00', 'Лечение');

SELECT * FROM polyclinic.appointment;

-------------------------------------------------------------------------------------
INSERT INTO polyclinic.clinics (title, lat, lon, notes) VALUES 
('Central Clinic', 55.751244, 37.618423, '{"services": "Cardiology, Neurology", "rating": 4.7}'),
('East Clinic', 55.753564, 37.609218, '{"services": "Dermatology, Pediatrics", "rating": 4.4}');

SELECT * FROM polyclinic.clinics;

-------------------------------------------------------------------------------------