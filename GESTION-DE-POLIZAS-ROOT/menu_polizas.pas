unit Menu_Polizas;
interface
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,validaciones,crt;
const
  ruta_polizas='arch_polizas.dat';
procedure abrir_crear_pol (var a:t_archivo_polizas);
procedure leer_dato_pol (var a:t_archivo_polizas ; pos:cardinal ; var dato:t_reg_polizas);
procedure guardar_registro_pol (var a:t_archivo_polizas ; pos:cardinal ; registro:t_reg_polizas);
procedure mostrar_registro_pol (r:t_reg_polizas);
procedure menu_poliza (var arch_polizas:t_archivo_polizas);
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; dni1:string; var pos:longint);
procedure menu_poliza_no_encontrado(var arch_polizas:t_archivo_polizas;dni1:string;patente_1:string);
implementation
Procedure abrir_crear_pol(var a:t_archivo_polizas);
begin
  assign(a,ruta_polizas);
  {$I-}
  Reset(a);
  {$I+}
  if IOResult <> 0 then
    ReWrite(a);
end;
procedure leer_dato_pol (var a:t_archivo_polizas ; pos:cardinal ; var dato:t_reg_polizas);
begin
  seek(a,pos);
  read(a,dato);
end;
procedure guardar_registro_pol (var a:t_archivo_polizas ; pos:cardinal ; registro:t_reg_polizas);
begin
  seek(a,pos);
  write(a,registro);
end;
{BUSQUEDA}
procedure busqueda_dni_patente (var a: t_archivo_polizas;dni_buscado:string;patente_buscada:string;var pos: longint);
var
  i: cardinal;
  encontrado: boolean;
  leido: t_reg_polizas;
begin
  encontrado := false;
  i := 0;
  pos := -1;
  while (i < filesize(a)) and not encontrado do
  begin
    leer_dato_pol(a, i, leido);
    if (leido.dni = dni_buscado) and (leido.patente = patente_buscada) then
    begin
      encontrado := true;
      pos := i;
    end
    else
      i := i + 1;
  end;
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
procedure mostrar_registro_pol (r:t_reg_polizas);
begin
  with r do
    begin
      gotoxy(40,10);
      writeln('Poliza: ', numero_poliza);
      gotoxy(40,11);
      writeln('DNI: ', dni);
      gotoxy(40,12);
      writeln('Marca: ', marca);
      gotoxy(40,13);
      writeln('Modelo: ', modelo);
      gotoxy(40,14);
      writeln('Ano del vehiculo: ', Ano_Vehiculo);
      gotoxy(40,15);
      writeln('Patente: ', patente);
      gotoxy(40,16);
      writeln('Suma asegurada: ', Suma_asegurada);
      gotoxy(40,17);
      writeln('Cobertura: ', cobertura);
      gotoxy(40,18);
      writeln('Valor de cuota: ', Valor_cuota);
      gotoxy(40,19);
      if estado = true then
        writeln('Estado: ACTIVO')
      else
        writeln('Estado: INACTIVO');
    end;
end;

procedure campo_valido_pol(var campo:string);
var
  valido:boolean;
begin
  valido:=False;
  repeat
    gotoxy(40,10);
    writeln('Ingrese el campo que quiere modificar ');
    gotoxy(40,12);
    writeln('0:Salir');
    gotoxy(40,13);
    writeln('1:Numero de poliza');
    gotoxy(40,14);
    writeln('2:Marca');
    gotoxy(40,15);
    writeln('3:Modelo');
    gotoxy(40,16);
    writeln('4:Ano del vehiculo');
    gotoxy(40,17);
    writeln('5:Patente');
    gotoxy(40,18);
    writeln('6:Suma Asegurdad');
    gotoxy(40,19);
    writeln('7:Cobertura');
    gotoxy(40,20);
    writeln('8:Valor de cuota');
    gotoxy(78,10);
    campo:=readkey;
    case lowercase(campo) of
    '1', '2', '3', '4', '5', '6', '7', '8', '0': valido:=True;

    else
      begin
        textbackground(red);
        gotoxy(40,20);
        writeln('CAMPO INVALIDO; PULSE UNA TECLA PARA VOLVER A INGRESAR. ');
        readkey();
        normVideo;
        clrscr;
      end;
    end;
  until (valido);
end;
procedure modificar_registro_pol (var registro:t_reg_polizas; campo:string; dato_modificado:string;dato_modificado_cardinal:cardinal;dato_modificado_real:real);
begin
  with registro do
    begin
      case campo of
      '1': numero_poliza:=dato_modificado_cardinal;
      '2': marca:=dato_modificado;
      '3': modelo:=dato_modificado;
      '4': ano_vehiculo:=dato_modificado_cardinal;
      '5': patente:=dato_modificado;
      '6': suma_asegurada:=dato_modificado_real;
      '7': cobertura:=dato_modificado;
      '8': valor_cuota:=dato_modificado_real;
      end;
    end;
