unit pSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Spin, ComCtrls, Tabnotbk, FileCtrl, ExtDlgs,
  Geometry, Geom1;

type
  TSetupForm = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    OpenTexture: TOpenPictureDialog;
    BitBtn4: TBitBtn;
    ColorDialog1: TColorDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Model3DType: TRadioGroup;
    Label6: TLabel;
    TextureEdit: TEdit;
    BitBtn1: TBitBtn;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBoxShowIsolines: TCheckBox;
    SpinEdit2: TSpinEdit;
    SpinEdit1: TSpinEdit;
    CBoxZ: TComboBox;
    EditMaxZ: TEdit;
    EditMinZ: TEdit;
    TabSheet3: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    BitBtn5: TBitBtn;
    SE_ManHeight: TSpinEdit;
    ComboBox1: TComboBox;
    Label7: TLabel;
    Image2: TImage;
    Label9: TLabel;
    Panel1: TPanel;
    Label12: TLabel;
    TabSheet4: TTabSheet;
    Panel6: TPanel;
    Image4: TImage;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Panel2: TPanel;
    Image3: TImage;
    Panel3: TPanel;
    Image7: TImage;
    Panel4: TPanel;
    Image8: TImage;
    Panel5: TPanel;
    Image9: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    HeightLabel: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    WorkCatLabel: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    DiskLabel: TLabel;
    Panel7: TPanel;
    Image5: TImage;
    TabSheet7: TTabSheet;
    Label16: TLabel;
    Panel8: TPanel;
    BitBtn6: TBitBtn;
    TabSheet8: TTabSheet;
    CBShow2DProjection: TCheckBox;
    GroupBox2: TGroupBox;
    Label17: TLabel;
    LightXEdit: TEdit;
    LightYEdit: TEdit;
    Label18: TLabel;
    LightZEdit: TEdit;
    Label19: TLabel;
    EditScaleX: TEdit;
    X: TLabel;
    EditScaleY: TEdit;
    Label20: TLabel;
    EditScaleZ: TEdit;
    Label21: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Model3DTypeClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReadFromForm;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupForm: TSetupForm;
  ManHeight : integer;
  TextureName: string;
  vModel3DType : integer;
  Discrette : integer;
  ShowIsolines : boolean;
  ZoneColor, FontColor: TColor;
  MinColor, MaxColor: byte;
//  SeeFrom: integer;
  Show2DProjection: boolean;
  LightPosition: TVector;
  h0, CamBetta, CamMove, CamAngle : real;
  ScaleX, ScaleY, ScaleZ: real;

implementation

uses pBitmap, Visio_1, FormCopy, PM_Messages;

{$R *.DFM}

procedure SelectPanel( Panel: TPanel; n: integer );
var
  s: string;
begin
  with SetupForm do begin
    Panel2.BevelInner := bvLowered;
    Panel3.BevelInner := bvLowered;
    Panel4.BevelInner := bvLowered;
    Panel5.BevelInner := bvLowered;
    Panel7.BevelInner := bvLowered;
    Panel2.BevelOuter := bvLowered;
    Panel3.BevelOuter := bvLowered;
    Panel4.BevelOuter := bvLowered;
    Panel5.BevelOuter := bvLowered;
    Panel7.BevelOuter := bvLowered;
    s := PM_CAMERA_DESCRIPTION[n];
    Label8.Caption := s;
    Label8.Left := GroupBox1.Width div 2 - Label8.Width div 2;
    Edit3.Enabled := ( n = 1 ) or ( n = 3 );
    ComboBox4.Enabled := Edit3.Enabled;
    ComboBox5.Enabled := Edit3.Enabled;
    Edit4.Enabled := Edit3.Enabled;
  end;
  Panel.BevelInner := bvRaised;
  Panel.BevelOuter := bvRaised;
  case n of
    0: CameraType := CT_CONST_H_DONT_OBSCURE;
    1: CameraType := CT_CONST_H_OBSCURE;
    2: CameraType := CT_GLIDE_TERRAIN_DONT_OBSCURE;
    3: CameraType := CT_GLIDE_TERRAIN_OBSCURE;
    4: CameraType := CT_GLIDE_TERRAIN_GLIDE;
  end;
end;

procedure SetValues;
begin
end;

procedure DrawColorScale;
var
  i: integer;
  col: TColor;
