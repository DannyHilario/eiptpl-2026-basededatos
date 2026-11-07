# PIA QuintaSol — Objeto 07 de 11: `ufn_totalCobradoQuinta`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Función escalar `ufn_totalCobradoQuinta`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** saber cuánto se ha cobrado en total por cada quinta, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una quinta es la **suma del precio cobrado** de todas sus eventos, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La quinta tiene eventos | La suma de lo cobrado |
| La quinta existe pero no tiene eventos | `0.00` |
| La quinta no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoQuinta` que reciba el nombre de una quinta y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreQuinta` | `varchar(50)` | Nombre de la quinta |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoQuinta` y recibe `@p_NombreQuinta varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una quinta con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada evento, no el precio actual).
- [ ] Si la quinta existe pero no tiene eventos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarQuinta`](03-procedimiento-usp_insertarQuinta.md), [`usp_actualizarPrecioTipoQuinta`](04-procedimiento-usp_actualizarPrecioTipoQuinta.md), [`usp_registrarEvento`](05-procedimiento-usp_registrarEvento.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'

-- Preparación: una quinta nueva, 'Quinta Prueba' (Mediana, $5,500.00)
EXEC usp_insertarQuinta @p_NombreTipoQuinta = 'Mediana', @p_NombreQuinta = 'Quinta Prueba', @p_FechaApertura = '2026-11-01'

-- Sin eventos: 0.00
SELECT dbo.ufn_totalCobradoQuinta('Quinta Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoQuinta('NoExiste') AS TotalCobrado
EXEC usp_registrarEvento @p_NombreQuinta = 'Quinta Prueba', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80
EXEC usp_registrarEvento @p_NombreQuinta = 'Quinta Prueba', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 120

-- Dos eventos: 11000.00
SELECT dbo.ufn_totalCobradoQuinta('Quinta Prueba') AS TotalCobrado

-- Sube el precio a $6,600.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Mediana', @p_PrecioNuevo = 6600.00
EXEC usp_registrarEvento @p_NombreQuinta = 'Quinta Prueba', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-03', @p_Invitados = 50

-- Tres eventos: 17600.00
SELECT dbo.ufn_totalCobradoQuinta('Quinta Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Quinta Prueba' sin eventos | 0.00 |
| No existe | NULL |
| Con 2 eventos | 11000.00 |
| Con 3 eventos, uno con el precio nuevo | 17600.00 |
