# PIA SalaRock — Objeto 01 de 11: `usp_insertarBanda`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_insertarBanda`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** registrar a una banda que llega por primera vez, **para** empezar a registrar sus ensayos sin que se repita su registro.

## Contexto

Una banda se registra una sola vez. El nombre de banda identifica a la banda: no puede haber dos bandas con el mismo nombre de banda. Además, una banda tiene **de 1 a 8 integrantes**. Una banda nueva siempre se registra **activa**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarBanda` que valide las reglas de arriba y, si todo es correcto, registre a la banda.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre de la banda |
| `@p_Integrantes` | `int` | Número de integrantes |
| `@p_TelefonoContacto` | `varchar(15)` | Teléfono de contacto |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de banda no está registrado | `000001` | El nombre de banda ya está registrado |
| 2 | Una banda tiene de 1 a 8 integrantes | `000002` | Una banda tiene de 1 a 8 integrantes |
| 3 | Todo correcto | `000000` | Banda registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarBanda` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de banda no está registrado → `000001` *El nombre de banda ya está registrado*.
- [ ] Valida: una banda tiene de 1 a 8 integrantes → `000002` *Una banda tiene de 1 a 8 integrantes*.
- [ ] Cuenta también a las bandas dadas de baja: su nombre de banda sigue siendo suyo.
- [ ] Si todo es correcto, inserta a la banda **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Banda registrada'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una banda nueva
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'

-- 000001: el nombre de banda 'Banda de Prueba' ya está registrado
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 3, @p_TelefonoContacto = '8199990002'

-- 000002: Integrantes = 0
EXEC usp_insertarBanda @p_Nombre = 'Banda Dos', @p_Integrantes = 0, @p_TelefonoContacto = '8199990002'

-- 000002: Integrantes = 9
EXEC usp_insertarBanda @p_Nombre = 'Banda Dos', @p_Integrantes = 9, @p_TelefonoContacto = '8199990002'

-- 000000: el límite, Integrantes = 1, sí se acepta
EXEC usp_insertarBanda @p_Nombre = 'Banda Dos', @p_Integrantes = 1, @p_TelefonoContacto = '8199990002'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una banda nueva | `000000` | Banda registrada |
| El nombre de banda 'Banda de Prueba' ya está registrado | `000001` | El nombre de banda ya está registrado |
| Integrantes = 0 | `000002` | Una banda tiene de 1 a 8 integrantes |
| Integrantes = 9 | `000002` | Una banda tiene de 1 a 8 integrantes |
| El límite, Integrantes = 1, sí se acepta | `000000` | Banda registrada |
