-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Cuenta
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Cuenta (
    idCuenta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NumeroCuenta CHAR(10) NOT NULL,
    TipoCuenta VARCHAR(20) NOT NULL,
    FechaApertura DATE NOT NULL,
    FechaCancelacion DATE,
    SaldoActual DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT uq_Cuenta_NumeroCuenta UNIQUE (NumeroCuenta),
    CONSTRAINT chk_Cuenta_TipoCuenta CHECK (TipoCuenta IN ('Débito', 'Nómina', 'Ahorro')),
    CONSTRAINT chk_Cuenta_Saldo CHECK (SaldoActual >= 0)
);
