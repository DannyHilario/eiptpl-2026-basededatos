# Ejercicio de Evidencia 1: `vw_ConsultaCompleta`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Vista `vw_ConsultaCompleta`

## Contexto

`Consulta` guarda solo los ids de paciente, médico y consultorio — para leer la agenda del hospital en un lenguaje humano ("¿quién ve a quién, y dónde?") hay que cruzar esos ids contra sus catálogos. Tu vista arma esa lectura completa de una sola vez.

## Tu tarea

Crea una vista llamada exactamente `vw_ConsultaCompleta` que una `Consulta` con `Paciente`, `Medico` y `Consultorio`, mostrando los nombres completos en lugar de los ids.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ConsultaCompleta`.
- [ ] Muestra `idConsulta`, `Fecha` y `Efectuada` (de `Consulta`, tal cual).
- [ ] Muestra `NombrePaciente`: el nombre completo del paciente, concatenando `Nombre`, `PrimerApellido` y `SegundoApellido` (separados por un espacio).
- [ ] Muestra `NombreMedico`: el nombre completo del médico, con la misma lógica de concatenación.
- [ ] Muestra `NombreConsultorio`: el valor de `Consultorio.Nombre`.
- [ ] Incluye **todas** las consultas, sin importar el valor de `Efectuada` (agendadas y ya efectuadas).

## Ejemplo de salida esperada

| idConsulta | Fecha | Efectuada | NombrePaciente | NombreMedico | NombreConsultorio |
|---|---|---|---|---|---|
| 1 | 2026-09-01 09:00 | 1 | Sergio Castro Ibarra | Carlos García López | Consultorio 1 |
| 16 | 2026-09-11 09:00 | 0 | Sergio Castro Ibarra | Sofía Sánchez Vega | Consultorio 6 |
| 17 | 2026-10-01 09:00 | 0 | Fernanda Morales Sandoval | Alejandro Ramírez Cruz | Consultorio 7 |

## Casos de prueba sugeridos

```sql
-- Ver toda la agenda
SELECT * FROM vw_ConsultaCompleta

-- Verificar el nombre completo de una consulta específica
SELECT NombrePaciente, NombreMedico
FROM vw_ConsultaCompleta
WHERE idConsulta = 1
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_EspinozaJuarezAngelDeJesus_2253562.txt
```
