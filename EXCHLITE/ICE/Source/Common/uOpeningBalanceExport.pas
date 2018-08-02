unit uOpeningBalanceExport;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants, Forms,
  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
  ComnUnit,
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass,
  uXMLFileManager,
  uXMLWriter,
  uOpeningBalanceDB,
  uHistoryAdjustments,
  uTransactionTracker
  ;

{$I ice.inc}

type
  TAccumulatorAddMode = (aamFromLine, aamFromTransaction, aamFromNominal, aamForDiscount, aamForCurrency);
  TOpeningBalanceExport = class(_ExportBase)
  private
    FileManager: TXMLFileManager;
    XMLWriter: TXMLWriter;
    StartYear, StartPeriod: Byte;
    EndYear, EndPeriod: Byte;
    TargetDocType: DocTypes;
    PrecedingDateAsString: string;
    VarianceGLCode: LongInt;
    oToolkit: IToolkit;
    oTrans: ITransaction3;
    OB: TOBOpeningBalance;
    OBAccumulator: TOBAccumulator;
    OBDiscount: TOBDiscount;
    OBOriginator: TOBOriginator;
    OBMatchLink: TOBMatchLink;
    Adjustments: THistoryAdjustments;
    Tracker: TTransactionTracker;
    // Accumulator methods
    function AccumulateAccounts: Boolean;
    function AccumulateNominals: Boolean;
    procedure BuildOpeningBalances;
    procedure BuildMatchingRecords;
    procedure ExportAccumulatedValues;
    procedure ExportTransaction;
    procedure ExportTransactionHeader;
    procedure ExportTransactionLine;
    function ExportFullTransaction: Boolean;
    procedure ExportFullTransactionLine(Line: ITransactionLine3);
    procedure ExportFullTransactionHeader;
    procedure ExportMatching;
    function ConvertToBase(Amount: Double): Double;
    function InitialiseFiles: Boolean;
    function CreateAccumulator: Integer;
    function CreateAdjustmentsFile: Integer;
    function CreateDiscountFile: Integer;
    function CreateOriginatorFile: Integer;
    function CreateOpeningBalanceFile: Integer;
    function CreateMatchingFile: Integer;
    function GLCodeIsNegative: Boolean;
    function AccountCodeIsBlank: Boolean;
    function FindAccumulator: Boolean;
    function FindDiscount: Boolean;
    function FindNOMAccumulator: Boolean;
    procedure AddAccumulator(Mode: TAccumulatorAddMode);
    procedure AddDiscount;
    procedure AddTransaction;
    procedure UpdateAccumulator;
    procedure UpdateTracker;
    function RecordInRange: Boolean;
    function RecordInDripFeedRange: Boolean;
    function DetermineTargetDocType: DocTypes;
    function OpenGLStructure: LongInt;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  CTKUtil,
  ETDateU,
  DateUtils,
  uBaseClass,
  BtKeys1U,
  EtStrU,
  MiscU,
  CurrncyU,
  VarRec2U,
  Math,
  ETMiscU,
  SavePos
  ;

const
  NOT_REQUIRED = JPA;
  VATCodes:       array[1..23] of Char = ('S','E','Z','M','I','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATCodesLessMI: array[1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

function GetUDPeriodYear_Ext(pDataPath, pDate : pChar; var iPeriod : smallint; var iYear : smallint) : smallint; stdcall; external 'UDPeriod.dll';
function GetDateFromUDPY_Ext(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall; external 'UDPeriod.dll';
function UseUDPeriods(pDataPath : pChar) : smallint; stdcall; external 'UDPeriod.dll';
procedure SuppressErrorMessages(iSetTo : smallint) stdcall; external 'UDPeriod.dll';


// =============================================================================
// TOpeningBalanceExport
// =============================================================================
constructor TOpeningBalanceExport.Create;
begin
  inherited Create;
  UseFiles := True;
  FileManager := TXMLFileManager.Create;
  FileManager.BaseFileName := 'obal';
  XMLWriter := TXMLWriter.Create;
  XMLWriter.NameSpace := 'obal';
  OB := TOBOpeningBalance.Create;
  OBAccumulator := TOBAccumulator.Create;
  OBDiscount := TOBDiscount.Create;
  OBOriginator := TOBOriginator.Create;
  OBMatchLink := TOBMatchLink.Create;
  Adjustments := THistoryAdjustments.Create;
end;

// -----------------------------------------------------------------------------

destructor TOpeningBalanceExport.Destroy;
begin
  if Assigned(oToolkit) then
  begin
    oTrans := nil;
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;
  Close_File(F[HistAdjF]);
  Close_File(F[CustF]);
  Close_File(F[SysF]);
  Close_File(F[OrigF]);
  Close_File(F[OBalF]);
  Close_File(F[OBMatchF]);
  Close_File(F[OBRefF]);
  Close_File(F[DiscF]);
  Close_File(F[AccumF]);
  Close_File(F[IdetailF]);
  Close_File(F[InvF]);
  Adjustments.Free;
  OBMatchLink.Free;
  OBAccumulator.Free;
  OBDiscount.Free;
  OBOriginator.Free;
  OB.Free;
  Tracker.Free;
  XMLWriter.Free;
  FileManager.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.LoadFromDB: Boolean;
var
  DateBuffer: PChar;
  PrecedingDate: TDateTime;
  TempPeriod, TempYear: SmallInt;
  dd, mm, yy: Word;
begin
  Result := False;
  FileManager.Directory := DataPath + cICEFOLDER;

  { Remove any existing opening balance files from the export path. }
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');

  if not VarIsNull(Param1) then
  begin
    { Get the start of the drip-feed period from the parameters. }
    if (Param2 > 1900) then
      Param2 := Param2 - 1900;
    if (Param4 > 1900) then
      Param4 := Param4 - 1900;
    StartPeriod := Param1;
    StartYear   := Param2;
    EndPeriod   := Param3;
    EndYear     := Param4;
    XMLWriter.StartPeriod := StartPeriod;
    XMLWriter.StartYear   := StartYear;
    XMLWriter.EndPeriod   := EndPeriod;
    XMLWriter.EndYear     := EndYear;
  end
  else
  begin
    StartPeriod := 0;
    StartYear   := 0;
    EndPeriod   := 0;
    EndYear     := 0;
  end;

  if InitialiseFiles then
  try
    { Calculate the period which immediately precedes the start of the
      drip-feed -- opening balances will use this as the transaction date. }
    GetMem(DateBuffer, 9);
    try
      { Convert the drip-feed Year and Period into a string-date. }
      if (UseUDPeriods(PChar(DataPath)) = 1) then
      begin
        if GetDateFromUDPY_Ext(PChar(DataPath), DateBuffer, StartPeriod, StartYear) <> 0 then
        begin
          StrPCopy(DateBuffer, SimplePr2Date(StartPeriod, StartYear));
{
          DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                       'Invalid period and year: ' +
                       IntToStr(StartPeriod) + ', ' + IntToStr(StartYear),
                       cCONNECTINGDBERROR);
}
        end;
      end
      else
        StrPCopy(DateBuffer, SimplePr2Date(StartPeriod, StartYear));
      { Decode the string-date into day, month, and year. }
      DateStr(DateBuffer, dd, mm, yy);
      { Re-encode day, month, and year as a TDateTime and subtract one day,
        giving us the last day of the immediately-preceding period. }
      PrecedingDate := EncodeDate(yy, mm ,dd) - 1;
      { Decode the resulting date into day, month, and year. }
      DecodeDate(PrecedingDate, yy, mm, dd);
      { Re-encode the day, month, and year as a string-date. }
      PrecedingDateAsString := StrDate(yy, mm, dd);
      { Copy the string-date into the temporary PChar buffer... }
      StrPCopy(DateBuffer, PrecedingDateAsString);
      { ...and get the Year and Period for the date. }
      if (UseUDPeriods(PChar(DataPath)) = 1) then
      begin
        TempPeriod := PrecedingPeriod;
        TempYear   := DripFeedYear;
        SuppressErrorMessages(1);
        if GetUDPeriodYear_Ext(PChar(DataPath), DateBuffer, TempPeriod, TempYear) <> 0 then
        begin
{
          DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                       'Invalid period and year: ' +
                       IntToStr(StartPeriod) + ', ' + IntToStr(StartYear),
                       cCONNECTINGDBERROR);
}
          if (StartPeriod < 2) then
          begin
            DripFeedYear   := StartYear - 1;
            PrecedingPeriod := Syss.PrinYr;
          end
          else
          begin
            PrecedingPeriod := StartPeriod - 1;
            DripFeedYear   := StartYear;
          end;
        end
        else
        begin
          PrecedingPeriod := TempPeriod;
          DripFeedYear   := TempYear;
        end;
      end
      else
        SimpleDate2Pr(PrecedingDateAsString, PrecedingPeriod, DripFeedYear);
    finally
      Dispose(DateBuffer);
    end;

    Result := AccumulateAccounts;

    if Result then
      Result := AccumulateNominals;

    if Result then
    begin
      BuildOpeningBalances;
      BuildMatchingRecords;
      ExportAccumulatedValues;
      ExportMatching;
      Result := (Files.Count > 0);
      UpdateTracker;
    end;

  except
    on E:Exception do
      DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' + E.Message, 0)

  end;

