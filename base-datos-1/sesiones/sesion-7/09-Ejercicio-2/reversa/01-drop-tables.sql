-- Tema:        Reversa Ejercicio 2 - Hotel Vista
-- Descripción: Eliminar tablas del modelo Hotel Vista en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE CursoDB;

-- Paso 1: Reservacion — depende de Huesped y de Habitacion
DROP TABLE IF EXISTS Reservacion;

-- Paso 2: Huesped — ya no tiene dependientes tras eliminar Reservacion
DROP TABLE IF EXISTS Huesped;

-- Paso 3: Habitacion — ya no tiene dependientes tras eliminar Reservacion
DROP TABLE IF EXISTS Habitacion;

-- Paso 4: TipoHabitacion — ya no tiene dependientes tras eliminar Habitacion
DROP TABLE IF EXISTS TipoHabitacion;
