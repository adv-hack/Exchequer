unit TDBAClass;

{******************************************************************************}
{     The DBA is responsible for writing records to the Exchequer database.    }
{    It is the only part of Importer which contains Exchequer-specific code... }
{    ..........(apart from TImportToolkitClass)                                }
{******************************************************************************}

interface

uses GlobalTypes, GlobalConsts, Enterprise01_TLB, CTKUtil, TImportToolkitClass, dialogs, DLLTH_UP, ETDateU, Contnrs,
     Classes, Calcwrap, MiscFunc;

type
  TDBA = class(TObject)
  private
{* internal fields *}
    FBatchTHRec:        TManagedRec;
//    FBatchLinesRec:     TBatchLinesRec;
    FBatchLinesRec:     array{[1..MAX_TRANS_LINES]} of TBatchTLRec; // v.084
    FHighFileNo:        integer;
    FLineCount:         integer;
    FOutputRec:         PManagedRec;
    FPrevKeyFields:     array[0..19] of char;
    FTH:                TBatchTHRec;
    FTransCached:       boolean;

    FAVTransCached:     boolean;
    FBatchAVHRec:       TManagedRec;
    FBatchAVLinesRec:   TArrayOfManagedRec; // array[1..MAX_TRANS_LINES] of TManagedRec;
    FAVLineCount:       integer;

    FBOMParentStockRec: TBatchSKRec; //SSK 23/09/2016 2016-R3 ABSEXCH-15502: FBOMParentStockRec - unit level variable declared to avoid multiple db call
{* property fields *}
    FCurrencyVarianceCount: integer;
    FTHCount:               integer;
    FNomCurrencyVarianceTolerance: double;
    FIncrementErrorCount : TNotifyEvent;
{* procedural methods *}
    function  CloseTheToolkit: smallint;
    function  StockCodeFolioNum(AStockCode: string): Longint;
    function  OpenTheToolkit: smallint;
    function  ValidRecord: boolean;
    function  ValidCD: boolean;
    function  ValidCU: boolean;
    function  ValidDM: boolean;
    function  ValidSU: boolean;
    function  ValidGL: boolean;
    function  ValidSK: boolean;
    function  ValidTH: boolean;
    function  ValidTL: boolean;
    function  ValidBR: boolean;
    function  ValidBM: boolean;
    function  ValidNP: boolean;
    function  ValidML: boolean;
    function  ValidSL: boolean;
    function  ValidMA: boolean;
    function  ValidJR: boolean;
    function  ValidEM: boolean;
    function  ValidJA: boolean;
    function  ValidJC: boolean;
    function  ValidAS: boolean;
    function  ValidMB: boolean;
    function  ValidSN: boolean;
    function  WriteToExchequer: integer;
    function  WriteTransToExchequer: smallint;
    function  WriteAVTransToExchequer: smallint;
{* getters and setters *}
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
    procedure UpdateHeaderTotals(const TL: TBatchTLRec);
    procedure SetHighFileNo(const Value: integer);
    procedure SetNomCurrencyVarianceTolerance(const Value: double);
    function StockCodeDesc(AStockCode: string): string;
    function StockCodeVATCode(AStockCode: string): char;
    function StockCodeNomCode(AStockCode: string; ACode: integer): integer;
    function ProcessBatchSerialDetails: integer;
    function AddBatchSerialRecords: integer;
    function FindAndUseBatchRecords(const AStockCode, ABatchNo: string; AQtyReqd: double; ArrayLineNo: integer; UseBatches: boolean): integer;
    function UseBatchSerialRecords: integer;
    function FindAndUseSerialRecords(const AStockCode, ASerialNo: string;
      ArrayLineNo: integer; UseSerialNos: boolean): integer;
    procedure ResizeArray(ElementCount: integer);

    procedure ExplodeBOMLines; //SSK 14/09/2016 2016-R3 ABSEXCH-15502: ExplodeBOMLines - explode BOM Components as transaction lines; StockCodeType - return stock code type
    procedure ImportDefaultLineValues(var TL : TBatchTLRec); //SSK 22/09/2016 2016-R3 ABSEXCH-15502: ImportDefaultLineValues - implements TL for BOM component to get right GL Code
    function IsExplodeBOM(AStockCode: string): Boolean;     //SSK 26/09/2016 2016-R3 ABSEXCH-15502: IsExplodeBOM - check for the BOM stock to be exploded

  public
    constructor create;
    destructor destroy; override;
    procedure  ClearTotals;
    function  FlushRecords: smallint;
    function  WriteRecord(var OutputRec: TManagedRec): smallint;
    property  CurrencyVarianceCount: integer read FCurrencyVarianceCount;
    property  HighFileNo: integer read FHighFileNo write SetHighFileNo;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
    property  THCount: integer read FTHCount;
    property  IncrementErrorCount : TNotifyEvent read FIncrementErrorCount write FIncrementErrorCount;
{* Import Options *}
    property  NomCurrencyVarianceTolerance: double read FNomCurrencyVarianceTolerance write SetNomCurrencyVarianceTolerance;
  end;

implementation

uses sysutils, TLoggerClass, TErrors, Utils, DLLErrU, etMiscU, VarRec2U, CurrncyU, Comnu2, MultiBuyFuncs, VarConst;

{$I EXDLLBT.INC}

{ TDBA }

constructor TDBA.create;
begin
  inherited;
  SetLength(FBatchAVLinesRec, MAX_TRANS_LINES);
  SetLength(FBatchLinesRec, 1000);  //PR: 27/05/2010 Change to set length initially and only resize if necessary to avoid memory leak.
end;

destructor TDBA.destroy;
begin
  ImportToolkit.CloseImportToolkit;
  Finalize(FBatchLinesRec); //PR: 27/05/2010
  inherited;
end;

{* procedural methods *}

procedure TDBA.ResizeArray(ElementCount: integer); // v.084
// the dynamic array is resized in chunks of 1000 records.
// If we only allocate one element at a time, transactions with 1000s of detail lines generate an "out of memory" exception because the
// memory block containing the array gets massively fragmented and there isn't a big enough contiguous block of memory to hold the resized array.
begin
  ElementCount := ((ElementCount div 1000) + 1) * 1000;
  if length(FBatchLinesRec) < ElementCount then
  try
    SetLength(FBatchLinesRec, ElementCount);
  except on EOutOfMemory do begin
    MessageDlg('Out of Memory', mtInformation, [mbOK], 0);
    raise;
  end;
  end;
end;

