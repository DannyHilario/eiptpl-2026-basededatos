# `usp_crearPedido`

Script: [`instalacion/06-Pedido/02-usp-crear.sql`](../../instalacion/06-Pedido/02-usp-crear.sql)

Crea un pedido nuevo para un cliente y registra su primer estatus (**Creado**) en la bitácora. El pedido nace sin líneas y con total 0: los artículos se agregan después.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Cliente que hace el pedido; debe existir y estar activo |
| `@p_DireccionEntrega` | `varchar(200)` | Dirección a la que se envía; no puede venir vacía |
| `@p_CostoEnvio` | `decimal(10,2)` | Costo del envío; no puede ser negativo |

No recibe estatus, fecha, líneas ni total: los pone la tabla con sus `DEFAULT` (estatus 1, `GETDATE()`, 0 y 0). Así nadie puede crear un pedido que ya esté "Enviado" o con un total inventado.

## Validaciones y códigos de salida

| Orden | Validación | ErrCodigo | ErrMensaje |
|-------|------------|-----------|------------|
| 1 | El cliente existe y está activo | `000001` | El cliente no existe o no está activo |
| 2 | La dirección no es `NULL` ni solo espacios | `000002` | La dirección de entrega es obligatoria |
| 3 | El costo de envío no es `NULL` ni negativo | `000003` | El costo de envío no puede ser negativo |
| — | Todo correcto: crea el pedido | `000000` | Pedido creado |

Cuando todo sale bien, además de `ErrCodigo` y `ErrMensaje` regresa la columna **`idPedido`**, para agregarle artículos enseguida.

## Cómo lo hace

1. Inserta el pedido con `idCliente`, `DireccionEntrega` y `CostoEnvio`.
2. Obtiene el `idPedido` con **`SCOPE_IDENTITY()`**: es la única forma segura cuando hay triggers, porque `@@IDENTITY` podría regresar el id de un registro que insertó un trigger (ver la [sesión 12](../../../README.md#3-crear-un-pedido-scope_identity)).
3. Registra en [`BitacoraEstatusPedido`](../tablas/BitacoraEstatusPedido.md) el estatus 1.

El primer estatus lo registra **el procedimiento** porque el trigger de la bitácora, [`trg_actualizarEstatusPedido`](../triggers/trg_actualizarEstatusPedido.md), solo atiende `UPDATE`: un pedido nuevo no cambia de estatus, nace con él.

## Ejemplos

```sql
-- Éxito: 000000 e idPedido
EXEC usp_crearPedido 5, 'Calzada Madero 1200, Col. Centro, CP 64000', 35.00;

-- El cliente no existe: 000001
EXEC usp_crearPedido 999, 'Calzada Madero 1200', 35.00;

-- Dirección vacía: 000002
EXEC usp_crearPedido 5, '   ', 35.00;

-- Envío negativo: 000003
EXEC usp_crearPedido 5, 'Calzada Madero 1200', -10.00;
```

Las pruebas 13 y 14 de [`pruebas.sql`](../../pruebas.sql) muestran cada caso.
