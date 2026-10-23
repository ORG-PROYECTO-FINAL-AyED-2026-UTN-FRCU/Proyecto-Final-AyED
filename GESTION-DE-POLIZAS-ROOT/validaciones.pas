unit validaciones;
{$mode ObjFPC}{$H+}

interface
  uses crt,sysutils,archivo_clientes;
  function ValidarDNI(dni:string): BOOLEAN;
  procedure Validar_T_dato_word(var dato: word);
  function Validar_rango_fecha(var dato: word; min, max: word): boolean;
  function Validar_String(dato: string):boolean;
  procedure validar_apynom(var dato:shortstring);
  function validar_formato_celular( dato: string):boolean;
  procedure validar_celular(dato: string);
  procedure validar_fecha_completo(var reg:reg_fecha; opc:BYTE);
implementation

procedure validar_apynom(var dato:shortstring);
begin
    repeat
      readln(dato);
      if not validar_string(dato) then
        writeln('ERROR, Debe ser una cadena, ingrese nuevamente: ');
    until Validar_String(dato);
end;
//VALIDACIONES  DE RANGO DE FECHA, DIA Y MES, QUE CUMPLAN RANGOS ESTIPULADOS
//ESTAS VALIDACIONES NO INVOLUCRAN ANTI-CRASH POR DATO INGRESADO DE TIPO INVALIDO, EJEMPLO SI SE INGRESA UN STRING.
function validar_rango_fecha(var dato: word; min, max: word): boolean;
var
  s: string;  //auxiliar
  codigo: integer;
  valido: boolean;
begin
  valido := false;
  repeat
    readln(s);
    val(s, dato, codigo); // Intenta convertir el texto ingresado a número

    if codigo <> 0 then
      begin
        writeln('TIPO DE DATO INVALIDO. Ingrese nuevamente: ');
      end
    else
      if (dato < min) or (dato > max) then
        begin
          writeln('ERROR: Rango invalido, reingrese: ');
        end
      else
        begin
          valido := true; // El número es válido y está dentro del rango
        end;
  until valido;
  validar_rango_fecha := true;
end;
//squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
procedure Validar_T_dato_word(var dato: word);
begin
  repeat
    {$I-}
     readln(dato);
    {$I+}
     if IORESULT<>0 THEN
    writeln('TIPO DE DATO INVALIDO. ');
  until IOresult=0;
end; //squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
procedure validar_fecha_completo(var reg: reg_fecha; opc: BYTE);
begin
    case opc of
      1:
        begin
          validar_rango_fecha(reg.dia, 1, 31);
        end;
      2:
        begin
          validar_rango_fecha(reg.mes, 1, 12);
        end;
      3:
        begin
          validar_rango_fecha(reg.ano, 1900, 2049);
        end;
    end;
end;

//validacion DNI
function ValidarDNI(dni:string): boolean;
var
    esValido, esNumero : boolean;
    i:integer;
begin
  esValido:=FALSE;
  EsNumero:=TRUE;
  for i:=1 to length(dni) do
    begin
      if not (DNI[i] in ['0'..'9']) then
        esNumero:=false
    end;

  //Validacion final
  if (length(dni) < 7) or (length(dni) > 8) or (esNumero=false) then
    esValido:=false
  else
    begin
      if (StrToInt(dni) < 1000000) or (StrToInt(dni)>100000000) then
        esValido := true
      else
        esValido := true;
    end;
  validarDNI:=esValido;
end;


//valida que una cadena sea efectivamente una cadena
function Validar_String( dato: string):boolean;
var
  i:word;
  control:boolean;
begin
  if (length(dato) < 3) then
    begin
      control := false;
    end
  else
    begin
      control := true;
      for i := 1 to length(dato) do
        begin
         if not (upcase(dato[i]) in ['A'..'Z']) then
           begin
            control := false;
           end;
        end;
    end;
  validar_string:=control;
end;
//validar que un numero de celular cumpla formato y sean todos digitos numericos
Function validar_formato_celular(dato: string):boolean;
var
  i:byte;
  esNumero,esvalido:boolean;
begin
  EsNumero:=TRUE;
  for i:=1 to length(dato) do
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
    readln(dato);
    if not(validar_formato_celular(dato)) then
      writeln('celular invalido ingrese nuevamente: ');
  until validar_formato_celular(dato);
end;
  end.