procedure TDBA.ClearTotals;
begin
  FTHCount := 0;
  FCurrencyVarianceCount := 0;
  FillChar(FPrevKeyFields, SizeOf(FPrevKeyFields), #0);
end;

function TDBA.CloseTheToolkit: smallint;
begin
  result := ImportToolkit.CloseImportToolkit;
end;

function TDBA.WriteRecord(var OutputRec: TManagedRec): smallint;
// TH's and TL's are always cached to FBatchTHRec and the FBatchLinesRec array.
// All other records are operated on via the FOutputRec pointer.
// The RL record type allows for several TL's with the same LinkRef to be
// associated with one TH. In reality, a TH gets generated for each but with the
// same Key Fields. If we've cached a TH below, the next TH doesn't trigger a
// write to Exchequer of the TH/TL's if the TH has the same Key Fields as the
// previous one.
// 10/2006: Apps and Vals work in the same way as TH's and TL's: ST, CT, PT, SA and PA
// record types are cached like TH's. ST, CT and PT headers can be followed by BB, DD and RR
// transaction lines.
var
  rc: smallint;
  FileMsg: string;
begin
  result := -1;

  FOutputRec := @OutputRec; // store so we can use OutputRec in ValidRec etc.

  with ImportToolkit do
    if not itToolkitOpen then begin
      rc := OpenTheToolkit;
      if rc <> 0 then begin
        result := abs(rc) * -1; // make sure we have a negative return code
        EXIT;
      end;
    end;

  if (OutputRec.RecordType = 'TH') then begin
    result := 0;
    if FTransCached then
      if string(OutputRec.KeyFields) <> string(FPrevKeyFields) then
        result := WriteTransToExchequer; // write the cached records first
//    if result >= 0 then   // 23/02/2006: can't let problem with storing previous TH/TL set prevent us from caching the next TH
    if ValidRecord then begin
      if string(OutputRec.KeyFields) <> string(FPrevKeyFields) then // v.061
        if OutputRec.RecordType <> OutputRec.OrigRecType then // v.061
          inc(FTHCount); // TH must have been generated from an RL or OL record // v.061
      FBatchTHRec := OutputRec; // copy/cache the record
      FTransCached := true;
      Move(OutputRec.KeyFields[0], FPrevKeyFields[0], SizeOf(OutputRec.KeyFields)); // copy the key fields
    end
    else
      result := -1;
    EXIT;
  end;

  if (OutputRec.RecordType = 'TL') then begin
    if not FTransCached then begin // TH's and TL's out of sequence
      if FHighFileNo <> FOutputRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
        //PR: 09/03/2012 Changed to use FOutputRec.FileNo as FBatchAVHRec is the wrong record, and isn't populated here.
        FileMsg := format('File %d Row ', [FOutputRec.FileNo]);
      Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FOutputRec.RecNo, 99004, 'Transaction line not preceded by Transaction header']));
      result := -1;
    end
    else begin
      //PR: 09/03/2012 ABSEXCH-12141 Wasn't checking that the line belonged to the cached transaction,
      //so check that LinkRef is the same as the header LinkRef.
      if Copy(OutputRec.KeyFields, 1, 10) = Copy(FPrevKeyFields, 1, 10) then
      begin
        inc(FLineCount);   // cache the transaction line
        ResizeArray(FLineCount); // v.084
        FBatchLinesRec[FLineCount - 1] := OutputRec.ExchequerRec.BatchTLRec; // v.084
        result := 0;
      end
      else
      begin
        FileMsg := format('File %d Row ', [FOutputRec.FileNo]);
        Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FOutputRec.RecNo, 99005, 'No transaction header with Link Ref ' + Copy(OutputRec.KeyFields, 1, 10)]));
        result := -1;
      end;
    end;
    EXIT;
  end;

  if (OutputRec.RecordType = 'ST') or (OutputRec.RecordType = 'CT') or (OutputRec.RecordType = 'PT')
  or (OutputRec.RecordType = 'SA') or (OutputRec.RecordType = 'PA') then begin
    result := 0;
    if FAVTransCached then
      result := WriteAVTransToExchequer;
    if ValidRecord then begin
      FBatchAVHRec := OutputRec; // copy/cache the record
      FAVTransCached := true;
    end
    else
      result := -1;
    EXIT;
  end;

  if (OutputRec.RecordType = 'DD') or (OutputRec.RecordType = 'RR') or (OutputRec.RecordType = 'BB') then begin
    if not FAVTransCached then begin  // records out of sequence
      if FHighFileNo <> FOutputRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
        FileMsg := format('File %d Row ', [FBatchAVHRec.FileNo]);
      Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FOutputRec.RecNo, 99003, 'Terms line not preceded by Terms header']));
      result := -1;
    end
    else begin
      inc(FAVLineCount);
      FBatchAVLinesRec[FAVLineCount] := OutputRec;
      result := 0;
    end;
    EXIT;
  end;

  if ValidRecord then
    result := WriteToExchequer; // else result := -1;
end;

function TDBA.WriteAVTransToExchequer: smallint;
var
  FileMsg: string;
begin
try
  result := -1;

  if FHighFileNo <> FBatchAVHRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
    FileMsg := format('File %d Row ', [FBatchAVHRec.FileNo]);

  try
    //PR: 29/10/2013 ABSEXCH-14075  Set transaction originator if we have a user.
    if not SchedulerMode then
      FTH.thOriginator := BlowfishDecrypt(LoginUserName);

    result := ImportToolkit.StoreAVTrans(FBatchAVHRec, FBatchAVLinesRec, FAVLineCount);
  except on e:exception do begin
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchAVHRec.RecNo, -1, e.message]));
    result := -1;
    exit;
  end; end;

   if result <> 0 then begin
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchAVHRec.RecNo, result, ImportToolkit.itLastErrorDesc]));
    result := (FLineCount + 1) * -1; // (DD's + RR's) + AVH as a negative error code. RecordMgr adds this number to its FErrorRecordCount
  end
  else
    result := FAVLineCount + 1; // (DD's + RR's) + AVH

finally
  FAVLineCount := 0;
  FAVTransCached := false;
  FillChar(FBatchAVLinesRec, FAVLineCount * SizeOf(TManagedRec), #0);
end;
end;

function GetDefaultTag(AccountCode: string): Integer;
var
  BatchCURec: TBatchCURec;
  rc: smallint;
begin                   
  result := 0;
  if trim(AccountCode) = '' then EXIT;
  rc := ImportToolkit.GetAccount(@BatchCURec, SizeOf(BatchCURec), AccountCode, 0, B_GetEq, 0, false);
  if rc = 0 then
    result := BatchCURec.DefTagNo;
end;


function GetDueDate(AccountCode: string; TransDate: string): string;
var
  BatchCURec: TBatchCURec;
  rc: smallint;
begin
  result := '';
  if trim(AccountCode) = '' then EXIT;
  rc := ImportToolkit.GetAccount(@BatchCURec, SizeOf(BatchCURec), AccountCode, 0, B_GetEq, 0, false);
  if rc = 0 then
    result := CalcDueDate(TransDate, BatchCURec.PayTerms)
end;


function IsApplication(const s : string) : Boolean;
begin
  Result := (s = 'JPA') or (s = 'JSA') or (s = 'JPT') or (s = 'JST') or (s = 'JCT');
end;

// Copied from TTransaction.UpdateHeaderTotals in OTrans.pas in ComTK
// if that changes, copy the changes here.
// Some of the commented-out lines are for Importer's benefit.
{-----------------------------------------}

// Update Transaction Header Totals
Procedure {TTransaction.}TDBA.UpdateHeaderTotals (Const TL : TBatchTLRec);
type
  PBatchTLRec = ^TBatchTLRec;
Var
  LineTotal, DiscTotal  : Double;
  Res, VatIdx           : SmallInt;
  VATChar               : Char;
  GotStk                : Boolean;
//StockR                : StockRec;
  SplitMult             : Double;
//  siPos                 : TBtrieveFileSavePos;
//  DocType               : DocTypes;
  TmpVat,
  TmpSettleDisc         : Double;
  NomCurr : CurrTypes;
  UOR : Byte;

  TmpQty : Double;
  BatchSKRec: TBatchSKRec;
  rc: smallint;
  StockType: char;

begin { UpdateHeaderTotals }
  StockType := #0;
//  If (FTH.TransDocHed <> 'NOM') Then
//    PBatchTLRec(@TL)^.PadChar1 := 'BH';
    With TL Do Begin
      GotStk := False;
      SplitMult := 1;

      //PR: 05/06/02 - Added code to adjust the value + vat for split pack items
        If (Trim(TL.StockCode) <> '') And (FTH.TransDocHed <> 'TSH') Then Begin
          // Get Stock Record
          rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), TL.StockCode, 0, B_GetEq ,false);
          if rc = 0 then
           StockType := BatchSKRec.StockType
          else
            StockType := ' ';
        end;

