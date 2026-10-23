unit menu;
interface
  uses
    archivo_clientes,archivo_polizas, U_CLIENTES,validaciones,//,ARCHIVO_POLIZAS, ARBOL, ESTADÍSTICAS
    CRT,SYSUTILS;
    //LISTADOS; //LLAMADA A TODAS LAS UNIT NECESARIAS
    procedure menu_principal;
IMPLEMENTATION
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
            pos:=filesize(arch_clientes);
            carga_registro(registro_clientes,dni1);
            guardar_registro(arch_clientes,pos,registro_clientes);
          end
        else
          begin
            clrscr;
            TextBackground(red);
            gotoxy(34,10);
            writeln('RESPUESTA INCORRECTA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
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
    writeln('Ingrese el campo que quiere modificar ');
    writeln('1:Apellido');
    writeln('2:Nombres');
    writeln('3:Direccion');
    writeln('4:Fecha de nacimiento');
    writeln('5:Celular');
    writeln('6:Email');
    writeln('0:Salir');
    readln(campo);
    case lowercase(campo) of
    '1', '2', '3', '4', '5', '6', '0': valido:=True;

    else
      writeln('CAMPO INVALIDO; VUELVA A INGRESAR. ');
    end;
  until (valido);
end;
procedure modificar_datos (var arch_clientes:t_archivo_clientes ; campo:string ; var pos:longint);
var
  registro_clientes : t_reg_clientes;
  dato_modificado:shortstring;  // CAMBIE ESTO DE STRING--->> ShortString por compatibilidad de rangos en Strings acotados
  fecha_modificada:reg_fecha;
  reg_modificado:reg_fecha;
begin
  campo_valido(campo);
  leer_dato(arch_clientes,pos,registro_clientes);
  if (campo <> '4') and (campo<>'0') then
    begin
      //VALIDA Y LEE DATO DATO_MODIFICADO
      write('Ingrese el nuevo dato ');
      case campo of
      '1':validar_apynom(dato_modificado);
      '2':validar_apynom(dato_modificado);
      '5':validar_celular(dato_modificado);
      else
        readln(dato_Modificado);
      end;    // PD: SANTI RAMEAU.

      modificar_registro(registro_clientes,campo,dato_modificado,fecha_modificada);
      guardar_registro(arch_clientes,pos,registro_clientes);
    end
  else
  if campo<>'0' then
    begin
      writeln('Ingrese la nueva fecha de nacimiento');
    write('Dia: ');
      validar_fecha_completo(fecha_modificada,1);
      write('Mes: ');
      validar_fecha_completo(fecha_modificada,2);
      write('Año: ');
       validar_fecha_completo(fecha_modificada,3);
     modificar_registro(registro_clientes,campo,dato_modificado,fecha_modificada);
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
  leer_dato(arch_clientes,pos,registro_clientes);
  mostrar_registro(registro_clientes);
  vc:=false;
  while vc=false do
    begin
      writeln('0: volver');
      if registro_clientes.estado = true then
        writeln('1: Dar de baja')
      else
        writeln('1: Dar de alta');
      writeln('2: Modificar');
      respuesta:=readkey;
      case respuesta of
      '0': vc:=True;
      '1': begin
            vc:=True;
            if registro_clientes.estado = true then
              registro_clientes.estado:=False
            else
              registro_clientes.estado:=True;
            guardar_registro(arch_clientes,pos,registro_clientes);
           end;
      '2': begin
             vc:=true;
             modificar_datos(arch_clientes,campo,pos);
           end;
      else
        writeln('opcion invalida ingrese nuevamente.');
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
    if res <> '0' then
      begin
        clrscr;
        gotoxy(40,10);
        writeln('DNI: ');
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
      end;
  until (es_valido = true) or (res = '0');
  busqueda_dni(arch_clientes,dni,pos);
  if es_valido = True then
      if pos = -1 then
        menu_Cliente_no_encontrado(arch_clientes,dni)
      else
        menu_cliente_encontrado(arch_clientes,dni,pos);
end;
PROCEDURE menu_principal;
VAR
  arch_clientes:t_archivo_clientes;
  arch_polizas:t_archivo_polizas;
// ARBOL_DNI, ARBOL_NOM:T_PUNT;
  OPCION:CHAR;

BEGIN
  abrir_crear(arch_clientes);
//GENERAR ARBOLES
repeat
  CLRSCR;
  GOTOXY(40,10);
  WRITELN('1- GESTION DE CLIENTES ');
  GOTOXY(40,12);
  WRITELN('2- GESTION DE POLIZAS ');
  GOTOXY(40,14);
  WRITELN('3- LISTADOS ');
  GOTOXY(40,16);
  WRITELN('4- ESTADISTICAS ');
  GOTOXY(40,18);
  WRITELN('0- SALIR ');
  GOTOXY(40,20);
  WRITELN ('INGRESE OPCION: ');
 OPCION:=READKEY;

    CASE OPCION OF
    '1': menu_clientes(arch_clientes);
    {'2': POLIZAS (ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_DNI );
    '3': LISTADOS (ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_NOM);
    '4': ESTADÍSTICAS (ARCH_CLIENTES,ARCH_POLIZAS);    }
    ELSE
      WRITELN('ERROR, OPCION INVALIDA');
    END;
     if opcion<>'0' then
      begin
        clrscr;
        gotoxy(40,10);
        writeln('PRESIONE UNA TECLA PARA MOSTRAR NUEVAMENTE EL MENU'); READKEY;
      end;
until OPCION = '0';
end;
END.

