unit comandos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, math, operadores, Conversion, ParseMath;

type
  TComandos = class
    public
      VarEntero:Integer;
      VarFloat:float;
      VarFuncion:string;
      VarMatriz:matriz;
      VEntero:Integer;
      VFloat:real;
      VFuncion:string;
      VMatriz:matriz;
      Tipo:string;
      Texto:string;
      procedure ParametrosMatriz(f:string;var x:real);
      procedure ParametrosGrafico(var f:string;var Min:real;var Max:real;input:string);
      procedure ParametrosExtrapolar(var f:string;var v:real;input:string);
      procedure ParametrosIntegral(var metodo:string;var f:string;var Min:real;var Max:real;var n:Integer;input:string);
      procedure ParametrosENL(var metodo:string;var f:string;var a:real;var b:real;var x:real;input:string);
      procedure ParametrosEDO(var metodo:string;var f:string;var a:real;var b:real;var y:real;var n:real;input:string);
      procedure ParametrosInterseccion(var f1:string;var f2:string;var Min:real;var Max:real;var n:real;input:string);
      function ObtenerVariable(var v1:string;var v2:string;comando:string):Integer;
      procedure OperarExpresion(n:Integer;variable:cadena;valor:matriz;expresion:string);
    private
  end;

implementation
const
  EsENTERO = 1;
  EsFLOAT = 2;
  EsFUNCION = 3;
  EsMATRIZ = 4;

procedure TComandos.ParametrosMatriz(f:string;var x:real);
begin
   try
      f:=f+'.0';
      x:=StrToFloat(f);
   except
   end;
end;

procedure TComandos.ParametrosGrafico(var f:string;var Min:real;var Max:real;input:string);
var
  FinalLine:string;
begin
   try
      FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
      f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Min:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Max:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   Except
     f:='';
   end;

end;

procedure TComandos.ParametrosExtrapolar(var f:string;var v:real;input:string);
var
  FinalLine:string;
begin
   try
      FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
      f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      v:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   Except
     f:='';
   end;
end;

procedure TComandos.ParametrosIntegral(var metodo:string;var f:string;var Min:real;var Max:real;var n:Integer;input:string);
var
  FinalLine:string;
begin
   try
      FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
      metodo:=(copy(FinalLine,pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Min:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Max:=StrToFloat(copy(FinalLine,Pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      n:=StrToInt(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   Except
     f:='';
   end;
end;

procedure TComandos.ParametrosENL(var metodo:string;var f:string;var a:real;var b:real;var x:real;input:string);
var
  FinalLine:string;
begin
   try
       FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
       metodo:=(copy(FinalLine,pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
       delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));

       if((Pos('newton',metodo)>0) or (Pos('secante',metodo)>0)) then
       begin
         f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
         delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
         a:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
         delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
         x:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
         exit();
       end;
       f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
       delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
       a:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
       delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
       b:=StrToFloat(copy(FinalLine,Pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
       delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
       x:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   except
     f:='';
   end;

end;

function TComandos.ObtenerVariable(var v1:string;var v2:string;comando:string):Integer;
var
  FinalLine,variable,valor:String;
  a:Extended;
  Adp:TAdaptadorMatriz;
  dd:real;
  mat:String;
begin
   mat:=comando;
   comando := Trim(comando);
   FinalLine:=  StringReplace ( comando, ' ', '', [ rfReplaceAll ] );
   variable := Copy(FinalLine,0,Pos('=',FinalLine)-1);
   valor := Copy(FinalLine,Pos('=',FinalLine)+1,length(FinalLine));
   v1:=variable;
   v2:=valor;
   try
     VEntero:=strtoint(valor);
     Tipo:='int';
   except
     Result:=-1;
   end;

   if(Result=-1) then
   begin
        try
          VFloat:=StrToFloat(valor);
          Tipo:='float';
          Result:=EsFloat;
        except
          Result:=-1;
        end;
   end;

   if(Result=-1) then
   begin
     if((Pos('[',valor)>0) and (Pos(']',valor)>0)) then
     begin
         Tipo:='matriz';
         v2 := Copy(mat,Pos('=',mat)+1,length(mat));
         //v2:=mat;
     end;
   end;

   if((Pos('(x)',variable)>0) or (Pos('(x,y)',variable)>0) ) then
   begin
        VFuncion:=valor;
        Tipo:='funcion';
        Result:=EsFuncion;
   end;

   Result := -1;
end;

procedure TComandos.ParametrosEDO(var metodo:string;var f:string;var a:real;var b:real;var y:real;var n:real;input:string);
var
  FinalLine:string;
begin
   try
      FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
      metodo:=(copy(FinalLine,pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      f:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      a:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      b:=StrToFloat(copy(FinalLine,Pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      y:=StrToFloat(copy(FinalLine,Pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      n:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   Except
     f:='';
   end;
end;

procedure TComandos.ParametrosInterseccion(var f1:string;var f2:string;var Min:real;var Max:real;var n:real;input:string);
var
  FinalLine:string;
begin
   try
      FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
      f1:=(copy(FinalLine,pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      f2:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Min:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      Max:=StrToFloat(copy(FinalLine,Pos('(',FinalLine)+1,pos(';',FinalLine)-1-pos('(',FinalLine)));
      delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
      n:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));
   Except
     f1:='';
   end;
end;

procedure TComandos.OperarExpresion(n:Integer;variable:cadena;valor:matriz;expresion:string);
var
  Parse:TParseMath;
  i:Integer;
begin
   Parse:=TParseMath.create;
   Parse.Expression:=expresion;

   for i:=0 to n-1 do
   begin

   end;
   try
      if Pos('+',expresion)>0 then
      begin

      end;

   except
   end;

end;


















end.

