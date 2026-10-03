-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Movimiento
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Movimiento (
    idMovimiento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTarjeta INT NOT NULL,
    idTipoMovimiento INT NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaMovimiento DATETIME NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Movimiento_Tarjeta FOREIGN KEY (idTarjeta) REFERENCES Tarjeta(idTarjeta),
    CONSTRAINT fk_Movimiento_TipoMovimiento FOREIGN KEY (idTipoMovimiento) REFERENCES TipoMovimiento(idTipoMovimiento),
    CONSTRAINT chk_Movimiento_Monto CHECK (Monto > 0)
);
