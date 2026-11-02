# PIA EnigmaRoom — Objeto 03 de 11: `usp_insertarSalaEscape`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Procedimiento almacenado `usp_insertarSalaEscape`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** dar de alta una sala de escape nueva, **para** que empiece a acumular partidas.

## Contexto

Cada sala de escape tiene un nombre de sala que **no se repite** y un **precio por partida** mayor a cero. Además: la dificultad debe estar entre 1 y 5. Una sala de escape nueva siempre se registra **activa**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarSalaEscape` que valide las reglas de arriba y, si todo es correcto, registre la sala de escape.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre de la sala |
| `@p_Tema` | `varchar(30)` | Tema de la sala |
| `@p_Dificultad` | `int` | Dificultad, del 1 al 5 |
| `@p_Precio` | `decimal(10,2)` | Precio por partida |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de sala no existe | `000001` | El nombre de sala ya existe |
| 2 | La dificultad está entre 1 y 5 | `000002` | La dificultad debe estar entre 1 y 5 |
| 3 | El precio por partida es mayor a cero | `000003` | El precio por partida debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Sala de escape registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarSalaEscape` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de sala no existe → `000001` *El nombre de sala ya existe*.
- [ ] Valida: la dificultad está entre 1 y 5 → `000002` *La dificultad debe estar entre 1 y 5*.
- [ ] Valida: el precio por partida es mayor a cero → `000003` *El precio por partida debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta la sala de escape **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sala de escape registrada'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una sala de escape nueva
EXEC usp_insertarSalaEscape @p_Nombre = 'Sala de Prueba', @p_Tema = 'Piratas', @p_Dificultad = 2, @p_Precio = 900.00

-- 000001: 'El Laboratorio' ya existe
EXEC usp_insertarSalaEscape @p_Nombre = 'El Laboratorio', @p_Tema = 'Piratas', @p_Dificultad = 2, @p_Precio = 900.00

-- 000002: Dificultad = 6
EXEC usp_insertarSalaEscape @p_Nombre = 'Sala de Prueba 2', @p_Tema = 'Piratas', @p_Dificultad = 6, @p_Precio = 900.00

-- 000003: precio 0
EXEC usp_insertarSalaEscape @p_Nombre = 'Sala de Prueba 2', @p_Tema = 'Piratas', @p_Dificultad = 2, @p_Precio = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una sala de escape nueva | `000000` | Sala de escape registrada |
| 'El Laboratorio' ya existe | `000001` | El nombre de sala ya existe |
| Dificultad = 6 | `000002` | La dificultad debe estar entre 1 y 5 |
| Precio 0 | `000003` | El precio por partida debe ser mayor a cero |
