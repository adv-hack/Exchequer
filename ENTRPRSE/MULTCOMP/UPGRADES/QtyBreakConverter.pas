unit QtyBreakConverter;

interface

uses
  BtrvU2, VarConst, Classes;

const
  LOG_FILE_NAME = 'Logs\QtyBreakConversion.log';

  //Prefixes for existing records in ExStkChk.dat
  CUST_DISCOUNT = 'CC';
  SUPP_DISCOUNT = 'CS';
  CUST_BREAK    = 'DC';
  SUPP_BREAK    = 'DS';
  STOCK_BREAK   = 'DQ';


type
  //Event handler for updating the calling form with progress
  TProgressProc = Procedure(Sender : TObject; const sMessage : string) of Object;

  //Class to iterate through Customer, Supplier and Stock Qty Break records, converting them to the
  //new 6.10 Qty Break file. ABSEXCH-9795
  TQtyBreakConverter = Class
  private
    FLogFile : TextFile;
    FHasUnconvertedBreaks : Boolean;

    FQtyBreakFolio : Integer; //Next Qty Break Folio number, incremented each time we convert a set of cust/supp qty breaks
    FMiscPosition : longint;  //Stores the file position of the current cust/supp discount record.
    FCurrentCustDiscRec : CustDiscType; //Stores the current cust/supp discount record
    FCurrentStockFolio : longint;
    FCurrenciesUsed : TBits; //Stores the Currencies for Qty Break records for a specific AcCode/StockCode combi.
    FExceptionString : string;
    FOnProgress : TProgressProc;
    procedure SaveMiscPosition;
    procedure RestoreMiscPosition;
    procedure ConvertCurrentRecord;
    procedure ConvertStock;
    procedure ConvertCustSupp(const DiscPrefix : string;
                              const BreakPrefix : string);
    procedure FindAndConvertBreakLines(BreakPrefix : string);
    procedure AddCurrentRecordToLog(ErrorCode : Integer);
    function GetStockFolio : longint;
    procedure ResetCurrencies;
    function StoreQBHeaderRec : Integer;
    function FullNomKey(Value : longint) : ShortString; //Saves bringing in half of Exchequer.
    procedure StartLogFile;
    procedure EndLogFile;
    procedure UpdateDocCodes;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute : Integer;
    property HasUnconvertedBreaks : Boolean read FHasUnconvertedBreaks write FHasUnconvertedBreaks;
    property ExceptionString : string read FExceptionString write FExceptionString;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
  end;

  function Need610Conversion : Boolean;

implementation

uses
  QtyBreakVar, GlobVar, SysUtils, EtStrU, EtMiscU, StrUtil, Forms, IIFFuncs, MathUtil,
  SQLUtils;

//PR: 24/02/2012 Changed to public function (from method of TQtyBreakConverter) so
//that we can use it before converting qty breaks to check whether we need to add new custom fields. ABSEXCH-12128

//Check whether QBF exists in the Doc Numbers table. If not then we havn't converted qty breaks yet.
function Need610Conversion: Boolean;
var
  Res : Integer;
  KeyS : Str255;
begin
  Result := True;
  Open_System(IncF, IncF);

  //PR: 20/03/2012 Search key wasn't being set - D'oh!
  KeyS := 'QBF';
  Res := Find_Rec(B_GetEQ, F[IncF], IncF, RecPtr[IncF]^, IncK, KeyS);
  Result := Res = 4;

  //Leave file open, as QtyBreakConverter uses it. File gets closed at the end of TQtyBreakConverter.Execute.
end;


{ TQtyBreakConverter }

//Procedure to add record details to the log file where we haven't been able to convert the record.
//If ErrorCode = 0 then the problem is that we couldn't link qty break records to the cust/supp header.
//If ErrorCode > 0 then ErrorCode is the return code from Add_Rec.
procedure TQtyBreakConverter.AddCurrentRecordToLog(ErrorCode: Integer);

  function FormatDiscountType(AType : Char) : string;
  begin
    Case AType of
      'B'  : Result := 'Price Band';
      'P'  : Result := 'Special Price';
      'M'  : Result := 'Margin';
      'U'  : Result := 'Markup';
    end;
  end;

  function FormatValueString : string;
  var
    Value : Double;
  begin
    with MiscRecs^.QtyDiscRec do
    begin
      Case QBType of
        'B'  : Value := IIF(ZeroFloat(QDiscP), QDiscA, QDiscP);
        'P'  : Value := QSPrice;
        'M',
        'U'  : Value := QMUMG;
      end;

      Result := Format('%8.2f', [Value]);

      if QBType = 'B' then //Add percent sign if necessary, and Price Band
      begin
        if not ZeroFloat(QDiscP) then
          Result := Result + '%';

        Result := Result + ' (Band ' + QBand + ')';
      end;
    end;
  end;


