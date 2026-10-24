-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
