-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Instalación completa (tablas, catálogos, procedimientos almacenados y triggers) en un solo script
-- Autor:       Daniel Hilario

--
-- Generado concatenando los scripts de instalacion/ en orden de carpeta y archivo.
-- Ejecútalo completo en SSMS (F5): cada script va separado con GO, porque
-- CREATE PROCEDURE y CREATE TRIGGER deben ser la primera sentencia de su lote.
-- Pedido, DetallePedido, HistoricoPrecioArticulo y BitacoraEstatusPedido se crean vacías.

-- ===== instalacion/00-create-database.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear base de datos TiendaDB
-- Autor:       Daniel Hilario

CREATE DATABASE TiendaDB;
GO

-- ===== instalacion/01-Cliente/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ===== instalacion/01-Cliente/02-insert.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar 20 clientes
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, Telefono, Correo)
VALUES ('Mariana', 'Garza', 'Treviño', '8131000001', 'mariana.garza@hotmail.com'),
       ('Jorge', 'Villarreal', 'Cantú', '8131000002', 'jorge.villarreal@outlook.com'),
       ('Sofía', 'Martínez', 'Salinas', '8131000003', 'sofia.martinez@yahoo.com'),
       ('Luis', 'Rodríguez', 'Elizondo', '8131000004', 'luis.rodriguez@gmail.com'),
       ('Andrea', 'Hernández', 'Leal', '8131000005', 'andrea.hernandez@hotmail.com'),
       ('Carlos', 'González', 'Zambrano', '8131000006', 'carlos.gonzalez@outlook.com'),
       ('Valeria', 'Pérez', 'Cavazos', '8131000007', 'valeria.perez@yahoo.com'),
       ('Diego', 'Sánchez', 'Montemayor', '8131000008', 'diego.sanchez@gmail.com'),
       ('Fernanda', 'Ramírez', 'Quiroga', '8131000009', 'fernanda.ramirez@hotmail.com'),
       ('Ricardo', 'Flores', 'Benavides', '8131000010', 'ricardo.flores@outlook.com'),
       ('Daniela', 'Torres', 'Saldaña', '8131000011', 'daniela.torres@yahoo.com'),
       ('Héctor', 'Gómez', 'Lozano', '8131000012', 'hector.gomez@gmail.com'),
       ('Paola', 'Díaz', 'Rangel', '8131000013', 'paola.diaz@hotmail.com'),
       ('Roberto', 'Cruz', 'Tamez', '8131000014', 'roberto.cruz@outlook.com'),
       ('Ximena', 'Morales', 'Guajardo', '8131000015', 'ximena.morales@yahoo.com'),
       ('Arturo', 'Ortiz', 'Barrera', '8131000016', 'arturo.ortiz@gmail.com'),
       ('Natalia', 'Reyes', 'Chapa', '8131000017', 'natalia.reyes@hotmail.com'),
       ('Emilio', 'Castillo', 'Garza', '8131000018', 'emilio.castillo@outlook.com'),
       ('Regina', 'Mendoza', 'Villarreal', '8131000019', 'regina.mendoza@yahoo.com'),
       ('Óscar', 'Aguilar', 'Sepúlveda', '8131000020', 'oscar.aguilar@gmail.com');
GO

