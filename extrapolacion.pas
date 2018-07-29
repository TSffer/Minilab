unit extrapolacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, operadores, math, ParseMath, Dialogs;

type

  TExtrapolacion = class
    public
      Character:TvectorString;
      rows: Integer;
      MatXn:matriz;
      check:Integer;
      function MExtrapolacionLineal(var n:Integer;var f :string;var RR:real) : matriz;
      function MExtrapolacionExponencial(var n:Integer;var f :string;var RR:real) : matriz;
      function MLogaritmico(var n:Integer;var f:string;var RR:real) : matriz;
      function MSenoidal(var n:Integer;var f:string;var RR:real;periodo:real) : matriz;
      function Execute(opcion:string;var f:string;var R:real;var n:Integer):matriz;
      function Evaluar(a:real;var min:real;var max:real;Fpolinomio:string):real;
      procedure MM(datos:matriz;n:Integer;var Min:real;var Max : real);
      function BestFit(var f:string;var R:real;var n:Integer):matriz;
      procedure ObtenerValores(var datos: matriz;var n:Integer);
      procedure ObtenerValoresL(var datos: matriz;var n:Integer);
      procedure range(var min:real;var max:real;n:Integer;puntos:matriz);
  end;

implementation

function TExtrapolacion.Execute(opcion:string;var f:string;var R:real;var n:Integer):matriz;
begin
   opcion:=LowerCase(opcion);
   Character[0]:='x';Character[1]:='f(x)';
   case opcion of
        'lineal': begin Execute:=MExtrapolacionLineal(n,f,R) ;end;
        'exp': begin Execute:=MExtrapolacionExponencial(n,f,R);end;
        'ln': begin Execute:=MLogaritmico(n,f,R);end;
        'best': begin Execute:=BestFit(f,R,n); end;
        else begin MatXn[0,0]:=(-1);Execute:=MatXn;end;
   end;
end;

function TExtrapolacion.BestFit(var f:string;var R:real;var n:Integer):matriz;
var
  f1,f2,f3:string;
  R1,R2,R3:real;
  m1,m2,m3:matriz;
  tn:Integer;
begin
   tn:=n;
   m1:=MExtrapolacionLineal(n,f1,R1);
   m2:=MExtrapolacionExponencial(n,f2,R2);
   m3:=MLogaritmico(tn,f3,R3);
   if( (R1>R2) and (R1>R3) ) then
   begin
       f:=f1;
       R:=R1;
       Result:=m1;
   end
   else if((R2>R1) and (R2>R3)) then
   begin
        f:=f2;
        R:=R2;
        Result:=m2;
   end
   else
   begin
        f:=f3;
        R:=R3;
        n:=tn;
        Result:=m3;
   end;

end;

function TExtrapolacion.MExtrapolacionLineal(var n:Integer;var f :string;var RR:real) : matriz;
var
  xmedia,ymedia,pendiente,bias,R2,R,SSxy,SSxx,a,b: real;
  datos : matriz;
  i : Integer;
begin
  ObtenerValores(datos,n);
  a:=0; b:=0; SSxy:=0; SSxx:=0; xmedia:=0; ymedia:=0;

  for i:=0 to n-1 do
  begin
       xmedia := xmedia+datos[i,0];
       ymedia := ymedia+datos[i,1];
  end;
  xmedia := xmedia/n;
  ymedia := ymedia/n;

  for i:=0 to n-1 do
  begin
       datos[i,2] := datos[i,0]-xmedia;
       datos[i,3] := datos[i,1]-ymedia;
       datos[i,4] := datos[i,2]*datos[i,2];
       SSxx:=SSxx+datos[i,4];
       datos[i,5] := datos[i,2]*datos[i,3];
       SSxy:=SSxy+datos[i,5];
  end;

  pendiente := SSxy/SSxx;
  bias := ymedia-xmedia*pendiente;

  for i:=0 to n-1 do
  begin
       datos[i,6] := datos[i,0]*pendiente+bias;
       datos[i,7]:= datos[i,6]-ymedia;
       datos[i,8]:= datos[i,7]*datos[i,7];
       a:=a+datos[i,8];
       datos[i,9]:=datos[i,3]*datos[i,3];
       b:=b+datos[i,9];
  end;

  R2 := a/b;
  R := sqrt(R2);
  RR := R;
  f := FloatToStr(pendiente)+'*x+'+FloatToStr(bias);
  Result := datos;
end;

