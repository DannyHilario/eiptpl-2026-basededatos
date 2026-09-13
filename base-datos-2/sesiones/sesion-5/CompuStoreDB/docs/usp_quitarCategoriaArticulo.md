# `usp_quitarCategoriaArticulo`

Script: [`instalacion/03-ArticuloCategoria/04-usp-quitar.sql`](../instalacion/03-ArticuloCategoria/04-usp-quitar.sql)

Quita la asignación de una categoría a un artículo (`DELETE` físico del renglón en `ArticuloCategoria`). No hay baja lógica aquí — la tabla puente no tiene columna `Activo`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_idCategoria` | `int` | Id de la categoría a quitar |

## Validaciones

1. Esa combinación artículo-categoría debe existir actualmente.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no está asignado a esa categoría | La relación no existe |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_quitarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3
```

## Casos de prueba sugeridos

```sql
-- Preparar: asignar primero
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3

-- Éxito
EXEC usp_quitarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3

-- La relación ya no existe (correrlo dos veces seguidas)
EXEC usp_quitarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3
```
