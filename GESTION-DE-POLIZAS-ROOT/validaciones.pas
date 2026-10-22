unit validaciones;
{$mode ObjFPC}{$H+}

interface
 uses crt,sysutils,archivo_clientes;
 FUNCTION ValidarDNI(dni:string): BOOLEAN;
 PROCEDURE Validar_T_dato_word(var dato: word);
 PROCEDURE Validar_T_dato_real(var dato: real);
 FUNCTION Validar_rango_fecha(var reg: reg_fecha; opc:byte):boolean;
 Function Validar_String(dato: string):boolean;
 Function validar_celular( dato: string):boolean;
implementation
      //VALIDACIONES INDEPENDIENTES DE RANGO DE FECHA, DIA Y MES, QUE CUMPLAN RANGOS ESTIPULADOS
//ESTAS VALIDACIONES NO INVOLUCRAN ANTI-CRASH POR DATO INGRESADO DE TIPO INVALIDO, EJEMPLO SI SE INGRESA UN STRING.
FUNCTION Validar_rango_fecha(var reg: reg_fecha; opc:byte):boolean;
var valido:boolean;
begin
 valido:=true;
 case opc of
     //DIA
     1:begin
     if (reg.dia<1) or (reg.dia >31) then
     valido:=false;
     end;
     //MES
     2:begin
     if (reg.mes<1) or (reg.mes >12) then
     valido:=false;
     end;
     //ANIO
     3:begin
     if (reg.ano >2049) OR (reg.ano <1900) then
     valido:=false;
     end;
 end;
 Validar_rango_fecha:=valido;
end;

     //validacion DNI
     FUNCTION ValidarDNI(dni:string): BOOLEAN;
    var esValido, esNumero : BOOLEAN;
    i:INTEGER;
    begin
    esValido:=FALSE;
    EsNumero:=TRUE;
        for i:=1 to length(dni) do
        begin
        IF NOT (Dni[i] IN ['0'..'9']) THEN
        esNumero:=FALSE
        end;

       //Validacion final
       if (length(dni) < 7) or (length(dni) > 8) or (esNumero=FALSE) then
       esValido:=FALSE
       Else
       begin
      if (StrToInt(dni) < 1000000) or (StrToInt(dni)>100000000) then
        esValido := FALSE
        else
        esValido := TRUE;
        end;
       validarDNI:=esValido;
    end;


     //squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
    PROCEDURE Validar_T_dato_word(var dato: word);
    begin
     while ioresult<>0 do
       begin
       WRITELN('TIPO DE DATO INVALIDO, INGRESE NUEVAMENTE: ');
       {$I-}
        readln(dato);
       {$I+}
       end;
     end;

    PROCEDURE Validar_T_dato_real(var dato: real);
    begin
     while ioresult<>0 do
       begin
       WRITELN('TIPO DE DATO INVALIDO, INGRESE NUEVAMENTE: ');
       {$I-}
        readln(dato);
       {$I+}
       end;
     end;
    //valida que una cadena sea efectivamente una cadena
    function Validar_String(dato: string):boolean;
    var i:word;
    control:boolean;
    begin
     control:=true;
         for i:=1 to length(dato) do
         if not(upcase(dato[i]) in ['A'..'Z']) then
            control:=false;
         validar_string:=control;
    end;
    //validar que un numero de celular cumpla formato y sean todos digitos numericos
    Function validar_celular(dato: string):boolean;
    var i:byte;
        esNumero:boolean;
        esvalido:boolean;
    begin
     EsNumero:=TRUE;
     for i:=2 to length(dato) do
        begin
        IF (NOT (dato[i] IN ['0'..'9']))  THEN
        esNumero:=FALSE;
        end;


      if (dato[1]<> '+') or Not(esnumero) or (length(dato)<2) then
        esValido := FALSE
      else
        esValido := TRUE;

        validar_celular:=esValido;
    end;
end.