(*      if GotStk then
      begin
        DocType := TKDocTypeToEntDocType(FTH.TransDocHed);
        if StockR.DPackQty and StockR.PricePack then
        begin
          if Doctype in SalesSplit then
            SplitMult := StockR.SellUnit
          else
            SplitMult := StockR.BuyUnit;
        end;
      end; *)
      // Cost
      if IsApplication(FTH.TransDocHed) then
      begin
        if (LineNo > 0) then
        begin
          FTH.TotalCost := FTH.TotalCost + Round_Up(CostPrice, 2);
          if ((FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA')) then
          begin
            if (FTH.TransNat = 2) then
            begin
              if LineNo > 0 then
                FTH.TotalInvoiced := FTH.TotalInvoiced + Round_Up(QtyDel, 2);
            end
            else
              FTH.TotalInvoiced := FTH.TotalCost;

          end;
        end;
        if ((FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA')) then
        begin
          if FTH.TransMode = 3 then //Final application so header total must be zero
          begin
            FTH.TotalInvoiced := 0;
//            FTH.TotalCost := 0;
          end;
        end;
      end
      else
      if (FTH.TransDocHed <> 'WOR') or (StockType <> 'M') then   // stkBillCode
        FTH.TotalCost := FTH.TotalCost + Round_Up(CostPrice * Qty, 2);

      // VAT - Check not Manual VAT
      If (Not FTH.ManVAT) {And ((VAT <> 0.0) or (VATCode in ['M', 'I']))} Then Begin
        // HM 22/03/01: Modified to support Manual VAT
        If (VATCode in ['M', 'I']) Then
          VATChar := VATIncFlg
        Else
          VATChar := VATCode;

        if ((FTH.TransDocHed <> 'NOM') or (TL.NOMVatType <> 0)) and not IsApplication(FTH.TransDocHed) then
        begin
          // Update VAT Analysis & Totals
          //PR 18/08/03 - This was passing the settlement discount amount rather than percentage to
          //Ex_CalcLineTax, causing some strange vat amounts.

{          if FTH.DiscTaken then
            TmpSettleDisc := FTH.DiscSetAm
          else
            TmpSettleDisc := 0.0;}
          TmpSettleDisc := FTH.DiscSetl;

          Res := Ex_CalcLineTax(@TL, SizeOf(TL), TmpSettleDisc);

          VatIdx := VatCharToIdx(VATChar);
          FTH.InvVatAnal[VatIdx] := FTH.InvVatAnal[VatIdx] + (VAT{ * Qty{ * SplitMult});

          FTH.InvVat := FTH.InvVat + (VAT{ * Qty{ * SplitMult});
        end;
      End; { If (Not ManVAT) }

      // Value - exlcuding Line and Settlement Discount
      Res := EX_GETLINETOTAL(@TL, SizeOf(TL), False, 0.0, LineTotal);



        LineTotal := LineTotal{ * SplitMult};

      // HM 30/11/00: Modified for SRI Payment Lines
      If ((FTH.TransDocHed <> 'SRI') and (FTH.TransDocHed <> 'SRF') and
          (FTH.TransDocHed <> 'PPI') and (FTH.TransDocHed <> 'PRF')) Or (Not Payment) Then
      begin
        if FTH.TransDocHed <> 'NOM' then
          FTH.InvNetVal := FTH.InvNetVal + LineTotal
        else
        begin
          NomCurr[False] := TL.CoRate;
          NomCurr[True]  := TL.VATRate;

          UOR := fxUseORate (false, true, NomCurr, FTH.thUseORate, TL.Currency, 0);
          LineTotal := Round_Up(Conv_TCurr(LineTotal, XRate(NomCurr, UseCoDayRate ,TL.Currency), TL.Currency, UOR, false),2);

          FTH.InvNetVal := FTH.InvNetVal + LineTotal;

        end;

      end;

      // Line Discount
      Res := EX_GETLINETOTAL(@TL, SizeOf(TL), True, 0.0, DiscTotal);

//      DiscTotal := DiscTotal{ * SplitMult};

      FTH.DiscAmount := FTH.DiscAmount + (LineTotal - DiscTotal);

      FTH.TotalCost2 := FTH.TotalCost2 + TL.CostApport;
    End; { With TL }
end; { UpdateHeaderTotals }

{-----------------------------------------}

function TDBA.StockCodeDesc(AStockCode: string): string;
var
  BatchSKRec: TBatchSKRec;
  rc: smallint;
begin
  rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), AStockCode, 0, B_GetEq ,false);
  if rc = 0 then
    result := BatchSKRec.Desc[1]
  else
    result := '-';
end;

function TDBA.StockCodeVATCode(AStockCode: string): char;
var
  BatchSKRec: TBatchSKRec;
  rc: smallint;
begin
  rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), AStockCode, 0, B_GetEq ,false);
  if rc = 0 then
    result := BatchSKRec.VATCode
  else
    result := '-';
end;

function TDBA.StockCodeNomCode(AStockCode: string; ACode: integer): integer;
var
  BatchSKRec: TBatchSKRec;
  rc: smallint;
begin
  rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), AStockCode, 0, B_GetEq ,false);
  if rc = 0 then
    result := BatchSKRec.NomCodes[ACode]
  else
    result := -1;
end;

function TDBA.AddBatchSerialRecords: integer;
type
  TBatchOrSerial = (bsNone, bsBatch, bsSerial); // v.083
var
  i: integer;
  BatchSerialRec: TBatchSerialRec;
  FileMsg: string;
  res: integer;
  BatchOrSerial: TBatchOrSerial; // v.083
begin
  result := 1;

  if FHighFileNo <> FBatchTHRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
    FileMsg := format('File %d Row ', [FBatchTHRec.FileNo]);

  for i := 1 to FTH.LineCount do
  begin
    if FBatchLinesRec[i - 1].Qty > 0 then
    begin

      BatchOrSerial := bsNone;
      if trim(FBatchLinesRec[i - 1].tlImporterBatchNo) <> '' then // v.084
        BatchOrSerial := bsBatch else
      if trim(FBatchLinesRec[i - 1].tlImporterSerialNo) <> '' then  // v.084
        BatchOrSerial := bsSerial;
      if BatchOrSerial <> bsNone then begin // Check if batch number or serial has been included by user on this transaction line // v.083
        FillChar(BatchSerialRec, SizeOf(TBatchSerialRec), #0);
        case BatchOrSerial of
          bsBatch:      BatchSerialRec.BatchNo  := FBatchLinesRec[i - 1].tlImporterBatchNo; // v.084
          bsSerial:     BatchSerialRec.SerialNo := FBatchLinesRec[i - 1].tlImporterSerialNo; // v.084
        end;
        BatchSerialRec.StockCode  := FBatchLinesRec[i - 1].StockCode; // v.084
        BatchSerialRec.InDoc      := FTH.OurRef;
        BatchSerialRec.DateIn     := FTH.TransDate;
        BatchSerialRec.BuyABSLine := FBatchLinesRec[i - 1].ABSLineNo; // v.084
        if BatchOrSerial = bsBatch then                               // v.083
          BatchSerialRec.BuyQty     := FBatchLinesRec[i - 1].Qty;     // v.083, v.084
        BatchSerialRec.InMLoc     := FBatchLinesRec[i - 1].MLocStk;   // v.084

        BatchSerialRec.CurCost    := FBatchLinesRec[i - 1].Currency;  // v.084
        BatchSerialRec.SerCost    := FBatchLinesRec[i - 1].CostPrice;  // v.084
        BatchSerialRec.CoRate     := 1;
        BatchSerialRec.DailyRate  := 1;
        BatchSerialRec.BatchRec   := BatchOrSerial = bsBatch;         // v.083
        res := ImportToolkit.StoreSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec));
        if res <> 0 then begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
          result := -1;
          Break;
        end;
      end;
    end
    else
      result := 0;
  end;
end;

function TDBA.FindAndUseBatchRecords(const AStockCode: string; const ABatchNo: string; AQtyReqd: double; ArrayLineNo: integer; UseBatches: boolean): integer; // v5.71.073
// If there's an error or insufficient batch stock, negate the WriteTransToExchequer return code by returning -1
var
  BatchSerialRec: TBatchSerialRec;
  res: integer;
  QtyAvailable: double;
  FileMsg: string;
  RecAddress: longint;

  //PR: 11/10/2012 ABSEXCH-13371 Added trims so that values can match + separated out into a function
  function RecordOK : Boolean;
  begin
    Result := (Trim(BatchSerialRec.BatchNo) = Trim(ABatchNo)) and (Trim(BatchSerialRec.StockCode) = Trim(AStockCode));
  end;

begin
  result := 1;
  if AQtyReqd = 0 then EXIT;

  //PR: 12/10/2012 ABSEXCH-13371 If this is an ADJ, the value could be negative, so make it positive.
  AQtyReqd := Abs(AQtyReqd);

  if FHighFileNo <> FBatchTHRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
    FileMsg := format('File %d Row ', [FBatchTHRec.FileNo]);

  FillChar(BatchSerialRec, SizeOf(TBatchSerialRec), #0);
  BatchSerialRec.BatchNo    := ABatchNo;
  BatchSerialRec.StockCode  := AStockCode;

  res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec), B_GetGEq);

  with BatchSerialRec do
    while (res = 0) and RecordOK do begin // cycle thru all the batch records for this stockcode/batch key
      res := ImportToolkit.GetRecordAddress(9, RecAddress); // Store the current record address for the Batch file
      if res <> 0 then begin
        Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
        result := -1;
        EXIT;
      end;

      QtyAvailable := BuyQty - QtyUsed;
      if QtyAvailable > 0 then begin
        if AQtyReqd > QtyAvailable then
          QtyUsed := QtyAvailable
        else
          QtyUsed := AQtyReqd;

        AQtyReqd    := AQtyReqd - QtyUsed;
        if FTH.TransDocHed = 'SOR' then begin
          OutOrdDoc := FTH.OurRef;
          OutDoc    := FTH.OurRef;
        end
        else begin
          OutDoc    := FTH.OurRef;
          OutOrdDoc := '';
        end;
        SoldABSLine := FBatchLinesRec[ArrayLineNo - 1].ABSLineNo; // v.084
        OutMLoc     := FBatchLinesRec[ArrayLineNo - 1].MLocStk;   // v.084
        if FTH.TransDocHed = 'ADJ' then // v.085
          DateOut := FTH.TransDate
        else
          DateOut     := FBatchLinesRec[ArrayLineNo - 1].LineDate;  // v.084
        OutOrdLine  := FBatchLinesRec[ArrayLineNo - 1].LineNo;    // v.084

        //PR: 11/10/2012 ABSEXCH-13371 Add currency and exchange rate.
        SerSell     := FBatchLinesRec[ArrayLineNo - 1].NetValue;
        CurSell     := FTH.Currency;
        CoRate      := FTH.CoRate;
        DailyRate   := FTH.VATRate;

        if UseBatches then
          res := ImportToolkit.UseSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec))
        else
          res := 0;
        if res <> 0 then begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
          result := -1;
          EXIT;
        end;
      end;

      if AQtyReqd = 0 then
        BREAK
      else begin
        res := ImportToolkit.GetRecWithAddress(9, 2, RecAddress); // Restore the file pointer in the Batch file
        if res <> 0 then begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
          result := -1;
          EXIT;
        end;

        BatchSerialRec.BatchNo    := ABatchNo;
        BatchSerialRec.StockCode  := AStockCode;
        res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec), B_GetNext);
      end;
    end;

  if AQtyReqd <> 0 then begin // there was insufficient available stock for this batch to satisfy the line qty
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, -1, format('Insufficient batched stock: %s batch %s, Trans Line %d, Qty %.3f short', [trim(AStockCode), trim(ABatchNo), ArrayLineNo, AQtyReqd])]));
    result := -1;
  end;
