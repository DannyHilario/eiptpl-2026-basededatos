-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla EstatusReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE EstatusReceta (
    idEstatusReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
