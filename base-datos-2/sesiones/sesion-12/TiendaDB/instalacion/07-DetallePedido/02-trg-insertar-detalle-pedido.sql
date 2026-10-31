-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER INSERT sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cada vez que se le agrega una línea (versión de clase)
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_insertarDetallePedido
ON DetallePedido
AFTER INSERT
AS
BEGIN
	
	DECLARE 
		@idPedido int,
		@idArticulo int,
		@Total decimal(12,2),
		@CantidadArticulos int
		
	SELECT
		@idPedido = idPedido
	FROM inserted
	
	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = SUM(PrecioUnitario * Cantidad)
	FROM DetallePedido
	WHERE idPedido = @idPedido
	
	UPDATE Pedido
	SET
		CantidadArticulos = @CantidadArticulos,
		Total = @Total,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @idPedido
END

