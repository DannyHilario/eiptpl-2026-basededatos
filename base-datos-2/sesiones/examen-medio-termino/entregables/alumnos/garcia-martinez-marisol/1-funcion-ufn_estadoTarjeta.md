# Examen de Medio Término — Ejercicio 1 de 3: `ufn_estadoTarjeta`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Función escalar `ufn_estadoTarjeta`
**Valor:** 20 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** conocer el estado de una tarjeta con una sola consulta, **para** saber de inmediato si el cliente puede usarla.

## Contexto

La tabla `Tarjeta` no tiene una columna de estatus. El estado se deduce de dos columnas, `Activo` y `FechaVencimiento`, con esta regla (README del examen, sección *Estado de una tarjeta*):

| Estado | Condición |
|--------|-----------|
| **Cancelada** | `Activo = 0` (sin importar su fecha de vencimiento) |
| **Vencida** | `Activo = 1` y `FechaVencimiento` anterior a la fecha de hoy |
| **Vigente** | `Activo = 1` y `FechaVencimiento` igual o posterior a la fecha de hoy |

Tu función aplica esa regla y regresa el estado como texto.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_estadoTarjeta` que reciba el id de una tarjeta y regrese `'Cancelada'`, `'Vencida'` o `'Vigente'` según la regla de arriba. Usa variables y `IF` / `ELSE`.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Regresa:** `varchar(20)` — `'Cancelada'`, `'Vencida'` o `'Vigente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_estadoTarjeta` y recibe `@p_idTarjeta int`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Guarda `Activo` y `FechaVencimiento` de la tarjeta en variables y decide el estado con `IF` / `ELSE`.
- [ ] Revisa primero si está cancelada: una tarjeta con `Activo = 0` regresa `'Cancelada'` aunque ya haya pasado su fecha de vencimiento.
- [ ] Para decidir si está vencida, compara `FechaVencimiento` contra la fecha de hoy sin hora: `CAST(GETDATE() AS date)`.
- [ ] Si el `idTarjeta` no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada

| Tarjeta | Activo | FechaVencimiento | Resultado esperado |
|---|---|---|---|
| 1 | 1 | 2028-04-10 | **Vigente** |
| 3 | 1 | 2026-02-15 | **Vencida** |
| 6 | 0 | 2028-07-12 | **Cancelada** |
| 9999 | — | — | **NULL** (no existe) |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT dbo.ufn_estadoTarjeta(1) AS Estado     -- esperado: Vigente
SELECT dbo.ufn_estadoTarjeta(3) AS Estado     -- esperado: Vencida
SELECT dbo.ufn_estadoTarjeta(6) AS Estado     -- esperado: Cancelada
SELECT dbo.ufn_estadoTarjeta(9999) AS Estado  -- esperado: NULL

-- Para revisar las 40 tarjetas: deben salir 34 Vigente, 4 Vencida y 2 Cancelada
SELECT idTarjeta, Activo, FechaVencimiento, dbo.ufn_estadoTarjeta(idTarjeta) AS Estado
FROM Tarjeta
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 1**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
