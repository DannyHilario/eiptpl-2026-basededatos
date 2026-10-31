# `trg_actualizarEstatusPedido`

Script: [`instalacion/08-BitacoraEstatusPedido/02-trg-actualizar-estatus-pedido.sql`](../../instalacion/08-BitacoraEstatusPedido/02-trg-actualizar-estatus-pedido.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `Pedido` | `AFTER` | `UPDATE` |

Cada vez que **cambia el estatus** de un pedido, registra el estatus nuevo en [`BitacoraEstatusPedido`](../tablas/BitacoraEstatusPedido.md). Así la bitácora queda completa sin importar quién cambió el estatus: un procedimiento o un `UPDATE` escrito a mano. El script vive en la carpeta de la bitácora porque necesita que esa tabla ya exista.

## Cómo lo hace

```sql
INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
SELECT I.idPedido, I.idEstatusPedido, GETDATE(), GETDATE(), GETDATE()
FROM inserted I
INNER JOIN deleted D ON D.idPedido = I.idPedido
WHERE I.idEstatusPedido <> D.idEstatusPedido
```

| Parte | Para qué |
|-------|----------|
| `inserted I INNER JOIN deleted D` | Pone en la misma fila el estatus nuevo (`I`) y el anterior (`D`) de cada pedido |
| `WHERE I.idEstatusPedido <> D.idEstatusPedido` | Solo registra los pedidos cuyo estatus **cambió** |
| `INSERT … SELECT` | Registra un renglón por cada pedido que cambió, aunque un solo `UPDATE` cambie muchos |

## Por qué comparar el estatus anterior

`Pedido` se actualiza por muchas razones que no son un cambio de estatus:

| Quién hace el `UPDATE` | Qué cambia |
|------------------------|------------|
| Los triggers de [`DetallePedido`](../tablas/DetallePedido.md) | `CantidadArticulos`, `Total` y `FechaUltimaModificacion` |
| [`usp_actualizarPedido`](../procedimientos/usp_actualizarPedido.md) | `DireccionEntrega` y `CostoEnvio` |

Todos esos `UPDATE` disparan este trigger. Sin la comparación, registraría otra vez el estatus actual: el `UNIQUE (idPedido, idEstatusPedido)` de la bitácora lo rechazaría, y el error **desharía** la operación original. Agregar un artículo o cambiar la dirección fallaría.

## De la versión de clase a esta versión

La versión que se escribió en clase guardaba `inserted` en variables y registraba **con cualquier `UPDATE`**:

| Problema en la versión de clase | Corrección |
|---------------------------------|------------|
| Registraba aunque el estatus no hubiera cambiado: fallaban `usp_actualizarPedido` y agregar artículos a un pedido | Solo registra si `inserted` y `deleted` tienen estatus distinto |
| Con variables, un `UPDATE` que cambiaba el estatus de varios pedidos registraba **uno** | `INSERT … SELECT` desde `inserted`: un renglón por pedido |
| Un `UPDATE` que no encontraba filas dejaba las variables en `NULL`, y el `INSERT` a la bitácora fallaba (`Msg 515`: `idPedido` no acepta `NULL`) | El `INNER JOIN` sobre tablas vacías no regresa filas: no registra nada |

## Qué no hace

- **No registra el primer estatus.** Un pedido nuevo no se *actualiza*, se inserta: el estatus Creado lo registra [`usp_crearPedido`](../procedimientos/usp_crearPedido.md).
- **No valida la transición.** Si alguien regresa un pedido a un estatus anterior, el `UNIQUE` de la bitácora lo detiene solo cuando ese estatus ya estaba registrado. La regla completa (1 → 2, 2 → 3, 2 → 4) necesita que el trigger **rechace** el cambio con `THROW`: ver [THROW](../../../../../temas/Etapa-4/07-Throw.md).

## Resultados (pruebas 15 a 17 y 19 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Renglones nuevos en la bitácora |
|-----------|---------------------------------|
| `usp_actualizarPedido` cambia la dirección del pedido 3 | Ninguno |
| Se agrega una línea al pedido 3 (el trigger de la línea actualiza la cabecera) | Ninguno |
| El pedido 3 pasa a Enviado | 1: (3, 2) |
| Un solo `UPDATE` pasa a Enviado los pedidos 1 y 2 | 2: (1, 2) y (2, 2) |
