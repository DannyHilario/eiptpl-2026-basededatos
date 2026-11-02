# PIA MudaFacil — Objeto 07 de 11: `ufn_totalCobradoPaquete`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Función escalar `ufn_totalCobradoPaquete`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** saber cuánto se ha cobrado en total por cada paquete, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un paquete es la **suma del precio cobrado** de todas sus mudanzas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El paquete tiene mudanzas | La suma de lo cobrado |
| El paquete existe pero no tiene mudanzas | `0.00` |
| El paquete no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoPaquete` que reciba el nombre de un paquete y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombrePaquete` | `varchar(30)` | Nombre del paquete |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoPaquete` y recibe `@p_NombrePaquete varchar(30)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un paquete con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada mudanza, no el precio actual).
- [ ] Si el paquete existe pero no tiene mudanzas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarPaquete`](03-procedimiento-usp_insertarPaquete.md), [`usp_actualizarPrecioPaquete`](04-procedimiento-usp_actualizarPrecioPaquete.md), [`usp_registrarMudanza`](05-procedimiento-usp_registrarMudanza.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: un paquete nuevo, 'Paquete de Prueba' ($1,800.00)
EXEC usp_insertarPaquete @p_Nombre = 'Paquete de Prueba', @p_CapacidadToneladas = 2.0, @p_Precio = 1800.00

-- Sin mudanzas: 0.00
SELECT dbo.ufn_totalCobradoPaquete('Paquete de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoPaquete('NoExiste') AS TotalCobrado
EXEC usp_registrarMudanza @p_NombrePaquete = 'Paquete de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-01', @p_Cargadores = 3
EXEC usp_registrarMudanza @p_NombrePaquete = 'Paquete de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-02', @p_Cargadores = 2

-- Dos mudanzas: 3600.00
SELECT dbo.ufn_totalCobradoPaquete('Paquete de Prueba') AS TotalCobrado

-- Sube el precio a $2,160.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Paquete de Prueba', @p_PrecioNuevo = 2160.00
EXEC usp_registrarMudanza @p_NombrePaquete = 'Paquete de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-03', @p_Cargadores = 4

-- Tres mudanzas: 5760.00
SELECT dbo.ufn_totalCobradoPaquete('Paquete de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Paquete de Prueba' sin mudanzas | 0.00 |
| No existe | NULL |
| Con 2 mudanzas | 3600.00 |
| Con 3 mudanzas, una con el precio nuevo | 5760.00 |
