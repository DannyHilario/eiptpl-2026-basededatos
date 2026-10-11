-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Crear tabla TipoServicio
-- Autor:       Daniel Hilario

USE LavaExpressDB;

CREATE TABLE TipoServicio (
    idTipoServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    PrecioPorKilo DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_TipoServicio_PrecioPorKilo CHECK (PrecioPorKilo > 0)
);
