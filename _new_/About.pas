unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    FlyGIS3D: TLabel;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.BitBtn1Click(Sender: TObject);
begin
  Hide;
end;

end.
