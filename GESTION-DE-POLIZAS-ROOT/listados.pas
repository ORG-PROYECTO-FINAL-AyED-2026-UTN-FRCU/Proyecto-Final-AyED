unit listados;
{$codepage UTF8}


interface
uses
  u_clientes,u_polizas,crt,ARCHIVO_POLIZAS,archivo_clientes,validaciones,unit_base_cola_dinamica,u_arbol;
procedure menu_listados(var a:t_archivo_clientes; var ap:t_archivo_polizas;var arbol_clientes,arbol_polizas:T_PUNT_ARBOL);
Procedure mostrar_dato_listado_clientes(var A:t_archivo_clientes;var arbol:T_PUNT_ARBOL);
procedure Listado_clientes(var a:t_archivo_clientes; var reg:t_reg_clientes;var auxy:integer;var arbol:T_PUNT_ARBOL);
procedure listado_de_polizas_vigentes (var a:t_archivo_polizas;var arbol_polizas:t_punt_arbol);

implementation
//listado clientes
procedure encabezado1;
begin
    clrscr;
    gotoxy(1,2);
    write('Apellido');
    gotoxy(16,2);
    write('Nombre');
    gotoxy(30,2);
    write('Dni');
    gotoxy(40,2);
    write('Direccion');
    gotoxy(53,2);
    write('Fecha de nacimiento');
    gotoxy(76,2);
    write('Celular');
    gotoxy(94,2);
    write('Email');
    gotoxy(115,2);
    writeln('Estado');
end;
procedure Listado_clientes(var a:t_archivo_clientes; var reg:t_reg_clientes;var auxy:integer;var arbol:T_PUNT_ARBOL);
var
  pos,i:integer;
  cola1:t_cola;
  dir:word;
begin
 pos:=filesize(a);
 auxy:=3;
 crear_cola(cola1);
 inorden_listado_cliente(arbol,cola1);
 for i:=0 to (pos-1) do
     begin
       desencolar(cola1,dir);
       write('-------------------------------------------------------------------------------------------------------------------------');
      leer_dato(a,dir,reg);
      auxy:=auxy+2;
          begin
            with reg do
                      begin
                        gotoxy(1,auxy);
                        write(apellido);
                        gotoxy(17,auxy);
                        write(nombres);
                        gotoxy(28,auxy);
                        write(dni);
                        gotoxy(40,auxy);
                        write(direccion.calle,' ',direccion.nro);
                        gotoxy(58,auxy);
                        write(fecha_nacimiento.dia,'/',fecha_nacimiento.mes,'/',fecha_nacimiento.ano);
                        gotoxy(75,auxy);
                        write(celular);
                        gotoxy(87,auxy);
                        write(email);
                        gotoxy(116,auxy);
                        if estado=true then
                        begin
                        textcolor(green);
                        writeln('Alta');
                        textcolor(lightgray);
                        end
                        else
                        begin
                          textcolor(red);
                          writeln('Baja');
                          textcolor(lightgray);
                        end;
                      end;
          end;
          if (i mod 9=0) and (i<>0) then  //Reinicia la lista
          begin
          textcolor(red);
          gotoxy(32,auxy+4);
          writeln('Toque una tecla para mostrar la siguiente pagina');
          textcolor(lightgray);
          readkey;
          clrscr;
          auxy:=3;
          encabezado1;
          end;
     end;
end;
Procedure mostrar_dato_listado_clientes(var a:t_archivo_clientes;var arbol:T_PUNT_ARBOL);
var
  auxy:integer;
  reg_clientes:t_reg_clientes;
begin //PARTE FIJA
 encabezado1;
  begin  // PARTE VARIABLE
        Listado_clientes(a,reg_clientes,auxy,arbol);
    readkey;
  end;
end;
procedure encabezado2 (r:t_reg_clientes);
begin
    clrscr;
    gotoxy(1,2);
    write('DATOS DEL CLIENTE:');
    gotoxy(26,2);
    write('DNI: ', r.dni);
    gotoxy(50,2);
    write('Apellido: ', r.apellido);
    gotoxy(80,2);
    write('Nombres: ', r.nombres);
    gotoxy(46,4);
    write('--- DATOS DE LAS POLIZAS ---');
end;
procedure lista_poliza(r:t_reg_polizas ; x,y:integer);
begin
    gotoxy(x,y);
    write('NUMERO DE POLIZA: ',r.numero_poliza);
    gotoxy(x,y+1);
    write('TIPO DE COBERTURA: ',r.cobertura);
    gotoxy(x,y+2);
    write('MARCA: ', r.marca);
    gotoxy(x,y+3);
    write('MODELO: ', r.modelo);
    gotoxy(x,y+4);
    write('PATENTE: ', r.patente);
    gotoxy(x,y+5);
    write('AÑO VEHICULO: ', r.ano_vehiculo);
    gotoxy(x,y+6);
    write('VIGENCIA DESDE: ',r.vigencia_desde.dia, '/',r.vigencia_desde.mes, '/',r.vigencia_desde.ano);
    gotoxy(x,y+7);
    write('VIGENCIA HASTA: ', r.vigencia_hasta.dia, '/',r.vigencia_hasta.mes, '/',r.vigencia_hasta.ano);
    gotoxy(x,y+8);
    write('VALOR VEHICULO: $');
    gotoxy(x,y+9);
    write('CUOTA: $', r.valor_cuota:0:2);