end;

function TOpeningBalanceExport.InitialiseFiles: Boolean;
var
  FuncRes: LongInt;
begin
  Result := True;

  oToolkit := OpenToolkit(DataPath, True);
  if not Assigned(oToolkit) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: Cannot create COM Toolkit instance', cCONNECTINGDBERROR);
    Result := False;
    Exit;
  end;
  oTrans := oToolkit.Transaction as ITransaction3;

  { Open the transaction header file }
  FuncRes := Open_File(F[InvF], DataPath + FileNames[InvF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open transaction header file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the transaction lines file }
  FuncRes := Open_File(F[IdetailF], DataPath + FileNames[IdetailF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open transaction lines file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  SetDrive := DataPath;

  { Create accumulator file }
  FuncRes := CreateAccumulator;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create Accumulator file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the accumulator file }
  FuncRes := Open_File(F[AccumF], DataPath + FileNames[AccumF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Accumulator file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Create Transaction Settlement Discount file }
  FuncRes := CreateDiscountFile;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create Settlement Discount file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the Discount file }
  FuncRes := Open_File(F[DiscF], DataPath + FileNames[DiscF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Settlement Discount file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Create the Original Transactions link file }
  FuncRes := CreateOriginatorFile;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create Original Transactions Link file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the Originator file }
  FuncRes := Open_File(F[OrigF], DataPath + FileNames[OrigF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Original Transactions Link file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Create the Opening Balance file }
  FuncRes := CreateOpeningBalanceFile;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create Opening Balance file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the Opening Balance file }
  FuncRes := Open_File(F[OBalF], DataPath + FileNames[OBalF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Opening Balance file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Create the Opening Balance Matching file }
  FuncRes := CreateMatchingFile;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create Opening Balance Matching file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the Opening Balance Matching file }
  FuncRes := Open_File(F[OBMatchF], DataPath + FileNames[OBMatchF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Opening Balance Matching file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the System Settings file to get the G/L Structure }
  FuncRes := OpenGLStructure;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open System Settings file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the Customer/Supplier file }
  FuncRes := Open_File(F[CustF], DataPath + FileNames[CustF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open Customer/Supplier file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Create the History Adjustments file }
  FuncRes := CreateAdjustmentsFile;
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot create History Adjustments file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  { Open the History Adjustments file }
  FuncRes := Open_File(F[HistAdjF], DataPath + FileNames[HistAdjF], 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.LoadFromDB: ' +
                 'Cannot open History Adjustments file',
                 cCONNECTINGDBERROR,
                 IntToStr(FuncRes));
    Result := False;
    Exit;
  end;

  Tracker := TTransactionTracker.Create;
  Tracker.DataPath := DataPath;

end;

// -----------------------------------------------------------------------------
// Accumulator methods
// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateAccumulator: Integer;
begin
  Result := OBAccumulator.InitFile;
  if (Result = 0) then
    Result := OBAccumulator.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateAdjustmentsFile: Integer;
begin
  Result := Adjustments.InitFile;
  if (Result = 0) then
    Result := Adjustments.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateDiscountFile: Integer;
begin
  Result := OBDiscount.InitFile;
  if (Result = 0) then
    Result := OBDiscount.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateOriginatorFile: Integer;
begin
  Result := OBOriginator.InitFile;
  if (Result = 0) then
    Result := OBOriginator.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateOpeningBalanceFile: Integer;
begin
  Result := OB.InitFile;
  if (Result = 0) then
    Result := OB.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.CreateMatchingFile: Integer;
begin
  Result := OBMatchLink.InitFile;
  if (Result = 0) then
    Result := OBMatchLink.CreateFile(DataPath);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.AccumulateAccounts: Boolean;

  function IsNotSettled: Boolean;
  begin
    Result := (oTrans.thOutstanding <> #0);
//    Result := False;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
begin
  try
    oTrans.Index := thIdxFolio;

    Key     := '';
    FuncRes := Find_Rec(B_GetFirst, F[IdetailF], IdetailF, Id, 0, Key);

    Result  := (FuncRes = 0);
    while (FuncRes = 0) do
    begin

      Application.ProcessMessages;

      { Ignore lines with negative G/L Codes or blank Customer/Supplier
        codes. }
      if GLCodeIsNegative or AccountCodeIsBlank then
      begin
        FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, 0, Key);
        Continue;
      end;

      { Determine the target Doc Type (i.e. the document type under which
        the values should be accumulated for the current transaction line). }
      TargetDocType := DetermineTargetDocType;
      if (TargetDocType = NOT_REQUIRED) then
      begin
        FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, 0, Key);;
        Continue;
      end;

      { Find the transaction header record }
      Key := FullNomKey(Id.FolioRef);
      FuncRes := oTrans.GetEqual(Key);
      if (FuncRes = 0) then
      begin
        { If this is an unallocated or partially allocated record, export the
          whole transaction and do not accumulate the values. }
        if (IsNotSettled and RecordInRange) or (RecordInDripFeedRange) then
        begin
          AddTransaction;
        end
        else if RecordInRange then
        begin
          { Find the accumulating record }
          if not FindAccumulator then
          begin
            Id.VATCode := #0;
            AddAccumulator(aamFromLine);
          end
          else
          begin
            FuncRes := OBOriginator.Add(oTrans.thOurRef, Id.IdDocHed, (Id.NomCode = VarianceGLCode));
            if (FuncRes <> 0) then
              DoLogMessage('TOpeningBalanceExport.AccumulateAccounts: Failed to add Originator record',
                           cUPDATINGDBERROR,
                           IntToStr(FuncRes));
          end;

          { Accumulate the values }
          UpdateAccumulator;

          if not FindDiscount then
            AddDiscount;
        end;
      end
      else
      begin
        DoLogMessage('TOpeningBalanceExport.AccumulateAccounts: Cannot find transaction ' +
                     'header for folio ' + IntToStr(Id.FolioRef),
                     cUPDATINGDBERROR,
                     IntToStr(FuncRes));
      end;

      { Find the next record }
      FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, 0, Key);;

    end;

  except
    on E:Exception do
    begin
      Result := False;
      DoLogMessage('TOpeningBalanceExport.AccumulateAccounts: ' + E.Message, 0);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.AccumulateNominals: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
begin
  try
    oTrans.Index := thIdxFolio;
    TargetDocType := NMT;

    Key := '';
    FuncRes := Find_Rec(B_GetFirst, F[IdetailF], IdetailF, Id, 0, Key);

    Result  := (FuncRes = 0);
    while (FuncRes = 0) do
    begin

      Application.ProcessMessages;

      { Ignore lines with negative G/L Codes, or records which are after the
        end of the drip-feed period. }
      if GLCodeIsNegative or (not (RecordInRange or RecordInDripFeedRange)) or (Id.IdDocHed <> NMT) then
      begin
        FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, 0, Key);;
        Continue;
      end;

      { Find the transaction header record }
      Key := FullNomKey(Id.FolioRef);
      FuncRes := oTrans.GetEqual(Key);
      if FuncRes = 0 then
      begin
        if RecordInDripFeedRange then
        begin
          AddTransaction;
        end
        else
        begin
          { Find the accumulating record }
          if not FindNOMAccumulator then
            AddAccumulator(aamFromNominal);

          { Accumulate the values }
          UpdateAccumulator;
        end;
      end
      else
      begin
        DoLogMessage('TOpeningBalanceExport.AccumulateNominals: Cannot find transaction ' +
                     'header for folio ' + IntToStr(Id.FolioRef),
                     cUPDATINGDBERROR,
                     IntToStr(FuncRes));
      end;

      { Find the next record }
      FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, 0, Key);;

    end;
  except
    on E:Exception do
    begin
      Result := False;
      DoLogMessage('TOpeningBalanceExport.AccumulateAccounts: ' + E.Message, 0);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.AccountCodeIsBlank: Boolean;
begin
  Result := (Trim(Id.CustCode) = '');
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.GLCodeIsNegative: Boolean;
begin
  Result := (Id.NomCode < 0);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.RecordInRange: Boolean;
begin
  Result := ((Id.PYr < DripFeedYear) or
            ((Id.PYr = DripFeedYear) and (Id.PPr <= PrecedingPeriod)));
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.RecordInDripFeedRange: Boolean;
var
  StartYrPr, EndYrPr: Integer;
  IdYrPr: Integer;
