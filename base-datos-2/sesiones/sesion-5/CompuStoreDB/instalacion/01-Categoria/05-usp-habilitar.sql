-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Habilitar (reactivar) una categoría dada de baja
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_habilitarCategoria
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@Activo bit

	-- Validación de la Categoria: Revisamos primero si el idCategoria existe en la tabla

	SELECT
		@Nombre = Nombre,
		@Activo = Activo
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: la categoría ya debe estar dada de baja

	IF @Activo = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La categoría ya está activa'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Activo = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Habilitación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
