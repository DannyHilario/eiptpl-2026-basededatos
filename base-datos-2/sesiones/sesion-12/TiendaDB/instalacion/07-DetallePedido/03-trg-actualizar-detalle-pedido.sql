-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER UPDATE sobre DetallePedido: recalcula la cabecera del pedido
--              (CantidadArticulos y Total) cuando se modifica una línea; si la línea se movió
--              a otro pedido, recalcula también el pedido del que salió
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_actualizarDetallePedido
ON DetallePedido
AFTER UPDATE
AS
BEGIN

	DECLARE
		@idPedido int,
		@idPedidoAnterior int,
		@CantidadArticulos int,
		@Total decimal(12,2)

	-- El pedido de la línea como quedó (inserted) y como estaba (deleted)

	SELECT
		@idPedido = idPedido
	FROM inserted

	SELECT
		@idPedidoAnterior = idPedido
	FROM deleted

	-- Si el UPDATE no encontró ninguna línea, no hay nada que recalcular

	IF @idPedido IS NULL BEGIN
		RETURN
	END

	-- Recalcular la cabecera del pedido de la línea

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

	-- Si la línea se cambió de pedido, el pedido del que salió también cambió

	IF @idPedidoAnterior <> @idPedido BEGIN

		SELECT
			@CantidadArticulos = COUNT(idDetallePedido),
			@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
		FROM DetallePedido
		WHERE idPedido = @idPedidoAnterior

		UPDATE Pedido
		SET
			CantidadArticulos = @CantidadArticulos,
			Total = @Total,
			FechaUltimaModificacion = GETDATE()
		WHERE idPedido = @idPedidoAnterior

	END

END
