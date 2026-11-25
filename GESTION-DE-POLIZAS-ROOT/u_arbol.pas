unit u_arbol;
INTERFACE
uses
u_clientes,u_polizas,ARCHIVO_CLIENTES,ARCHIVO_POLIZAS,unit_base_cola_dinamica;
TYPE
T_DATO_ARBOL = record
clave:string[50];//dni
pos_arch:word;
end;
T_DATO = t_dato_arbol;
T_PUNT_ARBOL = ^T_NODO;
T_NODO = RECORD
INFO:t_dato_arbol;
SAI,SAD: T_PUNT_ARBOL;
END;
PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT_ARBOL);
PROCEDURE AGREGAR (VAR RAIZ:T_PUNT_ARBOL; X:t_dato_arbol);
FUNCTION ARBOL_VACIO (RAIZ:T_PUNT_ARBOL): BOOLEAN;
FUNCTION ARBOL_LLENO (RAIZ:T_PUNT_ARBOL): BOOLEAN;
procedure suprime (var raiz:T_PUNT_ARBOL;x:t_dato);
PROCEDURE INORDEN(VAR RAIZ:T_PUNT_ARBOL);
PROCEDURE PREORDEN(RAIZ:T_PUNT_ARBOL;BUSCADO:CHAR; VAR ENC:BOOLEAN; VAR X:T_DATO);
procedure CARGAR_ARBOL_CLIENTES(VAR RAIZ:T_PUNT_ARBOL;var archivo:t_archivo_clientes);
//procedure CARGAR_ARBOL_POLIZAS(VAR RAIZ:T_PUNT_ARBOL;var archivo_polizas:t_archivo_polizas);
procedure inorden_listado_cliente(var raiz:T_PUNT_ARBOL; var cola:t_cola);
implementation
PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT_ARBOL);
BEGIN
     RAIZ:= NIL;
END;
PROCEDURE AGREGAR (VAR RAIZ:T_PUNT_ARBOL; X:T_DATO);
BEGIN
IF RAIZ = NIL THEN
  BEGIN
    NEW (RAIZ);
    RAIZ^.INFO:= X;
    RAIZ^.SAI:= NIL;
    RAIZ^.SAD:= NIL;
  END
ELSE
    IF RAIZ^.INFO.clave > X.clave THEN
       AGREGAR (RAIZ^.SAI,X)
       ELSE
           AGREGAR (RAIZ^.SAD,X)
END;
FUNCTION ARBOL_VACIO (RAIZ:T_PUNT_ARBOL): BOOLEAN;
  BEGIN
       ARBOL_VACIO:= RAIZ = NIL;
  END;
FUNCTION ARBOL_LLENO (RAIZ:T_PUNT_ARBOL): BOOLEAN;
  BEGIN
        ARBOL_LLENO:= GETHEAPSTATUS.TOTALFREE < SIZEOF (T_NODO);
  END;
function suprime_min (var raiz:T_PUNT_ARBOL): t_dato;
    VAR DIR:T_PUNT_ARBOL;
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
procedure suprime (var raiz:T_PUNT_ARBOL; x:t_dato);
begin
if raiz <> nil then
if x.clave < raiz^.info.clave then
suprime (raiz^.sai,x)
else
if x.clave > raiz^.info.clave then
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
PROCEDURE PREORDEN(RAIZ:T_PUNT_ARBOL;BUSCADO:CHAR; VAR ENC:BOOLEAN; VAR X:T_DATO);
BEGIN
IF (RAIZ = NIL) THEN ENC:= FALSE
ELSE
IF ( RAIZ^.INFO.clave = BUSCADO) THEN
BEGIN
ENC:= TRUE; X:= RAIZ^.INFO
END
ELSE IF RAIZ^.INFO.clave > BUSCADO THEN
PREORDEN(RAIZ^.SAI,BUSCADO,ENC,X)
ELSE
PREORDEN(RAIZ^.SAD,BUSCADO,ENC,X)
END;
PROCEDURE INORDEN(VAR RAIZ:T_PUNT_ARBOL);
BEGIN
IF RAIZ <> NIL THEN BEGIN
INORDEN (RAIZ^.SAI);
WRITELN (RAIZ^.INFO.clave);
INORDEN (RAIZ^.SAD);
end;
END;
{procedure CARGAR_ARBOL_POLIZAS(VAR RAIZ:T_PUNT_ARBOL;var archivo_polizas:t_archivo_polizas);
          var
            i:integer;
            tam:integer;
            dato_salida:t_reg_polizas;
            dato_arbol:t_dato_arbol;
            begin
            CREAR_ARBOL(raiz);
              tam:=filesize(archivo_polizas);
              for i:=0 to tam-1 do
                  begin
                    leer_dato_pol(archivo_polizas,i,dato_salida);
                    dato_arbol.clave:=dato_salida.numero_poliza;
                    dato_arbol.pos_arch:=i;
                    AGREGAR(raiz,dato_arbol);
                  end;
            end;}

procedure inorden_listado_cliente(var raiz:T_PUNT_ARBOL; var cola:t_cola);
          begin
            IF RAIZ <> NIL THEN
            BEGIN
                inorden_listado_cliente (RAIZ^.SAI,cola);
                encolar(cola,RAIZ^.INFO.pos_arch);
                inorden_listado_cliente (RAIZ^.SAD,cola);
            end;
          end;

procedure CARGAR_ARBOL_CLIENTES(VAR RAIZ:T_PUNT_ARBOL;var archivo:t_archivo_clientes);
          var
            i:integer;
            tam:integer;
            dato_salida:t_reg_clientes;
            dato_arbol:t_dato_arbol;
            begin
            CREAR_ARBOL(raiz);
              tam:=filesize(archivo);
              for i:=0 to tam-1 do
                  begin
                    leer_dato(archivo,i,dato_salida);
                    dato_arbol.clave:=dato_salida.apellido+dato_salida.nombres;
                    dato_arbol.pos_arch:=i;
                    AGREGAR(raiz,dato_arbol);
                  end;
            end;
end.

