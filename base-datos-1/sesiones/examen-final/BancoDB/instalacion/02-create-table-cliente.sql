-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    CURP CHAR(18),
    RFC CHAR(13),
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(15),
    CorreoElectronico VARCHAR(100),
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);
