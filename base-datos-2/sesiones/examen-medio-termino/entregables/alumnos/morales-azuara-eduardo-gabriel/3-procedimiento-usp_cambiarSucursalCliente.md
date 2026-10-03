# Examen de Medio Término — Ejercicio 3 de 3: `usp_cambiarSucursalCliente`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Procedimiento almacenado `usp_cambiarSucursalCliente`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** cambiar a un cliente de sucursal, **para** que lo atienda la sucursal más cercana a su nuevo domicilio.

## Contexto

Cada cliente pertenece a una sucursal (`Cliente.idSucursal`). Cambiarlo de sucursal es actualizar ese dato. El banco revisa que:

- El cliente exista y esté activo.
- La sucursal nueva exista y esté activa.
- La sucursal nueva sea **distinta** a la que el cliente ya tiene.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_cambiarSucursalCliente` que valide las reglas de arriba y, si todo es correcto, cambie al cliente de sucursal.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente |
| `@p_idSucursalNueva` | `int` | Id de la sucursal nueva |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |
| 2 | El cliente está activo (`Activo = 1`) | `000002` | El cliente está dado de baja |
| 3 | La sucursal nueva existe | `000003` | La sucursal no existe |
| 4 | La sucursal nueva está activa (`Activo = 1`) | `000004` | La sucursal está dada de baja |
| 5 | La sucursal nueva es distinta a la actual del cliente | `000005` | El cliente ya pertenece a esa sucursal |
| 6 | Todo correcto | `000000` | Sucursal actualizada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_cambiarSucursalCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Valida: el cliente está activo (`Activo = 1`) → `000002` *El cliente está dado de baja*.
- [ ] Valida: la sucursal nueva existe → `000003` *La sucursal no existe*.
- [ ] Valida: la sucursal nueva está activa (`Activo = 1`) → `000004` *La sucursal está dada de baja*.
- [ ] Valida: la sucursal nueva es distinta a la actual del cliente → `000005` *El cliente ya pertenece a esa sucursal*.
- [ ] Si todo es correcto, actualiza `Cliente.idSucursal` con la sucursal nueva y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sucursal actualizada'`.

## Ejemplo de salida esperada

`EXEC usp_cambiarSucursalCliente @p_idCliente = 1, @p_idSucursalNueva = 5`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Sucursal actualizada |

El cliente 1 pertenecía a la Sucursal Centro (1). Después, `SELECT idSucursal FROM Cliente WHERE idCliente = 1` muestra `5`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: el cliente 1 pasa de Centro (1) a Guadalupe (5)
EXEC usp_cambiarSucursalCliente @p_idCliente = 1, @p_idSucursalNueva = 5
SELECT idCliente, idSucursal
FROM Cliente
WHERE idCliente = 1

-- 000005: el cliente 1 ya pertenece a la sucursal 5 después del caso anterior
EXEC usp_cambiarSucursalCliente @p_idCliente = 1, @p_idSucursalNueva = 5

-- 000001: el cliente no existe
EXEC usp_cambiarSucursalCliente @p_idCliente = 9999, @p_idSucursalNueva = 2

-- 000002: cliente dado de baja (en los datos iniciales todos están activos; primero da de baja al 30)
UPDATE Cliente SET Activo = 0 WHERE idCliente = 30
EXEC usp_cambiarSucursalCliente @p_idCliente = 30, @p_idSucursalNueva = 1

-- 000003: la sucursal no existe
EXEC usp_cambiarSucursalCliente @p_idCliente = 2, @p_idSucursalNueva = 9999

-- 000004: sucursal dada de baja (primero da de baja la 4)
UPDATE Sucursal SET Activo = 0 WHERE idSucursal = 4
EXEC usp_cambiarSucursalCliente @p_idCliente = 2, @p_idSucursalNueva = 4
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
