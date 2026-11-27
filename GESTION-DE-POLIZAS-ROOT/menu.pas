unit menu;
{$codepage UTF8}
interface
  uses
    archivo_clientes,archivo_polizas, u_clientes,validaciones, menu_polizas,u_polizas, //, ARBOL, ESTADÍSTICAS
    crt,sysutils,listados,u_arbol;
    //LISTADOS; //LLAMADA A TODAS LAS UNIT NECESARIAS
    procedure menu_principal;
implementation
procedure menu_Cliente_no_encontrado(var arch_clientes:t_archivo_clientes;dni1:string;var arbol,arbol_clientes_dni:T_PUNT_ARBOL);
var
  registro_clientes:t_reg_clientes;
  VC:boolean;
  respuesta:char;
  pos:integer;
  aux_arbol,aux_arbol_dni:t_dato_arbol;
begin
  vc:=false;
  while vc=false do
  begin
    clrscr;
    gotoxy(35,8);
    writeln('0:SALIR');
    gotoxy(35,9);
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
            if confirmar(registro_clientes) then
              begin
                   guardar_registro(arch_clientes,pos,registro_clientes);
                   aux_arbol.clave:=(registro_clientes.apellido+registro_clientes.nombres);
                   aux_arbol.pos_arch:=pos;
                   AGREGAR(arbol,aux_arbol);
                   aux_arbol_dni.clave:=registro_clientes.dni;
                   aux_arbol_dni.pos_arch:=pos;
                   AGREGAR(arbol_clientes_dni,aux_arbol_dni);
              end;
          end
        else
          mensaje_opcion_invalida;
  end;
end;
procedure menu_cliente_encontrado (var arch_clientes:t_archivo_clientes ; dni1:string; var pos:word);
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
  textbackground(Blue);
  gotoxy(35,20);
  write('PULSE UNA TECLA PARA CONTINUAR');
  readkey();
  normVideo;
  clrscr;
  vc:=false;
  while vc=false do
    begin
      gotoxy(35,8);
      writeln('0: VOLVER');
      gotoxy(35,9);
      if registro_clientes.estado = true then
        begin
          writeln('1: DAR DE BAJA');
          gotoxy(35,10);
          writeln('2: MODIFICAR');
        end
      else
        writeln('1: DAR DE ALTA');
      respuesta:=readkey;
      case respuesta of
      '0': begin
             vc:=True;
             clrscr;
           end;
      '1': begin
            vc:=True;
            clrscr;
            textbackground(green);
            gotoxy(30,14);
            if registro_clientes.estado = true then
              begin
              registro_clientes.estado:=False;
              writeln('CLIENTE DADO DE BAJA CORRECTAMENTE. PULSE UNA TECLA PARA CONTINUAR');
              readkey;
              end
            else
              begin
                registro_clientes.estado:=True;
                writeln('CLIENTE DADO DE ALTA CORRECTAMENTE. PULSE UNA TECLA PARA CONTINUAR');
                readkey;
              end;
            normvideo;
            guardar_registro(arch_clientes,pos,registro_clientes);
           end;
      '2': begin
             vc:=true;
             clrscr;
             modificar_datos(arch_clientes,campo,pos);
           end;
      else
        mensaje_opcion_invalida;
      end;
    end;
end;
procedure menu_clientes (var arch_clientes:t_archivo_clientes;var arbol,arbol_clientes_dni:T_PUNT_ARBOL);
var
  res:char;
  dni:string;
  es_valido,enc : boolean;
  pos:T_DATO_ARBOL;
begin
    ingresar_dni_opciones(dni,es_valido,res);
  if (es_valido = True) and (res <> '0') then
    begin
      PREORDEN(arbol_clientes_dni,dni,enc,pos);
      //busqueda_dni(arch_clientes,dni,pos);    //abria q borrar el procedimiento
      if not(enc) then
        menu_Cliente_no_encontrado(arch_clientes,dni,arbol,arbol_clientes_dni)
      else
        menu_cliente_encontrado(arch_clientes,dni,pos.pos_arch);
    end;
end;
procedure menu_principal;
var
  arch_clientes:t_archivo_clientes;
  arch_polizas:t_archivo_polizas;
  arbol_clientes,arbol_polizas_activas,arbol_clientes_dni,arbol_polizas_patente:T_PUNT_ARBOL;
// ARBOL_DNI, ARBOL_NOM:T_PUNT;
  opcion:char;

begin
  abrir_crear(arch_clientes);
  abrir_crear_pol(arch_polizas);

  CREAR_ARBOL(arbol_clientes);                           // arbol 1: ordena por apynom, arbol 2:ordena por fecha de vigencia desde y filtra polizas activas;
  CREAR_ARBOL(arbol_polizas_activas);                    //arbol 3: ordena por dni;
  CREAR_ARBOL(arbol_clientes_dni);                       // arbol 4: ordena por patente, para el listado 4;
  CREAR_ARBOL(arbol_polizas_patente);

  CARGAR_ARBOL_POLIZAS_3(arbol_polizas_activas,arch_polizas);
  CARGAR_ARBOL_CLIENTES(arbol_clientes,arch_clientes);
  CARGAR_ARBOL_CLIENTES_DNI(arbol_clientes_dni,arch_clientes);
  CARGAR_ARBOL_POLIZAS_PATENTE(arbol_polizas_patente,arch_polizas);
//GENERAR ARBOLES
repeat
  clrscr;
  gotoxy(35,8);
  writeln('1- GESTION DE CLIENTES ');
  gotoxy(35,10);
  writeln('2- GESTION DE POLIZAS ');
  gotoxy(35,12);
  writeln('3- LISTADOS ');
  gotoxy(35,14);
  writeln('4- ESTADISTICAS ');
  gotoxy(35,16);
  writeln('0- SALIR ');
  gotoxy(35,18);
  write('INGRESE OPCION: ');
  opcion:=readkey;

    case opcion of
    '0': ;
    '1': menu_clientes(arch_clientes,arbol_clientes,arbol_clientes_dni);
    '2': menu_poliza(arch_polizas,arch_clientes,arbol_polizas_activas,arbol_polizas_patente);
    '3': menu_listados(arch_clientes , arch_polizas,arbol_clientes_dni,arbol_polizas_activas,arbol_polizas_patente);
    //'4': ESTADÍSTICAS (ARCH_CLIENTES,ARCH_POLIZAS);}
    else
      mensaje_opcion_invalida;
    end;
until opcion = '0';
end;
end.

