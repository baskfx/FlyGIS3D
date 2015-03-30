{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

uses crt, graph, dos;

type
  TPoint = record
    x, y, z : real;
  end;
  TTriangle = record
    v : array [0..2] of TPoint;
  end;
  TEdge = record
    org, dest : TPoint;
  end;
  TEnum = ( LEFT, RIGHT, BEYOND, BEHIND, BETWEEN, ORIGIN, DESTINATION,
            COLLINEAR, PARALLEL, SKEW_CROSS, SKEW_NO_CROSS );

  List=^my_list;
  my_list=record
    prev:List;
    next:List;
    edge : TEdge;
  end;
  TList=record
    head:List;
    curr:List;
    last:List;
    length : integer;
  end;

var
  gd, gm : integer;
  c : char;

  ft : text;
  n : integer;
  i, j : integer;
  triangles : integer;
  s : array [0..500] of TPoint;
  frontier : TList;
  triangle : array [1..500] of TTriangle;
  e : TEdge;
  p : TPoint;

  ss : string;
  a, r : real;
  ply : array [0..2] of PointType;
  x, y, z : real;
  mx, my : integer;
  h1, m1, s1, ms1,
  h2, m2, s2, ms2 : word;
  t1, t2, dt : longint;

  pOffsX,pOffsY,pminX,pmaxX,pminY,pmaxY:real;
  tOffsX,tOffsY,tOffsZ,tminX,tmaxX,tminY,tmaxY,tminZ,tmaxZ:real;
  scale:real;

procedure AddFirst ( var a : TList; c : TEdge );
begin
  new(a.curr);
  a.curr^.edge := c;
  a.curr^.next := nil;
  a.curr^.prev := nil;
  a.head := a.curr;
  a.last := a.curr;
  a.length := 1;
end;

procedure AddNext ( var a : TList; c : TEdge );
begin
  new(a.curr);
  a.curr^.edge := c;
  a.curr^.next := a.head;
  a.curr^.prev := nil;
  a.head^.prev := a.curr;
  a.head := a.curr;

  inc ( a.length );
end;

procedure DeleteElement ( var a : TList; d : List );
var
  a1, a2 : List;
begin
  a1 := d^.prev;
  a2 := d^.next;
  a1^.next := a2;
  a2^.prev := a1;
  if d = a.head then a.head := a2;
  if d = a.last then a.last := a1;
  if d <> nil then dispose( d );
  dec ( a.length );{}
end;

function p_length ( p : TPoint ) : real ;
begin
  p_length := sqrt ( p.x * p.x + p.y * p.y );
end;

function classify ( p2, p0, p1 : TPoint ) : TEnum;
var
  a, b : TPoint;
  sa : real;
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

procedure hullEdge ( s : array of TPoint; n : integer; var e : TEdge  );
var
  m, i : integer;
  swp : TPoint;
  c : TEnum;
begin
  m := 0;
  for i := 1 to n - 1 do
    if ( s[i].x < s[m].x ) and ( s[i].y < s[m].y ) then m := i;
  swp := s[0]; s[0] := s[m]; s[m] := swp;
  m := 1;
  for i := 2 to n - 1 do begin
    c := classify ( s[i], s[0], s[m] );
    if ( c = LEFT ) or ( c = BETWEEN ) then m := i;
  end;
  e.org := s[0];
  e.dest := s[m];
end;

procedure removeMin ( var frontier : TList; var e : TEdge );
var
  first : List;
begin
  {- returns first edge in the frontier -}
  {- and then its remove from the frontier -}
  first := frontier.head;
  e := first^.edge;
  DeleteElement ( frontier, first );
end;

procedure rot ( var e : TEdge );
var
  m, v, n : TPoint;
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

procedure intersect ( f, e : TEdge; var t : real );
var
  a, b, c, d, n, ba, ac : TPoint;
  denom, num : real;
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

function mate ( e : TEdge; s : array of TPoint; n : integer;
                var p : TPoint ) : boolean;
var
  t, bestt : real;
  bestp : ^TPoint;
  f, g : TEdge;
  i : integer;
begin
  bestp := nil;
  bestt := 1.7e+38;
  f := e;
  rot ( f );
  for i := 0 to n - 1 do begin
    if classify ( s[i], e.org, e.dest ) = RIGHT then begin
      g.org := e.dest;
      g.dest := s[i];
      rot ( g );
      intersect ( f, g, t );
      if t < bestt then begin
        bestp := @s[i];
        bestt := t;
      end;
    end;
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
begin
  rot (e);
  rot (e);
end;

procedure update1 ( var frontier : TList; a, b : TPoint );
var
  e : List;
  frontier_find : boolean;
begin
  new(e);
  e^.edge.org := a;
  e^.edge.dest := b;

  frontier_find := false;
  frontier.curr := frontier.head;
  while frontier.curr <> frontier.last do begin
    if ( e^.edge.org.x = frontier.curr^.edge.org.x ) and
       ( e^.edge.org.y = frontier.curr^.edge.org.y ) and
       ( e^.edge.dest.x = frontier.curr^.edge.dest.x ) and
       ( e^.edge.dest.y = frontier.curr^.edge.dest.y )
         then begin
           frontier_find := true;
           e := frontier.curr;
           break;
         end;
    frontier.curr := frontier.curr^.next;
  end;

  if frontier_find then begin
      DeleteElement ( frontier, e );
    end
    else begin
      flip ( e^.edge );{}
      AddNext( frontier, e^.edge );
    end;
end;

function IntToStr(n : integer) : string;
var
  s : string;
begin
  str(n,s);
  IntToStr := s;
end;

function StrToInt(s : string) : integer;
var
  n : integer;
  c : integer;
begin
  val(s,n,c);
  if c = 0  then StrToInt := n;
end;

procedure ReadData(s:string;from:integer;delimiter:char;
                   var data:string;var LastIndex:integer);
var
  i:integer;
begin
  s:=s+delimiter;
  i:=from;
  while i<=length(s) do begin
    LastIndex:=i;
    data:=copy(s,from,i-from);
    if s[i]=delimiter then exit;
    i:=i+1;
  end;
end;

procedure LoadPointsFrom_Mif_Mid(name:string);
var
  f, fMID : Text;
  col : integer;
  m, i, k : integer;
  MidString, FullMifString, MifString, MIDname, MIDz : string;
  x, y, z : real;
  ss, com : string;
  err : integer;
  columns, plines : integer;
begin
  Assign( f, name + '.MIF' );
  Reset( f );
  Assign( ft, name + '.trg' );
  Rewrite( ft );
{  Fname:=copy(name,1,length(name)-3);}
  MIDname := name + '.MID';
  Assign(fMID,MIDname);
  Reset(fMID);
  MifString:='';
  while MifString<>'Columns' do begin
    readln(f,FullMifString);
    MifString:=copy(FullMifString,1,7);
  end;
  columns:=StrToInt(copy(FullMifString,9,length(FullMifString)-8));
  m:=0;
  for i:=1 to columns do begin
    readln(f,FullMifString);
    ReadData(FullMifString,3,#32,MifString,k);
    if MifString='┬█╤╬╥└_└┴╤╬╦▐╥═└▀' then m:=i;
  end;
  m:=6;{,7}
  pminX:=1e+7;
  pminY:=1e+7;
  tminZ:=1e+7;
  pmaxX:=-1e+7;
  pmaxY:=-1e+7;
  tmaxZ:=-1e+7;
  n := 0;
  while not eof(f) do begin
   readln(f,com);
   if copy(com,1,5)='Pline' then begin
     plines := StrToInt(copy(com,6,length(com)-5));
     readln( fMID, MidString );
     ReadData( MidString, 1, ',', MIDz, k );
     for i:=2 to m do begin
       ReadData( MidString, k+1, ',', MIDz, k );
     end;
     MIDz:=copy(MIDz,2,length(MIDz)-2);
     val( MIDz, z, err );
     for i:=1 to plines do begin
       readln(f,x,y);
       y := y; {-invert Coordinate System !!!-}
       if x<pminX then pminX:=x;
       if x>pmaxX then pmaxX:=x;
       if z>tmaxZ then tmaxZ:=z;
       if y<pminY then pminY:=y;
       if y>pmaxY then pmaxY:=y;
       if z<tminZ then tminZ:=z;
       s[n].x := x;
       s[n].y := y;
       s[n].z := z;
       inc(n);
     end;
   end;{-if-}
  end;{-while-}
  pOffsX:=(pminX+pmaxX)/2;
  pOffsY:=(pminY+pmaxY)/2;
  tminX:=pminX;
  tminY:=pminY;
  tmaxX:=pmaxX;
  tmaxY:=pmaxY;
  tOffsX:=pOffsX;
  tOffsY:=pOffsY;
  tOffsZ:=(tminZ+tmaxZ)/2;
  Close(f);
  Close(fMID);
  scale:=(tmaxx-tminx)/400;
  for i := 0 to n - 1 do begin
    s[i].x := trunc((s[i].x-toffsx)/scale+320);
    s[i].y := trunc((s[i].y-toffsy)/scale+240);
    s[i].z := {s[i].z}i;
    putpixel(trunc(s[i].x), (trunc(s[i].y)),10);
  end;
end;

begin
  gd := detect;
  initgraph ( gd, gm ,'c:\tp7\bgi' );

  randomize;{}
{
  n := 500;
  setcolor ( 14 );
  for i := 0 to n - 1 do begin
    s[i].x := random * 640;
    s[i].y := random * 480;
    putpixel ( trunc(s[i].x), trunc(s[i].y), 10 );
  end;
{}
  LoadPointsFrom_Mif_Mid('c:\users\baskov\source\mapinfo\vulcan\vulcan');{}
{  LoadPointsFrom_Mif_Mid('c:\users\baskov\source\mapinfo\ravine\ravine');{}
{  LoadPointsFrom_Mif_Mid('c:\users\baskov\source\mapinfo\mifd2\mifd2');{}
{  LoadPointsFrom_Mif_Mid('c:\users\baskov\source\mapinfo\mifd1\mifd1');{}
{  LoadPointsFrom_Mif_Mid('c:\users\baskov\source\mapinfo\Terrain1\Terrain1');{}

  readkey;

{---}
  gettime(h1, m1, s1, ms1);
  t1 := longint(ms1)+longint(s1)*1000+longint(m1)*1000*60+longint(h1)*1000*60*60;

  hullEdge ( s, n, e );

  AddFirst( frontier, e );

  triangles := 0;

  while frontier.length > 0 do begin
    removeMin ( frontier, e );{- берём, а затем удаляем первое ребро из границы -}
    if keypressed then c := readkey;
    if c = #27 then exit;{}
    if mate ( e, s, n, p ) then begin
      update1 ( frontier, p, e.org ); {-  а) перевернуть и добавить, если ребра в границе нет; -}
      update1 ( frontier, e.dest, p );{-  б) либо удалить из границы, если таковое в ней находится -}

      SetColor(2);
      moveto ( trunc ( p.x ), trunc ( p.y ) );
      lineto ( trunc ( e.org.x ), trunc ( e.org.y ) );
      lineto ( trunc ( e.dest.x ), trunc ( e.dest.y ) );
      lineto ( trunc ( p.x ), trunc ( p.y ) );

      triangles := triangles + 1;
      with Triangle[triangles] do begin
        v[0] := (p);
        v[1] := (e.org);
        v[2] := (e.dest);
      end;
(*
      SetColor( random ( 16 ) );
      SetFillStyle ( 1, GetColor );
      DrawPoly (3, ply);
      FillPoly (3, ply);{}
(*
      mx:=(ply[0].x+ply[1].x+ply[2].x) div 3;
      my:=(ply[0].y+ply[1].y+ply[2].y) div 3;
      SetFillStyle(10,9);
{      FillPoly(3,ply);{}
      setcolor(15 - GetColor);
      str(i,ss);
      SetTextStyle(SmallFont,HorizDir,2);
      outtextxy(mx-4,my-4,ss);
*)
    end;
  end;

  gettime(h2, m2, s2, ms2);

  rewrite(ft);
  writeln(ft,triangles);
  for i:=1 to triangles do
    with Triangle[i] do begin
      for j := 0 to 2 do begin
        v[j].x := (v[j].x - 320) * scale + toffsx;
        v[j].y := (v[j].y - 240) * scale + toffsy;
        writeln(ft, v[j].x :0:7,' ', v[j].y :0:7,' ', v[j].z :0:7);
      end;
    end;
  Close(ft);

  t2 := longint(ms2)+longint(s2)*1000+longint(m2)*1000*60+longint(h2)*1000*60*60;
  dt := t2 - t1;
  readln;
  closegraph;

  writeln(t1);
  writeln(t2);
  writeln(dt,'ms = ',(dt mod 3600000) div 60000,' m ',
                     (dt mod 60000) div 1000,' s ',
                      dt mod 1000,' ms ');
end.
