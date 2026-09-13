-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Consultar el detalle (encabezado + líneas) de un solo pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_obtenerDetallePedido
	@p_idPedido int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int

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

	-- Consulta: encabezado del pedido + una línea por artículo (0 renglones si el pedido no tiene líneas)

	SELECT
		p.idPedido,
		p.Fecha,
		p.Cerrado,
		p.FechaEntrega,
		dp.idDetallePedido,
		a.idArticulo,
		a.Nombre AS Articulo,
		a.Marca,
		dp.Cantidad,
		dp.PrecioUnitario,
		dp.Cantidad * dp.PrecioUnitario AS Subtotal
	FROM Pedido p
	INNER JOIN DetallePedido dp ON dp.idPedido = p.idPedido
	INNER JOIN Articulo a ON a.idArticulo = dp.idArticulo
	WHERE p.idPedido = @p_idPedido

END