end;
procedure modificar_datos_pol(var arch_polizas:t_archivo_polizas ; campo:string ; var pos:longint);
var
  registro_polizas : t_reg_polizas;
  dato_modificado:shortstring;
  dato_modificado_cardinal:cardinal;
  dato_modificado_Real:real;
begin
  campo_valido_pol(campo);
  leer_dato_pol(arch_polizas,pos,registro_polizas);
  clrscr;
  if campo <> '0' then
    begin
    case campo of
    '1': begin
           gotoxy(40,10);
           write('Ingrese nuevo numero de poliza ');
           readln(dato_modificado_cardinal);
         end;
    '2': begin
          gotoxy(40,10);
          write('Ingrese marca ');
          readln(dato_modificado);
         end;
    '3':begin
          gotoxy(40,10);
          write('Ingrese modelo ');
          readln(dato_Modificado);
        end;
    '4': begin
           clrscr;
           gotoxy(40,10);
           writeln('Ingrese ano del vehiculo ');
           readln(dato_modificado_cardinal);
         end;
    {'5': ingresar_validar_Patente(dato_modificado);}
    '6':begin
          gotoxy(40,10);
          write('Ingrese la nueva suma asegurada ');
          readln(dato_Modificado_real);
        end;
    '7':begin
          gotoxy(40,10);
          write('Ingrese cobertura ');
          readln(dato_Modificado);
        end;
    '8':begin
          gotoxy(40,10);
          write('Ingrese valor de cuota ');
          readln(dato_Modificado_real);
        end;

    end;
      modificar_registro_pol(registro_polizas,campo,dato_modificado,dato_modificado_cardinal,dato_modificado_real);
      guardar_registro_pol(arch_polizas,pos,registro_polizas);
    end;
end;


procedure carga_registro_pol (var r:t_reg_polizas ; dni_1:string;Patente_1:string);
begin
  with r do
    begin
      dni:=dni_1;
      patente:=patente_1;
      gotoxy(40,13);
      write('Ingrese numero de poliza ');
      readln(numero_poliza);
      gotoxy(40,14);
      write('Ingrese marca ');
      readln(marca);
      gotoxy(40,15);
      write('Ingrese modelo ');
      readln(modelo);
      write('Ingrese ano del vehiculo ');
      readln(ano_Vehiculo);
      {write('Ingrese suma asegurada ');
      readln(Suma_asegurada);}
      write('Ingrese cobertura ');         {La suma asegurada y valor de cuota se tiene que sacar con un calculo pero por las dudas las dejamos por ahora}
      readln(cobertura);
      {writeln('Ingrese valor de cuota ');
      readln(Valor_cuota);}
      estado:=True;
     end;
    end;
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; dni1:string; var pos:longint);
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
      gotoxy(40,20);
      write('PULSE UNA TECLA PARA CONTINUAR');
      readkey();
      normVideo;
      clrscr;
      gotoxy(40,10);
      writeln('0: VOLVER');
      gotoxy(40,11);
      if registro_polizas.estado = true then
        writeln('1: DAR DE BAJA')
      else
        writeln('1: DAR DE ALTA');
      gotoxy(40,12);
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
    gotoxy(40,10);
    writeln('0:SALIR');
    gotoxy(40,11);
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
{MENU POLIZA PRINCIPAL}
procedure menu_poliza (var arch_polizas:t_archivo_polizas);
var
  res:char;
  dni:string;
  patente:String;
  es_valido_dni,es_valido_Patente:boolean;
  pos:longint;
begin
  repeat
    clrscr;
    gotoxy(40,10);
    writeln('0: VOLVER');
    gotoxy(40,11);
    writeln('1: DNI');
    res:=readkey;
    if res = '1' then
      ingresar_dni(dni,es_valido_dni)
    else
      if res <> '0' then
        begin
          clrscr;
          gotoxy(36,10);
          TextBackground(red);
          writeln('OPCION INVALIDA. PRESIONE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
          clrscr;
        end;

  until (es_valido_dni = true) or (res = '0');
        begin
        repeat
        clrscr;
        gotoxy(40,10);
        write('PATENTE: ');
        readln(patente);
        es_valido_Patente:=Validar_formato_patente(patente);
        if es_valido_patente = false then
          begin
            clrscr;
            gotoxy(40,10);
            TextBackground(red);
            writeln('PATENTE INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
          end;
          until es_valido_patente=true;
        end;
      end
    else
      if res <> '0' then
        begin
          clrscr;
          gotoxy(36,10);
          TextBackground(red);
          writeln('OPCION INVALIDA. PRESIONE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
          clrscr;
        end;

  until ((es_valido_DNI = true) and (es_valido_Patente = true)) or (res = '0');
  busqueda_dni_patente(arch_polizas,dni,patente,pos);
  if ((es_valido_DNI = true) and (es_valido_Patente = true)) then
      if pos = -1 then
        menu_poliza_no_encontrado(arch_polizas,dni,patente)
      else
        menu_poliza_encontrado(arch_polizas,dni,pos);
  end;

{MENU ENCONTRADO POLIZA}



end.

