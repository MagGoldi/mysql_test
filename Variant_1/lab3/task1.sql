-- В базе данных поликлиники содержится информация о записях пациентов на прием к врачам.
-- Информация о пациенте (таблица patients) включает следующие поля:

-- идентификатор (patient_id);
-- номер паспорта (passport);
-- имя (first_name);
-- фамилия (last_name);
-- дата рождения (birthday).


-- Информация о врачах (таблица doctors) включает следующие поля:

-- идентификатор (doctor_id);
-- номер паспорта (passport);
-- имя (first_name);
-- фамилия (last_name);
-- специализация (specialization_id) (поле выбирается из справочника specializations);
-- дата начала работы (employment_date).
-- Cправочник специализаций (specializations) содержит идентификатор (specialization_id) и название (title).


-- При записи на прием пациента в таблице (appointment) фиксируется дата и время приема (start_date). 
--После завершения приема пациента врач выносит заключение (description), 
--указывает текстовый статус (status) (на лечении / здоров) и дату окончания лечения (finish_date), 
--которые заносятся в базу данных.

-- Кроме того, в БД хранится информация об остальных больницах в городе (таблица clinics): 
-- название (title), 
-- широта (lat), 
-- долгота (lon), 
-- заметки (notes) для хранения информации в JSON-виде (поле типа json). 

--Таблица используется в лабораторной работе №7.


DROP DATABASE IF EXISTS polyclinic;

CREATE DATABASE polyclinic;
USE polyclinic;


DROP TABLE IF EXISTS polyclinic.patients;
CREATE TABLE polyclinic.patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    passport VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL
);


DROP TABLE IF EXISTS polyclinic.specializations;
CREATE TABLE polyclinic.specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS polyclinic.doctors;
CREATE TABLE polyclinic.doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    passport VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization_id INT NOT NULL,
    employment_date DATE NOT NULL,
    FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id)
);


DROP TABLE IF EXISTS polyclinic.appointment;
CREATE TABLE polyclinic.appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    start_date DATETIME NOT NULL,
    description TEXT,
    status ENUM('на лечении', 'здоров') DEFAULT 'на лечении',
    finish_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

DROP TABLE IF EXISTS polyclinic.clinics;
CREATE TABLE polyclinic.clinics (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    lat DECIMAL(10, 8) NOT NULL,
    lon DECIMAL(11, 8) NOT NULL,
    notes JSON
);




