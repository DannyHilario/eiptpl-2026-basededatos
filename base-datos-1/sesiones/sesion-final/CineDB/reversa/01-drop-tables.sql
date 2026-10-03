-- Tema:        Reversa CineDB - Sesión Final
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE CineDB;

-- Paso 1: Boleto — depende de Funcion y de Cliente
DROP TABLE IF EXISTS Boleto;

-- Paso 2: Funcion — depende de Sala y de Pelicula
DROP TABLE IF EXISTS Funcion;

-- Paso 3: Pelicula — depende de Clasificacion y de Genero
DROP TABLE IF EXISTS Pelicula;

-- Paso 4: Sala — depende de TipoSala
DROP TABLE IF EXISTS Sala;

-- Paso 5: Cliente — ya no tiene dependientes tras eliminar Boleto
DROP TABLE IF EXISTS Cliente;

-- Paso 6: Genero — ya no tiene dependientes tras eliminar Pelicula
DROP TABLE IF EXISTS Genero;

-- Paso 7: Clasificacion — ya no tiene dependientes tras eliminar Pelicula
DROP TABLE IF EXISTS Clasificacion;

-- Paso 8: TipoSala — ya no tiene dependientes tras eliminar Sala
DROP TABLE IF EXISTS TipoSala;
