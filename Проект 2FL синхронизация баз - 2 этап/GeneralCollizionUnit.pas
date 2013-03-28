{unit GeneralCollizionUnit
������: 2.4 �� 21.03
�����������: ����������� �������
Sokolovskynik@gmail.com
�����������: DateUtils
���� ������������� ��������� �������, ��������� �������� �� ��������� ��������
 ��������� ������� � ���������� ������� �� MainForm ����������� ����������� ���
 �������������}
unit GeneralCollizionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
  DateUtils;

type
  TGeneralCollizionForm = class(TForm)
    OkButton: TButton;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    SkipAllButton: TButton;
    SQLStringGrid: TStringGrid;
    FBStringGrid: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    MataNameTabLabel: TLabel;
    procedure SQLStringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FBStringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SQLStringGridDblClick(Sender: TObject);
    procedure FBStringGridDblClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SkipAllButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure LoadCollision;
    procedure SQLStringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FBStringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SQLStringGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FBStringGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    SQLNameTab, FBNameTab: string;
    sFBPrimeKey: string;
    k: integer;
  end;

var
  GeneralCollizionForm: TGeneralCollizionForm;
  C, R: Integer;
  //������ ������ ����������� ������������� ��� ��������

implementation

{$R *.dfm}

uses CollisionUnit, MainUnit, SynchUnit;

//�������� ������� ������ ������������ �����
procedure TGeneralCollizionForm.FBStringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
if AROW <> 0 then
  begin
   if SQLStringGrid.Cells[aCol, aRow] <> FBStringGrid.Cells[aCol, aRow] then
    begin
    FBStringGrid.Canvas.Font.Style:=[fsBold];
    FBStringGrid.Canvas.Font.Color := clRed;
    FBStringGrid.Canvas.FillRect(rect);
        FBStringGrid.Canvas.TextOut(rect.left+2, rect.top+2,
      FBStringGrid.cells[acol, arow]);
    end;
  end;
end;

procedure TGeneralCollizionForm.FBStringGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ACol, ARow: Integer;
begin
with FBStringGrid do
 try
  MouseToCell(X, Y, ACol, ARow);
  if (ACol<0) or (ARow<0) then exit;

  if ((ACol<>C) or (ARow<>R)) then
    begin
      C:=ACol; R:=ARow;
      Application.CancelHint;
      Hint:= SQLStringGrid.Cells[ACol, ARow];
    end;
except
end;
end;

procedure TGeneralCollizionForm.SQLStringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if AROW <> 0 then
  begin
   if SQLStringGrid.Cells[aCol, aRow] <> FBStringGrid.Cells[aCol, aRow] then
    begin
    SQLStringGrid.Canvas.Font.Style:=[fsBold];
    SQLStringGrid.Canvas.Font.Color := clRed;
    SQLStringGrid.Canvas.FillRect(rect);
        SQLStringGrid.Canvas.TextOut(rect.left+2, rect.top+2,
      SQLStringGrid.cells[acol, arow]);
    end;
  end;
end;

procedure TGeneralCollizionForm.SQLStringGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ACol, ARow: Integer;
begin
with SQLStringGrid do
try
  MouseToCell(X, Y, ACol, ARow);
  if (ACol<0) or (ARow<0) then exit;

  if ((ACol<>C) or (ARow<>R)) then
    begin
      C:=ACol; R:=ARow;
      Application.CancelHint;
      Hint:= SQLStringGrid.Cells[ACol, ARow];
    end;
except
end;
end;

//������������ ����������� ����
procedure TGeneralCollizionForm.SQLStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 k := aRow;
end;

procedure TGeneralCollizionForm.FBStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 k := aRow;
end;

//������� � ��������� �� �����
procedure TGeneralCollizionForm.LoadCollision;
var
 i, high: integer;
begin
 with CollisionForm.CompairStringGrid do
  begin
    High := Length(MainForm.GenStringQuery.arMetaNameField);
    RowCount := High + 1;
    SetLength(CollisionForm.arDirect, High);
    for I := 0 to High - 1 do
     begin
      Cells[0, i+1] := MainForm.GenStringQuery.arMetaNameField[i].sMetaName;
      Cells[1, i+1] := FBStringGrid.Cells[i+1, k];
      Cells[3, i+1] := SQLStringGrid.Cells[i+1, k];
      if Cells[1, i+1] <> Cells[3, i+1] then CollisionForm.arDirect[i] := 0
                                        else CollisionForm.arDirect[i] := 3;
     end;
  end;
end;

