unit SQLCompany;
{
  Routines for accessing the Company table through the SQL Emulator.
}
{$ALIGN 1}
{$REALCOMPATIBILITY ON}
interface

uses Classes, Contnrs, BtrvU2;

type
  { Cache for Company records. }
  TCompanyCacheItem = class(TObject)
  private
    FCode: string;
    FPath: string;
    procedure SetCode(const Value: string);
    procedure SetPath(const Value: string);
  public
    property Code: string read FCode write SetCode;
    property Path: string read FPath write SetPath;
  end;

  TCompanyCache = class(TObjectList)
  private
    function GetEntry(index: Integer): TCompanyCacheItem;
  public
    constructor Create;
    function Add(const CompanyCode, Path: string): TCompanyCacheItem;
    function FindByCode(const Code: string): TCompanyCacheItem;
    function FindByPath(const Path: string): TCompanyCacheItem;
    property Entries[index: Integer]: TCompanyCacheItem read GetEntry; default;
  end;

  { Class for access to the Company table. This caches the information the
    first time the table is accessed, and from there on it uses the cache,
    not the Company table itself. }
  TCompanyTable = class(TObject)
  private
    function GetCache: TCompanyCache;
  private
    FIsInitialised: Boolean;
    FIsOpen: Boolean;
    FClientID: ^ClientIdType;
    FUseCache: Boolean;
    FCache: TCompanyCache;
    function BKeyPos (Const OfsField, OfsRec : Pointer) : Word;
    function EnsureOpen: LongInt;
    function FullCompanyPath(const Path : string) : string;
    function FullCompanyPathKey(const Prefix, Path : string) : string;
    function GetIsOpen: Boolean;
    procedure Init;
    property Cache: TCompanyCache read GetCache;
    property IsInitialised: Boolean read FIsInitialised write FIsInitialised;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(CompanyCode, CompanyName, CompanyPath: string; IsDemo: Boolean): Integer;
    function Close: Integer;
    function Delete(CompanyCode: string): Integer;
    function FindByPath(const Path: string): string;
    function FindByCode(const Code: string): Integer;
    function GetUniqueID: Integer;
    function InitCache: Integer;
    function LongPathToShortPath(const Path: string): string;
    function Open: LongInt;
    function UpdateCache(CompanyCode, CompanyPath: string): Integer;
    property IsOpen: Boolean read GetIsOpen;
    property UseCache: Boolean read FUseCache;
  end;

function CompanyTable: TCompanyTable;
function DelimitedPath(Path: string): string;

function FindCompanyCode(const ForPath: string): string;
function FindCompany(const ForCode: string; ClientID: Pointer = nil): Integer;
function FindCompanyCodeFromSubFolder(FromPath: string; ClientID: Pointer = nil): string;

var
  SystemPath:  string;

implementation

uses SysUtils, Windows, Forms, Dialogs,
  GlobVar,
  ETStrU,
  PathUtil,
  StrUtils,
  DebugLogU,
  // MH 04/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
  UNCCache,
  VarRec2U;

{$I ..\MULTCOMP\CompVar.pas}

const
  MultCompNam = 'COMPANY.DAT';

var
  FCompany:    TCompanyTable = nil;
  CompanyRec:  CompRec;
  CompFile:    Comp_FileDef;

// =============================================================================
// Support routines
// =============================================================================

function CompanyTable: TCompanyTable;
begin
  if (FCompany = nil) then
    FCompany := TCompanyTable.Create;
  Result := FCompany;
end;

// -----------------------------------------------------------------------------

function DelimitedPath(Path: string): string;
begin
  Result := Trim(Path);
  if (Result <> '') then
    Result := IncludeTrailingPathDelimiter(Result);
end;

// -----------------------------------------------------------------------------

function FindCompanyCode(const ForPath: string): string;
begin
  // CJS 2013-10-08 - MRD1.1 - Consumer Support
  // Result := CompanyTable.FindByPath(DelimitedPath(ForPath));
  Result := FindCompanyCodeFromSubFolder(DelimitedPath(ForPath));
