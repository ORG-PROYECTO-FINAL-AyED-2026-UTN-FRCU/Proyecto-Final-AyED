unit ARCHIVO_CLIENTES;
interface
type
  reg_fecha = record
    dia: 1..31;
    mes: 1..12;
    ano: 2020..2050;
  end;
  t_reg_clientes = record
    dni:string[9];
    apellido : string[60];
    nombres : string[60];
    direccion : string[60];
    fecha_nacimiento : reg_fecha;
    celular : string[15];
    email : string[30];
    estado : boolean;
  end;
  t_archivo_clientes = file of t_reg_clientes;
implementation

end.
