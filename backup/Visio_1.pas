unit Visio_1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, GL, GLU, Geometry, Math, Geom1, ToolWin, ComCtrls,
  Buttons;

type
  TVisio1 = class(TForm)
    PopupMenu1: TPopupMenu;
    PopMnuEndFly: TMenuItem;
    N2: TMenuItem;
    PopMnuIncrease: TMenuItem;
    PopMnuDecrease: TMenuItem;
    PopMnuEndScale: TMenuItem;
    Timer: TTimer;
    function GetGL_X( RealMapInfo_X : real ): real;
    function GetGL_Y( RealMapInfo_Y : real ): real;
    function GetGL_Z( RealMapInfo_Z : real ): real;
    procedure SeeFromV1toV2( v1, v2: TMyPoint; ShowNow: boolean );
    procedure SetupTexture(Name : string);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopMnuEndFlyClick(Sender: TObject);
    procedure PopMnuIncreaseClick(Sender: TObject);
    procedure PopMnuDecreaseClick(Sender: TObject);
    procedure PopMnuEndScaleClick(Sender: TObject);
    procedure DrawFont;
    procedure DrawScene( ShowNow: boolean );
    procedure DrawScan( xx, yy: real; v1, v2: TMyPoint );
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    DC: HDC;
    hrc: HGLRC;
    Palette: HPALETTE;
    Angle: GLfloat;

    procedure InitializeRC;
    procedure SetDCPixelFormat;

  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMQueryNewPalette(var Msg: TWMQueryNewPalette); message WM_QUERYNEWPALETTE;
    procedure WMPaletteChanged(var Msg: TWMPaletteChanged); message WM_PALETTECHANGED;

  public
  end;

var
  Visio1: TVisio1;
  IncreaseR, FocusChange, MClick : boolean;

implementation

uses pFlyGIS3D, pCamera, Visio_2, pBitmap, pSetup, pTraektoryForm, FormCopy;

{$R *.DFM}

function TVisio1.GetGL_X( RealMapInfo_X : real ): real;
var n: real;
begin
  n := ScaleX * ( ( RealMapInfo_X - Point.minX ) / ( Point.maxX - Point.minX ) - 0.5 );
  Result := n;
end;

function TVisio1.GetGL_Y( RealMapInfo_Y : real ): real;
var n: real;
begin
  n := ScaleY * ( ( RealMapInfo_Y - Point.minY ) / ( Point.maxY - Point.minY ) - 0.5 );
  Result := n;
end;

function TVisio1.GetGL_Z( RealMapInfo_Z : real ): real;
begin
  Result := ScaleZ * ( ( RealMapInfo_Z - Point.minZ ) / ( Point.maxZ - Point.minZ ) - 0.5 );
end;

procedure TVisio1.DrawFont;
var
  i, k: integer;
  fcol: TColor;
begin
  for i := 0 to TraektoryForm.Image1.Height - 1 do begin
    k := trunc( 255*(TraektoryForm.Image1.Height-i)/TraektoryForm.Image1.Height );
    fcol := col_bounds( FontColor, 70, 255, k );
    TraektoryForm.Image1.Canvas.Pen.Color := fcol;
    TraektoryForm.Image1.Canvas.MoveTo( 0, i );
    TraektoryForm.Image1.Canvas.LineTo( TraektoryForm.Image1.Width-1, i );
  end;
end;

procedure TVisio1.SetDCPixelFormat;
var
  hHeap: THandle;
  nColors, i: Integer;
  lpPalette: PLogPalette;
  byRedMask, byGreenMask, byBlueMask: Byte;
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;

begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do begin
    nSize     := sizeof(pfd);                               // Size of this structure
    nVersion  := 1;                                         // Version number
    dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;                          // Flags
    iPixelType:= PFD_TYPE_RGBA;                             // RGBA pixel values
    cColorBits:= 24;                                        // 24-bit color
    cDepthBits:= 32;                                        // 32-bit depth buffer
    iLayerType:= PFD_MAIN_PLANE;                            // Layer type
  end;

  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, nPixelFormat, @pfd);

  DescribePixelFormat(DC, nPixelFormat, sizeof(TPixelFormatDescriptor), pfd);

  if ((pfd.dwFlags and PFD_NEED_PALETTE) <> 0) then begin
    nColors   := 1 shl pfd.cColorBits;
    hHeap     := GetProcessHeap;
    lpPalette := HeapAlloc(hHeap, 0, sizeof(TLogPalette) + (nColors * sizeof(TPaletteEntry)));

    lpPalette^.palVersion := $300;
    lpPalette^.palNumEntries := nColors;

    byRedMask   := (1 shl pfd.cRedBits) - 1;
    byGreenMask := (1 shl pfd.cGreenBits) - 1;
    byBlueMask  := (1 shl pfd.cBlueBits) - 1;

    for i := 0 to nColors - 1 do begin
      lpPalette^.palPalEntry[i].peRed   := (((i shr pfd.cRedShift)   and byRedMask)   * 255) DIV byRedMask;
      lpPalette^.palPalEntry[i].peGreen := (((i shr pfd.cGreenShift) and byGreenMask) * 255) DIV byGreenMask;
      lpPalette^.palPalEntry[i].peBlue  := (((i shr pfd.cBlueShift)  and byBlueMask)  * 255) DIV byBlueMask;
      lpPalette^.palPalEntry[i].peFlags := 0;
    end;

    Palette := CreatePalette(lpPalette^);
    HeapFree(hHeap, 0, lpPalette);

    if (Palette <> 0) then begin
      SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
  end;
end;

procedure TVisio1.InitializeRC;
const
  glfLightAmbient : Array[0..3] of GLfloat = (0.1, 0.1, 0.1, 1.0);
  glfLightDiffuse : Array[0..3] of GLfloat = (0.7, 0.7, 0.7, 1.0);
  glfLightSpecular: Array[0..3] of GLfloat = (0.0, 0.0, 0.0, 1.0);
begin
  //
  // Enable depth testing and backface culling.
  //
  glEnable(GL_DEPTH_TEST);
  //
  // Add a light to the scene.
  //
  glLightfv(GL_LIGHT0, GL_AMBIENT, @glfLightAmbient);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, @glfLightDiffuse);
  glLightfv(GL_LIGHT0, GL_SPECULAR,@glfLightSpecular);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
end;

procedure SetColor(r,g,b:real);
var
  glfMaterialColor: Array[0..3] of GLfloat;
begin
  glfMaterialColor[0] := r;
  glfMaterialColor[1] := g;
  glfMaterialColor[2] := b;
  glfMaterialColor[3] := 1.0;
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @glfMaterialColor);
end;

procedure DrawTraektory;
var
  i: integer;
//  k : integer;
//  A : BresenhamesLine;
//  p, v : TPoint3D;
  p1: TMyPoint;
//  z: real;
//  qobj: PGLUQuadricObj;
begin
  SetColor( 1, 0, 0 );
  glBegin(GL_LINE_LOOP);
  for i := 1 to TrPoints do begin
    p1 := Traektory[ i ];
    glVertex3f( Visio1.GetGL_X( p1.x ),
                Visio1.GetGL_Y( p1.y ),
                Visio1.GetGL_Z( p1.z ) );
  end;
  glEnd;

end;

procedure TVisio1.DrawScene( ShowNow: boolean );
var
  i: integer;
  norm : TVector;
  glfMaterialColor : Array[0..3] of GLfloat;
  x, y : real;
  p1, p2, p3 : TMyPoint;
