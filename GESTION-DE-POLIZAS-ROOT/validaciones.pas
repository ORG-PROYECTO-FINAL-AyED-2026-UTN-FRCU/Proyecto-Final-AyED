unit validaciones;

{$mode ObjFPC}{$H+}

interface
 uses sysutils;
 FUNCTION ValidarDNI(dni:string): BOOLEAN;
 PROCEDURE Validar_T_dato_int(var dato: integer);
 PROCEDURE Validar_T_dato_real(var dato: real);

implementation


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

    PROCEDURE Validar_T_dato_int(var dato: integer);
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

end.

