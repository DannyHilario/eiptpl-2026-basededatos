-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Sala
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Sala (
    idSala INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTipoSala INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Capacidad INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Sala_TipoSala FOREIGN KEY (idTipoSala) REFERENCES TipoSala(idTipoSala)
);
