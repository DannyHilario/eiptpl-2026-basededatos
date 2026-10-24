-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Clasificacion
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Clasificacion (
    idClasificacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
