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