-- ===== instalacion/02-EstatusPedido/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla EstatusPedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE EstatusPedido (
    idEstatusPedido INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ===== instalacion/02-EstatusPedido/02-insert.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar los 4 estatus de un pedido (id explícito: las reglas de negocio dependen de él)
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO EstatusPedido (idEstatusPedido, Nombre)
VALUES (1, 'Creado'),
       (2, 'Enviado'),
       (3, 'Cancelado'),
       (4, 'Entregado');
GO

-- ===== instalacion/03-Clasificacion/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Clasificacion
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Clasificacion (
    idClasificacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ===== instalacion/03-Clasificacion/02-insert.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar las 8 clasificaciones de artículos
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO Clasificacion (Nombre)
VALUES ('Bebidas'),
       ('Botanas'),
       ('Dulces y chocolates'),
       ('Lácteos'),
       ('Panadería'),
       ('Abarrotes'),
       ('Limpieza del hogar'),
       ('Higiene personal');
GO

-- ===== instalacion/04-Articulo/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Articulo
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Articulo (
    idArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idClasificacion INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Articulo_Clasificacion FOREIGN KEY (idClasificacion) REFERENCES Clasificacion(idClasificacion),
    CONSTRAINT chk_Articulo_PrecioUnitario CHECK (PrecioUnitario > 0)
);
GO

-- ===== instalacion/04-Articulo/02-insert.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar 40 artículos (5 por clasificación) con su precio vigente
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO Articulo (idClasificacion, Nombre, PrecioUnitario)
VALUES (1, 'Refresco de cola 600 ml', 23.00),
       (1, 'Agua natural 1 L', 18.00),
       (1, 'Agua mineral 600 ml', 22.00),
       (1, 'Bebida hidratante 1 L', 44.00),
       (1, 'Néctar de durazno 960 ml', 31.00),
       (2, 'Papas fritas adobadas 42 g', 28.00),
       (2, 'Totopos sabor queso 61 g', 28.00),
       (2, 'Frituras de queso 48 g', 26.00),
       (2, 'Cacahuate natural 150 g', 16.00),
       (2, 'Galletas con chispas de chocolate 76 g', 23.50),
       (3, 'Chocolate con leche y almendras 38 g', 30.00),
       (3, 'Chocolate relleno de cacahuate 40 g', 32.00),
       (3, 'Gomitas enchiladas 70 g', 27.00),
       (3, 'Paleta de caramelo con chamoy 14 g', 4.00),
       (3, 'Dulce de tamarindo enchilado 30 g', 16.00),
       (4, 'Leche entera 1 L', 30.00),
       (4, 'Leche deslactosada 1 L', 33.00),
       (4, 'Yogurt bebible de fresa 220 g', 11.00),
       (4, 'Queso panela 200 g', 45.00),
       (4, 'Queso crema 200 g', 46.00),
       (5, 'Pan blanco de caja 620 g', 52.00),
       (5, 'Pan integral 620 g', 58.00),
       (5, 'Donas 6 piezas', 27.00),
       (5, 'Pan relleno de chocolate 62 g', 22.50),
       (5, 'Tortillas de harina 15 piezas', 25.00),
       (6, 'Sopa instantánea en vaso 64 g', 27.00),
       (6, 'Atún en agua 130 g', 13.00),
       (6, 'Arroz 900 g', 15.00),
       (6, 'Frijoles refritos 430 g', 12.50),
       (6, 'Café capuchino en sobre 20 g', 12.00),
       (7, 'Detergente en polvo 1 kg', 45.00),
       (7, 'Cloro 950 ml', 18.50),
       (7, 'Limpiador multiusos 1 L', 47.00),
       (7, 'Suavizante de telas 700 ml', 36.00),
       (7, 'Papel higiénico 4 rollos', 35.00),
       (8, 'Pasta dental 75 ml', 32.00),
       (8, 'Jabón de tocador 120 g', 29.50),
       (8, 'Shampoo 200 ml', 44.00),
       (8, 'Desodorante en barra 50 g', 68.00),
       (8, 'Pañuelos desechables 90 piezas', 32.50);
GO

-- ===== instalacion/05-HistoricoPrecioArticulo/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla HistoricoPrecioArticulo
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE HistoricoPrecioArticulo (
    idHistoricoPrecioArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idArticulo INT NOT NULL,
    PrecioAnterior DECIMAL(10,2) NOT NULL,
    PrecioNuevo DECIMAL(10,2) NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_HistoricoPrecioArticulo_Articulo FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioAnterior CHECK (PrecioAnterior > 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_PrecioNuevo CHECK (PrecioNuevo > 0),
    CONSTRAINT chk_HistoricoPrecioArticulo_Cambio CHECK (PrecioNuevo <> PrecioAnterior)
);
GO

-- ===== instalacion/05-HistoricoPrecioArticulo/02-trg-insertar-historico-precio.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER UPDATE sobre Articulo: cuando cambia el precio de un artículo,
--              registra el precio anterior y el nuevo en HistoricoPrecioArticulo (versión de clase)
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_insertarHistoricoPrecioArticulo
ON Articulo
AFTER UPDATE
AS
BEGIN
	
	DECLARE 
		@PrecioAnterior decimal(10,2),
		@PrecioNuevo decimal (10,2),
		@idArticulo int
		
	-- Obtener el precio anterior (a eliminar)
		
	SELECT
		@PrecioAnterior = PrecioUnitario,
		@idArticulo = idArticulo
	FROM deleted
		
	-- Obtener el precio actual (a insertar)
				
	SELECT
		@PrecioNuevo = PrecioUnitario
	FROM inserted
		
	IF @PrecioAnterior = @PrecioNuevo BEGIN -- Si el precio es el mismo, nos salimos porque no tiene caso el registro
		RETURN
	END
	
	IF @PrecioAnterior IS NULL OR @PrecioNuevo IS NULL BEGIN
		RETURN
	END
	
	
	INSERT INTO HistoricoPrecioArticulo (idArticulo, PrecioAnterior, PrecioNuevo, FechaCambio, FechaCreacion, FechaUltimaModificacion)
	VALUES (
		@idArticulo,
		@PrecioAnterior,
		@PrecioNuevo,
		GETDATE(),
		GETDATE(),
		GETDATE()
	)
	
END
GO

-- ===== instalacion/06-Pedido/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla Pedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE Pedido (
    idPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idEstatusPedido INT NOT NULL DEFAULT 1,
    FechaPedido DATETIME NOT NULL DEFAULT GETDATE(),
    DireccionEntrega VARCHAR(200) NOT NULL,
    CostoEnvio DECIMAL(10,2) NOT NULL DEFAULT 0,
    CantidadArticulos INT NOT NULL DEFAULT 0,
    Total DECIMAL(12,2) NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Pedido_EstatusPedido FOREIGN KEY (idEstatusPedido) REFERENCES EstatusPedido(idEstatusPedido),
    CONSTRAINT chk_Pedido_CostoEnvio CHECK (CostoEnvio >= 0),
    CONSTRAINT chk_Pedido_CantidadArticulos CHECK (CantidadArticulos >= 0),
    CONSTRAINT chk_Pedido_Total CHECK (Total >= 0)
);
GO

-- ===== instalacion/06-Pedido/02-usp-crear.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear un pedido en estatus Creado y registrar su primer estatus en la bitácora,
--              con validaciones y códigos de salida
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE PROCEDURE usp_crearPedido
	@p_idCliente int,
	@p_DireccionEntrega varchar(200),
	@p_CostoEnvio decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idClienteExistente int,
			@idPedido int

	-- Validación 1: el cliente debe existir y estar activo

	SELECT
		@idClienteExistente = idCliente
	FROM Cliente
	WHERE idCliente = @p_idCliente
		AND Activo = 1

	IF @idClienteExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe o no está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 2: la dirección de entrega no puede venir vacía

	IF @p_DireccionEntrega IS NULL OR LTRIM(RTRIM(@p_DireccionEntrega)) = '' BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La dirección de entrega es obligatoria'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 3: el costo de envío no puede ser negativo

	IF @p_CostoEnvio IS NULL OR @p_CostoEnvio < 0 BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El costo de envío no puede ser negativo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- El pedido nace en estatus Creado, sin líneas y con total 0 (los DEFAULT de la tabla)

	INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
	VALUES (@p_idCliente, @p_DireccionEntrega, @p_CostoEnvio)

	SELECT @idPedido = SCOPE_IDENTITY()

	-- Primer estatus en la bitácora

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido)
	VALUES (@idPedido, 1)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Pedido creado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje,
			@idPedido as idPedido

END
GO

-- ===== instalacion/06-Pedido/03-usp-actualizar.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Actualizar la dirección de entrega y el costo de envío de un pedido en estatus Creado,
--              con validaciones y códigos de salida
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE PROCEDURE usp_actualizarPedido
	@p_idPedido int,
	@p_DireccionEntrega varchar(200),
	@p_CostoEnvio decimal(10,2)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idEstatusPedido int

	-- Validación 1: el pedido debe existir

	SELECT
		@idEstatusPedido = idEstatusPedido
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idEstatusPedido IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 2: solo se modifica un pedido en estatus Creado

	IF @idEstatusPedido <> 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'Solo se puede modificar un pedido en estatus Creado'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 3: la dirección de entrega no puede venir vacía

	IF @p_DireccionEntrega IS NULL OR LTRIM(RTRIM(@p_DireccionEntrega)) = '' BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La dirección de entrega es obligatoria'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 4: el costo de envío no puede ser negativo

	IF @p_CostoEnvio IS NULL OR @p_CostoEnvio < 0 BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El costo de envío no puede ser negativo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	UPDATE Pedido
	SET
		DireccionEntrega = @p_DireccionEntrega,
		CostoEnvio = @p_CostoEnvio,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @p_idPedido

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Pedido actualizado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
GO

-- ===== instalacion/07-DetallePedido/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla DetallePedido
-- Autor:       Daniel Hilario

USE TiendaDB;

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
    CONSTRAINT chk_DetallePedido_PrecioUnitario CHECK (PrecioUnitario > 0),
    CONSTRAINT uq_DetallePedido_Pedido_Articulo UNIQUE (idPedido, idArticulo)
);
GO

-- ===== instalacion/07-DetallePedido/02-trg-insertar-detalle-pedido.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER INSERT sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cada vez que se le agrega una línea (versión de clase)
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_insertarDetallePedido
ON DetallePedido
AFTER INSERT
AS
BEGIN
	
	DECLARE 
		@idPedido int,
		@idArticulo int,
		@Total decimal(12,2),
		@CantidadArticulos int
		
	SELECT
		@idPedido = idPedido
	FROM inserted
	
	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = SUM(PrecioUnitario * Cantidad)
	FROM DetallePedido
	WHERE idPedido = @idPedido
	
	UPDATE Pedido
	SET
		CantidadArticulos = @CantidadArticulos,
		Total = @Total,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @idPedido
END
GO

-- ===== instalacion/07-DetallePedido/03-trg-actualizar-detalle-pedido.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER UPDATE sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cuando se modifica una línea; si la línea se movió
--              a otro pedido, recalcula también el pedido del que salió
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_actualizarDetallePedido
ON DetallePedido
AFTER UPDATE
AS
BEGIN

	DECLARE
		@idPedido int,
		@idPedidoAnterior int,
		@CantidadArticulos int,
		@Total decimal(12,2)

	-- El pedido de la línea como quedó (inserted) y como estaba (deleted)

	SELECT
		@idPedido = idPedido
	FROM inserted

	SELECT
		@idPedidoAnterior = idPedido
	FROM deleted

	-- Si el UPDATE no encontró ninguna línea, no hay nada que recalcular

	IF @idPedido IS NULL BEGIN
		RETURN
	END

	-- Recalcular la cabecera del pedido de la línea

	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
	FROM DetallePedido
	WHERE idPedido = @idPedido

	UPDATE Pedido
	SET
		CantidadArticulos = @CantidadArticulos,
		Total = @Total,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @idPedido

	-- Si la línea se cambió de pedido, el pedido del que salió también cambió

	IF @idPedidoAnterior <> @idPedido BEGIN

		SELECT
			@CantidadArticulos = COUNT(idDetallePedido),
			@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
		FROM DetallePedido
		WHERE idPedido = @idPedidoAnterior

		UPDATE Pedido
		SET
			CantidadArticulos = @CantidadArticulos,
			Total = @Total,
			FechaUltimaModificacion = GETDATE()
		WHERE idPedido = @idPedidoAnterior

	END

END
GO

-- ===== instalacion/07-DetallePedido/04-trg-eliminar-detalle-pedido.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER DELETE sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cuando se le quita una línea
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_eliminarDetallePedido
ON DetallePedido
AFTER DELETE
AS
BEGIN

	DECLARE
		@idPedido int,
		@CantidadArticulos int,
		@Total decimal(12,2)

	-- En un DELETE, la línea eliminada solo está en deleted

	SELECT
		@idPedido = idPedido
	FROM deleted

	-- Si el DELETE no encontró ninguna línea, no hay nada que recalcular

	IF @idPedido IS NULL BEGIN
		RETURN
	END

	-- Recalcular con las líneas que le quedan al pedido.
	-- Si era la última, SUM regresa NULL: ISNULL lo convierte en 0,
	-- porque Pedido.Total no acepta NULL

	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
	FROM DetallePedido
	WHERE idPedido = @idPedido

	UPDATE Pedido
	SET
		CantidadArticulos = @CantidadArticulos,
		Total = @Total,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @idPedido

END
GO

-- ===== instalacion/08-BitacoraEstatusPedido/01-create-table.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Crear tabla BitacoraEstatusPedido
-- Autor:       Daniel Hilario

USE TiendaDB;

CREATE TABLE BitacoraEstatusPedido (
    idBitacoraEstatusPedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPedido INT NOT NULL,
    idEstatusPedido INT NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_BitacoraEstatusPedido_Pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT fk_BitacoraEstatusPedido_EstatusPedido FOREIGN KEY (idEstatusPedido) REFERENCES EstatusPedido(idEstatusPedido),
    CONSTRAINT uq_BitacoraEstatusPedido_Pedido_Estatus UNIQUE (idPedido, idEstatusPedido)
);
GO

-- ===== instalacion/08-BitacoraEstatusPedido/02-trg-actualizar-estatus-pedido.sql =====
-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER UPDATE sobre Pedido: registra en BitacoraEstatusPedido el estatus nuevo
--              de cada pedido cuyo estatus cambió. Los UPDATE que no cambian el estatus (como el
--              recálculo de la cabecera que hacen los triggers de DetallePedido) no registran nada
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_actualizarEstatusPedido
ON Pedido
AFTER UPDATE
AS
BEGIN

	-- inserted tiene el estatus nuevo y deleted el anterior: solo se registran
	-- los pedidos en los que son distintos, sin importar cuántos cambió el UPDATE

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
	SELECT I.idPedido, I.idEstatusPedido, GETDATE(), GETDATE(), GETDATE()
	FROM inserted I
	INNER JOIN deleted D ON D.idPedido = I.idPedido
	WHERE I.idEstatusPedido <> D.idEstatusPedido

END
GO
