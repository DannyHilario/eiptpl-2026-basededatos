# PIA FitZone — Objeto 01 de 11: `usp_insertarSocio`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_insertarSocio`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** registrar a un socio que llega por primera vez, **para** empezar a registrar sus asistencias sin que se repita su registro.

## Contexto

Un socio se registra una sola vez. El correo electrónico identifica al socio: no puede haber dos socios con el mismo correo electrónico. Cada socio tiene un objetivo; quien lo registra conoce el **nombre** del objetivo, no su id: el procedimiento lo busca, y solo acepta objetivos activos. Un socio nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarSocio` que valide las reglas de arriba y, si todo es correcto, registre al socio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreObjetivo` | `varchar(50)` | Nombre del objetivo |
| `@p_Nombre` | `varchar(100)` | Nombre del socio |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaInscripcion` | `date` | Fecha de inscripción |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El objetivo existe | `000001` | El objetivo no existe |
| 2 | El objetivo está activo | `000002` | El objetivo está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Socio registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarSocio` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el objetivo existe → `000001` *El objetivo no existe*.
- [ ] Valida: el objetivo está activo → `000002` *El objetivo está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los socios dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al socio **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Socio registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un socio nuevo
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-02'

-- 000001: el objetivo 'Otro' no existe
EXEC usp_insertarSocio @p_NombreObjetivo = 'Otro', @p_Nombre = 'Socio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaInscripcion = '2026-11-02'

-- 000002: el objetivo dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeObjetivos> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Bajar de peso'
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaInscripcion = '2026-11-02'
UPDATE <TuTablaDeObjetivos> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Bajar de peso'

-- 000000: ya está activo otra vez
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaInscripcion = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un socio nuevo | `000000` | Socio registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El objetivo 'Otro' no existe | `000001` | El objetivo no existe |
| El objetivo dado de baja. Como ningún procedimiento lo da de baja | `000002` | El objetivo está dado de baja |
| Ya está activo otra vez | `000000` | Socio registrado |
