-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de un cliente, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarCliente
	@p_Nombre varchar(50),
	@p_PrimerApellido varchar(50),
	@p_SegundoApellido varchar(50),
	@p_Sexo char(1),
	@p_Telefono varchar(20),
	@p_Correo varchar(100)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200)

	-- Validación del Sexo: debe ser 'M' o 'F'

	IF @p_Sexo NOT IN ('M', 'F') BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El sexo debe ser M o F'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Correo: no debe estar registrado por otro cliente

	IF EXISTS (SELECT 1 FROM Cliente WHERE Correo = @p_Correo) BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El correo ya está registrado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Telefono: no debe estar registrado por otro cliente

	IF @p_Telefono IS NOT NULL AND EXISTS (SELECT 1 FROM Cliente WHERE Telefono = @p_Telefono) BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El teléfono ya está registrado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
						 Correo)
	VALUES (@p_Nombre, @p_PrimerApellido, @p_SegundoApellido, @p_Sexo, @p_Telefono,
			@p_Correo)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
