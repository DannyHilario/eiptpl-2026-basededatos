-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Asignar una categoría a un artículo, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_asignarCategoriaArticulo
	@p_idArticulo int,
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloEncontrado int,
			@idCategoriaEncontrada int,
			@idArticuloCategoriaExistente int

	-- Validación del Articulo: debe existir

	SELECT
		@idArticuloEncontrado = idArticulo
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @idArticuloEncontrado IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Categoria: debe existir

	SELECT
		@idCategoriaEncontrada = idCategoria
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @idCategoriaEncontrada IS NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la relación: no debe existir ya esa combinación

	SELECT
		@idArticuloCategoriaExistente = idArticuloCategoria
	FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	IF @idArticuloCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El artículo ya está asignado a esa categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
	VALUES (@p_idArticulo, @p_idCategoria)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Asignación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
