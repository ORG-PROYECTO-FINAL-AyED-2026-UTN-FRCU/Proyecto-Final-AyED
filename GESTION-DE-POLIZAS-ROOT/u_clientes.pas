unit u_clientes;
{$codepage UTF8}
interface
uses
    archivo_clientes,validaciones,crt;
const
  ruta = 'arch_clientes.DAT';
  //ESTOS SON PROCEDIMIENTOS USADOS CON VALIDACONES PARA EL INGRESO SEGURO DE DATOS SANITIZADOS
procedure ingresar_validar_fecha_completo(var reg:reg_fecha; opc:BYTE; opc_mostrar:byte);
procedure Ingresar_mail(var dato:shortstring;opc_mostrar:byte);
procedure Ingresar_apellido(var dato:shortstring);
procedure ingresar_validar_celular(var dato: shortstring;opc_mostrar:byte);
procedure Ingresar_nombre(var dato:shortstring);
procedure ingresar_direccion_calle(var calle:shortstring;opc_mostrar:byte);
procedure ingresar_direccion_nro(var nro: word;opc_mostrar:byte);
procedure ingresar_dni (var dni:string; var es_valido:boolean);
procedure ingresar_dni_opciones (var dni:string; var es_valido : boolean ; var res:char);
  // ESTOS SON PROCEDIMIENTOS PROPIOS  DE LA UNIT DE GESTION DE CLIENTES, REALIZAN LAS FUNCIONES COMO TAL, "ABMC CLIENTES"
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
procedure guardar_registro (var a:t_archivo_clientes ; pos:cardinal ; registro:t_reg_clientes);
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string;fecha_modificada:reg_fecha;dir_modificada:reg_direccion);
procedure mostrar_registro (r:t_reg_clientes);
procedure carga_registro (var r:t_reg_clientes ; dni_1:string);
procedure busqueda_dni (var a:t_archivo_clientes ; buscado : string; var pos:longint);

//otros
Function Confirmar(var reg:t_reg_clientes):boolean;
procedure Modificar_Reg(var reg:t_reg_clientes);
procedure modificar_reg_Confirmacion (var Reg: t_reg_clientes; campo: string);
implementation

//AQUI SE ENCUENTRAN LOS PROCEDIMIENTOS Y FUNCIONES QUE USAN VALIDACIONES PARA EL INGRESO DE DATOS. (1).
procedure ingresar_dni_opciones (var dni:string; var es_valido : boolean;var res:char);
begin
    repeat
    clrscr;
    gotoxy(35,8);
    writeln('0: VOLVER');
    gotoxy(35,9);
    writeln('1: DNI');
    res:=readkey;
    if res = '1' then
      ingresar_dni(dni,es_valido)
    else
      if res <> '0' then
        begin
          clrscr;
          gotoxy(35,10);
          TextBackground(red);
          writeln('OPCION INVALIDA. PRESIONE UNA TECLA PARA VOLVER A INGRESAR');
          readkey();
          NormVideo;
          clrscr;
        end;
    until (es_valido = true) or (res = '0');
end;
procedure ingresar_dni (var dni:string; var es_valido:boolean);
   begin
     clrscr;
     gotoxy(35,8);
     write('DNI: ');
     readln(dni);
     es_valido:= ValidarDNI(dni);
     if es_valido = false then
       begin
         clrscr;
         gotoxy(35,10);
         TextBackground(red);
         writeln('DNI INVALIDO. PULSE UNA TECLA PARA VOLVER A INGRESAR');
         readkey();
         NormVideo;
       end;
end;
procedure Ingresar_apellido(var dato:shortstring);
begin
   repeat
     gotoxy(35,9);
     write('                                                                                                                   '); //limpia esa linea
     gotoxy(35,9);
     write('Ingrese apellido: ');
     readln(dato);
     if not validar_string(dato) then
       begin
           TextBackground(red);
           gotoxy(35,11);
           writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
           readkey();
           NormVideo;
           gotoxy(35,11);
           write('                                                                                                             '); //limpia esa linea
       end;
   until Validar_String(dato);
end;


procedure Ingresar_mail(var dato:shortstring;opc_mostrar:byte);
var
   i:byte;
begin
   if opc_mostrar = 1 then
     i:=19
   else
     i:=11;
   repeat                                                                                                              // borra esa linea
     gotoxy(35,i);
     write('Ingrese su e-mail (puede contener: letras, arroba, puntos y guion bajo) : ');
     gotoxy(35,i+1);
     write('                                                                                                               ');
     gotoxy(35,i+1);
     readln(dato);
     if not(validar_mail(dato) ) then
       begin
           TextBackground(red);
           gotoxy(35,i+2);
           writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
           readkey();
           NormVideo;
           gotoxy(35,i+2);
           write('                                                                                                                 '); // borra esa linea
       end;

   until validar_mail(dato);
end;

procedure ingresar_direccion_calle(var calle:shortstring;opc_mostrar:byte);
var
   i:byte;