end;

function TDBA.FindAndUseSerialRecords(const AStockCode: string; const ASerialNo: string; ArrayLineNo: integer; UseSerialNos: boolean): integer; // v.83
// If there's an error or no serial record, negate the WriteTransToExchequer return code by returning -1
var
  BatchSerialRec: TBatchSerialRec;
  res: integer;
  FileMsg: string;
  RecAddress: longint;
  FoundUnsold: boolean;

  //PR: 11/10/2012 ABSEXCH-13371 Added trims so that values can match + separated out into a function
  function RecordOK : Boolean;
  begin
    Result := (Trim(BatchSerialRec.SerialNo) = Trim(ASerialNo)) and (Trim(BatchSerialRec.StockCode) = Trim(AStockCode));
  end;

begin
  result := 1;

  if FHighFileNo <> FBatchTHRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
    FileMsg := format('File %d Row ', [FBatchTHRec.FileNo]);

  FillChar(BatchSerialRec, SizeOf(TBatchSerialRec), #0);
  BatchSerialRec.SerialNo   := ASerialNo;
  BatchSerialRec.StockCode  := AStockCode;

  FoundUnsold := false;
  res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec), B_GetGEq);

  with BatchSerialRec do
    while (res = 0) and RecordOK do begin // cycle thru all the batch records for this stockcode/serial key
      res := ImportToolkit.GetRecordAddress(9, RecAddress); // Store the current record address for the Batch file
      if res <> 0 then begin
        Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
        result := -1;
        EXIT;
      end;

      if not Sold then begin
        if (FTH.TransDocHed = 'SOR') then begin // v.085
          OutOrdDoc := FTH.OurRef;
          OutDoc    := FTH.OurRef;
        end
        else begin
          OutDoc    := FTH.OurRef;
          OutOrdDoc := '';
        end;
        SoldABSLine := FBatchLinesRec[ArrayLineNo - 1].ABSLineNo;  // v.084
        OutMLoc     := FBatchLinesRec[ArrayLineNo - 1].MLocStk;    // v.084

        //PR: 11/10/2012 ABSEXCH-13371 Add currency and exchange rate.
        SerSell     := FBatchLinesRec[ArrayLineNo - 1].NetValue;
        CurSell     := FTH.Currency;
        CoRate      := FTH.CoRate;
        DailyRate   := FTH.VATRate;

        if FTH.TransDocHed = 'ADJ' then // v.085
          DateOut := FTH.TransDate
        else
          DateOut     := FBatchLinesRec[ArrayLineNo - 1].LineDate;   // v.084
        OutOrdLine  := FBatchLinesRec[ArrayLineNo - 1].LineNo;     // v.084
        if FTH.TransDocHed = 'ADJ' then // v.085
          QtyUsed   := 1
        else
          QtyUsed     := FBatchLinesRec[ArrayLineNo - 1].Qty;        // v.084
        if UseSerialNos then begin
          res := ImportToolkit.UseSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec));
          FoundUnsold := res = 0;
        end
        else begin
          res := 0;             // dummy success
          FoundUnsold := true;
        end;
        if res <> 0 then begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
          result := -1;
          EXIT;
        end;
      end;

      if FoundUnsold then // only process the first unsold occurrence of this serial no.
        BREAK
      else begin // restore the record pointer and continue the search of the BatchSerial table.
        res := ImportToolkit.GetRecWithAddress(9, 2, RecAddress); // Restore the file pointer in the Batch file
        if res <> 0 then begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, res, ImportToolkit.itLastErrorDesc]));
          result := -1;
          EXIT;
        end;

        BatchSerialRec.SerialNo   := ASerialNo;
        BatchSerialRec.StockCode  := AStockCode;
        res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(TBatchSerialRec), B_GetNext);
      end;
    end;

  if (not FoundUnsold) and (FTH.TransDocHed <> 'ADJ') then begin // there wasnt unsold stock for this serial number to satisfy the line // v.085
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, -1, format('No unsold stock for this serial number: %s serial no. %s, Trans Line %d', [trim(AStockCode), trim(ASerialNo), ArrayLineNo])]));
    result := -1;
  end;
end;

function TDBA.UseBatchSerialRecords: integer; // v5.71.073
var
  i: integer;
begin
  result := 1; // if no lines contain a batch number than don't negate the WriteTransToExchequer return code

  for i := 1 to FTH.LineCount do
  begin
    with FBatchLinesRec[i - 1] do // v.084
    if (FTH.TransDocHed <> 'ADJ') or (FBatchLinesRec[i - 1].Qty < 0) then
    begin
      if trim(tlImporterBatchNo) <> '' then // Check if batch number has been included by user on this transaction line
        if FindAndUseBatchRecords(StockCode, tlImporterBatchNo, Qty, i, false) = 1 then // do a dry run without updating the BatchSerial table
          result := FindAndUseBatchRecords(StockCode, tlImporterBatchNo, Qty, i, not ImportToolkit.ToolkitConfiguration.tcTrialImport) // qty is available so update BatchSerial table // v.085
        else
          result := -1
      else                         // v.083
      if trim(tlImporterSerialNo) <> '' then // Check if serial number has been included by user on this transaction line // v.083
        if FindAndUseSerialRecords(StockCode, tlImporterSerialNo, i, false) = 1 then // do a dry run without updating the BatchSerial table // v.083
          result := FindAndUseSerialRecords(StockCode, tlImporterSerialNo, i, not ImportToolkit.ToolkitConfiguration.tcTrialImport) // serial no is available so update BatchSerial table // v.083 // v.085
        else                                                                                                                           // v.083
          result := -1;                                                                                                                // v.083  end;
    end
    else
    //PR: 08/11/2012 Need to set result to 1 rather than 0. BB
      result := 1;

    //PR: 08/11/2012 Need to check result is 1 rather than 0. BB
    if result <> 1 then
      Break;
  end;
end;

function TDBA.ProcessBatchSerialDetails: integer; // v5.71.073
// During a Trial Import (e.g. the Pre-Import Data Check), OurRef will be blank.
// As a result, processing of batch records will only occur below when a transaction has actually been stored and generated an OurRef.
// This is less than ideal as the user doesn't get a second chance if there are problems: only some batch records may get created or used.
begin
  result := 1; // if no lines have a sales or purchase doctype than don't negate the WriteTransToExchequer return code

  if FTH.OurRef[1] = 'P' then // if this is a purchase transaction create a record on the SerialBatch table for each line that contains a batch number
    result := AddBatchSerialRecords
  else
  if FTH.OurRef[1] = 'S' then // if this is a sales transaction, use stock from the SerialBatch table for each line that contains a batch number
    result := UseBatchSerialRecords


  else // v.085
  if FTH.TransDocHed = 'ADJ' then
  begin
   //PR: 12/10/2012 ABSEXCH-13371 Change from Qty = 1, Qty = -1 to Qty > 0, Qty < 0, to accomodate batch records.
    if (FTH.LineCount > 0) then // v.086
        result := AddBatchSerialRecords;
    if result = 0 then
      result := UseBatchSerialRecords;
  end;
end;

function TDBA.WriteTransToExchequer: smallint;
// Here's where we do old Import-Module-style adjustments to the data.
// If no error occurs writing to Exchequer we return the number of records written
// Errors are returned as negative return codes.
const
  tolerance: double = 0.01;
