-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla TipoSala
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE TipoSala (
    idTipoSala INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
