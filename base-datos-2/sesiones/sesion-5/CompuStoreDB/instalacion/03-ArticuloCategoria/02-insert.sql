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
