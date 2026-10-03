-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 40 clientes (exportados de Alumno - Sesiones 9 y 10)
-- Autor:       Daniel Hilario

USE CineDB;

-- Clientes 1-3 (origen: Técnica 1 - Sistemas Computacionales)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('García', 'López', 'Carlos', '8100000001', 'carlos.garcia@gmail.com',
        '2008-03-15', 1),
       ('Hernández', 'Ramírez', 'Ana', '8100000002', 'ana.hernandez@hotmail.com',
        '2007-12-20', 1),
       ('Rodríguez', 'Silva', 'Miguel', '8100000003', 'miguel.rodriguez@outlook.com',
        '2009-11-05', 1)

-- Clientes 4-6 (origen: Técnica 2 - Diseño de Imagen)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Gutiérrez', 'Peña', 'Andrea', '8100000026', 'andrea.gutierrez@hotmail.com',
        '2009-11-24', 1),
       ('Mendoza', 'Torres', 'Iván', '8100000027', 'ivan.mendoza@outlook.com',
        '2008-03-13', 1),
       ('Herrera', 'Soto', 'Camila', '8100000028', 'camila.herrera@yahoo.com.mx',
        '2007-10-19', 1)

-- Clientes 7-9 (origen: Técnica 3 - Actividad Física y Deporte)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('López', 'García', 'Andrés', '8100000051', 'andres.lopez@outlook.com',
        '2008-02-10', 1),
       ('Martínez', 'Flores', 'Diana', '8100000052', 'diana.martinez@yahoo.com.mx',
        '2007-11-18', 1),
       ('González', 'Torres', 'Kevin', '8100000053', 'kevin.gonzalez@gmail.com',
        '2009-10-07', 1)

-- Clientes 10-12 (origen: Técnica 4 - Artes)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Aguilar', 'Reyes', 'Vanessa', '8100000076', 'vanessa.aguilar@yahoo.com.mx',
        '2008-03-16', 1),
       ('Salinas', 'Díaz', 'Arturo', '8100000077', 'arturo.salinas@gmail.com',
        '2007-10-24', 1),
       ('Medina', 'García', 'Guadalupe', '8100000078', 'guadalupe.medina@hotmail.com',
        '2009-11-08', 1)

-- Clientes 13-14 (origen: Técnica 5 - Gastronomía Integral)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Sánchez', 'Fuentes', 'Erick', '8100000101', 'erick.sanchez@gmail.com',
        '2008-02-21', 1),
       ('Jiménez', 'Reyes', 'Angélica', '8100000102', 'angelica.jimenez@hotmail.com',
        '2007-11-05', 1)

-- Clientes 15-16 (origen: Técnica 6 - Diseño y Comunicación Visual)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('González', 'Ramírez', 'Paola', '8100000126', 'paola.gonzalez@hotmail.com',
        '2008-04-14', 1),
       ('Ramírez', 'López', 'Alan', '8100000127', 'alan.ramirez@outlook.com',
        '2007-11-07', 1)

-- Clientes 17-18 (origen: Técnica 7 - Diseño de Modas)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Reyes', 'Silva', 'Gabriela', '8100000151', 'gabriela.reyes@outlook.com',
        '2008-04-16', 1),
       ('Ortiz', 'Rivera', 'Jonathan', '8100000152', 'jonathan.ortiz@yahoo.com.mx',
        '2007-11-22', 1)

-- Clientes 19-20 (origen: Técnica 8 - Fisioterapia y Readaptación Físico Deportiva)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Cervantes', 'García', 'Laura', '8100000176', 'laura.cervantes@yahoo.com.mx',
        '2008-01-20', 1),
       ('Sandoval', 'Martínez', 'Javier', '8100000177', 'javier.sandoval@gmail.com',
        '2007-11-17', 1)

-- Clientes 21-23 (origen: Técnica 1 - Sistemas Computacionales)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Torres', 'Gutiérrez', 'Valeria', '8100000004', 'valeria.torres@yahoo.com.mx',
        '2008-07-22', 1),
       ('Pérez', 'Morales', 'Luis', '8100000005', 'luis.perez@gmail.com',
        '2007-10-14', 1),
       ('Sánchez', 'Vega', 'Sofía', '8100000006', 'sofia.sanchez@hotmail.com',
        '2009-12-30', 1)

-- Clientes 24-26 (origen: Técnica 2 - Diseño de Imagen)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Vega', 'Ramírez', 'Carlos', '8100000029', 'carlos.vega@gmail.com',
        '2009-12-07', 1),
       ('Navarro', 'Flores', 'Lucía', '8100000030', 'lucia.navarro@hotmail.com',
        '2008-05-25', 1),
       ('Castillo', 'García', 'Tomás', '8100000031', 'tomas.castillo@outlook.com',
        '2007-11-18', 1)

-- Clientes 27-29 (origen: Técnica 3 - Actividad Física y Deporte)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Ramírez', 'Pérez', 'Fernanda', '8100000054', 'fernanda.ramirez@hotmail.com',
        '2008-08-14', 1),
       ('Rodríguez', 'Sánchez', 'Eduardo', '8100000055', 'eduardo.rodriguez@outlook.com',
        '2007-12-03', 1),
       ('Cruz', 'Jiménez', 'Alejandra', '8100000056', 'alejandra.cruz@yahoo.com.mx',
        '2009-11-15', 1)

-- Clientes 30-32 (origen: Técnica 4 - Artes)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Lozano', 'Martínez', 'Rubén', '8100000079', 'ruben.lozano@outlook.com',
        '2008-07-21', 1),
       ('Fuentes', 'González', 'Sofía', '8100000080', 'sofia.fuentes@yahoo.com.mx',
        '2007-12-15', 1),
       ('Núñez', 'Rodríguez', 'Miguel', '8100000081', 'miguel.nunez@gmail.com',
        '2009-10-02', 1)

-- Clientes 33-34 (origen: Técnica 5 - Gastronomía Integral)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Gómez', 'Herrera', 'Miguel', '8100000103', 'miguel.gomez@outlook.com',
        '2009-10-30', 1),
       ('Delgado', 'Cruz', 'Jimena', '8100000104', 'jimena.delgado@yahoo.com.mx',
        '2008-09-16', 1)

-- Clientes 35-36 (origen: Técnica 6 - Diseño y Comunicación Visual)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Rodríguez', 'García', 'Valeria', '8100000128', 'valeria.rodriguez@yahoo.com.mx',
        '2009-10-21', 1),
       ('Hernández', 'Martínez', 'Carlos', '8100000129', 'carlos.hernandez@gmail.com',
        '2008-03-19', 1)

-- Clientes 37-38 (origen: Técnica 7 - Diseño de Modas)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Cruz', 'Gómez', 'Pamela', '8100000153', 'pamela.cruz@gmail.com',
        '2009-10-09', 1),
       ('Flores', 'Vargas', 'Sergio', '8100000154', 'sergio.flores@hotmail.com',
        '2008-02-15', 1)

-- Clientes 39-40 (origen: Técnica 8 - Fisioterapia y Readaptación Físico Deportiva)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Guerrero', 'González', 'Vanessa', '8100000178', 'vanessa.guerrero@hotmail.com',
        '2009-10-11', 1),
       ('Ibáñez', 'Rodríguez', 'Carlos', '8100000179', 'carlos.ibanez@outlook.com',
        '2008-03-18', 1)
