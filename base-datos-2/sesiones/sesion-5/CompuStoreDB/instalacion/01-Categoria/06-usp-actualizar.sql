-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar el nombre de una categoría
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarCategoria
	@p_idCategoria int,
	@p_Nombre varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@idCategoriaExistente int

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

	-- Validación del Nombre: no debe estar registrado por otra categoría

	SELECT
		@idCategoriaExistente = idCategoria
	FROM Categoria
	WHERE Nombre = @p_Nombre AND idCategoria <> @p_idCategoria

	IF @idCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El nombre ya está registrado por otra categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Nombre = @p_Nombre,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
