# PIA CampoVerde — Objeto 01 de 11: `usp_insertarCampista`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_insertarCampista`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** registrar a un campista que llega por primera vez, **para** empezar a registrar sus rentas sin que se repita su registro.

## Contexto

Un campista se registra una sola vez. El teléfono identifica al campista: no puede haber dos campistas con el mismo teléfono. Un campista nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarCampista` que valide las reglas de arriba y, si todo es correcto, registre al campista.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(100)` | Nombre del campista |
| `@p_Telefono` | `varchar(15)` | Teléfono |
| `@p_Ciudad` | `varchar(50)` | Ciudad de origen |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El teléfono no está registrado | `000001` | El teléfono ya está registrado |
| 2 | Todo correcto | `000000` | Campista registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarCampista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el teléfono no está registrado → `000001` *El teléfono ya está registrado*.
- [ ] Cuenta también a los campistas dados de baja: su teléfono sigue siendo suyo.
- [ ] Si todo es correcto, inserta al campista **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Campista registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un campista nuevo
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'

-- 000001: el teléfono '8199990001' ya está registrado
EXEC usp_insertarCampista @p_Nombre = 'Campista Dos', @p_Telefono = '8199990001', @p_Ciudad = 'Saltillo'

-- 000000: otro campista
EXEC usp_insertarCampista @p_Nombre = 'Campista Dos', @p_Telefono = '8199990002', @p_Ciudad = 'Saltillo'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un campista nuevo | `000000` | Campista registrado |
| El teléfono '8199990001' ya está registrado | `000001` | El teléfono ya está registrado |
| Otro campista | `000000` | Campista registrado |
