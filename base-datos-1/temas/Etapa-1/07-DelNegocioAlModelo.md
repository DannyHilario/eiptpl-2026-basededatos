# Del negocio al modelo

Los temas anteriores explican **qué** es una tabla, una llave o una forma normal. Este tema explica **cómo** pasar de la descripción de un negocio a un modelo relacional, paso a paso. Es lo que haces en la Evidencia Integral.

Usaremos de ejemplo un consultorio dental.

> **Dental Sonrisa** atiende a pacientes con varios dentistas. Ofrece **tratamientos** (limpieza, resina, extracción), cada uno con su **costo**; los costos suben cada año. Cada **dentista** tiene su cédula profesional, que no se repite. Los **pacientes** se registran una sola vez con su nombre, su teléfono y su fecha de nacimiento. Cuando un paciente llega, se registra la **cita**: qué paciente, con qué dentista, qué tratamiento, la fecha y cuánto se le cobró. Si un dentista deja de trabajar en el consultorio, se le da de baja, pero no se borra, para conservar su historial de citas.

---

## Paso 1. Encuentra los sustantivos

Subraya las "cosas" de las que el negocio guarda información:

> … **pacientes** … **dentistas** … **tratamientos** … **costo** … **cédula** … **cita** … **fecha** …

Algunos sustantivos son **entidades** (tendrán su propia tabla) y otros son **atributos** (serán columnas). La pregunta para distinguirlos es:

> ¿El negocio guarda **varios datos** de esa cosa? Entonces es una entidad. ¿Es **un solo dato** de otra cosa? Entonces es un atributo.

| Sustantivo | ¿Entidad o atributo? | Por qué |
|------------|----------------------|---------|
| Paciente | Entidad | Tiene nombre, teléfono, fecha de nacimiento |
| Dentista | Entidad | Tiene nombre, cédula |
| Tratamiento | Entidad | Tiene nombre y costo |
| Cita | Entidad | Tiene paciente, dentista, tratamiento, fecha, costo cobrado |
| Cédula | Atributo de `Dentista` | Es un solo dato del dentista |
| Costo | Atributo de `Tratamiento`… **y** de `Cita` | Ver el paso 5 |

---

## Paso 2. Distingue catálogos, entidades y hechos

No todas las entidades son iguales:

| Tipo | Qué es | Cómo reconocerla | En el ejemplo |
|------|--------|------------------|---------------|
| **Catálogo** | Una lista que el negocio define y casi no cambia | "maneja **tipos** de…", "ofrece **servicios**…" | `Tratamiento` |
| **Entidad** | Personas o cosas que el negocio registra | "se registran", "tiene un número de…" | `Paciente`, `Dentista` |
| **Hechos** | Lo que **sucede** en el negocio, cada vez, con una fecha | Un **verbo**: "se registra la cita", "se vende", "se renta" | `Cita` |

Un **hecho** es algo que **sucede** en el negocio, en una fecha: una cita, una venta, una renta. La **tabla de hechos** tiene una fila por cada vez que algo sucede: es la que más crece y la **más importante** del modelo, porque guarda lo que realmente pasó. En otros libros también se le llama *operación* o *transacción*.

---

## Paso 3. Define las relaciones con la cardinalidad

Pregunta en los dos sentidos (ver [Modelo Entidad-Relación](05-ModeloEntidadRelacion.md)):

| Relación | Sentido 1 | Sentido 2 | Cardinalidad | La llave foránea va en |
|----------|-----------|-----------|--------------|------------------------|
| Paciente – Cita | Un paciente tiene **muchas** citas | Una cita es de **un** paciente | 1:N | `Cita` |
| Dentista – Cita | Un dentista atiende **muchas** citas | Una cita es con **un** dentista | 1:N | `Cita` |
| Tratamiento – Cita | Un tratamiento se aplica en **muchas** citas | Una cita es de **un** tratamiento | 1:N | `Cita` |

Fíjate: entre `Paciente` y `Dentista` hay una relación **N:M** (un paciente ve a varios dentistas y un dentista atiende a varios pacientes), y `Cita` es justamente su tabla intermedia.

---

## Paso 4. Convierte cada regla del negocio en una restricción

