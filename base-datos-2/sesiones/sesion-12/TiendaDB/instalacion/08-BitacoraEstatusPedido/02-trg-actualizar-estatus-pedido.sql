-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Trigger AFTER UPDATE sobre Pedido: registra en BitacoraEstatusPedido el estatus nuevo
--              de cada pedido cuyo estatus cambió. Los UPDATE que no cambian el estatus (como el
--              recálculo de la cabecera que hacen los triggers de DetallePedido) no registran nada
-- Autor:       Daniel Hilario

USE TiendaDB;
GO

CREATE TRIGGER trg_actualizarEstatusPedido
ON Pedido
AFTER UPDATE
AS
BEGIN

	-- inserted tiene el estatus nuevo y deleted el anterior: solo se registran
	-- los pedidos en los que son distintos, sin importar cuántos cambió el UPDATE

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
	SELECT I.idPedido, I.idEstatusPedido, GETDATE(), GETDATE(), GETDATE()
	FROM inserted I
	INNER JOIN deleted D ON D.idPedido = I.idPedido
	WHERE I.idEstatusPedido <> D.idEstatusPedido

END
