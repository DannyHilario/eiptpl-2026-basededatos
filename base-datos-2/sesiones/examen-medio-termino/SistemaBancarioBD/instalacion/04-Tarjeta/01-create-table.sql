-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Tarjeta
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Tarjeta (
    idTarjeta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idTipoTarjetaCredito INT NOT NULL,
    NumeroTarjeta CHAR(16) NOT NULL UNIQUE,
    FechaEmision DATE NOT NULL,
    FechaVencimiento DATE NOT NULL,
    LimiteCredito DECIMAL(12,2) NOT NULL,
    SaldoActual DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Tarjeta_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Tarjeta_TipoTarjetaCredito FOREIGN KEY (idTipoTarjetaCredito) REFERENCES TipoTarjetaCredito(idTipoTarjetaCredito),
    CONSTRAINT uq_Tarjeta_Cliente_TipoTarjetaCredito UNIQUE (idCliente, idTipoTarjetaCredito),
    CONSTRAINT chk_Tarjeta_LimiteCredito CHECK (LimiteCredito > 0),
    CONSTRAINT chk_Tarjeta_SaldoActual CHECK (SaldoActual >= 0 AND SaldoActual <= LimiteCredito),
    CONSTRAINT chk_Tarjeta_FechaVencimiento CHECK (FechaVencimiento > FechaEmision)
);
