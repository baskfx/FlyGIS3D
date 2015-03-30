unit pTraektory;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TTraektoryForm = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TraektoryForm: TTraektoryForm;

implementation

uses pFlyGIS3D, pBitmap;

{$R *.DFM}

procedure TTraektoryForm.FormPaint(Sender: TObject);
begin
{  Canvas.Brush.Color:=clWhite;
  Canvas.Pen.Color:=clWhite;
  Canvas.Rectangle(0,0,Width,Height);
  Canvas.Pen.Color:=clBlack;}
end;

procedure TTraektoryForm.FormResize(Sender: TObject);
begin
  FormPaint(Sender);
end;

procedure TTraektoryForm.FormCreate(Sender: TObject);
begin
  Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.Pen.Color:=clWhite;
  Image1.Canvas.Rectangle(0,0,Width,Height);
  Image1.Canvas.Pen.Color:=clBlack;
  Image1.Width := 0;
end;

procedure TTraektoryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.MnuTraektoryView.Checked := false;
end;

end.
