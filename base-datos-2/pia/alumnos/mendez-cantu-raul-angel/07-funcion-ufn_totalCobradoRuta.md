# PIA RutaNorte — Objeto 07 de 11: `ufn_totalCobradoRuta`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Función escalar `ufn_totalCobradoRuta`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** saber cuánto se ha cobrado en total por cada ruta, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una ruta es la **suma del precio cobrado** de todas sus boletos, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La ruta tiene boletos | La suma de lo cobrado |
| La ruta existe pero no tiene boletos | `0.00` |
| La ruta no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoRuta` que reciba la clave de una ruta y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_ClaveRuta` | `varchar(10)` | Clave de la ruta |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoRuta` y recibe `@p_ClaveRuta varchar(10)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una ruta con esa clave, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada boleto, no el precio actual).
- [ ] Si la ruta existe pero no tiene boletos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_insertarRuta`](03-procedimiento-usp_insertarRuta.md), [`usp_actualizarPrecioRuta`](04-procedimiento-usp_actualizarPrecioRuta.md), [`usp_registrarBoleto`](05-procedimiento-usp_registrarBoleto.md).

```sql
-- Preparación: el pasajero de prueba
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: una ruta nueva, 'MTY-ZAC' ($180.00)
EXEC usp_insertarRuta @p_Clave = 'MTY-ZAC', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 6, @p_Precio = 180.00

-- Sin boletos: 0.00
SELECT dbo.ufn_totalCobradoRuta('MTY-ZAC') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoRuta('NoExiste') AS TotalCobrado
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-ZAC', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-ZAC', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 20

-- Dos boletos: 360.00
SELECT dbo.ufn_totalCobradoRuta('MTY-ZAC') AS TotalCobrado

-- Sube el precio a $220.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-ZAC', @p_PrecioNuevo = 220.00
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-ZAC', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-03', @p_Asiento = 5

-- Tres boletos: 580.00
SELECT dbo.ufn_totalCobradoRuta('MTY-ZAC') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'MTY-ZAC' sin boletos | 0.00 |
| No existe | NULL |
| Con 2 boletos | 360.00 |
| Con 3 boletos, uno con el precio nuevo | 580.00 |
