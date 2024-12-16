/* Задание 2
Добавление / изменение / удаление данных
В таблицы внести несколько записей с помощью редактора запросов и операции INSERT.

Изменить записи с помощью операции UPDATE.

Удалить запись с помощью операции DELETE. */


INSERT INTO session.student (full_name, birth_date) VALUES 
('Иванов Иван Иванович', '2000-05-15'),
('Петров Петр Петрович', '1999-03-22'),
('Сидоров Сидор Сидорович', '2001-08-30'),
('Кузнецова Анна Владимировна', '2000-12-05'),
('Васильев Сергей Павлович', '1998-09-12'),
('Михайлова Ольга Игоревна', '2002-01-19'),
('Алексеев Дмитрий Владимирович', '2001-06-17');

select * from session.student;

INSERT INTO session.teacher (full_name) VALUES 
('Смирнов Алексей Викторович'),
('Кузнецова Мария Николаевна'),
('Павлов Игорь Андреевич'),
('Зайцева Елена Викторовна');

select * from session.teacher;

INSERT INTO session.subject (name, semester, teacher_id) VALUES 
('Математика', 1, 1),
('Физика', 1, 2),
('Химия', 2, 1),
('Информатика', 2, 3),
('История', 1, 4),
('Биология', 2, 4);

select * from session.subject;

INSERT INTO session.grades (student_id, subject_id, grade) VALUES 
(1, 1, 5),
(1, 2, 4), 
(2, 1, 3), 
(3, 2, 5),
(2, 3, 4),
(4, 1, 5), 
(4, 2, 5),
(5, 4, 3), 
(6, 5, 4), 
(7, 6, 5), 
(3, 3, 4), 
(6, 1, 5), 
(7, 4, 3), 
(5, 5, 4), 
(1, 3, 4); 

select * from session.grades;

UPDATE session.grades
SET grade = 4
WHERE student_id = 2 AND subject_id = 1;

DELETE FROM session.grades
WHERE student_id = 1 AND subject_id = 1;




