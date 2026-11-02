# PIA SalaRock — Objeto 02 de 11: `usp_darDeBajaBanda`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaBanda`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** dar de baja a la banda que ya no regresa, **para** que ya no se le registren ensayos sin perder su historial.

## Contexto

En SalaRock una banda **no se borra**: se da de baja, para conservar su historial. Se la busca por su **nombre de banda**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaBanda` que valide las reglas de abajo y, si todo es correcto, marque a la banda como dada de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreBanda` | `varchar(50)` | Nombre de la banda |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La banda existe | `000001` | La banda no existe |
| 2 | La banda está activa | `000002` | La banda ya está dada de baja |
| 3 | Todo correcto | `000000` | Banda dada de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaBanda` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la banda existe → `000001` *La banda no existe*.
- [ ] Valida: la banda está activa → `000002` *La banda ya está dada de baja*.
- [ ] Si todo es correcto, marca a la banda como dada de baja con un `UPDATE`. **No** la borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Banda dada de baja'`.

**Sugerencia** (no se califica): Obtén el id de la banda y si está activa en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre de banda.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md).

```sql
-- Preparación: la banda de prueba
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'

-- 000001: no existe una banda con ese nombre de banda
EXEC usp_darDeBajaBanda @p_NombreBanda = 'NoExiste99'

-- 000000: se da de baja
EXEC usp_darDeBajaBanda @p_NombreBanda = 'Banda de Prueba'

-- 000002: ya estaba dada de baja
EXEC usp_darDeBajaBanda @p_NombreBanda = 'Banda de Prueba'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| La banda de prueba | `000000` | Banda registrada |
| No existe una banda con ese nombre de banda | `000001` | La banda no existe |
| Se da de baja | `000000` | Banda dada de baja |
| Ya estaba dada de baja | `000002` | La banda ya está dada de baja |
