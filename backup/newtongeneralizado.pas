unit newtongeneralizado;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath, math, Dialogs, operadores, matrizJacobiana, operacionesmatrices;

type
  funcionesParse = array of array of TParseMath;
  TMetodoAbiertosG = class
    public
      Rows:Integer;
      Character:TvectorString;
      function PuntoFijoG(Variables:cadena;X0:matriz ; GX:cadena  ; es:real ; imax,numv:Integer) : matriz;
      function NewtonG(Variables:cadena;X0:matriz ; FX:cadena ; EX:real ;MAXIT,numv: Integer) : cadena;
      function derivadaParcial(fun:TParseMath;x:string;valor:real): real;
      constructor create();
      destructor destroy(); override;
    private
  end;

implementation

constructor TMetodoAbiertosG.create();
begin
end;


destructor TMetodoAbiertosG.destroy();
begin
end;

function TMetodoAbiertosG.PuntoFijoG(Variables:cadena;X0:matriz; GX:cadena ; es:real ; imax,numv:Integer) : matriz;
var
   e,veri ,converge: real;
   M : matriz;
   xr,temp,temp1,xrold , x , xn,aux: matriz;
   miparse : funcionesParse;
   i,j,iter ,ii,cont,k: Integer;
   Error : matriz;
   resul : TJacobiana;
begin
  SetLength(miparse,numv,1);
  converge :=0;
  resul := TJacobiana.create(Variables,GX,X0,numv);
  aux := resul.Evaluate();
  for i:=0 to numv-1 do
  begin
       for j:=0 to numv-1 do
       begin
            converge :=  converge + power(aux[i,j],2)
       end;
  end;
  converge := sqrt(converge);
  if (converge >=1) then
  begin
      for i:=0 to numv-1 do
      begin
           M[0,i] := 0;
           ShowMessage('El Sistema no converge');
           result := M;
           exit();
      end;
  end;

  for i:=0 to numv-1 do
  begin
      miparse[i,0] := TParseMath.create();
  end;

  for i:=0 to numv-1 do
  begin
      miparse[i,0].Expression := GX[i,0];
  end;

  for i:=0 to numv-1 do
    for j:=0 to numv-1 do
      begin
        miparse[i,0].AddVariable(Variables[j,0],0.0);
      end;

  for i:=0 to numv-1 do
    begin
        M[0,i] := (X0[i,0]);
    end;


  for i:=0 to numv-1 do
    for j:=0 to numv-1 do
      begin
        miparse[i,0].NewValue(Variables[j,0],X0[j,0]);
      end;

  for i:=0 to numv-1 do
    begin
      temp[i,0]:= miparse[i,0].Evaluate();
    end;

  {verificar}
  for i:=0 to numv-1 do
    begin
      if(temp[i,0]=0) then
      begin
        if(cont = numv) then
        begin
             for k:=0 to numv-1 do
             begin
                M[0,k] := X0[k,0];
                result := M;
                exit();
             end;
        end;
      cont := cont + 1;
      end;
    end;
  {}

cont := 0;
e:=0;
xr := X0;
iter := 0;
ii := 0;

while (iter<imax) do
  begin
      xn := X0;
      for i:=0 to numv-1 do
          for j:=0 to numv-1 do
          begin
               miparse[i,0].NewValue(Variables[j,0],X0[j,0]);
          end;

      for i:=0 to numv-1 do
          begin
               temp1[i,0]:= miparse[i,0].Evaluate();
          end;
      x := temp1;
      iter := iter+1;

      {ERROR}
      for i:=0 to numv-1 do
      begin
          e := e + power(x[i,0]-xn[i,0],2);
      end;
      veri := sqrt(e);
      {ShowMessage(FloatToStr(x[1,0])+'   '+FloatToStr(xn[1,0]));}

      for i:=0 to numv-1 do
          begin
            M[ii,i]:= x[i,0];
          end;
      M[ii,numv] := veri;
      ii := ii+1;
       X0 := x;
       e := 0;
  end;
    Result := M;
end;

function TMetodoAbiertosG.NewtonG(Variables:cadena;X0:matriz ; FX:cadena ; EX:real ;MAXIT,numv: Integer) : cadena;
var
   temp , aux,x,xn,BB,JInver: matriz;
   i , j , cont,ii : Integer;
   M :cadena;
   veri,e: real;
   resul : TJacobiana;
   miparse : funcionesParse;
   operacion : TMatriz;
begin
   for i:=0 to numv-1 do
   begin
     Character[i]:='  '+variables[i,0];
   end;
   Character[numv]:='  Error';

   SetLength(miparse,numv,1);
   operacion := TMatriz.create();
   Rows:=0;
   e := 0;
     for i:=0 to numv-1 do
      begin
            miparse[i,0] := TParseMath.create();
      end;

    for i:=0 to numv-1 do
     begin
          miparse[i,0].Expression := FX[i,0];
     end;

     for i:=0 to numv-1 do
        for j:=0 to numv-1 do
         begin
              miparse[i,0].AddVariable(Variables[j,0],0.0);
         end;

     cont :=0;
     ii := 0;
     while(cont < MAXIT) do
     begin
          xn := X0;
          resul := TJacobiana.create(Variables,FX,X0,numv);
          aux := resul.Evaluate();
          for i:=0 to numv-1 do
              for j:=0 to numv-1 do
              begin
                   miparse[i,0].NewValue(Variables[j,0],X0[j,0]);
              end;

          for i:=0 to numv-1 do
          begin
               temp[i,0]:= miparse[i,0].Evaluate();
          end;
          JInver := operacion.Invierte(numv,aux,BB);
          x := operacion.Resta(X0,operacion.Multiplicacion(JInver,temp,numv,numv,numv,numv),numv,numv);

          for i:=0 to numv-1 do
          begin
              e := e + power(x[i,0]-xn[i,0],2);
          end;

          veri := sqrt(e);

          for i:=0 to numv-1 do
          begin
                M[ii,i]:= FloatToStr(x[i,0]);
          end;
          M[ii,numv] := FloatToStr(veri);
          ii := ii+1;

          if(Abs(veri)<EX) then
          begin
               Result := M;
               exit();
          end;
          Rows:=Rows+1;
          X0 := x;
          cont := cont+1;
          e := 0;
     end;
     Result := M;
end;




function TMetodoAbiertosG.derivadaParcial(fun:TParseMath;x:string;valor:real): real;
var
  h,a,b,v:real;
  funaux:TParseMath;
begin
  h:=0.00001;
  v:=valor;
  funaux:=fun;
  funaux.NewValue(x,v-h);
  b:=funaux.Evaluate();
  funaux.NewValue(x,v+h);
  a:=funaux.Evaluate();
  derivadaParcial:=(a-b)/h;
end;


end.



