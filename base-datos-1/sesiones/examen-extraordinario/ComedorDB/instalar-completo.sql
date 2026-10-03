-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Instalación completa (base de datos, tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético ('find instalacion -name "*.sql" | sort'),
-- que es el mismo orden de la tabla del README y respeta las llaves foráneas.
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.

-- ============================================================
-- instalacion/01-create-database.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear base de datos ComedorDB
-- Autor:       Daniel Hilario

CREATE DATABASE ComedorDB

GO

-- ============================================================
-- instalacion/02-create-table-empleado.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Empleado
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Empleado (
    idEmpleado INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Departamento VARCHAR(50) NOT NULL,
    CURP CHAR(18),
    Sexo CHAR(1) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    CONSTRAINT chk_Empleado_Sexo CHECK (Sexo IN ('M', 'F'))
);

GO

-- ============================================================
-- instalacion/03-create-table-platillo.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Platillo
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Platillo (
    idPlatillo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(200),
    Precio DECIMAL(8,2) NOT NULL,
    CONSTRAINT chk_Platillo_Precio CHECK (Precio > 0)
);

GO

-- ============================================================
-- instalacion/04-create-table-servicio.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Servicio
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Servicio (
    idServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idEmpleado INT NOT NULL,
    idPlatillo INT NOT NULL,
    FechaServicio DATE NOT NULL,
    Precio DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_Servicio_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado),
    CONSTRAINT fk_Servicio_Platillo FOREIGN KEY (idPlatillo) REFERENCES Platillo(idPlatillo),
    CONSTRAINT chk_Servicio_Precio CHECK (Precio > 0)
);

GO

-- ============================================================
-- instalacion/05-insert-empleado.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Insertar 25 empleados de prueba
-- Autor:       Daniel Hilario

USE ComedorDB;

-- Departamento: Producción (idEmpleado 1-5)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('García', 'López', 'Carlos', 'Producción', 'GALC080315NLHRRL06',
        'M', '2008-03-15'),
       ('Hernández', 'Ramírez', 'Ana', 'Producción', 'HERA071220NLMRNA09',
        'F', '2007-12-20'),
       ('Rodríguez', 'Silva', 'Miguel', 'Producción', 'ROSM091105NLHDGS07',
        'M', '2009-11-05'),
       ('Torres', 'Gutiérrez', 'Valeria', 'Producción', 'TOGV080722NLMRRV02',
        'F', '2008-07-22'),
       ('Pérez', 'Morales', 'Luis', 'Producción', 'PEML071014NLHRRM08',
        'M', '2007-10-14')

-- Departamento: Administración (idEmpleado 6-9)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('Gutiérrez', 'Peña', 'Andrea', 'Administración', 'GUPA091124NLMTTM08',
        'F', '2009-11-24'),
       ('Mendoza', 'Torres', 'Iván', 'Administración', 'METI080313NLHNDZ03',
        'M', '2008-03-13'),
       ('Herrera', 'Soto', 'Camila', 'Administración', 'HESC071019NLMRRR06',
        'F', '2007-10-19'),
       ('Vega', 'Ramírez', 'Carlos', 'Administración', 'VERC091207NLHGGS01',
        'M', '2009-12-07')

-- Departamento: Recursos Humanos (idEmpleado 10-12)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('López', 'García', 'Andrés', 'Recursos Humanos', 'LOGA080210NLHPPG02',
        'M', '2008-02-10'),
       ('Martínez', 'Flores', 'Diana', 'Recursos Humanos', 'MAFD071118NLMRRN07',
        'F', '2007-11-18'),
       ('González', 'Torres', 'Kevin', 'Recursos Humanos', 'GOTK091007NLHNZR05',
        'M', '2009-10-07')

-- Departamento: Finanzas (idEmpleado 13-15)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('Aguilar', 'Reyes', 'Vanessa', 'Finanzas', 'AGRV080316NLMGLL04',
        'F', '2008-03-16'),
       ('Salinas', 'Díaz', 'Arturo', 'Finanzas', 'SADA071024NLHLNS08',
        'M', '2007-10-24'),
       ('Medina', 'García', 'Guadalupe', 'Finanzas', 'MEGG091108NLMDNN02',
        'F', '2009-11-08')

-- Departamento: Mantenimiento (idEmpleado 16-18)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('Sánchez', 'Fuentes', 'Erick', 'Mantenimiento', 'SAFE080221NLHNNC02',
        'M', '2008-02-21'),
       ('Jiménez', 'Reyes', 'Angélica', 'Mantenimiento', 'JIRA071105NLMMMN08',
        'F', '2007-11-05'),
       ('Gómez', 'Herrera', 'Miguel', 'Mantenimiento', 'GOMM091030NLHMMR05',
        'M', '2009-10-30')

-- Departamento: Logística (idEmpleado 19-21)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('González', 'Ramírez', 'Paola', 'Logística', 'GORP080414NLMNZR06',
        'F', '2008-04-14'),
       ('Ramírez', 'López', 'Alan', 'Logística', 'RALA071107NLHRMR02',
        'M', '2007-11-07'),
       ('Rodríguez', 'García', 'Valeria', 'Logística', 'ROGV091021NLMDRL09',
        'F', '2009-10-21')

