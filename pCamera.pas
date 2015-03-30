unit pCamera;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls, ExtCtrls, Math, Buttons;

type
  TCameraForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Image1: TImage;
    Label13: TLabel;
    GroupBox3: TGroupBox;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Label6: TLabel;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure ShowWindow;
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CameraForm: TCameraForm;

implementation

uses pFlyGIS3D;

{$R *.DFM}

procedure TCameraForm.ShowWindow;
var
  x,y:integer;
begin
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
  if SpinEdit2.Value<45
    then begin
      Image1.Canvas.MoveTo(Image1.Width,Image1.Height);
      y:=Image1.Height-trunc(tan(SpinEdit2.Value*pi/180)*Image1.Width);
      Image1.Canvas.LineTo(0,y);
    end
    else begin
      Image1.Canvas.MoveTo(0,0);
      x:=trunc(Image1.Height/tan(SpinEdit2.Value*pi/180));
      Image1.Canvas.LineTo(x,Image1.Height);
    end;
end;

procedure SetValues;
begin
end;

procedure TCameraForm.FormCreate(Sender: TObject);
begin
//  SetValues;
//  ShowWindow;
end;

procedure TCameraForm.SpinEdit2Change(Sender: TObject);
begin
//  ShowWindow;
end;

procedure TCameraForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  MainForm.MnuCamera.Checked := false;
end;

procedure TCameraForm.BitBtn1Click(Sender: TObject);
begin
//  SetValues;
//  Hide;
end;

procedure TCameraForm.BitBtn2Click(Sender: TObject);
begin
//  Hide;
end;

end.

