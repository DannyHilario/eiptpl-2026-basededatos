# Tabla `Receta`

Script: [`instalacion/08-Receta/01-create-table.sql`](../../instalacion/08-Receta/01-create-table.sql)

Hecho — **1:1** con [`Consulta`](Consulta.md); referencia su estatus actual.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idReceta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idConsulta` | `INT` | No | — | FK a `Consulta`, `UNIQUE` (1:1) |
| `idEstatusReceta` | `INT` | No | — | FK a `EstatusReceta` — estatus **actual** de la receta |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idReceta)` | Llave primaria | Identifica cada receta de forma única. |
| `FOREIGN KEY (idConsulta)` + `UNIQUE (idConsulta)` | Llave foránea única | Garantiza que cada consulta genere **como máximo una** receta (relación 1:1); sin el `UNIQUE` sería 1:N. |
| `FOREIGN KEY (idEstatusReceta)` | Llave foránea | Solo permite estatus que existan en el catálogo. |

## `idEstatusReceta` vs. `BitacoraEstatusReceta` — por qué se guarda en ambos lados

`idEstatusReceta` es una copia de lectura rápida del estatus vigente; [`BitacoraEstatusReceta`](BitacoraEstatusReceta.md) guarda el historial completo (una fila por cada transición). Es el mismo patrón que `Articulo.PrecioUnitario` + `HistoricoPrecioArticulo` en `CompuStoreDB` (sesión 5): evita tener que calcular `MAX(Fecha)` sobre la bitácora cada vez que alguien solo necesita saber el estatus actual. La responsabilidad de mantener ambos sincronizados recaerá en el SP que cambie el estatus (pendiente de escribir): debe actualizar `Receta.idEstatusReceta` **y** registrar la transición en `BitacoraEstatusReceta` en la misma operación.

No tiene `Activo`: es una tabla de hechos, no un catálogo.

## Relacionada con

[`DetalleReceta`](DetalleReceta.md) — sus líneas de medicamentos (1:N).
