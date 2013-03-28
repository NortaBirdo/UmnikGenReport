{unit MainUnit
������: 6.0 �� 26.03
�����������: ����������� �������
Sokolovskynik@gmail.com

�����������: SQLite3, SQLiteWrap, IniFiles, ResourceUnit, Math
���� ������ ���������� �������� ����, ������������ ������� � ���� ��������, ����� ������, �������, � ��������.
������������ ��������� ����������� � ��������� � ���������������� ��.
�������� �������� ���������� � ���������������� �����, ������������� �������.
���������� ����� ������}

unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Grids,
  Vcl.Buttons, Vcl.XPMan,
  SQLite3, SQLiteWrap, DateUtils, SynchUnit,
  Vcl.Menus, Data.DB, IBCustomDataSet, IBQuery, IBDatabase,
  IBUpdateSQL, Vcl.ExtCtrls, Math, Vcl.ComCtrls;

type
  TMetaNameTab=record
    iMetaID: integer;
    sFBName, sSQLName, sSQLPrimeKey, sFBPrimeKey: string;
    sMetaName:string;
    idirection: integer;
  end;
  TMetaNameField=record
    sFBField, sSQLField, sDataType: string;
    sMetaName:string;

  end;
  TFlag=record
   iStatus: integer;
   bInReport: boolean;
   end;
  TUpdateInfo=record
   sQueryText:string;    //� ������ ���� ����������� - SQLite
   sDopQueryText:string; //��� FB �� ������ ���� �����������
   sSetFlagQuery: string;
   iDirect:integer;      //1 - ��������� � FB, 0 - ��������� � SQLite, 2 - ��� �����������
  end;

  TMainForm = class(TForm)
    USBDriveComboBox: TComboBox;
    TableSynchChListBox: TCheckListBox;
    AllChekedButton: TButton;
    NoOneChekedButton: TButton;
    SynchButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ProtocolConnectMemo: TMemo;
    UpDateUSBButton: TBitBtn;
    ProtocolSynchGrid: TStringGrid;
    XPManifest1: TXPManifest;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N3: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    IBDatabase2: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuery1: TIBQuery;
    N12: TMenuItem;
    N13: TMenuItem;
    SaveDialog1: TSaveDialog;
    ErrorImage: TImage;
    DoneImage: TImage;
    N14: TMenuItem;
    IBQuery2: TIBQuery;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    PercentLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GetDiscs;
    procedure UpDateUSBButtonClick(Sender: TObject);
    procedure AllChekedButtonClick(Sender: TObject);
    procedure NoOneChekedButtonClick(Sender: TObject);
    procedure TableSynchChListBoxClickCheck(Sender: TObject);
    procedure SynchButtonClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure ProtocolSynchGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N5Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private


  public

   arMetaNameTab: array of TMetaNameTab;     //������ ������ �������� ����� ������
   arMetaNameField: array of TMetaNameField;  //������ ��� �������� ����� �������������.
   GenStringQuery: TGenStringQuery;
   arCollision: array of TUpdateInfo;         //������ ������ ������� �� ���������� 0 - ��,
                                              //1- �� 2- � ������ �������, -1 - �������
   SkipAll, SkipThis: boolean;                //����� ���������� ���, ���������� �������
   arFlag: array of TFlag;
   iRowReport: integer;

   {���������� ��� ���������}
   sresStartSynch,
   sresDChangeUSB,
   sresSettingAbsent,
   sresNoArgLlocalSQLite,
   sresNoPathSQLite,
   sresNoArgLocalFireBird,
   sresNoPathFireBird,
   sresSettingSuuccess,
   sresError,
   sresErrorConSQLite,
   sresConnectSQLite,
   sresSuccess,
   sresErrorConFireBird,
   sresConnectFireBird,
   sresTakingListField,
   sresBeginSynch,
   sresFinishSynch,
   sresTable,
   sresRecordCount: string
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CollisionUnit, IniFiles, ChangePassUnit, AboutUnit, HelpUnit, ResourceUnit,
  GeneralCollizionUnit;


//��������� ���� ������ ��� �������������
procedure TMainForm.AllChekedButtonClick(Sender: TObject);
begin
  TableSynchChListBox.CheckAll(cbChecked, true, true);
  SynchButton.Enabled := true;
end;

//������� � ���� "� ��������"
procedure TMainForm.N11Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

//���������� ���� ������
procedure TMainForm.N12Click(Sender: TObject);
var
 i: integer;
begin
  if SaveDialog1.Execute then
   begin
     for I := 1 to ProtocolSynchGrid.RowCount - 1 do
      ProtocolConnectMemo.Lines.add(ProtocolSynchGrid.Cells[0, i]+
       ' - ' + ProtocolSynchGrid.Cells[2, i]);
     for I := 0 to Length(arFlag)-1 do
       if arFlag[i].bInReport = false then
        ProtocolConnectMemo.Lines.add(arMetaNameTab[i].sMetaName +
          ' - 0');
     ProtocolConnectMemo.Lines.SaveToFile(SaveDialog1.FileName+ '.txt');
   end;

end;

//������� � ���� ������
procedure TMainForm.N5Click(Sender: TObject);
begin
 with ChangePassForm do
  begin
   if n7.Checked then
    begin
    sresNoEqualPass := sresNoEqualPassRU;
    sresNoSuchPassUser := sresNoSuchPassUserRU;
    sresNoSuchUserName := sresNoSuchUserNameRU;
    sresNoSuchTabPass := sresNoSuchTabPassRU;
    end;
    ChangePassForm.ShowModal;
  end;
end;


//������� � ���� "�������"
procedure TMainForm.N9Click(Sender: TObject);
begin
  HelpForm.ShowModal;
end;

//������ ��������� �� ���� ������ ��� �������������
procedure TMainForm.NoOneChekedButtonClick(Sender: TObject);
begin
 TableSynchChListBox.CheckAll(cbUnchecked, false, false);
 SynchButton.Enabled := false;
end;