function TExtrapolacion.MExtrapolacionExponencial(var n:Integer;var f :string;var RR:real) : matriz;
var
  Xmedia,Ymedia,pendiente,bias,R,R2,lny,SSxy,SSxx,a,b,AA: real;
  datos : matriz;
  i: Integer;
begin
  ObtenerValores(datos,n);
  SSxy := 0;
  SSxx := 0;
  Xmedia := 0;
  Ymedia := 0;
  a := 0;
  b := 0;
  for i:=0 to n-1 do
  begin
       Xmedia := Xmedia + datos[i,0];
       if(datos[i,1]>0) then
       begin
         datos[i,2] := ln(datos[i,1]);
         Ymedia := Ymedia + datos[i,2];
       end
       else
       begin
            Result := datos;
            exit();
       end;
  end;

  Xmedia := Xmedia/n;
  Ymedia := Ymedia/n;

  for i:=0 to n-1 do
  begin
       datos[i,3] := datos[i,0]-Xmedia;
       datos[i,4] := datos[i,2]-Ymedia;
       datos[i,5] := datos[i,3]*datos[i,3];
       SSxx:=SSxx+datos[i,5];
       datos[i,6] := datos[i,3]*datos[i,4];
       SSxy:=SSxy+datos[i,6];
  end;

  pendiente :=SSxy/SSxx;
  bias := Ymedia-Xmedia*pendiente;

  for i:=0 to n-1 do
  begin
       datos[i,7] := pendiente*datos[i,0]+bias;
       datos[i,8] := datos[i,7]-Ymedia;
       datos[i,9] := datos[i,8]*datos[i,8];
       a:=a+datos[i,9];
       datos[i,10]:= datos[i,4]*datos[i,4];
       b:=b+datos[i,10];
  end;
  AA:=exp(bias);
  R2 := a/b;
  R :=  sqrt(R2);
  RR := R;
  f := FloatToStr(AA)+'*exp('+FloatToStr(pendiente)+'*x)';
  Result := datos;
end;

function TExtrapolacion.MLogaritmico(var n:Integer;var f:string;var RR:real) : matriz;
var
  Xmedia,Ymedia,pendiente,bias,R,R2,lny,SSxy,SSxx: real;
  sumX,sumY,sumXY,sumXX,BB,A : real;
  datos : matriz;
  i,newN: Integer;
  m,b:real;
  parse:TParseMath;
  fs,ss,Ymt:real;
begin

  ObtenerValoresL(datos,n);
  m:=0;b:=0;
  sumX := 0;
  sumY := 0;
  sumXY := 0;
  sumXX := 0;
  newN:=0;
  for i:=0 to n-1 do
  begin
     datos[i,2] := ln(datos[i,0]);
     sumX := sumX + datos[i,2];
     sumY := sumY + datos[i,1];
     datos[i,3] := datos[i,2]*datos[i,1];
     sumXY := sumXY + datos[i,3];
     datos[i,4] := datos[i,2]*datos[i,2];
     sumXX := sumXX + datos[i,4];
  end;
  Xmedia := sumX/n;
  Ymedia := sumY/n;

  B := ((n*sumXY)-(sumX*sumY))/(n*sumXX-power(sumX,2));
  A := Ymedia-B*Xmedia;
  {m:=(sumXY-(Ymedia*sumX))/(sumXX-((SumX/n)*SumX));
  b:=Ymedia-(m*(SumX/n));

  f:=FloatToStr(m)+'*ln(x)+'+ FloatToStr(b);     }
  f := FloatToStr(A)+'+'+FloatToStr(B)+'*ln(x)';

  parse:=TParseMath.create();
  parse.AddVariable('x',0);
  Parse.Expression:=f;
  {fs:=0;ss:=0;Ymt:=0;
  for i:=0 to n-1 do
  begin
    // if((datos[i,0]>0) and (datos[i,0]<>0.000001)) then
      // begin
          datos[i,5]:=B*ln(datos[i,0])+A;
          datos[i,6]:=datos[i,5]-Ymedia;
          fs:=fs+datos[i,6]*datos[i,6];
          datos[i,7]:=datos[0,1]-Ymedia;
          ss:=ss+datos[i,7]*datos[i,7];
       //end;

  end; }

  fs:=0;ss:=0;Ymt:=0;
  for i:=0 to n-1 do
      Ymt:=Ymt+datos[i,1];

  Ymt:=Ymt/n;
  for i:=0 to n-1 do
  begin
    Parse.NewValue('x',datos[i,0]);
    fs:=fs+power(Parse.Evaluate()-Ymt,2);
    ss:=ss+power(datos[i,1]-Ymt,2);
  end;
  R2 := fs/ss;
  R := sqrt(R2);
  RR:= R;
  Result := datos;
