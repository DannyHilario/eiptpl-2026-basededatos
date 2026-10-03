-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idSucursal INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Sexo CHAR(1) NOT NULL,
    CURP CHAR(18) NOT NULL UNIQUE,
    RFC CHAR(13) NOT NULL UNIQUE,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    CorreoElectronico VARCHAR(100) NOT NULL UNIQUE,
    Direccion VARCHAR(200) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Cliente_Sucursal FOREIGN KEY (idSucursal) REFERENCES Sucursal(idSucursal),
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);
