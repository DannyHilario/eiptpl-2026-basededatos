# Conceptos básicos de bases de datos

## ¿Qué es una base de datos?

Una **base de datos** es una colección de datos organizados y relacionados entre sí, guardados de forma que se puedan consultar, agregar, modificar y eliminar fácilmente.

Ejemplos de la vida diaria:

- El control de alumnos de una escuela: nombre, matrícula, grupo, turno.
- El inventario de una tienda: productos, precios, existencias.
- Las reservaciones de un hotel: huéspedes, habitaciones, fechas.

Sin una base de datos, esa información vive en cuadernos u hojas de cálculo, donde es fácil repetirla, perderla o contradecirla.

---

## ¿Qué es un SGBD?

Un **SGBD** (Sistema Gestor de Base de Datos; en inglés **DBMS**, *Database Management System*) es el programa que permite **crear** bases de datos, **mantener** su información y **consultarla**.

Es común confundir la base de datos con el SGBD:

| Concepto | Qué es | Ejemplo |
|----------|--------|---------|
| **Base de datos** | Los datos organizados | `HospitalDB`, con sus pacientes y consultas |
| **SGBD** | El programa que la administra | Microsoft SQL Server, MySQL, PostgreSQL, Oracle, Access |

En este curso el SGBD es **Microsoft SQL Server**.

---

## Ventajas y desventajas

| Ventajas | Desventajas |
|----------|-------------|
| **Menos redundancia:** cada dato se guarda una sola vez | Requiere **personal capacitado** para diseñarla y administrarla |
| **Integridad:** reglas que impiden datos inválidos | Puede requerir **hardware adicional** (servidores, memoria, disco) |
| **Seguridad:** cada usuario ve y modifica solo lo que le corresponde | **Costo inicial** alto en software, equipo y personal |
| **Independencia física:** dónde se guardan los datos (servidor local o nube) no cambia cómo se consultan | |

---

## Tabla, campo y registro

En una base de datos relacional, toda la información se guarda en **tablas**.

```
                          Tabla: Cliente
            ┌───────────┬──────────────────────┬────────────┐
            │ idCliente │ Nombre               │ Telefono   │  ← campos (columnas)
            ├───────────┼──────────────────────┼────────────┤
registro →  │ 1         │ Marcela Rivas Ochoa  │ 8115550101 │
            │ 2         │ Tomás Garza Leal     │ 8115550102 │
            └───────────┴──────────────────────┴────────────┘
```

| Concepto | También se llama | Qué es |
|----------|------------------|--------|
| **Tabla** | Relación, entidad | Conjunto de registros sobre un mismo tema (clientes, pedidos) |
| **Campo** | Columna, atributo | Un dato específico, con nombre y tipo (`Nombre`, `Telefono`) |
| **Registro** | Fila, tupla | Toda la información de un elemento (un cliente) |

---

## Base de datos plana y base de datos relacional

### Base de datos plana

Guarda todo en **una sola tabla**. Funciona para un directorio telefónico, pero no para un negocio con varias cosas que registrar.

Imagina un consultorio que anota cada visita en una sola tabla:

| Fecha | Paciente | Dirección | Diagnóstico | Médico |
|-------|----------|-----------|-------------|--------|
| 2026-01-06 | Pedro Cabrera | C. Mayor 12 | Gripe | Dra. Sanz |
| 2026-02-14 | Ana García | Av. Arroyos 54 | Sinusitis | Dr. Pérez |
| 2026-03-02 | Pedro Cabrera | C. Mayor 12 | Fractura | Dr. Alonso |

Cada vez que Pedro regresa, su dirección se **vuelve a escribir**. Con cientos de pacientes, la tabla se llena de datos repetidos, y si Pedro se cambia de casa hay que corregir **todas** sus filas.

### Base de datos relacional

Separa la información en **varias tablas**, y las une por un **campo en común**:

```
   Paciente                         Visita
┌────────────┬───────────────┐    ┌────────────┬────────────┬─────────────┐
│ idPaciente │ Nombre        │    │ Fecha      │ idPaciente │ Diagnóstico │
├────────────┼───────────────┤    ├────────────┼────────────┼─────────────┤
│ 1          │ Pedro Cabrera │◄───│ 2026-01-06 │ 1          │ Gripe       │
│ 2          │ Ana García    │    │ 2026-03-02 │ 1          │ Fractura    │
└────────────┴───────────────┘    └────────────┴────────────┴─────────────┘
```

Ahora la dirección de Pedro se guarda **una sola vez**; cada visita solo anota su `idPaciente`.

Una base de datos relacional cumple estas reglas:

- Generalmente tiene **muchas tablas**.
- Cada tabla tiene un número **fijo** de campos, con nombres distintos.
- Cada registro es **único**: lo identifica su **llave primaria** (ver [Los tres tipos de llaves](03-TiposDeClaves.md)).

---

## Modelos de datos

Un **modelo de datos** es la forma en que un tipo de base de datos organiza su información. El manual del curso menciona varios:

| Modelo | Cómo organiza los datos |
|--------|-------------------------|
| **Plano** | Una sola tabla con filas y columnas |
| **Jerárquico** | Un árbol: cada registro tiene un solo "padre", como las carpetas de Windows |
| **De red** | Registros unidos por enlaces; un registro puede tener varios "padres" |
| **Relacional** | Tablas relacionadas por campos en común |
| **Entidad-Relación** | Un modelo **conceptual** para diseñar: entidades, atributos y relaciones (ver [Modelo Entidad-Relación](05-ModeloEntidadRelacion.md)) |

En este curso trabajamos con el **modelo relacional**, y usamos el **Entidad-Relación** para diseñar antes de crear las tablas.

---

## Resumen

| Concepto | En una frase |
|----------|--------------|
| Base de datos | Datos organizados y relacionados |
| SGBD | El programa que administra la base de datos (SQL Server) |
| Tabla / campo / registro | El tema / el dato / el elemento |
| BD plana | Una sola tabla: repite información |
| BD relacional | Varias tablas unidas por campos en común: cada dato se guarda una vez |
