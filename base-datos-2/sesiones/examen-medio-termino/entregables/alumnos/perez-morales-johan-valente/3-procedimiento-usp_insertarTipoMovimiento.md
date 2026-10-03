# Examen de Medio Término — Ejercicio 3 de 3: `usp_insertarTipoMovimiento`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Procedimiento almacenado `usp_insertarTipoMovimiento`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente de operaciones, **quiero** dar de alta un tipo de movimiento nuevo, **para** poder registrar operaciones que hoy no están en el catálogo, por ejemplo una comisión.

## Contexto

Cada movimiento de una tarjeta es de un tipo (`TipoMovimiento`). La columna `EsCargo` indica si ese tipo de movimiento **sube** el saldo (`1`, cargo: el cliente le debe más al banco) o lo **baja** (`0`, abono: el cliente le debe menos).

El nombre del tipo de movimiento no se puede repetir.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarTipoMovimiento` que valide la regla de arriba y, si todo es correcto, inserte el tipo de movimiento.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre del tipo de movimiento |
| `@p_EsCargo` | `bit` | `1` si es cargo, `0` si es abono |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | No existe otro tipo de movimiento con ese nombre | `000001` | Ya existe un tipo de movimiento con ese nombre |
| 2 | Todo correcto | `000000` | Tipo de movimiento registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarTipoMovimiento` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: no existe otro tipo de movimiento con ese nombre → `000001` *Ya existe un tipo de movimiento con ese nombre*.
- [ ] Si todo es correcto, inserta el tipo en `TipoMovimiento` con nombre y `EsCargo`. `Activo`, `FechaCreacion` y `FechaUltimaModificacion` toman su valor por defecto.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tipo de movimiento registrado'`.

## Ejemplo de salida esperada

`EXEC usp_insertarTipoMovimiento @p_Nombre = 'Comisión', @p_EsCargo = 1`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Tipo de movimiento registrado |

Después, `SELECT * FROM TipoMovimiento WHERE idTipoMovimiento = 6` muestra el tipo Comisión, como cargo.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito
EXEC usp_insertarTipoMovimiento @p_Nombre = 'Comisión', @p_EsCargo = 1
SELECT idTipoMovimiento, Nombre, EsCargo, Activo
FROM TipoMovimiento
WHERE idTipoMovimiento = 6

-- 000001: ya existe el tipo Pago
EXEC usp_insertarTipoMovimiento @p_Nombre = 'Pago', @p_EsCargo = 0
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_PerezMoralesJohanValente_2254047_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
