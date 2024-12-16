

SELECT first_name, last_name
FROM polyclinic.doctors
WHERE YEAR(CURDATE()) - YEAR(employment_date) >= 10;

SELECT 
    p.first_name, 
    p.last_name
FROM 
    appointment a
JOIN 
    patients p ON a.patient_id = p.patient_id
WHERE 
    a.status = 'здоров' or s.finish_date < CURDATE();
