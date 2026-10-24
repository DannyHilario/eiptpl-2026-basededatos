-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Pedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idEstatusPedido INT NOT NULL DEFAULT 1,
    FechaPedido DATETIME NOT NULL DEFAULT GETDATE(),
    DireccionEntrega VARCHAR(200) NOT NULL,
    CostoEnvio DECIMAL(10,2) NOT NULL DEFAULT 0,
    CantidadArticulos INT NOT NULL DEFAULT 0,
    Total DECIMAL(12,2) NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Pedido_EstatusPedido FOREIGN KEY (idEstatusPedido) REFERENCES EstatusPedido(idEstatusPedido),
    CONSTRAINT chk_Pedido_CostoEnvio CHECK (CostoEnvio >= 0),
    CONSTRAINT chk_Pedido_CantidadArticulos CHECK (CantidadArticulos >= 0),
    CONSTRAINT chk_Pedido_Total CHECK (Total >= 0)
);
