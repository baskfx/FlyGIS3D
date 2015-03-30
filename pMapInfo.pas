unit pMapInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Geom1, PM_Messages;

type
  TMapInfoForm = class(TForm)
    Image1: TImage;
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Centered;
    procedure CropPoints ( var Point : TMyListPoint );
    procedure DrawPoints( Point : TMyListPoint );
    procedure DrawTriangles ( Triangle : TMyListTriangle );
    procedure DrawIsolines ( Triangle : TMyListTriangle );
    procedure Bounds( x1, y1, x2, y2 : integer; var Point : TMyListPoint );
    { Public declarations }
  end;

var
  MapInfoForm: TMapInfoForm;
  ActionMode: TMode;
  oldOffsetX0, oldOffsetY0,
  OffsetX0, OffsetY0,
  ClickX0, ClickY0: integer;
  WinScale: real = 1;
  WinSizeX, WinSizeY: real;
  Clicks: integer = 0;
  CropStartX, CropStartY: integer;
  CropEndX, CropEndY: integer;
  OldX, OldY: integer;

implementation

uses pFlyGIS3D;

{$R *.DFM}

procedure TMapInfoForm.CropPoints ( var Point : TMyListPoint );
var
  i : integer;
  x, y, z : integer;
  dx, dy : real;
  p : TMyPoint;
  PointCopy: TMyListPoint;
begin
  PointCopy.points := 0;
//  ClientWidth := Image1.Width;
//  ClientHeight := Image1.Height;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Rectangle( 0, 0, ClientWidth, ClientHeight );
  if Point.points <> 0 then begin
    dx := WinSizeX / ( Point.maxX - Point.minX );
    dy := WinSizeY / ( Point.maxY - Point.minY );
    Point.curr := Point.head;
    for i := 1 to Point.points do begin
      x := trunc ( ( Point.curr.point.x - Point.minX ) * dx );
      y := //Image1.Height -
           trunc ( WinSizeY - ( Point.curr.point.y - Point.minY ) * dy );
      z := Trunc(Point.curr.point.z);
      if (x >= CropStartX) and (x <= CropEndX) and
         (y >= CropStartY) and (y <= CropEndY) then
         begin
           P.x := x;
           P.y := y;
           P.z := z;
           if PointCopy.points = 0
             then AddFirstP( PointCopy, P )
             else AddNextP ( PointCopy, P );
           Image1.Canvas.Pixels [ x, y ] := clBlack;
         end;
      Point.curr := Point.curr^.mynext;
    end;
  end;
  Point := PointCopy;
end;

procedure TMapInfoForm.DrawPoints ( Point : TMyListPoint );
var
  i : integer;
  x, y : integer;
  dx, dy : real;
begin
//  ClientWidth := Image1.Width;
//  ClientHeight := Image1.Height;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Rectangle( 0, 0, ClientWidth, ClientHeight );
  if Point.points <> 0 then begin
    dx := WinSizeX / ( Point.maxX - Point.minX );
    dy := WinSizeY / ( Point.maxY - Point.minY );
    Point.curr := Point.head;
    for i := 1 to Point.points do begin
      x := trunc ( ( Point.curr.point.x - Point.minX ) * dx );
      y := //Image1.Height -
           trunc ( WinSizeY - ( Point.curr.point.y - Point.minY ) * dy );
      Image1.Canvas.Pixels [ x, y ] := clBlack;
      Point.curr := Point.curr^.mynext;
    end;
  end;
end;

procedure TMapInfoForm.DrawTriangles ( Triangle : TMyListTriangle );
var
  i : integer;
  dx, dy : real;
  x1, y1, x2, y2, x3, y3 : integer;
