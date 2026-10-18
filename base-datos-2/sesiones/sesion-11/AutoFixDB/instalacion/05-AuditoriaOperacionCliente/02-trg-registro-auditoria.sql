-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Trigger AFTER INSERT, UPDATE, DELETE sobre Cliente: registra en AuditoriaOperacionCliente
--              un renglón por cada cliente afectado, con el tipo de operación (I, U o D)
-- Autor:       Daniel Hilario

USE AutoFixDB;
GO

CREATE TRIGGER trg_registroAuditoriaOperacionCliente
ON Cliente
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

	DECLARE @RegistrosInsertados int,
			@RegistrosEliminados int,
			@Operacion char(1)

	-- Contar registros insertados y eliminados por la sentencia

	SELECT
		@RegistrosInsertados = COUNT(1)
	FROM inserted

	SELECT
		@RegistrosEliminados = COUNT(1)
	FROM deleted

	-- La sentencia no afectó ninguna fila (por ejemplo, un DELETE cuyo WHERE no encontró nada):
	-- no hay nada que auditar

	IF @RegistrosInsertados = 0 AND @RegistrosEliminados = 0 BEGIN
		RETURN
	END

	-- Deducir la operación:
	--   UPDATE -> inserted (valores nuevos) y deleted (valores anteriores) tienen filas
	--   INSERT -> solo inserted tiene filas
	--   DELETE -> solo deleted tiene filas

	IF @RegistrosInsertados > 0 AND @RegistrosEliminados > 0 BEGIN
		SELECT @Operacion = 'U'
	END
	ELSE IF @RegistrosInsertados > 0 BEGIN
		SELECT @Operacion = 'I'
	END
	ELSE BEGIN
		SELECT @Operacion = 'D'
	END

	-- Un renglón por cada cliente afectado. FechaOperacion toma su DEFAULT GETDATE()

	IF @Operacion = 'D' BEGIN

		INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
		SELECT idCliente, @Operacion
		FROM deleted

	END
	ELSE BEGIN

		INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
		SELECT idCliente, @Operacion
		FROM inserted

	END

END
