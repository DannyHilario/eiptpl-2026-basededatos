# PIA AsesorPro — Objeto 04 de 11: `usp_actualizarTarifaAsesor`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarTarifaAsesor`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** cambiar la tarifa por hora de un asesor, **para** que las asesorías nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada asesoría guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarTarifaAsesor` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoAsesor` | `varchar(100)` | Correo electrónico |
| `@p_PrecioNuevo` | `decimal(10,2)` | Tarifa por hora nueva |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El asesor existe | `000001` | El asesor no existe |
| 2 | La tarifa por hora nueva es mayor a cero | `000002` | La tarifa por hora debe ser mayor a cero |
| 3 | La tarifa por hora nueva es distinta a la actual | `000003` | La tarifa por hora nueva es igual a la actual |
| 4 | Todo correcto | `000000` | Tarifa por hora actualizada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarTarifaAsesor` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el asesor existe → `000001` *El asesor no existe*.
- [ ] Valida: la tarifa por hora nueva es mayor a cero → `000002` *La tarifa por hora debe ser mayor a cero*.
- [ ] Valida: la tarifa por hora nueva es distinta a la actual → `000003` *La tarifa por hora nueva es igual a la actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna asesoría ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarifa por hora actualizada'`.

**Sugerencia** (no se califica): Obtén el id del asesor y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un asesor 'Otro'
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'Otro', @p_PrecioNuevo = 260.00

-- 000002: precio 0
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $260.00
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = 260.00

-- 000000: sube a $335.00
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = 335.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un asesor 'Otro' | `000001` | El asesor no existe |
| Precio 0 | `000002` | La tarifa por hora debe ser mayor a cero |
| Precio negativo | `000002` | La tarifa por hora debe ser mayor a cero |
| Ya cuesta $260.00 | `000003` | La tarifa por hora nueva es igual a la actual |
| Sube a $335.00 | `000000` | Tarifa por hora actualizada |

Al final, la tarifa por hora de 'monica.leal@asesorpro.mx' es **$335.00**.
