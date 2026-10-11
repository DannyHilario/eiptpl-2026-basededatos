# El Modelo Relacional

## ¿Qué es el modelo relacional?

El modelo relacional organiza los datos en tablas separadas, cada una con una responsabilidad clara, y las conecta mediante llaves. Esta separación evita que la misma información se repita en múltiples lugares.

En el [modelo Entidad-Relación](05-ModeloEntidadRelacion.md) dibujamos entidades y relaciones. El modelo relacional las convierte en **tablas** unidas por llaves. Cómo se escribe esa llave foránea en SQL Server se ve en [Constraints](../Etapa-3/04-Constraints.md).

---

## Llave primaria y llave foránea en contexto

Cuando dos tablas se relacionan:

- La tabla **padre** expone su `PRIMARY KEY`
- La tabla **hijo** guarda esa llave como `FOREIGN KEY`

```
Tabla padre                    Tabla hijo
+------------------+           +----------------------+
| Carrera          |           | Alumno               |
+------------------+           +----------------------+
| idCarrera (PK)   |<----------| idCarrera (FK)       |
| Nombre           |           | idAlumno (PK)        |
+------------------+           | Nombre               |
                               +----------------------+
```

`Alumno` guarda `idCarrera` para saber a qué carrera pertenece, sin necesidad de repetir el nombre de la carrera en cada fila.

---

## Tipos de relaciones

### Uno a muchos (1:N)

Es la relación más común. Un registro de la tabla padre puede estar relacionado con muchos registros de la tabla hijo, pero cada registro hijo pertenece a un solo padre.

**Ejemplo:** Una carrera tiene muchos alumnos, pero cada alumno pertenece a una sola carrera.

```
Carrera                        Alumno
+------------------+           +----------------------+
| idCarrera = 1    |<----+-----| idCarrera = 1        |
| Nombre = ISC     |     |     | Nombre = Carlos      |
+------------------+     |     +----------------------+
                         |     +----------------------+
                         +-----| idCarrera = 1        |
                               | Nombre = Ana         |
                               +----------------------+
                               +----------------------+
                         +-----| idCarrera = 1        |
                               | Nombre = Luis        |
                               +----------------------+
```

La `FOREIGN KEY` siempre vive en el lado "muchos" de la relación (en `Alumno`).

---

### Uno a uno (1:1)

Un registro de la tabla A se relaciona con exactamente un registro de la tabla B, y viceversa. Se usa cuando se quiere separar información que conceptualmente pertenece a la misma entidad pero que no siempre es necesaria consultar.

**Ejemplo:** Un alumno tiene un único expediente académico.

```
Alumno                         Expediente
+------------------+           +----------------------+
| idAlumno (PK)   |<----------| idAlumno (FK, UNIQUE) |
| Nombre           |           | Promedio             |
+------------------+           | FechaIngreso         |
                               +----------------------+
```

La `FOREIGN KEY` en `Expediente` lleva además `UNIQUE` para garantizar que ningún expediente se repita.

---

### Muchos a muchos (N:M)

Un registro de la tabla A puede relacionarse con muchos de la tabla B, y un registro de B puede relacionarse con muchos de A. Este tipo de relación **no se puede representar directamente** con una sola `FOREIGN KEY`; requiere una tabla intermedia.

**Ejemplo:** Un alumno puede inscribirse en muchas materias, y una materia puede tener muchos alumnos inscritos.

```
Alumno                 AlumnoMateria               Materia
+-----------+          +----------------+          +------------+
| idAlumno  |<---------| idAlumno (FK)  |          | idMateria  |
| Nombre    |          | idMateria (FK) |--------->| Nombre     |
+-----------+          | Calificacion   |          +------------+
                       +----------------+
```

La tabla intermedia (`AlumnoMateria`) tiene una `FOREIGN KEY` hacia cada una de las dos tablas. Su llave primaria generalmente es la combinación de ambas llaves foráneas.

---

## ¿Cómo identificar el tipo de relación?

Hazte estas dos preguntas:

| Pregunta | Respuesta |
|----------|-----------|
| ¿Un alumno puede tener varias carreras? | No → la FK va en Alumno |
| ¿Una carrera puede tener varios alumnos? | Sí → es una relación 1:N |

Si la respuesta a ambas preguntas es "sí", es una relación N:M y necesitas tabla intermedia.

---

## El orden importa

Al crear tablas relacionadas en SQL Server, siempre crea primero la tabla padre (la que tiene la `PRIMARY KEY` referenciada) y después la tabla hijo (la que tiene la `FOREIGN KEY`).

Al insertar datos, el mismo principio aplica: primero los registros del padre, después los del hijo. No puedes insertar un alumno con `idCarrera = 3` si la carrera 3 todavía no existe.
