-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Actualizar la dirección de entrega y el costo de envío de un pedido en estatus Creado,
--              con validaciones y códigos de salida
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE PROCEDURE usp_actualizarPedido
	@p_idPedido int,
	@p_DireccionEntrega varchar(200),
	@p_CostoEnvio decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idEstatusPedido int

	-- Validación 1: el pedido debe existir

	SELECT
		@idEstatusPedido = idEstatusPedido
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idEstatusPedido IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 2: solo se modifica un pedido en estatus Creado

	IF @idEstatusPedido <> 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'Solo se puede modificar un pedido en estatus Creado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 3: la dirección de entrega no puede venir vacía

	IF @p_DireccionEntrega IS NULL OR LTRIM(RTRIM(@p_DireccionEntrega)) = '' BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La dirección de entrega es obligatoria'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 4: el costo de envío no puede ser negativo

	IF @p_CostoEnvio IS NULL OR @p_CostoEnvio < 0 BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El costo de envío no puede ser negativo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Pedido
	SET
		DireccionEntrega = @p_DireccionEntrega,
		CostoEnvio = @p_CostoEnvio,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Pedido actualizado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