begin
  StartYrPr := (StartYear * 1000) + StartPeriod;
  EndYrPr   := (EndYear * 1000) + EndPeriod;
  IdYrPr    := (Id.PYr * 1000) + Id.PPr;
  Result := (IdYrPr >= StartYrPr) and (IdYrPr <= EndYrPr);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.DetermineTargetDocType: DocTypes;
begin
  if Id.IdDocHed in [SIN, SJI, SBT] then
    Result := SJI
  else if Id.IdDocHed in [PIN, PJI, PBT] then
    Result := PJI
  else if Id.IdDocHed in [SCR, SJC]  then
    Result := SJC
  else if Id.IdDocHed in [PCR, PJC] then
    Result := PJC
  else if Id.IdDocHed in [SRI, PPI, SRF, PRF, SRC, PPY] then
    Result := Id.IdDocHed
  else
    Result := NOT_REQUIRED;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.AddAccumulator(Mode: TAccumulatorAddMode);
var
  FuncRes: Integer;
  OriginalDocType: DocTypes;
  Currency: SmallInt;
begin
  OriginalDocType   := Id.IdDocHed;
//  if SameValue(Id.NetValue, 0.00) then
//    Exit;
  { Fill in the basic details }
  FillChar(Accum, SizeOf(Accum), 0);
  Accum.Id          := Id;
  Accum.CtrlGL      := oTrans.thControlGL; // Inv.CtrlNom;
  Accum.Outstanding := False;
  if (Id.PYr < DripFeedYear) then
  begin
    Accum.Id.PYr    := Id.PYr;
    Accum.Id.PPr    := 12;
  end
  else
  begin
    Accum.Id.PYr    := DripFeedYear;
    Accum.Id.PPr    := PrecedingPeriod;
  end;
  Accum.Id.PDate    := Id.PDate;
  Accum.PaymentMode := ' ';

  { Force Currency Variance lines to be against the same Opening Balance as
    their original transaction. }
  Currency := Accum.Id.Currency;
  if Accum.Id.NomCode = VarianceGLCode then
    Currency := oTrans.thCurrency;

  case Mode of
    aamFromLine:
      begin
        Accum.Id.IdDocHed := DetermineTargetDocType;

        if (Accum.Id.IdDocHed in [SRI, PPI]) then
        begin
          if (Id.LineNo=RecieptCode) then
          begin
            { This is a payment line }
            Accum.PaymentMode := 'P';
          end
          else
          begin
            { This is an invoice line }
            Accum.PaymentMode := 'I';
          end;
        end;

        Accum.OBalCode := BuildOBalCode(Accum.Id.IdDocHed, Id.CustCode,
                                        Currency, oTrans.thControlGL,
                                        Id.PYr);
      end;
    aamFromTransaction:
      begin
        Accum.OBalCode    := OBal.OBalCode;
        Accum.Outstanding := True;
        Accum.Id.PYr      := Id.PYr;
        Accum.Id.PPr      := Id.PPr;
      end;
    aamFromNominal:
      begin
        Accum.OBalCode    := RightJustify(IntToStr(Id.FolioRef), '0', 10);
        Accum.VATIO       := ((oTrans.thAsNOM) as ITransactionAsNOM2).tnVatIO;
        Accum.Id.IdDocHed := NMT;
        Accum.Id.PYr      := Id.PYr;
        Accum.Id.PPr      := Id.PPr;
      end;
    aamForDiscount:
      begin
        Accum.OBalCode    := OBal.OBalCode;
        Accum.Id.IdDocHed := DetermineTargetDocType;
        Accum.Id.Currency := oTrans.thCurrency;
      end;
    aamForCurrency:
      begin
        Accum.OBalCode    := OBal.OBalCode;
        Accum.Id.IdDocHed := DetermineTargetDocType;
      end;
  end;

  Accum.Id.NetValue := 0.00;  // These will be recalculated by
  Accum.Id.VAT      := 0.00;  // UpdateAccumulator

  { Add the record }
  FuncRes := Add_Rec(F[AccumF], AccumF, Accum, 0);
  if (FuncRes = 0) then
  begin
    if not (Mode in [aamFromNominal, aamForDiscount, aamForCurrency]) then
    begin
      FuncRes := OBOriginator.Add(oTrans.thOurRef, OriginalDocType, (Accum.Id.NomCode = VarianceGLCode));
      if (FuncRes <> 0) then
        DoLogMessage('TOpeningBalanceExport.AddAccumulator: Failed to add Originator record for ' + oTrans.thOurRef,
                     cUPDATINGDBERROR,
                     IntToStr(FuncRes));
    end;
  end
  else
  begin
    DoLogMessage('TOpeningBalanceExport.AddAccumulator: Cannot add Accumulator record for ' + Accum.OBalCode,
                 cUPDATINGDBERROR,
                 IntToStr(FuncRes));
  end
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.AddDiscount;
var
  FuncRes: Integer;
begin
  if (oTrans.thSettleDiscAmount <> 0) and (oTrans.thSettleDiscTaken) then
  begin
    FuncRes := OBDiscount.Add(TargetDocType, oTrans.thSettleDiscAmount, oTrans.thOurRef);
    if (FuncRes <> 0) then
    begin
      DoLogMessage('TOpeningBalanceExport.AddDiscount: Cannot add record',
                   cUPDATINGDBERROR,
                   IntToStr(FuncRes));
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.AddTransaction;
{ This method is used for adding a complete transaction (including the header
  and all the transaction lines) to the Accumulator and the Opening Balance
  file. It is used for exporting transactions which are not allocated or only
  partially allocated -- these transactions are not summarised into Opening
  Balance records, but are instead exported exactly as they are.

  It should only be called when oTrans holds the required record. }

  function IncludeRecord: Boolean;
  var
    DocCode: string;
  const
    DocCodes: string =
      'NOM SIN SJI SJC SRF SRC SCR SRI PIN PJI PJC PPI PRF PCR PPY SBT PBT';
  begin
    DocCode := Copy(oTrans.thOurRef, 1, 3);
    Result := (Pos(DocCode, DocCodes) <> 0);
    if Result then
    begin
      { Don't include auto-items. }
      if (oTrans.thRunNo = -1) or
         (oTrans.thRunNo = -2) or
         ((oTrans.thAutoSettings <> nil) and (oTrans.thAutoSettings.atAutoTransaction)) then
        Result := False;
    end;
  end;

var
  FuncRes: Integer;
  Key: Str255;
begin
  if IncludeRecord then
  begin
    { Try to find an existing record. }
    Key := FullOurRefKey(oTrans.thOurRef);
    FuncRes := Find_Rec(B_GetEq, F[OBalF], OBalF, OBal, 0, Key);
    if ((FuncRes = 4) or (FuncRes = 9)) then
    begin
      { Not found -- add a new Opening Balance transaction, using the details
        from oTrans, and mark it as an Outstanding transaction }
      OB.AddFromTransaction(oTrans.thOurRef, oTrans.thFolioNum);
      { Add the transaction lines }
      Key := FullNomKey(oTrans.thFolioNum);
      with TBtrieveSavePosition.Create do
      try
        SaveFilePosition(IdetailF, GetPosKey);
        FuncRes := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, Id, IdFolioK, Key);
        while (FuncRes = 0) and (Id.FolioRef = oTrans.thFolioNum) do
        begin
          { Add record to Accumulator }
          AddAccumulator(aamFromTransaction);
          { Add record to History Adjustments }
          Adjustments.Add;
          FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, IdFolioK, Key);
        end;
      finally
        RestoreSavedPosition(True);
        Free;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.FindAccumulator: Boolean;
var
  FuncRes: Integer;
  Key: Str255;
  OBalCode: Str10;
  PaymentMode: Char;
  Currency: SmallInt;
begin
  if (Id.IdDocHed in [SRI, PPI]) then
  begin
    if (Id.LineNo=RecieptCode) then
    begin
      { This is a payment line }
      PaymentMode := 'P';
    end
    else
    begin
      { This is an invoice line }
      PaymentMode := 'I';
    end;
  end
  else
    PaymentMode := ' ';

  Currency := Accum.Id.Currency;
  if Id.NomCode = VarianceGLCode then
    Currency := oTrans.thCurrency;

  { OBalCode + CostCentre + Dept + NomCode + PaymentMode }
  OBalCode := BuildOBalCode(DetermineTargetDocType, Id.CustCode, Currency, oTrans.thControlGL, Id.PYr);
  Key := OBalCode +
         Id.CCDep[True] +
         Id.CCDep[False] +
         FullNomKey(Id.NomCode) +
         PaymentMode;
  FuncRes := Find_Rec(B_GetEq, F[AccumF], AccumF, Accum, 0, Key);
  Result := (FuncRes = 0);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.FindDiscount: Boolean;
var
  Key: ShortString;
  FuncRes: Integer;
begin
  { DocType + CustCode + Currency + OurRef }
  Key := BuildOBalCode(Id.IdDocHed, Id.CustCode, Id.Currency, oTrans.thControlGL, Id.PYr);
  FuncRes := Find_Rec(B_GetEq, F[DiscF], DiscF, Discount, 0, Key);
  Result := (FuncRes = 0);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.FindNOMAccumulator: Boolean;
