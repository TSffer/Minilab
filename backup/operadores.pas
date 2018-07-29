unit operadores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TAGraph, TASeries, TAFuncSeries;
type
  matriz = array[0..500, 0..500] of real;
  Tvector = array[0..500] of Integer;
  TvectorFloat = array[0..500] of real;
  TvectorString = array[0..500] of string;
  TvectorMat = array[0..500] of matriz;
  TvectorFuncion = array[0..20] of string;
  cadena = array[0..500,0..500] of string;
  TvectorLineSeries = array [0..500] of TLineSeries;
  Toperacion = class
    public
      function NumeroDecimales(Numero:real;d:real):real;
  end;

implementation

function Toperacion.NumeroDecimales(Numero:real;d:real):real;
var
   CantDecimals:Integer;
begin
   CantDecimals:=trunc(1/d);
   Result:=(trunc((Numero*CantDecimals))/CantDecimals);
end;
end.

