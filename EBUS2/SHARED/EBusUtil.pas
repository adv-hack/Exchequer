unit EBusUtil;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Forms, ComCtrls, EBusCnst, StrUtil, eBusVar, Classes, UseTKit,
  Messages,EntLic;

const
  wm_IconMessage = wm_User;
  wm_IconClose   = wm_User+1;

type
  TCompanyInfo = Class
    CompanyRec : TCompanyType;
    Active : boolean;
  end;

  TFillMode = (fmAll, fmActive, fmInactive);

procedure ShowSetUpScreen; external 'eBusSet.DLL' index 1;

Function FullCompCodeKey(sCompanyCode : shortstring) : String10;
function DaysOfWeekToByte(DaysOfWeek : array of boolean) : byte;
function DayBitEnabled(Week : byte; DayOfWeek : TCalDayOfWeek) : boolean;
function ThirdPartyAvailable(ThirdParty : TThirdParty) : boolean;
Function GetMapFileDir : string;
function GetXSLDirectory : string;
Function GetFileRecord(sCompanyCode : shortstring; sExportCode : string20) : TEBusFile;
function GetCurrencyDescription(CurrNum : integer) : string;
function GetCurrencySymbol(CurrNum : integer) : string;
function GetVATDescription(Code : char) : string;
function GetNomDescription(NominalCode : longint) : string;
function GetTraderDetailsFromCode(TraderCode : string; var TraderDetails : TBatchCURec) : integer;
function GetStockDetailsFromCode(StockCode : string; var StockDetails : TBatchSKRec) : integer;
function GetTraderNameFromCode(TraderCode : string) : string;

{$IFDEF EXTERNALIMPORT}
  function GetCompanyDirFromCode(CompanyCode, CompanyPath : shortstring) : string;
{$ELSE}
  function GetCompanyDirFromCode(CompanyCode : shortstring) : string;
{$ENDIF}

