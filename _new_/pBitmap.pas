unit pBitmap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, pFlyGIS3D, Geom1, Geometry, Menus;

type
  TBitmapForm = class(TForm)
    Image1: TImage;
    PopMnuTraektory: TPopupMenu;
    PopMnuEnding: TMenuItem;
    PopMnuDelete: TMenuItem;
    PopMnuUndo: TMenuItem;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MyCircle(x,y:real;r:integer);
    function GetBM_X( MapInfo_X : real ):integer; // из СК MapInfo в СК Bitmap
    function GetBM_Y( MapInfo_Y : real ):integer;
    function GetMI_X( Bitmap_X : integer ) : real;
    function GetMI_Y( Bitmap_Y : integer ) : real;
    procedure ClearLastTraektoryLine;
    procedure ClearTraektory2D;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopMnuEndingClick(Sender: TObject);
    procedure PopMnuDeleteClick(Sender: TObject);
    procedure PopMnuUndoClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BitmapForm: TBitmapForm;

  points: integer;
  Traektory2D : array [ 1..1000 ] of TPoint;
  vX, vY, oldX, oldY, x1, y1, x2, y2: integer;
  t1, t2 : TPoint3D;

implementation

uses pTraektoryForm, pCamera, pSetup, FormCopy, Visio_1, pTraektTable;

{$R *.DFM}

function TBitmapForm.GetBM_X( MapInfo_X : real ):integer;
var
//  scale : real;
  w : integer;
begin
  w := Image1.Width;
  Result := trunc(w * ( ( MapInfo_X - Point.minX ) / ( Point.maxX - Point.minX ) ));
//  scale := ( Point.maxX - Point.minX ) / w;
//  GetX := trunc ( ( x - tOffsX ) / scale + w / 2 );
end;

function TBitmapForm.GetBM_Y( MapInfo_Y : real ):integer;
var
//  scale : real;
  h : integer;
begin
  h := Image1.Height;
  Result := trunc(h * ( ( - MapInfo_Y - Point.minY ) / ( Point.maxY - Point.minY ) ));
//  scale := ( Point.maxY - Point.minY ) / h;
//  GetY := trunc ( ( - y - tOffsY ) / scale + h / 2 );
end;

function TBitmapForm.GetMI_X( Bitmap_X : integer ) : real;
var
//  scale : real;
  w : integer;
begin
  w := Image1.Width;
  Result := ( Point.maxX - Point.minX ) * Bitmap_X / w + Point.minX;
//  scale := ( Point.maxX - Point.minX ) / w;
//  GetX_1 := ( X - w / 2 ) * scale + tOffsX;
end;

function TBitmapForm.GetMI_Y( Bitmap_Y : integer ) : real;
var
//  scale : real;
  h : integer;
begin
  h := Image1.Height;
  Result := ( ( Point.maxY - Point.minY ) * Bitmap_Y / h + Point.minY);
//  scale := ( Point.maxY - Point.minY ) / h;
//  GetY_1:= - ( ( Y - h / 2 ) * scale + tOffsY );
end;

procedure TBitmapForm.MyCircle ( x, y : real; r : integer );
begin
  Image1.Canvas.Ellipse ( GetBM_X ( x ) - r, GetBM_Y ( y ) - r,
                          GetBM_X ( x ) + r, GetBM_Y ( y ) + r );
end;

procedure TBitmapForm.ClearLastTraektoryLine;
begin
  if points > 1 then begin
    t1.x := Traektory2D[ points - 1 ].x;
    t1.y := Traektory2D[ points - 1 ].y;
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points - 1 ].x, Traektory2D [ points - 1 ].y );
    Image1.Canvas.LineTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
{    NegLine.Init ( Traektory2D[ points - 1 ].x, Traektory2D[ points - 1 ].y,
      Traektory2D[ points ].x, Traektory2D[ points ].y, BitmapForm.Image1.Canvas );
    NegLine.Negate;// clearing...
    NegLine.Done;}
  end;
  if points > 0
    then dec ( points );
  if points = 0
    then MainForm.MnuUndo.Enabled := false;
  TrPoints := points;
end;

procedure TBitmapForm.ClearTraektory2D;
var
  i : integer;
begin
  points := TrPoints;
  for i := points downto 2 do
    ClearLastTraektoryLine;
  points := 0;
  TrPoints := 0;
  angle := 0;
  trace := 0;
  step := 0;
  MainForm.MnuUndo.Enabled := false;
