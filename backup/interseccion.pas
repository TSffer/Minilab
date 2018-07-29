unit Interseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetodosAbiertos, MetodosCerrados, ParseMath, Dialogs, operadores;

type
  TInterseccion=class
    public
      rows:Integer;
      presicion:real;
      funtion:string;
      fx:TParseMath;
      Interseccion:TvectorFloat;
      function Bolzano(x,xn:real):boolean;
      function NumeroDecimales(Numero:real;d:real):real;
      procedure execute(a1,b1:real);
      constructor create(f:string);
      destructor Destroy();
    private
  end;

implementation

constructor TInterseccion.create(f:string);
begin
   fx := TParseMath.create();
   fx.Expression := f;
   fx.AddVariable('x',0);
   funtion := f;
end;

destructor TInterseccion.Destroy();
begin


end;

function TInterseccion.NumeroDecimales(Numero:real;d:real):real;
var
   CantDecimals:Integer;
begin
   CantDecimals:=trunc(1/d);
   Result:=(trunc(round(Numero*CantDecimals))/CantDecimals);
end;

function TInterseccion.Bolzano(x,xn:real):boolean;
begin
   {ShowMessage(FloatToStr(x));
   ShowMessage(FloatToStr(xn));}
   if(x*xn<0) then
   begin
     Result:=True;
   end
   else
   begin
     Result:=False;
   end;
end;

procedure TInterseccion.execute(a1,b1:real);
var
  h,PuntoInterseccion:real;
  Ia,Ib,temp1,temp2,PuntoCercano,a:real;
  MetodoAbierto:TMetodoAbiertos;
  MetodoCerrado:TMetodosCerrados;

begin
   rows:=0;
   MetodoAbierto:=TMetodoAbiertos.Create;
   MetodoCerrado:=TMetodosCerrados.create(funtion);
   h := 0.01;

   Ia:=a1;
   Ib:=a1+h;

   {fx.NewValue('x',800000000);
   ShowMessage(FloatToStr(fx.Evaluate()));}

   {if(fx.Evaluate()<>0) then
   begin

   end;               }
   fx.NewValue('x',a1);
   if(fx.Evaluate()<=0.00001) then
   begin
      Interseccion[rows]:=a1;
      rows:=rows+1;
   end
   else
   begin
     fx.NewValue('x',b1);
     if(fx.Evaluate()<=0.00001) then
     begin
        Interseccion[rows]:=a1;
        rows:=rows+1;
     end;
   end;


   while(Ib<=b1) do
   begin
     fx.NewValue('x',Ia);
     temp1:=fx.Evaluate();
     fx.NewValue('x',Ib);
     temp2:=fx.Evaluate();
     if((Abs(temp2)<=0.00001)) then
     begin
       Interseccion[rows]:=Ib;
       rows:=rows+1;
     end;

     if(Bolzano(temp1,temp2)=True) then
     begin
       PuntoCercano:=MetodoCerrado.MBiseccion(Ia,Ib,presicion,7);
       PuntoInterseccion:=NumeroDecimales(MetodoAbierto.Newton(PuntoCercano,presicion,funtion),presicion);
       if((PuntoInterseccion>=a1) and (PuntoInterseccion<=b1) and (PuntoInterseccion<>a)) then
       begin
          Interseccion[rows]:=PuntoInterseccion;
          a:=PuntoInterseccion;
          rows:=rows+1;
       end;
     end;
     Ia:=Ib;
     Ib:=Ib+h;
   end;

   if(rows=0) then
   begin
     ShowMessage('No hay Interseccion en el Intervalo ['+FloatToStr(a1)+','+FloatToStr(b1)+']');
     exit();
   end;

end;

end.

