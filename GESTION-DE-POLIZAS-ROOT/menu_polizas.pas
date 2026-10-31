unit Menu_Polizas;
interface
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,archivo_clientes,validaciones,u_clientes,u_polizas,crt;
const
  ruta_polizas='arch_polizas.dat';
procedure menu_poliza (var arch_polizas:t_archivo_polizas;var arch_clientes:t_archivo_clientes);
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; var pos:longint);
procedure menu_poliza_no_encontrado(var arch_polizas:t_archivo_polizas;dni1:string;patente_1:string);
implementation
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
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; var pos:longint);
var
  registro_polizas : t_reg_polizas;
  VC:boolean;
  respuesta:char;
  campo:string;
begin
  campo:='';
  clrscr;
  leer_dato_pol(arch_polizas,pos,registro_polizas);
  mostrar_registro_pol(registro_polizas);
  vc:=false;
  while vc=false do
    begin
      textbackground(Blue);
      gotoxy(35,20);
      write('PULSE UNA TECLA PARA CONTINUAR');
      readkey();
      normVideo;
      clrscr;
      gotoxy(35,10);
      writeln('0: VOLVER');
      gotoxy(35,11);
      if registro_polizas.estado = true then
        writeln('1: DAR DE BAJA')
      else
        writeln('1: DAR DE ALTA');
      gotoxy(35,12);
      writeln('2: MODIFICAR');
      respuesta:=readkey;
      case respuesta of
      '0': begin
             vc:=True;
             clrscr;
           end;
      '1': begin
            vc:=True;
            if registro_polizas.estado = true then
              registro_polizas.estado:=False
            else
              registro_polizas.estado:=True;
            guardar_registro_pol(arch_polizas,pos,registro_polizas);
            clrscr;
           end;
      '2': begin
             vc:=true;
             clrscr;
             modificar_datos_pol(arch_polizas,campo,pos);
             clrscr;
           end;
      else
        begin
           clrscr;
           gotoxy(40,10);
           textbackground(red);
          writeln('OPCION SELECCIONADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR.');
          readkey();
          normVideo;
          CLRSCR;
        end;
      end;
    end;
end;

{MENU NO ENCONTRADO}
procedure menu_poliza_no_encontrado(var arch_polizas:t_archivo_polizas;dni1:string;patente_1:string);
var
  registro_polizas:t_reg_polizas;
  VC:boolean;
  respuesta:char;
  pos:integer;
begin
  vc:=false;
  while vc=false do
  begin
    clrscr;
    gotoxy(35,10);
    writeln('0:SALIR');
    gotoxy(35,11);
    writeln('1:DAR DE ALTA');
    respuesta:=readkey;
    if respuesta='0' then
      vc:=true
      else
        if respuesta ='1' then
          begin
            vc:=true;
            clrscr;
            pos:=filesize(arch_polizas);
            carga_registro_pol(registro_polizas,dni1,patente_1);
            guardar_registro_pol(arch_polizas,pos,registro_polizas);
          end
        else
          begin
            clrscr;
            TextBackground(red);
            gotoxy(34,10);
            writeln('OPCION SELECCIONADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
          end;
  end;
end;
procedure ingresar_patente (var patente:string);
var
  es_valido_Patente:boolean;
begin
repeat
clrscr;
gotoxy(35,10);
write('Ingrese patente: ');
readln(patente);
es_valido_Patente:=Validar_formato_patente(patente);
if es_valido_patente = false then
  begin
    clrscr;
    gotoxy(35,12);
    TextBackground(red);
    writeln('PATENTE INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
    readkey();
    NormVideo;
  end;
  until es_valido_patente=true;
end;
procedure menu_patente(var arch_polizas:t_archivo_polizas; dni:string; pos:longint);
var
  patente:string;
  es_valido:boolean;
begin
  ingresar_patente(patente);
  busqueda_patente(arch_polizas,patente,pos);
  if pos <> -1 then                                           {SEGUIR ACA}
    menu_poliza_encontrado(arch_polizas,pos)
  else
    menu_poliza_no_encontrado(arch_polizas,dni,patente);
end;
{MENU POLIZA PRINCIPAL}
procedure menu_poliza (var arch_polizas:t_archivo_polizas; var arch_clientes:t_archivo_clientes);
var
  res:char;
  dni:string;
  patente:String;
  es_valido_dni,es_valido_Patente:boolean;
  pos:longint;
  aux:t_reg_clientes;
begin
  repeat
    clrscr;
    gotoxy(35,10);
    writeln('0: VOLVER');
    gotoxy(35,11);
    writeln('1: DNI');
    res:=readkey;
    if res = '1' then
      ingresar_dni(dni,es_valido_dni)
    else
      if res <> '0' then
        begin
          clrscr;
          gotoxy(35,10);
          TextBackground(red);
          writeln('OPCION INVALIDA. PRESIONE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
          clrscr;
        end;
  until (es_valido_dni = true) or (res = '0');
if es_valido_dni = True then
  begin
    busqueda_dni(arch_clientes,dni,pos);
    if pos = -1 then
      begin
        gotoxy(35,15);
        writeln('Cliente no encontrado . Dar de alta');
        readkey();
      end
    else
      begin
        leer_dato(arch_clientes,pos,aux);
        if aux.estado = False then
          begin
            gotoxy(35,15);
            writeln('Estado del cliente: INACTIVO. Dar de alta');
            readkey();
          end
        else
          menu_patente(arch_polizas,dni,pos);
  end;
end;
end;
end.

