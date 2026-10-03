-- Tema:        Reversa Ejercicio 2 - Etapa 4
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Paso 1: Servicio primero — depende de Vehiculo y de TipoServicio
DROP TABLE IF EXISTS Servicio;

-- Paso 2: Vehiculo — depende de Cliente; ya no tiene dependientes
DROP TABLE IF EXISTS Vehiculo;

-- Paso 3: TipoServicio — ya no tiene dependientes tras eliminar Servicio
DROP TABLE IF EXISTS TipoServicio;

-- Paso 4: Cliente — ya no tiene dependientes tras eliminar Vehiculo
DROP TABLE IF EXISTS Cliente;
