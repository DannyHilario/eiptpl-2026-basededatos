-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Consultorio
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Consultorio (
    idConsultorio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
