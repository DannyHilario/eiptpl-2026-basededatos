-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Genero
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Genero (
    idGenero INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
