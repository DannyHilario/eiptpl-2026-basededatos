-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Trigger AFTER INSERT: después de cada INSERT en Cliente, informa cuántos registros se insertaron
-- Autor:       Daniel Hilario

USE AutoFixDB;
GO

CREATE TRIGGER trg_mensajeInsertarCliente
ON Cliente
AFTER INSERT
AS
BEGIN

	DECLARE @CantidadInsertada int

	-- inserted tiene una fila por cada cliente que insertó la sentencia

	SELECT
		@CantidadInsertada = COUNT(1)
	FROM inserted

	PRINT 'Registros correctamente insertados: ' + CONVERT(varchar(10), @CantidadInsertada)

END
