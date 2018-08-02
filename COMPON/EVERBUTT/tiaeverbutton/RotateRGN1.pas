unit RotateRGN1;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,Math;

type
Tpoints = array of Tpoint;
Tintegers = array of integer;
TRgnpoints = record
             points : Tpoints;
             types : Tintegers;
             end;

function RotateRegion(var Rgn : Hrgn;X,Y,Angle : integer): integer;
function  ReCreateRgn(var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers): HRGN;
procedure PolyRotate(var points : Tpoints;x,y,Angle : integer);
  procedure PolyZrotate(var points : Tpoints;Angle : integer);
procedure RgnToPoly(var Rgn : HRGN;var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers);
procedure Getinner(var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers;Dd : integer;Outer,Inner :Boolean);

function GetPPCopy(var PPoly : Tpoints): Tpoints;
procedure GetLDppoly(var MainPpoly,InnerPPoly : Tpoints;var mainvertex,Maininpower: Tintegers; var Lppoly,DPpoly
                      : Tpoints;var Lvertex,Dvertex : Tintegers; var Ln,Dn : integer);

  function DivideToRegions(var Rgns : TrgnPoints): TrgnPoints;

    function FindFpoint(var points : Tintegers): integer;
    function FindNextPoint(var Rgns : TRgnpoints;var Points : Tintegers; LastType,AtLType,x,y,Fx,Fy,Nf,Nn : integer;
                           var Moving : integer): integer;
  function getRvertex(var Rgns : Trgnpoints): Tintegers;
  procedure  SimplifyPolys(var Rgns: Trgnpoints;var Rvertex : Tintegers);
  function GetInPower(var Rgns: Trgnpoints;var Rvertex: Tintegers): Tintegers;
    function PinPoly(var points : Tpoints;point: Tpoint): boolean;
    function PrealinPoly(var points : Tpoints;x1,y1 : extended): boolean;

  //Здесь начинаются новые функции....
  function DetectPointsTypes(var points : Tpoints;var types : Tintegers): Tpoints;

  procedure RemovePointsPP(var Polypoly : Tpoints;var Vertex,Powers : Tintegers;D : integer);

  function NextP(N,Count : integer): integer;
  function PredP(N,Count : integer): integer;
implementation

uses
  Variants;

procedure RgnToPoly(var Rgn : HRGN;var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers);
var
  RgnSize,Nrects,i : Integer;
  RgnData1 : PRGNDATA;
  PointsRect,IntPoints : Tpoints;
  RgnPoints,Rgns : Trgnpoints;
  Types,RVertex,Rinpower : Tintegers;

begin
  RgnSize:=GetRegionData(Rgn,0,Nil);
  GetMem(RgnData1,RgnSize+sizeof(RgnData1^));
  GetRegionData(Rgn,RgnSize,RgnData1);
  Nrects:=(RgnSize-32) div 16;
  if Nrects=0 then exit;
  SetLength(PointsRect,Nrects*4);
  for i:=0 to Nrects*2-1 do
    begin
      PointsRect[i*2].x:=pinteger(integer(RgnData1)+32+i*8)^;
      PointsRect[i*2].y:=pinteger(integer(RgnData1)+32+i*8+4)^;
    end;
  FreeMem(RgnData1,RgnSize+sizeof(RgnData1^));
  for i:=0 to Nrects-1 do
    begin
      PointsRect[i*4+1].x:=PointsRect[i*4+2].x;
      PointsRect[i*4+1].y:=PointsRect[i*4].y;
      PointsRect[i*4+3].x:=PointsRect[i*4].x;
      PointsRect[i*4+3].y:=PointsRect[i*4+2].y;
    end;



   //Заданы координаты углов прямоугольников...

  IntPoints:=DetectPointsTypes(PointsRect,Types);
  SetLength(RgnPoints.Points,1+high(IntPoints));
  SetLength(RgnPoints.Types,1+high(Types));
  For i:=0 to  high(IntPoints) do
    begin
      RgnPoints.points[i].x:=IntPoints[i].x;
      RgnPoints.points[i].y:=IntPoints[i].y;
      RgnPoints.types[i]:=Types[i];
    end;

  Rgns:=DivideToRegions(RgnPoints);
  Rvertex:=getRvertex(Rgns);

  //Сколько составляющих в каждом полиноме...
  SimplifyPolys(Rgns,Rvertex);
  //Упростили полиномы...
  Rinpower:=GetInPower(Rgns,Rvertex);
  SetLength(PolyPoly,1+High(Rgns.points));
  Setlength(Polyvertex,1+High(Rvertex));
  Setlength(Polyinpower,1+High(Rinpower));
  for i:=0 to High(Rgns.points) do
    begin
      Polypoly[i].x:=Rgns.points[i].x;
      Polypoly[i].y:=Rgns.points[i].y;
    end;
  for i:=0 to High(Rvertex) do
    PolyVertex[i]:=Rvertex[i];
  for i:=0 to High(Rinpower) do
    Polyinpower[i]:=Rinpower[i];
end;



function DivideToRegions(var Rgns : TrgnPoints): TrgnPoints;
var
  points : Tintegers;
  Fpoint,Nrgn,Npoint,Lasttype,Nextpoint,X,Y,AtLtype,Moving,Fx,Fy,Nf,Nn : integer;
begin
  //Здесь мы делим на регионы....
  Setlength(Result.points,1+High(Rgns.points));
  Setlength(Result.types,1+High(Rgns.points));
  //Подготовлен буфер под результаты...
  Setlength(points,1+High(Rgns.points));
  Nrgn:=1;Npoint:=0;
  repeat          //Повторять пока есть свободные точки...
    Fpoint:=findFpoint(points);
    if Fpoint<>-1 then
      begin
        Nf:=Fpoint;  Nn:=nf;
        points[Fpoint]:=Nrgn;
        Result.points[Npoint].x:=Rgns.points[Fpoint].x;
        Result.points[Npoint].y:=Rgns.points[Fpoint].y;
        Result.types[Npoint]:=Nrgn;
        LastType:=Rgns.types[Fpoint];
        AtLtype:=LastType;
        Moving:=0;
        X:=Result.points[Npoint].x;
        y:=Result.points[Npoint].y;
        Fx:=x;Fy:=y;
        inc(Npoint);
        repeat
          NextPoint:=FindNextPoint(Rgns,Points,LastType,AtLType,x,y,Fx,Fy,Nf,Nn,Moving);
          if NextPoint<>-1 then
            begin
              nn:=Nextpoint;
              points[Nextpoint]:=Nrgn;
              Result.points[Npoint].x:=Rgns.points[Nextpoint].x;
              Result.points[Npoint].y:=Rgns.points[Nextpoint].y;
              Result.types[Npoint]:=Nrgn;
              AtLtype:=LastType;
              LastType:=Rgns.types[Nextpoint];
              X:=Result.points[Npoint].x;
              y:=Result.points[Npoint].y;
              inc(Npoint);
            end;
        until NextPoint=-1;
        inc(Nrgn);
      end;
  until Fpoint=-1;
