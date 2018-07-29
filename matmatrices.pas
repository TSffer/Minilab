unit matmatrices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, operadores;

type
  TMatriz1 = class
      public
      matrizA:matriz;
      matrizB:matriz;
      matrizC:cadena;
      valor:real;

      function CMtr(x,y:Integer): matriz;
      procedure MostrarMatriz(M: matriz;x,y:Integer);
      function Suma(A,B : matriz; m,n:Integer):cadena;
      function Resta(A,B: matriz; m,n:Integer) : cadena;
      function Multiplicacion(A,B:Matriz;m,n,c,d:Integer): cadena;
      function Division(A,B:Matriz;m,n,c,d:Integer): cadena;
      function Invierte(Dim: Integer;Sist,Inv:matriz) : cadena;
      procedure MetodoGauss();
      function Potencia(A,B:Matriz;m,n,e:Integer): cadena;
      function MulEsc(A:matriz;esc:real;m,n:Integer): cadena;
      function Transpuesta(var A: matriz;m,n:Integer): cadena;
      function Traza(A: matriz;n,m:Integer): real;
      function Determinante(A:matriz;filas:Integer):real;
      function Execute(opcion:string;m:Integer;n:Integer;c,d:Integer;var Text:string;var Rows:Integer;var Cols:Integer;variable:real):cadena;
      function Invierte2(Dim: Integer;Sist,Inv:matriz) : matriz;
      function Multiplicacion2(A,B:Matriz;m,n,c,d:Integer): matriz;

      constructor create(); overload;
      destructor Destroy();

    private

  end;

operator *(a,b:matriz):matriz;
operator +(a,b:matriz):matriz;
operator -(a,b:matriz):matriz;
operator /(a,b:matriz):matriz;

implementation

constructor TMatriz1.create();
begin
end;

destructor TMatriz1.Destroy();
begin
end;

function TMatriz1.Execute(opcion:string;m :Integer;n:Integer;c,d:Integer;var Text:string;var Rows:Integer;var Cols:Integer;variable:real):cadena;
var
    R:cadena;
    val:string;
    valI:Integer;
begin
   opcion:=LowerCase(opcion);
   Text:='';
   val:='';
   valI:=0;
   case opcion of
        'sumar': begin
                      if((m=c) and (n=d)) then
                         begin Rows:=m;Cols:=d;Execute:=Suma(matrizA,matrizB,m,n); end
                      else
                         begin Rows:=0;Cols:=0;Text:='No se puede sumar las dimenciones son diferentes !';Execute:=R; end;
                 end;

        'restar': begin
                      if((m=c) and (n=d)) then
                         begin Rows:=m;Cols:=d;Execute:=Resta(matrizA,MatrizB,m,n); end
                      else
                         begin Rows:=0;Cols:=0;Text:='No de puede restar las dimenciones son diferentes !';Execute:=R; end;
                  end;
        'multiplicar': begin
                           if(n=c) then
                             begin Rows:=m;Cols:=d; Execute:=Multiplicacion(matrizA,matrizB,m,n,c,d);end
                           else
                               begin Rows:=0;Cols:=0;Text:='No se puede multiplicar, dimenciones no validas !';Execute:=R; end;
                       end;
        'dividir':begin
                     if((n=c) and (d=c)) then
                       begin
                           Rows:=m;Cols:=d;
                           Execute:=Division(matrizA,matrizB,m,n,c,d);
                       end
                     else
                         begin Rows:=0;Cols:=0;Text:='No se pudo dividir, dimenciones no validad !'; Execute:=R;end;
                  end;
        'power':begin
                     if(m=n) then
                       begin
                          val:=FloatToStr(variable);
                          valI:=StrToInt(val);
                          if(valI=-2) then
                            begin Rows:=m;Cols:=n;Execute:=Invierte(m,matrizA,matrizB); end
                          else
                             begin Rows:=m;Cols:=n;Execute:=Potencia(matrizA,matrizB,m,n,valI);end;
                       end
                     else
                     begin Rows:=0;Cols:=0;Text:='Expreción no valida !';Execute:=R;end;
                end;
        'transpuesta':begin
                       if(m=n) then
                          begin Rows:=m;Cols:=n;Execute:=Transpuesta(matrizA,m,n); end
                       else
                           begin Rows:=0;Cols:=0;Text:='No se pudo transponer, la matriz no es cuadrada !'; Execute:=R;end;
                     end;
        'inversa':begin
                       if(m=n) then
                          begin  Rows:=m;Cols:=n;Execute:=Invierte(m,matrizA,matrizB); end
                       else
                          begin Rows:=0;Cols:=0;Text:='No se pudo invertir, la matriz no es cuadrada !'; Execute:=R;end;
                  end;
        'mulesc':begin
                     Execute:=MulEsc(matrizA,variable+1,m,n);
                     Rows:=m;Cols:=n;
                 end;
        'traza':begin
                     if(m=n) then
                        begin  Rows:=0;Cols:=0;Text:= FloatToStr(Traza(matrizA,n,m));Execute:=R; end
                     else
                         begin Rows:=0;Cols:=0;Text:='La matriz no es cuadrada !'; Execute:=R;end;
                end;
        'determinante':begin
                     if(m=n) then
                        begin  Rows:=0;Cols:=0;Text:= FloatToStr(Determinante(matrizA,m));Execute:=R; end
                     else
                         begin Rows:=0;Cols:=0;Text:='La matriz no es cuadrada !'; Execute:=R;end;
                end;

        else begin Execute:=matrizC;end;
   end;
