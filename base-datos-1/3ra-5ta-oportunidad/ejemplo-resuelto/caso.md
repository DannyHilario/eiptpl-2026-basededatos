# Ejemplo resuelto — Caso: LavaExpress

**Este caso no está asignado a ningún alumno.** Es el enunciado del [ejemplo resuelto](README.md): tiene exactamente el mismo formato que tu caso, para que compares lo que recibes con lo que se espera que entregues.

**Base de datos a crear:** `LavaExpressDB`

← [Regresar a la descripción de la evidencia](../descripcion-evidencia-integral.md)

---

## Historia de usuario

**Como** dueña de LavaExpress, **quiero** una base de datos que registre a mis clientes, mis servicios y cada pedido que dejan, **para** saber cuánta ropa recibe cada sucursal, qué servicios se piden más y qué clientes registrados nunca han regresado.

## El negocio

LavaExpress es una lavandería con varias **sucursales** en la ciudad. Cada sucursal tiene un nombre que no se repite y una dirección.

Ofrece distintos **tipos de servicio**: Lavado, Lavado y planchado, Planchado, Tintorería y Edredones. Cada servicio se cobra **por kilo**, y cada uno tiene su propio precio por kilo. **Los precios cambian** de vez en cuando. Aun así, el negocio necesita saber **cuánto se cobró en cada pedido**, con el precio que tenía el servicio el día del pedido.

Los **clientes** se registran una sola vez, en la sucursal a la que llegan por primera vez, con su nombre y su teléfono. El teléfono identifica al cliente: no puede haber dos clientes con el mismo. Cuando un cliente pide que ya no le manden promociones, se le **da de baja**, pero no se borra, para conservar sus pedidos.

## Lo que el negocio ya tiene definido

Estos datos **no los inventas**: son los que LavaExpress ya tiene. Tu base de datos debe guardarlos **exactamente así**, con los mismos nombres y valores.

**Sucursales**

| Sucursal | Dirección |
|---|---|
| LavaExpress Centro | Av. Juárez 820, Col. Centro, Monterrey, N.L. |
| LavaExpress Cumbres | Av. Paseo de los Leones 2150, Col. Cumbres, Monterrey, N.L. |
| LavaExpress Linda Vista | Av. Benito Juárez 1340, Col. Linda Vista, Guadalupe, N.L. |

**Servicios y precios por kilo**

| Servicio | Precio por kilo |
|---|---|
| Lavado | $28.00 |
| Lavado y planchado | $45.00 |
| Planchado | $35.00 |
| Tintorería | $80.00 |
| Edredones | $60.00 |

Todo lo demás (clientes y pedidos) **lo inventas tú**, cumpliendo los mínimos de [Lo que debes construir](#lo-que-debes-construir).

## Flujo de negocio

Así funciona una operación de principio a fin. Arriba, lo que pasa en la lavandería; abajo, la información que cada paso consulta o registra.

> En tu caso, este diagrama describe la **información** con palabras del negocio. Aquí, por ser el ejemplo resuelto, ya muestra las tablas de la solución.

![Flujo de negocio de LavaExpress](assets/flujo-negocio.png)

Con detalle, una clienta imaginaria (Marcela) recorriendo el flujo:

1. **Marcela llega por primera vez** a LavaExpress Centro. En mostrador le piden su nombre y su teléfono, y la **registran como clienta** de esa sucursal. Si Marcela regresa otro día, ya no se le registra de nuevo: se le busca por su teléfono.
2. **Marcela entrega una bolsa de ropa** y pide "Lavado y planchado". El encargado revisa el **precio por kilo vigente** de ese servicio: hoy, $45.00.
3. **Se pesa la ropa**: 6.4 kilos. Se **registra el pedido**: clienta Marcela, servicio Lavado y planchado, fecha de hoy, 6.4 kilos y el precio por kilo con el que se le cobra ($45.00).
4. **Cuando Marcela recoge su ropa**, se le cobra: kilos × el precio por kilo **guardado en su pedido**. La entrega no se registra en la base de datos.

Si el mes siguiente el Lavado y planchado sube a $50.00, el pedido de Marcela tiene que seguir diciendo que se le cobró a $45.00.

La semana siguiente, Marcela deja un saco para Tintorería: es otro pedido, de la misma clienta y de otro servicio. Así, **un cliente acumula muchos pedidos y un servicio también**.

## Reglas de negocio

- Cada cliente se registra en **una sola** sucursal.
- No puede haber dos sucursales con el mismo nombre, ni dos tipos de servicio con el mismo nombre.
- No puede haber dos clientes con el mismo teléfono.
- El precio por kilo y los kilos siempre son **mayores a cero**.
- Cuando cambia el precio de un servicio, los pedidos que ya se hicieron **conservan el precio con el que se cobraron**.
- Un cliente nuevo se registra como **activo**.

## Lo que debes construir

1. El **modelo relacional**, con al menos 4 tablas, que guarde toda la información de arriba y respete las reglas de negocio con restricciones (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT`).
2. El **paquete de instalación** y el **paquete de reversa** de `LavaExpressDB`.
3. **Datos iniciales:**
   - **Lo que el negocio ya tiene definido**, exactamente como viene arriba: las 3 sucursales y los 5 servicios con su precio por kilo.
   - **Lo que tú inventas**, como mínimo: 10 clientes y 20 pedidos, con
     - 2 clientes que nunca hayan hecho un pedido;
     - 1 servicio que nunca se haya solicitado;
     - al menos 1 cliente dado de baja;
     - cada pedido con el precio por kilo con el que se cobró (en tus datos, el precio del servicio que viene arriba);
     - pedidos en marzo de 2026;
     - clientes cuyo nombre comience con M.
4. **Las 10 consultas** de abajo.

## Consultas

| # | Pregunta del negocio |
|---|---|
| 1 | Lista los pedidos de más de 5 kilos, ordenados del más pesado al más ligero. |
| 2 | Lista los clientes activos, del más antiguo al más reciente según su fecha de registro. |
| 3 | Lista los clientes cuyo nombre comienza con la letra M. |
| 4 | Lista los pedidos realizados en marzo de 2026, ordenados por fecha. |
| 5 | Muestra los 5 pedidos con más kilos. |
| 6 | Muestra cada cliente con el nombre de la sucursal donde se registró. |
| 7 | Muestra cada pedido con el tipo de servicio, el precio por kilo cobrado y el precio por kilo actual del servicio. |
| 8 | Muestra cada pedido con el nombre del cliente, el tipo de servicio, los kilos y el precio por kilo cobrado. |
| 9 | Lista los clientes que nunca han hecho un pedido. |
| 10 | Lista los tipos de servicio que nunca se han solicitado. |

---

**Siguiente:** ver la [solución](README.md).
