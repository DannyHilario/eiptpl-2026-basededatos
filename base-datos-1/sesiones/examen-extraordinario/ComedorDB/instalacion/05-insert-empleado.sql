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
