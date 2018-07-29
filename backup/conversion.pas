unit Conversion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, operadores;

type
  TAdaptadorMatriz = class
    public
      Tn:Integer;
      Tm:Integer;
      function StringToMat(matriz:String):matriz;
      function StringToMatStr(matriz:String):cadena;
      function MatToString(A:matriz;n,m:Integer):string;
      function MatStrToString(A:cadena;n,m:Integer):string;
      function StrToStr(matriz:String):real;
      function Rows(A:String):Integer;
      function Cols(A:String):Integer;
    private

  end;

implementation

function TAdaptadorMatriz.StringToMat(matriz:String):matriz;
var
  A:matriz;
  poss:Tvector;
  num:Real;
  caracter:string;
  i,n,m,c: integer;
begin
  caracter:='';
  m:=0;
  n:=0;
  c:=0;

  for i:=2 to Length(matriz) do
  begin
   if matriz[i]=' ' then
        begin
             A[m,n]:=StrToFloat(caracter);
             caracter:='';
             n:=n+1;
        end
   else if matriz[i]=';' then
        begin
             n:=0;
             m:=m+1;
        end
   else
       caracter:= caracter+matriz[i];
  end;
  Tn:=n;
  Tm:=m+1;

  StringToMat:=A;
end;


function TAdaptadorMatriz.StringToMatStr(matriz:String):cadena;
var
   A:cadena;
   num:real;
   caracter:string;
   i,n,m:Integer;
begin
  caracter:='';
  m:=0;
  n:=0;

  for i:=2 to Length(matriz) do
  begin
    if matriz[i]=' ' then
    begin
      A[n,m]:=caracter;
      caracter:='';
      n:=n+1;
    end
    else if matriz[i]=';' then
    begin
      n:=0;
      m:=m+1;
    end
    else
        caracter:=caracter+matriz[i];
  end;
  Tn:=n;
  Tm:=m+1;
  Result := A;
end;

function TAdaptadorMatriz.StrToStr(matriz:String):real;
var
   A:matriz;
   num:real;
   caracter,cadena1:string;
   i,n,m:Integer;
begin
  caracter:='';
  cadena1:='';
  m:=0;
  n:=0;

  for i:=2 to Length(matriz) do
  begin
    if matriz[i]=' ' then
    begin
      A[n,m]:=StrToFloat(caracter);
      cadena1:=cadena1+'  '+caracter;
      caracter:='';
      n:=n+1;
    end
    else if matriz[i]=';' then
    begin
      n:=0;
      m:=m+1;
      cadena1:=cadena1+' // ';
    end
    else
    begin
      caracter:=caracter+matriz[i];
    end;

  end;
  Tn:=n;
  Tm:=m+1;
  ShowMessage('filas: '+intToStr(Tm)+' Colunmas: ' +IntToStr(Tn));
  ShowMessage('this: '+cadena1);
  Result:=num;
end;

function TAdaptadorMatriz.MatToString(A:matriz;n,m:Integer):string;
var
   i,j:Integer;
   C:string;
begin
  c:='[';
  for i:=0 to n-1 do
  begin
    for j:=0 to m-1 do
    begin
      C:=C+FloatToStr(A[j,i])+' ';
    end;
    if i<> n-1 then C:=C+';';
  end;
  C:=C+']';
  Result:=C;
end;

function TAdaptadorMatriz.MatStrToString(A:cadena;n,m:Integer):string;
var
   i,j:Integer;
   C:string;
begin
  C:='[';
  for i:=0 to n-1 do
  begin
    for j:=0 to m-1 do
    begin
      C:=C+A[j,i]+' ';
    end;
    if i<>n-1 then C:=C+';';
  end;
  C:=C+']';
  Result:=C;
end;

function TAdaptadorMatriz.Rows(A:String):Integer;
begin
  Result:=Tm;
end;

function TAdaptadorMatriz.Cols(A:String):Integer;
begin
  Result:=Tn;
end;







end.

