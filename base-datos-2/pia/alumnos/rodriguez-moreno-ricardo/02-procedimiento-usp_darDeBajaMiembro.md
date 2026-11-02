# PIA EspacioUno — Objeto 02 de 11: `usp_darDeBajaMiembro`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaMiembro`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** dar de baja al miembro que ya no regresa, **para** que ya no se le registren reservas sin perder su historial.

## Contexto

En EspacioUno un miembro **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaMiembro` que valide las reglas de abajo y, si todo es correcto, marque al miembro como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoMiembro` | `varchar(100)` | Correo electrónico del miembro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El miembro existe | `000001` | El miembro no existe |
| 2 | El miembro está activo | `000002` | El miembro ya está dado de baja |
| 3 | Todo correcto | `000000` | Miembro dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaMiembro` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el miembro existe → `000001` *El miembro no existe*.
- [ ] Valida: el miembro está activo → `000002` *El miembro ya está dado de baja*.
- [ ] Si todo es correcto, marca al miembro como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Miembro dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del miembro y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md).

```sql
-- Preparación: el miembro de prueba
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'

-- 000001: no existe un miembro con ese correo electrónico
EXEC usp_darDeBajaMiembro @p_CorreoMiembro = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaMiembro @p_CorreoMiembro = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaMiembro @p_CorreoMiembro = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El miembro de prueba | `000000` | Miembro registrado |
| No existe un miembro con ese correo electrónico | `000001` | El miembro no existe |
| Se da de baja | `000000` | Miembro dado de baja |
| Ya estaba dado de baja | `000002` | El miembro ya está dado de baja |
