-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Sucursal
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Sucursal (
    idSucursal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
