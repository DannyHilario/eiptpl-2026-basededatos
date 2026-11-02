# PIA BiciRuta — Objeto 01 de 11: `usp_insertarCliente`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Procedimiento almacenado `usp_insertarCliente`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** registrar a un cliente que llega por primera vez, **para** empezar a registrar sus rentas sin que se repita su registro.

## Contexto

Un cliente se registra una sola vez. El correo electrónico identifica al cliente: no puede haber dos clientes con el mismo correo electrónico. Un cliente nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarCliente` que valide las reglas de arriba y, si todo es correcto, registre al cliente.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(100)` | Nombre del cliente |
| `@p_Telefono` | `varchar(15)` | Teléfono |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El correo electrónico no está registrado | `000001` | El correo electrónico ya está registrado |
| 2 | Todo correcto | `000000` | Cliente registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el correo electrónico no está registrado → `000001` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los clientes dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al cliente **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un cliente nuevo
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- 000001: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarCliente @p_Nombre = 'Cliente Dos', @p_Telefono = '8199990002', @p_CorreoElectronico = 'prueba1@correo.com'

-- 000000: otro cliente
EXEC usp_insertarCliente @p_Nombre = 'Cliente Dos', @p_Telefono = '8199990002', @p_CorreoElectronico = 'prueba2@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un cliente nuevo | `000000` | Cliente registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000001` | El correo electrónico ya está registrado |
| Otro cliente | `000000` | Cliente registrado |
