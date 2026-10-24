-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Instalación completa (tablas y catálogos) en un solo script
-- Autor:       Daniel Hilario

--
-- Generado concatenando los scripts de instalacion/ en orden de carpeta y archivo.
-- Ejecútalo completo en SSMS (F5). Pedido, DetallePedido, HistoricoPrecioArticulo y
-- BitacoraEstatusPedido se crean vacías.

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
