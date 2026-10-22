unit validaciones;
{$mode ObjFPC}{$H+}

interface
 uses crt,sysutils,archivo_clientes;
 FUNCTION ValidarDNI(dni:string): BOOLEAN;
 PROCEDURE Validar_T_dato_int(var dato: integer);
 PROCEDURE Validar_T_dato_real(var dato: real);
 Procedure ValidarRangoFecha (var reg:Reg_fecha);
 Function Validar_String(var dato: string):boolean;
 Function validar_celular( dato: string):boolean;
implementation
      //Validar Rango Fecha
     Procedure ValidarRangoFecha (var reg:Reg_fecha);
      var
        diaCont,mesCont,anoCont:integer;
        vc:0..1;
        begin
          vc:=0;
          repeat
            writeln('Ingrese dia: ');
            readln(diaCont);
            if (DiaCont<=31) and (diaCont>=1) then
              begin
              vc:=1;
              REG.dia:=diacont;
              end
            Else
            begin
              Writeln('Dia no valido');
              readkey;
            end;
            clrscr;
          until vc=1;
          vc:=0;
          Repeat
            writeln('Ingrese mes: ');
            readln(mesCont);
            if (MesCont<=12) and (MesCont>=1) then
              begin
               vc:=1;
               REG.Mes:=Mescont;
              end
            Else
              begin
                Writeln('Mes no valido');
                readkey;
              end;
            clrscr;
          Until vc=1;
          vc:=0;
          Repeat
            writeln('Ingrese anio: ');
            readln(anoCont);
            If (anoCont>=2020) and (anoCont<=2049) then
            begin
              vc:=1;
              REG.Mes:=Mescont;
            end
            Else
            begin
              Writeln('Ano no valido');
              readkey;
            end;
            clrscr;
          Until Vc=1;
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
    //valida que una cadena sea efectivamente una cadena
    function Validar_String(var dato: string):boolean;
    var i:word;
    control:boolean;
    begin
     control:=true;
         for i:=1 to sizeof(dato) do
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
     for i:=1 to length(dato) do
        begin
        IF NOT (dato[i] IN ['0'..'9']) THEN
        esNumero:=FALSE;
        esvalido:=false;
        end;


      if dato[1]<> '+' then
        esValido := FALSE
      else
        esValido := TRUE;

        validar_celular:=esValido;
    end;
end.