end;

procedure TMatriz1.MostrarMatriz(M:matriz;x,y:Integer);
var
    i: Integer;
    j: Integer;
begin
    for i:= 0 to x-1 do
        begin
            for j := 0 to y-1 do
                begin
                   write(FloatToStr(M[i,j])+'   ');
                end;
        writeLn();
        end;
end;

function TMatriz1.CMtr(x,y:Integer): matriz;
var
    i: Integer;
    j: Integer;
    mdata : real;
    M: matriz;
begin
    for i:= 0 to x-1 do
        begin
        for j:=0 to y-1 do
            begin
                 write('Ingrese los datos ');
                 read(mdata);
                 M[i,j] := mdata;
            end;
        end;
    Result := M;
end;


function TMatriz1.Suma(A,B : matriz; m,n:Integer):cadena;
var
    i : Integer;
    j : Integer;
    C : cadena;
begin
     for i:=0 to m-1 do
         begin
           for j:=0  to n-1 do
               begin
                    C[i,j] := FloatToStr(A[i,j]+B[i,j]);
               end;
         end;
     Result := C;
end;

function TMatriz1.Resta(A,B: matriz; m,n:Integer) : cadena;
var
    i : Integer;
    j : Integer;
    C : cadena;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to n-1 do
               begin
                 C[i,j] := FloatToStr(A[i,j]-B[i,j]);
               end;
         end;
     Result := C;
end;

function TMatriz1.Multiplicacion(A,B:Matriz;m,n,c,d:Integer): cadena;
var
    i : Integer;
    j : Integer;
    k : Integer;
    CC : cadena;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to c-1 do
               begin
                 CC[i,j] :=FloatToStr(0);
                 for k:=0 to n-1 do
                     begin
                       CC[i,j] := FloatToStr(StrToFloat(CC[i,j])+(A[i,k]*B[k,j]));
                     end;
               end;
         end;
     Result := CC;
end;

function TMatriz1.Multiplicacion2(A,B:Matriz;m,n,c,d:Integer): matriz;
var
    i : Integer;
    j : Integer;
    k : Integer;
    CC : matriz;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to c-1 do
               begin
                 CC[i,j] :=(0);
                 for k:=0 to n-1 do
                     begin
                       CC[i,j] :=((CC[i,j])+(A[i,k]*B[k,j]));
                     end;
               end;
         end;
     Result := CC;
end;

function TMatriz1.Potencia(A,B:Matriz;m,n,e:Integer): cadena;
var
 i,j:Integer;
 CC:matriz;
 C:cadena;
begin
    CC:=A;
    for i:=0 to e-1 do
    begin
        CC:=Multiplicacion2(A,CC,m,n,m,n);
    end;
    for i:=0 to m-1 do
    begin
      for j:=0 to n-1 do
      begin
        C[i,j]:=FloatToStr(CC[i,j]);
      end;
    end;
    Result:=C;
end;

function TMatriz1.MulEsc(A:matriz;esc:real;m,n:Integer): cadena;
var
    i : Integer;
    j : Integer;
    C : cadena;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to n-1 do
               begin
                 C[i,j] := FloatToStr(A[i,j]*esc);
               end;
         end;
     Result := C;
