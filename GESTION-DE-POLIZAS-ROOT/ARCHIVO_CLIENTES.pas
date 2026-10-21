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
    nombre : string[60];
    direccion : string[60];
    fecha_nacimiento : reg_fecha;
    celular : string[15];
    email : string[30];
    estado : boolean;
  end;
<<<<<<< HEAD
<<<<<<< HEAD
  t_archivo_polizas = file of t_reg_polizas;

IMPLEMENTATION
end.
=======
=======
>>>>>>> f693a676dfa4bce5d095b564e4523f0d438eef7c
  t_archivo_cliente = file of t_reg_clientes;
  IMPLEMENTATION

  END.
<<<<<<< HEAD
>>>>>>> f693a676dfa4bce5d095b564e4523f0d438eef7c
=======
>>>>>>> f693a676dfa4bce5d095b564e4523f0d438eef7c

