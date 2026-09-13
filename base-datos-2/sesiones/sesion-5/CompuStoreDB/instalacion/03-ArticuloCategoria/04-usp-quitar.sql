-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Quitar la asignación de una categoría a un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_quitarCategoriaArticulo
	@p_idArticulo int,
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloCategoriaExistente int

	-- Validación de la relación: debe existir

	SELECT
		@idArticuloCategoriaExistente = idArticuloCategoria
	FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	IF @idArticuloCategoriaExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no está asignado a esa categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	DELETE FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
