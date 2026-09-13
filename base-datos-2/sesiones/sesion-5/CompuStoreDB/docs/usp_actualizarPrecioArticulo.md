# `usp_actualizarPrecioArticulo`

Script: [`instalacion/02-Articulo/06-usp-actualizar-precio.sql`](../instalacion/02-Articulo/06-usp-actualizar-precio.sql)

**Este es el SP que debe usarse para cambiar el precio de un artículo.** Deja el registro en el histórico y actualiza el precio vigente en una sola llamada.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio nuevo |

## Validaciones (orden en que se evalúan)

1. El artículo debe existir.
2. `PrecioNuevo` debe ser mayor a cero.
3. `PrecioNuevo` debe ser diferente al precio actual.

Son las mismas validaciones que [`usp_insertarHistoricoPrecioArticulo`](usp_insertarHistoricoPrecioArticulo.md) — se repiten aquí porque este SP no captura el resultado del `EXEC` interno (el curso todavía no cubre `OUTPUT` params ni `INSERT ... EXEC`), así que no puede confiar ciegamente en que la inserción del histórico tuvo éxito sin validar por su cuenta antes de continuar.

## Qué hace, en orden

1. Corre las 3 validaciones de arriba (con `RETURN` si alguna falla).
2. `EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo, @p_PrecioNuevo` — registra el cambio.
3. `UPDATE Articulo SET PrecioUnitario = @p_PrecioNuevo, FechaUltimaModificacion = GETDATE()` — aplica el precio nuevo.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000002` | El precio nuevo debe ser mayor a cero | `PrecioNuevo <= 0` |
| `000003` | El precio nuevo debe ser diferente al precio anterior | `PrecioNuevo` = precio actual |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 400.00
```

## Casos de prueba sugeridos

```sql
-- Éxito: verificar que quedó en Articulo Y en HistoricoPrecioArticulo
EXEC usp_actualizarPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 400.00
SELECT PrecioUnitario FROM Articulo WHERE idArticulo = 1
SELECT * FROM HistoricoPrecioArticulo WHERE idArticulo = 1

-- Artículo no existe
EXEC usp_actualizarPrecioArticulo @p_idArticulo = 9999, @p_PrecioNuevo = 400.00

-- Precio inválido
EXEC usp_actualizarPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 0

-- Precio igual al actual (correr el primero dos veces seguidas con el mismo valor)
EXEC usp_actualizarPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 400.00
```

## Instalación

Depende de que [`usp_insertarHistoricoPrecioArticulo`](usp_insertarHistoricoPrecioArticulo.md) ya exista **al momento de ejecutarse**, aunque no al crearse: SQL Server resuelve nombres de objetos referenciados dentro de un procedimiento hasta que se invoca (deferred name resolution), no cuando se hace el `CREATE PROCEDURE`. Por eso el paquete de instalación puede crear este SP (carpeta `02-Articulo`) antes que el de histórico (carpeta `04-HistoricoPrecioArticulo`) sin error — solo importa que ambos existan antes del primer `EXEC usp_actualizarPrecioArticulo`.
