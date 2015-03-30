program CalendarTest;

uses
  Forms,
  MainFfm in 'MainFfm.pas' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
