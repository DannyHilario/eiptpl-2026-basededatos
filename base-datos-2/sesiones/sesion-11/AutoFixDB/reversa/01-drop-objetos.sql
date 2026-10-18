-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Reversa: eliminar los triggers y el procedimiento almacenado
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Paso 1: triggers de Cliente (también se eliminarían solos al borrar la tabla Cliente)
DROP TRIGGER IF EXISTS trg_registroAuditoriaOperacionCliente;
DROP TRIGGER IF EXISTS trg_mensajeInsertarCliente;

-- Paso 2: procedimiento almacenado
DROP PROCEDURE IF EXISTS usp_insertarCliente;
