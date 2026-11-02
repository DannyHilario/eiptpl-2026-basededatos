# PIA VeloKart — Objeto 04 de 11: `usp_actualizarPrecioTipoKart`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioTipoKart`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** cambiar el precio por carrera de un tipo de kart, **para** que las carreras nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio de un tipo **no** cambia lo que ya se cobró: cada carrera guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioTipoKart` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_NombreTipoKart` | `varchar(30)` | Nombre del tipo de kart |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por carrera nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de kart existe | `000001` | El tipo de kart no existe |
| 2 | El precio nuevo es mayor a cero | `000002` | El precio debe ser mayor a cero |
| 3 | El precio nuevo es distinto al actual | `000003` | El precio nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioTipoKart` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de kart existe → `000001` *El tipo de kart no existe*.
- [ ] Valida: el precio nuevo es mayor a cero → `000002` *El precio debe ser mayor a cero*.
- [ ] Valida: el precio nuevo es distinto al actual → `000003` *El precio nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio del tipo con un `UPDATE`. **No** modifica ninguna carrera ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio actualizado'`.

**Sugerencia** (no se califica): obtén el id del tipo y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Ejemplo de salida esperada

`EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 380.00`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Precio actualizado |

Después, el precio por carrera del tipo Profesional es $380.00. Infantil y Estándar siguen en $180.00 y $250.00.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: VeloKart no maneja karts Turbo
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Turbo', @p_PrecioNuevo = 300.00

-- 000002: precio cero
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = -50.00

-- 000003: Profesional ya cuesta $350.00
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 350.00

-- 000000: sube a $380.00
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 380.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Tipo Turbo | `000001` | El tipo de kart no existe |
| Precio 0 | `000002` | El precio debe ser mayor a cero |
| Precio -50.00 | `000002` | El precio debe ser mayor a cero |
| Mismo precio, 350.00 | `000003` | El precio nuevo es igual al actual |
| 380.00 | `000000` | Precio actualizado |

Al final, los precios por carrera son: Infantil $180.00, Estándar $250.00 y Profesional **$380.00**.
