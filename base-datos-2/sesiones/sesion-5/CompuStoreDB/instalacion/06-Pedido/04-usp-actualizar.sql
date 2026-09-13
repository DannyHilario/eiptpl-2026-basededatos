-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar la fecha de un pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarPedido
	@p_idPedido int,
	@p_Fecha date
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int,
			@Cerrado bit

	-- Validación del Pedido: Revisamos primero si el idPedido existe en la tabla

	SELECT
		@idCliente = idCliente,
		@Cerrado = Cerrado
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idCliente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: el pedido no debe estar entregado

	IF @Cerrado = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido ya fue entregado y no puede modificarse'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Fecha: no puede ser fecha pasada

	IF @p_Fecha < GETDATE() BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La fecha no puede ser pasada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Pedido
	SET
		Fecha = @p_Fecha,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