end;
function FindFpoint(var points : Tintegers): integer;
var
  i : integer;
begin
  result:=-1; i:=0;
  repeat
    if (points[i]=0) then result:=i else inc(i);
  until (result<>-1) or (i>High(points));
end;
function FindNextPoint(var Rgns : TRgnpoints;var Points : Tintegers; LastType,AtLType,x,y,Fx,Fy,Nf,Nn : integer;
                           var Moving : integer): integer;
var
  N1,N2,i : integer;
  OnX,NoPoint,OnPlus : Boolean;
begin
  Result:=-1;N1:=0;N2:=0;OnX:=false;Onplus:=false;
  if AtLtype*LastType<0 then Moving:=1-Moving;
  if Moving=0 then
  begin
  if LastType=1
  then begin
    N1:=2;
    N2:=-3;
    OnX:=true;
    Onplus:=true;
  end;
  if LastType=2
  then begin
    N1:=3;
    N2:=-4;
    OnX:=false;
    Onplus:=true;
  end;
  if LastType=3
  then begin
    N1:=4;
    N2:=-1;
    OnX:=true;
    Onplus:=false;
  end;
  if LastType=4
  then begin
    N1:=1;
    N2:=-2;
    OnX:=false;
    Onplus:=false;
  end;
  if LastType=-1
  then begin
    N1:=3;
    N2:=-2;
    OnX:=true;
    Onplus:=true;
  end;
  if LastType=-2
  then begin
    N1:=4;
    N2:=-3;
    OnX:=false;
    Onplus:=true;
  end;
  if LastType=-3
  then begin
    N1:=1;
    N2:=-4;
    OnX:=true;
    Onplus:=false;
  end;
  if LastType=-4
  then begin
    N1:=2;
    N2:=-1;
    OnX:=false;
    Onplus:=false;
  end;
  end else
  begin
  if LastType=1
  then begin
    N1:=4;
    N2:=-3;
    OnX:=false;
    Onplus:=true;
  end;
  if LastType=2
  then begin
    N1:=1;
    N2:=-4;
    OnX:=true;
    Onplus:=false;
  end;
  if LastType=3
  then begin
    N1:=2;
    N2:=-1;
    OnX:=false;
    Onplus:=false;
  end;
  if LastType=4
  then begin
    N1:=3;
    N2:=-2;
    OnX:=true;
    Onplus:=true;
  end;
  if LastType=-1
  then begin
    N1:=3;
    N2:=-4;
    OnX:=false;
    Onplus:=true;
  end;
  if LastType=-2
  then begin
    N1:=4;
    N2:=-1;
    OnX:=true;
    Onplus:=false;
  end;
  if LastType=-3
  then begin
    N1:=1;
    N2:=-2;
    OnX:=false;
    Onplus:=false;
  end;
  if LastType=-4
  then begin
    N1:=2;
    N2:=-3;
    OnX:=true;
    Onplus:=true;
  end;
  end;
  Nopoint:=true;
  //===============================================
  //we must found next point of defined upper style at defined there also position...
     for i:=Nf to high(Rgns.points) do
       begin
         if ((i<>Nn) and (points[i]=0)) or (i=Nf) then
           begin // if the point is avaible...
             if (Rgns.types[i]=N1) or (Rgns.types[i]=N2) then
               begin //if the point is required style by angle...
                 if onX then
                   begin
                     if Onplus then
                       begin
                         if (y=Rgns.points[i].y) and (x<=Rgns.points[i].x) then // that is point by wind...
                           begin
                             if Nopoint or (Rgns.points[Result].x>Rgns.points[i].x) then
                               begin
                                 Result:=i;Nopoint:=False;
                               end;
                           end;
                       end else //Onplus
                       begin
                         if (y=Rgns.points[i].y) and (x>=Rgns.points[i].x) then // that is point by wind...
                           begin
                             if Nopoint or (Rgns.points[Result].x<Rgns.points[i].x) then
                               begin
                                 Result:=i;Nopoint:=False;
                               end;
                           end;
                       end;
                   end else //onX
                   begin
                     if Onplus then
                       begin
                         if (x=Rgns.points[i].x) and (y<=Rgns.points[i].y) then // that is point by wind...
                           begin
                             if Nopoint or (Rgns.points[Result].y>Rgns.points[i].y) then
                               begin
                                 Result:=i;Nopoint:=False;
                               end;
                           end;
                       end else //Onplus
                       begin
                         if (x=Rgns.points[i].x) and (y>=Rgns.points[i].y) then // that is point by wind...
                           begin
                             if Nopoint or (Rgns.points[Result].y<Rgns.points[i].y) then
                               begin
                                 Result:=i;Nopoint:=False;
                               end;
                           end;
                       end;
                   end;
               end;
           end;
       end;
     //Now we found the nearest point so we must look on first point and solve is first point is better
     if result=Nf then
       begin
         result:=-1;
       end;
    //===============================================
end;
function getRvertex(var Rgns : Trgnpoints): Tintegers;
var

  RealRgns,i,j : integer;
begin
   j:=0;RealRgns:=0;
  for i:=0 to High(Rgns.types) do
  begin
    if j<>Rgns.types[i] then
      begin
        inc(RealRgns);
        J:=Rgns.types[i];
      end;
  end;
  setlength(Result,RealRgns);
  fillChar(Result[0],4*(1+High(result)),0);
  i:=1;j:=0;
  repeat
    if Rgns.types[j]=i then inc(Result[i-1])
                       else begin inc(i); dec(j) end;
    inc(j);
  until j>high(Rgns.types);