var
//  BatchTHRec: TBatchTHRec; // the THRec part of the TManagedRec.
  i: integer;
  PrevStockCode: string[16];
  TLLineTotal: double;
  FileMsg: string;
  variance: double;


  function ValidateAnySerialBatch : Boolean;
  var
    LineNo : integer;
    IsSerial : Boolean;

    //If serial, check that the record exists
    //If batch, check that the record exists and has enough unused
    function OKToUseSerialBatch : Boolean;
    var
      BatchSerialRec: TBatchSerialRec;
      res: integer;
    begin
      Result := False;
      FillChar(BatchSerialRec, SizeOf(BatchSerialRec), 0);
      BatchSerialRec.StockCode := FBatchLinesRec[LineNo - 1].StockCode;
      BatchSerialRec.SerialNo := FBatchLinesRec[LineNo - 1].tlImporterSerialNo;
      BatchSerialRec.BatchNo := FBatchLinesRec[LineNo - 1].tlImporterBatchNo;

      Res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(BatchSerialRec), B_GetGEq);

      if (Res = 0) and (Trim(BatchSerialRec.StockCode) = Trim(FBatchLinesRec[LineNo - 1].StockCode)) then
      begin
        if IsSerial and (Trim(BatchSerialRec.SerialNo) = Trim(FBatchLinesRec[LineNo - 1].tlImporterSerialNo)) then
          Result := not BatchSerialRec.Sold
        else
        begin
          //If batch then need to make sure we're not on a child record.
          while not Result and (Res = 0) and
                (Trim(BatchSerialRec.StockCode) = Trim(FBatchLinesRec[LineNo - 1].StockCode)) and
                (Trim(BatchSerialRec.BatchNo) = Trim(FBatchLinesRec[LineNo - 1].tlImporterBatchNo)) do
          begin
            Result := not BatchSerialRec.BatchChild and
                      ((BatchSerialRec.BuyQty - BatchSerialRec.QtyUsed) >= Abs(FBatchLinesRec[LineNo - 1].Qty));

            if not Result then
              Res := ImportToolkit.GetSerialBatch(@BatchSerialRec, SizeOf(BatchSerialRec), B_GetNext);

          end;
        end;
      end;
    end;

  begin
    Result := True;
    for LineNo := 1 to FLineCount do
    begin
      if (trim(FBatchLinesRec[LineNo - 1].tlImporterBatchNo) <> '') or
         (trim(FBatchLinesRec[LineNo - 1].tlImporterSerialNo) <> '') then
      begin
        IsSerial := trim(FBatchLinesRec[LineNo - 1].tlImporterSerialNo) <> '';
        //Check for qty of > 1 on a serial no
        if IsSerial and (Abs(FBatchLinesRec[LineNo - 1].Qty) > 1) then
        begin
          Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO,
                          FBatchTHRec.RecNo, -1, 'Serial Number Qty cannot be more than 1']));
          result := False;
          if Assigned(FIncrementErrorCount) then
            FIncrementErrorCount(Self);
          EXIT;
        end;

        //If we're using the serial/batch then check it exists.
        if (FBatchTHRec.ExchequerRec.BatchTHRec.TransDocHed[1] = 'S') or
           (FBatchLinesRec[LineNo - 1].Qty < 0) then
        begin
          if not OKToUseSerialBatch then
          begin
            Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO,
                            FBatchTHRec.RecNo, -1, 'No Unused Serial/Batch Number found to use']));
            result := False;
            if Assigned(FIncrementErrorCount) then
              FIncrementErrorCount(Self);
            EXIT;
          end;
        end;
      end;
    end; //for LineNo
  end;

begin
try
  result := -1;

  //PR: 19/10/2012 Added as MR/DR want serial/batch validated before transaction is created.
  if not ValidateAnySerialBatch then
    EXIT;

  if FHighFileNo <> FBatchTHRec.FileNo then // occurs when processing the final file of cached files and Read Record Cache=EndOfJob
    FileMsg := format('File %d Row ', [FBatchTHRec.FileNo]);

  FTH := FBatchTHRec.ExchequerRec.BatchTHRec; // copy to reduce amendments to UpdateHeaderTotals copied from COM toolkit which refers to FTH

  with ImportToolkit.ToolkitConfiguration do begin
    if tcAutoSetTHLineCount then
      FTH.LineCount := FLineCount;

    PrevStockCode := '';

    for i := 1 to FLineCount do begin
      if FTH.TransDocHed = 'NOM' then begin  // FUDGE !
        {if FBatchLinesRec[i].Qty    = 0 then} FBatchLinesRec[i - 1].Qty    := 1; // v.070 more fudges on behalf of the toolkit // v.084
        {if FBatchLinesRec[i].QtyMul = 0 then} FBatchLinesRec[i - 1].QtyMul := 1; // v.070 more fudges on behalf of the toolkit // v.084
      end;

      if FBatchLinesRec[i - 1].KitLink = -1 then  // link this transaction to the previous one in the Exchequer UI // v.084
        try
          FBatchLinesRec[i - 1].KitLink := StockCodeFolioNum(PrevStockCode) // v.084
        except
          FBatchLinesRec[i - 1].KitLink := 0; // v.084
        end
      else
        PrevStockCode := FBatchLinesRec[i - 1].StockCode; // v.084

      if trim(FBatchLinesRec[i - 1].Desc) = '-1' then // v.072 - pick up the description from the stock record // v.084
        FBatchLinesRec[i - 1].Desc := StockCodeDesc(FBatchLinesRec[i - 1].StockCode); // v.084

      if trim(FBatchLinesRec[i - 1].VATCode) = '-' then // v.072 - pick up the VAT code from the stock record  // v.084
        FBatchLinesRec[i - 1].VATCode := StockCodeVATCode(FBatchLinesRec[i - 1].StockCode); // v.084

      if FBatchLinesRec[i - 1].NomCode = -1 then // v.072 - pick up the GL code from the stock record // v.084
        if FTH.TransDocHed = 'SOR' then
          FBatchLinesRec[i - 1].NomCode := StockCodeNomCode(FBatchLinesRec[i - 1].StockCode, 1) // v.084
        else
        if FTH.TransDocHed = 'POR' then
          if ImportToolkit.itLiveStockCOSVal then // v.075
            FBatchLinesRec[i - 1].NomCode := StockCodeNomCode(FBatchLinesRec[i - 1].StockCode, 4) // use the Stock Valuation code // v.084
          else
            FBatchLinesRec[i - 1].NomCode := StockCodeNomCode(FBatchLinesRec[i - 1].StockCode, 2); // use cost of sales code // v.084

      if tcAutoSetTLRefFromTH then
        FBatchLinesRec[i - 1].TransRefNo := FTH.OurRef; // v.084
      if tcAutoSetTLLineNo then
        FBatchLinesRec[i - 1].LineNo     := i; // v.084



      if tcCalcTHTotals then
      begin
        //PR: 09/02/2015 ABSEXCH-16131 Need to ensure VAT Code on line is set before calculating totals
        if (FBatchLinesRec[i - 1].VATCode = #0) and (Length(ImportToolkit.ToolkitConfiguration.tcDefaultVATCode) > 0) then
           FBatchLinesRec[i - 1].VATCode := ImportToolkit.ToolkitConfiguration.tcDefaultVATCode[1];

        UpdateHeaderTotals(FBatchLinesRec[i - 1]); // v.084
      end;

      with FTH do
        if trim(DueDate) = '' then
          DueDate := GetDueDate(CustCode, TransDate); // v.066l

      FBatchLinesRec[i - 1].ABSLineNo := FBatchLinesRec[i - 1].LineNo; // v5.71.073 // v.084

      if tcApplyMBD then
      with TMultiBuyFunctions.Create do
      Try
        FBatchLinesRec[i - 1].tlMBDList := GetMultiBuyList(FTH.CustCode,
                                                           FBatchLinesRec[i - 1].StockCode,
                                                           FTH.TransDate,
                                                           nil,
                                                           FBatchLinesRec[i - 1].Currency,
                                                           False,
                                                           FTH.TransDocHed[1] = 'S',
                                                           FBatchLinesRec[i - 1].Qty);

        //PR: 28/05/2010 - Remember to free MultiBuyList
        if Assigned(FBatchLinesRec[i - 1].tlMBDList) then
        Try
          if (FBatchLinesRec[i - 1].tlMBDList.Count > 0) then
            GetUnitDiscountValue(FBatchLinesRec[i - 1].tlMBDList,
                                 FBatchLinesRec[i - 1],
                                 FBatchLinesRec[i - 1].tlMultiBuyDiscount,
                                 FBatchLinesRec[i - 1].tlMultiBuyDiscountChr);
        Finally
          //FBatchLinesRec[i - 1].tlMBDList.Free;
          // PS : 14/06/2016 : ABSEXCH-14444 : Importer – Import Job fails with ‘Access Violation’
        end;
      Finally
        Free;
      End;

    end;

    if tcCalcTHTotals then // v99. calculate Settlement Discount on the transaction header now we've done the lines - snaffled from the COMTK
    with FTH do begin
      if DiscSetAm < 0.000001 then
         DiscSetAm := Calc_PAmount(FTH.InvNetVal - FTH.DiscAmount, FTH.DiscSetl, '%'); // v100 added " - FTH.DiscAmount"

      DiscSetAm := Round_Up(DiscSetAm, 2);
    end;
  end;

      { Sanjay Sonani : 08/02/2016  2016-R1
   ABSEXCH-15979: Ability to allow imported transactions (from importer module)
                  to respect automatic tagging numbers from customer / supplier
                  records}
  if (FTH.TransDocHed = 'SOR') or (FTH.TransDocHed = 'POR') then
  begin
    FTH.Tagged := GetDefaultTag(FTH.CustCode);
  end;

  {* Create a balancing NOM line if currency variance and rounding produced a non-zero transaction header total above *}
  if (FTH.TransDocHed = 'NOM') and (FTH.InvNetVal <> 0) then begin   // create a currency variance transaction if conversion out by 0.01
    variance := ImportToolkit.RoundUp(FTH.InvNetVal, 2);
    if (variance <> 0) and (abs(variance) <= FNomCurrencyVarianceTolerance) then begin
      inc(FLineCount);
      FTH.LineCount := FLineCount;
      ResizeArray(FLineCount); // v.084
      FBatchLinesRec[FLineCount - 1] := FBatchLinesRec[FLineCount - 2]; // create a new line from the last one // v.084
      with FBatchLinesRec[FLineCount - 1] do begin // v.084
        LineNo   := FLineCount;
        NetValue := FTH.InvNetVal * -1; // credits are -ve, debits are +ve (or vice versa)
        Currency := 1;
        NomCode  := ImportToolkit.itCurrencyVarianceGLCode;
        Desc     := 'Importer Variance';
      end;
      FTH.InvNetVal  := 0;
      FTH.DiscAmount := 0;
      inc(FCurrencyVarianceCount);
    end;
  end;

  try
    //PR: 29/10/2013 ABSEXCH-14075  Set transaction originator if we have a user.
    //PR: 20/11/2013 ABSEXCH-14779 Use LoginUserName as itUserName is the User who created/edited the job.
    if not SchedulerMode then
    begin
      FTH.thOriginator := BlowfishDecrypt(LoginUserName);
      //SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
      FTH.OpName   := BlowfishDecrypt(LoginDisplayName);
      //PR: 07/11/2014 ABSEXCH-15805 Need to set EntryRec so CreateSRC can set thransaction originator
      EntryRec^.Login := FTH.thOriginator;
    end;

    ExplodeBOMLines; //SSK 14/09/2016 2016-R3 ABSEXCH-15502: call this to explode all the BOM Stock

    result := ImportToolkit.StoreTrans(@FTH, @FBatchLinesRec[0], SizeOf(FTH), SizeOf(TBatchTLRec) * FLineCount); // v.084 replaces the line above
    except on e:exception do begin
      Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, -1, e.message]));
      result := -1;
      exit;
    end;
  end;

  if result <> 0 then begin
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, result, ImportToolkit.itLastErrorDesc]));
    result := (FLineCount + 1) * -1; // TL's + TH as a negative error code. RecordMgr adds this number to its FErrorRecordCount
  end
  else begin
    result := (FLineCount + 1) * ProcessBatchSerialDetails; // TL's + TH   // v5.71.073 multiply by 1 or -1 to return a negative error code if necessary
  end;

