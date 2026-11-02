# PIA EspacioUno — Objeto 03 de 11: `usp_insertarEspacio`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_insertarEspacio`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** dar de alta un espacio nuevo, **para** que empiece a acumular reservas.

## Contexto

Cada espacio es de **un solo** tipo de espacio y tiene un nombre de espacio que **no se repite**. Solo se dan de alta espacios de un tipo de espacio que el negocio **sigue manejando**. Un espacio nuevo siempre se registra **activo**.

Quien registra conoce el **nombre** del tipo de espacio, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarEspacio` que valide las reglas de arriba y, si todo es correcto, registre el espacio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoEspacio` | `varchar(30)` | Nombre del tipo de espacio |
| `@p_NombreEspacio` | `varchar(50)` | Nombre de espacio |
| `@p_FechaApertura` | `date` | Fecha de apertura |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de espacio existe | `000001` | El tipo de espacio no existe |
| 2 | El tipo de espacio está activo | `000002` | El tipo de espacio está dado de baja |
| 3 | El nombre de espacio no existe | `000003` | El nombre de espacio ya existe |
| 4 | Todo correcto | `000000` | Espacio registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarEspacio` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de espacio existe → `000001` *El tipo de espacio no existe*.
- [ ] Valida: el tipo de espacio está activo → `000002` *El tipo de espacio está dado de baja*.
- [ ] Valida: el nombre de espacio no existe → `000003` *El nombre de espacio ya existe*.
- [ ] El nombre de espacio de un espacio dado de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta el espacio con el id del tipo de espacio que encontró, **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Espacio registrado'`.

**Sugerencia** (no se califica): Obtén el id del tipo de espacio y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un espacio nuevo
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Oficina privada', @p_NombreEspacio = 'Escritorio Prueba', @p_FechaApertura = '2026-11-01'

-- 000001: el tipo de espacio 'Otro' no existe
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Otro', @p_NombreEspacio = 'Escritorio Prueba', @p_FechaApertura = '2026-11-01'

-- 000003: 'Escritorio Ventana' ya existe
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Oficina privada', @p_NombreEspacio = 'Escritorio Ventana', @p_FechaApertura = '2026-11-01'

-- 000003: 'Oficina Mitras' está dado de baja, pero sigue siendo suyo
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Oficina privada', @p_NombreEspacio = 'Oficina Mitras', @p_FechaApertura = '2026-11-01'

-- 000002: el tipo de espacio dado de baja. Como ningún procedimiento da de baja los tipos de espacio,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeEspacio> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Sala de juntas'
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Sala de juntas', @p_NombreEspacio = 'Escritorio PruebaB', @p_FechaApertura = '2026-11-01'
UPDATE <TuTablaDeTiposDeEspacio> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Sala de juntas'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un espacio nuevo | `000000` | Espacio registrado |
| El tipo de espacio 'Otro' no existe | `000001` | El tipo de espacio no existe |
| 'Escritorio Ventana' ya existe | `000003` | El nombre de espacio ya existe |
| 'Oficina Mitras' está dado de baja, pero sigue siendo suyo | `000003` | El nombre de espacio ya existe |
| El tipo de espacio dado de baja. Como ningún procedimiento da de baja los tipos de espacio | `000002` | El tipo de espacio está dado de baja |
