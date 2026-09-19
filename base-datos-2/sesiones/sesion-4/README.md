# Sesión 4 — Validaciones en procedimientos almacenados y manejo de errores

Continúa con **procedimientos almacenados** sobre **CineDB**, retomando el trabajo inconcluso de la Sesión 3 y agregando un patrón de manejo de errores basado en códigos y mensajes de salida.

---

## Qué se hizo en esta sesión

| # | Archivo | Contenido |
|---|---------|-----------|
| 01 | [`01-alter-usp-insertar-pelicula-validacion.sql`](01-alter-usp-insertar-pelicula-validacion.sql) | `ALTER PROCEDURE usp_insertarPelicula` — se completan las validaciones pendientes de Sesión 3 |
| 02 | [`02-alter-usp-eliminar-pelicula.sql`](02-alter-usp-eliminar-pelicula.sql) | `ALTER PROCEDURE usp_eliminarPelicula` — validación de existencia y baja lógica (`Activo = 0`) |

---

## Contexto

Esta sesión reutiliza CineDB tal como quedó instalada en Base de Datos I, más los procedimientos `usp_insertarPelicula` y `usp_eliminarPelicula` creados en clase (no versionados en scripts previos).

## Prerequisito

- Si ya tienes CineDB instalada, solo selecciona **CineDB** en el dropdown de SSMS.
- Si no la tienes, sigue el paquete de instalación en [`../../../base-datos-1/sesiones/sesion-final/CineDB/instalacion`](../../../base-datos-1/sesiones/sesion-final/CineDB/instalacion).

---

## Contenido de estudio — patrón de manejo de errores con códigos de salida

En lugar de usar `TRY CATCH`/`THROW` (que se ve más adelante en el curso), esta sesión valida "a mano" con `IF` y comunica el resultado al llamador mediante dos variables de salida:

```sql
DECLARE @ErrCodigo varchar(10),
        @ErrMensaje varchar(200)

IF Condicion BEGIN
    SELECT @ErrCodigo = '000001',
           @ErrMensaje = 'Descripción del error'

    SELECT @ErrCodigo as ErrCodigo,
           @ErrMensaje as ErrMensaje

    RETURN
END

-- ... si todas las validaciones pasan:

SELECT @ErrCodigo = '000000',
       @ErrMensaje = 'Operación correcta'

SELECT @ErrCodigo as ErrCodigo,
       @ErrMensaje as ErrMensaje
```

- `'000000'` se reserva por convención para "todo salió bien".
- Cada validación fallida tiene su propio código (`'000001'`, `'000002'`, ...) y hace `RETURN` para cortar la ejecución del procedimiento.

### `usp_insertarPelicula` — validaciones agregadas

Retomando el pendiente de la Sesión 3 ([`04-alter-sp-insertar-pelicula-validacion.sql`](../sesion-3/04-alter-sp-insertar-pelicula-validacion.sql)), se completó el procedimiento con las siguientes validaciones, en orden:

1. `idClasificacion` existe en la tabla `Clasificacion` (`'000001'`)
2. `idGenero` existe en la tabla `Genero` (`'000002'`)
3. `Duracion` es un número entero positivo (`'000003'`)
4. `AnioEstreno` está entre 1 y un año máximo definido con `DECLARE`/`SET` (`'000004'`)

Si todas las validaciones pasan, se ejecuta el `INSERT INTO Pelicula` real.

### `usp_eliminarPelicula` — validación y baja lógica

Se valida que el `idPelicula` recibido exista en la tabla `Pelicula` (`'000001'`); si no existe, se corta con `RETURN`. Si existe, en vez de un `DELETE` se hace una **baja lógica**:

```sql
UPDATE Pelicula
SET Activo = 0
WHERE idPelicula = @p_idPelicula
```

Esto evita romper llaves foráneas de otras tablas (por ejemplo `Funcion`) que referencien la película eliminada.

---

## Nota de nomenclatura

En clase estos procedimientos se crearon originalmente con el prefijo `sp_`. En la [Sesión 5-6](../sesion-5-6) se renombraron a `usp_` (tanto en CineDB como en estos scripts) para alinearlos con la convención del repositorio (ver [CLAUDE.md](../../../CLAUDE.md)) — `sp_` queda reservado por SQL Server para procedimientos del sistema.

## Escenarios para seguir practicando

- Agregar a `usp_eliminarPelicula` una validación adicional: no permitir la baja si la película tiene funciones futuras programadas.
- Comparar en la práctica la baja lógica (`UPDATE Activo = 0`) contra un `DELETE` directo cuando existen registros dependientes en `Boleto`/`Funcion`, y documentar qué error arroja SQL Server en ese caso.
