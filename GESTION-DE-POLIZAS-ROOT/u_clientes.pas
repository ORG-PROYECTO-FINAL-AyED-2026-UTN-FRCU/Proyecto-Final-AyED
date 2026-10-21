unit u_clientes;
interface
uses
    archivo_clientes;
const
  ruta = 'arch_clientes.DAT';
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
procedure guardar_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
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
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
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
      write('Ingrese nombre: ');
      readln(nombres);
      write('Ingrese direccion ');
      readln(direccion);
      writeln('Fecha nacimiento: ');
      write('Dia: ');
      readln(fecha_nacimiento.dia);
      write('Mes: ');
      readln(fecha_nacimiento.mes);
      write('Año: ');
      readln(fecha_nacimiento.ano);
      write('Ingrese celular: ');
      readln(celular);
      write('Ingrese direccion de e-mail ');
      readln(email);
    end;
end;
begin

end.
