unit Menu_Polizas;
interface
uses
  Classes, SysUtils,ARCHIVO_POLIZAS,validaciones;
const
  ruta='ARCHIVO_POLIZAS.DAT';
procedure abrir_crear (var a:t_archivo_polizas);
procedure leer_dato (var a:t_archivo_polizas ; pos:cardinal ; var dato:t_reg_polizas);
procedure guardar_registro (var a:t_archivo_polizas ; pos:cardinal ; registro:t_reg_polizas);
implementation
Procedure abrir_crear (var a:t_archivo_polizas);
begin
  assign(a,ruta);
  {$I-}
  Reset(a);
  {$I+}
  if IOResult <> 0 then
    ReWrite(a);
end;
procedure leer_dato (var a:t_archivo_polizas ; pos:cardinal ; var dato:t_reg_polizas);
begin
  seek(a,pos);
  read(a,dato);
end;
procedure guardar_registro (var a:t_archivo_polizas ; pos:cardinal ; registro:t_reg_polizas);
begin
  seek(a,pos);
  write(a,registro);
end;
procedure modificar_registro (var registro:t_reg_polizas; campo:string; dato_modificado:string;fecha_modificada:reg_fecha);
begin
  with registro do
    begin
      case campo of
      '1': apellido:=dato_modificado;
      '2': nombres:=dato_modificado;
      '3': direccion:=dato_modificado;                      //stand by
      '4': fecha_nacimiento:=fecha_modificada;
      '5': celular:=dato_modificado;
      '6': email:=dato_modificado;
      end;
    end;
end;
procedure mostrar_registro (r:t_reg_polizas); //llama primero el leer_dato y dsp el mostrar
begin
  with r do
    begin
      gotoxy(40,10);
      writeln('Poliza: ', numero_poliza);
      gotoxy(40,11);
      writeln('DNI: ', dni);
      gotoxy(40,12);
      writeln('Marca: ', marca);
      gotoxy(40,13);
      writeln('Modelo: ', modelo);
      gotoxy(40,14);
      writeln('Ano del vehiculo: ', Ano_Vehiculo);
      gotoxy(40,15);
      writeln('Patente: ', patente);
      gotoxy(40,16);
      writeln('Suma asegurada: ', Suma_asegurada);
      gotoxy(40,17);
      writeln('Cobertura: ', cobertura);
      gotoxy(40,18);
      writeln('Valor de cuota: ', Valor_cuota);
      gotoxy(40,19);
      if estado = true then
        writeln('Estado: ACTIVO')
      else
        writeln('Estado: INACTIVO');
    end;
end;


{Procedure Validar_ano (var dato:cardinal);
begin
  readln(dato);
  if (dato<1950) or (dato>2026) then {Pusimos 2026 porque no sabemos como poner anio actual}
    then
end;}




end.

