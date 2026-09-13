-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarArticulo
	@p_idArticulo int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100)

	-- Validación del Articulo: Revisamos primero si el idArticulo existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Articulo
	SET
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
