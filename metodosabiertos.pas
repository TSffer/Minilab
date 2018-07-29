unit MetodosAbiertos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs,ParseMath;

type
  matrizA = array of array of string;
  TMetodoAbiertos = class
    public
      function Derivar(h,x :real) : real;
      function Fx(x:real) : real;
      function Newton(X0,EX:real;funcion:string) : real;
      function Secante(X0,EX:real;funcion:string) : real;
      function DF(h,x :real) : real;
    private
  end;

implementation

function TMetodoAbiertos.Derivar(h,x:real) : real;
begin
  Result := (Fx(x+h)-Fx(x-h))/(2*h);
end;

function TMetodoAbiertos.Fx(x:real) : real;
begin
  Result := -2*power(x,6)-1.5*power(x,4)+10*x+2;
end;

function TMetodoAbiertos.DF(h,x:real) : real;
begin
  Result := (Fx(x+h)-Fx(x-h))/(2*h);
end;


function TMetodoAbiertos.Newton(X0,EX:real;funcion:string) : real;
var
  M : matrizA;
  cont,i : Integer;
  x,xn,vdr, e,e1,e2,ant,temp,temp1,temp2: real;
  funtion : TParseMath;
  res : real;
begin
  e:=100;
  ant := X0;
  SetLength(M,100,5);
  funtion := TParseMath.create();
  funtion.Expression := funcion;
  funtion.AddVariable('x',0) ; funtion.Evaluate();

  cont := 1;
  i := 1;
  x := 0;

  M[0,0] := FloatToStr(X0);
  M[0,1] := FloatToStr(ant);
  M[0,2] := '-';
  M[0,3] := '-';
  M[0,4] := '-';

   funtion.NewValue('x',X0); temp := funtion.Evaluate();
   if(temp = 0) then
   begin
        M[i,0] := FloatToStr(X0);
        M[i,1] := FloatToStr(X0);
        result := X0;

        exit();
   end;
  while(EX<=e) do
  begin
    xn := x;

    funtion.NewValue('x',(X0+0.0001)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(X0-0.0001)); temp2 := funtion.Evaluate();
    vdr := ((temp1-temp2)/(2*0.0001));

    if(vdr = 0) then
    begin
         X0 := X0-EX;
         funtion.NewValue('x',(X0+0.0001)); temp1 := funtion.Evaluate();
         funtion.NewValue('x',(X0-0.0001)); temp2 := funtion.Evaluate();
         vdr := ((temp1-temp2)/(2*0.0001))
    end;
    funtion.NewValue('x',X0); temp := funtion.Evaluate();
    x := X0-(temp/vdr);

    e := Abs(xn-x);
    e1 := Abs((xn-x)/x);
    e2 := Abs((xn-x)/x*100);

    M[i,0] := FloatToStr(xn);
    M[i,1] := FloatToStr(x);
    M[i,2] := FloatToStr(e);
    M[i,3] := FloatToStr(e1);
    M[i,4] := FloatToStr(e2);
    i := i + 1;
    X0 := x;
    cont := cont+1;
  end;
  Result := x;
end;

function TMetodoAbiertos.Secante(X0,EX:real;funcion :string) : real;
var
  CantDecimals:Integer;
  x,xn,h,di, e,e1,e2,ant,temp,temp1,temp2: real;
  funtion : TParseMath;
begin
  CantDecimals:=trunc(1/EX);
  e:=100;
  funtion := TParseMath.create();
  funtion.Expression := funcion;
  funtion.AddVariable('x',0); funtion.Evaluate();
  ant := X0;
  h := EX/10;
  x := 0;
  funtion.NewValue('x',X0); temp:= funtion.Evaluate();
  if(temp = 0) then
  begin
       Result := X0;
       exit();
  end;

  while(EX<=e) do
  begin
    xn := x;
    funtion.NewValue('x',(X0+h)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(X0-h)); temp2 := funtion.Evaluate();
    di := (temp1-temp2);
    if(di = 0) then
    begin
         di := di + 0.00001;
    end;
    funtion.NewValue('x',X0); temp := funtion.Evaluate();
    x := X0-((2*h*temp)/di);
    e := Abs(xn-x);
    e1 := Abs((xn-x)/x);
    e2 := Abs((xn-x)/x*100);
    X0 := x;
  end;
  Result := trunc(round(x*CantDecimals))/CantDecimals;
end;
end.

