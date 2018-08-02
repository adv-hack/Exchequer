/////////////////////////////////////////////////////
// Wrapper Unit for common calls to the Toolkit DLL//
/////////////////////////////////////////////////////
unit TKUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

function GetMultiCompDir: ansistring;

function GetMultiCurrencyCode: integer;

function IsMultiCurrency: boolean;

function SetToolkitPath(Path: ansistring): integer;

function ShowTKError(sFuncDesc: string; iProcNo: smallint; iErrorCode: integer; sMessCaption: string = 'Toolkit Error'): boolean;

//PR: 24/11/2017 ABSEXCH-19463 Function to return Exchequer UserID from a string
//which may be an Exchequer UserID or may be a Windows UserID.
function GetExchequerUserID(UserID: ansistring): string;

procedure ToolKitOK;

const
  ebRemoteDirSw = '/DIR:';
  ebEntDirSw = '/CODIR:';
  ebpAccess = 319;
  ebpEdit = 320;
  ebpPost = 321;
  ebpDelete = 322;
  ebpHold = 323;
  ebpHTML = 324;
  ebpXML = 325;
  ebpImpLogs = 326;
  ebpPostLogs = 327;

type
  TUserAccess = class
  private
    FUserName: string;
  protected
    function GetBool(Index: integer): Boolean;
  public
    property UserName: string write FUserName;
    property CanAccess: Boolean index 0 read GetBool;
    property CanEdit: Boolean index 1 read GetBool;
    property CanPost: Boolean index 2 read GetBool;
    property CanDelete: Boolean index 3 read GetBool;
    property CanHold: Boolean index 4 read GetBool;
    property CanViewHTML: Boolean index 5 read GetBool;
    property CanViewXML: Boolean index 6 read GetBool;
    property CanViewImpLogs: Boolean index 7 read GetBool;
    property CanViewPostLogs: Boolean index 8 read GetBool;
  end;

var
  eBSetDrive: AnsiString = ''; // Exchequer dir
  ebCompDir: AnsiString = ''; //company data set
  ThisUser: TUserAccess;
  //VA:05/1/2018:2018-R1:ABSEXCH-19589:Existing Issue: Local Work Station Setup Run gives
  //error on login window for eBusiness
  TKSetUpF: TextFile;  // File Handle
  TKNoSws: Integer = 32;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  Crypto {in X:\ENTRPRSE\MULTCOMP}
    , LicRec, EntLic, UseDLLU, SysUtils, Forms, IniFiles, APIUtil, Dialogs,
    ETStrU;

// Include the DLL constant declarations
{$I ExDllBt.Inc}

// Include the DLL type definitions
{$I ExchDll.Inc}



//VA:05/01/2018:2018-R1:ABSEXCH-19589:Existing Issue: Local Work Station Setup Run gives
//error on login window for eBusiness

{ ====== Process EXCHDLL.INI File ====== }

function Process_EXCHDLL(DFName: AnsiString; aExchTag: AnsiString): AnsiString;

  { ============ Open/Close Files ============ }

  procedure Open_SetUp(DFnam: AnsiString; Mode: Byte; var TmpIO: Integer);
  var
    LoopCnt: Integer;
  begin

    TmpIO := 0;

    FileMode := 66;

    {$I-}
    // Try to open the file for reading and writing to
    AssignFile(TKSetUpF, DFnam);
    LoopCnt := 0;

    case Mode of

      0:
        begin
          repeat
            Reset(TKSetUpF);
            TmpIO := IOResult;

            Inc(LoopCnt);

          until (TmpIO <> 32) or (LoopCnt > 999);

        end;

      1:
        begin
          ReWrite(TKSetUpF);
          TmpIO := IOResult;

        end;

    end; {Case..}

    {$I+}

  end;

var
  Line: AnsiString;
  TmpIO, lRes, lPos: Integer;
  FoundOk, Abort: Boolean;
 // N: LongInt;
begin

  FoundOk := False;
 // N := 0;

  Result := EmptyStr;

  Open_SetUp(DFName, 0, lRes);
  try
    begin
      if (lRes = 0) then
      begin

        ReadLn(TKSetUpF, Line);

        Abort := EOF(TKSetUpF);

        TmpIO := IOResult;

        while (TmpIO = 0) and (not Abort) do
        begin

          Abort := EOF(TKSetUpF);
          FoundOk := False;
          lPos := 0;
          // Added lPos field for index value of ExchTag
          lPos := Pos(aExchTag, Line);

          FoundOk := lPos <> 0;  // If ExchTag passed is found

          if (FoundOk) then
          begin
            Result := ExtractWords(2, 1, Line);   // Returns value of ExchTag
            Exit;
          end;  //  If (FoundOk)

          ReadLn(TKSetUpF, Line);

          TmpIO := IOResult;

        end; {While..}

      end;

    end;  // Try..Finally
  finally
    begin

      // Close the file
      CloseFile(TKSetUpF);

    end;  // Try..Finally

  end; {IF Opned Ok..}


end; {Proc..}

//-----------------------------------------------------------------------

function TUserAccess.GetBool(Index: integer): Boolean;
var
  iStatus, SecRes: SmallInt;
begin
  iStatus := Ex_CheckSecurity(PChar(FUserName), ebpAccess + Index, SecRes);
  Result := (iStatus = 0) and (SecRes = 1);
end;

