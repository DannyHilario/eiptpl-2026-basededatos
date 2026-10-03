-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Vehiculo
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Vehiculo (
    idVehiculo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Anio INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Vehiculo_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
