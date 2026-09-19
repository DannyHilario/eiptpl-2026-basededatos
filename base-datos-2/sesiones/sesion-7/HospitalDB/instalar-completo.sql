-- Tema:        HospitalDB - Sesión 7
-- Descripción: Instalación completa (tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético de carpeta/archivo
-- (mismo orden que la tabla del README de esta sesión — un simple 'find instalacion -name "*.sql" | sort'
-- ya respeta las llaves foráneas porque el prefijo numérico de cada carpeta sigue ese orden).
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.

-- ============================================================
-- instalacion/00-create-database.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear base de datos HospitalDB
-- Autor:       Daniel Hilario

CREATE DATABASE HospitalDB;

GO

-- ============================================================
-- instalacion/01-Especialidad/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Especialidad
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Especialidad (
    idEspecialidad INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/01-Especialidad/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar catálogo de especialidades médicas
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Especialidad (Nombre, Activo)
VALUES ('Medicina General', 1),
       ('Pediatría', 1),
       ('Cardiología', 1),
       ('Dermatología', 1),
       ('Ginecología', 1),
       ('Traumatología', 1),
       ('Oftalmología', 1),
       ('Otorrinolaringología', 1),
       ('Psiquiatría', 1),
       ('Endocrinología', 1);

GO

-- ============================================================
-- instalacion/02-Medico/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Medico
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Medico (
    idMedico INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Cedula VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(20) UNIQUE,
    Correo VARCHAR(100) UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/02-Medico/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 10 médicos (origen: primeros 10 clientes de CompuStoreDB - Sesión 5, adaptados)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Medico (Nombre, PrimerApellido, SegundoApellido, Cedula, Telefono,
                    Correo, Activo)
VALUES ('Carlos', 'García', 'López', '10234501', '8112000001',
        'carlos.garcia@hospitaldb.com', 1),
       ('Ana', 'Hernández', 'Ramírez', '10234502', '8112000002',
        'ana.hernandez@hospitaldb.com', 1),
       ('Miguel', 'Rodríguez', 'Silva', '10234503', '8112000003',
        'miguel.rodriguez@hospitaldb.com', 1),
       ('Valeria', 'Torres', 'Gutiérrez', '10234504', '8112000004',
        'valeria.torres@hospitaldb.com', 1),
       ('Luis', 'Pérez', 'Morales', '10234505', '8112000005',
        'luis.perez@hospitaldb.com', 1),
       ('Sofía', 'Sánchez', 'Vega', '10234506', '8112000006',
        'sofia.sanchez@hospitaldb.com', 1),
       ('Alejandro', 'Ramírez', 'Cruz', '10234507', '8112000007',
        'alejandro.ramirez@hospitaldb.com', 1),
       ('Daniela', 'Jiménez', 'Flores', '10234508', '8112000008',
        'daniela.jimenez@hospitaldb.com', 1),
       ('Ricardo', 'Gómez', 'Reyes', '10234509', '8112000009',
        'ricardo.gomez@hospitaldb.com', 1),
       ('Mariana', 'Delgado', 'Ortiz', '10234510', '8112000010',
        'mariana.delgado@hospitaldb.com', 1);

GO

-- ============================================================
-- instalacion/03-MedicoEspecialidad/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla MedicoEspecialidad (relación N:M entre Medico y Especialidad)
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE MedicoEspecialidad (
    idMedicoEspecialidad INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idMedico INT NOT NULL,
    idEspecialidad INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_MedicoEspecialidad_Medico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico),
    CONSTRAINT fk_MedicoEspecialidad_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(idEspecialidad),
    CONSTRAINT uq_MedicoEspecialidad_Medico_Especialidad UNIQUE (idMedico, idEspecialidad)
);

GO

-- ============================================================
-- instalacion/03-MedicoEspecialidad/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar relaciones Medico-Especialidad (algunos médicos con más de una especialidad, para ilustrar la relación N:M)
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Especialidades: 1 Medicina General, 2 Pediatría, 3 Cardiología, 4 Dermatología, 5 Ginecología,
--                 6 Traumatología, 7 Oftalmología, 8 Otorrinolaringología, 9 Psiquiatría, 10 Endocrinología

INSERT INTO MedicoEspecialidad (idMedico, idEspecialidad)
VALUES (1, 1),
       (1, 3),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (5, 10),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (10, 1);

GO

-- ============================================================
-- instalacion/04-Paciente/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Paciente
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Paciente (
    idPaciente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(20) UNIQUE,
    Correo VARCHAR(100) UNIQUE,
    FechaNacimiento DATE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Paciente_Sexo CHECK (Sexo IN ('M', 'F'))
);

GO

-- ============================================================
-- instalacion/04-Paciente/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 15 pacientes (origen: clientes 11-25 de CompuStoreDB - Sesión 5, adaptados)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Paciente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
                      Correo, FechaNacimiento, Activo)
VALUES ('Sergio', 'Castro', 'Ibarra', 'M', '8100000011',
        'sergio.castro@outlook.com', '1978-04-12', 1),
       ('Fernanda', 'Morales', 'Sandoval', 'F', '8100000012',
        'fernanda.morales@yahoo.com.mx', '1985-11-03', 1),
       ('Eduardo', 'Vargas', 'Lozano', 'M', '8100000013',
        'eduardo.vargas@gmail.com', '1990-07-22', 1),
       ('Adriana', 'Fuentes', 'Cervantes', 'F', '8100000014',
        'adriana.fuentes@hotmail.com', '1965-02-14', 1),
       ('Daniel', 'Aguilar', 'Mendoza', 'M', '8100000015',
        'daniel.aguilar@outlook.com', '2001-09-30', 1),
       ('Carolina', 'Salinas', 'Herrera', 'F', '8100000016',
        'carolina.salinas@yahoo.com.mx', '1972-05-18', 1),
       ('Pablo', 'Medina', 'Castillo', 'M', '8100000017',
        'pablo.medina@gmail.com', '1995-12-08', 1),
       ('Elena', 'Lozano', 'Guerrero', 'F', '8100000018',
        'elena.lozano@hotmail.com', '1958-08-25', 1),
       ('Francisco', 'Núñez', 'Ramos', 'M', '8100000019',
        'francisco.nunez@outlook.com', '1983-03-11', 1),
       ('Victoria', 'Reyes', 'Díaz', 'F', '8100000020',
        'victoria.reyes@yahoo.com.mx', '1999-06-27', 1),
       ('Gabriel', 'Ortiz', 'Peña', 'M', '8100000021',
        'gabriel.ortiz@gmail.com', '1968-10-05', 1),
       ('Monserrat', 'Cruz', 'Navarro', 'F', '8100000022',
        'monserrat.cruz@hotmail.com', '1992-01-19', 1),
       ('Héctor', 'Flores', 'Ibáñez', 'M', '8100000023',
        'hector.flores@outlook.com', '1975-04-30', 1),
       ('Patricia', 'Rivera', 'Moreno', 'F', '8100000024',
        'patricia.rivera@yahoo.com.mx', '1988-09-14', 1),
       ('Roberto', 'Silva', 'Espinoza', 'M', '8100000025',
        'roberto.silva@gmail.com', '2003-02-21', 1);

GO

-- ============================================================
-- instalacion/05-Consultorio/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Consultorio
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Consultorio (
    idConsultorio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/05-Consultorio/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 10 consultorios
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Consultorio (Nombre, Activo)
VALUES ('Consultorio 1', 1),
       ('Consultorio 2', 1),
       ('Consultorio 3', 1),
       ('Consultorio 4', 1),
       ('Consultorio 5', 1),
       ('Consultorio 6', 1),
       ('Consultorio 7', 1),
       ('Consultorio 8', 1),
       ('Consultorio 9', 1),
       ('Consultorio 10', 1);

GO

-- ============================================================
-- instalacion/06-EstatusReceta/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla EstatusReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE EstatusReceta (
    idEstatusReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/06-EstatusReceta/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar catálogo de estatus de receta
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO EstatusReceta (Nombre, Activo)
VALUES ('Creada', 1),
       ('En atención', 1),
       ('Surtida', 1),
       ('Surtida parcialmente', 1),
       ('Cancelada', 1);

GO

-- ============================================================
-- instalacion/07-Consulta/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Consulta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Consulta (
    idConsulta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPaciente INT NOT NULL,
    idMedico INT NOT NULL,
    idConsultorio INT NOT NULL,
    Fecha DATETIME NOT NULL,
    Efectuada BIT NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Consulta_Paciente FOREIGN KEY (idPaciente) REFERENCES Paciente(idPaciente),
    CONSTRAINT fk_Consulta_Medico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico),
    CONSTRAINT fk_Consulta_Consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(idConsultorio)
);

GO

-- ============================================================
-- instalacion/07-Consulta/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 17 consultas (15 efectuadas, una por paciente, más 2 sin efectuar)
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Las primeras 15 ya se efectuaron y cada una generó su receta (ver 08-Receta/02-insert.sql).
-- Las 2 últimas ilustran el flujo de "consulta agendada, pendiente de efectuarse":
-- la 16 ya pasó su fecha y nunca se efectuó (no se presentó el paciente); la 17 todavía no llega su fecha.
-- Ninguna de las dos tiene receta — se generaría con usp_generarReceta una vez efectuada con usp_efectuarConsulta.

INSERT INTO Consulta (idPaciente, idMedico, idConsultorio, Fecha, Efectuada)
VALUES (1, 1, 1, '2026-09-01T09:00:00', 1),
       (2, 2, 2, '2026-09-01T10:00:00', 1),
       (3, 3, 3, '2026-09-02T09:00:00', 1),
       (4, 4, 4, '2026-09-02T11:00:00', 1),
       (5, 5, 5, '2026-09-03T09:00:00', 1),
       (6, 6, 6, '2026-09-03T12:00:00', 1),
       (7, 7, 7, '2026-09-04T09:00:00', 1),
       (8, 8, 8, '2026-09-04T13:00:00', 1),
       (9, 9, 9, '2026-09-05T09:00:00', 1),
       (10, 10, 10, '2026-09-05T10:30:00', 1),
       (11, 1, 1, '2026-09-08T09:00:00', 1),
       (12, 2, 2, '2026-09-08T11:00:00', 1),
       (13, 3, 3, '2026-09-09T09:00:00', 1),
       (14, 4, 4, '2026-09-09T12:00:00', 1),
       (15, 5, 5, '2026-09-10T09:00:00', 1),
       (1, 6, 6, '2026-09-11T09:00:00', 0),
       (2, 7, 7, '2026-10-01T09:00:00', 0);

GO

-- ============================================================
-- instalacion/07-Consulta/03-usp-insertar.sql
-- ============================================================
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

GO

-- ============================================================
-- instalacion/07-Consulta/04-usp-efectuar.sql
-- ============================================================
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

GO

-- ============================================================
-- instalacion/08-Receta/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Receta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Receta (
    idReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idConsulta INT NOT NULL UNIQUE,
    idEstatusReceta INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Receta_Consulta FOREIGN KEY (idConsulta) REFERENCES Consulta(idConsulta),
    CONSTRAINT fk_Receta_EstatusReceta FOREIGN KEY (idEstatusReceta) REFERENCES EstatusReceta(idEstatusReceta)
);

GO

-- ============================================================
-- instalacion/08-Receta/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 15 recetas (una por consulta), repartidas entre los 5 estatus
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Estatus: 1 Creada, 2 En atención, 3 Surtida, 4 Surtida parcialmente, 5 Cancelada

INSERT INTO Receta (idConsulta, idEstatusReceta)
VALUES (1, 1),
       (2, 1),
       (3, 5),
       (4, 2),
       (5, 2),
       (6, 2),
       (7, 2),
       (8, 3),
       (9, 3),
       (10, 3),
       (11, 3),
       (12, 4),
       (13, 4),
       (14, 2),
       (15, 5);

GO

-- ============================================================
-- instalacion/08-Receta/03-usp-generar.sql
-- ============================================================
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

GO

-- ============================================================
-- instalacion/08-Receta/04-usp-cambiar-estatus.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Cambiar el estatus de una receta, registrando la transición en la bitácora
-- Autor:       Daniel Hilario

USE HospitalDB;
GO

CREATE PROCEDURE usp_cambiarEstatusReceta
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

	EXEC usp_insertarBitacoraEstatusReceta
		@p_idReceta = @p_idReceta,
		@p_idEstatusNuevo = @p_idEstatusNuevo

	UPDATE Receta
	SET
		idEstatusReceta = @p_idEstatusNuevo,
		FechaUltimaModificacion = GETDATE()
	WHERE idReceta = @p_idReceta

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- instalacion/09-Medicamento/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Medicamento
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Medicamento (
    idMedicamento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uq_Medicamento_Nombre_Marca UNIQUE (Nombre, Marca)
);

GO

-- ============================================================
-- instalacion/09-Medicamento/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 15 medicamentos
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Medicamento (Nombre, Marca, Activo)
VALUES ('Paracetamol 500mg', 'Tempra', 1),
       ('Ibuprofeno 400mg', 'Advil', 1),
       ('Amoxicilina 500mg', 'Amoxil', 1),
       ('Omeprazol 20mg', 'Losec', 1),
       ('Loratadina 10mg', 'Clarityne', 1),
       ('Metformina 850mg', 'Glucophage', 1),
       ('Losartán 50mg', 'Cozaar', 1),
       ('Naproxeno 250mg', 'Flanax', 1),
       ('Ambroxol Jarabe', 'Mucosolvan', 1),
       ('Diclofenaco 100mg', 'Voltaren', 1),
       ('Ranitidina 150mg', 'Zantac', 1),
       ('Captopril 25mg', 'Capotena', 1),
       ('Salbutamol Inhalador', 'Ventolin', 1),
       ('Ciprofloxacino 500mg', 'Ciproxina', 1),
       ('Clotrimazol Crema', 'Canesten', 1);

GO

-- ============================================================
-- instalacion/10-DetalleReceta/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla DetalleReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE DetalleReceta (
    idDetalleReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idReceta INT NOT NULL,
    idMedicamento INT NOT NULL,
    Cantidad INT NOT NULL,
    Indicaciones VARCHAR(200),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_DetalleReceta_Receta FOREIGN KEY (idReceta) REFERENCES Receta(idReceta),
    CONSTRAINT fk_DetalleReceta_Medicamento FOREIGN KEY (idMedicamento) REFERENCES Medicamento(idMedicamento),
    CONSTRAINT chk_DetalleReceta_Cantidad CHECK (Cantidad > 0)
);

GO

-- ============================================================
-- instalacion/10-DetalleReceta/02-insert.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar líneas de detalle en las recetas que ya tienen medicamentos asignados
-- Autor:       Daniel Hilario
--
-- Nota: las recetas 1, 2 y 3 (estatus Creada/Cancelada) se dejan sin líneas a propósito —
-- una receta puede seguir sin líneas mientras no se le haya empezado a surtir nada.

USE HospitalDB;

INSERT INTO DetalleReceta (idReceta, idMedicamento, Cantidad, Indicaciones)
VALUES (4, 1, 20, 'Tomar 1 tableta cada 8 horas por 5 días'),
       (4, 2, 10, 'Tomar 1 tableta cada 12 horas por 5 días'),
       (5, 3, 21, 'Tomar 1 cápsula cada 8 horas por 7 días'),
       (6, 4, 14, 'Tomar 1 tableta cada 12 horas en ayunas'),
       (7, 5, 10, 'Tomar 1 tableta cada 24 horas'),
       (8, 6, 60, 'Tomar 1 tableta cada 12 horas con alimentos'),
       (8, 7, 30, 'Tomar 1 tableta cada 24 horas'),
       (9, 8, 10, 'Tomar 1 tableta cada 12 horas por 5 días'),
       (10, 9, 1, 'Tomar 10ml cada 8 horas por 7 días'),
       (11, 10, 15, 'Tomar 1 tableta cada 8 horas por 5 días'),
       (11, 11, 20, 'Tomar 1 tableta cada 12 horas por 10 días'),
       (12, 12, 30, 'Tomar 1 tableta cada 8 horas'),
       (12, 13, 1, 'Aplicar 2 disparos cada 8 horas'),
       (13, 14, 8, 'Tomar 1 tableta cada 12 horas por 4 días'),
       (14, 15, 1, 'Aplicar en la zona afectada cada 12 horas'),
       (15, 1, 10, 'Tomar 1 tableta cada 8 horas por 3 días');

GO

-- ============================================================
-- instalacion/11-BitacoraEstatusReceta/01-create-table.sql
-- ============================================================
-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla BitacoraEstatusReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE BitacoraEstatusReceta (
    idBitacoraEstatusReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idReceta INT NOT NULL,
    idEstatusReceta INT NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_BitacoraEstatusReceta_Receta FOREIGN KEY (idReceta) REFERENCES Receta(idReceta),
    CONSTRAINT fk_BitacoraEstatusReceta_EstatusReceta FOREIGN KEY (idEstatusReceta) REFERENCES EstatusReceta(idEstatusReceta)
);

GO

-- ============================================================
-- instalacion/11-BitacoraEstatusReceta/02-usp-insertar.sql
-- ============================================================
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

GO
