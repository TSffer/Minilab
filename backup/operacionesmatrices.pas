unit operacionesMatrices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,operadores;

type

  TMatriz = class
      public

      function CMtr(x,y:Integer): matriz;
      procedure Operar();
      procedure MostrarMatriz(M: matriz;x,y:Integer);
      function Suma(A,B : matriz; m,n:Integer) : matriz;
      function Resta(A,B: matriz; m,n:Integer) : matriz;
      function Multiplicacion(A,B:Matriz;m,n,c,d:Integer): matriz;
      function Division(A,B:Matriz;m,n,c,d:Integer): matriz;
      function Invierte(Dim: Integer;Sist,Inv:matriz) : matriz;
      procedure MetodoGauss();

      function Potencia(A,B:Matriz;m,n,e:Integer): matriz;
      function MulEsc(A:matriz;esc:real;m,n:Integer): matriz;
      function Transpuesta(var A: matriz;m,n:Integer): matriz;
      function Traza(A: matriz;n,m:Integer): real;
      function Determinante(A:matriz;filas:Integer):real;

      constructor create(); overload;
      destructor Destroy();

    private

  end;


implementation

constructor TMatriz.create();
begin
end;

destructor TMatriz.Destroy();
begin
end;


procedure TMatriz.Operar();
var
    A,B,C,D : Matriz;
    x , y ,xx,yy, op: Integer;
begin
    write('[1] Suma '+LineEnding
         +'[2] Resta'+LineEnding
         +'[3] Multipicacion'+LineEnding
         +'[4] Determinante'+LineEnding
         +'[5] Inversa'+LineEnding
         +'[6] Division'+LineEnding
         +'[7] Metodo Gauss'+LineEnding
         +'[8] Multiplicacion escalar'+LineEnding
         +'[9] Transpuesta'+LineEnding
         +'[10] Traza'+LineEnding);
    readLn(op);
    if op = 1 then
       begin
          write('Ingrese el tamanio de filas MATRIZ A: ');
          readLn(x);
          write('Ingrese el tamanio de colunmas MATRIZ A: ');
          readLn(y);
          write('Ingrese el tamanio de filas MATRIZ B: ');
          readLn(xx);
          write('Ingrese el tamanio de colunmas MATRIZ B: ');
          readLn(yy);
          if (x = xx) and (y = yy) then
          begin
            writeLn('MATRIZ A: ');
            A := CMtr(x,y);
            writeLn('MATRIZ B: ');
            B := CMtr(xx,yy);
            C:= Suma(A,B,x,y);
            MostrarMatriz(C,x,y);
          end
          else
              begin
                  writeLn('Las Dimensiones de las matrices no son iguales !!!');
              end;
       end
    else if op = 2 then
       begin
          write('Ingrese el tamanio de filas MATRIZ A: ');
          readLn(x);
          write('Ingrese el tamanio de colunmas MATRIZ A: ');
          readLn(y);
          write('Ingrese el tamanio de filas MATRIZ B: ');
          readLn(xx);
          write('Ingrese el tamanio de colunmas MATRIZ B: ');
          readLn(yy);
          if (x = xx) and (y = yy) then
             begin
                writeLn('MATRIZ A: ');
                A := CMtr(x,y);
                writeLn('MATRIZ B: ');
                B := CMtr(x,y);
                C:= Resta(A,B,x,y);
                MostrarMatriz(C,x,y);
             end
          else
              begin
                  writeLn('Las Dimensiones de las matrices no son iguales !!!');
              end;
       end

       else if op = 3 then
       begin
          write('Ingrese el tamanio de filas MATRIZ A: ');
          readLn(x);
          write('Ingrese el tamanio de colunmas MATRIZ A: ');
          readLn(y);
          write('Ingrese el tamanio de filas MATRIZ B: ');
          readLn(xx);
          write('Ingrese el tamanio de colunmas MATRIZ B: ');
          readLn(yy);
         if (y = xx) then
           begin
            writeLn('MATRIZ A: ');
            A := CMtr(x,y);
            writeLn('MATRIZ B: ');
            B := CMtr(xx,yy);
            C := Multiplicacion(A,B,x,y,xx,yy);
            MostrarMatriz(C,x,yy);
           end
         else
       begin
          writeLn('Estas matrices no se pueden multiplicar' );
          writeLn('Matriz A tiene colunmas diferentes al numero de filas de B' );
       end;
    end

    else if op = 4 then
       begin
            write('Ingrese el tamanio de filas MATRIZ A: ');
            read(x);
            write('Ingrese el tamanio de colunmas MATRIZ A: ');
            read(y);
            if( x = y) then
               begin
                    A := CMtr(x,y);
                    writeLn(FloatToStr(Determinante(A,x)));
                    readLn();
               end
            else write('La matriz no es cuadrada !!!');
        end

    else if op = 5 then
       begin
            write('Ingrese el tamanio de filas MATRIZ A: ');
            read(x);
            write('Ingrese el tamanio de colunmas MATRIZ A: ');
            read(y);
            if (x = y) then
               begin
                 A := CMtr(x,y);
                 MostrarMatriz(Invierte(x,A,B),x,y);
               end
            else writeLn('La matriz A no es cuadrada !!!');
       end
    else if op = 6 then
       begin
             write('Ingrese el tamanio de filas MATRIZ A: ');
             readLn(x);
             write('Ingrese el tamanio de colunmas MATRIZ A: ');
             readLn(y);
             write('Ingrese el tamanio de filas MATRIZ B: ');
             readLn(xx);
             write('Ingrese el tamanio de colunmas MATRIZ B: ');
             readLn(yy);
            if (y = xx) and (xx = yy) then
              begin
               writeLn('MATRIZ A: ');
               A := CMtr(x,y);
               writeLn('MATRIZ B: ');
               B := CMtr(xx,yy);
                    if(determinante(B,xx)<>0)then
                    begin
                    C := Multiplicacion(A,Invierte(x,B,D),x,y,xx,yy);
                    MostrarMatriz(C,x,yy);
                    end
                    else writeLn('La Determinante es 0 La matriz A no tiene Inversa !!!');
              end
            else
          begin
             writeLn('Estas matrices no se pueden Dividir' );
             writeLn('La matriz  B no es cuadrada o las dimensiones de A y B son Incorrectas !!! ' );
          end;
        end
    else if op = 7 then
       begin
            MetodoGauss();
       end
    else if op = 8 then
       begin
             write('Ingrese el tamanio de filas MATRIZ A: ');
             readLn(x);
             write('Ingrese el tamanio de colunmas MATRIZ A: ');
             readLn(y);
             A := CMtr(x,y);
             write('Ingrese el munero: ');
             readLn(xx);
             B := MulEsc(A,xx,x,y);
             MostrarMatriz(B,x,y);
       end
    else if op = 9 then
       begin
            write('Ingrese el tamanio de filas MATRIZ A: ');
            readLn(x);
            write('Ingrese el tamanio de colunmas MATRIZ A: ');
            readLn(y);
            A := CMtr(x,y);
            B := Transpuesta(A,x,y);
            MostrarMatriz(B,x,y);
       end
    else if op = 10 then
       begin
            write('Ingrese el tamanio de filas MATRIZ A: ');
            readLn(x);
            write('Ingrese el tamanio de colunmas MATRIZ A: ');
            readLn(y);
            if(x = y) then
               begin
                  A := CMtr(x,y);
                  writeLn('La Traza es: '+FloatToStr(Traza(A,x,y)));
               end
            else writeLn('No se puede hallar la traza si no es cuadrada !!!');
       end;