function GetMultiCompDir: ansistring;
// Notes : Calls to Ex_GetCompany require the directory that the multicompany
//         Btrieve file (COMPANY.DAT) exists in to be passed as a parameter.
//         This is stored in ENTWREPL.INI under a specific key.  If the key is
//         empty, assume that COMPANY.DAT is in the EXE's directory.
const
  WORKSTATION_REPLICATION_INI = 'ENTWREPL.INI';

  //VA:05/1/2018:2018-R1:ABSEXCH-19589:Existing Issue: Local Work Station Setup Run gives
  //error on login window for eBusiness
  EXCHDLL_INI = 'EXCHDLL.INI';
  SECTION_NAME = 'UpdateEngine';
  KEY_NAME = 'NetworkDir';
  EXCH_PATH = 'Exchequer_Path';
var
  Directory: ansistring;
  ShortDir: ansistring;
begin
  Result := '';
  ShortDir := '';

  if (ebSetDrive = '') then
    Directory := ExtractFilePath(Application.ExeName)
  else
    Directory := ebSetDrive;

  with TIniFile.Create(Directory + WORKSTATION_REPLICATION_INI) do
  try
    Result := ReadString(SECTION_NAME, KEY_NAME, '');
  finally
    Free;
  end;
   //VA:05/1/2018:2018-R1:ABSEXCH-19589:Existing Issue: Local Work Station Setup Run gives
   //error on login window for eBusiness	
  Result := Process_EXCHDLL(EXCHDLL_INI, EXCH_PATH);  // Return Network Drive Path for Ebusiness Module

  if Trim(Result) = '' then
    Result := Directory;

  ShortDir := ExtractShortPathName(Result);

  if (ShortDir <> '') then
    Result := ShortDir;

  Result := IncludeTrailingBackslash(Result);
end;

//-----------------------------------------------------------------------

function GetMultiCurrencyCode: integer;
// Notes : Reads the licence file to determine whether a particular installation
//         is multi-currency or not.
// Post  : Returns -1 if licence file not read
var
  LicenceInfo: EntLicenceRecType;
  LicencePath: shortstring;
begin
  LicencePath := GetMultiCompDir + EntLicFName;
  if ReadEntLic(LicencePath, LicenceInfo) then
    Result := LicenceInfo.licEntCVer
  else
    Result := -1;
end;

//-----------------------------------------------------------------------

function IsMultiCurrency: boolean;
// Notes : Defaults to true if licence file not read
begin
  Result := GetMultiCurrencyCode <> 0;
end;

//-----------------------------------------------------------------------

procedure ToolKitOK;
const
  CODE = #238 + #27 + #236 + #131 + #174 + #38 + #110 + #208 + #185 + #168 + #157;
var
  pCode: array[0..255] of char;
begin
  ChangeCryptoKey(19701115);
  StrPCopy(pCode, Decode(CODE));
  Ex_SetReleaseCode(pCode);
end;

//-----------------------------------------------------------------------

function SetToolkitPath(Path: ansistring): integer;
// Pre : Path to chosen multi-company
begin
  ToolKitOK;
  Result := Ex_InitDLLPath(PChar(Path), IsMultiCurrency);
end;

//-----------------------------------------------------------------------

function ShowTKError(sFuncDesc: string; iProcNo: smallint; iErrorCode: integer; sMessCaption: string = 'Toolkit Error'): boolean;
begin
  Result := iErrorCode = 0;
  if not Result then
  begin
    MsgBox('The DLL Toolkit function "' + sFuncDesc + '" failed with the error code : ' + IntToStr(iErrorCode) + ', and with the error message :' + #13 + #13 + '"' + EX_ERRORDESCRIPTION(iProcNo, iErrorCode) + '"', mtError, [mbOK], mbOK, sMessCaption);
  end; {if}
end;

procedure GetDirParam;
var
  n: Integer;
begin
  ebSetDrive := '';

  for n := 0 to Pred(ParamCount) do
  begin
    if UpperCase(ParamStr(n)) = ebRemoteDirSw then
    begin
      ebSetDrive := IncludeTrailingBackslash(ParamStr(n + 1));
      Break;
    end;

  end;

end;

//PR: 24/11/2017 ABSEXCH-19463 Function to return Exchequer UserID from a string
//which may be an Exchequer UserID or may be a Windows UserID.
function GetExchequerUserID(UserID: ansistring): string;
var
  Res: Integer;
  UserProfile: TUserProfileType;
  Found: Boolean;
  KeyS: PChar;
begin
  Result := '';
  Found := False;
  try
    KeyS := PChar(UserID + StringOfChar(#0, 255 - Length(UserID)));
    //Look for a match on Exchequer User ID
    Res := Ex_GetUserProfile(@UserProfile, SizeOf(UserProfile), KeyS, B_GetEq);
    if Res = 0 then //Ok
      Found := True
    else //Check for Windows ID
      Res := Ex_GetUserProfile(@UserProfile, SizeOf(UserProfile), KeyS, B_GetFirst);

    while (Res = 0) and not Found do
    begin
      Found := UpperCase(Trim(UserID)) = UpperCase(Trim(UserProfile.upWindowsUserId));

      if not Found then
        Res := Ex_GetUserProfile(@UserProfile, SizeOf(UserProfile), KeyS, B_GetNext);
    end;
  finally
    if Found then
      Result := UserProfile.upUserId;
  end;
end;

initialization
  GetDirParam; {See if we need to override ini file settings}


end.

