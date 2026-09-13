-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla HistoricoPrecioArticulo
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE HistoricoPrecioArticulo (
    idHistoricoPrecioArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idArticulo INT NOT NULL,
    PrecioAnterior DECIMAL(10,2) NOT NULL,
    PrecioNuevo DECIMAL(10,2) NOT NULL,
    Fecha DATETIME NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_HistoricoPrecioArticulo_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioAnterior CHECK (PrecioAnterior >= 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioNuevo CHECK (PrecioNuevo >= 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_Cambio CHECK (PrecioNuevo <> PrecioAnterior)
);
