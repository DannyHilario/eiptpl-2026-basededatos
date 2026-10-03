-- Tema:        Ejercicio 3 - ViajeYA (Reversa)
-- Descripción: Elimina todas las tablas de ViajeYA en orden inverso a las FK
-- Autor:       Daniel Hilario

USE ViajeYA;

-- Paso 1: Reservacion — depende de Cliente y de Destino
DROP TABLE IF EXISTS Reservacion;

-- Paso 2: Destino — depende de Pais y de TipoPaquete
DROP TABLE IF EXISTS Destino;

-- Paso 3: Cliente — ya no tiene dependientes tras eliminar Reservacion
DROP TABLE IF EXISTS Cliente;

-- Paso 4: TipoPaquete — ya no tiene dependientes tras eliminar Destino
DROP TABLE IF EXISTS TipoPaquete;

-- Paso 5: Pais — ya no tiene dependientes tras eliminar Destino
DROP TABLE IF EXISTS Pais;