end;

function TExtrapolacion.MSenoidal(var n:Integer;var f:string;var RR:real;periodo:real) : matriz;
var
   datos : matriz;
   Max,Min,a,c,k,d,b : real;
   Xmedia,Ymedia,YP,Y: real;
begin
  ObtenerValores(datos,n);
  MM(datos,n,Min,Max);
  d := (Max+Min)/2;
  a := (Max-Min)/2;
  b := (2*pi)/periodo;
  c := -d*b;
  Xmedia := 0;
  YMedia := 0;
  f := FloatToStr(a)+'*'+'sen('+FloatToStr(b)+'*x+'+FloatToStr(c)+')+'+FloatToStr(d);
  Xmedia := Xmedia/n;
  Ymedia := YMedia/n;

  RR :=sqrt(d/a);
  Result := datos;

end;

procedure TExtrapolacion.ObtenerValores(var datos: matriz;var n:Integer);
var
  F : TextFile;
  s , x , y : string;
  ts : TStrings;
  i, elementos : Integer;
begin
  AssignFile(F,'datos.txt');
  Reset(F);
  i := 0;
  elementos := 0;
  while not Eof(F) do
  begin
       ReadLn(F,s);
       x := Trim(Copy(s,0,Pos(',',s)-1));
       y := Trim(Copy(s,Pos(',',s)+1,Length(s)));
       if (x<>'') and (y<>'') then
       begin
            if(StrToFloat(x)=0) then
            begin
                 x := FloatToStr(0.000001);
            end;
           datos[i,0] := StrToFloat(x);
           datos[i,1] := StrToFloat(y);
           i := i+1;
           elementos := elementos + 1;
       end;
       {ShowMessage('Datos : ' + x);}

  end;
  n := elementos;
  close(F);
end;

procedure TExtrapolacion.ObtenerValoresL(var datos: matriz;var n:Integer);
var
  F : TextFile;
  s , x , y : string;
  ts : TStrings;
  i, elementos : Integer;
begin
  AssignFile(F,'datos.txt');
  Reset(F);
  i := 0;
  elementos := 0;
  while not Eof(F) do
  begin
       ReadLn(F,s);
       x := Trim(Copy(s,0,Pos(',',s)-1));
       y := Trim(Copy(s,Pos(',',s)+1,Length(s)));
       if (x<>'') and (y<>'') then
       begin
            if(StrToFloat(x)<>0) then
            begin
               datos[i,0] := StrToFloat(x);
               datos[i,1] := StrToFloat(y);
               i := i+1;
               elementos := elementos + 1;
            end;
       end;
       {ShowMessage('Datos : ' + x);}

  end;
  n := elementos;
  close(F);
end;


function TExtrapolacion.Evaluar(a:real;var min:real;var max:real;Fpolinomio:string):real;
var
  funtion : TParseMath;
begin
  check:=0;
     if(a>=max) then
     begin
         max := a;
         check:=1;
     end
     else if(a<=min) then
     begin
         min := a;
         check:=2;
     end;
    funtion := TParseMath.create();
    funtion.Expression := FPolinomio;
    funtion.AddVariable('x',0) ;
    funtion.NewValue('x',a);
    Result := funtion.Evaluate();
end;

procedure TExtrapolacion.range(var min:real;var max:real;n:Integer;puntos:matriz);
var
  i:Integer;
begin
    max := puntos[0,0];
    for i:=0 to n-1 do
    begin
         if (puntos[i,0]>max) then
            max := puntos[i,0];
    end;
    min := puntos[0,0];
    for i:=0 to n-1 do
    begin
         if (puntos[i,0]<min) then
            min := puntos[i,0];
    end;
end;

procedure TExtrapolacion.MM(datos:matriz;n:Integer;var Min:real;var Max : real);
var
  i :Integer;
begin
    Min := datos[0,1];
    Max := datos[0,1];
    for i:=0 to n-1 do
    begin
         if Min>datos[i,1] then
         begin
             Min := datos[i,1];
         end;
         if Max<datos[i,1] then
         begin
             Max := datos[i,1];
         end;
    end;
end;

end.


