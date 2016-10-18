  SELECT e.first_name
        ,e.last_name
        ,m.first_name AS manager_first_name
        ,m.last_name AS manager_last_name
    FROM hr.employees e, hr.employees m
   WHERE m.employee_id = e.manager_id
ORDER BY last_name, first_name;