-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear un pedido en estatus Creado y registrar su primer estatus en la bitácora,
--              con validaciones y códigos de salida
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE PROCEDURE usp_crearPedido
	@p_idCliente int,
	@p_DireccionEntrega varchar(200),
	@p_CostoEnvio decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idClienteExistente int,
			@idPedido int

	-- Validación 1: el cliente debe existir y estar activo

	SELECT
		@idClienteExistente = idCliente
	FROM Cliente
	WHERE idCliente = @p_idCliente
		AND Activo = 1

	IF @idClienteExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe o no está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 2: la dirección de entrega no puede venir vacía

	IF @p_DireccionEntrega IS NULL OR LTRIM(RTRIM(@p_DireccionEntrega)) = '' BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La dirección de entrega es obligatoria'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 3: el costo de envío no puede ser negativo

	IF @p_CostoEnvio IS NULL OR @p_CostoEnvio < 0 BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El costo de envío no puede ser negativo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- El pedido nace en estatus Creado, sin líneas y con total 0 (los DEFAULT de la tabla)

	INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
	VALUES (@p_idCliente, @p_DireccionEntrega, @p_CostoEnvio)

	SELECT @idPedido = SCOPE_IDENTITY()

	-- Primer estatus en la bitácora

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido)
	VALUES (@idPedido, 1)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Pedido creado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje,
			@idPedido as idPedido

END