end;
procedure  SimplifyPolys(var Rgns: Trgnpoints;var Rvertex : Tintegers);
var
  i,j,k,Current,TempCurrent,Np,Dp,repeats,LostPointsAtRgn,Freepoint,Types1 : integer;
  Usedpoints : Tintegers;
  TempRgns : TPoints;
  NeedInRepeat,Break1 : Boolean;
  y,L1,L2,L3,P,S : Extended;

begin
  setlength(UsedPoints,1+high(Rgns.points));
  setlength(TempRgns,1+high(Rgns.points));

  current:=0;TempCurrent:=0;
  for i:=0 to high(Rvertex) do
    begin
      repeats:=0;
      LostPointsAtRgn:=Rvertex[i];
      repeat
        Break1:=false;
        inc(repeats);
        NeedInRepeat:=False;
        if LostPointsAtRgn>4 then
          begin
          for j:=0 to Rvertex[i]-1 do
            begin
              if (UsedPoints[Current+j]=0)  then
                begin
                  Np:=j+1;Dp:=j-1;
                  if j=0 then Dp:=Rvertex[i]-1;
                  if j=(Rvertex[i]-1) then Np:=0;
                  while not((UsedPoints[Current+Dp]=0) or (UsedPoints[Current+Dp]=Repeats)) do
                    begin
                      dec(Dp);if Dp<0 then Dp:=Rvertex[i]-1;
                      if Dp=Np then
                        begin
                          Break1:=True;
                          break;
                        end;
                    end;
                  if Break1 then Break;
                  while not((UsedPoints[Current+Np]=0) or (UsedPoints[Current+Np]=Repeats)) do
                    begin
                      inc(Np);if Np>Rvertex[i]-1 then Np:=0;
                      if Dp=Np then
                        begin
                          Break1:=True;
                          break;
                        end;
                    end;
                  if Break1 then Break;

                  //Now we must remove single step staires at regions
                  L1:=sqrt(sqr(1.0*(Rgns.points[Current+j].x-Rgns.points[Current+Dp].x))
                          +sqr(1.0*(Rgns.points[Current+j].y-Rgns.points[Current+Dp].y)));
                  L2:=sqrt(sqr(1.0*(Rgns.points[Current+j].x-Rgns.points[Current+Np].x))
                          +sqr(1.0*(Rgns.points[Current+j].y-Rgns.points[Current+Np].y)));
                  L3:=sqrt(sqr(1.0*(Rgns.points[Current+Np].x-Rgns.points[Current+Dp].x))
                          +sqr(1.0*(Rgns.points[Current+Np].y-Rgns.points[Current+Dp].y)));
                  P:=(L1+L2+L3)/2.0;
                  S:=sqrt(P*(P-L1)*(P-L2)*(P-L3));
                  if (S>0.1) and (L3>0.1)then
                    begin
                      y:=2.0*S/L3;
                    end else y:=L3;





                  if y<=1/sqrt(2.0) then //Point is not need...
                    begin
                      UsedPoints[Current+j]:=repeats; //Mark point as used;
                      Needinrepeat:=true;
                      dec(LostPointsAtRgn);
                    end;
                end;
            end;
          end; //LostPointsAtRgn
      until not NeedInRepeat;

      //All uneseful points were marked...
      //Write new points at temp storage...
      Freepoint:=0;
      for j:=0 to LostPointsAtRgn-1 do
        begin
          for k:=0 to Rvertex[i]-1 do
            begin
              if Usedpoints[Current+k]=0 then
                begin
                  Freepoint:=k;
                  Usedpoints[Current+k]:=-1;
                  break;
                end;
            end;
          TempRgns[TempCurrent+j].x:=Rgns.points[Current+Freepoint].x;
          TempRgns[TempCurrent+j].y:=Rgns.points[Current+Freepoint].y;
        end;
      inc(Current,Rvertex[i]);
      Rvertex[i]:=LostPointsAtRgn;
      inc(TempCurrent,LostPointsAtRgn);
    end;
   //Moving data to Rgns;
   setlength(Rgns.points,TempCurrent);
   setlength(Rgns.types,TempCurrent);
   Current:=0;Types1:=0;
   for i:=0 to High(Rvertex) do
     begin
       inc(types1);
       for j:=0 to Rvertex[i]-1 do
         begin
           Rgns.points[Current+j].x:=TempRgns[Current+j].x;
           Rgns.points[Current+j].y:=TempRgns[Current+j].y;
           Rgns.types[Current+j]:=types1;
         end;
       inc(Current,Rvertex[i]);
     end;
end;
function GetInPower(var Rgns: Trgnpoints;var Rvertex: Tintegers): Tintegers;
var
  i,j,i1,NofFirst,x,y,N1offirst : integer;
  points : Tpoints;

begin
  SetLength(Result,1+High(Rvertex));
  NofFirst:=0;
  for i:=1 to 1+High(Rvertex) do
    begin
      x:=Rgns.points[NofFirst].x;
      y:=Rgns.points[NofFirst].y;
      inc(NofFirst,Rvertex[i-1]);
      N1offirst:=0;
      for i1:=1 to 1+High(Rvertex) do
        begin
          setLength(points,Rvertex[i1-1]);
          if i1<>i then
          begin
          for j:=0 to Rvertex[i1-1]-1 do
            begin
              points[j].x:=Rgns.points[N1ofFirst+j].x;
              points[j].y:=Rgns.points[N1ofFirst+j].y;
            end;
            if PinPoly(Points,point(x,y)) then inc(Result[i-1]);
          end;
      inc(N1ofFirst,Rvertex[i1-1]);
      end;
    end;
end;
function PinPoly(var points : Tpoints;point: Tpoint): boolean;
var
  i,Size1 : integer;
  AtLeft,AtRight,Np,Dp : integer;
  x : double;
  Points1 : Tpoints;
