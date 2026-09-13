-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar el nombre y la marca de un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarArticulo
	@p_idArticulo int,
	@p_Nombre varchar(100),
	@p_Marca varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100),
			@idArticuloExistente int

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

	-- Validación del Nombre y Marca: no deben estar registrados por otro artículo

	SELECT
		@idArticuloExistente = idArticulo
	FROM Articulo
	WHERE Nombre = @p_Nombre AND Marca = @p_Marca AND idArticulo <> @p_idArticulo

	IF @idArticuloExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'Ya existe otro artículo registrado con ese nombre y marca'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Articulo
	SET
		Nombre = @p_Nombre,
		Marca = @p_Marca,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
