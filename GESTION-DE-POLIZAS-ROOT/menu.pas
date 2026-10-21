unit menu;
interface
  uses
    archivo_clientes,archivo_polizas, U_CLIENTES,validaciones,//,ARCHIVO_POLIZAS, ARBOL, ESTADÍSTICAS
    CRT,SYSUTILS;
    //LISTADOS; //LLAMADA A TODAS LAS UNIT NECESARIAS
    procedure menu_principal;
    procedure menu_clientes;
IMPLEMENTATION
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
    '1': menu_clientes;
    {'2': POLIZAS (ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_DNI );
    '3': LISTADOS (ARCH_CLIENTES, ARCH_POLIZAS, ARBOL_NOM);
    '4': ESTADÍSTICAS (ARCH_CLIENTES,ARCH_POLIZAS);
    ELSE
      WRITELN('ERROR, OPCION INVALIDA');}
    END;
until OPCION = '0';
end;
procedure menu_clientes;
var
  arch_clientes:t_archivo_clientes;
  dni:string;
  es_valido : boolean;
begin
  repeat
    write('DNI: ');
    readln(dni);
    es_valido:= ValidarDNI(dni);
    if es_valido = false then
      writeln('DNI INVALIDO. VUELVA A INGRESAR');
  until es_valido = true;
end;
END.