begin
//  ClientWidth := Image1.Width;
//  ClientHeight := Image1.Height;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Rectangle( 0, 0, ClientWidth, ClientHeight );
  if Triangle.triangles <> 0 then begin
    dx := WinSizeX / ( Point.maxX - Point.minX );
    dy := WinSizeY / ( Point.maxY - Point.minY );
    Triangle.curr := Triangle.head;
    for i := 1 to Triangle.triangles do begin
      x1 := trunc ( ( Triangle.curr^.triangle.v[0].x - Point.minX ) * dx );
      y1 := //Image1.Height -
             trunc ( WinSizeY - ( Triangle.curr^.triangle.v[0].y - Point.minY ) * dy );
      x2 := trunc ( ( Triangle.curr^.triangle.v[1].x - Point.minX ) * dx );
      y2 := //Image1.Height -
             trunc ( WinSizeY - ( Triangle.curr^.triangle.v[1].y - Point.minY ) * dy );
      x3 := trunc ( ( Triangle.curr^.triangle.v[2].x - Point.minX ) * dx );
      y3 := //Image1.Height -
             trunc ( WinSizeY - ( Triangle.curr^.triangle.v[2].y - Point.minY ) * dy );
      Image1.Canvas.MoveTo ( trunc( x1 * WinScale + OffsetX0 ), trunc( y1 * WinScale + OffsetY0 ) );
      Image1.Canvas.LineTo ( trunc( x2 * WinScale + OffsetX0 ), trunc( y2 * WinScale + OffsetY0 ) );
      Image1.Canvas.LineTo ( trunc( x3 * WinScale + OffsetX0 ), trunc( y3 * WinScale + OffsetY0 ) );
      Image1.Canvas.LineTo ( trunc( x1 * WinScale + OffsetX0 ), trunc( y1 * WinScale + OffsetY0 ) );
      Triangle.curr := Triangle.curr^.mynext;
    end;
  end;
end;

procedure TMapInfoForm.DrawIsolines( Triangle : TMyListTriangle );
var
  i, k1, k2 : integer;
  dx, dy : real;
  x1, y1, x2, y2, x3, y3 : integer;
  T: TTriangle;
begin
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Rectangle( 0, 0, ClientWidth, ClientHeight );
  dx := WinSizeX / ( Point.maxX - Point.minX );
  dy := WinSizeY / ( Point.maxY - Point.minY );
  Image1.Canvas.Pen.Color := clRed;
  if Triangle.triangles <> 0 then begin
    Triangle.curr := Triangle.head;
    for i := 1 to Triangle.triangles do begin
      T := Triangle.curr^.triangle;
      k1 := 0;
      k2 := 0;
      if ( T.v[0].z = T.v[1].z ) and ( T.v[0].z <> T.v[2].z ) and ( T.v[1].z <> T.v[2].z )
        then begin
          k1 := 0; k2 := 1;
        end;
      if ( T.v[1].z = T.v[2].z ) and ( T.v[1].z <> T.v[0].z ) and ( T.v[2].z <> T.v[0].z )
        then begin
          k1 := 1; k2 := 2;
        end;
      if ( T.v[2].z = T.v[0].z ) and ( T.v[2].z <> T.v[1].z ) and ( T.v[0].z <> T.v[1].z )
        then begin
          k1 := 2; k2 := 0;
        end;
      x1 := trunc ( ( T.v[k1].x - Point.minX ) * dx );
      y1 := trunc ( WinSizeY - ( T.v[k1].y - Point.minY ) * dy );
      x2 := trunc ( ( T.v[k2].x - Point.minX ) * dx );
      y2 := trunc ( WinSizeY - ( T.v[k2].y - Point.minY ) * dy );
      Image1.Canvas.MoveTo ( trunc( x1 * WinScale + OffsetX0 ), trunc( y1 * WinScale + OffsetY0 ) );
      Image1.Canvas.LineTo ( trunc( x2 * WinScale + OffsetX0 ), trunc( y2 * WinScale + OffsetY0 ) );
      Triangle.curr := Triangle.curr^.mynext;
    end;
  end;
end;

procedure TMapInfoForm.Bounds( x1, y1, x2, y2 : integer; var Point : TMyListPoint );
var
  i : integer;
  x, y : integer;
  dx, dy : real;
  tmpPoint : TMyListPoint;
begin
  ClientWidth := Image1.Width;
  ClientHeight := Image1.Height;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Rectangle( 0, 0, ClientWidth, ClientHeight );
  if Point.points <> 0 then begin
    dx := WinSizeX / ( Point.maxX - Point.minX );
    dy := WinSizeY / ( Point.maxY - Point.minY );
    Point.curr := Point.head;
    for i := 1 to Point.points do begin
      x := trunc ( ( Point.curr.point.x - Point.minX ) * dx );
      y := //Image1.Height -
           trunc ( WinSizeY - ( Point.curr.point.y - Point.minY ) * dy );
      if ( x >= x1 ) and ( x <= x2 ) and ( y >= y1 ) and ( y <= y2 )
        then begin
          Image1.Canvas.Pixels [ x, y ] := clRed;
          if tmpPoint.points = 0
           then AddFirstP( tmpPoint, Point.curr^.point )
           else AddNextP ( tmpPoint, Point.curr^.point );
        end;
      Point.curr := Point.curr^.mynext;
    end;
  end;
  PlayPoints ( tmpPoint );
  Point.points := 0;
  Point := tmpPoint;
end;