begin
  //
  // Clear the color and depth buffers.
  //
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    //
    // Define the modelview transformation.
    //
    glMatrixMode(GL_MODELVIEW);
    if (not Flying) and (not DrawViewing) then begin
      glLoadIdentity;
      glTranslatef(0.0, 0.0, -Focus);
      glRotatef(betta, 1.0, 0.0, 0.0);
      glRotatef(alpha, 0.0, 1.0, 0.0);
      glRotatef(gamma, 0.0, 0.0, 1.0);
    end;
    //
    // Define the reflective properties of the faces.
    //
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @glfMaterialColor);
    glfMaterialColor[0]:=1.0;
    glfMaterialColor[1]:=1.0;
    glfMaterialColor[2]:=1.0;
    glfMaterialColor[3]:=1.0; { Alpha }
    glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@glfMaterialColor);
    glBegin(GL_LINES);
     SetColor(1,0,0);
     glVertex3f(0,0,0);
     glVertex3f(1,0,0);
     SetColor(0,1,0);
     glVertex3f(0,0,0);
     glVertex3f(0,1,0);
     SetColor(0,0,1);
     glVertex3f(0,0,0);
     glVertex3f(0,0,1);
    glEnd;

    Triangle.curr := Triangle.head;
    for i:=1 to Triangle.triangles do begin
      case vModel3DType of
        0: begin
          SetColor( 1.0, 1.0, 0.0 );
          glBegin(GL_LINE_LOOP);
           MakeNormal(norm,Triangle.curr^.triangle.v[0],
                           Triangle.curr^.triangle.v[1],
                           Triangle.curr^.triangle.v[2]);
           glNormal3f(norm.x, norm.y, norm.z);
            p1 := Triangle.curr^.triangle.v[0];
            p2 := Triangle.curr^.triangle.v[1];
            p3 := Triangle.curr^.triangle.v[2];
            glVertex3f( GetGL_X( p1.x ),GetGL_Y( p1.y ),GetGL_Z( p1.z ) );
            glVertex3f( GetGL_X( p2.x ),GetGL_Y( p2.y ),GetGL_Z( p2.z ) );
            glVertex3f( GetGL_X( p3.x ),GetGL_Y( p3.y ),GetGL_Z( p3.z ) );
          glEnd;
        end; // -0-
        1: begin
          glShadeModel(GL_SMOOTH);
          glBegin(GL_TRIANGLES);
           MakeNormal(norm,Triangle.curr^.triangle.v[0],
                           Triangle.curr^.triangle.v[1],
                           Triangle.curr^.triangle.v[2]);
           p1 := Triangle.curr^.triangle.v[0];
           p2 := Triangle.curr^.triangle.v[1];
           p3 := Triangle.curr^.triangle.v[2];
            SetColor(1,1,1);
            glVertex3f( GetGL_X( p1.x ),GetGL_Y( p1.y ),GetGL_Z( p1.z ) );
            glVertex3f( GetGL_X( p2.x ),GetGL_Y( p2.y ),GetGL_Z( p2.z ) );
            glVertex3f( GetGL_X( p3.x ),GetGL_Y( p3.y ),GetGL_Z( p3.z ) );
          glEnd;
        end; // -1-
        2: begin
          glBegin(GL_TRIANGLES);
           MakeNormal(norm,Triangle.curr^.triangle.v[0],
                           Triangle.curr^.triangle.v[1],
                           Triangle.curr^.triangle.v[2]);
           glNormal3f(norm.x, norm.y, norm.z);
            p1 := Triangle.curr^.triangle.v[0];
            p2 := Triangle.curr^.triangle.v[1];
            p3 := Triangle.curr^.triangle.v[2];
            x := (p1.x - Point.minX) / ( Point.maxX - Point.minX);
            y := ( - p1.y - Point.minY) / ( Point.maxY - Point.minY);
            glTexCoord2d( x, y);
            glVertex3f( GetGL_X( p1.x ),GetGL_Y( p1.y ),GetGL_Z( p1.z ) );
            x := (p2.x - Point.minX) / ( Point.maxX - Point.minX);
            y := ( - p2.y - Point.minY) / ( Point.maxY - Point.minY);
            glTexCoord2d( x, y);
            glVertex3f( GetGL_X( p2.x ),GetGL_Y( p2.y ),GetGL_Z( p2.z ) );
            x := (p3.x - Point.minX) / ( Point.maxX - Point.minX);
            y := ( - p3.y - Point.minY) / ( Point.maxY - Point.minY);
            glTexCoord2d( x, y );
            glVertex3f( GetGL_X( p3.x ),GetGL_Y( p3.y ),GetGL_Z( p3.z ) );
          glEnd;
        end; // -2-
      end; // case
      Triangle.curr := Triangle.curr^.mynext;
    end;// for i
    if Point.points <> 0 then begin
      if vModel3DType = 3 then begin
        point.curr := point.head;
        for i := 0 to Point.points - 1 do begin
          glBegin(GL_POINTS);
            SetColor( 0.7, 0.7, 0.7 );
            p1 := Point.curr^.point;
            glVertex3f( GetGL_X( p1.x ),GetGL_Y( p1.y ),GetGL_Z( p1.z ) );
            Point.curr := Point.curr^.mynext;
          glEnd;
        end;// for i
      end; // vModel3DType = 3
    end;// Point.points <> 0

    SetColor( 1, 0, 0 );
    glBegin(GL_LINE_LOOP);
    for i := 1 to TrPoints do begin
      p1 := Traektory[ i ];
      p1.x := GetGL_X( p1.x );
      p1.y := - GetGL_Y( p1.y );
      p1.z := GetGL_Z( p1.z );
      glVertex3f( p1.x, p1.y, p1.z );
    end;
    glEnd;

    if SeeToPoint or DrawViewing then begin
      SetColor( 1, 0, 0 );
      glBegin(GL_LINE_LOOP);
        p1 := ObscurePoint;
        p2 := ObscurePoint;
        p2.z := ObscurePoint.z + 1;
        glVertex3f( GetGL_X( p1.x ),GetGL_Y( p1.y ),GetGL_Z( p1.z ) );
        glVertex3f( GetGL_X( p2.x ),GetGL_Y( p2.y ),GetGL_Z( p2.z ) );
      glEnd;
    end;