end;

function TMatriz1.Transpuesta(var A: matriz;m,n:Integer): cadena;
var
    i : Integer;
    j : Integer;
    i1 : Integer;
    j1 : Integer;
    C : cadena;
begin

     j1 := 0;
     for i:=0 to m-1 do
         begin
           i1 := 0;
           for j:=0 to n-1 do
               begin
                 C[j1,i1] := FloatToStr(A[j,i]);
                 i1 := i1 + 1;
               end;
               j1 := j1+1;
         end;
     Result := C;
end;

function TMatriz1.Traza(A: matriz;n,m:Integer): real;
var
    i : Integer;
    C : real;
begin
     C := 0;
     for i:=0 to m-1 do
         begin
           C:=A[i,i]+C;
         end;
     Traza := C;
end;

function TMatriz1.Determinante(A:matriz;filas:Integer):real;
var
    i : Integer;
    j : Integer;
    n : Integer;
    det : real;
    B : matriz;
begin

     if filas  = 2 then
        det := A[0,0] * A[1,1] - A[0,1]*A[1,0]
     else
       begin
         det := 0;
         for n:= 0 to filas-1 do
             begin
               for i:=1 to filas-1 do
                   begin
                     for j := 0 to n-1 do
                         B[i-1,j] := A[i,j];
                     for j:=n+1 to filas-1 do
                         B[i-1,j-1] := A[i,j];
                   end;
                   if(n+2) mod 2 = 0 then i:= 1
                           else i := -1;
                   det := det + i*A[0,n]*Determinante(B,filas-1);
             end;
       end;
     Result := det;
end;

procedure TMatriz1.MetodoGauss();
var
    M : matriz;
    aux : real;
    i,j,k,n : Integer;
begin
     writeLn('  <<<Metodo de Gauss>>>        ');
     write('   Matriz cuadrada de orden N= ');
     read(n);
     writeLn('   Digite los elementos de la matriz en la posicion ');
     for i := 1 to n do
         begin
           for j := 1 to n do
               begin
                 write('  M=['+IntToStr(i)+','+IntToStr(j)+']= ');
                 read(M[i,j]);
               end;
           write(' Termino idependiente de X'+IntToStr(i)+' ');
           read(M[i,n+1]);
         end;
     for i := 1 to n do
         begin
           if(M[i,i] <> 0) then
           begin
              aux := 1/M[i,i];
              for j := 1 to n+1 do
                  begin
                    M[i,j] := aux*M[i,j];
                  end;
              for j := 1 to n do
                  begin
                    if (j <> i) then
                       begin
                            aux := -M[j,i];
                            for k := 1 to n+1 do
                            begin
                                 M[j,k] := M[j,k] + aux*M[i,k];
                            end;
                       end;
                  end;
           end;
         end;
         writeLn();
         writeLn('La matriz identidad es');
         writeLn();
         for i := 1 to n do
         begin
           for j := 1 to n do
               begin
                 write(FloatToStr(M[i,j])+'    ');
               end;
           writeLn();
         end;
         writeLn('El valor de las incognitas es : ');
         for i := 1 to n do
         begin
           writeLn('\X'+IntToStr(i)+' = '+ FloatToStr(M[i,n+1])+LineEnding);
         end;
         read();
end;

function TMatriz1.Invierte(Dim: Integer;Sist,Inv:matriz) : cadena;
var
    NoCero,Col,C1,C2,A,i,j : Integer;
    Pivote,V1,V2 : real;
    R:cadena;
