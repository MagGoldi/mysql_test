-- Управление парками
-- Создать базу данных для предметной области, связанной с управлением парками 
-- и озеленением городских территорий. База данных будет содержать информацию о парках, 
-- видах деревьев, размещенных деревьях, а также информацию о волонтерах, ухаживающих за деревьями.

-- В таблице parks хранится информация о парках:

-- идентификатор парка (столбец park_id);
-- название парка (name);
-- площадь парка в гектарах (area).
-- Информация о видах деревьев (таблица tree_species) включает следующие поля:

-- идентификатор вида дерева (species_id);
-- общепринятое название вида (common_name);
-- научное название вида (scientific_name);
-- средняя продолжительность жизни в годах (lifespan).
-- Таблица trees хранит информацию о посаженных деревьях:

-- идентификатор дерева (tree_id);
-- идентификатор парка (park_id);
-- идентификатор вида дерева (species_id);
-- дата посадки (planting_date);
-- координаты дерева: широта (lat), долгота (lon).
-- Таблица volunteers хранит информацию о волонтерах:

-- идентификатор волонтера (volunteer_id);
-- имя волонтера (first_name);
-- фамилия волонтера (last_name);
-- телефонный номер (phone).
-- Таблица maintenance хранит информацию о работах по уходу за деревьями:

-- идентификатор записи (maintenance_id);
-- идентификатор дерева (tree_id);
-- идентификатор волонтера, проводившего работы (volunteer_id);
-- дата выполнения работ (maintenance_date);
-- описание выполненных работ (work_notes) - информация в JSON-виде (поле типа json).

DROP DATABASE IF EXISTS parks_management;
CREATE DATABASE parks_management;

-- Управление парками
-- Создать базу данных для предметной области, связанной с управлением парками 
-- и озеленением городских территорий. База данных будет содержать информацию о парках, 
-- видах деревьев, размещенных деревьях, а также информацию о волонтерах, ухаживающих за деревьями.

-- В таблице parks хранится информация о парках:

-- идентификатор парка (столбец park_id);
-- название парка (name);
-- площадь парка в гектарах (area).
-- Информация о видах деревьев (таблица tree_species) включает следующие поля:

-- идентификатор вида дерева (species_id);
-- общепринятое название вида (common_name);
-- научное название вида (scientific_name);
-- средняя продолжительность жизни в годах (lifespan).
-- Таблица trees хранит информацию о посаженных деревьях:

-- идентификатор дерева (tree_id);
-- идентификатор парка (park_id);
-- идентификатор вида дерева (species_id);
-- дата посадки (planting_date);
-- координаты дерева: широта (lat), долгота (lon).
-- Таблица volunteers хранит информацию о волонтерах:

-- идентификатор волонтера (volunteer_id);
-- имя волонтера (first_name);
-- фамилия волонтера (last_name);
-- телефонный номер (phone).
-- Таблица maintenance хранит информацию о работах по уходу за деревьями:

-- идентификатор записи (maintenance_id);
-- идентификатор дерева (tree_id);
-- идентификатор волонтера, проводившего работы (volunteer_id);
-- дата выполнения работ (maintenance_date);
-- описание выполненных работ (work_notes) - информация в JSON-виде (поле типа json).


DROP DATABASE IF EXISTS parks_management;
CREATE DATABASE parks_management;


-- Таблица парков
CREATE TABLE parks_management.parks (
    park_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    area DECIMAL(5,2) NOT NULL
);

-- Таблица видов деревьев
CREATE TABLE parks_management.tree_species (
    species_id INT AUTO_INCREMENT PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    lifespan INT NOT NULL
);

-- Таблица посаженных деревьев
CREATE TABLE parks_management.trees (
    tree_id INT AUTO_INCREMENT PRIMARY KEY,
    park_id INT,
    species_id INT,
    planting_date DATE,
    lat DECIMAL(10, 7),
    lon DECIMAL(10, 7),
    FOREIGN KEY (park_id) REFERENCES parks_management.parks(park_id) ON DELETE CASCADE,
    FOREIGN KEY (species_id) REFERENCES parks_management.tree_species(species_id) ON DELETE CASCADE
);

-- Таблица волонтеров
CREATE TABLE parks_management.volunteers (
    volunteer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Таблица ухода за деревьями
CREATE TABLE parks_management.maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    tree_id INT,
    volunteer_id INT,
    maintenance_date DATE,
    work_notes JSON,
    FOREIGN KEY (tree_id) REFERENCES parks_management.trees(tree_id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES parks_management.volunteers(volunteer_id) ON DELETE CASCADE
);

