-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