begin
  if ErrorCode <> 0 then
    WriteLn(FLogFile, 'Error saving Qty Break Record. Error no: ' + IntToStr(ErrorCode));

  WriteLn(FLogFile, ' ');

  WriteLn(FLogFile, 'Account Code: ' + Trim(FCurrentCustDiscRec.DCCode));
  WriteLn(FLogFile, 'Stock Code: ' + Trim(FCurrentCustDiscRec.QStkCode));
  WriteLn(FLogFile, 'Discount Type: ' + FormatDiscountType(MiscRecs^.QtyDiscRec.QBType));
  WriteLn(FLogFile, Format('Qty: %8.2f to %8.2f', [MiscRecs^.QtyDiscRec.FQB, MiscRecs^.QtyDiscRec.TQB]));
  WriteLn(FLogFile, 'Value: ' + FormatValueString);
  WriteLn(FLogFile, 'Currency: ' + IntToStr(MiscRecs^.QtyDiscRec.QBCurr));

  if ErrorCode <> 0 then
    WriteLn(FLogFile, '==============================================================');

  WriteLn(FLogFile, ' ');
end;

procedure TQtyBreakConverter.ResetCurrencies;
var
  i : integer;
begin
  for i := 0 to FCurrenciesUsed.Size - 1 do
    FCurrenciesUsed[i] := False;

  //This function is called immediately after we've read a new cust/Supp qty break header, so set the currency bit for that.
  FCurrenciesUsed[MiscRecs^.CustDiscRec.QBCurr] := True;
end;

//Iterate through Account discounts. When we find a QtyBreak header, find the qty break records and copy them to the new qty break file.
//DiscPrefix is the prefix for the headers, BreakPrefix is the prefix for the line records.
procedure TQtyBreakConverter.ConvertCustSupp(const DiscPrefix,
  BreakPrefix: string);
var
  Res : Integer;
  KeyS : Str255;
  KeyChk : Str255;
  ConflictFound : Boolean;

  //Returns true if we're still on the same record type
  function RecordTypeOK : Boolean;
  begin
    Result := (Copy(KeyS, 1, 2) = KeyChk);
  end;

  //Returns true if we're still on the same AcCode/StockCode combination
  function SameAcAndStock : Boolean;
  begin
    Result := (FCurrentCustDiscRec.QStkCode = MiscRecs^.CustDiscRec.QStkCode) and
              (FCurrentCustDiscRec.DCCode = MiscRecs^.CustDiscRec.DCCode);
  end;

  //Returns true if we already have a QtyBreak header record with the same currency
  function SameCurrency : Boolean;
  begin
    Result := FCurrenciesUsed[MiscRecs^.CustDiscRec.QBCurr];
    if not Result then
      FCurrenciesUsed[MiscRecs^.CustDiscRec.QBCurr] := True;
  end;

  procedure WriteConflictsToLog;
  var
    LKey : Str255;
    LChk : Str255;
    LRes : integer;
  begin
    WriteLn(FLogFile, 'It was not possible to match the following Quantity Break records with their headers:');
    WriteLn(FLogFile, ' ');
    FCurrentStockFolio := GetStockFolio;
    if FCurrentStockFolio <> 0 then
    begin
      LKey := BreakPrefix + LJVar(FCurrentCustDiscRec.DCCode, 6) + FullNomKey(FCurrentStockFolio);
      LChk := LKey;

      //Find all qty break records for this AcCode/Stock code
      LRes := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, LKey);
      while (LRes = 0) and (Copy(LKey, 1, 12) = LChk) do
      begin
        AddCurrentRecordToLog(0);

        Application.ProcessMessages;

        //Find next record
        LRes := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, LKey);
      end;
    end;

  end;

