unit CatalogUnit;

interface

uses SysUtils;

type
TCatalog = class (Tobject)
 sFolderName: string;
 arFileList: array of string;
 procedure GetFileList;
 end;
implementation

{ TCatalog }

procedure TCatalog.GetFileList;
var
  SearchRec: TSearchRec;
  Mask: string;
  i: integer;
begin
  Mask := '*.doc?';
  sFolderName := sFolderName + '\';
  if FindFirst(sFolderName + Mask, faAnyFile, SearchRec) = 0 then
  begin
    i := 0;
    repeat
     i := i + 1;
     SetLength(arFileList, i);
     arFileList[i-1] := SearchRec.Name;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

end.
