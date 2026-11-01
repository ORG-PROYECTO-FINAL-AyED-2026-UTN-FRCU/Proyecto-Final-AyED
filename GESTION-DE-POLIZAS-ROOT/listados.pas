unit listados;


interface
uses
  Classes, SysUtils,u_clientes,crt,archivo_clientes;
procedure menu_listados(var a:t_archivo_clientes);
Procedure mostrar_dato_listado(var A:t_archivo_clientes);
procedure Listado_clientes(var a:t_archivo_clientes; var reg:t_reg_clientes;var auxy:integer);


implementation
procedure encabezado;
begin
clrscr ;
gotoxy(1,2);
write('Nombre');
gotoxy(16,2);
write('Apellido');
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

procedure Listado_clientes(var a:t_archivo_clientes; var reg:t_reg_clientes;var auxy:integer);
var
  pos,i:integer;
begin
 pos:=filesize(a);
 auxy:=3;
 for i:=0 to (pos-1) do
     begin
       write('-------------------------------------------------------------------------------------------------------------------------');
      leer_dato(a,i,reg);
      auxy:=auxy+2;
          begin
            with reg do
                      begin
                        gotoxy(1,auxy);
                        write(nombres);
                        gotoxy(17,auxy);
                        write(apellido);
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
                        writeln('Alta')
                        else
                          writeln('Baja');
                      end;
          end;
          if i=9 then  //Reinicia la lista
          begin
          textcolor(red);
          gotoxy(32,auxy+4);
          writeln('Toque una tecla para mostrar la siguiente pagina');
          textcolor(lightgray);
          readkey;
          clrscr;
          auxy:=3;
          encabezado;
          end;
     end;
end;


Procedure mostrar_dato_listado(var a:t_archivo_clientes);
var
  auxy:integer;
  reg_clientes:t_reg_clientes;
begin //PARTE FIJA
 encabezado;
  begin  // PARTE VARIABLE
        Listado_clientes(a,reg_clientes,auxy);
    readkey;

  end;

end;
procedure menu_listados(var a:t_archivo_clientes);
var res:string;
  vc:boolean;
begin
 repeat
     vc:=false;
     clrscr;
     gotoxy(35,10);
     writeln('0: VOLVER');
     gotoxy(35,11);
     writeln('1: LISTADO CLIENTES0');
     res:=readkey;
     case res of
     '1':
         begin
              mostrar_dato_listado(a);
              vc:=true;
         end;
     '0':
         vc:=true;
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

