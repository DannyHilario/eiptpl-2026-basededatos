-- Tema:        HospitalDB - Sesión 7
-- Descripción: Generar la receta de una consulta ya efectuada, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE HospitalDB;
GO

CREATE PROCEDURE usp_generarReceta
	@p_idConsulta int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Fecha datetime,
			@Efectuada bit,
			@idRecetaExistente int

	-- Validación de la Consulta: Revisamos primero si el idConsulta existe en la tabla

	SELECT
		@Fecha = Fecha,
		@Efectuada = Efectuada
	FROM Consulta
	WHERE idConsulta = @p_idConsulta

	IF @Fecha IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La consulta no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de Efectuada: solo se genera receta de una consulta que sí se llevó a cabo

	IF @Efectuada = 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La consulta no ha sido efectuada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Fecha: no se puede generar una receta antes de la fecha programada de la consulta

	IF GETDATE() < @Fecha BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'No se puede generar la receta antes de la fecha programada de la consulta'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Receta: la consulta no debe tener ya una receta generada (relación 1:1)

	SELECT
		@idRecetaExistente = idReceta
	FROM Receta
	WHERE idConsulta = @p_idConsulta

	IF @idRecetaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'La consulta ya tiene una receta generada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Receta (idConsulta, idEstatusReceta)
	VALUES (@p_idConsulta, 1) -- 1 = Creada

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