end;

// -----------------------------------------------------------------------------

function FindCompany(const ForCode: string; ClientID: Pointer): Integer;
begin
  Result := CompanyTable.FindByCode(ForCode);
end;

// -----------------------------------------------------------------------------

function FindCompanyCodeFromSubFolder(FromPath: string; ClientID: Pointer): string;
{ Given a path which might be a sub-directory off the company directory, this
  routine attempts to find the actual company directory. Returns the company
  code if found, otherwise returns an empty string. }
var
  Code: string;
  CharPos: Integer;
begin
  FromPath := DelimitedPath(FromPath);
  repeat
    { Search for a company matching the path. }
    Code := CompanyTable.FindByPath(FromPath);
    if (Code <> '') then
    begin
      { Found a matching company, return the code. }
      Result := Code;
    end
    else
    begin
      { Remove the last sub-directory from the end of the path. }
      CharPos := Length(FromPath) - 1;
      while (CharPos > 0) do
      begin
        if (FromPath[CharPos] = '\') then
        begin
          FromPath := Copy(FromPath, 1, CharPos);
          break;
        end
        else
          CharPos := CharPos - 1;
      end;
      if (CharPos < 1) then
      begin
        { Run out of path, return blank. }
        Result := '';
        break;
      end;
    end;
  until (Code <> '');

if (Code = '') then
  Log('FindCompanyCodeFromSubFolder: company not found.');
//else
//  Log('FindCompanyCodeFromSubFolder: found company ' + Code);

end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCompanyCacheItem
// =============================================================================

procedure TCompanyCacheItem.SetCode(const Value: string);
begin
  FCode := Value;
end;

// -----------------------------------------------------------------------------

procedure TCompanyCacheItem.SetPath(const Value: string);
begin
  FPath := Value;
end;

// =============================================================================
// TCompanyCache
// =============================================================================

function TCompanyCache.Add(const CompanyCode, Path: string): TCompanyCacheItem;
begin
  Result := TCompanyCacheItem.Create;
  Result.Code := Uppercase(Trim(CompanyCode));
  Result.Path := Uppercase(Trim(CompanyTable.LongPathToShortPath(Path)));
  inherited Add(Result);
end;

// -----------------------------------------------------------------------------

constructor TCompanyCache.Create;
begin
  inherited Create;
end;

// -----------------------------------------------------------------------------

function TCompanyCache.FindByCode(const Code: string): TCompanyCacheItem;
var
  i: Integer;
  SearchFor: string;
begin
  Result := nil;
  SearchFor := Uppercase(Trim(Code));
  for i := 0 to Count - 1 do
  begin
    if (Entries[i].Code = Code) then
    begin
      Result := Entries[i];
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyCache.FindByPath(const Path: string): TCompanyCacheItem;
var
  i: Integer;
  SearchFor: string;
begin
  Result := nil;
  SearchFor := Uppercase(Trim(CompanyTable.LongPathToShortPath(Path)));
  for i := 0 to Count - 1 do
  begin
    if (Entries[i].Path = SearchFor) then
    begin
      Result := Entries[i];
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyCache.GetEntry(index: Integer): TCompanyCacheItem;
begin
  Result := inherited Items[index] as TCompanyCacheItem;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCompanyTable
// =============================================================================

function TCompanyTable.Add(CompanyCode, CompanyName,
  CompanyPath: string; IsDemo: Boolean): Integer;
var
  ID: Integer;
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
begin

Log('TCompanyTable.Add');

  if (EnsureOpen = 0) then
  begin
//Log('TCompanyTable.Add: Creating ID');
    ID := GetUniqueID;
    if (ID <> -1) then
    begin
//Log('TCompanyTable.Add: Adding company record');
      FillChar(CompanyRec, SizeOf(CompanyRec), 0);
      CompanyRec.CompDet.CompId   := ID;
      CompanyRec.RecPFix := 'C';
      CompanyRec.CompDet.CompCode := LJVar(CompanyCode, 6);
      CompanyRec.CompDet.CompName := CompanyName;
      CompanyRec.CompDet.CompDemoData := IsDemo;
      CompanyPath := LongPathToShortPath(DelimitedPath(CompanyPath));
      CompanyRec.CompDet.CompPath := UpcaseStr(LJVar(CompanyPath, 100));

      Result := Add_RecCId(F[FNum], FNum, CompanyRec, KeyPath, FClientID);
//Log('TCompanyTable.Add: Company record added');
    end
    else
      Result := 5;
    Close;
  end
  else
    Result := 3;  // File not open.

//Log('TCompanyTable.Add: ' + IntToStr(Result));

end;

// -----------------------------------------------------------------------------

{ Function to return position of field within a record }
Function TCompanyTable.BKeyPos (Const OfsField, OfsRec : Pointer) : Word;
Var
  OfR, OfF : LongInt;
Begin { BKeyPos }
  OfR := LongInt(OfsRec);
  OfF := LongInt(OfsField);

  If (OfF > OfR) Then
    BKeyPos := (OfF - OfR) + 1
  Else
    BKeyPos := 1;
End;  { BKeyPos }

// -----------------------------------------------------------------------------

function TCompanyTable.Close: Integer;
begin
  Result := Close_FileCId(F[CompF], FClientID);
  FIsOpen := False;
end;

// -----------------------------------------------------------------------------

constructor TCompanyTable.Create;
begin
  inherited Create;

  New(FClientId);
  Prime_ClientIdRec(FClientId^, 'BS', 0);

  FUseCache := True;
  Init;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.Delete(CompanyCode: string): Integer;
var
  KeyS   : Str255;
  FuncRes: LongInt;
const
  FNum             = CompF;
  KeyPath: Integer = CompCodeK;
begin
  if (EnsureOpen = 0) then
  begin
    KeyS := 'C' + LJVar(CompanyCode, 6);
    FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, FClientID);
    if (FuncRes = 0) then
      FuncRes := Delete_RecCId(F[FNum], FNum, KeyPath, FClientID);
    Result := FuncRes;
    Close;
  end
  else
    Result := 3;  // File not open.