begin
   SetLength(Points1,1+High(points)); Size1:=0;
    for i:=0 to high(points) do
    begin
      if i<>0 then
      begin
        if not ((Points1[Size1-1].x=Points[i].x) and
                (Points1[Size1-1].y=Points[i].y))
                then
                begin
                  Points1[Size1].x:=Points[i].x;
                  Points1[Size1].y:=Points[i].y;inc(size1);
                end;
      end else
      begin
        Points1[Size1].x:=Points[i].x;
        Points1[Size1].y:=Points[i].y;inc(size1);
      end;
    end;


   //-----------------
  AtLeft:=0;AtRight:=0;
  Result:=false;
  for i:=0 to Size1-1 do
    begin
      Np:=i+1;Dp:=i-1;
      if Np=Size1 then Np:=0;
      if Dp=-1 then Dp:=Size1-1;


      if Np<>Dp then
      begin
      //New type of resolving problem
      if ((point.y>=points1[i].y) and (point.y<points1[Np].y)) or
         ((point.y>points1[Np].y) and (point.y<=points1[i].y)) then
        begin
          x:=points1[i].x+(points1[Np].x-points1[i].x)*
             (point.y-points1[i].y)/(points1[Np].y-points1[i].y);
          if (point.y=points1[i].y) then
            begin
               while Point.y=Points1[Dp].y do
                 begin
                   Dp:=PredP(Dp,Size1);
                   if Dp=Np then Break;
                 end;
               while Point.y=Points1[Np].y do
                 begin
                   if Dp=Np then Break;
                   Dp:=NextP(Np,Size1);
                   if Dp=Np then Break;
                 end;
                if Np<>Dp then
                  begin
                  if ((points1[Dp].y<Point.y) and (points1[Np].y>Point.y)) or
                     ((points1[Dp].y>Point.y) and (points1[Np].y<Point.y)) then
                     begin
                       if x>point.x then inc(atright);
                       if x<point.x then inc(atleft);
                     end;
                  end;
            end else//======
            begin
              if x>point.x then inc(atright);
              if x<point.x then inc(atleft);
            end;
        end;
      end;  
      //-----------------------
      //End of New type of resolving problem
    end;
  if Odd(AtRight) and Odd(Atleft) then Result:=True;
end;

function PrealinPoly(var points : Tpoints;x1,y1 : extended): boolean;
var
  i : integer;
  Nextpoint,Predpoint,AtLeft,AtRight : integer;
  x : double;
begin
  AtLeft:=0;AtRight:=0;
  Result:=false;
  for i:=0 to high(points) do
    begin
      nextpoint:=i;
      predpoint:=i-1;
      if i=0 then  predpoint:=High(points);
      //New type of resolving problem
      if ((y1>=points[predpoint].y) and (y1<points[nextpoint].y)) or
         ((y1>points[nextpoint].y) and (y1<=points[predpoint].y)) then
        begin
          x:=points[predpoint].x+(points[nextpoint].x-points[predpoint].x)*
             (y1-points[predpoint].y)/(points[nextpoint].y-points[predpoint].y);
          if x>x1 then inc(atright);
          if x<x1 then inc(atleft);
        end;
      //-----------------------
      //End of New type of resolving problem
    end;
  if Odd(AtRight) and Odd(Atleft) then Result:=True;
end;


//---------------
function  ReCreateRgn(var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers): HRGN;
var
  Rgns : array of HRGN;
  FirstPoint,i,MaxPower,j : integer;
  First : Boolean;
begin
  Result:=0;
  SetLength(Rgns,HIGH(PolyVertex)+1);
  FirstPoint:=0;
  for i:=0 to HIGH(PolyVertex) do
    begin
      Rgns[i]:=CreatePolygonRGN(PolyPoly[FirstPoint],PolyVertex[i],ALTERNATE);
      inc(FirstPoint,PolyVertex[i]);
    end;
  //Созданы все регионы... Начинаем их складывать и вычитать...
  Maxpower:=0;
  for i:=0 to HIGH(PolyinPower) do
    begin
      Maxpower:=Max(Maxpower,Polyinpower[i]);
    end;
   first:=true;
 for i:=0 to Maxpower do
   begin
     for j:=0 to HIGH(polyVertex) do
       begin
         if PolyinPower[j]=i then
           begin
             if First then
               begin
                 Result:=CreateRectRGn(0,0,0,0);
                 CombineRgn(Result,Rgns[j],0,RGN_COPY);
                 First:=False;
               end else
               begin
                 if Odd(i) then
                 CombineRgn(Result,Result,Rgns[j],RGN_DIFF)
                 else
                 CombineRgn(Result,Result,Rgns[j],RGN_OR);
               end;
           end;
       end;
   end;
   for i:=0 to HIGH(PolyVertex) do
     begin
       DeleteObject(Rgns[i]);
     end;
end;
procedure PolyRotate(var points : Tpoints;x,y,Angle : integer);
var
  i : integer;
  dx,dy,R,alfa : double;
begin
  PolyZrotate(points,Angle);
  R:=sqrt(sqr(x)+sqr(y));
  if round(r)<>0 then
    begin
      if x<>0 then
        begin
          alfa:=Angle*pi/1800+arctan2(-y/1000.0,x/1000.0);
        end else
        begin
          if y>0 then alfa:=Angle*pi/1800-pi/2.0
                 else alfa:=Angle*pi/1800+pi/2.0;
        end;
      dx:=x-r*cos(alfa);
      dy:=y+r*sin(alfa);
    end else
    begin
      dx:=0;
      dy:=0;
    end;;
  for i:=0 to High(points) do
    begin
      inc(points[i].x,round(dx));
      inc(points[i].y,round(dy));
    end;
end;
procedure PolyZrotate(var points : Tpoints;Angle : integer);
var
i : integer;
R,Alfa : Double;
begin
  for i:=0 to High(points) do
    begin
      R:=sqrt(sqr(points[i].x)+sqr(points[i].y));
      if round(r)<>0 then
      begin
        if points[i].x<>0 then
        begin
          alfa:=Angle*pi/1800+arctan2(-points[i].y/1000.0,points[i].x/1000.0);
        end else
        begin
          if points[i].y>0 then alfa:=Angle*pi/1800-pi/2.0
                           else alfa:=Angle*pi/1800+pi/2.0;
        end;
        points[i].x:=round(r*cos(alfa));
        points[i].y:=-round(r*sin(alfa));
      end;
    end;
