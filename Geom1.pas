{
Y = 0.299 R + 0.587 G + 0.114 B
1. Поменять структуру данных
2. Всвязи с этим переписать некоторые функции (поиска, удаления, добавления элементов)

ПРОБЛЕМА - ИЗ-ЗА НЕПРАВИЛЬНОГО/НЕТОЧНОГО ОПРЕДЕЛЕНИЯ ПЕРВОГО РЕБРА !!!
если триангуляция правильно начата, то она корректно завершится !
Правда, есть ситуация, когда процесс зацикливается при неоднозначности решения
}
unit Geom1;

interface

type

  vClass = (vRIGHT,vLEFT);

  TVector = record
    x, y, z : real;
  end;
  tLocate=(tLeft,tRight,tUnknown);

  TPoint3D = record
    x, y : integer;
    z : real;
  end;

  TMyPoint = record
    x, y, z : real;
  end;

  MyListPoint = ^my_MyListPoint;
  my_MyListPoint = record
    mynext : MyListPoint;
    point : TMyPoint;
    index : longint;
  end;
  TMyListPoint = record
    head : MyListPoint;
    curr : MyListPoint;
    last : MyListPoint;
    minX, minY, minZ,
    maxX, maxY, maxZ : real;
    points : longint;
  end;

  TTriangle = record
    v : array [0..2] of TMyPoint;
  end;

  MyListTriangle = ^my_MyListTriangle;
  my_MyListTriangle = record
//    prev : MyListTriangle;
    mynext : MyListTriangle;
    triangle : TTriangle;
  end;
  TMyListTriangle = record
    head : MyListTriangle;
    curr : MyListTriangle;
    last : MyListTriangle;
    triangles : longint;
  end;

  TPolyline = record
    theFirstPoint,
    theCurrentPoint,
    theLastPoint: TMyListPoint;
    points: integer;
  end;
  TPolylineList = record
    theFirstPolyline,
    theCurrentPolyline,
    theLastPolyline: TPolyLine;
    polylines: integer;
  end;

  TEdge = record
    org, dest : TMyPoint;
  end;

  TEnum = ( LEFT, RIGHT, BEYOND, BEHIND, BETWEEN, ORIGIN, DESTINATION,
            COLLINEAR, PARALLEL, SKEW_CROSS, SKEW_NO_CROSS );

  MyListEdge = ^my_MyListEdge;
  my_MyListEdge = record
    prev : MyListEdge;
    mynext : MyListEdge;
    edge : TEdge;
  end;
  TMyListEdge = record
    head : MyListEdge;
    curr : MyListEdge;
    last : MyListEdge;
    length : longint;
  end;

  TTraektPoint = record
    x, y, z : real;
    a, b, c : real;
  end;
  TTraektPointArray = array{[1..1000] или переделать в TMyListPoint} of TTraektPoint;
  pTraektPointArray = tTraektPointArray;

var
  DrawMode : integer;
//  TrPoints:integer;
  ActivePoint, OldActivePoint : integer;
//  Traektory:TTraektPointArray;
  x0,y0 : integer;
  Move : boolean;

  RatioXY : real;
  Point : TMyListPoint;
  Triangle : TMyListTriangle;
  Polyline: TPolylineList;
  SeeToPoint : boolean = false;
  Fname : string;
  tOffsX, tOffsY, tOffsZ : real;
  scale : real;
  Traektory : array [1..1000] of TMyPoint;
  TrPoints : integer;

procedure AddFirst ( var a : TMyListEdge; c : TEdge );
procedure AddNext ( var a : TMyListEdge; c : TEdge );
procedure DeleteElement ( var a : TMyListEdge; d : MyListEdge );
procedure AddFirstP ( var a : TMyListPoint; c : TMyPoint );
procedure AddNextP ( var a : TMyListPoint; c : TMyPoint );
procedure AddFirstPL ( var a : TPolylineList; c : TPolyline );
procedure AddNextPL ( var a : TPolylineList; c : TPolyline );
procedure PlayPoints ( var Point : TMyListPoint );
procedure AddFirstT ( var a : TMyListTriangle; c : TTriangle );
procedure AddNextT ( var a : TMyListTriangle; c : TTriangle );
procedure AddTriangle(p1,p2,p3:TMyPoint);
function p_length ( p : TMyPoint ) : double ;
function classify ( p2, p0, p1 : TMyPoint ) : TEnum;
procedure hullEdge ( s : TMyListPoint; var e : TEdge  );
procedure removeMin ( var frontier : TMyListEdge; var e : TEdge );
procedure rot ( var e : TEdge );
procedure intersect ( f, e : TEdge; var t : double );
procedure flip (var e : TEdge);
function mate ( e : TEdge; s : TMyListPoint;
                var p : TMyPoint ) : boolean;