//    DrawTraektory;

    if ShowNow then SwapBuffers(DC);
end;

procedure TVisio1.SeeFromV1toV2( v1, v2: TMyPoint; ShowNow: boolean );
begin
  glLoadIdentity;
  gluLookAt( GetGL_X( v1.x ), GetGL_Y( v1.y ), GetGL_Z( v1.z ),
             GetGL_X( v2.x ), GetGL_Y( v2.y ), GetGL_Z( v2.z ),
             0, 0, 1);
  DrawScene( ShowNow );
end;

procedure TVisio1.WMPaint(var Msg: TWMPaint);
var
  ps : TPaintStruct;
begin
  // Draw the scene.
  BeginPaint(Handle, ps);
  DrawScene( True );
  EndPaint(Handle, ps);
end;

procedure TVisio1.WMQueryNewPalette(var Msg : TWMQueryNewPalette);
begin
  if (Palette <> 0) then begin
    Msg.Result := RealizePalette(DC);
{    if (Msg.Result <> GDI_ERROR) then
      InvalidateRect(Handle, nil, False);}
  end;
end;

procedure TVisio1.WMPaletteChanged(var Msg : TWMPaletteChanged);
begin
  if ((Palette <> 0) and (THandle(TMessage(Msg).wParam) <> Handle)) then begin
    if (RealizePalette(DC) <> GDI_ERROR) then
      UpdateColors(DC);
    Msg.Result := 0;
  end;
end;

procedure TVisio1.SetupTexture(Name : string);
const
  SizeX = 256;
  SizeY = 256;
var
  pic : TBitmap;
  bits : array [0..SizeX - 1, 0..SizeY - 1, 0..3] of GLubyte;
  i, j : integer;
begin

  pic := TBitmap.Create;
  pic.LoadFromFile(Name);
//  GetMem(bits, SizeOf(pGLubyteArray)*pic.Width*pic.Height);
  for i := 0 to SizeX - 1 do begin
    for j := 0 to SizeY - 1 do
      begin
        bits[i][j][0] := GLbyte(GetRValue(pic.Canvas.Pixels[trunc(j*pic.Width/SizeX),trunc(i*pic.Height/SizeY)]));
        bits[i][j][1] := GLbyte(GetGValue(pic.Canvas.Pixels[trunc(j*pic.Width/SizeX),trunc(i*pic.Height/SizeY)]));
        bits[i][j][2] := GLbyte(GetBValue(pic.Canvas.Pixels[trunc(j*pic.Width/SizeX),trunc(i*pic.Height/SizeY)]));
        bits[i][j][3] := 255;
      end;
  end;

  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, SizeX, SizeY, 0, GL_RGBA, GL_UNSIGNED_BYTE, bits);

  glEnable(GL_TEXTURE_2D);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);