var
  Key: Str255;
  OBalCode: Str10;
  FuncRes: Integer;
  VATIO: Byte;
begin
  VATIO := ((oTrans.thAsNOM) as ITransactionAsNOM2).tnVatIO;

  { OBalCode + CostCentre + Dept + NomCode + VATIO }
  OBalCode := RightJustify(IntToStr(Id.FolioRef), '0', 10);
  Key := OBalCode +
         Id.CCDep[True] +
         Id.CCDep[False] +
         FullNomKey(Id.NomCode) +
         Char(VATIO);
  FuncRes := Find_Rec(B_GetEq, F[AccumF], AccumF, Accum, 2, Key);
  Result := (FuncRes = 0);

end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.UpdateAccumulator;
{ Updates the accumulated values for the current record. }
var
  FuncRes: Integer;
  Value: Double;
begin
  Value := InvLTotal(Id, True, 0);// * Id.Qty;
{
  if (Id.Payment = 'Y') then
  begin
    Accum.Id.NetValue := Accum.Id.NetValue - Value;
    Accum.Id.VAT      := Accum.Id.VAT - Id.VAT;
  end
  else
  begin
}
    Accum.Id.NetValue := Accum.Id.NetValue + Value;
    Accum.Id.VAT      := Accum.Id.VAT + Id.VAT;
{
  end;
}
  FuncRes := Put_Rec(F[AccumF], AccumF, Accum, 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceExport.UpdateAccumulator: Cannot save record',
                 cUPDATINGDBERROR,
                 IntToStr(FuncRes));
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.BuildOpeningBalances;
{ Constructs the Opening Balance records, based on the records in the
  Accumulator file. }
var
  FuncRes: LongInt;
  Key: Str255;
  OBalCode: Str10;
  Amount: Double;
  StoredFolios: TStringList;
{
  CurrencyNet: Double;
  BaseNet: Double;
  VATAmount: Double;
  Discrepancy: Double;
  AccumCopy: AccumRec;
}
  TransKey: Str255;

  // ...........................................................................
  function StartOfNextTransaction: Boolean;
  begin
    Result := (OBalCode <> Accum.OBalCode);
  end;
  // ...........................................................................

begin
  { Build the basic Opening Balance headers }
  Key := '';
  StoredFolios := TStringList.Create;
  try
    FuncRes  := Find_Rec(B_GetFirst, F[AccumF], AccumF, Accum, 0, Key);
    OBalCode := '';
    while (FuncRes = 0) do
    begin
      if (not Accum.Outstanding) then
      begin
        TransKey := FullNomKey(Accum.Id.FolioRef);
        FuncRes := oTrans.GetEqual(TransKey);
        if (FuncRes <> 0) then
          DoLogMessage('TOpeningBalanceExport.BuildOpeningBalances: ' +
                       'Cannot find transaction for folio ' + IntToStr(Accum.Id.FolioRef),
                       cUPDATINGDBERROR,
                       IntToStr(FuncRes));
        if StartOfNextTransaction then
        begin
          if (StoredFolios.Count > 0) then
          begin
            StoredFolios.Clear;
            Put_Rec(F[OBalF], OBalF, OBal, 0);
          end;
          OB.Add(oTrans);
          OBalCode := OBal.OBalCode;
        end;
        if StoredFolios.IndexOf(IntToStr(Accum.Id.FolioRef)) = -1 then
        begin
          StoredFolios.Add(IntToStr(Accum.Id.FolioRef));
          OBal.Inv.TotalReserved := OBal.Inv.TotalReserved + (oTrans as IBetaTransaction).thTotalReserved;
          OBal.Inv.TotalInvoiced := OBal.Inv.TotalInvoiced + (oTrans as IBetaTransaction).thTotalInvoiced;
          OBal.Inv.Variance      := OBal.Inv.Variance + (oTrans as IBetaTransaction).thVariance;
          OBal.Inv.TotalOrdered  := OBal.Inv.TotalOrdered + (oTrans as IBetaTransaction).thTotalOrdered;
          OBal.Inv.ReValueAdj    := OBal.Inv.ReValueAdj + (oTrans as IBetaTransaction).thReValueAdj;
        end;
      end;
      FuncRes := Find_Rec(B_GetNext, F[AccumF], AccumF, Accum, 0, Key);
    end;
  finally
    StoredFolios.Free;
  end;
  { Traverse the Opening Balance headers to add any required adjustment
    transaction lines, and to calculate the additional header values }
  Key := '';
  FuncRes  := Find_Rec(B_GetFirst, F[OBalF], OBalF, OBal, 0, Key);
  OBalCode := '';
  while (FuncRes = 0) do
  begin
    { Update the discount amounts for this Opening Balance }
    Amount := 0.00;
    Key := OBal.OBalCode;
    FuncRes := Find_Rec(B_GetGEq, F[DiscF], DiscF, Discount, 0, Key);
    while (FuncRes = 0) and (Discount.OBalCode = OBalCode) do
    begin
      Amount := Amount + Discount.DiscSetAm;
      FuncRes := Find_Rec(B_GetNext, F[DiscF], DiscF, Discount, 0, Key);
    end;
    { Add a transaction line if a discount amount was found }
    if (Amount <> 0.00) then
    begin
      { Find the first transaction line for this Opening Balance, and use the
        details as the basis for the new transaction line }
      Key := OBal.OBalCode;
      if Find_Rec(B_GetNext, F[AccumF], AccumF, Accum, 0, Key) = 0 then
      begin
        Accum.Id.NetValue := Amount;
        Accum.Id.Desc     := 'Discount adjustment';
        AddAccumulator(aamForDiscount);
      end
      else
        DoLogMessage('TOpeningBalanceExport.BuildOpeningBalances: ' +
                     'Cannot find transaction line for ' + OBal.OBalCode,
                     cUPDATINGDBERROR,
                     IntToStr(FuncRes));
    end;
    FuncRes := Find_Rec(B_GetNext, F[OBalF], OBalF, OBal, 0, Key);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.BuildMatchingRecords;

  function FindTransaction: Boolean;
  var
    FuncRes: LongInt;
    Key: WideString;
  begin
    Key := FullNomKey(Originator.FolioNum);
    oTrans.Index := thIdxFolio;
    FuncRes := oTrans.GetEqual(Key);
    Result := (FuncRes = 0);
  end;

var
  Key: Str255;
  FuncRes: LongInt;
  OBalCode: Str10;
  OBInvoice: OBalRec;
  OBReceipt: OBalRec;
