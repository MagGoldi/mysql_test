use polyclinic;

-- Задание 1
-- Создание необновляемого представления
-- Создать необновляемое представление с именем non_updated_view, возвращающее пользователю количество незакрытых приемов по каждому врачу. 
-- Представление должно возвращать следующие столбцы: имя, фамилия, количество приемов (столбец назвать count).

create or replace algorithm=merge view non_updated_view as (
    with unclosed_app as
        (select appointments.doctor_id as doc_id 
        from appointments
        where appointments.finish_date is null)
    select doctors.first_name, 
            doctors.last_name, 
            coalesce(count(unclosed_app.doc_id), 0) as count 
    from doctors
    join unclosed_app 
    on doctors.doctor_id = unclosed_app.doc_id
    group by doctors.first_name, doctors.last_name, doctors.doctor_id);

-- Задание 2
-- Создание обновляемого представления, не допускающего добавление
-- Создать обновляемое представление с именем updated_view, не позволяющее выполнить команду INSERT, 
-- возвращающую информацию о врачах-терапевтах. Представление должно возвращать следующие столбцы: идентификатор, имя, фамилия.


CREATE VIEW updated_view AS
SELECT 
    doctor_id,
    first_name,
    last_name
FROM 
    doctors
WHERE 
    specialization_id = 1
WITH CHECK OPTION;


-- Задание 3
-- Создание обновляемого представления, допускающего добавление
-- Создать обновляемое представление с именем inserted_view с проверкой ограничений, возвращающую информацию о врачах со специализацией с id = 1. 
-- Представление должно позволять выполнить команду INSERT. Представление должно возвращать все столбцы из таблицы doctors.

CREATE VIEW inserted_view AS
SELECT 
    doctor_id,
    passport,
    first_name,
    last_name,
    specialization_id,
    employment_date
FROM 
    doctors
WHERE 
    specialization_id = 1
WITH CHECK OPTION;

-- Задание 4
-- Создание вложенного обновляемого представления
-- Создать вложенное обновляемое представление с именем cascaded_view с проверкой ограничений, 
-- возвращающую информацию о врачах со специализацией с id = 1 и паспортом, содержащим 789 в своем номере.
-- Представление cascaded_view должно использовать созданное представление inserted_view. 
-- Представление должно возвращать все столбцы из таблицы doctors.

CREATE VIEW cascaded_view AS
SELECT 
    doctor_id,
    passport,
    first_name,
    last_name,
    specialization_id,
    employment_date
FROM 
    inserted_view
WHERE 
    passport LIKE '%789%'
WITH CHECK OPTION;
