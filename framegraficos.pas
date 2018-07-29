unit FrameGraficos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  DateTimePicker, Forms, Controls, ExtCtrls, StdCtrls, Graphics, ParseMath, Types, math,
  Dialogs, ComCtrls, Interseccion, operadores, ColorBox, TADrawUtils, TACustomSeries;

type

  { TFrame1 }
  matriz = array[0..200, 0..200] of real;
  TFrame1 = class(TFrame)
    grafico7: TLineSeries;
    grafico6: TLineSeries;
    grafico5: TLineSeries;
    grafico4: TLineSeries;
    grafico3: TLineSeries;
    grafico2: TLineSeries;
    grafico1: TLineSeries;
    Area: TAreaSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    chrGrafica: TChart;
    GraficaPoints2: TLineSeries;
    GraficaPoints: TLineSeries;
    Plotear2: TLineSeries;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    Funcion: TFuncSeries;
    Plotear: TLineSeries;
    StatusBar1: TStatusBar;
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure grafico1CustomDrawPointer(ASender: TChartSeries;
      ADrawer: IChartDrawer; AIndex: Integer; ACenter: TPoint);
  private
    EditList: TList;
    ActiveFunction: Integer;
    min1,max1:real;
    Parse  : TparseMath;
    Xminimo,
    Xmaximo: String;

  public
    Texts:string;
    IMin,IMax:real;
    s:Integer;
    vectorfunction:TvectorString;
    FSelecionado:TvectorFuncion;
    FunctionList : TList;
    Wid:Integer;
    Pintar:TColorButton;
    MatP:cadena;
    Rows:Integer;
    Character:TvectorString;
    procedure FuncionCalculate(const AX: Double; out AY: Double);
    Procedure GraficarFuncion(Min,Max:real;funcion1:string;Line:TLineSeries;check:boolean);
    Procedure GraficarFuncion1(Min,Max:real;funcion1:string;Line:TLineSeries;check:boolean);
    procedure ShowPoint(nPoint:Integer;vectorPoint:matriz;pointfuntion:string);
    procedure ShowPointXY(nPoint:Integer;vectorPoint:matriz;f:string;x:real);
    procedure EncontrarInterseccion(fx:string;gx:string;a,b:real;press:real);
    procedure EncontrarInterseccionS();
    Procedure FunctionalBehavior(n:Integer;mat:cadena;Line:TLineSeries);
    procedure Graphic2D(h,min,max:real);
    procedure CreateNewFunction();
    Procedure Clear();
    Procedure NewCreate();
    Procedure NewDestroy();
    function f(x:real;func:string):real;
  end;

implementation

const
  FunctionSeriesName = 'FunctionLines';

Procedure TFrame1.NewCreate();
begin
  s:=0;
  FunctionList:=TList.Create;
  FunctionList.Add(grafico1);
  FunctionList.Add(grafico2);
  FunctionList.Add(grafico3);
  FunctionList.Add(grafico4);
  FunctionList.Add(grafico5);
  FunctionList.Add(grafico6);
  FunctionList.Add(grafico7);

end;

function TFrame1.f(x:real;func:string):real;
begin
  Parse.Expression:= func;
  Parse.NewValue('x',x);
  Result:=Parse.Evaluate();
end;

Procedure TFrame1.NewDestroy();
var
  i:Integer;
begin
  for i:=0 to FunctionList.Count do
  begin
       FunctionList.Delete(i);
  end;
end;

Procedure TFrame1.Clear();
var
  i:Integer;
begin
  for i:=0 to FunctionList.Count-1 do
  begin
       TLineSeries(FunctionList.Items[i]).Clear;
  end;

end;

procedure TFrame1.Graphic2D(h,min,max:real);
var
  x:real;
begin
  x:=min;
  TLineSeries(FunctionList[ActiveFunction]).Clear;
  with TLineSeries(FunctionList[ActiveFunction]) do
  repeat
    AddXY(x,f(x,'sen(x)'));
    x:=x+h;
  until (x>=max);;