end;
function RotateRegion(var Rgn : Hrgn;X,Y,Angle : integer): integer;
var
  PolyPoly : Tpoints;
  PolyVertex,Polyinpower : Tintegers;
begin
  if Rgn<>Null then
    begin
     RgnToPoly(Rgn,PolyPoly,PolyVertex,Polyinpower);
     PolyRotate(PolyPoly,x,y,Angle);
     DeleteObject(Rgn);
     Rgn:=ReCreateRgn(PolyPoly,PolyVertex,Polyinpower);
     Result:=1;
    end else Result:=0;
end;
function DetectPointsTypes(var points : Tpoints;var types : Tintegers): Tpoints;
var
 i,j,Nrects,Npoints,NOrigPoints,x,y,NRealPoints,j1,x_Left,X_right,y_top,Y_bottom : integer;
 Points1,RealPoints : Tpoints;
 Stypes1,Used1,Npoints1 : Tintegers;
 RealTypes : Tintegers;

begin
  Npoints:=1+high(points);
  Nrects:=Npoints shr 2;// t.e. div 4
  SetLength(Types,Npoints);
  for i:=0 to Nrects-1 do
    for j:=0 to 3 do
      Types[i*4+j]:=1+j;


  //The first step of Marleson balet...
  SetLength(Points1,Npoints);
  SetLength(NPoints1,Npoints);
  SetLength(Stypes1,Npoints);
  SetLength(Used1,  Npoints);
  NOrigPoints:=0;
  for i:=0 to Npoints-1 do
    begin
      if Used1[i]=0 then
        begin
          x:=Points[i].x;y:=Points[i].y;
          Points1[NOrigPoints].x:=x;Points1[NOrigPoints].y:=y;
          inc(Used1[i]);
          inc(Stypes1[NOrigPoints],Types[i]);
          inc(Npoints1[NOrigPoints]);
          for j:=i to Npoints-1 do
            begin
              if Used1[j]=0 then
                begin
                  if (x=Points[j].x) and (y=Points[j].y) then
                    begin
                      inc(Used1[j]);
                      inc(Stypes1[NOrigPoints],Types[j]);
                      inc(Npoints1[NOrigPoints]);
                    end;
                end;
            end;
          inc(NOrigPoints);
        end;
    end;
  //From this plase we have the Number of origin points at NOrigPoints
  //Number of point intersections at Npoints1
  //Sum of tis points types...
  //Now we must use this data to choice the truly type of origin point...
  SetLength(RealTypes, NPoints);
  SetLength(RealPoints,NPoints);
  NrealPoints:=0;
  for i:=0 to NOrigPoints-1 do
    begin
      if Npoints1[i]=4 then
        begin

        end;
      if Npoints1[i]=3 then
        begin
          if Stypes1[i]=6 then
            begin
              RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
              RealTypes[NrealPoints]:=-4;inc(NrealPoints);
            end;
          if Stypes1[i]=9 then
            begin
              RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
              RealTypes[NrealPoints]:=-1;inc(NrealPoints);
            end;
          if Stypes1[i]=8 then
            begin
              RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
              RealTypes[NrealPoints]:=-2;inc(NrealPoints);
            end;
          if Stypes1[i]=7 then
            begin
              RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
              RealTypes[NrealPoints]:=-3;inc(NrealPoints);
            end;
        end;
      if Npoints1[i]=2 then
        begin
          if  not((Stypes1[i]=6) or (Stypes1[i]=4)) then
            begin

            end else
            begin
              if Stypes1[i]=6 then
                begin
                  RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
                  RealTypes[NrealPoints]:=-3;inc(NrealPoints);
                  RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
                  RealTypes[NrealPoints]:=-1;inc(NrealPoints);
                end;
              if Stypes1[i]=4 then
                begin
                  RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
                  RealTypes[NrealPoints]:=-4;inc(NrealPoints);
                  RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
                  RealTypes[NrealPoints]:=-2;inc(NrealPoints);
                end;
            end;
        end;
      if Npoints1[i]=1 then
        begin
          //Most Compex case...
          RealPoints[NrealPoints].x:=Points1[i].x;RealPoints[NrealPoints].y:=Points1[i].y;
          x:=Points1[i].x;y:=Points1[i].y;
          if Stypes1[i]=1 then
            begin
              RealTypes[NrealPoints]:=1;
              for j1:=0 to Nrects-1 do
                begin
                  x_left:=Points[j1*4].x;y_top:=Points[j1*4].y;
                  x_Right:=Points[j1*4+2].x;y_Bottom:=Points[j1*4+2].y;
                  if x=x_right then
                    if (y<y_bottom) and (y>y_top) then RealTypes[NrealPoints]:=-4;
                  if y=y_bottom then
                    if (x<x_right) and (x>x_left) then RealTypes[NrealPoints]:=-2;
                end;
            end;
          if Stypes1[i]=2 then
            begin
              RealTypes[NrealPoints]:=2;
              for j1:=0 to Nrects-1 do
                begin
                  x_left:=Points[j1*4].x;y_top:=Points[j1*4].y;
                  x_Right:=Points[j1*4+2].x;y_Bottom:=Points[j1*4+2].y;
                  if x=x_left then
                    if (y<y_bottom) and (y>y_top) then RealTypes[NrealPoints]:=-3;
                  if y=y_bottom then
                    if (x<x_right) and (x>x_left) then RealTypes[NrealPoints]:=-1;
                end;
            end;
          if Stypes1[i]=3 then
            begin
              RealTypes[NrealPoints]:=3;
              for j1:=0 to Nrects-1 do
                begin
                  x_left:=Points[j1*4].x;y_top:=Points[j1*4].y;
                  x_Right:=Points[j1*4+2].x;y_Bottom:=Points[j1*4+2].y;
                  if x=x_left then
                    if (y<y_bottom) and (y>y_top) then RealTypes[NrealPoints]:=-2;
                  if y=y_top then
                    if (x<x_right) and (x>x_left) then RealTypes[NrealPoints]:=-4;
                end;
            end;
          if Stypes1[i]=4 then
            begin
              RealTypes[NrealPoints]:=4;
              for j1:=0 to Nrects-1 do
                begin
                  x_left:=Points[j1*4].x;y_top:=Points[j1*4].y;
                  x_Right:=Points[j1*4+2].x;y_Bottom:=Points[j1*4+2].y;
                  if x=x_right then
                    if (y<y_bottom) and (y>y_top) then RealTypes[NrealPoints]:=-1;
                  if y=y_top then
                    if (x<x_right) and (x>x_left) then RealTypes[NrealPoints]:=-3;
                end;
            end;
          inc(NrealPoints);
        end;
    end;
  //Now we have at NrealPoints the number of reals points at RealPoints
  //that types are in RealTypes...
  //Now we must to rewrite data to result...
  SetLength(Result,NrealPoints);
  SetLength(Types, NrealPoints);
  for i:=0 to NrealPoints-1 do
    begin
      Result[i].x:=RealPoints[i].x;
      Result[i].y:=RealPoints[i].y;
      Types[i]   :=RealTypes[i];
    end;
