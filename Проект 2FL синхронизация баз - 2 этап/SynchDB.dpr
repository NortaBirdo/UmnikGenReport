program SynchDB;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  CollisionUnit in 'CollisionUnit.pas' {CollisionForm},
  ChangePassUnit in 'ChangePassUnit.pas' {ChangePassForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  HelpUnit in 'HelpUnit.pas' {HelpForm},
  ResourceUnit in 'ResourceUnit.pas',
  GeneralCollizionUnit in 'GeneralCollizionUnit.pas' {GeneralCollizionForm},
  SynchUnit in 'SynchUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCollisionForm, CollisionForm);
  Application.CreateForm(TChangePassForm, ChangePassForm);
  Application.CreateForm(TGeneralCollizionForm, GeneralCollizionForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(THelpForm, HelpForm);
  Application.Run;
end.
