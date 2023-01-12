-- Chequear que ninguna fecha de inicio de la visita sea mayor que la fecha fin de la visita
SELECT
  p.person_id,
  v.visit_occurrence_id
FROM cdm_hcuch.person p
JOIN cdm_hcuch.visit_occurrence v ON v.person_id = p.person_id 
WHERE v.visit_start_date > v.visit_end_date 
