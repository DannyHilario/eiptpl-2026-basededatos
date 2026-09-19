-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Paciente
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Paciente (
    idPaciente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(20) NOT NULL UNIQUE,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    FechaNacimiento DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Paciente_Sexo CHECK (Sexo IN ('M', 'F'))
);
