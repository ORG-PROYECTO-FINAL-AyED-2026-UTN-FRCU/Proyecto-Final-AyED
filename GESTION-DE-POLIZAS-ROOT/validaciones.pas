unit validaciones;

{$mode ObjFPC}{$H+}

interface
 FUNCTION ValidarDNI(dni:string): BOOLEAN;
 FUNCTION ValidarFecha(fecha:string;anioActual:INTEGER): BOOLEAN;


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
      if (StrToInt(dni) < 1000000) or (StrToInt(dni)>100000000 then
        esValido := FALSE
        else
        esValido := TRUE;
        end;
       validarDNI:=esValido;
    end;


end.

