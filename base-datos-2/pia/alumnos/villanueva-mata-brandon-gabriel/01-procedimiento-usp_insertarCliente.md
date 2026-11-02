# PIA ImprimeYa — Objeto 01 de 11: `usp_insertarCliente`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_insertarCliente`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** registrar a un cliente que llega por primera vez, **para** empezar a registrar sus pedidos sin que se repita su registro.

## Contexto

Un cliente se registra una sola vez. El correo electrónico identifica al cliente: no puede haber dos clientes con el mismo correo electrónico. Cada cliente tiene un giro; quien lo registra conoce el **nombre** del giro, no su id: el procedimiento lo busca, y solo acepta giros activos. Un cliente nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarCliente` que valide las reglas de arriba y, si todo es correcto, registre al cliente.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreGiro` | `varchar(50)` | Nombre del giro |
| `@p_NombreNegocio` | `varchar(100)` | Nombre del negocio |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaRegistro` | `date` | Fecha de registro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El giro existe | `000001` | El giro no existe |
| 2 | El giro está activo | `000002` | El giro está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Cliente registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el giro existe → `000001` *El giro no existe*.
- [ ] Valida: el giro está activo → `000002` *El giro está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los clientes dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al cliente **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un cliente nuevo
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000001: el giro 'Otro' no existe
EXEC usp_insertarCliente @p_NombreGiro = 'Otro', @p_NombreNegocio = 'Negocio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000002: el giro dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeGiros> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Restaurante'
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
UPDATE <TuTablaDeGiros> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Restaurante'

-- 000000: ya está activo otra vez
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un cliente nuevo | `000000` | Cliente registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El giro 'Otro' no existe | `000001` | El giro no existe |
| El giro dado de baja. Como ningún procedimiento lo da de baja | `000002` | El giro está dado de baja |
| Ya está activo otra vez | `000000` | Cliente registrado |
