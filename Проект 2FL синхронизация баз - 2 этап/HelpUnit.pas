unit HelpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ImgList;

type
  THelpForm = class(TForm)
    WebBrowser1: TWebBrowser;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    BackButton: TToolButton;
    NextlButton: TToolButton;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure NextlButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation

{$R *.dfm}

procedure THelpForm.BackButtonClick(Sender: TObject);
begin
 WebBrowser1.GoBack;
end;

procedure THelpForm.FormShow(Sender: TObject);
var
sPath: string;
begin
  getDir(0, sPath);
  sPath := sPath + '\stab.html';
  WebBrowser1.Navigate(sPath);
end;

procedure THelpForm.NextlButtonClick(Sender: TObject);
begin
 WebBrowser1.GoForward;
end;

end.
