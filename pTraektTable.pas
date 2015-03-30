unit pTraektTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

type
  TTableForm = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableForm: TTableForm;

implementation

{$R *.DFM}

procedure TTableForm.FormPaint(Sender: TObject);
begin
  StringGrid1.Cells [ 0, 0 ] := 'Точка';
  StringGrid1.Cells [ 1, 0 ] := 'X';
  StringGrid1.Cells [ 2, 0 ] := 'Y';
  StringGrid1.Cells [ 3, 0 ] := 'Z';
  StringGrid1.Cells [ 4, 0 ] := 'alpha';
  StringGrid1.Cells [ 5, 0 ] := 'betta';
  StringGrid1.Cells [ 6, 0 ] := 'Скорость';
end;

initialization

finalization

end.
