SELECT first_name
        ,last_name
        , (SELECT first_name
             FROM hr.employees m
            WHERE m.employee_id = e.manager_id)
            AS manager_first_name
        , (SELECT last_name
             FROM hr.employees m
            WHERE m.employee_id = e.manager_id)
            AS manager_last_name
    FROM hr.employees e
   WHERE manager_id IS NOT NULL
ORDER BY last_name, first_name;
