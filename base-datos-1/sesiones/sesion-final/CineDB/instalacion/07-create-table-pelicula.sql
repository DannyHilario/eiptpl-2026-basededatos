-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Pelicula
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Pelicula (
    idPelicula INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idClasificacion INT NOT NULL,
    idGenero INT NOT NULL,
    Nombre VARCHAR(200) NOT NULL,
    Duracion INT NOT NULL,
    Director VARCHAR(150) NOT NULL,
    AnioEstreno INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Pelicula_Clasificacion FOREIGN KEY (idClasificacion) REFERENCES Clasificacion(idClasificacion),
    CONSTRAINT fk_Pelicula_Genero FOREIGN KEY (idGenero) REFERENCES Genero(idGenero)
);