-- Departamento: Calidad (idEmpleado 22-24)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('Reyes', 'Silva', 'Gabriela', 'Calidad', 'RESG080416NLMYYY04',
        'F', '2008-04-16'),
       ('Ortiz', 'Rivera', 'Jonathan', 'Calidad', 'ORIJ071122NLHRRZ07',
        'M', '2007-11-22'),
       ('Cruz', 'Gómez', 'Pamela', 'Calidad', 'CRGP091009NLMRZM02',
        'F', '2009-10-09')

-- Departamento: Ventas (idEmpleado 25)
INSERT INTO Empleado (PrimerApellido, SegundoApellido, Nombre, Departamento, CURP,
                      Sexo, FechaNacimiento)
VALUES ('Cervantes', 'García', 'Laura', 'Ventas', 'CEGL080120NLMRRV04',
        'F', '2008-01-20')

GO

-- ============================================================
-- instalacion/06-insert-platillo.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Insertar 10 platillos del comedor subsidiado
-- Autor:       Daniel Hilario

USE ComedorDB;

INSERT INTO Platillo (Nombre, Descripcion, Precio)
VALUES ('Pozole rojo', 'Caldo de maíz cacahuazintle con carne de cerdo y chile guajillo', 45.00),
       ('Enchiladas verdes', 'Tortillas bañadas en salsa verde con pollo y crema', 40.00),
       ('Tacos de bistec', 'Tres tacos de carne de res asada con cebolla y cilantro', 38.00),
       ('Arroz con pollo', 'Pechuga de pollo guisada con arroz rojo y verduras', 42.00),
       ('Milanesa de res', 'Empanizada de res frita acompañada de ensalada de col', 48.00),
       ('Sopa de lima', 'Caldo de pollo con tortilla frita y lima yucateca', 35.00),
       ('Tamales de rajas', 'Masa de maíz rellena de rajas de chile poblano y queso', 30.00),
       ('Quesadillas de queso', 'Dos piezas de harina rellenas de queso Oaxaca', 32.00),
       ('Chile relleno', 'Chile poblano relleno de queso en caldillo de jitomate', 44.00),
       ('Frijoles charros', 'Caldo de frijol con chorizo, tocino y epazote', 28.00)

GO

-- ============================================================
-- instalacion/07-insert-servicio.sql
-- ============================================================
-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Insertar 54 registros de servicio (empleados 1-22 tienen consumos;
--              empleados 23-25 no tienen ningún servicio registrado)
--              Nota: el Precio refleja el cobro del día; algunos platillos
--              tuvieron precio distinto en abril vs mayo de 2026.
-- Autor:       Daniel Hilario

USE ComedorDB;

-- Servicios del 7 al 9 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (1, 3, '2026-04-07', 38.00),
       (5, 6, '2026-04-07', 35.00),
       (10, 7, '2026-04-07', 30.00),
       (2, 1, '2026-04-08', 42.00),
       (6, 5, '2026-04-08', 45.00),
       (11, 2, '2026-04-08', 38.00),
       (3, 8, '2026-04-09', 30.00),
       (7, 4, '2026-04-09', 40.00),
       (12, 9, '2026-04-09', 42.00)

-- Servicios del 10 al 15 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (4, 2, '2026-04-10', 38.00),
       (8, 3, '2026-04-10', 38.00),
       (13, 1, '2026-04-10', 42.00),
       (1, 5, '2026-04-14', 45.00),
       (9, 7, '2026-04-14', 30.00),
       (14, 6, '2026-04-14', 35.00),
       (5, 9, '2026-04-15', 42.00),
       (10, 8, '2026-04-15', 30.00),
       (15, 4, '2026-04-15', 40.00)

-- Servicios del 16 al 21 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (2, 3, '2026-04-16', 38.00),
       (6, 1, '2026-04-16', 42.00),
       (16, 2, '2026-04-16', 38.00),
       (3, 6, '2026-04-17', 35.00),
       (7, 5, '2026-04-17', 45.00),
       (17, 3, '2026-04-17', 38.00),
       (4, 7, '2026-04-21', 30.00),
       (8, 2, '2026-04-21', 38.00),
       (18, 9, '2026-04-21', 42.00)

-- Servicios del 22 de abril al 6 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (11, 4, '2026-04-22', 40.00),
       (19, 1, '2026-04-22', 42.00),
       (20, 3, '2026-04-22', 38.00),
       (1, 1, '2026-05-05', 45.00),
       (5, 2, '2026-05-05', 40.00),
       (21, 5, '2026-05-05', 48.00),
       (2, 4, '2026-05-06', 42.00),
       (9, 8, '2026-05-06', 32.00),
       (22, 7, '2026-05-06', 30.00)

-- Servicios del 7 al 13 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (3, 5, '2026-05-07', 48.00),
       (10, 3, '2026-05-07', 38.00),
       (12, 9, '2026-05-07', 44.00),
       (4, 9, '2026-05-12', 44.00),
       (6, 7, '2026-05-12', 30.00),
       (13, 4, '2026-05-12', 42.00),
       (7, 2, '2026-05-13', 40.00),
       (11, 8, '2026-05-13', 32.00),
       (14, 1, '2026-05-13', 45.00)

-- Servicios del 19 al 26 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (8, 6, '2026-05-19', 35.00),
       (15, 5, '2026-05-19', 48.00),
       (16, 3, '2026-05-19', 38.00),
       (17, 2, '2026-05-20', 40.00),
       (18, 9, '2026-05-20', 44.00),
       (19, 6, '2026-05-20', 35.00),
       (20, 1, '2026-05-26', 45.00),
       (21, 8, '2026-05-26', 32.00),
       (22, 4, '2026-05-26', 42.00)

GO
