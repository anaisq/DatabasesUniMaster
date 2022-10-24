SET SERVEROUTPUT ON

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

VARIABLE g_sir VARCHAR(25);

BEGIN
:g_sir:='Azi am tot intampinat pb cu sunete';
DBMS_OUTPUT.PUT(g_sir);
END;
/

PRINT g_sir;


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

