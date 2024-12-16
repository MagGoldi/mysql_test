from sqlalchemy import create_engine, Column, Integer, String, Date, ForeignKey, DECIMAL, JSON
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

Base = declarative_base()

# Таблица "parks"


class Park(Base):
    __tablename__ = 'parks'

    park_id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    area = Column(DECIMAL(5, 2))

    # Связь с таблицей "trees"
    trees = relationship("Tree", back_populates="park")

# Таблица "tree_species"


class TreeSpecies(Base):
    __tablename__ = 'tree_species'

    species_id = Column(Integer, primary_key=True)
    common_name = Column(String(100))
    scientific_name = Column(String(150))
    lifespan = Column(Integer)

    # Связь с таблицей "trees"
    trees = relationship("Tree", back_populates="species")

# Таблица "trees"


class Tree(Base):
    __tablename__ = 'trees'

    tree_id = Column(Integer, primary_key=True)
    park_id = Column(Integer, ForeignKey('parks.park_id'))
    species_id = Column(Integer, ForeignKey('tree_species.species_id'))
    planting_date = Column(Date)
    lat = Column(DECIMAL(10, 7))
    lon = Column(DECIMAL(10, 7))

    # Связь с таблицами "parks", "tree_species" и "maintenance"
    park = relationship("Park", back_populates="trees")
    species = relationship("TreeSpecies", back_populates="trees")
    maintenance = relationship("Maintenance", back_populates="tree")

# Таблица "volunteers"


class Volunteer(Base):
    __tablename__ = 'volunteers'

    volunteer_id = Column(Integer, primary_key=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    phone = Column(String(20))

    # Связь с таблицей "maintenance"
    maintenance = relationship("Maintenance", back_populates="volunteer")

# Таблица "maintenance"


class Maintenance(Base):
    __tablename__ = 'maintenance'

    maintenance_id = Column(Integer, primary_key=True)
    tree_id = Column(Integer, ForeignKey('trees.tree_id'))
    volunteer_id = Column(Integer, ForeignKey('volunteers.volunteer_id'))
    maintenance_date = Column(Date)
    work_notes = Column(JSON)

    # Связь с таблицами "trees" и "volunteers"
    tree = relationship("Tree", back_populates="maintenance")
    volunteer = relationship("Volunteer", back_populates="maintenance")


engine = create_engine('mysql+pymysql://root:1234@localhost/parks_management')
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()


def modify_data():
    # Добавить новый парк
    new_park = Park(name="Парк Data Сайнса", area=456.50)
    new_species = TreeSpecies(
        common_name="Oak", scientific_name="Quercus robur", lifespan=200)
    new_tree = Tree(park_id=new_park.park_id, species_id=new_species.species_id,
                    planting_date="2020-05-15", lat=40.785091, lon=-73.968285)
    park_to_update = session.query(Park).filter_by(
        tree_id=new_tree.tree_id).first()
    if park_to_update:
        park_to_update.name = 'test'
        session.commit()

    # tree_to_update = session.query(Tree).filter_by(
    #     tree_id=new_tree.tree_id).first()
    # if tree_to_update:
    #     tree_to_update.lat = 40.785100
    #     tree_to_update.lon = -73.968290
    #     session.commit()

    # new_park

    # # Добавить новое дерево
    # new_species = TreeSpecies(
    #     common_name="Oak", scientific_name="Quercus robur", lifespan=200)
    # session.add(new_species)
    # session.commit()

    # new_tree = Tree(park_id=new_park.park_id, species_id=new_species.species_id,
    #                 planting_date="2020-05-15", lat=40.785091, lon=-73.968285)
    # session.add(new_tree)
    # session.commit()

    # # Добавить нового волонтера
    # new_volunteer = Volunteer(
    #     first_name="John", last_name="Doe", phone="123-456-7890")
    # session.add(new_volunteer)
    # session.commit()

    # # Добавить запись о техобслуживании
    # new_maintenance = Maintenance(tree_id=new_tree.tree_id, volunteer_id=new_volunteer.volunteer_id,
    #                               maintenance_date="2023-03-15", work_notes={"task": "pruning"})
    # session.add(new_maintenance)
    # session.commit()

    # Обновить данные
    # tree_to_update = session.query(Tree).filter_by(
    #     tree_id=new_tree.tree_id).first()
    # if tree_to_update:
    #     tree_to_update.lat = 40.785100
    #     tree_to_update.lon = -73.968290
    #     session.commit()

    # # Удалить данные
    # maintenance_to_delete = session.query(Maintenance).filter_by(
    #     maintenance_id=new_maintenance.maintenance_id).first()
    # if maintenance_to_delete:
    #     session.delete(maintenance_to_delete)
    #     session.commit()
modify_data()


# -- Проверить добавление парка
# SELECT * FROM parks;

# -- Проверить добавление дерева
# SELECT * FROM trees;

# -- Проверить добавление вида деревьев
# SELECT * FROM tree_species;

# -- Проверить добавление волонтера
# SELECT * FROM volunteers;

# -- Проверить добавление записи о техобслуживании
# SELECT * FROM maintenance;

# -- Проверить обновление координат дерева
# SELECT * FROM trees WHERE tree_id = 1; -- заменить 1 на фактический tree_id

# -- Проверить удаление записи о техобслуживании
# SELECT * FROM maintenance WHERE maintenance_id = 1; -- заменить 1 на фактический maintenance_id