finally
  FLineCount := 0;
  FTransCached := false;
  FillChar(FBatchLinesRec[0], FLineCount * SizeOf(TBatchLinesRec), #0);
//  FBatchLinesRec := nil; // v.084 replaces the above line
end;
end;

function TDBA.StockCodeFolioNum(AStockCode: string): Longint;
var
  BatchSKRec: TBatchSKRec;
  rc: smallint;
begin
  rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), AStockCode, 0, B_GetEq ,false);
  if rc = 0 then
    result := BatchSKRec.StockFolio
  else
    result := -1;
end;

function TDBA.WriteToExchequer: integer;
// Writes the Exchequer record in FOutputRec.
// This function writes all record types except TH and TL
begin
  result := -1;

  try
    with ImportToolkit do
      if FOutputRec.RecordType = 'CU' then result := StoreAccount      (@FOutputRec.ExchequerRec.BatchCURec,        SizeOf(FOutputRec.ExchequerRec.BatchCURec))        else //Customer            TBatchCURec
      if FOutputRec.RecordType = 'SU' then result := StoreAccount      (@FOutputRec.ExchequerRec.BatchCURec,        SizeOf(FOutputRec.ExchequerRec.BatchCURec))        else //Supplier            TBatchCURec
      if FOutputRec.RecordType = 'GL' then result := StoreGLAccount    (@FOutputRec.ExchequerRec.BatchNOMRec,       SizeOf(FOutputRec.ExchequerRec.BatchNOMRec))       else //General Ledger      TBatchNomRec
      if FOutputRec.RecordType = 'SK' then result := StoreStock        (@FOutputRec.ExchequerRec.BatchSKRec,        SizeOf(FOutputRec.ExchequerRec.BatchSKRec))        else //Stock               TBatchSKRec
      if FOutputRec.RecordType = 'BR' then result := StoreAutoBank     (@FOutputRec.ExchequerRec.BatchAutoBankRec,  SizeOf(FOutputRec.ExchequerRec.BatchAutoBankRec))  else //AutoBank            TBatchAutoBankRec
      if FOutputRec.RecordType = 'BM' then result := StoreEachBOMLine  (@FOutputRec.ExchequerRec.BatchBOMImportRec, SizeOf(FOutputRec.ExchequerRec.BatchBOMImportRec)) else //BOM                 TBatchBOMImportRec
      if FOutputRec.RecordType = 'NP' then result := StoreNotes        (@FOutputRec.ExchequerRec.BatchNotesRec,     SizeOf(FOutputRec.ExchequerRec.BatchNotesRec))     else //Note                TBatchNotesRec
      if FOutputRec.RecordType = 'ML' then result := StoreLocation     (@FOutputRec.ExchequerRec.BatchMLocRec,      SizeOf(FOutputRec.ExchequerRec.BatchMLocRec))      else //Location            TBatchMLocRec
      if FOutputRec.RecordType = 'SL' then result := StoreMultiLocation(@FOutputRec.ExchequerRec.BatchSLRec,        SizeOf(FOutputRec.ExchequerRec.BatchSLRec))        else //Location            TBatchSLRec
      if FOutputRec.RecordType = 'MA' then result := StoreMatch        (@FOutputRec.ExchequerRec.BatchMatchRec,     SizeOf(FOutputRec.ExchequerRec.BatchMatchRec))     else //Matching            TBatchMatchRec
      if FOutputRec.RecordType = 'JR' then result := StoreJob          (@FOutputRec.ExchequerRec.BatchJHRec,        SizeOf(FOutputRec.ExchequerRec.BatchJHRec))        else //Job Record          TBatchJHRec
      if FOutputRec.RecordType = 'EM' then result := StoreJobEmployee  (@FOutputRec.ExchequerRec.BatchEmplRec,      SizeOf(FOutputRec.ExchequerRec.BatchEmplRec))      else //Employee            TBatchEmplRec
      if FOutputRec.RecordType = 'JA' then result := StoreJobAnalysis  (@FOutputRec.ExchequerRec.BatchJobAnalRec,   SizeOf(FOutputRec.ExchequerRec.BatchJobAnalRec))   else //Job Analysis        TBatchJobAnalRec
      if FOutputRec.RecordType = 'JC' then result := StoreJobTimeRate  (@FOutputRec.ExchequerRec.BatchJobRateRec,   SizeOf(FOutputRec.ExchequerRec.BatchJobRateRec))   else //Job Costing         TBatchJobRateRec
      if FOutputRec.RecordType = 'AS' then result := StoreStkAlt       (@FOutputRec.ExchequerRec.BatchSKAltRec,     SizeOf(FOutputRec.ExchequerRec.BatchSKAltRec))     else //Alternative Stock   TBatchSKAltRec
      if FOutputRec.RecordType = 'MB' then result := StoreMultiBin     (@FOutputRec.ExchequerRec.BatchBinRec,       SizeOf(FOutputRec.ExchequerRec.BatchBinRec))       else //MultiBin            TBatchBinRec
      if FOutputRec.RecordType = 'SN' then result := StoreSerialBatch  (@FOutputRec.ExchequerRec.BatchSerialRec,    SizeOf(FOutputRec.ExchequerRec.BatchSerialRec))    else //Serial No           TBatchSerialRec
      if FOutputRec.RecordType = 'DM' then result := StoreDiscMatrix   (@FOutputRec.ExchequerRec.BatchDiscRec,      SizeOf(FOutputRec.ExchequerRec.BatchDiscRec))      else //Discount Matrix     TBatchDiscRec
      if FOutputRec.RecordType = 'JB' then result := StoreAVJob        (FOutputRec.ExchequerRec.BatchAVJobRec)    else
      if FOutputRec.RecordType = 'AB' then result := StoreAVAnalysisBudget (FOutputRec.ExchequerRec.BatchAVABRec) else
      if FOutputRec.RecordType = 'CD' then result := StoreCCDep        (@FOutputRec.ExchequerRec.BatchCCDepRec,     SizeOf(FOutputRec.ExchequerRec.BatchCCDepRec))     else         // CC/Dept            TBatchCCDepRec
      if FOutputRec.RecordType = 'MD' then result := StoreMultiBuyDiscount  (@FOutputRec.ExchequerRec.BatchMultiBuyRec,     SizeOf(FOutputRec.ExchequerRec.BatchMultiBuyRec))         // MultiBuyDiscount
      //PR: 04/02/2014 ABSEXCH-14974 Added handling for Multi-Contacts
      else //AccountContact
      if FOutputRec.RecordType = 'CO' then result := StoreContact(@FOutputRec.ExchequerRec.ContactRec)
      else //AccountContactRole
      if FOutputRec.RecordType = 'CR' then result := StoreContactRole(@FOutputRec.ExchequerRec.ContactRoleRec);


  except on e:exception do begin
    Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, -1, e.message]));
    exit;
  end; end;

  if result <> 0 then begin
    case result of
      -99001: Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, 99001, 'Invalid Stock Code'])); // invalid stock code returned by StoreMultiBin
      -99002: Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, 99002, 'Invalid Job Code']));   // job code not found in StoreAVPurchaseTerms
    else
      Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, result, ImportToolkit.itLastErrorDesc]));
    end;
    result := -1;
  end
  else
    result := 1; // 1 recorded imported
