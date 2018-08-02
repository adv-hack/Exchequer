unit COMExprt;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


// Unit to export required files for the price COM calculations

interface

uses
  VarConst, Classes, SysUtils, VarRec2U;

const
  SpareF = ReportF;

type
  TUpdateMode = (updOverwrite, updUpdate);

  EExportCOMError = class(Exception);

  TExportCOMFiles = class
    private
      fCompanyDir : string;
      fExportDir  : string;
      fErrorMsg   : string;
      fUpdateMode : TUpdateMode;
      fLastRun    : TDateTime;
      fIgnoreStockWebIncludeFlag,
      fIgnoreCustWebIncludeFlag: boolean;
    protected
      procedure SetString(const index : integer; const Value : string);
      procedure SetUpdateMode(const Value: TUpdateMode);
      procedure SetLastRun(const Value: TDateTime);
      procedure SetBoolean(const Index: Integer; const Value: boolean);
      function  UpdatePossible : boolean;
      procedure Process(BtrieveCopy : TObject);
      procedure ProcessPwrdFile;
      function  AssignExportFileList : TStringList;
      procedure SwapFileListExt(FileList : TStringList; NewExt : string);
      procedure CreateZipFile;
    public
      property  CompanyDir : string index 1 read fCompanyDir write SetString;
      property  ExportDir : string index 2 read fExportDir write SetString;
      property  ErrorMsg : string index 3 read fErrorMsg;
      property  LastRun : TDateTime read fLastRun write SetLastRun;
      property  UpdateMode : TUpdateMode read fUpdateMode write SetUpdateMode;
      property  IgnoreCustWebIncludeFlag : boolean index 1 read fIgnoreCustWebIncludeFlag write SetBoolean;
      property  IgnoreStockWebIncludeFlag : boolean index 2 read fIgnoreStockWebIncludeFlag write SetBoolean;
      function  RunCOMExport : integer;
  end;

implementation

uses
  BtrvU2, EBusVar, EBusBtrv, GlobVar, Windows, CommsInt, Dialogs, BTSupU1,
  StrUtil, MathUtil, FileUtil, UseDLLU, UseTKit, Forms, MultiBuyVar, QtyBreakVar;

type
  TBtrieveFileCopy = class
    private
      fNum : smallint;
      fCompanyDir : shortstring;
      fExportDir : shortstring;
      fFileName : shortstring;
      fLastRun : TDateTime;
      fUpdateMode : TUpdateMode;
      fIgnoreCustWebIncludeFlag,
      fIgnoreStockWebIncludeFlag : boolean;
    protected
      procedure SetBtrieveInfo;
      procedure SetBoolean(const Index: Integer; const Value: boolean);
      procedure SetString(const Index : integer; const Value : shortstring);
      procedure SetLastRun(const Value : TDateTime);
      procedure SetUpdateMode(const Value : TUpdateMode);

      function  StockIncludeOnWeb(StockFolio : longint) : boolean; virtual;
      function CustIncludeOnWeb(CustCode : string) : boolean;
      function  ExportFileName : string;
      function  UpdatedRecord(EditDate, EditTime : string) : boolean;
      function  ExportThisRecord : boolean; virtual; abstract;
    public
      property  LastRun : TDateTime read fLastRun write SetLastRun;
      property  UpdateMode : TUpdateMode read fUpdateMode write SetUpdateMode;
      property  CompanyDir : shortstring index 1 read fCompanyDir write SetString;
      property  ExportDir : shortstring index 2 read fExportDir write SetString;
      property  FileName : shortstring index 3 read fFileName write SetString;
      property  IgnoreCustWebIncludeFlag : boolean index 1 read fIgnoreCustWebIncludeFlag write SetBoolean;
      property  IgnoreStockWebIncludeFlag : boolean index 2 read fIgnoreStockWebIncludeFlag write SetBoolean;
      procedure CopyRecords;
  end; // TBtrieveFileCopy

  //-----------------------------------------------------------------------

  TCustFileCopy = class(TBtrieveFileCopy)
    protected
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;

  //-----------------------------------------------------------------------

  TStockFileCopy = class(TBtrieveFileCopy)
    protected
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;

  //-----------------------------------------------------------------------

  TMiscFileCopy = class(TBtrieveFileCopy)
    protected
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;

  //-----------------------------------------------------------------------

  TMLocFileCopy = class(TBtrieveFileCopy)
    protected
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;

  //-----------------------------------------------------------------------

  TMultiBuyFileCopy = class(TBtrieveFileCopy)
    protected
      function  StockIncludeMeOnWeb(StockCode : ShortString) : boolean;
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;


  //-----------------------------------------------------------------------
  //PR: 03/04/2012 Add Qty Break file ABSEXCH-9795
  TQtyBreakFileCopy = class(TBtrieveFileCopy)
    protected
      function ExportThisRecord : boolean; override;
    public
      constructor Create;
  end;

  //-----------------------------------------------------------------------


