-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Correo VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
