-- Tema:        Ejercicio 1 - Etapa 4
-- Descripción: Crear tabla Alumno
-- Autor:       Daniel Hilario

USE EscuelaDB;

CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTecnica INT NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Edad INT,
    Sexo CHAR(1) NOT NULL,
    CURP CHAR(18),
    FechaNacimiento DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Alumno_Tecnica FOREIGN KEY (idTecnica) REFERENCES Tecnica(idTecnica),
    CONSTRAINT chk_Alumno_Sexo CHECK (Sexo IN ('M', 'F'))
);
