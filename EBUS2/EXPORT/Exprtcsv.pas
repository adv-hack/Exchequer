unit ExprtCSV;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, IOUtil, {EBusUtil, UseTKit, }CSVUtils, Globvar, StrUtil, MathUtil, eBusCnst
  ,APIUtil;

{$I EXCHDLL.INC}
{$I EXDLLBT.INC}

type
  PBatchSKRec = ^TBatchSKRec;
  PBatchSLRec = ^TBatchSLRec;
  PBatchTLRec = ^TBatchTLRec;

  TExportCSV = class
    private
      fCSVType : TExportType;            // Type of CSV working with
      fHedFieldList, // All field keys (as in DataDef.ini) in fixed order
      fHedMappedFieldList, // Selected field keys in required order
      fLineFieldList,
      fLineMappedFieldList : TStringList;
      fDelimiter,
      fSeparator   : char;
      fMapFileName : string;
      fCSVHedFileName : string;
      fCSVLineFileName : string;
      fDescription : string;
      fIgnoreWebIncludeFlag : boolean;
//      fExportUpdatedLocations : boolean;
      fExportMode : TRecExportMode;
      fHeaderRow : TCSVHeader;
      fHedCSVExport : TFileExport;
      fLineCSVExport : TFileExport;
      fExportLastRun : TDateTime;
      fExportFormat : TCSVExportFormat;
      BatchSysRec : TBatchSysRec;
    protected
      procedure SetString(Index : integer; const Value : string);
      procedure SetChar(Index : integer; Value : char);
      procedure SetBoolean(Index : integer; Value : boolean);
      procedure SetHeaderRow(Value : TCSVHeader);
      procedure SetExportMode(Value : TRecExportMode);
      procedure SetExportLastRun(Value : TDateTime);
      procedure WriteHeaderRow;
      procedure ReadMapFile;
      procedure ReadFields;
      procedure SetCSVSettings;
      function  OKToWriteRecord(const EditDate : longdate; const EditTime : string) : boolean;
      procedure ProcessRecords; virtual; abstract;
      procedure OpenToolkit;
      procedure CloseToolkit;
      procedure ShowToolkitError(sFuncName : string; iFuncNo, iStatus : smallint);
    public
      OSTXFilter : Array[1..4] of boolean;
{      LockFilename : string;}
      // 1 = Export Oustanding Sales Orders
      // 2 = Export Other Oustanding Sales Transactions
      // 3 = Export Oustanding Purchase Orders
      // 4 = Export Other Oustanding Purchase Transactions

      Success : Boolean;
      cTransport : Char;
      CompanyCode : ShortString;

      function  ProcessExport : boolean;
      property  MapFileName : string index 1 read fMapFileName write SetString;
      property  CSVHedFileName : string index 2 read fCSVHedFileName write SetString;
      property  CSVLineFileName : string index 3 read fCSVLineFileName write SetString;
      property  Delimiter : char index 1 read fDelimiter write SetChar;
      property  Separator : char index 2 read fSeparator write SetChar;
      property  HeaderRow : TCSVHeader read fHeaderRow write SetHeaderRow;
      property  IgnoreWebIncludeFlag : boolean index 1 read fIgnoreWebIncludeFlag write SetBoolean;
//      property  ExportUpdatedLocations : boolean index 1 read fExportUpdatedLocations write SetBoolean;
      property  ExportMode : TRecExportMode read fEXportMode write SetExportMode;
      property  ExportLastRun : TDateTime read fExportLastRun write SetExportLastRun;
      constructor Create;
      destructor  Destroy; override;
  end;

  TExportStockCSV = class(TExportCSV)
    private
      fStockRec : ^TBatchSKRec;
      StockLocnInfo : PBatchSLRec;
    protected
      function  OKToWriteStockRecord : boolean;
      procedure ProcessRecords; override;
      procedure ProcessStockTree(SearchCode : TCharArray255);
      procedure WriteStockHedField(FieldID : integer);
      procedure WriteStockLineField(FieldID : integer; LineExportFile : TFileExport);
    public
      WebCatFilter, ProdGroupFilter : string;
      WebCatFilterFlag : Byte;
      constructor Create;
      destructor  Destroy; override;
  end;{TExportStockCSV}

  TExportTXCSV = class(TExportCSV)
    private
      TXHeader : ^TBatchTHRec;
      TXLine : PBatchTLRec;
    protected
      function TXHedOK : boolean;
      procedure ProcessRecords; override;
      procedure WriteTXHedField(FieldID : integer);
      procedure WriteTXLineField(FieldID : integer; LineExportFile : TFileExport);
    public
      constructor Create;
      destructor  Destroy; override;
  end;{TExportStockCSV}

  TExportAccountCSV = class(TExportCSV)
    private
      fCustSuppRec : ^TBatchCURec;
    protected
      function OKToWriteAccountRecord : boolean;
      procedure ProcessRecords; override;
      procedure WriteAccountField(FieldID : integer);
    public
      AccTypeFilter : string;
      AccTypeFilterFlag : Byte;
      constructor Create;
      destructor  Destroy; override;
  end;{TExportAccountCSV}

  TExportStockGroupCSV = class(TExportCSV)
    private
      fStockRec : ^TBatchSKRec;
    protected
      function OKToWriteStockGrpRecord : boolean;
      procedure ProcessRecords; override;
      procedure ProcessStockGroups(SearchCode : TCharArray255);
      procedure WriteStockGrpField(FieldID : integer);
    public
      constructor Create;
      destructor  Destroy; override;
  end;{TExportStockGroupCSV}

implementation

uses
  ExpUtil, eBusUtil, FileUtil, IniFiles, SysUtils, UseDLLU, TKUtil,
  Forms, // for Application
  Dialogs; // for ShowMessage

//-----------------------------------------------------------------------

constructor TExportCSV.Create;
var
  iPos : byte;
begin
  inherited Create;
  fHedFieldList := TStringList.Create;
  fHedMappedFieldList := TStringList.Create;
  fLineFieldList := TStringList.Create;
  fLineMappedFieldList := TStringList.Create;
  Success := FALSE;
  for iPos := 1 to 4 do OSTXFilter[iPos] := FALSE;
