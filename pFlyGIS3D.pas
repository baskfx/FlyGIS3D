unit pFlyGIS3D;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GL, GLU, ExtCtrls, Menus, StdCtrls, Math, Geometry, ImgList, ToolWin,
  ComCtrls, ExtDlgs, Buttons, Geom1, SimpThread, ActnList, Visio_1,
  Tabnotbk;

type

  // создаём новый класс исключения для отражения неудачной загрузки DLL
  EDLLLoadError = class(Exception);

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    MnuOptions: TMenuItem;
    MnuTriangulate: TMenuItem;
    MnuClear: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N9: TMenuItem;
    MnuExit: TMenuItem;
    MnuEdit: TMenuItem;
    MnuUndo: TMenuItem;
    MnuCopy: TMenuItem;
    MnuDelete: TMenuItem;
    MnuInsert: TMenuItem;
    MnuView: TMenuItem;
    MnuWindows: TMenuItem;
    MnuShutWins: TMenuItem;
    MnuHelp: TMenuItem;
    MnuAbout: TMenuItem;
    MnuGetIsolines: TMenuItem;
    MnuVectorize: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    MnuBitmapMake: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    MnuMakeXYZ: TMenuItem;
    SaveDialog2: TSaveDialog;
    MnuInfo: TMenuItem;
    MnuRefreshBMP: TMenuItem;
    MnuNegate: TMenuItem;
    N1: TMenuItem;
    MnuContents: TMenuItem;
    N3: TMenuItem;
    ImageList1: TImageList;
    MnuOpenFile: TMenuItem;
    MnuSaveFile: TMenuItem;
    CoolBar1: TCoolBar;
    StatusBar1: TStatusBar;
    ControlBar1: TControlBar;
    CameraTool: TToolBar;
    ToolButton4: TToolButton;
    FileTool: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    MainTool: TToolBar;
    ToolButton2: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton23: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton30: TToolButton;
    ToolButton28: TToolButton;
    ToolButton31: TToolButton;
    EditTools: TToolBar;
    ToolButton14: TToolButton;
    ToolButton20: TToolButton;
    TBGrabber: TToolButton;
    ToolButton22: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    N2: TMenuItem;
    Mnu3D: TMenuItem;
    MnuPoints: TMenuItem;
    MnuIsolines: TMenuItem;
    MnuTriangles: TMenuItem;
    MnuCamera: TMenuItem;
    MnuBitmap: TMenuItem;
    MnuTraektoryView: TMenuItem;
    MnuTraektParams: TMenuItem;
    N4: TMenuItem;
    MnuFileTools: TMenuItem;
    MnuMainTools: TMenuItem;
    MnuToolsView: TMenuItem;
    MnuCameraView: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    ActionList1: TActionList;
    acOpenFile: TAction;
    acSaveFile: TAction;
    acPrintWindow: TAction;
    acHorizontal: TAction;
    acVertical: TAction;
    acCascade: TAction;
    acInfoWindow: TAction;
    acZoomIn: TAction;
    acZoomOut: TAction;
    acClearAll: TAction;
    acShowWindow: TAction;
    acHideWindow: TAction;
    acSetup: TAction;
    acCameraShow: TAction;
    acFly: TAction;
    acPause: TAction;
    acPrevPoint: TAction;
    acNextPoint: TAction;
    acStop: TAction;
    acHelp: TAction;
    acMoveWindow: TAction;
    acSelectPoint: TAction;
    acDeletePoint: TAction;
    acNone: TAction;
    acMakeRaster: TAction;
    acGetZones: TAction;
    acTriangulate: TAction;
    acSetVPoint: TAction;
    acGetIsolines: TAction;
    acSetObscure: TAction;
    acMakeDTM: TAction;
    N12: TMenuItem;
    acSetup1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    MnuRotating: TMenuItem;
    MnuVisibleZone: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    MnuSetObscurePoint: TMenuItem;
    MnuSetVisiblePoint: TMenuItem;
    MnuTraektory: TMenuItem;
    MnuFly: TMenuItem;
    N18: TMenuItem;
    TBSetTraektory: TToolButton;
    acSetTraektory: TAction;
    ToolButton33: TToolButton;
    acEndTraektory: TAction;
    ToolButton11: TToolButton;
    ToolButton32: TToolButton;
    ToolButton19: TToolButton;
    acUndo: TAction;
    MnuShadeModel: TMenuItem;
    MnuTINisolines: TMenuItem;
    DLLHeightRaster1: TMenuItem;
    BitmapDLL1: TMenuItem;
    ToolButton21: TToolButton;
    procedure MnuRotatingClick(Sender: TObject);
    procedure MnuTriangulateClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure MnuClearClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure MnuTriCellClick(FileName: string);
    procedure MnuTraektoryClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure MnuFlyClick(Sender: TObject);
    procedure MapInfoMIFMID1Click(FileName: string);
    procedure MnuPointsOpenClick(FileName: string);
    procedure MnuTrianglesSaveClick(Sender: TObject);
    procedure Mnu3DClick(Sender: TObject);
    procedure MnuExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MnuShutWinsClick(Sender: TObject);
    procedure MnuBitmapOpenClick(FileName: string);
    procedure MnuBitmapClick(Sender: TObject);
    procedure MnuCameraClick(Sender: TObject);
    procedure MnuTraektoryViewClick(Sender: TObject);
    procedure MakeBitmap1Click(Sender: TObject);
    procedure MnuBitmapSaveClick(Sender: TObject);
    procedure MnuGetIsolinesClick(Sender: TObject);
    procedure MnuSetObscurePointClick(Sender: TObject);
    procedure VRML101Click(Sender: TObject);
    procedure VRML1Click(FileName: string);
    procedure MnuAboutClick(Sender: TObject);
    procedure MnuTraektParamsClick(Sender: TObject);
    procedure MnuSetVisiblePointClick(Sender: TObject);
    procedure MnuUndoClick(Sender: TObject);
    procedure MnuVisibleZoneClick(Sender: TObject);
    procedure MnuMakeXYZClick(Sender: TObject);
    procedure MnuInfoClick(Sender: TObject);
    procedure MnuRefreshBMPClick(Sender: TObject);
    procedure AboutBitBtnClick(Sender: TObject);
    procedure MnuNegateClick(Sender: TObject);
    procedure MyIdleHandler(Sender: TObject; var Done: Boolean);
    procedure N1Click(Sender: TObject);
    procedure MnuContentsClick(Sender: TObject);
    procedure SavePointsClick(Sender: TObject);
    procedure acOpenFileExecute(Sender: TObject);
    procedure ToolButton25Click(Sender: TObject);
    procedure ToolButton26Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure acSetupExecute(Sender: TObject);
    procedure ToolButton23Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure acEndTraektoryExecute(Sender: TObject);
    procedure TBGrabberClick(Sender: TObject);
    procedure UpdateMenu(Sender: TObject);
    procedure MnuFileToolsClick(Sender: TObject);
    procedure MnuMainToolsClick(Sender: TObject);
    procedure MnuToolsViewClick(Sender: TObject);
    procedure MnuCameraViewClick(Sender: TObject);
    procedure MnuShadeModelClick(Sender: TObject);
    procedure MnuTINisolinesClick(Sender: TObject);
    procedure MnuPointsClick(Sender: TObject);
    procedure DLLHeightRaster1Click(Sender: TObject);
    procedure BitmapDLL1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
  private
  protected
  public
  end;

var
  MainForm: TMainForm;

  Flying, Rotate : boolean;
  MonoChromate : boolean;
  X0, Y0 : integer;
  Focus, Focus0 : real;
  angle, angstep, step: real;
  alpha, betta, gamma : real;
  trace : integer;
  TrassMode : byte;       // режим построения 3D-модели (1-...)
  SetObscurePoint : boolean = false;
  SetVisiblePoint : boolean = false;
  SetVisibleLine  : boolean = false;
  SetTraektory    : boolean = false;
  ClearVisibleLine: boolean = false;
  DrawViewing     : boolean = false;
  ObscurePoint,           // точка, вокруг которой происходит облёт
  VisiblePoint : TMyPoint;// точка, для которой расчитывается зона видимости

  Mode2D : integer;

  LibHandle: THandle;

implementation

uses pCamera, Visio_2, pSetup, pTraektoryForm, PM_Messages,
     pIsoline, Process, VRMLtype, About, pTraektTable, FormCopy,
     pVisibleZone, pInfo, pBuffer, pMapInfo, pBitmap;

{$R *.DFM}

