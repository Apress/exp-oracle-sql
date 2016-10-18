SELECT e.employee_id
      ,e.first_name
      ,e.last_name
      ,j.job_title
      ,j.min_salary
  FROM hr.employees e, hr.jobs j
 WHERE e.job_id = j.job_id AND e.manager_id = 100 AND j.min_salary > 8000;