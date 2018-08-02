unit EposComn;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  strUtil, EPOSCnst;

  Function GetEXEDir : string;
  Function GetTillNo : smallint;
  Function GetTillFilename : string12;
  Function GetCommandLineDir(sDir : string) : string;

const
  IniFilename = 'TRADE.INI';

{var
  sBtrvFilename : string;} // NF: 27/04/2007 Removed as file is not SQL compatible


implementation

uses
  APIUtil, IniFiles, SysUtils, Forms, Dialogs;

Function GetEXEDir : string;
begin
  Result := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
end;

Function GetTillNo : smallint;
var
  sDir : string;
begin
  Result := 0;
  sDir := GetEXEDir;
  if FileExists(sDir + IniFilename) then
    begin
      with TIniFile.Create(sDir + IniFilename) do begin
        Result := ReadInteger('Settings', 'TillNo', -1);
        if Result = -1 then MsgBox('A valid setting for "TillNo" was not found in the section "Settings"', mtError, [mbOK], mbOK, 'INI File error');
      end;{with}
    end
  else MsgBox('INI File : ' + IniFilename + ', not found in this dir : ' + sDir, mtError, [mbOK], mbOK, 'INI File error');
end;

Function GetTillFilename : string12;
begin
  Result := 'TRADEC' + PadString(psLeft,IntToStr(iTillNo),'0',2) + '.DAT';
end;

Function GetCommandLineDir(sDir : string) : string;
var
  iParam : integer;
begin
  Result := sDir;
  For iParam := 1 to ParamCount do begin
    if UPPERCASE(ParamStr(iParam)) = '/DIR:' then Begin
      if iParam < ParamCount then Result := IncludeTrailingBackslash(ParamStr(Succ(iParam)));
    end;
  end;{for}
end;

end.
