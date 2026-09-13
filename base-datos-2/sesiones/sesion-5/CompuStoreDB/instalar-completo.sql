-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Instalación completa (tablas, datos y procedimientos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando, en orden, los scripts de instalacion/ (ver instalacion/ para instalar paso a paso).
-- Requiere ejecutarse completo en SSMS (F5): cada CREATE PROCEDURE necesita ir solo en su lote,
-- por eso se separa cada script con GO.

-- ============================================================
-- 00-create-database.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear base de datos CompuStoreDB
-- Autor:       Daniel Hilario

CREATE DATABASE CompuStoreDB;

GO

-- ============================================================
-- 01-Categoria/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Categoria
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Categoria (
    idCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- 02-Articulo/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Articulo
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Articulo (
    idArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Articulo_PrecioUnitario CHECK (PrecioUnitario > 0),
    CONSTRAINT uq_Articulo_Nombre_Marca UNIQUE (Nombre, Marca)
);

GO

-- ============================================================
-- 03-ArticuloCategoria/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla ArticuloCategoria (relación N:N entre Articulo y Categoria)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE ArticuloCategoria (
    idArticuloCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idArticulo INT NOT NULL,
    idCategoria INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_ArticuloCategoria_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT fk_ArticuloCategoria_Categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
    CONSTRAINT uq_ArticuloCategoria_Articulo_Categoria UNIQUE (idArticulo, idCategoria)
);

GO

-- ============================================================
-- 04-HistoricoPrecioArticulo/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla HistoricoPrecioArticulo
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE HistoricoPrecioArticulo (
    idHistoricoPrecioArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idArticulo INT NOT NULL,
    PrecioAnterior DECIMAL(10,2) NOT NULL,
    PrecioNuevo DECIMAL(10,2) NOT NULL,
    Fecha DATETIME NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_HistoricoPrecioArticulo_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioAnterior CHECK (PrecioAnterior >= 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioNuevo CHECK (PrecioNuevo >= 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_Cambio CHECK (PrecioNuevo <> PrecioAnterior)
);

GO

-- ============================================================
-- 05-Cliente/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(20) UNIQUE,
    Correo VARCHAR(100) UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);

GO

-- ============================================================
-- 06-Pedido/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla Pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    Fecha DATE NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

GO

-- ============================================================
-- 07-DetallePedido/01-create-table.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Crear tabla DetallePedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;

CREATE TABLE DetallePedido (
    idDetallePedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPedido INT NOT NULL,
    idArticulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_DetallePedido_Pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT fk_DetallePedido_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT chk_DetallePedido_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT chk_DetallePedido_PrecioUnitario CHECK (PrecioUnitario > 0)
);

GO

-- ============================================================
-- 01-Categoria/02-insert.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Insertar catálogo de categorías
-- Autor:       Daniel Hilario

USE CompuStoreDB;

INSERT INTO Categoria (Nombre, Activo)
VALUES ('Laptops', 1),
       ('Monitores', 1),
       ('Teclados', 1),
       ('Ratones', 1),
       ('Impresoras', 1),
       ('Almacenamiento', 1),
       ('Componentes', 1),
       ('Audio', 1),
       ('Redes', 1),
       ('Accesorios', 1),
       ('Telefonía', 1);

GO

-- ============================================================
-- 02-Articulo/02-insert.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Insertar 51 artículos (origen: material de asesoría, adaptado a CompuStore)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

-- Articulos 1-10
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Laptop 15.6" Core i5', 'HP', 14500.00, 1),
       ('Mouse Inalámbrico', 'Logitech', 350.00, 1),
       ('Teclado Mecánico RGB', 'Redragon', 1250.00, 1),
       ('Monitor 24" LED', 'Samsung', 4200.00, 1),
       ('Memoria USB 32GB', 'Kingston', 120.00, 1),
       ('Disco Duro Externo 1TB', 'Seagate', 1500.00, 1),
       ('Silla Gamer', 'Cougar', 5500.00, 1),
       ('Memoria RAM 8GB DDR4', 'Corsair', 700.00, 1),
       ('Tarjeta Gráfica RTX 3060', 'Nvidia', 9800.00, 1),
       ('Mouse Pad Grande RGB', 'Genérico', 300.00, 1);

-- Articulos 11-20
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Cargador Universal para Laptop', 'Genérico', 450.00, 1),
       ('Cámara Web Full HD', 'Logitech', 1100.00, 1),
       ('Audífonos Inalámbricos', 'Sony', 1600.00, 1),
       ('Laptop ThinkPad Core i7', 'Lenovo', 19500.00, 1),
       ('Enfriador de CPU', 'Cooler Master', 600.00, 1),
       ('SSD 240GB', 'Kingston', 800.00, 1),
       ('Impresora Multifuncional', 'HP', 2500.00, 1),
       ('Cable HDMI 2 metros', 'Genérico', 150.00, 1),
       ('Adaptador USB-C a HDMI', 'Genérico', 200.00, 1),
       ('Router WiFi', 'TP-Link', 850.00, 1);

-- Articulos 21-30
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Hub USB 4 puertos', 'Genérico', 220.00, 1),
       ('Smartphone Redmi Note 11', 'Xiaomi', 5900.00, 1),
       ('Lector de Tarjetas SD', 'Genérico', 90.00, 1),
       ('Bocinas Bluetooth', 'JBL', 1300.00, 1),
       ('Cargador Rápido USB-C', 'Genérico', 180.00, 1),
       ('Fuente de Poder 600W', 'EVGA', 1000.00, 1),
       ('Pantalla LED 32" Smart TV', 'LG', 7200.00, 1),
       ('Tarjeta Madre B450', 'ASUS', 2800.00, 1),
       ('Mouse Óptico USB', 'Genérico', 100.00, 1),
       ('Base para Laptop Ajustable', 'Genérico', 350.00, 1);

-- Articulos 31-40
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Tableta Gráfica', 'Wacom', 1900.00, 1),
       ('Memoria RAM 16GB DDR4', 'Kingston', 1400.00, 1),
       ('Disco Duro Interno 2TB', 'WD', 1900.00, 1),
       ('Impresora Láser', 'Brother', 4500.00, 1),
       ('Switch Ethernet 8 puertos', 'Genérico', 650.00, 1),
       ('Cable de Red CAT6 5m', 'Genérico', 80.00, 1),
       ('Auriculares Gamer', 'HyperX', 1800.00, 1),
       ('Ventilador RGB para PC', 'Genérico', 200.00, 1),
       ('Adaptador de Red Inalámbrico USB', 'Genérico', 300.00, 1),
       ('Laptop Aspire 5 Core i3', 'Acer', 9800.00, 1);

-- Articulos 41-51
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Control Xbox Inalámbrico', 'Microsoft', 1200.00, 1),
       ('Memoria USB 64GB', 'Sandisk', 170.00, 1),
       ('Batería Externa 10000mAh', 'Genérico', 500.00, 1),
       ('Cable USB Tipo-C', 'Genérico', 100.00, 1),
       ('Laptop XPS 13 Core i7', 'Dell', 24000.00, 1),
       ('Soporte de Pared para Monitor', 'Genérico', 400.00, 1),
       ('Toner 85A', 'HP', 800.00, 1),
       ('Teclado Inalámbrico', 'Microsoft', 850.00, 1),
       ('SSD 500GB', 'Samsung', 1600.00, 1),
       ('Repetidor de Señal WiFi', 'Genérico', 300.00, 1),
       ('Estación de Carga USB 6 puertos', 'Genérico', 750.00, 1);

GO

-- ============================================================
-- 03-ArticuloCategoria/02-insert.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Insertar relaciones Articulo-Categoria (algunos artículos en más de una categoría, para ilustrar la relación N:N)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

-- Categorías: 1 Laptops, 2 Monitores, 3 Teclados, 4 Ratones, 5 Impresoras,
--             6 Almacenamiento, 7 Componentes, 8 Audio, 9 Redes, 10 Accesorios, 11 Telefonía

-- Articulos 1-10
INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
VALUES (1, 1),
       (2, 4),
       (3, 3),
       (4, 2),
       (5, 6),
       (6, 6),
       (7, 10),
       (8, 7),
       (9, 7),
       (10, 4);

-- Articulos 10-20 (10 también en Accesorios: mouse pad)
INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
VALUES (10, 10),
       (11, 1),
       (11, 10),
       (12, 10),
       (13, 8),
       (14, 1),
       (15, 7),
       (16, 6),
       (17, 5),
       (18, 10),
       (19, 10),
       (20, 9);

-- Articulos 21-30
INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
VALUES (21, 10),
       (22, 11),
       (23, 10),
       (24, 8),
       (25, 10),
       (26, 7),
       (27, 2),
       (28, 7),
       (29, 4),
       (30, 1),
       (30, 10);

-- Articulos 31-40
INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
VALUES (31, 10),
       (32, 7),
       (33, 6),
       (34, 5),
       (35, 9),
       (36, 9),
       (37, 8),
       (38, 7),
       (39, 9),
       (40, 1);

-- Articulos 41-51
INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
VALUES (41, 10),
       (42, 6),
       (43, 10),
       (44, 10),
       (45, 1),
       (46, 2),
       (46, 10),
       (47, 5),
       (48, 3),
       (49, 6),
       (50, 9),
       (51, 10);

GO

-- ============================================================
-- 05-Cliente/02-insert.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Insertar 25 clientes (origen: AutoFixDB - Sesión 10, Base de Datos I)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
                     Correo, Activo)
VALUES ('Carlos', 'García', 'López', 'M', '8100000001',
        'carlos.garcia@gmail.com', 1),
       ('Ana', 'Hernández', 'Ramírez', 'F', '8100000002',
        'ana.hernandez@hotmail.com', 1),
       ('Miguel', 'Rodríguez', 'Silva', 'M', '8100000003',
        'miguel.rodriguez@outlook.com', 1),
       ('Valeria', 'Torres', 'Gutiérrez', 'F', '8100000004',
        'valeria.torres@yahoo.com.mx', 1),
       ('Luis', 'Pérez', 'Morales', 'M', '8100000005',
        'luis.perez@gmail.com', 1),
       ('Sofía', 'Sánchez', 'Vega', 'F', '8100000006',
        'sofia.sanchez@hotmail.com', 1),
       ('Alejandro', 'Ramírez', 'Cruz', 'M', '8100000007',
        'alejandro.ramirez@outlook.com', 1),
       ('Daniela', 'Jiménez', 'Flores', 'F', '8100000008',
        'daniela.jimenez@yahoo.com.mx', 1),
       ('Ricardo', 'Gómez', 'Reyes', 'M', '8100000009',
        'ricardo.gomez@gmail.com', 1),
       ('Mariana', 'Delgado', 'Ortiz', 'F', '8100000010',
        'mariana.delgado@hotmail.com', 1),
       ('Sergio', 'Castro', 'Ibarra', 'M', '8100000011',
        'sergio.castro@outlook.com', 1),
       ('Fernanda', 'Morales', 'Sandoval', 'F', '8100000012',
        'fernanda.morales@yahoo.com.mx', 1),
       ('Eduardo', 'Vargas', 'Lozano', 'M', '8100000013',
        'eduardo.vargas@gmail.com', 1),
       ('Adriana', 'Fuentes', 'Cervantes', 'F', '8100000014',
        'adriana.fuentes@hotmail.com', 1),
       ('Daniel', 'Aguilar', 'Mendoza', 'M', '8100000015',
        'daniel.aguilar@outlook.com', 1),
       ('Carolina', 'Salinas', 'Herrera', 'F', '8100000016',
        'carolina.salinas@yahoo.com.mx', 1),
       ('Pablo', 'Medina', 'Castillo', 'M', '8100000017',
        'pablo.medina@gmail.com', 1),
       ('Elena', 'Lozano', 'Guerrero', 'F', '8100000018',
        'elena.lozano@hotmail.com', 1),
       ('Francisco', 'Núñez', 'Ramos', 'M', '8100000019',
        'francisco.nunez@outlook.com', 1),
       ('Victoria', 'Reyes', 'Díaz', 'F', '8100000020',
        'victoria.reyes@yahoo.com.mx', 1),
       ('Gabriel', 'Ortiz', 'Peña', 'M', '8100000021',
        'gabriel.ortiz@gmail.com', 1),
       ('Monserrat', 'Cruz', 'Navarro', 'F', '8100000022',
        'monserrat.cruz@hotmail.com', 1),
       ('Héctor', 'Flores', 'Ibáñez', 'M', '8100000023',
        'hector.flores@outlook.com', 1),
       ('Patricia', 'Rivera', 'Moreno', 'F', '8100000024',
        'patricia.rivera@yahoo.com.mx', 1),
       ('Roberto', 'Silva', 'Espinoza', 'M', '8100000025',
        'roberto.silva@gmail.com', 1);

GO

-- ============================================================
-- 01-Categoria/03-usp-insertar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de una categoría, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarCategoria
	@p_Nombre varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCategoriaExistente int

	-- Validación de la Categoria: no debe estar registrada con el mismo Nombre

	SELECT
		@idCategoriaExistente = idCategoria
	FROM Categoria
	WHERE Nombre = @p_Nombre

	IF @idCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría ya está registrada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Categoria (Nombre)
	VALUES (@p_Nombre)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 01-Categoria/04-usp-eliminar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de una categoría
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarCategoria
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50)

	-- Validación de la Categoria: Revisamos primero si el idCategoria existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 01-Categoria/05-usp-habilitar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Habilitar (reactivar) una categoría dada de baja
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_habilitarCategoria
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@Activo bit

	-- Validación de la Categoria: Revisamos primero si el idCategoria existe en la tabla

	SELECT
		@Nombre = Nombre,
		@Activo = Activo
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: la categoría ya debe estar dada de baja

	IF @Activo = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La categoría ya está activa'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Activo = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Habilitación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 01-Categoria/06-usp-actualizar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar el nombre de una categoría
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarCategoria
	@p_idCategoria int,
	@p_Nombre varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@idCategoriaExistente int

	-- Validación de la Categoria: Revisamos primero si el idCategoria existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Nombre: no debe estar registrado por otra categoría

	SELECT
		@idCategoriaExistente = idCategoria
	FROM Categoria
	WHERE Nombre = @p_Nombre AND idCategoria <> @p_idCategoria

	IF @idCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El nombre ya está registrado por otra categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Categoria
	SET
		Nombre = @p_Nombre,
		FechaUltimaModificacion = GETDATE()
	WHERE idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 02-Articulo/03-usp-insertar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de un artículo, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarArticulo
	@p_Nombre varchar(100),
	@p_Marca varchar(50),
	@p_PrecioUnitario decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloExistente int

	-- Validación del PrecioUnitario: debe ser mayor a cero

	IF @p_PrecioUnitario <= 0 BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El precio unitario debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Articulo: no debe estar registrado con el mismo Nombre y Marca

	SELECT
		@idArticuloExistente = idArticulo
	FROM Articulo
	WHERE Nombre = @p_Nombre AND Marca = @p_Marca

	IF @idArticuloExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El artículo ya está registrado con esa marca'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Articulo (Nombre, Marca, PrecioUnitario)
	VALUES (@p_Nombre, @p_Marca, @p_PrecioUnitario)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 02-Articulo/04-usp-eliminar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarArticulo
	@p_idArticulo int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100)

	-- Validación del Articulo: Revisamos primero si el idArticulo existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Articulo
	SET
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 02-Articulo/05-usp-habilitar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Habilitar (reactivar) un artículo dado de baja
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_habilitarArticulo
	@p_idArticulo int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100),
			@Activo bit

	-- Validación del Articulo: Revisamos primero si el idArticulo existe en la tabla

	SELECT
		@Nombre = Nombre,
		@Activo = Activo
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: el artículo ya debe estar dado de baja

	IF @Activo = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El artículo ya está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Articulo
	SET
		Activo = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Habilitación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 04-HistoricoPrecioArticulo/02-usp-insertar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Registrar un cambio de precio de un artículo, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarHistoricoPrecioArticulo
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

	INSERT INTO HistoricoPrecioArticulo (idArticulo, PrecioAnterior, PrecioNuevo,
										 Fecha)
	VALUES (@p_idArticulo, @PrecioAnterior, @p_PrecioNuevo,
			GETDATE())

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 02-Articulo/06-usp-actualizar-precio.sql
-- ============================================================
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

