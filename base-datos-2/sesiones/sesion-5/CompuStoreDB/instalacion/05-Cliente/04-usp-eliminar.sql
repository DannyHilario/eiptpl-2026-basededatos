-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de un cliente
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

ALTER PROCEDURE usp_eliminarCliente
	@p_idCliente int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50)

	-- Validación del Cliente: Revisamos primero si el idCliente existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Cliente
	SET 
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idCliente = @p_idCliente

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
