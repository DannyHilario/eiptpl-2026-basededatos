# `vw_PedidoResumen`

Script: [`instalacion/08-Vistas/01-vw-pedido-resumen.sql`](../../instalacion/08-Vistas/01-vw-pedido-resumen.sql)

Vista de negocio: un renglón por pedido con el nombre completo del cliente, el estado de entrega y el total (calculado con [`ufn_calcularTotalPedido`](../funciones/ufn_calcularTotalPedido.md), no almacenado).

> Vive en `08-Vistas/` (no en `06-Pedido/`) junto con las demás vistas que cruzan varios dominios. `CREATE VIEW` no tiene resolución diferida de nombres como sí la tienen `CREATE PROCEDURE`/`CREATE FUNCTION` — necesita que **todas** sus tablas/funciones referenciadas ya existan al momento de crearla, así que las vistas se agrupan al final del paquete de instalación, después de que toda la base ya está creada.

## Columnas

| Columna | Origen | Descripción |
|---------|--------|-------------|
| `idPedido` | `Pedido` | Id del pedido |
| `idCliente` | `Pedido` | Id del cliente |
| `NombreCliente` | `Cliente` | `Nombre + PrimerApellido + SegundoApellido` concatenados |
| `Fecha` | `Pedido` | Fecha del pedido |
| `Cerrado` | `Pedido` | `1` si ya fue entregado |
| `FechaEntrega` | `Pedido` | `1900-01-01` si todavía no se entrega |
| `Total` | calculado | `ufn_calcularTotalPedido(idPedido)` |

## Ejemplo de uso

```sql
SELECT *
FROM vw_PedidoResumen
WHERE Cerrado = 0
ORDER BY Fecha
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido con líneas
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 2

-- Antes de entregar: Cerrado = 0, FechaEntrega = 1900-01-01
SELECT * FROM vw_PedidoResumen WHERE idPedido = @idPedidoPrueba

-- Después de entregar: Cerrado = 1, FechaEntrega = hoy
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
SELECT * FROM vw_PedidoResumen WHERE idPedido = @idPedidoPrueba
```
