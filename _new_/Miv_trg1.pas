
const
  SizeX = 630;
  SizeY = 400;

type
  TPoint = record
    x, y, z : real;
  end;
  TVector = TPoint;
  TEdge = record
    org,dest : TPoint;
  end;
  tLocate = (tLeft,tRight,tUnknown);
  TTriangle = record
    pp : array [1..3] of TPoint;
  end;

var
{  fm1 : pImFileMatrix; {}
  vm1 : pScrBGI8Matrix;
  ft : text;
  i, j, n : integer;
  colstr : string;
  col : byte;
  minX, minY, minZ, maxX, maxY, maxZ : real;
  Triangle : array [1..1000] of TTriangle;
  last : integer;
  z : real;
  step, find : integer;
  mb, ms, mx, my : word;
  filename : string;
  zi, x1, x2, y1, y2, x, y : integer;
  dx, dy, d : real;
  c : char;

procedure line1 (x1, y1, x2, y2 : real);
var
  x_1, y_1, x_2, y_2 : integer;
begin
  x_1 := trunc( ( SizeX - 1 ) * ( (x1 - minX ) / ( maxX - minX ) ) );
  y_1 := trunc( ( SizeY - 1 ) * ( (y1 - minY ) / ( maxY - minY ) ) );
  x_2 := trunc( ( SizeX - 1 ) * ( (x2 - minX ) / ( maxX - minX ) ) );
  y_2 := trunc( ( SizeY - 1 ) * ( (y2 - minY ) / ( maxY - minY ) ) );
  line (x_1, y_1, x_2, y_2);
end;

procedure putpixel1 (x, y : real; color : byte);
var
  xx, yy : integer;
begin
  xx := trunc( ( SizeX - 1 ) * ( (x - minX ) / ( maxX - minX ) ) );
  yy := trunc( ( SizeY - 1 ) * ( (y - minY ) / ( maxY - minY ) ) );
  putpixel ( xx, yy, color );
end;

function fWhere (p : TPoint; e : TEdge) : tLocate;
var
  ax, ay, bx, by : real;
  as1, as2, as0 : real;
  p1, p2 : TPoint;
begin
  p1 := e.org;
  p2 := e.dest;
  ax := (p2.x - p1.x) * 10;
  ay := (p2.y - p1.y) * 10;
  bx := (p.x - p1.x) * 10;
  by := (p.y - p1.y) * 10;
  as1 := ax * by;
  as2 := ay * bx;
  as0 := as1 - as2;
  if as0 < 0 then fWhere := tLeft else
   if as0 > 0 then fWhere := tRight else
    fWhere := tUnKnown;
end;

function InTriangle1(p:TPoint; k : integer):boolean;
var
  e1, e2, e3 : TEdge;
begin
  with Triangle[k] do begin
    e1.org := pp[1];  e1.dest := pp[2];
    e2.org := pp[2];  e2.dest := pp[3];
    e3.org := pp[3];  e3.dest := pp[1];
  end;
  InTriangle1:=(fWhere(p,e1)=fWhere(p,e2)) and
              (fWhere(p,e2)=fWhere(p,e3)) and
              (fWhere(p,e1)=fWhere(p,e3));
end;

procedure Normalize(var v : TVector);
var d : real;
begin
  d := sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  if d<>0 then begin
    v.x := v.x/d;
    v.y := v.y/d;
    v.z := v.z/d;
  end;
end;

function GetTriangleColor( x, y : integer; printing : boolean; var z : real; var find : integer) : byte;
var
  i : integer;
  p : TPoint;
  xx, yy : real;
  col : byte;
  d : real;
  a, b, c, nv : TVector;
  e : TEdge;
begin
  xx := minX + x * ( maxX - minX ) / ( SizeX - 1 );
  yy := minY + y * ( maxY - minY ) / ( SizeY - 1 );
  p.x := xx;
  p.y := yy;
  find := 0;
  if InTriangle1( p, last ) then begin
    find := last;
  end else
  for i := 1 to n do begin
    if InTriangle1( p, i ) then begin
      find := i;
      last := i;
      break;
   end;
  end;
  if find<>0 then begin
    {-интерполяция координаты Z по плоскости треугольника-}
    with Triangle[find] do begin
      a.x := pp[2].x - pp[1].x;
      a.y := pp[2].y - pp[1].y;
      a.z := pp[2].z - pp[1].z;
      b.x := pp[3].x - pp[1].x;
      b.y := pp[3].y - pp[1].y;
      b.z := pp[3].z - pp[1].z;
      nv.x :=   a.y * b.z - a.z * b.y;
      nv.y := -(a.x * b.z - a.z * b.x);
      nv.z :=   a.x * b.y - a.y * b.x;
      d := - pp[1].x * nv.x - pp[1].y * nv.y - pp[1].z * nv.z;
    end;
    Z := ( - xx * nv.x - yy * nv.y - d ) / nv.z; {-type A-}
    GetTriangleColor := trunc( 255 * ( ( Z - minZ ) / ( maxZ - minZ ) ) );
  end;
end;

begin
  New(vm1,Init(800, 800, 0, 0, 2, 0, nil));
{  New(fm1,Init(0, 0, 'c:\users\baskov\source\mapinfo\mapinfo1.i$', of_write));{-create the new file-}

  last := 0;

  assign(ft, 'c:\users\554\baskov\source\mapinfo\vulcan\vulcan.trg');{}
  assign(ft, 'c:\users\554\baskov\source\mapinfo\ravine\ravine.trg');{}
  reset(ft);
  readln(ft, n);
  maxX := - MaxInt;
  maxY := - MaxInt;
  maxZ := - MaxInt;
  minX := MaxInt;
  minY := MaxInt;
  minZ := MaxInt;

  for i := 1 to n do
    with Triangle[i] do begin
      for j := 1 to 3 do begin
        readln(ft, pp[j].x, pp[j].y, pp[j].z );
        if pp[j].x > maxX then maxX := pp[j].x;
        if pp[j].y > maxY then maxY := pp[j].y;
        if pp[j].z > maxZ then maxZ := pp[j].z;
        if pp[j].x < minX then minX := pp[j].x;
        if pp[j].y < minY then minY := pp[j].y;
        if pp[j].z < minZ then minZ := pp[j].z;
      end;
    end;
  close(ft);

  setcolor(111);
  for i:=1 to n do
    with Triangle[i] do begin
      line1(pp[1].x, pp[1].y, pp[2].x, pp[2].y);
      line1(pp[2].x, pp[2].y, pp[3].x, pp[3].y);
      line1(pp[3].x, pp[3].y, pp[1].x, pp[1].y);{}
    end;

  for j := 0 to SizeY - 1 do
    for i := 0 to SizeX - 1 do begin
      col := GetTriangleColor(i, j, false, z, find);
      putpixel(i, j, col);
{      fm1^.PutDot(j, i, col); {-write to the file-}
    end;
    mx := mx div 2;
    col := GetTriangleColor(mx, my, true, z, find);
    if ( mx < SizeX ) and ( my < SizeY ) and ( mx > 0 ) and ( my > 0 )
      then begin
        setfillstyle ( 1, col );
        bar(SizeX + 5, 0, SizeX + 5 + 10, 5);
      end;

  readln;
  x1 := 0;
  x2 := 0;
  y1 := 0;
  y2 := SizeY;
  repeat
{    x1 := random(SizeX);
    y1 := random(SizeY);
    x2 := random(SizeX);
    y2 := random(SizeY);{}
    if c = '1' then begin
      x1 := x1 - 1;
      x2 := x2 - 1;
      y1 := 0;
      y2 := SizeY;
    end;
    if c = '3' then begin
      x1 := x1 + 1;
      x2 := x2 + 1;
      y1 := 0;
      y2 := SizeY;
    end;

    dx := x2 - x1;
    dy := y2 - y1;
    d := sqrt ( dx * dx + dy * dy );
    dx := dx / d;
    dy := dy / d;
    setcolor ( 128 );
    line( 0, SizeY + 50, trunc ( d ), SizeY + 50 );
    for i:= 0 to trunc( d ) do begin
      x := trunc ( x1 + i * dx );
      y := trunc ( y1 + i * dy );
      col := getpixel ( x, y );
      zi := trunc ( col / 255 * 50 );
      setcolor ( 255 );
      if i = 0 then MoveTo ( i, SizeY + 50 - zi )
               else LineTo ( i, SizeY + 50 - zi );
      putpixel ( i, SizeY + 51, col );
    end;
    for i:= 0 to trunc( d ) do begin
      x := trunc ( x1 + i * dx );
      y := trunc ( y1 + i * dy );
      col := getpixel ( x, y );
      putpixel ( x, y, 255 - col );
    end;
    c := readkey;
    setcolor ( 0 );
    line( 0, SizeY + 50, trunc ( d ), SizeY + 50 );
    for i:= 0 to trunc( d ) do begin
      x := trunc ( x1 + i * dx );
      y := trunc ( y1 + i * dy );
      col := getpixel ( i, SizeY + 51 );
      zi := trunc ( col / 255 * 50 );
      setcolor ( 0 );
      if i = 0 then MoveTo ( i, SizeY + 50 - zi )
               else LineTo ( i, SizeY + 50 - zi );
      putpixel ( i, SizeY + 51, 0 );
      putpixel ( x, y, col );
    end;
  until c = #27;

  step := 30;
  for j := 0 to SizeY - 1 do
    for i := 0 to SizeX - 1 do begin
      col := getpixel( i, j );
      col := col div step * step;
      putpixel(i, j, col);
    end;
  readln;

  for j := 0 to SizeY - 1 do
    for i := 0 to SizeX - 1 do begin
      if ( getpixel( i + 1, j ) <> getpixel( i, j ) ) or
         ( getpixel( i, j + 1 ) <> getpixel( i, j ) )
         then putpixel( i, j, 255 )
         else putpixel( i, j, 000 );
    end;
  readln;

  Dispose(vm1,Done);
end.