begin
  KeyS := DiscPrefix;
  KeyChk := KeyS;

  Res := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);

  while (Res = 0) and RecordTypeOK do
  begin
    if Assigned(OnProgress) then
      with MiscRecs^.CustDiscRec do
        OnProgress(Self, 'Checking ' + Trim(DCCode) + '\' + Trim(QStkCode));

    Application.ProcessMessages;

    if MiscRecs^.CustDiscRec.QBType = 'Q' then
    begin
      if Assigned(OnProgress) then
        with MiscRecs^.CustDiscRec do
          OnProgress(Self, 'Converting ' + Trim(DCCode) + '\' + Trim(QStkCode));


      //Store position and current record details
      FCurrentCustDiscRec := MiscRecs^.CustDiscRec;
      SaveMiscPosition;


      ConflictFound := False;
      ResetCurrencies;

      Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);

      //Search through the remaining discount recs for this Ac and Stock combi and
      //see if there are any more qty break headers with the same currency. If so then we can't link up their qty breaks
      while (Res = 0) and RecordTypeOK and SameAcAndStock and not ConflictFound do
      begin
        Application.ProcessMessages;

        ConflictFound := (Res = 0) and RecordTypeOk and SameAcAndStock and
                         (MiscRecs^.CustDiscRec.QBType = 'Q') and SameCurrency;

        if not ConflictFound then
          Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
      end; //While not ConflictFound

      if ConflictFound and (Res = 0) and RecordTypeOk and SameAcAndStock then
      begin
        //Iterate through remaining Qty Break headers for this AcCode/StockCode combi,
        //writing  connected qty break lines.
        WriteConflictsToLog;
        FHasUnconvertedBreaks := True;

        //Now we need to move to the last discount header for this AcCode/StockCode, so we can
        //carry on to the next. As the index is AcCode + StockCode + Currency, we can do this
        //by doing GetLessThan on AcCode + StockCode + 'z';
        KeyS[Length(KeyS)] := 'z';
        Res := Find_Rec(B_GetLess, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
        SaveMiscPosition;
      end
      else
      begin
        //Next record doesn't belong, so we can convert the current record as it's the only one qb for this currency
        FindAndConvertBreakLines(BreakPrefix);
        StoreQBHeaderRec;
      end;

      //Restore position
      RestoreMiscPosition;

    end; //if MiscRecs^.CustDiscRec.QBType = 'Q'

    Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
  end; //While
end;

//Procedure to convert old qty break rec to new.
procedure TQtyBreakConverter.ConvertCurrentRecord;
var
  IsStockQtyBreak : Boolean;
begin
  FillChar(QtyBreakRec, SizeOf(QtyBreakRec), 0);

  IsStockQtyBreak := MiscRecs.SubType = 'Q';

  //Set folio on qty break if it's a customer or supplier break.
  if IsStockQtyBreak then //Stock Qty Break
    QtyBreakRec.qbFolio := 0
  else  //Cust/Supp Qty Break
    QtyBreakRec.qbFolio := FQtyBreakFolio;

  QtyBreakRec.qbAcCode := LJVar(MiscRecs^.QtyDiscRec.QCCode, 6);
  QtyBreakRec.qbStockFolio := MiscRecs^.QtyDiscRec.QStkFolio;


  if IsStockQtyBreak then
  begin
    //Copy the date settings from the existing qty break record
    QtyBreakRec.qbUseDates := MiscRecs^.QtyDiscRec.QUseDates;

    //PR: 18/04/2012 Pad dates as they are now part of an index. ABSEXCH-12827
    QtyBreakRec.qbStartDate := LJVar(MiscRecs^.QtyDiscRec.QStartD, 8);
    QtyBreakRec.qbEndDate := LJVar(MiscRecs^.QtyDiscRec.QEndD, 8);
  end
  else
  begin
    //Doesn't have date settings, so copy from the current cust/supp qty break header record.
    QtyBreakRec.qbUseDates := FCurrentCustDiscRec.CUseDates;
    QtyBreakRec.qbStartDate := FCurrentCustDiscRec.CStartD;
    QtyBreakRec.qbEndDate := FCurrentCustDiscRec.CEndD;
  end;

  QtyBreakRec.qbQtyFrom := MiscRecs^.QtyDiscRec.FQB;
  QtyBreakRec.qbQtyTo := MiscRecs^.QtyDiscRec.TQB;
  QtyBreakRec.qbBreakType := BreakTypeFromDiscountChar(MiscRecs^.QtyDiscRec.QBType);
  QtyBreakRec.qbCurrency := MiscRecs^.QtyDiscRec.QBCurr;
  QtyBreakRec.qbSpecialPrice := MiscRecs^.QtyDiscRec.QSPrice;
  QtyBreakRec.qbPriceBand := MiscRecs^.QtyDiscRec.QBand;
  QtyBreakRec.qbDiscountPercent := MiscRecs^.QtyDiscRec.QDiscP;
  QtyBreakRec.qbDiscountAmount := MiscRecs^.QtyDiscRec.QDiscA;
  QtyBreakRec.qbMarginOrMarkup := MiscRecs^.QtyDiscRec.QMUMG;
  QtyBreakRec.qbQtyToString := FormatBreakQtyTo(QtyBreakRec.qbQtyTo);
end;

procedure TQtyBreakConverter.ConvertStock;
//Read through MiscF for Stock Qty Breaks and copy them into the Qty Break file
var
  Res : Integer;
  KeyS : Str255;
  KeyChk : Str255;
begin
  KeyS := STOCK_BREAK;
  KeyChk := KeyS;

  Res := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, 2) = KeyChk) do
  begin
    ConvertCurrentRecord;
    Res := Add_Rec(F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, 0);

    if Res <> 0 then
      AddCurrentRecordToLog(Res);

    Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);

    if Assigned(OnProgress) then
      OnProgress(Self, 'Converting Stock Qty Breaks ' + IntToStr(MiscRecs^.QtyDiscRec.QStkFolio));

    Application.ProcessMessages;
  end;

