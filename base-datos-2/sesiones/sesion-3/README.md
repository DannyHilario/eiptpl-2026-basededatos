# Sesión 3 — Variables y Procedimientos Almacenados

Introduce **variables T-SQL** (`DECLARE`/`SET`), control de flujo con `IF`/`ELSE`, y **procedimientos almacenados** (`CREATE PROCEDURE`/`ALTER PROCEDURE`), practicando sobre **CineDB**, la base de datos usada en la sesión final de Base de Datos I.

---

## Qué se hizo en esta sesión

| # | Archivo | Contenido |
|---|---------|-----------|
| 01 | [`01-variables-control-flujo.sql`](01-variables-control-flujo.sql) | Declaración de variables, `IF`/`ELSE`, y primer llamado a `usp_obtenerNombreCliente` |
| 02 | [`02-usp-obtener-nombre-cliente.sql`](02-usp-obtener-nombre-cliente.sql) | `CREATE PROCEDURE usp_obtenerNombreCliente` |
| 03 | [`03-consultas-insert-pelicula.sql`](03-consultas-insert-pelicula.sql) | Exploración de `Clasificacion`, `Genero`, `Pelicula`, `Funcion`; `INSERT INTO Pelicula`; primer llamado a `usp_insertarPelicula` |
| 04 | [`04-alter-usp-insertar-pelicula-validacion.sql`](04-alter-usp-insertar-pelicula-validacion.sql) | `ALTER PROCEDURE usp_insertarPelicula` con validación de `idClasificacion` inexistente — **incompleto, se retoma en Sesión 4** |

---

## Contexto

Esta sesión reutiliza dos tablas de catálogo de CineDB (`Clasificacion`, `Genero`) y dos tablas principales (`Pelicula`, `Funcion`), además de `Cliente` para los ejemplos de variables.

## Prerequisito

Esta sesión **reutiliza** CineDB tal como quedó instalada en Base de Datos I.

- Si ya la tienes instalada, solo selecciona **CineDB** en el dropdown de SSMS.
- Si no la tienes, sigue el paquete de instalación en [`../../../base-datos-1/sesiones/sesion-final/CineDB/instalacion`](../../../base-datos-1/sesiones/sesion-final/CineDB/instalacion).

---

## Contenido de estudio — variables T-SQL

### `DECLARE` — declarar una o varias variables

```sql
DECLARE @Variable1 TipoDato,
        @Variable2 TipoDato
```

### `SET` — asignar un valor

```sql
SET @Variable1 = Valor
```

### `IF` / `ELSE` — control de flujo

```sql
IF Condicion BEGIN

	-- instrucciones si se cumple

END
ELSE BEGIN

	-- instrucciones si no se cumple

END
```

---

## Contenido de estudio — procedimientos almacenados

### `CREATE PROCEDURE` — crear un procedimiento

```sql
CREATE PROCEDURE usp_NombreProcedimiento
	@p_Parametro1 TipoDato,
	@p_Parametro2 TipoDato
AS
BEGIN

	-- instrucciones

END
```

- Los parámetros de entrada se identifican con el prefijo `@p_`.
- Se ejecuta con `EXECUTE usp_NombreProcedimiento Valor1, Valor2`.

### `ALTER PROCEDURE` — modificar un procedimiento existente

```sql
ALTER PROCEDURE usp_NombreProcedimiento
	@p_Parametro1 TipoDato
AS
BEGIN

	-- nueva definición completa del procedimiento

END
```

- A diferencia de `CREATE`, `ALTER` reemplaza la definición de un procedimiento que ya existe, sin necesidad de eliminarlo primero (`DROP`).

### Ejemplos trabajados en esta sesión

- **`usp_obtenerNombreCliente`** ([`02-usp-obtener-nombre-cliente.sql`](02-usp-obtener-nombre-cliente.sql)): dado un `idCliente`, devuelve su nombre completo concatenado, o un mensaje si no existe.
- **`usp_insertarPelicula`** ([`04-alter-usp-insertar-pelicula-validacion.sql`](04-alter-usp-insertar-pelicula-validacion.sql)): valida que el `idClasificacion` recibido exista antes de continuar con el resto de la lógica del procedimiento.

> **Trabajo en progreso:** este procedimiento quedó incompleto al cierre de la sesión — solo tiene la validación de `idClasificacion` y termina con un `SELECT 'Se saltó el IF'` de prueba en vez del `INSERT` real. La validación de `idGenero` y el `INSERT INTO Pelicula` final se completan en la [Sesión 4](../sesion-4).

> **Nota de nomenclatura:** en clase estos procedimientos se crearon originalmente con el prefijo `sp_`. En la [Sesión 5-6](../sesion-5-6) se renombraron a `usp_` (tanto en CineDB como en estos scripts) para alinearlos con la convención del repositorio (ver [CLAUDE.md](../../../CLAUDE.md)) — `sp_` queda reservado por SQL Server para procedimientos del sistema.

---

## Pendiente para Sesión 4

- Agregar a `usp_insertarPelicula` la validación de `idGenero` (misma lógica que la de `idClasificacion`).
- Reemplazar el `SELECT 'Se saltó el IF'` de prueba por el `INSERT INTO Pelicula` real, una vez pasadas ambas validaciones.

> Resuelto en la [Sesión 4](../sesion-4), que además agrega validaciones de `Duracion` y `AnioEstreno`, y un procedimiento `usp_eliminarPelicula` con baja lógica.

## Escenarios para seguir practicando

- Hacer que `usp_obtenerNombreCliente` devuelva también el `PrimerApellido` y `SegundoApellido` por separado usando `OUTPUT` parameters.
- Crear un procedimiento `sp_actualizarPrecioFuncion` que reciba `idFuncion` y `NuevoPrecio`, y valide que el precio no sea negativo antes de actualizar.