end;

// -----------------------------------------------------------------------------

destructor TCompanyTable.Destroy;
begin
  if (FCache <> nil) then
  begin
    FCache.Free;
  end;
  Dispose(FClientId);
  inherited;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.EnsureOpen: LongInt;
var
  FSpec   : FileSpec;
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
begin
  { Try to read the file version number, as a way of checking whether the file
    is open or not. }
Log('Checking Open status for Company Table');
  Result := GetFileSpecCId(F[Fnum],Fnum, FSpec, FClientID);
//  if not IsOpen then
  if (Result = 3) then
  begin
Log('Company Table not open. Opening now');
    Result := Open;
  end
  else
  begin
Log('Company Table already open');
    Result := 0;
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FindByPath(const Path: string): string;
var
  KeyS   : Str255;
  FuncRes: LongInt;
  Company: TCompanyCacheItem;
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
begin

//Log('TCompanyTable.FindByPath: ' + Path);
  Result := '';
  FuncRes := 4;

  if (UseCache) then
    begin
    Company := Cache.FindByPath(Path);
    if (Company <> nil) then
      Result := Company.Code;
  end
  else
  begin
    { Check for path }
    KeyS    := FullCompanyPathKey(cmCompDet, LongPathToShortPath(DelimitedPath(Path)));
    FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, FClientID);
    if (FuncRes = 3) then
    begin
      { Open Company Table and try again. }
      FuncRes := Open;
      if (FuncRes = 0) then
        FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, FClientID)
      else
        Log('Could not open Company Table');
    end;
      if (FuncRes = 0) then
      Result := CompanyRec.CompDet.CompCode;
    end;

  if (Result = '') then
  begin
    // MH 04/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
    Result := UNCCompanyCache.CompanyCodeFromPath(Path);
  end;

  if (Result = '') then
  begin
    Log('TCompanyTable.FindByPath failed for path "' + Path + '", error : ' + IntToStr(FuncRes));
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FindByCode(const Code: string): Integer;
var
  KeyS   : Str255;
