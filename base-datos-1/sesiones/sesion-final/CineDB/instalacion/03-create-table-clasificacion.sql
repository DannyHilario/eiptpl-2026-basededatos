-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Clasificacion
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Clasificacion (
    idClasificacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(10) NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
