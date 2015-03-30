{
Copyright © 1999 by Delphi 5 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

unit MainFfm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type

  TMainForm = class(TForm)
    btnShowCalendar: TButton;
    btnCloseCalendar: TButton;
    procedure btnShowCalendarClick(Sender: TObject);
    procedure btnCloseCalendarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFormRef: TForm;
  end;

var
  MainForm: TMainForm;

function ShowCalendar(AHandle: THandle; ACaption: String): Longint; StdCall;
  external 'CALENDARMLLIB.DLL';

procedure CloseCalendar(AFormRef: Longint); stdcall;
  external 'CALENDARMLLIB.DLL';

implementation

{$R *.DFM}

procedure TMainForm.btnShowCalendarClick(Sender: TObject);
begin
  if not Assigned(FFormRef) then
    FFormRef := TForm(ShowCalendar(Application.Handle, Caption));
end;

procedure TMainForm.btnCloseCalendarClick(Sender: TObject);
begin
  if Assigned(FFormRef) then
  begin
    CloseCalendar(Longint(FFormRef));
    FFormRef := nil;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FFormRef := nil; // Initialize the FFormRef field to nil. 
end;

end.
