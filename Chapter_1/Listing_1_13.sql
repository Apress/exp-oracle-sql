  SELECT e.employee_id
        ,e.first_name
        ,e.last_name
        ,e.manager_id
        ,sub.mgr_cnt subordinates
        ,peers.mgr_cnt - 1 peers
        ,peers.job_id_cnt peer_job_id_cnt
        ,sub.job_id_cnt sub_job_id_cnt
    FROM hr.employees e
        ,(  SELECT e.manager_id, COUNT (*) mgr_cnt, job_id_cnt
              FROM hr.employees e
                  ,(  SELECT manager_id, COUNT (DISTINCT job_id) job_id_cnt
                        FROM hr.employees
                    GROUP BY manager_id) jid
             WHERE jid.manager_id = e.manager_id
          GROUP BY e.manager_id, jid.job_id_cnt) sub
        ,(  SELECT e.manager_id, COUNT (*) mgr_cnt, job_id_cnt
              FROM hr.employees e
                  ,(  SELECT manager_id, COUNT (DISTINCT job_id) job_id_cnt
                        FROM hr.employees
                    GROUP BY manager_id) jid
             WHERE jid.manager_id = e.manager_id
          GROUP BY e.manager_id, jid.job_id_cnt) peers
   WHERE sub.manager_id = e.employee_id AND peers.manager_id = e.manager_id
ORDER BY last_name, first_name;
