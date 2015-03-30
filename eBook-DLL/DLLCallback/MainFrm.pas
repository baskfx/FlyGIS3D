{
Copyright © 1999 by Delphi 5 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    btnCallDLLFunc: TButton;
    edtSearchStr: TEdit;
    lblSrchWrd: TLabel;
    memStr: TMemo;
    procedure btnCallDLLFuncClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;
  Count: Integer;

implementation

{$R *.DFM}

{ Define the DLL's exported procedure }
function SearchStr(ASrcStr, ASearchStr: PChar; AProc: TFarProc): Integer; StdCall external
  'STRSRCHLIB.DLL';

{ Define the callback procedure, make sure to use the StdCall directive }
procedure StrPosProc(AStrPsn: PChar); StdCall;
begin
  inc(Count); // Increment the Count variable.
end;

procedure TMainForm.btnCallDLLFuncClick(Sender: TObject);
var
  S: String;
  S2: String;
begin
  Count := 0; // Initialize Count to zero.
  { Retrieve the length of the text on which to search. }
  SetLength(S, memStr.GetTextLen);
  { Now copy the text to the variable S }
  memStr.GetTextBuf(PChar(S), memStr.GetTextLen);
  { Copy Edit1's Text to a string variable so that it can be passed to
    the DLL function }
  S2 := edtSearchStr.Text;
  { Call the DLL function }
  SearchStr(PChar(S), PChar(S2), @StrPosProc);
  { Show how many times the word occurs in the string. This has been
    stored in the Count variable which is used by the callback function }
  ShowMessage(Format('%s %s %d %s', [edtSearchStr.Text, 'occurs', Count, 'times.']));
end;

end.