procedure TMainForm.UpdateMenu(Sender: TObject);
begin
  MnuFileTools.Checked := FileTool.Visible;
  MnuMainTools.Checked := MainTool.Visible;
  MnuToolsView.Checked := EditTools.Visible;
  MnuCameraView.Checked := CameraTool.Visible;
end;

procedure CreateChild3D;
begin
{
  if Child3D <> nil then Child3D.Destroy;

  Child3D := TVisio1.Create( Application );
  Child3D.Caption := 'Трёхмерная модель местности';
}
  if Visio1 <> nil then Visio1.Destroy;

  Visio1 := TVisio1.Create( Application );
  Visio1.Caption := PM_MODEL_3D;
end;

procedure CreateMapInfoChild;
begin
  if MapInfoForm <> nil then MapInfoForm.Destroy;

  MapInfoForm := TMapInfoForm.Create( Application );
//  MapInfoForm.Caption := '';
end;

function GetFileName ( s : string ) : string;
var
  n, k : integer;
begin
  k := length ( s ) - 4;
  if s [ k + 1 ] <> '.' then k := length ( s );
  n := k;
  while ( s[n] <> '\' ) and ( s[n] <> ':' ) and  ( s[n] <> '' ) do
    n := n - 1;
  k := k - n;
  GetFileName := copy ( s, n + 1, k );
end;

procedure LoadPointsFrom(name:string);
var
  f : TextFile;
  x, y, z : real;
  p : TMyPoint;
begin
  MainForm.Cursor:=crHourGlass;
  AssignFile(f,name);
  Reset(f);
  Point.Points := 0;
  while not eof(f) do begin
    readln( f, x, y, z );
    y:=-y; {-invert Coordinate System !!!-}
    P.x:=x;
    P.y:=y;
    P.z:=z;
    if Point.points = 0
      then AddFirstP ( Point, P )
      else AddNextP( Point, p );
  end;
  PlayPoints ( Point );
  CloseFile(f);
  MainForm.Cursor:=crDefault;
end;

procedure TMainForm.MnuRotatingClick(Sender: TObject);
begin
  Rotate:=not Rotate;
  Flying:=False;
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

procedure LoadSurfaceFrom(name:string);
var
  f: TextFile;
  i, n: integer;
  p1, p2, p3: TMyPoint;
begin
  MainForm.Cursor:=crHourGlass;
  Fname:=name;
  AssignFile(f,name);
  Reset(f);
  readln(f, n);

  Point.points := 0;
  Triangle.curr := Triangle.head;
  for i:=1 to n do begin
    readln( f, p1.x, p1.y, p1.z );
    readln( f, p2.x, p2.y, p2.z );
    readln( f, p3.x, p3.y, p3.z );
    AddTriangle( p1, p2, p3 );
    if Point.points = 0
      then AddFirstP( Point, p1 )
      else AddNextP( Point, p1 );
    Triangle.curr := Triangle.curr^.mynext;
  end;
  CloseFile(f);
  PlayPoints( Point );
  MainForm.Cursor:=crDefault;
  MainForm.Caption:= GetFileName ( name ) + ' - ' + PM_MAIN_HEADER;
end;

procedure Triangulate ( s : TMyListPoint;
        var Triangle : TMyListTriangle; var triangles : integer );
var
  e : TEdge;
  p : TMyPoint;
  frontier : TMyListEdge;
  t : TTriangle;
begin
  BreakProcess := False;
  Triangle.Triangles := 0;
  Triangle.head := nil;
  Triangle.last := nil;

  frontier.head := nil;
  frontier.last := nil;
  frontier.length := 0;

  hullEdge ( s, e );

  AddFirst( frontier, e );

  ProcessForm.Caption := PM_PROCESS_HEADER;
  ProcessForm.Show;
  ProcessForm.Gauge1.Visible := False;
  ProcessForm.Repaint;

  while frontier.length > 0 do begin
    removeMin ( frontier, e );
    if mate ( e, s, p ) then begin
      update1 (frontier, p, e.org );
      update1 ( frontier, e.dest, p );
      AddTriangle( p, e.org, e.dest );
      ProcessForm.Label1.Caption := 'Треугольников: ' +
        IntToStr( Triangle.triangles );
      ProcessForm.Label1.Repaint;
      Application.ProcessMessages;
      if BreakProcess
        then
          if Application.MessageBox(
           PChar(PM_BREAK_TRIANGULATION), PChar(PM_ATTENTION_HEADER), MB_OKCANCEL) = IDOK
           then
             begin
               Triangle.triangles := 0;
               break;
             end
           else BreakProcess := False;
    end; //-case-
  end;
  ProcessForm.Close;
  ProcessForm.Gauge1.Visible := True;
end;

procedure TMainForm.MnuTriangulateClick(Sender: TObject);
begin
  // Предупреждение: нет точек для триангуляции!
  if Point.points = 0 then begin
    case Application.MessageBox(
    PChar(PM_NO_POINTS_MSG),
    PChar(PM_ATTENTION_HEADER), MB_OK) of
    IDOK :
      begin
      end
    end; //-case-
  end;
{
  // подтверждение отмены триангуляции
  if Triangle.triangles <> 0 then begin
    case Application.MessageBox(
      PChar(PM_TN_WAS_CREATED_CONTINUE),
      PChar(PM_ATTENTION_HEADER), MB_OKCANCEL) of
      IDOK : begin end
      else exit
    end; //-case-
  end;
}
  Screen.Cursor := crHourGlass;
  vModel3DType := 0;

  Triangulate ( Point, Triangle, Triangle.triangles );

  MnuRotating.Enabled := true;
  MnuTriangles.Enabled := true;
  MnuPoints.Checked := false;
  MnuIsolines.Checked := false;
  MnuTriangles.Checked := false;
  MnuBitmapMake.Enabled := true;
  MnuTraektory.Enabled := true;
  MnuClear.Enabled := true;

  SetupForm.Model3DType.ItemIndex := 0;
  vModel3DType := SetupForm.Model3DType.ItemIndex;
  InvalidateRect(Handle, nil, False);
  Screen.Cursor := crDefault;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.MnuClearClick(Sender: TObject);
begin
  points:=0;
  Point.points := 0;
  Triangle.triangles:=0;
  TrPoints := 0;
  MainForm.Caption:= PM_MAIN_HEADER;
  MnuTriangulate.Enabled:=false;
  MnuRotating.Enabled:=false;
  SeeToPoint := false;
  Visio2D.Image1.Canvas.Brush.Color:=clWhite;
  Visio2D.Image1.Canvas.Pen.Color:=clWhite;
  Visio2D.Image1.Canvas.Rectangle(0,0,Width,Height);
  Visio2D.Image1.Canvas.Pen.Color:=clBlack;
  InvalidateRect(Handle, nil, False);
  GDIFlush;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  FocusChange:=true;
  Focus0:=Focus;
  IncreaseR:=true;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  FocusChange:=true;
  Focus0:=Focus;
  IncreaseR:=false;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Visio1.FormDestroy(Sender);
  Application.Terminate;
end;

procedure TMainForm.MnuTriCellClick(FileName: string);
// Открываем ТС - набор треугольников
begin
//  if OpenDialog1.Execute
//    then begin
      SeeToPoint := False;
      TrPoints := 0;
      Point.points := 0;
      Triangle.triangles := 0;
      CreateChild3D;
      LoadSurfaceFrom(OpenDialog1.FileName);
      MnuTraektory.Enabled := True;
      MnuTriangles.Enabled := true;
      MnuRotating.Enabled := true;
      MnuBitmapMake.Enabled := true;
      MnuTraektory.Enabled := true;
      MnuClear.Enabled := true;
//    end;
end;

procedure ReadData( s : string; from : integer; delimiter : char;
                     var data : string; var LastIndex : integer);
// читаем из строки s данные в data, начиная с позиции from до символа delimiter
var
  i: integer;
begin
  s := s + delimiter;
  i := from;
  while i <= length( s ) do begin
    LastIndex := i;
    data := copy( s, from, i - from );
    if s[i] = delimiter then exit;
    i := i + 1;
  end;
end;

procedure LoadPointsFrom_Mif_Mid(name:string);
var
  f, fMID : TextFile;
  m, i, k : integer;
  MidString, FullMifString, MifString, MIDname, MIDz : string;
  x, y, z : real;
  com : string;
  Fname : string;
  err : integer;
  columns, plines : integer;
  p : TMyPoint;
  DontRead : boolean;
begin
  Fname:=copy(name,1,length(name)-4);
  AssignFile( f, Fname + '.MIF' );
  Reset( f );
  MIDname := Fname + '.MID';
  Assign(fMID,MIDname);
  Reset(fMID);
  MifString:='';
  while MifString <> MIF_COLUMNS do begin
    readln(f,FullMifString);
    MifString:=copy(FullMifString,1,7);
  end;
  columns:=StrToInt(copy(FullMifString,9,length(FullMifString)-8) );
  m:=0;
  for i:=1 to columns do begin
    readln(f,FullMifString);
    ReadData(FullMifString,3,#32,MifString,k);
    if MifString = MIF_ABSOLUTE_HEIGHT then m:=i;
  end;
  m := 7;
  Point.points := 0;
  Polyline.polylines := 0;
  while not eof(f) do begin
   readln(f,com);
   if copy(com,1,5) = MIF_PLINE then begin
     plines := StrToInt(copy(com,6,length(com)-5));
     readln( fMID, MidString );
     ReadData( MidString, 1, ',', MIDz, k );
     DontRead := false;
     for i:=2 to m do begin
       ReadData( MidString, k+1, ',', MIDz, k );
//       if ( i = 4 ) and ( MIDz <> '21200000' ) then DontRead := true;
     end;
     MIDz:=copy(MIDz,2,length(MIDz)-2);
     val( MIDz, z, err );
     for i:=1 to plines do begin
       readln(f,x,y);
       if DontRead then continue;
       y := y; {-DON'T invert Coordinate System !!!-}
       P.x := x;
       P.y := y;
       P.z := z;
       if Point.points = 0
         then AddFirstP( Point, P )
         else AddNextP ( Point, P );
     end;
   end;{-if-}
  end;{-while-}
  PlayPoints ( Point );
  CloseFile(f);
  CloseFile(fMID);
end;

procedure TMainForm.MnuTraektoryClick(Sender: TObject);
begin
  MnuUndo.Enabled := false;
  SetVisiblePoint := false;
  SetObscurePoint := false;
  SeeToPoint := False;
  SetTraektory := true;
  BitmapForm.ClearTraektory2D;
  Screen.Cursor := crCross;
  TBSetTraektory.Down := True;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  Flying:=false;
  trace:=0;
  Visio1.FormResize(Sender);
end;

procedure TMainForm.MnuFlyClick(Sender: TObject);
begin
  if TrPoints = 0 then begin
    MessageDlg ( PM_NO_TRAEKTORY, mtWarning, [mbOk], 0 );
    exit;
  end;
  step := 0;
  angstep := 0;
  Flying := not Flying;
//  MnuFly.Checked := Flying;
  Rotate := false;
end;

procedure TMainForm.MapInfoMIFMID1Click(FileName: string);
// Открываем файл MapInfo
begin
    begin
      SeeToPoint := False;
      TrPoints := 0;
      Point.points := 0;
      Triangle.triangles := 0;
      MainForm.Caption:= GetFileName (FileName) + ' - ' + PM_MAIN_HEADER;
      LoadPointsFrom_Mif_Mid(FileName);
      CreateChild3D;
      CreateMapInfoChild;
      MapInfoForm.Show;
      MapInfoForm.DrawPoints( Point );
      SetupForm.Model3DType.ItemIndex := 3;
      vModel3DType := SetupForm.Model3DType.ItemIndex;
      MnuTriangulate.Enabled := true;
      MnuPoints.Enabled := true;
      MnuClear.Enabled := true;
      Triangle.Triangles := 0;
      Repaint;
    end;
end;

procedure TMainForm.MnuPointsOpenClick(FileName: string);
// Открываем набор точек из ASCII-файла
begin
//  if OpenDialog1.Execute then
    begin
      SeeToPoint := False;
      TrPoints := 0;
      Point.points := 0;
      Triangle.triangles := 0;
      MainForm.Caption:= GetFileName (FileName) + ' - ' + PM_MAIN_HEADER;
      LoadPointsFrom(FileName);
      MnuTriangulate.Enabled := true;
      MnuPoints.Enabled := true;
      MnuClear.Enabled := true;
    end;
  Triangle.Triangles:=0;
  Repaint;
end;

procedure TMainForm.MnuTrianglesSaveClick(Sender: TObject);
var
  i:integer;
  f:TextFile;
begin
  SaveDialog1.InitialDir:=Fname;
//  if SaveDialog1.Execute then
    begin
      AssignFile(f,SaveDialog1.FileName);
      rewrite(f);
      writeln(f, Triangle.triangles);
      Triangle.curr := Triangle.head;
      for i:=1 to Triangle.triangles do begin
        writeln(f,Triangle.curr^.triangle.v[0].x,' ',Triangle.curr^.triangle.v[0].y,' ',Triangle.curr^.triangle.v[0].z);
        writeln(f,Triangle.curr^.triangle.v[1].x,' ',Triangle.curr^.triangle.v[1].y,' ',Triangle.curr^.triangle.v[1].z);
        writeln(f,Triangle.curr^.triangle.v[2].x,' ',Triangle.curr^.triangle.v[2].y,' ',Triangle.curr^.triangle.v[2].z);
        Triangle.curr := Triangle.curr^.mynext;
      end;
      CloseFile(f);
      MainForm.Caption:= GetFileName ( SaveDialog1.FileName ) + ' - ' + PM_MAIN_HEADER;
    end;
end;

procedure TMainForm.Mnu3DClick(Sender: TObject);
begin
  Visio1.FormResize(Sender);
  Mnu3D.Checked := not Mnu3D.Checked;
  Visio1.Visible := Mnu3D.Checked;
end;

procedure TMainForm.MnuExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Mode2D := 0;
  TrPoints := 0;
  vModel3DType := 3;
  SetObscurePoint := false;
  SetVisiblePoint := false;
  SetTraektory := false;
end;

procedure TMainForm.MnuShutWinsClick(Sender: TObject);
begin
  Mode2d := 0;
end;

procedure TMainForm.MnuBitmapOpenClick(FileName: string);
// Открываем полутоновое изображение местности
// (BMP-файл)
var
  i, j : integer;
  c : longint;
  r, g, b : byte;
begin
  if OpenPictureDialog1.Execute then begin
    SeeToPoint := False;
    BitmapForm := TBitmapForm.Create(Application);
    BitmapForm.ClearTraektory2D;
    BitmapForm.Image1.AutoSize := True;
    BitmapForm.Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
//    BitmapForm.Show;
    TrPoints := 0;
    points := 0;
    // анализ изображения
    MonoChromate := true;
    for j := 0 to BitmapForm.Image1.Height - 1 do
      for i := 0 to BitmapForm.Image1.Width - 1 do begin
        c := BitmapForm.Image1.Canvas.Pixels [ i, j ];
        r :=   c and $ff;
        g := ( c and $ff00 ) shr 8;
        b := ( c and $ff0000 ) shr 16;
        MonoChromate := ( r = g ) and ( g = b );
        if not MonoChromate then break;
      end;
    if MonoChromate then begin
      CopyForm.Image1.Picture.Create;
      CopyForm.Image1.AutoSize := True;
      CopyForm.Image1.Picture := BitmapForm.Image1.Picture;
//      CopyForm.Image1.Picture.Width := BitmapForm.Image1.Width;
//      CopyForm.Image1.Picture.Height := BitmapForm.Image1.Height;
{      if Point.points = 0 then begin
        Point.minX := - ( CopyForm.Image1.Width  / 2 ) * 0.008811;
        Point.maxX :=   ( CopyForm.Image1.Width  / 2 ) * 0.008811;
        Point.minY := - ( CopyForm.Image1.Height / 2 ) * 0.008811;
        Point.maxY :=   ( CopyForm.Image1.Height / 2 ) * 0.008811;
        Point.minZ := 0;
        Point.maxZ := 1;
        tOffsX := 0;
        tOffsY := 0;
        tOffsZ := 0;
      end;
}
      MnuBitmap.Enabled := true;
      MnuBitmap.Checked := true;
      MnuGetIsolines.Enabled := true;
      MnuTraektory.Enabled := true;
      MnuClear.Enabled := true;
      TraektoryForm.Image1.Picture.Create;
    end
    else begin
      MessageDlg( PM_NOT_GRAYSCALE_IMAGE_MSG, mtWarning, [mbOk], 0 );
    end;
  end;
end;

procedure TMainForm.MnuBitmapClick(Sender: TObject);
begin
  MnuBitmap.Checked := not MnuBitmap.Checked;
  BitmapForm.Visible := MnuBitmap.Checked;
end;

procedure TMainForm.MnuCameraClick(Sender: TObject);
begin
  MnuCamera.Checked := not MnuCamera.Checked;
  CameraForm.Visible := MnuCamera.Checked;
end;

procedure TMainForm.MnuTraektoryViewClick(Sender: TObject);
begin
  MnuTraektoryView.Checked := not MnuTraektoryView.Checked;
  TraektoryForm.Visible := MnuTraektoryView.Checked;
  if TraektoryForm.Visible then Visio1.DrawFont;
end;

procedure TMainForm.MyIdleHandler(Sender: TObject; var Done: Boolean);
begin
  ProcessForm.BitBtn1Click( Sender );
end;

procedure TMainForm.MakeBitmap1Click(Sender: TObject);
var
  i : longint;
  x, y : longint;
  last : TTriangle;
  col : byte;
  z : real;
  find : TTriangle;
  p : TMyPoint;
  xx, yy : real;
  d : real;
  a, b, nv : TVector;
  LineB : pByteArray;
  scX, scY : longint;
  Hour0, Min0, Sec0, MSec0,
  Hour1, Min1, Sec1, MSec1: Word;
  mSecs0, mSecs1, mSecs2, mSecs: longint;
begin

  if Triangle.triangles = 0 then begin
    MessageDlg( PM_NO_TRIANGULATION_NETWORK, mtWarning, [mbOk], 0 );
    exit;
  end;

  Screen.Cursor := crHourGlass;

  BitmapForm := TBitmapForm.Create(Application);
  BitmapForm.ClearTraektory2D;

  BitmapForm.Show;

//  CopyForm.Image1.AutoSize := false;
//{?}  CopyForm.Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 );
//{?}  CopyForm.Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 );

  ProcessForm.Caption := PM_HEIGHT_RASTER_HEADER;
  ProcessForm.Label1.Caption := PM_HEIGHT_RASTER_PROCESS;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;

  DecodeTime( Time, Hour0, Min0, Sec0, MSec0 );
  mSecs0 := MSec0 + Sec0*1000 + Min0*60*1000 + Hour0*60*60*1000;
  last := Triangle.head^.Triangle;
  BitmapForm.Image1.Picture.Bitmap.PixelFormat := pf24bit;
  for y := 0 to BitmapForm.Image1.Height - 1 do begin
    scY := BitmapForm.Image1.Height - y-1;
    LineB := BitmapForm.Image1.Picture.Bitmap.ScanLine[ scY ];
    for x := 0 to BitmapForm.Image1.Width - 1 do begin
      xx := Point.minX + x * ( Point.maxX - Point.minX ) / ( BitmapForm.Image1.Width - 1 );
      yy := Point.minY + y * ( Point.maxY - Point.minY ) / ( BitmapForm.Image1.Height - 1 );
      p.x := xx;
      p.y := yy;
      find := Triangle.head^.Triangle;
      col := 0;
      if InTriangle1( p, last ) then begin
        find := last;
      end else
      Triangle.curr := Triangle.head;
      for i := 1 to Triangle.triangles do begin
        if InTriangle1( p, Triangle.curr^.Triangle ) then begin
          find := Triangle.curr^.Triangle;
          last := Triangle.curr^.Triangle;
          break;
       end;
       Triangle.curr := Triangle.curr^.mynext;
      end;
      if @find<>nil then begin
        with find do begin
          a.x := v[1].x - v[0].x;
          a.y := v[1].y - v[0].y;
          a.z := v[1].z - v[0].z;
          b.x := v[2].x - v[0].x;
          b.y := v[2].y - v[0].y;
          b.z := v[2].z - v[0].z;
          nv.x :=    a.y * b.z - a.z * b.y;
          nv.y := - (a.x * b.z - a.z * b.x);
          nv.z :=    a.x * b.y - a.y * b.x;
          d := - v[0].x * nv.x - v[0].y * nv.y - v[0].z * nv.z;
        end;
        if nv.z <> 0
          then Z := ( - xx * nv.x - yy * nv.y - d ) / nv.z  {-type A-}
          else Z := 0;
        col := trunc( 255 * ( ( Z - Point.minZ ) / ( Point.maxZ - Point.minZ ) ) );
        col := 255 - col;
      end;
      scX := 3*x;
      BitmapForm.Image1.Canvas.Pixels [x, CopyForm.Image1.Height - y] := RGB ( col, col, col );
{
      LineB^[ scX ]     := col; // R
      LineB^[ scX + 1 ] := col; // G
      LineB^[ scX + 2 ] := col; // B{}
    end;// x
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( y + 1 ) / BitmapForm.Image1.Height );
    DecodeTime( Time, Hour1, Min1, Sec1, MSec1 );
    mSecs1 := MSec1 + Sec1*1000 + Min1*60*1000 + Hour1*60*60*1000;
    mSecs := mSecs1 - mSecs0;
    if ProcessForm.Gauge1.Progress <> 0
      then mSecs2 := trunc( mSecs / ProcessForm.Gauge1.Progress * ( 100 - ProcessForm.Gauge1.Progress ) );
    ProcessForm.Label1.Caption := PM_HEIGHT_RASTER_PROCESS + ' Прошло: ' +
      IntToStr( mSecs div 1000 ) + ' сек., осталось: ' + IntToStr(mSecs2 div 1000) + ' сек.      ';
    ProcessForm.Label1.Repaint;
  end;// y

  CopyForm.Image1.Picture.Bitmap.Width := BitmapForm.Image1.Width;
  CopyForm.Image1.Picture.Bitmap.Height := BitmapForm.Image1.Height;
  CopyForm.Image1.Width := BitmapForm.Image1.Width;
  CopyForm.Image1.Height := BitmapForm.Image1.Height;
  CopyForm.Image1.Picture := BitmapForm.Image1.Picture;

  ProcessForm.Hide;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.MnuBitmapSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
    CopyForm.Image1.Picture.SaveToFile( SavePictureDialog1.FileName );
end;

procedure TMainForm.MnuGetIsolinesClick(Sender: TObject);
var
  i, j : integer;
  a, b, c : longint;
begin
  Screen.Cursor := crHourGlass;

  IsolineForm.Image1.AutoSize := false;
//  IsolineForm.Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 );
//  IsolineForm.Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 );
  IsolineForm.Show;
  CopyForm.Image1.AutoSize := false;
//  CopyForm.Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 );
//  CopyForm.Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 );
  BufferForm.Image1.AutoSize := false;
//  BufferForm.Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 );
//  BufferForm.Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 );
  IsolineForm.Image1.Picture := CopyForm.Image1.Picture;
  ProcessForm.Caption := PM_GET_ISOLINES_HEADER;

  ProcessForm.Label1.Caption := PM_DISCRETISATION_MSG1 +
   IntToStr ( Discrette ) + PM_DISCRETISATION_MSG2;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;

  for j := 0 to CopyForm.Image1.Height - 1 do begin
    for i := 0 to CopyForm.Image1.Width - 1 do begin
      a  := CopyForm.Image1.Canvas.Pixels [ i, j ] and $ff;
      a := ( a div Discrette ) * Discrette;{}
      BufferForm.Image1.Canvas.Pixels [ i, j ] := RGB ( a, a, a );
      IsolineForm.Image1.Canvas.Pixels [ i, j ] := clBlack;
    end;
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( j + 1 ) / CopyForm.Image1.Height );
    GDIFlush;
  end;

  IsolineForm.Repaint;
  ProcessForm.Label1.Caption := PM_GET_ISOLINES_PROCESS;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;
  GDIFlush;

  for j := 1 to CopyForm.Image1.Height - 1 do begin
    for i := 1 to CopyForm.Image1.Width - 1 do begin
//      gi1j := pByteArray(CopyForm.Image1.Picture.Bitmap.ScanLine[j]^)[i+1];
//      gij := pByteArray(CopyForm.Image1.Picture.Bitmap.ScanLine[j]^)[i];
//      gij1 := pByteArray(CopyForm.Image1.Picture.Bitmap.ScanLine[j+1]^)[i];
      a := BufferForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] and $ff;
      b := BufferForm.Image1.Canvas.Pixels[ i, j - 1 ] and $ff;
      c := BufferForm.Image1.Canvas.Pixels[ i - 1, j ] and $ff;

      if ( a <> b ) and ( ( IsolineForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] and $ff ) = 0)
       and ( ( IsolineForm.Image1.Canvas.Pixels[ i, j - 1 ] and $ff ) = 0)
        then begin
          IsolineForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] := RGB( a, a, a );
          IsolineForm.Image1.Canvas.Pixels[ i, j - 1 ] := RGB( b, b, b );
          if ShowIsolines then begin
            BitmapForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] := clWhite;
            BitmapForm.Image1.Canvas.Pixels[ i, j - 1 ] := clWhite;
          end;
        end;
      if ( a <> c ) and ( ( IsolineForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] and $ff ) = 0)
       and ( ( IsolineForm.Image1.Canvas.Pixels[ i - 1, j ] and $ff ) = 0)
        then begin
          IsolineForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] := RGB( a, a, a );
          IsolineForm.Image1.Canvas.Pixels[ i - 1, j ] := RGB( c, c, c );
          if ShowIsolines then begin
            BitmapForm.Image1.Canvas.Pixels[ i - 1, j - 1 ] := clWhite;
            BitmapForm.Image1.Canvas.Pixels[ i - 1, j ] := clWhite;
          end;
        end;
    end;
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( j + 1 ) / CopyForm.Image1.Height );
    GDIFlush;
  end;
  ProcessForm.Hide;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.MnuSetObscurePointClick(Sender: TObject);
