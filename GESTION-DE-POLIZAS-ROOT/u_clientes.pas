unit u_clientes;
{$codepage UTF8}
interface
uses
    archivo_clientes,validaciones,crt;
const
  ruta = 'arch_clientes.DAT';
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
procedure guardar_registro (var a:t_archivo_clientes ; pos:cardinal ; registro:t_reg_clientes);
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string;fecha_modificada:reg_fecha;dir_modificada:reg_direccion);
procedure mostrar_registro (r:t_reg_clientes);
procedure carga_registro (var r:t_reg_clientes ; dni_1:string);
procedure busqueda_dni (var a:t_archivo_clientes ; buscado : string; var pos:longint);
implementation
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
      gotoxy(35,16);
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
begin

end.
