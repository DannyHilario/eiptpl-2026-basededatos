-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Habilitar (reactivar) un cliente dado de baja
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_habilitarCliente
	@p_idCliente int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@Activo bit

	-- Validación del Cliente: Revisamos primero si el idCliente existe en la tabla

	SELECT
		@Nombre = Nombre,
		@Activo = Activo
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: el cliente ya debe estar dado de baja

	IF @Activo = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El cliente ya está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Cliente
	SET
		Activo = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idCliente = @p_idCliente

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Habilitación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
