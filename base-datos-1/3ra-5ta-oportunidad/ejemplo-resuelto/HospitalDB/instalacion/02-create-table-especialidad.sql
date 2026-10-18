-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla Especialidad
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Especialidad (
    idEspecialidad INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
