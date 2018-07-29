unit EDO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,operadores, ParseMath,Dialogs, math;
type

  TEcuacionesDO = class
    public
      Character:TvectorString;
      rows: Integer;
      MatXn:cadena;
      ArcTxt:TextFile;
      comportamiento:string;
      function MEuler(funcion:string;Ia,Ib,y:real;n:real):cadena;
      function MEulerMejorado(funcion:string;Ia,Ib,y:real;n:real): cadena;
      function MVR(funcion :string;Ia,Ib,y:real;n:Integer):cadena;
      function MRungeKutta(funcion:string;Ia,Ib,y:real;n:real):cadena;
      function DormandPrince(funcion:string;Ia,Ib,y:real;n:real):cadena;
      function Execute(opcion:string;funcion:string;Ia,Ib,y:real;n:real):cadena;
      private

  end;

implementation

function TEcuacionesDO.Execute(opcion:string;funcion:string;Ia,Ib,y:real;n:real):cadena;
begin
   opcion:=LowerCase(opcion);
   Character[0]:='x';Character[1]:='f(x)';
   case opcion of
        'euler': begin Execute:=MEuler(funcion,Ia,Ib,y,n);end;
        'heun': begin Execute:=MEulerMejorado(funcion,Ia,Ib,y,n);end;
        'rk': begin Execute:=MRungeKutta(funcion,Ia,Ib,y,n);end;
        'dp':begin Execute:=DormandPrince(funcion,Ia,Ib,y,n);end;
        else begin MatXn[0,0]:=FloatToStr(-1);Execute:=MatXn;end;
   end;
end;

function TEcuacionesDO.MEuler(funcion :string ; Ia,Ib,y:real;n : real) : cadena;
var
  h , yn , xn,Iy0:real;
  EcuacionDiferencial : TParseMath;
 // i:Integer;
begin
  Comportamiento:='';
  AssignFile(ArcTxt,'C:\Users\Luis Fernando\Desktop\Minilab\datos.csv');
  Rewrite(ArcTxt);
  EcuacionDiferencial := TParseMath.create();
  EcuacionDiferencial.AddVariable('x',0);
  EcuacionDiferencial.AddVariable('y',0);
  EcuacionDiferencial.Expression :=  funcion;
  Iy0 := y;
  yn := Iy0;
  xn := Ia;
  Rows:=1;
  h := n; //(Ib-Ia)/n;

  MatXn[0,0] := FloatToStr(xn);
  MatXn[0,1] := FloatToStr(yn);
  comportamiento:=FloatToStr(xn)+','+FloatToStr(yn);
  WriteLn(ArcTxt,comportamiento);
  //for i:=1 to n do
  while (Ib>xn) do
  begin
    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',yn);

    try
       yn :=yn+h*EcuacionDiferencial.Evaluate();
    except
      ShowMessage('ERROR: Esta dividiendo entre Cero !!!');
      exit();
    end;

    xn := xn+h;
    MatXn[Rows,0] := FloatToStr(xn);
    MatXn[Rows,1] := FloatToStr(yn);
    comportamiento:=FloatToStr(xn)+','+FloatToStr(yn);
    WriteLn(ArcTxt,comportamiento);

    if(((Rows>=3) and (MatXn[Rows,1]=MatXn[Rows-1,1]) and (MatXn[Rows,1]=MatXn[Rows-2,1]) and(MatXn[Rows,1]=MatXn[Rows-3,1])) or (StrToFloat(MatXn[Rows,1])>90000)) then
    begin
         Result:=MatXn;
         exit();
    end;
    rows:=Rows+1;
  end;
  CloseFile(ArcTxt);
  Result:=MatXn;
end;

function TEcuacionesDO.MEulerMejorado(funcion :string ; Ia,Ib,y:real;n : real): cadena;
var
  h , yn , xn,Iy0,yM,yant,xant,valor1,valor2,y0:real;
  EcuacionDiferencial : TParseMath;
  {MatXn:matriz;}