begin
 if opc_mostrar = 1 then
   i:=11
 else
   i:=9;
   repeat
     gotoxy(35,i);
     write('                                                                                                                                                    '); //limpia esa linea
     gotoxy(35,i);
     writeln('Ingrese direccion ');
     gotoxy(35,i+1);
     write('                                                                                                                                                                                ');
     gotoxy(35,i+1);
     write('Nombre de la calle: ');
     readln(calle);
     if not validar_string(calle) then
       begin
           TextBackground(red);
           gotoxy(35,i+3);
           writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
           readkey();
           NormVideo;
           gotoxy(35,i+3);
           write('                                                                                                             '); //limpia esa linea
       end;
   until Validar_String(calle);
end;

 procedure ingresar_direccion_nro(var nro: word;opc_mostrar:byte);
var
 s: string;
 vc: boolean;
 i:byte;
begin
 if opc_mostrar = 1 then
   i:=13
 else
   i:=11;
 repeat
   gotoxy(35, i);
   write('                                                                                                               ');
   gotoxy(35, i);
   write('Numero de calle: ');

   {$I-}
   readln(s);
   {$I+}

   if IORESULT <> 0 then
     s := '';
   vc := validar_formato_word(s, nro);
   if (not vc) or (length(s) > 4) then
   begin
     vc:=false;
     gotoxy(35, i+2);
     textbackground(red);
     write('TIPO DE DATO INVALIDO O VACIO. PULSE UNA TECLA');
     normvideo;
     readkey;
     gotoxy(35, i+2);
     write('                                                                                                               '); // limpia la línea de error
   end;
 until vc;
end;


procedure Ingresar_nombre(var dato:shortstring);
begin
   repeat
     gotoxy(35,10);
     write('                                                                                                                '); // borra esa linea
     gotoxy(35,10);
     write('Ingrese nombres: ');
     readln(dato);
     if not validar_string(dato) then
       begin
           TextBackground(red);
           gotoxy(35,12);
           writeln('ENTRADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR');
           readkey();
           NormVideo;
           gotoxy(35,12);
           write('                                                                    '); // borra esa linea
       end;
   until Validar_String(dato);
end;


procedure ingresar_validar_celular(var dato: shortstring; opc_mostrar:byte);
var
 vc:boolean;
 i:byte;
begin
 if opc_mostrar = 1 then
   i:=18
 else
   i:=12;
 repeat
   gotoxy(35,i);
   write('                                                                         ');   // borra esa linea
   gotoxy(35,i);
   write('Ingrese celular:  ');
   readln(dato);
   vc:=validar_formato_celular(dato);
   if not vc then
     begin
       gotoxy(35,i+2);
       textbackground(red);
       writeln('ERROR. PULSE UNA TECLA PARA VOLVER A INGRESAR');
       readkey;
       NormVideo;
       gotoxy(35,i+2);
       write('                                                                    ');   // borra esa linea
     end;
 until validar_formato_celular(dato);
end;


procedure ingresar_validar_fecha_completo(var reg: reg_fecha; opc: BYTE; opc_mostrar:byte);
var
 vc:boolean;
 i:byte;
begin
 vc:=false;
 if opc_mostrar = 1 then
   i:=15
 else
   i:=11;
   case opc of
     1:
       begin
         repeat
           gotoxy(35,i);
           write('                                                                                                       ');    //limpia esa linea
           gotoxy(35,i);
           write('Dia: ');
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
           write('Mes: ');
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
           write('Año: ');
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


//---------------- HASTA ACA LAS FUNCIONES DED INGRESO DE DATOS SEGUROS ------------------------


procedure abrir_crear (var a:t_archivo_clientes);
begin
  assign(a,ruta);
  {$I-}
  Reset(a);
  {$I+}
  if IOResult <> 0 then
    ReWrite(a);
end;
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
begin
  seek(a,pos);
  read(a,dato);
end;
procedure guardar_registro (var a:t_archivo_clientes ; pos:cardinal ; registro:t_reg_clientes);
begin
  seek(a,pos);
  write(a,registro);
end;
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string;fecha_modificada:reg_fecha; dir_modificada:reg_direccion);
begin
  with registro do
    begin
      case campo of
      '1': apellido:=dato_modificado;
      '2': nombres:=dato_modificado;
      '3': direccion:=dir_modificada;
      '4': fecha_nacimiento:=fecha_modificada;
      '5': celular:=dato_modificado;
      '6': email:=dato_modificado;
      end;
    end;
end;
procedure mostrar_registro (r:t_reg_clientes); //llama primero el leer_dato y dsp el mostrar
begin
  with r do
    begin
      gotoxy(35,10);
      writeln('DNI: ', dni);
      gotoxy(35,11);
      writeln('Apellido: ',apellido);
      gotoxy(35,12);
      writeln('Nombres: ', nombres);
      gotoxy(35,13);
      writeln('Direccion: ', direccion.calle, ' ', direccion.nro);
      gotoxy(35,14);
      writeln('Fecha nacimiento: ',fecha_nacimiento.dia, '/',fecha_nacimiento.mes, '/', fecha_nacimiento.ano);
      gotoxy(35,15);
      writeln('Celular: ', celular);
      gotoxy(35,16);
      writeln('Direccion e-mail: ', email);
      gotoxy(35,17);
      if estado = true then
        writeln('Estado: ACTIVO')
      else
        writeln('Estado: INACTIVO');
    end;