//  PopMnuUndo.Enabled := false;
end;

procedure TBitmapForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  c : byte;
  z : real;
  bz : real;
//  NegLine : BresenhamesLine;
begin
  if SetObscurePoint then begin
    ObscurePoint.x := BitmapForm.GetMI_X ( X );
    ObscurePoint.y := BitmapForm.GetMI_Y ( Y );
    c := ( CopyForm.Image1.Canvas.Pixels [ X , Y ] and $ff );
    z := ( Point.maxZ - Point.minZ ) * c / 255 + Point.minZ;
    ObscurePoint.z := z;
    SeeToPoint := true;
    SetObscurePoint := false;
    Screen.Cursor := crDefault;
  end;
  if SetVisiblePoint or SetVisibleLine then begin
    vX := trunc( VisiblePoint.x );
    vY := trunc( VisiblePoint.y );
    VisiblePoint.x := X;
    VisiblePoint.y := Y;
    c := ( CopyForm.Image1.Canvas.Pixels [ X , Y ] and $ff );
    VisiblePoint.z := c;
    SetVisiblePoint := false;
    if not SetVisibleLine
      then Screen.Cursor := crDefault
      else ClearVisibleLine := True;
  end;
  if SetTraektory then begin
    if Shift = [ ssLeft ] then begin
      if ( X <> Traektory2D [ TrPoints ].x ) and
         ( Y <> Traektory2D [ TrPoints ].y )
        then begin
          inc ( points );
          TrPoints := points;
          Traektory2D [ TrPoints ].x := X;
          Traektory2D [ TrPoints ].y := Y;
          Traektory [ TrPoints ].x := GetMI_X ( X );
          Traektory [ TrPoints ].y := GetMI_Y ( Y );
          bz := ( CopyForm.Image1.Canvas.Pixels [ X, Y ] and $ff );
          bz := ( Point.maxZ - Point.minZ ) * bz / 255 + Point.minZ + h0;
          Traektory[TrPoints].z :=  bz;
          TableForm.StringGrid1.RowCount := TrPoints + 1;
          TableForm.StringGrid1.Cells[1,TrPoints] := FloatToStr( Traektory[TrPoints].x );
          TableForm.StringGrid1.Cells[2,TrPoints] := FloatToStr( Traektory[TrPoints].y );
          TableForm.StringGrid1.Cells[3,TrPoints] := FloatToStr( Traektory[TrPoints].z );

          if points = 1 then begin
            t1.x := X;
            t1.y := Y;
          end else begin
            MainForm.MnuUndo.Enabled := true;
            t2.x := X;
            t2.y := Y;
    {        NegLine.Init ( t1.x, t1.y, t2.x, t2.y, BitmapForm.Image1.Canvas );
            NegLine.Negate;
            NegLine.Done;}
            t1 := t2;
          end; // else
        end;
      oldX := X;
      oldY := Y;
    end; // ssLeft
    Visio1.FormResize ( Sender );
  end; // SetTraektory
end;

procedure TBitmapForm.FormPaint(Sender: TObject);
begin
  points := 0;
end;

procedure TBitmapForm.FormCreate(Sender: TObject);
begin
  Image1.AutoSize := false;
  if Image1.Width < Image1.Height
    then Image1.Height := trunc( ClientWidth  / RatioXY )
    else Image1.Width  := trunc( ClientHeight * RatioXY );
  Image1.Picture.Create;
  Image1.Picture.Bitmap.Create;
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  points := 0;
  Image1.Canvas.Pen.Mode := pmXOR;
  Image1.Canvas.Pen.Color := clWhite;
end;

procedure TBitmapForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BitmapForm.Image1.AutoSize := false;
  MainForm.MnuBitmap.Checked := false;
end;