const
  {$I FilePath.inc}

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetString(const Index : integer; const Value: shortstring);
begin
  case Index of
    1: fCompanyDir := Value;
    2: fExportDir := Value;
    3: fFileName := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetBoolean(const Index: Integer; const Value: boolean);
begin
  case Index of
    1: fIgnoreCustWebIncludeFlag := Value;
    2: fIgnoreStockWebIncludeFlag := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetLastRun(const Value: TDateTime);
begin
  fLastRun := Value;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetUpdateMode(const Value: TUpdateMode);
begin
  fUpdateMode := Value;
end;

//-----------------------------------------------------------------------

function TBtrieveFileCopy.ExportFileName : string;
begin
//  Result := IncludeTrailingBackslash(ExportDir) + FileName;
  Result := sTempDir + FileName;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetBtrieveInfo;
var
  Status : integer;
begin
  // Copy file specs into SpareF
  FileNames[SpareF] := FileNames[FNum];

  RecPtr[SpareF] := RecPtr[FNum];
  FileRecLen[SpareF] := FileRecLen[FNum];

  FileSpecOfs[SpareF]^ := FileSpecOfs[FNum]^;
  FileSpecLen[SpareF] := FileSpecLen[FNum];

  Status := Open_File(F[FNum], CompanyDir + FileNames[FNum], 0);
  if Status <> 0 then
    raise EExportCOMError.CreateFmt('Could not open file %s' + #13#10 + '%s',
      [CompanyDir + FileNames[FNum], Set_StatMes(Status)])
  else
  begin
    Status := Open_File(F[SpareF], ExportFileName, 0);
    if Status <> 0 then
      raise EExportCOMError.CreateFmt('Could not open file %s' + #13#10 + '%s',
      [ExportFileName, Set_StatMes(Status)]);
  end;
end; // TBtrieveFileCopy.SetBtrieveInfo;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.CopyRecords;
var
  Status : integer;
  Keys : str255;
