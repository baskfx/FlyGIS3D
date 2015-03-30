unit SimpThread;

interface

uses
  Classes;

type
  TSimpleThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
  end;

implementation

uses pBitmap, Process, Windows;
{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TSimpleTread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TSimpleTread }

procedure TSimpleThread.Execute;
var
  i, j : integer;
  col : longint;
begin
  ProcessForm.Caption := 'Пример использования потока';
  ProcessForm.Label1.Caption := 'поток...';
  ProcessForm.Show;
  ProcessForm.Gauge1.Progress := 0;
  ProcessForm.Repaint;
  for j := 0 to BitmapForm.Image1.Height - 1 do begin
    for i := 0 to BitmapForm.Image1.Width - 1 do begin
      col := BitmapForm.Image1.Canvas.Pixels [ i, j ];
      BitmapForm.Image1.Canvas.Pixels [ i, j ] := RGB( 255, 255, 255 ) - col;
    end;
    ProcessForm.Gauge1.Progress := trunc ( 100 * ( j + 1 ) / BitmapForm.Image1.Height );
    GDIFlush;
  end;
end;

end.
