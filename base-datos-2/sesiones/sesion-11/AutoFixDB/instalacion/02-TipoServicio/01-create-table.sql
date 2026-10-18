-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Crear tabla TipoServicio (igual que en Base de Datos I)
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE TipoServicio (
    idTipoServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Costo DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
