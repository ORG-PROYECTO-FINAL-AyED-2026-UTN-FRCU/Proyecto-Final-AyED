unit u_polizas;
interface
{$codepage UTF8}
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,validaciones,crt;
const
  ruta_polizas='arch_polizas.dat';
procedure abrir_crear_pol (var a:t_archivo_polizas);
procedure leer_dato_pol (var a:t_archivo_polizas ; pos:cardinal ; var dato:t_reg_polizas);
procedure guardar_registro_pol (var a:t_archivo_polizas ; pos:cardinal ; registro:t_reg_polizas);
procedure mostrar_registro_pol (r:t_reg_polizas);
procedure campo_valido_pol(var campo:string);
//ingresar validar
procedure ingresar_marca (var marca:shortstring);
procedure ingresar_modelo (var modelo:shortstring);
procedure ingresar_ano (var ano:CARDINAL);
procedure ingresar_cobertura (var COBERTURA:shortstring);
//procedure ingresar_poliza (var poliza:shortstring);
//fin ingresar validar
procedure modificar_registro_pol (var registro:t_reg_polizas; campo:string; dato_modificado:string;dato_modificado_cardinal:cardinal;dato_modificado_real:real);
procedure modificar_datos_pol(var arch_polizas:t_archivo_polizas ; campo:string ; var pos:longint);
procedure carga_registro_pol (var r:t_reg_polizas ; dni_1:string;Patente_1:string;pos:integer);
procedure busqueda_patente (var a: t_archivo_polizas; patente_buscada:string; var pos: longint);
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
procedure busqueda_patente (var a: t_archivo_polizas; patente_buscada:string; var pos: longint);
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
    if leido.patente = patente_buscada then
    begin
      encontrado := true;
      pos := i;
    end
    else
      i := i + 1;
  end;
end;
procedure mostrar_registro_pol (r:t_reg_polizas);
begin
  with r do
    begin
      gotoxy(35,10);
      writeln('Poliza: ', numero_poliza);
      gotoxy(35,11);
      writeln('DNI: ', dni);
      gotoxy(35,12);
      writeln('Marca: ', marca);
      gotoxy(35,13);
      writeln('Modelo: ', modelo);
      gotoxy(35,14);
      writeln('Año del vehiculo: ', Ano_Vehiculo);
      gotoxy(35,15);
      writeln('Patente: ', patente);
      gotoxy(35,16);
      writeln('Suma asegurada: ', Suma_asegurada:0:2);
      gotoxy(35,17);
      writeln('Cobertura: ', cobertura);
      gotoxy(35,18);
      writeln('Valor de cuota: ', Valor_cuota:0:2);
      gotoxy(35,19);
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
    gotoxy(35,10);
    writeln('Ingrese el campo que quiere modificar ');
    gotoxy(35,12);
    writeln('0:Salir');
    gotoxy(35,13);
    writeln('1:Numero de poliza');
    gotoxy(35,14);
    writeln('2:Marca');
    gotoxy(35,15);
    writeln('3:Modelo');
    gotoxy(35,16);
    writeln('4:Año del vehiculo');
    gotoxy(35,17);
    writeln('5:Patente');
    gotoxy(35,18);
    writeln('6:Suma Asegurdad');
    gotoxy(35,19);
    writeln('7:Cobertura');
    gotoxy(35,20);
    writeln('8:Valor de cuota');
    gotoxy(35,21);
    campo:=readkey;
    case lowercase(campo) of
    '1', '2', '3', '4', '5', '6', '7', '8', '0': valido:=True;

    else
      begin
        textbackground(red);
        gotoxy(35,22);
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
      '1': marca:=dato_modificado;
      '2': modelo:=dato_modificado;
      '3': ano_vehiculo:=dato_modificado_cardinal;
      '4': patente:=dato_modificado;
      '5': suma_asegurada:=dato_modificado_real;
      '6': cobertura:=dato_modificado;
      '7': valor_cuota:=dato_modificado_real;
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
    '1': begin          //marca
          gotoxy(35,10);
          ingresar_marca(dato_modificado);
         end;
    '2':begin    //modelo
          gotoxy(35,10);
          ingresar_Modelo(dato_Modificado);
        end;
    '3': begin         //ano_vehiculo
           clrscr;
           gotoxy(35,10);
           ingresar_ano(dato_modificado_cardinal);
         end;
    '4': ingresar_validar_Patente(dato_modificado); //patente
   { '5':begin       //suma asegurada
          gotoxy(35,10);
          write('Ingrese la nueva suma asegurada ');
          readln(dato_Modificado_real);
        end;          } // ES CON LA TABLA
    '6':begin     //cobertura
          gotoxy(35,10);
          Ingresar_cobertura(dato_Modificado);
        end;
    {'7':begin     //VALOR CUOTA
          gotoxy(35,10);
          write('Ingrese valor de cuota ');
          readln(dato_Modificado_real);
        end;    } // ES CON TABLA

    end;
      modificar_registro_pol(registro_polizas,campo,dato_modificado,dato_modificado_cardinal,dato_modificado_real);
      guardar_registro_pol(arch_polizas,pos,registro_polizas);
    end;
