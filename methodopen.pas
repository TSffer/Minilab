unit methodOpen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs,parsemath;

type
  matriz = array of array of string;
  TMetodoAbiertos = class
    public
      funtion:TParseMath;
      M:matriz;
      i:Integer;
      function Newton(x,EX:real) : real;
      function Secante(x,EX:real) : real;
      constructor create(f:string);
      destructor Destroy(); override;
    private
  end;

implementation

constructor TMetodoAbiertos.create(f:string);
begin
  funtion:=TParseMath.create();
  funtion.Expression:=f;
  funtion.AddVariable('x',0);
end;

destructor TMetodoAbiertos.Destroy();
begin
  funtion.destroy;
end;

function TMetodoAbiertos.Newton(x,EX:real) : real;
var
  xn,vdr,e,temp,temp1,temp2: real;
begin
  SetLength(M,100,2);
  e:=1000;
  i := 1;

  M[0,0] := FloatToStr(x);
  M[0,1] := '';

  funtion.NewValue('x',x); temp := funtion.Evaluate();
  if(temp = 0) then
  begin
       M[i,0] := FloatToStr(x);
       M[i,1] := '';
       result := x;
       ShowMessage('RESULTADO: '+FloatToStr(x));
       exit();
   end;

  while(EX<=e) do
  begin
    xn := x;
    funtion.NewValue('x',(x+0.0001)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(x-0.0001)); temp2 := funtion.Evaluate();
    vdr := ((temp1-temp2)/(2*0.0001));

    if(vdr = 0) then
    begin
         x := x-EX;
         funtion.NewValue('x',(x+0.0001)); temp1 := funtion.Evaluate();
         funtion.NewValue('x',(x-0.0001)); temp2 := funtion.Evaluate();
         vdr := ((temp1-temp2)/(2*0.0001))
    end;
    funtion.NewValue('x',x); temp := funtion.Evaluate();
    x := x-(temp/vdr);

    e := Abs(xn-x);

    M[i,0] := FloatToStr(x);
    M[i,1] := FloatToStr(e);
    i := i + 1;
  end;
  Result := x;
end;

function TMetodoAbiertos.Secante(x,EX:real) : real;
var
  cont : Integer;
  xn,h,di, e,e1,e2,ant,temp,temp1,temp2,temp3: real;
begin
  SetLength(M,100,2);
  ant := x;
  h := 0.00000001;
  cont := 1;
  i := 1;
  e:=1000;
  M[0,0] := FloatToStr(x);
  M[0,1] := '';

  funtion.NewValue('x',x); temp:= funtion.Evaluate();
  if(temp = 0) then
  begin
        M[i,0] := FloatToStr(x);
        M[i,1] := '';
        Result := x;
        showMessage('RESULTADO  '+FloatToStr(x));
        exit();
  end;

  while(Ex<=e) do
  begin
    xn := x;

    funtion.NewValue('x',(x+h)); temp1 := funtion.Evaluate();
    funtion.NewValue('x',(x-h)); temp2 := funtion.Evaluate();
    di := (temp1-temp2);
    if(di = 0) then
    begin
         di := di + 0.00001;
    end;
    funtion.NewValue('x',x); temp := funtion.Evaluate();
    x := x-((2*h*temp)/di);

    e := Abs(x-xn);

    M[i,0] := FloatToStr(x);
    M[i,1] := FloatToStr(e);
    i := i + 1;

    cont := cont+1;
  end;
  Result := x;
end;
end.






