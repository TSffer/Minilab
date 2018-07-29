program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, cmdbox, customdrawn, datetimectrls, FormularioMain,
  FrameGraficos, Integral, Interpolacion, Conversion, Parsemath1, operadores,
  MetodosSisEcuNoLineales, EDO, extrapolacion, matmatrices, SobrecargaMatriz,
  rec, newtongeneralizado, matrizJacobiana, operacionesMatrices
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

