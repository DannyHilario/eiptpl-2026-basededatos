-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar el precio de un artículo, registrando el cambio en el histórico
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarPrecioArticulo
	@p_idArticulo int,
	@p_PrecioNuevo decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100),
			@PrecioAnterior decimal(10,2)

	-- Validación del Articulo: Revisamos primero si el idArticulo existe en la tabla

	SELECT
		@Nombre = Nombre,
		@PrecioAnterior = PrecioUnitario
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del PrecioNuevo: debe ser mayor a cero

	IF @p_PrecioNuevo <= 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El precio nuevo debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del PrecioNuevo: debe ser diferente al precio actual

	IF @p_PrecioNuevo = @PrecioAnterior BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El precio nuevo debe ser diferente al precio anterior'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	EXEC usp_insertarHistoricoPrecioArticulo
		@p_idArticulo = @p_idArticulo,
		@p_PrecioNuevo = @p_PrecioNuevo

	UPDATE Articulo
	SET
		PrecioUnitario = @p_PrecioNuevo,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
