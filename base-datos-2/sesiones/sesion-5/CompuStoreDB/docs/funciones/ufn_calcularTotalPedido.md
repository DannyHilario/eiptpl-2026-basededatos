# `ufn_calcularTotalPedido`

Script: [`instalacion/06-Pedido/06-ufn-calcular-total.sql`](../../instalacion/06-Pedido/06-ufn-calcular-total.sql)

Función escalar que calcula el total de un pedido a partir de sus líneas en `DetallePedido` (`SUM(Cantidad * PrecioUnitario)`). El total **no se guarda** en `Pedido` — se calcula al vuelo cada vez que se necesita, para no arriesgar que quede desincronizado si se agrega/quita/modifica una línea. Si el pedido no tiene líneas (o no existe), regresa `0` en vez de `NULL`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido |

## Valor de retorno

`decimal(12,2)` — la suma de `Cantidad * PrecioUnitario` de todas las líneas de ese pedido en `DetallePedido`; `0` si no tiene líneas.

## Ejemplo de uso

```sql
SELECT dbo.ufn_calcularTotalPedido(1) AS Total
```

Una función escalar de usuario siempre se invoca con el prefijo del esquema (`dbo.`), a diferencia de una función del sistema como `GETDATE()`.

## Casos de prueba sugeridos

```sql
-- Preparar un pedido con dos líneas
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 2, @p_Cantidad = 1

-- Total esperado: 2 * PrecioUnitario(Articulo 1) + 1 * PrecioUnitario(Articulo 2)
SELECT dbo.ufn_calcularTotalPedido(@idPedidoPrueba) AS Total
SELECT SUM(Cantidad * PrecioUnitario) AS TotalEsperado FROM DetallePedido WHERE idPedido = @idPedidoPrueba

-- Pedido sin líneas: debe regresar 0, no NULL
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-16'
DECLARE @idPedidoVacio int = (SELECT MAX(idPedido) FROM Pedido)
SELECT dbo.ufn_calcularTotalPedido(@idPedidoVacio) AS Total

-- Pedido que no existe: también regresa 0
SELECT dbo.ufn_calcularTotalPedido(9999) AS Total
```
