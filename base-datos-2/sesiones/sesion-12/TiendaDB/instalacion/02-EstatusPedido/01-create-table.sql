-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla EstatusPedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE EstatusPedido (
    idEstatusPedido INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
