# Los tres tipos de llaves

Las **llaves** (el manual también las llama **claves**) son las columnas que identifican registros y que unen una tabla con otra. Hay tres tipos.

---

## Llave primaria (PRIMARY KEY)

Es la columna, o grupo de columnas, que **identifica de forma única** a cada registro de una tabla.

- **Nunca** se repite.
- **Nunca** está vacía (`NULL`).
- Cada tabla tiene **una sola** llave primaria.

```
   Cliente
┌───────────┬──────────────────────┐
│ idCliente │ Nombre               │
├───────────┼──────────────────────┤
│ 1         │ Marcela Rivas Ochoa  │   ← idCliente = 1 identifica a Marcela
│ 2         │ Tomás Garza Leal     │      y solo a ella
└───────────┴──────────────────────┘
```

En el curso, la llave primaria es una columna `id` + nombre de la tabla (`idCliente`), numerada automáticamente con `IDENTITY` (ver [Constraints](../Etapa-3/04-Constraints.md)).

> ¿Por qué no usar el nombre o el teléfono como llave primaria? Porque pueden repetirse o cambiar. Un número que no significa nada fuera de la base de datos nunca cambia. El teléfono puede ser **único** (`UNIQUE`) sin ser la llave primaria.

---

## Llave foránea (FOREIGN KEY)

El manual la llama **clave externa**. Es una columna de una tabla que **guarda la llave primaria de otra tabla**. Es lo que une dos tablas.

```
   Sucursal                         Cliente
┌────────────┬────────────────┐   ┌───────────┬─────────────────┬────────────┐
│ idSucursal │ Nombre         │   │ idCliente │ Nombre          │ idSucursal │
├────────────┼────────────────┤   ├───────────┼─────────────────┼────────────┤
│ 1          │ LE Centro      │◄──│ 1         │ Marcela Rivas   │ 1          │
│ 2          │ LE Cumbres     │   │ 2         │ Tomás Garza     │ 1          │
└────────────┴────────────────┘   └───────────┴─────────────────┴────────────┘
   llave primaria                                          llave foránea
```

`Cliente.idSucursal` solo acepta valores que existan en `Sucursal.idSucursal`: no se puede registrar un cliente en una sucursal que no existe.

---

## Llave compuesta

A veces **una sola columna no basta** para identificar un registro, pero la **combinación** de dos o más sí. Esa combinación es una llave compuesta, y también puede ser la llave primaria de la tabla.

Ejemplo: una tabla que registra en qué materias está inscrito cada alumno.

| idAlumno | idMateria | Calificacion |
|----------|-----------|--------------|
| 1 | 10 | 95 |
| 1 | 11 | 88 |
| 2 | 10 | 76 |

- `idAlumno` se repite (el alumno 1 está en dos materias).
- `idMateria` se repite (la materia 10 tiene dos alumnos).
- La **pareja** `(idAlumno, idMateria)` **no** se repite: un alumno no se inscribe dos veces a la misma materia.

```sql
CREATE TABLE AlumnoMateria (
    idAlumno INT NOT NULL,
    idMateria INT NOT NULL,
    Calificacion INT NOT NULL,
    PRIMARY KEY (idAlumno, idMateria)
);
```

> Cuando la pareja **sí** puede repetirse (un paciente consulta al mismo médico varias veces, en días distintos), la llave compuesta no sirve: esa tabla lleva su propia llave primaria (`idConsulta`). Ver [Del negocio al modelo](07-DelNegocioAlModelo.md).

---

## Resumen

| Llave | Qué hace | ¿Se repite? |
|-------|----------|-------------|
| **Primaria** | Identifica cada registro de su tabla | No |
| **Foránea** | Guarda la llave primaria de otra tabla para unirlas | Sí: varios clientes en la misma sucursal |
| **Compuesta** | Varias columnas que **juntas** identifican un registro | Cada columna sí; la combinación no |