end;

procedure TVisio1.FormCreate(Sender: TObject);
begin
  FocusChange:=false;
  trace:=1;
  DrawMode:=1;
  TrassMode:=1;
  alpha:=0;
  betta:=-70;
  gamma:=0;
  Focus:=10.0;
// Create a rendering context.
  Angle := 0;
  DC := GetDC(Handle);
  SetDCPixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  InitializeRC;
//  SetupTexture('Default.bmp');
  glClearColor( 0.0, 0.0, 0.0, 1);
  Width := 400;
  Height := 300;
  FormResize(Sender);
end;

procedure TVisio1.FormResize(Sender: TObject);
var
  gldAspect : GLdouble;
  H : integer;
begin
  // Redefine the viewing volume and viewport when the window size changes.
  H := Height;
  gldAspect := Width / H;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(30.0,           // Field-of-view angle
                 gldAspect,      // Aspect ratio of viewing volume
                 0.1,            // Distance to near clipping plane
                 1000.0);         // Distance to far clipping plane
  glViewport(0, 0, Width, H );
  InvalidateRect(Handle, nil, False);
end;

procedure TVisio1.FormDestroy(Sender: TObject);
begin
  // Clean up and terminate.
  Timer.Enabled := False;
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC(Handle, DC);
  if (Palette <> 0) then
    DeleteObject(Palette);
end;

procedure TVisio1.DrawScan( xx, yy: real; v1, v2: TMyPoint );
var
  minToFlag, toFlag: real;
  FlagX, FlagY, Flag_i, Flag_h: integer;
  bz, ddx, ddy, dd : real;
  i: integer;
  zi, col, hz : integer;
  xi, yi : integer;
begin
  zi := ( CopyForm.Image1.Canvas.Pixels [ BitmapForm.GetBM_X ( xx ),
    BitmapForm.GetBM_Y ( yy ) ] and $ff );
  bz := ( Point.maxZ - Point.minZ ) * zi / 255 + Point.minZ + h0;
  zi := trunc( ( 255 * ( bz - Point.minZ ) / ( Point.maxZ - Point.minZ ) ) / 255 * 50 );

  ddx := v2.x - v1.x;
  ddy := v2.y - v1.y;
  dd := sqrt ( ddx * ddx + ddy * ddy );
  if dd = 0 then dd := 1;

  DrawFont;

  FlagX := BitmapForm.GetBM_X( ObscurePoint.x );
  FlagY := BitmapForm.GetBM_Y( ObscurePoint.y );
  Flag_i := -1;
  minToFlag := MaxInt;
  for i := 0 to TraektoryForm.Image1.Width - 1 do begin
    Visio2D.Image1.Canvas.Pen.Color := clGreen;
    Visio2D.MyCircle ( xx, yy, 3 );
    xi := trunc ( BitmapForm.GetBM_X ( Visio2D.GetX_1 ( trunc ( Visio2D.GetX ( xx ) + i * ddx / dd ) ) ) );
    yi := trunc ( BitmapForm.GetBM_Y ( Visio2D.GetY_1 ( trunc ( Visio2D.GetY ( yy ) - i * ddy / dd ) ) ) );
    toFlag := sqrt( sqr( FlagX - xi ) + sqr( FlagY - yi ) );
    if ( xi < CopyForm.Image1.Width ) and ( yi < CopyForm.Image1.Height )
      and ( xi >= 0  ) and ( yi >= 0 )
        then col := (CopyForm.Image1.Canvas.Pixels [ xi, yi ]) and $ff
        else col := 0;
