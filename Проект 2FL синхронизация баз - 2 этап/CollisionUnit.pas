{unit CollisionUnit;
������: 2.3 �� 21.03
�����������: ����������� �������
Sokolovskynik@gmail.com

�����������: MainUnit, DateUtils
���� ������ ���������� ���� � ������ ���������� �������� �� �����}
unit CollisionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.Imaging.pngimage,
  DateUtils;

type
  TCollisionForm = class(TForm)
    Label1: TLabel;
    CompairStringGrid: TStringGrid;
    NextBackImage: TImage;
    OkButton: TButton;
    RadioGroup1: TRadioGroup;
    FBtoSQLImage: TImage;
    SQLtoFBImage: TImage;
    EqImage: TImage;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CompairStringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure OkButtonClick(Sender: TObject);
    procedure SkipButtonClick(Sender: TObject);
    procedure CompairStringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
    iWight, iHeight: integer;
  public
   arDirect: array of integer;     //0 - �� ����������, 1 - FB-SQLite,
   sSQLQuery, sFBQuery: string;    //2 - SQLite - FB, 3 - �����
  end;

var
  CollisionForm: TCollisionForm;

implementation

{$R *.dfm}

uses MainUnit, SynchUnit;

//���������� �������
procedure TCollisionForm.CancelButtonClick(Sender: TObject);
begin
 CollisionForm.Close;
end;

procedure TCollisionForm.CompairStringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);

begin
  if (Acol = 2) and (aRow <> 0) then
   begin
      case arDirect[aRow-1] of
        0: CompairStringGrid.Canvas.StretchDraw(Rect, NextBackImage.Picture.Graphic);
        1: CompairStringGrid.Canvas.StretchDraw(Rect, FBtoSQLImage.Picture.Graphic);
        2: CompairStringGrid.Canvas.StretchDraw(Rect, SQLtoFBImage.Picture.Graphic);
        3: CompairStringGrid.Canvas.StretchDraw(Rect, EqImage.Picture.Graphic);
     end;
   end;
//��������� ������������ �������
if (aCol<>2) and (aRow>0)  then
 begin
 if CompairStringGrid.Cells[1, aRow] <> CompairStringGrid.Cells[3, aRow] then
    begin
    CompairStringGrid.Canvas.Font.Style:=[fsBold];
    CompairStringGrid.Canvas.Font.Color := clRed;
    CompairStringGrid.Canvas.FillRect(rect);
        CompairStringGrid.Canvas.TextOut(rect.left+2, rect.top+2,
      CompairStringGrid.cells[acol, arow]);
    end;
 end;
end;

//����������� ������ ����������� ������������� �������������
procedure TCollisionForm.CompairStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
i: integer;
begin
  if (Acol = 2) and (aRow <> 0) then
   begin
     with Mainform do
      begin
       case arDirect[aRow-1] of
        0: arDirect[aRow-1] := 1;
        1: arDirect[aRow-1] := 2;
        2: arDirect[aRow-1] := 0;
        3: arDirect[aRow-1] := 3;
       end;
      end;
   CompairStringGrid.Repaint;
   end;
for I := 0 to Length(arDirect)-1 do
  if arDirect[i]=0 then begin
                        OkButton.Enabled := false;
                        break;
                        end
                   else OkButton.Enabled := true;
end;

//�������� ��� �������� ����
procedure TCollisionForm.FormCreate(Sender: TObject);
var
 i: integer;
begin
 //��������� ����� �������
 CompairStringGrid.Cells[0,0] := 'Metaname';
 CompairStringGrid.Cells[1,0] := 'FireBird';
 CompairStringGrid.Cells[3,0] := 'SQLite';

 //�������� ������� "�� ����������"
 for I := 1 to CompairStringGrid.RowCount - 1 do
   begin
    iWight := NextBackImage.Picture.Width;
    iHeight := NextBackImage.Picture.Height;
    CompairStringGrid.ColWidths[2] := iWight;
    CompairStringGrid.RowHeights[i] := iHeight;
   end;
  OkButton.Enabled := false;
