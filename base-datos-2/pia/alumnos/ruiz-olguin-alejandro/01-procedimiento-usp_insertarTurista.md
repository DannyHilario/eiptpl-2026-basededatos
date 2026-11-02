# PIA RecorreMTY — Objeto 01 de 11: `usp_insertarTurista`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_insertarTurista`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** registrar a un turista que llega por primera vez, **para** empezar a registrar sus reservaciones sin que se repita su registro.

## Contexto

Un turista se registra una sola vez. El correo electrónico identifica al turista: no puede haber dos turistas con el mismo correo electrónico. Cada turista tiene un país; quien lo registra conoce el **nombre** del país, no su id: el procedimiento lo busca, y solo acepta países activos. Un turista nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarTurista` que valide las reglas de arriba y, si todo es correcto, registre al turista.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombrePais` | `varchar(50)` | Nombre del país |
| `@p_Nombre` | `varchar(100)` | Nombre del turista |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaRegistro` | `date` | Fecha de registro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El país existe | `000001` | El país no existe |
| 2 | El país está activo | `000002` | El país está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Turista registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarTurista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el país existe → `000001` *El país no existe*.
- [ ] Valida: el país está activo → `000002` *El país está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los turistas dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al turista **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Turista registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un turista nuevo
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000001: el país 'Otro' no existe
EXEC usp_insertarTurista @p_NombrePais = 'Otro', @p_Nombre = 'Turista Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000002: el país dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDePaíses> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'México'
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
UPDATE <TuTablaDePaíses> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'México'

-- 000000: ya está activo otra vez
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un turista nuevo | `000000` | Turista registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El país 'Otro' no existe | `000001` | El país no existe |
| El país dado de baja. Como ningún procedimiento lo da de baja | `000002` | El país está dado de baja |
| Ya está activo otra vez | `000000` | Turista registrado |
