INSERT INTO exam_results.Student (gradebook_number, full_name, birth_date)
VALUES 
('A1001', 'Пронин Максончик Игоревич', '2000-05-15'),
('A1002', 'Валынцев Дмитрий Игоревич', '2001-10-25'),
('A1003', 'Иваныч', '2002-07-18');

INSERT INTO exam_results.Teacher (full_name)
VALUES 
('Дима Кэпчик'),
('Антон Куклев');

INSERT INTO exam_results.Subject (subject_name, semester, teacher_id)
VALUES 
('Сайкуэль', 1, 1),
('Питон', 1, 2),
('Эксель', 2, 1);


INSERT INTO exam_results.Grade (student_id, subject_id, grade)
VALUES 
(1, 1, 5),
(2, 1, 4),
(1, 2, 3),
(3, 2, 5),
(2, 3, 4);

select * from exam_results.Grade

select * from exam_results.Student

UPDATE exam_results.Student
SET birth_date =  '2001-10-25'
WHERE gradebook_number = 'A1001' AND full_name  = 'Пронин Максончик Игоревич';

select * from exam_results.Student

DELETE FROM exam_results.Student
WHERE gradebook_number = 'A1001' AND full_name  = 'Пронин Максончик Игоревич';

select * from exam_results.Student
