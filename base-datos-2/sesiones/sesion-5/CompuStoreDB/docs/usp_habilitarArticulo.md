# `usp_habilitarArticulo`

Script: [`instalacion/02-Articulo/05-usp-habilitar.sql`](../instalacion/02-Articulo/05-usp-habilitar.sql)

Reactiva (`Activo = 1`) un artículo que había sido dado de baja con `usp_eliminarArticulo`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo a reactivar |

## Validaciones

1. El artículo debe existir.
2. El artículo debe estar actualmente dado de baja (`Activo = 0`).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000002` | El artículo ya está activo | Ya estaba `Activo = 1` |
| `000000` | Habilitación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_habilitarArticulo @p_idArticulo = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar: dar de baja primero
EXEC usp_eliminarArticulo @p_idArticulo = 1

-- Éxito
EXEC usp_habilitarArticulo @p_idArticulo = 1

-- Ya está activo (correrlo dos veces seguidas)
EXEC usp_habilitarArticulo @p_idArticulo = 1

-- Artículo no existe
EXEC usp_habilitarArticulo @p_idArticulo = 9999
```
