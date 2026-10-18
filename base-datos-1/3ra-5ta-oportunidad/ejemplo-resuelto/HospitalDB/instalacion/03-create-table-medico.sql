-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla Medico
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Medico (
    idMedico INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Cedula VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NOT NULL UNIQUE,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