end;

//������� ������
procedure TCollisionForm.OkButtonClick(Sender: TObject);
var
 i: integer;
begin
 //��������� ��������
 sSQLQuery := ' SET ';
 sFBQuery := ' SET ';
 for i := 0 to CompairStringGrid.RowCount - 1 do
  begin
    //������ FB
    case arDirect[i] of
    2:begin
      sFBQuery := sFBQuery + MainForm.GenStringQuery.arMetaNameField[i].sFBField + ' = ';
     //���� ������
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'str' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + #39 + ChangeQuotes(CompairStringGrid.Cells[3, i+1]) + #39;
          end;
      //���� ��������� ����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'txt' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + #39 +
                ChangeQuotes(CompairStringGrid.Cells[3, i+1]) + #39;
          end;
      //���� �����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'int' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + CompairStringGrid.Cells[3, i+1];
          end;
      //���� ������� �����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'flt' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + StringReplace(CompairStringGrid.Cells[3, i+1],
                    ',','.',[rfReplaceAll]);
          end;
      //���� ����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'dat' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + #39 + CompairStringGrid.Cells[3, i+1] + #39;
          end;
      //���� ������
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'boo' then
          begin
           if CompairStringGrid.Cells[3, i+1] = '' then
               sFBQuery := sFBQuery + 'null'
               else sFBQuery :=
                sFBQuery + CompairStringGrid.Cells[3, i+1];
          end;
      if i <> CompairStringGrid.RowCount - 1 then
         sFBQuery := sFBQuery + ', ';
      end;
     //������ SQLite
     1:Begin
      sSQLQuery := sSQLQuery + MainForm.GenStringQuery.arMetaNameField[i].sSQLField + ' = ';
      //���� ������
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'str' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + #39 +
                ChangeQuotes(CompairStringGrid.Cells[1, i+1]) + #39;
          end;
      //���� ��������� ����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'txt' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + #39 +
                ChangeQuotes(CompairStringGrid.Cells[1, i+1]) + #39;
          end;
      //���� �����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'int' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + CompairStringGrid.Cells[1, i+1];
          end;
      //���� ������� �����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'flt' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + #39 + StringReplace(CompairStringGrid.Cells[1, i+1],
                    ',','.',[rfReplaceAll]) + #39;
          end;
      //���� ����
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'dat' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + #39 +
                 DTToUnixStr(StrToDateTime(CompairStringGrid.Cells[1, i+1])) + #39;
          end;
      //���� ������
      if MainForm.GenStringQuery.arMetaNameField[i].sDataType = 'boo' then
          begin
           if CompairStringGrid.Cells[1, i+1] = '' then
               sSQLQuery := sSQLQuery + 'null'
               else sSQLQuery :=
                sSQLQuery + CompairStringGrid.Cells[1, i+1];
          end;
     if i <> CompairStringGrid.RowCount - 1 then sSQLQuery := sSQLQuery + ', ';
     End;
    end;
  end;
 CollisionForm.Close;
end;

//����� ������������ ����������� ��� ���� �����
procedure TCollisionForm.RadioGroup1Click(Sender: TObject);
var
i: integer;
begin
  if RadioGroup1.ItemIndex=0 then  //���� ������� FB->SQLite
   begin
     for I := 0 to length (arDirect) - 1 do
       if arDirect[i] <> 3 then arDirect[i] := 1;
    end
    else
    begin
      for I := 0 to length (arDirect) - 1 do
       if arDirect[i] <> 3 then arDirect[i] := 2;
    end;
   CompairStringGrid.Repaint;
 for I := 0 to Length(arDirect)-1 do
  if arDirect[i]=0 then begin
                        OkButton.Enabled := false;
                        break;
                        end
                   else OkButton.Enabled := true;
end;

//���������� ��� ������
procedure TCollisionForm.SkipButtonClick(Sender: TObject);
begin
 CollisionForm.Close;
end;

end.
