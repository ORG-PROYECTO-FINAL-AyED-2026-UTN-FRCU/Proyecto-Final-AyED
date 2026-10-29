unit ARCHIVO_CLIENTES;
interface
type
  reg_direccion = record
    calle:string[20];
    nro:word;
  end;

  reg_fecha = record
    dia: word;
    mes: word;
    ano: word;
  end;
  t_reg_clientes = record
    dni:string[9];
    apellido : string[60];
    nombres : string[60];
    direccion :reg_direccion;
    fecha_nacimiento : reg_fecha;
    celular : string[15];
    email : string[30];
    estado : boolean;
  end;
  t_archivo_clientes = file of t_reg_clientes;
implementation

end.
