# PIA SpaZen — Objeto 03 de 11: `usp_insertarServicio`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Procedimiento almacenado `usp_insertarServicio`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** dar de alta un servicio nuevo, **para** que empiece a acumular citas.

## Contexto

Cada servicio tiene un nombre de servicio que **no se repite** y un **precio** mayor a cero. Además: la duración debe ser mayor a cero. Un servicio nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarServicio` que valide las reglas de arriba y, si todo es correcto, registre el servicio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre del servicio |
| `@p_DuracionMinutos` | `int` | Duración, en minutos |
| `@p_Precio` | `decimal(10,2)` | Precio |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de servicio no existe | `000001` | El nombre de servicio ya existe |
| 2 | La duración es mayor a cero | `000002` | La duración debe ser mayor a cero |
| 3 | El precio es mayor a cero | `000003` | El precio debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Servicio registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarServicio` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de servicio no existe → `000001` *El nombre de servicio ya existe*.
- [ ] Valida: la duración es mayor a cero → `000002` *La duración debe ser mayor a cero*.
- [ ] Valida: el precio es mayor a cero → `000003` *El precio debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta el servicio **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Servicio registrado'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un servicio nuevo
EXEC usp_insertarServicio @p_Nombre = 'Servicio de Prueba', @p_DuracionMinutos = 30, @p_Precio = 750.00

-- 000001: 'Masaje relajante' ya existe
EXEC usp_insertarServicio @p_Nombre = 'Masaje relajante', @p_DuracionMinutos = 30, @p_Precio = 750.00

-- 000002: DuracionMinutos = 0
EXEC usp_insertarServicio @p_Nombre = 'Servicio de Prueba 2', @p_DuracionMinutos = 0, @p_Precio = 750.00

-- 000003: precio 0
EXEC usp_insertarServicio @p_Nombre = 'Servicio de Prueba 2', @p_DuracionMinutos = 30, @p_Precio = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un servicio nuevo | `000000` | Servicio registrado |
| 'Masaje relajante' ya existe | `000001` | El nombre de servicio ya existe |
| DuracionMinutos = 0 | `000002` | La duración debe ser mayor a cero |
| Precio 0 | `000003` | El precio debe ser mayor a cero |