begin
  {SetLength(MatXn,n+10,10);}
  Comportamiento:='';
  AssignFile(ArcTxt,'C:\Users\Luis Fernando\Desktop\Minilab\datos.csv');
  Rewrite(ArcTxt);
  Rows:=1;
  EcuacionDiferencial := TParseMath.create();
  EcuacionDiferencial.AddVariable('x',0);
  EcuacionDiferencial.AddVariable('y',0);
  EcuacionDiferencial.Expression :=  funcion;
  Iy0 := y;
  yn := Iy0;
  xn := Ia;

  h := n; //(Ib-Ia)/n;

  MatXn[0,0] := FloatToStr(xn);
  MatXn[0,1] := FloatToStr(yn);
  comportamiento:=FloatToStr(xn)+','+FloatToStr(yn);
  WriteLn(ArcTxt,comportamiento);

  //for i:=1 to n do
  while (Ib>xn) do
  begin
    yant := yn;
    xant := xn;

    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',yn);

    y0 :=yn+h*EcuacionDiferencial.Evaluate();
    xn := xn+h;

    EcuacionDiferencial.NewValue('x',xant);
    EcuacionDiferencial.NewValue('y',yant);
    valor1 := EcuacionDiferencial.Evaluate();
    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',y0);
    valor2 := EcuacionDiferencial.Evaluate();
    yM := yant+h*(valor1+valor2)/2;
    yn := yM;
    MatXn[Rows,0] := FloatToStr(xn);
    MatXn[Rows,1] := FloatToStr(yM);

    comportamiento:=FloatToStr(xn)+','+FloatToStr(yM);
    WriteLn(ArcTxt,comportamiento);

    if(((Rows>=3) and (MatXn[Rows,1]=MatXn[Rows-1,1]) and (MatXn[Rows,1]=MatXn[Rows-2,1]) and(MatXn[Rows,1]=MatXn[Rows-3,1])) or (StrToFloat(MatXn[Rows,1])>90000)) then
    begin
         Result:=MatXn;
         exit();
    end;
      Rows:=Rows+1;
  end;
  CloseFile(ArcTxt);
  Result:=MatXn;
end;

function TEcuacionesDO.MVR(funcion :string ; Ia,Ib,y:real;n : Integer): cadena;
var
  h , yn , xn,Iy0:real;
  EcuacionDiferencial : TParseMath;
  i:Integer;
begin

  EcuacionDiferencial := TParseMath.create();
  EcuacionDiferencial.AddVariable('x',0);
  EcuacionDiferencial.AddVariable('y',0);
  EcuacionDiferencial.Expression :=  funcion;
  Iy0 := y;
  yn := Iy0;
  xn := Ia;

  h := (Ib-Ia)/n;

  MatXn[0,0] := FloatToStr(xn);
  MatXn[0,3] := FloatToStr(yn);
  xn := xn+h;
  EcuacionDiferencial.NewValue('y',yn);
  yn := EcuacionDiferencial.Evaluate();
  for i:=1 to n do
  begin
    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',yn);
    yn := EcuacionDiferencial.Evaluate();
    MatXn[i,0] := FloatToStr(xn);
    MatXn[i,3] := FloatToStr(yn);
    xn := xn+h;
  end;
  Rows:=Rows+1;
  Result:=MatXn;
end;

function TEcuacionesDO.MRungeKutta(funcion : string ; Ia,Ib,y:real;n:real):cadena;
var
   h,xn,yn,ytemp,Iy0,k1,k2,k3,k4 : real;
   EcuacionDiferencial : TParseMath;
begin
  Comportamiento:='';
  AssignFile(ArcTxt,'C:\Users\Luis Fernando\Desktop\Minilab\datos.csv');
  Rewrite(ArcTxt);
  EcuacionDiferencial := TParseMath.create();
  EcuacionDiferencial.AddVariable('x',0);
  EcuacionDiferencial.AddVariable('y',0);
  EcuacionDiferencial.Expression := funcion;

  Iy0 := y;
  yn := Iy0;
  xn := Ia;
  h := n;//(Ib-Ia)/n;
  Rows:=0;
  //for i:=0 to n do
  while (Ib>=xn) do
  begin
    ytemp := yn;

    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',yn);
    k1 := EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x',(xn+(h/2)));
    EcuacionDiferencial.NewValue('y',(yn+(1/2)*k1*h));
    k2 := EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x',(xn+(h/2)));
    EcuacionDiferencial.NewValue('y',(yn+(1/2)*k2*h));
    k3 := EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x',(xn+h));
    EcuacionDiferencial.NewValue('y',(yn+k3*h));
    k4 := EcuacionDiferencial.Evaluate();

    MatXn[Rows,0] := FloatToStr(xn);
    MatXn[Rows,1] := FloatToStr(ytemp);
    comportamiento:=FloatToStr(xn)+','+FloatToStr(ytemp);
    WriteLn(ArcTxt,comportamiento);
    {MatXn[i,2] := FloatToStr(k1);
    MatXn[i,3] := FloatToStr(k2);
    MatXn[i,4] := FloatToStr(k3);
    MatXn[i,5] := FloatToStr(k4);}


    yn := yn +(h/6)*(k1+2*k2+2*k3+k4);
    xn := xn+h;
    Rows:=Rows+1;
  end;
   CloseFile(ArcTxt);
   Result := MatXn;
