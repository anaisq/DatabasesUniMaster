SET SERVEROUTPUT ON

--1
DECLARE
TYPE info_ang_afl IS RECORD (
cod_ang NUMBER(4),
nume VARCHAR2(20),
salariu NUMBER(8),
cod_dep NUMBER(4));
v_info_ang info_ang_afl;
BEGIN
DELETE FROM emp_afl
WHERE employee_id = 200
RETURNING employee_id, last_name, salary, department_id
INTO v_info_ang;
DBMS_OUTPUT.PUT_LINE('A fost stearsa linia continand valorile ' ||
v_info_ang.cod_ang ||' '||v_info_ang.nume||' ' ||v_info_ang.salariu ||' '
|| v_info_ang.cod_dep) ;
END;
/
ROLLBACK ;

SELECT *
FROM emp_afl
WHERE employee_id=200;

--2

DECLARE
    TYPE info_ang_afl IS RECORD (
    cod_ang NUMBER(4):=500,
    nume VARCHAR2(20):='abc',
    prenume VARCHAR2(20):='john',
    email emp_afl.email%TYPE:='abc@mail',
    telefon emp_afl.phone_number%type,
    data emp_afl.hire_date%TYPE:=SYSDATE,
    job emp_afl.job_id%TYPE:='SA_REP',
    salariu NUMBER(8, 2):=1000,
    comision emp_afl.commission_pct%TYPE,
    manager emp_afl.manager_id%TYPE,
    cod_dep NUMBER(4):=30
    );
    v_info_ang info_ang_afl;
BEGIN
    --inserare; nu ar fi fost posibila maparea unei variabile de tip RECORD într-o lista
    -- explicita de coloane
    INSERT INTO emp_afl
    VALUES v_info_ang;
    DBMS_OUTPUT.PUT_LINE('A fost introdusa linia continand valorile ' ||
    v_info_ang.cod_ang ||' '||v_info_ang.nume||' ' ||v_info_ang.salariu ||' '
    || v_info_ang.cod_dep) ;
    --actualizare
    v_info_ang.nume:='smith';
    UPDATE emp_afl
    SET ROW=v_info_ang
    WHERE employee_id = v_info_ang.cod_ang;
    DBMS_OUTPUT.PUT_LINE('A fost actualizata linia cu valorile ' ||
    v_info_ang.cod_ang ||' '||v_info_ang.nume||' ' ||v_info_ang.salariu ||' '
    || v_info_ang.cod_dep) ;
END;
/

ROLLBACK ;


--3
DECLARE
    TYPE tab_index IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE tab_imbri IS TABLE OF NUMBER;
    TYPE vector IS VARRAY(15) OF NUMBER;
    v_tab_index tab_index;
    v_tab_imbri tab_imbri;
    v_vector vector;
    i INTEGER;
BEGIN
    v_tab_index(1) := 72;
    v_tab_index(2) := 23;
    v_tab_imbri := tab_imbri(5, 3, 2, 8, 7);
    
    v_vector := vector(1, 2);
    -- afisati valorile variabilelor definite; exemplu dat pentru v_tab_imbri
    FOR i IN 1..v_tab_index.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('v_tab_imbri: '||v_tab_index(i));
    END LOOP;
    
    FOR i IN v_vector.FIRST ..v_vector.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('v_tab_imbri: '||v_vector(i));
    END LOOP;
    
    i:=v_tab_imbri.FIRST;
    
    WHILE (i <= v_tab_imbri.LAST) LOOP
        DBMS_OUTPUT.PUT_LINE('v_tab_imbri: '||v_tab_imbri(i));
    i:= v_tab_imbri.NEXT(i);
    END LOOP;
END;
/

--4
DECLARE
    TYPE tablou_numar IS TABLE OF NUMBER
    INDEX BY PLS_INTEGER;
    v_tablou tablou_numar;
    v_aux tablou_numar; -- tablou folosit pentru stergere
BEGIN
    FOR i IN 1..20 LOOP
    v_tablou(i) := i*i;
    
    DBMS_OUTPUT.PUT_LINE(v_tablou(i));
    END LOOP;
    --v_tablou := NULL;
    --aceasta atribuire da eroarea PLS-00382
    FOR i IN v_tablou.FIRST..v_tablou.LAST LOOP -- metoda 1 de stergere
    v_tablou(i) := NULL;
    END LOOP;
    --sau
    v_tablou := v_aux; -- metoda 2 de stergere
    --sau
    v_tablou.delete; --metoda 3 de stergere
    DBMS_OUTPUT.PUT_LINE('tabloul are ' || v_tablou.COUNT ||
    ' elemente');
    
END;
/

--7
CREATE TYPE proiect_afl AS VARRAY(50) OF VARCHAR2(15)
/

SELECT * FROM user_types;

CREATE TABLE test_afl (cod_ang NUMBER(4),proiecte_alocate proiect_afl);

