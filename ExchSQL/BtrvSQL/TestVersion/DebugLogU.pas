unit DebugLogU;

interface

uses SysUtils, Classes;

procedure Log(Msg: string);

implementation

var
  Msgs: TStringList;

procedure Log(Msg: string);
var
  Line: string;
begin
  Line := FormatDateTime('dd/mm/yyyy hh:nn : ', Now) + Msg;
  Msgs.Add(Line);
  Msgs.SaveToFile('C:\BtrvSQL.log');
end;

initialization

  Msgs := TStringList.Create;

finalization

//  Msgs.SaveToFile('C:\BtrvSQL.log');
  Msgs.Free;

end.