function GetCompanyNameFromCode(CompanyCode : shortstring) : string;
function JobCostingEnabled : boolean;
function GetEBusSubDir(CompanyDir, BtrieveFileName : string) : string;
function CompanyCodeFromDir(CoDir : AnsiString) : shortstring;
procedure FillCompanyList(slCompanyList : TStringList; FillMode : TFillMode);
procedure ShowEbusSetup;
function ExGetCompany(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : smallint;
function GetCompanyCodeFromPath(const APath : string) : string;

//PR: 17/02/2016 v2016 R1 Change all eBus Modules to use the same build number
function BuildNo : string;

Var
  BusyInProcess,
  WantToClose  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  Windows, SysUtils, IniFiles, eBusBtrv, Dialogs, ETStrU,UseDLLU, TKUtil, LicRec, FileUtil;

//-----------------------------------------------------------------------

type
  TCompElement = (cmpName, cmpPath);

//PR: 17/02/2016 v2016 R1 ABSEXCH-17070 Change dynamic loading of EntComp to static link
const
 {$IFDEF EXTERNALIMPORT}
 CompanyLib = 'EntComp2.dll';
 {$ELSE}
 CompanyLib = 'EntComp.dll';
 {$ENDIF}

//VA:05/1/2018:2018-R1:ABSEXCH-19589:Existing Issue: Local Work Station Setup Run gives error on login window for eBusiness
// Increase Build No
FUNCTION EX_GETCOMPANY(COMPDIR    : PCHAR; PARRAY     : POINTER;
                       VAR PARRAYSIZE : LONGINT) : SMALLINT; StdCall; External CompanyLib;

function BuildNo : string;
begin
  Result := '208';
end;


function DaysOfWeekToByte(DaysOfWeek : array of boolean) : byte;
// Pre   : DaysOfWeek = position 0 => Monday, 6 => Sunday
// Notes : If there aren't 7 boolean values passed in, an exception is raised
// Post  : Returns a byte, bit 0 = Monday, bit 6 = Sunday, 0 = excluded, 1 = included
const
  DAYS_PER_WEEK = 7;
var
  i : integer;
  Num : byte;
begin
  Result := 0;
  if length(DaysOfWeek) <> 7 then
    raise EConvertError.CreateFmt('DaysOfWeekToByte expects %d array elements, %d received',
      [DAYS_PER_WEEK, length(DaysOfWeek)])
  else
  begin
    Num := 1;
    for i := Low(DaysOfWeek) to High(DaysOfWeek) do
    begin
     if DaysOfWeek[i] then
       Result := Result or Num;
     Num := Num * 2;
    end;
  end;
end; // DaysOfWeekToByte

//-----------------------------------------------------------------------

function DayBitEnabled(Week : byte; DayOfWeek : TCalDayOfWeek) : boolean;
// Pre   : Week, byte = bit 0 = Monday, bit 6 = Sunday, 0 = excluded, 1 = included
// Post  : Returns true if the day was enabled
// Notes : TCalDayOfWeek defined in ComCtrls,
//         relies on ordinality of dowMonday to dowSunday
var
  i,
  Num : integer;
begin
  Num := 1;
  for i := 1 to ord(DayOfWeek) do
    Num := Num * 2;
  Result := Week and Num = Num;
end;

//-----------------------------------------------------------------------

function ThirdPartyAvailable(ThirdParty : TThirdParty) : boolean;
begin
  case ThirdParty of
    tptDragNet : Result := false;
    tptActinic : Result := false;
    tptFreeCom : Result := false;
  else
    Result := false;
  end;
end;

//-----------------------------------------------------------------------

Function GetMapFileDir : string;
// Post : Returns Main Company\EBUS\CSVMAP

begin
  Result := IncludeTrailingBackslash(GetMultiCompDir) +
  IncludeTrailingBackSlash(EBUS_DIR) +IncludeTrailingBackSlash(EBUS_CSVMAP_DIR);
end;

//-----------------------------------------------------------------------

function GetXSLDirectory : string;
// Post : Returns Main Company\EBUS\XML\XSL
begin
  Result := IncludeTrailingBackslash(GetMultiCompDir) +
    IncludeTrailingBackSlash(EBUS_DIR) +
    IncludeTrailingBackslash(EBUS_XML_DIR) +
    IncludeTrailingBackslash(EBUS_XSL_DIR);
end;

//-----------------------------------------------------------------------

Function GetFileRecord(sCompanyCode : shortstring; sExportCode : string20) : TEBusFile;
begin
  FillChar(Result, SizeOf(Result),#0);
  with TEBusBtrieveFile.Create(TRUE) do begin
    OpenFile;
    CompanyCode := sCompanyCode;
    ExportCode := sExportCode;
    if (FindRecord = 0) then Result := FileSettings;
    CloseFile;
    Free;
  end;{with}
end;


//-----------------------------------------------------------------------

Function FullCompCodeKey(sCompanyCode : shortstring) : String10;

Begin
  Result:=LJVar(SCompanyCode,CompCodeLen);

end;

//-----------------------------------------------------------------------

procedure FillCompanyList(slCompanyList : TStringList; FillMode : TFillMode);
var
  CompArray : PCompanies;
  ArrayItems : longint;
  Status : integer;
  i : LongInt;
  CompanyInfo : TCompanyInfo;
  bActive, bAdd : boolean;
begin
  {fill company array from enterprise}
  new(CompArray);
  ArrayItems := SizeOf(CompArray^);
  Status := EXGETCOMPANY(PChar(GetMultiCompDir), CompArray, ArrayItems);

  if Status = 0 then
    begin
      {check to see if the companies are valid for eBus}
      with TEbusBtrieveCompany.Create(TRUE) do begin
        try
          Openfile;
          for i := 1 to ArrayItems do begin
            CompanyCode := FullCompCodeKey(CompArray^[i].CompCode);

            bActive := FindRecord = 0;
            case FillMode of
              fmAll : bAdd := TRUE;
              fmActive : bAdd := bActive;
              fmInactive : bAdd := not bActive;
            end;{case}

            if bAdd then begin
              CompanyInfo := TCompanyInfo.create;
              CompanyInfo.CompanyRec := CompArray^[i];
              CompanyInfo.Active := bActive;
              slCompanyList.AddObject(CompArray^[i].CompName + ' (' + CompArray^[i].CompCode + ')', CompanyInfo);
            end;{if}
          end;{for}
          CloseFile;
        finally
          free;
        end;{try}
      end;{with}
    end
  else ShowMessage('Error - EX_GETCOMPANY : ' + IntToStr(Status));
  dispose(CompArray);
end;

//-----------------------------------------------------------------------

function GetCurrencyDescription(CurrNum : integer) : string;
// Pre   : CurrNum = Currency number
// Post  : Returns its description, if found
// Notes : Assumes the DLL Toolkit is open, and for the correct company
var
  CurrInfo : TBatchCurrRec;
begin
  FillChar(CurrInfo, SizeOf(CurrInfo), 0);
  if Ex_GetCurrency(@CurrInfo, SizeOf(CurrInfo), CurrNum) = 0 then
    Result := CurrInfo.Name
  else
    Result := '';
end; // GetCurrencyDescription

//-----------------------------------------------------------------------

function GetCurrencySymbol(CurrNum : integer) : string;
// Pre   : CurrNum = Currency number
// Post  : Returns its screen symbol, if found
// Notes : Assumes the DLL Toolkit is open, and for the correct company
var
  CurrInfo : TBatchCurrRec;
begin
  FillChar(CurrInfo, SizeOf(CurrInfo), 0);
  if Ex_GetCurrency(@CurrInfo, SizeOf(CurrInfo), CurrNum) = 0 then
  begin
    Result := CurrInfo.ScreenSymb;
    Result := StringReplace(Result, #156, '£', []);
  end
  else
    Result := '';
end; // GetCurrencyDescription

//-----------------------------------------------------------------------

function GetVATDescription(Code : char) : string;
// Pre  : Code = VAT code letter
// Post : Returns its description, if found
// Notes : Assumes the DLL Toolkit is open, and for the correct company
var
  VATInfo : TBatchVATRec;
begin
  FillChar(VATInfo, SizeOf(VatInfo), 0);
  VATInfo.VATCode := Code;
  if Ex_GetVATRate(@VATInfo, SizeOf(VATInfo)) = 0 then
    Result := VATInfo.VATDesc
  else
    Result := '';
end; // GetVATDescription

//-----------------------------------------------------------------------

function GetTraderDetailsFromCode(TraderCode : string;
  var TraderDetails : TBatchCURec) : integer;
var
  SearchCode : array[0..255] of char;
begin
  FillChar(TraderDetails, SizeOf(TraderDetails), 0);
  StrPCopy(SearchCode, PadString(psRight, TraderCode, ' ', 6));
  Result := Ex_GetAccount(@TraderDetails, SizeOf(TraderDetails), SearchCode, 0, B_GetEq, 0, false);
end;

//-----------------------------------------------------------------------

function GetTraderNameFromCode(TraderCode : string) : string;
// Pre  : TraderCode = 6 character customer or supplier code
// Post : Returns the trader's name, or blank if not found
var
  TraderRec : TBatchCURec;
begin
  if GetTraderDetailsFromCode(TraderCode, TraderRec)  = 0 then
    Result := TraderRec.Company
  else
    Result := '';
end;


//-----------------------------------------------------------------------

function GetStockDetailsFromCode(StockCode : string; var StockDetails : TBatchSKRec) : integer;
var
  SearchCode : array[0..255] of char;
begin
  FillChar(StockDetails, SizeOf(StockDetails), 0);
  StrPCopy(SearchCode, PadString(psRight, StockCode, ' ', 16));
  Result := Ex_GetStock(@StockDetails, SizeOf(StockDetails), SearchCode, 0, B_GetEq, false);
end;

//-----------------------------------------------------------------------

function JobCostingEnabled : boolean;
// Pre   : Path to chosen multi-company
// Notes : Reads the licence file to determine whether a particular installation
//         has job costing enabled
var
  LicenceInfo : EntLicenceRecType;
  LicencePath : shortstring;
begin
  LicencePath := GetMultiCompDir + EntLicFName;
  if ReadEntLic(LicencePath, LicenceInfo) then
    Result := LicenceInfo.LicModules[modJobCost] > 0
  else
    Result := false;
end;

//-----------------------------------------------------------------------

function GetEBusSubDir(CompanyDir, BtrieveFileName : string) : string;
// Pre  : CompanyDir = Path to top level of company's directory structure
//        BtrieveFileName = Name of file
// Post : Returns full path and file name of file in root of a comapny's EBUS sub directory
begin
  Result := IncludeTrailingBackSlash(IncludeTrailingBackSlash(CompanyDir) + EBUS_DIR) +
    ExtractFileName(BtrieveFileName);
end;

//-----------------------------------------------------------------------

function GetCompanyGeneric(CompanyCode : shortstring; CompanyElement : TCompElement) : string;
var
  slCompanies : TStringList;
  iPos : integer;
begin
  Result := '';
  slCompanies := TStringList.Create;
  FillCompanyList(slCompanies, fmActive);
  for iPos := 0 to slCompanies.Count - 1 do begin
    if FullCompCodeKey(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.CompCode) = FullCompCodeKey(CompanyCode) then
      case CompanyElement of
        cmpPath : Result := Trim(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.CompPath);
        cmpName : Result := Trim(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.CompName);
      end;
  end;
  slCompanies.Free;
end;

//-----------------------------------------------------------------------

{$IFDEF EXTERNALIMPORT}
  function GetCompanyDirFromCode(CompanyCode, CompanyPath : shortstring) : string;
  begin
    if Trim(CompanyPath) = '' then
    begin
      Result := GetCompanyGeneric(CompanyCode, cmpPath);
    end else
    begin
      Result := IncludeTrailingBackslash(Trim(CompanyPath));
    end;{if}
  end;
{$ELSE}
  function GetCompanyDirFromCode(CompanyCode : shortstring) : string;
  begin
    Result := GetCompanyGeneric(CompanyCode, cmpPath);
  end;
{$ENDIF}

//-----------------------------------------------------------------------

function GetCompanyNameFromCode(CompanyCode : shortstring) : string;
begin
  Result := GetCompanyGeneric(CompanyCode, cmpName);
end;

//-----------------------------------------------------------------------

function GetNomDescription(NominalCode : longint) : string;
var
  NomRec : TBatchNomRec;
  NomCode : array[0..255] of char;
begin
  Result := 'unknown';
  FillChar(NomCode, SizeOf(NomCode), 0);
  FillChar(NomRec, SizeOf(NomRec), 0);

  StrPCopy(NomCode, IntToStr(NominalCode));
  if Ex_GetGLAccount(@NomRec, SizeOf(NomRec), NomCode, 0, B_GetEq, false) = 0 then
    Result := NomRec.Desc;
end;

//-----------------------------------------------------------------------

function CompanyCodeFromDir(CoDir : AnsiString) : shortstring;
var
  i : integer;
  ArrayItems : longint;
  c : TCompanies;
  pCoDir : PChar;
begin
  pCoDir := StrAlloc(255);
  ArrayItems := 255;
  GetShortPathName(PChar(CoDir), pCoDir, ArrayItems);
  CoDir := String(pCoDir);
  StrDispose(pCoDir);
  ArrayItems := SizeOf(c);

  i := ExGetCompany(PChar(GetEnterpriseDirectory), @c, ArrayItems);

  if i = 0 then
  begin
    for i := 1 to ArrayItems do
      if UpperCase(Trim(CoDir)) = UpperCase(Trim(c[i].CompPath)) then
      begin
        Result := c[i].CompCode;
        Break;
      end;
  end;
end;

procedure ShowEbusSetup;
{var
// Only used if dynamically linking to the DLL
  SysSetup : procedure; stdcall;
  hSysSetupDLL : THandle;}
begin
{ When attempting to load the set-up screen DLL dynamically
   Access violation on calling FreeLibrary which could not be tracked down.
  hSysSetupDLL := LoadLibrary('eBusSet.dll');
  if hSysSetupDLL > HInstance_Error then SysSetup := GetProcAddress(hSysSetupDLL, 'ShowSetupScreen');
  if Assigned(SysSetup)
  then SysSetup;
  FreeLibrary(hSysSetupDLL);}

  ShowSetupScreen;
{  ShowSetUpScreen;}
end;

function ExGetCompany(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : smallint;
begin
  //PR: 17/02/2016 v2016 R1 ABSEXCH-17070 Change dynamic loading of EntComp to static link
  Result := EX_GETCOMPANY(COMPDIR, PARRAY, PARRAYSIZE);
end;

function GetCompanyCodeFromPath(const APath : string) : string;
var
  CompArray : PCompanies;
  ArrayItems : longint;
  Status : integer;
  i : LongInt;
begin
  {fill company array from enterprise}
  new(CompArray);
  Try
    ArrayItems := SizeOf(CompArray^);
    Status := EXGETCOMPANY(PChar(GetMultiCompDir), CompArray, ArrayItems);
    if Status = 0 then
    for i := 1 to ArrayItems do
    begin
      if UpperCase(Trim(CompArray^[i].CompPath)) = UpperCase(Trim(APath)) then
      begin
        Result := CompArray^[i].CompCode;
        Break;
      end;
    end;
  Finally
    Dispose(CompArray);
  End;
end;



Initialization
  BusyInProcess:=False;
  WantToClose:=False;

end.
