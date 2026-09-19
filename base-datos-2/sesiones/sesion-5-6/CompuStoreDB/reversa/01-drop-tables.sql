-- Tema:        Reversa CompuStoreDB - Sesión 5-6
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE CompuStoreDB;

-- Paso 1: DetallePedido — depende de Pedido y de Articulo
DROP TABLE IF EXISTS DetallePedido;

-- Paso 2: Pedido — depende de Cliente
DROP TABLE IF EXISTS Pedido;

-- Paso 3: HistoricoPrecioArticulo — depende de Articulo
DROP TABLE IF EXISTS HistoricoPrecioArticulo;

-- Paso 4: ArticuloCategoria — depende de Articulo y de Categoria
DROP TABLE IF EXISTS ArticuloCategoria;

-- Paso 5: Cliente — ya no tiene dependientes tras eliminar Pedido
DROP TABLE IF EXISTS Cliente;

-- Paso 6: Articulo — ya no tiene dependientes tras eliminar DetallePedido, HistoricoPrecioArticulo y ArticuloCategoria
DROP TABLE IF EXISTS Articulo;

-- Paso 7: Categoria — ya no tiene dependientes tras eliminar ArticuloCategoria
DROP TABLE IF EXISTS Categoria;
