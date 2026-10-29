unit menu;
{$codepage UTF8}
interface
  uses
    archivo_clientes,archivo_polizas, u_clientes,validaciones, menu_polizas, //, ARBOL, ESTADÍSTICAS
    crt,sysutils;
    //LISTADOS; //LLAMADA A TODAS LAS UNIT NECESARIAS
    procedure menu_principal;
implementation
procedure menu_Cliente_no_encontrado(var arch_clientes:t_archivo_clientes;dni1:string);
var
  registro_clientes:t_reg_clientes;
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
            pos:=filesize(arch_clientes);
            carga_registro(registro_clientes,dni1);
            guardar_registro(arch_clientes,pos,registro_clientes);
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
procedure campo_valido(var campo:string);
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
    writeln('1:Apellido');
    gotoxy(40,14);
    writeln('2:Nombres');
    gotoxy(40,15);
    writeln('3:Direccion');
    gotoxy(40,16);
    writeln('4:Fecha de nacimiento');
    gotoxy(40,17);
    writeln('5:Celular');
    gotoxy(40,18);
    writeln('6:Email');
    gotoxy(78,10);
    campo:=readkey;
    case lowercase(campo) of
    '1', '2', '3', '4', '5', '6', '0': valido:=True;

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
procedure modificar_datos (var arch_clientes:t_archivo_clientes ; campo:string ; var pos:longint);
var
  registro_clientes : t_reg_clientes;
  dato_modificado:shortstring;  // CAMBIE ESTO DE STRING--->> ShortString por compatibilidad de rangos en Strings acotados
  fecha_modificada:reg_fecha;
  reg_modificado:reg_fecha;
  dir_modificada:reg_direccion;
begin
  campo_valido(campo);
  leer_dato(arch_clientes,pos,registro_clientes);
  clrscr;
  if campo <> '0' then
    begin
    case campo of
    '1': ingresar_apellido(dato_modificado);
    '2': ingresar_nombre(dato_modificado);
    '3':begin
      ingresar_direccion_calle(dir_modificada.calle);
      ingresar_direccion_nro(dir_modificada.nro);
       end;
    '4': begin
           clrscr;
           gotoxy(40,13);
           writeln('Ingrese la nueva fecha de nacimiento');
           ingresar_validar_fecha_completo(fecha_modificada,1);
           ingresar_validar_fecha_completo(fecha_modificada,2);
           ingresar_validar_fecha_completo(fecha_modificada,3);
           modificar_registro(registro_clientes,campo,dato_modificado,fecha_modificada,dir_modificada);
           guardar_registro(arch_clientes,pos,registro_clientes);
         end;
    '5': ingresar_validar_celular(dato_modificado);
    '6':Ingresar_mail(dato_modificado);

    end;
      modificar_registro(registro_clientes,campo,dato_modificado,fecha_modificada,dir_modificada);
      guardar_registro(arch_clientes,pos,registro_clientes);
    end;

end;
procedure menu_cliente_encontrado (var arch_clientes:t_archivo_clientes ; dni1:string; var pos:longint);
var
  registro_clientes : t_reg_clientes;
  VC:boolean;
  respuesta:char;
  campo:string;
begin
  campo:='';
  clrscr;
  leer_dato(arch_clientes,pos,registro_clientes);
  mostrar_registro(registro_clientes);
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
      if registro_clientes.estado = true then
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
            if registro_clientes.estado = true then
              registro_clientes.estado:=False
            else
              registro_clientes.estado:=True;
            guardar_registro(arch_clientes,pos,registro_clientes);
            clrscr;
           end;
      '2': begin
             vc:=true;
             clrscr;
             modificar_datos(arch_clientes,campo,pos);
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
procedure menu_clientes (var arch_clientes:t_archivo_clientes);
var
  res:char;
  dni:string;
  es_valido : boolean;
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
      begin
        clrscr;
        gotoxy(40,10);
        write('DNI: ');
        readln(dni);
        es_valido:= ValidarDNI(dni);
        if es_valido = false then
          begin
            clrscr;
            gotoxy(40,10);
            TextBackground(red);
            writeln('DNI INVALIDO. PULSE UNA TECLA PARA VOLVER A INGRESAR');
            readkey();
            NormVideo;
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

  until (es_valido = true) or (res = '0');
  busqueda_dni(arch_clientes,dni,pos);
  if es_valido = True then
      if pos = -1 then
        menu_Cliente_no_encontrado(arch_clientes,dni)
      else
        menu_cliente_encontrado(arch_clientes,dni,pos);
end;
procedure menu_principal;
var
  arch_clientes:t_archivo_clientes;
  arch_polizas:t_archivo_polizas;
// ARBOL_DNI, ARBOL_NOM:T_PUNT;
  opcion:char;

begin
  abrir_crear(arch_clientes);
  abrir_crear_pol(arch_polizas);
//GENERAR ARBOLES
repeat
  clrscr;
  gotoxy(40,10);
  writeln('1- GESTION DE CLIENTES ');
  gotoxy(40,12);
  writeln('2- GESTION DE POLIZAS ');
  gotoxy(40,14);
  writeln('3- LISTADOS ');
  gotoxy(40,16);
  writeln('4- ESTADISTICAS ');
  gotoxy(40,18);
  writeln('0- SALIR ');
  gotoxy(40,20);
  writeln('INGRESE OPCION: ');
  gotoxy(56,20);
  opcion:=readkey;

    case opcion of
    '1': menu_clientes(arch_clientes);
    '2': menu_poliza(arch_polizas);
{    '3': LISTADOS (ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_NOM);
    '4': ESTADÍSTICAS (ARCH_CLIENTES,ARCH_POLIZAS);}
    else
      writeln('ERROR, OPCION INVALIDA');
    end;
     if opcion<>'0' then
      begin
        clrscr;
        gotoxy(40,10);
        writeln('PRESIONE UNA TECLA PARA MOSTRAR NUEVAMENTE EL MENU'); READKEY;
      end;
until opcion = '0';
end;
end.

