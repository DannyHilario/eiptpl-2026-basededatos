# Ejercicio de Evidencia 1: `vw_ConsultaPendiente`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Vista `vw_ConsultaPendiente`

## Contexto

Recuerda el flujo de negocio del hospital: una consulta se agenda, pero solo si en efecto ocurre se marca `Efectuada = 1` (ver [`usp_efectuarConsulta`](../../../sesiones/sesion-7/HospitalDB/docs/procedimientos/usp_efectuarConsulta.md)). Recepción necesita ver, de un vistazo, qué consultas siguen agendadas y aún no se han marcado como efectuadas — ya sea porque su fecha todavía no llega, o porque ya pasó y nadie la confirmó (posible inasistencia). Tu vista es ese reporte de "pendientes".

## Tu tarea

Crea una vista llamada exactamente `vw_ConsultaPendiente` que muestre únicamente las consultas con `Efectuada = 0`, con los nombres legibles de paciente, médico y consultorio.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ConsultaPendiente`.
- [ ] Muestra `idConsulta` y `Fecha` (de `Consulta`, tal cual).
- [ ] Muestra `NombrePaciente`: nombre completo del paciente (`Nombre + ' ' + PrimerApellido + ' ' + SegundoApellido`).
- [ ] Muestra `NombreMedico`: nombre completo del médico, misma lógica de concatenación.
- [ ] Muestra `NombreConsultorio`: el valor de `Consultorio.Nombre`.
- [ ] Filtra únicamente las consultas donde `Efectuada = 0`.
- [ ] No incluye ninguna consulta con `Efectuada = 1`, aunque su fecha ya haya pasado.

## Ejemplo de salida esperada

Con los datos ya instalados, solo las consultas 16 y 17 tienen `Efectuada = 0`:

| idConsulta | Fecha | NombrePaciente | NombreMedico | NombreConsultorio |
|---|---|---|---|---|
| 16 | 2026-09-11 09:00 | Sergio Castro Ibarra | Sofía Sánchez Vega | Consultorio 6 |
| 17 | 2026-10-01 09:00 | Fernanda Morales Sandoval | Alejandro Ramírez Cruz | Consultorio 7 |

## Casos de prueba sugeridos

```sql
-- Ver las pendientes (deben ser exactamente 2 con los datos originales)
SELECT * FROM vw_ConsultaPendiente

-- Efectuar una y verificar que desaparece de la vista
EXEC usp_efectuarConsulta @p_idConsulta = 16
SELECT * FROM vw_ConsultaPendiente WHERE idConsulta = 16  -- ya no debe aparecer
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_MejiaGarciaRicardoAzael_2253586.txt
```
