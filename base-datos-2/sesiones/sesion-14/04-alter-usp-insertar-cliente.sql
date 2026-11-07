-- Tema:        Sesión 14 - Manejo de excepciones en procedimientos almacenados
-- Descripción: usp_insertarCliente con TRY CATCH: lo que no atrapan las validaciones
--              responde con el código 999999 en lugar de un error en rojo
-- Autor:       Daniel Hilario

ALTER PROCEDURE usp_insertarCliente
	@p_Nombre varchar(50),
	@p_PrimerApellido varchar(50),
	@p_SegundoApellido varchar(50),
	@p_Sexo char(1),
	@p_Telefono varchar(20),
	@p_Correo varchar(100)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@CorreoExistente varchar(100),
			@TelefonoExistente varchar(20)

	-- Validación del Sexo: debe ser 'M' o 'F'

	IF @p_Sexo NOT IN ('M', 'F') BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El sexo debe ser M o F'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Correo: no debe estar registrado por otro cliente

	SELECT
		@CorreoExistente = Correo
	FROM Cliente
	WHERE Correo = @p_Correo

	IF @CorreoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El correo ya está registrado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Telefono: no debe estar registrado por otro cliente

	SELECT
		@TelefonoExistente = Telefono
	FROM Cliente
	WHERE Telefono = @p_Telefono

	IF @p_Telefono IS NOT NULL AND @TelefonoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El teléfono ya está registrado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- NUEVO: el INSERT va dentro del TRY. Si falla, el código 000000 nunca se asigna:
	-- el control salta al CATCH

	BEGIN TRY

		INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
							 Correo)
		VALUES (@p_Nombre, @p_PrimerApellido, @p_SegundoApellido, @p_Sexo, @p_Telefono,
				@p_Correo)

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
