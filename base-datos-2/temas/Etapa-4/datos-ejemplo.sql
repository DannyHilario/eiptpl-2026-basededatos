-- Tema:        Etapa 4 - Datos de los ejemplos
-- Descripción: Pedidos de ejemplo en TiendaDB para los temas de la Etapa 4: 8 pedidos de octubre de 2026
--              en los cuatro estatus, con sus líneas y su bitácora. Ejecutar completo (F5) sobre una
--              instalación limpia de TiendaDB; los triggers de DetallePedido calculan las cabeceras
-- Autor:       Daniel Hilario

USE TiendaDB;

-- Pedido 1
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (1, '2026-10-05 10:15', 'Hidalgo 210 Pte., Col. Centro, CP 64000', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (1, 1, '2026-10-05 10:15');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 1, idArticulo, 6, PrecioUnitario
FROM Articulo
WHERE idArticulo = 1;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 1, idArticulo, 2, PrecioUnitario
FROM Articulo
WHERE idArticulo = 6;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 1, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 21;

UPDATE Pedido
SET idEstatusPedido = 2
WHERE idPedido = 1;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (1, 2, '2026-10-05 11:15');

UPDATE Pedido
SET idEstatusPedido = 4
WHERE idPedido = 1;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (1, 4, '2026-10-05 12:15');

-- Pedido 2
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (2, '2026-10-06 18:40', 'Padre Mier 845 Ote., Col. Centro, CP 64000', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (2, 1, '2026-10-06 18:40');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 2, idArticulo, 2, PrecioUnitario
FROM Articulo
WHERE idArticulo = 16;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 2, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 22;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 2, idArticulo, 3, PrecioUnitario
FROM Articulo
WHERE idArticulo = 26;

UPDATE Pedido
SET idEstatusPedido = 2
WHERE idPedido = 2;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (2, 2, '2026-10-06 19:40');

UPDATE Pedido
SET idEstatusPedido = 4
WHERE idPedido = 2;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (2, 4, '2026-10-06 20:40');

-- Pedido 3
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (3, '2026-10-08 12:05', 'Morelos 1450 Ote., Col. Obispado, CP 64060', 0.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (3, 1, '2026-10-08 12:05');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 3, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 31;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 3, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 32;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 3, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 35;

UPDATE Pedido
SET idEstatusPedido = 2
WHERE idPedido = 3;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (3, 2, '2026-10-08 13:05');

-- Pedido 4
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (4, '2026-10-09 20:30', 'Av. Garza Sada 2501, Col. Tecnológico, CP 64700', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (4, 1, '2026-10-09 20:30');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 4, idArticulo, 10, PrecioUnitario
FROM Articulo
WHERE idArticulo = 11;

UPDATE Pedido
SET idEstatusPedido = 2
WHERE idPedido = 4;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (4, 2, '2026-10-09 21:30');

UPDATE Pedido
SET idEstatusPedido = 3
WHERE idPedido = 4;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (4, 3, '2026-10-09 22:30');

-- Pedido 5
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (5, '2026-10-12 09:50', 'Calzada Madero 1200, Col. Centro, CP 64000', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (5, 1, '2026-10-12 09:50');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 5, idArticulo, 12, PrecioUnitario
FROM Articulo
WHERE idArticulo = 2;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 5, idArticulo, 4, PrecioUnitario
FROM Articulo
WHERE idArticulo = 8;

-- Pedido 6
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (1, '2026-10-14 17:20', 'Hidalgo 210 Pte., Col. Centro, CP 64000', 0.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (6, 1, '2026-10-14 17:20');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 6, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 36;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 6, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 37;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 6, idArticulo, 2, PrecioUnitario
FROM Articulo
WHERE idArticulo = 40;

-- Pedido 7
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (6, '2026-10-15 13:35', 'Av. Lázaro Cárdenas 1000, Col. Valle Oriente, CP 66269', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (7, 1, '2026-10-15 13:35');

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 7, idArticulo, 3, PrecioUnitario
FROM Articulo
WHERE idArticulo = 4;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 7, idArticulo, 2, PrecioUnitario
FROM Articulo
WHERE idArticulo = 19;

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 7, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 24;

UPDATE Pedido
SET idEstatusPedido = 2
WHERE idPedido = 7;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (7, 2, '2026-10-15 14:35');

UPDATE Pedido
SET idEstatusPedido = 4
WHERE idPedido = 7;

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (7, 4, '2026-10-15 15:35');

-- Pedido 8
INSERT INTO Pedido (idCliente, FechaPedido, DireccionEntrega, CostoEnvio)
VALUES (7, '2026-10-16 11:00', 'Zaragoza 500 Sur, Col. Centro, CP 64000', 35.00);

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio)
VALUES (8, 1, '2026-10-16 11:00');
