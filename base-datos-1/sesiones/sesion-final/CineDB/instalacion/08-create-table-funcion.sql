-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Funcion
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Funcion (
    idFuncion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idSala INT NOT NULL,
    idPelicula INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    CantidadVendida INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_Funcion_Sala FOREIGN KEY (idSala) REFERENCES Sala(idSala),
    CONSTRAINT fk_Funcion_Pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(idPelicula),
    CONSTRAINT uq_Funcion_SalaFechaHora UNIQUE (idSala, Fecha, Hora)
);
