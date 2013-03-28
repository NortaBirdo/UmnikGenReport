{ Unit  ChangePassUnit
������: 1.2 �� 16.10
�����������: ����������� �������
Sokolovskynik@gmail.com

�����������: IniFiles

������ ������ �������� ��������� � �������:
����������� � ����, ��������� � ��������� ���������� � ������}
unit ChangePassUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  SQLite3, SQLiteWrap, IniFiles;

type
  TChangePassForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Okbutton: TButton;
    CancelButton: TButton;
    UserNameEdit: TEdit;
    OldPassEdit: TEdit;
    NewPassEdit: TEdit;
    RepNewPassEdit: TEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
   sresNoEqualPass,
   sresNoSuchPassUser,
   sresNoSuchUserName,
   sresNoSuchTabPass: string
  end;

var
  ChangePassForm: TChangePassForm;
  db: TSQLiteDatabase;
  table: TSQLiteTable;
  sTab, sFieldUserName, sFieldPassName: string; //���������� ��� �������� �������, ���� �����

implementation

{$R *.dfm}

uses MainUnit;

//����� ��� ���������
procedure TChangePassForm.CancelButtonClick(Sender: TObject);
begin
ChangePassForm.Close;
end;

procedure TChangePassForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 db.Free;
end;

//��������� ������ ��� ������ ����
procedure TChangePassForm.FormShow(Sender: TObject);
var
sPath, sQuery: string;                       //���������� ��� �������� ���� � �������
SettingFile: TIniFile;
begin
  //������ ���� � �����
  GetDir (0, sPath);
  sPath := sPath + '\setting.ini';
                                    //���� ���� ����������, ���������
  if FileExists(sPath) then SettingFile := TIniFile.Create(sPath)
                      else
                       begin        //���� ���, ��������� ������
                         ShowMessage(sresNoSuchTabPass);
                         Okbutton.Enabled := false;
                         exit
                       end;

 if Mainform.USBDriveComboBox.Text = '' then  //���� �������� �� ������
  begin                              //�����������
    ShowMessage(MainForm.sresDChangeUSB);
    Mainform.USBDriveComboBox.Items.Clear;
    Mainform.GetDiscs;                        //��������� ������ ���������
    Okbutton.Enabled := false;
    exit;                           //� �������
  end;
   //������ ���� � SQLite ��
  sPath := Mainform.USBDriveComboBox.Text + ':/' + SettingFile.ReadString('PathDB', 'SQLiteDB', '');

  if sPath = Mainform.USBDriveComboBox.Text + ':/'  then    //���� ���� ������
    begin                          //�����������
      ShowMessage(MainForm.sresNoArgLlocalSQLite);
                                   //��������� ���� ������
      if Not (Mainform.OpenDialog1.Execute) then  //���� ������ �� �������
        begin                       //����������� � �������
         ShowMessage(MainForm.sresNoPathSQLite);
         Okbutton.Enabled := false;
         exit;
        end
        else sPath := MainForm.USBDriveComboBox.Text + ':/' + MainForm.OpenDialog1.FileName;
    end;

 //������ ���������, ������ ����� ������� ������ � ���
 sTab := SettingFile.ReadString('PassInfo', 'TableName', '');
 if sTab = '' then
  begin
    ShowMessage(sresNoSuchTabPass);
    Okbutton.Enabled := false;
    exit;
  end;

 sFieldUserName := SettingFile.ReadString('PassInfo', 'LogFieldName', '');
  if sFieldUserName = '' then
  begin
    ShowMessage(sresNoSuchUserName);
    Okbutton.Enabled := false;
    exit;
  end;

 sFieldPassName := SettingFile.ReadString('PassInfo', 'PassFieldName', '');
  if sFieldPassName = '' then
  begin
    ShowMessage(sresNoSuchPassUser);
    Okbutton.Enabled := false;
    exit;
  end;

 Okbutton.Enabled := true;

 try
  db := TSQLiteDatabase.Create(sPath);
  sQuery := 'SELECT * FROM ' + STab;
  table := TSQLiteTable.Create(db, sQuery);

  UserNameEdit.Text := table.FieldAsString(table.FieldIndex[sFieldUserName]);
  OldPassEdit.Text := table.FieldAsString(table.FieldIndex[sFieldPassName]);

  table.Free;
   except
     on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(MainForm.sresError), MB_ICONERROR);
      exit;
    end;
  end;
end;

procedure TChangePassForm.OkbuttonClick(Sender: TObject);
var
sQuery: String;
begin
 //�������� ��� ����� ������ ����� ��� ��������
  if NewPassEdit.Text <> RepNewPassEdit.Text then
   begin
     ShowMessage(sresNoEqualPass);
     NewPassEdit.SetFocus;
     exit;
   end;
 //�������� ������ � ��
 try

  sQuery := 'UPDATE '+ sTab + ' SET ' + sFieldUserName + '=' + #39 + UserNameEdit.Text + #39 +
   ', ' + sFieldPassName + '=' + #39 + NewPassEdit.Text+ #39;
  table := TSQLiteTable.Create(db, sQuery);
  table.Free;
  ChangePassForm.Close;
 except
     on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(MainForm.sresError), MB_ICONERROR);
      exit;
    end;
  end;

end;

end.
