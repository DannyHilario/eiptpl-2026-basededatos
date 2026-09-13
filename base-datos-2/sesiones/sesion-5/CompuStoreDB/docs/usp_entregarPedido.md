# `usp_entregarPedido`

Script: [`instalacion/06-Pedido/05-usp-entregar.sql`](../instalacion/06-Pedido/05-usp-entregar.sql)

Marca un pedido como entregado: pone `Cerrado = 1` y `FechaEntrega = GETDATE()` en una sola operación. Es el evento que **cierra** un pedido — a partir de aquí `usp_actualizarPedido`, `usp_eliminarPedido`, `usp_insertarDetallePedido`, `usp_actualizarDetallePedido` y `usp_eliminarDetallePedido` lo rechazan.

`Cerrado` nace en `0` y `FechaEntrega` nace en `1900-01-01` (fecha centinela: "todavía no entregado", en vez de dejar la columna en `NULL`) al insertar el pedido — este SP es la única forma de cambiarlos.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido a marcar como entregado |

## Validaciones (orden en que se evalúan)

1. El pedido debe existir.
2. El pedido no debe estar ya entregado (`Cerrado = 1`).
3. El pedido debe tener al menos una línea en `DetallePedido` — no tiene sentido entregar un pedido vacío.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | El pedido ya fue entregado | `Cerrado` ya era `1` |
| `000003` | El pedido no tiene líneas registradas y no puede entregarse | `DetallePedido` vacío para ese pedido |
| `000000` | Entrega registrada correctamente | Éxito |

## Ejemplo de uso

```sql
EXEC usp_entregarPedido @p_idPedido = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba con una línea
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1

-- Pedido sin líneas (usar un pedido nuevo, vacío)
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-16'
DECLARE @idPedidoVacio int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_entregarPedido @p_idPedido = @idPedidoVacio

-- Éxito
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
SELECT Cerrado, FechaEntrega FROM Pedido WHERE idPedido = @idPedidoPrueba

-- Ya fue entregado (correrlo dos veces seguidas)
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba

-- Pedido no existe
EXEC usp_entregarPedido @p_idPedido = 9999
```

## Nota sobre limpieza de datos de prueba

Un pedido entregado ya no se puede borrar con `usp_eliminarPedido` (por diseño). Para limpiar datos de prueba de un pedido ya entregado hay que hacer el `DELETE` directo (no a través de los SPs), en el orden correcto por las llaves foráneas:

```sql
DELETE FROM DetallePedido WHERE idPedido = @idPedidoPrueba
DELETE FROM Pedido WHERE idPedido = @idPedidoPrueba
```
