-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Calcular el total de un pedido a partir de sus líneas
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE FUNCTION ufn_calcularTotalPedido (@p_idPedido int)
RETURNS decimal(12,2)
AS
BEGIN

	DECLARE @Total decimal(12,2)

	SELECT
		@Total = SUM(Cantidad * PrecioUnitario)
	FROM DetallePedido
	WHERE idPedido = @p_idPedido

	RETURN ISNULL(@Total, 0)

END
