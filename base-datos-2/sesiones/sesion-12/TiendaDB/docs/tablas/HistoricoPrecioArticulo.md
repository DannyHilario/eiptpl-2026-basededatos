# Tabla `HistoricoPrecioArticulo`

Scripts: [`instalacion/05-HistoricoPrecioArticulo/`](../../instalacion/05-HistoricoPrecioArticulo)

Cada cambio de precio de un artículo: de cuánto a cuánto y cuándo. La llena el trigger [`trg_insertarHistoricoPrecioArticulo`](../triggers/trg_insertarHistoricoPrecioArticulo.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idHistoricoPrecioArticulo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idArticulo` | `INT` | No | — | FK a `Articulo` |
| `PrecioAnterior` | `DECIMAL(10,2)` | No | — | Precio antes del cambio |
| `PrecioNuevo` | `DECIMAL(10,2)` | No | — | Precio después del cambio |
| `FechaCambio` | `DATETIME` | No | `GETDATE()` | Cuándo cambió el precio |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idHistoricoPrecioArticulo)` | Llave primaria | Identifica cada registro. |
| `DEFAULT GETDATE()` en `FechaCambio` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `fk_HistoricoPrecioArticulo_Articulo`: `FOREIGN KEY (idArticulo)` → `Articulo(idArticulo)` | Llave foránea | Solo permite referenciar registros de `Articulo` que existan. |
| `chk_HistoricoPrecioArticulo_PrecioAnterior`: `CHECK (PrecioAnterior > 0)` | Check | Evita valores imposibles para el negocio. |
| `chk_HistoricoPrecioArticulo_PrecioNuevo`: `CHECK (PrecioNuevo > 0)` | Check | Evita valores imposibles para el negocio. |
| `chk_HistoricoPrecioArticulo_Cambio`: `CHECK (PrecioNuevo <> PrecioAnterior)` | Check | El precio nuevo debe ser distinto del anterior: si no cambió, no es un cambio. |

## Diferencia con el precio de DetallePedido

Las dos guardan precios del pasado, pero responden preguntas distintas: `DetallePedido.PrecioUnitario` dice **a cuánto se le vendió a un cliente**, y esta tabla dice **cómo ha cambiado el precio del artículo**, aunque nadie lo haya comprado.

## Relacionada con

- [`Articulo`](Articulo.md) — por `idArticulo` (N:1).