end;

//-----------------------------------------------------------------------

destructor TExportCSV.Destroy;
begin
  fHedFieldList.Free;
  fHedMappedFieldList.Free;
  fLineFieldList.Free;
  fLineMappedFieldList.Free;
  fHedCSVExport.Free;
  if fExportFormat = efBothSeparate then fLineCSVExport.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetString(Index : integer; const Value : string);
begin
  case Index of
    1 : fMapFileName := Value;
    2 : fCSVHedFileName := Value;
    3 : fCSVLineFileName := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetChar(Index : integer; Value : char);
begin
  case Index of
    1: fDelimiter := Value;
    2: fSeparator := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetBoolean(Index: integer; Value: boolean);
begin
  case Index of
    1: fIgnoreWebIncludeFlag := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetExportMode(Value: TRecExportMode);
begin
  fExportMode := Value;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetHeaderRow(Value : TCSVHeader);
begin
  fHeaderRow := Value;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetCSVSettings;
begin
  fHedCSVExport := TFileExport.Create(CSVHedFileName);
  fHedCSVExport.Separator := Separator;
  fHedCSVExport.Delimiter := Delimiter;

  if fExportFormat = efBothSeparate then begin
    fLineCSVExport := TFileExport.Create(CSVLineFileName);
    fLineCSVExport.Separator := Separator;
    fLineCSVExport.Delimiter := Delimiter;
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TExportCSV.SetExportLastRun(Value : TDateTime);
begin
  fExportLastRun := Value;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.ReadFields;
// Action : Populates fHedFieldList with the appropriate section from DataDef.ini
begin
  with TMemIniFile.Create(ExtractFilePath(Application.ExeName) + FIELD_DEFS_INI) do
  try
    ReadSection(CSV_DESC[fCSVType], fHedFieldList);

    if fExportFormat <> efHeadersOnly then begin
      case fCSVType of
        etStockHeader : ReadSection('StockLocation', fLineFieldList);
        etTXHeader : ReadSection('TXLines', fLineFieldList);
      end;{case}
    end;{if}
  finally
    Free;
  end;
end; // procedure TExportCSV.ReadFields

//-----------------------------------------------------------------------

procedure TExportCSV.ReadMapFile;
var
  sExportFormat : string;
begin
  with TMemIniFile.Create(MapFileName) do
    try
      // Check that the loaded file is of correct type by checking Section name
      ReadSection(CSV_DESC[fCSVType], fHedMappedFieldList);
      case fCSVType of
        etStockHeader : ReadSection('StockLocation', fLineMappedFieldList);
        etTXHeader : ReadSection('TXLines', fLineMappedFieldList);
      end;{case}

      fDescription := ReadString('Details','Description','');
      if fCSVType in [etStockHeader, etTXHeader] then begin
        sExportFormat := ReadString('Details','ExportFormat','');
        if sExportFormat = 'HeadersOnly' then fExportFormat := efHeadersOnly
        else begin
          if sExportFormat = 'BothSeparate' then fExportFormat := efBothSeparate
          else begin
            if sExportFormat = 'BothTogether' then fExportFormat := efBothTogether
          end;{if}
        end;{if}
      end;{if}
    finally
      Free;
    end;
end;

//-----------------------------------------------------------------------

procedure TExportCSV.WriteHeaderRow;
var
  i : integer;
begin
  with fHedCSVExport do begin
    case HeaderRow of
      hdrFields: begin
        {write fields into 1st line of header file}
        for i := 0 to fHedMappedFieldList.Count - 1 do WriteString(fHedMappedFieldList[i]);
        NewLine;

        {write fields into 1st line of lines file}
        if fExportFormat = efBothSeparate then begin
          if fCSVType = etTXHeader then begin
            for i := 0 to fLineMappedFieldList.Count -1
            do fLineCSVExport.WriteString(fLineMappedFieldList[i]);
            fLineCSVExport.NewLine;
          end;{if}
        end;{if}
      end;

      hdrDescs: begin
        with TMemIniFile.Create(ExtractFilePath(Application.ExeName) + FIELD_DEFS_INI) do begin
          try
            {write field descriptions into 1st line of header file}
            for i := 0 to fHedMappedFieldList.Count -1
            do fHedCSVExport.WriteString(ExtractCSVValue(ReadString(CSV_DESC[fCSVType], fHedMappedFieldList[i], ''), 3));
            NewLine;

            {write field descriptions into 1st line of lines file}
            if fCSVType = etTXHeader then begin
              for i := 0 to fLineMappedFieldList.Count -1
              do fLineCSVExport.WriteString(ExtractCSVValue(ReadString(CSV_DESC[etTXLines], fLineMappedFieldList[i], ''), 3));
              fLineCSVExport.NewLine;
            end;{if}
          finally
            Free;
          end;{try}
        end;{with}
      end;
    end;{case}
  end;{with}
end; // TExportCSV.WriteHeaderRow

//-----------------------------------------------------------------------

function TExportCSV.OKToWriteRecord(const EditDate : longdate; const EditTime : string) : boolean;
// Pre : EditDate = Date current record last edited, format yyyymmdd
//       EditTime = Time record current record last edited, format hhmmss
var
  EditDateTime : TDateTime;
begin
  Result := true;
  if ExportMode = expAll then
    exit;

  EditDateTime := ToDateTime(EditDate, EditTime);
  Result := ZeroFloat(EditDateTime) or (EditDateTime >= ExportLastRun);
end;

//-----------------------------------------------------------------------

function TExportCSV.ProcessExport : boolean;
// Post : Returns true if no exceptions raised
var
  Msg : string;
