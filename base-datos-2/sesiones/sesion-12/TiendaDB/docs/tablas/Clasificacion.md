# Tabla `Clasificacion`

Scripts: [`instalacion/03-Clasificacion/`](../../instalacion/03-Clasificacion)

Catálogo de clasificaciones de los artículos: Bebidas, Botanas, Dulces y chocolates, Lácteos, Panadería, Abarrotes, Limpieza del hogar e Higiene personal.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idClasificacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre de la clasificación |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = dada de baja |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idClasificacion)` | Llave primaria | Identifica cada registro. |
| `UNIQUE (Nombre)` | Único | No puede repetirse entre registros. |
| `DEFAULT 1` en `Activo` | Default | Todo registro nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |

## Relacionada con

- [`Articulo`](Articulo.md) — la referencia por `idClasificacion` (1:N).
