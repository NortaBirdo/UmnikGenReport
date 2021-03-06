unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ImgList, Vcl.ToolWin,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls, Vcl.XPMan, Vcl.CheckLst, Vcl.FileCtrl,
  ComObj;

type
  TMainForm = class(TForm)
    XPManifest1: TXPManifest;
    MemoGenReportProtocol: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    N8: TMenuItem;
    N9: TMenuItem;
    ToolBtnGenReport: TToolButton;
    ToolButton3: TToolButton;
    ToolBtnHelp: TToolButton;
    ToolButton5: TToolButton;
    ToolBtnExit: TToolButton;
    Label1: TLabel;
    Label2: TLabel;
    ChListBoxFileList: TCheckListBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelAllFileCount: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    CheckBoxIsVisible: TCheckBox;
    ImageList1: TImageList;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure ChListBoxFileListClickCheck(Sender: TObject);
    procedure N3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
  type
  TCoordinate = record
   startPriv, startTotel: OleVariant;
   end;

  var
  MainForm: TMainForm;


implementation

{$R *.dfm}

uses CatalogUnit, AboutFormUnit, HelpFormUnit, ReportGenUnit;

//������� ���������� ������ ��� �������������
procedure TMainForm.ChListBoxFileListClickCheck(Sender: TObject);
var
i: integer;
count: integer;
begin
 count := 0;
 for i := 0 to ChListBoxFileList.Items.Count - 1 do
  if ChListBoxFileList.Checked[i] = true then count := count + 1;

 LabelAllFileCount.Caption := IntToStr(count);
end;

//������� ������ ������ �� ��������
procedure TMainForm.DirectoryListBox1Change(Sender: TObject);
var
Catalog: TCatalog;
i, high: integer;
begin

Catalog := TCatalog.Create;
Catalog.sFolderName := DirectoryListBox1.Directory;
Catalog.GetFileList;

high := Length(Catalog.arFileList) - 1;
ChListBoxFileList.Items.Clear;

for I := 0 to high do
 begin
   ChListBoxFileList.Items.Add(Catalog.arFileList[i]);
   ChListBoxFileList.Checked[i] := true;
 end;
LabelAllFileCount.Caption := IntToStr(high + 1);

end;

//��������� ������
function FindAndReplace(WordDoc: OleVariant; LocalPos: TCoordinate; GenReport, PrivateReport:TFileName; S1, S2, S3, S4:string):TCoordinate;
var
 FStart, FEnd, a, b: OleVariant;
 i,DocLen:longint;
 s: string;
 label next;
begin
 FStart:=0;
 FEnd:=0;

 WordDoc.Documents.Item(PrivateReport).Activate;

 //���� ������ �������
 DocLen:=Length(WordDoc.Documents.Item(PrivateReport).Range.Text);
 for I := LocalPos.startPriv to DocLen - length (s1) do
  begin
    a:=i;
    b:=i + length (s1);
    s := WordDoc.Documents.Item(PrivateReport).Range(a,b).Text;
    if s=S1 then begin
                  FStart:=i+length (s1);
                  break;
                 end;
  end;
 //���� ����� �������
 for I := FStart to DocLen - length (s2) do
  begin
    if S2 = '' then begin
                    FEnd := DocLen - length (s2);
                    Result.startPriv := FEnd;
                    break;
                    end;
    a:=i;
    b:=i + length (s2);
    s := WordDoc.Documents.Item(PrivateReport).Range(a,b).Text;
    if (s=S2) or (s = '�����')  then begin
                                    FEnd:=i;
                                    Result.startPriv := FEnd;
                                    break;
                                   end;
  end;

 //���� ��� ���� �� ������������ ������������ ��������
 if (s1 = '������ �������������� ����������') and (FEnd=0) then
   FEnd := DocLen - length (s2);

 if (FStart=0) or (FEnd=0) then begin
                                 Result.startPriv := -1;
                                 Result.startTotel := -1;
                                 exit;
                                end
                           else begin
                                 WordDoc.Documents.Item(PrivateReport).Range(FStart, FEnd).Select;
                                 WordDoc.Selection.Copy;
                                end;

 FStart:=0;
 FEnd:=0;
 WordDoc.Documents.Item(GenReport).Activate;
 DocLen:=Length(WordDoc.Documents.Item(GenReport).Range.Text);
 for i:=LocalPos.startTotel to DocLen-6 do
  begin
   a:=i;
   b:=i+6;
   if (WordDoc.Documents.Item(GenReport).Range(a,b).Text=S3)
    then FStart:=i
    else if (WordDoc.Documents.Item(GenReport).Range(a,b).Text=S4) then begin
                                                                         FEnd:=i+6;
                                                                         break;
                                                                        end;
  end;

 if (FStart=0) or (FEnd=0) then begin
                                 Result.startPriv := -2;
                                 Result.startTotel := -2;
                                 exit;
                                end
                           else begin
                                 WordDoc.Documents.Item(GenReport).Range(FStart, FEnd).Select;
                                 WordDoc.Selection.Paste;
                                 Result.startTotel := FEnd;
                                end;
end;

