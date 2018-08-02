unit uHistoryAdjustments;
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
  HistAdjNoOfSegs  =  9;
  HistAdjNoOfKeys  =  2;

  CC_ORDER   = 'C';
  DEPT_ORDER = 'D';
  ANY_ORDER  = ' ';

type
  HistAdjRec = record
    Year:       Byte;
    Currency:   Byte;
    GLCode:     LongInt;
    Order:      Char;
    CostCentre: string[3];
    Department: string[3];
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

  function GLMatchFound(WithGLCode: LongInt; WithCostCentre, WithDepartment: string): Boolean;
  begin
    Result := (HistAdj.GLCode = WithGLCode) and
              (Trim(HistAdj.CostCentre) = WithCostCentre) and
              (Trim(HistAdj.Department) = WithDepartment);
  end;

  function AccountMatchFound(WithAcctCode: string): Boolean;
  begin
    Result := (Trim(HistAdj.AcctCode) = WithAcctCode);
  end;

  function AddGLRecord(GLCode: LongInt; Order: Char; CostCentre,
    Department: string): LongInt;
  begin
    FillChar(HistAdj, SizeOf(HistAdj), 0);
    HistAdj.Year       := Id.PYr;
    HistAdj.Currency   := Id.Currency;
    HistAdj.GLCode     := GLCode;
    HistAdj.Order      := Order;
    HistAdj.CostCentre := FullCCDepKey(CostCentre);
    HistAdj.Department := FullCCDepKey(Department);
    HistAdj.AcctCode   := FullCustCode('');
    Result := Add_Rec(F[HistAdjF], HistAdjF, HistAdj, 0);
  end;

  function AddAccountRecord(AcctCode: string): LongInt;
  begin
    FillChar(HistAdj, SizeOf(HistAdj), 0);
    HistAdj.Year       := Id.PYr;
    HistAdj.Currency   := Id.Currency;
    HistAdj.GLCode     := 0;
    HistAdj.Order      := ANY_ORDER;
    HistAdj.CostCentre := FullCCDepKey('');
    HistAdj.Department := FullCCDepKey('');
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

  function UpdateGL(GLCode: LongInt; Order: Char; CostCentre,
    Department: string): LongInt;
  var
    Key: Str255;
  begin
    Key  := Chr(Id.PYr) + Chr(Id.Currency) +
            FullNomKey(Id.NomCode) +
            Order +
            FullCCDepKey(CostCentre) +
            FullCCDepKey(Department);
    { Look for a matching record }
    Result := Find_Rec(B_GetGEq, F[HistAdjF], HistAdjF, HistAdj, 0, Key);
    { Add a new record if required }
    if not ((Result = 0) and GLMatchFound(GLCode, CostCentre, Department)) then
      Result := AddGLRecord(GLCode, Order, CostCentre, Department);
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
  { Update BaseKey + G/L Code }
  Result := UpdateGL(Id.NomCode, ANY_ORDER, '', '');

  if (Result = 0) then
    { Update BaseKey + G/L Code + Cost Centre }
    Result := UpdateGL(Id.NomCode, CC_ORDER, Id.CCDep[True], '');

  if (Result = 0) then
    { Update BaseKey + G/L Code + Cost Centre + Department }
    Result := UpdateGL(Id.NomCode, CC_ORDER, Id.CCDep[True], Id.CCDep[False]);

  if (Result = 0) then
    { Update BaseKey + G/L Code + Department }
    Result := UpdateGL(Id.NomCode, DEPT_ORDER, Id.CCDep[False], '');

  if (Result = 0) then
    { Update BaseKey + G/L Code + Department + Cost Centre }
    Result := UpdateGL(Id.NomCode, DEPT_ORDER, Id.CCDep[False], Id.CCDep[True]);

  if (Result = 0) then
    { Update BaseKey + Customer/Supplier }
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

      { 00 - Year + Currency + GLCode + Order + CostCentre + Department }
      KeyBuff[1].KeyPos     := BtKeyPos(@HistAdj.Year, @HistAdj);
      KeyBuff[1].KeyLen     := SizeOf(HistAdj.Year);
      KeyBuff[1].KeyFlags   := ModSeg;

      KeyBuff[2].KeyPos    := BtKeyPos(@HistAdj.Currency, @HistAdj);
      KeyBuff[2].KeyLen    := SizeOf(HistAdj.Currency);
      KeyBuff[2].KeyFlags  := ModSeg;

      KeyBuff[3].KeyPos     := BtKeyPos(@HistAdj.GLCode, @HistAdj);
      KeyBuff[3].KeyLen     := SizeOf(HistAdj.GLCode);
      KeyBuff[3].KeyFlags   := ModSeg + ExtType;
      KeyBuff[3].ExtTypeVal := BInteger;

      KeyBuff[4].KeyPos    := BtKeyPos(@HistAdj.Order, @HistAdj);
      KeyBuff[4].KeyLen    := SizeOf(HistAdj.Order);
      KeyBuff[4].KeyFlags  := ModSeg;

      KeyBuff[5].KeyPos    := BtKeyPos(@HistAdj.CostCentre, @HistAdj) + 1;
      KeyBuff[5].KeyLen    := SizeOf(HistAdj.CostCentre) - 1;
      KeyBuff[5].KeyFlags  := ModSeg;

      KeyBuff[6].KeyPos    := BtKeyPos(@HistAdj.Department, @HistAdj) + 1;
      KeyBuff[6].KeyLen    := SizeOf(HistAdj.Department) - 1;
      KeyBuff[6].KeyFlags  := Modfy;

      { 01 - Year + Currency + AcctCode }
      KeyBuff[7].KeyPos     := BtKeyPos(@HistAdj.Year, @HistAdj);
      KeyBuff[7].KeyLen     := SizeOf(HistAdj.Year);
      KeyBuff[7].KeyFlags   := DupModSeg;

      KeyBuff[8].KeyPos    := BtKeyPos(@HistAdj.Currency, @HistAdj);
      KeyBuff[8].KeyLen    := SizeOf(HistAdj.Currency);
      KeyBuff[8].KeyFlags  := DupModSeg;

      KeyBuff[9].KeyPos    := BtKeyPos(@HistAdj.AcctCode, @HistAdj) + 1;
      KeyBuff[9].KeyLen    := SizeOf(HistAdj.AcctCode) - 1;
      KeyBuff[9].KeyFlags  := DupMod;

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

  procedure ParseHistoryCode(var GLCode: LongInt; var Order: Char;
    var CostCentre, Department, AcctCode: string);
  { The nominal code, cost centre, department, and customer/supplier codes are
    buried inside NHist.Code, and do not appear anywhere else in the record. The
    actual position within the code varies according to the type of history
    record. This function parses the code, and extracts the values from it. }
  begin
    GLCode     := 0;
    CostCentre := '';
    Department := '';
    AcctCode   := '';
    Order      := ' ';
    if (not (NHist.ExCLass in ['U', 'V', 'W', 'E'])) then
    begin
      if IsCCDept then
      begin
        Move(NHist.Code[2], GLCode, SizeOf(GLCode) - 1);
        if (NHist.Code[1] = 'C') then
        begin
          CostCentre := Copy(NHist.Code, 6, 3);
          Department := Copy(NHist.Code, 10, 3);
          Order      := 'C';
        end
        else
        begin
          Department := Copy(NHist.Code, 6, 3);
          CostCentre := Copy(NHist.Code, 10, 3);
          Order      := 'D';
        end;
      end
      else
      begin
        Move(NHist.Code[1], GLCode, SizeOf(GLCode));
      end;
    end
    else
    begin
      AcctCode := Copy(NHist.Code, 1, 6);
    end;
  end;

var
  Key: Str255;
  GLCode: LongInt;
  Order: Char;
  CostCentre, Department, AcctCode: string;
  FuncRes: LongInt;
begin
  { Extract the details from the History code, and use them to build a search
    key }
  ParseHistoryCode(GLCode, Order, CostCentre, Department, AcctCode);
  Key := Chr(NHist.Yr) + Chr(NHist.Cr) +
         FullNomKey(GLCode) +
         Order +
         FullCCDepKey(CostCentre) +
         FullCCDepKey(Department);

  { Locate a matching Adjustments record }
  FuncRes := Find_Rec(B_GetEq, F[HistAdjF], HistAdjF, HistAdj, 0, Key);

  if (FuncRes = 0) then
  begin
    { Update the values }
    NHist.Sales     := NHist.Sales - HistAdj.Sales;
    NHist.Purchases := NHist.Purchases - HistAdj.Purchases;
  end;

  Result := FuncRes;
end;

end.
