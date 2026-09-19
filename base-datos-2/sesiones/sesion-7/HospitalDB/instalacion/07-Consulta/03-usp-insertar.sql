-- Tema:        HospitalDB - Sesión 7
-- Descripción: Agendar una consulta, validando que no se traslape con otra del mismo médico o consultorio
-- Autor:       Daniel Hilario

USE HospitalDB;
GO

CREATE PROCEDURE usp_insertarConsulta
	@p_idPaciente int,
	@p_idMedico int,
	@p_idConsultorio int,
	@p_Fecha datetime
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@NombrePaciente varchar(100),
			@NombreMedico varchar(100),
			@NombreConsultorio varchar(50),

			@idConsultaConflicto int,

			@DuracionMinutos int

	SET @DuracionMinutos = 30 -- HARDCODE

	-- Validación del Paciente: Revisamos primero si el idPaciente existe en la tabla

	SELECT
		@NombrePaciente = Nombre
	FROM Paciente
	WHERE idPaciente = @p_idPaciente

	IF @NombrePaciente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El paciente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Medico: Revisamos primero si el idMedico existe en la tabla

	SELECT
		@NombreMedico = Nombre
	FROM Medico
	WHERE idMedico = @p_idMedico

	IF @NombreMedico IS NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El médico no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Consultorio: Revisamos primero si el idConsultorio existe en la tabla

	SELECT
		@NombreConsultorio = Nombre
	FROM Consultorio
	WHERE idConsultorio = @p_idConsultorio

	IF @NombreConsultorio IS NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El consultorio no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de traslape: ninguna consulta del mismo médico o consultorio puede compartir
	-- la ventana de @DuracionMinutos minutos con la consulta nueva

	SELECT TOP 1
		@idConsultaConflicto = idConsulta
	FROM Consulta
	WHERE (idMedico = @p_idMedico OR idConsultorio = @p_idConsultorio)
	AND Fecha < DATEADD(MINUTE, @DuracionMinutos, @p_Fecha)
	AND DATEADD(MINUTE, @DuracionMinutos, Fecha) > @p_Fecha

	IF @idConsultaConflicto IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El médico o el consultorio ya tienen una consulta agendada en ese horario'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Consulta (idPaciente, idMedico, idConsultorio, Fecha)
	VALUES (@p_idPaciente, @p_idMedico, @p_idConsultorio, @p_Fecha)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