select * from test_afl;

DECLARE
    v_proiect proiect_afl := proiect_afl(); --initializare utilizând constructorul
BEGIN
    v_proiect.extend (2);
    v_proiect(1) := 'proiect 1';
    v_proiect(2) := 'proiect 2' ;
    INSERT INTO test_afl VALUES (1, v_proiect);
END;
/

INSERT INTO tesT_afl VALUES(2, proiect_afl('proiect 3'));

select cod_ang, t.*
from test_afl, TABLE(SELECT proiecte_alocate FROM test_afl where cod_ang=1) t;


DELETE from test_afl;

--8

DECLARE
    TYPE t_id IS VARRAY(100) OF emp_afl.employee_id%TYPE ;
    v_id t_id := t_id();
BEGIN
    FOR contor IN (SELECT * FROM emp_afl) LOOP
        IF contor. Department_id =50 AND contor.salary < 5000 THEN
        V_id.extend;
        V_id(v_id.COUNT) := contor.employee_id;
        END IF;
    END LOOP;
        FORALL contor IN 1..v_id.COUNT
        UPDATE emp_afl
        SET salary = salary *1.1
        WHERE employee_id = v_id (contor);
END;
/

select * from emp_afl where department_id =50;

ROLLBACK;

--13
CREATE OR REPLACE TYPE DateTab_afl AS
TABLE OF DATE;
/

CREATE TABLE famous_dates_afl ( key VARCHAR2(100) PRIMARY KEY,
                                date_list DateTab_afl)
NESTED TABLE date_list STORE AS dates_tab_afl;

DECLARE
    v_Dates DateTab_afl := DateTab_afl(TO_DATE('04-JUL-1776', 'DD-MON-YYYY'),
    TO_DATE('12-APR-1861', 'DD-MON-YYYY'),
    TO_DATE('05-JUN-1968', 'DD-MON-YYYY'),
    TO_DATE('26-JAN-1986', 'DD-MON-YYYY'),
    TO_DATE('01-JAN-2001', 'DD-MON-YYYY'));

    PROCEDURE Print(p_Dates IN DateTab_afl) IS
    v_Index BINARY_INTEGER := p_Dates.FIRST;
BEGIN
    WHILE v_Index <= p_Dates.LAST LOOP
    DBMS_OUTPUT.PUT(' ' || v_Index || ': ');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(p_Dates(v_Index),
    'DD-MON-YYYY'));
    v_Index := p_Dates.NEXT(v_Index);
    END LOOP;
    END Print;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valoarea initiala a tabloului');
    Print(v_Dates);
    INSERT INTO famous_dates_afl (key, date_list)
    VALUES ('Date importante', v_Dates);
    v_Dates.DELETE(2); -- tabloul va avea numai 4 elemente
    SELECT date_list
    INTO v_Dates
    FROM famous_dates_afl
    WHERE key = 'Date importante';
    DBMS_OUTPUT.PUT_LINE('Tabloul dupa INSERT si SELECT:');
    Print(v_Dates);
END;
/
ROLLBACK;

--Ment?inet?i i?ntr-o colect?ie codurile celor mai prost pla?tit?i 5 angajat?i
--care nu ca?s?tiga? comision. Folosind aceasta? colect?ie ma?rit?i cu 5% salariul acestor angajat?i.
-- Afis?at?i valoarea veche a salariului, respectiv valoarea noua? a salariului. 

DECLARE
    TYPE t_id IS VARRAY(100) OF emp_afl.employee_id%TYPE ;
    v_id t_id := t_id();
    v_salary emp_afl.salary%TYPE;
BEGIN
    SELECT employee_id
    BULK COLLECT INTO v_id
    FROM ( SELECT * 
           FROM emp_afl
           WHERE commission_pct IS NULL
           ORDER BY salary)
    WHERE ROWNUM<6;
    
    FOR contor IN 1..v_id.COUNT LOOP
    SELECT salary
    INTO v_salary
    FROM emp_afl
    WHERE employee_id = v_id(contor);
    DBMS_OUTPUT.PUT_LINE('salariul vechi: '|| v_salary);
    END LOOP;
    
    FORALL contor IN 1..v_id.COUNT
    UPDATE emp_afl
    SET salary = salary *1.05
    WHERE employee_id = v_id (contor);
    
    FOR contor IN 1..v_id.COUNT LOOP
    SELECT salary
    INTO v_salary
    FROM emp_afl
    WHERE employee_id = v_id(contor);
    DBMS_OUTPUT.PUT_LINE('salariul nou: '|| v_salary);
    END LOOP;
    
END;
/


select * from emp_afl;

    SELECT employee_id
    FROM ( SELECT * 
           FROM emp_afl
           WHERE commission_pct IS NULL
           ORDER BY salary)
    WHERE ROWNUM<6;