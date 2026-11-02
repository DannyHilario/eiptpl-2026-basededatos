# PIA VeloKart — Objeto 07 de 11: `ufn_totalCobradoKart`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Función escalar `ufn_totalCobradoKart`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** saber cuánto se ha cobrado en total por cada kart, **para** decidir si ya se pagó solo o si conviene reemplazarlo.

## Contexto

Lo cobrado con un kart es la **suma del precio cobrado** de todas sus carreras: el que se guardó en cada carrera, **no** el precio actual del tipo.

Hay tres situaciones distintas, y la función debe distinguirlas:

| Situación | Regresa |
|---|---|
| El kart tiene carreras | La suma de lo cobrado |
| El kart existe pero nunca se ha usado | `0.00`: no se ha cobrado nada |
| El kart no existe | `NULL`: no hay nada que sumar |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoKart` que reciba el número de un kart y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_NumeroKart` | `varchar(10)` | Número del kart, por ejemplo `K-07` |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoKart` y recibe `@p_NumeroKart varchar(10)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un kart con ese número, regresa `NULL`.
- [ ] Suma el **precio cobrado** de las carreras del kart (el que guarda cada carrera, no el precio actual del tipo).
- [ ] Si el kart existe pero no tiene carreras, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Ejemplo de salida esperada

Después de la preparación de los casos de prueba:

| Llamada | Resultado esperado |
|---|---|
| `SELECT dbo.ufn_totalCobradoKart('K-20')` antes de correr | **0.00** |
| `SELECT dbo.ufn_totalCobradoKart('K-99')` | **NULL** |
| `SELECT dbo.ufn_totalCobradoKart('K-20')` con 2 carreras a $250.00 | **500.00** |
| `SELECT dbo.ufn_totalCobradoKart('K-20')` con una tercera carrera a $280.00 | **780.00** |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan los procedimientos [01](01-procedimiento-usp_insertarPiloto.md), [03](03-procedimiento-usp_insertarKart.md), [04](04-procedimiento-usp_actualizarPrecioTipoKart.md) y [05](05-procedimiento-usp_registrarCarrera.md).

```sql
-- Preparación: el piloto de prueba y un kart nuevo, K-20 (Estándar, $250.00)
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175
EXEC usp_insertarKart @p_NombreTipoKart = 'Estándar', @p_NumeroKart = 'K-20', @p_FechaAlta = '2026-11-01'

-- Kart sin carreras: 0.00
SELECT dbo.ufn_totalCobradoKart('K-20') AS TotalCobrado

-- Kart que no existe: NULL
SELECT dbo.ufn_totalCobradoKart('K-99') AS TotalCobrado

-- Dos carreras a $250.00: 500.00
EXEC usp_registrarCarrera @p_NumeroKart = 'K-20', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80
EXEC usp_registrarCarrera @p_NumeroKart = 'K-20', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 40.95
SELECT dbo.ufn_totalCobradoKart('K-20') AS TotalCobrado

-- Sube el Estándar a $280.00 y se corre una tercera carrera: 250 + 250 + 280 = 780.00
-- (las dos primeras conservan lo que se cobró)
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Estándar', @p_PrecioNuevo = 280.00
EXEC usp_registrarCarrera @p_NumeroKart = 'K-20', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-03', @p_MejorVuelta = 40.10
SELECT dbo.ufn_totalCobradoKart('K-20') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| `K-20` sin carreras | 0.00 |
| `K-99` | NULL |
| `K-20` con 2 carreras | 500.00 |
| `K-20` con 3 carreras, una con el precio nuevo | 780.00 |

Con la función puedes revisar también tus datos inventados: `SELECT <ColumnaNumero>, dbo.ufn_totalCobradoKart(<ColumnaNumero>) FROM <TuTablaDeKarts>`. Los 2 karts que nunca se han usado deben salir en 0.00.
