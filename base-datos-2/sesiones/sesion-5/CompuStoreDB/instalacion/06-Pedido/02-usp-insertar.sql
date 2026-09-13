-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de un pedido, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarPedido
	@p_idCliente int,
	@p_Fecha date
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@ClienteActivo bit

	-- Validación del Cliente: debe existir

	SELECT
		@ClienteActivo = Activo
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @ClienteActivo IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Cliente: debe estar activo

	IF @ClienteActivo = 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El cliente está dado de baja'

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

	INSERT INTO Pedido (idCliente, Fecha)
	VALUES (@p_idCliente, @p_Fecha)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