Cada frase del negocio que dice "no puede", "siempre", "al menos" o "se registra como" es una **restricción** que la base de datos debe hacer cumplir (ver [Constraints](../Etapa-3/04-Constraints.md)):

| Frase del negocio | Restricción |
|-------------------|-------------|
| "La cédula **no se repite**" | `UNIQUE` en `Dentista.Cedula` |
| "Cada cita es de **un** paciente" | `FOREIGN KEY` de `Cita` a `Paciente`, `NOT NULL` |
| "El costo **siempre es mayor a cero**" | `CHECK (Costo > 0)` |
| "Un dentista nuevo **se registra como activo**" | `DEFAULT 1` en `Dentista.Activo` |
| "Se le **da de baja, pero no se borra**" | Columna `Activo BIT`: la baja es `Activo = 0` (baja lógica), nunca un `DELETE` |
| "Una cita dura **al menos** 15 minutos y **como máximo** 3 horas" | `CHECK (Minutos BETWEEN 15 AND 180)` |

> Si una regla del caso no termina convertida en una restricción o en una columna, falta algo en tu modelo.

---

## Paso 5. Datos que cambian con el tiempo

> "… cada uno con su **costo**; los costos **suben cada año** … se registra la cita: … y **cuánto se le cobró**."

Aquí hay **dos costos distintos**:

| Dato | Dónde va | ¿Cambia? |
|------|----------|----------|
| El costo **actual** de la limpieza | `Tratamiento.Costo` | Sí, cada año |
| Lo que **se le cobró** a un paciente en una cita | `Cita.CostoCobrado` | **Nunca** |

Si `Cita` solo guardara `idTratamiento`, el costo se tomaría siempre de `Tratamiento`. Al subir el costo de la limpieza, **todas las citas anteriores** "costarían" el precio nuevo, y ya no se sabría cuánto pagó cada paciente.

Por eso, **al registrar la cita se copia el costo vigente** en `Cita.CostoCobrado`. No es redundancia: son dos datos diferentes que hoy coinciden y mañana no.

> **Regla:** cuando un dato puede cambiar (precio, tarifa, costo) y un hecho depende del valor que tenía **en el momento en que sucedió**, ese valor se copia en la tabla de hechos.

---

## Paso 6. Arma el modelo y revísalo

```
Tratamiento ──1────N── Cita ──N────1── Paciente
                        │
                        N
                        │
                        1
                     Dentista
```

| Tabla | Columnas | Llaves y restricciones |
|-------|----------|------------------------|
| `Tratamiento` | `idTratamiento`, `Nombre`, `Costo` | PK; `Nombre` UNIQUE; `Costo` CHECK > 0 |
| `Paciente` | `idPaciente`, `Nombre`, `Telefono`, `FechaNacimiento` | PK |
| `Dentista` | `idDentista`, `Nombre`, `Cedula`, `Activo` | PK; `Cedula` UNIQUE; `Activo` DEFAULT 1 |
| `Cita` | `idCita`, `idPaciente`, `idDentista`, `idTratamiento`, `FechaCita`, `Minutos`, `CostoCobrado` | PK; 3 FK; `Minutos` CHECK; `CostoCobrado` CHECK > 0 |

Antes de escribir SQL, revisa:

- [ ] Cada **sustantivo** con varios datos tiene su tabla.
- [ ] Cada **regla** del negocio quedó como restricción.
- [ ] Cada **pregunta** del negocio se puede responder con estas tablas.
- [ ] Ninguna tabla repite información de otra (está en 3FN; ver [Normalización](04-Normalizacion.md)).
- [ ] Los datos que cambian con el tiempo se copian en la tabla de hechos.

---

## Paso 7. Los datos iniciales

Una base de datos recién creada necesita datos para probarse. Hay dos tipos:

| Tipo | Ejemplo | Quién los define |
|------|---------|------------------|
| **Lo que el negocio ya tiene definido** | Los tratamientos que ofrece y sus costos | El negocio: se capturan **tal cual** |
| **Lo que ocurre día a día** | Pacientes, citas | Se inventan datos de prueba realistas |

Los datos inventados deben **cubrir todos los casos** que el negocio quiere consultar. Si una pregunta es "¿qué pacientes nunca han tenido una cita?", tiene que haber al menos un paciente sin citas; si no, la consulta no se puede comprobar.
