-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla BitacoraEstatusPedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE BitacoraEstatusPedido (
    idBitacoraEstatusPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPedido INT NOT NULL,
    idEstatusPedido INT NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_BitacoraEstatusPedido_Pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT fk_BitacoraEstatusPedido_EstatusPedido FOREIGN KEY (idEstatusPedido) REFERENCES EstatusPedido(idEstatusPedido),
    CONSTRAINT uq_BitacoraEstatusPedido_Pedido_Estatus UNIQUE (idPedido, idEstatusPedido)
);
