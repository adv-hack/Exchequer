unit UDPProc;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

{EXPORTS}
function GetUDPeriodYear(sDataPath, sDate : string; var iPeriod : Byte; var iYear : Byte) : boolean; stdcall;
function GetUDPeriodYear_Ext(pDataPath, pDate : pChar; var iPeriod : smallint; var iYear : smallint) : smallint; stdcall;
function GetDateFromUDPY(sDataPath : string; var sDate : shortstring; iPeriod, iYear : Byte) : boolean; stdcall;
function GetDateFromUDPY_Ext(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall;
function UseUDPeriods(pDataPath : pChar) : smallint; stdcall;
procedure SuppressErrorMessages(iSetTo : smallint) stdcall;
function GetEndDateOfUDPY(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall;

implementation
uses
  Classes, Inifiles, SysUtils, APIUtil, PerUtil, Dialogs,
  EntLicence; // X:\ENTRPRSE\DRILLDN

var
  bSuppressMessages : boolean;


procedure LocalMessageDlg(sMessage : string);
begin
  if not bSuppressMessages then MsgBox(sMessage,mtError,[mbOK],mbOK,'User Defined Periods');
end;

function GetUDPeriodYear(sDataPath, sDate : string; var iPeriod : Byte; var iYear : Byte) : boolean;
var
  PeriodCalc : TPeriodCalc;
begin
  Result := FALSE;
  PeriodCalc := TPeriodCalc.Create(sDataPath);
  PeriodCalc.EntMessageDlg := LocalMessageDlg;

  with PeriodCalc do begin

    EntVersion := 'v5.70';
//    LoggedInUser := UserName;
    TransDate := sDate;

    if PeriodCalc.UsePlugIn then begin
      if ConvertDateToPeriod then begin
        iPeriod := Period;
        iYear := Year;
        Result := TRUE;
      end;{if}
    end;{if}

  end;{with}

  PeriodCalc.EntMessageDlg := nil;
  PeriodCalc.Free;
end;

function GetDateFromUDPY(sDataPath : string; var sDate : shortstring; iPeriod, iYear : Byte) : boolean;
var
  PeriodCalc : TPeriodCalc;
begin
  Result := FALSE;
  PeriodCalc := TPeriodCalc.Create(sDataPath);
  PeriodCalc.EntMessageDlg := LocalMessageDlg;

  with PeriodCalc do begin

    EntVersion := 'v5.70';
//    LoggedInUser := UserName;
    Period := iPeriod;
    Year := iYear;

    if PeriodCalc.UsePlugIn then begin
      if ConvertPYToDate then begin
        sDate := TransDate;
        Result := TRUE;
      end;{if}
    end;{if}

  end;{with}

  PeriodCalc.EntMessageDlg := nil;
  PeriodCalc.Free;
end;

function GetDateFromUDPY_Ext(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall;
var
  asDate, asDataPath : ANSIString;
  iPeriodAsByte, iYearAsByte : Byte;
  sDate : shortstring;
begin
  Result := 0;

  // Convert PChars to Ansi Strings
  asDataPath := pDataPath;
  asDate := pDate;

  // Copy Ansi string to shortstring;
  sDate := asDate;

  // Check that period/year will fit into "bytes"
  if (iPeriod > 255) or (iPeriod < 0) then Result := 1;
  if (iYear > 255) or (iYear < 0) then Result := 2;

  if Result = 0 then
  begin
    // Copy period/year into bytes
    iPeriodAsByte := iPeriod;
    iYearAsByte := iYear;

    // Call original function
    if GetDateFromUDPY(asDataPath, sDate, iPeriodAsByte, iYearAsByte) then
    begin
      Result := 0;
    end else
    begin
      // Function failed
      Result := 1000;
    end;{if}

    // Copy back new Date
    asDate := sDate;
    StrPCopy(pDate, asDate);
  end;{if}
end;

function GetUDPeriodYear_Ext(pDataPath, pDate : pChar; var iPeriod : smallint; var iYear : smallint) : smallint;
var
  asDate, asDataPath : ANSIString;
//  asDate, asDataPath : String;
  iPeriodAsByte, iYearAsByte : Byte;
begin
//  Result := 0;

  // Convert PChars to Ansi Strings
  asDataPath := pDataPath;
  asDate := pDate;

//  asDataPath := StrPas(pDataPath);
//  asDate := StrPas(pDate);

  // Check that period/year will fit into "bytes"
//  if (iPeriod > 255) or (iPeriod < 0) then Result := 1;
//  if (iYear > 255) or (iYear < 0) then Result := 2;

//  if Result = 0 then
//  begin
    // Copy period/year in bytes
//    iPeriodAsByte := iPeriod;
//    iYearAsByte := iYear;

    // Call original function
    if GetUDPeriodYear(asDataPath, asDate, iPeriodAsByte, iYearAsByte) then
    begin
      Result := 0;
    end else
    begin
      // Function failed
      Result := 1000;
    end;{if}

    // Copy back new Period and Year
    iPeriod := iPeriodAsByte;
    iYear := iYearAsByte;
//  end;{if}
end;


function UseUDPeriods(pDataPath : pChar) : smallint;
var
  asDataPath : ANSIString;
  PeriodCalc : TPeriodCalc;

  function PlugInInstalled : boolean;
  var
    IniF : TIniFile;
    slKeys : TStringList;
    iLine{, iPos} : integer;
    sKey, sValue : string;
  begin{PlugInInstalled}
    // Go through EntCustm.ini, and make sure the period Plug-In is actually installed
    Result := FALSE;
    IniF := TIniFile.Create(ExtractFilePath(Paramstr(0)) + 'ENTCUSTM.INI');
    slKeys := TStringList.Create;
    IniF.ReadSection('HookChain', slKeys);

    For iLine := 0 to slKeys.count-1 do
    begin
      sKey := slKeys[iLine];
      sValue := IniF.ReadString('HookChain',sKey,'');

      if (Uppercase(sValue) = 'PERHOOK')
      and FileExists(ExtractFilePath(Paramstr(0)) + sKey + '.DLL') then
      begin
        Result := TRUE;
        Break;
      end;{if}
    end;{for}

    slKeys.Free;
  end;{PlugInInstalled}

begin
 Result := 1000;
  asDataPath := pDataPath;
  PeriodCalc := TPeriodCalc.Create(asDataPath);
  PeriodCalc.EntMessageDlg := LocalMessageDlg;

  with PeriodCalc do
  begin
    EntVersion := 'v5.70';

    if EnterpriseLicence.IsLITE then
    begin
      // In IAO the UDPeriods Plug-In is ALWAYS installed, so we don't need to check whether it is in LIB\VPQ0001
      if PeriodCalc.UsePlugIn then Result := 1
      else Result := 0;
    end else
    begin
      // In Exchequer we need to make sure that the UDPeriods Plug-In is in entcustm.ini, and that the Plug-In file exists
      if PeriodCalc.UsePlugIn and FileExists(ExtractFilePath(Paramstr(0))+'PERHOOK.DLL')
      and PlugInInstalled then Result := 1
      else Result := 0;
    end;{if}

  end;{with}

  PeriodCalc.EntMessageDlg := nil;
  PeriodCalc.Free;
end;

function GetEndDateOfUDPY(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall;
var
  PeriodCalc : TPeriodCalc;
  asDate, asDataPath : ANSIString;
  iPeriodAsByte, iYearAsByte : Byte;
  sDate : shortstring;
  bResult : boolean;
begin
  Result := 0;

  // Convert PChars to Ansi Strings
  asDataPath := pDataPath;
  asDate := pDate;

  // Copy Ansi string to shortstring;
  sDate := asDate;

  // Check that period/year will fit into "bytes"
  if (iPeriod > 255) or (iPeriod < 0) then Result := 1;
  if (iYear > 255) or (iYear < 0) then Result := 2;

  if Result = 0 then
  begin
    // Copy period/year into bytes
    iPeriodAsByte := iPeriod;
    iYearAsByte := iYear;

    bResult := FALSE;
    PeriodCalc := TPeriodCalc.Create(asDataPath);
    PeriodCalc.EntMessageDlg := LocalMessageDlg;

    with PeriodCalc do
    begin
      EntVersion := 'v5.70';
  //    LoggedInUser := UserName;
      Period := iPeriod;
      Year := iYear;

      if PeriodCalc.UsePlugIn then
      begin
        if ConvertPYToEndDate then
        begin
          sDate := TransDate;
          bResult := TRUE;
        end;{if}
      end;{if}

    end;{with}

    PeriodCalc.EntMessageDlg := nil;
    PeriodCalc.Free;

    if bResult then
    begin
      Result := 0;
    end else
    begin
      // Function failed
      Result := 1000;
    end;{if}

    // Copy back new Date
    asDate := sDate;
    StrPCopy(pDate, asDate);
  end;{if}
end;

procedure SuppressErrorMessages(iSetTo : smallint);
begin
  bSuppressMessages := iSetTo <> 0;
end;

initialization
  bSuppressMessages := FALSE;


end.
