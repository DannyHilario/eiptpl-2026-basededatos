-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Vista de artículos con las categorías que tienen asignadas
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE VIEW vw_ArticuloConCategorias
AS
SELECT
	a.idArticulo,
	cat.idCategoria,
	cat.Nombre AS Categoria,
	a.Nombre AS Articulo,
	a.Marca,
	a.PrecioUnitario
FROM Articulo a
INNER JOIN ArticuloCategoria ac ON ac.idArticulo = a.idArticulo
INNER JOIN Categoria cat ON cat.idCategoria = ac.idCategoria
