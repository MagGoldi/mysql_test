from sqlalchemy import create_engine, Column, Integer, String, Date, DateTime, Enum, ForeignKey, DECIMAL, JSON
from sqlalchemy.orm import declarative_base, relationship, sessionmaker


Base = declarative_base()


class Specialization(Base):
    __tablename__ = 'specializations'

    specialization_id = Column(Integer, primary_key=True)
    title = Column(String(100), nullable=False)

    doctors = relationship("Doctor", back_populates="specialization")


class Doctor(Base):
    __tablename__ = 'doctors'

    doctor_id = Column(Integer, primary_key=True)
    passport = Column(String(20), nullable=False)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    specialization_id = Column(Integer, ForeignKey(
        'specializations.specialization_id'))
    employment_date = Column(Date)

    specialization = relationship("Specialization", back_populates="doctors")
    appointment = relationship("Appointment", back_populates="doctor")


class Patient(Base):
    __tablename__ = 'patients'

    patient_id = Column(Integer, primary_key=True)
    passport = Column(String(20), nullable=False)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    birthday = Column(Date)

    appointment = relationship("Appointment", back_populates="patient")


class Appointment(Base):
    __tablename__ = 'appointment'

    appointment_id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey('patients.patient_id'))
    doctor_id = Column(Integer, ForeignKey('doctors.doctor_id'))
    start_date = Column(DateTime)
    description = Column(String)
    status = Column(Enum('на лечении', 'здоров'))
    finish_date = Column(Date)

    doctor = relationship("Doctor", back_populates="appointment")
    patient = relationship("Patient", back_populates="appointment")


class Clinic(Base):
    __tablename__ = 'clinics'

    clinic_id = Column(Integer, primary_key=True)
    title = Column(String(100), nullable=False)
    lat = Column(DECIMAL(10, 8))
    lon = Column(DECIMAL(11, 8))
    notes = Column(JSON)


engine = create_engine('mysql+pymysql://root:1234@localhost/polyclinic')
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()


def modify_data():
    # Добавить новую специализацию
    new_specialization = Specialization(title="test")
    session.add(new_specialization)
    session.commit()

    # # Обновить информацию о докторе
    # doctor = session.query(Doctor).filter_by(doctor_id=1).first()
    # if doctor:
    #     doctor.specialization_id = new_specialization.specialization_id
    #     session.commit()

    # # Удалить пациента
    # patient = session.query(Patient).filter_by(patient_id=8).first()
    # if patient:
    #     session.delete(patient)
    #     session.commit()
    # pass


modify_data()

# 1 select * from specializations;

# 2 select * from doctors
#  join specializations using(specialization_id)
#  where doctor_id = 1;

# 3 select * from patients
#  where patient_id = 3
