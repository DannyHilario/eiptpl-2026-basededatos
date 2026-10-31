# `usp_actualizarPedido`

Script: [`instalacion/06-Pedido/03-usp-actualizar.sql`](../../instalacion/06-Pedido/03-usp-actualizar.sql)

Cambia los datos propios de un pedido: su **dirección de entrega** y su **costo de envío**. Solo se permite mientras el pedido está en estatus **Creado**: una vez enviado, ya no se modifica.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Pedido a modificar; debe existir y estar en estatus Creado |
| `@p_DireccionEntrega` | `varchar(200)` | Dirección nueva; no puede venir vacía |
| `@p_CostoEnvio` | `decimal(10,2)` | Costo de envío nuevo; no puede ser negativo |

## Qué no cambia

| Dato | Por qué no |
|------|------------|
| El cliente | Un pedido es siempre del cliente que lo hizo |
| El estatus | Tiene sus propias reglas de transición (1 → 2, 2 → 3, 2 → 4); cambiarlo corresponde a otro procedimiento |
| `CantidadArticulos` y `Total` | Los mantienen los triggers de [`DetallePedido`](../tablas/DetallePedido.md) |

## Validaciones y códigos de salida

| Orden | Validación | ErrCodigo | ErrMensaje |
|-------|------------|-----------|------------|
| 1 | El pedido existe | `000001` | El pedido no existe |
| 2 | El pedido está en estatus Creado | `000002` | Solo se puede modificar un pedido en estatus Creado |
| 3 | La dirección no es `NULL` ni solo espacios | `000003` | La dirección de entrega es obligatoria |
| 4 | El costo de envío no es `NULL` ni negativo | `000004` | El costo de envío no puede ser negativo |
| — | Todo correcto: actualiza el pedido | `000000` | Pedido actualizado |

La validación 1 y la 2 usan la misma consulta: se guarda el estatus en `@idEstatusPedido`; si queda en `NULL`, el pedido no existe, y si es distinto de 1, ya no está en Creado.

## Relación con los triggers

El `UPDATE` que hace el procedimiento **dispara** [`trg_actualizarEstatusPedido`](../triggers/trg_actualizarEstatusPedido.md). Como el estatus no cambió, el trigger no registra nada en la bitácora. Antes de la corrección del 31 de octubre, ese trigger registraba con cualquier `UPDATE`, y el `UNIQUE` de la bitácora hacía fallar este procedimiento.

## Ejemplos

```sql
-- Éxito: 000000
EXEC usp_actualizarPedido 3, 'Calzada Madero 1250, Col. Centro, CP 64000', 0.00;

-- El pedido no existe: 000001
EXEC usp_actualizarPedido 999, 'Otra dirección', 0.00;

-- El pedido ya se envió: 000002
EXEC usp_actualizarPedido 3, 'Otra dirección', 0.00;
```

Las pruebas 15 y 18 de [`pruebas.sql`](../../pruebas.sql) muestran cada caso.
