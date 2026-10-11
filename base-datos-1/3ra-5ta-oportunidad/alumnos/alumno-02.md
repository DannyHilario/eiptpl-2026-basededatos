# Evidencia Integral — Caso: FitZone

**Alumno:** Alumno 2
**Base de datos a crear:** `FitZoneDB`

← [Regresar a la descripción de la evidencia](../descripcion-evidencia-integral.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** una base de datos que registre a mis socios, mis clases grupales y cada vez que un socio toma una clase, **para** saber qué clases se toman más, cuánto se cobró por ellas y qué socios inscritos nunca han tomado una clase.

## El negocio

FitZone es un gimnasio. Vende **membresías mensuales** de tres tipos: Básica, Plus y Premium. Cada tipo de membresía tiene su **costo mensual**, que da acceso al área de pesas y cardio.

Además, FitZone ofrece **clases grupales**, como Spinning, Yoga o Box. Cada clase tiene un nombre que no se repite, un **instructor** y un **cupo máximo** de personas. Las clases **no están incluidas en la membresía**: se pagan aparte, **por clase**, y el **precio por clase depende de la membresía del socio**; quien paga una membresía más cara, paga menos por cada clase. **Los precios por clase cambian**: el 1 de abril de 2026 subieron los de dos membresías. Aun así, el negocio necesita saber **cuánto se cobró cada vez que un socio tomó una clase**, con el precio que tenía su membresía ese día.

Los **socios** se inscriben una sola vez, con un tipo de membresía, su nombre, su correo electrónico y la fecha de inscripción. El correo identifica al socio en recepción: no puede haber dos socios con el mismo. Cuando un socio cancela su membresía, se le **da de baja**, pero no se borra, para conservar su historial de clases.

## Lo que el negocio ya tiene definido

Estos datos **no los inventas**: son los que FitZone ya tiene. Tu base de datos debe guardarlos **exactamente así**, con los mismos nombres y valores.

**Tipos de membresía, costo mensual y precio por clase**

El **1 de abril de 2026** subió el precio por clase de las membresías Básica y Plus. El de Premium no cambió. El costo mensual de las tres tampoco cambió.

| Membresía | Costo mensual | Precio por clase actual (desde el 1 de abril de 2026) | Precio por clase anterior (hasta el 31 de marzo de 2026) |
|---|---|---|---|
| Básica | $450.00 | $100.00 | $90.00 |
| Plus | $650.00 | $80.00 | $70.00 |
| Premium | $900.00 | $60.00 | $60.00 |

Todo lo demás (clases, socios y clases tomadas) **lo inventas tú**, cumpliendo los mínimos de [Lo que debes construir](#lo-que-debes-construir).

## Flujo de negocio

Así funciona una operación de principio a fin. Arriba, lo que pasa en el gimnasio; abajo, la información que cada paso consulta o registra.

![Flujo de negocio de FitZone](assets/alumno-02/flujo-negocio.png)

Con detalle, una socia imaginaria (Andrea) recorriendo el flujo:

1. **Andrea llega por primera vez** a FitZone y contrata la membresía Plus. En recepción le piden su nombre y su correo, y la **inscriben como socia** con esa membresía y la fecha de hoy. Si Andrea regresa otro día, ya no se le inscribe de nuevo: se le busca por su correo.
2. **Andrea quiere tomar Spinning.** La recepcionista revisa la clase: quién la imparte y cuál es su cupo.
3. **Se registra la asistencia.** La recepcionista revisa el **precio por clase vigente** de la membresía de Andrea (Plus): hoy, $80.00. Registra la asistencia: socia Andrea, clase Spinning, fecha de hoy y el precio con el que se le cobra ($80.00). Andrea paga la clase.
4. **Andrea toma la clase** con su instructor. Lo que pasa dentro de la clase no se registra en la base de datos.

Si el mes siguiente el precio por clase de Plus sube a $85.00, la asistencia de Andrea tiene que seguir diciendo que se le cobró a $80.00. Y si Andrea se cambia después a Premium, sus asistencias anteriores también conservan lo que pagó.

Dos días después, Andrea toma Yoga: es otra asistencia, de la misma socia y de otra clase. Ese mismo día, otros socios toman Spinning. Así, **un socio acumula muchas asistencias y una clase también**.

## Reglas de negocio

- Cada socio tiene **un solo** tipo de membresía.
- No puede haber dos tipos de membresía con el mismo nombre, ni dos clases con el mismo nombre.
- No puede haber dos socios con el mismo correo electrónico.
- El costo mensual, el precio por clase y el cupo máximo de una clase siempre son **mayores a cero**.
- Cuando cambia el precio por clase de una membresía, las asistencias que ya se registraron **conservan el precio con el que se cobraron**.
- Un socio nuevo se registra como **activo**.

## Lo que debes construir

1. El **modelo relacional**, con al menos 4 tablas, que guarde toda la información de arriba y respete las reglas de negocio con restricciones (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT`).
2. El **paquete de instalación** y el **paquete de reversa** de `FitZoneDB`.
3. **Datos iniciales:**
   - **Lo que el negocio ya tiene definido**, exactamente como viene arriba: los 3 tipos de membresía con su costo mensual y su **precio por clase actual**.
   - **Lo que tú inventas**, como mínimo: 8 clases, 10 socios y 20 asistencias, con
     - socios de los tres tipos de membresía;
     - clases con cupo máximo mayor a 15 personas;
     - 2 socios que nunca hayan tomado una clase;
     - 2 clases que nunca se hayan tomado;
     - al menos 1 socio dado de baja;
     - asistencias antes **y** después del 1 de abril de 2026, de socios de las tres membresías: cada asistencia se cobra con el precio por clase que tenía la membresía del socio **en la fecha de la asistencia** (precio anterior hasta el 31 de marzo, precio actual desde el 1 de abril);
     - asistencias en marzo de 2026;
     - socios con correo `@gmail.com`.
4. **Las 10 consultas** de abajo.

## Consultas

| # | Pregunta del negocio |
|---|---|
| 1 | Lista las clases con cupo máximo mayor a 15 personas, ordenadas de mayor a menor cupo. |
| 2 | Lista los socios activos, del más antiguo al más reciente según su fecha de inscripción. |
| 3 | Lista los socios cuyo correo electrónico termina en `@gmail.com`. |
| 4 | Lista las asistencias de marzo de 2026, ordenadas por fecha. |
| 5 | Muestra las 5 clases con mayor cupo máximo. |
| 6 | Muestra cada socio con el nombre de su tipo de membresía, su costo mensual y su precio por clase actual. |
| 7 | Muestra las asistencias que se cobraron con un precio distinto al precio por clase actual de la membresía del socio, con el precio cobrado y el precio actual. |
| 8 | Muestra cada asistencia con el nombre del socio, el nombre de la clase, su instructor y el precio cobrado. |
| 9 | Lista los socios que nunca han tomado una clase. |
| 10 | Lista las clases que nunca se han tomado. |

## Entrega

Ver [Entregables](../descripcion-evidencia-integral.md#entregables) y [Forma de entrega](../descripcion-evidencia-integral.md#forma-de-entrega) en la descripción de la evidencia.
