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
//    function FindByPath(const Path: string): string;
    function FindByPath(const Path: string; ClientID: Pointer = nil): string;
    function Open(ClientID: Pointer = nil): LongInt;
    property IsOpen: Boolean read GetIsOpen;
    property SystemPath: string read FSystemPath write SetSystemPath;
  end;

function CompanyTable: TCompanyTable;
function DelimitedPath(Path: string): string;

function FindCompanyCode(const ForPath: string): string;
function FindCompanyCodeFromSubFolder(FromPath: string; ClientID: Pointer = nil): string;

implementation

uses SysUtils, Windows, Forms, GlobVar, ETStrU,
  StrUtils,
  BtrvU2,
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
  directory if found, otherwise returns an empty string. }
var
  FuncRes: LongInt;
  Code: string;
  CharPos: Integer;
begin
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
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCompanyTable
// =============================================================================

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

function TCompanyTable.EnsureOpen(ClientID: Pointer = nil): LongInt;
begin
//  if not IsOpen then
    Result := CompanyTable.Open(ClientID)
//  else
//    Result := 0;
end;

// -----------------------------------------------------------------------------

function TCompanyTable.FindByPath(const Path: string; ClientID: Pointer): string;
const
  FNum             = CompF;
  KeyPath: Integer = CompPathK;
var
  KeyS   : Str255;
  FuncRes: LongInt;
begin
  Result := '';
  if (EnsureOpen = 0) then
  begin
    { Check for path }
    KeyS    := FullCompanyPathKey(cmCompDet, LongPathToShortPath(DelimitedPath(Path)));
    if (ClientID = nil) then
      FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS)
    else
      FuncRes := Find_RecCId(B_GetEq, F[FNum], FNum, CompanyRec, KeyPath, KeyS, ClientID);
    if (FuncRes = 0) then
      Result := CompanyRec.CompDet.CompCode;
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
  if (ClientID = nil) then
    Result := Open_File(F[CompF], SystemPath + 'COMPANY.DAT', 0)
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
