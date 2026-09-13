-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(20) UNIQUE,
    Correo VARCHAR(100) UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);
