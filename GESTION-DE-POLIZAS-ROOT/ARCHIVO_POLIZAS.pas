unit ARCHIVO_POLIZAS;
interface
  type
  reg_fecha1 = record
    dia:1..31;
    mes:1..12;
    ano:2020..2050;
  end;
  t_reg_polizas = record
    numero_poliza : cardinal;
    dni : string[9];
    fecha_carga : reg_fecha1;
    vigencia_desde : reg_fecha1;
    vigencia_hasta : reg_fecha1;
    marca : string[15];
    modelo : string[20];
    ano_vehiculo : cardinal;
    patente : string [7];
    suma_asegurada : real;
    cobertura : string[4];
    valor_cuota : real;
    estado : boolean;
  end;
  t_archivo_polizas = file of t_reg_polizas;
implementation

end.