procedure TBitmapForm.PopMnuEndingClick(Sender: TObject);
//var  NegLine : BresenhamesLine;
begin
  if points > 0 then begin
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( oldX, oldY );
{    NegLine.Init ( Traektory2D [ points ].x, Traektory2D [ points ].y, oldX, oldY, BitmapForm.Image1.Canvas );
    NegLine.Negate;// ( BitmapForm.Image1.Canvas );
    NegLine.Done;}
    inc ( points );
    TrPoints := points;
    Traektory2D [ TrPoints ] := Traektory2D [ 1 ];
    Traektory [ TrPoints ] := Traektory [ 1 ];
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points - 1 ].x, Traektory2D [ points - 1 ].y );
    Image1.Canvas.LineTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
{    NegLine.Init ( Traektory2D [ TrPoints - 1 ].x, Traektory2D [ TrPoints - 1 ].y,
      Traektory2D [ TrPoints ].x, Traektory2D [ TrPoints ].y, BitmapForm.Image1.Canvas );
    NegLine.Negate;// ( BitmapForm.Image1.Canvas );
    NegLine.Done;}
    Screen.Cursor := crDefault;
    points := 0;
    SetTraektory := false;
    GDIFlush;
  end;
  MainForm.TBSetTraektory.Down := False;
end;

procedure TBitmapForm.PopMnuDeleteClick(Sender: TObject);
begin
//  points := TrPoints;
  if points > 0 then begin
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( oldX, oldY );
  end;
  ClearTraektory2D;
end;

procedure TBitmapForm.PopMnuUndoClick(Sender: TObject);
begin
  if points > 0 then begin
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( oldX, oldY );
  end;
  ClearLastTraektoryLine;
  if points > 0 then begin
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( oldX, oldY );
  end;
  GDIFlush;
end;

procedure TBitmapForm.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  A: BresenhamesLine;
  p, v: TPoint3D;
  k: integer;
  visibility : boolean;
  col32 : longint;
  col8 : byte;
  v1, v2 : TMyPoint;
  dx, dy, dz, tmin, tmax, scale: real;
begin
  k := ( CopyForm.Image1.Canvas.Pixels [ X, Y ] and $ff );
  dz := ( Point.maxZ - Point.minZ ) * k / 255 + Point.minZ;
  MainForm.StatusBar1.Panels[3].Text := 'X='+FloatToStr( GetMI_X ( X ));
  MainForm.StatusBar1.Panels[4].Text := 'Y='+FloatToStr( GetMI_Y ( Y ));
  MainForm.StatusBar1.Panels[5].Text := 'Z='+FloatToStr( dz );

  if ( TrPoints <> 0 ) and SetTraektory then begin
    Image1.Canvas.Pen.Mode := pmXOR;
    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( oldX, oldY );
{    NegLine.Init ( Traektory2D [ TrPoints ].x, Traektory2D [ TrPoints ].y, oldX, oldY, BitmapForm.Image1.Canvas );
    NegLine.Negate;// ( BitmapForm.Image1.Canvas );
    NegLine.Done;}
    Image1.Canvas.MoveTo ( Traektory2D [ points ].x, Traektory2D [ points ].y );
    Image1.Canvas.LineTo ( X, Y );
{    NegLine.Init ( Traektory2D [ TrPoints ].x, Traektory2D [ TrPoints ].y, X, Y, BitmapForm.Image1.Canvas );
    NegLine.Negate;// ( BitmapForm.Image1.Canvas );
    NegLine.Done;}
    GDIFlush;
    oldX := X;
    oldY := Y;
  end;

  if ClearVisibleLine then begin
      if ( OldX <> 0 ) or ( OldY <> 0 ) then begin
        v.x := vX;
        v.y := vY;
        v.z := ( CopyForm.Image1.Canvas.Pixels [ v.x , v.y ] and $ff );
        A.Init ( v.x, v.y, OldX, OldY, CopyForm.Image1.Canvas );
        col32 := CopyForm.Image1.Canvas.Pixels[ OldX, OldY ];
        col8 := col32 shr 16;
        visibility := true;
          while not A.IsEnded do begin
            A.NextMovement;
            p := A.GetCurPoint;
//            case SeeFrom of
//              0: p.z := p.z + 255 * h0 / ( Point.maxZ - Point.minZ );
            p.z := p.z + ManHeight;
