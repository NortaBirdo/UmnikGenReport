{unit CollisionUnit;
������: 2.0 �� 21.03
�����������: ����������� �������
Sokolovskynik@gmail.com

�����������: SysUtils, DateUtils
���� ��������� ������� ��������� ��������, �������-������� ��� �������������� ������}

unit SynchUnit;

interface

uses System.SysUtils, DateUtils, IBQuery, SQLite3, SQLiteWrap, Vcl.Grids;

type
 TGenStringQuery = class(TObject)
  type
   TMetaNameField=record
    sFBField, sSQLField, sDataType: string;
    sMetaName:string;
  end;
  var
  arMetaNameField: array of TMetaNameField;
  high: integer;

  //���������� ������ ����� � ���� ������. t (0) - FB, t(1) - SQLite
  function GenFieldString(t:integer):string;
  //���������� ������ ��������
  function GenValString(IBQuery: TIBQuery; sPrimeKey: string):string; overload;
  function GenValString(Table: TSQLiteTable):string; overload;
  function GenValString(StrGrid: TStringGrid; i:integer; isFB:boolean):string; overload;
 end;

//������� - ���������������
function ChangeQuotes (sString: WideString):WideString;
function UnixToDTStr (iUnixTime: integer): string;
function DTToUnixStr (dt: TDateTime):string;


implementation

function ChangeQuotes (sString: WideString):WideString;
begin
 result := StringReplace(sString, #39, #39+#39, [rfReplaceAll]);
end;

function UnixToDTStr (iUnixTime: integer): string;
begin
  result := DateTimeToStr(UnixToDateTime(iUnixTime));
end;

function DTToUnixStr (dt: TDateTime):string;
begin
  result := IntToStr(DateTimeToUnix(dt));
end;

{������ SYNCHOBJ}
function TGenStringQuery.GenFieldString(t:integer):string;
var
 i: integer;
begin
 result := '';
 for I := 0 to Length(arMetaNameField) - 1 do
   case t of
    0: if i <> 0 then result := result + ', ' + arMetaNameField[i].sFBField
                 else result := result + arMetaNameField[i].sFBField;
    1: if i <> 0 then result := result + ', ' +arMetaNameField[i].sSQLField
                 else result := result + arMetaNameField[i].sSQLField;
   end;
end;

function TGenStringQuery.GenValString(IBQuery: TIBQuery; sPrimeKey: string): string;
var
 j: integer;
 sValQuery: string;
begin
if high<=0 then begin
                 result := '';
                 exit;
                end;
for j := 0 to high do
  begin
   if arMetaNameField[j].sDataType = 'dat'
     then sValQuery := sValQuery + DTToUnixStr(IBQuery.FieldByName(arMetaNameField[j].sFBField).AsDateTime)
     else sValQuery := sValQuery + ChangeQuotes(IBQuery.FieldByName(arMetaNameField[j].sFBField).AsWideString);
   if j <> high  then sValQuery := sValQuery + #39+', ' + #39
                 else sValQuery := sValQuery + #39 + ', ' + #39 + IBQuery.FieldByName(sPrimeKey).AsString +#39 +') ';
  end;
result := ' VALUES ('+ #39 + sValQuery;

end;

function TGenStringQuery.GenValString(Table: TSQLiteTable): string;
var
 j: integer;
 sValQuery: string;
begin
 for j := 0 to high do
          begin

          //��������� � ������ ������
          //���� ������ ��� - ����� null
          //� ������������ � �����
          if arMetaNameField[j].sDataType = 'str'  then
            begin
            if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
              sValQuery := sValQuery + 'null'
              else sValQuery := sValQuery + #39 +
               ChangeQuotes(Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField])) + #39;
            end;
          //��������� �����
          if arMetaNameField[j].sDataType = 'txt'  then
            begin
            if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
              sValQuery := sValQuery + 'null'
              else sValQuery := sValQuery + #39 +
               ChangeQuotes(Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField])) + #39;
            end;
          //����� �����
          if arMetaNameField[j].sDataType = 'int' then
            begin
            if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
              sValQuery := sValQuery + 'null'
              else sValQuery := sValQuery +
             Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]);
            end;
           //������� ����� (������� �������)
          if arMetaNameField[j].sDataType = 'flt' then
             begin
              if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
               sValQuery := sValQuery + 'null'
               else begin
                sValQuery := sValQuery  + StringReplace(
                 table.FieldAsString(table.FieldIndex[arMetaNameField[j].sSQLField]),
                 ',','.',[rfReplaceAll]);
               end;
              end;
          //����
          if arMetaNameField[j].sDataType = 'dat' then
            begin
            if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
               sValQuery := sValQuery + 'null'
               else
               sValQuery := sValQuery + #39 +
                UnixToDTStr(Table.FieldAsInteger(Table.FieldIndex[arMetaNameField[j].sSQLField])) + #39;
            end;
          //���������� ���
          if arMetaNameField[j].sDataType = 'boo' then
            begin
            if Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]) = '' then
               sValQuery := sValQuery + 'null'
               else sValQuery := sValQuery +
              Table.FieldAsString(Table.FieldIndex[arMetaNameField[j].sSQLField]);
            end;

         if j <> high  then  sValQuery := sValQuery + ', '

                        else  sValQuery := sValQuery +') ';

           end;
           result := ' VALUES (' + sValQuery;
end;

function TGenStringQuery.GenValString(StrGrid: TStringGrid; i:integer; isFB:boolean): string;
var
 sValString: string;
 j: integer;
begin
sValString := '';
 //������� �����
       for j := 0 to Length(arMetaNameField)-1 do
        begin
         sValString :=  sValString + arMetaNameField[j].sSQLField + ' = ';
        //����������� ��� ������, ���� ������������ ����� �� ��� �������
        //������, ��������� �����, ������� �����
        if (arMetaNameField[j].sDataType = 'str')
           or (arMetaNameField[j].sDataType = 'txt')
         then
          begin
            if StrGrid.Cells[j+1, i+1] = ''
               then sValString := sValString + 'null'
               else sValString := sValString + #39 + ChangeQuotes(StrGrid.Cells[j+1, i+1])+#39;
          end;
        if  arMetaNameField[j].sDataType = 'flt' then
         begin
           if StrGrid.Cells[j+1, i+1] = ''
               then sValString := sValString + 'null'
               else
                 if not(isFB) then sValString := sValString + #39 + ChangeQuotes(StrGrid.Cells[j+1, i+1])+#39
                              else sValString := sValString + StringReplace(StrGrid.Cells[j+1, i+1], ',','.',[rfReplaceAll]);
          end;
        //����� �����, �����
        if (arMetaNameField[j].sDataType = 'int')
          or ( arMetaNameField[j].sDataType = 'boo')
          then
         begin
          if StrGrid.Cells[j+1, i+1] = ''
            then sValString := sValString + 'null'
            else sValString := sValString + StrGrid.Cells[j+1, i+1];
         end;
        // ����
        if arMetaNameField[j].sDataType = 'dat' then
          begin
           if StrGrid.Cells[j+1, i+1] = ''
             then sValString := sValString + 'null'
             else
              if not(isFB) then sValString := sValString + #39 + DTToUnixStr(StrToDateTime(StrGrid.Cells[j+1, i+1])) + #39
                           else sValString := sValString + #39 + StrGrid.Cells[j+1, i+1] + #39
          end;

        if j <> (Length(arMetaNameField)-1) then sValString := sValString + ', ';
      end;

result := sValString;
end;


end.
