-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Categoria
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Categoria (
    idCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
