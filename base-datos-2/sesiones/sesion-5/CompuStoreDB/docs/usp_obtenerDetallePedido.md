# `usp_obtenerDetallePedido`

Script: [`instalacion/06-Pedido/07-usp-obtener-detalle.sql`](../instalacion/06-Pedido/07-usp-obtener-detalle.sql)

Consulta el detalle completo (encabezado + líneas) de **un solo pedido**. Es un SP de solo **consulta**, no modifica nada — ilustra que un procedimiento almacenado también sirve para encapsular un `SELECT` parametrizado, no solo para `INSERT`/`UPDATE`/`DELETE`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido a consultar |

## Validaciones

1. El pedido debe existir.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |

Si el pedido **sí** existe, no regresa `ErrCodigo`/`ErrMensaje` — regresa directamente el result set con el detalle (una fila por línea del pedido; `0` filas si el pedido existe pero todavía no tiene líneas).

## Columnas que regresa (cuando el pedido existe)

| Columna | Origen | Descripción |
|---------|--------|-------------|
| `idPedido` | `Pedido` | Id del pedido |
| `Fecha` | `Pedido` | Fecha del pedido |
| `Cerrado` | `Pedido` | `1` si ya fue entregado |
| `FechaEntrega` | `Pedido` | `1900-01-01` si todavía no se entrega |
| `idDetallePedido` | `DetallePedido` | Id de la línea |
| `idArticulo` | `Articulo` | Id del artículo de esa línea |
| `Articulo` | `Articulo.Nombre` | Nombre del artículo |
| `Marca` | `Articulo` | Marca del artículo |
| `Cantidad` | `DetallePedido` | Cantidad de esa línea |
| `PrecioUnitario` | `DetallePedido` | Precio congelado al momento de la venta |
| `Subtotal` | calculado | `Cantidad * PrecioUnitario` de esa línea |

## Ejemplo de uso

```sql
EXEC usp_obtenerDetallePedido @p_idPedido = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido con 2 líneas
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 2, @p_Cantidad = 1

-- Éxito: debe regresar 2 renglones
EXEC usp_obtenerDetallePedido @p_idPedido = @idPedidoPrueba

-- Pedido sin líneas: 0 renglones, sin error
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-16'
DECLARE @idPedidoVacio int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_obtenerDetallePedido @p_idPedido = @idPedidoVacio

-- Pedido que no existe
EXEC usp_obtenerDetallePedido @p_idPedido = 9999
```
