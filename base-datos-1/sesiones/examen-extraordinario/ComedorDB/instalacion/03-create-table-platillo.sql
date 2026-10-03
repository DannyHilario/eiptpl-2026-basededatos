-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Platillo
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Platillo (
    idPlatillo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(200),
    Precio DECIMAL(8,2) NOT NULL,
    CONSTRAINT chk_Platillo_Precio CHECK (Precio > 0)
);