GO

-- ============================================================
-- 02-Articulo/07-usp-actualizar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar el nombre y la marca de un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarArticulo
	@p_idArticulo int,
	@p_Nombre varchar(100),
	@p_Marca varchar(50)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(100),
			@idArticuloExistente int

	-- Validación del Articulo: Revisamos primero si el idArticulo existe en la tabla

	SELECT
		@Nombre = Nombre
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Nombre y Marca: no deben estar registrados por otro artículo

	SELECT
		@idArticuloExistente = idArticulo
	FROM Articulo
	WHERE Nombre = @p_Nombre AND Marca = @p_Marca AND idArticulo <> @p_idArticulo

	IF @idArticuloExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'Ya existe otro artículo registrado con ese nombre y marca'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Articulo
	SET
		Nombre = @p_Nombre,
		Marca = @p_Marca,
		FechaUltimaModificacion = GETDATE()
	WHERE idArticulo = @p_idArticulo

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 03-ArticuloCategoria/03-usp-asignar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Asignar una categoría a un artículo, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_asignarCategoriaArticulo
	@p_idArticulo int,
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloEncontrado int,
			@idCategoriaEncontrada int,
			@idArticuloCategoriaExistente int

	-- Validación del Articulo: debe existir

	SELECT
		@idArticuloEncontrado = idArticulo
	FROM Articulo
	WHERE idArticulo = @p_idArticulo

	IF @idArticuloEncontrado IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Categoria: debe existir

	SELECT
		@idCategoriaEncontrada = idCategoria
	FROM Categoria
	WHERE idCategoria = @p_idCategoria

	IF @idCategoriaEncontrada IS NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La categoría no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la relación: no debe existir ya esa combinación

	SELECT
		@idArticuloCategoriaExistente = idArticuloCategoria
	FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	IF @idArticuloCategoriaExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El artículo ya está asignado a esa categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO ArticuloCategoria (idArticulo, idCategoria)
	VALUES (@p_idArticulo, @p_idCategoria)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Asignación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 03-ArticuloCategoria/04-usp-quitar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Quitar la asignación de una categoría a un artículo
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_quitarCategoriaArticulo
	@p_idArticulo int,
	@p_idCategoria int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idArticuloCategoriaExistente int

	-- Validación de la relación: debe existir

	SELECT
		@idArticuloCategoriaExistente = idArticuloCategoria
	FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	IF @idArticuloCategoriaExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El artículo no está asignado a esa categoría'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	DELETE FROM ArticuloCategoria
	WHERE idArticulo = @p_idArticulo AND idCategoria = @p_idCategoria

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 05-Cliente/03-usp-insertar.sql
-- ============================================================
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

	INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
						 Correo)
	VALUES (@p_Nombre, @p_PrimerApellido, @p_SegundoApellido, @p_Sexo, @p_Telefono,
			@p_Correo)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 05-Cliente/04-usp-eliminar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja lógica de un cliente
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarCliente
	@p_idCliente int
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

	UPDATE Cliente
	SET 
		Activo = 0,
		FechaUltimaModificacion = GETDATE()
	WHERE idCliente = @p_idCliente

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 05-Cliente/05-usp-habilitar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Habilitar (reactivar) un cliente dado de baja
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_habilitarCliente
	@p_idCliente int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@Nombre varchar(50),
			@Activo bit

	-- Validación del Cliente: Revisamos primero si el idCliente existe en la tabla

	SELECT
		@Nombre = Nombre,
		@Activo = Activo
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @Nombre IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del estado: el cliente ya debe estar dado de baja

	IF @Activo = 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El cliente ya está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Cliente
	SET
		Activo = 1,
		FechaUltimaModificacion = GETDATE()
	WHERE idCliente = @p_idCliente

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Habilitación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 05-Cliente/06-usp-actualizar.sql
-- ============================================================
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

			@Nombre varchar(50),
			@CorreoExistente varchar(100),
			@TelefonoExistente varchar(20)

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

	SELECT
		@CorreoExistente = Correo
	FROM Cliente
	WHERE Correo = @p_Correo AND idCliente <> @p_idCliente

	IF @CorreoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El correo ya está registrado por otro cliente'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Telefono: no debe estar registrado por otro cliente

	SELECT
		@TelefonoExistente = Telefono
	FROM Cliente
	WHERE Telefono = @p_Telefono AND idCliente <> @p_idCliente

	IF @p_Telefono IS NOT NULL AND @TelefonoExistente IS NOT NULL BEGIN

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

