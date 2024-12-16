-- Удаляем базу данных, если она уже существует
DROP DATABASE IF EXISTS polyclinic;

-- Создаем новую базу данных
CREATE DATABASE polyclinic;
USE polyclinic;

-- Создаем таблицу пациентов
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    passport VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL
);

-- Создаем таблицу специализаций докторов
CREATE TABLE specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- Создаем таблицу докторов
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    passport VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization_id INT NOT NULL,
    employment_date DATE NOT NULL,
    FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id)
);

-- Создаем таблицу записей на прием
CREATE TABLE appointment (
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

-- Создаем таблицу клиник
CREATE TABLE clinics (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    lat DECIMAL(10, 8) NOT NULL,
    lon DECIMAL(11, 8) NOT NULL,
    notes JSON
);

-- Вставляем несколько начальных данных для таблиц specializations, doctors, и patients

-- Добавляем специализации
INSERT INTO specializations (title) VALUES 
('Терапевт'), 
('Хирург'), 
('Педиатр');

-- Добавляем пациентов
INSERT INTO patients (passport, first_name, last_name, birthday) VALUES
('P12345678', 'Иван', 'Иванов', '1990-05-15'),
('P87654321', 'Сергей', 'Сергеев', '1985-09-25');

-- Добавляем докторов
INSERT INTO doctors (passport, first_name, last_name, specialization_id, employment_date) VALUES
('D12345678', 'Петр', 'Петров', 1, '2015-03-12'),
('D87654321', 'Анна', 'Смирнова', 2, '2018-07-22');

-- Добавляем клиники
INSERT INTO clinics (title, lat, lon, notes) VALUES
('Клиника №1', 53.195873, 50.100193, JSON_OBJECT('телефон', '123-456-7890', 'вебсайт', 'clinic1.com')),
('Клиника №2', 53.195958, 50.100298, JSON_OBJECT('телефон', '098-765-4321', 'вебсайт', 'clinic2.com'));