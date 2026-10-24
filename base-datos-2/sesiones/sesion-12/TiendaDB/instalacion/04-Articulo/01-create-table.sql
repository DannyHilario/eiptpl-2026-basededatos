-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Articulo
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Articulo (
    idArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idClasificacion INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Articulo_Clasificacion FOREIGN KEY (idClasificacion) REFERENCES Clasificacion(idClasificacion),
    CONSTRAINT chk_Articulo_PrecioUnitario CHECK (PrecioUnitario > 0)
);