begin
  Key := '';
  FuncRes := Find_Rec(B_GetFirst, F[OrigF], OrigF, Originator, 0, Key);
  while (FuncRes = 0) do
  begin
    { Only process Receipt transactions }
    if (not Originator.IsInvoice) and (not Originator.IsVariance) then
    begin
      { Locate the original transaction }
      if FindTransaction then
      begin
        { Work through all the Matching records }
        (oTrans.thMatching as IMatching2).maSearchType := maSearchTypeFinancial;
        FuncRes := oTrans.thMatching.GetFirst;
        while (FuncRes = 0) do
        begin
          if oTrans.thMatching.maType = maTypeFinancial then
          begin
            OBalCode := Originator.OBalCode;
            { Store the current location in the Originator file }
            with TBtrieveSavePosition.Create do
            try
              SaveFilePosition(OrigF, GetPosKey);
              { Find the matching Invoice record in the Originator file }
              Key := oTrans.BuildOurRefIndex(oTrans.thMatching.maDocRef);
              FuncRes := Find_Rec(B_GetEq, F[OrigF], OrigF, Originator, 1, Key);
              if (FuncRes = 0) then
              begin
                { The Opening Balance Code from this record is the DocCode (i.e.
                  the OurRef of the Opening Balance Invoice record), whereas the
                  Opening Balance Code from the record we were originally on is
                  the PayRef (i.e. the OurRef of the Opening Balance Receipt
                  record.

                  Locate the two Opening Balance records that match with these
                  codes, and use them to create a new Matching record. }
                Key := OBalCode;  // Opening Balance for Receipt
                FuncRes := Find_Rec(B_GetEq, F[OBalF], OBalF, OBReceipt, 0, Key);
                if (FuncRes = 0) then
                begin
                  Key := Originator.OBalCode; // Opening Balance for Invoice;
                  FuncRes := Find_Rec(B_GetEq, F[OBalF], OBalF, OBInvoice, 0, Key);
                end;
                if (FuncRes = 0) then
                begin
                  FuncRes := OBMatchLink.Add(oTrans.thMatching, OBInvoice, OBReceipt);
                  if (FuncRes <> 0) then
                    DoLogMessage('TOpeningBalanceExport.BuildMatchingRecords: ' +
                                 'Could not save Matching record for ' + OBalCode,
                                 cUPDATINGDBERROR,
                                 IntToStr(FuncRes));
                end
                else
                  DoLogMessage('TOpeningBalanceExport.BuildMatchingRecords: ' +
                               'Cannot locate invoice and receipts for ' + OBalCode,
                               cUPDATINGDBERROR,
                               IntToStr(FuncRes));
              end
              else
                DoLogMessage('TOpeningBalanceExport.BuildMatchingRecords: ' +
                             'Cannot find invoice matching receipt for ' + oTrans.thMatching.maDocRef,
                             cUPDATINGDBERROR,
                             IntToStr(FuncRes));

              { Restore the current location in the Originator file }
              RestoreSavedPosition(True);
            finally
              Free;
            end;
          end; // if oTrans.thMatching.maType = maTypeFinancial then...
          FuncRes := oTrans.thMatching.GetNext;
        end;
      end
      else
        DoLogMessage('TOpeningBalanceExport.BuildMatchingRecords: ' +
                     'Cannot find transaction for Folio ' + IntToStr(Originator.FolioNum),
                     cUPDATINGDBERROR,
                     IntToStr(FuncRes));
    end;
    FuncRes := Find_Rec(B_GetNext, F[OrigF], OrigF, Originator, 0, Key);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportAccumulatedValues;
var
  FuncRes: LongInt;
  Key: Str255;
  FileName: ShortString;
begin
  FileManager.BaseFileName := 'bal';
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');
  { Export outstanding transactions first }
  Key := '';
  FuncRes := Find_Rec(B_GetFirst, F[OBalF], OBalF, OBal, 0, Key);
  while (FuncRes = 0) do
  begin
    if OBal.Outstanding then
    begin
      { Start the XML file }
      XMLWriter.NameSpace := 'obal';
      XMLWriter.Start(cOPENINGBALANCETABLE, 'obal');
      if ExportFullTransaction then
      begin
        { Finish the XML file and save it to the XML directory. Store the
          file name in the Files list (this list will be passed back to the
          DSR, which will use it to find the files to be emailed) }
        XMLWriter.Finish;
        FileName := FileManager.SaveXML(XMLWriter.XML.Text);
        Files.Add(FileName);
      end;
    end;
(*
    else
    begin
      { Start the XML file }
      XMLWriter.NameSpace := 'obal';
      XMLWriter.Start(cOPENINGBALANCETABLE, 'obal');
      ExportTransaction;
      { Finish the XML file and save it to the XML directory. Store the
        file name in the Files list (this list will be passed back to the
        DSR, which will use it to find the files to be emailed) }
      XMLWriter.Finish;
      FileName := FileManager.SaveXML(XMLWriter.XML.Text);
    end;
*)
    FuncRes := Find_Rec(B_GetNext, F[OBalF], OBalF, OBal, 0, Key);
  end;
  { Now export Opening Balance transactions }
  FuncRes := Find_Rec(B_GetFirst, F[OBalF], OBalF, OBal, 0, Key);
  while (FuncRes = 0) do
  begin
    if not OBal.Outstanding then
    begin
      { Start the XML file }
      XMLWriter.NameSpace := 'obal';
      XMLWriter.Start(cOPENINGBALANCETABLE, 'obal');
      ExportTransaction;
      { Finish the XML file and save it to the XML directory. Store the
        file name in the Files list (this list will be passed back to the
        DSR, which will use it to find the files to be emailed) }
      XMLWriter.Finish;
      FileName := FileManager.SaveXML(XMLWriter.XML.Text);
      Files.Add(FileName);
    end;
    FuncRes := Find_Rec(B_GetNext, F[OBalF], OBalF, OBal, 0, Key);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportTransaction;
var
  Key: Str255;
  FuncRes: LongInt;
begin
  XMLWriter.AddOpeningTag('threc');
  Key := OBal.OBalCode;
  FuncRes := Find_Rec(B_GetGEq, F[AccumF], AccumF, Accum, 0, Key);

  { Add the transaction header }
  ExportTransactionHeader;

  { Add the transaction lines from the Accumulator file }
  while ((FuncRes = 0) and (OBal.OBalCode = Accum.OBalCode)) do
  begin
    XMLWriter.AddOpeningTag('tlrec');
    ExportTransactionLine;
    XMLWriter.AddClosingTag('tlrec');

    FuncRes := Find_Rec(B_GetNext, F[AccumF], AccumF, Accum, 0, Key);
  end;

  { Close the XML record node }
  XMLWriter.AddClosingTag('threc');

end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportTransactionHeader;
begin
  try
    XMLWriter.AddLeafTag('thunallocated',     False);
    XMLWriter.AddLeafTag('thobalcode',        OBal.OBalCode);
    XMLWriter.AddLeafTag('thaccode',          OBal.Inv.CustCode);
    XMLWriter.AddLeafTag('thcompanyrate',     OBal.Inv.CXrate[False]);
    XMLWriter.AddLeafTag('thcontrolgl',       Accum.CtrlGL);
    XMLWriter.AddLeafTag('thcurrency',        OBal.Inv.Currency);
    XMLWriter.AddLeafTag('thdailyrate',       OBal.Inv.CXrate[True]);

    XMLWriter.AddLeafTag('thdoctype',         OBal.Inv.InvDocHed);
    XMLWriter.AddLeafTag('thduedate',         PrecedingDateAsString);
    if Accum.Id.IdDocHed = NMT then
      XMLWriter.AddLeafTag('thmanualvat',     False)
    else
      XMLWriter.AddLeafTag('thmanualvat',     True);
    XMLWriter.AddLeafTag('thoperator',        'CS-CLIENT');
    XMLWriter.AddLeafTag('thperiod',          Accum.Id.PPr);
    XMLWriter.AddLeafTag('thtransdate',       PrecedingDateAsString);
    if (Accum.Id.IdDocHed = NMT) then
      XMLWriter.AddLeafTag('thvatio',         Accum.VATIO);
    XMLWriter.AddLeafTag('thyear',            Accum.Id.PYr);
//    XMLWriter.AddLeafTag('thamount',          OBal.Inv.InvNetVal);
//    XMLWriter.AddLeafTag('thvatamount',       OBal.Inv.InvVat);

    XMLWriter.AddLeafTag('thtotalreserved',   OBal.Inv.TotalReserved);
    XMLWriter.AddLeafTag('thtotalinvoiced',   OBal.Inv.TotalInvoiced);
    XMLWriter.AddLeafTag('thvariance',        OBal.Inv.Variance);
    XMLWriter.AddLeafTag('thtotalordered',    OBal.Inv.TotalOrdered);
    XMLWriter.AddLeafTag('threvalueadj',      OBal.Inv.ReValueAdj);

  except
    on e:Exception do
      DoLogMessage('TOpeningBalanceExport.ExportTransactionHeader',
                   cBUILDINGXMLERROR,
                   'Error: ' + e.message);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportTransactionLine;
begin
  try
    XMLWriter.AddLeafTag('tlcompanyrate',         Accum.Id.CXRate[False]);
    XMLWriter.AddLeafTag('tlcostcentre',          Accum.Id.CCDep[True]);
    XMLWriter.AddLeafTag('tlcurrency',            Accum.Id.Currency);
    XMLWriter.AddLeafTag('tldailyrate',           Accum.Id.CXrate[True]);
    XMLWriter.AddLeafTag('tldepartment',          Accum.Id.CCDep[False]);
    XMLWriter.AddLeafTag('tldescr',               'Opening Balance');
    XMLWriter.AddLeafTag('tlglcode',              Accum.Id.NomCode);
    XMLWriter.AddLeafTag('tlnetvalue',            Accum.Id.NetValue);
    XMLWriter.AddLeafTag('tlperiod',              Accum.Id.PPr);
    XMLWriter.AddLeafTag('tlvatamount',           Accum.Id.VAT);
    XMLWriter.AddLeafTag('tlvatcode',             Accum.Id.VATCode);
    XMLWriter.AddLeafTag('tlyear',                Accum.Id.PYr);
    XMLWriter.AddLeafTag('tlpaymentmode',         Accum.PaymentMode);
  except
    On e: Exception Do
      DoLogMessage('TTransactionExport.ExportTransactionLine', cBUILDINGXMLERROR, 'Error: ' +
        e.message);
  end;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.ConvertToBase(Amount: Double): Double;
begin
  Result := CurrncyU.Conv_TCurr(Amount, Accum.Id.CXrate[(Syss.TotalConv=XDayCode)],
                                Accum.Id.Currency, 0, False);
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.ExportFullTransaction: Boolean;
var
  Key: Str255;
  FuncRes: LongInt;
  Line: Integer;
  SuppressLines: array of integer;
  CanContinue: Boolean;

  function IsRevaluationNominal: Boolean;
  begin
    Result := (oTrans.thDocType = dtNMT) and
              (Trim(Lowercase(oTrans.thLongYourRef)) = 'auto re-valuation');
//              ((oTrans as IBetaTransaction).thRevalueAdj <> 0);
  end;

  procedure ListSuppressedLines;
  { Builds an array of the lines which are either Debtors/Creditors control
    accounts, or matching double-entry lines. Only used when dealing with
    revaluation nominals. }
  var
    Line, AcctLine, EntryLine: Integer;
    CtrlGL: array[0..1] of integer;
    TotalLines: Integer;
  begin
    CtrlGL[0] := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLDebtors];
    CtrlGL[1] := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLCreditors];
    AcctLine  := -1;
    { First, locate any Debtors/Creditors Control Account lines. }
    for Line := 1 to oTrans.thLines.thLineCount do
    begin
      if (oTrans.thLines[Line].tlGLCode = CtrlGL[0]) or
         (oTrans.thLines[Line].tlGLCode = CtrlGL[1]) then
      begin
        SetLength(SuppressLines, Length(SuppressLines) + 1);
        AcctLine := AcctLine + 1;
        SuppressLines[AcctLine] := Line;
      end;
    end;
    { If we found Debtors/Creditors Control Account lines, locate the
      matching double-entry lines, by comparing values (unfortunately, there is
      no other way of identifying the matching entries). }
    if AcctLine <> -1 then
    begin
      TotalLines := Length(SuppressLines);
      for Line := 0 to TotalLines - 1 do
      begin
        AcctLine := SuppressLines[Line];
        for EntryLine := 1 to oTrans.thLines.thLineCount do
        begin
          if (EntryLine <> AcctLine) then
            if (oTrans.thLines[EntryLine].tlNetValue = (oTrans.thLines[AcctLine].tlNetValue * -1.0)) then
            begin
              SetLength(SuppressLines, Length(SuppressLines) + 1);
              SuppressLines[Length(SuppressLines) - 1] := EntryLine;
            end;
        end;
      end;
    end;
  end;

  function IsSuppressed(Line: Integer): Boolean;
  var
    EntryLine: Integer;
  begin
    Result := False;
    for EntryLine := 0 to Length(SuppressLines) - 1 do
    begin
      if (SuppressLines[EntryLine] = Line) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

