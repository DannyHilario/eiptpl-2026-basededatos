-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla Consultorio
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Consultorio (
    idConsultorio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