//������ �������������
procedure TMainForm.SynchButtonClick(Sender: TObject);
var
 SettingFile: TIniFile;
 sPath: string;                          //���� � ������ ���������
 sSQLitePath, sFBPath, sQuery, sQuery1 : string;  //���� � ����� SQLite � FirBird, �������
 Table: TSQLiteTable;                  //���������������� SQLite
 AddTable: TSQLiteTable;               //���������������� ������� SQLite+ ������� ��� ����������
 dbSetting: TSQLiteDatabase;            //��������� ����
 TabMetaName: TSQLiteTable;             //��������� �������
 i, j, High: integer;                   //��������� ��� ������
 iCountRowReport:integer;               //���-�� ������ ��� ���������
 sValQuery: string;                     //�������������� ������ �������
 iCountRec: integer;                    //������� ������������������ �������
 sStr1, sStr2: Double;
 int1, int2 : integer;
 bIsMod: boolean;


 db: TSQLiteDatabase;
 QueryForSQLite, QueryForFB: TStringList;
 sListFieldsSQLite, sListFieldsFB: string; //������������ ������ ����� ��� �������
 iTotalCount, iProcessingCount: integer;
 label Collizion;
begin
 ProtocolConnectMemo.Lines.Clear;                  //�������� ����� ��������
 ProtocolConnectMemo.Lines.Add(sresStartSynch);

 if USBDriveComboBox.Text = '' then  //���� �������� �� ������
  begin                              //�����������
    ShowMessage(sresDChangeUSB);
    ProtocolConnectMemo.Lines.Add(sresDChangeUSB);
    USBDriveComboBox.Items.Clear;
    GetDiscs;                        //��������� ������ ���������
    exit;                            //� �������
  end;


  //������ ���� � �����
  GetDir (0, sPath);
  sPath := sPath + '\setting.ini';
                                    //���� ���� ����������, ���������
  if FileExists(sPath) then SettingFile := TIniFile.Create(sPath)
                      else
                       begin        //���� ���, ��������� ������
                         ProtocolConnectMemo.Lines.Add(sresSettingAbsent);
                         ShowMessage(sresSettingAbsent);
                         exit;
                       end;

                                    //������ ���� � SQLite ��
  sSQLitePath := USBDriveComboBox.Text + ':/' + SettingFile.ReadString('PathDB', 'SQLiteDB', '');

  if sSQLitePath = USBDriveComboBox.Text then         //���� ���� ������
    begin                          //�����������
      ShowMessage(sresNoArgLlocalSQLite);
                                   //��������� ���� ������
      if Not (OpenDialog1.Execute) then  //���� ������ �� �������
        begin                       //����������� � �������
         ShowMessage(sresNoPathSQLite);
         ProtocolConnectMemo.Lines.Add(sresNoPathSQLite);
         exit;
        end
        else sSQLitePath := USBDriveComboBox.Text + ':/' + OpenDialog1.FileName;
    end;

                                       //������ ���� � FireBird ��
  sFBPath := SettingFile.ReadString('PathDB', 'FBDB', '');

  if sFBPath = '' then                //���� ���� ������
    begin                             //�����������
      ShowMessage(sresNoArgLocalFireBird);
                                      //��������� ���� ������
      if Not (OpenDialog1.Execute) then  //���� ������ �� �������
        begin                         //����������� � �������
         ShowMessage(sresNoPathFireBird);
         ProtocolConnectMemo.Lines.Add(sresNoPathFireBird);
         exit;
        end
        else sFBPath := OpenDialog1.FileName;
    end;

  ProtocolConnectMemo.Lines.Add(sresSettingSuuccess);
  // ����������� � ���� SQLite ������
  try
  //���� �� ��������� ���� ��� ����, ���������� �� �������
   if not (FileExists (sSQLitePath)) then
    begin
      if OpenDialog1.Execute then
       begin
         sSQLitePath := OpenDialog1.FileName;
         SettingFile.WriteString('PathDB', 'SQLiteDB', Copy(sSQLitePath, 4, Length(sSQLitePath)));
       end
       else begin
             //���� ������ �� �������, ��������� � ������
             ShowMessage(sresNoPathSQLite);
             ProtocolConnectMemo.Lines.Add(sresNoPathSQLite);
             exit;
             end;
     end;
   db := TSQLiteDatabase.Create(sSQLitePath);
   ProtocolConnectMemo.Lines.Add(sresConnectSQLite + sSQLitePath + sresSuccess);
  except
     on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(sresError), MB_ICONERROR);
      ProtocolConnectMemo.Lines.Add(sresErrorConSQLite + sSQLitePath +' '+ PChar(E.Message));
      exit;
    end;
  end;

  // ����������� � ���� FireBird ������
  try
    if not (FileExists (sFBPath)) then
     begin
       if OpenDialog1.Execute then
        begin
         sFBPath := OpenDialog1.FileName;
         SettingFile.WriteString('PathDB', 'FBDB', sFBPath);
        end
        else begin
             //���� ������ �� �������, ��������� � ������
             ShowMessage(sresNoPathFireBird);
             ProtocolConnectMemo.Lines.Add(sresNoPathFireBird);
             exit;
            end;
      end;
   IBDatabase2.DatabaseName := sFBPath;
   IBDatabase2.Connected := true;
   IBTransaction1.Active := true;
   ProtocolConnectMemo.Lines.Add(sresConnectFireBird + sFBPath + sresSuccess);

  except
     on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(sresError), MB_ICONERROR);
      ProtocolConnectMemo.Lines.Add(sresErrorConFireBird + sFBPath + ' ' + PChar(E.Message));
      exit;
    end;
  end;


  // ����������� � ��������� ��
  GetDir(0, sPath);
  sPath := sPath + '\SynchDB.db';
  try
  dbSetting := TSQLiteDatabase.Create(sPath);
  ProtocolConnectMemo.Lines.Add(sresTakingListField);
   except
   on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(sresError), MB_ICONERROR);
      ProtocolConnectMemo.Lines.Add(sresError+ ':' + PChar(E.Message));
    end;
  end;

 //������������� - ������
 //����������� ������� ������ ����� ����������������, ����� ��������� ������
 //����������� ��� ���������
 j:=1;
 iCountRowReport := 1;
 iRowReport := 0;     //�������� ������� �������������

 for i := 0 to TableSynchChListBox.Count-1 do
   if TableSynchChListBox.Checked[i] then j := j + 1;
 ProtocolSynchGrid.RowCount := 1;
 ProtocolSynchGrid.RowCount := j;
 MainForm.Repaint;
 ProtocolConnectMemo.Lines.Add(sresBeginSynch);
 Application.ProcessMessages;

 SetLength(arFlag, Length(arMetaNameTab));
 SkipAll := false;
 SkipThis := false;

 Screen.Cursor := crHourGlass;

 //������������� �������� ��� ������� ��������.
 QueryForSQLite := TStringList.Create;
 QueryForFB := TStringList.Create;
 //������� ������
 try
  for i:= 0 to Length(arMetaNameTab)-1 do
   begin
    //������������� � ����������� FB->SQLite
    //��������� ���� �� ������� ������� ��� �������������
    //��������� ������ ����������� � ��� �� ������������������,
    //��� ��������� ������ ��������� ������,
    //�� ����� ���������� �� ���� �� �������
    if not (TableSynchChListBox.Checked[i]) then
      begin //������� �� ������� ��� �������������
        arFlag[i].iStatus := 0;
        arFlag[i].bInReport := false;
        Continue;
      end;
     ProgressBar1.Position := 0;
     PercentLabel.Caption := '0%';
     //�������� ������ ���������������� ����� ��� ������� �������
     sQuery := 'SELECT * FROM MetaNameFieldTab WHERE LinkMetaNameTab=' +
       IntToStr(arMetaNameTab[i].iMetaID);
     TabMetaName := TSQLiteTable.Create(dbSetting, sQuery);
     j := 1;
     iCountRec := 0;

     //��������� ������ ���������������� �����
     GenStringQuery := TGenStringQuery.Create;
     while not (TabMetaName.EOF) do
      begin
       with GenStringQuery do
        begin
        SetLength (arMetaNameField, j);
        arMetaNameField[j-1].sFBField :=
         TabMetaName.FieldAsString(TabMetaName.FieldIndex['FBFieldName']);
        arMetaNameField[j-1].sSQLField :=
         TabMetaName.FieldAsString(TabMetaName.FieldIndex['SQLFieldName']);
        arMetaNameField[j-1].sDataType :=
         TabMetaName.FieldAsString(TabMetaName.FieldIndex['DataType']);
        arMetaNameField[j-1].sMetaName :=
         TabMetaName.FieldAsString(TabMetaName.FieldIndex['MetaNameField']);
        j := j + 1;
        end;
       TabMetaName.Next;
      end;
     TabMetaName.Free;

     high := Length (GenStringQuery.arMetaNameField) - 1;  //���������� ���������� �����
     GenStringQuery.high := high;

     //�������� ������ ��� �������
     sListFieldsFB := GenStringQuery.GenFieldString(0);
     sListFieldsSQLite := GenStringQuery.GenFieldString(1) + ', FBID';

     //������� ���� ��� ��������
     with GeneralCollizionForm do
      begin
       FBStringGrid.RowCount := 2;
       FBStringGrid.ColCount := high + 2;
       SQLStringGrid.ColCount := high + 2;
       SQLStringGrid.RowCount := 2;
       FBStringGrid.Cells[0,0] := 'ID';
       SQLStringGrid.Cells[0,0] := 'FBID';
       MataNameTabLabel.Caption := arMetaNameTab[i].sMetaName;
        for j := 0 to High do
         begin
          //������� �� FB
          FBStringGrid.Cells[j+1, 0] := GenStringQuery.arMetaNameField[j].sMetaName;
          //������� �� SQLite
          SQLStringGrid.Cells[j+1,0] := GenStringQuery.arMetaNameField[j].sMetaName;
         end;
      end;

     //���������, ������������� �� ������� ��� ������������� � ����� �����������
     if arMetaNameTab[i].iDirection = 1 then
      begin
       sQuery := 'SELECT ' + sListFieldsFB + ' FROM ' + arMetaNameTab[i].sFBName
        + ' ORDER BY ' + arMetaNameTab[i].sFBPrimeKey;
       IBQuery1.Close;
       IBQuery1.SQL.Clear;
       IBQuery1.SQL.Add(sQuery);
       IBQuery1.Open;
       IBQuery1.First;

       sQuery := 'SELECT ' + sListFieldsSQLite + ' FROM ' + arMetaNameTab[i].sSQLName + ' ORDER BY FBID';
       Table := TSQLiteTable.Create(db, sQuery);

       //���� ��������� � ��
       bIsMod := false;
       while not(IBQuery1.Eof) do
        begin
         if Table.FieldIsNull(Table.FieldIndex['FBID']) then
          begin
           bIsMod := true;
           break;
          end;
         if IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsString <>
              Table.FieldAsString(Table.FieldIndex['FBID']) then
               begin
                bIsMod := true;
                break;
               end;

         Table.Next;
         IBQuery1.Next;
        end;
       Table.Free;

       //���� ��������� � SQLite
       if not (bIsMod) then
        begin
         sQuery := 'SELECT FBID FROM ' + arMetaNameTab[i].sSQLName + ' ORDER BY FBID';
         Table := TSQLiteTable.Create(db, sQuery);
         IBQuery1.First;
         while not(Table.EOF) do
          begin
           if IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).IsNull then
             begin
              bIsMod := true;
              break;
             end;
           if IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsString <>
             Table.FieldAsString(Table.FieldIndex['FBID']) then
             begin
              bIsMod := true;
              break;
             end;

           IBQuery1.Next;
           table.Next;
          end;
         Table.Free;
         iCountRec := 0;
        end
        else //����� ���������, ������������ �������
         begin
          iCountRec := 0;
          sQuery := 'DELETE FROM ' + arMetaNameTab[i].sSQLName;
          Table := TSQLiteTable.Create(db, sQuery);
          IBQuery1.First;

          while not (IBQuery1.Eof) do
           begin
            sQuery := 'INSERT INTO ' + ArMetaNameTab[i].sSQLName + ' (' + sListFieldsSQLite + ') ';
            sValQuery := GenStringQuery.GenValString(IBQuery1, arMetaNameTab[i].sFBPrimeKey);
            sQuery := sQuery + sValQuery;
            QueryForSQLite.Add(sQuery);
            sQuery := 'UPDATE '+ ArMetaNameTab[i].sSQLName + ' SET is_new = 0 WHERE ' +  ArMetaNameTab[i].sSQLPrimeKey
                      + '='+ #39 + IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsString + #39;
            QueryForSQLite.Add(sQuery);
            iCountRec := iCountRec + 1;
            IBQuery1.Next;
           end;
         end;

      ProtocolSynchGrid.Cells[0, iCountRowReport] := arMetaNameTab[i].sMetaName;
      arFlag[i].iStatus := 1;
      arFlag[i].bInReport := true;
      ProtocolSynchGrid.Cells[2, iCountRowReport] := IntToStr(iCountRec);
      iCountRec := iCountRec + 1;
      iCountRowReport := iCountRowReport + 1;
      iRowReport := i;
      ProtocolSynchGrid.Repaint;
      //������� ���������� ������������������ ������/���������� ������
      MainForm.Repaint;
      Application.ProcessMessages;

      //��������� ���� ������������� ������
      sQuery := 'UPDATE MetaNameTab SET LastDate=' + #39 + DateToStr(Now) +#39 +
          ' WHERE ID = ' + #39 + IntToStr(arMetaNameTab[i].iMetaID) + #39;
      TabMetaName := TSQLiteTable.Create(dbSetting, sQuery);
      //��������� ���� � ������ ������
      TableSynchChListBox.Items.Strings[i] := arMetaNameTab[i].sMetaName + ' (' + DateToStr(Now) +')';
      Continue; //������ �� ��������� ��������
     end;


     //�������� ������� �� SQLite, ������� ���� ������� �� FB
     sQuery := 'SELECT ' + sListFieldsSQLite + ', is_new'+ ' FROM '
                + arMetaNameTab[i].sSQLName + ' WHERE is_new = 0';
     Table := TSQLiteTable.Create(db, sQuery);

     while not (Table.EOF) do
      begin
       //���������� ������ � FB
       IBQuery1.Close;
       IBQuery1.SQL.Clear;
       sQuery := 'SELECT ' + sListFieldsFB + ' FROM '+ arMetaNameTab[i].sFBName +
          ' WHERE ' + arMetaNameTab[i].sFBPrimeKey + ' = ' + #39 +
            Table.FieldAsString(table.FieldIndex['FBID']) + #39;
       IBQuery1.SQL.Add(sQuery);
       IBQuery1.Open;

       //���� ����� ������ � FB �� �������, ������� ��
       if IBQuery1.FieldByName(GenStringQuery.arMetaNameField[0].sFBField).IsNull then
         begin
          sQuery := 'DELETE FROM ' + arMetaNameTab[i].sSQLName +
             ' WHERE FBID = ' + #39 + Table.FieldAsString(table.FieldIndex['FBID']) + #39;
          QueryForSQLite.Add(sQuery);
          iCountRec := iCountRec + 1;
         end;
       Table.Next;

      end;

     //���������� ��������
     IBQuery1.Close;
     IBQuery1.SQL.Clear;
     IBQuery1.SQL.Add('SELECT ' + sListFieldsFB + ' FROM '+ arMetaNameTab[i].sFBName);
     IBQuery1.Open;
     IBQuery1.First;
     while not(IBQuery1.Eof) do
      begin
      //��������� ������� ������������ ������ � SQLite
      //select * From ����������������_SQLite_�������
      //Where FBID = ID_��_��
      //���� ������� �� ��������� ��

       sQuery := 'SELECT ' + sListFieldsSQLite+ ', is_new FROM ' + ArMetaNameTab[i].sSQLName +
         ' WHERE FBID' + ' = ' + #39 + IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsWideString + #39;
       table := TSQLiteTable.Create(db, sQuery);

       //���� ����� ������ �� �������, �������� � SQLite
       if table.FieldIsNull(Table.FieldIndex['FBID']) then
        begin
         sQuery := 'INSERT INTO ' + ArMetaNameTab[i].sSQLName + ' (' + sListFieldsSQLite + ') ';
         sValQuery := GenStringQuery.GenValString(IBQuery1, arMetaNameTab[i].sFBPrimeKey);
         sQuery := sQuery + sValQuery;
         QueryForSQLite.Add(sQuery);
         //���������� ����
         sQuery := 'UPDATE ' + arMetaNameTab[i].sSQLName + ' SET is_new = 0 WHERE FBID = ' +  #39 +
                     IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsString + #39;

         QueryForSQLite.Add(sQuery);
         //����������� ������� �������
         iCountRec := iCountRec + 1;
        end
        else  //���������� ��������
        begin //���� ������ �������, ��������� ������������ ��������
         if not (SkipAll) then //���� ����� "���������� ���" ���������
          begin
           // �������� �� �����, ���� ���� �������� � FB - ��������
           if table.FieldAsInteger(Table.FieldIndex['is_new']) = 0 then
            begin
             for j := 0 to High do
              begin
               if GenStringQuery.arMetaNameField[j].sDataType = 'dat' then
                 begin
                  int1 := Table.FieldAsInteger(Table.FieldIndex[GenStringQuery.arMetaNameField[j].sSQLField]);
                  int2 := DateTimeToUnix(IBQuery1.FieldByName(GenStringQuery.arMetaNameField[j].sFBField).AsDateTime);
                   if  int1 <> int2 then goto Collizion //������ ���� �������� � FireBird, ������� � ���������
                                    else continue;
                 end;

                 if GenStringQuery.arMetaNameField[j].sDataType = 'flt' then
                   begin
                    sStr1 := RoundTo(IBQuery1.FieldByName(GenStringQuery.arMetaNameField[j].sFBField).AsFloat, -2);
                    sStr2 := RoundTo(StrToFloat( StringReplace(
                                Table.FieldAsString(Table.FieldIndex[GenStringQuery.arMetaNameField[j].sSQLField]),
                                 '.',',',[rfReplaceAll])), -2);
                    if (sStr1 - sStr2) <> 0 then goto Collizion
                                            else continue;
                   end
                  else
                  begin
                   if IBQuery1.FieldByName(GenStringQuery.arMetaNameField[j].sFBField).AsString
                    <> Table.FieldAsString(Table.FieldIndex[GenStringQuery.arMetaNameField[j].sSQLField])
                    then goto Collizion;
                  end;
              end;
            end;
           //��������� ���� ������ � SQLite ���� ���� ������� - ��������,
           if table.FieldAsInteger(Table.FieldIndex['is_new']) <> 0 then
            begin
             Collizion:
             //������� ����
             //������� ���� � ��������
             GeneralCollizionForm.RadioGroup1.ItemIndex := -1;
             with GeneralCollizionForm do
              begin
               //������� � ������� ���������������
               FBStringGrid.Cells[0, FBStringGrid.RowCount-1] :=
                   IBQuery1.FieldByName(arMetaNameTab[i].sFBPrimeKey).AsWideString;
               SQLStringGrid.Cells[0, SQLStringGrid.RowCount-1] :=
                   Table.FieldAsString(Table.FieldIndex['FBID']);
               for j := 0 to High do
                 begin
                  //������� �� FB
                  FBStringGrid.Cells[j+1, FBStringGrid.RowCount-1] :=
                      IBQuery1.FieldByName(GenStringQuery.arMetaNameField[j].sFBField).AsWideString;
                  //������������ ����
                  if GenStringQuery.arMetaNameField[j].sDataType = 'dat'
                   then
                    SQLStringGrid.Cells[j+1,SQLStringGrid.RowCount-1] :=
                         UnixToDTStr(Table.FieldAsInteger(Table.FieldIndex[GenStringQuery.arMetaNameField[j].sSQLField]))
                   else
                    SQLStringGrid.Cells[j+1,SQLStringGrid.RowCount-1] :=
                           Table.FieldAsString(Table.FieldIndex[GenStringQuery.arMetaNameField[j].sSQLField]);
                 end;
               //����������� ������ ��������
               SetLength(arCollision, SQLStringGrid.RowCount-1);
               arCollision[Length(arCollision)-1].iDirect := -1;

               FBStringGrid.RowCount := FBStringGrid.RowCount + 1;
               SQLStringGrid.RowCount := SQLStringGrid.RowCount + 1;
              end;
            end;
         end;
       end;

      Table.Free;
      IBQuery1.Next;

     end;


     //������� ������� ������
     if GeneralCollizionForm.FBStringGrid.RowCount>2 then
      begin
       GeneralCollizionForm.FBStringGrid.RowCount := GeneralCollizionForm.FBStringGrid.RowCount -1;
       GeneralCollizionForm.SQLStringGrid.RowCount := GeneralCollizionForm.SQLStringGrid.RowCount -1;
      end;

     //�������� ����� ������ � ����� ��� ��������
     GeneralCollizionForm.SQLNameTab := arMetaNameTab[i].sSQLName;
     GeneralCollizionForm.FBNameTab := arMetaNameTab[i].sFBName;
     GeneralCollizionForm.sFBPrimeKey := arMetaNameTab[i].sFBPrimeKey;

     // ���� �������� �� ����, ���� �� ����������
     if Length(arCollision) <> 0 then GeneralCollizionForm.ShowModal;

     //�������� ������� �� ������ ������������.
     //���� �� ������� "���������� ���"
     if SkipAll = false then
      begin
       //��������� ������� �� ���������� ������
       for j := 0 to Length(arCollision)-1 do
        begin
         //��������� ������
         case arCollision[j].iDirect of
          0:begin
            //������� ����
            QueryForSQLite.Add(arCollision[j].sSetFlagQuery);
            QueryForSQLite.Add(arCollision[j].sQueryText);
            iCountRec := iCountRec + 1;
            end;
          1:begin
            //������� ����
            QueryForSQLite.Add(arCollision[j].sSetFlagQuery);
            //��������� ������
            QueryForFB.Add(arCollision[j].sQueryText);
            iCountRec := iCountRec + 1;
            end;
          2:begin //��������������� �������������
           //������� ����
            QueryForSQLite.Add(arCollision[j].sSetFlagQuery);
            if arCollision[j].sQueryText <> '' then QueryForSQLite.Add(arCollision[j].sQueryText);
            if arCollision[j].sDopQueryText <> '' then QueryForFB.Add(arCollision[j].sDopQueryText);
            iCountRec := iCountRec + 1;
            end;
         end;
        end;
      end;

     //������������� � ����������� SQLite->FB ����� �������
     //�������� ������ � ������ "�����"
     sQuery := 'SELECT ' + sListFieldsSQLite + ', is_new FROM ' + arMetaNameTab[i].sSQLName + ' WHERE is_new = 2';
     Table := TSQLiteTable.Create(db, sQuery);
     while not (Table.EOF) do
      begin
       //���������� ����.
       sQuery := 'UPDATE ' + arMetaNameTab[i].sSQLName + ' SET is_new = 0, FBID = '
            + #39 + Table.FieldAsString(Table.FieldIndex[arMetaNameTab[i].sSQLPrimeKey]) + #39
            +  ' WHERE ' + arMetaNameTab[i].sSQLPrimeKey + ' = ' + #39 +
            Table.FieldAsString(Table.FieldIndex[arMetaNameTab[i].sSQLPrimeKey]) + #39;
       QueryForSQLite.Add(sQuery);
       //���������� ������
       sQuery := 'INSERT INTO ' + ArMetaNameTab[i].sFBName + ' (' + sListFieldsFB + ') ';
       sValQuery := GenStringQuery.GenValString(Table);
       sQuery := sQuery + sValQuery;

       QueryForFB.Add(sQuery);
       iCountRec := iCountRec + 1;
       Table.Next;
      end;

     Table.free;

     //��������� ��������
     ProtocolSynchGrid.Cells[0, iCountRowReport] := arMetaNameTab[i].sMetaName;
     arFlag[i].iStatus := 1;
     arFlag[i].bInReport := true;
     ProtocolSynchGrid.Cells[2, iCountRowReport] := IntToStr(iCountRec);
     iCountRec := iCountRec + 1;
     iCountRowReport := iCountRowReport + 1;
     iRowReport := i;
     ProtocolSynchGrid.Repaint;
     //������� ���������� ������������������ ������/���������� ������
     MainForm.Repaint;
     Application.ProcessMessages;

    //��������� ���� ������������� ������
    sQuery := 'UPDATE MetaNameTab SET LastDate=' + #39 + DateToStr(Now) +#39 +
      ' WHERE ID = ' + #39 + IntToStr(arMetaNameTab[i].iMetaID) + #39;
    TabMetaName := TSQLiteTable.Create(dbSetting, sQuery);
    //��������� ���� � ������ ������
    TableSynchChListBox.Items.Strings[i] := arMetaNameTab[i].sMetaName + ' (' + DateToStr(Now) +')';
    TabMetaName.Free;
  end;

  //��������� ���������� ��������
  iTotalCount := QueryForSQLite.Count + QueryForFB.Count;
  iProcessingCount := 0;


  for j := 0 to QueryForSQLite.Count -1 do
     begin
      if QueryForSQLite.Strings[j] ='' then continue;
      db.ExecSQL(QueryForSQLite.Strings[j]);
      iProcessingCount := iProcessingCount + 1;
      ProgressBar1.Position := (iProcessingCount div iTotalCount)*100;
      PercentLabel.Caption := IntToStr(ProgressBar1.Position) + '%';
      MainForm.Refresh;
      MainForm.Repaint;
      Application.ProcessMessages;
     end;

 for j := 0 to QueryForFB.Count -1 do
  begin
   if QueryForFB.Strings[j] = '' then continue;

   with IBQuery1 do
      begin
       close;
       SQL.Clear;
       SQL.Add(QueryForFB.Strings[j]);
       open;
       iProcessingCount := iProcessingCount + 1;
       ProgressBar1.Position := (iProcessingCount div iTotalCount)*100;
       PercentLabel.Caption := IntToStr(ProgressBar1.Position) + '%';
       MainForm.Refresh;
       MainForm.Repaint;
       Application.ProcessMessages;
      end;
     IBTransaction1.Commit;
 end;

 except
  on E: Exception do
   begin
    Application.MessageBox(PChar(E.Message), '������', MB_ICONERROR);
    ProtocolConnectMemo.Lines.Add('������: ' + PChar(E.Message));
   end;
 end;

 ProtocolConnectMemo.Lines.Add(sresFinishSynch);
 Screen.Cursor := crDefault;
