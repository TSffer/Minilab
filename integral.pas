unit Integral;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath1,Dialogs,math;

type
  TPonderacion = array of array of real;
  vector = array of real;
  TIntegral = class
    public
      Ponderacion1 : TPonderacion;
      Ponderacion2 : TPonderacion;
      Ponderacion3 : TPonderacion;
      Ponderacion4 : TPonderacion;
      Ponderacion5 : TPonderacion;
      function Trapesio2(funcion:string;a,b:real;n:Double):real;
      function Trapesio(funcion:string;a,b:real;n:Integer):real;
      function TrapesioArea(funcion:string;a,b:real;n:Integer):real;
      function Simpson13(funcion:string;a,b:real;n:Integer):real;
      function Simpson13Area(funcion:string;a,b:real;n:Integer):real;
      function Simpson38(funcion:string;a,b:real;n:Integer):real;
      function Simpson38Area(funcion:string;a,b:real;n:Integer):real;
      function CuadraturaGauss(funcion:string;a,b:real;n:Integer):real;
      function CuadraturaGaussArea(funcion:string;a,b:real;n:Integer):real;
      function Romberg(funcion:string;a,b:real;n:Integer):real;
      function RombergArea(funcion:string;a,b:real;n:Integer):real;
      function Execute(opcion:string;funcion:string;a,b:real;n:Integer):real;
      function ExecuteA(opcion:string;funcion:string;a,b:real;n:Integer):real;
      procedure EvaluarValores(funcion:string;valor:real);
      constructor create();
      destructor destroy(); override;
  end;

implementation

constructor TIntegral.create();
begin
   SetLength(Ponderacion1,2,2);
   SetLength(Ponderacion2,3,3);
   SetLength(Ponderacion3,4,2);
   SetLength(Ponderacion4,5,2);
   SetLength(Ponderacion5,6,2);

   Ponderacion1[0,0] := 1.0000000;
   Ponderacion1[1,0] := 1.0000000;
   Ponderacion1[0,1] := -0.577350269;
   Ponderacion1[1,1] := 0.577350269;
           {wi}
   Ponderacion2[0,0] := 0.5555556;
   Ponderacion2[1,0] := 0.8888889;
   Ponderacion2[2,0] := 0.5555556;
           {zi}
   Ponderacion2[0,1] := -0.774596669;
   Ponderacion2[1,1] := 0.0000000001;
   Ponderacion2[2,1] := 0.774596669;

   Ponderacion3[0,0] := 0.3478548;
   Ponderacion3[1,0] := 0.6521452;
   Ponderacion3[2,0] := 0.6521452;
   Ponderacion3[3,0] := 0.3478548;
   Ponderacion3[0,1] := -0.861136312;
   Ponderacion3[1,1] := -0.339981044;
   Ponderacion3[2,1] := 0.339981044;
   Ponderacion3[3,1] := 0.861136312;

   Ponderacion4[0,0] := 0.2369269;
   Ponderacion4[1,0] := 0.4786287;
   Ponderacion4[2,0] := 0.5688889;
   Ponderacion4[3,0] := 0.4786287;
   Ponderacion4[4,0] := 0.2369269;
   Ponderacion4[0,1] := -0.906179846;
   Ponderacion4[1,1] := -0.538469310;
   Ponderacion4[2,1] := 0.0;
   Ponderacion4[3,1] := 0.538469310;
   Ponderacion4[4,1] := 0.906179846;

   Ponderacion5[0,0] := 0.1713245;
   Ponderacion5[1,0] := 0.3607616;
   Ponderacion5[2,0] := 0.4679139;
   Ponderacion5[3,0] := 0.4679139;
   Ponderacion5[4,0] := 0.3607616;
   Ponderacion5[5,0] := 0.1713245;
   Ponderacion5[0,1] := -0.932469514;
   Ponderacion5[1,1] := -0.661209386;
   Ponderacion5[2,1] := -0.238619186;
   Ponderacion5[3,1] := 0.238619186;
   Ponderacion5[4,1] := 0.661209386;
   Ponderacion5[5,1] := 0.932469514;