begin
  with SetupForm do begin
    for i := 0 to 255 do begin
      col := col_bounds( ColorDialog1.Color, SpinEdit3.Value, SpinEdit4.Value, i );
      Image2.Canvas.Pen.Color := col;
      Image2.Canvas.MoveTo( i, 0 );
      Image2.Canvas.LineTo( i, Image2.Height - 1 );
    end;
  end;
end;

procedure TSetupForm.ReadFromForm;
begin
  vModel3DType := Model3DType.ItemIndex;
  ManHeight := SE_ManHeight.Value;
  Discrette := SpinEdit1.Value;
  ShowIsolines := CheckBoxShowIsolines.Checked;
  TextureName := TextureEdit.Text;
  TextureEdit.Enabled := Model3DType.ItemIndex = 2;
  ColorDialog1.Color := Panel1.Color;
  ZoneColor := Panel1.Color;
  FontColor := Panel8.Color;
  MinColor := SpinEdit3.Value;
  MaxColor := SpinEdit4.Value;
  h0 := StrToFloat( Edit1.Text );
  CamBetta := StrToFloat( Edit4.Text );
  CamMove := StrToFloat( Edit2.Text );
  CamAngle := StrToFloat( Edit3.Text );
//  SeeFrom := RGSeeFrom.ItemIndex;
  Show2DProjection := CBShow2DProjection.Checked;
  LightPosition.x := StrToFloat( LightXEdit.Text );
  LightPosition.y := StrToFloat( LightYEdit.Text );
  LightPosition.z := StrToFloat( LightZEdit.Text );
  ScaleX := StrToFloat ( EditScaleX.Text );
  ScaleY := StrToFloat ( EditScaleY.Text );
  ScaleZ := StrToFloat ( EditScaleZ.Text );
  DrawColorScale;
end;

procedure TSetupForm.BitBtn2Click(Sender: TObject);
begin
  SetValues;
  BitBtn4Click( Sender );
  SetupForm.Hide;
end;

procedure TSetupForm.BitBtn3Click(Sender: TObject);
begin
  Model3DType.ItemIndex := vModel3DType;
  SE_ManHeight.Value := ManHeight;
  SpinEdit1.Value := Discrette;
  CheckBoxShowIsolines.Checked := ShowIsolines;
  TextureEdit.Enabled := Model3DType.ItemIndex = 2;
  TextureEdit.Text := TextureName;
  SetupForm.Hide;
end;

procedure TSetupForm.Model3DTypeClick(Sender: TObject);
begin
  BitBtn1.Enabled := Model3DType.ItemIndex = 2;
  TextureEdit.Enabled := BitBtn1.Enabled;
end;

procedure TSetupForm.BitBtn1Click(Sender: TObject);
begin
  if OpenTexture.Execute then
    TextureEdit.Text := OpenTexture.Filename;
end;

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  ReadFromForm;
  SetValues;
  SelectPanel( Panel5, 3 );
end;

procedure TSetupForm.BitBtn4Click(Sender: TObject);
begin
  if TextureEdit.Enabled
    then begin
      TextureName := TextureEdit.Text;
      Visio1.SetupTexture(TextureName);
    end
    else TextureName := '';
  vModel3DType := Model3DType.ItemIndex;
  ReadFromForm;
end;

procedure TSetupForm.BitBtn5Click(Sender: TObject);
begin
  if ColorDialog1.Execute
    then begin
      Panel1.Color := ColorDialog1.Color;
      DrawColorScale;
    end;
end;

procedure TSetupForm.SpinEdit3Change(Sender: TObject);
begin
  try
    DrawColorScale;
  finally
  end;
end;

procedure TSetupForm.SpinEdit4Change(Sender: TObject);
begin
  try
    DrawColorScale;
  finally
  end;
end;

procedure TSetupForm.Image3Click(Sender: TObject);
begin
  SelectPanel( Panel2, 0 );
end;

procedure TSetupForm.Image7Click(Sender: TObject);
begin
  SelectPanel( Panel3, 1 );
end;

procedure TSetupForm.Image8Click(Sender: TObject);
begin
  SelectPanel( Panel4, 2 );
end;

procedure TSetupForm.Image9Click(Sender: TObject);
begin
  SelectPanel( Panel5, 3 );
end;

procedure TSetupForm.Image5Click(Sender: TObject);
begin
  SelectPanel( Panel7, 4 );
end;

procedure TSetupForm.BitBtn6Click(Sender: TObject);
begin
  if ColorDialog1.Execute
    then begin
      Panel8.Color := ColorDialog1.Color;
    end;
end;

end.

