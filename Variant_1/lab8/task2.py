from sqlalchemy import create_engine, func, and_, distinct, or_, text
from models import Doctor, Patient, Appointment, Specialization
from sqlalchemy.orm import sessionmaker
from datetime import date


engine = create_engine("mysql+pymysql://root:1234@localhost/polyclinic")
Session = sessionmaker(bind=engine)


def get_experienced_doctors(session, years_of_experience: int) -> list:
    """
    Возвращает список докторов с опытом работы не менее N лет.

    :param session: Сессия базы данных SQLAlchemy.
    :param years_of_experience: Минимальный стаж доктора в годах (целое число).
    :return: Список докторов (имя, фамилия).
    :raises TypeError: Если years_of_experience не является целым числом.
    """
    if not isinstance(years_of_experience, int):
        raise TypeError(
            "Параметр 'years_of_experience' должен быть целым числом.")

    current_year = date.today().year
    threshold_year = date.today().year - years_of_experience

    doctors = (
        session.query(Doctor.first_name,
                      Doctor.last_name,
                      (current_year - func.year(Doctor.employment_date)))
        .filter(func.year(Doctor.employment_date) <= threshold_year)
        .all()
    )
    return doctors


# Запрос 2: Пациенты, лечившиеся у доктора "Анна Антонова"
def get_patients_by_doctor(session, doctor_first_name: str, doctor_last_name: str) -> list:
    """
    Возвращает список пациентов, лечившихся у доктора с указанным именем и фамилией.

    :param session: Сессия базы данных SQLAlchemy.
    :param doctor_first_name: Имя доктора (строка).
    :param doctor_last_name: Фамилия доктора (строка).
    :return: Список пациентов (имя, фамилия), отсортированный по фамилии и имени.
    :raises TypeError: Если doctor_first_name или doctor_last_name не строки.
    """
    if not isinstance(doctor_first_name, str) or not isinstance(doctor_last_name, str):
        raise TypeError("Имена и фамилии доктора должны быть строками.")

    patients = (
        session.query(Patient.first_name, Patient.last_name)
        .join(Appointment, Appointment.patient_id == Patient.patient_id)
        .join(Doctor, Appointment.doctor_id == Doctor.doctor_id)
        .filter(
            Doctor.first_name == doctor_first_name,
            Doctor.last_name == doctor_last_name
        )
        .order_by(Patient.last_name, Patient.first_name)
        .all()
    )
    return patients


# Запрос 3: Пациенты со статусом 'здоров' или без посещений
def get_healthy_or_unvisited_patients(session) -> list:
    """
    Возвращает список пациентов, которые либо имеют статус 'здоров', либо не имеют записей о посещениях.

    :param session: Сессия базы данных SQLAlchemy.
    :return: Список пациентов (имя, фамилия).
    """
    patients = (
        session.query(Patient.first_name, Patient.last_name)
        .outerjoin(Appointment, Appointment.patient_id == Patient.patient_id)
        .filter(
            or_(Appointment.status == 'здоров', Appointment.status == None)
        )
        .order_by(Patient.last_name, Patient.first_name)
        .all()
    )
    return patients


# Запрос 4: Количество приемов для каждого доктора за указанный период
def get_appointments_count_per_doctor(session, start_date: str, end_date: str):
    """
    Возвращает количество приемов для каждого доктора за указанный период.

    :param session: Сессия базы данных SQLAlchemy.
    :param start_date: Начало периода (строка в формате 'YYYY-MM-DD').
    :param end_date: Конец периода (строка в формате 'YYYY-MM-DD').
    :return: Список докторов (имя, фамилия, количество приемов).
    :raises ValueError: Если формат даты некорректен.
    """
    try:
        start_date = date.fromisoformat(start_date)
        end_date = date.fromisoformat(end_date)
    except ValueError:
        raise ValueError("Дата должна быть в формате 'YYYY-MM-DD'.")

    doctors_with_counts = (
        session.query(
            Doctor.first_name,
            Doctor.last_name,
            func.count(Appointment.appointment_id).label("count"),
        )
        .outerjoin(
            Appointment,
            and_(
                Doctor.doctor_id == Appointment.doctor_id,
                Appointment.start_date >= start_date,
                Appointment.start_date < end_date,
            ),
        )
        .group_by(Doctor.first_name, Doctor.last_name)
        .all()
    )
    return doctors_with_counts


