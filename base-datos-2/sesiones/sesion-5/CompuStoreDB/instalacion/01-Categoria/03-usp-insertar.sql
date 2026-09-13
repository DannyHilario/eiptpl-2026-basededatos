-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de una categoría, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarCategoria
	@p_Nombre varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCategoriaExistente int

	-- Validación de la Categoria: no debe estar registrada con el mismo Nombre

	SELECT
		@idCategoriaExistente = idCategoria
	FROM Categoria
	WHERE Nombre = @p_Nombre

	IF @idCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría ya está registrada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Categoria (Nombre)
	VALUES (@p_Nombre)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
