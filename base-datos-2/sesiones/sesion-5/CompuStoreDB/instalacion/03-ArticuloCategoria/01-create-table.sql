-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla ArticuloCategoria (relación N:N entre Articulo y Categoria)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE ArticuloCategoria (
    idArticuloCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idArticulo INT NOT NULL,
    idCategoria INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_ArticuloCategoria_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT fk_ArticuloCategoria_Categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
    CONSTRAINT uq_ArticuloCategoria_Articulo_Categoria UNIQUE (idArticulo, idCategoria)
);
