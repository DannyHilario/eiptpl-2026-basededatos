-- Tema:        HospitalDB - Sesión 7
-- Descripción: Marcar una consulta como efectuada (se llevó a cabo), con validaciones de guard clause
-- Autor:       Daniel Hilario

USE HospitalDB;
GO

CREATE PROCEDURE usp_efectuarConsulta
	@p_idConsulta int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Fecha datetime,
			@Efectuada bit

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

	-- Validación de Efectuada: no se puede efectuar una consulta que ya está efectuada

	IF @Efectuada = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La consulta ya fue efectuada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Fecha: no se puede efectuar una consulta antes de su fecha programada

	IF GETDATE() < @Fecha BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'No se puede efectuar una consulta antes de su fecha programada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Consulta
	SET
		Efectuada = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idConsulta = @p_idConsulta

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
