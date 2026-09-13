-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja de una línea de pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarDetallePedido
	@p_idDetallePedido int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idPedido int,
			@Cerrado bit

	-- Validación del DetallePedido: debe existir

	SELECT
		@idPedido = idPedido
	FROM DetallePedido
	WHERE idDetallePedido = @p_idDetallePedido

	IF @idPedido IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La línea de pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: el pedido no debe estar entregado

	SELECT
		@Cerrado = Cerrado
	FROM Pedido
	WHERE idPedido = @idPedido

	IF @Cerrado = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido ya fue entregado y no admite cambios en sus líneas'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	DELETE FROM DetallePedido
	WHERE idDetallePedido = @p_idDetallePedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