procedure update1 ( var frontier : TMyListEdge; a, b : TMyPoint );
//procedure Triangulate ( s : array of TMyPoint; n : integer;
//        var Triangle : TriangleArray; var triangles : integer );
function InTriangle1(p : TMyPoint; t : TTRiangle) : boolean;
function fWhere (p : TMyPoint; e : TEdge) : tLocate;
function AngleCos(a,b:TVector):real;

implementation

function AngleCos(a,b:TVector):real;
begin
  AngleCos:=(a.x*b.x+a.y*b.y+a.z*b.z);
end;

procedure AddFirst ( var a : TMyListEdge; c : TEdge );
begin
  new(a.curr);
  a.curr^.edge := c;
  a.curr^.mynext := nil;
  a.curr^.prev := nil;
  a.head := a.curr;
  a.last := a.curr;
  a.length := 1;
end;

procedure AddNext ( var a : TMyListEdge; c : TEdge );
begin
  new(a.curr);
  a.curr^.edge := c;
  a.curr^.mynext := a.head;
  a.curr^.prev := nil;
  if a.head <> nil
    then a.head^.prev := a.curr;
  a.head := a.curr;
  inc ( a.length );
end;

procedure AddFirstP ( var a : TMyListPoint; c : TMyPoint );
begin
  new(a.curr);
  a.curr^.Point := c;
  a.curr^.mynext := nil;
//  a.curr^.prev := nil;
  a.head := a.curr;
  a.last := a.curr;
  a.points := 1;
  a.minX := c.x;
  a.minY := c.y;
  a.minZ := c.z;
  a.maxX := c.x;
  a.maxY := c.y;
  a.maxZ := c.z;
end;

procedure AddNextP ( var a : TMyListPoint; c : TMyPoint );
begin
  new(a.curr);
  a.curr^.Point := c;
  a.curr^.mynext := nil;
//  a.curr^.prev := a.last;
  if a.last <> nil
    then a.last^.mynext := a.curr;
  a.last := a.curr;
  inc ( a.Points );
  if c.x > a.maxX then a.maxX := c.x;
  if c.y > a.maxY then a.maxY := c.y;
  if c.z > a.maxZ then a.maxZ := c.z;
  if c.x < a.minX then a.minX := c.x;
  if c.y < a.minY then a.minY := c.y;
  if c.z < a.minZ then a.minZ := c.z;
end;

procedure AddFirstPL ( var a : TPolylineList; c : TPolyline );
begin
end;

procedure AddNextPL ( var a : TPolylineList; c : TPolyline );
begin
end;

procedure PlayPoints ( var Point : TMyListPoint );
var
  p : TMyPoint;
begin
  tOffsX := ( Point.minX + Point.maxX ) / 2;
  tOffsY := ( Point.minY + Point.maxY ) / 2;
  tOffsZ := ( Point.minZ + Point.maxZ ) / 2;
  P.x := Point.minX;
  P.y := Point.minY;
  P.z := Point.minZ;
  AddNextP ( Point, P );
  P.x := Point.maxX;
  P.y := Point.minY;
  P.z := Point.minZ;
  AddNextP ( Point, P );
  P.x := Point.maxX;
  P.y := Point.maxY;
  P.z := Point.minZ;
  AddNextP ( Point, P );
  P.x := Point.minX;
  P.y := Point.maxY;
  P.z := Point.minZ;
  AddNextP ( Point, P );
  scale := ( Point.maxX - Point.minX ) * 0.008811;
  RatioXY := ( Point.maxX - Point.minX ) / ( Point.maxY - Point.minY );
//  scale:=( Point.maxX - Point.minX ) / 200;
//  scale := ( tmax - tmin ) / 0.008811 / MainForm.Width;
end;

procedure AddFirstT ( var a : TMyListTriangle; c : TTriangle );
begin
  new(a.curr);
  a.curr^.Triangle := c;
  a.curr^.mynext := nil;
  a.head := a.curr;
  a.last := a.curr;
  a.Triangles := 1;
end;

procedure AddNextT ( var a : TMyListTriangle; c : TTriangle );
begin
  new(a.curr);
  a.curr^.Triangle := c;
  a.curr^.mynext := nil;
  if a.last <> nil
    then a.last^.mynext := a.curr;
  a.last := a.curr;
  inc ( a.Triangles );
