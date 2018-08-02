unit SQLCompany;
{
  Routines for accessing the Company table through the SQL Emulator.
}
{$ALIGN 1}
{$REALCOMPATIBILITY ON}
interface

uses BtrvU2;

type
  { Class for access to the Company table }
  TCompanyTable = class(TObject)
  private
    FIsInitialised: Boolean;
    FIsOpen: Boolean;
    FClientID: ^ClientIdType;
    function BKeyPos (Const OfsField, OfsRec : Pointer) : Word;
    function EnsureOpen: LongInt;
    function FullCompanyPath(const Path : string) : string;
    function FullCompanyPathKey(const Prefix, Path : string) : string;
    function GetIsOpen: Boolean;
    procedure Init;
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
    function LongPathToShortPath(const Path: string): string;
    function Open: LongInt;
    property IsOpen: Boolean read GetIsOpen;
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
  VarRec2U;

{$I ..\MULTCOMP\CompVar.pas}

const
  MultCompNam = 'COMPANY.DAT';

var
  FCompany:    TCompanyTable;
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
var
  FuncRes: LongInt;
begin

//Log('FindCompanyCode: ' + ForPath);
{
  if not CompanyTable.IsOpen then
  begin
    FuncRes := CompanyTable.Open;
    if (FuncRes <> 0) then
    begin

    end;
  end;
}
  Result := CompanyTable.FindByPath(DelimitedPath(ForPath));
end;

// -----------------------------------------------------------------------------

function FindCompany(const ForCode: string; ClientID: Pointer): Integer;
var
  FuncRes: LongInt;
begin

//Log('FindCompany: ' + ForCode);
{
  if not CompanyTable.IsOpen then
  begin
    FuncRes := CompanyTable.Open;
    if (FuncRes <> 0) then
    begin

    end;
  end;
}
  Result := CompanyTable.FindByCode(ForCode);
end;

// -----------------------------------------------------------------------------

function FindCompanyCodeFromSubFolder(FromPath: string; ClientID: Pointer): string;
{ Given a path which might be a sub-directory off the company directory, this
  routine attempts to find the actual company directory. Returns the company
  code if found, otherwise returns an empty string. }
var
  FuncRes: LongInt;
  Code: string;
  CharPos: Integer;
begin

//Log('FindCompanyCodeFromSubFolder: ' + FromPath);
{
  if not CompanyTable.IsOpen then
  begin
    FuncRes := CompanyTable.Open;
    if (FuncRes <> 0) then
    begin

    end;
  end;
}
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
  Result := Close_File(F[CompF]);
  FIsOpen := False;
end;

// -----------------------------------------------------------------------------

constructor TCompanyTable.Create;
begin
  inherited Create;

  New(FClientId);
  Prime_ClientIdRec(FClientId^, 'BS', 0);

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
  end
  else
    Result := 3;  // File not open.
end;

// -----------------------------------------------------------------------------

destructor TCompanyTable.Destroy;
begin
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
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
begin

//Log('TCompanyTable.FindByPath: ' + Path);

  Result := '';
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
    Result := CompanyRec.CompDet.CompCode
  else
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
//Log('TCompanyTable.GetUniqueID: First company record:' + CompanyRec.CompDet.CompCode);

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
//Log('TCompanyTable.GetUniqueID: Stepping to next company record');
      LStatus := Find_RecCId(B_StepNext, F[FNum], FNum, CompanyRec, CompCodeK, KeyS, FClientID);
//Log('TCompanyTable.GetUniqueID: Next company record:' + CompanyRec.CompDet.CompCode);
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
{
  if not IsInitialised then
  begin
    if (SystemPath = '') then
      SystemPath := ExtractFilePath(Application.ExeName);
    IsInitialised := True;
  end;
}

//Log('TCompanyTable.Open: ' + SystemPath);

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

initialization

finalization

  if (FCompany <> nil) then
  begin
    FCompany.Close;
    FCompany.Free;
  end;

end.
