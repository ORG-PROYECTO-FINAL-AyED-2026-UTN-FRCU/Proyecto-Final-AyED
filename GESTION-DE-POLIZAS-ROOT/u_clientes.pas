unit u_clientes;
interface
uses
    archivo_clientes,validaciones;
const
  ruta = 'arch_clientes.DAT';
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
procedure guardar_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
procedure mostrar_registro (r:t_reg_clientes);
procedure carga_registro (var r:t_reg_clientes ; dni_1:string);
procedure busqueda_dni (var a:t_archivo_clientes ; buscado : string; var pos:cardinal);
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
procedure guardar_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
begin
  seek(a,pos);
  write(a,dato);
end;
procedure mostrar_registro (r:t_reg_clientes); //llama primero el leer_dato y dsp el mostrar
begin
  with r do
    begin
      writeln('DNI: ', dni);
      writeln('Apellido: ',apellido);
      writeln('Nombres: ', nombres);
      writeln('Direccion: ', direccion);
      writeln('Fecha nacimiento: ',fecha_nacimiento.dia, '/',fecha_nacimiento.mes, '/', fecha_nacimiento.ano);
      writeln('Celular: ', celular);
      writeln('Direccion e-mail: ', email);
    end;
end;
procedure carga_registro (var r:t_reg_clientes ; dni_1:string);
begin
  with r do
    begin
      dni:=dni_1;
      write('Ingrese apellido: ');
      readln(apellido);
      while not(validar_string(apellido)) do
      begin
           writeln('apellido invalido, ingrese nuevamente: ');
           readln(apellido);
      end;
      write('Ingrese nombre: ');
      readln(nombres);
      while not(validar_string(nombres)) do
      begin
           writeln('nombre invalido, ingrese nuevamente: ');
      end;
      write('Ingrese direccion ');
      readln(direccion);
      validar_string(direccion);
      writeln('Fecha nacimiento: ');
      write('Dia: ');
      readln(fecha_nacimiento.dia);
      write('Mes: ');
      readln(fecha_nacimiento.mes);
      write('Año: ');
      readln(fecha_nacimiento.ano);
      ValidarRangoFecha(r.fecha_nacimiento);
      write('Ingrese celular: +COD.PAIS ');
      readln(celular);
      validar_celular(celular);
      write('Ingrese direccion de e-mail ');
      readln(email);
      estado:=True;
    end;
end;
procedure busqueda_dni (var a:t_archivo_clientes ; buscado : string; var pos:cardinal);
var
  i: cardinal;
  encontrado: boolean;
  leido:t_reg_clientes;
begin
  encontrado:= false;
  i:=0;
  while (i <= filesize(a)) and not encontrado do
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
    pos:=0;
end;
begin

end.