procedure TGeneralCollizionForm.SQLStringGridDblClick(Sender: TObject);
var
i: integer;
begin
  LoadCollision;
  CollisionForm.ShowModal;
  //��������� ��� ����������� ����� � ���� ������������
  //��������� ������
  MainForm.arCollision[k-1].iDirect := 2;
  MainForm.arCollision[k-1].sSetFlagQuery := 'UPDATE ' + SQLNameTab +
         ' SET is_new = 0 WHERE FBID = ' + #39 + SQLStringGrid.Cells[0, k] + #39;
  if CollisionForm.sSQLQuery <> ' SET ' then
   begin
   MainForm.arCollision[k-1].sQueryText := 'UPDATE ' + SQLNameTab + CollisionForm.sSQLQuery;
   //������� ������ �������
   MainForm.arCollision[k-1].sQueryText :=
    copy(MainForm.arCollision[k-1].sQueryText, 0,
     Length(MainForm.arCollision[k-1].sQueryText)-2);
   //��������� �������
   MainForm.arCollision[k-1].sQueryText := MainForm.arCollision[k-1].sQueryText +
    ' WHERE FBID = ' + #39 + SQLStringGrid.Cells[0, k]+ #39;
   end;
  if CollisionForm.sFBQuery <> ' SET ' then
   begin
   MainForm.arCollision[k-1].sDopQueryText := 'UPDATE ' + FBNameTab + CollisionForm.sFBQuery;
      MainForm.arCollision[k-1].sDopQueryText :=
    copy(MainForm.arCollision[k-1].sDopQueryText, 0,
     Length(MainForm.arCollision[k-1].sDopQueryText)-2);
   MainForm.arCollision[k-1].sDopQueryText := MainForm.arCollision[k-1].sDopQueryText +
    ' WHERE ' + sFBPrimeKey +' = ' + #39 + SQLStringGrid.Cells[0, k] + #39;
   end;
end;

procedure TGeneralCollizionForm.FBStringGridDblClick(Sender: TObject);
begin
  LoadCollision;
  CollisionForm.ShowModal;
  //��������� ������, ��������� ����������� � ����
  MainForm.arCollision[k-1].iDirect := 2;
  MainForm.arCollision[k-1].sSetFlagQuery := 'UPDATE ' + SQLNameTab +
         ' SET is_new = 0 WHERE FBID = ' + #39 + SQLStringGrid.Cells[0, k] + #39;
  if CollisionForm.sSQLQuery <> ' SET ' then
   begin
   MainForm.arCollision[k-1].sQueryText := 'UPDATE ' + SQLNameTab + CollisionForm.sSQLQuery;
   //������� ������ �������
   MainForm.arCollision[k-1].sQueryText :=
    copy(MainForm.arCollision[k-1].sQueryText, 0,
     Length(MainForm.arCollision[k-1].sQueryText)-2);
   //��������� �������
   MainForm.arCollision[k-1].sQueryText := MainForm.arCollision[k-1].sQueryText +
    ' WHERE FBID = ' + #39 + SQLStringGrid.Cells[0, k]+ #39;
   end;
  if CollisionForm.sFBQuery <> ' SET ' then
   begin
   MainForm.arCollision[k-1].sDopQueryText := 'UPDATE ' + FBNameTab + CollisionForm.sFBQuery;
      MainForm.arCollision[k-1].sDopQueryText :=
    copy(MainForm.arCollision[k-1].sDopQueryText, 0,
     Length(MainForm.arCollision[k-1].sDopQueryText)-2);
   MainForm.arCollision[k-1].sDopQueryText := MainForm.arCollision[k-1].sDopQueryText +
    ' WHERE '+ sFBPrimeKey +' = ' + #39 + SQLStringGrid.Cells[0, k] + #39;
   end;
end;


//����������� ������ �����������
procedure TGeneralCollizionForm.RadioGroup1Click(Sender: TObject);
var
 i, j: integer;
 sUpdateStrSQL, sUpdateStrFB :string;
begin
with MainForm do
 begin
   sUpdateStrSQL := 'UPDATE ' + SQLNameTab + ' SET ';
   sUpdateStrFB  := 'UPDATE ' + FBNameTab + ' SET ';

   //������� ���� ��������
   for I := 0 to Length(arCollision)-1 do
    begin
     if RadioGroup1.ItemIndex = 0 then
       begin
       //����������� SQlite
       if arCollision[i].iDirect <> 2 then arCollision[i].iDirect := 0
                                      else Continue;
       arCollision[i].sQueryText := sUpdateStrSQL + MainForm.GenStringQuery.GenValString(FBStringGrid, i, false);
       arCollision[i].sQueryText := arCollision[i].sQueryText +
          ' WHERE FBID = ' + #39 + FBStringGrid.Cells[0, i+1] + #39;
       arCollision[i].sSetFlagQuery := sUpdateStrSQL + 'is_new = 0 WHERE FBID = '
          + #39 + SQLStringGrid.Cells[0, i+1] + #39;
       end
       ELSE
       //����������� � FIREBIRD
       BEGIN
       if arCollision[i].iDirect <> 2 then arCollision[i].iDirect := 1
                                      else Continue;
       arCollision[i].sQueryText := sUpdateStrFB + MainForm.GenStringQuery.GenValString(SQLStringGrid, i, true);

       arCollision[i].sQueryText := arCollision[i].sQueryText + ' WHERE ' +
           sFBPrimeKey + ' = ' + #39 +  SQLStringGrid.Cells[0, i+1] + #39;
       arCollision[i].sSetFlagQuery := sUpdateStrFB + 'is_new = 0 WHERE FBID = '
          + #39 + SQLStringGrid.Cells[0, i+1] + #39;
       END;
    end;

 end;

end;

//������� �� ������������ ��������
procedure TGeneralCollizionForm.SkipAllButtonClick(Sender: TObject);
begin
 MainForm.SkipAll := true;
 GeneralCollizionForm.Close;
end;

//�������� ���������
procedure TGeneralCollizionForm.OkButtonClick(Sender: TObject);
begin
 MainForm.SkipAll := false;
 GeneralCollizionForm.Close;
end;

end.
