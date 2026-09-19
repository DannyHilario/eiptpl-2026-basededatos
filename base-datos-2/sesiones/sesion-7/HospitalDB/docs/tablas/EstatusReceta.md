# Tabla `EstatusReceta`

Script: [`instalacion/06-EstatusReceta/01-create-table.sql`](../../instalacion/06-EstatusReceta/01-create-table.sql)

Catálogo de los 5 estatus por los que transiciona una receta: `1 Creada`, `2 En atención`, `3 Surtida`, `4 Surtida parcialmente`, `5 Cancelada`.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idEstatusReceta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(30)` | No | — | Nombre del estatus |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idEstatusReceta)` | Llave primaria | Identifica cada estatus de forma única. |
| `UNIQUE (Nombre)` | Único | Evita registrar dos veces el mismo estatus. |
| `DEFAULT 1` en `Activo` | Default | Consistencia con el resto de los catálogos, aunque en la práctica estos 5 registros no se dan de baja. |

## Reglas de negocio de las transiciones

Válidas: `1 → 2`, `2 → 3`, `2 → 4`, `4 → 3`, `1 → 5`, `2 → 5`. **No** válidas: `3 → 4` ni cancelar (`→ 5`) desde `3` o `4` — una vez surtida (parcial o completa) ya no se cancela. Estas reglas se validan en [`usp_cambiarEstatusReceta`](../procedimientos/usp_cambiarEstatusReceta.md).

## Relacionada con

[`Receta`](Receta.md) — su estatus actual (1:N). [`BitacoraEstatusReceta`](BitacoraEstatusReceta.md) — el historial de transiciones (1:N).
