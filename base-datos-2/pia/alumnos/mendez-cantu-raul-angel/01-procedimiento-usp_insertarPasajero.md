# PIA RutaNorte — Objeto 01 de 11: `usp_insertarPasajero`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_insertarPasajero`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** registrar a un pasajero que llega por primera vez, **para** empezar a registrar sus boletos sin que se repita su registro.

## Contexto

Un pasajero se registra una sola vez. El correo electrónico identifica al pasajero: no puede haber dos pasajeros con el mismo correo electrónico. Cada pasajero tiene un tipo de pasajero; quien lo registra conoce el **nombre** del tipo de pasajero, no su id: el procedimiento lo busca, y solo acepta tipos de pasajero activos. Un pasajero nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarPasajero` que valide las reglas de arriba y, si todo es correcto, registre al pasajero.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoPasajero` | `varchar(50)` | Nombre del tipo de pasajero |
| `@p_Nombre` | `varchar(100)` | Nombre del pasajero |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaRegistro` | `date` | Fecha de registro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de pasajero existe | `000001` | El tipo de pasajero no existe |
| 2 | El tipo de pasajero está activo | `000002` | El tipo de pasajero está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Pasajero registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarPasajero` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de pasajero existe → `000001` *El tipo de pasajero no existe*.
- [ ] Valida: el tipo de pasajero está activo → `000002` *El tipo de pasajero está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los pasajeros dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al pasajero **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Pasajero registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un pasajero nuevo
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000001: el tipo de pasajero 'Otro' no existe
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Otro', @p_Nombre = 'Pasajero Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000002: el tipo de pasajero dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDePasajero> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Adulto'
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
UPDATE <TuTablaDeTiposDePasajero> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Adulto'

-- 000000: ya está activo otra vez
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un pasajero nuevo | `000000` | Pasajero registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El tipo de pasajero 'Otro' no existe | `000001` | El tipo de pasajero no existe |
| El tipo de pasajero dado de baja. Como ningún procedimiento lo da de baja | `000002` | El tipo de pasajero está dado de baja |
| Ya está activo otra vez | `000000` | Pasajero registrado |