begin
  Result := true;
  ReadMapFile;
  ReadFields;
  SetCSVSettings;
  OpenToolkit;
  try
    WriteHeaderRow;
    ProcessRecords;
  except
    on E:EInOutError do
      with E do
      begin
        Result := false;
        case ErrorCode of
          2 : Msg := Format('File %s not found', [fHedCSVExport.FileName]);
          3 : Msg := Format('%s is an invalid file name', [fHedCSVExport.FileName]);
          4 : Msg := 'There are too many open files';
          5 : Msg := 'File access denied';
          32 : Msg := Format('File %s is being used by another application', [fHedCSVExport.FileName]);
          33 : Msg := Format('File %s has been locked by another application', [fHedCSVExport.FileName]);
          101 : Msg := 'The disk is full';
          103 : Msg := 'File Not Open';
        else
          Msg := '';
        end; // case
        MessageDlg(Format('An error occurred writing the CSV export' + CRLF + '%s' + CRLF +
          'Error code : %d', [Msg, ErrorCode]), mtWarning, [mbOK], 0);
      end; // with
  end; // try
  CloseToolkit;
end; // TExportCSV.ProcessExport

//=======================================================================

constructor TExportStockCSV.Create;
begin
  inherited Create;
  fCSVType := etStockHeader;
  new(fStockRec);
end;

//-----------------------------------------------------------------------

destructor TExportStockCSV.Destroy;
begin
  dispose(fStockRec);
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TExportStockCSV.WriteStockHedField(FieldID : integer);
// longint = 10 digits (>0)
// smallint = 5 digits (>0);
begin
  with fStockRec^, fHedCSVExport, BatchSysRec do
  case FieldID of
    0:      WriteString(StockCode);
    1..6:   WriteString(Desc[FieldID]);
    7:      WriteString(AltCode);
    8:      WriteString(SuppTemp);
    9..13:  WriteNum(NomCodes[FieldID-8],10,0);
    14:     WriteNum(StockFolio,10,0);
    15:     WriteString(StockCat);
    16:     WriteString(StockType);
    17:     WriteString(UnitK);
    18:     WriteString(UnitS);
    19:     WriteString(UnitP);
    20:     WriteNum(PCurrency,2,0);
    21:     WriteNum(CostPrice,18,CostDP);
    22..37: if odd(FieldID) then
              WriteNum(SaleBands[((FieldID + 1) div 2) - 11].SalesPrice,12,PriceDP)
            else
              WriteNum(SaleBands[(FieldID div 2) - 10].Currency, 2, 0);
    38:     WriteNum(SellUnit,18,QuantityDP);
    39:     WriteNum(BuyUnit,18,QuantityDP);
    40:     WriteString(VATCode);
    41:     WriteString(CC);
    42:     WriteString(Dep);
    43:     WriteNum(QtyMin,12,QuantityDP);
    44:     WriteNum(QtyMax,12,QuantityDP);
    45:     WriteNum(ROQty,12,QuantityDP);
    46:     WriteString(CommodCode);
    47:     WriteNum(SWeight,12,4);
    48:     WriteNum(PWeight,12,4);
    49:     WriteString(UnitSupp);
    50:     WriteNum(SuppSUnit,12,CostDP);
    51:     WriteString(BinLoc);
    52:     WriteString(StkValType);
    53:     WriteBool(UseCover);
    54:     WriteNum(CovMaxPr,4,0);
    55:     WriteString(CovMaxUnit);
    56:     WriteNum(CovMinPr,4,0);
    57:     WriteString(CovMinUnit);
    58:     WriteNum(ROCurrency,4,0);
    59:     WriteString(JAnalCode);
    60:     WriteNum(ROCPrice,18,PriceDP);
    61:     WriteString(StStkUser1);
    62:     WriteString(StStkUser2);
    63:     WriteString(StBarCode);
    64:     WriteString(StRODepartment);
    65:     WriteString(StROCostCentre);
    66:     WriteString(StLocation);
    67:     WriteBool(StPricePack);
    68:     WriteBool(StDPackQty);
    69:     WriteBool(StKitPrice);
    70:     WriteBool(StKitOnPurch);
    71:     WriteNum(WebInclude,4,0);
    72:     WriteString(WebLiveCat);
    73:     WriteString(StkUser3);
    74:     WriteString(StkUser4);
    75:     WriteNum(SerNoWAvg,4,0);
    76:     WriteNum(SSDDUpLift,10,CostDP);
    77:     WriteString(TimeChange);
    78:     WriteString(SVATIncFlg);
    79:     WriteString(LastOpo);
    80:     WriteString(ImageFile);
    81:     WriteString(WebPrevCat);
    82:     WriteString(LastUsed);
    83:     WriteNum(QtyInStock,12,QuantityDP);
    84:     if OrderAllocStock then
              WriteNum(QtyPicked,12,QuantityDP)
            else
              WriteNum(QtyAllocated,12,QuantityDP);
    85:     WriteNum(QtyOnOrder,12,QuantityDP);
    
    //PR: 26/08/2014 ABSEXCH-15585 Added UDFs 5-10
    86:     WriteString(StkUser5);
    87:     WriteString(StkUser6);
    88:     WriteString(StkUser7);
    89:     WriteString(StkUser8);
    90:     WriteString(StkUser9);
    91:     WriteString(StkUser10);
  else
    WriteString('***ERROR***');
  end;
end; // TExportStockCSV.WriteStockHedField

procedure TExportStockCSV.WriteStockLineField(FieldID : integer; LineExportFile : TFileExport);
// longint = 10 digits (>0)
// smallint = 5 digits (>0);
begin
  with StockLocnInfo^, LineExportFile, BatchSysRec do
  case FieldID of
    0:      WriteString(lsStkCode);
    1:      WriteString(lsLocCode);
    2:      WriteString(lsSupplier);
    3:      WriteString(lsTempSupp);
    4:      WriteString(lsCC);
    5:      WriteString(lsDep);
    6:      WriteString(lsBinLoc);

    7..11:  WriteNum(lsDefNom[FieldID - 6],10,0);

   12:      WriteNum(lsQtyPicked,12,QuantityDP);
   13:      WriteNum(lsQtyInStock,12,QuantityDP);
   14:      WriteNum(lsQtyPosted,12,QuantityDP);
   15:      WriteNum(lsQtyAlloc,12,QuantityDP);
   16:      WriteNum(lsQtyOnOrder,12,QuantityDP);
   17:      WriteNum(lsQtyMin,12,QuantityDP);
   18:      WriteNum(lsQtyMax,12,QuantityDP);
   19:      WriteBool(lsMinFlg);
   20:      WriteNum(lsRoQty,12,QuantityDP);
   21:      WriteNum(lsQtyTake,12,QuantityDP);
   22:      WriteNum(lsQtyFreeze,12,QuantityDP);
   23:      WriteNum(lsPCurrency,6,0);
   24:      WriteNum(lsCostPrice,12,CostDP);

   25..40:  if odd(FieldID) then WriteNum(lsSaleBands[((FieldID + 1) div 2) - 12].Currency, 2, 0)
            else WriteNum(lsSaleBands[(FieldID div 2) - 12].SalesPrice,12,PriceDP);

   41:      WriteNum(lsRoCurrency,6,0);
   42:      WriteNum(lsRoPrice,12,PriceDP);
   43:      WriteString(lsRoDate);
   44:      WriteString(lsRoCC);
   45:      WriteString(lsRoDep);
   46:      WriteString(lsLastUsed);
   47:      WriteString(lsLastTime);
  else
    WriteString('***ERROR***');
  end;
