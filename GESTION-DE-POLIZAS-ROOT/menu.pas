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
    writeln('0:SALIR');
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
            guardar_dato(arch_clientes,pos,registro_clientes);
          end
        else
            writeln('Respuesta incorrecta reingrese ingrese');
  end;
end;
procedure modificar_datos(var arch_clientes:t_archivo_clientes ; dni1:string ; var pos:cardinal);
var
  res:string;
begin
  repeat
    write('Ingrese el campo que quiere modificar ');
    readln(res);
    if not (res in ['dni','apellido','nombres','direccion','fecha_nacimiento','celular','email']) then
      writeln('CAMPO INVALIDO; VUELVA A INGRESAR');
  until res in ['dni','apellido','nombres','direccion','fecha_nacimiento','celular','email'];

end;
procedure menu_cliente_encontrado (var arch_clientes:t_archivo_clientes ; dni1:string; var pos:cardinal);
var
  registro_clientes : t_reg_clientes;
  VC:boolean;
  respuesta:char;
begin
  leer_dato(arch_clientes,pos,registro_clientes);
  mostrar_registro(registro_clientes);
  vc:=false;
  while vc=false do
    begin
      writeln('0: Dar de baja');
      writeln('1: Modificar');
      writeln('2: volver');
      respuesta:=readkey;
      {case respuesta of
      '1':
        begin
          vc:=True;
          registro_clientes.estado:=False;
        end;
      '2':
      '3': vc:=true;
      else
        writeln('Respuesta incorrecta reingrese ingrese');
      end;}
    end;
end;
procedure menu_clientes (var arch_clientes:t_archivo_clientes);
var
  dni:string;
  es_valido : boolean;
  pos:cardinal;
begin
  repeat
    write('DNI: ');
    readln(dni);
    es_valido:= ValidarDNI(dni);
    if es_valido = false then
      writeln('DNI INVALIDO. VUELVA A INGRESAR');
  until es_valido = true;
  busqueda_dni(arch_clientes,dni,pos);
  if pos = 0 then
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
        writeln('PRESIONE UNA TECLA PARA MOSTRAR NUEVAMENTE EL MENU'); READKEY;
      end;
until OPCION = '0';
end;
END.

