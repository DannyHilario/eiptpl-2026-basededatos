-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Pruebas de los triggers de la clase, en el orden en que se construyeron.
--              Ejecutar una sección a la vez (seleccionarla y F5), sobre una instalación limpia,
--              y revisar el resultado de cada una
-- Autor:       Daniel Hilario

USE TiendaDB;

-- =====================================================================
-- Parte 1. Histórico de precios (trg_insertarHistoricoPrecioArticulo)
-- =====================================================================

-- Prueba 1: el histórico empieza vacío.
-- Los 40 artículos se insertaron con su precio inicial: un INSERT no es un cambio de precio
SELECT idHistoricoPrecioArticulo, idArticulo, PrecioAnterior, PrecioNuevo, FechaCambio
FROM HistoricoPrecioArticulo;
-- Esperado: 0 filas

-- Prueba 2: cambia el precio del artículo 27 (Atún en agua 130 g) de 13.00 a 14.50.
-- El trigger toma el precio anterior de deleted y el nuevo de inserted
UPDATE Articulo
SET PrecioUnitario = 14.50
WHERE idArticulo = 27;

SELECT idHistoricoPrecioArticulo, idArticulo, PrecioAnterior, PrecioNuevo, FechaCambio
FROM HistoricoPrecioArticulo;
-- Esperado: 1 fila, artículo 27, de 13.00 a 14.50

-- Prueba 3: un UPDATE que NO cambia el precio también dispara el trigger,
-- pero el IF @PrecioAnterior = @PrecioNuevo lo termina con RETURN antes del INSERT
UPDATE Articulo
SET Activo = 1
WHERE idArticulo = 27;

SELECT idHistoricoPrecioArticulo, idArticulo, PrecioAnterior, PrecioNuevo, FechaCambio
FROM HistoricoPrecioArticulo;
-- Esperado: sigue 1 fila

-- =====================================================================
-- Parte 2. Crear un pedido (sin trigger todavía)
-- =====================================================================

-- Prueba 4: se crea el pedido del cliente 8 y se registra su primer estatus en la bitácora.
-- SCOPE_IDENTITY() regresa el idPedido que se acaba de generar en este mismo lote.
-- Ejecutar las 3 sentencias juntas: la variable solo existe dentro del lote
DECLARE @idPedido int

INSERT INTO Pedido (idCliente, idEstatusPedido, FechaPedido, DireccionEntrega, CostoEnvio,
                    CantidadArticulos, Total, FechaCreacion, FechaUltimaModificacion)
VALUES (8, 1, GETDATE(), 'Jiménez 321 Sur, Col. Centro, CP 64000', 50.32,
        0, 0, GETDATE(), GETDATE())

SELECT @idPedido = SCOPE_IDENTITY()

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
VALUES (@idPedido, 1, GETDATE(), GETDATE(), GETDATE())

SELECT idPedido, idCliente, idEstatusPedido, CantidadArticulos, Total
FROM Pedido;

SELECT idBitacoraEstatusPedido, idPedido, idEstatusPedido, FechaCambio
FROM BitacoraEstatusPedido;
-- Esperado: pedido 1, cliente 8, estatus 1, CantidadArticulos 0 y Total 0.00;
-- bitácora: 1 fila (pedido 1, estatus 1)

-- =====================================================================
-- Parte 3. Agregar artículos al pedido (trg_insertarDetallePedido)
-- =====================================================================

-- Prueba 5: se agrega el artículo 9 (Cacahuate natural 150 g, $16.00) x 3.
-- El precio de la línea es el precio VIGENTE del artículo, que se copia en el INSERT.
-- El trigger recalcula la cabecera del pedido
DECLARE @PrecioActual decimal(10,2)

SELECT
	@PrecioActual = PrecioUnitario
FROM Articulo
WHERE idArticulo = 9

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario, FechaCreacion, FechaUltimaModificacion)
VALUES (1, 9, 3, @PrecioActual, GETDATE(), GETDATE())

SELECT idPedido, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = 1;
-- Esperado: CantidadArticulos 1, Total 48.00 (3 x 16.00)

