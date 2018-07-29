unit Parsemath1;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, math, fpexprpars, Dialogs, Integral;

type
  TParseMath = Class

  Private
      FParser: TFPExpressionParser;
      identifier: array of TFPExprIdentifierDef;
      Procedure AddFunctions();


  Public
      Expression: string;
      function NewValue( Variable:string; Value: Double ): Double;
      procedure AddVariable( Variable: string; Value: Double );
      procedure AddString( Variable: string; Value: string );
      function Evaluate(  ): Double;
      constructor create();
      destructor destroy;

  end;

implementation

constructor TParseMath.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();
end;

destructor TParseMath.destroy;
begin
    FParser.Destroy;
end;

function TParseMath.NewValue( Variable: string; Value: Double ): Double;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;

end;

function TParseMath.Evaluate(): Double;
begin
     FParser.Expression:= Expression;
     Result:= ArgToFloat( FParser.Evaluate );

end;

function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;



procedure ExprFloor(var Result: TFPExpressionResult; Const Args: TExprParameterArray); // maximo entero
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   if x > 0 then
     Result.ResFloat:= trunc( x )

   else
     Result.ResFloat:= trunc( x ) - 1;

end;

Procedure ExprTan( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x - 0.5) / pi) <> 0.0) then begin
      if((tan(x)>xmin) or (tan(x)<-xmin)) then
      begin
          Result.resFloat :=NaN;
      end
      else if (IsNumber(x) and ((frac(x - 0.5) / pi) <> 0.0)) then
      begin

          Result.resFloat := tan(x);
      end;
   end
   else
     Result.resFloat := NaN;

end;

Procedure ExprSin( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := sin(x)

end;

Procedure ExprCos( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := cos(x)

end;

Procedure ExprLn( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprLog( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x) / ln(10)

   else
     Result.resFloat := NaN;

end;

Procedure ExprSQRT( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := sqrt(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprPower( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,y: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
    y := ArgToFloat( Args[ 1 ] );


     Result.resFloat := power(x,y);

end;

//Funciones nuevas
Procedure ExprSinh( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := sinh(x)

end;                             //e

Procedure ExprCsch( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x-0.5)/pi)<>0.0) then
   begin
      if((1/sinh(x)>xmin) or (1/sinh(x)<-xmin)) then
      begin
         Result.ResFloat:=NaN;
      end
      else if (IsNumber(x) and ((frac(x-0.5)/pi)<>0.0)) then
      begin
        Result.resFloat := (1/sinh(x))
      end;
   end
   else
       Result.ResFloat:=NaN;

                                    //e
end;

Procedure ExprCosh( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := Cosh(x)
                                  //e
end;

Procedure ExprSech( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := (1/cosh(x))
                                     //e
end;

Procedure ExprTanh( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := tanh(x)
                               //e
end;

Procedure ExprCoth( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x-0.5)/pi)<>0.0) then
   begin
      if((1/tanh(x)>xmin) or (1/tanh(x)<-xmin)) then
      begin
         Result.ResFloat:=NaN;
      end
      else if (IsNumber(x) and ((frac(x-0.5)/pi)<>0.0)) then
      begin
        Result.resFloat := (1/tanh(x))
      end;
   end
   else
       Result.ResFloat:=NaN;
                                //e
end;

Procedure ExprArcsen( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := Arcsin(x)  //e

end;

Procedure ExprArcCos( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := ArcCos(x)
                                //e
end;

Procedure ExprArcTan( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := ArcTan(x)
                               //e
end;

Procedure ExprSec( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x-0.5)/pi)<>0.0) then
   begin
      if((sec(x)>xmin) or (sec(x)<-xmin)) then
      begin
         Result.ResFloat:=NaN;
      end
      else if (IsNumber(x) and ((frac(x-0.5)/pi)<>0.0)) then
      begin
        Result.resFloat := sec(x)
      end;
   end
   else
       Result.ResFloat:=NaN;
                              //e
end;

Procedure ExprCsc( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x-0.5)/pi)<>0.0) then
   begin
      if((Csc(x) >xmin) or (Csc(x)<-xmin)) then
      begin
         Result.ResFloat:=NaN;
      end
      else if (IsNumber(x) and ((frac(x-0.5)/pi)<>0.0)) then
      begin
        Result.resFloat := Csc(x)
      end;
   end
   else
       Result.ResFloat:=NaN;
                             //e
end;

Procedure ExprCot( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  xmin:Double;
begin
   xmin:=100;
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x-0.5)/pi)<>0.0) then
   begin
      if((cot(x) >xmin) or (cot(x)<-xmin)) then
      begin
         Result.ResFloat:=NaN;
      end
      else if (IsNumber(x) and ((frac(x-0.5)/pi)<>0.0)) then
      begin
        Result.resFloat := cot(x)
      end;
   end
   else
       Result.ResFloat:=NaN;
                               //e
end;

Procedure TParseMath.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('tan', 'F', 'F', @ExprTan);
       AddFunction('sin', 'F', 'F', @ExprSin);
       AddFunction('sen', 'F', 'F', @ExprSin);
       AddFunction('cos', 'F', 'F', @ExprCos);
       AddFunction('ln', 'F', 'F', @ExprLn);
       AddFunction('log', 'F', 'F', @ExprLog);
       AddFunction('sqrt', 'F', 'F', @ExprSQRT);
       AddFunction('floor', 'F', 'F', @ExprFloor );
       AddFunction('power', 'F', 'FF', @ExprPower); //two float arguments 'FF' , returns float
       //AddFunction('Newton', 'F', 'SF', @ExprNewton ); // Una sring argunmen and one float argument, returns float
       AddFunction('senh', 'F', 'F', @ExprSinh);
       AddFunction('csch', 'F', 'F', @ExprCsch);
       AddFunction('cosh', 'F', 'F', @ExprCosh);
       AddFunction('sech', 'F', 'F', @ExprSech);
       AddFunction('tanh', 'F', 'F', @ExprTanh);
       AddFunction('coth', 'F', 'F', @ExprCoth);
       AddFunction('arcsen', 'F', 'F', @ExprArcsen);
       AddFunction('arccos', 'F', 'F', @ExprArcCos);
       AddFunction('arctan', 'F', 'F', @ExprArcTan);
       AddFunction('sec', 'F', 'F', @ExprSec);
       AddFunction('csc', 'F', 'F', @ExprCsc);
       AddFunction('cot', 'F', 'F', @ExprCot);
       //Metodos Numericos
   end

end;

procedure TParseMath.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);

end;

procedure TParseMath.AddString( Variable: string; Value: string );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;

   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
end;

end.

