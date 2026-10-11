-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Crear tabla Pedido
-- Autor:       Daniel Hilario

USE LavaExpressDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idTipoServicio INT NOT NULL,
    FechaPedido DATE NOT NULL,
    Kilos DECIMAL(5,2) NOT NULL,
    PrecioPorKilo DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Pedido_TipoServicio FOREIGN KEY (idTipoServicio) REFERENCES TipoServicio(idTipoServicio),
    CONSTRAINT chk_Pedido_Kilos CHECK (Kilos > 0),
    CONSTRAINT chk_Pedido_PrecioPorKilo CHECK (PrecioPorKilo > 0)
);
