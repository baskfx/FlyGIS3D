unit pTraektoryForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TTraektoryForm = class(TForm)
    Image1: TImage;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TraektoryForm: TTraektoryForm;

implementation

uses pFlyGIS3D;

{$R *.DFM}

procedure TTraektoryForm.FormResize(Sender: TObject);
begin
  Width := 400;
  Height := 160;
end;

procedure TTraektoryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.MnuTraektoryView.Checked := False;
end;

end.
