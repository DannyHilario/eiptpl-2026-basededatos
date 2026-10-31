# Tabla `Articulo`

Scripts: [`instalacion/04-Articulo/`](../../instalacion/04-Articulo)

Catálogo de los artículos que vende la tienda, con su precio vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idArticulo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idClasificacion` | `INT` | No | — | FK a `Clasificacion` |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre del artículo con su presentación (por ejemplo, "Refresco de cola 600 ml") |
| `PrecioUnitario` | `DECIMAL(10,2)` | No | — | Precio **vigente** |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idArticulo)` | Llave primaria | Identifica cada registro. |
| `UNIQUE (Nombre)` | Único | No puede repetirse entre registros. |
| `DEFAULT 1` en `Activo` | Default | Todo registro nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `fk_Articulo_Clasificacion`: `FOREIGN KEY (idClasificacion)` → `Clasificacion(idClasificacion)` | Llave foránea | Solo permite referenciar registros de `Clasificacion` que existan. |
| `chk_Articulo_PrecioUnitario`: `CHECK (PrecioUnitario > 0)` | Check | Evita valores imposibles para el negocio. |

## El precio vigente

`PrecioUnitario` es el precio de **hoy** y puede cambiar. Cada cambio queda registrado en [`HistoricoPrecioArticulo`](HistoricoPrecioArticulo.md) por el trigger [`trg_insertarHistoricoPrecioArticulo`](../triggers/trg_insertarHistoricoPrecioArticulo.md). Las líneas de los pedidos guardan su propia copia del precio (ver [`DetallePedido`](DetallePedido.md)).

El nombre incluye la presentación porque "Refresco de cola 600 ml" y "Refresco de cola 2 L" son artículos distintos, con su propio precio.

## Relacionada con

- [`Clasificacion`](Clasificacion.md) — por `idClasificacion` (N:1).
- [`HistoricoPrecioArticulo`](HistoricoPrecioArticulo.md) — la referencia por `idArticulo` (1:N).
- [`DetallePedido`](DetallePedido.md) — la referencia por `idArticulo` (1:N).