end;


procedure Getinner(var PolyPoly : Tpoints;var PolyVertex,Polyinpower : Tintegers;Dd : integer;Outer,Inner :Boolean);
var
  i,j, Current,Np,Dp,x1,x2,x3,x4,x,y1,y2,y3,y4 : integer;
  Poly,Newpoints : Tpoints;
  p1 : Tpoint;
  pin1,Norgn,Lr,Ub,Needback : Boolean;
  Midangle,Dangle,Nangle,halfangle : extended;
  Powerofpoints : Tintegers;
begin

  Current:=0;Norgn:=false;
  setlength(Newpoints,1+high(polypoly));
  setlength(Powerofpoints,1+high(polypoly));
  for i:=0 to high(PolyVertex) do
    begin
      SetLength(Poly,PolyVertex[i]);
      for j:=0 to PolyVertex[i]-1 do
        begin
          Poly[j].x:=Polypoly[j+Current].x;
          Poly[j].y:=Polypoly[j+Current].y;
        end;
  
      for j:=0 to PolyVertex[i]-1 do
        begin
          Np:=j+1;Dp:=j-1;
          if j=PolyVertex[i]-1 then Np:=0;
          if j=0 then Dp:=PolyVertex[i]-1;
          while (Polypoly[Current+j].x=Polypoly[Current+Np].x) and
                (Polypoly[Current+j].y=Polypoly[Current+Np].y) do
            begin
              inc(Np);if Np=PolyVertex[i] then Np:=0;
              if Np=Dp then
                begin
                  NoRgn:=true;
                  break;
                end;
            end;
          while (Polypoly[Current+j].x=Polypoly[Current+dp].x) and
                (Polypoly[Current+j].y=Polypoly[Current+dp].y) do
            begin
              dec(Dp);if Dp=-1 then Dp:=PolyVertex[i]-1;
              if Np=Dp then
                begin
                  NoRgn:=true;
                  break;
                end;
            end;
         //we found the next and pred points if this is avaible...
         if not Norgn then
          begin
            if Polypoly[Current+j].x=Polypoly[Current+dp].x then
              begin
                if Polypoly[Current+dp].y>Polypoly[Current+j].y then dangle:=-pi/2.0
                                                                else dangle:=pi/2.0;

              end else
              begin
                dangle:=-arctan2((Polypoly[Current+dp].y-Polypoly[Current+j].y)/
                                1000.0,(Polypoly[Current+dp].x-Polypoly[Current+j].x)/
                                1000.0);

              end;
            if Polypoly[Current+j].x=Polypoly[Current+np].x then
              begin
                if Polypoly[Current+np].y>Polypoly[Current+j].y then nangle:=-pi/2.0
                                                                else nangle:=pi/2.0;

              end else
              begin
                nangle:=-arctan2((Polypoly[Current+np].y-Polypoly[Current+j].y)/
                                1000.0,(Polypoly[Current+np].x-Polypoly[Current+j].x)/
                                1000.0);

              end;
            Midangle:=(dangle+nangle)/2.0;
            halfangle:=(dangle-nangle)/2.0;
            powerofpoints[Current+j]:=abs(round(1000*cos(halfangle)));
         //==============================================
           if abs(sin(Halfangle))<0.001 then
           begin
             newpoints[Current+j].x:=polypoly[Current+j].x;
             newpoints[Current+j].y:=polypoly[Current+j].y;
           end else
           begin
           if prealinpoly(poly,
                          polypoly[Current+j].x+0.011*cos(Midangle)/abs(sin(Halfangle)),
                          polypoly[Current+j].y-0.011*sin(Midangle)/abs(sin(Halfangle))) then
             begin
               if (not odd(Polyinpower[i])) then
                 begin
                   if outer then
                   begin
                   if abs(sin(Halfangle))>=0.5 then
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x+round(Dd*cos(Midangle)/abs(sin(Halfangle)));
                   newpoints[Current+j].y:=polypoly[Current+j].y+round(-Dd*sin(Midangle)/abs(sin(Halfangle)));
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x+round(2*Dd*cos(Midangle));
                   newpoints[Current+j].y:=polypoly[Current+j].y+round(-2*Dd*sin(Midangle));
                   end;
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x;
                   newpoints[Current+j].y:=polypoly[Current+j].y;
                   end;
                 end else
                 begin
                   if inner then
                   begin
                   if abs(sin(Halfangle))>=0.5 then
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x-round(Dd*cos(Midangle)/abs(sin(Halfangle)));
                   newpoints[Current+j].y:=polypoly[Current+j].y-round(-Dd*sin(Midangle)/abs(sin(Halfangle)));
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x-round(2*Dd*cos(Midangle));
                   newpoints[Current+j].y:=polypoly[Current+j].y-round(-2*Dd*sin(Midangle));
                   end;
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x;
                   newpoints[Current+j].y:=polypoly[Current+j].y;
                   end;
                 end;
             end else
             begin
               if not odd(Polyinpower[i]) then
                 begin
                   if abs(sin(Halfangle))>=0.5 then
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x-round(Dd*cos(Midangle)/abs(sin(Halfangle)));
                   newpoints[Current+j].y:=polypoly[Current+j].y-round(-Dd*sin(Midangle)/abs(sin(Halfangle)));
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x-round(2*Dd*cos(Midangle));
                   newpoints[Current+j].y:=polypoly[Current+j].y-round(-2*Dd*sin(Midangle));
                   end;
                 end else
                 begin
                   if abs(sin(Halfangle))>=0.5 then
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x+round(Dd*cos(Midangle)/abs(sin(Halfangle)));
                   newpoints[Current+j].y:=polypoly[Current+j].y+round(-Dd*sin(Midangle)/abs(sin(Halfangle)));
                   end else
                   begin
                   newpoints[Current+j].x:=polypoly[Current+j].x+round(2*Dd*cos(Midangle));
                   newpoints[Current+j].y:=polypoly[Current+j].y+round(-2*Dd*sin(Midangle));
                   end;
                 end;
             end;
           end;
        //==============================================
         end else
         begin
           newpoints[Current+j].x:=polypoly[Current+j].x;
           newpoints[Current+j].y:=polypoly[Current+j].y;
         end;
        end;
      inc(Current,PolyVertex[i]);
    end;
    //

    repeat
    needback:=false;
    current:=0;
    for i:=0 to high(polyvertex) do
      begin
        for j:=0 to polyvertex[i]-1 do
          begin
            x1:=polypoly[Current+j].x;
            y1:=polypoly[Current+j].y;
            x2:=newpoints[Current+j].x;
            y2:=newpoints[Current+j].y;
            if j<>(polyvertex[i]-1) then
              begin
                x3:=polypoly[Current+j+1].x;
                y3:=polypoly[Current+j+1].y;
                x4:=newpoints[Current+j+1].x;
                y4:=newpoints[Current+j+1].y;
              end else
              begin
                x3:=polypoly[Current].x;
                y3:=polypoly[Current].y;
                x4:=newpoints[Current].x;
                y4:=newpoints[Current].y;
              end;
           if ((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))<>0 then    //Unparallel req..
             begin
               x:=round(((y3-y1)*(x2-x1)*(x4-x3)+x1*(y2-y1)*(x4-x3)-x3*(y4-y3)*(x2-x1))/
                  ((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1)));
               if (((x>x1) and (x<x2)) or ((x>x2) and (x<x1))) and
                  (((x>x3) and (x<x4)) or ((x>x4) and (x<x3)))  then
                  begin
                    //We got the unlegal intersection..
                    if j<> (polyvertex[i]-1) then
                      begin
                        if powerofpoints[current+j]>powerofpoints[Current+j+1] then
                          begin
                            newpoints[Current+j+1].x:=newpoints[Current+j].x;
                            newpoints[Current+j+1].y:=newpoints[Current+j].y;
                            powerofpoints[Current+j+1]:=powerofpoints[current+j];
                          end else
                          begin
                            newpoints[Current+j].x:=newpoints[Current+j+1].x;
                            newpoints[Current+j].y:=newpoints[Current+j+1].y;
                            powerofpoints[current+j]:=powerofpoints[current+j+1];
                            needback:=true;
                          end;
                      end else
                      begin
                        if powerofpoints[current+j]>powerofpoints[Current] then
                          begin
                            newpoints[Current].x:=newpoints[Current+j].x;
                            newpoints[Current].y:=newpoints[Current+j].y;
                            powerofpoints[Current]:=powerofpoints[current+j];
                          end else
                          begin
                            newpoints[Current+j].x:=newpoints[Current].x;
                            newpoints[Current+j].y:=newpoints[Current].y;
                            powerofpoints[current+j]:=powerofpoints[current];
                            Needback:=true;
                          end;
                      end;
                  end;
             end;
          end;
        inc(Current,PolyVertex[i]);
      end;
    until not needback;

    for i:=0 to high(polypoly) do
      begin
        polypoly[i].x:=newpoints[i].x;
        polypoly[i].y:=newpoints[i].y;
      end;
