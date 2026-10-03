# Examen de Medio Término — Ejercicio 3 de 3: `usp_eliminarSucursal`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Procedimiento almacenado `usp_eliminarSucursal`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente regional, **quiero** dar de baja una sucursal que va a cerrar, **para** que ya no se le asignen clientes, siempre que no tenga clientes activos.

## Contexto

Las sucursales no se borran: se hace una **baja lógica**, poniendo `Activo = 0`.

El banco no permite cerrar una sucursal que todavía tiene **clientes activos** (`Cliente.Activo = 1`): primero habría que cambiarlos de sucursal. Para revisarlo, cuenta con `COUNT` cuántos clientes activos tiene la sucursal y guarda el resultado en una variable.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_eliminarSucursal` que valide las reglas de arriba y, si todo es correcto, dé de baja la sucursal.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idSucursal` | `int` | Id de la sucursal |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sucursal existe | `000001` | La sucursal no existe |
| 2 | La sucursal no está ya dada de baja (`Activo = 1`) | `000002` | La sucursal ya está dada de baja |
| 3 | La sucursal no tiene clientes con `Activo = 1` | `000003` | La sucursal tiene clientes activos |
| 4 | Todo correcto | `000000` | Sucursal dada de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarSucursal` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la sucursal existe → `000001` *La sucursal no existe*.
- [ ] Valida: la sucursal no está ya dada de baja (`Activo = 1`) → `000002` *La sucursal ya está dada de baja*.
- [ ] Valida: la sucursal no tiene clientes con `Activo = 1` → `000003` *La sucursal tiene clientes activos*.
- [ ] Si todo es correcto, actualiza la sucursal con `Activo = 0` y `FechaUltimaModificacion = GETDATE()`. No usa `DELETE`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sucursal dada de baja'`.

## Ejemplo de salida esperada

`EXEC usp_eliminarSucursal @p_idSucursal = 5`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Sucursal dada de baja |

La Sucursal Guadalupe (5) no tiene clientes. Después, `SELECT Activo FROM Sucursal WHERE idSucursal = 5` muestra `0`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: la Sucursal Guadalupe (5) no tiene clientes
EXEC usp_eliminarSucursal @p_idSucursal = 5
SELECT idSucursal, Nombre, Activo
FROM Sucursal
WHERE idSucursal = 5

-- 000002: ya se dio de baja en el caso anterior
EXEC usp_eliminarSucursal @p_idSucursal = 5

-- 000001: la sucursal no existe
EXEC usp_eliminarSucursal @p_idSucursal = 9999

-- 000003: la Sucursal Centro (1) tiene 10 clientes activos
EXEC usp_eliminarSucursal @p_idSucursal = 1
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
