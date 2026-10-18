-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Reversa: eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Paso 1: AuditoriaOperacionCliente — no tiene llaves foráneas ni nadie depende de ella
DROP TABLE IF EXISTS AuditoriaOperacionCliente;

-- Paso 2: Servicio — depende de Vehiculo y de TipoServicio
DROP TABLE IF EXISTS Servicio;

-- Paso 3: Vehiculo — depende de Cliente; ya no tiene dependientes tras eliminar Servicio
DROP TABLE IF EXISTS Vehiculo;

-- Paso 4: TipoServicio — ya no tiene dependientes tras eliminar Servicio
DROP TABLE IF EXISTS TipoServicio;

-- Paso 5: Cliente — ya no tiene dependientes tras eliminar Vehiculo
DROP TABLE IF EXISTS Cliente;