end;
function GetPPCopy(var PPoly : Tpoints): Tpoints;
  var
    i : integer;
begin
  setlength(result,1+high(PPoly));
  for i:=0 to high(PPoly) do
    begin
      Result[i].x:=PPoly[i].x;
      Result[i].y:=PPoly[i].y;
    end;
end;

procedure GetLDppoly(var MainPpoly,InnerPPoly : Tpoints;var mainvertex,Maininpower: Tintegers; var Lppoly,DPpoly
                      : Tpoints;var Lvertex,Dvertex : Tintegers; var Ln,Dn : integer);

  var
    i,j,Current,CurrentL,CurrentD,x2,y2,X3,y3,dx,dy: integer;
    Timel,Timed : Tpoints;
    TimeLvertex,TimeDVertex : Tintegers;

begin
  Ln:=0;Dn:=0;
  Current:=0;CurrentL:=0;CurrentD:=0;
  SetLength(TimeL,4*(1+high(MainPPoly)));
  SetLength(TimeD,4*(1+high(MainPPoly)));
  SetLength(TimeLVertex,(1+high(MainPPoly)));
  SetLength(TimeDVertex,(1+high(MainPPoly)));
  for i:=0 to high(MainVertex) do
    begin
      for j:=0 to MainVertex[i]-1 do
        begin
          x2:=mainPPoly[Current+j].x;
          y2:=mainPPoly[Current+j].y;
          if j<>(MainVertex[i]-1) then
            begin
              x3:=mainPPoly[current+j+1].x;
              y3:=mainPPoly[current+j+1].y;
            end else
            begin
              x3:=mainPPoly[current].x;
              y3:=mainPPoly[current].y;
            end;
            dx:=x3-x2;
            dy:=y3-y2;
            if (((dx>=0) and ((dy)<(dx))) or ((dx<0) and ((-dy)>(-dx)))) and (not odd(Maininpower[i])) or
               (not ((dx>=0) and ((dy)<(dx))) or ((dx<0) and ((-dy)>(-dx)))) and (odd(Maininpower[i]))
                 then
                 begin
                   TimeL[CurrentL].x:=MainPPoly[Current+j].x;
                   TimeL[CurrentL].y:=MainPPoly[Current+j].y;
                   TimeL[CurrentL+1].x:=InnerPPoly[Current+j].x;
                   TimeL[CurrentL+1].y:=InnerPPoly[Current+j].y;
                   if j=(MainVertex[i]-1) then
                     begin
                       TimeL[CurrentL+3].x:=MainPPoly[Current].x;
                       TimeL[CurrentL+3].y:=MainPPoly[Current].y;
                       TimeL[CurrentL+2].x:=InnerPPoly[Current].x;
                       TimeL[CurrentL+2].y:=InnerPPoly[Current].y;
                     end else
                     begin
                       TimeL[CurrentL+3].x:=MainPPoly[Current+j+1].x;
                       TimeL[CurrentL+3].y:=MainPPoly[Current+j+1].y;
                       TimeL[CurrentL+2].x:=InnerPPoly[Current+j+1].x;
                       TimeL[CurrentL+2].y:=InnerPPoly[Current+j+1].y;

                     end;
                   inc(CurrentL,4);
                   TimeLVertex[Ln]:=4;
                   inc(Ln);
                 end else
                 begin
                   TimeD[CurrentD].x:=MainPPoly[Current+j].x;
                   TimeD[CurrentD].y:=MainPPoly[Current+j].y;
                   TimeD[CurrentD+1].x:=InnerPPoly[Current+j].x;
                   TimeD[CurrentD+1].y:=InnerPPoly[Current+j].y;
                   if j=(MainVertex[i]-1) then
                     begin
                       TimeD[CurrentD+3].x:=MainPPoly[Current].x;
                       TimeD[CurrentD+3].y:=MainPPoly[Current].y;
                       TimeD[CurrentD+2].x:=InnerPPoly[Current].x;
                       TimeD[CurrentD+2].y:=InnerPPoly[Current].y;
                     end else
                     begin
                       TimeD[CurrentD+3].x:=MainPPoly[Current+j+1].x;
                       TimeD[CurrentD+3].y:=MainPPoly[Current+j+1].y;
                       TimeD[CurrentD+2].x:=InnerPPoly[Current+j+1].x;
                       TimeD[CurrentD+2].y:=InnerPPoly[Current+j+1].y;

                     end;
                   inc(CurrentD,4);
                   TimeDVertex[Dn]:=4;
                   inc(Dn);
                 end;
        end;
        inc(current,MainVertex[i]);
    end;

    Setlength(LPpoly,CurrentL);
    Setlength(DPpoly,CurrentD);
    SetLength(LVertex,Ln);
    SetLength(DVertex,Dn);
    for i:=0 to CurrentL-1 do
      begin
        LPpoly[i].x:=TimeL[i].x;
        LPpoly[i].y:=TimeL[i].y;
      end;
    for i:=0 to CurrentD-1 do
      begin
        DPpoly[i].x:=TimeD[i].x;
        DPpoly[i].y:=TimeD[i].y;
      end;
    for i:=0 to Ln-1 do
      begin
        LVertex[i]:=TimeLVertex[i];
      end;
    for i:=0 to Dn-1 do
      begin
        DVertex[i]:=TimeDVertex[i];
      end;
