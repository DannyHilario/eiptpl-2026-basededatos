-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla TipoTarjetaCredito
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE TipoTarjetaCredito (
    idTipoTarjetaCredito INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    LimiteCreditoMinimo DECIMAL(12,2) NOT NULL,
    LimiteCreditoMaximo DECIMAL(12,2) NOT NULL,
    Anualidad DECIMAL(10,2) NOT NULL,
    TasaInteresAnual DECIMAL(5,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_TipoTarjetaCredito_LimiteCreditoMinimo CHECK (LimiteCreditoMinimo > 0),
    CONSTRAINT chk_TipoTarjetaCredito_LimiteCreditoMaximo CHECK (LimiteCreditoMaximo > LimiteCreditoMinimo),
    CONSTRAINT chk_TipoTarjetaCredito_Anualidad CHECK (Anualidad >= 0),
    CONSTRAINT chk_TipoTarjetaCredito_TasaInteresAnual CHECK (TasaInteresAnual >= 0)
);
