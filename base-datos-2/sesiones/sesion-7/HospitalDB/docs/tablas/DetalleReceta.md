# Tabla `DetalleReceta`

Script: [`instalacion/10-DetalleReceta/01-create-table.sql`](../../instalacion/10-DetalleReceta/01-create-table.sql)

Líneas de una [`Receta`](Receta.md): qué [`Medicamento`](Medicamento.md), cuántas unidades, y con qué indicaciones.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idDetalleReceta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idReceta` | `INT` | No | — | FK a `Receta` |
| `idMedicamento` | `INT` | No | — | FK a `Medicamento` |
| `Cantidad` | `INT` | No | — | Cantidad prescrita |
| `Indicaciones` | `VARCHAR(200)` | Sí | — | Dosis/frecuencia (ej. "Tomar 1 tableta cada 8 horas") |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idDetalleReceta)` | Llave primaria | Identifica cada línea de receta de forma única. |
| `FOREIGN KEY (idReceta)` / `(idMedicamento)` | Llave foránea | Solo permite referenciar registros que existan. |
| `CHECK (Cantidad > 0)` | Check | No permite cantidades cero o negativas. |

## Regla de negocio pendiente de validar en el SP correspondiente

Una receta solo puede ganar líneas aquí mientras su estatus es `1 Creada` o `2 En atención`; en `3`, `4` o `5` debe ser un error. Si estaba en `1`, al agregar la primera línea pasa a `2` (si ya estaba en `2`, se queda en `2`). No tiene `Activo`: es una tabla de hechos, no un catálogo — quitar una línea es un `DELETE` físico.
