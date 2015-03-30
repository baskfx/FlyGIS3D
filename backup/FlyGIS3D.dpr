program FlyGIS3D;

uses
  Forms,
  pFlyGIS3D in 'pFlyGIS3D.pas' {MainForm},
  pCamera in 'pCamera.pas' {CameraForm},
  Geometry in 'Geometry.pas',
  Visio_1 in 'Visio_1.pas' {Visio1},
  Visio_2 in 'Visio_2.pas' {Visio2D},
  pSetup in 'pSetup.pas' {SetupForm},
  pBitmap in 'pBitmap.pas' {BitmapForm},
  Geom1 in 'Geom1.pas',
  pTraektTable in 'pTraektTable.pas' {TableForm},
  pTraektoryForm in 'pTraektoryForm.pas' {TraektoryForm},
  VRMLtype in 'VRMLtype.pas',
  About in 'About.pas' {AboutBox},
  FormCopy in 'FormCopy.pas' {CopyForm},
  pVisibleZone in 'pVisibleZone.pas' {ZoneForm},
  Process in 'Process.pas' {ProcessForm},
  pInfo in 'pInfo.pas' {InfoForm},
  pIsoline in 'pIsoline.pas' {IsolineForm},
  pBuffer in 'pBuffer.pas' {BufferForm},
  SimpThread in 'SimpThread.pas',
  pMapInfo in 'pMapInfo.pas' {MapInfoForm},
  PM_Messages in 'PM_Messages.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.HelpFile := 'x:\554\Baskov\Delphi\NewInterface\Help\FLYGIS3DHELP.HLP';
  Application.Title := 'Программа FlyGIS3D';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCameraForm, CameraForm);
//  Application.CreateForm(TVisio1, Visio1);
  Application.CreateForm(TVisio2D, Visio2D);
  Application.CreateForm(TSetupForm, SetupForm);
  Application.CreateForm(TTableForm, TableForm);
  Application.CreateForm(TTraektoryForm, TraektoryForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TCopyForm, CopyForm);
  Application.CreateForm(TProcessForm, ProcessForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TIsolineForm, IsolineForm);
  Application.CreateForm(TBufferForm, BufferForm);
//  Application.CreateForm(TMapInfoForm, MapInfoForm);
  Application.Run;
end.