begin
  BitmapForm.Show;
  SetVisiblePoint := false;
  SetTraektory := false;
  SetObscurePoint := not SetObscurePoint;
  if SetObscurePoint then Screen.Cursor := crCross;
end;

procedure TMainForm.VRML101Click(Sender: TObject);
// Note: запись нерациональна из-за многократного использования одних и тех же точек
// Устранение: не запоминать все треугольники, а запоминать только индексы точек, связывающихся между собой
var
  ft : TextFile;
  i, j : integer;
begin
  if SaveDialog2.Execute then begin
    AssignFile ( ft, SaveDialog2.FileName );
    Rewrite ( ft );
    writeln ( ft, '#VRML V1.0 ascii' );
    writeln ( ft, 'Separator {' );
      writeln ( ft, #9, 'DEF SceneInfo Info {' );
        writeln ( ft, #9, #9, 'string "Converted by wcvt2pov v2.7"' );
      writeln ( ft, #9, '}' );
      writeln ( ft, #9, 'ShapeHints {' );
        writeln ( ft, #9, #9, 'vertexOrdering CLOCKWISE' );
        writeln ( ft, #9, #9, 'shapeType SOLID' );
        writeln ( ft, #9, #9, 'faceType CONVEX' );
        writeln ( ft, #9, #9, 'creaseAngle 0.0' );
      writeln ( ft, #9, '}' );
(*      writeln ( ft, #9, 'Perspective Camera {' );
        write   ( ft, #9, #9, 'position ' );
          writeln ( ft, 0.0 :0:6, #32, 0.0 :0:6, #32, 1.0 :0:6, #32 );
        write   ( ft, #9, #9, 'orientation ' );
          writeln ( ft, 0.0 :0:6, #32, 0.0 :0:6, #32, 1.0 :0:6, #32, 0.0 :0:6, #32 );
        writeln ( ft, #9, #9, 'focalDistance ', 5 );
        writeln ( ft, #9, #9, 'heightAngle ',0.785398 :0:6 );
      writeln ( ft, #9, '}' );*)
      writeln ( ft, #9, 'DEF ;RAW Separator {' );//terrain
        writeln ( ft, #9, #9, 'Material {' );
          write   ( ft, #9, #9, #9, 'ambientColor ' );
          writeln ( ft, 1.0 :0:6, #32, 1.0 :0:6, #32, 1.0 :0:6, #32 );
          write   ( ft, #9, #9, #9, 'diffuseColor ' );
          writeln ( ft, 1.0 :0:6, #32, 1.0 :0:6, #32, 1.0 :0:6, #32 );
          write   ( ft, #9, #9, #9, 'specularColor ' );
          writeln ( ft, 0.8 :0:6, #32, 0.8 :0:6, #32, 0.8 :0:6, #32 );
          write   ( ft, #9, #9, #9, 'shininess ' );
          writeln ( ft, 0.1 :0:6 );
        writeln ( ft, #9, #9, '}' );
        if SetupForm.Model3DType.ItemIndex = 2
          then begin
            writeln ( ft, #9, #9, 'Texture2 {' );
            writeln ( ft, #9, #9, #9, 'filename "', TextureName, '"' );
            writeln ( ft, #9, #9, '}' );
          end;
        writeln ( ft, #9, #9, 'Coordinate3 {' );
          writeln   ( ft, #9, #9, #9, 'point [' );
          Triangle.curr := Triangle.head;
          for i := 1 to Triangle.triangles do begin
            for j := 0 to 2 do begin
              write ( ft, #9, #9, #9, #9 );
              write ( ft, Triangle.curr^.triangle.v[j].x:0:6, #32 );
              write ( ft, Triangle.curr^.triangle.v[j].y:0:6, #32 );
              write ( ft, Triangle.curr^.triangle.v[j].z:0:6, #32 );
              if ( i = Triangle.triangles ) and ( j = 2 )
                then writeln ( ft )
                else writeln ( ft, ',' );
            end;//j
            Triangle.curr := Triangle.curr^.mynext;
          end;//i
          writeln   ( ft, #9, #9, #9, ']' );
        writeln ( ft, #9, #9, '}' );
        writeln ( ft, #9, #9, 'IndexedFaceSet {' );
          writeln   ( ft, #9, #9, #9, 'coordIndex [' );
          Triangle.curr := Triangle.head;
          for i := 1 to Triangle.triangles do begin
            write ( ft, #9, #9, #9, #9 );
            write ( ft, ( i * 3 - 3 ), ' , ' );
            write ( ft, ( i * 3 - 2 ), ' , ' );
            write ( ft, ( i * 3 - 1 ), ' , ' );
            if ( i = Triangle.triangles )
              then writeln ( ft, ( -1 ) )
              else writeln ( ft, ( -1 ), ' , ' );
            Triangle.curr := Triangle.curr^.mynext;
          end;//i
          writeln   ( ft, #9, #9, #9, ']' );
        writeln ( ft, #9, #9, '}' );
      writeln ( ft, #9, '}' );
      writeln ( ft, #9, 'DEF traektory Separator {' );
        writeln ( ft, #9, #9, 'Coordinate3 {' );
          writeln   ( ft, #9, #9, #9, 'point [' );
          for i := 1 to TrPoints do begin
            write ( ft, #9, #9, #9, #9 );
            write ( ft, Traektory[i].x:0:6, #32 );
            write ( ft, Traektory[i].y:0:6, #32 );
            write ( ft, Traektory[i].z:0:6, #32 );
            if ( i = TrPoints )
              then writeln ( ft )
              else writeln ( ft, ',' );
          end;//i
          writeln   ( ft, #9, #9, #9, ']' );
        writeln ( ft, #9, #9, '}' );
        writeln ( ft, #9, #9, 'IndexedLineSet {' );
          writeln   ( ft, #9, #9, #9, 'coordIndex [' );
          write ( ft, #9, #9, #9, #9 );
          for i := 1 to TrPoints do begin
            write ( ft, ( i - 1 ), ' , ' );
            if ( i = TrPoints )
              then write ( ft, -1 )
          end;//i
          writeln ( ft );
          writeln   ( ft, #9, #9, #9, ']' );
        writeln ( ft, #9, #9, '}' );
      writeln ( ft, #9, '}' );
    writeln ( ft, '}' );
    CloseFile ( ft );
  end;
end;

procedure TMainForm.VRML1Click(FileName: string);
const
  VRMLhead = '#VRML V1.0 ascii';
var
  ft : TextFile;
  Head : string[16];
  a, b : char;
  isComments, comment, isword, MsgOn : boolean;
  lexem, PrevLexem : string;
  comm : string;
  value : SFFloat;
  code : integer;
  numbers : integer;
  ExecutionStack : array [ 1..256 ] of string;
  inStack : integer;
  Point1 : TMyListPoint;
  i : integer;
  index : array [ 0..5000 ] of integer;
  indexes : integer;
  ExecutionLexem : string;
  P : TMyPoint;
  ItIs : string;

begin
//  if OpenDialog1.Execute then begin
    SeeToPoint := False;
    TrPoints := 0;
    Point.points := 0;
    Triangle.triangles := 0;
    AssignFile ( ft, FileName );
    Reset ( ft );
    read ( ft, head );
    if head <> VRMLhead then begin
      ShowMessage ( PM_FORMAT_NOT_SUPPORTED_MSG );
      CloseFile ( ft );
      exit;
    end;
    b := #32;
    ItIs := '';
    lexem := '';
    PrevLexem := '';
    comment := false;
    numbers := 0;
    indexes := 0;
    Point1.points := 0;
    inStack := 0;

    while not eof ( ft ) do
      begin
        read ( ft, a );
        isword := false;
        MsgOn := false;

        // определяем комментарии
        case a of // for comments
          '#' :
            begin
              comment := true;
            end;
          #13 :
            begin
              if comment then MsgOn := true;
              comment := false
            end;
        end;// case

        // определяем текущее слово
        if ( not ( a in [ #00..#32 ] ) ) and
                 ( b in [ #00..#32, '#', '}', ',', '{', '[', ']' ] )
          then lexem := a;
        if ( not ( a in [ #00..#32 ] ) ) and
             not ( b in [ #00..#32, '#' ] )
          then lexem := lexem + a;
        if (     ( a in [ #00..#32, '#', ',', ']', '}' ] ) ) and
             not ( b in [ #00..#32 ] )
          then isWord := true;

        if a = ','
          then begin
            if ExecutionStack [ inStack ] = 'point'
              then begin
//                inc ( Point.points );
//                Point.curr := Point.curr^.mynext;
              end;
            if ExecutionStack [ inStack ] = 'coordIndex'
              then inc ( indexes );
          end;

        // определяем комментарий
        isComments := comment or MsgOn;
        if isComments
          then comm := ' - comments'
          else comm := '';

        // обработка слова ( если НЕ КОММЕНТАРИЙ !!! )
        if not isComments then
         if isWord
          then begin
            // определяем его численное значение
            val ( lexem, value, code );
            if not isComments
              then
                if code = 0
                  then comm := ' - number'
                  else comm := ' - identifier';

             if code = 0
              // если слово - число
              then begin
                if PrevLexem = 'point'
                  then begin
                    case numbers of
                      0: P.x := value;
                      1: P.y := value;
                      2: begin
                           P.z := value;
                           if Point1.points = 0
                             then AddFirstP( Point1, P )
                             else AddNextP ( Point1, P );
                         end;
                    end;
                  end;

                if PrevLexem = 'coordIndex'
                  then begin
                    index[ indexes ] := Trunc ( value );
                  end;

                inc ( numbers );
              end // if code = 0

              // обрабатываем любое другое слово, не являющееся числом
              else begin
                if PrevLexem = 'DEF'
                  then ItIs := lexem;
                // если мы входим в группу <Группа> { ... }
                if ( lexem = '{' ) or ( lexem = '[' )
                  then begin
                    inc ( inStack );
                    ExecutionStack [ inStack ] := PrevLexem;
                  end;
                // выполняем группу
                if ( lexem = '}' ) or ( lexem = ']' )
                  then begin
                    ExecutionLexem := ExecutionStack [ inStack ];
                    if ExecutionLexem = 'Material'
                      then begin
{                        glMaterialfv ( face, GL_AMBIENT,   @Material.ambientColor );
                        glMaterialfv ( face, GL_DIFFUSE,   @Material.diffuseColor );
                        glMaterialfv ( face, GL_SPECULAR,  @Material.specularColor );
                        glMaterialfv ( face, GL_EMISSION,  @Material.emissiveColor );
                        glMaterialfv ( face, GL_SHININESS, @Material.shininess );
                        glColor3fv ( @Material.diffuseColor );}
                      end;
                    if ExecutionLexem = 'point'
                      then begin
                      // закончить заполнение набора точек
                      end;
                    if ExecutionLexem = 'coordIndex'
                      then begin
                      // закончить заполнение индексов координат
                      end;
                    if ExecutionLexem = 'Coordinate3'
                      then begin
                      // нужные координаты точек - в Point1
                      end;
                    if ExecutionLexem = 'IndexedFaceSet'
                     then if ItIs = 'terrain'
                      then begin
                        Point := Point1;
                        PlayPoints ( Point );
                        ItIs := '';
                      end;
                    if ExecutionLexem = 'IndexedLineSet'
                     then if ItIs = 'traektory'
                      then begin
                        Point1.curr := Point1.head;
                        TrPoints := Point1.points;
                        for i := 1 to TrPoints do begin
                          Traektory [ i ].x := Point1.curr^.point.x;
                          Traektory [ i ].y := Point1.curr^.point.y;
                          Traektory [ i ].z := Point1.curr^.point.z;
                          Point1.curr := Point1.curr^.mynext;
                        end;
                        ItIs := '';
                      end;
                    if ExecutionLexem = 'SpotLight'
                      then begin
{                        glLightf ( GL_LIGHT1, GL_SPOT_CUTOFF,
                                   SpotLight.cutOffAngle );
                        glLightfv ( GL_LIGHT1, GL_DIFFUSE,
                                   @SpotLight.color );
                        glLightfv ( GL_LIGHT1, GL_POSITION,
                                   @SpotLight.location );
                        glEnable ( GL_LIGHT1 );}
                      end;
                    if ExecutionLexem = 'DirectionalLight'
                      then begin
{                        glLightf ( GL_LIGHT2, GL_SPOT_CUTOFF,
                                   SpotLight.cutOffAngle );
                        glLightfv ( GL_LIGHT2, GL_DIFFUSE,
                                   @DirectionalLight.color );
                        glLightfv ( GL_LIGHT2, GL_SPOT_DIRECTION,
                                   @DirectionalLight.Adirection );
                        glEnable ( GL_LIGHT2 );}
                      end;

                    dec ( inStack );
                  end;
                if not ( lexem[1] in [ '[', ']', '{', '}', ',' ] )
                  then PrevLexem := lexem;
                numbers := 0;
              end; // else
          end; // if isWord
        b := a;
      end;// while not oef ( ft )
    CloseFile ( ft );
    MnuTriangulate.Enabled := true;
    MnuPoints.Enabled := true;
    MnuClear.Enabled := true;
    Triangle.Triangles := 0;
    Repaint;
//  end;
end;

procedure TMainForm.MnuAboutClick(Sender: TObject);
var
  AboutBox: TAboutBox;
begin
  AboutBox := TAboutBox.Create(Self);
  try
    AboutBox.ShowModal;
  finally
    AboutBox.Free;
  end;
end;

procedure TMainForm.MnuTraektParamsClick(Sender: TObject);
begin
  MnuTraektParams.Checked := not MnuTraektParams.Checked;
  TableForm.Visible := MnuTraektParams.Checked;
end;

procedure TMainForm.MnuSetVisiblePointClick(Sender: TObject);
begin
  BitmapForm.Show;
  SetTraektory := false;
  SetObscurePoint := false;
  SetVisiblePoint := not SetVisiblePoint;
  if SetVisiblePoint then Screen.Cursor := crCross;
  SetVisibleLine := False;
  ClearVisibleLine := true;
end;

procedure TMainForm.MnuUndoClick(Sender: TObject);
begin
  if SetTraektory then BitmapForm.ClearLastTraektoryLine;
end;

procedure TMainForm.MnuVisibleZoneClick(Sender: TObject);
var
  i, j, k : integer;
  A : BresenhamesLine;
  visibility : boolean;
  p, v : TPoint3D;
  Child1: TZoneForm;
  col32 : longint;
  col8 : byte;
  Hour0, Min0, Sec0, MSec0,
  Hour1, Min1, Sec1, MSec1: Word;
  Secs0, Secs1, Secs2, Secs: longint;
begin
  { create a new MDI child window }
  if ( VisiblePoint.x = 0 ) and
     ( VisiblePoint.y = 0 ) and
     ( VisiblePoint.z = 0 )
    then begin
      MessageDlg ( PM_NO_VISIBLE_POINT_MSG, mtWarning, [mbOk], 0 );
      exit;
    end;
  Screen.Cursor := crHourGlass;
  Child1 := TZoneForm.Create(Application);
  Child1.Caption := PM_VISIBLE_ZONE_HEADER;

  Child1.Image1.AutoSize := false;
  Child1.Image1.Width  := CopyForm.Image1.Width;
  Child1.Image1.Height := CopyForm.Image1.Height;
//  ZoneForm.Show;

  ProcessForm.Caption := PM_VISIBLE_ZONE_MSG1
    + IntToStr( ManHeight ) + PM_VISIBLE_ZONE_MSG2;
  ProcessForm.Label1.Caption := PM_VISIBLE_ZONE_PROCESS;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;

  v.x := trunc ( VisiblePoint.x );
  v.y := trunc ( VisiblePoint.y );
  v.z := ( CopyForm.Image1.Canvas.Pixels [ v.x , v.y ] and $ff );

  DecodeTime( Time, Hour0, Min0, Sec0, MSec0 );
  Secs0 := Sec0 + Min0*60 + Hour0*60*60;
  for j := 0 to CopyForm.Image1.Height - 1 do begin
    for i := 0 to CopyForm.Image1.Width - 1 do begin
      A.Init ( v.x, v.y, i, j, CopyForm.Image1.Canvas );
      col32 := CopyForm.Image1.Canvas.Pixels[ i, j ];
      col8 := col32 shr 16;
      visibility := true;
        while not A.IsEnded do begin
          A.NextMovement;
          p := A.GetCurPoint;
          p.z := p.z + ManHeight;
          k := ( CopyForm.Image1.Canvas.Pixels [ p.X , p.Y ] shr 16 );
          visibility := ( k <= p.z ) and visibility;
          if not visibility then begin
            A.IsEnded := true;
            break;
          end;
        end;
      if visibility
        then Child1.Image1.Canvas.Pixels[ i, j ] := col_bounds( ZoneColor, MinColor, MaxColor, col8 )
        else Child1.Image1.Canvas.Pixels[ i, j ] := col32;
//        then Child1.Image1.Canvas.Pixels[ i, j ] := RGB( col8, 255 - col8, 0 )
//        else Child1.Image1.Canvas.Pixels[ i, j ] := col32;
      A.Done;
    end;// i
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( j + 1 ) / CopyForm.Image1.Height );
    DecodeTime( Time, Hour1, Min1, Sec1, MSec1 );
    Secs1 := Sec1 + Min1*60 + Hour1*60*60;
    Secs := Secs1 - Secs0;
    if ProcessForm.Gauge1.Progress <> 0
      then Secs2 := trunc( Secs / ProcessForm.Gauge1.Progress * ( 100 - ProcessForm.Gauge1.Progress ) );
    ProcessForm.Label1.Caption := PM_VISIBLE_ZONE_PROCESS + IntToStr( Secs ) + ' сек., осталось: ' + IntToStr(Secs2) + ' сек.       ';
    ProcessForm.Label1.Repaint;
    GDIFlush;
  end;// j
  Child1.Image1.Canvas.Ellipse ( v.x - 2, v.y - 2, v.x + 2, v.y + 2 );
  ProcessForm.Hide;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.MnuMakeXYZClick(Sender: TObject);
var
  i, j, k : integer;
  z : longint;
  P : TMyPoint;
begin
//  Randomize;
  Screen.Cursor := crHourGlass;
  Point.points := 0;
  Triangle.triangles := 0;
  ProcessForm.Caption := PM_DTM_HEADER;
  ProcessForm.Label1.Caption := PM_DTM_PROCESS;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;
  for k := 1 to 400 do begin
    i := random ( CopyForm.Image1.Width );
    j := random ( CopyForm.Image1.Height );
    P.x := BitmapForm.GetMI_X ( i );
    P.y := BitmapForm.GetMI_Y ( j );
    z := CopyForm.Image1.Canvas.Pixels [ i, j ] and $ff;
    P.z := 3 * z / 255;
    if Point.points = 0
      then AddFirstP( Point, P )
      else AddNextP ( Point, P );
    ProcessForm.Gauge1.Progress := trunc ( 100 * k / 400 );
    ProcessForm.Gauge1.Refresh;
  end;
  PlayPoints ( Point );
//  scale := ( Point.maxX - Point.minX) * 0.008811;
//  scale := ( tmax - tmin ) / 0.008811 / MainForm.Width;
  ProcessForm.Hide;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.MnuInfoClick(Sender: TObject);
begin
  InfoForm.Label1.Caption := PM_POINTS_INFO + IntToStr( Point.points );
  InfoForm.Label2.Caption := PM_MIN_X_INFO + FloatToStr( Point.minX );
  InfoForm.Label3.Caption := 'Ymin = ' + FloatToStr( Point.minY );
  InfoForm.Label4.Caption := 'Zmin = ' + FloatToStr( Point.minZ );
  InfoForm.Label5.Caption := 'Xmax = ' + FloatToStr( Point.maxX );
  InfoForm.Label6.Caption := 'Ymax = ' + FloatToStr( Point.maxY );
  InfoForm.Label7.Caption := 'Zmax = ' + FloatToStr( Point.maxZ );
  InfoForm.Label8.Caption := 'Всего треугольников: ' + IntToStr( Triangle.triangles );
  InfoForm.Label9.Caption := 'Всего точек траектории: ' + IntToStr( TrPoints );
  InfoForm.Show;
end;

procedure TMainForm.MnuRefreshBMPClick(Sender: TObject);
begin
  BitmapForm.Image1.Picture := CopyForm.Image1.Picture;
end;

procedure TMainForm.AboutBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MnuNegateClick(Sender: TObject);
var
  Line : pByteArray;
  i, j : longint;
begin
  Screen.Cursor := crHourGlass;
  for i := 0 to BitmapForm.Image1.Picture.Height - 1 do begin
    Line := BitmapForm.Image1.Picture.Bitmap.ScanLine[i];
    case BitmapForm.Image1.Picture.Bitmap.PixelFormat of
      pf8bit:
        for j := 0 to BitmapForm.Image1.Picture.Bitmap.Width - 1 do
          Line^[j] := 255 - Line^[j];
      pf24bit:
        for j := 0 to BitmapForm.Image1.Picture.Bitmap.Width * 3 - 1 do
          Line^[j] := 255 - Line^[j];
    end;
  end;
  Screen.Cursor := crDefault;
  BitmapForm.Image1.Repaint;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  ProcessForm.CreateThread( Sender );
end;

procedure TMainForm.MnuContentsClick(Sender: TObject);
begin
  Application.HelpFile := '..\Help\GISHelp.HLP';
  Application.HelpCommand( HELP_FINDER, 0 );
end;

procedure TMainForm.SavePointsClick(Sender: TObject);
var
  i:integer;
  f:TextFile;
begin
  SaveDialog1.InitialDir:=Fname;
  SaveDialog1.Title := 'Сохранить набор точек.';
  if SaveDialog1.Execute then
    begin
      AssignFile(f,SaveDialog1.FileName);
      rewrite(f);
      writeln(f, Point.points);
      Point.curr := Point.head;
      for i:=1 to Point.points do begin
        writeln(f,Point.curr^.Point.x:10:0,' ',Point.curr^.Point.y:10:0,' ',Point.curr^.Point.z:4:0);
        Point.curr := Point.curr^.mynext;
      end;
      CloseFile(f);
      MainForm.Caption:= GetFileName ( SaveDialog1.FileName ) + ' - FlyGIS3D';
    end;
end;

procedure TMainForm.acOpenFileExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    WinScale := 1;
    case OpenDialog1.FilterIndex of
      1 : MainForm.MapInfoMIFMID1Click(OpenDialog1.FileName);
      2 : MainForm.MnuTriCellClick(OpenDialog1.FileName);
      3 : MainForm.MnuPointsOpenClick(OpenDialog1.FileName);
      4 : MainForm.VRML1Click(OpenDialog1.FileName);
      5 : MainForm.MnuBitmapOpenClick(OpenDialog1.FileName);
    end;
  end;
end;

procedure TMainForm.ToolButton25Click(Sender: TObject);
begin
  Visio1.PopMnuIncreaseClick( Sender );
  ActionMode := AM_ZoomIn;
end;

procedure TMainForm.ToolButton26Click(Sender: TObject);
begin
  Visio1.PopMnuDecreaseClick( Sender );
  ActionMode := AM_ZoomOut;
end;

procedure TMainForm.ToolButton27Click(Sender: TObject);
begin
  Visio1.PopMnuEndScaleClick( Sender );
end;

procedure Create3DChild;
var
  Child3D: TVisio1;
begin
  Child3D := TVisio1.Create(Application);
  Child3D.Width  := 400;
  Child3D.Height := 300;
end;

procedure TMainForm.acSetupExecute(Sender: TObject);
begin
  SetupForm.Show;//ShowModal;
end;

procedure TMainForm.ToolButton23Click(Sender: TObject);
begin
  acSetupExecute(Sender);
end;

procedure TMainForm.N14Click(Sender: TObject);
begin
  BitmapForm.Show;
  SetTraektory := false;
  SetObscurePoint := false;
  SetVisiblePoint := false;
  SetVisibleLine := (not SetVisibleLine) and
    ( ( VisiblePoint.x <> 0 ) or
      ( VisiblePoint.y <> 0 ) or
      ( VisiblePoint.z <> 0 ) );
  DrawViewing := SetVisibleLine;
//  if not DrawViewing
//    then SeeNowTo := ObscurePoint;
  if SetVisibleLine
    then Screen.Cursor := crCross
    else Screen.Cursor := crDefault;
  if not SetVisibleLine
    then ClearVisibleLine := true;
end;

procedure TMainForm.acEndTraektoryExecute(Sender: TObject);
begin
  BitmapForm.PopMnuEndingClick(Sender);
end;

procedure TMainForm.TBGrabberClick(Sender: TObject);
begin
  ActionMode := AM_Grabber;
//  Screen.Cursor := crSize;
end;

procedure TMainForm.MnuFileToolsClick(Sender: TObject);
begin
  FileTool.Visible := not FileTool.Visible;
  UpdateMenu( Sender );
end;

procedure TMainForm.MnuMainToolsClick(Sender: TObject);
begin
  MainTool.Visible := not MainTool.Visible;
  UpdateMenu( Sender );
end;

procedure TMainForm.MnuToolsViewClick(Sender: TObject);
begin
  EditTools.Visible := not EditTools.Visible;
  UpdateMenu( Sender );
end;

procedure TMainForm.MnuCameraViewClick(Sender: TObject);
begin
  CameraTool.Visible := not CameraTool.Visible;
  UpdateMenu( Sender );
end;

procedure TMainForm.MnuShadeModelClick(Sender: TObject);
var
  i : longint;
  x, y : longint;
  last : TTriangle;
  col : byte;
  z : real;
  find : TTriangle;
  ang: real;
  p : TMyPoint;
  xx, yy : real;
  d : real;
  a, b, nv: TVector;
  LineB : pByteArray;
  scX, scY : longint;
  Hour0, Min0, Sec0, MSec0,
  Hour1, Min1, Sec1, MSec1: Word;
  mSecs0, mSecs1, mSecs2, mSecs: longint;
begin

  if Triangle.triangles = 0 then begin
    MessageDlg( PM_NO_TRIANGULATION_NETWORK, mtWarning, [mbOk], 0 );
    exit;
  end;

  Screen.Cursor := crHourGlass;

  BitmapForm := TBitmapForm.Create(Application);
  BitmapForm.ClearTraektory2D;

  BitmapForm.Show;

//  CopyForm.Image1.AutoSize := false;
//{?}  CopyForm.Image1.Width  := trunc ( ( Point.maxX - Point.minX ) / 0.008811 );
//{?}  CopyForm.Image1.Height := trunc ( ( Point.maxY - Point.minY ) / 0.008811 );

  ProcessForm.Caption := PM_HEIGHT_RASTER_HEADER;
  ProcessForm.Label1.Caption := PM_HEIGHT_RASTER_PROCESS;
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;

  DecodeTime( Time, Hour0, Min0, Sec0, MSec0 );
  mSecs0 := MSec0 + Sec0*1000 + Min0*60*1000 + Hour0*60*60*1000;
  last := Triangle.head^.Triangle;
  BitmapForm.Image1.Picture.Bitmap.PixelFormat := pf24bit;
  for y := 0 to BitmapForm.Image1.Height - 1 do begin
    scY := BitmapForm.Image1.Height - y;
    LineB := BitmapForm.Image1.Picture.Bitmap.ScanLine[ scY ];
    for x := 0 to BitmapForm.Image1.Width - 1 do begin
      xx := Point.minX + x * ( Point.maxX - Point.minX ) / ( BitmapForm.Image1.Width - 1 );
      yy := Point.minY + y * ( Point.maxY - Point.minY ) / ( BitmapForm.Image1.Height - 1 );
      p.x := xx;
      p.y := yy;
      find := Triangle.head^.Triangle;
      col := 0;
      if InTriangle1( p, last ) then begin
        find := last;
      end else
      Triangle.curr := Triangle.head;
      for i := 1 to Triangle.triangles do begin
        if InTriangle1( p, Triangle.curr^.Triangle ) then begin
          find := Triangle.curr^.Triangle;
          last := Triangle.curr^.Triangle;
          break;
       end;
       Triangle.curr := Triangle.curr^.mynext;
      end;
      if @find<>nil then begin
        with find do begin
          a.x := v[1].x - v[0].x;
          a.y := v[1].y - v[0].y;
          a.z := v[1].z - v[0].z;
          b.x := v[2].x - v[0].x;
          b.y := v[2].y - v[0].y;
          b.z := v[2].z - v[0].z;
          // the normal vector of the triangle
          nv.x :=    a.y * b.z - a.z * b.y;
          nv.y := - (a.x * b.z - a.z * b.x);
          nv.z :=    a.x * b.y - a.y * b.x;
          ang := AngleCos( nv, LightPosition );
        end;
        if ang > 0
          then col := trunc( 255 * ang )
          else col := 0;
      end;
      scX := 3*x;
//      BitmapForm.Image1.Canvas.Pixels [x, CopyForm.Image1.Height - y] := RGB ( col, col, col );
{      LineB^[ scX ]     := col; // R
      LineB^[ scX + 1 ] := col; // G
      LineB^[ scX + 2 ] := col; // B{}
    end;// x
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( y + 1 ) / BitmapForm.Image1.Height );
    DecodeTime( Time, Hour1, Min1, Sec1, MSec1 );
    mSecs1 := MSec1 + Sec1*1000 + Min1*60*1000 + Hour1*60*60*1000;
    mSecs := mSecs1 - mSecs0;
    if ProcessForm.Gauge1.Progress <> 0
      then mSecs2 := trunc( mSecs / ProcessForm.Gauge1.Progress * ( 100 - ProcessForm.Gauge1.Progress ) );
    ProcessForm.Label1.Caption := PM_HEIGHT_RASTER_PROCESS + ' Прошло: '+ IntToStr( mSecs div 1000 ) + ' сек., осталось: ' + IntToStr(mSecs2 div 1000) + ' сек.      ';
    ProcessForm.Label1.Repaint;
  end;// y

  CopyForm.Image1.Picture.Bitmap.Width := BitmapForm.Image1.Width;
  CopyForm.Image1.Picture.Bitmap.Height := BitmapForm.Image1.Height;
  CopyForm.Image1.Width := BitmapForm.Image1.Width;
  CopyForm.Image1.Height := BitmapForm.Image1.Height;
  CopyForm.Image1.Picture := BitmapForm.Image1.Picture;

  ProcessForm.Hide;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.MnuTINisolinesClick(Sender: TObject);
begin
  MapInfoForm.DrawIsolines( Triangle );
end;

procedure TMainForm.MnuPointsClick(Sender: TObject);
begin
  Visio2D.Show;
end;

procedure TMainForm.DLLHeightRaster1Click(Sender: TObject);
type
  TGetHeightValue = function (x, y: integer): byte;
var
  LibHandle: THandle;
  vGetHeightValue: TGetHeightValue;
  x: byte;
begin
  LibHandle := LoadLibrary('DLLHeightsImage');
  try
    x := 0;
    if LibHandle = 0 then
      raise EDLLLoadError.Create('Unable to load DLL');
    @vGetHeightValue := GetProcAddress(LibHandle, 'GetHeightValue');
    if not (@vGetHeightValue = nil) then
      x := vGetHeightValue(1,1)
    else
      RaiseLastWin32Error;
    ShowMessage('x='+IntToStr(x));
  finally
    FreeLibrary(LibHandle);
  end;
end;

procedure TMainForm.BitmapDLL1Click(Sender: TObject);
type
  TShowBitmap = function (AHandle: THandle; ACaption: String): TForm; StdCall;
var
  vShowBitmap: TShowBitmap;
  BMPfrm: TForm;
begin
  LibHandle := LoadLibrary('BitmapDLL');
  try
    if LibHandle = 0 then
      raise EDLLLoadError.Create('Unable to load DLL');
    @vShowBitmap := GetProcAddress(LibHandle, 'ShowBitmap');
    if not (@vShowBitmap = nil) then
    begin
      vShowBitmap(Application.Handle, Caption);
//      ShowMessage('Created!');
    end
    else
    begin
      RaiseLastWin32Error;
//      ShowMessage('Failed!');
    end;
  except
    FreeLibrary(LibHandle);
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if LibHandle <> 0 then FreeLibrary(LibHandle);
end;

procedure TMainForm.ToolButton21Click(Sender: TObject);
begin
  ActionMode := AM_CROP;
end;

end.

