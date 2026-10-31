# Tabla `BitacoraEstatusPedido`

Scripts: [`instalacion/08-BitacoraEstatusPedido/`](../../instalacion/08-BitacoraEstatusPedido)

Cada estatus por el que pasa un pedido, con su fecha. Resuelve la relación N:M entre [`Pedido`](Pedido.md) y [`EstatusPedido`](EstatusPedido.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idBitacoraEstatusPedido` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPedido` | `INT` | No | — | FK a `Pedido` |
| `idEstatusPedido` | `INT` | No | — | FK a `EstatusPedido` |
| `FechaCambio` | `DATETIME` | No | `GETDATE()` | Cuándo pasó el pedido a ese estatus |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idBitacoraEstatusPedido)` | Llave primaria | Identifica cada registro. |
| `DEFAULT GETDATE()` en `FechaCambio` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `fk_BitacoraEstatusPedido_Pedido`: `FOREIGN KEY (idPedido)` → `Pedido(idPedido)` | Llave foránea | Solo permite referenciar registros de `Pedido` que existan. |
| `fk_BitacoraEstatusPedido_EstatusPedido`: `FOREIGN KEY (idEstatusPedido)` → `EstatusPedido(idEstatusPedido)` | Llave foránea | Solo permite referenciar registros de `EstatusPedido` que existan. |
| `uq_BitacoraEstatusPedido_Pedido_Estatus`: `UNIQUE (idPedido, idEstatusPedido)` | Único compuesto | La combinación no puede repetirse. |

## Por qué el UNIQUE compuesto

Un pedido **nunca regresa** a un estatus anterior, así que pasa por cada estatus una sola vez. `UNIQUE (idPedido, idEstatusPedido)` lo garantiza y además evita registrar dos veces el mismo cambio.

## Quién la llena

Por ahora se registra **a mano** después de crear el pedido (ver [`pruebas.sql`](../../pruebas.sql)). Que la llene un trigger sobre `Pedido` está en [lo que falta](../../../README.md#7-lo-que-falta) de la sesión.

## Relacionada con

- [`Pedido`](Pedido.md) — por `idPedido` (N:1).
- [`EstatusPedido`](EstatusPedido.md) — por `idEstatusPedido` (N:1).