begin
  { Locate the original transaction }
  oTrans.Index := thIdxFolio;
  Key := FullNomKey(OBal.Inv.FolioNum);
  FuncRes := oTrans.GetEqual(Key);
  CanContinue := True;
  if (FuncRes = 0) then
  begin

    if IsRevaluationNominal then
    begin
      ListSuppressedLines;
      CanContinue := (Length(SuppressLines) <> oTrans.thLines.thLineCount);
    end;

    if CanContinue then
    begin
      { Add the transaction header }
      XMLWriter.AddOpeningTag('threc');
      ExportFullTransactionHeader;

      { Find all the transaction lines and add them to the XML file }
      for Line := 1 to oTrans.thLines.thLineCount do
      begin
        if not IsSuppressed(Line) then
        begin
          XMLWriter.AddOpeningTag('tlrec');
          ExportFullTransactionLine(oTrans.thLines[Line] as ITransactionLine3);
          XMLWriter.AddClosingTag('tlrec');
        end;
      end;

      { Close the XML record node }
      XMLWriter.AddClosingTag('threc');
    end;

  end
  else
  { TODO: Error - transaction not found }
  ;

  Result := CanContinue;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportFullTransactionHeader;

  function IsPaymentOrReceipt(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'PPY') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SRC');
  end;

  function IsInvoice(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'SIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'PIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'ADJ') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SCR');
  end;

var
  i: Integer;
  LineType: TTransactionLineType;
  RunNo: LongInt;
  RunStr: ShortString;
  HoldStatus: Byte;
