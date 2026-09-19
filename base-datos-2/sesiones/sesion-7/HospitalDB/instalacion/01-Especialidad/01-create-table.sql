-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Especialidad
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Especialidad (
    idEspecialidad INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
