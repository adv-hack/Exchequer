unit uCrossReference;

interface

uses
  Classes, SysUtils,

  // Exchequer units
  GlobVar,
  BtrvU2,
  uConsts
  ;

const
  CrossRefF          = 17;
  CrossRefNoOfSegs   =  2;
  CrossRefNoOfKeys   =  2;

type
  { Cross-reference file between original OurRef values and the OurRef values
    assigned to imported transactions. Used on import to allow the imported
    Matching records to locate the transactions that they should actually
    refer to. }
  CrossRefRec = record
    OrigRef  : Str10;
    OurRef   : Str10;
  end;

  CrossRef_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..CrossRefNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  TCrossReference = class(TObject)
  private
    FErrorCode: Integer;
    FErrorMsg: string;
  public
    constructor Create(DataPath: string);
    destructor Destroy; override;
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(OrigRef, OurRef: Str10): LongInt;
    function OurRef(ForOrigRef: Str10): Str10;
    property ErrorCode: Integer read FErrorCode;
    property ErrorMsg: string read FErrorMsg;
  end;

var
  CrossRef:     CrossRefRec;
  CrossRefFile: CrossRef_FileDef;

implementation

uses
  ETStrU;

// =============================================================================
// TCrossReference
// =============================================================================

function TCrossReference.Add(OrigRef, OurRef: Str10): LongInt;
var
  Key: Str255;
begin
  FErrorMsg  := '';
  Key := OrigRef;
  Result := Find_Rec(B_GetEq, F[CrossRefF], CrossRefF, CrossRef, 0, Key);
  if ((Result = 4) or (Result = 9)) then
  begin
    FillChar(CrossRef, SizeOf(CrossRef), 0);
    CrossRef.OrigRef := LJVar(OrigRef, 10);
    CrossRef.OurRef  := LJVar(OurRef, 10);
    Result := Add_Rec(F[CrossRefF], CrossRefF, CrossRef, 0);
    if Result <> 0 then
      FErrorMsg := 'Could not save Cross-Reference record';
  end;
  FErrorCode := Result;
end;

// -----------------------------------------------------------------------------

constructor TCrossReference.Create(DataPath: string);
var
  FuncRes: LongInt;
begin
  { Make sure the file exists, and open it }
  FErrorCode := 0;
  FErrorMsg  := '';
  FuncRes := InitFile;
  if (FuncRes = 0) then
    FuncRes := CreateFile(DataPath);
  if (FuncRes = 0) then
  begin
    FuncRes := Open_File(F[CrossRefF], DataPath + FileNames[CrossRefF], 0);
    if (FuncRes <> 0) then
    begin
      FErrorCode := cCONNECTINGDBERROR;
      FErrorMsg  := 'Unable to open Cross-Reference database file';
    end;
  end
  else
  begin
    FErrorCode := cCONNECTINGDBERROR;
    FErrorMsg  := 'Unable to create Cross-Reference database file';
  end;
end;

// -----------------------------------------------------------------------------

function TCrossReference.CreateFile(DataPath: string): LongInt;
const
  Idx = CrossRefF;
begin
  if not FileExists(DataPath + FileNames[Idx]) then
    Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx])
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

destructor TCrossReference.Destroy;
begin
  Close_File(F[CrossRefF]);
  inherited;
end;

// -----------------------------------------------------------------------------

function TCrossReference.InitFile: LongInt;
const
  Idx = CrossRefF;
begin
  Result := 0;
  try
    FillChar(CrossRefFile, FileSpecLen[Idx], 0);
    with CrossRefFile do
    begin
      FileSpecLen[Idx] := Sizeof(CrossRefFile);
      RecLen           := Sizeof(CrossRef);
      PageSize         := DefPageSize;
      NumIndex         := CrossRefNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OrigRef }
      KeyBuff[1].KeyPos   := BtKeyPos(@CrossRef.OrigRef, @CrossRef) + 1;
      KeyBuff[1].KeyLen   := SizeOf(CrossRef.OrigRef) - 1;
      KeyBuff[1].KeyFlags := Modfy;

      { 01 - OurRef }
      KeyBuff[2].KeyPos   := BtKeyPos(@CrossRef.OurRef, @CrossRef) + 1;
      KeyBuff[2].KeyLen   := SizeOf(CrossRef.OurRef) - 1;
      KeyBuff[2].KeyFlags := Modfy;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with CrossRefFile do... }

    FileRecLen[Idx]  := Sizeof(CrossRef);
    RecPtr[Idx]      := @CrossRef;
    FileSpecOfs[Idx] := @CrossRefFile;
    FileNames[Idx]   := 'ICS\XREF.DAT';

    FillChar(CrossRef, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCrossReference.OurRef(ForOrigRef: Str10): Str10;
{ Returns the OurRef stored against the specified Opening Balance Code. Returns
  the original reference if no match can be found. }
var
  Key: Str255;
  FuncRes: LongInt;
begin
  Key := ForOrigRef;
  FuncRes := Find_Rec(B_GetEq, F[CrossRefF], CrossRefF, CrossRef, 0, Key);
  if (FuncRes = 0) then
    Result := CrossRef.OurRef
  else
    Result := ForOrigRef;
end;

// -----------------------------------------------------------------------------

end.

