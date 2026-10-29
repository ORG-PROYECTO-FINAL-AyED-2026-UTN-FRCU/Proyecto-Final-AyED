unit validaciones;
{$mode ObjFPC}{$H+} {$codepage UTF8}

interface
  uses crt,sysutils,archivo_clientes;
  procedure Ingresar_apellido(var dato:shortstring);
  procedure Ingresar_nombre(var dato:shortstring);
  function ValidarDNI(dni:string): BOOLEAN;
  function validar_formato_word(s: string; var num: word): boolean;
  function Validar_rango_fecha(var dato: word; min, max: word): boolean;
  function Validar_String(dato: string):boolean;
  function validar_formato_celular( dato: string):boolean;
  procedure ingresar_validar_celular(var dato: shortstring);
  procedure ingresar_validar_fecha_completo(var reg:reg_fecha; opc:BYTE);
  procedure Ingresar_mail(var dato:shortstring);
  function Validar_formato_patente (patente:String):boolean;
  procedure ingresar_direccion_calle(var calle:shortstring);
  procedure ingresar_direccion_nro(var nro: word);
  function validar_mail(var dato: shortstring):boolean;
  procedure ingresar_dni (var dni:string; var es_valido:boolean);
implementation
    procedure ingresar_dni (var dni:string; var es_valido:boolean);
    begin
      clrscr;
      gotoxy(35,10);
      write('DNI: ');
      readln(dni);
      es_valido:= ValidarDNI(dni);
      if es_valido = false then
        begin
          clrscr;
          gotoxy(35,10);
          TextBackground(red);
          writeln('DNI INVALIDO. PULSE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
        end;
end;
procedure Ingresar_apellido(var dato:shortstring);
begin
    repeat
      gotoxy(35,11);
      write('                                                                                                                   '); //limpia esa linea
      gotoxy(35,11);
      write('Ingrese apellido: ');
      readln(dato);
      if not validar_string(dato) then
        begin
            TextBackground(red);
            gotoxy(35,13);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            gotoxy(35,13);
            write('                                                                                                             '); //limpia esa linea
        end;
    until Validar_String(dato);
end;
procedure Ingresar_nombre(var dato:shortstring);
begin
    repeat
      gotoxy(35,12);
      write('                      '); // borra esa linea
      gotoxy(35,12);
      write('Ingrese nombres: ');
      readln(dato);
      if not validar_string(dato) then
        begin
            TextBackground(red);
            gotoxy(35,14);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            gotoxy(35,14);
            write('                                                                    '); // borra esa linea
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
//squi evitamos que se cierre el programa por errores de tipos de datos usando los controles I/O y manejo de cadenas
 function validar_formato_word(s: string; var num: word): boolean;
var
  codigo: integer;
  valido: boolean;
begin
  valido := true;

  if length(s) = 0 then
  begin
    valido := false;
  end
  else
  begin
    val(s, num, codigo); // Intenta convertir el texto a word
    if codigo <> 0 then
    begin
      valido := false;
    end;
  end;

  validar_formato_word := valido;
end;

procedure ingresar_validar_fecha_completo(var reg: reg_fecha; opc: BYTE);
var
  vc:boolean;
begin
  vc:=false;
    case opc of
      1:
        begin
          repeat
            gotoxy(35,17);
            write('                             ');    //limpia esa linea
            gotoxy(35,17);
            write('Dia: ');
            vc:=validar_rango_fecha(reg.dia, 1, 31);
            if not vc then
              begin
                gotoxy(35,18);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(35,18);
                write('                                                   ');  //limpia la linea
              end;
          until vc=True;
        end;
      2:
        begin
          repeat
            gotoxy(35,18);
            write('                             ');    //limpia esa linea
            gotoxy(35,18);
            write('Mes: ');
            vc:=validar_rango_fecha(reg.mes, 1, 12);
            if not vc then
              begin
                gotoxy(35,19);                                                             //validar_rango_fecha(reg.ano, 1900, 2049);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(35,19);
                write('                                                   ');  //limpia la linea
              end;
            until vc=True;
          end;
      3:
        begin
          repeat
            gotoxy(35,19);
            write('                             ');    //limpia esa linea
            gotoxy(35,19);
            write('Año: ');
            vc:=validar_rango_fecha(reg.ano, 1900, 2049);
            if not vc then
              begin
                gotoxy(35,21);
                TextBackground(red);
                write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
                readkey();
                normvideo;
                gotoxy(35,21);
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
  cont_espacios:byte;
begin
  cont_espacios:=0;
  if (length(dato) <= 3) then
    begin
      control := false;
    end
  else
    begin
      control := true;
      for i := 1 to length(dato) do
        begin
         if not (upcase(dato[i]) in ['A'..'Z',' ']) then
           begin
            control := false;
           end;
         if dato[i]=' ' then
         cont_espacios:=cont_espacios+1;
        end;
      if cont_espacios>1 then
      control:=false;
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

procedure ingresar_validar_celular(var dato: shortstring);
var
  vc:boolean;
begin
  repeat
    gotoxy(35,20);
    write('                             ');   // borra esa linea
    gotoxy(35,20);
    write('Ingrese celular:  ');
    readln(dato);
    vc:=validar_formato_celular(dato);
    if not vc then
      begin
        gotoxy(35,22);
        textbackground(red);
        writeln('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
        readkey;
        NormVideo;
        gotoxy(35,22);
        write('                                                      ');   // borra esa linea
      end;
  until validar_formato_celular(dato);
end;


//validaciones de email y direccion


function validar_mail(var dato: shortstring):boolean;
var i,cont:byte;
    control:boolean;
begin
  cont:=0;
  control:=true;
     if (length(dato) < 3) then
    begin
      control := false;
    end
  else
    begin
      for i := 1 to length(dato) do
        begin
         if (not (upcase(dato[i]) in ['A'..'Z', '0'..'9', '@', '.', '_'])) then
           begin
            control := false;
           end;
         if (dato[i]='@') then
           inc(cont);
        end;
    end;
    if cont<>1 Then
      control:=false;
    validar_mail:=control ;


end;

procedure Ingresar_mail(var dato:shortstring);
begin
    repeat
      gotoxy(35,21);
      write('                                                                                                           ');   // borra esa linea
      gotoxy(35,21);
      write('Ingrese su e-mail (puede contener: letras, arroba, puntos y guion bajo) : ');
      readln(dato);
      if not(validar_mail(dato) ) then
        begin
            TextBackground(red);
            gotoxy(35,23);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            gotoxy(35,23);
            write('                                                                                                                 '); // borra esa linea
        end;

    until validar_mail(dato);
end;

procedure ingresar_direccion_calle(var calle:shortstring);
begin
    repeat
      gotoxy(35,13);
      write('                                                                                                                   '); //limpia esa linea
      gotoxy(35,13);
      writeln('Ingrese direccion ');
      gotoxy(35,14);
      write('                          ');
      gotoxy(35,14);
      write('Nombre de la calle: ');
      readln(calle);
      if not validar_string(calle) then
        begin
            TextBackground(red);
            gotoxy(35,16);
            writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
            gotoxy(35,16);
            write('                                                                                                             '); //limpia esa linea
        end;
    until Validar_String(calle);
end;

  procedure ingresar_direccion_nro(var nro: word);
var
  s: string;
  vc: boolean;
begin
  repeat
    gotoxy(35, 15);
    write('                                                                                                               ');
    gotoxy(35, 15);
    write('Numero de calle: ');

    {$I-}
    readln(s);
    {$I+}

    if IORESULT <> 0 then
      s := '';
    vc := validar_formato_word(s, nro);
    if not vc then
    begin
      gotoxy(35, 17);
      textbackground(red);
      write('TIPO DE DATO INVALIDO O VACIO. PULSE UNA TECLA');
      normvideo;
      readkey;

      gotoxy(35, 17);
      write('                                                                                                               '); // limpia la línea de error
    end;
  until vc;
end;

  {VALIDACION PATENTE}
function Validar_formato_patente (patente:String):boolean;
var VC:boolean;
begin
  if length(patente)<>7 then
    vc:=false
   else
    if not (Upcase(patente[1]) in ['A'..'Z']) or not (Upcase(patente[2]) in ['A'..'Z']) then
       vc:=false
      else
         if not (Upcase(patente[6]) in ['A'..'Z']) or not (Upcase(patente[7]) in ['A'..'Z']) then
           Vc:=false
           else
             if not (Patente[3] in ['0'..'9']) or not (Patente[4] in ['0'..'9']) or not (Patente[5] in ['0'..'9']) then
               Vc:=false
               else
                 vc:=true;
  Validar_formato_patente:=vc;
end;

  end.

