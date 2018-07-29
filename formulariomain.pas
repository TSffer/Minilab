unit FormularioMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, CustomDrawnControls, ValEdit, ComCtrls, PairSplitter,
  Grids, ColorBox, FrameGraficos, comandos, Integral, Interpolacion, Conversion,
  TASeries, TAFuncSeries, SpkToolbar, spkt_Tab, operadores,
  MetodosSisEcuNoLineales, math, EDO, extrapolacion, matmatrices, ParseMath,
  newtongeneralizado, Interseccion;

type

  { TForm1 }

  TForm1 = class(TForm)
    CDButton1: TCDButton;
    CmdBox: TCmdBox;
    ActualFrame: Tframe;
    colorbtnFunction: TColorButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Historial: TMemo;
    PairSplitter1: TPairSplitter;
    PairSplitter2: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pgcRight: TPageControl;
    SpkTab1: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrackBar1: TTrackBar;
    tshcomandos: TTabSheet;
    tshVariables: TTabSheet;
    ValueListEditor1: TValueListEditor;
    procedure CDButton1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure StartCommand();
    procedure CmdBoxInput(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
  private

  public
     FunctionList : TList;
     iLineSeries:Integer;
     funcionPloteo:TvectorString;
     VectorLineSeries:TvectorLineSeries;
     obtenerParametros:TComandos;
     operadores:Toperacion;
     varFuncion:TvectorString;
     procedure Write(Message:string);
     procedure Resetear();
     procedure Active();
     procedure Show(min,max:real;funcion:string;check:boolean);
     procedure ShowMatriz(rows,cols:Integer;x:real;mat:cadena;Character:TvectorString);
     procedure OperarExpresion(expresion:string);
     procedure FormatoGraph();
     function VerificarFuncion(var f:string):boolean;
     function VerificarMatriz(f:string;var m:matriz;var n:Integer;var mm:Integer):boolean;
     function VerificarMatrizS(f:string;var m:cadena;var n:Integer;var mm:Integer):boolean;
     procedure range(var min:real;var max:real;n:Integer;puntos:TvectorFloat);
  end;

var
  Form1: TForm1;

implementation
const
  FunctionSeriesName = 'FunctionLines';

{$R *.lfm}

{ TForm1 }

procedure TForm1.CDButton1Click(Sender: TObject);
begin
  Panel4.Visible:=not Panel4.Visible;
  Panel3.Align:=alClient;
  ActualFrame.Free;
  StartCommand();

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.StartCommand();
begin
  CmdBox.StartRead( clBlack, clWhite,  'MiniLab-> ', clBlack, clWhite);

end;

procedure TForm1.CmdBoxInput(ACmdBox: TCmdBox; Input: string);
var
  FinalLine: string;
  f,b1,a1,metodo,Pol,f1,f2,comilla,Texto,funcionA:string;
  a,b,Max,Min,x,respuesta,y,h:real;
  n,j,i,m,c,d,Cols,Rows:Integer;
  integral:TIntegral;
  interpolar:TLagrange;
  adaptadormatriz:TAdaptadorMatriz;
  ENL:TMetodosENL;
  MEDO:TEcuacionesDO;
  Mat,Mat2,P:matriz;
  res:cadena;
  variables,funciones:cadena;
  X0:matriz;
  character:TvectorString;
  RENL, REDO:cadena;
  Extrapolar:TExtrapolacion;
  MatrizMath:TMatriz1;
  newtong:TMetodoAbiertosG;
  PuntosInterseccion:TInterseccion;
  Limites:TvectorFloat;

begin
   a:=0; Rows:=0;
   b:=0; Cols:=0;
   f:='';
   metodo:=''; comilla := '''';

  n:=0; min:=0;max:=0;x:=0;respuesta:=0;y:=0;
  try
     Input:= Trim(Input);
     Historial.Lines.Add(' >> '+Input);
     case input of
       'help': begin CmdBox.TextColors(clBlack,clWhite);CmdBox.Writeln('Hola')end;
       'exit': Application.Terminate;
       'clear': begin CmdBox.Clear; TFrame1(ActualFrame).chrGrafica.ClearSeries; Historial.Lines.Clear; StartCommand() end;
       else
         begin
            FinalLine := StringReplace(Input,' ','',[rfReplaceAll] );
            FinalLine := LowerCase(FinalLine);

            if Pos('plot',FinalLine)>0 then
               begin
                  obtenerParametros.ParametrosGrafico(f,a,b,Input);
                  VerificarFuncion(f);
                  //Show(a,b,f,false);
                  funcionPloteo[iLineSeries]:=f;
                  Active();
                  TFrame1(ActualFrame).NewCreate();
                  TFrame1(ActualFrame).vectorfunction:=funcionPloteo;
                  TFrame1(ActualFrame).IMin:=a;
                  TFrame1(ActualFrame).IMax:=b;
                  FormatoGraph();
                  iLineSeries:=iLineSeries+1;

                  //ShowMessage(TFrame1(ActualFrame).MatP[0,0]);

                  Write(TFrame1(ActualFrame).Texts);
                  ShowMatriz(TFrame1(ActualFrame).Rows,2,0.0001,TFrame1(ActualFrame).MatP,TFrame1(ActualFrame).Character);
                  //ShowMessage(IntToStr(TFrame1(ActualFrame).FunctionList.Count-1));
                  //TFrame1(ActualFrame).GraficarFuncion(a,b,f,TLineSeries(TFrame1(ActualFrame).FunctionList[TFrame1(ActualFrame).FunctionList.Count-1]),False);

                  for i:=0 to iLineSeries do
                  begin
                     TFrame1(ActualFrame).GraficarFuncion1(a,b,funcionPloteo[i],TLineSeries(TFrame1(ActualFrame).FunctionList[i]),False);
                  end;
                  //ShowMessage('Hola 3');

                  StartCommand();
               end
            else if Pos('integrar',FinalLine)>0 then
               begin
                   integral := TIntegral.Create;
                   obtenerParametros.ParametrosIntegral(metodo,f,a,b,n,Input);
                   VerificarFuncion(f);
                   Write(FloatToStr(integral.Execute(metodo,f,a,b,n)));
                   integral.destroy();
                   StartCommand();
               end
            else if Pos('area',FinalLine)>0 then
               begin
                   integral := TIntegral.Create;
                   obtenerParametros.ParametrosIntegral(metodo,f,a,b,n,Input);
                   //if((a=0) and (b=0)) then begin a:=-50;b:=50; end;
                   VerificarFuncion(f);

                   if(n=1) then
                   begin
                      f1:=f;
                      VerificarFuncion(metodo);
                      funcionA:=metodo+'-'+'('+f+')';
                      f:='Abs'+'('+metodo+'-'+'('+f+')'+')';

                      //if((a=-50) and (b=50)) then
                      //begin
                        PuntosInterseccion:=TInterseccion.create(funcionA);
                        PuntosInterseccion.presicion:=0.0001;
                        PuntosInterseccion.execute(a,b);
                        Limites:=PuntosInterseccion.Interseccion;
                        range(a,b,PuntosInterseccion.rows,Limites);

                        respuesta:=integral.Simpson13(f,a,b,150);
                        //ShowMessage(FloatTostr(a) + ' ' +FloatTostr(b));
                        Active();
                        FormatoGraph();
                        TFrame1(ActualFrame).GraficarFuncion1(a,b,metodo,TFrame1(ActualFrame).grafico1,false);
                        TFrame1(ActualFrame).GraficarFuncion1(a,b,f1,TFrame1(ActualFrame).grafico2,false);
                        mat[0,0]:=a;
                        mat[0,1]:=b;
                        TFrame1(ActualFrame).ShowPoint(2,mat,metodo);
                        //TFrame1(ActualFrame).GraficarFuncion(a,b,f,TFrame1(ActualFrame).grafico1,True);
                      //end   e(x)
                      //else
                      //begin
                         //respuesta:=integral.Simpson13(f,Limites[0],Limites[PuntosInterseccion.rows-1],200);
                         //Active();
                         //FormatoGraph();
                         //TFrame1(ActualFrame).GraficarFuncion(Limites[0],Limites[PuntosInterseccion.rows-1],f,TFrame1(ActualFrame).grafico1,True;
                      //end;
                      //TFrame1(ActualFrame).GraficarFuncion(Limites[0],Limites[PuntosInterseccion.rows-1],metodo,TFrame1(ActualFrame).grafico2,True);
                      //Show(Limites[0]-5,Limites[0],f,True);
                      Write(FloatToStr(respuesta));
                      Write('xi '+FloatToStr(a));
                      Write('xf '+FloatToStr(b));
                      StartCommand();
                   end
                   else
                   begin
                     respuesta:=integral.ExecuteA(metodo,f,a,b,n);
                     Show(a,b,f,True);
                     Write(FloatToStr(respuesta));
                     integral.destroy();
                     StartCommand();
                   end;
               end
            else if Pos('interpolar',FinalLine)>0 then
               begin
                   interpolar := TLagrange.Create;
                   f:=(copy(Input,pos('(',Input)+2, pos(',',Input)-3-pos('(',Input)));
                   adaptadormatriz := TAdaptadorMatriz.Create;
                   Mat:=adaptadormatriz.StringToMat(f);
                   n:=adaptadormatriz.Tm;
                   if(n=1) then
                   begin
                     VerificarMatriz(f,Mat,n,c);
                   end;

                   delete(Input,pos('(',Input)+1, pos(',',Input)-pos('(',Input));
                   a:=StrToFloat(copy(Input,pos('(',Input)+1, pos(')',Input)-1-pos('(',Input)));

                   if (n>5) then
                   begin
                       Mat:=interpolar.NearPoint(Mat,a,n);
                   end;
                   res:=interpolar.Langrangeanos(Mat,n,a);
                   interpolar.range(min,max,n,Mat);
                   Show(min-1,max+1,res[0,0],false);
                   Pol:= interpolar.Evaluar(a,min,max,res[0,0]);
                   if(interpolar.check=1) then
                   begin
                       Mat[n,0]:=a;
                       n:=n+1
                   end;
                   TFrame1(ActualFrame).ShowPoint(n,Mat,res[0,0]);
                   Write(res[0,0]);
                   Write(Pol);
                   StartCommand();
               end
            else if Pos('enl',FinalLine)>0 then
               begin
                   obtenerParametros.ParametrosENL(metodo,f,a,b,x,Input);
                   VerificarFuncion(f);
                   ENL:=TMetodosENL.create(f);
                   respuesta:=ENL.Execute(metodo,f,a,b,x);
                   RENL:= ENL.M;
                   ShowMatriz(ENL.i,ENL.j,x,ENL.M,ENL.Character);
                   Write(FloatToStr(operadores.NumeroDecimales(respuesta,x)));
                   Mat2[0,0] := respuesta;
                   Show(respuesta-10,respuesta+10,f,false);
                   TFrame1(ActualFrame).ShowPoint(1,mat2,f);
                   ENL.Destroy;
                   StartCommand();
               end
            else if Pos('newtong',FinalLine)>0 then
               begin
                  try
                     newtong:=TMetodoAbiertosG.create;
                     f1:=(copy(Input,pos('(',Input)+2, pos(',',Input)-3-pos('(',Input)));
                     VerificarMatrizS(f1,funciones,m,n);

                     delete(Input,pos('(',Input)+1, pos(',',Input)-pos('(',Input));
                     f1:=(copy(Input,pos('(',Input)+2, pos(',',Input)-3-pos('(',Input)));
                     VerificarMatrizS(f1,variables,m,n);
                     delete(Input,pos('(',Input)+1, pos(',',Input)-pos('(',Input));

                     f1:=(copy(Input,pos('(',Input)+2, pos(')',Input)-3-pos('(',Input)));
                     VerificarMatriz(f1,X0,m,n);

                     ShowMatriz(newtong.Rows,m+1,0.0001,newtong.NewtonG(variables,X0,funciones,0.0001,20,m),newtong.Character);
                  except
                     Write('Verifique la entrada !');
                     StartCommand();
                  end;
                   StartCommand();
               end
            else if Pos('interseccion',FinalLine)>0 then
               begin
                   obtenerParametros.ParametrosInterseccion(f1,f2,a,b,x,Input);
                   VerificarFuncion(f1);
                   VerificarFuncion(f2);
                   Active(); FormatoGraph();
                   TFrame1(ActualFrame).EncontrarInterseccion(f1,f2,a,b,x);
                   ShowMatriz(TFrame1(ActualFrame).Rows,2,x,TFrame1(ActualFrame).MatP,TFrame1(ActualFrame).Character);
                   StartCommand();
               end
            else if Pos('edo',FinalLine)>0 then
               begin
                   obtenerParametros.ParametrosEDO(metodo,f,a,b,y,h,Input);
                   VerificarFuncion(f);
                   MEDO:=TEcuacionesDO.create();
                   REDO:=MEDO.Execute(metodo,f,a,b,y,h);
                   write(FloatToStr(Mat[0,0]));
                   ShowMatriz(MEDO.rows,2,0.0000001,REDO,MEDO.Character);

                   Active(); FormatoGraph();
                   TFrame1(ActualFrame).FunctionalBehavior(MEDO.rows,REDO,TFrame1(ActualFrame).Plotear2);
                   StartCommand();
               end
            else if Pos('extrapolar',FinalLine)>0 then
               begin
                   obtenerParametros.ParametrosExtrapolar(metodo,x,Input);
                   Extrapolar:=TExtrapolacion.Create;
                   Mat:=Extrapolar.Execute(metodo,f,a,n);
                   Extrapolar.range(min,max,n,Mat);
                   //ValueListEditor1 LoadFromFile('datos.txt');
                   respuesta := Extrapolar.Evaluar(x,min,max,f);
                   Show(min,max,f,False);
                   TFrame1(ActualFrame).ShowPointXY(n,Mat,f,x);
                   Write('f(x) = '+f);
                   Write('R = '+FloatToStr(a));
                   Write('Valor Extrapolado = '+FloatToStr(respuesta));
                   StartCommand();
               end
            else if Pos('matriz',FinalLine)>0 then
               begin
                   MatrizMath:=TMatriz1.create;

                   metodo:=(copy(Input,pos('(',Input)+1,pos(',',Input)-1-pos('(',Input)));
                   delete(Input,pos('(',Input)+1, pos(',',Input)-pos('(',Input));
                   f1:=(copy(Input,pos('(',Input)+2, pos(',',Input)-3-pos('(',Input)));
                   adaptadormatriz := TAdaptadorMatriz.Create;
                   mat:=adaptadormatriz.StringToMat(f1);
                   delete(Input,pos('(',Input)+1, pos(',',Input)-pos('(',Input));
                   m:=adaptadormatriz.Tm;
                   n:=adaptadormatriz.Tn;

                   if((n=1) or (m=1)) then
                   begin
                     VerificarMatriz(f1,Mat,m,n);
                   end;

                   f1:=(copy(Input,pos('(',Input)+2, pos(')',Input)-3-pos('(',Input)));
                   mat2:=adaptadormatriz.StringToMat(f1);
                   obtenerParametros.ParametrosMatriz(f1,x);
                   c:=adaptadormatriz.Tm;
                   d:=adaptadormatriz.Tn;

                   if((c=1) or (d=1)) then
                   begin
                     VerificarMatriz(f1,Mat2,c,d);
                   end;

                   MatrizMath.matrizA:=mat;
                   MatrizMath.matrizB:=mat2;
                   res:=MatrizMath.Execute(metodo,m,n,c,d,Texto,Rows,Cols,x-1);
                   ShowMatriz(Rows,Cols,0.0001,res,character);
                   write(Texto);
                   StartCommand();
               end
            else if Pos('=',FinalLine)>0 then
               begin
                   obtenerParametros.ObtenerVariable(a1,b1,Input);
                   StringGrid1.Cells[0,StringGrid1.RowCount-1]:=a1;
                   StringGrid1.Cells[1,StringGrid1.RowCount-1]:=b1;
                   StringGrid1.Cells[2,StringGrid1.RowCount-1]:=obtenerParametros.Tipo;
                   StringGrid1.RowCount:=StringGrid1.RowCount+1;
               end
            else if Pos('reset',FinalLine)>0 then
               begin
                  TFrame1(ActualFrame).chrGrafica.ClearSeries;
                  iLineSeries:=0;
                  Resetear()
               end
            else if true then
               begin
                   try
                   OperarExpresion(FinalLine);
                   except
                       Write('Comando no valido !');
                       StartCommand();
                   end;
               end
            else
                Write('Comando no valido !');
                StartCommand();
         end;
  end;
  Except
     StartCommand();
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox.StartRead( clBlack, clWhite,  'MiniLab-> ', clBlack, clWhite);
  Memo1.Lines.LoadFromFile('instrucciones.txt');
  iLineSeries:=0;
  obtenerParametros := TComandos.Create;
  operadores:=Toperacion.Create;
  Panel4.Visible:=False;
  StartCommand();
end;


procedure TForm1.Write(Message:string);
begin
   if(Message=FloatToStr(10101000000000)) then
      begin
         CmdBox.TextColors(clBlack,clWhite);
         CmdBox.Writeln(' >> '+'Invalido!');
         exit();
      end;
   CmdBox.TextColors(clBlack,clWhite);
   Historial.Lines.Add(' >> '+Message);
   CmdBox.Writeln(' >> '+Message);
end;

procedure TForm1.Resetear();
begin
   if(Panel4.Visible = True ) then
   begin
     ActualFrame.Free;
     Panel4.Visible:=not Panel4.Visible;
     Panel3.Align:=alClient;
     StartCommand();
     exit();
   end
   else if(Panel4.Visible=false) then
   begin
     Panel3.Align:=alClient;
     StartCommand();
     exit()
   end;
     Panel4.Visible:=not Panel4.Visible;
     Panel3.Align:=alClient;
     StartCommand();
end;

procedure TForm1.Active();
begin
   if(Panel4.Visible = True ) then
   begin
      ActualFrame.Free;
   end;

   Panel4.Visible:=True;
   ActualFrame:= TFrame1.Create( Form1 );
   ActualFrame.Parent:= Form1.Panel4;
   ActualFrame.Align:= alClient;
   ActualFrame.Show;
end;
procedure TForm1.FormatoGraph();
begin
   TFrame1(ActualFrame).Wid:=TrackBar1.Position;
   TFrame1(ActualFrame).Pintar:=TColorButton(colorbtnFunction);
end;

procedure TForm1.Show(min,max:real;funcion:string;check:boolean);
begin
   Active();
   FormatoGraph();
   TFrame1(ActualFrame).GraficarFuncion(min,max,funcion,TFrame1(ActualFrame).Plotear2,check);
end;

procedure TForm1.ShowMatriz(rows,cols:Integer;x:real;mat:cadena;Character:TvectorString);
var
  i,j:Integer;
  bla:string;
begin
  bla:='                                                                          ';
  for i:=0 to cols-1 do
  begin
     CmdBox.TextColors(clBlack,clWhite);
     CmdBox.Write(' '+Copy(bla,0,round(Length(FloatToStr(x))/2))+Character[i]+' ');
  end;

  CmdBox.TextColors(clBlack,clWhite);
  CmdBox.WriteLn('');
  for i:=0 to rows-1 do
  begin
      for j:=0 to cols-1 do
      begin
         CmdBox.TextColors(clBlack,clWhite);
         CmdBox.Write(' '+FloatTostr(operadores.NumeroDecimales(StrToFloat(Mat[i,j]),x))+Copy(bla,0,(Abs(Length(FloatToStr(x))-Length(FloatTostr(operadores.NumeroDecimales(StrToFloat(mat[i,j]),x))))))+'  ');
      end;
      CmdBox.TextColors(clBlack,clWhite);
      CmdBox.WriteLn('');
  end;
end;

procedure TForm1.OperarExpresion(expresion:string);
var
  i,check,j:Integer;
  a:matriz;
  b:matriz;
  v1,v2,matS:string;
  Parse:TParseMath;
  varEntero:Tvector;
  varFloat:TvectorFloat;
  varMatriz:TvectorMat;
  k:real;
  adaptadormatriz:TAdaptadorMatriz;
  vf:TvectorString;
begin
  Parse:=TParseMath.Create;
  v1:='';v2:='';
  k:=0;check:=0;

  for i:=0 to StringGrid1.RowCount-1 do
  begin
     if Pos(StringGrid1.Cells[0,i],expresion)>0  then
     begin
       try
          VarEntero[i]:=StrToInt(StringGrid1.Cells[1,i] );
          Parse.AddVariable(StringGrid1.Cells[0,i],0);
          Parse.NewValue(StringGrid1.Cells[0,i],VarEntero[i]);
          StringGrid1.Cells[2,i]:='int';
       except
          k:=-1;
       end;
       if(k=-1) then
       begin
          try
            VarFloat[i]:=StrToFloat(StringGrid1.Cells[1,i] );
            Parse.AddVariable(StringGrid1.Cells[0,i] ,0);
            Parse.NewValue(StringGrid1.Cells[0,i],VarFloat[i]);
            StringGrid1.Cells[2,i]:='float';
          except
            k:=-1;
          end;
       end;
       if((k=-1) and (Pos('[',StringGrid1.Cells[1,i])>0)) then
       begin
          adaptadormatriz := TAdaptadorMatriz.Create;
          varMatriz[i]:=adaptadormatriz.StringToMat(StringGrid1.Cells[1,i]);
          exit();
       end;
       if (Pos('(x)',StringGrid1.Cells[0,i])>0) or (Pos('(x,y)',StringGrid1.Cells[0,i])>0) then
       begin
          varFuncion[i]:=StringGrid1.Cells[1,i];
          StringGrid1.Cells[2,i]:='funcion';
          exit();
       end;
     end;
  end;

  Parse.Expression:=expresion;
  Write(FloatToStr(Parse.Evaluate()));
end;

function TForm1.VerificarFuncion(var f:string):boolean;
var
  i:Integer;
begin
     for i:=0 to StringGrid1.RowCount-1 do
     begin
       if(f = StringGrid1.Cells[0,i]) then
       begin
         f:=StringGrid1.Cells[1,i];
         Result:=True;
       end;
     end;

end;

function TForm1.VerificarMatriz(f:string;var m:matriz;var n:Integer;var mm:Integer):boolean;
var
  i:Integer;
  adaptadormatriz:TAdaptadorMatriz;
begin
  adaptadormatriz:=TAdaptadorMatriz.Create;
  for i:=0 to StringGrid1.RowCount-1 do
  begin
    if(f=stringGrid1.Cells[0,i]) then
    begin
      m:=adaptadormatriz.StringToMat(StringGrid1.Cells[1,i]);
      n:=adaptadormatriz.Tm;
      mm:=adaptadormatriz.Tn;
      VerificarMatriz:=True;
    end;
  end;
end;

function TForm1.VerificarMatrizS(f:string;var m:cadena;var n:Integer;var mm:Integer):boolean;
var
  i:Integer;
  adaptadormatriz:TAdaptadorMatriz;
begin
  adaptadormatriz:=TAdaptadorMatriz.Create;
  for i:=0 to StringGrid1.RowCount-1 do
  begin
    if(f=stringGrid1.Cells[0,i]) then
    begin
      m:=adaptadormatriz.StringToMatStr(StringGrid1.Cells[1,i]);
      n:=adaptadormatriz.Tm;
      mm:=adaptadormatriz.Tn;
      VerificarMatrizS:=True;
    end;
  end;
end;

procedure TForm1.range(var min:real;var max:real;n:Integer;puntos:TvectorFloat);
var
  i:Integer;
begin
    max := puntos[0];
    for i:=0 to n-1 do
    begin
         if (puntos[i]>max) then
            max := puntos[i];
    end;
    min := puntos[0];
    for i:=0 to n-1 do
    begin
         if (puntos[i]<min) then
            min := puntos[i];
    end;
end;


end.

