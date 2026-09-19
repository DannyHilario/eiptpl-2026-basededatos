# `usp_cambiarEstatusReceta`

Script: [`instalacion/08-Receta/04-usp-cambiar-estatus.sql`](../../instalacion/08-Receta/04-usp-cambiar-estatus.sql)

**Este es el SP que debe usarse para cambiar el estatus de una receta.** Deja el registro en la bitácora y actualiza el estatus vigente en una sola llamada.

## En palabras simples

Este es el SP que corre en farmacia. Alguien surte total o parcialmente la receta de un paciente, o la cancela, y este SP hace dos cosas a la vez: (1) deja constancia del cambio en el "diario" (`BitacoraEstatusReceta`, vía [`usp_insertarBitacoraEstatusReceta`](usp_insertarBitacoraEstatusReceta.md)) y (2) actualiza el estatus vigente de la receta, para que una consulta rápida (`SELECT idEstatusReceta FROM Receta`) siempre refleje el estado actual sin tener que buscar en el historial.

Antes de mover nada, valida que el cambio de estatus solicitado tenga sentido — por ejemplo, no se puede "cancelar" una receta que ya se surtió. Esa validación es la misma que usa el SP de la bitácora; la explicación completa, con el mapa de qué estatus puede pasar a cuál, está en su ficha: [¿Cómo funciona la validación de la transición?](usp_insertarBitacoraEstatusReceta.md#cómo-funciona-la-validación-de-la-transición-explicado-sin-jerga)

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta |
| `@p_idEstatusNuevo` | `int` | Id del estatus al que transiciona |

## Validaciones (orden en que se evalúan)

1. La receta debe existir.
2. El estatus nuevo debe existir en `EstatusReceta`.
3. La transición del estatus actual al estatus nuevo debe ser una de las permitidas: `1 Creada → 2 En atención`, `2 → 3 Surtida`, `2 → 4 Surtida parcialmente`, `4 → 3`, `1 → 5 Cancelada`, `2 → 5`.

Son las mismas validaciones que [`usp_insertarBitacoraEstatusReceta`](usp_insertarBitacoraEstatusReceta.md) — se repiten aquí porque este SP no captura el resultado del `EXEC` interno (el curso todavía no cubre `OUTPUT` params ni `INSERT ... EXEC`), así que no puede confiar ciegamente en que la inserción de la bitácora tuvo éxito sin validar por su cuenta antes de continuar.

## Qué hace, en orden

1. Corre las 3 validaciones de arriba (con `RETURN` si alguna falla).
2. `EXEC usp_insertarBitacoraEstatusReceta @p_idReceta, @p_idEstatusNuevo` — registra la transición.
3. `UPDATE Receta SET idEstatusReceta = @p_idEstatusNuevo, FechaUltimaModificacion = GETDATE()` — aplica el estatus nuevo.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La receta no existe | `idReceta` inválido |
| `000002` | El estatus nuevo no existe | `idEstatusNuevo` inválido |
| `000003` | La transición de estatus no es válida | La combinación estatus actual → estatus nuevo no está en la lista de transiciones permitidas |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_cambiarEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 2
```

## Casos de prueba sugeridos

```sql
-- Éxito: verificar que quedó en Receta Y en BitacoraEstatusReceta
EXEC usp_cambiarEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 2
SELECT idEstatusReceta FROM Receta WHERE idReceta = 1
SELECT * FROM BitacoraEstatusReceta WHERE idReceta = 1

-- Receta no existe
EXEC usp_cambiarEstatusReceta @p_idReceta = 9999, @p_idEstatusNuevo = 2

-- Estatus nuevo no existe
EXEC usp_cambiarEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 9999

-- Transición inválida: 3 -> 4 (receta 8 está en estatus 3 Surtida)
EXEC usp_cambiarEstatusReceta @p_idReceta = 8, @p_idEstatusNuevo = 4

-- Transición inválida: cancelar desde 3 o 4 (receta 12 está en estatus 4 Surtida parcialmente)
EXEC usp_cambiarEstatusReceta @p_idReceta = 12, @p_idEstatusNuevo = 5
```

## Instalación

Depende de que [`usp_insertarBitacoraEstatusReceta`](usp_insertarBitacoraEstatusReceta.md) ya exista **al momento de ejecutarse**, aunque no al crearse: SQL Server resuelve nombres de objetos referenciados dentro de un procedimiento hasta que se invoca (deferred name resolution), no cuando se hace el `CREATE PROCEDURE`. Por eso el paquete de instalación puede crear este SP (carpeta `08-Receta`) antes que el de bitácora (carpeta `11-BitacoraEstatusReceta`) sin error — solo importa que ambos existan antes del primer `EXEC usp_cambiarEstatusReceta`.
