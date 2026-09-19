# Tabla `BitacoraEstatusReceta`

Script: [`instalacion/11-BitacoraEstatusReceta/01-create-table.sql`](../../instalacion/11-BitacoraEstatusReceta/01-create-table.sql)

Historial de transiciones de estatus de una [`Receta`](Receta.md): una fila por cada vez que la receta cambió de estatus. Relación **1:N** con `Receta`, **N:1** con [`EstatusReceta`](EstatusReceta.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idBitacoraEstatusReceta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idReceta` | `INT` | No | — | FK a `Receta` |
| `idEstatusReceta` | `INT` | No | — | FK a `EstatusReceta` — el estatus al que transicionó en ese momento |
| `Fecha` | `DATETIME` | No | `GETDATE()` | Cuándo ocurrió la transición |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idBitacoraEstatusReceta)` | Llave primaria | Identifica cada renglón de bitácora de forma única. |
| `FOREIGN KEY (idReceta)` / `(idEstatusReceta)` | Llave foránea | Solo permite referenciar registros que existan. |

Se crea **vacía** en esta instalación inicial — el SP que cambie el estatus de una receta (pendiente de escribir) será quien la vaya llenando, un renglón por cada transición, junto con actualizar `Receta.idEstatusReceta` (ver la nota en [`Receta.md`](Receta.md)).
