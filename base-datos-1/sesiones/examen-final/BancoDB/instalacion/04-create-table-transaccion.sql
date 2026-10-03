-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Transaccion
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Transaccion (
    idTransaccion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCuenta INT NOT NULL,
    idCliente INT NOT NULL,
    TipoTransaccion VARCHAR(20) NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaTransaccion DATE NOT NULL,
    HoraTransaccion TIME NOT NULL,
    CONSTRAINT fk_Transaccion_Cuenta FOREIGN KEY (idCuenta) REFERENCES Cuenta(idCuenta),
    CONSTRAINT fk_Transaccion_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT chk_Transaccion_Tipo CHECK (TipoTransaccion IN ('Depósito', 'Retiro', 'Transferencia')),
    CONSTRAINT chk_Transaccion_Monto CHECK (Monto > 0)
);
