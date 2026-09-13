-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de un artículo, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarArticulo
	@p_Nombre varchar(100),
	@p_Marca varchar(50),
	@p_PrecioUnitario decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloExistente int

	-- Validación del PrecioUnitario: debe ser mayor a cero

	IF @p_PrecioUnitario <= 0 BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El precio unitario debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Articulo: no debe estar registrado con el mismo Nombre y Marca

	SELECT
		@idArticuloExistente = idArticulo
	FROM Articulo
	WHERE Nombre = @p_Nombre AND Marca = @p_Marca

	IF @idArticuloExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El artículo ya está registrado con esa marca'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Articulo (Nombre, Marca, PrecioUnitario)
	VALUES (@p_Nombre, @p_Marca, @p_PrecioUnitario)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
