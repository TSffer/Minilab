unit MethodClose;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,ParseMath,Dialogs;

type
  matriz=array of array of string;
  TMetodosCerrados=class
    public
      funtion:TParseMath;
      M:matriz;
      i,OPType:Integer;
      Resultado:real;
      function MBiseccion(a,b,EX:real):real;
      function MFalsaPosicion(a,b,EX:real):real;
      function Executar(a,b,EX:real):real;
      constructor create(f:string);
      destructor Destroy();override;
    private
  end;
const
  M_BISECCION=0;
  M_FALSAPOSICION=1;

implementation

constructor TMetodosCerrados.create(f:string);
begin
  funtion:=TParseMath.create();
  funtion.Expression:=f;
  funtion.AddVariable('x',0);
end;

destructor TMetodosCerrados.Destroy();
begin
  funtion.destroy;
end;

function TMetodosCerrados.Executar(a,b,EX:real):real;
begin
  Result:=0;
  case OPType of
      M_BISECCION:Result:=MBiseccion(a,b,EX);
      M_FALSAPOSICION:Result:=MFalsaPosicion(a,b,EX);
  end;
end;

function TMetodosCerrados.MBiseccion(a,b,EX:real):real;
var
  xn,cn,fxn,e:real;
  fa,fb:real;
begin
  SetLength(M,100,5);
  funtion.NewValue('x',a);
  fa:=funtion.Evaluate();
  funtion.NewValue('x',b);
  fb:=funtion.Evaluate();
  if(fa*fb>0) then
  begin
    ShowMessage('En el Intervalo evaluado no se Cumple Bolzano!');
    Result:=-1;
    exit()
  end;
  if(fa=0) then
  begin
    M[0,0]:=FloatToStr(a);
    Resultado:=a;
    Result:=a;
    exit();
  end;
  if(fb=0) then
  begin
    M[0,1]:=FloatToStr(b);
    Resultado:=b;
    Result:=b;
    exit();
  end;
  xn:=0;
  i:=0;
  e:=100;
  while((e>=EX))do
  begin
    cn:=xn;
    M[i,0]:=FloatToStr(a);
    M[i,1]:=FloatToStr(b);
    xn:=(a+b)/2;
    M[i,2]:=FloatToStr(xn);
    funtion.NewValue('x',a);
    fa:=funtion.Evaluate();

    funtion.NewValue('x',xn);
    fxn:=funtion.Evaluate();

    if(fa*fxn=0)then
    begin
      Resultado:=xn;
      Result:=xn;
      exit();
    end;
    if(fa*fxn<0) then
    begin
      M[i,3]:='     -';
      b:=xn;
    end
    else
    begin
      M[i,3]:='     +';
      a:=xn;
    end;
    e:=Abs(xn-cn);
    Resultado:=xn;
    M[i,4]:=FloatToStr(e);
    i:=i+1;
  end;
  Result:=xn;
end;

function TMetodosCerrados.MFalsaPosicion(a,b,EX:real):real;
var
  xn,cn,fxn,e,denominador:real;
  fa,fb:real;
begin
  SetLength(M,100,5);
  funtion.NewValue('x',a);
  fa:=funtion.Evaluate();
  funtion.NewValue('x',b);
  fb:=funtion.Evaluate();
  if(fa*fb>0) then
  begin
    ShowMessage('En el Intervalo evaluado no se Cumple Bolzano!');
    Result:=-1;
    exit()
  end;
  if(fa=0) then
  begin
    M[0,0]:=FloatToStr(a);
    Resultado:=a;
    Result:=a;
    exit();
  end;
  if(fb=0) then
  begin
    M[0,1]:=FloatToStr(b);
    Resultado:=b;
    Result:=b;
    exit();
  end;
  xn:=0;
  i:=0;
  e:=100;
  while((e>=EX))do
  begin
    cn:=xn;
    M[i,0]:=FloatToStr(a);
    M[i,1]:=FloatToStr(b);

    funtion.NewValue('x',a);
    fa:=funtion.Evaluate();
    funtion.NewValue('x',b);
    fb:=funtion.Evaluate();
    denominador:=(fb-fa);
    if(denominador=0)then
    begin
      M[i,2]:=FloatToStr((fb+fa)/2);
      Result:=1;
      exit();
    end;

    xn:=(a - ((fa*(b-a))/denominador));
    M[i,2]:=FloatToStr(xn);

    funtion.NewValue('x',xn);
    fxn:=funtion.Evaluate();

    if(fa*fxn=0)then
    begin
      Resultado:=xn;
      Result:=xn;
      exit();
    end;
    if(fa*fxn<0) then
    begin
      M[i,3]:='     -';
      b:=xn;
    end
    else
    begin
      M[i,3]:='     +';
      a:=xn;
    end;
    e:=Abs(xn-cn);
    Resultado:=xn;
    M[i,4]:=FloatToStr(e);
    i:=i+1;
  end;
  Result:=xn;
end;

end.


