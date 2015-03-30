unit OpenFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, pFlyGIS3D;

type
  TOpenForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RadioGroup1: TRadioGroup;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OpenForm: TOpenForm;
  FileIndex : integer;

implementation

//uses pFlyGIS3D;
{$R *.DFM}

procedure TOpenForm.BitBtn2Click(Sender: TObject);
begin
  FileIndex := -1;
  Close;
end;

procedure TOpenForm.BitBtn1Click(Sender: TObject);
begin
  FileIndex := RadioGroup1.ItemIndex;
  Close;
end;

end.
