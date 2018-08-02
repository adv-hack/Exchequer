unit first;

interface

implementation
{uses
  SysUtils, Classes, EPOSProc, Dialogs, MiscUtil;
var
  Companies : TStringList;}

initialization
{  try
    Companies := TStringList.Create;
    FillCompanyList(Companies);
    showmessage(Companies[0]);
  except
    on e:exception do
    begin
      ShowMessage(e.message);
    end;
  end;

  if Assigned(Companies) then
  begin
    ClearList(Companies);
    Companies.Free;
  end;{if}
end.