//    hz := trunc ( ( ( Point.maxZ - Point.minZ ) * col / 255 + Point.minZ + h0 ) * 50 );
    col := trunc ( col / 255 * 50 );
    if toFlag < minToFlag
     then begin
       mintoFlag := toFlag;
       Flag_i := i;
       Flag_h := col;
     end;
    TraektoryForm.Image1.Canvas.MoveTo
    ( i, TraektoryForm.Image1.Height - col );
    TraektoryForm.Image1.Canvas.Pen.Color := clGreen;
    TraektoryForm.Image1.Canvas.LineTo ( i, TraektoryForm.Image1.Height);
  end;
  if minToFlag <= 2 then begin
    TraektoryForm.Image1.Canvas.Pen.Color := clRed;
    TraektoryForm.Image1.Canvas.MoveTo
      ( Flag_i, TraektoryForm.Image1.Height - Flag_h - 10 );
    TraektoryForm.Image1.Canvas.LineTo
      ( Flag_i, TraektoryForm.Image1.Height - Flag_h );
  end;

  TraektoryForm.Image1.Canvas.Pen.Color := clYellow;
  TraektoryForm.Image1.Canvas.MoveTo
   ( 0, TraektoryForm.Image1.Height - trunc ( zi ) );
  TraektoryForm.Image1.Canvas.LineTo
    ( Flag_i, TraektoryForm.Image1.Height - Flag_h );

  TraektoryForm.Image1.Canvas.Pen.Color := clBlack;
  TraektoryForm.Image1.Canvas.Rectangle
   ( 0, TraektoryForm.Image1.Height - trunc ( zi ) - 1,
     3, TraektoryForm.Image1.Height - trunc ( zi ) + 1 );
end;

procedure TVisio1.TimerTimer(Sender: TObject);
var
  i : integer;
  col, zi, hz : integer;
  dx, dy, dz, d : real;
  ddx, ddy, dd : real;
  xi, yi : integer;
  xx, yy, zz : real;
  p1, p2, p3 : TMyPoint;
  v1, v2 : TMyPoint;
  bz, da, a1, a2, a1s, a1c, a2s, a2c : real;
  sign : integer;
  tmin,tmax : real;
  scale : real;
  minToFlag, toFlag: real;
  FlagX, FlagY, Flag_i, Flag_h: integer;
begin

//  if TrPoints = 0 then Flying := false;

  if Rotate then begin
    gamma := gamma + 5;
    InvalidateRect(Handle, nil, False);
  end;

  if Flying then begin
    glLoadIdentity;
    if trace = 0 then trace := 1;
    if trace > TrPoints - 1 then trace := 1;
    if (TrassMode and 1) <> 0 then begin
      if step = 0
        then CameraForm.Label13.Caption:='Летим из '+
          IntToStr( trace );
      p1 := Traektory[ trace ]; // в СК MapInfo
      if trace < TrPoints - 1
        then p2 := Traektory[ trace + 1 ]
        else p2 := Traektory[ 1 ];
      dx := p2.x - p1.x;
      dy := p2.y - p1.y;
      d := sqrt ( dx * dx + dy * dy );
      if d = 0 then d := 1;

      xx := p1.x + dx * step / d; // в СК MapInfo
      yy := p1.y + dy * step / d;

      Visio2D.MyCircle(xx, yy, 3);

      bz := ( CopyForm.Image1.Canvas.Pixels [ BitmapForm.GetBM_X ( xx ),
        BitmapForm.GetBM_Y ( yy ) ] and $ff ); // чтение высоты
      bz := ( Point.maxZ - Point.minZ ) * bz / 255 + Point.minZ + h0;
//      zi := trunc( ( 255 * ( bz - Point.minZ ) / ( Point.maxZ - Point.minZ ) ) / 255 * 50 );
      MainForm.StatusBar1.Panels[3].Text := 'X='+FloatToStr(xx);
      MainForm.StatusBar1.Panels[4].Text := 'Y='+FloatToStr(yy);
      MainForm.StatusBar1.Panels[5].Text := 'Z='+FloatToStr(bz);

      p1.z := bz;
      p2.z := p1.z;
      zz := d * tan ( CamBetta * pi / 180 );
      if SeeToPoint then begin // если смотрим в точку
        v2.x := ObscurePoint.x;
        v2.y := ObscurePoint.y;
        v2.z := ObscurePoint.z;
      end
      else begin // если смотрим в направлении движения
        v2.x := p2.x;
        v2.y := p2.y;
        v2.z := p2.z - zz * ( 1 - step / d ) ;
      end;

      v1.x := xx;
      v1.y := yy;
      v1.z := p1.z;

      SeeFromV1toV2( v1, v2, False );

      DrawScan( xx, yy, v1, v2 );

      SwapBuffers(DC);

      step := step + CamMove / 100;
      if step >= d then begin
        step := 0;
        trace := trace + 1;
        TrassMode := 2;
        angstep := 0;
      end;{-if-}
      if trace = 0 then trace := 1;
      if trace > TrPoints - 1 then trace := 1;
    end{-TrassMode and 1-}

    else
     if (TrassMode and 2) <> 0 then begin
      if SeeToPoint then begin