begin
  try

    XMLWriter.AddLeafTag('thunallocated',      True);
    XMLWriter.AddLeafTag('thaccode',           OBal.Inv.CustCode);
    XMLWriter.AddLeafTag('thourref',           OBal.Inv.OurRef);
    XMLWriter.AddLeafTag('thamountsettled',    OBal.Inv.Settled);

    if (oTrans.thAsBatch <> nil) then
    with oTrans.thAsBatch do
    begin
      XMLWriter.AddOpeningTag('thasbatch');
      XMLWriter.AddLeafTag('btbankgl',        btBankGL);
      XMLWriter.AddLeafTag('btchequenostart', btChequeNoStart);
      XMLWriter.AddLeafTag('bttotal',         btTotal);
      XMLWriter.AddClosingTag('thasbatch');
    end;

    if (oTrans.thAsNOM <> nil) then
    with oTrans.thAsNOM as ITransactionAsNOM2 do
    begin
      XMLWriter.AddOpeningTag('thasnom');
      XMLWriter.AddLeafTag('tnautoreversing', tnAutoReversing);
      XMLWriter.AddLeafTag('tnvatio',         tnVatIO);
      XMLWriter.AddClosingTag('thasnom');
    end;

    if (oTrans.thAutoSettings <> nil) then
    with oTrans.thAutoSettings do
    begin
      XMLWriter.AddOpeningTag('thautosettings');
      XMLWriter.AddLeafTag('atautocreateonpost', atAutoCreateOnPost);
      XMLWriter.AddLeafTag('atenddate',          atEndDate);
      XMLWriter.AddLeafTag('atendperiod',        atEndPeriod);
      XMLWriter.AddLeafTag('atendyear',          atEndYear);
      XMLWriter.AddLeafTag('atincrement',        atIncrement);
      XMLWriter.AddLeafTag('atincrementtype',    atIncrementType);
      XMLWriter.AddLeafTag('atstartdate',        atStartDate);
      XMLWriter.AddLeafTag('atstartperiod',      atStartPeriod);
      XMLWriter.AddLeafTag('atstartyear',        atStartYear);
      XMLWriter.AddClosingTag('thautosettings');
    end;

    XMLWriter.AddLeafTag('thautotransaction', oTrans.thAutoTransaction);
    XMLWriter.AddLeafTag('thbatchdiscamount', oTrans.thBatchDiscAmount);
    XMLWriter.AddLeafTag('thcisdate',         oTrans.thCISDate);
    XMLWriter.AddLeafTag('thcisemployee',     oTrans.thCISEmployee);
    XMLWriter.AddLeafTag('thcismanualtax',    oTrans.thCISManualTax);
    XMLWriter.AddLeafTag('thcissource',       oTrans.thCISSource);
    XMLWriter.AddLeafTag('thcistaxdeclared',  oTrans.thCISTaxDeclared);
    XMLWriter.AddLeafTag('thcistaxdue',       oTrans.thCISTaxDue);
    XMLWriter.AddLeafTag('thcistotalgross',   oTrans.thCISTotalGross);
    XMLWriter.AddLeafTag('thcompanyrate',     oTrans.thCompanyRate);
    XMLWriter.AddLeafTag('thcontrolgl',       oTrans.thControlGL);
    XMLWriter.AddLeafTag('thcurrency',        oTrans.thCurrency);
    XMLWriter.AddLeafTag('thdailyrate',       oTrans.thDailyRate);

    if (oTrans.thDelAddress <> nil) then
    with oTrans.thDelAddress do
    begin
      XMLWriter.AddOpeningTag('thdeladdress');
      XMLWriter.AddLeafTag('street1',  Street1);
      XMLWriter.AddLeafTag('street2',  Street2);
      XMLWriter.AddLeafTag('town',     Town);
      XMLWriter.AddLeafTag('county',   County);
      XMLWriter.AddLeafTag('postcode', PostCode);
      XMLWriter.AddClosingTag('thdeladdress');
    end;

    XMLWriter.AddLeafTag('thdeliverynoteref', oTrans.thDeliveryNoteRef);

    RunStr := oTrans.thDeliveryRunNo;
    if IsPaymentOrReceipt(oTrans.thOurRef) and
       (Length(RunStr) >= 7) then
    begin
      Move (RunStr, RunNo, SizeOf(RunNo));
      XMLWriter.AddLeafTag('thdeliveryrunno', RunNo);
    end
    else if IsInvoice(oTrans.thOurRef) and
            (Length(RunStr) >= 7) then
    begin
      Move (RunStr, RunNo, SizeOf(RunNo));
      XMLWriter.AddLeafTag('thdeliveryrunno', RunNo);
    end
    else
      XMLWriter.AddLeafTag('thdeliveryrunno',   oTrans.thDeliveryRunNo);

    XMLWriter.AddLeafTag('thdeliveryterms',   oTrans.thDeliveryTerms);
    XMLWriter.AddLeafTag('thdoctype',         oTrans.thDocType);
    XMLWriter.AddLeafTag('thduedate',         oTrans.thDueDate);
    XMLWriter.AddLeafTag('themployeecode',    oTrans.thEmployeeCode);
    XMLWriter.AddLeafTag('thexternal',        oTrans.thExternal);
    XMLWriter.AddLeafTag('thfixedrate',       oTrans.thFixedRate);
    XMLWriter.AddLeafTag('thfolionum',        oTrans.thFolioNum);

    XMLWriter.AddOpeningTag('thgoodsanalysis');
    for i := Low(VATCodesLessMI) to High(VATCodesLessMI) do
    begin
      XMLWriter.AddOpeningTag('tgaline');
      XMLWriter.AddLeafTag('tgacode', VATCodesLessMI[i]);
      XMLWriter.AddLeafTag('tgavalue', oTrans.thGoodsAnalysis[VATCodes[i]]);
      XMLWriter.AddClosingTag('tgaline');
    end;
    XMLWriter.AddClosingTag('thgoodsanalysis');

    if (oTrans.thRunNo > 0) then
    begin
      { Do not export the hold status for posted transactions -- always
        export it as not on hold. Do not export the 'notes' status either, but
        preserve the Suspend status. }
      HoldStatus := oTrans.thHoldFlag and HoldSuspend;
      XMLWriter.AddLeafTag('thholdflag', HoldStatus);
    end
    else
      XMLWriter.AddLeafTag('thholdflag', oTrans.thHoldFlag);

    XMLWriter.AddLeafTag('thjobcode',             '');
    XMLWriter.AddLeafTag('thlastdebtchaseletter', oTrans.thLastDebtChaseLetter);

    XMLWriter.AddOpeningTag('thlineanalysis');
    for LineType := tlTypeNormal to tlTypeMaterials2 do //tlTypeMisc2
    begin
      XMLWriter.AddOpeningTag('tlaline');
      XMLWriter.AddLeafTag('tlacode', LineType);
      XMLWriter.AddLeafTag('tlavalue', oTrans.thLineTypeAnalysis[LineType]);
      XMLWriter.AddClosingTag('tlaline');
    end;
    XMLWriter.AddClosingTag('thlineanalysis');

    XMLWriter.AddLeafTag('thlongyourref',       oTrans.thLongYourRef);
    XMLWriter.AddLeafTag('thmanualvat',         oTrans.thManualVAT);
    XMLWriter.AddLeafTag('thnetvalue',          oTrans.thNetValue);
    XMLWriter.AddLeafTag('thnolabels',          oTrans.thNoLabels);
    XMLWriter.AddLeafTag('thoperator',          oTrans.thOperator);
    XMLWriter.AddLeafTag('thoutstanding',       oTrans.thOutstanding);
    XMLWriter.AddLeafTag('thperiod',            oTrans.thPeriod);
    XMLWriter.AddLeafTag('thpickingrunno',      oTrans.thPickingRunNo);
    XMLWriter.AddLeafTag('thporpicksor',        oTrans.thPORPickSOR);
    XMLWriter.AddLeafTag('thpostcompanyrate',   oTrans.thPostCompanyRate);
    XMLWriter.AddLeafTag('thpostdailyrate',     oTrans.thPostDailyRate);
    XMLWriter.AddLeafTag('thpostdiscamount',    oTrans.thPostDiscAmount);
    XMLWriter.AddLeafTag('thpostdisctaken',     oTrans.thPostDiscTaken);
    XMLWriter.AddLeafTag('thposteddate',        oTrans.thPostedDate);
    XMLWriter.AddLeafTag('thprepost',           oTrans.thPrePost);
    XMLWriter.AddLeafTag('thprinted',           oTrans.thPrinted);
                                                 
    try
      XMLWriter.AddLeafTag('thprocess',           oTrans.thProcess);
    except
      on E:Exception do
        XMLWriter.AddLeafTag('thprocess', ' ')
    end;

    XMLWriter.AddLeafTag('thrunno',             oTrans.thRunNo);
    XMLWriter.AddLeafTag('thsettlediscamount',  oTrans.thSettleDiscAmount);
    XMLWriter.AddLeafTag('thsettlediscdays',    oTrans.thSettleDiscDays);
    XMLWriter.AddLeafTag('thsettlediscperc',    oTrans.thSettleDiscPerc);
    XMLWriter.AddLeafTag('thsettledisctaken',   oTrans.thSettleDiscTaken);
    XMLWriter.AddLeafTag('thsettledvat',        oTrans.thSettledVat);
    XMLWriter.AddLeafTag('thsource',            oTrans.thSource);
    XMLWriter.AddLeafTag('thtagged',            oTrans.thTagged);
    XMLWriter.AddLeafTag('thtagno',             oTrans.thTagNo);
    XMLWriter.AddLeafTag('thtotalcost',         oTrans.thTotalCost);
    XMLWriter.AddLeafTag('thtotalcostapport',   oTrans.thTotalCostApport);
    XMLWriter.AddLeafTag('thtotallinediscount', oTrans.thTotalLineDiscount);
    XMLWriter.AddLeafTag('thtotalorderos',      oTrans.thTotalOrderOS);
    XMLWriter.AddLeafTag('thtotalvat',          oTrans.thTotalVAT);
    XMLWriter.AddLeafTag('thtotalweight',       oTrans.thTotalWeight);
    XMLWriter.AddLeafTag('thtransdate',         oTrans.thTransDate);
    XMLWriter.AddLeafTag('thtransportmode',     oTrans.thTransportMode);
    XMLWriter.AddLeafTag('thtransportnature',   oTrans.thTransportNature);
    XMLWriter.AddLeafTag('thuserfield1',        oTrans.thUserField1);
    XMLWriter.AddLeafTag('thuserfield2',        oTrans.thUserField2);
    XMLWriter.AddLeafTag('thuserfield3',        oTrans.thUserField3);
    XMLWriter.AddLeafTag('thuserfield4',        oTrans.thUserField4);

    XMLWriter.AddOpeningTag('thvatanalysis');
    for i := Low(VATCodesLessMI) to High(VATCodesLessMI) do
    begin
      XMLWriter.AddOpeningTag('tvaline');
      XMLWriter.AddLeafTag('tvacode', VATCodesLessMI[i]);
      XMLWriter.AddLeafTag('tvavalue', oTrans.thVATAnalysis[VATCodesLessMI[i]]);
      XMLWriter.AddClosingTag('tvaline');
    end;
    XMLWriter.AddClosingTag('thvatanalysis');

    XMLWriter.AddLeafTag('thvatclaimed',     oTrans.thVATClaimed);
    XMLWriter.AddLeafTag('thvatcompanyrate', oTrans.thVATCompanyRate);
    XMLWriter.AddLeafTag('thvatdailyrate',   oTrans.thVATDailyRate);
    XMLWriter.AddLeafTag('thyear',           oTrans.thYear);
    XMLWriter.AddLeafTag('thyourref',        oTrans.thYourRef);

    with oTrans as IBetaTransaction do
    begin
      XMLWriter.AddLeafTag('thordmatch', thOrdMatch);
      XMLWriter.AddLeafTag('thautopost', thAutoPost);
      XMLWriter.AddLeafTag('thtotalreserved', thTotalReserved);
      XMLWriter.AddLeafTag('thtotalinvoiced', thTotalInvoiced);
      XMLWriter.AddLeafTag('thvariance', thVariance);
      XMLWriter.AddLeafTag('thtotalordered', thTotalOrdered);
      XMLWriter.AddLeafTag('threvalueadj', thReValueAdj);
    end;

  except
    On e:Exception Do
      DoLogMessage('TOpeningBalance.ExportFullTransactionHeader', cBUILDINGXMLERROR, 'Error: ' +
        e.message);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportFullTransactionLine(Line: ITransactionLine3);
