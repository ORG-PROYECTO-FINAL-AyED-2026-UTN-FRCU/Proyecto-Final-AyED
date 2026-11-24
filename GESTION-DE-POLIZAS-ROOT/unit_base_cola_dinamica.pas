unit unit_base_cola_dinamica;

interface

uses
  Classes, SysUtils,CRT;
TYPE
  t_dato=word;
  t_punt=^t_nodo;
  t_nodo=record
      info:t_dato;
      sig:t_punt;
  end;
  t_cola=record
      tam:byte;
      fre,fin:t_punt;
      end;

//aca los encabezaDOS DE LOS PROCEDURES
procedure desencolar(var Q:t_cola; var x:t_dato);
procedure crear_cola(var q:t_cola);
function cola_llena(var q:t_cola):boolean;
function cola_vacia(var q:t_cola):boolean;
procedure encolar(var q:t_cola; x:t_dato);
function tamanio(var q:t_cola):byte;

implementation

procedure crear_cola(var q:t_cola);
begin
     q.fre:=nil;
     q.fin:=NIL;
     q.tam:=0;
end;

function cola_llena(var q:t_cola):boolean;
begin
     cola_llena:=getHeapStatus.TotalFree<sizeof(t_nodo);
end;

function cola_vacia(var q:t_cola):boolean;
begin
     cola_vacia:=q.tam=0;
end;

procedure encolar(var q:t_cola; x:t_dato);
var dir:t_punt;
begin
     new(dir);
     dir^.info:=x;
     dir^.sig:=nil;

     if q.fre = nil then
         q.fre:=dir
     else
         q.fin^.sig:=dir;
     q.fin := dir;
     inc(q.tam);
end;

function tamanio(var q:t_cola):byte;
begin
     tamanio:=q.tam;
end;

procedure desencolar(var q:t_cola; var x:t_dato);
var dir:t_punt;
begin
     x:=q.fre^.info;
     dir:=q.fre;
     q.fre:=q.fre^.sig;
     dispose (dir);
     if (q.fre=nil) then
          begin
         q.fre:=nil;
         q.fin := nil;
          end;
     dec(q.tam);
end;

end.


