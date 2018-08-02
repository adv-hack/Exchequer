unit D4DateU;

interface

Procedure GetD4DateFormat;

implementation

{$IFDEF VER140}
  {$WARN Symbol_Platform Off}
{$ENDIF}

Uses SysUtils, Windows;

Type
  { System Locale information record }
  TSysLocale = packed record
    DefaultLCID: LCID;
    PriLangID: LANGID;
    SubLangID: LANGID;
    FarEast: Boolean;
    MiddleEast: Boolean;
  end;

Var
  SysLocale        : TSysLocale;
  LeadBytes        : set of Char = [];

procedure InitSysLocale;
var
  DefaultLCID: LCID;
  DefaultLangID: LANGID;
  AnsiCPInfo: TCPInfo;
  I: Integer;
  J: Byte;
begin
  { Set default to English (US). }
  SysLocale.DefaultLCID := $0409;
  SysLocale.PriLangID := LANG_ENGLISH;
  SysLocale.SubLangID := SUBLANG_ENGLISH_US;

  DefaultLCID := GetThreadLocale;
  if DefaultLCID <> 0 then SysLocale.DefaultLCID := DefaultLCID;

  DefaultLangID := Word(DefaultLCID);
  if DefaultLangID <> 0 then
  begin
    SysLocale.PriLangID := DefaultLangID and $3ff;
    SysLocale.SubLangID := DefaultLangID shr 10;
  end;

  SysLocale.MiddleEast := GetSystemMetrics(SM_MIDEASTENABLED) <> 0;
  SysLocale.FarEast := GetSystemMetrics(SM_DBCSENABLED) <> 0;
  if not SysLocale.FarEast then Exit;

  GetCPInfo(CP_ACP, AnsiCPInfo);
  with AnsiCPInfo do
  begin
    I := 0;
    while (I < MAX_LEADBYTES) and ((LeadByte[I] or LeadByte[I+1]) <> 0) do
    begin
      for J := LeadByte[I] to LeadByte[I+1] do
        Include(LeadBytes, Char(J));
      Inc(I,2);
    end;
  end;
end;

function TranslateDateFormat(const FormatStr: string): string;
Const
  LOCALE_ICALENDARTYPE = $00001009;   { type of calendar specifier }
var
  I: Integer;
  CalendarType: CALTYPE;
  RemoveEra: Boolean;
begin
  I := 1;
  Result := '';
  CalendarType := StrToIntDef(GetLocaleStr(GetThreadLocale,
    LOCALE_ICALENDARTYPE, '1'), 1);
  if not (CalendarType in [CAL_JAPAN, CAL_TAIWAN, CAL_KOREA]) then
  begin
    RemoveEra := SysLocale.PriLangID in [LANG_JAPANESE, LANG_CHINESE, LANG_KOREAN];
    if RemoveEra then
    begin
      While I <= Length(FormatStr) do
      begin
        if not (FormatStr[I] in ['g', 'G']) then
          Result := Result + FormatStr[I];
        Inc(I);
      end;
    end
    else
      Result := FormatStr;
    Exit;
  end;

  while I <= Length(FormatStr) do
  begin
    if FormatStr[I] in LeadBytes then
    begin
      Result := Result + Copy(FormatStr, I, 2);
      Inc(I, 2);
    end else
    begin
      if StrLIComp(@FormatStr[I], 'gg', 2) = 0 then
      begin
        Result := Result + 'ggg';
        Inc(I, 1);
      end
      else if StrLIComp(@FormatStr[I], 'yyyy', 4) = 0 then
      begin
        Result := Result + 'eeee';
        Inc(I, 4-1);
      end
      else if StrLIComp(@FormatStr[I], 'yy', 2) = 0 then
      begin
        Result := Result + 'ee';
        Inc(I, 2-1);
      end
      else if FormatStr[I] in ['y', 'Y'] then
        Result := Result + 'e'
      else
        Result := Result + FormatStr[I];
      Inc(I);
    end;
  end;
end;


{ ==== Function to determine if Winnt is running ==== }
Function IS_WinNTX  :  Boolean;
Var
  OSVerIRec  :  TOSVersionInfo;
Begin
  Result:=False;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then Begin
    With OSVerIRec Do Begin
      { Return True if Win NT or Win 98 }
      Result:= (dwPlatformId=VER_PLATFORM_WIN32_NT) Or
              ((dwPlatformId=VER_PLATFORM_WIN32_WINDOWS) And
               (dwMajorVersion=4) And (dwMinorVersion=10));
    End; { With }
  end;
end;



Procedure GetD4DateFormat;
Begin { GetD4DateFormat }
  If IS_WinNTX Then Begin
    InitSysLocale;
    ShortDateFormat := TranslateDateFormat(GetLocaleStr(SysLocale.DefaultLCID, LOCALE_SSHORTDATE, 'm/d/yy'));
  End; { If IS_WinNTX }
End; { GetD4DateFormat }


end.
