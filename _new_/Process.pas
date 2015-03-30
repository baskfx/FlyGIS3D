unit Process;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ComCtrls, Buttons, SimpThread;

type
  TProcessForm = class(TForm)
    Label1: TLabel;
    Gauge1: TGauge;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateThread(Sender: TObject );
  private
    { Private declarations }
  public
    Thread1, Thread2 : TSimpleThread;
    { Public declarations }
  end;

var
  ProcessForm: TProcessForm;
  BreakProcess : boolean;

implementation

{$R *.DFM}

procedure TProcessForm.BitBtn1Click(Sender: TObject);
begin
  BreakProcess := True;
  if Thread1 <> nil then begin
    Thread1.Suspend;
    Thread1.Terminate;
    ShowMessage( 'Поток уничтожен !!!' );
  end;
end;

procedure TProcessForm.CreateThread(Sender: TObject );
begin
  Thread1 := TSimpleThread.Create( False );
  Thread1.Priority := tpNormal;
end;

procedure TProcessForm.FormCreate(Sender: TObject);
begin
  BreakProcess := False;
end;

end.

