# Tabla `Articulo`

Script: [`instalacion/02-Articulo/01-create-table.sql`](../../instalacion/02-Articulo/01-create-table.sql)

Catálogo de artículos, con el precio de lista vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idArticulo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre del artículo |
| `Marca` | `VARCHAR(50)` | No | — | Marca del artículo |
| `PrecioUnitario` | `DECIMAL(10,2)` | No | — | Precio de lista **vigente**. Cambia solo vía [`usp_actualizarPrecioArticulo`](../usp_actualizarPrecioArticulo.md) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idArticulo)` | Llave primaria | Identifica cada artículo de forma única. |
| `CHECK (PrecioUnitario > 0)` | Check | Un precio en cero o negativo no tiene sentido de negocio; el motor rechaza el `INSERT`/`UPDATE` aunque alguien se salte el SP y escriba SQL directo. `usp_insertarArticulo` valida lo mismo antes, con mensaje amigable — el `CHECK` es la última línea de defensa. |
| `UNIQUE (Nombre, Marca)` | Único | No permite registrar el mismo artículo (nombre + marca) dos veces — por ejemplo, dos filas `('Mouse inalámbrico', 'Logitech')`. |
| `DEFAULT 1` en `Activo` | Default | Todo artículo nuevo nace activo. |
| `DEFAULT GETDATE()` en fechas de auditoría | Default | Igual que en `Categoria`: se registra solo cuándo se creó/modificó. |

## SPs relacionados

[`usp_insertarArticulo`](../usp_insertarArticulo.md) · [`usp_eliminarArticulo`](../usp_eliminarArticulo.md) · [`usp_habilitarArticulo`](../usp_habilitarArticulo.md) · [`usp_actualizarArticulo`](../usp_actualizarArticulo.md) · [`usp_actualizarPrecioArticulo`](../usp_actualizarPrecioArticulo.md)
