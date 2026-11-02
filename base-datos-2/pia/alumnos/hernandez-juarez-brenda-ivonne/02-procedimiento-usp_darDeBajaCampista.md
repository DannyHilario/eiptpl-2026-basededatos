# PIA CampoVerde — Objeto 02 de 11: `usp_darDeBajaCampista`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaCampista`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** dar de baja al campista que ya no regresa, **para** que ya no se le registren rentas sin perder su historial.

## Contexto

En CampoVerde un campista **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **teléfono**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaCampista` que valide las reglas de abajo y, si todo es correcto, marque al campista como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_TelefonoCampista` | `varchar(15)` | Teléfono del campista |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El campista existe | `000001` | El campista no existe |
| 2 | El campista está activo | `000002` | El campista ya está dado de baja |
| 3 | Todo correcto | `000000` | Campista dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaCampista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el campista existe → `000001` *El campista no existe*.
- [ ] Valida: el campista está activo → `000002` *El campista ya está dado de baja*.
- [ ] Si todo es correcto, marca al campista como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Campista dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del campista y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el teléfono.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md).

```sql
-- Preparación: el campista de prueba
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'

-- 000001: no existe un campista con ese teléfono
EXEC usp_darDeBajaCampista @p_TelefonoCampista = 'NoExiste99'

-- 000000: se da de baja
EXEC usp_darDeBajaCampista @p_TelefonoCampista = '8199990001'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaCampista @p_TelefonoCampista = '8199990001'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El campista de prueba | `000000` | Campista registrado |
| No existe un campista con ese teléfono | `000001` | El campista no existe |
| Se da de baja | `000000` | Campista dado de baja |
| Ya estaba dado de baja | `000002` | El campista ya está dado de baja |
