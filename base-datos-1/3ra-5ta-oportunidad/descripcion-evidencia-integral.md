# Evidencia Integral — Base de Datos I (3ra y 5ta oportunidad)

De manera **individual**, diseñarás e implementarás en Microsoft SQL Server la base de datos de un negocio pequeño. Cada alumno tiene **su propio caso de negocio**, distinto al de los demás; busca tu nombre en la tabla de abajo.

| Evaluación | Valor |
|------------|-------|
| **Evidencia Integral** (este documento) | **30%** |
| **Examen presencial escrito** | **70%** |

> **El examen presencial es sobre el contenido de tu Evidencia Integral.**
>
> **Entrega de la Evidencia Integral:** sábado 14 de noviembre de 2026, 10:00 p.m., en Teams. No hay entregas extemporáneas.
>
> **Fecha del examen:** sábado 21 de noviembre de 2026, 8:30 a.m. **Aula:** por asignar.

---

## Tu caso

Cada caso describe un negocio: qué hace, cómo funciona una operación de principio a fin (flujo de negocio), sus reglas y las 10 preguntas que el dueño quiere responder con la base de datos. **El caso no te dice qué tablas crear:** deducir el modelo a partir del negocio es parte de la evidencia.

| Alumno | Caso |
|--------|------|
| Almaguer Mireles Wisin Jesus | [BiciRuta — renta de bicicletas](alumnos/almaguer-mireles-wisin-jesus.md) |
| Alvarez Salazar Yadira Lizbeth | [FitZone — gimnasio](alumnos/alvarez-salazar-yadira-lizbeth.md) |
| Cuevas Catalan Jenifer Victoria | [SalaRock — salas de ensayo](alumnos/cuevas-catalan-jenifer-victoria.md) |
| De Luna Zul Christian Gael | [AsesorPro — asesorías escolares](alumnos/de-luna-zul-christian-gael.md) |
| Echazarreta Hernandez Kevin Joshua | [RutaNorte — autobuses foráneos](alumnos/echazarreta-hernandez-kevin-joshua.md) |
| Gomez Ordaz Bryan Omar | [VeloKart — pista de go-karts](alumnos/gomez-ordaz-bryan-omar.md) |
| Gonzalez Hernandez Iker Emmanuel | [EnigmaRoom — salas de escape](alumnos/gonzalez-hernandez-iker-emmanuel.md) |
| Guerrero Gutiérrez David | [GameZone — renta de consolas](alumnos/guerrero-gutierrez-david.md) |
| Hernandez Arreola Walter Daniel | [RecorreMTY — recorridos turísticos](alumnos/hernandez-arreola-walter-daniel.md) |
| Hernandez Juarez Brenda Ivonne | [CampoVerde — casas de campaña](alumnos/hernandez-juarez-brenda-ivonne.md) |
| Montoya Moreno Ana Valeria | [SpaZen — spa](alumnos/montoya-moreno-ana-valeria.md) |
| Morales Ordaz Alberto Alejandro | [DisfracesMil — renta de disfraces](alumnos/morales-ordaz-alberto-alejandro.md) |
| Morua Tello Said Lestat | [ImprimeYa — imprenta rápida](alumnos/morua-tello-said-lestat.md) |
| Mota Ortiz Raul Andres | [GuardaTodo — minibodegas](alumnos/mota-ortiz-raul-andres.md) |
| Perez Ruiz Jesus Alejandro | [VolanteSeguro — escuela de manejo](alumnos/perez-ruiz-jesus-alejandro.md) |
| Ramírez Palacios Debora Dayan | [EspacioUno — coworking](alumnos/ramirez-palacios-debora-dayan.md) |
| Rodriguez Zavala Jeronimo | [TatuArte — estudio de tatuajes](alumnos/rodriguez-zavala-jeronimo.md) |
| Sanchez Guillen Cristian Otoniel | [StrikeMax — boliche](alumnos/sanchez-guillen-cristian-otoniel.md) |
| Sifuentes Emiliano Mucio Rafael | [MudaFácil — mudanzas](alumnos/sifuentes-emiliano-mucio-rafael.md) |
| Silva Maldonado Josue David | [EstacionaYa — estacionamiento](alumnos/silva-maldonado-josue-david.md) |
| Torres Maldonado Emma Valentina | [ClickEstudio — estudio de fotografía](alumnos/torres-maldonado-emma-valentina.md) |
| Tristan Acuña Orlando | [LagoAzul — renta de lanchas](alumnos/tristan-acuna-orlando.md) |
| Castillo Medrano Jesus Alejandro | [Vertical — gimnasio de escalada](alumnos/castillo-medrano-jesus-alejandro.md) |
| Hernandez Martínez Alexander Kalet | [QuintaSol — quintas para fiestas](alumnos/hernandez-martinez-alexander-kalet.md) |
| Lopez Sustaita Jesus Alejandro | [EnvíaYa — mensajería en motocicleta](alumnos/lopez-sustaita-jesus-alejandro.md) |