end;

constructor TQtyBreakConverter.Create;
begin
  inherited;
  FCurrenciesUsed := TBits.Create;
  FCurrenciesUsed.Size := 90
end;

destructor TQtyBreakConverter.Destroy;
begin
  FCurrenciesUsed.Free;
  inherited;
end;

//Runs the whole process
function TQtyBreakConverter.Execute : integer;
var
  Res : Integer;
begin
  Result := 0;
  Try
    Try
      //Open data files
      Open_System(MiscF, MiscF);
      { CJS 2012-04-20 ABSEXCH-12681 - Amended QtyBreak handling to create the
        table at this point if it does not exist. This is a fix for issues with
        the Emulator's upgrade/install system. }
      if not (TableExists('MISC\QTYBREAK.DAT')) then
      begin
        Res := Make_File(F[QtyBreakF], SetDrive+FileNames[QtyBreakF],FileSpecOfs[QtyBreakF]^,FileSpecLen[QtyBreakF]);
        if (Res <> 0) then
          raise Exception.Create('Failed to create QTYBREAK table, error ' + IntToStr(Res));
      end;
      Open_System(QtyBreakF, QtyBreakF);
      Open_System(StockF, StockF); //Required to find the StockFolio for QtyBreak recs

      //Initialise
      FQtyBreakFolio := 1;
      FHasUnconvertedBreaks := False;

      //Open log file
      StartLogFile;

      //Run conversions

      ConvertStock;
      ConvertCustSupp(CUST_DISCOUNT, CUST_BREAK);
      ConvertCustSupp(SUPP_DISCOUNT, SUPP_BREAK);
    Except
      on E:Exception do
      begin
        Result := -1;
        FExceptionString := E.Message;
      end;
    End;
  Finally
    if Result = 0 then
      UpdateDocCodes;
    EndLogFile;
    Close_Files(True);
  End;
end;

//Read through the Qty Break records belonging to the current MiscRecs^.CustDiscRec and copy them to the new file.
procedure TQtyBreakConverter.FindAndConvertBreakLines(BreakPrefix : string);
var
  KeyS : Str255;
  KeyChk : Str255;
  Res : integer;
begin
  FCurrentStockFolio := GetStockFolio;
  if FCurrentStockFolio <> 0 then  //If folio = 0 then we couldn't find the stock record, so the discount rec is probably a rogue.
  begin
    KeyS := BreakPrefix + LJVar(FCurrentCustDiscRec.DCCode, 6) + FullNomKey(FCurrentStockFolio);
    KeyChk := KeyS;

    //Find all qty break records for this AcCode/Stock code
    Res := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    while (Res = 0) and (Copy(KeyS, 1, 12) = KeyChk) do
    begin

      if MiscRecs^.QtyDiscRec.QBCurr = FCurrentCustDiscRec.QBCurr then
        ConvertCurrentRecord;

      Res := Add_Rec(F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, 0);

      if Res <> 0 then
        AddCurrentRecordToLog(Res);

      Application.ProcessMessages;

      //Find next record
      Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    end; //While
  end; //If Folio <> 0
end;

//Find stock record for discount and return the stock folio. If we can't find the stock record then we can only
//assume that the discount record is an orphan of some sort, so ignore it.
function TQtyBreakConverter.GetStockFolio: longint;
var
  Res : Integer;
  KeyS : Str255;
begin
  KeyS := LJVar(FCurrentCustDiscRec.QStkCode, 16);

  Res := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, 0, KeyS);
  if Res = 0 then
    Result := Stock.StockFolio
  else
    Result := 0;
