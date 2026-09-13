# `usp_insertarArticulo`

Script: [`instalacion/02-Articulo/03-usp-insertar.sql`](../instalacion/02-Articulo/03-usp-insertar.sql)

Alta de un artículo.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(100)` | Nombre del artículo |
| `@p_Marca` | `varchar(50)` | Marca del artículo |
| `@p_PrecioUnitario` | `decimal(10,2)` | Precio de lista inicial |

## Validaciones (orden en que se evalúan)

1. `PrecioUnitario` debe ser mayor a cero.
2. No debe existir ya un artículo con el mismo `Nombre` y `Marca` (mismo criterio que el `UNIQUE (Nombre, Marca)` de la tabla, pero con mensaje amigable).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El precio unitario debe ser mayor a cero | `PrecioUnitario <= 0` |
| `000002` | El artículo ya está registrado con esa marca | `Nombre`+`Marca` duplicado |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarArticulo @p_Nombre = 'Mouse inalámbrico', @p_Marca = 'Logitech', @p_PrecioUnitario = 350.00
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarArticulo @p_Nombre = 'Mouse inalámbrico', @p_Marca = 'Logitech', @p_PrecioUnitario = 350.00

-- Precio inválido
EXEC usp_insertarArticulo @p_Nombre = 'Teclado mecánico', @p_Marca = 'Logitech', @p_PrecioUnitario = 0

-- Nombre+Marca duplicado (correr el primero dos veces)
EXEC usp_insertarArticulo @p_Nombre = 'Mouse inalámbrico', @p_Marca = 'Logitech', @p_PrecioUnitario = 400.00
```