const
  FNum             = CompF;
  KeyPath: Integer = CompCodeK;
begin
//Log('TCompanyTable.FindByCode: ' + Code);
  Result := 4;
  if (UseCache) then
  begin
    if (Cache.FindByCode(Code) <> nil) then
      Result := 0;
  end
  else
  begin
    { Check for code }
    KeyS := cmCompDet + UpcaseStr(LJVar(Code, CompCodeLen));
    Result := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, FClientID);
    if (Result = 3) then
    begin
      { Open Company Table and try again. }
      Result := Open;
      if (Result = 0) then
        Result := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, FClientID)
      else
        Log('Could not open Company Table');
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FullCompanyPath(const Path: string): string;
begin
  Result := UpcaseStr(LJVar(Path, CompPathLen));
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FullCompanyPathKey(const Prefix,
  Path: string): string;
begin
  Result := Prefix + FullCompanyPath(Path);
end;

// -----------------------------------------------------------------------------

function TCompanyTable.GetCache: TCompanyCache;
begin
  if (FCache = nil) then
  begin
    FCache := TCompanyCache.Create;
    InitCache;
  end;
  Result := FCache;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.GetIsOpen: Boolean;
begin
  Result := FIsOpen;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.GetUniqueID: Integer;
const
  FNum = CompF;
var
  KeyS      : Str255;
  LStatus   : Smallint;
  TmpComp   : CompRec;
  FKeyPath  : Integer;
  TmpRecAddr: LongInt;
  Unique    : Boolean;
begin
  { Save current position in Company.Dat }
  TmpComp := CompanyRec;
  FKeyPath := GetPosKey;
  LStatus := Presrv_BTPosCId(CompF, FKeyPath, F[FNum], TmpRecAddr, BOff, BOff, FClientID);

  Result := 0;
  Unique := False;
  Randomize;
  while not Unique do
  begin
    Result := Random(99998) + 1;
    Unique := True;
    { Process Company Records }
    LStatus := Find_RecCId(B_StepFirst, F[FNum], FNum, CompanyRec, CompCodeK, KeyS, FClientID);
Log('TCompanyTable.GetUniqueID: First company record:' + CompanyRec.CompDet.CompCode);

    while (LStatus = 0) do
    begin
      // Check it's a Company Record
      if (CompanyRec.RecPFix = cmCompDet) then
      begin
        // If it matches the new ID, we will have to try again.
        if CompanyRec.CompDet.CompID = Result then
        begin
          Unique := False;
          Break;
        end;
      end // If (Company.RecPFix = cmCompDet)
      else if (CompanyRec.RecPFix = cmUserCount) then
      begin
        Break;
      end;
Log('TCompanyTable.GetUniqueID: Stepping to next company record');
      LStatus := Find_RecCId(B_StepNext, F[FNum], FNum, CompanyRec, CompCodeK, KeyS, FClientID);
Log('TCompanyTable.GetUniqueID: Next company record:' + CompanyRec.CompDet.CompCode);
    end; { While (LStatus = 0) }
  end;

  { Restore current position in Company.Dat }
  Presrv_BTPosCId(CompF, FKeyPath, F[FNum], TmpRecAddr, BOn, BOn, FClientID);
  CompanyRec := TmpComp;

end;

// -----------------------------------------------------------------------------

procedure TCompanyTable.Init;
Const
  Idx = CompF;