-- Prueba 6: dos líneas más: artículo 12 ($32.00) x 2 y artículo 38 ($44.00) x 5
INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario, FechaCreacion, FechaUltimaModificacion)
SELECT 1, idArticulo, 2, PrecioUnitario, GETDATE(), GETDATE()
FROM Articulo
WHERE idArticulo = 12;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario, FechaCreacion, FechaUltimaModificacion)
SELECT 1, idArticulo, 5, PrecioUnitario, GETDATE(), GETDATE()
FROM Articulo
WHERE idArticulo = 38;

SELECT idDetallePedido, idArticulo, Cantidad, PrecioUnitario
FROM DetallePedido
WHERE idPedido = 1;

SELECT idPedido, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = 1;
-- Esperado: 3 líneas; CantidadArticulos 3, Total 332.00 (48.00 + 64.00 + 220.00)

-- Prueba 7: el mismo artículo dos veces en el mismo pedido viola uq_DetallePedido_Pedido_Articulo.
-- Esperado: Msg 2627 (Violation of UNIQUE KEY constraint); la línea no se inserta
-- y la cabecera no cambia (sigue en 332.00)
INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario, FechaCreacion, FechaUltimaModificacion)
VALUES (1, 9, 1, 16.00, GETDATE(), GETDATE());

SELECT idPedido, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = 1;

-- =====================================================================
-- Parte 4. Cambiar y quitar líneas (trg_actualizarDetallePedido y trg_eliminarDetallePedido)
-- =====================================================================

-- Prueba 8: la línea del artículo 9 pasa de 3 a 4 piezas.
-- trg_actualizarDetallePedido recalcula la cabecera
UPDATE DetallePedido
SET Cantidad = 4
WHERE idPedido = 1 AND idArticulo = 9;

SELECT idPedido, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = 1;
-- Esperado: CantidadArticulos 3, Total 348.00 (64.00 + 64.00 + 220.00)

-- Prueba 9: se quita la línea del artículo 12.
-- trg_eliminarDetallePedido recalcula con las líneas que quedan
DELETE FROM DetallePedido
WHERE idPedido = 1 AND idArticulo = 12;

SELECT idPedido, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = 1;
-- Esperado: CantidadArticulos 2, Total 284.00 (64.00 + 220.00)

-- Prueba 10: se crea el pedido 2 (cliente 3) y la línea del artículo 38 se MUEVE del pedido 1 al 2.
-- En el UPDATE, deleted dice de qué pedido salió la línea e inserted a cuál llegó:
-- el trigger recalcula los dos pedidos
DECLARE @idPedido2 int

INSERT INTO Pedido (idCliente, idEstatusPedido, FechaPedido, DireccionEntrega, CostoEnvio,
                    CantidadArticulos, Total, FechaCreacion, FechaUltimaModificacion)
VALUES (3, 1, GETDATE(), 'Morelos 1450 Ote., Col. Obispado, CP 64060', 0,
        0, 0, GETDATE(), GETDATE())

SELECT @idPedido2 = SCOPE_IDENTITY()

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
VALUES (@idPedido2, 1, GETDATE(), GETDATE(), GETDATE())

UPDATE DetallePedido
SET idPedido = @idPedido2
WHERE idPedido = 1 AND idArticulo = 38;

SELECT idPedido, CantidadArticulos, Total
FROM Pedido;
-- Esperado: pedido 1 con 1 línea y Total 64.00; pedido 2 con 1 línea y Total 220.00

-- Prueba 11: se quita la ÚLTIMA línea del pedido 1.
-- Sin líneas, SUM regresa NULL; el ISNULL del trigger lo deja en 0
DELETE FROM DetallePedido
WHERE idPedido = 1;

SELECT idPedido, CantidadArticulos, Total
FROM Pedido;
-- Esperado: pedido 1 con 0 líneas y Total 0.00; pedido 2 sin cambios (220.00)

-- Prueba 12: un UPDATE y un DELETE que no encuentran ninguna línea.
-- Los triggers se disparan igual, pero salen con RETURN: ninguna cabecera cambia
UPDATE DetallePedido
SET Cantidad = 10
WHERE idDetallePedido = 999;

DELETE FROM DetallePedido
WHERE idDetallePedido = 999;

SELECT idPedido, CantidadArticulos, Total, FechaUltimaModificacion
FROM Pedido;
-- Esperado: igual que en la prueba 11, con la misma FechaUltimaModificacion