end; // TExportStockCSV.WriteStockHedField

//-----------------------------------------------------------------------

function TExportStockCSV.OKToWriteStockRecord : boolean;
begin
  with fStockRec^ do
  begin
    Result := StockType <> 'G'; // i.e. ignore groups
    Result := Result and OKToWriteRecord(LastUsed, TimeChange);
    if not IgnoreWebIncludeFlag then
      Result := Result and (WebInclude > 0);

    Result := Result and CheckFilter(WebCatFilter, WebLiveCat, WebCatFilterFlag);

  end;
end;

//-----------------------------------------------------------------------

procedure TExportStockCSV.ProcessRecords;
var
  Seed : TCharArray255;
begin
{  ProcessStockTree('');}
  StrPCopy(Seed,ProdGroupFilter);
  ProcessStockTree(Seed);
end;

procedure TExportStockCSV.ProcessStockTree(SearchCode : TCharArray255);
var
  iKey, iSearchMode, Position, Status : integer;
  LocationCode, TempSearchCode : TCharArray255;
  CurGroup : string;
  LocationsList : TStringList;
  bMultiLocation : boolean;
  LocationRec : TBatchMLocRec;
  sCode : string16;
  bGroup : boolean;

  Procedure WriteLine;
  var
    SearchStockCode, SearchLocationCode : array[0..255] of char;
    i, iPos, {Status, }iLocStatus : integer;
    LineExportFile : TFileExport;
  begin
    new(StockLocnInfo);

    {Write Stock Header Line}
    if (fExportFormat = efBothTogether) and bMultiLocation then fHedCSVExport.WriteString('SH');
    for i := 0 to fHedMappedFieldList.Count -1 do begin
      if copy(fHedMappedFieldList[i], 1, length(IGNORE_FIELD)) = IGNORE_FIELD then
        begin
          fHedCSVExport.WriteString('');
          fHedCSVExport.NewLine;
        end
      else begin
        WriteStockHedField(fHedFieldList.IndexOf(fHedMappedFieldList[i]));
      end;{if}
    end;{for}
    fHedCSVExport.NewLine;

    {get stock location information}
    if (fExportFormat <> efHeadersOnly) and bMultiLocation then begin

      if fExportFormat = efBothSeparate then LineExportFile := fLineCSVExport
      else LineExportFile := fHedCSVExport;

      {for each location}
      for i := 0 to LocationsList.Count -1 do begin
        FillChar(SearchLocationCode, Sizeof(SearchLocationCode), 0);
        StrPCopy(SearchLocationCode, LocationsList[i]);
        StrPCopy(SearchStockCode, fStockRec.StockCode);
        iLocStatus := Ex_GetStockLoc(StockLocnInfo, SizeOf(StockLocnInfo^), SearchStockCode
        , SearchLocationCode, false);
        if iLocStatus = 0 then begin

          {Write 1 Location Line}
          if fExportFormat = efBothTogether then LineExportFile.WriteString('SL');
          for iPos := 0 to fLineMappedFieldList.Count -1 do begin
            if copy(fLineMappedFieldList[iPos], 1, length(IGNORE_FIELD)) = IGNORE_FIELD then
              begin
                LineExportFile.WriteString('');
                LineExportFile.NewLine;
              end
            else begin
              WriteStockLineField(fLineFieldList.IndexOf(fLineMappedFieldList[iPos]), LineExportFile);
            end;{if}
          end;{for}
          LineExportFile.NewLine;
        end;{if}
      end;{for}
    end;{if}
    dispose(StockLocnInfo);
  end;{WriteLine}

