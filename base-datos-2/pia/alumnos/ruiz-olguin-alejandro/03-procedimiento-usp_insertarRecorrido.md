# PIA RecorreMTY — Objeto 03 de 11: `usp_insertarRecorrido`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_insertarRecorrido`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** dar de alta un recorrido nuevo, **para** que empiece a acumular reservaciones.

## Contexto

Cada recorrido tiene un nombre de recorrido que **no se repite** y un **precio por persona** mayor a cero. Además: la duración debe ser mayor a cero. Un recorrido nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarRecorrido` que valide las reglas de arriba y, si todo es correcto, registre el recorrido.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre del recorrido |
| `@p_DuracionHoras` | `decimal(3,1)` | Duración, en horas (por ejemplo, 1.5) |
| `@p_PrecioPorPersona` | `decimal(10,2)` | Precio por persona |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de recorrido no existe | `000001` | El nombre de recorrido ya existe |
| 2 | La duración es mayor a cero | `000002` | La duración debe ser mayor a cero |
| 3 | El precio por persona es mayor a cero | `000003` | El precio por persona debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Recorrido registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarRecorrido` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de recorrido no existe → `000001` *El nombre de recorrido ya existe*.
- [ ] Valida: la duración es mayor a cero → `000002` *La duración debe ser mayor a cero*.
- [ ] Valida: el precio por persona es mayor a cero → `000003` *El precio por persona debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta el recorrido **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Recorrido registrado'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un recorrido nuevo
EXEC usp_insertarRecorrido @p_Nombre = 'Recorrido de Prueba', @p_DuracionHoras = 2.5, @p_PrecioPorPersona = 250.00

-- 000001: 'Barrio Antiguo' ya existe
EXEC usp_insertarRecorrido @p_Nombre = 'Barrio Antiguo', @p_DuracionHoras = 2.5, @p_PrecioPorPersona = 250.00

-- 000002: DuracionHoras = 0
EXEC usp_insertarRecorrido @p_Nombre = 'Recorrido de Prueba 2', @p_DuracionHoras = 0, @p_PrecioPorPersona = 250.00

-- 000003: precio 0
EXEC usp_insertarRecorrido @p_Nombre = 'Recorrido de Prueba 2', @p_DuracionHoras = 2.5, @p_PrecioPorPersona = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un recorrido nuevo | `000000` | Recorrido registrado |
| 'Barrio Antiguo' ya existe | `000001` | El nombre de recorrido ya existe |
| DuracionHoras = 0 | `000002` | La duración debe ser mayor a cero |
| Precio 0 | `000003` | El precio por persona debe ser mayor a cero |