Begin
  FileSpecLen[Idx] := SizeOf(CompFile);
  FillChar(CompFile, FileSpecLen[Idx],0);

  With CompFile do Begin
    RecLen := Sizeof(CompanyRec);
    PageSize:=DefPageSize3;  //2k
    NumIndex:=CompNofKeys;

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { Index 0 - RecPFix + Company Code  (CompCodeK) }
    KeyBuff[1].KeyPos:=BKeyPos(@CompanyRec.RecPFix, @CompanyRec);
    KeyBuff[1].KeyLen:=1;
    KeyBuff[1].KeyFlags:=ModSeg;
    KeyBuff[2].KeyPos:=BKeyPos(@CompanyRec.CompDet.CompCode, @CompanyRec) + 1;
    KeyBuff[2].KeyLen:=CompCodeLen;
    KeyBuff[2].KeyFlags:=Modfy+AltColSeq;

    { Index 1 - RecPFix + Company Path  (CompPathK) }
    KeyBuff[3].KeyPos:=BKeyPos(@CompanyRec.RecPFix, @CompanyRec);
    KeyBuff[3].KeyLen:=1;
    KeyBuff[3].KeyFlags:=ModSeg;
    KeyBuff[4].KeyPos:=BKeyPos(@CompanyRec.CompDet.CompPath, @CompanyRec) + 1;
    KeyBuff[4].KeyLen:=CompPathLen;
    KeyBuff[4].KeyFlags:=Modfy+AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With..}

  FileRecLen[Idx]:=Sizeof(CompanyRec);

  FillChar(CompanyRec, FileRecLen[Idx],0);

  RecPtr[Idx] := @CompanyRec;

  FileSpecOfs[Idx] := @CompFile;

  FileNames[Idx] := MultCompNam;
end; {..}

// -----------------------------------------------------------------------------

function TCompanyTable.InitCache: Integer;
var
  KeyS   : Str255;
  FuncRes: LongInt;
const
  FNum = CompF;
begin
Log('TCompanyTable.InitCache');
  Result := 0;
  KeyS := '';
  FuncRes := Open;
  if (FuncRes = 0) then
  begin
    FCache.Clear;
    FuncRes := Find_RecCId(B_StepFirst, F[FNum], FNum, CompanyRec, CompCodeK, KeyS, FClientID);
    while (FuncRes = 0) do
    begin
      if (CompanyRec.RecPFix = 'C') then
      begin
        FCache.Add(CompanyRec.CompDet.CompCode, CompanyRec.CompDet.CompPath);
      end;
      FuncRes := Find_RecCId(B_StepNext, F[FNum], FNum, CompanyRec, CompCodeK, KeyS, FClientID);
    end;
    Close;
  end
  else
    Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.LongPathToShortPath(
  const Path: string): string;
var
  LongPath, ShortPath: PChar;
  PLen: SmallInt;
begin
  Result := Trim(Path);
  if (Result <> '') then
  begin
    LongPath  := StrAlloc(250);
    ShortPath := StrAlloc(250);

    StrPCopy (LongPath, Trim(Path));
    PLen := GetShortPathName(LongPath, ShortPath, StrBufSize(ShortPath));
    If (PLen > 0) Then
      Result := Trim(StrPas(ShortPath));

    StrDispose (LongPath);
    StrDispose (ShortPath);
  end;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.Open: LongInt;
begin
  if (SystemPath = '') then
  begin
    Log('TCompanyTable.Open - SystemPath not assigned. Cannot open company table.');
    Result := 3;
    Exit;
  end;

Log('TCompanyTable.Open: Opening Company table');

  Result := Open_FileCId(F[CompF], SystemPath + 'COMPANY.DAT', 0, FClientID);
  if (Result = 0) then
    FIsOpen := True;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.UpdateCache(CompanyCode,
  CompanyPath: string): Integer;
var
  Company: TCompanyCacheItem;
begin
  Company := Cache.FindByCode(CompanyCode);
  if (Company <> nil) then
  begin
    Company.Path := CompanyPath;
    Company.Path := LongPathToShortPath(DelimitedPath(CompanyPath));
    Result := 0;
  end
  else
  begin
    Log('Company not found for "' + CompanyCode + '"');
    Result := 4;
  end;
end;

initialization

finalization

  if (FCompany <> nil) then
  begin
    FCompany.Close;
    FCompany.Free;
  end;

end.