procedure GenLabel(var sStartPrivReport, sEnd: string; i:integer);
begin
 case i of
  1: begin
      sStartPrivReport := '1)';
      sEnd := '����';
     end;
  2: begin
      sStartPrivReport := '�������� �����:';
      sEnd := '������ ������������';
     end;
  3: begin
      sStartPrivReport := '������ ������������';
      sEnd := '�����������';
     end;
  4: begin
      sStartPrivReport := '�����������';
      sEnd := '����������� � ����������';
     end;
  5: begin
      sStartPrivReport := '����������� � ����������';
      sEnd := '��������';
     end;
  6: begin
      sStartPrivReport := '��������';
      sEnd := '�������� �����';
     end;
  7: begin
      sStartPrivReport := '�������� �����';
      sEnd := '����������';
     end;
  8: begin
      sStartPrivReport := '����������';
      sEnd := '������ �������������� ����������';
     end;
  9: begin
      sStartPrivReport := '������ �������������� ����������';
      sEnd := '����������';
     end;
  10: begin
      sStartPrivReport := '����������';
      sEnd := '�����';
     end;

 end;
end;

procedure TMainForm.N3Click(Sender: TObject);
var
 iError, LocalPos: TCoordinate;
 ShablonPath, PrivateReport:string;  //���� � ������
 WordDoc: OleVariant;                //���-��������
 i, j: integer;                      //��������
 sStartSnablon, sEndShablon: string; //�����
 sStartPrivReport, sEndPrivReport: string;
 pos: OleVariant;
 posBig: array [0..9] of OleVariant; //������ ��������� ���� ����������� ������� ��� �������� ������
begin

 ShablonPath := ExtractFilePath(Application.ExeName) + '������.docx';

 WordDoc:=CreateOLEObject('Word.Application');
 WordDoc.Visible:= CheckBoxIsVisible.Checked;
 WordDoc.Documents.Open(ShablonPath);

 //�������������� ������
 for j := 0 to 9 do posbig[j] := 0;

 //������� ���������� ��� �������
 MemoGenReportProtocol.Lines.Clear;

 for I := 0 to ChListBoxFileList.Items.Count - 1 do
  begin
   if not (ChListBoxFileList.Checked[i]) then Continue;
   MemoGenReportProtocol.Lines.Add('������ ��������� ������ ' + ChListBoxFileList.Items.Strings[i]);
   PrivateReport := DirectoryListBox1.Directory + '\' + ChListBoxFileList.Items.Strings[i];
   WordDoc.Documents.Open(PrivateReport);
   //������� � ������� �������� ������
   LocalPos.startPriv := 0;
   for j := 1 to 10 do
     begin
      //����������� ����� ��� ��������������� �������
      LocalPos.startTotel := posBig[j-1];
      GenLabel(sStartPrivReport, sEndPrivReport, j);
      //��������� ����� ��� �������
      if j<10 then sStartSnablon := '<#0' + IntToStr(j)
              else sStartSnablon := '<#' + IntToStr(j);
      if i<10 then sStartSnablon := sStartSnablon + '0' + IntToStr(i+1)
              else sStartSnablon := sStartSnablon + IntToStr(i+1);

      if j<10 then sEndShablon := '0' + IntToStr(j)
              else sEndShablon := IntToStr(j);
      if i<10 then sEndShablon := sEndShablon + '0' + IntToStr(i+1) + '#>'
              else sEndShablon := sEndShablon + IntToStr(i+1) + '#>';
      try
       iError := FindAndReplace(WordDoc, LocalPos,  ShablonPath, PrivateReport,
                             sStartPrivReport, sEndPrivReport, sStartSnablon, sEndShablon);
      except
       MemoGenReportProtocol.Lines.Add('������ �����������-������� � ������ ' + ChListBoxFileList.Items.Strings[i] + ', ������ ' + sStartPrivReport);
       Label7.Caption := IntToStr(StrToInt(Label7.Caption) + 1);
       break;
      end;
      case iError.startPriv of
       -1: MemoGenReportProtocol.Lines.Add('� ������ ' + ChListBoxFileList.Items.Strings[i] + ' �� ������ ������ ' + sStartPrivReport +
                 '�����: ' +   sStartPrivReport +', ' + sEndPrivReport  +', ' + sStartSnablon  +', ' +  sEndShablon);
       -2: MemoGenReportProtocol.Lines.Add('� ������� ������ �� ������� ����� ��� ������� �������: ' + sStartPrivReport +
                  ' ���������:' + sStartSnablon + ' ��������:' +sEndShablon );
      end;
      if j<3  then begin
                    LocalPos.startPriv := 0;
                    LocalPos.startTotel := 0;
                    end
              else begin
                    LocalPos := iError;
                    if LocalPos.startTotel > 0 then Posbig[j-1] := LocalPos.startTotel;
                   end;

     end;
   MemoGenReportProtocol.Lines.Add('����� ' + ChListBoxFileList.Items.Strings[i] + ' ���������');
   Label6.Caption := IntToStr(StrToInt(Label6.Caption) + 1);
   WordDoc.Documents.Item(PrivateReport).Close;
   MainForm.Refresh;
   Application.ProcessMessages;
  end;

 WordDoc.Documents.Item(ShablonPath).Close;
 WordDoc.Quit;
 WordDoc:=Unassigned;

end;

//�������� ���������
procedure TMainForm.N5Click(Sender: TObject);
begin
 MainForm.Close;
end;

//������� � "� ���������"
procedure TMainForm.N7Click(Sender: TObject);
begin
application.CreateForm(TAboutForm, AboutForm);
AboutForm.ShowModal;
aboutForm.Free;
end;

//������� � "�������"
procedure TMainForm.N8Click(Sender: TObject);
begin
Application.CreateForm(THelpForm, HelpForm);
HelpForm.ShowModal;
HelpForm.Free;
end;



end.
