# Tabla `HistoricoPrecioArticulo`

Script: [`instalacion/04-HistoricoPrecioArticulo/01-create-table.sql`](../../instalacion/04-HistoricoPrecioArticulo/01-create-table.sql)

Historial de cambios de precio de un artículo (`PrecioAnterior` → `PrecioNuevo`), **1:N** con `Articulo`. Es un log de auditoría de solo inserción — por diseño no tiene `usp_eliminar`/`usp_actualizar` (perdería el sentido de historial inmutable).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idHistoricoPrecioArticulo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idArticulo` | `INT` | No | — | FK a `Articulo` |
| `PrecioAnterior` | `DECIMAL(10,2)` | No | — | Precio antes del cambio |
| `PrecioNuevo` | `DECIMAL(10,2)` | No | — | Precio después del cambio |
| `Fecha` | `DATETIME` | No | — | Momento del cambio (no tiene default: la asigna el SP con `GETDATE()` en cada `INSERT`, no queda a discreción del motor) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría del renglón (normalmente igual a `Fecha`) |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | No debería cambiar — el renglón no se actualiza una vez insertado |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idHistoricoPrecioArticulo)` | Llave primaria | Identifica cada cambio de precio. |
| `FOREIGN KEY (idArticulo) REFERENCES Articulo` | Llave foránea | No se puede registrar un cambio de precio de un artículo que no existe. |
| `CHECK (PrecioAnterior >= 0)` | Check | Un precio histórico negativo no representa nada real (aquí se permite `0` porque podría representar un artículo que antes no tenía precio de lista todavía). |
| `CHECK (PrecioNuevo >= 0)` | Check | Mismo criterio para el precio nuevo. |
| `CHECK (PrecioNuevo <> PrecioAnterior)` | Check | **La constraint que le da sentido a la tabla**: no tiene caso registrar un "cambio" que en realidad no cambió nada. `usp_insertarHistoricoPrecioArticulo` valida lo mismo antes, con mensaje amigable, en vez de dejar que el `INSERT` falle con el error crudo del `CHECK`. |

## SPs relacionados

[`usp_insertarHistoricoPrecioArticulo`](../usp_insertarHistoricoPrecioArticulo.md) (pieza interna) · [`usp_actualizarPrecioArticulo`](../usp_actualizarPrecioArticulo.md) (el que se debe usar para cambiar un precio)