end;

function TDBA.FlushRecords: smallint;
// DBA stores sets of TH's and TL's and writes them to Exchequer when the
// next set is passed to WriteRecord.
// Obviously, when the last record has been passed to the DBA, it could be
// that there is a final set which is still waiting to be written.
// This function gets that done.
begin
  result := 0;
  if FTransCached then
    result := WriteTransToExchequer;
  if FAVTransCached then
    result := result + WriteAVTransToExchequer;
end;

function TDBA.OpenTheToolkit: smallint;
begin
  result := -1;

  with ImportToolkit do begin
    if itToolkitOpen then exit;
    OpenImportToolkit;     // Open the ImportToolkit and check the Login credentials
    if not itToolkitOpen then begin
      result := -2;
//      Logger.LogEntry(FOutputRec.FileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, result, 'Cannot open Toolkit']));
      Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, result, 'Cannot open Toolkit']));
      exit;
    end;
    if CheckLogin(BlowFishDecrypt(itUserName), BlowFishDecrypt(itPassword)) <> 0 then begin
      result := -3;
//      Logger.LogEntry(FOutputRec.FileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, result, 'Invalid UserName or Password']));
      Logger.LogEntry(FHighFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FOutputRec.RecNo, result, 'Invalid UserName or Password']));
      exit;
    end;
  end;

  result := 0;
end;

function TDBA.ValidRecord: boolean;
// Originally, I was expecting to do extra validation of each record prior
// to calling a toolkit to store the record.
// As it turns out, data-format checking has already been performed by this point and all
// other checking can be left to the toolkits.
// I've left this here just in case future enhancements provide a reason to
// make use of it.
// With the record types since Apps & Vals were introduced, I've cheated and
// just returned true instead of creating a blank function to return true.
begin
  result := true; // no further validation at the moment so just return True.
  EXIT;

  result := false;
  if FOutputRec.RecordType = 'CU' then result := ValidCU else //Customer             TBatchCURec
  if FOutputRec.RecordType = 'SU' then result := ValidSU else //Supplier             TBatchCURec
  if FOutputRec.RecordType = 'GL' then result := ValidGL else //General Ledger       TBatchNomRec
  if FOutputRec.RecordType = 'SK' then result := ValidSK else //Stock                TBatchSKRec
  if FOutputRec.RecordType = 'TH' then result := ValidTH else //Trans Header         TBatchTHRec
  if FOutputRec.RecordType = 'TL' then result := ValidTL else //Trans Line           TBatchTLRec
  if FOutputRec.RecordType = 'BR' then result := ValidBR else //AutoBank             TBatchAutoBankRec
  if FOutputRec.RecordType = 'BM' then result := ValidBM else //BOM                  TBatchBOMImportRec
  if FOutputRec.RecordType = 'NP' then result := ValidNP else //Note                 TBatchNotesRec
  if FOutputRec.RecordType = 'ML' then result := ValidML else //Location             TBatchMLocRec
  if FOutputRec.RecordType = 'SL' then result := ValidSL else //Multi-Location       TBatchSLRec
  if FOutputRec.RecordType = 'MA' then result := ValidMA else //Matching             TBatchMatchRec
  if FOutputRec.RecordType = 'JR' then result := ValidJR else //Job Record           TBatchJHRec
  if FOutputRec.RecordType = 'EM' then result := ValidEM else //Employee             TBatchEmplRec
  if FOutputRec.RecordType = 'JA' then result := ValidJA else //Job Analysis         TBatchJobAnalRec
  if FOutputRec.RecordType = 'JC' then result := ValidJC else //Job Costing          TBatchJobRateRec
  if FOutputRec.RecordType = 'AS' then result := ValidAS else //Alternative Stock    TBatchSKAltRec
  if FOutputRec.RecordType = 'MB' then result := ValidMB else //MultiBin             TBatchBinRec
  if FOutputRec.RecordType = 'SN' then result := ValidSN else //Serial No            TBatchSerialRec
  if FOutputRec.RecordType = 'DM' then result := ValidDM else //Discount Matrix      TBatchDiscRec
  if FOutputRec.RecordType = 'JB' then result := true    else //Job Rec              TBatchAVJobRec
  if FOutputRec.RecordType = 'AB' then result := true    else //Analysis Budget      TBatchAVABRec
  if FOutputRec.RecordType = 'CT' then result := true    else //Contract Terms       via COM Toolkit
  if FOutputRec.RecordType = 'ST' then result := true    else //Sales Terms          via COM Toolkit
  if FOutputRec.RecordType = 'PT' then result := true    else //Purchase Terms       via COM Toolkit
  if FOutputRec.RecordType = 'SA' then result := true    else //Sales Application    via COM Toolkit
  if FOutputRec.RecordType = 'PA' then result := true    else //Purchase Application via COM Toolkit
  if FOutputRec.RecordType = 'CD' then result := ValidCD;     //                     TBatchCCDepRec
end;

function TDBA.ValidAS: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidBR: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidCU: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidDM: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidEM: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidJA: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidJR: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidJC: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidML: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidMB: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidSL: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidNP: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidGL: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidSN: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidSK: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidBM: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidSU: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidMA: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidTH: boolean;
begin
  result := false;

  result := true;
end;

function TDBA.ValidTL: boolean;
begin
  result := false;

  result := true;
end;

{* getters and setters *}

function TDBA.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TDBA.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TDBA.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

procedure TDBA.SetHighFileNo(const Value: integer);
begin
  FHighFileNo := Value;
end;

procedure TDBA.SetNomCurrencyVarianceTolerance(const Value: double);
begin
  FNomCurrencyVarianceTolerance := Value;
end;

function TDBA.ValidCD: boolean;
begin
  result := false;

  result := true;
end;

