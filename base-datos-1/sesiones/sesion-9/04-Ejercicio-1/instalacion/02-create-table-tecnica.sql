-- Tema:        Ejercicio 1 - Etapa 4
-- Descripción: Crear tabla Tecnica
-- Autor:       Daniel Hilario

USE EscuelaDB;

CREATE TABLE Tecnica (
    idTecnica INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