begin
  SysUtils.DeleteFile(ExportFileName);

  // Create Btrieve File to copy data into
  Status := Make_File(F[FNum], ExportFileName, FileSpecOfs[FNum]^, FileSpecLen[FNum]);
  if Status <> 0 then
    raise EExportCOMError.CreateFmt('Could not create file %s' + #13#10 + '%s',
      [ExportFileName, Set_StatMes(Status)])
  else
  try
    SetBtrieveInfo;

    Status := Find_Rec(B_GetFirst, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    while (Status = 0) do
    begin
      if ExportThisRecord then
        Add_Rec(F[SpareF], SpareF, RecPtr[SpareF]^, 0);
      Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
      Application.ProcessMessages;
    end;

  finally
    Close_File(F[FNum]);
    Close_File(F[SpareF]);
  end;
end;

//-----------------------------------------------------------------------

function TBtrieveFileCopy.UpdatedRecord(EditDate, EditTime : string) : boolean;
var
  RecEditDateTime : TDateTime;
begin
  RecEditDateTime := ToDateTime(EditDate, EditTime);
  Result := (UpdateMode = updOverwrite) or
              ZeroFloat(RecEditDateTime) or
              ZeroFloat(LastRun) or
              (RecEditDateTime >= LastRun);
end;

//-----------------------------------------------------------------------

function TBtrieveFileCopy.StockIncludeOnWeb(StockFolio: Integer): boolean;
var
  StockRec : TBatchSKRec;
  SearchKey : array[0..255] of char;
begin
  Result := IgnoreStockWebIncludeFlag;
  if not Result then
  begin
    Status := Ex_GetStockByFolio(@StockRec, SizeOf(StockRec), StockFolio, B_GetEq, false);
    while (Status = 0) and not Result do
    begin
      Result := StockRec.WebInclude > 0;
      if not Result then
      begin // Search up the stock tree
        StrPCopy(SearchKey, StockRec.StockCat);
        Status := Ex_GetStock(@StockRec, SizeOf(StockRec), SearchKey, 0, B_GetEq, false);
      end;
    end;
  end;
end;

//=======================================================================

constructor TCustFileCopy.Create;
begin
  inherited Create;
  FNum := CustF;
  FileName := CustName;
end;

//-----------------------------------------------------------------------

function TCustFileCopy.ExportThisRecord : boolean;
begin
  Result := (Cust.CustSupp = 'C'); // Customers only
  Result := Result and ((Cust.AllowWeb > 0) or (IgnoreCustWebIncludeFlag));
  Result := Result and UpdatedRecord(Cust.LastUsed, Cust.TimeChange);
end;

//=======================================================================

constructor TStockFileCopy.Create;
begin
  inherited Create;
  FNum := StockF;
  FileName := StockNam;
end;

//-----------------------------------------------------------------------

function TStockFileCopy.ExportThisRecord : boolean;
begin
//  Result := (Stock.StockType in ['P','M']); // Products and Bill of Materials

  // NF 23/03/04 Changed to include groups and description only items
  Result := (Stock.StockType in ['P','M','D','G']); // Products, Bill of Materials, groups and description only items

  Result := Result and StockIncludeOnWeb(Stock.StockFolio);
  Result := Result and UpdatedRecord(Stock.LastUsed, Stock.TimeChange);
end;

//=======================================================================

constructor TMiscFileCopy.Create;
begin
  inherited Create;
  FNum := MiscF;
  FileName := MiscNam;
end;

//-----------------------------------------------------------------------


//-----------------------------------------------------------------------

function TMiscFileCopy.ExportThisRecord : boolean;
// Notes : Currently if the user edits the discount matrices and thereby updates
//         records in this file, the last edit date fields in the main customer or
//         stock files are not updated.  Therefore it's not possible to only send
//         updated records from this misc. file.
var
  StockFolio : longint;
begin
  with MiscRecs^ do
  begin
    // Only meaningful for a stock quantity break variant
    move(QtyDiscRec.DiscQtyCode[1], StockFolio, SizeOf(StockFolio));
    Result :=
      // Customer discounts
      (((RecMfix = 'C') and (SubType = 'C') and CustIncludeOnWeb(CustDiscRec.DCCode)) or
      // Customer quant breaks
      ((RecMfix = 'D') and (SubType = 'C') and CustIncludeOnWeb(QtyDiscRec.QCCode)) or
      // Stock Quantity break
      ((RecMfix = 'D') and (SubType = 'Q') and StockIncludeOnWeb(StockFolio)));
  end;
end;

//=======================================================================

constructor TMLocFileCopy.Create;
begin
  inherited Create;
  FNum := MLocF;
  FileName := MLocName;
end;

//-----------------------------------------------------------------------


//-----------------------------------------------------------------------

function TMLocFileCopy.ExportThisRecord : boolean;
// Notes : Currently if the user edits the discount matrices and thereby updates
//         records in this file, the last edit date fields in the main customer or
//         stock files are not updated.  Therefore it's not possible to only send
//         updated records from this MLoc. file.
{var
  StockFolio : longint;}
begin
  with MLocCtrl^ do
  begin
    // Only meaningful for a stock quantity break variant
//    move(QtyDiscRec.DiscQtyCode[1], StockFolio, SizeOf(StockFolio));
    Result :=
      // Location Pricing Records for Stock
      ((RecPfix = 'C') and (SubType = 'C')) or
      // Location Records
      ((RecPfix = 'C') and (SubType = 'D'));
  end;
end;

//=======================================================================

procedure TExportCOMFiles.SetString(const Index: integer; const Value: string);
begin
  case Index of
    1: fCompanyDir := Value;
    2: fExportDir := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.SetLastRun(const Value: TDateTime);
begin
  fLastRun := Value;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.SetUpdateMode(const Value: TUpdateMode);
begin
  fUpdateMode := Value;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.SetBoolean(const Index: Integer; const Value: boolean);
begin
  case Index of
    1: fIgnoreCustWebIncludeFlag := Value;
    2: fIgnoreStockWebIncludeFlag := Value;
  end;
end;

//-----------------------------------------------------------------------

function TExportCOMFiles.UpdatePossible : boolean;
// Post : Returns false if update was requested but there is no last run reference date
begin
  Result := not (ZeroFloat(LastRun) and (UpdateMode = updUpdate));
  if not Result then
  begin
    fErrorMsg := 'The COM pricing export could not be run in update mode as it ' + #13#10;
    fErrorMsg := fErrorMsg + 'has never been run previously via this particular export.' + #13#10;
    fErrorMsg := fErrorMsg + 'A complete data upload has been processed.';
    UpdateMode := updOverwrite;
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.Process(BtrieveCopy : TObject);
begin
  if BtrieveCopy is TBtrieveFileCopy then
    with (BtrieveCopy as TBtrieveFileCopy) do
      try
        LastRun := self.LastRun;
        UpdateMode := self.UpdateMode;
        CompanyDir := self.CompanyDir;
        ExportDir := self.ExportDir;
        IgnoreCustWebIncludeFlag := self.IgnoreCustWebIncludeFlag;
        IgnoreStockWebIncludeFlag := self.IgnoreStockWebIncludeFlag;
        CopyRecords;
      finally
        Free;
      end;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.ProcessPwrdFile;
var
  ExistingFile,
  NewFile : ansistring;
begin
  ExistingFile := CompanyDir + PathSys;
  NewFile := sTempDir + PathSys;
  CopyFile(PChar(ExistingFile), PChar(NewFile), false);
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.SwapFileListExt(FileList : TStringList; NewExt : string);
var
  i : integer;
begin
  for i := 0 to FileList.Count -1 do
    FileList[i] := ChangeFileExt(FileList[i], NewExt);
end;

//-----------------------------------------------------------------------

function TExportCOMFiles.AssignExportFileList : TStringList;
// Notes : Calling code needs to Free the returned string list
begin
  Result := TStringList.Create;
  with Result do
  begin
    Add(sTempDir + CustName);
    Add(sTempDir + StockNam);
    Add(sTempDir + MiscNam);
    Add(sTempDir + MLocName);
    Add(sTempDir + PathSys);
    Add(sTempDir + MultiBuyNam);

    //PR: 03/04/2012 Add QtyBreak File ABSEXCH-9795
    Add(sTempDir + QtyBreakNam);
  end;
end;

//-----------------------------------------------------------------------

procedure TExportCOMFiles.CreateZipFile;
const
  OVERWRITE_ZIPFILE = 'ENTPRCO.ZIP';
  UPDATE_ZIPFILE = 'ENTPRCU.ZIP';
var
  Result : smallint;
  ZipFileList : TStringList;
  EntZip : TEntZip;
  Msg : string;
begin
  // Instance to aid with debugging
  EntZip := TEntZip.Create;

  with EntZip do
  try
    ZipFileList := AssignExportFileList;
    Files.Assign(ZipFileList);

    if UpdateMode = updOverwrite then
      ZipName := ExportDir + OVERWRITE_ZIPFILE
    else
      ZipName := ExportDir + UPDATE_ZIPFILE;

    OverwriteExisting := true;
    StripDrive := true;
    StripPath := true;
    // Not possible to get progress of zip at moment - callbacks available
    // from Abbrevia code but not implemented in Entcomms.dll
    try
      Result := Save;
      if Result <> 0 then
      begin
        case Result of
          1: Msg := 'No files to compress';
          2: Msg := 'Could not delete existing ZIP file';
          3: Msg := 'Could not find compression DLL (EntComms.DLL)';
        else
          Msg := 'Unknown error';
        end;
        raise EExportCOMError.CreateFmt('Trying to create file zip %s' + #13#10 + '%s',
          [ZipName, Msg]);
      end;
    finally
      DeleteFiles(ZipFileList);
      // Remove any associated lock files
      SwapFileListExt(ZipFileList, '.LCK');
      DeleteFiles(ZipFileList);
      ZipFileList.Free;
    end;
  finally
    Free;
  end;
end;

//-----------------------------------------------------------------------

function TExportCOMFiles.RunCOMExport : integer;
// Post : 0 = no errors
//        1 = warnings
//        2 = error
begin
  try
    Result := 0;
    if not UpdatePossible then
      Result := 1;
    Process(TCustFileCopy.Create);
    Process(TStockFileCopy.Create);
    Process(TMiscFileCopy.Create);
    Process(TMLocFileCopy.Create);
    Process(TMultiBuyFileCopy.Create);
    //PR: 03/04/2012 Add Qty Break file ABSEXCH-9795
    Process(TQtyBreakFileCopy.Create);
    ProcessPwrdFile;
    CreateZipFile;
  except
    on E:EExportCOMError do
    begin
      fErrorMsg := E.Message;
      Result := 2;
    end;
  end;
end;

{ TMultiBuyFileCopy }

constructor TMultiBuyFileCopy.Create;
begin
  inherited Create;
  FNum := MultiBuyF;
  FileName := MultiBuyNam;
end;


function TMultiBuyFileCopy.ExportThisRecord: boolean;
begin
  with MultiBuyDiscount do
    Result := ((Trim(mbdAcCode) = '') or CustIncludeOnWeb(mbdAcCode)) and
               StockIncludeMeOnWeb(mbdStockCode);
end;

function TMultiBuyFileCopy.StockIncludeMeOnWeb(StockCode: ShortString): boolean;
var
  StockRec : TBatchSKRec;
  SearchKey : array[0..255] of char;
begin
  Result := IgnoreStockWebIncludeFlag;
  if not Result then
  begin
    StrPCopy(SearchKey, StockCode);
    Status := Ex_GetStock(@StockRec, SizeOf(StockRec), SearchKey, 0, B_GetEq, false);
    while (Status = 0) and not Result do
    begin
      Result := StockRec.WebInclude > 0;
      if not Result then
      begin // Search up the stock tree
        StrPCopy(SearchKey, StockRec.StockCat);
        Status := Ex_GetStock(@StockRec, SizeOf(StockRec), SearchKey, 0, B_GetEq, false);
      end;
    end;
  end;
end;

function TBtrieveFileCopy.CustIncludeOnWeb(CustCode: string): boolean;
var
  CustRec : TBatchCURec;
  SearchRef : array[0..255] of char;
begin
  Result := IgnoreCustWebIncludeFlag;
  if not Result then
  begin
    StrPCopy(SearchRef, copy(CustCode,1,6));
    Status := Ex_GetAccount(@CustRec, SizeOf(CustRec), SearchRef, 0, B_GetEq, 1, false);
    if (Status = 0) and (CustRec.AllowWeb > 0) then
      Result := true;
  end;
end;

{ TQtyBreakFileCopy }

constructor TQtyBreakFileCopy.Create;
begin
  inherited;
  FNum := QtyBreakF;
  FileName := QtyBreakNam;
end;

function TQtyBreakFileCopy.ExportThisRecord: boolean;
begin
  Result := True;
end;

end.


