unit u_clientes;
interface
uses
    archivo_clientes,validaciones;
const
  ruta = 'arch_clientes.DAT';
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
procedure guardar_registro (var a:t_archivo_clientes ; pos:cardinal ; registro:t_reg_clientes);
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string;fecha_modificada:reg_fecha);
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
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string;fecha_modificada:reg_fecha);
begin
  with registro do
    begin
      case campo of
      '1': apellido:=dato_modificado;
      '2': nombres:=dato_modificado;
      '3': direccion:=dato_modificado;
      '4':fecha_nacimiento:=fecha_modificada;
      '5': celular:=dato_modificado;
      '6': email:=dato_modificado;
      end;
    end;
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
      write('Ingrese apellido: ');
      validar_apynom(apellido);
      writeln('Ingrese nombre: ');
     validar_apynom(nombres);
      write('Ingrese direccion ');
      readln(direccion);
      writeln('Fecha nacimiento: ');
      write('Dia: ');
      validar_fecha_completo(fecha_nacimiento,1);
      write('Mes: ');
      validar_fecha_completo(fecha_nacimiento,2);
      write('Año: ');
       validar_fecha_completo(fecha_nacimiento,3);
      write('Ingrese celular:  ');
     validar_celular(celular);
      write('Ingrese direccion de e-mail ');
      readln(email);
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
