unit matrizJacobiana;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Dialogs, operadores;
type
  TJacobiana = Class

  Private
      Jvariables:cadena;
      Jfunciones:cadena;
      Jvalores:matriz;
      Jelementos:integer;
      function derivadaParcial(fun:TParseMath;x:string;valor:real): real;

  Public
      function Evaluate(): matriz;
      constructor create(A,B:cadena;C:matriz;n:integer);
      destructor destroy;

  end;

implementation
constructor TJacobiana.create(A,B:cadena;C:matriz;n:integer);
begin
   Jvariables:=A;
   Jfunciones:=B;
   Jvalores:=C;
   Jelementos:=n;
end;

destructor TJacobiana.destroy;
begin
end;

function TJacobiana.Evaluate(): matriz;
var
  m_function:TParseMath;
  help:matriz;
  i,j:integer;
begin
  m_function:=TParseMath.create();
  for i:=0 to Jelementos-1  do
      begin
        m_function.AddVariable(Jvariables[i,0],Jvalores[i,0]);
      end;
  for i:=0 to Jelementos-1  do
      begin
        m_function.Expression:=Jfunciones[i,0];
        for j:=0 to Jelementos-1  do
          begin
            help[i,j]:=derivadaParcial(m_function,Jvariables[j,0],Jvalores[j,0]);
          end;
      end;
  Evaluate:=help;
end;
function TJacobiana.derivadaParcial(fun:TParseMath;x:string;valor:real): real;
var
  h,a,b,v:real;
  funaux:TParseMath;
begin
  h:=0.0001;
  v:=valor;
  funaux:=fun;
  funaux.NewValue(x,v);
  b:=funaux.Evaluate();
  funaux.NewValue(x,v+h);
  a:=funaux.Evaluate();
  derivadaParcial:=(a-b)/h;

end;


end.



