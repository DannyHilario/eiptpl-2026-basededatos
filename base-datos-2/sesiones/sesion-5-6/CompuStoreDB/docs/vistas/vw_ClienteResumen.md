# `vw_ClienteResumen`

Script: [`instalacion/08-Vistas/04-vw-cliente-resumen.sql`](../../instalacion/08-Vistas/04-vw-cliente-resumen.sql)

Un renglón por cliente con cuántos pedidos ha hecho y cuánto ha gastado en total. Todos los clientes aparecen, incluso los que nunca han hecho un pedido (`LEFT JOIN`), con `0` pedidos y `0` gastado.

`TotalGastado` solo suma pedidos **entregados** (`Cerrado = 1`), usando [`ufn_calcularTotalPedido`](../funciones/ufn_calcularTotalPedido.md) — un pedido abierto (carrito sin entregar) no cuenta como gasto real todavía. `TotalPedidos`, en cambio, cuenta **todos** los pedidos del cliente, entregados o no.

## Columnas

| Columna | Origen | Descripción |
|---------|--------|-------------|
| `idCliente` | `Cliente` | Id del cliente |
| `NombreCliente` | `Cliente` | `Nombre + PrimerApellido + SegundoApellido` concatenados |
| `TotalPedidos` | calculado | `COUNT` de todos los pedidos del cliente (entregados o no) |
| `TotalGastado` | calculado | Suma de `ufn_calcularTotalPedido` solo de los pedidos con `Cerrado = 1` |
| `FechaUltimoPedido` | calculado | `MAX(Fecha)` de sus pedidos; `NULL` si nunca ha hecho uno |

## Ejemplo de uso

```sql
-- Los 5 clientes que más han gastado
SELECT TOP 5 * FROM vw_ClienteResumen ORDER BY TotalGastado DESC
```

## Casos de prueba sugeridos

```sql
-- Cliente sin pedidos: debe aparecer con 0 y 0, no ausente
SELECT * FROM vw_ClienteResumen WHERE idCliente = 5

-- Preparar un pedido entregado
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 2
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba

-- TotalPedidos = 1, TotalGastado = total del pedido entregado
SELECT * FROM vw_ClienteResumen WHERE idCliente = 1

-- Agregar un segundo pedido SIN entregar: TotalPedidos sube a 2, TotalGastado no cambia
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-16'
SELECT * FROM vw_ClienteResumen WHERE idCliente = 1
```