end;

//����������� ������������ ������������� (���������� �� ������ ������ ��� �������������)
procedure TMainForm.TableSynchChListBoxClickCheck(Sender: TObject);
var
 i: integer;
 flag: boolean; //����. ���� true - ���� ���.��� �������������
begin
 flag := false;
 For i := 0 to TableSynchChListBox.Items.Count-1 do
  begin
   flag := TableSynchChListBox.Checked[i];
   if flag then break;                     //���� ���� ������� ���� ���� "�������"
                                           //��������� ���������, � �������
  end;
 SynchButton.Enabled := flag;             //����������� ������ ���������
end;

//�������� ��� ������ ���������
procedure TMainForm.FormCreate(Sender: TObject);
var
 db: TSQLiteDatabase;
 Table: TSQLiteTable;
 sPath: string;                     //���� � ����
 sQuery: string;                    //������
 sTableName: string;                //��������� ���������� ��� ��������������\
 i: integer;
begin
  //������ ����� ����-������
  GetDiscs;
  //��������� ����� �������
  ProtocolSynchGrid.Cells[0,0] := '�������';
  ProtocolSynchGrid.Cells[2,0] := '���-�� �������';

  //������������ � �� � ������� ������ ������
  GetDir(0, sPath);
  sPath := sPath + '\SynchDB.db';
  try
  db := TSQLiteDatabase.Create(sPath);

  sQuery := 'SELECT * FROM MetaNameTab';
  Table := TSQLiteTable.Create(db, sQuery);

  i:= 1;
  TableSynchChListBox.Items.Clear;
  while  not (Table.EOF) do
   begin
     sTableName := Table.FieldAsString(Table.FieldIndex['MetaNameTable']);

     SetLength(arMetaNameTab, i);
     arMetaNameTab[i-1].sMetaName := sTableName;
     arMetaNameTab[i-1].iMetaID := Table.FieldAsInteger(Table.FieldIndex['ID']);
     arMetaNameTab[i-1].sFBName := Table.FieldAsString(Table.FieldIndex['FBNameTab']);
     arMetaNameTab[i-1].sSQLName := Table.FieldAsString(Table.FieldIndex['SQLNameTab']);
     arMetaNameTab[i-1].sFBPrimeKey := Table.FieldAsString(Table.FieldIndex['FBPrimeKey']);
     arMetaNameTab[i-1].sSQLPrimeKey := Table.FieldAsString(Table.FieldIndex['SQLPrimeKey']);
     arMetaNameTab[i-1].idirection := Table.FieldAsInteger(Table.FieldIndex['Direction']);
     i:= i+1;

     sTableName := sTableName + ' (' + Table.FieldAsString(Table.FieldIndex['LastDate']) + ')';
     TableSynchChListBox.Items.Add(sTableName);

     Table.Next;
   end;
  except
   on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(sresError), MB_ICONERROR);
      ProtocolConnectMemo.Lines.Add(PChar(sresError) + ':' + PChar(E.Message));
    end;
  end;
  //�������� ������ �������
  TableSynchChListBox.Checked[0] := true;
  table.Free;
  db.Free;

  //����������� ���������� ���������
  sresStartSynch  := sresStartSynchRU;
  sresDChangeUSB := sresDChangeUSBRU;
  sresSettingAbsent := sresSettingAbsentRU;
  sresNoArgLlocalSQLite := sresNoArgLlocalSQLiteRU;
  sresNoPathSQLite := sresNoPathSQLiteRU;
  sresNoArgLocalFireBird := sresNoArgLocalFireBirdRU;
  sresNoPathFireBird := sresNoPathFireBirdRU;
  sresSettingSuuccess := sresSettingSuuccessRU;
  sresError := sresErrorRU;
  sresErrorConSQLite := sresErrorConSQLiteRU;
  sresConnectSQLite := sresConnectSQLiteRU;
  sresSuccess := sresSuccessRU;
  sresErrorConFireBird := sresErrorConFireBirdRU;
  sresConnectFireBird := sresConnectFireBirdRU;
  sresTakingListField := sresTakingListFieldRU;
  sresBeginSynch := sresBeginSynchRU;
  sresFinishSynch := sresFinishSynchRU;
  sresTable := sresTableRU;
  sresRecordCount := sresRecordCountRU;

