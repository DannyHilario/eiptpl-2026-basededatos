-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla DetallePedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE DetallePedido (
    idDetallePedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPedido INT NOT NULL,
    idArticulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_DetallePedido_Pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT fk_DetallePedido_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT chk_DetallePedido_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT chk_DetallePedido_PrecioUnitario CHECK (PrecioUnitario > 0)
);
