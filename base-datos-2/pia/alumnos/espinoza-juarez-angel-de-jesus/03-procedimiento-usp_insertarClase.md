# PIA FitZone — Objeto 03 de 11: `usp_insertarClase`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_insertarClase`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** dar de alta una clase nueva, **para** que empiece a acumular asistencias.

## Contexto

Cada clase tiene un nombre de clase que **no se repite** y un **precio por clase** mayor a cero. Además: el cupo máximo debe ser mayor a cero. Una clase nueva siempre se registra **activa**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarClase` que valide las reglas de arriba y, si todo es correcto, registre la clase.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre de la clase |
| `@p_Instructor` | `varchar(100)` | Quién la imparte |
| `@p_CupoMaximo` | `int` | Cupo máximo de personas |
| `@p_PrecioPorClase` | `decimal(10,2)` | Precio por clase |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de clase no existe | `000001` | El nombre de clase ya existe |
| 2 | El cupo máximo es mayor a cero | `000002` | El cupo máximo debe ser mayor a cero |
| 3 | El precio por clase es mayor a cero | `000003` | El precio por clase debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Clase registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarClase` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de clase no existe → `000001` *El nombre de clase ya existe*.
- [ ] Valida: el cupo máximo es mayor a cero → `000002` *El cupo máximo debe ser mayor a cero*.
- [ ] Valida: el precio por clase es mayor a cero → `000003` *El precio por clase debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta la clase **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Clase registrada'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una clase nueva
EXEC usp_insertarClase @p_Nombre = 'Clase de Prueba', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 10, @p_PrecioPorClase = 90.00

-- 000001: 'Spinning' ya existe
EXEC usp_insertarClase @p_Nombre = 'Spinning', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 10, @p_PrecioPorClase = 90.00

-- 000002: CupoMaximo = 0
EXEC usp_insertarClase @p_Nombre = 'Clase de Prueba 2', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 0, @p_PrecioPorClase = 90.00

-- 000003: precio 0
EXEC usp_insertarClase @p_Nombre = 'Clase de Prueba 2', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 10, @p_PrecioPorClase = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una clase nueva | `000000` | Clase registrada |
| 'Spinning' ya existe | `000001` | El nombre de clase ya existe |
| CupoMaximo = 0 | `000002` | El cupo máximo debe ser mayor a cero |
| Precio 0 | `000003` | El precio por clase debe ser mayor a cero |
