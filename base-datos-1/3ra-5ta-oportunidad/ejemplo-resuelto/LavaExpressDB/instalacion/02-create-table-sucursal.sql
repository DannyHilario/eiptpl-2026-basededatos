-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Crear tabla Sucursal
-- Autor:       Daniel Hilario

USE LavaExpressDB;

CREATE TABLE Sucursal (
    idSucursal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Direccion VARCHAR(150) NOT NULL
);