end;

function TEcuacionesDO.DormandPrince(funcion : string ; Ia,Ib,y:real;n:real):cadena;
var
   h,xn,yn,ytemp,Iy0,k1,k2,k3,k4,k5,k6,k7,s,zn,t,err,h1 : real;
   EcuacionDiferencial : TParseMath;
begin
  Comportamiento:='';
  AssignFile(ArcTxt,'C:\Users\Luis Fernando\Desktop\Minilab\datos.csv');
  Rewrite(ArcTxt);
  EcuacionDiferencial := TParseMath.create();
  EcuacionDiferencial.AddVariable('x',0);
  EcuacionDiferencial.AddVariable('y',0);
  EcuacionDiferencial.Expression := funcion;

  Iy0 := y;
  yn := Iy0;
  xn := Ia;
  h := n;//(Ib-Ia)/n;
  Rows:=0;
  while(Ib>=xn) do
  begin
    ytemp := yn;

    EcuacionDiferencial.NewValue('x',xn);
    EcuacionDiferencial.NewValue('y',yn);
    k1 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+(1/5)*h) );
    EcuacionDiferencial.NewValue('y', (yn+(1/5)*k1) );
    k2 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+(3/10)*h) );
    EcuacionDiferencial.NewValue('y', (yn+(3/40)*k1+(9/40)*k2 ) );
    k3 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+(4/5)*h) );
    EcuacionDiferencial.NewValue('y', (yn+(44/45)*k1-(56/15)*k2+(32/9)*k3));
    k4 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+(8/9)*h) );
    EcuacionDiferencial.NewValue('y', (yn+(19372/6561)*k1-(25360/2187)*k2+(64448/6561)*k3-(212/729)*k4));
    k5 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+h));
    EcuacionDiferencial.NewValue('y', (yn+(9017/3168)*k1-(355/33)*k2-(46732/5247)*k3+(49/176)*k4-(5103/18656)*k5));
    k6 := h*EcuacionDiferencial.Evaluate();

    EcuacionDiferencial.NewValue('x', (xn+h));
    EcuacionDiferencial.NewValue('y', (yn+(35/384)*k1+(500/1113)*k3+(125/192)*k4-(2187/6784)*k5+(11/84)*k6));
    k7 := h*EcuacionDiferencial.Evaluate();

    MatXn[Rows,0] := FloatToStr(xn);
    {MatXn[i,1] := FloatToStr(ytemp); }
    MatXn[Rows,1] := FloatToStr(ytemp);

    comportamiento:=FloatToStr(xn)+','+FloatToStr(ytemp);
    WriteLn(ArcTxt,comportamiento);
    {MatXn[i,3] := FloatToStr(k2);
    MatXn[i,4] := FloatToStr(k3);
    MatXn[i,5] := FloatToStr(k4);}

    yn := (yn + (35/384)*k1+(500/1113*k3)+(125/192)*k4-(2187/6784)*k5+(11/84)*k6);

    zn := ytemp + (5179/57600)*k1+(7571/16695)*k3+(393/640)*k4-(92097/339200)*k5+(187/2100)*k6+(1/40)*k7;
    {t := Abs((71/57600)*k1-(71/16695)*k3+(71/1920)*k4-(17253/339200)*k5+(22/525)*k6-(1/40)*k7);}

    err := Abs(zn-yn);
    //s := power((0.0001*h)/(2*err),(0.2));
    //h1 := s*h;

    {if(h1<0.001) then h1:=0.001
    else if(h1>0.1) then h1:=0.1;}
    xn := xn+h;
    Rows:=Rows+1;
    {ShowMessage(FloatToStr(yn)); }
  end;
  CloseFile(ArcTxt);
  Result := MatXn;
end;



end.








