SELECT e.employee_id
      ,e.first_name
      ,e.last_name
      ,j.job_id
      ,j.min_salary
      ,d.department_name
      ,h.start_date
      ,h.end_date
  FROM hr.employees e
      ,hr.jobs j
      ,hr.departments d
      ,hr.job_history h
 WHERE     e.job_id = j.job_id
       AND e.employee_id = h.employee_id
       AND e.department_id = d.department_id;