unit validaciones;
{$mode ObjFPC}{$H+}

interface
  uses crt,sysutils,archivo_clientes;
  procedure Ingresar_apellido(var dato:shortstring);
  procedure Ingresar_nombre(var dato:shortstring);
  function ValidarDNI(dni:string): BOOLEAN;
  procedure Validar_T_dato_word(var dato: word);
  function Validar_rango_fecha(var dato: word; min, max: word): boolean;
  function Validar_String(dato: string):boolean;
  function validar_formato_celular( dato: string):boolean;
  procedure validar_celular(var dato: shortstring);
  procedure ingresar_validar_fecha_completo(var reg:reg_fecha; opc:BYTE);
implementation
procedure Ingresar_apellido(var dato:shortstring);
begin
    repeat
      gotoxy(40,11);
      write('Ingrese apellido: ');
      readln(dato);
      if not validar_string(dato) then
        begin
            TextBackground(red);
            gotoxy(36,13);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            clrscr;
        end;
    until Validar_String(dato);
end;
procedure Ingresar_nombre(var dato:shortstring);
begin
    repeat
      gotoxy(40,12);
      write('Ingrese nombre/s: ');
      readln(dato);
      if not validar_string(dato) then
        begin
            TextBackground(red);
            gotoxy(36,14);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            clrscr;
        end;
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
    readln(s);
    val(s, dato, codigo); // Intenta convertir el texto ingresado a número

    if codigo <> 0 then
      valido := false
    else
      if (dato < min) or (dato > max) then
        valido := false
      else
          valido := true; // El número es válido y está dentro del rango
  validar_rango_fecha := valido;
end;
//squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
procedure Validar_T_dato_word(var dato: word);
begin
  repeat
    {$I-}
     readln(dato);
    {$I+}
     if IORESULT<>0 THEN
       begin
       gotoxy(40,22);write('                                               ');
       gotoxy(40,22);
       textbackground(red);
    writeln('TIPO DE DATO INVALIDO. ');
    normvideo;
       end;
  until IOresult=0;
end; //aqui evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O
procedure ingresar_validar_fecha_completo(var reg: reg_fecha; opc: BYTE);
var
  vc:boolean;
begin
  vc:=false;
    case opc of
      1:
        begin
          repeat
            gotoxy(40,15);
            write('                             ');    //limpia esa linea
            gotoxy(40,15);
            write('Dia: ');
            vc:=validar_rango_fecha(reg.dia, 1, 31);
            if not vc then
              begin
                gotoxy(40,17);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(40,17);
                write('                                                   ');  //limpia la linea
              end;
          until vc=True;
        end;
      2:
        begin
          repeat
            gotoxy(40,16);
            write('                             ');    //limpia esa linea
            gotoxy(40,16);
            write('Mes: ');
            vc:=validar_rango_fecha(reg.mes, 1, 12);
            if not vc then
              begin
                gotoxy(40,18);                                                             //validar_rango_fecha(reg.ano, 1900, 2049);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(40,18);
                write('                                                   ');  //limpia la linea
              end;
            until vc=True;
          end;
      3:
        begin
          repeat
            gotoxy(40,17);
            write('                             ');    //limpia esa linea
            gotoxy(40,17);
            write('Año: ');
            vc:=validar_rango_fecha(reg.ano, 1900, 2049);
            if not vc then
              begin
                gotoxy(40,19);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(40,19);
                write('                                                   ');  //limpia la linea
              end;
            until vc=True;
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

procedure validar_celular(var dato: shortstring);
begin
  repeat
    readln(dato);
    if not(validar_formato_celular(dato)) then
      BEGIN
           gotoxy(40,22);   write('                                               ');
           gotoxy(40,22);
           textbackground(red);
      writeln('celular invalido ingrese nuevamente: ');
      NormVideo;
      end;
  until validar_formato_celular(dato);
end;
  end.