//        angle := a2;
//        sign := 1;
        TrassMode := 1;
        angstep := 0;
        step := 0;
      end;
      if trace = 0 then trace := 1;
      if trace > TrPoints - 1 then trace := 1;
      if angstep = 0
        then CameraForm.Label13.Caption:='Поворачиваемся в '+
          IntToStr( trace );
      if trace > 1
        then p1 := Traektory [ trace - 1 ]
        else p1 := Traektory [ TrPoints - 1 ];//trace=1
      p2 := Traektory [ trace ];
      if trace < TrPoints - 1
        then p3 := Traektory [ trace + 1 ]
        else p3 := Traektory [ 1 ];
      //летим из p1, поворачиваемся в p2 и летим в p3
      dx := p2.x - p1.x;
      dy := p2.y - p1.y;
      d := sqrt ( dx * dx + dy * dy );
      if d = 0 then d := 1;

      a1c := arccos ( dx / d ) * 180 / pi;
      a1s := arcsin ( dy / d ) * 180 / pi;
      if a1s >= 0 then a1 := a1c
                  else a1 := 360 - a1c;
      dx := p3.x - p2.x;
      dy := p3.y - p2.y;
      d := sqrt ( dx * dx + dy * dy );
      if d = 0 then d := 1;

      a2c := arccos ( dx / d ) * 180 / pi;
      a2s := arcsin ( dy / d ) * 180 / pi;
      if a2s >= 0
        then a2 := a2c
        else a2 := 360 - a2c;

      da := a1 - a2;
      if da > 0
        then
          if da < 180
            then sign := -1
            else sign := 1
        else
          begin
            da := a2 - a1;
            if da < 180
              then sign := 1
              else sign := -1;
          end;

      if sign = -1
        then
          if a2 > a1
            then a2 := a2 - 360;
      if sign = 1
        then
          if a1 > a2
            then a1 := a1 - 360;
      angle := a1 + sign * angstep * CamAngle / 10;// через ? градусов

      xx := p2.x + cos( angle * pi / 180 ) * 0.5;
      yy := p2.y + sin( angle * pi / 180 ) * 0.5;
      dx := xx - p2.x;
      dy := yy - p2.y;
      d := sqrt( dx * dx + dy * dy );

      bz := ( CopyForm.Image1.Canvas.Pixels [ BitmapForm.GetBM_X ( p2.x ),
        BitmapForm.GetBM_Y ( p2.y ) ] and $ff );
//      zi := trunc ( bz / 255 * 50 );
      bz := ( Point.maxZ - Point.minZ ) * bz / 255 + Point.minZ + h0;

      p1.z := bz;
      p2.z := p1.z;
      p3.z := p2.z;

      zz := d * tan ( CamBetta * pi / 180);
      Visio2D.MyLine1( p2.x, p2.y, xx, yy );
      if SeeToPoint then begin
        v1.x := p2.x;
        v1.y := p2.y;
        v1.z := p2.z;
        v2.x := ObscurePoint.x;
        v2.y := ObscurePoint.y;
        v2.z := ObscurePoint.z;
      end else begin
        v1.x := p2.x;
        v1.y := p2.y;
        v1.z := p2.z;
        v2.x := xx;
        v2.y := yy;
        v2.z := ( p2.z - zz );
      end;
     SeeFromV1toV2( v1, v2, False );
      ddx := v2.x - v1.x;
      ddy := v2.y - v1.y;
      dd := sqrt ( sqr ( ddx ) + sqr ( ddy ) );{}
      if dd = 0 then dd := 1;

      DrawFont;

      for i:= 0 to TraektoryForm.Image1.Width - 1 do begin
        xi := trunc ( BitmapForm.GetBM_X ( Visio2D.GetX_1 ( trunc ( Visio2D.GetX ( p2.x ) + i * ddx / dd ) ) ) );
        yi := trunc ( BitmapForm.GetBM_Y ( Visio2D.GetY_1 ( trunc ( Visio2D.GetY ( p2.y ) - i * ddy / dd ) ) ) );
        if ( xi < CopyForm.Image1.Width ) and ( yi < CopyForm.Image1.Height )
           and ( xi >= 0  ) and ( yi >= 0 )
             then col := (CopyForm.Image1.Canvas.Pixels [ xi, yi ]) and $ff
             else col := 0;
