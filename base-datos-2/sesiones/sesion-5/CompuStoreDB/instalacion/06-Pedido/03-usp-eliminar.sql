-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja de un pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarPedido
	@p_idPedido int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int,
			@idDetallePedidoExistente int

	-- Validación del Pedido: debe existir

	SELECT
		@idCliente = idCliente
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idCliente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del DetallePedido: no debe tener líneas registradas

	SELECT
		@idDetallePedidoExistente = idDetallePedido
	FROM DetallePedido
	WHERE idPedido = @p_idPedido

	IF @idDetallePedidoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido tiene líneas registradas y no puede eliminarse'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	DELETE FROM Pedido
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
