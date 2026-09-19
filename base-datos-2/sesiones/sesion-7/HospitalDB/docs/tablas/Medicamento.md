# Tabla `Medicamento`

Script: [`instalacion/09-Medicamento/01-create-table.sql`](../../instalacion/09-Medicamento/01-create-table.sql)

Catálogo de medicamentos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idMedicamento` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre del medicamento (ej. "Paracetamol 500mg") |
| `Marca` | `VARCHAR(50)` | No | — | Marca comercial |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idMedicamento)` | Llave primaria | Identifica cada medicamento de forma única. |
| `UNIQUE (Nombre, Marca)` | Único | Evita registrar dos veces el mismo medicamento de la misma marca. |
| `DEFAULT 1` en `Activo` | Default | Todo medicamento nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Relacionada con

[`DetalleReceta`](DetalleReceta.md) — las líneas de receta donde se prescribe (1:N).
