# PIA SalaRock — Objeto 03 de 11: `usp_insertarSala`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_insertarSala`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** dar de alta una sala nueva, **para** que empiece a acumular ensayos.

## Contexto

Cada sala es de **un solo** tipo de sala y tiene un nombre de sala que **no se repite**. Solo se dan de alta salas de un tipo de sala que el negocio **sigue manejando**. Una sala nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de sala, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarSala` que valide las reglas de arriba y, si todo es correcto, registre la sala.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoSala` | `varchar(30)` | Nombre del tipo de sala |
| `@p_NombreSala` | `varchar(50)` | Nombre de sala |
| `@p_FechaApertura` | `date` | Fecha de apertura |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de sala existe | `000001` | El tipo de sala no existe |
| 2 | El tipo de sala está activo | `000002` | El tipo de sala está dado de baja |
| 3 | El nombre de sala no existe | `000003` | El nombre de sala ya existe |
| 4 | Todo correcto | `000000` | Sala registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarSala` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de sala existe → `000001` *El tipo de sala no existe*.
- [ ] Valida: el tipo de sala está activo → `000002` *El tipo de sala está dado de baja*.
- [ ] Valida: el nombre de sala no existe → `000003` *El nombre de sala ya existe*.
- [ ] El nombre de sala de una sala dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la sala con el id del tipo de sala que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sala registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de sala y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una sala nueva
EXEC usp_insertarSala @p_NombreTipoSala = 'Mediana', @p_NombreSala = 'Sala Prueba', @p_FechaApertura = '2026-11-01'

-- 000001: el tipo de sala 'Otro' no existe
EXEC usp_insertarSala @p_NombreTipoSala = 'Otro', @p_NombreSala = 'Sala Prueba', @p_FechaApertura = '2026-11-01'

-- 000003: 'Sala Hendrix' ya existe
EXEC usp_insertarSala @p_NombreTipoSala = 'Mediana', @p_NombreSala = 'Sala Hendrix', @p_FechaApertura = '2026-11-01'

-- 000003: 'Sala Bowie' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarSala @p_NombreTipoSala = 'Mediana', @p_NombreSala = 'Sala Bowie', @p_FechaApertura = '2026-11-01'

-- 000002: el tipo de sala dado de baja. Como ningún procedimiento da de baja los tipos de sala,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeSala> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Grande'
EXEC usp_insertarSala @p_NombreTipoSala = 'Grande', @p_NombreSala = 'Sala PruebaB', @p_FechaApertura = '2026-11-01'
UPDATE <TuTablaDeTiposDeSala> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Grande'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una sala nueva | `000000` | Sala registrada |
| El tipo de sala 'Otro' no existe | `000001` | El tipo de sala no existe |
| 'Sala Hendrix' ya existe | `000003` | El nombre de sala ya existe |
| 'Sala Bowie' está dada de baja, pero sigue siendo suyo | `000003` | El nombre de sala ya existe |
| El tipo de sala dado de baja. Como ningún procedimiento da de baja los tipos de sala | `000002` | El tipo de sala está dado de baja |