begin

    if ( Determinante(Sist,Dim) <> 0) then
     begin

     for C1 := 0 to Dim-1 do
         for C2 := 0 to Dim-1 do
         begin
           if (C1 = C2) then
           begin
                Inv[C1,C2] := 1;
           end
           else Inv[C1,C2] := 0;
         end;

     for Col :=0 to Dim-1 do
     begin
       NoCero :=0;
       A := Col;
       while (NoCero = 0) do
       begin
            if ((Sist[A,Col]>0.0000001) or ((Sist[A,Col]<-0.0000001))) then
            begin
                 NoCero := 1;
            end
            else A := A+1;
       end;
       Pivote := Sist[A,Col];
       for C1 := 0 to Dim-1 do
           begin
               V1 := Sist[A,C1];
               Sist[A,C1] := Sist[Col,C1];
               Sist[Col,C1] := V1/Pivote;
               V2 := Inv[A,C1];
               Inv[A,C1] := Inv[Col,C1];
               Inv[Col,C1] := V2/Pivote;
           end;
       for C2 := Col+1 to Dim-1 do
           begin
             V1 := Sist[C2,Col];
             for C1 := 0 to Dim-1 do
             begin
                Sist[C2,C1] := Sist[C2,C1] - V1*Sist[Col,C1];
                Inv[C2,C1] := Inv[C2,C1]-V1*Inv[Col,C1];
             end;
           end;
     end;
     for Col := Dim-1 downto 0 do
         for C1 := (Col-1) downto 0 do
         begin
           V1 := Sist[C1,Col];
           for C2 := 0 to Dim-1 do
           begin
             Sist[C1,C2] := Sist[C1,C2] - V1*Sist[Col,C2];
             Inv[C1,C2] := Inv[C1,C2] - V1*Inv[Col,C2];
           end;
         end;

         for i:=0 to Dim-1 do
             for j:=0 to Dim-1 do
             begin
               R[i,j]:=FloatToStr(Inv[i,j]);
             end;
         Result := R;
     end
     else
         begin
         ShowMessage('La Determinante es 0 , no tiene Inversa !!!');
         Result := R;
         exit();
         end;
end;

function TMatriz1.Invierte2(Dim: Integer;Sist,Inv:matriz) : matriz;
var
    NoCero,Col,C1,C2,A,i,j : Integer;
    Pivote,V1,V2 : real;
    R:cadena;
begin

    if ( Determinante(Sist,Dim) <> 0) then
     begin

     for C1 := 0 to Dim-1 do
         for C2 := 0 to Dim-1 do
         begin
           if (C1 = C2) then
           begin
                Inv[C1,C2] := 1;
           end
           else Inv[C1,C2] := 0;
         end;

     for Col :=0 to Dim-1 do
     begin
       NoCero :=0;
       A := Col;
       while (NoCero = 0) do
       begin
            if ((Sist[A,Col]>0.0000001) or ((Sist[A,Col]<-0.0000001))) then
            begin
                 NoCero := 1;
            end
            else A := A+1;
       end;
       Pivote := Sist[A,Col];
       for C1 := 0 to Dim-1 do
           begin
               V1 := Sist[A,C1];
               Sist[A,C1] := Sist[Col,C1];
               Sist[Col,C1] := V1/Pivote;
               V2 := Inv[A,C1];
               Inv[A,C1] := Inv[Col,C1];
               Inv[Col,C1] := V2/Pivote;
           end;
       for C2 := Col+1 to Dim-1 do
           begin
             V1 := Sist[C2,Col];
             for C1 := 0 to Dim-1 do
             begin
                Sist[C2,C1] := Sist[C2,C1] - V1*Sist[Col,C1];
                Inv[C2,C1] := Inv[C2,C1]-V1*Inv[Col,C1];
             end;
           end;
     end;
     for Col := Dim-1 downto 0 do
         for C1 := (Col-1) downto 0 do
         begin
           V1 := Sist[C1,Col];
           for C2 := 0 to Dim-1 do
           begin
             Sist[C1,C2] := Sist[C1,C2] - V1*Sist[Col,C2];
             Inv[C1,C2] := Inv[C1,C2] - V1*Inv[Col,C2];
           end;
         end;

         Result := Inv;
     end
     else
         begin
         ShowMessage('La Determinante es 0 , no tiene Inversa !!!');
         Result := Sist;
         exit();
         end;
end;

function TMatriz1.Division(A,B:Matriz;m,n,c,d:Integer): cadena;
var
    res : cadena;
    Inv:matriz;
begin
    if(Determinante(B,c) <> 0 ) then
    begin
        Inv := Invierte2(c,B,Inv);
        res := Multiplicacion(A,Inv,m,n,c,d);
        result := res;
    end
    else ShowMessage('La Determinante es 0 , no se puede dividir!!!');

end;

operator *(a,b:matriz):matriz;
begin
end;


operator +(a,b:matriz):matriz;
begin
end;


operator -(a,b:matriz):matriz;
begin
end;

operator /(a,b:matriz):matriz;
begin
end;


end.

