-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Reversa: eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE TiendaDB;

-- Paso 1: BitacoraEstatusPedido — depende de Pedido y de EstatusPedido
DROP TABLE IF EXISTS BitacoraEstatusPedido;

-- Paso 2: DetallePedido — depende de Pedido y de Articulo
DROP TABLE IF EXISTS DetallePedido;

-- Paso 3: Pedido — depende de Cliente y de EstatusPedido; ya no tiene dependientes tras eliminar DetallePedido y BitacoraEstatusPedido
DROP TABLE IF EXISTS Pedido;

-- Paso 4: HistoricoPrecioArticulo — depende de Articulo
DROP TABLE IF EXISTS HistoricoPrecioArticulo;

-- Paso 5: Articulo — depende de Clasificacion; ya no tiene dependientes tras eliminar DetallePedido e HistoricoPrecioArticulo
DROP TABLE IF EXISTS Articulo;

-- Paso 6: Clasificacion — ya no tiene dependientes tras eliminar Articulo
DROP TABLE IF EXISTS Clasificacion;

-- Paso 7: EstatusPedido — ya no tiene dependientes tras eliminar Pedido y BitacoraEstatusPedido
DROP TABLE IF EXISTS EstatusPedido;

-- Paso 8: Cliente — ya no tiene dependientes tras eliminar Pedido
DROP TABLE IF EXISTS Cliente;