end;

function TQtyBreakConverter.StoreQBHeaderRec: Integer;
begin
  //Restore position in file
  RestoreMiscPosition;

  //Set folio number and increment it for next record
  MiscRecs^.CustDiscRec.QtyBreakFolio := FQtyBreakFolio;
  Inc(FQtyBreakFolio);

  //Store record
  Result := Put_Rec(F[MiscF], MiscF, RecPtr[MiscF]^, MIK);
end;

function TQtyBreakConverter.FullNomKey(Value: LongInt): ShortString;
begin
  Result[0] := Char(SizeOf(Value));
  Move(Value, Result[1], SizeOf(Value));
end;


//Restore the current position in MiscF
procedure TQtyBreakConverter.RestoreMiscPosition;
begin
  Move(FMiscPosition, RecPtr[MiscF]^, SizeOf(FMiscPosition));
  GetDirect(F[MiscF], MiscF, RecPtr[MiscF]^, MIK, 0);

end;

//Save the current position in MiscF
procedure TQtyBreakConverter.SaveMiscPosition;
begin
  GetPos(F[MiscF], MiscF, FMiscPosition);
end;

//Open the log file and write the header
procedure TQtyBreakConverter.StartLogFile;
begin
  //PR: 05/04/2012 If Logs folder doesn't exist then create it. ABSEXCH-12753
  if not FileExists(SetDrive + 'Logs') then
    ForceDirectories(SetDrive + 'Logs');

  AssignFile(FLogFile, SetDrive + LOG_FILE_NAME);
  Rewrite(FLogFile);

  WriteLn(FLogFile, 'Converting Quantity Breaks for ' + SetDrive);
  WriteLn(FLogFile, ' ');
end;

//Close log file
procedure TQtyBreakConverter.EndLogFile;
begin
  if not FHasUnconvertedBreaks then
    WriteLn(FLogFile, 'Quantity Breaks converted. No problems found.');
  CloseFile(FLogFile);
end;

//Add the QBF folio counter to the Doc Codes table.
procedure TQtyBreakConverter.UpdateDocCodes;
var
  Res : Integer;
begin
  FillChar(Count, SizeOf(Count), 0);
  Count.CountTyp := S_QTY_BREAK_FOLIO_KEY;

  Count.NextCount := FullNomKey(FQtyBreakFolio);
  Res := Add_Rec(F[IncF], IncF, RecPtr[IncF]^, 0);

  //If we have any problem adding the folio then log it along with the number.
  if Res <> 0 then
  begin
    WriteLn(FLogFile, ' ');
    WriteLn(FLogFile, '=================================================================');
    WriteLn(FLogFile, ' ');
    WriteLn(FLogFile, 'Unable to add QBF folio to Document Codes. Value should be ' + IntToStr(FQtyBreakFolio));
    WriteLn(FLogFile, ' ');
    WriteLn(FLogFile, '=================================================================');
  end;
end;

end.