//SSK 14/09/2016 2016-R3 ABSEXCH-15502:Added to explode BOM Components as transaction lines
procedure TDBA.ExplodeBOMLines;
var
  BomChildStockRec   : TBatchSKRec;
  BOMComponentLines  : TBatchBOMLinesRec;
  newBOMRec          : TBatchBOMRec;
  rc,
  BomLineCount       : smallint;
  BomTransHed        : TBatchTHRec;
  BomTransLines      : array of TBatchTLRec;
  I, K,
  TotalBOMComp       : integer;

  DocType            : DocTypes;
  FileMsg            : string;

  procedure CreateBOMLines;
  var
    Acc,
    Stock : array[0..255] of char;
    stkPrice: double;

  begin
    stkPrice := 0;
    inc(bomLineCount);
    SetLength(BomTransLines, bomLineCount);

    FillChar(BomTransLines[bomLineCount-1], sizeof(TBatchTLRec), #0);
    BomTransLines[bomLineCount-1] := FBatchLinesRec[K];

    with BomTransLines[bomLineCount-1] do
    begin
      LineNo := bomLineCount;

      StockCode := trim(BOMChildStockRec.StockCode);
      Desc := trim(BOMChildStockRec.desc[1]);
      Qty := (newBOMRec.QtyUsed * FBatchLinesRec[K].Qty);

      tlStockDeductQty := Qty;

      kitlink := FBOMParentStockRec.StockFolio;
      ImportDefaultLineValues(BomTransLines[bomLineCount-1]);

      StrPCopy(Acc, BomTransHed.CustCode);
      StrPCopy(Stock, BOMChildStockRec.stockcode);

      if (DocType In SalesSplit) then
      begin
        //price check
        If FBOMParentStockRec.StKitPrice then
          NetValue := 0
        else
        begin
          if (CalculatePrice('', Acc, Stock, BOMChildStockRec.PCurrency, Qty, StkPrice)=0) then
            NetValue := StkPrice;
        end;
      end
      else
      begin
        if CalculatePrice('', Acc, Stock, BOMChildStockRec.PCurrency, Qty, StkPrice)=0 then
          NetValue := StkPrice;
      end;  {(DocType In SalesSplit)}

      //header total outstanding needs to be updated
      UpdateHeaderTotals(BomTransLines[bomLineCount-1]);
    end;
  end;

  procedure CalculateBOMTotal;
  var
    Cnt : integer;
  begin
    TotalBOMComp := 0;

    for Cnt := 1 to high(BOMComponentLines) do
    begin
      //get the BOM batch record
      if trim(BOMComponentLines[Cnt].StockCode)<>'' then
        inc(TotalBOMComp)
      else
        break;
    end;
  end;

begin
  bomLineCount:=0;
  try
    //initial setup
    //get transaction header
    BomTransHed := FTH;
    DocType := TKDocTypeToEntDocType(BomTransHed.TransDocHed);

    for K := 0 to (FTH.LineCount-1) do
    begin
      inc(bomLineCount);
      SetLength(BomTransLines, bomLineCount);
      BomTransLines[bomLineCount-1] := FBatchLinesRec[K];
      BomTransLines[bomLineCount-1].LineNo := bomLineCount;

      //SSK 20/10/2016 2017-R1 ABSEXCH-15502: only explode where Payment equals to false (don't explode payment line)
      if IsExplodeBOM(FBatchLinesRec[K].StockCode) and (not FBatchLinesRec[K].Payment) then
      begin
        //extract BOM components
        FillChar(BOMComponentLines, SizeOf(TBatchBOMLinesRec), 0);
        rc := ImportToolkit.GetStockBOMRec(@BOMComponentLines, sizeof(TBatchBOMLinesRec), trim(FBatchLinesRec[K].StockCode), 0);

        if (rc=0) then
          CalculateBOMTotal;

        for I := 1 to TotalBOMComp do
        begin
          //get the BOM batch record
          newBOMRec := BOMComponentLines[I];

          //get the stock record for BOM Components
          FillChar(BOMChildStockRec, SizeOf(BOMChildStockRec), #0);
          rc := ImportToolkit.GetStock(@BOMChildStockRec, SizeOf(BOMChildStockRec), trim(newBOMRec.StockCode), 0, B_GetEq ,false);

          if rc=0 then
            CreateBOMLines;
        end; {for I := 1 to TotalBOMComp}
      end; {for K := 0 to (FTH.LineCount-1)}
    end;

    if (BomLineCount > FLineCount) then
    begin
      FLineCount := BomLineCount;
      ResizeArray(FLineCount);

      for K := 1 to FLineCount do
        FBatchLinesRec[K-1] := BomTransLines[K-1];

      FTH.LineCount := bomLineCount;
    end;

  except on e:exception do
  begin
    Logger.LogEntry(FHighFileNo, format('%s%.*d: [%d] %s', [FileMsg, LEN_REC_NO, FBatchTHRec.RecNo, -1, e.message]));
  end;
  end;
end;

//SSK 22/09/2016 2016-R3 ABSEXCH-15502: ImportDefaultLineValues - implements TL for BOM component to get right GL Code
procedure TDBA.ImportDefaultLineValues(var TL : TBatchTLRec);
Var
  GotStk,
  GotAcc      : Boolean;
  DocType     : DocTypes;
  BatchSKRec  : TBatchSKRec;
  BatchCURec  : TBatchCURec;
  rc          : smallint;
  SplitMult   : double;
begin

  Try
    GotStk := False;
    FillChar (BatchSKRec, SizeOf(BatchSKRec), #0);

    GotAcc := False;
    FillChar (BatchCURec, SizeOf(BatchCURec), #0);

    // Calculate Document Type
    DocType := TKDocTypeToEntDocType (FTH.TransDocHed);

    If (Trim(TL.StockCode) <> '') And (DocType <> TSH) Then
    Begin
      // Get Stock Record
      rc := ImportToolkit.GetStock(@BatchSKRec, SizeOf(BatchSKRec), TL.StockCode, 0, B_GetEq ,false);
      if rc = 0 then
        GotStk := true;
    End; { (Trim(TL.StockCode) <> '') }

    // Get customer/supplier Record
    If (Trim(FTH.CustCode) <> '') Then Begin

      if trim(FTH.CustCode) <> trim(TL.CustCode) then
        rc := ImportToolkit.GetAccount(@BatchCURec, SizeOf(BatchCURec), FTH.CustCode, 0, B_GetEq , 0,  false)
      else
        rc := ImportToolkit.GetAccount(@BatchCURec, SizeOf(BatchCURec), TL.CustCode, 0, B_GetEq , 0, false);

      if (rc = 0) then
        GotAcc := true;
    End; { (Trim(FTH.CustCode) <> '') }

    // Added for splitpacks
    if GotStk then
    begin
      if BatchSKRec.StDPackQty and BatchSKRec.StPricePack then
      begin
        if Doctype in SalesSplit then
          SplitMult := BatchSKRec.SellUnit
        else
          SplitMult := BatchSKRec.BuyUnit;
      end;
    end;

    //If we have an override location on the header use it for the line location
    if AllowOverrideLocation(DocType) and not TL.Payment and (Trim(FTH.thOverrideLocation) <> '') then
      TL.MLocStk := FTH.thOverrideLocation
    else
    begin
      If GotStk And Syss.UseMLoc And (Trim(TL.MLocStk) = '') Then
        TL.MLocStk := BatchSKRec.StLocation;
    end;

      // ---------------------------  Nominal Code  ---------------------------
    If GotStk Then
    Begin
      if (DocType = SRN) then
        TL.NomCode := BatchSKRec.SalesRetGL
      else
      if (DocType = PRN) then
        TL.NomCode := BatchSKRec.PurchRetGL
      else
      If (DocType <> ADJ) Then
      Begin
        If (DocType In PurchSplit) And Syss.AutoValStk And (BatchSKRec.StockType = StkBillCode) Then
          // When buying a BOM, force the GL to be WIP
          TL.NomCode := BatchSKRec.NomCodeS[5]
        Else
          TL.NomCode := BatchSKRec.NomCodeS[1 + Ord(DocType In PurchSplit) + (2 * Ord((DocType In PurchSplit) and Syss.AutoValStk))];
      End { If (DocType <> ADJ) }
      else
      Begin
        If (BatchSKRec.StockType = StkBillCode) then
          TL.NomCode := BatchSKRec.NomCodeS[5]
        Else
          TL.NomCode := BatchSKRec.NomCodeS[3];
      End; { Else }
      if (DocType = WOR) then
      begin
        If (BatchSKRec.StockType = StkBillCode) then
          TL.NomCode := BatchSKRec.NomCodes[5]
        Else
          TL.NomCode := BatchSKRec.NomCodes[4];
      end;
    End; { If GotStk }

    If GotAcc Then
    Begin
      // For sales invoices, override account nominal code
      If ((DocType In SalesSplit) Or (Not GotStk)) And (BatchCURec.DefNomCode <> 0) Then
        TL.NomCode := BatchCURec.DefNomCode;

      // ---------------------  Default Line Discount  ---------------------
      // added check for payment lines (Bug/Wish 20051102105526)
      if not TL.Payment then
        TL.Discount := BatchCURec.Discount;

      If (BatchCURec.CDiscCh In StkBandSet) Or (BatchCURec.Discount <> 0) Then
        TL.DiscountChr  := BatchCURec.CDiscCh;
    End; { If GotAcc }

    If Syss.UseCCDep Then
    Begin
      // ----------------  Cost Centre / Department  ---------------------
      If GotStk Then
      Begin
        If (Trim(TL.CC) = '') Then
          TL.CC  := BatchSKRec.CC;
        If (Trim(TL.Dep) = '') Then
          TL.Dep := BatchSKRec.CC;
      End; { If GotStk }

      If GotAcc Then
      Begin
        If (Trim(TL.CC) = '') Then
          TL.CC := BatchCURec.CustCC;
        If (Trim(TL.Dep) = '') Then
          TL.Dep := BatchCURec.CustCC;
      End; { If GotAcc }
    End; { If Syss.UseCCDep }
    except
//
  end;
end;

//SSK 16/09/2016 2016-R3 ABSEXCH-15502: determine if the stock needs to be exploded
function TDBA.IsExplodeBOM(AStockCode: string): Boolean;
var
  rc: smallint;
  DocType: DocTypes;
begin

  result := false;
  try

    rc := ImportToolkit.GetStock(@FBOMParentStockRec, SizeOf(TBatchSKRec), AStockCode, 0, B_GetEq ,false);

    if (rc=0) then
    begin
      if (FBOMParentStockRec.StockType = 'M') then
      begin
        //get Document Type
        DocType := TKDocTypeToEntDocType(FTH.TransDocHed);

        if FBOMParentStockRec.ShowAsKit and (DocType In SalesSplit) then
        begin
          result := true;
        end
        else
          if FBOMParentStockRec.StKitOnPurch and (DocType In PurchSplit) then
          begin
            result := true;
          end;
      end;
    end;
  except
    result := false;
  end;
end;


end.
