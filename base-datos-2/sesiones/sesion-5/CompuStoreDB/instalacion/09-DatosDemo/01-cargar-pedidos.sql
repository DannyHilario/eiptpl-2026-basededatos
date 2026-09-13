-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Cargar 35 pedidos de ejemplo (con líneas y algunos ya entregados), para poder
--              probar/demostrar las vistas y funciones sin tener que fabricar datos a mano.
-- Autor:       Daniel Hilario

USE CompuStoreDB;

DECLARE @idPedido int,
        @Fecha date

-- Pedido 1 de 35: cliente 1, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 2, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 20, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 37, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 2 de 35: cliente 2, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 3, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 2, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 22, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 39, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 5, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 3 de 35: cliente 3, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 4, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 3, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 24, @p_Cantidad = 5

-- Pedido 4 de 35: cliente 4, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 5, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 4, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 26, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 43, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 5 de 35: cliente 5, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 6, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 5, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 28, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 45, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 11, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 6 de 35: cliente 6, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 7, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 6, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 30, @p_Cantidad = 3

-- Pedido 7 de 35: cliente 7, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 8, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 7, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 32, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 49, @p_Cantidad = 5
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 8 de 35: cliente 8, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 9, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 8, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 34, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 51, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 17, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 9 de 35: cliente 9, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 10, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 9, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 36, @p_Cantidad = 1

-- Pedido 10 de 35: cliente 10, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 11, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 10, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 38, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 4, @p_Cantidad = 3
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 11 de 35: cliente 11, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 12, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 11, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 40, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 6, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 23, @p_Cantidad = 5
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 12 de 35: cliente 12, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 13, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 12, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 42, @p_Cantidad = 4

-- Pedido 13 de 35: cliente 13, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 14, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 13, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 44, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 10, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 14 de 35: cliente 14, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 15, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 14, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 46, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 12, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 29, @p_Cantidad = 3
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 15 de 35: cliente 15, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 15, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 48, @p_Cantidad = 2

-- Pedido 16 de 35: cliente 16, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 2, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 16, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 50, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 16, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 17 de 35: cliente 17, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 3, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 17, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 1, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 18, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 35, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 18 de 35: cliente 18, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 4, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 18, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 3, @p_Cantidad = 5

-- Pedido 19 de 35: cliente 19, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 5, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 19, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 5, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 22, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 20 de 35: cliente 20, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 6, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 20, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 7, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 24, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 41, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 21 de 35: cliente 21, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 7, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 21, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 9, @p_Cantidad = 3

-- Pedido 22 de 35: cliente 22, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 8, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 22, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 11, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 28, @p_Cantidad = 5
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 23 de 35: cliente 23, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 9, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 23, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 13, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 30, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 47, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 24 de 35: cliente 24, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 10, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 24, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 15, @p_Cantidad = 1

-- Pedido 25 de 35: cliente 25, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 11, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 25, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 17, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 34, @p_Cantidad = 3
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 26 de 35: cliente 1, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 12, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 19, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 36, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 2, @p_Cantidad = 5
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 27 de 35: cliente 2, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 13, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 2, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 21, @p_Cantidad = 4

-- Pedido 28 de 35: cliente 3, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 14, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 3, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 23, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 40, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 29 de 35: cliente 4, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 15, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 4, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 25, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 42, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 8, @p_Cantidad = 3
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 30 de 35: cliente 5, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 5, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 27, @p_Cantidad = 2

-- Pedido 31 de 35: cliente 6, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 2, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 6, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 29, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 46, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 32 de 35: cliente 7, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 3, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 7, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 31, @p_Cantidad = 4
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 48, @p_Cantidad = 5
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 14, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 33 de 35: cliente 8, 1 línea(s), abierto
SET @Fecha = DATEADD(DAY, 4, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 8, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 33, @p_Cantidad = 5

-- Pedido 34 de 35: cliente 9, 2 línea(s), entregado
SET @Fecha = DATEADD(DAY, 5, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 9, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 35, @p_Cantidad = 1
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 1, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedido

-- Pedido 35 de 35: cliente 10, 3 línea(s), entregado
SET @Fecha = DATEADD(DAY, 6, CAST(GETDATE() AS DATE))
EXEC usp_insertarPedido @p_idCliente = 10, @p_Fecha = @Fecha
SET @idPedido = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 37, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 3, @p_Cantidad = 3
EXEC usp_insertarDetallePedido @p_idPedido = @idPedido, @p_idArticulo = 20, @p_Cantidad = 4
EXEC usp_entregarPedido @p_idPedido = @idPedido

