SELECT
  p.person_id,
  v.visit_occurrence_id,
  v.visit_end_date - v.visit_start_date AS los
FROM cdm_hcuch.person p
JOIN cdm_hcuch.visit_occurrence v ON v.person_id = p.person_id 
ORDER BY los DESC