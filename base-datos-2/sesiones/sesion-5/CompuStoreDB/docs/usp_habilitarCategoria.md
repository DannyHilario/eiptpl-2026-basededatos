# `usp_habilitarCategoria`

Script: [`instalacion/01-Categoria/05-usp-habilitar.sql`](../instalacion/01-Categoria/05-usp-habilitar.sql)

Reactiva (`Activo = 1`) una categoría que había sido dada de baja con `usp_eliminarCategoria`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCategoria` | `int` | Id de la categoría a reactivar |

## Validaciones

1. La categoría debe existir.
2. La categoría debe estar actualmente dada de baja (`Activo = 0`).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La categoría no existe | `idCategoria` inválido |
| `000002` | La categoría ya está activa | Ya estaba `Activo = 1` |
| `000000` | Habilitación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_habilitarCategoria @p_idCategoria = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar: dar de baja primero
EXEC usp_eliminarCategoria @p_idCategoria = 1

-- Éxito
EXEC usp_habilitarCategoria @p_idCategoria = 1

-- Ya está activa (correrlo dos veces seguidas)
EXEC usp_habilitarCategoria @p_idCategoria = 1

-- Categoría no existe
EXEC usp_habilitarCategoria @p_idCategoria = 9999
```
