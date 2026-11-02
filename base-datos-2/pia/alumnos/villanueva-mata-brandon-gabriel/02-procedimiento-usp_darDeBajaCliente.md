# PIA ImprimeYa — Objeto 02 de 11: `usp_darDeBajaCliente`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaCliente`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** dar de baja al cliente que ya no regresa, **para** que ya no se le registren pedidos sin perder su historial.

## Contexto

En ImprimeYa un cliente **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaCliente` que valide las reglas de abajo y, si todo es correcto, marque al cliente como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

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

**Sugerencia** (no se califica): Obtén el id del cliente y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000001: no existe un cliente con ese correo electrónico
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| No existe un cliente con ese correo electrónico | `000001` | El cliente no existe |
| Se da de baja | `000000` | Cliente dado de baja |
| Ya estaba dado de baja | `000002` | El cliente ya está dado de baja |
