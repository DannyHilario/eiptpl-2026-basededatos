# PIA MudaFacil — Objeto 04 de 11: `usp_actualizarPrecioPaquete`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioPaquete`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** cambiar el precio por mudanza de un paquete, **para** que las mudanzas nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada mudanza guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioPaquete` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombrePaquete` | `varchar(30)` | Nombre de paquete |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por mudanza nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El paquete existe | `000001` | El paquete no existe |
| 2 | El precio por mudanza nuevo es mayor a cero | `000002` | El precio por mudanza debe ser mayor a cero |
| 3 | El precio por mudanza nuevo es distinto al actual | `000003` | El precio por mudanza nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por mudanza actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioPaquete` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el paquete existe → `000001` *El paquete no existe*.
- [ ] Valida: el precio por mudanza nuevo es mayor a cero → `000002` *El precio por mudanza debe ser mayor a cero*.
- [ ] Valida: el precio por mudanza nuevo es distinto al actual → `000003` *El precio por mudanza nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna mudanza ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por mudanza actualizado'`.

**Sugerencia** (no se califica): Obtén el id del paquete y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un paquete 'Otro'
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Otro', @p_PrecioNuevo = 6000.00

-- 000002: precio 0
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $6,000.00
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = 6000.00

-- 000000: sube a $7,800.00
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = 7800.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un paquete 'Otro' | `000001` | El paquete no existe |
| Precio 0 | `000002` | El precio por mudanza debe ser mayor a cero |
| Precio negativo | `000002` | El precio por mudanza debe ser mayor a cero |
| Ya cuesta $6,000.00 | `000003` | El precio por mudanza nuevo es igual al actual |
| Sube a $7,800.00 | `000000` | Precio por mudanza actualizado |

Al final, el precio por mudanza de 'Mediano' es **$7,800.00**.
