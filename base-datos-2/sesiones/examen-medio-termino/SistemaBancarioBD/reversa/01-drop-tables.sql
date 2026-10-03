-- Tema:        Reversa SistemaBancarioBD - Examen de Medio Término
-- Descripción: Eliminar el procedimiento y las tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

-- Paso 0: procedimiento almacenado
DROP PROCEDURE IF EXISTS usp_registrarMovimiento;

-- Paso 1: Movimiento — depende de Tarjeta y de TipoMovimiento
DROP TABLE IF EXISTS Movimiento;

-- Paso 2: TipoMovimiento — ya no tiene dependientes tras eliminar Movimiento
DROP TABLE IF EXISTS TipoMovimiento;

-- Paso 3: Tarjeta — depende de Cliente y de TipoTarjetaCredito
DROP TABLE IF EXISTS Tarjeta;

-- Paso 4: TipoTarjetaCredito — ya no tiene dependientes tras eliminar Tarjeta
DROP TABLE IF EXISTS TipoTarjetaCredito;

-- Paso 5: Cliente — depende de Sucursal; ya no tiene dependientes tras eliminar Tarjeta
DROP TABLE IF EXISTS Cliente;

-- Paso 6: Sucursal — ya no tiene dependientes tras eliminar Cliente
DROP TABLE IF EXISTS Sucursal;