end;

procedure TFrame1.ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
  APoint: TPoint);
var
  x, y: Double;
begin
  with ATool as TDatapointClickTool do
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        ShowMessage(' x : '+FloatToStr(x)+' y: '+FloatToStr(y));
        Statusbar1.SimpleText := Format('%s: x = %f, y = %f',[vectorfunction[Tag], x, y]);
        FSelecionado[s]:=vectorfunction[Tag];
        s:=s+1;
        EncontrarInterseccionS();
      end
    else
    begin
      Statusbar1.SimpleText:='';
    end;
end;

procedure TFrame1.grafico1CustomDrawPointer(ASender: TChartSeries;
  ADrawer: IChartDrawer; AIndex: Integer; ACenter: TPoint);
begin

end;

procedure TFrame1.CreateNewFunction();
begin
  FunctionList.Add(TLineSeries.Create(chrGrafica));
  with TLineSeries(FunctionList[FunctionList.Count-1]) do
    begin
      Name:=FunctionSeriesName+IntToStr(FunctionList.Count);
      Tag:=FunctionList.Count-1;
    end;
  chrGrafica.AddSeries(TLineSeries(FunctionList[FunctionList.Count-1]));
end;

procedure TFrame1.FuncionCalculate(const AX: Double; out AY: Double);
begin

end;

Procedure TFrame1.GraficarFuncion(Min,Max:real;funcion1:string;Line:TLineSeries;check:boolean);
var
    h, NewX, NewY: Real;
    Parse1: TparseMath;
begin
  Area.Clear;
  Line.Clear;
  Parse1 := TparseMath.create;
  parse1.AddVariable('x',0);
  parse1.Expression:=funcion1;
  h:= 1 / 1000;
  NewX:=Min ;

   with TLineSeries(Line) do
   begin
       LinePen.Width:= Wid;
       LinePen.Color:=Pintar.ButtonColor;
   end;
  with Line do
  repeat
    Parse1.NewValue('x' , NewX );
    NewY:= Parse1.Evaluate();
    AddXY( NewX, NewY );
    Area.AddXY(NewX,NewY);
    NewX:= NewX + h;
  until NewX>=Max ;
   Area.Active:=check;
   Line.Active:= true;
end;

Procedure TFrame1.GraficarFuncion1(Min,Max:real;funcion1:string;Line:TLineSeries;check:boolean);
var
    h, NewX, NewY: Real;
    Parse1: TparseMath;
begin
  Area.Clear;
  Line.Clear;
  Parse1 := TparseMath.create;
  parse1.AddVariable('x',0);
  parse1.Expression:=funcion1;
  h:= 1 / 1000;
  NewX:=Min ;

   with TLineSeries(Line) do
   begin
       LinePen.Width:= Wid;
   end;
  with Line do
  repeat
    Parse1.NewValue('x' , NewX );
    NewY:= Parse1.Evaluate();
    AddXY( NewX, NewY );
    Area.AddXY(NewX,NewY);
    NewX:= NewX + h;
  until NewX>=Max ;
   Area.Active:=check;
   Line.Active:= true;
end;

Procedure TFrame1.ShowPoint(nPoint:Integer;vectorPoint:matriz;pointfuntion:string);
var
  fx1:TParseMath;
  i:Integer;
begin
  Rows:=0;
  Character[0]:='x'; Character[1]:='  f(x)';
  fx1 := TParseMath.create();
  fx1.Expression := pointfuntion;
  fx1.AddVariable('x',0);
  GraficaPoints.Clear;
  for i:=0 to nPoint-1 do
  begin
       fx1.NewValue('x',vectorPoint[i,0]);
       GraficaPoints.AddXY(vectorPoint[i,0],fx1.Evaluate());
       GraficaPoints.AddXY(NaN,NaN);
       MatP[i,0]:=FloatToStr(vectorPoint[i,0]);
       //MatP[i,1]:=FloatToStr(fx1.Evaluate());
       Rows:=Rows+1;
  end;

  GraficaPoints.ShowPoints:=True;

