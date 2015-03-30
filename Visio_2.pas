unit Visio_2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,  Controls,
  Forms, Dialogs, GL, GLU, Geometry, pFlyGIS3D, Menus, Geom1,
  ExtCtrls;

type
  TVisio2D = class(TForm)
    PopupMenu2: TPopupMenu;
    popmnuEndTraektory: TMenuItem;
    Image1: TImage;
    function GetX( x : real ):integer; // из СК MapInfo в СК Visio2D
    function GetY( y : real ):integer;
    function GetX_1( x : integer ) : real;// из СК Visio2D в СК MapInfo
    function GetY_1( y : integer ) : real;
    procedure MyLine1(x1,y1,x2,y2:real);
    procedure MyRectangle(x1,y1,x2,y2:real);
    procedure MyTriangle(p1,p2,p3:TMyPoint);
    procedure MyMoveTo(x,y:real);
    procedure MyPixel(x,y:real);
    procedure MyLineTo(x,y:real);
    procedure MyCircle(x,y:real;r:integer);
    procedure popmnuEndTraektoryClick(Sender: TObject);
    procedure popmnuScaleClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Visio2D: TVisio2D;
//  outCycle : boolean = True;

implementation

uses pSetup, Visio_1, pTraektoryForm, pTraektTable, pBitmap, FormCopy,
  pCamera;

{$R *.DFM}

function TVisio2D.GetX( x : real ):integer;
var
  scale : real;
  w : integer;
begin
  w := Visio2D.Image1.Width;
  scale := ( Point.maxX - Point.minX ) / w;
  GetX := trunc ( ( x - tOffsX ) / scale + w / 2 );
end;

function TVisio2D.GetY ( y : real) : integer;
var
  scale : real;
  h : integer;
begin
  h := Visio2D.Image1.Height;
  scale := ( Point.maxY - Point.minY ) / h;
  GetY := trunc ( ( - y - tOffsY ) / scale + h / 2 );
end;

function TVisio2D.GetX_1( x : integer ):real;
var
  scale : real;
  w : integer;
begin
  w := Visio2D.Image1.Width;
  scale := ( Point.maxX - Point.minX ) / w;
  GetX_1 := ( X - w / 2 ) * scale + tOffsX;
end;

function TVisio2D.GetY_1(y : integer):real;
var
  scale : real;
  h : integer;
begin
  h := Visio2D.Image1.Height;
  scale:= ( Point.maxY - Point.minY ) / h;
  GetY_1 := - ( ( Y - h / 2 ) * scale + tOffsY );
end;

procedure TVisio2D.MyLine1(x1,y1,x2,y2:real);
begin
  Image1.Canvas.MoveTo(GetX(x1),GetY(y1));
  Image1.Canvas.LineTo(GetX(x2),GetY(y2));
end;

procedure TVisio2D.MyRectangle(x1,y1,x2,y2:real);
begin
  Image1.Canvas.Rectangle(GetX(x1),GetY(y1),GetX(x2),GetY(y2));
end;

procedure TVisio2D.MyTriangle(p1,p2,p3:TMyPoint);
var
  P:array [0..2] of TPoint;
begin
  P[0].x := GetX(p1.x);
  P[0].y := GetY(p1.y);
  P[1].x := GetX(p2.x);
  P[1].y := GetY(p2.y);
  P[2].x := GetX(p3.x);
  P[2].y := GetY(p3.y);
  Image1.Canvas.Polygon ( P );
end;

procedure TVisio2D.MyMoveTo(x,y:real);
begin
  Image1.Canvas.MoveTo(GetX(x),GetY(y));
end;

procedure TVisio2D.MyPixel(x,y:real);
begin
  Image1.Canvas.Pixels[GetX(x),GetY(y)]:=0;
end;

procedure TVisio2D.MyLineTo(x,y:real);
begin
  Image1.Canvas.LineTo(GetX(x),GetY(y));
end;

procedure TVisio2D.MyCircle(x,y:real;r:integer);
begin
  Image1.Canvas.Ellipse(GetX(x)-r, GetY(y)-r, GetX(x)+r, GetY(y)+r);
end;

procedure TVisio2D.popmnuEndTraektoryClick(Sender: TObject);
begin
  Image1.Canvas.Pen.Color:=clRed;
  DrawMode := 5;
  MainForm.MnuFly.Enabled := true;
  MainForm.MnuFly.Checked := true;
  MyLine1(Traektory[TrPoints].x,Traektory[TrPoints].y,
          Traektory[1].x,       Traektory[1].y);
end;

procedure TVisio2D.popmnuScaleClick(Sender: TObject);
begin
  DrawMode:=6;
end;

procedure TVisio2D.FormPaint(Sender: TObject);
begin
{
  if outCycle then begin
//    Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 ) + 50;
//    Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 ) + 50;
    Image1.Canvas.Brush.Color:=clWhite;
    Image1.Canvas.Pen.Color:=clWhite;
    Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
    Image1.Canvas.Pen.Color:=clBlack;
    case Mode2D of
      1: MainForm.MnuPointsClick(Sender);
      2: MainForm.MnuIsolinesClick(Sender);
      3: MainForm.MnuTrianglesClick(Sender);
    end;
  end;
}
end;

procedure TVisio2D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.MnuPoints.Checked := false;
  MainForm.MnuTriangles.Checked := false;
