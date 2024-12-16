CREATE DATABASE IF NOT EXISTS exam_results;

CREATE TABLE exam_results.Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    gradebook_number VARCHAR(10) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE
);

CREATE TABLE exam_results.Teacher (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE exam_results.Subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    semester INT NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES exam_results.Teacher(teacher_id)
);

CREATE TABLE exam_results.Grade (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    grade INT CHECK (grade IN (2, 3, 4, 5)), 
    FOREIGN KEY (student_id) REFERENCES exam_results.Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES exam_results.Subject(subject_id)
);