end;

{--------------------------------------------------------------
----------������ �� �������� ����-������----------------------
----------------------------------------------------------------}

//��������� ������ ����-������
procedure TMainForm.GetDiscs;
var
 i: Char;
begin
 for i:= 'A' to 'Z' do
  begin
   if (GetDriveType(PChar(i+':\')) = 2 ) then USBDriveComboBox.Items.Add(i);
  end;
end;


//�������������� ���������� ������ ����-������
procedure TMainForm.UpDateUSBButtonClick(Sender: TObject);
begin
 USBDriveComboBox.Items.Clear;
 GetDiscs;
end;

{--------------------------------------------------------------
----------������ � ���������� ������ � ������--------------------
----------------------------------------------------------------}
procedure TMainForm.ProtocolSynchGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (aRow<>0) and (aCol=1) then
   begin
    if ProtocolSynchGrid.Cells[0, aRow] <> '' then
      begin
       //���� ������� ������������������
       if arFlag[iRowReport].bInReport=true then
        begin
         ProtocolSynchGrid.ColWidths[1] := DoneImage.Picture.Width;
         ProtocolSynchGrid.RowHeights[aRow] := DoneImage.Picture.Height;
           //������� �������� ��� ���������
           if arFlag[iRowReport].iStatus = 1
            then ProtocolSynchGrid.Canvas.StretchDraw(Rect, DoneImage.Picture.Graphic)
            else ProtocolSynchGrid.Canvas.StretchDraw(Rect, ErrorImage.Picture.Graphic);
        end;
      end;
    end;
end;

{---------------------------------------------------------------
----------������ � ������������� ����� -------------------------
----------------------------------------------------------------}
//�������
procedure TMainForm.N7Click(Sender: TObject);
begin
 N7.Checked := true;
 N8.Checked := false;
 N14.Checked := false;

  //��������� ���������� ����������� �������� ����
  MainForm.Caption := sresSynchDBRU;
  n1.Caption := sresFileRU;
  n2.Caption := sresExitRU;
  n4.Caption := sresSettingRU;
  n5.Caption := sresPassRU;
  n6.Caption := sresLangRU;
  n7.Caption := sresRusRU;
  n8.Caption := sresEngRU;
  n3.Caption := sresHelpRU;
  n9.Caption := sresRefRU;
  n11.Caption := sresAboutProgRU;
  n12.Caption := sresSaveLogRU;
  n14.Caption := sresDeuRU;
  NoOneChekedButton.Caption := sresNothingRU;
  AllChekedButton.Caption := sresAllRU;
  SynchButton.Caption := sresSynchronizationRU;
  Label1.Caption := sresSynchProtocolRU;
  Label2.Caption :=  sresConProtocolRU;
  ProtocolSynchGrid.Cells[0,0] := sresTableRU;
  ProtocolSynchGrid.Cells[2,0] := sresRecordCountRU;
  Label3.Caption := sresProgressRU;
  //��������� ���������� ����������� ���� �������
  ChangePassForm.Caption := sresChangePassRU;
  ChangePassForm.Label1.Caption := sresUserNameRU;
  ChangePassForm.Label2.Caption := sresOldPassRU;
  ChangePassForm.Label3.Caption := sresNewPassRU;
  ChangePassForm.Label4.Caption := sresRepNewPassRU;
  ChangePassForm.Okbutton.Caption := sresOkRU;
  ChangePassForm.CancelButton.Caption := sresCancelRU;
  //��������� ���������� ����������� ���� ��������
  CollisionForm.Caption := sresSolConflictRU;
  CollisionForm.Label1.Caption := sresConflictRU;
  CollisionForm.RadioGroup1.Caption := sresCopyAllRU;
  CollisionForm.CancelButton.Caption := sresCancelRU;
  CollisionForm.OkButton.Caption := sresOkRU;
  //��������� ��������� ����������� ���� ����� ��������
  GeneralCollizionForm.SkipAllButton.Caption := sresSkipAllRU;
  GeneralCollizionForm.RadioGroup1.Caption:= sresCopyAllRU;
  GeneralCollizionForm.Label1.Caption := sresConflictRU;
  GeneralCollizionForm.Caption := sresSolConflictRU;
  GeneralCollizionForm.OkButton.Caption := sresOkRU;
  //�������
  AboutForm.Caption := sresHelpRU;
  HelpForm.Caption := sresRefRU;

  //����������� ���������� ���������
  sresStartSynch  := sresStartSynchRU;
  sresDChangeUSB := sresDChangeUSBRU;
  sresSettingAbsent := sresSettingAbsentRU;
  sresNoArgLlocalSQLite := sresNoArgLlocalSQLiteRU;
  sresNoPathSQLite := sresNoPathSQLiteRU;
  sresNoArgLocalFireBird := sresNoArgLocalFireBirdRU;
  sresNoPathFireBird := sresNoPathFireBirdRU;
  sresSettingSuuccess := sresSettingSuuccessRU;
  sresError := sresErrorRU;
  sresErrorConSQLite := sresErrorConSQLiteRU;
  sresConnectSQLite := sresConnectSQLiteRU;
  sresSuccess := sresSuccessRU;
  sresErrorConFireBird := sresErrorConFireBirdRU;
  sresConnectFireBird := sresConnectFireBirdRU;
  sresTakingListField := sresTakingListFieldRU;
  sresBeginSynch := sresBeginSynchRU;
  sresFinishSynch := sresFinishSynchRU;
  sresTable := sresTableRU;
  sresRecordCount := sresRecordCountRU;
  with ChangePassForm do
   begin
   sresNoEqualPass := sresNoEqualPassRU;
   sresNoSuchPassUser := sresNoSuchPassUserRU;
   sresNoSuchUserName := sresNoSuchUserNameRU;
   sresNoSuchTabPass := sresNoSuchTabPassRU;
   end;


end;

//����������
procedure TMainForm.N8Click(Sender: TObject);
begin
  //��������� ���������
  N7.Checked := false;
  N8.Checked := true;
  N14.Checked := false;

  //��������� ���������� ����������� �������� ����
  MainForm.Caption := sresSynchDBENG;
  n1.Caption := sresFileENG;
  n2.Caption := sresExitENG;
  n4.Caption := sresSettingENG;
  n5.Caption := sresPassENG;
  n6.Caption := sresLangENG;
  n7.Caption := sresRusENG;
  n8.Caption := sresEngENG;
  n3.Caption := sresHelpENG;
  n9.Caption := sresRefENG;
  n11.Caption := sresAboutProgENG;
  n12.Caption := sresSaveLogENG;
  n14.Caption := sresDeENG;
  NoOneChekedButton.Caption := sresNothingENG;
  AllChekedButton.Caption := sresAllENG;
  SynchButton.Caption := sresSynchronizationENG;
  Label1.Caption := sresSynchProtocolENG;
  Label2.Caption :=  sresConProtocolENG;
  ProtocolSynchGrid.Cells[0,0] := sresTableENG;
  ProtocolSynchGrid.Cells[2,0] := sresRecordCountENG;
  Label3.Caption := sresProgressENG;
  //��������� ���������� ����������� ���� �������
  ChangePassForm.Caption := sresChangePassENG;
  ChangePassForm.Label1.Caption := sresUserNameENG;
  ChangePassForm.Label2.Caption := sresOldPassENG;
  ChangePassForm.Label3.Caption := sresNewPassENG;
  ChangePassForm.Label4.Caption := sresRepNewPassENG;
  ChangePassForm.Okbutton.Caption := sresOkENG;
  ChangePassForm.CancelButton.Caption := sresCancelENG;
  //��������� ���������� ����������� ���� ��������
  CollisionForm.Caption := sresSolConflictENG;
  CollisionForm.Label1.Caption := sresConflictENG;
  CollisionForm.RadioGroup1.Caption := sresCopyAllENG;
  CollisionForm.CancelButton.Caption := sresCancelENG;
  CollisionForm.OkButton.Caption := sresOkENG;
  //��������� ��������� ����������� ���� ����� ��������
  GeneralCollizionForm.SkipAllButton.Caption := sresSkipAllENG;
  GeneralCollizionForm.RadioGroup1.Caption:= sresCopyAllENG;
  GeneralCollizionForm.Label1.Caption := sresConflictENG;
  GeneralCollizionForm.Caption := sresSolConflictENG;
  GeneralCollizionForm.OkButton.Caption := sresOkENG;
  //�������
  AboutForm.Caption := sresHelpENG;
  HelpForm.Caption := sresRefENG;
  //����������� ���������� ���������
  sresStartSynch  := sresStartSynchENG;
  sresDChangeUSB := sresDChangeUSBENG;
  sresSettingAbsent := sresSettingAbsentENG;
  sresNoArgLlocalSQLite := sresNoArgLlocalSQLiteENG;
  sresNoPathSQLite := sresNoPathSQLiteENG;
  sresNoArgLocalFireBird := sresNoArgLocalFireBirdENG;
  sresNoPathFireBird := sresNoPathFireBirdENG;
  sresSettingSuuccess := sresSettingSuuccessENG;
  sresError := sresErrorENG;
  sresErrorConSQLite := sresErrorConSQLiteENG;
  sresConnectSQLite := sresConnectSQLiteENG;
  sresSuccess := sresSuccesseENG;
  sresErrorConFireBird := sresErrorConFireBirdENG;
  sresConnectFireBird := sresConnectFireBirdENG;
  sresTakingListField := sresTakingListFieldENG;
  sresBeginSynch := sresBeginSynchENG;
  sresFinishSynch := sresFinishSynchENG;
  sresTable := sresTableENG;
  sresRecordCount := sresRecordCountENG;
  with ChangePassForm do
   begin
    sresNoEqualPass := sresNoEqualPassENG;
    sresNoSuchPassUser := sresNoSuchPassUserENG;
    sresNoSuchUserName := sresNoSuchUserNameENG;
    sresNoSuchTabPass := sresNoSuchTabPassENG;
   end;

end;

//��������
procedure TMainForm.N14Click(Sender: TObject);
begin
 N7.Checked := false;
 N8.Checked := false;
 N14.Checked := true;

  //��������� ���������� ����������� �������� ����
  MainForm.Caption := sresSynchDBDE;
  n1.Caption := sresFileDE;
  n2.Caption := sresExitDE;
  n4.Caption := sresSettingDE;
  n5.Caption := sresPassDE;
  n6.Caption := sresLangDE;
  n7.Caption := sresRusDE;
  n8.Caption := sresEngDE;
  n3.Caption := sresHelpDE;
  n9.Caption := sresRefDE;
  n11.Caption := sresAboutProgDE;
  n12.Caption := sresSaveLogDE;
  n14.Caption := sresDeDE;
  NoOneChekedButton.Caption := sresNothingDE;
  AllChekedButton.Caption := sresAllDE;
  SynchButton.Caption := sresSynchronizationDE;
  Label1.Caption := sresSynchProtocolDE;
  Label2.Caption :=  sresConProtocolDE;
  ProtocolSynchGrid.Cells[0,0] := sresTableDE;
  ProtocolSynchGrid.Cells[2,0] := sresRecordCountDE;
  Label3.Caption := sresProgressDE;
  //��������� ���������� ����������� ���� �������
  ChangePassForm.Caption := sresChangePassDE;
  ChangePassForm.Label1.Caption := sresUserNameDE;
  ChangePassForm.Label2.Caption := sresOldPassDE;
  ChangePassForm.Label3.Caption := sresNewPassDE;
  ChangePassForm.Label4.Caption := sresRepNewPassDE;
  ChangePassForm.Okbutton.Caption := sresOkDE;
  ChangePassForm.CancelButton.Caption := sresCancelDE;
  //��������� ���������� ����������� ���� ��������
  CollisionForm.Caption := sresSolConflictDE;
  CollisionForm.Label1.Caption := sresConflictDE;
  CollisionForm.RadioGroup1.Caption := sresCopyAllDE;
  CollisionForm.CancelButton.Caption := sresCancelDE;
  CollisionForm.OkButton.Caption := sresOkDE;
  //��������� ��������� ����������� ���� ����� ��������
  GeneralCollizionForm.SkipAllButton.Caption := sresSkipAllDE;
  GeneralCollizionForm.RadioGroup1.Caption:= sresCopyAllDE;
  GeneralCollizionForm.Label1.Caption := sresConflictDE;
  GeneralCollizionForm.Caption := sresSolConflictDE;
  GeneralCollizionForm.OkButton.Caption := sresOkDE;
  //�������
  AboutForm.Caption := sresHelpDE;
  HelpForm.Caption := sresRefDE;

  //����������� ���������� ���������
  sresStartSynch  := sresStartSynchDE;
  sresDChangeUSB := sresDChangeUSBDE;
  sresSettingAbsent := sresSettingAbsentDE;
  sresNoArgLlocalSQLite := sresNoArgLlocalSQLiteDE;
  sresNoPathSQLite := sresNoPathSQLiteDE;
  sresNoArgLocalFireBird := sresNoArgLocalFireBirdDE;
  sresNoPathFireBird := sresNoPathFireBirdDE;
  sresSettingSuuccess := sresSettingSuuccessDE;
  sresError := sresErrorDE;
  sresErrorConSQLite := sresErrorConSQLiteDE;
  sresConnectSQLite := sresConnectSQLiteDE;
  sresSuccess := sresSuccesseDE;
  sresErrorConFireBird := sresErrorConFireBirdDE;
  sresConnectFireBird := sresConnectFireBirdDE;
  sresTakingListField := sresTakingListFieldDE;
  sresBeginSynch := sresBeginSynchDE;
  sresFinishSynch := sresFinishSynchDE;
  sresTable := sresTableDE;
  sresRecordCount := sresRecordCountDE;
  with ChangePassForm do
   begin
    sresNoEqualPass := sresNoEqualPassDE;
    sresNoSuchPassUser := sresNoSuchPassUserDE;
    sresNoSuchUserName := sresNoSuchUserNameDE;
    sresNoSuchTabPass := sresNoSuchTabPassDE;
   end;
end;


procedure TMainForm.N2Click(Sender: TObject);
begin
Mainform.Close;
end;

end.
