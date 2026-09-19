-- Tema:        HospitalDB - Sesión 7
-- Descripción: Registrar una transición de estatus de una receta, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE HospitalDB;
GO

CREATE PROCEDURE usp_insertarBitacoraEstatusReceta
	@p_idReceta int,
	@p_idEstatusNuevo int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idEstatusActual int,
			@NombreEstatusNuevo varchar(30),
			@TransicionValida bit

	-- Validación de la Receta: Revisamos primero si el idReceta existe en la tabla

	SELECT
		@idEstatusActual = idEstatusReceta
	FROM Receta
	WHERE idReceta = @p_idReceta

	IF @idEstatusActual IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La receta no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del EstatusReceta nuevo: Revisamos primero si el idEstatusReceta existe en la tabla

	SELECT
		@NombreEstatusNuevo = Nombre
	FROM EstatusReceta
	WHERE idEstatusReceta = @p_idEstatusNuevo

	IF @NombreEstatusNuevo IS NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El estatus nuevo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la transición: solo se permiten las transiciones del catálogo de negocio
	-- 1 Creada, 2 En atención, 3 Surtida, 4 Surtida parcialmente, 5 Cancelada
	-- Válidas: 1->2, 2->3, 2->4, 4->3, 1->5, 2->5

	SET @TransicionValida = 0

	IF @idEstatusActual = 1 AND @p_idEstatusNuevo = 2 SET @TransicionValida = 1
	IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 3 SET @TransicionValida = 1
	IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 4 SET @TransicionValida = 1
	IF @idEstatusActual = 4 AND @p_idEstatusNuevo = 3 SET @TransicionValida = 1
	IF @idEstatusActual = 1 AND @p_idEstatusNuevo = 5 SET @TransicionValida = 1
	IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 5 SET @TransicionValida = 1

	IF @TransicionValida = 0 BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La transición de estatus no es válida'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO BitacoraEstatusReceta (idReceta, idEstatusReceta, Fecha)
	VALUES (@p_idReceta, @p_idEstatusNuevo, GETDATE())

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
