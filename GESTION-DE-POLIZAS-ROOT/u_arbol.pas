unit u_arbol;
T_DATO_ARBOL = record
clave:string[100]; //clave será o legajo o apynom
pos_arch:word;
end; }
TYPE
T_DATO = CHAR;
T_PUNT = ^T_NODO;
T_NODO = RECORD
INFO:T_DATO;
SAI,SAD: T_PUNT;
END;
PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT);
PROCEDURE AGREGAR (VAR RAIZ:T_PUNT; X:T_DATO);
FUNCTION ARBOL_VACIO (RAIZ:T_PUNT): BOOLEAN;
FUNCTION ARBOL_LLENO (RAIZ:T_PUNT): BOOLEAN;
procedure suprime (var raiz:t_punt;x:t_dato);
PROCEDURE INORDEN(VAR RAIZ:T_PUNT);
PROCEDURE PREORDEN(RAIZ:T_PUNT;BUSCADO:CHAR; VAR ENC:BOOLEAN; VAR X:T_DATO);
implementation
PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT);
BEGIN
RAIZ:= NIL;
END;
PROCEDURE AGREGAR (VAR RAIZ:T_PUNT; X:T_DATO);
BEGIN
IF RAIZ = NIL THEN
BEGIN
NEW (RAIZ);
RAIZ^.INFO:= X;
RAIZ^.SAI:= NIL;
RAIZ^.SAD:= NIL;
END
ELSE IF RAIZ^.INFO > X THEN AGREGAR (RAIZ^.SAI,X)
ELSE AGREGAR (RAIZ^.SAD,X)
END;
FUNCTION ARBOL_VACIO (RAIZ:T_PUNT): BOOLEAN;
BEGIN
ARBOL_VACIO:= RAIZ = NIL;
END;
FUNCTION ARBOL_LLENO (RAIZ:T_PUNT): BOOLEAN;
BEGIN
ARBOL_LLENO:= GETHEAPSTATUS.TOTALFREE < SIZEOF (T_NODO);
END;
function suprime_min (var raiz:t_punt): t_dato;
VAR DIR:T_PUNT;
begin
if RAIZ^.SAI = nil then
begin
suprime_min:= raiz^.info;
DIR:=RAIZ;
raiz:=raiz^.sad;
DISPOSE (DIR);
end
else
suprime_min:= suprime_min (raiz^.sai)
end;
procedure suprime (var raiz:t_punt; x:t_dato);
begin
if raiz <> nil then
if x < raiz^.info then
suprime (raiz^.sai,x)
else
if x > raiz^.info then
suprime (raiz^.sad,x)
else
if (raiz^.sai = nil) and (raiz^.sad = nil) then
raiz:= nil
else
if (raiz^.sai = nil) then
raiz:= raiz^.sad
else
if (raiz^.sad = nil) then
raiz:= raiz^.sai
else
raiz^.info:= suprime_min (raiz^.sad)
end;
PROCEDURE PREORDEN(RAIZ:T_PUNT;BUSCADO:CHAR; VAR ENC:BOOLEAN; VAR X:T_DATO);
BEGIN
IF (RAIZ = NIL) THEN ENC:= FALSE
ELSE
IF ( RAIZ^.INFO = BUSCADO) THEN
BEGIN
ENC:= TRUE; X:= RAIZ^.INFO
END
ELSE IF RAIZ^.INFO > BUSCADO THEN
PREORDEN(RAIZ^.SAI,BUSCADO,ENC,X)
ELSE
PREORDEN(RAIZ^.SAD,BUSCADO,ENC,X)
END;
PROCEDURE INORDEN(VAR RAIZ:T_PUNT);
BEGIN
IF RAIZ <> NIL THEN BEGIN
INORDEN (RAIZ^.SAI);
WRITELN (RAIZ^.INFO);
INORDEN (RAIZ^.SAD);
end;
END;
end.

