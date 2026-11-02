# PIA MudaFacil — Objeto 01 de 11: `usp_insertarCliente`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Procedimiento almacenado `usp_insertarCliente`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** registrar a un cliente que llega por primera vez, **para** empezar a registrar sus mudanzas sin que se repita su registro.

## Contexto

Un cliente se registra una sola vez. El correo electrónico identifica al cliente: no puede haber dos clientes con el mismo correo electrónico. Cada cliente tiene un tipo de vivienda; quien lo registra conoce el **nombre** del tipo de vivienda, no su id: el procedimiento lo busca, y solo acepta tipos de vivienda activos. Un cliente nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarCliente` que valide las reglas de arriba y, si todo es correcto, registre al cliente.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoVivienda` | `varchar(50)` | Nombre del tipo de vivienda |
| `@p_Nombre` | `varchar(100)` | Nombre del cliente |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_FechaRegistro` | `date` | Fecha de registro |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de vivienda existe | `000001` | El tipo de vivienda no existe |
| 2 | El tipo de vivienda está activo | `000002` | El tipo de vivienda está dado de baja |
| 3 | El correo electrónico no está registrado | `000003` | El correo electrónico ya está registrado |
| 4 | Todo correcto | `000000` | Cliente registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de vivienda existe → `000001` *El tipo de vivienda no existe*.
- [ ] Valida: el tipo de vivienda está activo → `000002` *El tipo de vivienda está dado de baja*.
- [ ] Valida: el correo electrónico no está registrado → `000003` *El correo electrónico ya está registrado*.
- [ ] Cuenta también a los clientes dados de baja: su correo electrónico sigue siendo suyo.
- [ ] Si todo es correcto, inserta al cliente **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un cliente nuevo
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000003: el correo electrónico 'prueba1@correo.com' ya está registrado
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente Dos', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000001: el tipo de vivienda 'Otro' no existe
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Otro', @p_Nombre = 'Cliente Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'

-- 000002: el tipo de vivienda dado de baja. Como ningún procedimiento lo da de baja,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeVivienda> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Casa'
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
UPDATE <TuTablaDeTiposDeVivienda> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Casa'

-- 000000: ya está activo otra vez
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente Dos', @p_CorreoElectronico = 'prueba2@correo.com', @p_FechaRegistro = '2026-11-02'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un cliente nuevo | `000000` | Cliente registrado |
| El correo electrónico 'prueba1@correo.com' ya está registrado | `000003` | El correo electrónico ya está registrado |
| El tipo de vivienda 'Otro' no existe | `000001` | El tipo de vivienda no existe |
| El tipo de vivienda dado de baja. Como ningún procedimiento lo da de baja | `000002` | El tipo de vivienda está dado de baja |
| Ya está activo otra vez | `000000` | Cliente registrado |
