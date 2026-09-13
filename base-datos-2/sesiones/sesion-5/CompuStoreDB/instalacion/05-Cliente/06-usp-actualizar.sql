-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar los datos principales de un cliente
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarCliente
	@p_idCliente int,
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

			@Nombre varchar(50)

	-- Validación del Cliente: Revisamos primero si el idCliente existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Sexo: debe ser 'M' o 'F'

	IF @p_Sexo NOT IN ('M', 'F') BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El sexo debe ser M o F'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Correo: no debe estar registrado por otro cliente

	IF EXISTS (SELECT 1 FROM Cliente WHERE Correo = @p_Correo AND idCliente <> @p_idCliente) BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El correo ya está registrado por otro cliente'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Telefono: no debe estar registrado por otro cliente

	IF @p_Telefono IS NOT NULL AND EXISTS (SELECT 1 FROM Cliente WHERE Telefono = @p_Telefono AND idCliente <> @p_idCliente) BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El teléfono ya está registrado por otro cliente'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Cliente
	SET
		Nombre = @p_Nombre,
		PrimerApellido = @p_PrimerApellido,
		SegundoApellido = @p_SegundoApellido,
		Sexo = @p_Sexo,
		Telefono = @p_Telefono,
		Correo = @p_Correo,
		FechaUltimaModificacion = GETDATE()
	WHERE idCliente = @p_idCliente

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
