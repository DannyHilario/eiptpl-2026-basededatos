-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de una línea de pedido, fusionando cantidades si el artículo ya está en el pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarDetallePedido
	@p_idPedido int,
	@p_idArticulo int,
	@p_Cantidad int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int,
			@Cerrado bit,
			@PrecioUnitario decimal(10,2),
			@Activo bit,
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

	-- Validación del estado: el pedido no debe estar entregado

	IF @Cerrado = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido ya fue entregado y no admite nuevas líneas'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Articulo: debe existir

	SELECT
		@PrecioUnitario = PrecioUnitario,
		@Activo = Activo
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @PrecioUnitario IS NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Articulo: debe estar activo

	IF @Activo = 0 BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El artículo está dado de baja'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Cantidad: debe ser mayor a cero

	IF @p_Cantidad <= 0 BEGIN

		SELECT 	@ErrCodigo = '000005',
				@ErrMensaje = 'La cantidad debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Fusión: si el artículo ya está en el pedido, se suma la cantidad a esa línea en vez de duplicarla
	-- (coincide con el UNIQUE(idPedido, idArticulo) de la tabla). El PrecioUnitario de la línea existente
	-- no se toca: es el precio que ya quedó pactado la primera vez que se agregó ese artículo al pedido.

	SELECT
		@idDetallePedidoExistente = idDetallePedido
	FROM DetallePedido
	WHERE idPedido = @p_idPedido AND idArticulo = @p_idArticulo

	IF @idDetallePedidoExistente IS NOT NULL BEGIN

		UPDATE DetallePedido
		SET
			Cantidad = Cantidad + @p_Cantidad,
			FechaUltimaModificacion = GETDATE()
		WHERE idDetallePedido = @idDetallePedidoExistente

		SELECT 	@ErrCodigo = '000000',
				@ErrMensaje = 'Cantidad sumada a la línea existente'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- El PrecioUnitario se toma del precio vigente del artículo, no se recibe como parámetro,
	-- para dejar congelado el precio real de la venta aunque el precio de lista cambie después

	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	VALUES (@p_idPedido, @p_idArticulo, @p_Cantidad, @PrecioUnitario)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