---

## Lo que debes construir

1. **El modelo relacional** del negocio, con al menos **4 tablas**, que guarde toda la información del caso y respete sus reglas de negocio mediante restricciones: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` y `DEFAULT`.
   > **Datos que cambian con el tiempo.** Cuando un dato puede cambiar (un precio, una tarifa, un costo) y una operación del negocio depende del valor que tenía **en el momento en que ocurrió**, ese valor se **copia** en la tabla de la operación. Por ejemplo, si una venta guardara solo la referencia al producto, al subir el precio del producto todas las ventas anteriores "costarían" más de lo que se cobró. Tu caso tiene al menos un dato así. **Este principio se revisa en la evidencia.**

2. **El paquete de instalación**: los scripts que crean la base de datos, sus tablas y sus datos iniciales.
3. **El paquete de reversa**: los scripts que eliminan por completo lo instalado.
4. **Los datos iniciales**, de dos tipos:
   - **Lo que el negocio ya tiene definido** (por ejemplo, sus sucursales o sus servicios y precios): viene en tu caso y se inserta **exactamente como viene**, sin cambiar nombres ni valores.
   - **Lo que tú inventas** (por ejemplo, clientes y operaciones): datos ficticios con las cantidades mínimas que pide tu caso.

   En conjunto, deben permitir que **cada una de las 10 consultas regrese al menos una fila**.
5. **Las 10 consultas** de tu caso.

Revisa el **ejemplo resuelto** de HospitalDB: su [enunciado](ejemplo-resuelto/caso.md) tiene el mismo formato que el tuyo, y su [solución](ejemplo-resuelto/README.md) muestra el nivel de detalle que se espera en el PDF y en los tres ZIP. El [PDF del ejemplo](ejemplo-resuelto/EvidenciaIntegral_HilarioMedranoDanielGustavo_1234567.pdf) muestra cómo debe verse el tuyo.

---

## Material de consulta

Todo lo que necesitas está en los [temas del curso](../README.md#temas-del-curso). Los más útiles para esta evidencia:

| Para… | Tema |
|-------|------|
| Pasar de tu caso a las tablas | [Del negocio al modelo](../temas/Etapa-1/07-DelNegocioAlModelo.md), [Normalización](../temas/Etapa-1/04-Normalizacion.md) y [Modelo Entidad-Relación](../temas/Etapa-1/05-ModeloEntidadRelacion.md) |
| Dibujar el modelo relacional | [Guía rápida de dbdiagram.io](../temas/Etapa-1/08-dbdiagram.md) |
| Elegir los tipos de datos | [Tipos de datos en SQL Server](../temas/Etapa-2/04-TiposDeDatos.md) |
| Escribir las restricciones | [Constraints](../temas/Etapa-3/04-Constraints.md) |
| Armar la instalación y la reversa | [Paquete de instalación y reversa](../temas/Etapa-3/07-InstalacionReversa.md) |
| Escribir las consultas | [Consultas simples](../temas/Etapa-3/06-ConsultasSimples.md) y los temas de la [Etapa 4](../README.md#etapa-4--consultas-multitabla) |

---

## Entregables

Cuatro archivos, todos con tu nombre (apellidos y nombres, sin espacios ni acentos) y tu matrícula. Ver el ejemplo en [Forma de entrega](#forma-de-entrega).

| Archivo | Contenido |
|---------|-----------|
| `Instalacion_ApellidoNombre_Matricula.zip` | Los scripts de instalación (`.sql`), numerados en el orden en que se ejecutan: `01-create-database.sql`, `02-create-table-...sql`, ..., `NN-insert-...sql` |
| `Reversa_ApellidoNombre_Matricula.zip` | Los scripts de reversa (`.sql`), numerados en el orden en que se ejecutan: primero se eliminan las tablas en orden inverso a las llaves foráneas y al final la base de datos |
| `Consultas_ApellidoNombre_Matricula.zip` | **Diez** archivos, uno por consulta: `01-consulta.sql` a `10-consulta.sql` |
| `EvidenciaIntegral_ApellidoNombre_Matricula.pdf` | El documento con la estructura de abajo |

### Las consultas van en el ZIP de consultas, no en el PDF

Cada archivo del ZIP de consultas contiene **solo el código SQL** de una consulta, listo para ejecutarse en SSMS **después de la instalación**, con la base de datos de tu caso seleccionada. El número de la consulta lo dice el nombre del archivo (`01-consulta.sql` es la consulta 1), así que adentro no va nada más:

```sql
SELECT ...
FROM ...
WHERE ...
```

- **Sin cabecera.** A diferencia de los scripts de instalación y de reversa, los archivos de consultas **no** llevan comentario de cabecera.
- **De preferencia, sin comentarios.** Si escribes uno, cuida que empiece con `--`. Un renglón de texto sin `--` (por ejemplo, la pregunta copiada tal cual, una explicación o un título) **no es SQL**: hace que el archivo falle al ejecutarse.
- **Nada más que la consulta:** no incluyas resultados, capturas de pantalla, explicaciones ni `USE`.

> Las consultas **no** se escriben en el PDF. El profesor instala tu base de datos con tu paquete de instalación y ejecuta cada archivo del ZIP de consultas sobre ella.

### Estructura del PDF

Todos los documentos deben tener exactamente esta estructura, con estos títulos y en este orden:

```
Portada
    Nombre completo, matrícula y nombre del caso

