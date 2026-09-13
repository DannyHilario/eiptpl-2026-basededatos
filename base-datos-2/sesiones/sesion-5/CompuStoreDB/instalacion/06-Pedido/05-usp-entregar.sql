-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Marcar un pedido como entregado (lo cierra para futuras modificaciones)
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_entregarPedido
	@p_idPedido int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int,
			@Cerrado bit,
			@idDetallePedidoExistente int

	-- Validación del Pedido: debe existir

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

	-- Validación del estado: el pedido no debe estar ya entregado

	IF @Cerrado = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido ya fue entregado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del DetallePedido: el pedido debe tener al menos una línea registrada

	SELECT
		@idDetallePedidoExistente = idDetallePedido
	FROM DetallePedido
	WHERE idPedido = @p_idPedido

	IF @idDetallePedidoExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El pedido no tiene líneas registradas y no puede entregarse'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Pedido
	SET
		Cerrado = 1,
		FechaEntrega = GETDATE(),
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Entrega registrada correctamente'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
