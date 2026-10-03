-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla TipoMovimiento
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE TipoMovimiento (
    idTipoMovimiento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    EsCargo BIT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
