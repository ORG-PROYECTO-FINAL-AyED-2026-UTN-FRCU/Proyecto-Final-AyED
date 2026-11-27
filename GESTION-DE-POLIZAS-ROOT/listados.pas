unit listados;
{$codepage UTF8}


interface
uses
  u_clientes,u_polizas,crt,ARCHIVO_POLIZAS,archivo_clientes,validaciones,unit_base_cola_dinamica,u_arbol,SysUtils;
procedure menu_listados(var a:t_archivo_clientes ; var ap:t_archivo_polizas;var arbol_clientes,arbol_polizas,arbol_polizas_patente:T_PUNT_ARBOL);
Procedure mostrar_dato_listado_clientes(var A:t_archivo_clientes;var arbol:T_PUNT_ARBOL);
procedure Listado_clientes(var a:t_archivo_clientes; var reg:t_reg_clientes;var auxy:integer;var arbol:T_PUNT_ARBOL);
procedure listado_de_polizas_vigentes (var a:t_archivo_polizas;var ac:t_archivo_clientes;var arbol_polizas,arbol_clientes:t_punt_arbol);

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
    write('VALOR VEHICULO: $', r.suma_asegurada:0:2);
    gotoxy(x,y+9);
    write('CUOTA: $', r.valor_cuota:0:2);
end;
procedure mostrar_polizas(var a:t_archivo_polizas ; dni:string; reg:t_reg_clientes);
var
  x,y,tam,i:integer;
  dato:t_reg_polizas;
  ctt:integer;
begin
  x:=1;              // X e Y sera para ubicar el gotoxy al mostrar
  y:=6;
  ctt:=0;
  tam:=filesize(a);
  for i:= 0 to tam-1 do
    begin
      leer_dato_pol(a,i,dato);
      if dato.dni = dni then
        begin
        ctt:=ctt+1;
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
      if ctt>7 then
        begin
          ctt:=0;
           gotoxy(38,30);
              textcolor(red);
              writeln('Para pasar a la siguiente pagina, toque un tecla');
              textcolor(lightgray);
              readkey;
              clrscr;
              encabezado2(reg);
        end;
    end;
  readkey;
end;
procedure mostrar_registro_pol_apynom (r:t_reg_polizas;nombre,apellido:string);
begin
  with r do
    begin
      gotoxy(40,10);
      writeln('Poliza: ', numero_poliza);
      gotoxy(40,11);
      writeln('DNI: ', dni);
      gotoxy(40,12);
      writeln('Nombre: ', Nombre);
      gotoxy(40,13);
      writeln('Apellido: ', apellido);
      gotoxy(40,14);
      writeln('Marca: ', marca);
      gotoxy(40,15);
      writeln('Modelo: ', modelo);
      gotoxy(40,16);
      writeln('Año del vehiculo: ', Ano_Vehiculo);
      gotoxy(40,17);
      writeln('Patente: ', patente);
      gotoxy(40,18);
      writeln('Suma asegurada: $', Suma_asegurada:0:2);
      gotoxy(40,19);
      writeln('Cobertura: ', cobertura);
      gotoxy(40,20);
      WriteLn('Vigencia desde: ', vigencia_desde.dia,'/',vigencia_desde.mes,'/',vigencia_desde.ano);
      gotoxy(40,21);
      WriteLn('Vigencia hasta: ', vigencia_hasta.dia,'/',vigencia_hasta.mes,'/',vigencia_hasta.ano);
      gotoxy(40,22);
      writeln('Valor de cuota: $', Valor_cuota:0:2);
      gotoxy(40,23);
      if estado = true then
         begin
              write('Estado: ');
              textcolor(green);
              writeln('ACTIVO');
           textcolor(lightgray);
         end
      else
          begin
               write('Estado: ');
               textcolor(red);
               writeln('INACTIVO');
               textcolor(lightgray);
          end;
    end;
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
  ingresar_dni_opciones(dni,valido,res);
  if res <> '0' then
    begin
      busqueda_dni(a,dni,pos);
      if pos <> -1 then
        leer_dato(a,pos,dato);
      encabezado2(dato);
      mostrar_polizas(ap,dni,dato);
    end;
end;
procedure encabezado3;
begin
    clrscr;
    gotoxy(46,2);
    writeln('--- POLIZAS VIGENTES ---');
    write('------------------------------------------------------------------------------------------------------------------------')
end;
procedure lista_poliza_vigente(r:t_reg_polizas ; x,y:integer;var nombre,apellido:string);
begin
    gotoxy(x,y);
    write('FECHA DE VIGENCIA DESDE: ',r.vigencia_desde.dia,'/',r.vigencia_desde.mes,'/',r.vigencia_desde.ano);
    gotoxy(x,y+1);
    write('NUMERO DE POLIZA: ',r.numero_poliza);
    gotoxy(x,y+2);
    write('NOMBRE DEL CONTRATANTE: ',nombre,' ',apellido);
    gotoxy(x,y+3);
    write('DNI CONTRATANTE: ', r.DNI);
    gotoxy(x,y+4);
    write('PATENTE: ', r.patente);
    gotoxy(x,y+5);
    write('TIPO DE COBERTURA: ',r.cobertura);
