# Examen de Medio Término — Ejercicio 3 de 3: `usp_actualizarDireccionCliente`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarDireccionCliente`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** actualizar la dirección de un cliente que se cambió de domicilio, **para** mantener sus datos de contacto al día.

## Contexto

La dirección del cliente se guarda completa en una sola columna, `Cliente.Direccion` (calle, número, colonia y municipio). Actualizarla solo se permite si el cliente existe y está activo.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarDireccionCliente` que valide las reglas de arriba y, si todo es correcto, actualice la dirección.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente |
| `@p_DireccionNueva` | `varchar(200)` | Dirección nueva completa |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |
| 2 | El cliente está activo (`Activo = 1`) | `000002` | El cliente está dado de baja |
| 3 | Todo correcto | `000000` | Dirección actualizada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarDireccionCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Valida: el cliente está activo (`Activo = 1`) → `000002` *El cliente está dado de baja*.
- [ ] Si todo es correcto, actualiza `Cliente.Direccion` con la dirección nueva y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Dirección actualizada'`.

## Ejemplo de salida esperada

`EXEC usp_actualizarDireccionCliente @p_idCliente = 4, @p_DireccionNueva = 'Av. Concordia 210, Col. Hacienda Las Margaritas, Apodaca, N.L.'`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Dirección actualizada |

Después, `SELECT Direccion FROM Cliente WHERE idCliente = 4` muestra la dirección nueva.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito
EXEC usp_actualizarDireccionCliente @p_idCliente = 4, @p_DireccionNueva = 'Av. Concordia 210, Col. Hacienda Las Margaritas, Apodaca, N.L.'
SELECT idCliente, Direccion
FROM Cliente
WHERE idCliente = 4

-- 000001: el cliente no existe
EXEC usp_actualizarDireccionCliente @p_idCliente = 9999, @p_DireccionNueva = 'Calle 1'

-- 000002: cliente dado de baja (en los datos iniciales todos están activos; primero da de baja al 30)
UPDATE Cliente SET Activo = 0 WHERE idCliente = 30
EXEC usp_actualizarDireccionCliente @p_idCliente = 30, @p_DireccionNueva = 'Calle 1'
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_HernandezPerezJoseIvan_2253557_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