1. Modelo relacional
    Imagen del diagrama generado en dbdiagram.io (https://dbdiagram.io)

2. Descripción del negocio y de la base de datos
    El negocio con tus palabras y qué guarda la base de datos

3. Plan de instalación
    Tabla: orden, nombre del script y qué hace

4. Plan de reversa
    Tabla: orden, nombre del script y qué hace, incluida la nota de seleccionar
    otra base de datos en SSMS antes de eliminar la base de datos

5. Decisiones de diseño
    Un apartado por tabla: por qué existe, de qué tabla depende y por qué
    (dónde va cada llave foránea), para qué sirve cada restricción y, si la
    tabla copia un dato que puede cambiar (precio, tarifa), por qué lo copia
```

---

## Convenciones de código

- Palabras reservadas SQL en **MAYÚSCULAS** (`SELECT`, `FROM`, `WHERE`, `CREATE TABLE`, etc.).
- Nombres de tablas y columnas en **PascalCase** y en **singular** (`Cliente`, `FechaRenta`).
- Columnas ID con prefijo `id` + nombre de la tabla (`idCliente`, `idBicicleta`).
- Cada script de **instalación** y de **reversa** inicia con un comentario de cabecera con tema, descripción y autor. Los de **consultas** van sin cabecera (ver [arriba](#las-consultas-van-en-el-zip-de-consultas-no-en-el-pdf)).
- `SELECT` y `FROM` en líneas separadas; máximo 5 campos por renglón.
- Los `INSERT` siempre mencionan las columnas.
- Sin `GO`. Cada script de instalación y de reversa, excepto el que crea la base de datos y el que la elimina, empieza con `USE <TuBase>;` (por ejemplo, `USE HospitalDB;`), para que se ejecute sobre la base correcta sin depender del dropdown de SSMS.

### Tus scripts se ejecutan tal cual

El profesor ejecuta tus archivos **exactamente como los entregas**, sin corregir nada: ni un punto, ni una coma, ni un comentario mal cerrado. Antes de entregar:

1. Ejecuta tu paquete de instalación completo, en orden, sobre un SQL Server donde **no** exista tu base de datos, y confirma que no aparece ningún error.
2. Ejecuta cada uno de los 10 archivos de consultas y revisa que regrese lo que pide la pregunta.
3. Ejecuta tu paquete de reversa y confirma que la base de datos desaparece. Si SQL Server dice que la base de datos está en uso, revisa [Si dice que la base de datos está en uso](../temas/Etapa-3/07-InstalacionReversa.md#si-dice-que-la-base-de-datos-está-en-uso).

**Un script que no se ejecuta tal cual cuenta como no entregado.**

### SQL permitido en las consultas

Solo lo visto en el curso: `SELECT`, alias con `AS`, `WHERE` (`=`, `<>`, `>`, `<`, `>=`, `<=`, `AND`, `OR`, `NOT`, `BETWEEN`, `LIKE`, `IN`, `IS NULL`), `ORDER BY`, `TOP`, `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`, `MONTH()`, `YEAR()`, `DAY()` y concatenación con `+`. No uses `GROUP BY`, `HAVING`, funciones de agregado, subconsultas ni `CASE`: son temas de Base de Datos II.

---

## Criterios de evaluación

La Evidencia Integral se califica sobre **100 puntos**. Cada criterio se cumple o no se cumple: no hay puntos parciales dentro de un criterio.

### A. Paquete de instalación (35 puntos)

| # | Criterio | Puntos |
|---|----------|--------|
| A1 | El paquete se ejecuta completo, en orden y **tal cual**, sin errores, y crea la base de datos de tu caso | 10 |
| A2 | Cada tabla tiene su llave primaria y cada llave foránea está en la tabla correcta (del lado de "muchos") | 7 |
| A3 | Las reglas de negocio de tu caso están implementadas como restricciones: `UNIQUE`, `CHECK` y `DEFAULT` | 8 |
| A4 | La tabla de la operación copia el dato que puede cambiar (precio o tarifa) | 5 |
| A5 | Los datos que el negocio ya tiene definidos están exactamente como vienen en tu caso, y los que inventas cumplen los mínimos | 5 |

### B. Paquete de reversa (5 puntos)

| # | Criterio | Puntos |
|---|----------|--------|
| B1 | Se ejecuta **tal cual**, elimina las tablas en orden inverso a las llaves foráneas y al final elimina la base de datos | 5 |

### C. Consultas (30 puntos)

| # | Criterio | Puntos |
|---|----------|--------|
| C1 a C10 | Cada consulta se ejecuta **tal cual**, responde la pregunta de tu caso con los datos de tu instalación y usa solo el [SQL permitido](#sql-permitido-en-las-consultas) | 3 cada una |

### D. Documento PDF (25 puntos)

| # | Criterio | Puntos |
|---|----------|--------|
| D1 | Tiene exactamente la [estructura del PDF](#estructura-del-pdf): portada y secciones 1 a 5, con esos títulos y en ese orden | 3 |
| D2 | El modelo relacional (dbdiagram.io) coincide con las tablas, columnas, llaves y relaciones de tus scripts | 7 |
| D3 | El plan de instalación y el plan de reversa coinciden con los archivos que entregas | 5 |
| D4 | Las decisiones de diseño explican cada tabla: por qué existe, dónde va cada llave foránea y por qué, para qué sirve cada restricción y por qué se copia el dato que puede cambiar | 10 |

### E. Formato (5 puntos)

| # | Criterio | Puntos |
|---|----------|--------|
| E1 | Los cuatro archivos tienen el nombre que se pide, los ZIP contienen los `.sql` directamente (sin carpetas) y el código sigue las [convenciones](#convenciones-de-código) | 5 |

### Reglas generales

- **Si tu paquete de instalación no se ejecuta tal cual**, la sección A vale 0 y, como no hay base de datos sobre la cual ejecutar las consultas, la sección C también vale 0.
- **Una consulta que no se ejecuta tal cual vale 0**, aunque la idea sea correcta.
- **Tu evidencia debe ser de tu caso.** Un modelo que no corresponde al negocio que te tocó (por ejemplo, copiado del ejemplo resuelto o de otro compañero) vale 0 en toda la evidencia.
- **No hay entregas extemporáneas.** Lo que no esté en la tarea de Teams a la fecha y hora límite no se recibe.
- **Si no entregas la Evidencia Integral**, presentas el examen de todos modos, sobre tu caso.

---

## Forma de entrega

- **Modalidad:** individual.
- **Plataforma:** Microsoft Teams, equipo *760 A2026 Base de Datos I REGULARIZACION 1*, tarea **Evidencia Integral Base de Datos I**. Sube los cuatro archivos en la misma tarea.
- **Fecha y hora límite:** sábado 14 de noviembre de 2026, 10:00 p.m. **No hay entregas extemporáneas.**

### Los cuatro archivos

Así deben quedar, por ejemplo, los archivos de un alumno llamado Daniel Gustavo Hilario Medrano (con matrícula de ejemplo 1234567), si su caso fuera el del [ejemplo resuelto](ejemplo-resuelto/caso.md):

| # | Archivo | Qué es |
|---|---------|--------|
| 1 | `EvidenciaIntegral_HilarioMedranoDanielGustavo_1234567.pdf` | El documento PDF |
| 2 | `Instalacion_HilarioMedranoDanielGustavo_1234567.zip` | Los scripts de instalación |
| 3 | `Reversa_HilarioMedranoDanielGustavo_1234567.zip` | Los scripts de reversa |
| 4 | `Consultas_HilarioMedranoDanielGustavo_1234567.zip` | Las 10 consultas |

Contenido de cada ZIP: solo los archivos `.sql`, directamente adentro (sin carpetas):

```
Instalacion_HilarioMedranoDanielGustavo_1234567.zip
├── 01-create-database.sql
├── 02-create-table-especialidad.sql
├── 03-create-table-medico.sql
├── 04-create-table-medico-especialidad.sql
├── 05-create-table-paciente.sql
├── 06-create-table-consultorio.sql
├── 07-create-table-estatus-receta.sql
├── 08-create-table-consulta.sql
├── 09-create-table-receta.sql
├── 10-create-table-medicamento.sql
├── 11-create-table-detalle-receta.sql
├── 12-insert-especialidad.sql
├── 13-insert-medico.sql
├── 14-insert-medico-especialidad.sql
├── 15-insert-paciente.sql
├── 16-insert-consultorio.sql
├── 17-insert-estatus-receta.sql
├── 18-insert-consulta.sql
├── 19-insert-receta.sql
├── 20-insert-medicamento.sql
└── 21-insert-detalle-receta.sql

Reversa_HilarioMedranoDanielGustavo_1234567.zip
├── 01-drop-tables.sql
└── 02-drop-database.sql

Consultas_HilarioMedranoDanielGustavo_1234567.zip
├── 01-consulta.sql
├── 02-consulta.sql
├── 03-consulta.sql
├── 04-consulta.sql
├── 05-consulta.sql
├── 06-consulta.sql
├── 07-consulta.sql
├── 08-consulta.sql
├── 09-consulta.sql
└── 10-consulta.sql
```

Los nombres de los scripts de instalación dependen de las tablas de tu modelo; lo que no cambia es que van numerados en el orden en que se ejecutan. En el ZIP de reversa y en el de consultas, los nombres son exactamente esos.