end;
procedure listado_de_polizas_vigentes (var a:t_archivo_polizas;var ac:t_archivo_clientes;var arbol_polizas,arbol_clientes:t_punt_arbol);
var
  i,x,y:integer;
  cola1:t_cola;
  dir:word;
  reg:t_reg_polizas;
  enc:boolean;
  aux_reg_clientes:t_reg_clientes;
  nombre,apellido:string;
  dato_arbol_cliente:T_DATO_ARBOL;
begin
   x:=1;              // X e Y sera para ubicar el gotoxy al mostrar
   y:=4;
  crear_cola(cola1);
  inorden_listado_cliente(arbol_polizas,cola1);  // DESCAGRA EL ARBOL EN UNA COLA( YA ORDENADO ), PARA DESPUES BUSCAR DE A UN DATO CON EL FOR, Y POSTERIORMENTE MOSTRARLO;
  encabezado3;
  for i:=1 to filesize(a) do
    begin
      if not(cola_vacia(cola1)) then
        begin
          desencolar(cola1,dir);
          leer_dato_pol(a,dir,reg);
          PREORDEN(arbol_clientes,reg.dni,enc,dato_arbol_cliente);       // BUSCAMOS EL DATO FALTANTE (APYNOM) EN EL REG_CLIENTES;
          leer_dato(ac,dato_arbol_cliente.pos_arch,aux_reg_clientes);
          nombre:=aux_reg_clientes.nombres;
          apellido:=aux_reg_clientes.apellido;
            begin
              lista_poliza_vigente(reg,x,y,nombre,apellido);
              x:=x+69;
              if x > 71 then
                begin
                  x:=1;
                  if y < 18 then
                    begin
                      y:=y+7;
                      gotoxy(1,y-1);
                      write('------------------------------------------------------------------------------------------------------------------------')
                    end
                  else
                    y:=4;
                end;
            end;
          if (i mod 6 = 0) and (i<>0) then
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
    end;
  readkey();
end;
procedure consulta_patente(var a:t_archivo_polizas; var arbol_polizas_patente:T_PUNT_ARBOL);
var
  patente:string;
  pos:integer;
  r:t_reg_polizas;
  enc:boolean;
  dato_arbol:T_DATO_ARBOL;
begin
  clrscr;
  ingresar_validar_patente(patente);
  PREORDEN(arbol_polizas_patente,patente,enc,dato_arbol);
  //busqueda_patente(a,patente,pos);                                            //busqueda vieja
  clrscr;
  if enc then
    begin
      leer_dato_pol(a,dato_arbol.pos_arch,r);
      mostrar_registro_pol(r);
      readkey;
    end
  else
  mensaje_patente_no_encontrada;
end;
procedure consulta_poliza(var ap:t_archivo_polizas ;var a:t_archivo_clientes);
          var
            poliza:string;
            pos,poliza_int:integer;
            enc:boolean;
            reg_poliza:t_reg_polizas;
            reg_clientes:t_reg_clientes;
            nombre,apellido:string;
              begin
                ingresar_validar_poliza(poliza);
                poliza_int:=StrToInt(poliza);
                if (poliza_int<=filesize(ap)) then
                  begin
                    busqueda_poliza(ap,poliza_int,pos,enc);
                    if (enc) then
                      begin
                        leer_dato_pol(ap,pos,reg_poliza);
                        busqueda_dni(a,reg_poliza.dni,pos);  //misma variable pos que la busqueda anterior, no se si esta bien, creo que si;
                        leer_dato(a,pos,reg_clientes);
                        nombre:=reg_clientes.nombres;
                        apellido:=reg_clientes.apellido;
                        clrscr;
                        mostrar_registro_pol_apynom(reg_poliza,nombre,apellido);
                        readkey
                      end
                    else
                      begin
                        mensaje_poliza_no_encontrada;
                      end;
                  end
                else
                mensaje_poliza_no_encontrada
end;

procedure menu_listados(var a:t_archivo_clientes ; var ap:t_archivo_polizas;var arbol_clientes,arbol_polizas,arbol_polizas_patente:T_PUNT_ARBOL);
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
     gotoxy(35,20);
     writeln('5: CONSULTA POR POLIZA');
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
           listado_de_polizas_vigentes(ap,a,arbol_polizas,arbol_clientes);
           vc:=True;
         end;
     '4':
         begin
           consulta_patente(ap,arbol_polizas_patente);
           vc:=True;
         end;
     '5':
         begin
          consulta_poliza(ap,a);
          vc:=true;
         end
     else
       mensaje_opcion_invalida;
     end;
   until vc=true;
end;

end.