end;

procedure TVisio2D.FormResize(Sender: TObject);
begin
  FormPaint(Sender);
end;

procedure TVisio2D.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
  bz, z : real;
  c : byte;
  p1 : TMyPoint;
begin
  Image1.Canvas.Pen.Color:=clRed;
  Move:=true;
  X0:=X;
  Y0:=Y;
  if (Shift = [ssLeft]) then begin
    if SetObscurePoint then begin
      ObscurePoint.x := Visio2D.GetX_1 ( X );
      ObscurePoint.y := Visio2D.GetY_1 ( Y );
      c := ( CopyForm.Image1.Canvas.Pixels [ X , Y ] and $ff );
      z := ( Point.maxZ - Point.minZ ) * c / 255 + Point.minZ;
      ObscurePoint.z := z;
      SeeToPoint := true;
      SetObscurePoint := false;
      Screen.Cursor := crDefault;
    end;
    if DrawMode=3 then begin
      inc(TrPoints);
      Traektory[TrPoints].x:=GetX_1(X);
      Traektory[TrPoints].y:=GetY_1(Y);
      p1 := Traektory[TrPoints];
      bz := ( CopyForm.Image1.Canvas.Pixels [ BitmapForm.GetBM_X ( p1.x ),
        BitmapForm.GetBM_Y ( p1.y ) ] and $ff );
      bz := ( Point.maxZ - Point.minZ ) * bz / 255 + Point.minZ + h0;
      Traektory[TrPoints].z :=  bz;
{      Traektory[TrPoints].a := 1;
      Traektory[TrPoints].b := 1;
      Traektory[TrPoints].c := 1;}
      if TrPoints=1
        then
          Image1.Canvas.Rectangle(X-2,Y-2,X+2,Y+2)
        else begin
          Image1.Canvas.Rectangle(X-2,Y-2,X+2,Y+2);
          MyLine1(Traektory[TrPoints].x,
                  Traektory[TrPoints].y,
                  Traektory[TrPoints-1].x,
                  Traektory[TrPoints-1].y);
        end;
    end
    else
      begin
        if DrawMode<>3 then begin
          OldActivePoint:=ActivePoint;
          ActivePoint:=0;
          for i:=1 to TrPoints do begin
            if (X>=GetX(Traektory[i].x)-3) and
               (X<=GetX(Traektory[i].x)+3) and
               (Y>=GetY(Traektory[i].y)-3) and
               (Y<=GetY(Traektory[i].y)+3)
               then ActivePoint:=i;
          end;
          if OldActivePoint<>0 then begin
            Image1.Canvas.Pen.Color:=clRed;
            Image1.Canvas.Brush.Color:=clWhite;
            MyRectangle(Traektory[OldActivePoint].x-0.05,
                        Traektory[OldActivePoint].y-0.05,
                        Traektory[OldActivePoint].x+0.05,
                        Traektory[OldActivePoint].y+0.05);
            Image1.Canvas.Pen.Color:=clBlack;
            Image1.Canvas.Brush.Color:=clWhite;
            CameraForm.Caption:='Параметры выделенной '+
                            'точки траектории';
            CameraForm.Edit1.Text:='None';
            CameraForm.Edit2.Text:='None';
          end;
          if ActivePoint<>0 then begin
            Image1.Canvas.Pen.Color:=clGreen;
            Image1.Canvas.Brush.Color:=clYellow;
              Image1.Canvas.Pen.Mode:=pmXor;
            MyRectangle(Traektory[ActivePoint].x-0.1,
                        Traektory[ActivePoint].y-0.1,
                        Traektory[ActivePoint].x+0.1,
                        Traektory[ActivePoint].y+0.1);
            Image1.Canvas.Pen.Color:=clBlack;
            Image1.Canvas.Brush.Color:=clWhite;
            CameraForm.Caption:='Параметры '+
                            IntToStr(ActivePoint)+
                            '-й точки траектории';
            CameraForm.Edit1.Text:=FloatToStr(Traektory[ActivePoint].x);
            CameraForm.Edit2.Text:=FloatToStr(Traektory[ActivePoint].y);
          end;
        end;
      end;
    if DrawMode=6 then begin
    end;
    Visio1.FormResize(Sender);
  end;
  if TrPoints <> 0 then begin
    TableForm.StringGrid1.RowCount := TrPoints + 1;
    TableForm.StringGrid1.Cells [ 0, TrPoints ] := IntToStr ( TrPoints );
    TableForm.StringGrid1.Cells [ 1, TrPoints ] := FloatToStr ( Traektory[TrPoints].x );
    TableForm.StringGrid1.Cells [ 2, TrPoints ] := FloatToStr ( Traektory[TrPoints].y );
    TableForm.StringGrid1.Cells [ 3, TrPoints ] := FloatToStr ( Traektory[TrPoints].z );
{    TableForm.StringGrid1.Cells [ 4, TrPoints ] := FloatToStr ( Traektory[TrPoints].a );
    TableForm.StringGrid1.Cells [ 5, TrPoints ] := FloatToStr ( Traektory[TrPoints].b );
    TableForm.StringGrid1.Cells [ 6, TrPoints ] := FloatToStr ( Traektory[TrPoints].c );}
  end;

end;

end.
