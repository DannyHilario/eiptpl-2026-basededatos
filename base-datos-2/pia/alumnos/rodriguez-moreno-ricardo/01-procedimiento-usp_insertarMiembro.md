# PIA EspacioUno — Objeto 01 de 11: `usp_insertarMiembro`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_insertarMiembro`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** registrar a un miembro que llega por primera vez, **para** empezar a registrar sus reservas sin que se repita su registro.

## Contexto

Un miembro se registra una sola vez. El correo electrónico identifica al miembro: no puede haber dos miembros con el mismo correo electrónico. Un miembro nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarMiembro` que valide las reglas de arriba y, si todo es correcto, registre al miembro.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(100)` | Nombre del miembro |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_Empresa` | `varchar(60)` | Empresa en la que trabaja |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El correo electrónico no está registrado | `000001` | El correo electrónico ya está registrado |
| 2 | Todo correcto | `000000` | Miembro registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarMiembro` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el correo electrónico no está registrado → `000001` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los miembros dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al miembro **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Miembro registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un miembro nuevo
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'

-- 000001: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarMiembro @p_Nombre = 'Miembro Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Independiente'

-- 000000: otro miembro
EXEC usp_insertarMiembro @p_Nombre = 'Miembro Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_Empresa = 'Independiente'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un miembro nuevo | `000000` | Miembro registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000001` | El correo electrónico ya está registrado |
| Otro miembro | `000000` | Miembro registrado |
