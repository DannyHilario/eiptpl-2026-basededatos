# PIA ImprimeYa — Objeto 06 de 11: `usp_obtenerPedidosPorFecha`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerPedidosPorFecha`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** ver los pedidos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los pedidos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerPedidosPorFecha` que valide el rango y regrese los pedidos.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_FechaInicio` | `date` | Primer día del rango |
| `@p_FechaFin` | `date` | Último día del rango |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La fecha inicial no es posterior a la final | `000001` | La fecha inicial es posterior a la fecha final |

**Columnas del resultado**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaPedido` | Fecha del pedido |
| `Producto` | Producto |
| `Cliente` | Nombre del cliente |
| `Paquetes` | Paquetes |
| `PrecioCobrado` | Precio con el que se cobró el pedido |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerPedidosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaPedido` y, en un mismo día, por `Producto`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerPedidosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaPedido | Producto | Cliente | Paquetes | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Tarjetas de presentación | Negocio de Prueba | 3 | 250.00 |
| 2026-12-02 | Menús enmicados | Negocio de Prueba | 2 | 380.00 |
| 2026-12-02 | Volantes media carta | Negocio de Prueba | 1 | 450.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPedido`](05-procedimiento-usp_registrarPedido.md).

```sql
-- Preparación: el cliente de prueba y tres pedidos de diciembre, registrados en desorden
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPedido @p_NombreProducto = 'Menús enmicados', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 2
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 3
EXEC usp_registrarPedido @p_NombreProducto = 'Volantes media carta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerPedidosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerPedidosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerPedidosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerPedidosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