# Запрос 5: Топ-N специализаций по количеству приемов
def get_top_specializations_by_appointments(session, top_n: int = 3):
    """
    Возвращает топ-N специализаций по количеству приемов.

    :param session: Сессия базы данных SQLAlchemy.
    :param top_n: Количество специализаций в топе (целое число, по умолчанию 3).
    :return: Список специализаций и количество приемов.
    :raises TypeError: Если top_n не является целым числом.
    """
    if not isinstance(top_n, int):
        raise TypeError("Параметр 'top_n' должен быть целым числом.")

    specializations_with_counts = (
        session.query(
            Specialization.title.label("specialization"),
            func.count(Appointment.appointment_id).label("count"),
        )
        .join(Doctor, Specialization.specialization_id == Doctor.specialization_id)
        .join(Appointment, Doctor.doctor_id == Appointment.doctor_id)
        .group_by(Specialization.title)
        .order_by(func.count(Appointment.appointment_id).desc())
        .limit(top_n)
        .all()
    )
    return specializations_with_counts


# Запрос 6: Пациенты старше 30 лет, посещавшие более одного врача
def get_patients_with_multiple_doctors(session):
    """
    Возвращает список пациентов старше 30 лет, посещавших более одного врача.

    :param session: Сессия базы данных SQLAlchemy.
    :return: Список пациентов (имя, фамилия, количество посещений).
    """

    patients = (
        session.query(
            Patient.first_name,
            Patient.last_name,
            Patient.birthday,
            func.count(Appointment.appointment_id).label("count")
        )
        .join(Appointment, Patient.patient_id == Appointment.patient_id)
        .filter(
            text("TIMESTAMPDIFF(YEAR, patients.birthday, CURDATE()) > 30")
        )
        .group_by(Patient.patient_id, Patient.first_name, Patient.last_name, Patient.birthday)
        .having(func.count(distinct(Appointment.doctor_id)) > 1)
        .order_by(Patient.birthday)
        .all()
    )
    return patients


def main():
    session = Session()

    # Запрос 1
    try:
        N = 5
        experienced_doctors = get_experienced_doctors(session, N)

        print(f"Доктора с опытом {N} лет:")
        for doctor in experienced_doctors:
            print(doctor)

    except TypeError as e:
        print(e)
    print()
    # Запрос 2
    try:
        FIRST_NAME = "Анна"
        LAST_NAME = "Смирнова"
        doctor_patients = get_patients_by_doctor(
            session, FIRST_NAME, LAST_NAME)

        print(F"Пациенты доктора {FIRST_NAME} {LAST_NAME}:")
        for patient in doctor_patients:
            print(f"{patient.first_name} {patient.last_name}")

    except TypeError as e:
        print(f"Ошибка: {e}")
    print()
    # Запрос 3
    healthy_or_unvisited_patients = get_healthy_or_unvisited_patients(session)

    print("Пациенты со статусом 'здоров' или без посещений:")
    for patient in healthy_or_unvisited_patients:
        print(f"{patient.first_name} {patient.last_name}")
    print()
    # Запрос 4
    try:
        START_DATE = "2023-01-01"
        END_DATE = "2023-02-01"
        doctors_with_counts = get_appointments_count_per_doctor(
            session, START_DATE, END_DATE)

        print(
            f"Количество приемов для каждого доктора за период {START_DATE} - {END_DATE}")
        for doctor in doctors_with_counts:
            print(f"{doctor.first_name} {doctor.last_name} - Приемов: {doctor.count}")

    except ValueError as e:
        print(f"Ошибка: {e}")
    print()
    # Запрос 5
    try:
        TOP_N = 3
        top_specializations = get_top_specializations_by_appointments(
            session, TOP_N)

        print(f"Топ - {TOP_N} специализаций по количеству приемов:")
        for specialization in top_specializations:
            print(
                f"{specialization.specialization} - Приемов: {specialization.count}")
    except TypeError as e:
        print(f"Ошибка: {e}")
    print()
    # Запрос 6
    patients_with_multiple_doctors = get_patients_with_multiple_doctors(
        session)
    print("Пациенты старше 30 лет, посещавшие более одного врача:")
    for patient in patients_with_multiple_doctors:
        print(f"{patient.first_name} {patient.last_name} - Посещений: {patient.count}")


if __name__ == "__main__":
    main()
