unit MetodosSisEcuNoLineales;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, operadores,math,ParseMath,Dialogs;

type
  TMetodosENL=class
    public
      funtion:TParseMath;
      Character:TvectorString;
      M:cadena;
      i,OPType,j:Integer;
      operador:Toperacion;
      function MBiseccion(a,b,EX:real):real;
      function MFalsaPosicion(a,b,EX:real):real;
      function Newton(x,EX:real) : real;
      function Secante(x,EX:real) : real;

      function Execute(opcion:string;funcion:string;a,b:real;x:real):real;
      constructor create(f:string);
      destructor Destroy();override;
    private
  end;

implementation

constructor TMetodosENL.create(f:string);
begin
  funtion:=TParseMath.create();
  funtion.Expression:=f;
  funtion.AddVariable('x',0);
  operador:=Toperacion.Create;
end;

destructor TMetodosENL.Destroy();
begin
  funtion.destroy;
end;


function TMetodosENL.Execute(opcion:string;funcion:string;a,b:real;x:real): real;
begin
   opcion:=LowerCase(opcion);
   case opcion of
        'biseccion': begin Character[0]:='a'; Character[1]:='  b'; Character[2]:='  xn'; Character[3]:='  Error';
                     Execute:=MBiseccion(a,b,x);end;
        'falsaposicion': begin Character[0]:='a'; Character[1]:='  b'; Character[2]:='  xn'; Character[3]:='  Error';
                         Execute:=MFalsaPosicion(a,b,x);end;
        'newton': begin Character[0]:='Xn'; Character[1]:='Error';
                        Execute:=Newton(a,x);end;
        'secante':begin Character[0]:='Xn'; Character[1]:='Error';
                        Execute:=Secante(a,x);end;
        else Execute:=0;
   end;
end;

function TMetodosENL.MBiseccion(a,b,EX:real):real;
var
  xn,cn,fxn,e:real;
  fa,fb:real;
begin

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
    Result:=a;
    exit();
  end;
  if(fb=0) then
  begin
    M[0,1]:=FloatToStr(b);
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
      Result:=xn;
      exit();
    end;
    if(fa*fxn<0) then
    begin
      //M[i,3]:='     -';
      b:=xn;
    end
    else
    begin
     // M[i,3]:='     +';
      a:=xn;
    end;
    e:=Abs(xn-cn);
    M[i,3]:=FloatToStr(e);
    i:=i+1;
  end;
  j:=4;
  Result:=xn;
end;

function TMetodosENL.MFalsaPosicion(a,b,EX:real):real;
var
  xn,cn,fxn,e,denominador:real;
  fa,fb:real;
begin
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
    M[0,0]:=FloatToStr(operador.NumeroDecimales(a,EX));
    Result:=a;
    exit();
  end;
  if(fb=0) then
  begin
    M[0,1]:=FloatToStr(operador.NumeroDecimales(b,EX));
    Result:=b;
    exit();
  end;
  xn:=0;
  i:=0;
  e:=100;
  while((e>=EX))do
  begin
    cn:=xn;
    M[i,0]:=FloatToStr(operador.NumeroDecimales(a,EX));
    M[i,1]:=FloatToStr(operador.NumeroDecimales(b,EX));

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
      Result:=xn;
      exit();
    end;
    if(fa*fxn<0) then
    begin
      b:=xn;
    end
    else
    begin
      a:=xn;
    end;
    e:=Abs(xn-cn);
    M[i,3]:=FloatToStr(operador.NumeroDecimales(e,EX));
    i:=i+1;
  end;
  j:=4;
  Result:=xn;
end;

function TMetodosENL.Newton(x,EX:real) : real;
var
  xn,vdr,e,temp,temp1,temp2: real;
begin
  e:=1000;
  i := 1;

  M[0,0] := FloatToStr(x);
  M[0,1] := '100';

  funtion.NewValue('x',x); temp := funtion.Evaluate();
  if(temp = 0) then
  begin
       M[i,0] := FloatToStr(x);
       M[i,1] := '100';
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
  j:=2;
  Result := x;
end;

function TMetodosENL.Secante(x,EX:real) : real;
var
  cont : Integer;
  xn,h,di, e,ant,temp,temp1,temp2: real;
begin
  ant := x;
  h := 0.00000001;
  cont := 1;
  i := 1;
  e:=1000;
  M[0,0] := FloatToStr(x);
  M[0,1] := '100';

  funtion.NewValue('x',x); temp:= funtion.Evaluate();
  if(temp = 0) then
  begin
        M[i,0] := FloatToStr(x);
        M[i,1] := '100';
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
  j:=2;
  Result := x;
end;


end.













