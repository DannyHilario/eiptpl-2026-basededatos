-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER DELETE sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cuando se le quita una línea
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_eliminarDetallePedido
ON DetallePedido
AFTER DELETE
AS
BEGIN

	DECLARE
		@idPedido int,
		@CantidadArticulos int,
		@Total decimal(12,2)

	-- En un DELETE, la línea eliminada solo está en deleted

	SELECT
		@idPedido = idPedido
	FROM deleted

	-- Si el DELETE no encontró ninguna línea, no hay nada que recalcular

	IF @idPedido IS NULL BEGIN
		RETURN
	END

	-- Recalcular con las líneas que le quedan al pedido.
	-- Si era la última, SUM regresa NULL: ISNULL lo convierte en 0,
	-- porque Pedido.Total no acepta NULL

	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
	FROM DetallePedido
	WHERE idPedido = @idPedido

	UPDATE Pedido
	SET
		CantidadArticulos = @CantidadArticulos,
		Total = @Total,
		FechaUltimaModificacion = GETDATE()
	WHERE idPedido = @idPedido

END