begin
  with Line do
  begin
    try
      { Add the field nodes. }
      XMLWriter.AddLeafTag('tlabslineno',    tlABSLineNo);
      XMLWriter.AddLeafTag('tlaccode',       tlAcCode);

      if (tlAsNOM <> nil) then
      with tlAsNOM as ITransactionLineAsNOM2 do
      begin
        XMLWriter.AddOpeningTag('tlasnom');
        XMLWriter.AddLeafTag('tlnnomvattype', tlnNomVatType);
        XMLWriter.AddClosingTag('tlasnom');
      end;

      XMLWriter.AddLeafTag('tlb2blineno',           tlB2BLineNo );
      XMLWriter.AddLeafTag('tlb2blinkfolio',        tlB2BLinkFolio );
      XMLWriter.AddLeafTag('tlbinqty',              tlBinQty );
      XMLWriter.AddLeafTag('tlbomkitlink',          tlBOMKitLink);
      XMLWriter.AddLeafTag('tlchargecurrency',      tlChargeCurrency);
      XMLWriter.AddLeafTag('tlcisrate',             tlCISRate );
      XMLWriter.AddLeafTag('tlcisratecode',         tlCISRateCode );
      XMLWriter.AddLeafTag('tlcompanyrate',         tlCompanyRate);
      XMLWriter.AddLeafTag('tlcosdailyrate',        tlCOSDailyRate );
      XMLWriter.AddLeafTag('tlcost',                tlCost);
      XMLWriter.AddLeafTag('tlcostapport',          tlCostApport );
      XMLWriter.AddLeafTag('tlcostcentre',          tlCostCentre);
      XMLWriter.AddLeafTag('tlcurrency',            tlCurrency);
      XMLWriter.AddLeafTag('tldailyrate',           tlDailyRate);
      XMLWriter.AddLeafTag('tldepartment',          tlDepartment);
      XMLWriter.AddLeafTag('tldescr',               tlDescr);
      XMLWriter.AddLeafTag('tldiscflag',            tlDiscFlag);
      XMLWriter.AddLeafTag('tldiscount',            tlDiscount);
      XMLWriter.AddLeafTag('tldoctype',             tlDocType );
      XMLWriter.AddLeafTag('tlfolionum',            tlFolioNum);
      XMLWriter.AddLeafTag('tlglcode',              tlGLCode);
      XMLWriter.AddLeafTag('tlinclusivevatcode',    tlInclusiveVATCode);
      XMLWriter.AddLeafTag('tlitemno',              tlItemNo);
      XMLWriter.AddLeafTag('tljobcode',             '');
      XMLWriter.AddLeafTag('tllineclass',           tlLineClass);
      XMLWriter.AddLeafTag('tllinedate',            tlLineDate);
      XMLWriter.AddLeafTag('tllineno',              tlLineNo);
      XMLWriter.AddLeafTag('tllinesource',          tlLineSource );
      XMLWriter.AddLeafTag('tllinetype',            tlLineType);
      XMLWriter.AddLeafTag('tllocation',            tlLocation);
      XMLWriter.AddLeafTag('tlnetvalue',            tlNetValue);
      XMLWriter.AddLeafTag('tlnominalmode',         tlNominalMode);
      XMLWriter.AddLeafTag('tlourref',              tlOurRef);
      XMLWriter.AddLeafTag('tlpayment',             tlPayment);
      XMLWriter.AddLeafTag('tlperiod',              tlPeriod );
      XMLWriter.AddLeafTag('tlpricemultiplier',     tlPriceMultiplier);
      XMLWriter.AddLeafTag('tlqty',                 tlQty);
      XMLWriter.AddLeafTag('tlqtydel',              tlQtyDel);
      XMLWriter.AddLeafTag('tlqtymul',              tlQtyMul);
      XMLWriter.AddLeafTag('tlqtypack',             tlQtyPack );
      XMLWriter.AddLeafTag('tlqtypicked',           tlQtyPicked);
      XMLWriter.AddLeafTag('tlqtypickedwo',         tlQtyPickedWO);
      XMLWriter.AddLeafTag('tlqtywoff',             tlQtyWOFF);
      XMLWriter.AddLeafTag('tlreconciliationdate',  tlReconciliationDate );
      XMLWriter.AddLeafTag('tlrecstatus',           tlRecStatus);
      XMLWriter.AddLeafTag('tlrunno',               tlRunNo );
      XMLWriter.AddLeafTag('tlsopabslineno',        tlSOPABSLineNo);
      XMLWriter.AddLeafTag('tlsopfolionum',         tlSOPFolioNum);
      XMLWriter.AddLeafTag('tlssdcommodcode',       tlSSDCommodCode);
      XMLWriter.AddLeafTag('tlssdcountry',          tlSSDCountry);
      XMLWriter.AddLeafTag('tlssdsalesunit',        tlSSDSalesUnit);
      XMLWriter.AddLeafTag('tlssdupliftperc',       tlSSDUpliftPerc);
      XMLWriter.AddLeafTag('tlssduselinevalues',    tlSSDUseLineValues);
      XMLWriter.AddLeafTag('tlstockcode',           tlStockCode);
      XMLWriter.AddLeafTag('tlstockdeductqty',      tlStockDeductQty );
      XMLWriter.AddLeafTag('tlunitweight',          tlUnitWeight);
      XMLWriter.AddLeafTag('tluserfield1',          tlUserField1);
      XMLWriter.AddLeafTag('tluserfield2',          tlUserField2);
      XMLWriter.AddLeafTag('tluserfield3',          tlUserField3);
      XMLWriter.AddLeafTag('tluserfield4',          tlUserField4);
      XMLWriter.AddLeafTag('tluseqtymul',           tlUseQtyMul );
      XMLWriter.AddLeafTag('tlvatamount',           tlVATAmount);
      XMLWriter.AddLeafTag('tlvatcode',             tlVATCode);
      XMLWriter.AddLeafTag('tlvatincvalue',         tlVATIncValue );
      XMLWriter.AddLeafTag('tlyear',                tlYear );
    except
      On e: Exception Do
        DoLogMessage('TOpenBalanceExport.ExportFullTransactionLine', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.ExportMatching;
var
  Key: Str255;
  FuncRes: LongInt;
  FileName: string;
begin
  FileManager.BaseFileName := 'obm';
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');
  XMLWriter.NameSpace := 'match';
  Key := '';
  FuncRes := Find_Rec(B_GetFirst, F[OBMatchF], OBMatchF, OBMatching, 0, Key);
  while (FuncRes = 0) do
  begin
    { Start a new XML file. }
    XMLWriter.Start(cOBMATCHINGTABLE, 'match');
    { Add the record node. }
    XMLWriter.AddOpeningTag('matchrec');
    { Add the fields }
    XMLWriter.AddLeafTag('madocyourref',  OBMatching.DocYourRef);
    XMLWriter.AddLeafTag('madocref',      OBMatching.DocCode);
    XMLWriter.AddLeafTag('mapayref',      OBMatching.PayRef);
    XMLWriter.AddLeafTag('matype',        0);
    XMLWriter.AddLeafTag('madoccurrency', OBMatching.DocCurrency);
    XMLWriter.AddLeafTag('madocvalue',    OBMatching.DocValue);
    XMLWriter.AddLeafTag('mapaycurrency', OBMatching.PayCurrency);
    XMLWriter.AddLeafTag('mapayvalue',    OBMatching.PayValue);
    XMLWriter.AddLeafTag('mabasevalue',   OBMatching.BaseValue);

    XMLWriter.AddClosingTag('matchrec');

    { Finish the XML file and save the filename. }
    XMLWriter.Finish;
    FileName := FileManager.SaveXML(XMLWriter.XML.Text);
    Files.Add(FileName);

    FuncRes := Find_Rec(B_GetNext, F[OBMatchF], OBMatchF, OBMatching, 0, Key);
  end;
end;

// -----------------------------------------------------------------------------

function TOpeningBalanceExport.OpenGLStructure: LongInt;
var
  Key: Str255;
  FuncRes: LongInt;
begin
  { Get the identifier for the G/L Structure record (the System Settings tables
    holds multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[SysR];

  SetDrive := DataPath;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin
    { ...and find the G/L Structure record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);

    if (FuncRes = 0) then
      FuncRes := GetPos(F[SysF], SysF, SysAddr[SysR]);

    VarianceGLCode := Syss.NomCtrlCodes[CurrVar];
  end;
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

procedure TOpeningBalanceExport.UpdateTracker;
begin
  try
    { Record the last used document numbers. }
    try
      { Take a copy of the 'next document number' details -- these will be
        stored in the ICS folder, ready for use by the Tracker in
        determining transactions which have been added since the last
        export }
      Tracker.UpdateDocumentNumbers;
    except
      on E:Exception do
        DoLogMessage('TTransactionExport.LoadFromDB: Failed to update data-tracking file for DripFeed mode: ' +
                     E.Message, cCONNECTINGDBERROR);
    end;

    { As we have done a bulk export of Transaction records, we are now
      in drip-feed mode, so update the drip-feed information file with
      the details }
    Tracker.DripFeed.Datapath    := Datapath + cICEFOLDER;
    Tracker.DripFeed.StartPeriod := StartPeriod;
    Tracker.DripFeed.StartYear   := StartYear;
    Tracker.DripFeed.EndPeriod   := EndPeriod;
    Tracker.DripFeed.EndYear     := EndYear;
    Tracker.DripFeed.IsActive    := False;
//          Tracker.DripFeed.UseCompression := False; // DEBUG ONLY -- REMOVE
    if Tracker.DripFeed.IsValidForSaving then
    begin
      if not Tracker.DripFeed.Save then
        DoLogMessage('TTransactionExport.LoadFromDB: Failed to update drip-feed file: ' +
                     Tracker.DripFeed.ErrorMessage,
                     cCONNECTINGDBERROR);
    end
    else
      DoLogMessage('TTransactionExport.LoadFromDB: Failed to update drip-feed file: ' +
                   Tracker.DripFeed.ErrorMessage,
                   cCONNECTINGDBERROR);
  except
    on E:Exception do
      DoLogMessage('TTransactionExport.LoadFromDB: Failed to update drip-feed file: ' +
                   E.Message, cCONNECTINGDBERROR);
  end;
end;

// -----------------------------------------------------------------------------

end.
