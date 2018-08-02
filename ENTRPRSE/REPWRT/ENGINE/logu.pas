unit logu;

interface

  procedure LogIt(const s : string);

implementation

uses
  SysUtils;

const
  FName = 'c:\sentvao.log';

  procedure LogIt(const s : string);
  var
    F : TextFile;
  begin
    Assignfile(F, FName);
    if FileExists(FName) then
      Append(F)
    else
      Rewrite(F);
    WriteLn(F, FormatDateTime('hh:nn:ss', Now) + '> ' + s);
    CloseFile(F);
  end;
end.