end;
function NextP(N,Count : integer): integer;
  begin
    inc(N);if N=Count then N:=0;
    Result:=N;
  end;
  function PredP(N,Count : integer): integer;
  begin
    dec(N);if N=-1 then N:=Count-1;
    Result:=N;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------The Block of Polys actions---------------------------------
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure removePointsP(Var poly : Tpoints; d :integer);
var
  i,Count : integer;
  TPoly : Tpoints;
  R : double;
begin
  Count:=0;
  Setlength(TPoly,1+High(poly));
  for i:=0 to High(Poly) do
    begin
      if i=0 then
        begin
          TPoly[Count].x:=Poly[i].x;
          TPoly[Count].y:=Poly[i].y;
          Inc(count);
        end else
        begin
          R:=sqrt(sqr(TPoly[Count-1].x-Poly[i].x)+sqr(TPoly[Count-1].y-Poly[i].y));
          if R>d then
            begin
              TPoly[Count].x:=Poly[i].x;
              TPoly[Count].y:=Poly[i].y;
              Inc(count);
            end;
        end;
    end;
  if Count>=3 then
    begin
      SetLength(Poly,Count);
      for i:=0 to Count-1 do
        begin
          Poly[i].x:=TPoly[i].x;
          Poly[i].y:=TPoly[i].y;
        end;
    end else
    begin
      SetLength(Poly,0);
    end;
end;

  procedure RemovePointsPP(var Polypoly : Tpoints;var Vertex,Powers : Tintegers;D : integer);
  var
    i,j,Count,TCount,Npolyes,dd: integer;
    Poly,TPPoly : Tpoints;
    Tvertex,TPowers :Tintegers;
begin
  dd:=max(2,d);
  Count:=0;TCount:=0;Npolyes:=0;
  SetLength(TPPoly,1+High(PolyPoly));
  SetLength(Tvertex,1+High(Vertex));
  SetLength(TPowers,1+High(Vertex));
  for i:=0 to High(vertex) do
    begin
      Setlength(poly,Vertex[i]);
      for j:=0 to Vertex[i]-1 do
        begin
          Poly[j].x:=PolyPoly[j+Count].x;
          Poly[j].y:=PolyPoly[j+Count].y;
        end;
      inc(Count,Vertex[i]);
      RemovepointsP(poly,dd);
      if High(Poly)>0 then
        begin
          TVertex[Npolyes]:=1+High(Poly);
          Tpowers[Npolyes]:=Powers[i];
          for j:=0 to TVertex[Npolyes]-1 do
            begin
              TPPoly[TCount+j].x:=Poly[j].x;
              TPPoly[TCount+j].y:=Poly[j].y;
            end;
          inc(TCount,TVertex[Npolyes]);
          inc(Npolyes);
        end;
    end;
  SetLength(PolyPoly,Tcount);
  for i:=0 to TCount-1 do
    begin
      PolyPoly[i].x:=TPPoly[i].x;
      PolyPoly[i].y:=TPPoly[i].y;
    end;
  setLength(Vertex,Npolyes);
  setLength(Powers,Npolyes);
  for i:=0 to NPolyes-1 do
    begin
      Vertex[i]:=TVertex[i];
      Powers[i]:=Tpowers[i];
    end;
end;


end.
