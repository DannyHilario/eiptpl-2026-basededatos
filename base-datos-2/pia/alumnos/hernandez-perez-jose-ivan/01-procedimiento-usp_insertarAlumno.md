# PIA AsesorPro — Objeto 01 de 11: `usp_insertarAlumno`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_insertarAlumno`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** registrar a un alumno que llega por primera vez, **para** empezar a registrar sus asesorías sin que se repita su registro.

## Contexto

Un alumno se registra una sola vez. El correo electrónico identifica al alumno: no puede haber dos alumnos con el mismo correo electrónico. Cada alumno tiene un nivel escolar; quien lo registra conoce el **nombre** del nivel escolar, no su id: el procedimiento lo busca, y solo acepta niveles escolares activos. Un alumno nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarAlumno` que valide las reglas de arriba y, si todo es correcto, registre al alumno.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreNivelEscolar` | `varchar(50)` | Nombre del nivel escolar |
| `@p_Nombre` | `varchar(100)` | Nombre del alumno |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaRegistro` | `date` | Fecha de registro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nivel escolar existe | `000001` | El nivel escolar no existe |
| 2 | El nivel escolar está activo | `000002` | El nivel escolar está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Alumno registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarAlumno` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nivel escolar existe → `000001` *El nivel escolar no existe*.
- [ ] Valida: el nivel escolar está activo → `000002` *El nivel escolar está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los alumnos dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al alumno **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Alumno registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un alumno nuevo
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000001: el nivel escolar 'Otro' no existe
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Otro', @p_Nombre = 'Alumno Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000002: el nivel escolar dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeNivelesEscolares> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Secundaria'
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
UPDATE <TuTablaDeNivelesEscolares> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Secundaria'

-- 000000: ya está activo otra vez
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un alumno nuevo | `000000` | Alumno registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El nivel escolar 'Otro' no existe | `000001` | El nivel escolar no existe |
| El nivel escolar dado de baja. Como ningún procedimiento lo da de baja | `000002` | El nivel escolar está dado de baja |
| Ya está activo otra vez | `000000` | Alumno registrado |
