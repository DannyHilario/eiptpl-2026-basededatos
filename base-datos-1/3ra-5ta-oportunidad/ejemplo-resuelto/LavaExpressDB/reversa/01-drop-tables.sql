-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE LavaExpressDB;

-- Paso 1: Pedido — depende de Cliente y de TipoServicio
DROP TABLE IF EXISTS Pedido;

-- Paso 2: TipoServicio — ya no tiene dependientes tras eliminar Pedido
DROP TABLE IF EXISTS TipoServicio;

-- Paso 3: Cliente — depende de Sucursal; ya no tiene dependientes tras eliminar Pedido
DROP TABLE IF EXISTS Cliente;

-- Paso 4: Sucursal — ya no tiene dependientes tras eliminar Cliente
DROP TABLE IF EXISTS Sucursal;
