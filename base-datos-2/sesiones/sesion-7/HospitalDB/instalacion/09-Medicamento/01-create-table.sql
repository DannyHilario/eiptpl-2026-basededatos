-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Medicamento
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Medicamento (
    idMedicamento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uq_Medicamento_Nombre_Marca UNIQUE (Nombre, Marca)
);
