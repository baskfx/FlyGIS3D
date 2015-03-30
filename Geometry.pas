unit Geometry;

interface

uses Geom1, Graphics, Windows;

type

  TCheckingType = ( CC_ONLY_INTEGER, CC_ONLY_FLOAT, CC_NUMBERS,
                CC_LETTERS, CC_ALL );

  BresenhamesLine = object
    InCanvas : TCanvas;
    p1, p2 : TPoint3D;
    linecolor : longint;
    negative : boolean;
    IsEnded : boolean;
    GetCurPoint : TPoint3D;

    dx, dy, sx, sy : integer;
    d, d1, d2 : integer;
    x, y, i : integer;

    constructor Init( x1, y1, x2, y2 : integer; vCanvas : TCanvas );
    procedure Negate;
    procedure NextMovement;
    procedure ShowLine ( col : longint );
    destructor Done;
  end;

procedure MakeNormal ( var n : TVector; p1, p2, p3 : TMyPoint);
function col_bounds( col0: TColor; b1, b2: byte; col: byte ): TColor;
function Correctness ( StringLine: string; CheckingType: TCheckingType ): boolean;

implementation

procedure HLine( vCanvas : TCanvas; x1, x2, y: Integer; c: Byte );
begin
  vCanvas.Pen.Color := RGB( c, c, c );
  vCanvas.MoveTo( x1, y );
  vCanvas.LineTo( x2, y );
end;

