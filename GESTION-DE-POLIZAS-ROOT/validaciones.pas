  unit validaciones;
  {$mode ObjFPC}{$H+}

  interface
   uses crt,sysutils,archivo_clientes;
   FUNCTION ValidarDNI(dni:string): BOOLEAN;
   PROCEDURE Validar_T_dato_word(var dato: word);
   FUNCTION Validar_rango_fecha(var reg: reg_fecha; VAR opc:byte):boolean;
   Function Validar_String(dato: string):boolean;
   procedure validar_apynom(dato:string);
   Function validar_formato_celular( dato: string):boolean;
   procedure validar_celular(dato: string);
   FUNCTION Validar_T_dato_FECHA(var dato: word):BOOLEAN;
   procedure validar_fecha_completo(var reg:reg_fecha; opc:BYTE);
  implementation

   procedure validar_apynom(dato:string);
   begin
        repeat
              if not validar_string(dato) then
                writeln('ERROR, Debe ser una cadena, ingrese nuevamente: ');
                readln(dato);
        until Validar_String(dato);
   end;
        //VALIDACIONES  DE RANGO DE FECHA, DIA Y MES, QUE CUMPLAN RANGOS ESTIPULADOS
  //ESTAS VALIDACIONES NO INVOLUCRAN ANTI-CRASH POR DATO INGRESADO DE TIPO INVALIDO, EJEMPLO SI SE INGRESA UN STRING.
  FUNCTION Validar_rango_fecha(var reg: reg_fecha; VAR opc:byte):boolean;
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
  //squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
  PROCEDURE Validar_T_dato_word(var dato: word);
  begin
  repeat

    {$I-}
     readln(dato);
    {$I+}
     if IORESULT<>0 THEN
    WRITELN('TIPO DE DATO INVALIDO, INGRESE NUEVAMENTE: ');
    until IOresult=0;
  end; //squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O

  function Validar_T_dato_FECHA(var dato: word): boolean;
  begin
  repeat
    {$I-}
     readln(dato);
    {$I+}
    if IORESULT<>0 THEN
      WRITELN('ERROR, INGRESE NUEVAMENTE: ');
    until IOresult=0;
    Validar_T_dato_FECHA:=true;
  end;

  procedure validar_fecha_completo(var reg:reg_fecha; opc:BYTE);
  begin
       repeat
        case opc of
       1:Validar_T_dato_FECHA(reg.dia) ;
       2:Validar_T_dato_FECHA(reg.mes) ;
       3:Validar_T_dato_FECHA(reg.ano) ;
        end;
       if not(validar_rango_fecha(reg,opc)) then
          writeln('ERROR: Rango invalido, reingrese: ');

       until validar_rango_fecha(reg, opc) ;
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


      //valida que una cadena sea efectivamente una cadena
      function Validar_String(dato: string):boolean;
      var i:word;
      control:boolean;
      begin
       control:=true;
           for i:=1 to length(dato) do
           if (not(upcase(dato[i]) in ['A'..'Z'])) or (length(dato)<3) then
              control:=false;
           validar_string:=control;
      end;
      //validar que un numero de celular cumpla formato y sean todos digitos numericos
      Function validar_formato_celular(dato: string):boolean;
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


        if  Not(esnumero) or (length(dato)<3) then
          esValido := FALSE
        else
          esValido := TRUE;

          validar_formato_celular:=esValido;
      end;

      procedure validar_celular( dato: string);
      begin
       repeat
        if not(validar_formato_celular(dato)) then
          writeln('celular invalido ingrese nuevamente: ');
        readln(dato);
        until validar_formato_celular(dato);
      end;
  end.

