# `usp_insertarHistoricoPrecioArticulo`

Script: [`instalacion/04-HistoricoPrecioArticulo/02-usp-insertar.sql`](../instalacion/04-HistoricoPrecioArticulo/02-usp-insertar.sql)

> **No lo ejecutes directamente para cambiar un precio.** Este SP solo inserta el renglón de histórico; no actualiza `Articulo.PrecioUnitario`. Para cambiar el precio de un artículo usa [`usp_actualizarPrecioArticulo`](usp_actualizarPrecioArticulo.md), que sí llama a este SP internamente **y** actualiza el precio vigente.

Registra un cambio de precio de un artículo en `HistoricoPrecioArticulo`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio nuevo propuesto |

`PrecioAnterior` no se recibe como parámetro: el SP lo lee internamente de `Articulo.PrecioUnitario` en el momento de la ejecución.

## Validaciones (orden en que se evalúan)

1. El artículo debe existir.
2. `PrecioNuevo` debe ser mayor a cero.
3. `PrecioNuevo` debe ser diferente al precio actual (`Articulo.PrecioUnitario`) — coincide con el `CHECK chk_HistoricoPrecioArticulo_Cambio` de la tabla: no tiene sentido registrar un "cambio" que no cambió nada.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000002` | El precio nuevo debe ser mayor a cero | `PrecioNuevo <= 0` |
| `000003` | El precio nuevo debe ser diferente al precio anterior | `PrecioNuevo` = precio actual |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 400.00
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 400.00

-- Artículo no existe
EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo = 9999, @p_PrecioNuevo = 400.00

-- Precio inválido
EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = 0

-- Precio igual al actual (usa el PrecioUnitario vigente del artículo)
DECLARE @PrecioActual decimal(10,2) = (SELECT PrecioUnitario FROM Articulo WHERE idArticulo = 1)
EXEC usp_insertarHistoricoPrecioArticulo @p_idArticulo = 1, @p_PrecioNuevo = @PrecioActual
```
