---- Master BD - Sorina Predut 
-- https://drive.google.com/drive/folders/1LV8wALYCSofeSKjbh7MceQdom-IfEhjM
-- Recapitulare SQL 0
---LAB 0 - 10 oct 2022
--- 2
desc employees;

-- 3

SELECT first_name, department_id
FROM employees
WHERE department_id in (10,30)
ORDER BY first_name;

-- 4
SELECT TO_CHAR(sysdate, 'DD-MON-YY HH24:MI:SS') FROM dual;

-- 5
SELECT last_name, hire_date
FROM employees 
--WHERE hire_date LIKE '%87%';
WHERE to_char(hire_date, 'YYYY')= '1987';

-- 6
SELECT last_name, JOB_TITLE
FROM employees JOIN jobs
USING(job_id)
WHERE manager_id is null;

--7
SELECT LAST_NAME, SALARY, COMMISSION_PCT--*SALARY
FROM employees
WHERE commission_pct is not null
ORDER BY salary DESC, commission_pct DESC;

-- 8
SELECT LAST_NAME, SALARY, COMMISSION_PCT--*SALARY
FROM employees
--WHERE commission_pct is not null
ORDER BY salary DESC, commission_pct DESC;

-- 9
SELECT last_name
FROM employees
WHERE TRIM(LOWER(last_name))LIKE '__a%';

--10
SELECT last_name
FROM employees
WHERE TRIM(LOWER(last_name))LIKE '%l%l%' AND
    (department_id = 30 OR manager_id = 102);


--11
SELECT last_name, JOB_TITLE, SALARY
FROM employees JOIN jobs
USING(job_id)
WHERE (trim(lower(job_title)) LIKE '%clerk%'
    OR trim(lower(job_title)) LIKE '%rep%')
    AND salary NOT IN (1000,2000, 3000);

--12, 13
SELECT last_name, department_name
FROM employees LEFT JOIN departments
USING(department_id);

--14
SELECT emp.employee_id, emp.last_name, mng.last_name as "Manager Name", 
    emp.manager_id as "Manager ID"
FROM employees emp JOIN employees mng
ON emp.manager_id=mng.manager_id;

--15
SELECT emp.employee_id, emp.last_name, mng.last_name as "Manager Name", 
    emp.manager_id as "Manager ID"
FROM employees emp LEFT JOIN employees mng
ON emp.manager_id=mng.manager_id;

--16
SELECT department_name
FROM departments 
WHERE department_id NOT IN (SELECT DISTINCT NVL(department_id,0)
                              FROM employees);
                              
--v2
                              
SELECT department_id
FROM departments 
MINUS
SELECT department_id
FROM employees;

--17
--SELECT max(salary), min(salary), sum(salary), 
--18-31
