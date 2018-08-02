unit uHistoryAdjustments;
{ THIS UNIT IS NOW OBSOLETE }
{
  THistoryAdjustments is a class for finding and storing the details of
  outstanding transactions, and is used by the History export to adjust the
  values of exported Year-To-Date figures so that they do not include values
  from outstanding transactions.
}
interface

uses
  Classes, SysUtils,
  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
  ComnUnit,
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb;

const
  HistAdjF         = 22;
  HistAdjNoOfSegs  =  6;
  HistAdjNoOfKeys  =  2;

type
  HistAdjRec = record
    Year:       Byte;
    Currency:   Byte;
    GLCode:     LongInt;
    AcctCode:   Str10;
    Sales:      Double;
    Purchases:  Double;
    Budget:     Double;
    Budget2:    Double;
  end;

  HistAdj_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..HistAdjNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  HistAdj:          HistAdjRec;
  HistAdjFile:      HistAdj_FileDef;

type
  THistoryAdjustments = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add: LongInt;
    function UpdateHistory: LongInt;
  end;

implementation

uses
  BtKeys1U
  ;

{ THistoryAdjustments }

function THistoryAdjustments.Add: LongInt;
{ Adds a new entry (provided one does not already exist) using the details from
  the current Idetail record. Returns a Btrieve result code. }

  function GLMatchFound(WithGLCode: LongInt): Boolean;
  begin
    Result := (HistAdj.GLCode = WithGLCode);
  end;

  function AccountMatchFound(WithAcctCode: string): Boolean;
  begin
    Result := (Trim(HistAdj.AcctCode) = WithAcctCode);
  end;

  function AddGLRecord(GLCode: LongInt): LongInt;
  begin
    FillChar(HistAdj, SizeOf(HistAdj), 0);
    HistAdj.Year       := Id.PYr;
    HistAdj.Currency   := Id.Currency;
    HistAdj.GLCode     := GLCode;
    HistAdj.AcctCode   := FullCustCode('');
    Result := Add_Rec(F[HistAdjF], HistAdjF, HistAdj, 0);
  end;

  function AddAccountRecord(AcctCode: string): LongInt;
  begin
    FillChar(HistAdj, SizeOf(HistAdj), 0);
    HistAdj.Year       := Id.PYr;
    HistAdj.Currency   := Id.Currency;
    HistAdj.GLCode     := 0;
    HistAdj.AcctCode   := FullCustCode(AcctCode);
    Result := Add_Rec(F[HistAdjF], HistAdjF, HistAdj, 0);
  end;

  function UpdateFigures: LongInt;
  begin
    if Id.IdDocHed in [SIN] then
      HistAdj.Sales := HistAdj.Sales + Id.NetValue
    else if Id.IdDocHed in [PIN] then
      HistAdj.Purchases := HistAdj.Purchases + Id.NetValue;
    Result := Put_Rec(F[HistAdjF], HistAdjF, HistAdj, 0);
  end;

  function UpdateGL(GLCode: LongInt): LongInt;
  var
    Key: Str255;
  begin
    Key  := Chr(Id.PYr) + Chr(Id.Currency) +
            FullNomKey(Id.NomCode);
    { Look for a matching record }
    Result := Find_Rec(B_GetGEq, F[HistAdjF], HistAdjF, HistAdj, 0, Key);
    { Add a new record if required }
    if not ((Result = 0) and GLMatchFound(GLCode)) then
      Result := AddGLRecord(GLCode);
    { Update the figures }
    if (Result = 0) then
      Result := UpdateFigures;
  end;

  function UpdateAccount(AcctCode: string): LongInt;
  var
    Key: Str255;
  begin
    Key := Chr(Id.PYr) + Chr(Id.Currency) +
           FullCustCode(AcctCode);
    { Look for a matching record }
    Result := Find_Rec(B_GetEq, F[HistAdjF], HistAdjF, HistAdj, 1, Key);
    { Add a new record if required }
    if not ((Result = 0) and AccountMatchFound(AcctCode)) then
      Result := AddAccountRecord(AcctCode);
    { Update the figures }
    if (Result = 0) then
      UpdateFigures;
  end;

begin
  { Update G/L Code }
  Result := UpdateGL(Id.NomCode);

  if (Result = 0) then
    { Update Customer/Supplier }
    Result := UpdateAccount(Id.CustCode);
end;

function THistoryAdjustments.CreateFile(DataPath: string): LongInt;
const
  Idx = HistAdjF;
begin
  { Delete any existing copy of the file }
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);
  { Create a new file }
  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

function THistoryAdjustments.InitFile: LongInt;
{ Initialises the file and indexes. Returns 0 if successful, otherwise
  returns 255. }
