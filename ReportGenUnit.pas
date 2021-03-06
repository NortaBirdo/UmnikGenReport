unit ReportGenUnit;

interface

uses  System.Classes;

 type
  TReportGen = class (TObject)
  arFileList: TStringList;
  constructor TReportGen;
  function CopyRange(WordDoc: OleVariant; sFrom, sTo, sPastPoint:string): smallint;
 end;

implementation

{ TReportGen }

//��������� ����������� ����� ������ �� ������ � ������ ��������
function TReportGen.CopyRange(WordDoc: OleVariant; sFrom, sTo, sPastPoint:string): smallint;
Var
 FStart, FEnd, FPastPoint, a, b: OleVariant;
 i,DocLen:longint;
Begin
  FStart:=0;
  FEnd:=0;
  WordDoc.Documents.Item(2).Activate;
  DocLen:=Length(WordDoc.Documents.Item(2).Range.Text);

  For i:=0 to DocLen-2 do
   begin
    a:=i;
    b:=i+2;
    if (WordDoc.Documents.Item(2).Range(a,b).Text=sFrom) then FStart:=i+2
    else if (WordDoc.Documents.Item(2).Range(a,b).Text=sTo) then FEnd:=i;
    end;
  if (FStart=0) or (FEnd=0) then
   begin
    result := -1; //������ - �� ������� ������� �����������
    exit;
   end
   else
    begin
     WordDoc.Documents.Item(2).Range(FStart, FEnd).Select;
     WordDoc.Selection.Copy;
    end;

   FStart:=0;
   FEnd:=0;
   DocLen:=Length(WordDoc.Documents.Item(1).Range.Text);
  For i:=0 to DocLen-2 do
   begin
    a:=i;
    b:=i+2;
   if (WordDoc.Documents.Item(1).Range(a,b).Text=sPastPoint) then FPastPoint:=i;
   end;

  if FPastPoint=0 then result := -2 //������, �� ������� ����� �������
   else
   begin
    WordDoc.Documents.Item(1).Range(FPastPoint, FPastPoint + 10).Select;
    WordDoc.Selection.Paste;
    Result:=0;
   end;
 End;

constructor TReportGen.TReportGen;
begin
 arFileList := TStringList.Create;
end;

end.
