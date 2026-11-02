# PIA QuintaSol — Objeto 03 de 11: `usp_insertarQuinta`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Procedimiento almacenado `usp_insertarQuinta`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** dar de alta una quinta nueva, **para** que empiece a acumular eventos.

## Contexto

Cada quinta es de **un solo** tipo de quinta y tiene un nombre de quinta que **no se repite**. Solo se dan de alta quintas de un tipo de quinta que el negocio **sigue manejando**. Una quinta nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de quinta, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarQuinta` que valide las reglas de arriba y, si todo es correcto, registre la quinta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoQuinta` | `varchar(30)` | Nombre del tipo de quinta |
| `@p_NombreQuinta` | `varchar(50)` | Nombre de quinta |
| `@p_FechaApertura` | `date` | Fecha de apertura |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de quinta existe | `000001` | El tipo de quinta no existe |
| 2 | El tipo de quinta está activo | `000002` | El tipo de quinta está dado de baja |
| 3 | El nombre de quinta no existe | `000003` | El nombre de quinta ya existe |
| 4 | Todo correcto | `000000` | Quinta registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarQuinta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de quinta existe → `000001` *El tipo de quinta no existe*.
- [ ] Valida: el tipo de quinta está activo → `000002` *El tipo de quinta está dado de baja*.
- [ ] Valida: el nombre de quinta no existe → `000003` *El nombre de quinta ya existe*.
- [ ] El nombre de quinta de una quinta dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la quinta con el id del tipo de quinta que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Quinta registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de quinta y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una quinta nueva
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Mediana', @p_NombreQuinta = 'Quinta Prueba', @p_FechaApertura = '2026-11-01'

-- 000001: el tipo de quinta 'Otro' no existe
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Otro', @p_NombreQuinta = 'Quinta Prueba', @p_FechaApertura = '2026-11-01'

-- 000003: 'Los Nogales' ya existe
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Mediana', @p_NombreQuinta = 'Los Nogales', @p_FechaApertura = '2026-11-01'

-- 000003: 'Los Álamos' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Mediana', @p_NombreQuinta = 'Los Álamos', @p_FechaApertura = '2026-11-01'

-- 000002: el tipo de quinta dado de baja. Como ningún procedimiento da de baja los tipos de quinta,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeQuinta> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Grande'
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Grande', @p_NombreQuinta = 'Quinta PruebaB', @p_FechaApertura = '2026-11-01'
UPDATE <TuTablaDeTiposDeQuinta> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Grande'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una quinta nueva | `000000` | Quinta registrada |
| El tipo de quinta 'Otro' no existe | `000001` | El tipo de quinta no existe |
| 'Los Nogales' ya existe | `000003` | El nombre de quinta ya existe |
| 'Los Álamos' está dada de baja, pero sigue siendo suyo | `000003` | El nombre de quinta ya existe |
| El tipo de quinta dado de baja. Como ningún procedimiento da de baja los tipos de quinta | `000002` | El tipo de quinta está dado de baja |