procedure DrawPoly( vCanvas : TCanvas; x1,y1, x2,y2, x3,y3: Integer; c: Byte);
var
  p1,p2,p3: TPoint3D;     {Die 3 Eckpunkte}
  ml, mr: LongInt;      {Steigungen der Dreiecksseiten}
  y: Integer;           {Laufvariable}
  xstart, xend: LongInt;{Anfang und Ende der horiz. Linie}
  xs, xe: Integer;
{
 ml / \ mr
   /  /
  / / mr
 //  }

BEGIN
  {Zuerst werden die Eckpunkte nach ihrer Y-Koordinate sortiert.
   p1.y >= p2.y >= p3.y}
  if y1 >= y2 then begin
    p1.x:=x2;
    p1.y:=y2;
    p3.x:=x1;
    p3.y:=y1;
  end
  else begin
    p1.x:=x1;
    p1.y:=y1;
    p3.x:=x2;
    p3.y:=y2;
  end;
  if (y3 >= p1.y) and (y3 <= p3.y) then begin  {Position ist in der Mitte}
    p2.x:=x3;
    p2.y:=y3;
  end
  else if y3 < p1.y then begin      {oberster Punkt}
    p2:=p1;
    p1.x:=x3;
    p1.y:=y3;
  end
  else if y3 > p3.y then begin      {unterster Punkt}
    p2:=p3;
    p3.x:=x3;
    p3.y:=y3;
  end;

  {Steigung der lÄngsten Geraden bestimmen nach der Formel
     x2-x1
  m= ------
     y2-y1 }

  {Falls das Dreieck eine Linie bildet}
  if (p3.y=p2.y) and (p3.y=p1.y) then
    exit;

  ml:=Trunc((p3.x - p1.x) SHL 16) div (p3.y - p1.y); {lÄngere Gerade}

  {Falls p1 und p2 die gleiche Y-Koordinate besitzen, zeichnet man nur eine
   horizontale Linie zwischen den Punkten. Das erste TeilstÁck besteht also
   praktisch aus einer Linie}
  if p2.y-p1.y <> 0 then begin
    {Steigung auf dem ersten TeilstÁck}
    mr:=Trunc((p2.x - p1.x) SHL 16) div (p2.y - p1.y);

    {erstes TeilstÁck zeichnen}
    xstart:=p1.x SHL 16;
    xend:=p1.x SHL 16;
    HLine ( vCanvas, p1.x, p1.x, p1.y, c );
    for y:=p1.y+1 to p2.y do begin  {Zeilenweise Linien zeichnen}
      Inc(xstart,ml);
      Inc(xend,mr);
      HLine ( vCanvas, xstart SHR 16, xend SHR 16, y, c );
    end;
  end

  else begin {Das erste TeilstÁck war eine Linie}
    xstart:=p1.x shl 16;
    xend:=p2.x shl 16;
    HLine ( vCanvas, p1.x, p2.x, p1.y , c );
  end;

  {Falls P3 und P2 die gleiche Y-Koordinate haben, nur eine horiz. Linie
   zeichnen}
  if p3.y-p2.y <> 0 then begin
    {Steigung auf dem zweiten TeilstÁck berechnen}
    mr:=((p3.x - p2.x) SHL 16) div (p3.y - p2.y);
    for y:=p2.y+1 to p3.y do begin
      Inc(xstart,ml);
      Inc(xend,mr);
      HLine ( vCanvas, xstart SHR 16, xend SHR 16, y, c );
    end;
  end
  {Das zweite TeilstÁck ist eine Linie}
  else
    HLine ( vCanvas, p2.x, p3.x, p2.y, c );
END;

constructor BresenhamesLine.Init ( x1, y1, x2, y2 : integer; vCanvas : TCanvas );
begin
  InCanvas := vCanvas;
  Negative := false;
  IsEnded := false;

  p1.x := x1;
  p1.y := y1;
  p1.z := InCanvas.Pixels [ x1, y1 ] and $ff;
  p2.x := x2;
  p2.y := y2;
  p2.z := InCanvas.Pixels [ x2, y2 ] and $ff;

  dx := abs ( x2 - x1 );
  dy := abs ( y2 - y1 );
  if x2 >= x1
    then sx := 1
    else sx :=-1;
  if y2 >= y1
    then sy := 1
    else sy :=-1;
  if dy <= dx then begin
    d1 := dy shl 1;
    d := ( d1 ) - dx;
    d2 := ( dy - dx ) shl 1;
    GetCurPoint.x := p1.x;
    GetCurPoint.y := p1.y;
    GetCurPoint.z := p1.z;
    x := p1.x + sx;
    y := p1.y;
    i := 1;
  end
  else begin
    d1 := dx shl 1;
    d := ( d1 ) - dy;
    d2 := ( dx - dy ) shl 1;
    GetCurPoint.x := p1.x;
    GetCurPoint.y := p1.y;
    GetCurPoint.z := p1.z;
    x := p1.x;
    y := p1.y + sy;
    i := 1;
  end;

end;

procedure BresenhamesLine.Negate;
var
  vd, vx, vy, vi : integer;
  c : longint;
begin

  Negative := not Negative;

  vd := d;
  vi := i;
  vx := x;
  vy := y;

  if dy <= dx then begin
    while vi <= dx do begin
      if vd > 0 then begin
        vd := vd + d2;
        vy := vy + sy;
      end
      else vd := vd + d1;
      c :=  255 - ( InCanvas.Pixels [ vx, vy ] and $ff );
      InCanvas.Pixels [ vx, vy ] := RGB ( c, c, c );
      vi := vi + 1;
      vx := vx + sx;
    end
  end
  else begin
    while vi <= dy do begin
      if vd > 0 then begin
        vd := vd + d2;
        vx := vx + sx;
      end
      else vd := vd + d1;
      c :=  255 - ( InCanvas.Pixels [ vx, vy ] and $ff );
      InCanvas.Pixels [ vx, vy ] := RGB ( c, c, c );
//      c :=  clWhite - InCanvas.Pixels [ vx, vy ];
//      varCanvas.Pixels [ vx, vy ] := c;
      vi := vi + 1;
      vy := vy + sy;
    end
  end;

end;

procedure BresenhamesLine.NextMovement;
begin
  if dy <= dx then begin
    IsEnded := not ( i <= dx );
    if not IsEnded then begin
      if d > 0 then begin
        d := d + d2;
        y := y + sy;
      end
      else d := d + d1;
      GetCurPoint.x := x;
      GetCurPoint.y := y;
      GetCurPoint.z := ( p1.z + ( p2.z - p1.z ) * i / dx );
      i := i + 1;
      x := x + sx;
    end
  end
  else begin
    IsEnded := not ( i <= dy );
    if not IsEnded then begin
      if d > 0 then begin
        d := d + d2;
        x := x + sx;
      end
      else d := d + d1;
      GetCurPoint.x := x;
      GetCurPoint.y := y;
      GetCurPoint.z := ( p1.z + ( p2.z - p1.z ) * i / dy );
      i := i + 1;
      y := y + sy;
    end
  end;
end;

procedure BresenhamesLine.ShowLine ( col : longint );
var
  vd, vx, vy, vi : integer;
begin

  vd := d;
  vi := i;
  vx := x;
  vy := y;

  if dy <= dx then begin
    while vi <= dx do begin
      if vd > 0 then begin
        vd := vd + d2;
        vy := vy + sy;
      end
      else vd := vd + d1;
      InCanvas.Pixels [ vx, vy ] := RGB ( col, col, col );
      vi := vi + 1;
      vx := vx + sx;
    end
  end
  else begin
    while vi <= dy do begin
      if vd > 0 then begin
        vd := vd + d2;
        vx := vx + sx;
      end
      else vd := vd + d1;
      InCanvas.Pixels [ vx, vy ] := RGB ( col, col, col );
      vi := vi + 1;
      vy := vy + sy;
    end
  end;
end;

destructor BresenhamesLine.Done;
begin
end;

procedure MakeNormal ( var n : TVector; p1, p2, p3 : TMyPoint );
var
  d : real;
  a, b : TVector;
begin
  a.x := p1.x - p2.x;
  a.y := p1.y - p2.y;
  a.z := p1.z - p2.z;
  b.x := p3.x - p2.x;
  b.y := p3.y - p2.y;
  b.z := p3.z - p2.z;
  n.x := a.x * b.y - a.y * b.x;
  n.y := a.z * b.x - a.x * b.z;
  n.z := a.y * b.z - a.z * b.y;
  d := sqrt ( n.x * n.x + n.y * n.y + n.z * n.z );
  if d = 0 then d := 1;
  n.x := n.x / d;
  n.y := n.y / d;
  n.z := n.z / d;
end;

function col_bounds( col0: TColor; b1, b2: byte; col: byte ): TColor;
var
  r, g, b: byte;
begin
  r := col0 and $ff;
  r := trunc( r / 255 * (integer( b2 - b1 ) * col / 255 + b1) );
  g := ( col0 and $ff00 ) shr 8;
  g := trunc( g / 255 * (integer( b2 - b1 ) * col / 255 + b1) );
  b := ( col0 and $ff0000 ) shr 16;
  b := trunc( b / 255 * (integer( b2 - b1 ) * col / 255 + b1) );
  col_bounds := r or ( g shl 8 ) or ( b shl 16 );
end;

function Correctness ( StringLine: string; CheckingType: TCheckingType ): boolean;
var
  i: integer;
  correct: boolean;
  c: char;
begin
  correct := true;
  for i := 1 to length ( StringLine ) do begin
    c := StringLine[i];
    case CheckingType of
      CC_ONLY_INTEGER: correct := correct and ( c in ['0'..'9','-'] );
      CC_ONLY_FLOAT: correct := correct and ( c in ['0'..'9','-',','] );
      CC_NUMBERS: correct := correct and ( c in ['0'..'9','-',','] );
      CC_LETTERS: correct := correct and ( c in ['A'..'Z','a'..'z','À'..'ß','à'..'ÿ'] );
      CC_ALL: correct := true;
    end;
    if not correct then break;
  end;
  Correctness := correct;
end;

end.
