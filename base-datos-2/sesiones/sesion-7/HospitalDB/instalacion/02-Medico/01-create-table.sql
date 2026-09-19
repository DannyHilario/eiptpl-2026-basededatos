-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Medico
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Medico (
    idMedico INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Cedula VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(20) UNIQUE,
    Correo VARCHAR(100) UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
