-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE LavaExpressDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idSucursal INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    FechaRegistro DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Cliente_Sucursal FOREIGN KEY (idSucursal) REFERENCES Sucursal(idSucursal)
);
