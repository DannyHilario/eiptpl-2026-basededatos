# `usp_insertarCategoria`

Script: [`instalacion/01-Categoria/03-usp-insertar.sql`](../instalacion/01-Categoria/03-usp-insertar.sql)

Alta de una categoría.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre de la categoría |

## Validaciones

1. No debe existir ya una categoría con el mismo `Nombre` (mismo criterio que el `UNIQUE` de la tabla, pero con mensaje amigable).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La categoría ya está registrada | `Nombre` duplicado |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarCategoria @p_Nombre = 'Impresoras 3D'
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarCategoria @p_Nombre = 'Impresoras 3D'

-- Nombre duplicado (correr el mismo dos veces)
EXEC usp_insertarCategoria @p_Nombre = 'Impresoras 3D'
```
