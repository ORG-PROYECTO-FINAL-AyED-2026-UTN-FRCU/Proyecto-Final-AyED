unit u_clientes;
interface
procedure abrir_crear (var a:t_archivo_cliente);
procedure leer_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
procedure guardar_dato (var a:t_archivo_clientes ; pos:cardinal ; dato:t_reg_clientes);
uses
    Classes, SysUtils, archivo_clientes;

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
