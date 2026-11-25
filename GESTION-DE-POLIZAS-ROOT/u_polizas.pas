unit u_polizas;
interface
{$codepage UTF8}
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,validaciones,crt,TABLAS_PROYECTO_FINAL;
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
procedure ingreso_automatico_vig_hasta(var fecha_hasta,fecha_desde:reg_fecha1);
procedure ingresar_validar_fecha_completo_pol(var reg: reg_fecha1; opc: BYTE; opc_mostrar:byte);
procedure ingresar_validar_patente(var patente:string);
procedure ingresar_cobertura (var COBERTURA:shortstring);
//procedure ingresar_poliza (var poliza:shortstring);
//fin ingresar validar
procedure modificar_registro_pol (var registro:t_reg_polizas; campo:string; dato_modificado:string;dato_modificado_cardinal:cardinal;dato_modificado_real:real;dato_modificado_fecha_desde,dato_modificado_fecha_hasta:reg_fecha1);
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
      WriteLn('Vigencia desde: ', vigencia_desde.dia,'/',vigencia_desde.mes,'/',vigencia_desde.ano);
      gotoxy(35,19);
      WriteLn('Vigencia hasta: ', vigencia_hasta.dia,'/',vigencia_hasta.mes,'/',vigencia_hasta.ano);
      gotoxy(35,20);
      writeln('Valor de cuota: ', Valor_cuota:0:2);
      gotoxy(35,21);
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
    writeln('0: Salir');
    gotoxy(35,13);
    writeln('1: Marca');
    gotoxy(35,14);
    writeln('2: Modelo');
    gotoxy(35,15);
    writeln('3: Año del vehiculo');
    gotoxy(35,16);
    writeln('4: Suma Asegurada');
    gotoxy(35,17);
    writeln('5: Cobertura');
    gotoxy(35,18);
    writeln('6: Valor de cuota');
    gotoxy(35,19);
    writeln('7: fecha vigencia desde');
    gotoxy(35,20);
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



procedure modificar_registro_pol (var registro:t_reg_polizas; campo:string; dato_modificado:string;dato_modificado_cardinal:cardinal;dato_modificado_real:real;dato_modificado_fecha_desde,dato_modificado_fecha_hasta:reg_fecha1);
begin
  with registro do
    begin
      case campo of
      '1': marca:=dato_modificado;
      '2': modelo:=dato_modificado;
      '3': ano_vehiculo:=dato_modificado_cardinal;
      '4': suma_asegurada:=dato_modificado_real;
      '5': cobertura:=dato_modificado;
      '6': valor_cuota:=dato_modificado_real;
      '7':begin
               vigencia_desde:=dato_modificado_fecha_desde;
               vigencia_hasta:=dato_modificado_fecha_hasta;
          end;
      end;
    end;
end;


// se precarga la fecha de vigencia hasta para 1 año despues.
procedure ingreso_automatico_vig_hasta(var fecha_hasta,fecha_desde:reg_fecha1);
begin
     fecha_hasta.dia:= Fecha_desde.dia;
     fecha_hasta.mes:= Fecha_desde.mes ;
     fecha_hasta.ano:=Fecha_desde.ano +1; // se le suma 1 para que se venza en un año exacto
end;

procedure modificar_datos_pol(var arch_polizas:t_archivo_polizas ; campo:string ; var pos:longint);
var
  registro_polizas : t_reg_polizas;
  dato_modificado:shortstring;
  dato_modificado_cardinal:cardinal;
  dato_modificado_Real:real;
  dato_modificado_fecha_hasta,dato_modificado_fecha_desde:reg_fecha1;
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
   { '4':begin       //suma asegurada
          gotoxy(35,10);
          write('Ingrese la nueva suma asegurada ');
          readln(dato_Modificado_real);
        end;          } // ES CON LA TABLA
    '5':begin     //cobertura
          gotoxy(35,10);
          Ingresar_cobertura(dato_Modificado);
        end;
    {'6':begin     //VALOR CUOTA
          gotoxy(35,10);
          write('Ingrese valor de cuota ');
          readln(dato_Modificado_real);
        end;    } // ES CON TABLA
    '7': begin    //fecha desde
            ingresar_validar_fecha_completo_pol(dato_modificado_fecha_desde,1,2);
            ingresar_validar_fecha_completo_pol(dato_modificado_fecha_desde,2,2);
            ingresar_validar_fecha_completo_pol(dato_modificado_fecha_desde,3,2);
            ingreso_automatico_vig_hasta(dato_modificado_fecha_hasta,dato_modificado_fecha_desde);  //modificar la fecha de vigencia desde implica modificar la vigencia hasta
          end;
    end;
      modificar_registro_pol(registro_polizas,campo,dato_modificado,dato_modificado_cardinal,dato_modificado_real,dato_modificado_fecha_desde,dato_modificado_fecha_hasta);
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
      ingresar_marca(marca);
      ingresar_modelo(modelo);
      ingresar_ano(ano_vehiculo);
      {write('Ingrese suma asegurada ');  {La suma asegurada y valor de cuota se tiene que sacar con un calculo pero por las dudas las dejamos por ahora}
      readln(Suma_asegurada);}
      Ingresar_cobertura(cobertura);
      clrscr;
      ingresar_validar_fecha_completo_pol(vigencia_desde,1,2);
      ingresar_validar_fecha_completo_pol(vigencia_desde,2,2);
      ingresar_validar_fecha_completo_pol(vigencia_desde,3,2);
      ingreso_automatico_vig_hasta(vigencia_hasta,Vigencia_desde);  //se precarga esto
      {writeln('Valor de cuota: ', Valor_cuota:0:2);}
      {writeln('Ingrese valor de cuota ');
      readln(Valor_cuota);}
      estado:=True;
     end;
    end;


