-- Tema:        Ejercicio 1 (CursoDB)
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
-- Tema:        Ejercicio 1
-- Descripción: Crear base de datos CursoDB
-- Autor:       Daniel Hilario

CREATE DATABASE CursoDB;

GO

-- ============================================================
-- instalacion/02-create-table-alumno.sql
-- ============================================================
-- Tema:        Ejercicio 1
-- Descripción: Crear tabla Alumno
-- Autor:       Daniel Hilario

USE CursoDB;

CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Edad INT,
    CorreoElectronico VARCHAR(100),
    Ciudad VARCHAR(50),
    Sexo CHAR(1) NOT NULL
);

GO

-- ============================================================
-- instalacion/03-insert-data-alumno.sql
-- ============================================================
-- Tema:        Ejercicio 1
-- Descripción: Insertar 30 alumnos de prueba
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Méndez', 'García', 'Carlos', '2003-07-15', 22,
        'carlos.mendez@cursodb.com', 'Monterrey', 'H'),
       ('Torres', 'López', 'Ana', '2005-04-22', 20,
        'ana.torres@cursodb.com', 'Guadalajara', 'M'),
       ('Ramos', 'Vázquez', 'Luis', '2002-11-08', 23,
        'luis.ramos@cursodb.com', 'Monterrey', 'H'),
       ('Pérez', 'Sánchez', 'María', '2004-09-30', 21,
        'maria.perez@cursodb.com', 'Ciudad de México', 'M'),
       ('Salinas', 'Mora', 'Jorge', '2006-06-14', 19,
        'jorge.salinas@cursodb.com', 'Guadalajara', 'H'),
       ('Herrera', 'Blanco', 'Sofía', '2001-12-03', 24,
        'sofia.herrera@cursodb.com', 'Monterrey', 'M'),
       ('Castillo', 'Reyes', 'Diego', '2004-02-19', 22,
        'diego.castillo@cursodb.com', 'Ciudad de México', 'H'),
       ('Cruz', 'Díaz', 'Valentina', '2005-08-07', 20,
        'valentina.cruz@cursodb.com', 'Puebla', 'M'),
       ('Flores', 'Gutiérrez', 'Andrés', '2004-10-25', 21,
        'andres.flores@cursodb.com', 'Monterrey', 'H'),
       ('Reyes', 'Torres', 'Camila', '2002-05-11', 23,
        'camila.reyes@cursodb.com', 'Guadalajara', 'M'),
       ('Vega', 'Moreno', 'Ricardo', '2006-10-28', 19,
        'ricardo.vega@cursodb.com', 'Puebla', 'H'),
       ('Morales', 'Jiménez', 'Isabela', '2003-09-16', 22,
        'isabela.morales@cursodb.com', 'Ciudad de México', 'M'),
       ('Ortiz', 'Hernández', 'Fernando', '2000-08-04', 25,
        'fernando.ortiz@cursodb.com', 'Monterrey', 'H'),
       ('Jiménez', 'Vargas', 'Lucía', '2005-11-20', 20,
        'lucia.jimenez@cursodb.com', 'Guadalajara', 'M'),
       ('Ruiz', 'Romero', 'Sebastián', '2004-06-09', 21,
        'sebastian.ruiz@cursodb.com', 'Puebla', 'H'),
       ('Gómez', 'Navarro', 'Daniela', '2002-03-17', 23,
        'daniela.gomez@cursodb.com', 'Monterrey', 'M'),
       ('Vargas', 'Castro', 'Emilio', '2003-09-02', 22,
        'emilio.vargas@cursodb.com', 'Ciudad de México', 'H'),
       ('Soto', 'Mendoza', 'Natalia', '2005-07-13', 20,
        'natalia.soto@cursodb.com', 'Guadalajara', 'M'),
       ('Núñez', 'Fuentes', 'Alejandro', '2001-04-27', 24,
        'alejandro.nunez@cursodb.com', 'Monterrey', 'H'),
       ('Guerrero', 'Ibarra', 'Renata', '2004-12-05', 21,
        'renata.guerrero@cursodb.com', 'Puebla', 'M'),
       ('Delgado', 'Peña', 'Iván', '2003-04-18', 22,
        'ivan.delgado@cursodb.com', 'Ciudad de México', 'H'),
       ('Aguilar', 'Sandoval', 'Mariana', '2006-08-23', 19,
        'mariana.aguilar@cursodb.com', 'Monterrey', 'M'),
       ('Romero', 'Cervantes', 'Tomás', '2002-07-31', 23,
        'tomas.romero@cursodb.com', 'Guadalajara', 'H'),
       ('Medina', 'Lozano', 'Valeria', '2006-02-14', 20,
        'valeria.medina@cursodb.com', 'Puebla', 'M'),
       ('Sandoval', 'Fuentes', 'Rodrigo', '2000-05-08', 25,
        'rodrigo.sandoval@cursodb.com', 'Monterrey', 'H'),
       ('Ibarra', 'Ortega', 'Paulina', '2003-11-26', 22,
        'paulina.ibarra@cursodb.com', 'Ciudad de México', 'M'),
       ('Cervantes', 'Mendoza', 'Óscar', '2004-08-12', 21,
        'oscar.cervantes@cursodb.com', 'Guadalajara', 'H'),
       ('Peña', 'Salinas', 'Gabriela', '2005-10-01', 20,
        'gabriela.pena@cursodb.com', 'Monterrey', 'M'),
       ('Lozano', 'Herrera', 'Mateo', '2003-01-19', 23,
        'mateo.lozano@cursodb.com', 'Puebla', 'H'),
       ('Fuentes', 'Ramos', 'Alicia', '2006-12-07', 19,
        'alicia.fuentes@cursodb.com', 'Ciudad de México', 'M');

GO
