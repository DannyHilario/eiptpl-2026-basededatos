# PIA CampoVerde — Objeto 03 de 11: `usp_insertarTienda`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_insertarTienda`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** dar de alta una casa de campaña nueva, **para** que empiece a acumular rentas.

## Contexto

Cada casa de campaña es de **un solo** tipo de casa de campaña y tiene un código que **no se repite**. Solo se dan de alta casas de campaña de un tipo de casa de campaña que el negocio **sigue manejando**. Una casa de campaña nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de casa de campaña, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarTienda` que valide las reglas de arriba y, si todo es correcto, registre la casa de campaña.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoTienda` | `varchar(30)` | Nombre del tipo de casa de campaña |
| `@p_CodigoTienda` | `varchar(10)` | Código |
| `@p_FechaCompra` | `date` | Fecha de compra |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de casa de campaña existe | `000001` | El tipo de casa de campaña no existe |
| 2 | El tipo de casa de campaña está activo | `000002` | El tipo de casa de campaña está dado de baja |
| 3 | El código no existe | `000003` | El código ya existe |
| 4 | Todo correcto | `000000` | Casa de campaña registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarTienda` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de casa de campaña existe → `000001` *El tipo de casa de campaña no existe*.
- [ ] Valida: el tipo de casa de campaña está activo → `000002` *El tipo de casa de campaña está dado de baja*.
- [ ] Valida: el código no existe → `000003` *El código ya existe*.
- [ ] El código de una casa de campaña dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la casa de campaña con el id del tipo de casa de campaña que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Casa de campaña registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de casa de campaña y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una casa de campaña nueva
EXEC usp_insertarTienda @p_NombreTipoTienda = '4 personas', @p_CodigoTienda = 'T-20', @p_FechaCompra = '2026-11-01'

-- 000001: el tipo de casa de campaña 'Otro' no existe
EXEC usp_insertarTienda @p_NombreTipoTienda = 'Otro', @p_CodigoTienda = 'T-20', @p_FechaCompra = '2026-11-01'

-- 000003: 'T-01' ya existe
EXEC usp_insertarTienda @p_NombreTipoTienda = '4 personas', @p_CodigoTienda = 'T-01', @p_FechaCompra = '2026-11-01'

-- 000003: 'T-07' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarTienda @p_NombreTipoTienda = '4 personas', @p_CodigoTienda = 'T-07', @p_FechaCompra = '2026-11-01'

-- 000002: el tipo de casa de campaña dado de baja. Como ningún procedimiento da de baja los tipos de casa de campaña,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeCasaDeCampaña> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = '6 personas'
EXEC usp_insertarTienda @p_NombreTipoTienda = '6 personas', @p_CodigoTienda = 'T-20B', @p_FechaCompra = '2026-11-01'
UPDATE <TuTablaDeTiposDeCasaDeCampaña> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = '6 personas'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una casa de campaña nueva | `000000` | Casa de campaña registrada |
| El tipo de casa de campaña 'Otro' no existe | `000001` | El tipo de casa de campaña no existe |
| 'T-01' ya existe | `000003` | El código ya existe |
| 'T-07' está dada de baja, pero sigue siendo suyo | `000003` | El código ya existe |
| El tipo de casa de campaña dado de baja. Como ningún procedimiento da de baja los tipos de casa de campaña | `000002` | El tipo de casa de campaña está dado de baja |
