program GenReportUMNIK;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  CatalogUnit in 'CatalogUnit.pas',
  AboutFormUnit in 'AboutFormUnit.pas' {AboutForm},
  HelpFormUnit in 'HelpFormUnit.pas' {HelpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