end;

procedure DeleteElement ( var a : TMyListEdge; d : MyListEdge );
//var  a1, a2: MyListEdge;
begin

  if a.head = nil then exit;
  if a.last = nil then exit;

  if a.head <> a.last then
    if d = a.head then begin
      a.head := d.mynext;
      a.head.prev := nil;
    end else
    if d = a.last then begin
      a.last := d.prev;
      a.last.mynext := nil;
    end
    else begin
      d.prev.mynext := d.mynext;
      d.mynext.prev := d.prev;
    end;
{  new( a1 );
  if d <> nil then a1 := d^.prev;
  new( a2 );
  if d <> nil then a2 := d^.mynext;
  if a1 <> nil then a1^.mynext := a2;
  if a2 <> nil then a2^.prev := a1;
  if d = a.head then a.head := a2;
  if d = a.last then a.last := a1;}
//  if d <> nil then dispose( d );
  dec( a.length );
end;

function p_length ( p : TMyPoint ) : double ;
begin
  p_length := sqrt ( p.x * p.x + p.y * p.y );
end;

function classify ( p2, p0, p1 : TMyPoint ) : TEnum;
{$S-}
var
  a, b : TMyPoint;
  sa : double;
begin
  a.x := p1.x - p0.x;
  a.y := p1.y - p0.y;
  b.x := p2.x - p0.x;
  b.y := p2.y - p0.y;
  sa := a.x * b.y - b.x * a.y;

  if sa > 0 then
    classify := LEFT else
  if sa < 0 then
    classify := RIGHT else
  if ( a.x * b.x < 0 ) or ( a.y * b.y < 0 ) then
    classify := BEHIND else
  if p_length ( a ) < p_length ( b ) then
    classify := BEYOND else
  if ( p0.x = p2.x ) and ( p0.y = p2.y ) then
    classify := ORIGIN else
  if ( p1.x = p2.x ) and ( p1.y = p2.y ) then
    classify := DESTINATION else
    classify := BETWEEN;
end;

procedure hullEdge ( s : TMyListPoint; var e : TEdge  );
var
  m, i : longint;
  c : TEnum;
  psm: MyListPoint;
  sm, swp : TMyPoint;
begin
  m := 0;
  if s.points < 3 then exit;

  // среди всех точек находим самую левую верхнюю точку
  // и ставим на неё указатель psm
  psm := s.head;
  s.curr := s.head;
  while s.curr <> nil do begin
    if ( s.curr.point.x <= psm^.point.x ) and ( s.curr.point.y <= psm^.point.y )
      then psm := s.curr;
    s.curr := s.curr^.mynext;
  end;

  // обмениваем значения точек: самой первой и найденной
  sm := psm^.point;
  swp := s.head^.point;
  s.head^.point := sm;
  psm^.point := swp;

//  начиная со второй точки в списке, просматриваем все точки
//  и отбираем ту, слева от которой нет больше точек,
//  т.е. всегда берём точку, удовлетворяющую этому условию
  sm := s.head^.mynext^.point; // вторая точка из списка
  s.curr := s.head^.mynext^.mynext^.mynext; // начиная с третьей точки списка
  while s.curr <> nil do begin
//  if s.curr.mynext = nil then break; {?}
//  for i := 2 to s.points -1 do begin
    c := classify ( s.curr^.point, s.head^.point, sm );
    if ( c = LEFT ) or ( c = BETWEEN ) then sm := s.curr^.point;
    s.curr := s.curr.mynext
  end;
  e.org := s.head^.point;
  e.dest := sm;
end;

procedure removeMin ( var frontier : TMyListEdge; var e : TEdge );
var
  first : MyListEdge;
begin
  {- returns first edge in the frontier -}
  {- and then its remove from the frontier -}
  first := frontier.head;
  e := first^.edge;
  DeleteElement ( frontier, first );
end;

procedure rot ( var e : TEdge );
var
  m, v, n : TMyPoint;
begin
  m.x := 0.5 * ( e.org.x + e.dest.x );
  m.y := 0.5 * ( e.org.y + e.dest.y );
  v.x := e.dest.x - e.org.x;
  v.y := e.dest.y - e.org.y;
  n.x := v.y;
  n.y := -v.x;
  e.org.x := m.x - 0.5 * n.x;
  e.org.y := m.y - 0.5 * n.y;
  e.dest.x := m.x + 0.5 * n.x;
  e.dest.y := m.y + 0.5 * n.y;
end;