procedure ingresar_validar_patente(var patente:string);
begin
  repeat
    clrscr;
    gotoxy(35,10);
    write('Ingrese patente formato nuevo o viejo (AB123BB, ABC012) ');
    readln(patente);
    patente:=upcase(patente);
    if not (Validar_formato_patente(patente) or Validar_formato_patente_vieja(patente)) then
      begin
          TextBackground(red);
          gotoxy(35,12);
          writeln('PATENTE INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
      end;
  until Validar_formato_patente(patente) or Validar_formato_patente_vieja(patente);
end;

//fecha ingresar validar
procedure ingresar_validar_fecha_completo_pol(var reg: reg_fecha1; opc: BYTE; opc_mostrar:byte);
var
 vc:boolean;
 i:byte;
begin
   vc:=false;
   i:=10;
   case opc of
     1:
       begin
         repeat
           gotoxy(35,i);
           write('                                                                                                       ');    //limpia esa linea
           gotoxy(35,i);
           write('Dia vigencia desde: ');
           vc:=validar_rango_fecha(reg.dia, 1, 31);
           if not vc then
             begin
               gotoxy(35,i+2);
               TextBackground(red);
               write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
               readkey();
               normvideo;
               gotoxy(35,i+2);
               write('                                                   ');  //limpia la linea
             end;
         until vc=True;
       end;
     2:
       begin
         repeat
           gotoxy(35,i+1);
           write('                                                                                                         ');    //limpia esa linea
           gotoxy(35,i+1);
           write('Mes vigencia desde: ');
           vc:=validar_rango_fecha(reg.mes, 1, 12);
           if not vc then
             begin
               gotoxy(35,i+3);                                                             //validar_rango_fecha(reg.ano, 1900, 2049);
               TextBackground(red);
               write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
               readkey();
               normvideo;
               gotoxy(35,i+3);
               write('                                                   ');  //limpia la linea
             end;
           until vc=True;
         end;
     3:
       begin
         repeat
           gotoxy(35,i+2);
           write('                                                                                                          ');    //limpia esa linea
           gotoxy(35,i+2);
           write('Año vigencia desde: ');
           vc:=validar_rango_fecha(reg.ano, 1900, 2049);
           if not vc then
             begin
               gotoxy(35,i+4);
               TextBackground(red);
               write('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
               readkey();
               normvideo;
               gotoxy(35,i+4);
               write('                                                   ');  //limpia la linea
             end;
           until vc=True;
         end;
   end;
end;

procedure ingresar_marca (var marca:shortstring);
var es_valido:boolean;
begin
  repeat
    clrscr;
    gotoxy(35,10);
    write('Marca: ');
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
    write('Modelo del vehiculo: ');
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
    write('Año del vehiculo: ');
    readln(s);

    val(s, num, cod);
    es_valido := (cod = 0) and (length(s) = 4) and (num >= 1920) and (num <= 2026);

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
  res:Char;
begin
  es_valido:=false;
  repeat
    clrscr;
    gotoxy(35,10);
    write('Tipo de cobertura: ');
    gotoxy(35,12);
    write('1: todo riesgo');
    gotoxy(35,13);
    write('2: responsabilidad civil');
    gotoxy(35,14);
    write('3: incendio y robo total');
    gotoxy(35,15);
    write('4: incendio y robo total y parcial');
    gotoxy(35,16);
    write('5: tercero completo');
    res:=readkey;
    case res of
      '1':
        begin
          cobertura:= 'todo riesgo';
          es_valido:=True;
        end;
      '2':
        begin
          cobertura:= 'responsabilidad civil';
          es_valido:=True;
        end;
      '3':
        begin
          cobertura:= 'incendio y robo total';
          es_valido := True;
        end;
      '4':
        begin
          cobertura:= 'incendio y robo total y parcial';
          es_valido := True;
        end;
      '5':
        begin
          cobertura:= 'tercero completo';
          es_valido := True;
        end
      else
        begin
          gotoxy(30,18);
          TextBackground(red);
          writeln('COBERTURA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
        end;
    end;
  until es_valido;
end;
end.

