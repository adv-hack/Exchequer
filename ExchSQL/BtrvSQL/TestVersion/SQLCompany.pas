unit SQLCompany;
{
  Routines for accessing the Company table through the SQL Emulator.
}
{$ALIGN 1}
{$REALCOMPATIBILITY ON}
interface

type
  { Class for access to the Company table }
  TCompanyTable = class(TObject)
  private
    FIsInitialised: Boolean;
    FIsOpen: Boolean;
    FSystemPath: string;
    function BKeyPos (Const OfsField, OfsRec : Pointer) : Word;
    function EnsureOpen(ClientID: Pointer = nil): LongInt;
    function FullCompanyPath(const Path : string) : string;
    function FullCompanyPathKey(const Prefix, Path : string) : string;
    function GetIsOpen: Boolean;
    procedure Init;
    function LongPathToShortPath(const Path: string): string;
    procedure SetSystemPath(const Value: string);
    property IsInitialised: Boolean read FIsInitialised write FIsInitialised;
  public
    constructor Create;
    function Add(CompanyCode, CompanyName, CompanyPath: string; IsDemo: Boolean): Integer;
    function Delete(CompanyCode: string; ClientID: Pointer = nil): Integer;
    function FindByPath(const Path: string; ClientID: Pointer = nil): string;
    function GetUniqueID: Integer;
    function Open(ClientID: Pointer = nil): LongInt;
    property IsOpen: Boolean read GetIsOpen;
    property SystemPath: string read FSystemPath write SetSystemPath;
  end;

function CompanyTable: TCompanyTable;
function DelimitedPath(Path: string): string;

function FindCompanyCode(const ForPath: string): string;
function FindCompanyCodeFromSubFolder(FromPath: string; ClientID: Pointer = nil): string;

implementation

uses SysUtils, Windows, Forms, Dialogs,
  GlobVar,
  ETStrU,
  PathUtil,
  StrUtils,
  BtrvU2,
{$IFDEF DEBUGON}
  DebugLogU,
{$ENDIF}
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
  if not CompanyTable.IsOpen then
  begin
    FuncRes := CompanyTable.Open;
    if (FuncRes <> 0) then
    begin

    end;
  end;
  Result := CompanyTable.FindByPath(DelimitedPath(ForPath));
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
{$IFDEF DEBUGON}
Log('FindCompanyCodeFromSubFolder: "' + FromPath + '"');
{$ENDIF}
  if not CompanyTable.IsOpen then
  begin
    FuncRes := CompanyTable.Open;
    if (FuncRes <> 0) then
    begin

    end;
  end;
  FromPath := DelimitedPath(FromPath);
  repeat
    { Search for a company matching the path. }
    Code := CompanyTable.FindByPath(FromPath, ClientID);
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
{$IFDEF DEBUGON}
if (Code = '') then
  Log('FindCompanyCodeFromSubFolder: company not found.')
else
  Log('FindCompanyCodeFromSubFolder: found company "' + Code + '"');
{$ENDIF}
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
  if (EnsureOpen = 0) then
  begin
    ID := GetUniqueID;
    FillChar(CompanyRec, SizeOf(CompanyRec), 0);
    CompanyRec.CompDet.CompId   := ID;
    CompanyRec.RecPFix := 'C';
    CompanyRec.CompDet.CompCode := LJVar(CompanyCode, 6);
    CompanyRec.CompDet.CompName := CompanyName;
    CompanyRec.CompDet.CompDemoData := IsDemo;
    CompanyPath := LongPathToShortPath(DelimitedPath(CompanyPath));
    CompanyRec.CompDet.CompPath := UpcaseStr(LJVar(CompanyPath, 100));

    Result := Add_Rec(F[FNum], FNum, CompanyRec, KeyPath);

{ TODO: Remove this SQL Emulator workaround. }
if (Result = 999) then
  Result := 0;

  end
  else
    Result := 3;  // File not open.

{$IFDEF DEBUGON}
Log('TCompanyTable.Add: ' + IntToStr(Result));
{$ENDIF}

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

