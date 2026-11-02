# PIA BiciRuta — Objeto 03 de 11: `usp_insertarBicicleta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Procedimiento almacenado `usp_insertarBicicleta`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** dar de alta una bicicleta nueva, **para** que empiece a acumular rentas.

## Contexto

Cada bicicleta es de **un solo** tipo de bicicleta y tiene un número de serie que **no se repite**. Solo se dan de alta bicicletas de un tipo de bicicleta que el negocio **sigue manejando**. Una bicicleta nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de bicicleta, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarBicicleta` que valide las reglas de arriba y, si todo es correcto, registre la bicicleta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoBicicleta` | `varchar(30)` | Nombre del tipo de bicicleta |
| `@p_NumeroSerie` | `varchar(20)` | Número de serie |
| `@p_FechaAlta` | `date` | Fecha de alta |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de bicicleta existe | `000001` | El tipo de bicicleta no existe |
| 2 | El tipo de bicicleta está activo | `000002` | El tipo de bicicleta está dado de baja |
| 3 | El número de serie no existe | `000003` | El número de serie ya existe |
| 4 | Todo correcto | `000000` | Bicicleta registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarBicicleta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de bicicleta existe → `000001` *El tipo de bicicleta no existe*.
- [ ] Valida: el tipo de bicicleta está activo → `000002` *El tipo de bicicleta está dado de baja*.
- [ ] Valida: el número de serie no existe → `000003` *El número de serie ya existe*.
- [ ] El número de serie de una bicicleta dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la bicicleta con el id del tipo de bicicleta que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Bicicleta registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de bicicleta y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una bicicleta nueva
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Montaña', @p_NumeroSerie = 'UR-0020', @p_FechaAlta = '2026-11-01'

-- 000001: el tipo de bicicleta 'Otro' no existe
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Otro', @p_NumeroSerie = 'UR-0020', @p_FechaAlta = '2026-11-01'

-- 000003: 'UR-0001' ya existe
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Montaña', @p_NumeroSerie = 'UR-0001', @p_FechaAlta = '2026-11-01'

-- 000003: 'MT-0010' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Montaña', @p_NumeroSerie = 'MT-0010', @p_FechaAlta = '2026-11-01'

-- 000002: el tipo de bicicleta dado de baja. Como ningún procedimiento da de baja los tipos de bicicleta,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeBicicleta> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Eléctrica'
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Eléctrica', @p_NumeroSerie = 'UR-0020B', @p_FechaAlta = '2026-11-01'
UPDATE <TuTablaDeTiposDeBicicleta> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Eléctrica'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una bicicleta nueva | `000000` | Bicicleta registrada |
| El tipo de bicicleta 'Otro' no existe | `000001` | El tipo de bicicleta no existe |
| 'UR-0001' ya existe | `000003` | El número de serie ya existe |
| 'MT-0010' está dada de baja, pero sigue siendo suyo | `000003` | El número de serie ya existe |
| El tipo de bicicleta dado de baja. Como ningún procedimiento da de baja los tipos de bicicleta | `000002` | El tipo de bicicleta está dado de baja |
