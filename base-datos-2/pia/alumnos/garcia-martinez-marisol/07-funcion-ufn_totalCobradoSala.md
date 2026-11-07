# PIA SalaRock — Objeto 07 de 11: `ufn_totalCobradoSala`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Función escalar `ufn_totalCobradoSala`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** saber cuánto se ha cobrado en total por cada sala, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una sala es la **suma de lo cobrado** en todas sus ensayos: en cada uno, el precio cobrado × horas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La sala tiene ensayos | La suma de lo cobrado |
| La sala existe pero no tiene ensayos | `0.00` |
| La sala no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoSala` que reciba el nombre de una sala y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreSala` | `varchar(50)` | Nombre de la sala |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoSala` y recibe `@p_NombreSala varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una sala con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada ensayo, no el precio actual), multiplicado por horas.
- [ ] Si la sala existe pero no tiene ensayos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_insertarSala`](03-procedimiento-usp_insertarSala.md), [`usp_actualizarTarifaTipoSala`](04-procedimiento-usp_actualizarTarifaTipoSala.md), [`usp_registrarEnsayo`](05-procedimiento-usp_registrarEnsayo.md).

```sql
-- Preparación: la banda de prueba
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'

-- Preparación: una sala nueva, 'Sala Prueba' (Mediana, $220.00)
EXEC usp_insertarSala @p_NombreTipoSala = 'Mediana', @p_NombreSala = 'Sala Prueba', @p_FechaApertura = '2026-11-01'

-- Sin ensayos: 0.00
SELECT dbo.ufn_totalCobradoSala('Sala Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoSala('NoExiste') AS TotalCobrado
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Prueba', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Prueba', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 3

-- Dos ensayos: 1100.00
SELECT dbo.ufn_totalCobradoSala('Sala Prueba') AS TotalCobrado

-- Sube el precio a $260.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaTipoSala @p_NombreTipoSala = 'Mediana', @p_PrecioNuevo = 260.00
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Prueba', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-03', @p_Horas = 1

-- Tres ensayos: 1360.00
SELECT dbo.ufn_totalCobradoSala('Sala Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Sala Prueba' sin ensayos | 0.00 |
| No existe | NULL |
| Con 2 ensayos | 1100.00 |
| Con 3 ensayos, uno con el precio nuevo | 1360.00 |
