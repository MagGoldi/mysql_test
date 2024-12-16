/* Создание БД
Создать базу данных для хранения сведений о результатах сдачи экзаменационной сессии. Создать таблицы в БД, 
соответствующие следующим типам сущностей:

Студент: номер зачетной книжки, ФИО, дата рождения.
Преподаватель: идентификатор, ФИО.
Предмет: идентификатор, название, семестр, преподаватель
Оценки: связь студент-предмет-оценка */


DROP DATABASE IF EXISTS session;

CREATE DATABASE session;
USE session;


-- Таблица Студент
CREATE TABLE session.student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL
);

-- Таблица Преподаватель
CREATE TABLE session.teacher (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL
);

-- Таблица Предмет
CREATE TABLE session.subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    semester INT NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

-- Таблица Оценки
CREATE TABLE session.grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    grade INT CHECK (grade >= 1 AND grade <= 5),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);


select * from grades;
