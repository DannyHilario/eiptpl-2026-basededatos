# Producto Integrador de Aprendizaje (PIA) — Base de Datos II

De manera **individual**, construirás en Microsoft SQL Server la base de datos completa de un negocio pequeño: el modelo, los datos y los **11 objetos programados** (procedimientos almacenados, funciones, vistas y un trigger) que hacen que la base de datos **cuide las reglas del negocio por sí misma**. Cada alumno tiene **su propio caso de negocio**; busca tu nombre en la tabla de abajo.

El PIA junta todo lo del curso: lo que aprendiste en Base de Datos I para diseñar e instalar una base de datos, y las cuatro etapas de Base de Datos II para programarla.

> **Entrega:** sábado 14 de noviembre de 2026, 10:00 p.m., en NEXUS. El **mismo** contenido se sube en **tres** lugares (ver [Forma de entrega](#forma-de-entrega)).

---

## Tu caso

| Alumno | Caso |
|--------|------|
| Aguilar Hernandez Marcos Fernando | [BiciRuta — renta de bicicletas](alumnos/aguilar-hernandez-marcos-fernando/README.md) |
| Espinoza Juarez Angel De Jesus | [FitZone — gimnasio](alumnos/espinoza-juarez-angel-de-jesus/README.md) |
| Garcia Martinez Marisol | [SalaRock — salas de ensayo](alumnos/garcia-martinez-marisol/README.md) |
| Gomez Ordaz Bryan Omar | [VeloKart — pista de go-karts](alumnos/gomez-ordaz-bryan-omar/README.md) |
| Hernandez Juarez Brenda Ivonne | [CampoVerde — casas de campaña](alumnos/hernandez-juarez-brenda-ivonne/README.md) |
| Hernandez Martínez Alexander Kalet | [QuintaSol — quintas para fiestas](alumnos/hernandez-martinez-alexander-kalet/README.md) |
| Hernandez Perez Jose Ivan | [AsesorPro — asesorías escolares](alumnos/hernandez-perez-jose-ivan/README.md) |
| Mejia Garcia Ricardo Azael | [GameZone — renta de consolas](alumnos/mejia-garcia-ricardo-azael/README.md) |
| Mendez Cantu Raúl Ángel | [RutaNorte — autobuses foráneos](alumnos/mendez-cantu-raul-angel/README.md) |
| Montoya Moreno Ana Valeria | [SpaZen — spa](alumnos/montoya-moreno-ana-valeria/README.md) |
| Morales Azuara Eduardo Gabriel | [GuardaTodo — minibodegas](alumnos/morales-azuara-eduardo-gabriel/README.md) |
| Perez Morales Johan Valente | [EnigmaRoom — salas de escape](alumnos/perez-morales-johan-valente/README.md) |
| Rodriguez Moreno Ricardo | [EspacioUno — coworking](alumnos/rodriguez-moreno-ricardo/README.md) |
| Ruiz Olguin Alejandro | [RecorreMTY — recorridos turísticos](alumnos/ruiz-olguin-alejandro/README.md) |
| Sifuentes Emiliano Mucio Rafael | [MudaFacil — mudanzas](alumnos/sifuentes-emiliano-mucio-rafael/README.md) |
| Vazquez Anaya Johann Adad | [StrikeMax — boliche](alumnos/vazquez-anaya-johann-adad/README.md) |
| Villanueva Mata Brandon Gabriel | [ImprimeYa — imprenta rápida](alumnos/villanueva-mata-brandon-gabriel/README.md) |

Cada caso describe el negocio, su flujo, sus reglas y lo que el negocio ya tiene definido, igual que en Base de Datos I. Además trae dos cosas nuevas:

- **El histórico de precios**: una tabla más en tu modelo, que guarda cada cambio de precio.
- **Los 11 objetos programados**, cada uno con su **ficha**: historia de usuario, firma (nombre, parámetros y tipos), validaciones con sus códigos de salida, criterios de aceptación, un ejemplo del resultado esperado y casos de prueba.

**El caso no te dice qué tablas ni qué columnas crear:** deducir el modelo a partir del negocio sigue siendo parte del trabajo. Lo que sí está fijo es lo que se ve desde fuera de la base de datos: el nombre de cada objeto, sus parámetros, sus códigos de salida y las columnas que regresan las vistas y los procedimientos de consulta.

---

## Lo que debes construir

1. **El modelo relacional** de tu negocio: las tablas de tu caso **más la tabla del histórico de precios**, con sus restricciones (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` y `DEFAULT`).
   > **Datos que cambian con el tiempo.** Como en Base de Datos I: cuando un hecho depende del precio que tenía **en el momento en que sucedió**, ese precio se **copia** en la tabla de hechos. En el PIA se agrega la otra mitad de la historia: el histórico guarda **cómo fue cambiando** el precio.
2. **Los datos iniciales**: lo que el negocio ya tiene definido, **exactamente como viene** en tu caso, y lo que tú inventas, con los mínimos que pide tu caso.
3. **Los 11 objetos programados**, como los describe la ficha de cada uno.
4. **El paquete de instalación**: los scripts que crean la base de datos, sus tablas, sus datos y sus objetos.
5. **El paquete de reversa**: los scripts que eliminan por completo lo instalado.
6. **El documento PDF**, con la [estructura](#estructura-del-pdf) de abajo.

### Los casos de prueba son para ti

Cada ficha trae casos de prueba para que **compruebes** tu objeto antes de entregarlo. Los casos de prueba **no se entregan**: no los copies en tus scripts. El profesor prueba cada objeto por su cuenta.

---

## Material de consulta

| Para… | Tema |
|-------|------|
| Pasar del negocio a las tablas | [Del negocio al modelo](../../base-datos-1/temas/Etapa-1/07-DelNegocioAlModelo.md) (Base de Datos I) |
| Dibujar el modelo relacional | [Guía rápida de dbdiagram.io](../../base-datos-1/temas/Etapa-1/08-dbdiagram.md) (Base de Datos I) |
| Escribir las restricciones | [Constraints](../../base-datos-1/temas/Etapa-3/04-Constraints.md) (Base de Datos I) |
| Armar la instalación y la reversa | [Paquete de instalación y reversa](../../base-datos-1/temas/Etapa-3/07-InstalacionReversa.md) (Base de Datos I) |
| Las vistas | [Funciones de agregado](../temas/Etapa-1/02-FuncionesAgregado.md), [Cláusulas](../temas/Etapa-1/01-Clausulas.md) y [Vistas](../temas/Etapa-1/05-Vistas.md) |
| Los procedimientos almacenados | [Crear y ejecutar](../temas/Etapa-2/02-CrearEjecutar.md), [Variables e IF / ELSE](../temas/Etapa-2/03-VariablesIfElse.md) y [Validaciones y códigos de salida](../temas/Etapa-2/04-Validaciones.md) |
| Las funciones | [Funciones definidas por el usuario](../temas/Etapa-3/01-FuncionesDefinidasUsuario.md) |
| El trigger | [Triggers](../temas/Etapa-3/02-Triggers.md) y [Uso de la tabla Inserted y Deleted](../temas/Etapa-3/03-InsertedDeleted.md) |
| Por qué un script falla completo | [Lotes y GO](../temas/Etapa-4/02-Lotes.md) |
| `CASE` | [CASE](../temas/Etapa-4/03-Case.md) |
| `TRY … CATCH` y `ISNULL` | [Errores y TRY CATCH](../temas/Etapa-4/04-Errores.md), [Errores de valor nulo](../temas/Etapa-4/05-ValoresNulos.md) y [Excepciones en procedimientos almacenados](../temas/Etapa-4/06-ExcepcionesProcedimientos.md) |

---

## Entregables

> **El PIA y la Evidencia Integral de Base de Datos I (3ra o 5ta oportunidad) son entregas distintas.** Si también presentas la 3ra o 5ta oportunidad con el mismo caso, el negocio es el mismo, pero los paquetes **no**: el de Base de Datos I lleva solo tablas y datos, con `USE` en cada script, y se entrega en Teams; el del PIA lleva además el histórico de precios y los 11 objetos, sigue las reglas de esta descripción y se entrega en NEXUS. Arma y prueba cada paquete por separado: no subas el mismo ZIP en los dos lugares.

Tres archivos, todos con tu nombre (apellidos y nombres, sin espacios ni acentos) y tu matrícula:

| Archivo | Contenido |
|---------|-----------|
| `Instalacion_ApellidoNombre_Matricula.zip` | Los scripts de instalación (`.sql`), numerados en el orden en que se ejecutan |
| `Reversa_ApellidoNombre_Matricula.zip` | Los scripts de reversa (`.sql`), numerados en el orden en que se ejecutan |
| `PIA_ApellidoNombre_Matricula.pdf` | El documento con la estructura de abajo |

### El paquete de instalación

Un script por cada cosa que se crea, en este orden:

1. `01-create-database.sql`
2. Un script por tabla: `NN-create-table-...sql`, en orden de dependencia (primero las tablas que no dependen de nadie).
3. Un script por tabla con datos: `NN-insert-...sql`.
4. Un script por objeto, **en el orden de las fichas** de tu caso: `NN-usp-...sql`, `NN-ufn-...sql`, `NN-vw-...sql` y, al final, `NN-trg-...sql`.

Por ejemplo, para VeloKart:

```
Instalacion_GomezOrdazBryanOmar_2254247.zip
├── 01-create-database.sql
├── 02-create-table-...sql
├── ...
├── NN-insert-...sql
├── NN-usp-insertar-piloto.sql
├── NN-usp-dar-de-baja-piloto.sql
├── NN-usp-insertar-kart.sql
├── NN-usp-actualizar-precio-tipo-kart.sql
├── NN-usp-registrar-carrera.sql
├── NN-usp-obtener-carreras-por-fecha.sql
├── NN-ufn-total-cobrado-kart.sql
├── NN-ufn-nivel-piloto.sql
├── NN-vw-detalle-carrera.sql
├── NN-vw-resumen-tipo-kart.sql
└── NN-trg-registrar-historico-precio.sql
```

**Los scripts de los objetos llevan solo la cabecera y el `CREATE`:** sin `USE`, sin `GO` y sin casos de prueba. Se ejecutan con tu base de datos seleccionada en el dropdown de SSMS:

```sql
-- Tema:        PIA - VeloKartDB
-- Descripción: Procedimiento usp_insertarPiloto
-- Autor:       Tu nombre completo (matrícula)

CREATE PROCEDURE usp_insertarPiloto
	...
```

Los scripts de tablas y de datos pueden empezar con `USE <TuBase>;`, como en Base de Datos I.

### El paquete de reversa

```
Reversa_GomezOrdazBryanOmar_2254247.zip
├── 01-drop-tables.sql
└── 02-drop-database.sql
```

`01-drop-tables.sql` elimina las tablas en orden inverso a las llaves foráneas, incluido el histórico. `02-drop-database.sql` elimina la base de datos: con ella desaparecen también los procedimientos, las funciones y las vistas.

### Estructura del PDF

Todos los documentos deben tener exactamente esta estructura, con estos títulos y en este orden:

```
Portada
    Nombre completo, matrícula y nombre del caso

1. Modelo relacional
    Imagen del diagrama generado en dbdiagram.io (https://dbdiagram.io),
    incluida la tabla del histórico de precios

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
    tabla copia un dato que puede cambiar, por qué lo copia. En el histórico,
    por qué nadie escribe en él a mano

6. Objetos programados
    Un apartado por objeto, en el orden de las fichas: qué hace, de qué
    tablas lee o en cuáles escribe, y cómo lo resolviste (qué valida y en qué
    orden, qué guarda en variables, qué atrapa el CATCH, qué cuenta o suma)
```

---

## Convenciones de código

- Palabras reservadas SQL en **MAYÚSCULAS**.
- Nombres de tablas y columnas en **PascalCase** y en **singular**; columnas ID con prefijo `id` + nombre de la tabla (`idKart`).
- Procedimientos con prefijo `usp_`, funciones con `ufn_`, vistas con `vw_` y triggers con `trg_`, con el nombre **exacto** de su ficha.
- Cada script de instalación y de reversa inicia con un comentario de cabecera con tema, descripción y autor.
- `SELECT` y `FROM` en líneas separadas; máximo 5 campos por renglón. Los `INSERT` siempre mencionan las columnas.
- En los procedimientos, las validaciones son *guard clauses*: el dato se guarda en una variable, se revisa con `IF @variable IS NULL` / `IS NOT NULL` y, si falla, se regresa el error y se sale con `RETURN`. `IF EXISTS (SELECT ...)` y los `IF` anidados se permiten, pero se evitan. Las **sugerencias** de cada ficha sobre cómo resolverlo no se califican.
- Los procedimientos responden con `ErrCodigo` / `ErrMensaje`.
- Las vistas no llevan `ORDER BY`.
- Sin `GO`.

### Tus scripts se ejecutan tal cual

El profesor ejecuta tus archivos **exactamente como los entregas**, sin corregir nada. Antes de entregar:

1. Guarda todos tus scripts en **UTF-8**. En SSMS: *File → Save As…*, flecha junto a *Save* → *Save with Encoding…* → *Unicode (UTF-8 with signature) - Codepage 65001*. Si no, las letras con acento (por ejemplo, *Estándar*) pueden guardarse mal en tu base de datos y las pruebas no encuentran esos datos.
2. Ejecuta tu paquete de instalación completo, en orden, sobre un SQL Server donde **no** exista tu base de datos, y confirma que no aparece ningún error.
3. Corre los casos de prueba de cada ficha, partiendo de una instalación limpia, y compara con los resultados esperados.
4. Ejecuta tu paquete de reversa y confirma que la base de datos desaparece.

**Un script que no se ejecuta tal cual cuenta como no entregado.**

---

## Criterios de evaluación

El PIA se califica con **una sola rúbrica**, y el mismo nivel se registra en los **tres** lugares donde lo subes (ver [Forma de entrega](#forma-de-entrega)). Cada criterio tiene cuatro niveles:

| Criterio | Evidencia completa | Evidencia suficiente | Evidencia débil | Sin evidencia |
|----------|--------------------|----------------------|-----------------|---------------|
| **Conocimientos** (3 / 2 / 1 / 0) | El PDF explica **qué hace y por qué** cada tabla y cada objeto: por ejemplo, por qué la tabla de hechos copia el precio o por qué el histórico lo llena un trigger y no un procedimiento | El PDF explica qué hace cada tabla y cada objeto, pero no por qué | La explicación es escasa o no coincide con tu código | No entregó |
| **Habilidades** (5 / 4 / 3 / 0) | Tu instalación se ejecuta tal cual y **los 11 objetos** cumplen **todos** sus criterios de aceptación | Tu instalación se ejecuta tal cual, pero **algún** objeto no cumple todos sus criterios o no se crea | Se crean **menos de 6** de los 11 objetos, o tu instalación no se ejecuta tal cual | No entregó |
| **Actitudes / Valores** (2 / 1 / 0 / 0) | Entregas a tiempo y con la forma pedida: nombres de archivo, ZIP sin carpetas, estructura del PDF, convenciones y sin casos de prueba en los scripts | Cumples la forma solo en parte | No cumples la forma pedida | No entregó |

### Cuándo cumple un objeto

Cada objeto se revisa contra los **criterios de aceptación de su ficha**, con tus scripts ejecutados tal cual sobre tu propia instalación. **Un objeto cumple si se crea sin errores y cumple todos sus criterios de aceptación.** Basta con que un solo criterio de un solo objeto falle para que Habilidades baje a *Evidencia suficiente*.

### Reglas generales

- **Tu PIA debe ser de tu caso.** Un modelo o unos objetos que no corresponden al negocio que te tocó cuentan como no entregados.
- **No hay entregas extemporáneas.** Lo que no esté en NEXUS a la fecha y hora límite no se recibe.

---

## Forma de entrega

- **Modalidad:** individual.
- **Plataforma:** NEXUS.
- **Fecha y hora límite:** sábado 14 de noviembre de 2026, 10:00 p.m. **No hay entregas extemporáneas.**

El PIA se sube **tres veces**, con **los mismos tres archivos** en cada lugar, para que cuente en cada una de las etapas que integra:

| # | Dónde en NEXUS |
|---|----------------|
| 1 | Etapa 3 · **3.2 Evidencia de aprendizaje: Script** |
| 2 | Etapa 4 · **4.2 Evidencia de aprendizaje: Script** |
| 3 | Producto Integrador de Aprendizaje · **Evidencia de Aprendizaje: Script** |

Si falta en alguno de los tres lugares, en ese lugar cuenta como no entregado.

### Los tres archivos

Así deben quedar, por ejemplo, los archivos de Gomez Ordaz Bryan Omar (matrícula 2254247):

| # | Archivo | Qué es |
|---|---------|--------|
| 1 | `PIA_GomezOrdazBryanOmar_2254247.pdf` | El documento PDF |
| 2 | `Instalacion_GomezOrdazBryanOmar_2254247.zip` | Los scripts de instalación |
| 3 | `Reversa_GomezOrdazBryanOmar_2254247.zip` | Los scripts de reversa |