procedure TMapInfoForm.Centered;
begin
  OffsetX0 := trunc ( ClientWidth  div 2 - WinSizeX * WinScale / 2 );
  OffsetY0 := trunc ( ClientHeight div 2 - WinSizeY * WinScale / 2 );
  oldOffsetX0 := OffsetX0;
  oldOffsetY0 := OffsetY0;
end;

procedure TMapInfoForm.FormResize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width  := ClientWidth;
  Image1.Picture.Bitmap.Height := ClientHeight;
  Image1.Width  := ClientWidth;
  Image1.Height := ClientHeight;
  if Triangle.triangles = 0
    then DrawPoints( Point )
    else DrawTriangles( Triangle );
end;

procedure TMapInfoForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case ActionMode of
    AM_Grabber:
      begin
        ClickX0 := X;
        ClickY0 := Y;
        oldOffsetX0 := OffsetX0;
        oldOffsety0 := OffsetY0;
      end;
    AM_ZoomIn, AM_ZoomOut:
      begin
        ClickX0 := X;
        ClickY0 := Y;
      end;
    AM_CROP:
      begin
        inc(Clicks);
        if Clicks = 1 then
        begin
          CropStartX := X;
          CropStartY := Y;
        end;
        if Clicks = 2 then
        begin
          CropEndX := X;
          CropEndY := Y;
          Clicks := 0;
          OldX := 0;
          OldY := 0;
          CropPoints(Point);
          ActionMode := AM_NONE;
        end;
      end;
  end;
end;

procedure TMapInfoForm.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift = [ssLeft] then
    case ActionMode of
      AM_Grabber:
        begin
          OffsetX0 := oldOffsetX0 + ( X - ClickX0 );
          Offsety0 := oldOffsetY0 + ( Y - ClickY0 );
          DrawTriangles( Triangle );
        end;
    end;
  case ActionMode of
    AM_CROP:
     begin
      if Clicks=1 then
      begin
        Image1.Canvas.Pen.Mode := pmXOR;
        if (OldX <> 0) and (OldY <> 0) then
        begin
          Image1.Canvas.Rectangle(CropStartX-1, CropStartY-1, OldX+1, OldY+1);
          Image1.Canvas.Rectangle(CropStartX, CropStartY, OldX, OldY);
        end;
        Image1.Canvas.Rectangle(CropStartX-1, CropStartY-1, X+1, Y+1);
        Image1.Canvas.Rectangle(CropStartX, CropStartY, X, Y);
        OldX := X;
        OldY := Y;
        Image1.Canvas.Pen.Mode := pmCopy;
      end;
     end;
  end;
  MainForm.StatusBar1.Panels[1].Text := 'WinSizeX=' + FloatToStr(WinSizeX) +
       ', WinSizeY=' + FloatToStr(WinSizeY);
end;

procedure TMapInfoForm.Image1Click(Sender: TObject);
begin
{  case ActionMode of
    AM_ZoomIn:
      if WinScale < 32 then begin
        WinScale := WinScale * 2;
        OffsetX0 := ClickX0 - ( ClickX0 - oldOffsetX0 ) shl 1;
        OffsetY0 := ClickY0 - ( ClickY0 - oldOffsetY0 ) shl 1;
//        WinSizeX := WinSizeX * 2;
//        WinSizeY := WinSizeY * 2;
      end;
    AM_ZoomOut:
      if WinScale > 1/32 then begin
        WinScale := WinScale / 2;
        OffsetX0 := ClickX0 - ( ClickX0 - oldOffsetX0 ) shr 1;
        OffsetY0 := ClickY0 - ( ClickY0 - oldOffsetY0 ) shr 1;
//        WinSizeX := WinSizeX / 2;
//        WinSizeY := WinSizeY / 2;
      end;
  end;
  DrawTriangles( Triangle );
  oldOffsetX0 := OffsetX0;
  oldOffsetY0 := OffsetY0;
}
end;

procedure TMapInfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  MapInfoForm := nil;
end;

procedure TMapInfoForm.FormCreate(Sender: TObject);
begin
  WinSizeX := ClientWidth;
  WinSizeY := ClientHeight;
  if ClientWidth < ClientHeight
    then WinSizeY := trunc( ClientWidth  / RatioXY )
    else WinSizeX := trunc( ClientHeight * RatioXY );
  Image1.Picture.Bitmap.Width  := ClientWidth;
  Image1.Picture.Bitmap.Height := ClientHeight;
  Image1.Width  := ClientWidth;
  Image1.Height := ClientHeight;
  Clicks := 0;
  Centered;
end;

end.

