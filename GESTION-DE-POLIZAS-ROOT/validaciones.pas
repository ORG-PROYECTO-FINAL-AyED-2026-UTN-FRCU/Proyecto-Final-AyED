unit FnVarias;

{$mode ObjFPC}{$H+}

interface
 FUNCTION ValidarDNI(dni:string): BOOLEAN;
 FUNCTION ValidarFecha(fecha:string;anioActual:INTEGER): BOOLEAN;
 FUNCTION InverseString(str:string):string;

implementation


     //validacion DNI
     FUNCTION ValidarDNI(dni:string): BOOLEAN;
    var esValido, esNumero : BOOLEAN;
    i:INTEGER;
    begin
    esValido:=FALSE;
    EsNumero:=TRUE;
        for i:=1 to length(dni) do
        begin
        IF NOT (Dni[i] IN ['0'..'9']) THEN
        esNumero:=FALSE
        end;

       //Validacion final
       if (length(dni) < 7) or (length(dni) > 8) or (esNumero=FALSE) then
       esValido:=FALSE
       Else
       begin
      if (StrToInt(dni) < 1000000) or (StrToInt(dni)>100000000 then
        esValido := FALSE
        else
        esValido := TRUE;
        end;
       validarDNI:=esValido;
    end;


      //validacion de fecha
     FUNCTION ValidarFecha(fecha:string;anioActual:INTEGER): BOOLEAN;
    var cumpleFormato, esNatural, esRealista, laFecha_esValida, esBisiesto: BOOLEAN;
    i, dia, mes, anio, diasEnMes, codError:INTEGER;
    begin
    cumpleFormato:=FALSE;
    esNatural:=TRUE;
    //descartamos el input automaticamente si su longitud es distinta de 10
    if length(fecha) <> 10 then
    begin
    ValidarFecha := FALSE;
    Exit;
    end;
   // Extraer y convertir dia (posiciones 1 y 2)
    Val(Copy(fecha, 1, 2), dia, codError);

    // Extraer y convertir Mes (posiciones 4 y 5)
    Val(Copy(fecha, 4, 2), mes, codError);

    //Extraer y convertir anio (posiciones 7 a 10)
    Val(Copy(fecha, 7, 4), anio, codError);

    //valido anio bisiesto
    esBisiesto := (anio mod 4 = 0) and ((anio mod 100 <> 0) or (anio mod 400 = 0));

    case mes of
    1, 3, 5, 7, 8, 10, 12: diasEnMes := 31;
    4, 6, 9, 11:         diasEnMes := 30;
    2: if esBisiesto then
         diasEnMes := 29
       else
         diasEnMes := 28;
  else
    if (mes<1) or (mes>12) then
    diasEnMes := 0; // Mes inválido
  end;

        for i:=1 to length(fecha) do
        begin
            IF (i <> 3) AND (i <> 6) THEN
            BEGIN
                IF NOT (fecha[i] IN ['0'..'9']) THEN
                esNatural:=FALSE
            END;
        end;

        IF (esNatural=TRUE) and (fecha[3]='/') and (fecha[6]='/') THEN
        cumpleFormato:=TRUE;

        IF (anio<=anioActual) and (dia >= 1) and (dia <= diasEnMes) then
        esRealista:=TRUE
        else
        esRealista:=FALSE;

       //Validacion final
       if (length(fecha) <>10 )or (cumpleFormato=FALSE) or (esRealista=FALSE) then
       laFecha_esValida:=FALSE
       Else
       laFecha_esValida:=TRUE;

       validarFecha:=laFecha_esValida;
    end;


     // cadena inversa
    FUNCTION InverseString(str:string):string;
    var inv:string;
    i: integer;
    begin
    for i:=length(str) to 1 do
    str:=str+str[i];

    InverseString:=inv;
    end;

end.