end;
procedure carga_registro (var r:t_reg_clientes ; dni_1:string);
begin
  with r do
    begin
      dni:=dni_1;
      Ingresar_apellido(apellido);
      Ingresar_nombre(nombres);
      ingresar_direccion_calle(direccion.calle,1);
      Ingresar_direccion_nro(direccion.nro,1);
      gotoxy(35,14);
      writeln('Fecha nacimiento: ');
      ingresar_validar_fecha_completo(fecha_nacimiento,1,1);
      ingresar_validar_fecha_completo(fecha_nacimiento,2,1);
      ingresar_validar_fecha_completo(fecha_nacimiento,3,1);
      ingresar_validar_celular(celular,1);
      Ingresar_mail(email,1);
      estado:=True;
     end;
    end;
procedure busqueda_dni (var a:t_archivo_clientes ; buscado : string; var pos:longint);
var
  i: cardinal;
  encontrado: boolean;
  leido:t_reg_clientes;
begin
  encontrado:= false;
  i:=0;
  while (i < filesize(a)) and not encontrado do
    begin
      leer_dato(a,i,leido);
      if leido.dni = buscado then
        encontrado:=true
      else
        i:= i+1;
    end;
  if encontrado then
    pos:=i
  else
    pos:=-1;
end;


procedure modificar_reg_Confirmacion (var Reg: t_reg_clientes; campo: string);
var dato_modificado:shortstring;
  dir_modificada:reg_direccion ;
  fecha_modificada:reg_fecha;
begin
   clrscr;
  campo_valido_confirmar(campo);
  clrscr;
   if campo <> '0' then
    begin
    case campo of
    '1': ingresar_apellido(dato_modificado);
    '2': ingresar_nombre(dato_modificado);
    '3':begin
      ingresar_direccion_calle(dir_modificada.calle,2);
      ingresar_direccion_nro(dir_modificada.nro,2);
       end;
    '4': begin
           clrscr;
           gotoxy(35,10);
           writeln('Ingrese la nueva fecha de nacimiento');
           ingresar_validar_fecha_completo(fecha_modificada,1,2);
           ingresar_validar_fecha_completo(fecha_modificada,2,2);
           ingresar_validar_fecha_completo(fecha_modificada,3,2);
           modificar_registro(Reg,campo,dato_modificado,fecha_modificada,dir_modificada);
         end;
    '5': ingresar_validar_celular(dato_modificado,2);
    '6':Ingresar_mail(dato_modificado,2);

    end;
      modificar_registro(Reg,campo,dato_modificado,fecha_modificada,dir_modificada);
    end;
  clrscr;
  mostrar_registro(reg);

end;


procedure Modificar_Reg(var reg:t_reg_clientes);
          var
            pos:string;
            campo:string;
          begin
            modificar_reg_Confirmacion(reg,pos);
          end;
procedure no_confirmar (var reg:t_reg_clientes ; var confirmar:boolean);
var
  resp:char;
  vc:boolean;
  campo:string;
begin
 vc:=false;
repeat
  gotoxy(50,22);
  write('                                   ');
  gotoxy(50,22);
  Writeln('¿Desea Modificar datos?');
  gotoxy(50,23);
  write('                                   ');
  gotoxy(50,23);
  Writeln('1: Modificar');
  gotoxy(50,24);
  write('                                   ');
  gotoxy(50,24);
  Write('0: Salir');
  Resp:=readkey;
  Case Resp of
  '1':begin
        Modificar_Reg_confirmacion(Reg,campo);
        vc:=true;
        confirmar:=true;
      end;
  '0': vc:=true;
  else
    begin
      gotoxy(36,26);
      writeln('OPCION SELECCIONADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR.');
      readkey();
      gotoxy(36,26);
      write('                                                                             ');
    end;
  end;
until vc=true;
end;
Function Confirmar(var reg:t_reg_clientes):boolean;
Var resp:char;
    vc:boolean;
begin
   confirmar:=false;

repeat
  gotoxy(50,22);
  writeln('¿Desea confirmar datos?');
  gotoxy(50,23);
  writeln('1: confirmar');
  gotoxy(50,24);
  write('0: no confirmar') ;
  resp:=readkey;
  case resp of
    '1':begin
          vc:=true;
          Confirmar:=true;
        end;
    '0':Begin
          no_confirmar(reg,confirmar);
        end;
    else
        begin
          gotoxy(36,26);
          writeln('OPCION SELECCIONADA INVALIDA. PULSE UNA TECLA PARA VOLVER A INGRESAR.');
          readkey();
          gotoxy(36,26);
          writeln('                                                                        ');
        end;
        end;
 until vc;
end;


begin

end.