begin{ProcessStockTree}
  LocationsList := TStringList.Create;

  bMultiLocation := (BatchSysRec.MultiLocn = 2);

  {fill List with locations}
  if (fExportFormat <> efHeadersOnly) and bMultiLocation then begin
    FillChar(LocationCode, SizeOf(LocationCode), 0);
    Status := Ex_GetLocation(@LocationRec, Sizeof(LocationRec), LocationCode, 0, B_GetFirst, false);
    while Status = 0 do begin
      LocationsList.Add(LocationRec.LoCode);
      Status := Ex_GetLocation(@LocationRec, Sizeof(LocationRec), LocationCode, 0, B_GetNext, false);
    end;
  end;{if}

  // Find record in stock file


  sCode := copy(SearchCode,0,StrLen(SearchCode));

  {is this item a group ?}
  if SearchCode = '' then bGroup := TRUE
  else begin
    Status := Ex_GetStock(fStockRec, SizeOf(fStockRec^), SearchCode, 0, B_GetGEq, false);
    bGroup := (Status = 0) and (fStockRec^.StockCode = sCode) and (fStockRec^.StockType = 'G');
  end;{if}

  if bGroup then
    begin
      iKey := 2;
      iSearchMode := B_GetGEq;
      CurGroup := sCode; {NF: 431.106 bug fix}
    end
  else begin
    iKey := 0;
    iSearchMode := B_GetEq;
  end;{if}

  Status := Ex_GetStock(fStockRec, SizeOf(fStockRec^), SearchCode, iKey, iSearchMode, false);

  if not bGroup then CurGroup := fStockRec^.StockCat; {NF: 431.106 bug fix}

  // Check we're processing same stock group code
  while (Status = 0) and (Trim(fStockRec^.StockCat) = Trim(CurGroup)) do begin
    with fStockRec^ do begin
      if (StockType = 'G') then
        begin
          if (IgnoreWebIncludeFlag  or (WebInclude > 0)) then begin
            // Store Btrieve position
            Ex_GetRecordAddress(StockF, Position);

            // Recurse down a level
            FillChar(TempSearchCode, SizeOf(TempSearchCode), #0);
            Move(StockCode[1], TempSearchCode, length(StockCode));
            ProcessStockTree(TempSearchCode);

            // Restore Btrieve position - moved back up a level
            Ex_GetRecWithAddress(StockF, 2, Position);
          end;
        end
      else begin
        {Write record to file}
        if OKToWriteStockRecord then WriteLine;
      end;{if}
    end;{with}
    Status := Ex_GetStock(fStockRec, SizeOf(fStockRec^), SearchCode, iKey, B_GetNext, false);
  end; // while

  LocationsList.Free;
end;{ProcessStockTree}


//=======================================================================

constructor TExportTXCSV.Create;
begin
  inherited Create;
  fCSVType := etTXHeader;
  new(TXHeader);
end;

//-----------------------------------------------------------------------

destructor TExportTXCSV.Destroy;
begin
  dispose(TXHeader);
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TExportTXCSV.WriteTXHedField(FieldID : integer);
// longint = 10 digits (>0)
// smallint = 5 digits (>0);
begin
  with TXHeader^, fHedCSVExport, BatchSysRec do
  case FieldID of
    0 :      WriteNum(RunNo,10,0);
    1 :      WriteString(CustCode);
    2 :      WriteString(OurRef);
    3 :      WriteNum(FolioNum,10,0);
    4 :      WriteNum(Currency,6,0);
    5 :      WriteNum(AcYr,6,0);
    6 :      WriteNum(AcPr,6,0);
    7 :      WriteString(DueDate);
    8 :      WriteString(TransDate);
    9 :      WriteNum(CoRate,13,6);
    10:      WriteNum(VATRate,13,6);
    11:      WriteString(YourRef);
    12:      WriteString(LongYrRef);
    13:      WriteNum(LineCount,10,0);
    14:      WriteString(TransDocHed);

    15..35 : WriteNum(InvVatAnal[FieldID - 15], 13, 2);{?}

    36:      WriteNum(InvNetVal,13,2);
    37:      WriteNum(InvVat,13,2);
    38:      WriteNum(DiscSetl,13,2);
    39:      WriteNum(DiscSetAm,13,2);
    40:      WriteNum(DiscAmount,13,2);
    41:      WriteNum(DiscDays,6,0);
    42:      WriteBool(DiscTaken);
    43:      WriteNum(Settled,13,2);
    44:      WriteNum(TransNat,6,0);
    45:      WriteNum(TransMode,6,0);
    46:      WriteNum(HoldFlg,6,0);
    47:      WriteNum(TotalWeight,13,4);

    48..52 : WriteString(DAddr[FieldID - 47]);

    53:      WriteNum(TotalCost,13,CostDP);
    54:      WriteBool(PrintedDoc);
    55:      WriteBool(ManVAT);
    56:      WriteString(DelTerms);
    57:      WriteString(OpName);
    58:      WriteString(DJobCode);
    59:      WriteString(DJobAnal);
    60:      WriteNum(TotOrdOS,13,2);
    61:      WriteString(DocUser1);
    62:      WriteString(DocUser2);
    63:      WriteString(EmpCode);
    64:      WriteNum(Tagged,2,0);
    65:      WriteNum(thNoLabels,6,0);
    66:      WriteNum(CtrlNom,10,0);
    67:      WriteString(DocUser3);
    68:      WriteString(DocUser4);
    69:      WriteString(SSDProcess);
    70:      WriteNum(ExtSource,6,0);
    71:      WriteString(PostDate);
    72:      WriteBool(PORPickSOR);
    73:      WriteNum(BDiscount,13,2);
    74:      WriteNum(PrePostFlg,6,0);
    75:      WriteString(AllocStat);

    //PR: 25/03/2013 ABSEXCH-13134 v7.0.3 Add UDFs 5-10
    76:      WriteString(DocUser5);
    77:      WriteString(DocUser6);
    78:      WriteString(DocUser7);
    79:      WriteString(DocUser8);
    80:      WriteString(DocUser9);
    81:      WriteString(DocUser10);

    //PR: 16/10/2013 ABSEXCH-14703 v7.0.7
    82:      WriteString(thDeliveryPostcode);

    //PR: 02/06/2015 v7.0.14
    83:      WriteNum(thPPDPercentage, 13, 2);
    84:      WriteNum(thPPDDays, 3, 0);
    85:      WriteNum(thPPDGoodsValue, 13, 2);
    86:      WriteNum(thPPDVATValue, 13, 2);
    87:      WriteNum(thPPDTaken, 1, 0);

    88:      WriteString(thDeliveryCountry);
  else
    WriteString('***ERROR***');
  end;
end; // TExportStockCSV.WriteStockHedField

//-----------------------------------------------------------------------

procedure TExportTXCSV.WriteTXLineField(FieldID : integer; LineExportFile : TFileExport);
// longint = 10 digits (>0)
// smallint = 5 digits (>0);
begin
  with TXLine^, LineExportFile, BatchSysRec do
  case FieldID of
    0 :      begin
//      WriteString(TransRefNo);
      WriteString(TXHeader.OurRef);  //NF: 21/10/2005 For some reason TransRefNo is always set to '' in the DLL TK, so let's get ti from the header
    end;

    1 :      WriteNum(LineNo,10,0);
    2 :      WriteNum(NomCode,10,0);
    3 :      WriteNum(Currency,6,0);
    4 :      WriteNum(CoRate,13,6);
    5 :      WriteNum(VATRate,13,6);
    6 :      WriteString(CC);
    7 :      WriteString(Dep);
    8 :      WriteString(StockCode);
    9 :      WriteNum(Qty,13,QuantityDP);
    10:      WriteNum(QtyMul,13,QuantityDP);
    11:      WriteNum(NetValue,13,2);
    12:      WriteNum(Discount,13,2);
    13:      WriteString(VATCode);
    14:      WriteNum(VAT,13,2);
    15:      WriteBool(Payment);
    16:      WriteString(DiscountChr);
    17:      WriteNum(QtyWOFF,13,QuantityDP);
    18:      WriteNum(QtyDel,13,QuantityDP);
    19:      WriteNum(CostPrice,13,CostDP);
    20:      WriteString(CustCode);
    21:      WriteString(LineDate);
    22:      WriteString(Item);
    23:      WriteString(Desc);
    24:      WriteNum(LWeight,13,4);
    25:      WriteString(MLocStk);
    26:      WriteString(JobCode);
    27:      WriteString(AnalCode);
    28:      WriteNum(TSHCCurr,6,0);
    29:      WriteNum(DocLTLink,6,0);
    30:      WriteNum(KitLink,10,0);
    31:      WriteNum(FolioNum,10,0);
    32:      WriteString(LineType);
    33:      WriteNum(Reconcile,4,0);
    34:      WriteNum(SOPLink,10,0);
    35:      WriteNum(SOPLineNo,10,0);
    36:      WriteNum(ABSLineNo,10,0);
    37:      WriteString(LineUser1);
    38:      WriteString(LineUser2);
    39:      WriteString(LineUser3);
    40:      WriteString(LineUser4);
    41:      WriteNum(SSDUplift,13,2); {DP ?}
    42:      WriteString(SSDCommod);
    43:      WriteNum(SSDSPUnit,13,2);
    44:      WriteBool(SSDUseLine);
    45:      WriteNum(PriceMulx,13,2);
    46:      WriteNum(QtyPick,13,QuantityDP);
    47:      WriteString(VATIncFlg);
    48:      WriteNum(QtyPWOff,13,QuantityDP);
    49:      WriteNum(RtnErrCode,6,0);
    50:      WriteString(SSDCountry);
  else
    WriteString('***ERROR***');
  end;
end; // TExportStockCSV.WriteStockHedField

//-----------------------------------------------------------------------

function TExportTXCSV.TXHedOK : boolean;
begin
  Result := FALSE;
  with TXHeader^ do begin
    if (TransDocHed = 'SOR') and OSTXFilter[1] then Result := TRUE
    else begin
      if (TransDocHed = 'POR') and OSTXFilter[3] then Result := TRUE
      else begin
        if (AllocStat = 'C') and OSTXFilter[2] then Result := TRUE
        else begin
          if (AllocStat = 'S') and OSTXFilter[4] then Result := TRUE
        end;{if}
      end;
    end;{if}
  end;{with}
end;

//-----------------------------------------------------------------------

procedure TExportTXCSV.ProcessRecords;
var
  SearchCode : array[0..255] of char;
  Status : integer;
  SaveIdx : Integer;
  RecPos : longint;

  Procedure CheckLine;
  var
    i, iPos, iLineStatus, res : integer;
    LineExportFile : TFileExport;
    pKey : Array[0..255] of Char;
    pBuffer : Pointer;
    LineSize : longint;
  begin
    if TXHedOK then begin
      if (fExportFormat = efBothTogether) then fHedCSVExport.WriteString('TH');
      for i := 0 to fHedMappedFieldList.Count -1 do begin
        if copy(fHedMappedFieldList[i], 1, length(IGNORE_FIELD)) = IGNORE_FIELD then
          begin
            fHedCSVExport.WriteString('');
            fHedCSVExport.NewLine;
          end
        else begin
          WriteTXHedField(fHedFieldList.IndexOf(fHedMappedFieldList[i]));
        end;{if}
      end;{for}
      fHedCSVExport.NewLine;

      {get TX Line information}
      if (fExportFormat <> efHeadersOnly) then
      begin

        if fExportFormat = efBothSeparate then LineExportFile := fLineCSVExport
        else LineExportFile := fHedCSVExport;

        //PR: 09/05/2011 Changed way we read the transaction lines. Previously this was using Ex_GetTransLine and
        //using each number between 1 and TXHeader.LineCount as the line number. However, if lines have been deleted or inserted,
        //the line numbers could be higher than the LineCount, leading to not all lines being processed. (ABSEXCH-11483)
        //Now we use Ex_GetTrans to read all the lines.


        FillChar(pKey, SizeOf(pKey), 0);
        StrPCopy(pKey, TXHeader.OurRef);
        LineSize := TxHeader.LineCount * SizeOf(TXLine^);

        GetMem(pBuffer, LineSize);

        Try
          //Store position in Transfile before calling Ex_GetTrans
          Ex_GetRecordAddress(2, RecPos);
          Res := EX_GETTRANS(TxHeader, pBuffer, SizeOf(TxHeader^), LineSize, pKey, 0, B_GetEq, False);

          if Res = 0 then
          for i := 1 to TXHeader.LineCount do
          begin
            //Copy data from the lines butter to TxLine
            iPos := (i-1) * SizeOf(TXLine^);
            Move(Pointer(Integer(pBuffer) + iPos)^, TxLine^, SizeOf(TXLine^));

            if fExportFormat = efBothTogether then
               LineExportFile.WriteString('SL');

            for iPos := 0 to fLineMappedFieldList.Count -1 do
            begin
              if copy(fLineMappedFieldList[iPos], 1, length(IGNORE_FIELD)) = IGNORE_FIELD then
                begin
                  LineExportFile.WriteString('');
                  LineExportFile.NewLine;
                end
              else
              begin
                WriteTXLineField(fLineFieldList.IndexOf(fLineMappedFieldList[iPos]), LineExportFile);
              end;{if}
            end;{for}

            LineExportFile.NewLine;

          end;{for}

          //Restore position and original index in trans file
          Ex_GetRecWithAddress(2, SaveIdx, RecPos);
        Finally
          FreeMem(pBuffer);
        End;
      end;{if}
    end;{if}
  end;{CheckLine}
begin
  new(TXLine);

  FillChar(SearchCode, SizeOf(SearchCode), 0);
  {Status := }EX_GETTRANSHED(TXHeader, SizeOf(TXHeader^), SearchCode, 11, B_GetFirst,FALSE);

  {gets all OS Sales Orders}
  SaveIdx := 5; //PR: 09/05/2011 Store index for use by CheckLines function.
  Status := EX_GETTHBYRUNNO(TXHeader, SizeOf(TXHeader^), -40, B_GetGEq,FALSE);
  while (Status = 0) and (TXHeader.RunNo = -40) do begin
    CheckLine;
    Status := EX_GETTHBYRUNNO(TXHeader, SizeOf(TXHeader^), -40, B_GetNext,FALSE);
  end;{while}

  {gets all OS Purchase Orders}
  Status := EX_GETTHBYRUNNO(TXHeader, SizeOf(TXHeader^), -50, B_GetGEq,FALSE);
  while (Status = 0) and (TXHeader.RunNo = -50) do begin
    CheckLine;
    Status := EX_GETTHBYRUNNO(TXHeader, SizeOf(TXHeader^), -50, B_GetNext,FALSE);
  end;{while}

  {gets all other OS Orders}
  SaveIdx := 11;
  FillChar(SearchCode, SizeOf(SearchCode), 0);
  Status := EX_GETTRANSHED(TXHeader, SizeOf(TXHeader^), SearchCode, 11, B_GetFirst,FALSE);
  while Status = 0 do begin
    CheckLine;
    Status := EX_GETTRANSHED(TXHeader, SizeOf(TXHeader^), SearchCode, 11, B_GetNext,FALSE);
    {toolkit errors}
  end;{while}

  dispose(TXLine);
end;

//=======================================================================

constructor TExportAccountCSV.Create;
begin
  inherited Create;
  fCSVType := etAccount;
  new(fCustSuppRec);
end;

//-----------------------------------------------------------------------

destructor TExportAccountCSV.Destroy;
begin
  dispose(fCustSuppRec);
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TExportAccountCSV.WriteAccountField(FieldID : integer);
// longint = 10 digits (>0)
// smallint = 5 digits (>0);
var
  HistoryBalRec : THistoryBalRec;
  pCustCode : PChar;
begin
  with fCustSuppRec^, fHedCSVExport do begin
    case FieldID of
      0:      WriteString(CustCode);
      1:      WriteString(CustSupp);
      2:      WriteString(Company);
      3:      WriteString(AreaCode);
      4:      WriteString(RepCode);
      5:      WriteString(RemitCode);
      6:      WriteString(VATRegNo);
      7..11:  WriteString(Addr[FieldID-6]);
      12:     WriteBool(DespAddr);
      13..17: WriteString(DAddr[FieldID-12]);
      18:     WriteString(Contact);
      19:     WriteString(Phone);
      20:     WriteString(Fax);
      21:     WriteString(RefNo);
      22:     WriteBool(TradTerm);
      23..24: WriteString(STerms[FieldID-22]);
      25:     WriteNum(Currency,2,0);
      26:     WriteString(VATCode);
      27:     WriteNum(PayTerms,3,0);
      28:     WriteNum(CreditLimit,20,2);
      29:     WriteNum(Discount,10,2);
      30:     WriteNum(CreditStatus,4,0);
      31:     WriteString(CustCC);
      32:     WriteString(CDiscCh);
      33:     WriteString(CustDep);
      34:     WriteBool(EECMember);
      35:     WriteBool(IncStat);
      36:     WriteNum(DefNomCode,10,0);
      37:     WriteString(DefMLocStk);
      38:     WriteNum(AccStatus,4,0);
      39:     WriteString(PayType);
      40:     WriteString(BankSort);
      41:     WriteString(BankAcc);
      42:     WriteString(BankRef);
      43:     WriteString(LastUsed);
      44:     WriteString(Phone2);
      45:     WriteString(UserDef1);
      46:     WriteString(UserDef2);
      47:     WriteString(SOPInvCode);
      48:     WriteBool(SOPAutoWOff);
      49:     WriteNum(BOrdVal,20,2);
      50:     WriteNum(DefCOSNom,10,0);
      51:     WriteNum(DefCtrlNom,10,0);
      52:     WriteString(LastOpo);
      53:     WriteNum(DirDeb,5,0);
      54:     WriteString(CCDSDate);
      55:     WriteString(CCDEDate);
      56:     WriteString(CCDName);
      57:     WriteString(CCDCardNo);
      58:     WriteString(CCDSARef);
      59:     WriteNum(DefSetDDays,5,0);
      60:     WriteNum(DefSetDisc,13,2);
      61:     WriteNum(DefFormNo,5,0);
      62:     WriteNum(StatDMode,5,0);
      63:     WriteString(EmailAddr);
      64:     WriteBool(EmlSndRdr);
      65:     WriteString(ebusPwrd);
      66:     WriteString(PostCode);
      67:     WriteString(CustCode2);
      68:     WriteNum(AllowWeb,5,0);
      69:     WriteBool(EmlZipAtc);
      70:     WriteString(UserDef3);
      71:     WriteString(UserDef4);
      72:     WriteString(TimeChange);
      73:     WriteString(SSDDelTerms);
      74:     WriteString(CVATIncFlg);
      75:     WriteNum(SSDModeTr,5,0);
      76:     WriteNum(InvDMode,5,0);
      77:     WriteBool(EmlSndHTML);
      78:     WriteString(WebLiveCat);
      79:     WriteString(WebPrevCat);
      80:
      begin {get current balance using the toolkit}
        FillChar(HistoryBalRec, sizeOf(HistoryBalRec), #0);
        with HistoryBalRec do begin
          Period := 'YTD';
          Year := '250';
          pCustCode := StrAlloc(255);
          StrPCopy(pCustCode, CustCode);
          if EX_GETACCOUNTBALANCE(@HistoryBalRec, SizeOf(HistoryBalRec),pCustCode,0) = 0 then WriteNum(Value,20,2)
          else WriteString('0.00');
          StrDispose(pCustCode);
        end;{with}
      end;
      //PR: 16/10/2013 ABSEXCH-14703
      81:     WriteString(acDeliveryPostcode);
      //PR: 02/06/2015 v7.0.14 
      82:     WriteNum(Ord(acPPDMode), 1, 0);

      83:    WriteString(acCountry);
      84:    WriteString(acDeliveryCountry);
      else
      WriteString('***ERROR***');
    end;{case}
  end;{with}
end;

//-----------------------------------------------------------------------

function TExportAccountCSV.OKToWriteAccountRecord : boolean;
begin
  with fCustSuppRec^ do
  begin
    Result := OKToWriteRecord(LastUsed, TimeChange);
    if not IgnoreWebIncludeFlag then
      Result := Result and (AllowWeb > 0);

    Result := Result and CheckFilter(AccTypeFilter, RepCode, AccTypeFilterFlag);
  end;
end;

//-----------------------------------------------------------------------

procedure TExportAccountCSV.ProcessRecords;
var
  SearchCode : array[0..255] of char;
  i,
  iStatus : integer;
begin
  FillChar(SearchCode, SizeOf(SearchCode), 0);
  iStatus := Ex_GetAccount(fCustSuppRec, SizeOf(fCustSuppRec^), SearchCode, 0, B_GetFirst, 1, false);
  ShowToolkitError('Ex_GetAccount', 3, iStatus);
  while iStatus = 0 do
  begin
    if OKToWriteAccountRecord then
    begin
      for i := 0 to fHedMappedFieldList.Count -1 do begin
        if copy(fHedMappedFieldList[i], 1, length(IGNORE_FIELD)) = IGNORE_FIELD
        then fHedCSVExport.WriteString('')
        else WriteAccountField(fHedFieldList.IndexOf(fHedMappedFieldList[i]));
      end;{for}
      fHedCSVExport.NewLine;
    end;
    iStatus := Ex_GetAccount(fCustSuppRec, SizeOf(fCustSuppRec^), SearchCode, 0, B_GetNext, 1, false);
    ShowToolkitError('Ex_GetAccount', 3, iStatus);
  end;
end;

//=======================================================================

constructor TExportStockGroupCSV.Create;
begin
  inherited Create;
  fCSVType := etStockGroup;
  new(fStockRec);
end;

//-----------------------------------------------------------------------

destructor TExportStockGroupCSV.Destroy;
begin
  dispose(fStockRec);
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TExportStockGroupCSV.WriteStockGrpField(FieldID : integer);
begin
  with fStockRec^, fHedCSVExport do
  case FieldID of
    0:      WriteString(StockCode);
    1:      WriteString(StockCat);
    2..7:   WriteString(Desc[FieldID-1]);
    8 :     WriteString(ImageFile);
  else
    WriteString('***ERROR***');
  end;
end;

//-----------------------------------------------------------------------

function TExportStockGroupCSV.OKToWriteStockGrpRecord : boolean;
begin
  with fStockRec^ do
  begin
    Result := StockType = 'G'; // i.e. only include groups
    Result := Result and OKToWriteRecord(LastUsed, TimeChange);
    if not IgnoreWebIncludeFlag then
      Result := Result and (WebInclude > 0);
  end;
end;

//------------------------------------------------------------------------------

procedure TExportStockGroupCSV.ProcessStockGroups(SearchCode : TCharArray255);
// SearchPath : 0 Stock Code
//              1 Stock Folio Number
//              2 Stock Group
var
  Position, i, Status : integer;
  TempSearchCode : TCharArray255;
  CurGroup : string;
begin
  // Find record in stock file
  Status := Ex_GetStock(fStockRec, SizeOf(fStockRec^), SearchCode, 2, B_GetGEq, false);
  CurGroup := fStockRec^.StockCat;

  // Check we're processing same stock group code
  while (Status = 0) and (Trim(fStockRec^.StockCat) = Trim(CurGroup)) do begin
    with fStockRec^ do begin
      if (StockType = 'G') and (IgnoreWebIncludeFlag  or (WebInclude > 0)) then begin

        {Write record to file}
        for i := 0 to fHedMappedFieldList.Count -1 do begin
          if copy(fHedMappedFieldList[i], 1, length(IGNORE_FIELD)) = IGNORE_FIELD then
            fHedCSVExport.WriteString('')
          else
            WriteStockGrpField(fHedFieldList.IndexOf(fHedMappedFieldList[i]));
        end;{for}
        fHedCSVExport.NewLine;

        // Store Btrieve position
        Ex_GetRecordAddress(StockF, Position);

        // Recurse down a level
        FillChar(TempSearchCode, SizeOf(TempSearchCode), #0);
        Move(StockCode[1], TempSearchCode, length(StockCode));
        ProcessStockGroups(TempSearchCode);

        // Restore Btrieve position - moved back up a level
        Ex_GetRecWithAddress(StockF, 2, Position);
      end;{if}
    end;{with}
    Status := Ex_GetStock(fStockRec, SizeOf(fStockRec^), SearchCode, 2, B_GetNext, false);
  end; // while
end; // ProcessStockGroups

procedure TExportStockGroupCSV.ProcessRecords;
begin
  ProcessStockGroups('');
end;

procedure TExportCSV.ShowToolkitError(sFuncName : string; iFuncNo, iStatus : smallint);
begin
  if not (iStatus in [0,9]) then begin
    MsgBox('Function : ' + sFuncName + #13 + 'Error Number : ' + IntToStr(iStatus) + #13
    + 'Error : ' + EX_ERRORDESCRIPTION(iFuncNo, iStatus),mtError,[mbOK],mbOK,'Toolkit DLL Error');
  end;{if}

end;

procedure TExportCSV.OpenToolkit;
begin
  SetToolkitPath(GetCompanyDirFromCode(Trim(CompanyCode)));
  ShowToolKitError('Ex_InitDLL', 1, Ex_InitDLL);
  EX_GETSYSDATA(@BatchSysRec, SizeOf(BatchSysRec));
end;

procedure TExportCSV.CloseToolkit;
begin
  ShowToolKitError('Ex_CloseDLL',2,Ex_CloseDLL);
end;

end.

