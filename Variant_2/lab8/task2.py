from sqlalchemy import create_engine, func
from sqlalchemy.orm import sessionmaker
from models import TreeSpecies, Tree, Park, Volunteer, Maintenance


def display_oak_in_central_park(session, tree_name, park_name):
    """Запрос деревьев вида {tree_name} в {park_name}"""
    result = session.query(TreeSpecies.common_name, TreeSpecies.scientific_name, Tree.planting_date).\
        join(Tree, Tree.species_id == TreeSpecies.species_id).\
        join(Park, Tree.park_id == Park.park_id).\
        filter(TreeSpecies.common_name == tree_name,
               Park.name == park_name).all()

    print(f"Деревья вида {tree_name} в {park_name}:")
    for row in result:
        print(row)
    print()


def display_volunteer_maintenance_count(session):
    """Запрос волонтеров и количества их работ"""
    result = session.query(Volunteer.first_name, Volunteer.last_name, Volunteer.phone, func.count(Maintenance.maintenance_id).label('count')).\
        outerjoin(Maintenance, Volunteer.volunteer_id == Maintenance.volunteer_id).\
        group_by(Volunteer.volunteer_id).all()

    print("Волонтеры и количество их работ:")
    for row in result:
        print(row)
    print()


def display_trees_in_parks(session):
    """Запрос количества деревьев по паркам и видам"""
    result = session.query(Park.name.label('park_name'), TreeSpecies.common_name, func.count(Tree.tree_id).label('count')).\
        join(Tree, Tree.park_id == Park.park_id).\
        join(TreeSpecies, Tree.species_id == TreeSpecies.species_id).\
        group_by(Park.name, TreeSpecies.common_name).\
        order_by(Park.name, TreeSpecies.common_name).all()

    print("Количество деревьев по паркам и видам:")
    for row in result:
        print(row)
    print()


def display_active_volunteers(session, min_maintenance_count):
    """Запрос волонтеров с количеством работ больше {min_maintenance_count}"""
    result = session.query(Volunteer.first_name, Volunteer.last_name, func.count(Maintenance.maintenance_id).label('count')).\
        join(Maintenance, Volunteer.volunteer_id == Maintenance.volunteer_id).\
        group_by(Volunteer.volunteer_id).\
        having(func.count(Maintenance.maintenance_id) > min_maintenance_count).\
        order_by(Volunteer.last_name, Volunteer.first_name).all()

    print(f"Волонтеры с количеством работ больше {min_maintenance_count}:")
    for row in result:
        print(row)
    print()


def display_park_with_max_trees(session):
    """Запрос парка с максимальным количеством деревьев"""
    subquery = session.query(Tree.park_id, func.count(Tree.tree_id).label('tree_count')).\
        group_by(Tree.park_id).subquery()

    max_tree_count = session.query(
        func.max(subquery.c.tree_count)).scalar_subquery()

    result = session.query(Park.park_id, Park.name).\
        join(subquery, Park.park_id == subquery.c.park_id).\
        filter(subquery.c.tree_count == max_tree_count).all()

    print("Парк с максимальным количеством деревьев:")
    for row in result:
        print(row)
    print()


def display_work_stats_year(session, year=2023):
    """Статистика работ по паркам за год"""
    subquery = session.query(Park.park_id, func.count(Maintenance.maintenance_id).label('work_count')).\
        outerjoin(Tree, Park.park_id == Tree.park_id).\
        outerjoin(Maintenance, (Tree.tree_id == Maintenance.tree_id) & (func.year(Maintenance.maintenance_date) == year)).\
        group_by(Park.park_id).subquery()

    result = session.query(
        func.min(subquery.c.work_count).label('min'),
        func.avg(subquery.c.work_count).label('avg'),
        func.max(subquery.c.work_count).label('max')
    ).all()

    print(f"Статистика работ по паркам за {year} год:")
    for row in result:
        print(row)
    print()


# Пример вызова функций
if __name__ == "__main__":
    engine = create_engine(
        "mysql+pymysql://root:1234@localhost/parks_management")
    Session = sessionmaker(bind=engine)
    session = Session()

    display_oak_in_central_park(session, 'Oak', 'Central Park')
    display_volunteer_maintenance_count(session)
    display_trees_in_parks(session)
    display_active_volunteers(session, min_maintenance_count=1)
    display_park_with_max_trees(session)
    display_work_stats_year(session, 2023)