procedure intersect ( f, e : TEdge; var t : double );
var
  a, b, c, d, n, ba, ac : TMyPoint;
  denom, num : double;
  aclass : TEnum;
begin
  a := f.org;
  b := f.dest;
  c := e.org;
  d := e.dest;
  n.x := d.y - c.y;
  n.y := c.x - d.x;
  ba.x := b.x - a.x;
  ba.y := b.y - a.y;
  denom := n.x * ba.x + n.y * ba.y;
  if denom = 0 then begin
    aclass := classify ( f.org , e.org, e.dest );
    if ( aclass = LEFT ) or ( aclass = RIGHT )
      then exit  { PARALLEL }
      else exit; { COLLINEAR }
  end;
  ac.x := a.x - c.x;
  ac.y := a.y - c.y;
  num := n.x * ac.x + n.y * ac.y;
  t := -num / denom;
  { SKEW }
end;

function mate ( e : TEdge; s : TMyListPoint;
                var p : TMyPoint ) : boolean;
var
  t, bestt : double;
  bestp : ^TMyPoint;
  f, g : TEdge;
  c: TEnum;
begin
  bestp := nil;
  bestt := 1e+300;
  f := e;
  rot ( f );
  s.curr := s.head;
//  for i := 0 to s.points - 1 do begin
  while ( s.curr <> nil ) do begin
    c := classify ( s.curr^.point, e.org, e.dest );
    if c = RIGHT then begin
      g.org := e.dest;
      g.dest := s.curr^.point;
      rot ( g );
      intersect ( f, g, t );
      if t <= bestt then begin
        bestp := @s.curr^.point;
        bestt := t;
      end;
    end;
    s.curr := s.curr^.mynext;
  end;
  if bestp <> nil
    then begin
      p := bestp^;
      mate := true;
    end
    else
      mate := false;
end;

procedure flip (var e : TEdge);
var
  swp : TMyPoint;
begin
  swp := e.org;
  e.org := e.dest;
  e.dest := swp;
{
  rot (e);
  rot (e);
}
end;

procedure update1 ( var frontier : TMyListEdge; a, b : TMyPoint );
var
  e : MyListEdge;
  frontier_find : boolean;
begin
  new(e);
  e^.edge.org := a;
  e^.edge.dest := b;

  frontier_find := false;
  frontier.curr := frontier.head;
  while frontier.curr <> nil do begin
    if ( e^.edge.org.x = frontier.curr^.edge.org.x ) and
       ( e^.edge.org.y = frontier.curr^.edge.org.y ) and
       ( e^.edge.dest.x = frontier.curr^.edge.dest.x ) and
       ( e^.edge.dest.y = frontier.curr^.edge.dest.y )
         then begin
           frontier_find := true;
           e := frontier.curr;
           break;
         end;
    frontier.curr := frontier.curr^.mynext;
  end;

  if frontier_find then begin
      DeleteElement ( frontier, e );
    end
    else begin
      flip ( e^.edge );{}
      AddNext( frontier, e^.edge );
    end;
end;

function fWhere (p : TMyPoint; e : TEdge) : tLocate;
var
  ax, ay, bx, by : real;
  as1, as2, as0 : real;
  p1, p2 : TMyPoint;
begin
  p1 := e.org;
  p2 := e.dest;
  ax := (p2.x - p1.x);
  ay := (p2.y - p1.y);
  bx := (p.x - p1.x);
  by := (p.y - p1.y);
  as1 := ax * by;
  as2 := ay * bx;
  as0 := as1 - as2;
  if as0 < 0 then fWhere := tLeft else
   if as0 > 0 then fWhere := tRight else
    fWhere := tUnKnown;
end;

procedure AddTriangle(p1,p2,p3:TMyPoint);
var
  t : TTriangle;
begin
  t.v[0] := p1;
  t.v[1] := p2;
  t.v[2] := p3;
  if Triangle.triangles = 0
    then AddFirstT( Triangle, t )
    else AddNextT( Triangle, t );
end;

function InTriangle1(p : TMyPoint; t : TTRiangle) : boolean;
var
  e1, e2, e3 : TEdge;
begin
  with t do begin
    e1.org := v[0];  e1.dest := v[1];
    e2.org := v[1];  e2.dest := v[2];
    e3.org := v[2];  e3.dest := v[0];
  end;
  InTriangle1 := (fWhere(p,e1) = fWhere(p,e2)) and
                 (fWhere(p,e2) = fWhere(p,e3)) and
                 (fWhere(p,e1) = fWhere(p,e3));
end;

end.

