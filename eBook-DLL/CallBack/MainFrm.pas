{
Copyright © 1999 by Delphi 5 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls;

type

  { Define a record/class to hold the window name and class name for
    each window. Instances of this class will get added to ListBox1 }
  TWindowInfo = class
    WindowName,          // The window name
    WindowClass: String; // The window's class name
  end;

  TMainForm = class(TForm)
    lbWinInfo: TListBox;
    btnGetWinInfo: TButton;
    hdWinInfo: THeaderControl;
    procedure btnGetWinInfoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbWinInfoDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure hdWinInfoSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}
function EnumWindowsProc(Hw: HWnd; AMainForm: TMainForm): Boolean; stdcall; 
{ This procedure is called by the User32.DLL library as it enumerates
  through windows active in the system. }
var
  WinName, CName: array[0..144] of char;
  WindowInfo: TWindowInfo;
begin
  { Return true by default which indicates not to stop enumerating
    through the windows }
  Result := True;
  GetWindowText(Hw, WinName, 144); // Obtain the current window text
  GetClassName(Hw, CName, 144);    // Obtain the class name of the window
  { Create a TWindowInfo instance and set its fields with the values of
    the window name and window class name. Then add this object to
    ListBox1's Objects array. These values will be displayed later by
    the listbox }
  WindowInfo := TWindowInfo.Create;
  with WindowInfo do
  begin
    SetLength(WindowName, strlen(WinName));
    SetLength(WindowClass, StrLen(CName));
    WindowName := StrPas(WinName);
    WindowClass := StrPas(CName);
  end;
  MainForm.lbWinInfo.Items.AddObject('', WindowInfo); // Add to Objects array
end;

procedure TMainForm.btnGetWinInfoClick(Sender: TObject);
begin
  { Enumerate through all top-level windows being displayed. Pass in the
    call back function EnumWindowsProc which will be called for each
    window }
  EnumWindows(@EnumWindowsProc, 0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  { Free all instances of TWindowInfo }
  for i := 0 to lbWinInfo.Items.Count - 1 do
    TWindowInfo(lbWinInfo.Items.Objects[i]).Free
end;

procedure TMainForm.lbWinInfoDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  { First, clear the rectangle to which drawing will be performed }
  lbWinInfo.Canvas.FillRect(Rect);
  { Now draw the strings of the TWindowInfo record stored at the
    Index'th position of the listbox. The sections of HeaderControl1
    will give positions to which to draw each string }
  with TWindowInfo(lbWinInfo.Items.Objects[Index]) do
  begin
    DrawText(lbWinInfo.Canvas.Handle, PChar(WindowName),
      Length(WindowName), Rect,dt_Left or dt_VCenter);
    { Shift the drawing rectangle over by using the size
      HeaderControl1's sections to determine where to draw the next
      string }
    Rect.Left := Rect.Left + hdWinInfo.Sections[0].Width;
    DrawText(lbWinInfo.Canvas.Handle, PChar(WindowClass),
      Length(WindowClass), Rect, dt_Left or dt_VCenter);
  end;
end;

procedure TMainForm.hdWinInfoSectionResize(HeaderControl:
   THeaderControl; Section: THeaderSection);
begin
  lbWinInfo.Invalidate; // Force ListBox1 to redraw itself.
end;

end.
