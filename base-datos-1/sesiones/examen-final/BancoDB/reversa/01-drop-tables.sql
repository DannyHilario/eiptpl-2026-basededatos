-- Tema:        BancoDB - Examen Final
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE BancoDB;

-- Paso 1: Transaccion — depende de Cuenta y de Cliente
DROP TABLE IF EXISTS Transaccion;

-- Paso 2: Cuenta — ya no tiene dependientes tras eliminar Transaccion
DROP TABLE IF EXISTS Cuenta;

-- Paso 3: Cliente — ya no tiene dependientes tras eliminar Transaccion
DROP TABLE IF EXISTS Cliente;
