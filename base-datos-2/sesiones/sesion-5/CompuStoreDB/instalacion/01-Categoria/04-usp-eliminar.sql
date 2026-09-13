-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de una categoría
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarCategoria
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50)

	-- Validación de la Categoria: Revisamos primero si el idCategoria existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
