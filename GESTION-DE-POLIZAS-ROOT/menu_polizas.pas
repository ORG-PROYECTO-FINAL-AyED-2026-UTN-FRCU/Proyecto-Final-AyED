unit Menu_Polizas;
interface
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,archivo_clientes,validaciones,u_clientes,u_polizas,crt,u_arbol;
const
  ruta_polizas='arch_polizas.dat';
procedure menu_poliza (var arch_polizas:t_archivo_polizas;var arch_clientes:t_archivo_clientes;var arbol_poliza,arbol_poliza_patente:T_PUNT_ARBOL);
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; var pos:longint;var arbol_polizas_activas:T_PUNT_ARBOL);
procedure menu_poliza_no_encontrado(var arch_polizas:t_archivo_polizas;dni1:string;patente_1:string;var arbol_poliza,arbol_poliza_patente:T_PUNT_ARBOL);
implementation
procedure menu_poliza_encontrado (var arch_polizas:t_archivo_polizas ; var pos:longint;var arbol_polizas_activas:T_PUNT_ARBOL);
var
  registro_polizas : t_reg_polizas;
  VC:boolean;
  respuesta:char;
  campo:string;
  reg_arbol:T_DATO_ARBOL;
begin
  campo:='';
  clrscr;
  leer_dato_pol(arch_polizas,pos,registro_polizas);
  mostrar_registro_pol(registro_polizas);
  textbackground(Blue);
  gotoxy(35,23);
  write('PULSE UNA TECLA PARA CONTINUAR');
  readkey();
  normVideo;
  clrscr;
  vc:=false;
  while vc=false do
    begin
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
              begin
              registro_polizas.estado:=False;
              reg_arbol.pos_arch:=pos;
              reg_arbol.clave:=inttostr(registro_polizas.vigencia_desde.ano)+inttostr(registro_polizas.vigencia_desde.mes)+inttostr(registro_polizas.vigencia_desde.dia);
              suprime(arbol_polizas_activas,reg_arbol);
              end
            else
              registro_polizas.estado:=True;
            guardar_registro_pol(arch_polizas,pos,registro_polizas);
            clrscr;
           end;
      '2': begin
             vc:=true;
             clrscr;
             modificar_datos_pol(arch_polizas,campo,pos);
             mensaje_datos_modificados
           end;
      else
        mensaje_opcion_invalida;
      end;
    end;
end;

{MENU NO ENCONTRADO}
procedure menu_poliza_no_encontrado(var arch_polizas:t_archivo_polizas;dni1:string;patente_1:string;var arbol_poliza,arbol_poliza_patente:T_PUNT_ARBOL);
var
  registro_polizas:t_reg_polizas;
  VC:boolean;
  respuesta:char;
  pos:integer;
dato_arbol1,dato_arbol2:t_dato_arbol;
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
            dato_arbol1.clave:=inttostr(registro_polizas.vigencia_desde.ano)+inttostr(registro_polizas.vigencia_desde.mes)+inttostr(registro_polizas.vigencia_desde.dia);
            dato_arbol1.pos_arch:=pos;
            carga_registro_pol(registro_polizas,dni1,patente_1,pos);
            AGREGAR(arbol_poliza,dato_arbol1);               //actualiza  el arbol de polizas activas
            dato_arbol2.pos_arch:=pos;
            dato_arbol2.clave:=registro_polizas.patente;
            AGREGAR(arbol_poliza_patente,dato_arbol2);      //actualiza el arbol de polizas ordenado por patente;
            guardar_registro_pol(arch_polizas,pos,registro_polizas);
          end
        else
          mensaje_opcion_invalida;
  end;
end;

procedure menu_patente(var arch_polizas:t_archivo_polizas; dni:string; pos:longint;var arbol_poliza,arbol_poliza_patente:T_PUNT_ARBOL);
var
  patente:string;
  es_valido:boolean;
  aux:t_reg_polizas;
begin
  ingresar_validar_patente(patente);
  busqueda_patente(arch_polizas,patente,pos);
  if pos <> -1 then
    begin
      leer_dato_pol(arch_polizas,pos,aux);
      if aux.dni = dni then
        menu_poliza_encontrado(arch_polizas,pos,arbol_poliza)
      else
        begin
          textbackground(red);
          gotoxy(34,16);
          write('La patente ingresada anteriormente ya se encuentra registrada con otro DNI');
          readkey;
          normvideo;
          clrscr;
        end;
    end
  else
    menu_poliza_no_encontrado(arch_polizas,dni,patente,arbol_poliza,arbol_poliza_patente);
end;
{MENU POLIZA PRINCIPAL}
procedure menu_poliza (var arch_polizas:t_archivo_polizas; var arch_clientes:t_archivo_clientes;var arbol_poliza,arbol_poliza_patente:T_PUNT_ARBOL);
var
  res:char;
  dni:string;
  patente:String;
  es_valido_dni,es_valido_Patente:boolean;
  pos:longint;
  aux:t_reg_clientes;
begin
ingresar_dni_opciones(dni,es_valido_dni,res);
if es_valido_dni = True then
  begin
    busqueda_dni(arch_clientes,dni,pos);
    if pos = -1 then
      begin
        gotoxy(35,15);
        writeln('CLIENTE NO ENCONTRADO. DAR DE ALTA');
        readkey();
      end
    else
      begin
        leer_dato(arch_clientes,pos,aux);
        if aux.estado = False then
          begin
            gotoxy(35,15);
            writeln('ESTADO DEL CLIENTE: INACTIVO. DAR DE ALTA');
            readkey();
          end
        else
          menu_patente(arch_polizas,dni,pos,arbol_poliza,arbol_poliza_patente);
  end;
end;
end;
end.