end;

destructor TIntegral.destroy();
begin
end;

function TIntegral.Execute(opcion:string;funcion:string;a,b:real;n:Integer): real;
begin
   try
      opcion:=LowerCase(opcion);
      case opcion of
        'trapecio': begin Execute:=Trapesio(funcion,a,b,n);end;
        'simpson13': begin Execute:=Simpson13(funcion,a,b,n);end;
        'simpson38': begin Execute:=Simpson38(funcion,a,b,n);end;
       else Execute:=10101000000000;
   end;
   except
     Execute:=10101000000000;
   end;

end;

function TIntegral.ExecuteA(opcion:string;funcion:string;a,b:real;n:Integer): real;
begin
   try
      opcion:=LowerCase(opcion);
      case opcion of
        'trapecio':begin ExecuteA:=TrapesioArea(funcion,a,b,n);end;
        'simpson13':begin ExecuteA:=Simpson13Area(funcion,a,b,n);end;
        'simpson38':begin ExecuteA:=Simpson38Area(funcion,a,b,n);end;
       else ExecuteA:=10101000000000;
   end;
   except
     ExecuteA:=10101000000000;
   end;

end;


procedure TIntegral.EvaluarValores(funcion:string;valor:real);
var
   m_function:TParseMath;
   fx:real;
begin
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;

  m_function.NewValue('x',valor);
  fx:= m_function.Evaluate();
  ShowMessage(FloatToStr(fx));

  ShowMessage('trapesio: '+ 'h/2*(f(x0)+2*sumatoria(f(xi)) +f(xn))'+ #10+#13 +'simsop1/3:  h/3*[f(x0)+4sumatoriaimpares f(xi)+ 2*sumatoriapares f(xi) + f(xn)]'+#10+#13 +'Simsop3/8: 3*h/8[f(x0)+3*sumatoria i=1 f(xi) + 3*sumatoria i=2(xi) + 2*sumatoria i=3 f(xi) + f(xn)]' +#10+#13  + 'cuadratura : (b-a)/2*[sumatoria i=1 wi * f((b-a)/2*zi+(a+b)/2)]'+#10+#13 +'Roberg : 4/3*I(h2)-1/3*I(h1)' + #10+#13 +'opR : (power(4,k-1)*I_j+1,k-1 - I_j,k-1)/power(4,k-1)-1');

end;

function TIntegral.Trapesio2(funcion:string;a,b:real;n:Double):real;
var
fa,fb,h,sum,i:Real;
m_function:TParseMath;
begin
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;
  m_function.NewValue('x',a);
  fa:=m_function.Evaluate();
  m_function.NewValue('x',b);
  fb:=m_function.Evaluate();

  h:=(b-a)/(n);
  //ShowMessage(FloatToStr(Ib)+' - '+FloatToStr(Ia)+' / '+FloatToStr(Ino)+' = '+FloatToStr(h));
  sum:=0;
  i:=a+h;
  //ShowMessage(FloatToStr(Ia)+' + '+FloatToStr(h)+ '='+ FloatToStr(i));
  repeat
    m_function.NewValue('x',i);
    sum:=sum+m_function.Evaluate();
    i:=i+h;
    //ShowMessage('i= '+FloatToStr(i));
  until i>=b;

  Result:=RoundTo(0.5*h*(fa+fb)+h*sum,-6);
end;


function TIntegral.Trapesio(funcion:string;a,b:real;n:Integer):real;
var
   res,h,sumatoria : real;
   i:Integer;
   fx : TParseMath;
   temp,fa,fb,x : real;
   va : vector;
begin
  SetLength(va,n);
  h := (b-a)/n;
  sumatoria :=0;
  x:=a;
  for i:=0 to n-1 do
  begin
    va[i] := x+h;
    {ShowMessage(FloatToStr(va[i]));}
    x := va[i]
  end;

  fx := TParseMath.create();
  fx.Expression := funcion;
  fx.AddVariable('x',0) ;

  for i:=0 to n-2 do
  begin
    fx.NewValue('x',va[i]); temp := fx.Evaluate();
    {ShowMessage(FloatToStr(temp));}
    sumatoria := sumatoria + temp;
  end;

  fx.NewValue('x',a); fa := fx.Evaluate();
  fx.NewValue('x',b); fb := fx.Evaluate();

  res := RoundTo(h*((fa+fb)/2 + sumatoria),-7);
  {ShowMessage('Resultado : '+FloatToStr(res));}
  result := res;
end;

function TIntegral.TrapesioArea(funcion:string;a,b:real;n:Integer):real;
var
   res,h,sumatoria : real;
   i:Integer;
   fx : TParseMath;
   temp,fa,fb,x : real;
   va : vector;
begin
  SetLength(va,n);
  h := (b-a)/n;
  sumatoria :=0;
  x:=a;
  for i:=0 to n-1 do
  begin
    va[i] := x+h;
    x := va[i]
  end;

  fx := TParseMath.create();
  fx.Expression := funcion;
  fx.AddVariable('x',0) ;

  for i:=0 to n-2 do
  begin
    fx.NewValue('x',va[i]); temp := Abs(fx.Evaluate());
    sumatoria := sumatoria + temp;
  end;

  fx.NewValue('x',a); fa := Abs(fx.Evaluate());
  fx.NewValue('x',b); fb := Abs(fx.Evaluate());

  res := h*((fa+fb)/2 + sumatoria);
  result := res;
end;

function TIntegral.Simpson13(funcion:string;a,b:real;n:Integer):real;
var
   fa,fb,h,sum,sum2,i,res,xi,eval:Real;
   m_function:TParseMath;
   va : vector;
   ii,nt:Integer;
   r,s:real;
   xim:vector;
begin
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;
  m_function.NewValue('x',a);
  fa := m_function.Evaluate();
  m_function.NewValue('x',b);
  fb := m_function.Evaluate();
  {n:=n*2;
  h := (b-a)/(n);
  sum := 0;
  sum2 := 0;
  eval := 0;
  i := a+h;
  repeat
    {ShowMessage('este es i '+FloatToStr(i));      }
    m_function.NewValue('x',i);
   { ShowMessage('este es la funcion evaluada en i impares'+FloatToStr(m_function.Evaluate()));}
    sum := sum+m_function.Evaluate();
    i :=i+2*h;
  until i>=b;

  i:=a+2*h;
  repeat
    {ShowMessage('este es i '+FloatToStr(i)); }
    m_function.NewValue('x',i);
    {ShowMessage('este es la funcion evaluada en i pares'+FloatToStr(m_function.Evaluate()));}
    sum2 := sum2+m_function.Evaluate();
    i:=i+2*h;
  until i>=b-h;

  res := (h/3)*((fa+fb)+2*sum2+4*sum);
  Result := res;

  ShowMessage(FloatToStr(res)); }


  h:=(b-a)/(2*n);
  r:= fa+fb;
  nt:=(2*n)+1;s:=0;
  SetLength(Xim,nt);
  for ii:=0 to nt-1 do
  begin
       m_function.NewValue('x',a);
       Xim[ii]:= m_function.Evaluate();
       a:=a+h;
  end;

  for ii:=1 to n-1 do
      s:=s+Xim[2*ii];
  r:=r+(2*s);s:=0;
  for ii:=0 to n-1 do
      s:=s+Xim[(2*ii)+1];
  r:=r+(4*s);
  Result:=(r*h)/3;
end;


function TIntegral.Simpson13Area(funcion:string;a,b:real;n:Integer):real;
var
   fa,fb,h,sum,sum2,i,res,xi,eval:Real;
   m_function:TParseMath;
   va : vector;
begin
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;
  m_function.NewValue('x',a);
  fa := Abs(m_function.Evaluate());
  m_function.NewValue('x',b);
  fb := Abs(m_function.Evaluate());
  n:=n*2;
  h := (b-a)/(n);
  sum := 0;
  sum2 := 0;
  eval := 0;
  i := a+h;
  repeat
    m_function.NewValue('x',i);
    sum := sum+Abs(m_function.Evaluate());
    i :=i+2*h;
  until i>=b;

  i:=a+2*h;
  repeat
    m_function.NewValue('x',i);
    sum2 := sum2+Abs(m_function.Evaluate());
    i:=i+2*h;
  until i>=b-h;

  res := (h/3)*((fa+fb)+2*sum2+4*sum);



  {ShowMessage('Este es el resultado: '+FloatToStr(res));}
  Result := res;
end;

function TIntegral.Simpson38(funcion:string;a,b:real;n:Integer):real;
var
   fa,fb,h,sum,sum2,sum3:Real;
   m_function:TParseMath;
   nt,i:Integer;
   r,s:real;
   xim:vector;
begin

  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;
  m_function.NewValue('x',a);
  fa:=m_function.Evaluate();
  m_function.NewValue('x',b);
  fb:=m_function.Evaluate();


  h:=(b-a)/(3*n);
  r:=0;
  s:=0;
  nt:=(3*n)+1;
  setLength(xim,nt);
  for i:=0 to nt-1 do
  begin
    m_function.NewValue('x',a);
    Xim[i]:=m_function.Evaluate();
    a:=a+h;
  end;
  for i:=1 to n do
      r:=r+Xim[3*(i-1)]+Xim[3*i];
  for i:=1 to n do
      s:=s+Xim[(3*i)-2]+Xim[(3*i)-1];
  r:=r+(3*s);

  Result:=(3*h*r)/8;
end;

function TIntegral.Simpson38Area(funcion:string;a,b:real;n:Integer):real;
var
  fa,fb,h,sum,sum2,sum3:Real;
  i,nt:Integer;
  r,s:real;
  m_function:TParseMath;
  xim:vector;
begin

  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;
  m_function.NewValue('x',a);
  fa:=m_function.Evaluate();
  m_function.NewValue('x',b);
  fb:=m_function.Evaluate();


  h:=(b-a)/(3*n);
  r:=0;
  s:=0;
  nt:=(3*n)+1;
  setLength(xim,nt);
  for i:=0 to nt-1 do
  begin
    m_function.NewValue('x',a);
    Xim[i]:=Abs(m_function.Evaluate());
    a:=a+h;
  end;
  for i:=1 to n do
      r:=r+Xim[3*(i-1)]+Xim[3*i];
  for i:=1 to n do
      s:=s+Xim[(3*i)-2]+Xim[(3*i)-1];
  r:=r+(3*s);

  Result:=(3*h*r)/8;
end;

function TIntegral.CuadraturaGauss(funcion:string;a,b:real;n:Integer):real;
var
  m_function : TParseMath;
  x1,res : real;
  II: real;
  i :Integer;
begin
  m_function := TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression := funcion;
  {0.2+25*x-200*power(x,2)+675*power(x,3)-900*power(x,4)+400*power(x,5)}
  if(n>6) then
  begin
      ShowMessage('Datos no tabulados para '+FloatToStr(n));
      Result := 0;
      exit();
  end;

    II := 0;
  if(n=2) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion1[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion1[i,0]*m_function.Evaluate();
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=3) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion2[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion2[i,0]*m_function.Evaluate();
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=4) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion3[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion3[i,0]*m_function.Evaluate();
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=5) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion4[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion4[i,0]*m_function.Evaluate();
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;

  if(n=6) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion5[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion5[i,0]*m_function.Evaluate();
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  {intregral  de a hasta b = (b-a)/2*sumatoria wi*f(  (b-a)/2*zi+(a+b)/2) )}
end;

function TIntegral.CuadraturaGaussArea(funcion:string;a,b:real;n:Integer):real;
var
  m_function : TParseMath;
  x1,res : real;
  II: real;
  i :Integer;
begin
  m_function := TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression := funcion;
  {0.2+25*x-200*power(x,2)+675*power(x,3)-900*power(x,4)+400*power(x,5)}
  if(n>6) then
  begin
      ShowMessage('Datos no tabulados para '+FloatToStr(n));
      Result := 0;
      exit();
  end;

    II := 0;
  if(n=2) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion1[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion1[i,0]*Abs(m_function.Evaluate());
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=3) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion2[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion2[i,0]*Abs(m_function.Evaluate());
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=4) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion3[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion3[i,0]*Abs(m_function.Evaluate());
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
  if(n=5) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion4[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion4[i,0]*Abs(m_function.Evaluate());
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;

  if(n=6) then
  begin
    for i:=0 to n-1 do
    begin
       x1 := ((b+a)+((b-a)*(Ponderacion5[i,1])))/2;
       m_function.NewValue('x',x1);
       II := II + Ponderacion5[i,0]*Abs(m_function.Evaluate());
    end;
    res := II*((b-a)/2);
    Result := res;
    exit();
  end;
end;

function TIntegral.Romberg(funcion:string;a,b:real;n:Integer):real;
var
   xi,xf,h,w,i : real;
   T : vector;
   aa,ii: Integer;
   m_function:TParseMath;
begin
  xi := a;
  xf := b;
  h := 1;
  aa:=0;
  SetLength(T,4);
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;


  while(h >= (0.125)) do
  begin
    i := xi;
    while(i<=xf) do
    begin
      if ((i=xi) or (i=xf)) then
      begin
         m_function.NewValue('x',i);
        T[aa] := T[aa]+(m_function.Evaluate())*(h/2);
      end
      else
          begin
            m_function.NewValue('x',i);
             T[aa] := T[aa]+(m_function.Evaluate())*(h);
          end;
      i:= i+h;
    end;
        aa := aa+1;
        h := h/2;
  end;

  for ii:=3 downto 1 do
  begin
    for aa:=0 to ii-1 do
    begin
         T[aa] := ((Power(4,(aa+1))*T[aa+1])-T[aa])/(Power(4,(aa+1))-1);
    end;
  end;
  {ShowMessage('El resultado obtenido es = '  + FloatToStr(T[0])); }
  Result:= T[0];
end;

function TIntegral.RombergArea(funcion:string;a,b:real;n:Integer):real;
var
   xi,xf,h,w,i : real;
   T : vector;
   aa,ii: Integer;
   m_function:TParseMath;
begin
  xi := a;
  xf := b;
  h := 1;
  aa:=0;
  SetLength(T,4);
  m_function:=TParseMath.create();
  m_function.AddVariable('x',0);
  m_function.Expression:=funcion;


  while(h >= (0.125)) do
  begin
    i := xi;
    while(i<=xf) do
    begin
      if ((i=xi) or (i=xf)) then
      begin
         m_function.NewValue('x',i);
        T[aa] := T[aa]+(Abs(m_function.Evaluate()))*(h/2);
      end
      else
          begin
            m_function.NewValue('x',i);
             T[aa] := T[aa]+(Abs(m_function.Evaluate()))*(h);
          end;
      i:= i+h;
    end;
        aa := aa+1;
        h := h/2;
  end;

  for ii:=3 downto 1 do
  begin
    for aa:=0 to ii-1 do
    begin
         T[aa] := ((Power(4,(aa+1))*T[aa+1])-T[aa])/(Power(4,(aa+1))-1);
    end;
  end;
  Result:= T[0];
end;

end.