const
  Idx = HistAdjF;
begin
  Result := 0;
  try
    FillChar(HistAdjFile, FileSpecLen[Idx], 0);
    with HistAdjFile do
    begin
      FileSpecLen[Idx] := Sizeof(HistAdjFile);
      RecLen           := Sizeof(HistAdj);
      PageSize         := DefPageSize;
      NumIndex         := HistAdjNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - Year + Currency + GLCode }
      KeyBuff[1].KeyPos     := BtKeyPos(@HistAdj.Year, @HistAdj);
      KeyBuff[1].KeyLen     := SizeOf(HistAdj.Year);
      KeyBuff[1].KeyFlags   := ModSeg;

      KeyBuff[2].KeyPos    := BtKeyPos(@HistAdj.Currency, @HistAdj);
      KeyBuff[2].KeyLen    := SizeOf(HistAdj.Currency);
      KeyBuff[2].KeyFlags  := ModSeg;

      KeyBuff[3].KeyPos     := BtKeyPos(@HistAdj.GLCode, @HistAdj);
      KeyBuff[3].KeyLen     := SizeOf(HistAdj.GLCode);
      KeyBuff[3].KeyFlags   := Modfy + ExtType;
      KeyBuff[3].ExtTypeVal := BInteger;

      { 01 - Year + Currency + AcctCode }
      KeyBuff[4].KeyPos     := BtKeyPos(@HistAdj.Year, @HistAdj);
      KeyBuff[4].KeyLen     := SizeOf(HistAdj.Year);
      KeyBuff[4].KeyFlags   := ModSeg;

      KeyBuff[5].KeyPos    := BtKeyPos(@HistAdj.Currency, @HistAdj);
      KeyBuff[5].KeyLen    := SizeOf(HistAdj.Currency);
      KeyBuff[5].KeyFlags  := ModSeg;

      KeyBuff[6].KeyPos    := BtKeyPos(@HistAdj.AcctCode, @HistAdj) + 1;
      KeyBuff[6].KeyLen    := SizeOf(HistAdj.AcctCode) - 1;
      KeyBuff[6].KeyFlags  := Modfy;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with HistAdjFile do... }

    FileRecLen[Idx]  := Sizeof(HistAdj);
    RecPtr[Idx]      := @HistAdj;
    FileSpecOfs[Idx] := @HistAdjFile;
    FileNames[Idx]   := 'SWAP\HISTADJ.DAT';

    FillChar(HistAdj, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

function THistoryAdjustments.UpdateHistory: LongInt;
{ Updates the values in the current NHist record }

  function IsCCDept: Boolean;
  begin
    Result:=(NHist.Code[6]>#32) or (NHist.Code[7]>#32) or (NHist.Code[8]>#32);
  end;

  procedure ParseHistoryCode(var GLCode: LongInt; AcctCode: string);
  { The nominal and customer/supplier codes are buried inside NHist.Code, and
    do not appear anywhere else in the record. The actual position within the
    code varies according to the type of history record. This function parses
    the code, and extracts the values from it. }
  begin
    GLCode     := 0;
    AcctCode   := '';
    if (not (NHist.ExCLass in ['U', 'V', 'W', 'E'])) then
    begin
      if IsCCDept then
        Move(NHist.Code[2], GLCode, SizeOf(GLCode) - 1)
      else
        Move(NHist.Code[1], GLCode, SizeOf(GLCode));
    end
    else
    begin
      AcctCode := Copy(NHist.Code, 1, 6);
    end;
  end;

var
  Key: Str255;
  GLCode: LongInt;
  AcctCode: string;
  FuncRes: LongInt;
  Idx: Integer;
begin
  { Extract the details from the History code, and use them to build a search
    key }
  ParseHistoryCode(GLCode, AcctCode);

  if (NHist.ExCLass in ['U', 'V', 'W', 'E']) then
  begin
    Key := Chr(Id.PYr) + Chr(Id.Currency) +
           FullCustCode(AcctCode);
    Idx := 1;
  end
  else
  begin
    Key := Chr(NHist.Yr) + Chr(NHist.Cr) +
           FullNomKey(GLCode);
    Idx := 0;
  end;

  { Locate a matching Adjustments record }
  FuncRes := Find_Rec(B_GetEq, F[HistAdjF], HistAdjF, HistAdj, Idx, Key);

  if (FuncRes = 0) then
  begin
    { Update the values }
    NHist.Sales     := NHist.Sales - HistAdj.Sales;
    NHist.Purchases := NHist.Purchases - HistAdj.Purchases;
  end;

  Result := FuncRes;
end;

end.
