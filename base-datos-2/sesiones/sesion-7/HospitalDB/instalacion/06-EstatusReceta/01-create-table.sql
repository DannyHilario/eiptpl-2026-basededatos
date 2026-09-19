-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla EstatusReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE EstatusReceta (
    idEstatusReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