end;
procedure carga_registro_pol (var r:t_reg_polizas ; dni_1:string;Patente_1:string;pos:integer);
begin
  with r do
    begin
      dni:=dni_1;
      patente:=patente_1;
      numero_poliza:=pos+1;
      gotoxy(35,11);
      ingresar_marca(marca);
      gotoxy(35,12);
      ingresar_modelo(modelo);
      gotoxy(35,13);
      ingresar_ano(ano_vehiculo);
      {write('Ingrese suma asegurada ');  {La suma asegurada y valor de cuota se tiene que sacar con un calculo pero por las dudas las dejamos por ahora}
      readln(Suma_asegurada);}
      gotoxy(35,14);
      Ingresar_cobertura(cobertura);
      {writeln('Ingrese valor de cuota ');
      readln(Valor_cuota);}
      estado:=True;
     end;
    end;
procedure ingresar_marca (var marca:shortstring);
var es_valido:boolean;
begin
  repeat
    clrscr;
    gotoxy(35,10);
    write('MARCA: ');
    readln(marca);
    es_valido := Validar_String(marca);
    if not es_valido then
      begin
        gotoxy(35,12);
        TextBackground(red);
        writeln('MARCA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
        readkey();
        NormVideo;
      end;
  until es_valido;
end;

procedure ingresar_modelo (var modelo:shortstring);
var es_valido:boolean;
begin
  repeat
    clrscr;
    gotoxy(35,10);
    write('MODELO: ');
    readln(modelo);
    es_valido := Validar_String(modelo);
    if not es_valido then
      begin
        gotoxy(35,12);
        TextBackground(red);
        writeln('MODELO INVALIDO. PULSE UNA TECLA PARA VOLVER A INGRESAR');
        readkey();
        NormVideo;
      end;
  until es_valido;
end;
procedure ingresar_ano (var ano: cardinal);
var
  es_valido: boolean;
  s: shortstring;
  cod: integer;
  num: longint;
begin
  repeat
    clrscr;
    gotoxy(35, 10);
    write('AÑO DEL VEHICULO: ');
    readln(s);

    val(s, num, cod);
    es_valido := (cod = 0) and (length(s) = 4) and (num >= 2020) and (num <= 2050);

    if es_valido then
      ano := cardinal(num)
    else
      begin
        gotoxy(35, 12);
        textbackground(red);
        writeln('AÑO INVALIDO. PULSE UNA TECLA PARA VOLVER A INGRESAR');
        readkey();
        normvideo;
      end;
  until es_valido;
end;
procedure ingresar_cobertura (var cobertura:shortstring);
var
  es_valido:boolean;
begin
  repeat
    clrscr;
    gotoxy(35,10);
    write('COBERTURA: ');
    readln(cobertura);
    es_valido := Validar_String(cobertura);
    if not es_valido then
      begin
        gotoxy(35,12);
        TextBackground(red);
        writeln('COBERTURA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
        readkey();
        NormVideo;
      end;
  until es_valido;
end;
{
procedure ingresar_poliza (var poliza:shortstring);
var vc,es_valido:boolean; s:shortstring;
begin
 repeat
    gotoxy(35, 10);
    write('                                                       '); // Limpia la línea
    gotoxy(35, 10);
    write('Numero de Poliza: ');

    {$I-}
    readln(s);
    {$I+}

    if IORESULT <> 0 then
      s := '';

    vc := validar_formato_cardinal(s, poliza);

    if not vc then
    begin
      gotoxy(40, 10);
      textbackground(red);
      write('POLIZA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
      normvideo;
      readkey;

      gotoxy(40, 10);
      write('                                                       '); // Limpia el mensaje de error
    end;
  until vc;
end;     }

end.

