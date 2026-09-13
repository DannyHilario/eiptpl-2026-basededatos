-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar la cantidad de una línea de pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarDetallePedido
	@p_idDetallePedido int,
	@p_Cantidad int
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

	-- Validación de la Cantidad: debe ser mayor a cero

	IF @p_Cantidad <= 0 BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La cantidad debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Solo se actualiza la Cantidad: el Articulo, el Pedido y el PrecioUnitario de la venta no se modifican

	UPDATE DetallePedido
	SET
		Cantidad = @p_Cantidad,
		FechaUltimaModificacion = GETDATE()
	WHERE idDetallePedido = @p_idDetallePedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