end;
procedure mostrar_polizas(var a:t_archivo_polizas ; dni:string);
var
  x,y,tam,i:integer;
  dato:t_reg_polizas;
begin
  x:=1;              // X e Y sera para ubicar el gotoxy al mostrar
  y:=6;
  tam:=filesize(a);
  for i:= 0 to tam-1 do
    begin
      leer_dato_pol(a,i,dato);
      if dato.dni = dni then
        begin
          lista_poliza(dato,x,y);
          x:=x+30;
          if x = 121 then
            begin
              x:=1;
              if y = 6 then
                y:=20
              else
                y:=6;
            end;
        end;
    end;
  readkey;
end;
//Listado de Polizas de un contratante/cliente
procedure Listado_de_Polizas_de_un_contratante(var a:t_archivo_clientes ; var ap:t_archivo_polizas);
var
  dni:string;
  valido:boolean;
  res:char;
  pos:integer;
  dato:t_reg_clientes;
begin
  ingresar_dni_opciones(dni,valido);
  busqueda_dni(a,dni,pos);
  if pos <> -1 then
    leer_dato(a,pos,dato);
  encabezado2(dato);
  mostrar_polizas(ap,dni);
end;
procedure encabezado3;
begin
    clrscr;
    gotoxy(54,1);
    write('--- POLIZAS ACTIVAS ---');
    gotoxy(1,3);
    write('Fecha vigencia desde');
    gotoxy(32,3);
    write('Numero de poliza');
    gotoxy(60,3);
    write('Contratante');
    gotoxy(82,3);
    write('Patente');
    gotoxy(100,3);
    write('Tipo de cobertura');
end;
procedure listado_de_polizas_vigentes (var a:t_archivo_polizas;var arbol_polizas:t_punt_arbol);
var
  i,x,y:integer;
  cola1:t_cola;
  dir:word;
  reg:t_reg_polizas;
begin
   x:=1;              // X e Y sera para ubicar el gotoxy al mostrar
   y:=6;
  crear_cola(cola1);
  inorden_listado_cliente(arbol_polizas,cola1);
  encabezado3;
  for i:=0 to filesize(a)-1 do
    begin
      desencolar(cola1,dir);
      leer_dato_pol(a,dir,reg);
        begin
          lista_poliza(reg,x,y);
          x:=x+30;
          if x = 121 then
            begin
              x:=1;
              if y = 6 then
                y:=20
              else
                y:=6;
            end;
        end;
      if (i mod 7 = 0) and (i<>0) then
        begin
          gotoxy(38,30);
          textcolor(red);
          writeln('Para pasar a la siguiente pagina, toque un tecla');
          textcolor(lightgray);
          readkey;
          clrscr;
          encabezado3;
          x:=1;
          y:=6;
        end;
    end;
  readkey();
end;
procedure consulta_patente(var a:t_archivo_polizas);
var
  patente:string;
  pos:integer;
  r:t_reg_polizas;
begin
  clrscr;
  ingresar_validar_patente(patente);
  busqueda_patente(a,patente,pos);
  clrscr;
  if pos <> -1 then
    begin
      leer_dato_pol(a,pos,r);
      mostrar_registro_pol(r);
      readkey;
    end;
end;
procedure menu_listados(var a:t_archivo_clientes ; var ap:t_archivo_polizas;var arbol_clientes,arbol_polizas:T_PUNT_ARBOL);
var res:string;
  vc:boolean;
begin
 repeat
     vc:=false;
     clrscr;
     gotoxy(35,10);
     writeln('0: VOLVER');
     gotoxy(35,12);
     writeln('1: LISTADO CLIENTES');
     gotoxy(35,14);
     writeln('2: LISTADO DE POLIZAS DE UN CLIENTE');
     gotoxy(35,16);
     writeln('3: LISTADO DE POLIZAS VIGENTES');
     gotoxy(35,18);
     writeln('4: CONSULTA POR PATENTE');
     res:=readkey;
     case res of
     '0':
         vc:=true;
     '1':
         begin
              mostrar_dato_listado_clientes(a,arbol_clientes);
              vc:=true;
         end;
     '2':
         begin
              Listado_de_Polizas_de_un_contratante(a,ap);
              vc:=true;
         end;
     '3':
         begin
           listado_de_polizas_vigentes(ap,arbol_polizas);
           vc:=True;
         end;
     '4':
         begin
           consulta_patente(ap);
           vc:=True;
         end
     else
         begin
           clrscr;
           gotoxy(35,10);
           TextBackground(red);
           writeln('OPCION INVALIDA. PRESIONE UNA TECLA PARA VOLVER A INGRESAR');
           readkey();
           NormVideo;
           clrscr;
         end;
     end;
   until vc=true;
end;

end.