constructor TCompanyTable.Create;
begin
  inherited Create;
  Init;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.Delete(CompanyCode: string; ClientID: Pointer): Integer;
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
    if (ClientID = nil) then
      FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS)
    else
      FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, ClientID);
    if (FuncRes = 0) then
    begin
      if (ClientID = nil) then
        FuncRes := Delete_Rec(F[FNum], FNum, KeyPath)
      else
        FuncRes := Delete_RecCId(F[FNum], FNum, KeyPath, ClientID);
    end;
    Result := FuncRes;
  end
  else
    Result := 3;  // File not open.
end;

// -----------------------------------------------------------------------------

function TCompanyTable.EnsureOpen(ClientID: Pointer = nil): LongInt;
begin
//  if not IsOpen then
    Result := CompanyTable.Open(ClientID)
//  else
//    Result := 0;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FindByPath(const Path: string; ClientID: Pointer): string;
var
  KeyS   : Str255;
  FuncRes: LongInt;
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
begin
{$IFDEF DEBUGON}
Log('TCompanyTable.FindByPath: "' + Path + '"');
{$ENDIF}

  Result := '';
  FuncRes := EnsureOpen;
  if (FuncRes = 0) then
  begin
    { Check for path }
    KeyS    := FullCompanyPathKey(cmCompDet, LongPathToShortPath(DelimitedPath(Path)));
    if (ClientID = nil) then
      FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS)
    else
      FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, ClientID);
    if (FuncRes = 0) then
      Result := CompanyRec.CompDet.CompCode
    else
    begin
      ShowMessage('Failed to find company for ' + Path + ', error ' + IntToStr(FuncRes));
{$IFDEF DEBUGON}
Log('TCompanyTable.FindByPath failed: ' + IntToStr(FuncRes));
{$ENDIF}
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
  Presrv_BTPos(CompF, FKeyPath, F[CompF], TmpRecAddr, BOff, BOff);

  Result := 0;
  Unique := False;
  Randomize;
  while not Unique do
  begin
    Result := Random(99998) + 1;
    Unique := True;
    { Process Company Records }
    LStatus := Find_Rec(B_StepFirst, F[FNum], FNum, CompanyRec, CompCodeK, KeyS);
    while (LStatus = 0) do
    begin
      // Check its a Company Record
      if (CompanyRec.RecPFix = cmCompDet) then
      begin
        // If it matches the new ID, we will have to try again.
        if CompanyRec.CompDet.CompID = Result then
        begin
          Unique := False;
          Break;
        end;
      end; // If (Company.RecPFix = cmCompDet)
      LStatus := Find_Rec(B_StepNext, F[FNum], FNum, CompanyRec, CompCodeK, KeyS);
    end; { While (LStatus = 0) }
  end;

  { Save current position in Company.Dat }
  Presrv_BTPos(CompF, FKeyPath, F[CompF], TmpRecAddr, BOn, BOff);
  Status := GetDirect(F[CompF], CompF, CompanyRec, FKeyPath, 0); {* Re-Establish Position *}
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

function TCompanyTable.Open(ClientID: Pointer = nil): LongInt;
begin
  if not IsInitialised then
  begin
    SystemPath := ExtractFilePath(Application.ExeName);
    IsInitialised := True;
  end;
{$IFDEF DEBUGON}
Log('TCompanyTable.Open: ' + SystemPath);
{$ENDIF}
  if (ClientID = nil) then
  begin
    Result := Open_File(F[CompF], SystemPath + 'COMPANY.DAT', 0);
  end
  else
    Result := Open_FileCId(F[CompF], SystemPath + 'COMPANY.DAT', 0, ClientID);
  if (Result = 0) then
    FIsOpen := True;
end;

// -----------------------------------------------------------------------------

procedure TCompanyTable.SetSystemPath(const Value: string);
begin
  FSystemPath := Value;
end;

initialization

finalization

  if (FCompany <> nil) then
  begin
    Close_File(F[CompF]);
    FCompany.Free;
  end;

end.
