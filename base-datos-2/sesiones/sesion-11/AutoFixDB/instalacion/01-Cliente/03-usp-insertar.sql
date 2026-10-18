-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Alta de un cliente validando que el correo y el teléfono no estén registrados.
--              Su INSERT dispara los triggers AFTER INSERT de Cliente igual que un INSERT escrito directamente
-- Autor:       Daniel Hilario

USE AutoFixDB;
GO

CREATE PROCEDURE usp_insertarCliente
	@p_PrimerApellido varchar(50),
	@p_SegundoApellido varchar(50),
	@p_Nombre varchar(100),
	@p_Telefono varchar(15),
	@p_Correo varchar(100)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@CorreoExistente varchar(100),
			@TelefonoExistente varchar(15)

	-- Validación del Correo: no debe estar registrado por otro cliente

	SELECT
		@CorreoExistente = Correo
	FROM Cliente
	WHERE Correo = @p_Correo

	IF @CorreoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
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

	IF @TelefonoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El teléfono ya está registrado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Este INSERT es el que dispara los triggers AFTER INSERT de la tabla Cliente

	INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
	VALUES (@p_PrimerApellido, @p_SegundoApellido, @p_Nombre, @p_Telefono, @p_Correo)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
