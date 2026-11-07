-- Tema:        Sesión 14 - Manejo de excepciones en procedimientos almacenados
-- Descripción: usp_insertarCategoria con TRY CATCH: lo que no atrapan las validaciones
--              responde con el código 999999 en lugar de un error en rojo
-- Autor:       Daniel Hilario

ALTER PROCEDURE usp_insertarCategoria
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

	-- NUEVO: el INSERT va dentro del TRY. Si falla, el código 000000 nunca se asigna:
	-- el control salta al CATCH

	BEGIN TRY

		INSERT INTO Categoria (Nombre)
		VALUES (@p_Nombre)

		SELECT 	@ErrCodigo = '000000',
				@ErrMensaje = 'Inserción correcta'

	END TRY
	BEGIN CATCH

		-- NUEVO: la excepción. Lo que se escapó a las validaciones

		SELECT 	@ErrCodigo = '999999',
				@ErrMensaje = 'Error ' + CONVERT(varchar(10), ERROR_NUMBER()) + ': ' + ERROR_MESSAGE()

	END CATCH

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