//        hz := trunc ( ( ( Point.maxZ - Point.minZ ) * col / 255 + Point.minZ + h0 ) * 50 );
        col := trunc ( col / 255 * 50 );
        TraektoryForm.Image1.Canvas.MoveTo
        ( i, TraektoryForm.Image1.Height - col{hz} );
        TraektoryForm.Image1.Canvas.Pen.Color := clGreen;
        TraektoryForm.Image1.Canvas.LineTo ( i, TraektoryForm.Image1.Height);
      end;

      TraektoryForm.Image1.Canvas.Pen.Color := clBlack;
      TraektoryForm.Image1.Canvas.Rectangle
       ( 0, TraektoryForm.Image1.Height - (trunc ( p2.z / 255 * 50 ) ) - 1,
         3, TraektoryForm.Image1.Height - (trunc ( p2.z / 255 * 50 ) ) + 1 );

    SwapBuffers(DC);

      angstep := angstep + 1;
      if SeeToPoint then begin
        angle := a2;
        sign := 1;
        TrassMode := 1;
        angstep := 0;
        step := 0;
      end;
      if ( ( sign =  1 ) and ( angle >= a2 ) ) or
         ( ( sign = -1 ) and ( angle <= a2 ) ) then begin
        TrassMode := 1;
        angstep := 0;
        step := 0;
      end
     end;{-TrassMode and 2-}

    GDIFlush;
    InvalidateRect(Handle, nil, False);
  end;{-Flying-}
end;

procedure TVisio1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MClick := false;
end;

procedure TVisio1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MClick := true;
  X0 := X;
  Y0 := Y;
  Focus0 := Focus;
end;

procedure TVisio1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  r:real;
//  OldCursor : TCursor;
begin
  MainForm.StatusBar1.Panels[1].Text :=
    'X0 = ' + IntToStr( X0 ) + '; ' +
    'Y0 = ' + IntToStr( Y0 ) + '; ' +
    'X = ' + IntToStr( X ) + '; ' +
    'Y = ' + IntToStr( Y ) + '; ';
//  OldCursor := Screen.Cursor;
{  if SetObscurePoint
    then Cursor := crNo
    else Cursor := crDefault;//OldCursor;{}
  if not Flying then begin
    if MClick and not FocusChange then begin
      gamma := gamma + ( X - X0 ) / 2;
      betta := betta + ( Y - Y0 ) / 2;
      FormResize( Sender );
      InvalidateRect(Handle, nil, False);
      X0 := X;
      Y0 := Y;
    end else
    if MClick and FocusChange then begin
      r := sqrt ( sqr ( X - X0 ) + sqr ( Y - Y0 ) ) / 100;
      if IncreaseR
        then Focus := Focus0 - r
        else Focus := Focus0 + r;
      FormResize( Sender );
      InvalidateRect(Handle, nil, False);
    end;
  end;
end;

procedure TVisio1.PopMnuEndFlyClick(Sender: TObject);
begin
  Flying := false;
end;

procedure TVisio1.PopMnuIncreaseClick(Sender: TObject);
begin
  FocusChange := true;
  IncreaseR := true;
end;

procedure TVisio1.PopMnuDecreaseClick(Sender: TObject);
begin
  FocusChange := true;
  IncreaseR := false;
end;

procedure TVisio1.PopMnuEndScaleClick(Sender: TObject);
begin
  FocusChange := false;
end;

procedure TVisio1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  MainForm.Mnu3D.Checked := false;
  Visio1 := nil;
end;

end.