GO

-- ============================================================
-- 06-Pedido/02-usp-insertar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Alta de un pedido, con validaciones de guard clause
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_insertarPedido
	@p_idCliente int,
	@p_Fecha date
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@ClienteActivo bit

	-- Validación del Cliente: debe existir

	SELECT
		@ClienteActivo = Activo
	FROM Cliente
	WHERE idCliente = @p_idCliente

	IF @ClienteActivo IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del Cliente: debe estar activo

	IF @ClienteActivo = 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El cliente está dado de baja'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Fecha: no puede ser fecha pasada

	IF @p_Fecha < GETDATE() BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La fecha no puede ser pasada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Pedido (idCliente, Fecha)
	VALUES (@p_idCliente, @p_Fecha)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 06-Pedido/03-usp-eliminar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Baja de un pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_eliminarPedido
	@p_idPedido int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int,
			@idDetallePedidoExistente int

	-- Validación del Pedido: debe existir

	SELECT
		@idCliente = idCliente
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idCliente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del DetallePedido: no debe tener líneas registradas

	SELECT
		@idDetallePedidoExistente = idDetallePedido
	FROM DetallePedido
	WHERE idPedido = @p_idPedido

	IF @idDetallePedidoExistente IS NOT NULL BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El pedido tiene líneas registradas y no puede eliminarse'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	DELETE FROM Pedido
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Eliminación correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

-- ============================================================
-- 06-Pedido/04-usp-actualizar.sql
-- ============================================================
-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Actualizar la fecha de un pedido
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE PROCEDURE usp_actualizarPedido
	@p_idPedido int,
	@p_Fecha date
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idCliente int

	-- Validación del Pedido: Revisamos primero si el idPedido existe en la tabla

	SELECT
		@idCliente = idCliente
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idCliente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de la Fecha: no puede ser fecha pasada

	IF @p_Fecha < GETDATE() BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La fecha no puede ser pasada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Pedido
	SET
		Fecha = @p_Fecha,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Actualización correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO

