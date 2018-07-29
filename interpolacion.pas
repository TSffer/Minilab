unit Interpolacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,ParseMath,operadores;

type
  vector = array[0..100] of string;
  Ccadena = array of array of string;
  TLagrange = class
    public
      Larraya : matriz;
      Polinomio : string;
      check:Integer;
      function Langrangeanos(LarrayXY:matriz;Lelementos:Integer; LX:real):cadena;
      function Polinomio_newton(n:Integer;LarrayXY:matriz;xi:real) : cadena;
      function NearPoint(puntos:matriz;X0:real;var n:Integer):matriz;
      procedure range(var min:real;var max:real;n:Integer;puntos:matriz);
      function Evaluar(a,min,max:real;Fpolinomio:string):string;
      constructor create();
      destructor destroy(); override;
end;

implementation
constructor TLagrange.create();
begin
end;

destructor TLagrange.destroy();
begin
end;

function TLagrange.NearPoint(puntos:matriz;X0:real;var n:Integer):matriz;
var
  puntosCercanos,verificar : matriz;
  distancia : matriz;
  i,j,jp,k:Integer;
  YP : real;
begin
    for i:=0 to n-1 do
    begin
      distancia[i,0] := Abs(puntos[i,0]-X0);
      distancia[i,1] := puntos[i,0];
    end;

    for i:=0 to n-1 do
         begin
            verificar[i,0] := distancia[i,0];
            verificar[i,1] := distancia[i,1];
            for j:=0 to n-1 do
            begin
                if(verificar[i,0]>=distancia[j,0]) then
                begin
                     verificar[i,0] := distancia[j,0];
                     verificar[i,1] := distancia[j,1];
                     jp := j;
                end;

            end;
                distancia[jp,0] := 10000000;
                for k:=0 to n-1 do
                  begin
                     if(puntos[k,0]=verificar[i,1]) then
                     begin
                       YP := puntos[k,1];
                     end;
                  end;

                puntosCercanos[i,0] := verificar[i,1];
                puntosCercanos[i,1] := YP;

    end;
    for i:=0 to 4 do
    begin
        puntos[i,0] := puntosCercanos[i,0];
        puntos[i,1] := puntosCercanos[i,1];
        n := 5;
    end;
    Result :=puntos;
end;

function TLagrange.Langrangeanos(LarrayXY:matriz;Lelementos:Integer; LX:real) : cadena;
var
  l,valor,temp : real;
  i,j,k : Integer;
  s : string;
  res : cadena;
  dividendo : real;
  funtion : TParseMath;
begin
  //SetLength(res,2,1);

  Larraya := LarrayXY;
  valor := 0;

  k := 1;
  s :='';
  for i:=0 to Lelementos-1 do
  begin
    l := LarrayXY[i,1];
    for j:=0 to Lelementos-1 do
    begin
      if(i<>j) then
      begin
        dividendo := (LarrayXY[i,0]-LarrayXY[j,0]);
        if(dividendo = 0) then
        begin
          showMessage('Division entre 0 !');
            res[0,0] := '-';
            res[1,0] := '-';
          Result := res;
          exit();
        end;
        l := (l*(LX-LarrayXY[j,0])/dividendo);
        s := s+'*'+'((x-'+FloatToStr(LarrayXY[j,0])+')/'+FloatToStr(LarrayXY[i,0]-LarrayXY[j,0])+')';
      end;
    end;

    if (i<>Lelementos-1) then s := s+'+'+FloatToStr(LarrayXY[k,1]);
      valor := valor + l;
      k := k+1;

  end;
  s :=FloatToStr(LarrayXY[0,1])+s;
  Polinomio := s;

  funtion := TParseMath.create();
  funtion.Expression := Polinomio;
  funtion.AddVariable('x',0) ; funtion.Evaluate();
  funtion.NewValue('x',LX); temp := funtion.Evaluate();

  res[0,0] := Polinomio;
  res[1,0] := FloatToStr(temp);
  Result := res;
end;


function TLagrange.Polinomio_newton(n:Integer;LarrayXY:matriz;xi:real) : cadena;
var
  b : matriz;
  yi : real;
  fx : string;
  fun : vector;
  i , j :Integer;
  Polinomio1 : string;
  dividendo : real;
  funtion : TParseMath;
  res:cadena;
begin
     //SetLength(res,2,1);
     fx :='';
     for i:=0 to n-1 do
     begin
       b[i][0] := LarrayXY[i,1];
     end;

     for j:=1 to n-1 do
     begin
       for i:=0 to n-j-1 do
       begin
         dividendo := (LarrayXY[i+j,0]-LarrayXY[i,0]);
         if(dividendo = 0) then
         begin
          showMessage('Division entre 0 !');
            res[0,0] := '-';
            res[1,0] := '-';
          Result := res;
          exit();
         end;
         b[i,j]:=(b[i+1,j-1]-b[i,j-1])/dividendo;
       end;
     end;
     yi := b[0,0];

     for i:=0 to n-2 do
     begin
       for j:=0 to i do
       begin
         if(j=0) then
         begin
           fx := fx+'(x-'+'('+FloatToStr(LarrayXY[j,0])+')'+')';
         end
         else
         begin
           fx := fx+'*(x-'+'('+FloatToStr(LarrayXY[j,0])+')'+')';
         end;
       end;
       fun[i] := fx;
       fx := '';
     end;

      Polinomio1 :=  FloatToStr(b[0,0]);

     for i:=0 to n-2 do
     begin
       Polinomio1 := Polinomio1+'+'+'('+FloatToStr(b[0][i+1])+')'+'*'+fun[i];
     end;

    { for j:=0 to n-2 do
     begin
       xt := xt*(xi+LarrayXY[j,0]);
       yi := yi+b[0][i+1]*xt;
     end;}

     funtion := TParseMath.create();
     funtion.Expression := Polinomio1;
     funtion.AddVariable('x',0) ; funtion.Evaluate();
     funtion.NewValue('x',xi); yi := funtion.Evaluate();

     res[0,0] := Polinomio1;
     res[1,0] := FloatToStr(yi);

     Result := res;
end;

procedure TLagrange.range(var min:real;var max:real;n:Integer;puntos:matriz);
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

function TLagrange.Evaluar(a,min,max:real;Fpolinomio:string):string;
var
  funtion : TParseMath;
begin
    check:=0;
    if((a>max) or (a<min)) then
    begin
         Result:='No se puede interpolar en '+FloatToStr(a)+' Fuera de Dominio!';
         check:=-1;
         exit();
    end;

    funtion := TParseMath.create();
    funtion.Expression := FPolinomio;
    funtion.AddVariable('x',0) ;
    funtion.NewValue('x',a);
    check:=1;
    Result := FloatToStr(funtion.Evaluate());
end;

end.