//            end;
            k := ( CopyForm.Image1.Canvas.Pixels [ p.X , p.Y ] shr 16 );
            visibility := ( k <= p.z ) and visibility;
            if not visibility
              then Image1.Canvas.Pixels[ p.x, p.y ] := clRed
              else Image1.Canvas.Pixels[ p.x, p.y ] := clGreen;
          end;
    end;
    ClearVisibleLine := false;
    OldX := 0;
    OldY := 0;
  end;// clearing

  if (( VisiblePoint.x <> 0 ) or
      ( VisiblePoint.y <> 0 ) or
      ( VisiblePoint.z <> 0 )) and
      SetVisibleLine then begin

      // стираем старое
      if ( OldX <> 0 ) or ( OldY <> 0 ) then begin
        v.x := vX;
        v.y := vY;
        v.z := ( CopyForm.Image1.Canvas.Pixels [ v.x , v.y ] and $ff );
        A.Init ( v.x, v.y, OldX, OldY, CopyForm.Image1.Canvas );
        col32 := CopyForm.Image1.Canvas.Pixels[ OldX, OldY ];
        col8 := col32 shr 16;
        visibility := true;
          while not A.IsEnded do begin
            A.NextMovement;
            p := A.GetCurPoint;
//            case SeeFrom of
//              0: p.z := p.z + 255 * h0 / ( Point.maxZ - Point.minZ );
            p.z := p.z + ManHeight;
//            end;
            k := ( CopyForm.Image1.Canvas.Pixels [ p.X , p.Y ] shr 16 );
            visibility := ( k <= p.z ) and visibility;
            if not visibility
              then Image1.Canvas.Pixels[ p.x, p.y ] := clRed
              else Image1.Canvas.Pixels[ p.x, p.y ] := clGreen;
          end;
      end;

      v.x := trunc ( VisiblePoint.x );
      v.y := trunc ( VisiblePoint.y );
      v.z := ( CopyForm.Image1.Canvas.Pixels [ v.x , v.y ] and $ff );
      vX := trunc ( VisiblePoint.x );
      vY := trunc ( VisiblePoint.y );

      A.Init ( v.x, v.y, X, Y, CopyForm.Image1.Canvas );
      col32 := CopyForm.Image1.Canvas.Pixels[ X, Y ];
      col8 := col32 shr 16;
      visibility := true;
        while not A.IsEnded do begin
          A.NextMovement;
          p := A.GetCurPoint;
//            case SeeFrom of
//              0: p.z := p.z + 255 * h0 / ( Point.maxZ - Point.minZ );
            p.z := p.z + ManHeight;
//            end;
          k := ( CopyForm.Image1.Canvas.Pixels [ p.X , p.Y ] shr 16 );
          visibility := ( k <= p.z ) and visibility;
          if not visibility then begin
            Image1.Canvas.Pixels[ p.x, p.y ] := clRed;
//            A.IsEnded := true;
//            break;
          end
          else Image1.Canvas.Pixels[ p.x, p.y ] := clGreen;
        end;
      if visibility
        then MainForm.StatusBar1.Panels[1].Text := 'Видно'
        else MainForm.StatusBar1.Panels[1].Text := 'Не видно';
      A.Done;
      GDIFlush;
      OldX := X;
      OldY := Y;

    dx := Point.maxX - Point.minX;
    dy := Point.maxY - Point.minY;
    dz := Point.maxZ - Point.minZ;
    if dx > dy then tmax := dx
     else
      if dy > dz then tmax := dy
       else tmax := dz;
    if dx <= dy then tmin := dx
     else
      if dy <= dz then tmin := dy
       else tmin := dz;
//    scale := ( tmax - tmin ) / 0.008811 / MainForm.Width;
    v1.x := BitmapForm.GetMI_X ( trunc(VisiblePoint.x) );
    v1.y := BitmapForm.GetMI_Y ( trunc(VisiblePoint.y) );
    k := ( CopyForm.Image1.Canvas.Pixels [ trunc(VisiblePoint.x) , trunc(VisiblePoint.y) ] and $ff );
//    case SeeFrom of
//      0: v1.z := ( Point.maxZ - Point.minZ ) * k / 255 + Point.minZ + h0;
    v1.z := ( Point.maxZ - Point.minZ ) * (k + ManHeight) / 255 + Point.minZ;
///    end;
    v2.x := BitmapForm.GetMI_X ( X );
    v2.y := BitmapForm.GetMI_Y ( Y );
    k := ( CopyForm.Image1.Canvas.Pixels [ X , Y ] and $ff );
    v2.z := ( Point.maxZ - Point.minZ ) * k / 255 + Point.minZ;

    ObscurePoint := v2; // сейчас-это временно, потом поменять обязательно, иначе будет БАГ

    Visio1.SeeFromV1toV2( v1, v2, True{?} );

    if Show2DProjection
      then Visio1.DrawScan( v1.x, v1.y, v1, v2 );

  end;
end;

end.

