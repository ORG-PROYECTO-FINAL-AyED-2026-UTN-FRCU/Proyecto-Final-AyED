unit validaciones;
{$mode ObjFPC}{$H+} {$codepage UTF8}

interface
  uses crt,sysutils,archivo_clientes, archivo_polizas;
  function validar_formato_cardinal(s: string; var num: cardinal): boolean;
  function Validar_ano(ano:integer): boolean;
  function ValidarDNI(dni:string): BOOLEAN;
  function validar_formato_word(s: string; var num: word): boolean;
  function Validar_rango_fecha(var dato: word; min, max: word): boolean;
  function Validar_String(dato: string):boolean;
  function validar_formato_celular( dato: string):boolean;
  function Validar_formato_patente (patente:String):boolean;
  function validar_mail(var dato: shortstring):boolean;
  procedure campo_valido_confirmar(var campo:string);
  function Validar_formato_patente_vieja (patente:String):boolean;

implementation




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
  if (length(dato) < 2) then
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
      if cont_espacios>3 then
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

function Validar_formato_patente_vieja (patente:String):boolean;
var VC:boolean;
begin
  if length(patente)<>6 then
    vc:=false
   else
    if not (Upcase(patente[1]) in ['A'..'Z']) or not (Upcase(patente[2]) in ['A'..'Z']) or not (Upcase(patente[3]) in ['A'..'Z']) then
       vc:=false
      else
         if not (Patente[4] in ['0'..'9']) or not (Patente[5] in ['0'..'9']) or not (Patente[6] in ['0'..'9']) then
            Vc:=false
           else
             vc:=true;
  Validar_formato_patente_vieja:=vc;
end;

function Validar_ano(ano:integer): boolean;
var
  codigo: integer;
  valido: boolean;
  s:string;
begin
  valido := true;

  // 1. Validar que tenga exactamente 4 caracteres y sean dígitos
  if length(s) <> 4 then
    valido := false
  else
  begin
    // 2. Intentar convertir a número entero/word
    val(s, ano, codigo);
    if codigo <> 0 then
      valido := false
    else
    begin
      // 3. Validar el rango permitidO
        if (ano < 1930) or (ano > 2050) then
        valido := false;
    end;
  end;

  Validar_ano := valido;
end;



 {validar_formato_cardinal}
function validar_formato_cardinal(s: string; var num: cardinal): boolean;
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
   val(s, num, codigo); // Intenta convertir el texto a cardinal
   if codigo <> 0 then
   begin
     valido := false;
   end;
 end;

 validar_formato_cardinal := valido;
end;

{CONFIRMACIÓN}

procedure campo_valido_confirmar(var campo:string);
var
  valido:boolean;
begin
  valido:=False;
  repeat
    gotoxy(35,10);
    writeln('Ingrese el campo que quiere modificar ');
    gotoxy(35,12);
    writeln('0:Salir');
    gotoxy(35,13);
    writeln('1:Apellido');
    gotoxy(35,14);
    writeln('2:Nombres');
    gotoxy(35,15);
    writeln('3:Direccion');
    gotoxy(35,16);
    writeln('4:Fecha de nacimiento');
    gotoxy(35,17);
    writeln('5:Celular');
    gotoxy(35,18);
    writeln('6:Email');
    gotoxy(78,10);
    campo:=readkey;
    case lowercase(campo) of
    '1', '2', '3', '4', '5', '6', '0': valido:=True;

    else
      begin
        textbackground(red);
        gotoxy(35,20);
        writeln('CAMPO INVALIDO; PULSE UNA TECLA PARA VOLVER A INGRESAR. ');
        readkey();
        normVideo;
        clrscr;
      end;
    end;
  until (valido);
end;




end.


