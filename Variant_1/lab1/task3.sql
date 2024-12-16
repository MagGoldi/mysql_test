/* Задание 3
Запросы вывода данных
Написать запросы для вывода данных:

Вывод всех предметов
Вывод количества студентов.
Вывод студентов, чья фамилия начинается на «Ива»
Вывод студентов, родившихся позже указанной даты.
Вывод студентов, получивших оценки 5 по указанному предмету
Вывод студентов, получивших оценки только 4 и 5 по всем предметам в указанном семестре, 
упорядочить по фамилии */

SELECT * 
FROM session.subject;

select * from  session.student;

SELECT COUNT(DISTINCT full_name) student_count 
FROM session.student;

SELECT * FROM session.student 
WHERE full_name LIKE '%Ива%';

SELECT * FROM session.student 
WHERE birth_date > '2000-01-01';

SELECT s.*, g.*
FROM session.student s 
JOIN session.grades g 
    ON s.student_id = g.student_id 
WHERE g.subject_id = 1 AND g.grade = 5;


SELECT DISTINCT Student.full_name, student.student_id
FROM  session.Student
JOIN  session.grades 
    ON Student.student_id = grades.student_id
JOIN  session.Subject 
    ON grades.subject_id = Subject.subject_id
WHERE Subject.semester = 1
AND grades.grade IN (4, 5)
AND NOT EXISTS (
    SELECT 1 FROM session.grades g2 
    JOIN  session.Subject s2 ON g2.subject_id = s2.subject_id 
    WHERE g2.student_id = Student.student_id 
    AND s2.semester = 1 
    AND g2.grade NOT IN (4, 5)
)
ORDER BY Student.full_name;

INSERT INTO session.grades (student_id, subject_id, grade) VALUES 
(4, 1, 3)


UPDATE session.grades
SET grade = 3
WHERE student_id = 2
    AND subject_id = 1;

select * from session.grades g
JOIN session.subject sub 
    ON g.subject_id = sub.subject_id
WHERE student_id = 4
