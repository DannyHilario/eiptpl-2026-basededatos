# PIA GameZone — Objeto 03 de 11: `usp_insertarEstacion`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_insertarEstacion`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** dar de alta una estación nueva, **para** que empiece a acumular sesiones.

## Contexto

Cada estación es de **un solo** tipo de consola y tiene un número de estación que **no se repite**. Solo se dan de alta estaciones de un tipo de consola que el negocio **sigue manejando**. Una estación nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de consola, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarEstacion` que valide las reglas de arriba y, si todo es correcto, registre la estación.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoConsola` | `varchar(30)` | Nombre del tipo de consola |
| `@p_NumeroEstacion` | `varchar(10)` | Número de estación |
| `@p_FechaInstalacion` | `date` | Fecha de instalación |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de consola existe | `000001` | El tipo de consola no existe |
| 2 | El tipo de consola está activo | `000002` | El tipo de consola está dado de baja |
| 3 | El número de estación no existe | `000003` | El número de estación ya existe |
| 4 | Todo correcto | `000000` | Estación registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarEstacion` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de consola existe → `000001` *El tipo de consola no existe*.
- [ ] Valida: el tipo de consola está activo → `000002` *El tipo de consola está dado de baja*.
- [ ] Valida: el número de estación no existe → `000003` *El número de estación ya existe*.
- [ ] El número de estación de una estación dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la estación con el id del tipo de consola que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Estación registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de consola y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una estación nueva
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Xbox Series X', @p_NumeroEstacion = 'E-20', @p_FechaInstalacion = '2026-11-01'

-- 000001: el tipo de consola 'Otro' no existe
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Otro', @p_NumeroEstacion = 'E-20', @p_FechaInstalacion = '2026-11-01'

-- 000003: 'E-01' ya existe
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Xbox Series X', @p_NumeroEstacion = 'E-01', @p_FechaInstalacion = '2026-11-01'

-- 000003: 'E-10' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Xbox Series X', @p_NumeroEstacion = 'E-10', @p_FechaInstalacion = '2026-11-01'

-- 000002: el tipo de consola dado de baja. Como ningún procedimiento da de baja los tipos de consola,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeConsola> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Nintendo Switch'
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Nintendo Switch', @p_NumeroEstacion = 'E-20B', @p_FechaInstalacion = '2026-11-01'
UPDATE <TuTablaDeTiposDeConsola> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Nintendo Switch'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una estación nueva | `000000` | Estación registrada |
| El tipo de consola 'Otro' no existe | `000001` | El tipo de consola no existe |
| 'E-01' ya existe | `000003` | El número de estación ya existe |
| 'E-10' está dada de baja, pero sigue siendo suyo | `000003` | El número de estación ya existe |
| El tipo de consola dado de baja. Como ningún procedimiento da de baja los tipos de consola | `000002` | El tipo de consola está dado de baja |
