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
