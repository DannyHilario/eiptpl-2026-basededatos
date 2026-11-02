# PIA VeloKart — Objeto 08 de 11: `ufn_nivelPiloto`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Función escalar `ufn_nivelPiloto`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** encargado del mostrador, **quiero** saber qué tan seguido viene un piloto, **para** ofrecerle una promoción según su nivel.

## Contexto

VeloKart clasifica a sus pilotos según **cuántas carreras han corrido**, en total:

| Carreras | Nivel |
|---|---|
| 0 | **Sin carreras** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Al piloto se le busca por su **teléfono**. Un piloto dado de baja también tiene nivel: se cuentan sus carreras igual.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelPiloto` que reciba el teléfono de un piloto y regrese su nivel según la tabla de arriba. Para elegir el nivel puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Telefono` | `varchar(15)` | Teléfono del piloto |

**Regresa:** `varchar(20)` — `'Sin carreras'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelPiloto` y recibe `@p_Telefono varchar(15)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un piloto con ese teléfono, regresa `NULL`.
- [ ] Cuenta las carreras del piloto, aunque esté dado de baja.
- [ ] Regresa `'Sin carreras'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Ejemplo de salida esperada

| Carreras del piloto de prueba | `SELECT dbo.ufn_nivelPiloto('8199990001')` |
|---|---|
| 0 | **Sin carreras** |
| 1 | **Ocasional** |
| 2 | **Ocasional** |
| 3 | **Frecuente** |

`SELECT dbo.ufn_nivelPiloto('8199999999')` regresa **NULL**: nadie tiene ese teléfono.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPiloto`](01-procedimiento-usp_insertarPiloto.md) y [`usp_registrarCarrera`](05-procedimiento-usp_registrarCarrera.md).

```sql
-- Preparación: el piloto de prueba
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175

-- 0 carreras: Sin carreras
SELECT dbo.ufn_nivelPiloto('8199990001') AS Nivel

-- Teléfono que no existe: NULL
SELECT dbo.ufn_nivelPiloto('8199999999') AS Nivel

-- 1 carrera: Ocasional
EXEC usp_registrarCarrera @p_NumeroKart = 'K-01', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 52.30
SELECT dbo.ufn_nivelPiloto('8199990001') AS Nivel

-- 2 carreras: Ocasional
EXEC usp_registrarCarrera @p_NumeroKart = 'K-02', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 51.90
SELECT dbo.ufn_nivelPiloto('8199990001') AS Nivel

-- 3 carreras: Frecuente
EXEC usp_registrarCarrera @p_NumeroKart = 'K-01', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-03', @p_MejorVuelta = 50.75
SELECT dbo.ufn_nivelPiloto('8199990001') AS Nivel
```

| Caso | Resultado esperado |
|---|---|
| 0 carreras | Sin carreras |
| Teléfono que no existe | NULL |
| 1 carrera | Ocasional |
| 2 carreras | Ocasional |
| 3 carreras | Frecuente |

Con la función puedes revisar también tus datos inventados: `SELECT <ColumnaNombre>, dbo.ufn_nivelPiloto(<ColumnaTelefono>) FROM <TuTablaDePilotos>`. Los 2 pilotos que nunca han corrido deben salir como *Sin carreras*.
