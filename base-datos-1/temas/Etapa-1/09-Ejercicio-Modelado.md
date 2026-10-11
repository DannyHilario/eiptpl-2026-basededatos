# Ejercicio 2: Modelado de base de datos

## Contexto

**HotelVista** es un hotel boutique que ofrece habitaciones de distintos tipos: sencilla, doble y suite. Cada tipo de habitación tiene un precio fijo por noche.

Actualmente, el hotel registra todas sus reservaciones en una hoja de cálculo donde cada fila representa una estadía. La hoja contiene la siguiente información en columnas:

> Número de habitación, tipo de habitación, precio por noche, ID del huésped, nombre completo del huésped, teléfono del huésped, correo electrónico del huésped, fecha de check-in, número de noches.

---

## El problema

El equipo de recepción ha notado las siguientes situaciones:

- Cuando un huésped regresa al hotel, toda su información personal se vuelve a capturar en una nueva fila, frecuentemente con pequeñas diferencias en el nombre o teléfono respecto a su visita anterior.
- Cuando el precio de un tipo de habitación cambia por temporada, es necesario actualizar manualmente cada fila histórica, lo que ha generado registros con precios contradictorios para el mismo tipo de habitación.
- Es imposible saber cuántos huéspedes únicos ha recibido el hotel sin revisar y limpiar duplicados a mano.

---

## Tu tarea

Con base en la información anterior, propón un modelo de base de datos relacional que elimine la redundancia y los problemas descritos.

Para cada tabla que identifiques, define:

- Nombre de la tabla
- Columnas con su tipo de dato
- Llave primaria
- Llaves foráneas, si aplica
- Constraints relevantes (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`)
