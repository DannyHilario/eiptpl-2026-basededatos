-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    Fecha DATE NOT NULL,
    Cerrado BIT NOT NULL DEFAULT 0,
    FechaEntrega DATE NOT NULL DEFAULT '1900-01-01',
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
