SET SERVEROUTPUT ON

--------------------------------------------------------------
DECLARE
v_nr NUMBER:=10;
BEGIN
NULL;
-- DBMS_OUTPUT.PUT_LINE('Azi e un laborator. Nota' || v_nr );
DBMS_OUTPUT.PUT_LINE('Azi');
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(v_nr);

END;
/
--------------------------------------------------------------
VARIABLE g_sir VARCHAR(25)

BEGIN
:g_sir:='Azi am tot intampinat pb cu sunete';
DBMS_OUTPUT.PUT(g_sir);
END;
/

PRINT g_sir;

--------------------------------------------------------------
DECLARE
v_nume employees.last_name%TYPE;
BEGIN
SELECT last_name
INTO v_nume
FROM employees;
--WHERE employee_id=100;
DBMS_OUTPUT.PUT_LINE(v_nume);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20000, 'Too many empl');
END;
/
--------------------------------------------------------------
<<principal>>
DECLARE v_nr NUMBER:=1;
BEGIN
v_nr:=v_nr+1;
    <<secundar>>
    DECLARE
    v_nr NUMBER :=10;
    BEGIN
    v_nr := v_nr + 10;
    DBMS_OUTPUT.PUT_LINE(v_nr ||' ' || principal.v_nr);
    END;
-- secundar.v_nr cannot be accessed
DBMS_OUTPUT.PUT_LINE(v_nr);
END;
/
--------------------------------------------------------------
-- illegal
DECLARE
v_data DATE NOT NULL;
BEGIN
END;
/
--------------------------------------------------------------
SET VERIFY OFF

DECLARE
v_media_sal employees.salary%TYPE;
v_dept NUMBER:=&p_dept;
BEGIN
SELECT AVG(salary)
INTO v_media_sal
FROM employees
WHERE department_id= v_dept;
DBMS_OUTPUT.PUT_LINE('media salariilor este '|| v_media_sal);
END;
/
--------------------------------------------------------------
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME LIKE 'EMP%';

CREATE TABLE emp_afl
AS SELECT * FROM employees;


SELECT * FROM emp_afl
WHERE department_id=50;

UPDATE emp_afl
SET commission_pct = 0.3;
WHERE department_id=50;


DEFINE p_cod_dep= 50
DEFINE p_com =10
DECLARE
v_cod_dep emp_afl.department_id%TYPE:= &p_cod_dep;
v_com NUMBER(2);
BEGIN
UPDATE emp_afl
SET commission_pct = &p_com/100
WHERE department_id= v_cod_dep;
IF SQL%ROWCOUNT = 0 THEN
DBMS_OUTPUT.PUT_LINE('Nici o linie actualizata');
ELSE DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT ||' linii actualizate ');
END IF;
END;
/

--------------------------------------------------------------
CREATE TABLE org_tab_afl
(cod_tab INTEGER, text_tab VARCHAR2(100));

DECLARE
v_contor BINARY_INTEGER := 1;
BEGIN
LOOP
INSERT INTO org_tab_afl
VALUES (v_contor, 'indice loop');
v_contor := v_contor + 1;
EXIT WHEN v_contor > 70;
END LOOP;
END;
/

SELECT * FROM org_tab_afl;

DECLARE
v_contor BINARY_INTEGER := 1;
BEGIN
LOOP

IF v_contor MOD 2 = 0 THEN
    UPDATE org_tab_afl
    SET text_tab = 'par'
    WHERE cod_tab = v_contor;
ELSE
    UPDATE org_tab_afl
    SET text_tab = 'impar'
    WHERE cod_tab = v_contor;
END IF;

v_contor := v_contor + 1;
EXIT WHEN v_contor > 70;
END LOOP;
END;
/

-----------------------------------------------
---Exercitii
----------------------------------------------- 
--1

VARIABLE g_sir VARCHAR2(100)
VARIABLE g_num NUMBER(10)

DECLARE
v_sir VARCHAR2(100) := 'Hello';
v_num NUMBER:=10;
BEGIN
:g_sir := v_sir;
:g_num :=v_num;
END;
/

PRINT g_sir;
PRINT g_num;

----------------------------------------------- 
--2
DECLARE
v_nr1 NUMBER := &nr1;
v_nr2 NUMBER := &nr2;
rez NUMBER(10);
BEGIN
    IF v_nr2 <> 0 THEN
        rez := v_nr1/v_nr2 + v_nr2;
    ELSE
        rez := v_nr1**2;
    END IF;
DBMS_OUTPUT.PUT_LINE('Rezultat: ' || rez);  
END;
/