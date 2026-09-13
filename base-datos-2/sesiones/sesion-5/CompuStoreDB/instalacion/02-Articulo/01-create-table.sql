-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Articulo
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Articulo (
    idArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Articulo_PrecioUnitario CHECK (PrecioUnitario > 0),
    CONSTRAINT uq_Articulo_Nombre_Marca UNIQUE (Nombre, Marca)
);
