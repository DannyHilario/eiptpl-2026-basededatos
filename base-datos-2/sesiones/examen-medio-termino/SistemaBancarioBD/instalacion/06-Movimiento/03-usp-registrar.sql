-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Registrar un movimiento de tarjeta y actualizar su SaldoActual
--              (única vía permitida para insertar en Movimiento)
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;
GO

CREATE PROCEDURE usp_registrarMovimiento
	@p_idTarjeta int,
	@p_idTipoMovimiento int,
	@p_Monto decimal(12,2),
	@p_Descripcion varchar(100)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@ActivoTarjeta bit,
			@FechaVencimiento date,
			@LimiteCredito decimal(12,2),
			@SaldoActual decimal(12,2),
			@EsCargo bit

	-- Validación de la Tarjeta: revisamos primero si el idTarjeta existe en la tabla

	SELECT @ActivoTarjeta = Activo,
		@FechaVencimiento = FechaVencimiento,
		@LimiteCredito = LimiteCredito,
		@SaldoActual = SaldoActual
	FROM Tarjeta
	WHERE idTarjeta = @p_idTarjeta

	IF @ActivoTarjeta IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La tarjeta no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de tarjeta cancelada (baja lógica)

	IF @ActivoTarjeta = 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La tarjeta está cancelada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de tarjeta vencida

	IF @FechaVencimiento < CAST(GETDATE() AS date) BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La tarjeta está vencida'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del TipoMovimiento: revisamos si el idTipoMovimiento existe en la tabla

	SELECT @EsCargo = EsCargo
	FROM TipoMovimiento
	WHERE idTipoMovimiento = @p_idTipoMovimiento

	IF @EsCargo IS NULL BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El tipo de movimiento no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del monto

	IF @p_Monto IS NULL OR @p_Monto <= 0 BEGIN

		SELECT 	@ErrCodigo = '000005',
				@ErrMensaje = 'El monto debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de crédito disponible (cargos) y de saldo suficiente (abonos)

	IF @EsCargo = 1 AND @SaldoActual + @p_Monto > @LimiteCredito BEGIN

		SELECT 	@ErrCodigo = '000006',
				@ErrMensaje = 'El cargo excede el crédito disponible'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	IF @EsCargo = 0 AND @p_Monto > @SaldoActual BEGIN

		SELECT 	@ErrCodigo = '000007',
				@ErrMensaje = 'El abono es mayor que el saldo de la tarjeta'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Registro del movimiento y ajuste del saldo de la tarjeta

	INSERT INTO Movimiento (idTarjeta, idTipoMovimiento, Monto, FechaMovimiento, Descripcion)
	VALUES (@p_idTarjeta, @p_idTipoMovimiento, @p_Monto, GETDATE(), @p_Descripcion)

	IF @EsCargo = 1 BEGIN

		UPDATE Tarjeta
		SET
			SaldoActual = SaldoActual + @p_Monto,
			FechaUltimaModificacion = GETDATE()
		WHERE idTarjeta = @p_idTarjeta
	END
	ELSE BEGIN

		UPDATE Tarjeta
		SET
			SaldoActual = SaldoActual - @p_Monto,
			FechaUltimaModificacion = GETDATE()
		WHERE idTarjeta = @p_idTarjeta
	END

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Movimiento registrado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
