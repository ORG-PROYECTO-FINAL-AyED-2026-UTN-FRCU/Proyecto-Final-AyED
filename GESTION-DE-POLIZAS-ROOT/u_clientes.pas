unit u_clientes;
interface
uses
    archivo_clientes,validaciones;
const
  ruta = 'arch_clientes.DAT';
procedure abrir_crear (var a:t_archivo_clientes);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; var dato:t_reg_clientes);
procedure guardar_registro (var a:t_archivo_clientes ; pos:cardinal ; registro:t_reg_clientes);
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string);
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
procedure modificar_registro (var registro:t_reg_clientes; campo:string; dato_modificado:string);
begin
  with registro do
    begin
      case campo of
      'dni': dni:=dato_modificado;
      'apellido': apellido:=dato_modificado;
      'direccion': direccion:=dato_modificado;
      'celular': celular:=dato_modificado;
      'email': email:=dato_modificado
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
      writeln('Ingrese nombre: ');
      readln(nombres);
      while not(validar_string(nombres)) do
      begin
           writeln('nombre invalido, ingrese nuevamente: ');
           readln(nombres);
      end;
      write('Ingrese direccion ');
      readln(direccion);
      writeln('Fecha nacimiento: ');
      write('Dia: ');
      {$I-}
      readln(fecha_nacimiento.dia);
      {$I+}
       Validar_T_dato_int(fecha_nacimiento.dia);
     while not( Validar_rango_fecha(fecha_nacimiento,1)) do
     begin
          writeln('Dia invalido, no esta dentro del rango, ingrese de nuevo:  '); readln(fecha_nacimiento.dia);
     end;
      write('Mes: ');
       {$I-}
      readln(fecha_nacimiento.mes);
      {$I+}
      Validar_T_dato_int(fecha_nacimiento.mes);
     while not( Validar_rango_fecha(fecha_nacimiento,2)) do
     begin
          writeln('Mes invalido, no esta dentro del rango, ingrese de nuevo:  ');
     {$I-}
      readln(fecha_nacimiento.mes);
      {$I+}
      Validar_T_dato_int(fecha_nacimiento.mes);
     end;
      write('Año: ');
       {$I-}
      readln(fecha_nacimiento.ano);
      {$I+}
      Validar_T_dato_int(fecha_nacimiento.ano);
     while not( Validar_rango_fecha(fecha_nacimiento,3)) do
     begin
          writeln('ANIO invalido, no esta dentro del rango, ingrese de nuevo:  ');
          {$I-}
          readln(fecha_nacimiento.ano);
          {$I+}
     end;
      write('Ingrese celular: +COD.PAIS ');
      readln(celular);
      while not(validar_celular(celular)) do
      begin
        writeln('Celular incorrecto, no cumple formato +<CODPAIS><NUMEROS> INGRESE NUEVAMENTE: '); Readln(celular);
      end;
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
