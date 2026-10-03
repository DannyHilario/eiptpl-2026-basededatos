-- Tema:        Reversa ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE ComedorDB;

-- Paso 1: Servicio — depende de Empleado y de Platillo
DROP TABLE IF EXISTS Servicio;

-- Paso 2: Platillo — ya no tiene dependientes tras eliminar Servicio
DROP TABLE IF EXISTS Platillo;

-- Paso 3: Empleado — ya no tiene dependientes tras eliminar Servicio
DROP TABLE IF EXISTS Empleado;
