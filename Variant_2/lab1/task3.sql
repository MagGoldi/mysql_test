
SELECT * FROM exam_results.Subject;

SELECT COUNT(*) AS student_count 
FROM exam_results.Student;

SELECT * FROM exam_results.Student
WHERE full_name LIKE 'Ива%';

SELECT * FROM exam_results.Student
WHERE birth_date > '2001-01-01';

SELECT *
FROM exam_results.Student
JOIN exam_results.Grade 
        ON Student.student_id = Grade.student_id
WHERE Grade.grade = 4 AND Grade.subject_id = 1; 


SELECT DISTINCT Student.full_name, Student.student_id 
FROM  exam_results.Student
JOIN  exam_results.Grade ON Student.student_id = Grade.student_id
JOIN  exam_results.Subject ON Grade.subject_id = Subject.subject_id
WHERE Subject.semester = 1
AND Grade.grade IN (4, 5)
AND NOT EXISTS (
    SELECT 1 FROM  exam_results.Grade g2 
    JOIN  exam_results.Subject s2 ON g2.subject_id = s2.subject_id 
    WHERE g2.student_id = Student.student_id 
    AND s2.semester = 1 
    AND g2.grade NOT IN (4, 5)
)
ORDER BY Student.full_name;


INSERT INTO exam_results.Grade (student_id, subject_id, grade)
VALUES 
(3, 1, 3)

select * from exam_results.Grade