end;

procedure TFrame1.ShowPointXY(nPoint:Integer;vectorPoint:matriz;f:string;x:real);
var
  i:Integer;
  fx1:TParseMath;
begin
  Rows:=0;
  GraficaPoints2.Clear;
  fx1 := TParseMath.create();
  fx1.Expression := f;
  fx1.AddVariable('x',0);

  fx1.NewValue('x',x);
  GraficaPoints2.AddXY(x,fx1.Evaluate());
  GraficaPoints2.AddXY(NaN,NaN);

  for i:=0 to nPoint-1 do
  begin
       GraficaPoints2.AddXY(vectorPoint[i,0],vectorPoint[i,1]);
       GraficaPoints2.AddXY(NaN,NaN);
       Rows:=Rows+1;
  end;
  GraficaPoints.ShowPoints:=True;
end;

Procedure TFrame1.FunctionalBehavior(n:Integer;mat:cadena;Line:TLineSeries);
var
    i:Integer;
begin
  Line.Clear;
  GraficaPoints.Clear;

   with TLineSeries(Line) do
   begin
       LinePen.Width:= Wid;
       LinePen.Color:=Pintar.ButtonColor;
   end;

  for i:=0 to n do
  begin
       Line.AddXY(StrToFloat(mat[i,0]),StrToFloat(mat[i,1]));
       GraficaPoints.AddXY(StrToFloat(mat[i,0]),StrToFloat(mat[i,1]));
       GraficaPoints.AddXY(NaN,NaN);
  end;

   Line.Active:= true;
   GraficaPoints.ShowPoints:=True;
end;

procedure TFrame1.EncontrarInterseccion(fx:string;gx:string;a,b:real;press:real);
var
  PuntosInterseccion:TInterseccion;
  funtion:string;
  i:Integer;
  puntos:TvectorFloat;
  p:matriz;
begin
  Plotear.Clear;
  GraficaPoints.Clear;
  Plotear2.Clear;
  funtion:='('+fx+')'+'-'+'('+gx+')';
  PuntosInterseccion:=TInterseccion.create(funtion);
  PuntosInterseccion.presicion:=press;
  PuntosInterseccion.execute(a,b);
  puntos:=PuntosInterseccion.Interseccion;

  GraficarFuncion1(a,b,fx,Plotear,false);
  GraficarFuncion1(a,b,gx,Plotear2,false);
  if(PuntosInterseccion.rows=0) then
    exit();

  for i:=0 to PuntosInterseccion.rows-1 do
  begin
       p[i,0]:=puntos[i];
  end;
  ShowPoint(PuntosInterseccion.rows,p,fx);
end;

procedure TFrame1.EncontrarInterseccionS();
var
  PuntosInterseccion:TInterseccion;
  funcionI:string;
  i:Integer;
  puntos:TvectorFloat;
  p:matriz;
begin
   Text:='';
   if (s mod 2) = 0 then
       begin
         funcionI:='('+ FSelecionado[s-2]+')'+'-'+'('+FSelecionado[s-1]+')';
         PuntosInterseccion := TInterseccion.create(funcionI);
         PuntosInterseccion.presicion:=0.00001;
         PuntosInterseccion.execute(IMin,IMax);
         puntos:=PuntosInterseccion.Interseccion;

         {GraficarFuncion(IMin,IMax,FSelecionado[s-2],Plotear,false);
         GraficarFuncion(IMin,IMax,FSelecionado[s-1],Plotear2,false);}
         if(PuntosInterseccion.rows=0) then
         begin
           Texts:='No hay interseccion en el intervalo'+'['+FloatToStr(IMin)+','+FloatToStr(IMax)+']';
           exit();
         end;

         for i:=0 to PuntosInterseccion.rows-1 do
         begin
            p[i,0]:=puntos[i];
         end;
         Texts:='       Puntos de Interseccion:      ';
         ShowPoint(PuntosInterseccion.rows,p,FSelecionado[s-1]);
       end;
end;




{$R *.lfm}

end.