end;


procedure TMatriz.MostrarMatriz(M:matriz;x,y:Integer);
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

function TMatriz.CMtr(x,y:Integer): matriz;
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


function TMatriz.Suma(A,B : matriz; m,n:Integer) : matriz;
var
    i : Integer;
    j : Integer;
    C : matriz;
begin
     for i:=0 to m-1 do
         begin
           for j:=0  to n-1 do
               begin
                    C[i,j] := A[i,j]+B[i,j];
               end;
         end;
     Result := C;
end;

function TMatriz.Resta(A,B: matriz; m,n:Integer) : matriz;
var
    i : Integer;
    j : Integer;
    C : matriz;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to n-1 do
               begin
                 C[i,j] := A[i,j]-B[i,j];
               end;
         end;
     Result := C;
end;

function TMatriz.Multiplicacion(A,B:Matriz;m,n,c,d:Integer): matriz;
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
                 CC[i,j] :=0;
                 for k:=0 to n-1 do
                     begin
                       CC[i,j] := CC[i,j]+(A[i,k]*B[k,j]);
                     end;
               end;
         end;
     Result := CC;
end;

function TMatriz.Potencia(A,B:Matriz;m,n,e:Integer):  matriz;
var
 i:Integer;
 CC:matriz;
begin
    CC:=A;
    for i:=0 to e-1 do
    begin
        CC:=Multiplicacion(A,CC,m,n,m,n);
    end;
    Result:=CC;
end;

function TMatriz.MulEsc(A:matriz;esc:real;m,n:Integer): matriz;
var
    i : Integer;
    j : Integer;
    C : matriz;
begin
     for i:=0 to m-1 do
         begin
           for j:=0 to n-1 do
               begin
                 C[i,j] := A[i,j]*esc;
               end;
         end;
     Result := C;
end;

function TMatriz.Transpuesta(var A: matriz;m,n:Integer): matriz;
var
    i : Integer;
    j : Integer;
    i1 : Integer;
    j1 : Integer;
    C : matriz;
begin
     j1 := 0;
     for i:=0 to m-1 do
         begin
           i1 := 0;
           for j:=0 to n-1 do
               begin
                 C[j1,i1] := A[j,i];
                 i1 := i1 + 1;
               end;
               j1 := j1+1;
         end;
     Result := C;
end;

function TMatriz.Traza(A: matriz;n,m:Integer): real;
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

function TMatriz.Determinante(A:matriz;filas:Integer):real;
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

procedure TMatriz.MetodoGauss();
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

function TMatriz.Invierte(Dim: Integer;Sist,Inv:matriz) : matriz;
var
    NoCero,Col,C1,C2,A : Integer;
    Pivote,V1,V2 : real;
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


function TMatriz.Division(A,B:Matriz;m,n,c,d:Integer): matriz;
var
    res,Inv : matriz;

begin
    SetLength(res,m,d);
    SetLength(Inv,c,d);
    if(Determinante(B,c) <> 0 ) then
    begin
        Inv := Invierte(c,B,Inv);
        res := Multiplicacion(A,Inv,m,n,c,d);
        result := res;
    end
    else writeLn('La Determinante es 0 , no se puede dividir!!!');

end;

end.
