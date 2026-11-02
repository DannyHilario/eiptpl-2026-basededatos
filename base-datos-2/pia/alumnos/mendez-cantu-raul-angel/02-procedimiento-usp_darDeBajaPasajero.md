# PIA RutaNorte — Objeto 02 de 11: `usp_darDeBajaPasajero`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaPasajero`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** dar de baja al pasajero que ya no regresa, **para** que ya no se le registren boletos sin perder su historial.

## Contexto

En RutaNorte un pasajero **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaPasajero` que valide las reglas de abajo y, si todo es correcto, marque al pasajero como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoPasajero` | `varchar(100)` | Correo electrónico del pasajero |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El pasajero existe | `000001` | El pasajero no existe |
| 2 | El pasajero está activo | `000002` | El pasajero ya está dado de baja |
| 3 | Todo correcto | `000000` | Pasajero dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaPasajero` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el pasajero existe → `000001` *El pasajero no existe*.
- [ ] Valida: el pasajero está activo → `000002` *El pasajero ya está dado de baja*.
- [ ] Si todo es correcto, marca al pasajero como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Pasajero dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del pasajero y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md).

```sql
-- Preparación: el pasajero de prueba
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000001: no existe un pasajero con ese correo electrónico
EXEC usp_darDeBajaPasajero @p_CorreoPasajero = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaPasajero @p_CorreoPasajero = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaPasajero @p_CorreoPasajero = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El pasajero de prueba | `000000` | Pasajero registrado |
| No existe un pasajero con ese correo electrónico | `000001` | El pasajero no existe |
| Se da de baja | `000000` | Pasajero dado de baja |
| Ya estaba dado de baja | `000002` | El pasajero ya está dado de baja |
