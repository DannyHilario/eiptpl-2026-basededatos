# Guía rápida de dbdiagram.io

[dbdiagram.io](https://dbdiagram.io) es una página web gratuita para dibujar modelos relacionales **escribiendo texto**: describes las tablas y él dibuja el diagrama. Es la herramienta que se usa para el modelo relacional del PDF de la Evidencia Integral.

No necesitas instalar nada. Puedes usarlo sin cuenta; con una cuenta gratuita además puedes guardar tus diagramas.

---

## Cómo se ve

A la izquierda escribes el código; a la derecha aparece el diagrama, que se actualiza solo.

```
┌──────────────────────────┬───────────────────────────────────┐
│ Table Paciente {         │   ┌─────────────┐                 │
│   idPaciente int [pk]    │   │ Paciente    │                 │
│   Nombre varchar(100)    │   ├─────────────┤                 │
│ }                        │   │ idPaciente  │                 │
│                          │   │ Nombre      │                 │
│      (código)            │   └─────────────┘  (diagrama)     │
└──────────────────────────┴───────────────────────────────────┘
```

---

## Una tabla

```
Table Dentista {
  idDentista int [pk, increment]
  Nombre varchar(100) [not null]
  Cedula varchar(20) [not null, unique]
  Activo bit [not null, default: 1]
}
```

| Escribes | Significa | En SQL Server |
|----------|-----------|---------------|
| `Table Dentista { … }` | Una tabla | `CREATE TABLE Dentista (…)` |
| `Nombre varchar(100)` | Columna y su tipo | `Nombre VARCHAR(100)` |
| `[pk]` | Llave primaria | `PRIMARY KEY` |
| `[increment]` | Se numera solo | `IDENTITY(1,1)` |
| `[not null]` | Obligatoria | `NOT NULL` |
| `[unique]` | No se repite | `UNIQUE` |
| `[default: 1]` | Valor por omisión | `DEFAULT 1` |

Varios ajustes van juntos, separados por comas, dentro de los mismos corchetes: `[pk, increment]`.

---

## Llaves foráneas y relaciones

En la columna que es llave foránea se agrega `ref: >` seguido de `Tabla.columna` a la que apunta:

```
Table Cita {
  idCita int [pk, increment]
  idPaciente int [not null, ref: > Paciente.idPaciente]
  idDentista int [not null, ref: > Dentista.idDentista]
  FechaCita date [not null]
}
```

El signo `>` se lee "muchos a uno": **muchas** citas apuntan a **un** paciente. El diagrama dibuja la línea entre las dos tablas.

| Signo | Relación |
|-------|----------|
| `>` | Muchos a uno (el más común: la llave foránea apunta a la llave primaria) |
| `-` | Uno a uno |

---

## Restricciones CHECK

dbdiagram.io no dibuja `CHECK`. Para que quede a la vista en el diagrama, anótalo como nota de la columna:

```
CostoCobrado decimal(10,2) [not null, note: 'CHECK (CostoCobrado > 0)']
```

---

## Exportar el diagrama

1. Revisa que no haya errores: si el código tiene un error, aparece marcado en rojo y el diagrama no se actualiza.
2. Acomoda las tablas arrastrándolas, para que ninguna línea quede encimada.
3. Usa la opción **Export** del menú y elige **PNG** (o PDF).
4. Pega la imagen en el punto **1. Modelo relacional** de tu PDF.

> El diagrama debe coincidir **exactamente** con tus scripts `CREATE TABLE`: las mismas tablas, columnas, tipos y llaves.

---

## Errores comunes

| Error | Cómo se ve | Solución |
|-------|------------|----------|
| La tabla referenciada no existe o tiene otro nombre | `ref: > Pacientes.idPaciente` marcado en rojo | Usa el nombre exacto: `Paciente` |
| Falta cerrar una llave `}` | Todo el código siguiente marcado en rojo | Cierra cada `Table { … }` |
| Dos tablas con el mismo nombre | Error de nombre duplicado | Cada tabla, un nombre único |
