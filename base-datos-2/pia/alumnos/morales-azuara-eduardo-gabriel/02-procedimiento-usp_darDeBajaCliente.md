# PIA GuardaTodo — Objeto 02 de 11: `usp_darDeBajaCliente`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaCliente`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** dar de baja al cliente que ya no regresa, **para** que ya no se le registren contratos sin perder su historial.

## Contexto

En GuardaTodo un cliente **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **teléfono**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaCliente` que valide las reglas de abajo y, si todo es correcto, marque al cliente como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_TelefonoCliente` | `varchar(15)` | Teléfono del cliente |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |
| 2 | El cliente está activo | `000002` | El cliente ya está dado de baja |
| 3 | Todo correcto | `000000` | Cliente dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000002` *El cliente ya está dado de baja*.
- [ ] Si todo es correcto, marca al cliente como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del cliente y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el teléfono.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- 000001: no existe un cliente con ese teléfono
EXEC usp_darDeBajaCliente @p_TelefonoCliente = 'NoExiste99'

-- 000000: se da de baja
EXEC usp_darDeBajaCliente @p_TelefonoCliente = '8199990001'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaCliente @p_TelefonoCliente = '8199990001'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| No existe un cliente con ese teléfono | `000001` | El cliente no existe |
| Se da de baja | `000000` | Cliente dado de baja |
| Ya estaba dado de baja | `000002` | El cliente ya está dado de baja |
