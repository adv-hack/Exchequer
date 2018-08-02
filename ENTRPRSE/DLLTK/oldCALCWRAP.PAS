unit CalcWrap;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  StdCtrls, Classes, AbArcTyp;

type

{$I COMPrice.inc}

function CurrencyInfo(RootDir : pchar;
                      CurrNum : smallint;
                      CurrName, CurrSymbol : pchar) : smallint;
                      stdcall export;

function CalculatePrice(RootDir,
                        AccCode,
                        StockCode : pchar;
                        CurrencyCode : smallint;
                        Quantity : double;
                        var Price : double) : smallint;
                        stdcall export;

function CalculatePriceByLocation(RootDir,
                                  AccCode,
                                  StockCode,
                                  DefLoc : pchar;
                                  CurrencyCode : smallint;
                                  Quantity : double;
                              var Price : double) : smallint;
                                  stdcall export;


function ProcessPriceUpdate(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
                            stdcall export;

function ProcessPriceUpdateWithLocation(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
                            stdcall export;

procedure SetLocation(LocCode : PChar; SetOn : Boolean); stdcall export;


implementation

uses
  IniFiles, SysUtils, dllsk01u, dllmiscu, dll01u, ETStrU, InitDLLU, GlobVar, VarCnst3,
  Windows, AbUnzPer, Dialogs, {TKUtil, }FileCtrl, VarConst, BtrvU2, Forms,
  BtKeys1U, Crypto, Varrec2U, BtSupU1;

const
  SpareF = ReportF;

type
  ECOMPriceUpdateError = class(Exception)
    private
      fErrorCode : smallint;
    public
      constructor Create(ErrorCode: smallint; const Msg: string = '');
      property ErrorCode : smallint read fErrorCode;
  end;

  TBtrieveFileCopy = class
    private
      fNum : smallint;
      fUploadDir,
      fInstallDir,
      fFileName : shortstring;
    protected
      function  GetKeyValue : str255; virtual; abstract;
      procedure SetBtrieveInfo;
      procedure ProcessRecord;
      procedure SetString(const Index : integer; const Value : shortstring);
      property  FileName : shortstring index 1 read fFileName write SetString;
    public
      property  UploadDir : shortstring index 2 read fUploadDir write SetString;
      property  InstallDir : shortstring index 3 read fInstallDir write SetString;
      procedure CopyRecords;
  end; // TBtrieveFileCopy

  TCustFileCopy = class(TBtrieveFileCopy)
    protected
      function GetKeyValue : str255; override;
    public
      constructor Create;
  end;

  TStockFileCopy = class(TBtrieveFileCopy)
    protected
      function GetKeyValue : str255; override;
    public
      constructor Create;
  end;

  TMiscFileCopy = class(TBtrieveFileCopy)
    protected
      function GetKeyValue : str255; override;
    public
      constructor Create;
  end;

  TMLocFileCopy = class(TBtrieveFileCopy)
    protected
      function GetKeyValue : str255; override;
    public
      constructor Create;
  end;

  TUpdateMode = (updOverwrite, updUpdate);

  TUpdatePriceFiles = class
    private
      fUpdateMode  : TUpdateMode;
      fUploadDir,               // Directory for uploaded files
      fInstallDir,              // Directory for installation to
      fZipFileName : string;    // Name of the zip file (no path)
      fStatus      : smallint;
    protected
      procedure SetZipFileName;
      procedure ExplodeZipFile;
      procedure SetDir(Index : integer; const Value : string);
      function  AssignFileList(FileSet : TFileNumSet;
                                         const RootDir : string;
                                         IncludeSubPath : boolean) : TStringList;
      procedure SwapFileListExt(FileList : TStringList; NewExt : string);
      function  DeleteFiles(FileList : TStringList) : boolean;
      procedure UpdateFiles;
      procedure ProcessBtrieveUpdate(BtrieveCopy : TObject);
      procedure OverwriteFiles;
      procedure CheckFilesPresent;
      procedure ConfirmOK(var FileName : string; var Confirm : boolean);
      procedure UnzipFail(Sender : TObject; Item : TAbArchiveItem;
                           ProcessType : TAbProcessType;
                           ErrorClass : TAbErrorClass;
                           ErrorCode : integer);
    public
      property UploadDir : string index 1 read fUploadDir write SetDir;
      property InstallDir : string index 2 read fInstallDir write SetDir;
      procedure Process;
  end;

const
  INVALID_DIR = 1;             // The upload or install directory does not exist
  NO_ZIPFILE = 2;              // No price update zip file found in specified directory
  ZIPPED_FILE_MISSING = 3;     // One of the expected files in the archive was missing
  UNZIP_ERROR = 4;             // An internal exception was raised during unzipping
  OVERWRITE_UPDATE_FAILED = 5; // Btrieve files not overwritten successfully
  BTRIEVE_ERROR = 6;           // Btrieve error
  CANNOT_OPEN_FILES = 7;       // Could not open installed COM price database

{$I Exchdll.inc}

var
  DefaultLocation : String[3];

//-----------------------------------------------------------------------

function InitialiseFiles(RootDir : string) : smallint;
// Pre : RootDir = Root data directory for specific Enterprise company

  // Copied from Entrprse\Funcs\TKUtil.Pas to avoid requireing the Toolkit DLL!
  procedure ToolKitOK;
  const
    CODE = #238 + #27 + #236 + #131 + #174 + #38 + #110 + #208 + #185 + #168 + #157;
  var
    pCode : array[0..255] of char;
  begin
    ChangeCryptoKey(19701115);
    StrPCopy(pCode, Decode(CODE));
    Ex_SetReleaseCode(pCode);
  end;

begin
  ToolkitOK;
  // Initialise globals appropriately
  SetDrive := RootDir;
  OvExPathName := RootDir;
  Result := CalcPriceBtrieveInit;
  // Within INITDLLU.InitialiseDLLMain (called from CalCostBtrieveInit)
  // EXSyss structure FillChar with 0
  ExSyss.ExPath := RootDir;
  ExSyss.MCMode := true; // Set multi-currency mode on
end; // InitialiseFiles

//-----------------------------------------------------------------------

function CalculatePrice(RootDir,
                        AccCode,
                        StockCode : pchar;
                        CurrencyCode : smallint;
                        Quantity : double;
                        var Price : double) : smallint;
var
  PriceInfo : TBatchStkPriceRec;

  procedure SetLocCode;
  begin
    if CheckRecExsists(PriceInfo.CustCode,CustF,CustCodeK) then
      PriceInfo.LocCode := Cust.DefMLocStk;
    if Trim(PriceInfo.LocCode) = '' then
    begin
      if CheckRecExsists(PriceInfo.StockCode, StockF, StkCodeK) then
        PriceInfo.LocCode := Stock.DefMLoc;
      if Trim(PriceInfo.LocCode) = '' then
        PriceInfo.LocCode := DefaultLocation;
    end;
  end;

begin
  Result := InitialiseFiles(RootDir);
  if Result <> 0 then
    exit;

  try
    FillChar(PriceInfo, SizeOf(PriceInfo), 0);
    PriceInfo.CustCode := FullCustCode(AccCode);
    PriceInfo.StockCode := StockCode + StringOfChar(' ', 16 - length(StockCode));
    PriceInfo.Currency := CurrencyCode;
    PriceInfo.Qty := Quantity;

    PriceInfo.PriceDate := FormatDateTime('yyyymmdd', SysUtils.Date);

    if UseLoc then
      SetLocCode;

    Result := Ex_CalcStockPrice(@PriceInfo, SizeOf(PriceInfo));

    if Result = 0 then
      if PriceInfo.DiscChar = '%' then
        Price := PriceInfo.Price * (1 - (PriceInfo.DiscVal / 100))
      else
        Price := PriceInfo.Price - PriceInfo.DiscVal
    else
      Price := 0;
  finally
    Ex_CloseData;
  end;
end; // CalculatePrice

//-----------------------------------------------------------------------

function CurrencyInfo(RootDir : PChar;
                      CurrNum : smallint;
                      CurrName, CurrSymbol : PChar) : smallint;
var
  CurrRec : TBatchCurrRec;
begin
  Result := InitialiseFiles(RootDir);
  if Result <> 0 then
    exit;

  try
    FillChar(CurrRec, Sizeof(CurrRec), 0);
    Result := Ex_GetCurrency(@CurrRec, SizeOf(CurrRec), CurrNum);
    if Result = 0 then
      with CurrRec do
      begin
        StrPCopy(CurrName, Name);
        StrPCopy(CurrSymbol, ScreenSymb);
      end;
  finally
    Ex_CloseData;
  end;
end; // GetCurrency

//=======================================================================

constructor ECOMPriceUpdateError.Create(ErrorCode: smallint; const Msg: string = '');
begin
  inherited Create(Msg);
  fErrorCode := ErrorCode;
end;

//=======================================================================

procedure TUpdatePriceFiles.SetDir(Index: integer; const Value: string);
var
  DirName : string;
begin
  case Index of
    1: begin
         fUploadDir := Value;
         DirName := 'upload';
       end;
    2: begin
         fInstallDir := Value;
         DirName := 'install';
       end;
  end;
  if not DirectoryExists(Value) then
    raise ECOMPriceUpdateError.Create(INVALID_DIR,
      'The specified ' + DirName + ' directory of ' + Value + ' does not exist');
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.SetZipFileName;
// Notes : Looks for a zipfile containing either a complete set of files to overwrite
//         existing ones or zipfile containing files to use for the update process.
const
  OVERWRITE_ZIPFILE = 'ENTPRCO.ZIP';
  UPDATE_ZIPFILE = 'ENTPRCU.ZIP';
begin
  if FileExists(IncludeTrailingBackSlash(fUploadDir) + OVERWRITE_ZIPFILE) then
  begin
    fZipFileName := OVERWRITE_ZIPFILE;
    fUpdateMode := updOverwrite
  end
  else
    if FileExists(IncludeTrailingBackSlash(fUploadDir) + UPDATE_ZIPFILE) then
    begin
      fZipFileName := UPDATE_ZIPFILE;
      fUpdateMode := updUpdate;
    end
    else
      raise ECOMPriceUpdateError.Create(NO_ZIPFILE, 'No zip file could be found to process');
end; // TUpdatePriceFiles.SetZipFileName

//-----------------------------------------------------------------------

function TUpdatePriceFiles.AssignFileList(FileSet : TFileNumSet;
                                          const RootDir : string;
                                          IncludeSubPath : boolean) : TStringList;
// Pre   : FileList = set including CustF, StockF, MiscF, SysF as required
//         RootDir  = directory files located in
//         IncludSubPath = true => include Enterprise sub-directory
//                         e.g. CompA\Cust\CustSupp.dat
// Notes : Calling code needs to Free the returned string list
var
  FileName,
  SubPath : string;

  procedure AddFileToList;
  begin
    if IncludeSubPath then
      Result.Add(RootDir + SubPath + FileName)
    else
      Result.Add(RootDir + FileName);
  end;

begin
  Result := TStringList.Create;

  if CustF in FileSet then
  begin
    FileName := CustName;
    SubPath := Path1;
    AddFileToList;
  end;
  if StockF in FileSet then
  begin
    FileName := StockNam;
    SubPath := Path4;
    AddFileToList;
  end;
  if MiscF in FileSet then
  begin
    FileName := MiscNam;
    SubPath := Path3;
    AddFileToList;
  end;
  if SysF in FileSet then
  begin
    FileName := PathSys;
    SubPath := '';
    AddFileToList;
  end;
  if (MLocF in FileSet) and UseLoc then
  begin
    FileName := MLocName;
    SubPath := Path4;
    AddFileToList;
  end;
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.SwapFileListExt(FileList : TStringList; NewExt : string);
var
  i : integer;
begin
  for i := 0 to FileList.Count -1 do
    FileList[i] := ChangeFileExt(FileList[i], NewExt);
end;

//-----------------------------------------------------------------------

function TUpdatePriceFiles.DeleteFiles(FileList : TStringList) : boolean;
// Pre    : FileList = String list with fully qualified file names
// Action : Attempts to delete as many files as possible
// Post   : Returns true if all files deleted
var
  i : integer;
  DeleteOK : boolean;
begin
  if not Assigned(FileList) then
  begin
    Result := false;
    exit;
  end;

  Result := true;
  with FileList do
    for i := 0 to Count -1 do
    begin
      // Avoid any problems with short-circuit boolean evaluation
      DeleteOK := SysUtils.DeleteFile(Strings[i]);
      Result := Result and DeleteOK;
    end;
end; // TUpdatePriceFiles.DeleteFiles

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.CheckFilesPresent;
var
  FileList : TStringList;
  i : integer;
  AllFilesExist : boolean;
  Msg : string;
begin
  AllFilesExist := true;
  Msg := 'Missing file(s) in upload directory';
  FileList := AssignFileList([CustF, StockF, MiscF, SysF, MLocF], UploadDir, false);
  try
    for i := 0 to FileList.Count -1 do
      if not FileExists(FileList[i]) then
      begin
        Msg := Msg + #13#10 + FileList[i] + ' missing';
        AllFilesExist := false;
      end;
  finally
    FileList.Free;
  end;

  if not AllFilesExist then
    raise ECOMPriceUpdateError.Create(ZIPPED_FILE_MISSING, Msg);
end; // TUpdatePriceFiles.CheckFilesPresent

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.ConfirmOK(var FileName : string; var Confirm : boolean);
// Notes : Event handler.
//         Automatically overwrite any existing files with new version from zip file
begin
  Confirm := true;
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.UnzipFail(Sender : TObject; Item : TAbArchiveItem;
                                      ProcessType : TAbProcessType;
                                      ErrorClass : TAbErrorClass;
                                      ErrorCode : integer);
var
  Msg : string;
begin
  Msg := 'Error processing unzipping of : ' + fZipFileName + #13#10 +
         'Attempting to extract : ' + Item.DiskFileName;
  if ErrorClass = ecAbbrevia then
    Msg := Msg + AbStrRes[ErrorCode];

  raise ECOMPriceUpdateError.Create(UNZIP_ERROR, Msg);
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.ExplodeZipFile;
begin
  with TAbUnzipper.Create(nil) do
  try
    // Event handler to ensure any existing files overwritten
    OnConfirmOverwrite := ConfirmOK;
    OnProcessItemFailure := UnzipFail;
    BaseDirectory := UploadDir;
    FileName := UploadDir + fZipFileName;
    ExtractFiles('*.*');
    CheckFilesPresent;
  finally
    Free;
  end;
end; // TUpdatePriceFiles.ExplodeZipFile

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.ProcessBtrieveUpdate(BtrieveCopy : TObject);
begin
  if BtrieveCopy is TBtrieveFileCopy then
    with (BtrieveCopy as TBtrieveFileCopy) do
      try
        UploadDir := self.UploadDir;
        InstallDir := self.InstallDir;
        CopyRecords;
      finally
        Free;
      end;
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.UpdateFiles;
var
  Status : integer;
  DelFileList : TStringList;
begin
  try
    Status := InitialiseFiles(InstallDir);
    if Status <> 0 then
      raise ECOMPriceUpdateError.Create(CANNOT_OPEN_FILES,
        Format('Could not open installed COM pricing database in %s', [InstallDir]));

    try
      with TBtrieveFileCopy.Create do
        try
          ProcessBtrieveUpdate(TCustFileCopy.Create);
          ProcessBtrieveUpdate(TStockFileCopy.Create);
          ProcessBtrieveUpdate(TMiscFileCopy.Create);
          if UseLoc then
            ProcessBtrieveUpdate(TMLocFileCopy.Create);
        finally
          Free;
        end;
    finally
      // Close all the files
      Ex_CloseData;
    end;

    // Copy ExchqSS.DAT
    OverwriteFiles;

  finally
    // Clear up
    DelFileList := AssignFileList([CustF, StockF, MiscF, SysF], UploadDir, false);
    try
      DeleteFiles(DelFileList);
      SwapFileListExt(DelFileList, '.LCK');
      DeleteFiles(DelFileList);
    finally
      DelFileList.Free;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.OverwriteFiles;
var
  FromFileList,
  ToFileList : TStringList;
  NumFiles : integer;
  AllFilesMovedOK : boolean;
begin
  try
    if fUpdateMode = updOverwrite then
    begin
      FromFileList := AssignFileList([CustF, StockF, MiscF, SysF, MLocF], UploadDir, false);
      ToFileList := AssignFileList([CustF, StockF, MiscF, SysF, MLocF], InstallDir, true);
    end
    else
    begin
      FromFileList := AssignFileList([SysF], UploadDir, false);
      ToFileList := AssignFileList([SysF], InstallDir, true);
    end;
    DeleteFiles(ToFileList);

    NumFiles := 0;
    AllFilesMovedOK := true;
    while AllFilesMovedOK and (NumFiles < ToFileList.Count) do
    begin
      ForceDirectories(ExtractFilePath(ToFileList.Strings[NumFiles]));
      AllFilesMovedOK := AllFilesMovedOK and
        MoveFile(PChar(FromFileList.Strings[NumFiles]),
          PChar(ToFileList.Strings[NumFiles]));
      inc(NumFiles);
    end;
  finally
    FromFileList.Free;
    ToFileList.Free;
  end;

  if not AllFilesMovedOK then
    raise ECOMPriceUpdateError.Create(OVERWRITE_UPDATE_FAILED, 'Overwrite failed');
end; // TUpdatePriceFiles.OverwriteFiles;

//-----------------------------------------------------------------------

procedure TUpdatePriceFiles.Process;
begin
  SetZipFileName;
  ExplodeZipFile;
  if fUpdateMode = updUpdate then
    UpdateFiles
  else
    OverwriteFiles;
  SysUtils.DeleteFile(IncludeTrailingBackSlash(fUploadDir) + fZipFileName);
end; // TUpdatePriceFiles.Process

//=======================================================================

function ProcessPriceUpdate(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
begin
  with TUpdatePriceFiles.Create do
  try
    try
      Result := 0;
      StrPCopy(COMPriceUpdateRec.ErrorMsg, 'OK');
      UploadDir := IncludeTrailingBackslash(COMPriceUpdateRec.UploadDir);
      InstallDir := IncludeTrailingBackslash(COMPriceUpdateRec.InstallDir);
      Process;
    except
      on E:ECOMPriceUpdateError do
      begin
        Result := E.ErrorCode;
        StrPCopy(COMPriceUpdateRec.ErrorMsg, E.Message);
      end;
    end;
  finally
    Free;
  end;
end;

//=======================================================================

procedure TBtrieveFileCopy.SetString(const Index: integer; const Value: shortstring);
begin
  case Index of
    1: fFileName := Value;
    2: fUploadDir := Value;
    3: fInstallDir := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.SetBtrieveInfo;
var
  Status : integer;
begin
  // Use Spare file as the one being read in i.e. in the upload dir

  // Copy file specs into SpareF
  FileNames[SpareF] := FileNames[FNum];

  RecPtr[SpareF]       := RecPtr[FNum];
  FileRecLen[SpareF]   := FileRecLen[FNum];

  FileSpecOfs[SpareF]^ := FileSpecOfs[FNum]^;
  FileSpecLen[SpareF]  := FileSpecLen[FNum];

  Status := Open_File(F[SpareF], UploadDir + ExtractFileName(FileNames[SpareF]), 0);
  if Status <> 0 then
    raise ECOMPriceUpdateError.Create(BTRIEVE_ERROR,
      Format('Could not open upload file %s' + #13#10 + '%s',
      [UploadDir + FileNames[SpareF], Set_StatMes(Status)]));

  Status := Open_File(F[FNum], InstallDir + FileNames[FNum], 0);
  if Status <> 0 then
    raise ECOMPriceUpdateError.Create(BTRIEVE_ERROR,
      Format('Could not open file %s' + #13#10 + '%s',
      [InstallDir + FileNames[FNum], Set_StatMes(Status)]));
end; // TBtrieveFileCopy.SetBtrieveInfo;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.CopyRecords;
var
  Status : integer;
  Keys : str255;
begin
  try
    SetBtrieveInfo;

    Status := Find_Rec(B_StepFirst, F[SpareF], SpareF, RecPtr[SpareF]^, 0, KeyS);
    while (Status = 0) do
    begin
      ProcessRecord;
      Status := Find_Rec(B_StepNext, F[SpareF], SpareF, RecPtr[SpareF]^, 0, KeyS);
      Application.ProcessMessages;
    end;

  finally
    Close_File(F[FNum]);
    Close_File(F[SpareF]);
  end;
end;

//-----------------------------------------------------------------------

procedure TBtrieveFileCopy.ProcessRecord;
type
  BufferType = array[1..4096] of char;
var
  Status : integer;
  KeyS : str255;
  TempBuffer : ^BufferType;
begin
  KeyS := GetKeyValue;

  // Save copy of record
  GetMem(TempBuffer, SizeOf(TempBuffer^));
  Move(RecPtr[SpareF]^, TempBuffer[1], FileRecLen[FNum]);

  Status := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);

  // Restore copy
  Move(TempBuffer[1], RecPtr[SpareF]^, FileRecLen[FNum]);
  FreeMem(TempBuffer, SizeOf(TempBuffer^));

  if Status = 0 then
    Status := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0)
  else
    Status := Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
end;

//-----------------------------------------------------------------------

constructor TCustFileCopy.Create;
begin
  inherited Create;
  FNum := CustF;
  FileName := CustName;
end;

//-----------------------------------------------------------------------

function TCustFileCopy.GetKeyValue : str255;
var
  UploadCust : CustRec;
begin
  Move(RecPtr[SpareF]^, UploadCust, SizeOf(UploadCust));
  Result := FullCustCode(UploadCust.CustCode);
end;

//=======================================================================

constructor TStockFileCopy.Create;
begin
  inherited Create;
  FNum := StockF;
  FileName := StockNam;
end;

//-----------------------------------------------------------------------

function TStockFileCopy.GetKeyValue : str255;
var
  UploadStock : StockRec;
begin
  Move(RecPtr[SpareF]^, UploadStock, SizeOf(UploadStock));
  Result := FullStockCode(UploadStock.StockCode);
end;

//=======================================================================

constructor TMiscFileCopy.Create;
begin
  inherited Create;
  FNum := MiscF;
  FileName := MiscNam;
end;

//-----------------------------------------------------------------------

function TMiscFileCopy.GetKeyValue : str255;
var
  UploadMisc : MiscRec;
begin
  Move(RecPtr[SpareF]^, UploadMisc, SizeOf(UploadMisc));
  // QtyDiscType.DiscQtyCode = CustDiscType.DiscCode so should be irrelevant which used
  Result := UploadMisc.RecMfix + UploadMisc.SubType + UploadMisc.CustDiscRec.DiscCode;
end;

function TMLocFileCopy.GetKeyValue : str255;
var
  UploadMLoc : MLocRec;
begin
  Move(RecPtr[SpareF]^, UploadMLoc, SizeOf(UploadMLoc));
  // QtyDiscType.DiscQtyCode = CustDiscType.DiscCode so should be irrelevant which used
  Result := UploadMLoc.RecPfix + UploadMLoc.SubType + UploadMLoc.MLocLoc.loCode;
end;

constructor TMLocFileCopy.Create;
begin
  inherited Create;
  FNum := MLocF;
  FileName := MLocName;
end;


//-----------------------------------------------------------------------

(*
procedure CalcStockPrice;
{calculates the price and VAT using the transaction line record}
var
  VATCodeRec : TVATCodeDefaultType;
  iStatus : smallint;
  TLRec : TBatchTLRec;
begin
  with TXLineRec, LStockRec do begin
    {Get Stock Pricing}
    FillChar(StockPriceRec, SizeOf(StockPriceRec),#0);
    with StockPriceRec  do begin
      (* ORDER OF PLAY
      Ex_CalcStockPrice         - To get Standard Stock Price
      Ex_Proper_VATCode         - To work out which vat code to use (cust / stock)
      Ex_CalcLineTax            - To remove VAT from inclusive VAT items
      Ex_GetLineTotal           - For enterprise discount
//      Ex_CalcLineTax            - To get VAT amount

      {gets the standard stock price}
      StockCode := sStockCode;
      CustCode := TXRec.sAccCode;
      Currency := iTillCurrency;
      Qty := rQuantity;
      iStatus := Ex_CalcStockPrice(@StockPriceRec, SizeOf(StockPriceRec));
      if iStatus = 0 then
        begin
          rNettPrice := Price;

          {Decides which VAT code to use - stock or cust}
          VATCodeRec.StockVATCode := VATCode;
          VATCodeRec.AccountVATCode := TXRec.LCust.VATCode;
          iStatus := Ex_GetCorrectVATCode(@VATCodeRec, SizeOf(VATCodeRec));
          if iStatus = 0 then
            begin
              cVATCode := VATCodeRec.DefaultVATCode;

              {Populate TX Line Record}
              fillchar(TLRec, sizeOf(TLRec),#0);
              with TLRec do begin
                Currency    := iTillCurrency;
                CC          := TXRec.sCostCentre;
                Dep         := TXRec.sDepartment;
                StockCode   := sStockCode;
                Qty         := 1;
                QtyMul      := 1;
                VATCode     := cVATCode;
                Discount    := DiscVal / 100;
                DiscountChr := DiscChar;
                CustCode    := TXRec.sAccCode;
                VATIncFlg   := SVATIncFlg;
                NetValue    := rNettPrice;

                {Remove VAT for inclusive VAT items}
                iStatus := Ex_CalcLineTax(@TLRec, sizeof(TLRec),TXRec.rSettlementDisc / 100);
                if iStatus = 0 then
                  begin
                    rNettPrice := NetValue;

                    {Remove enterprise discounts}
                    iStatus := Ex_GetLineTotal(@TLRec, sizeof(TLRec), TRUE, 0.0, rNettPrice);
                    if iStatus = 0 then
                      begin
                        NetValue := rNettPrice;

                        {Calculate VAT}
                        if iStatus = 0 then begin
                          iStatus := Ex_CalcLineTax(@TLRec, sizeof(TLRec),TXRec.rSettlementDisc / 100);
                          if iStatus = 0 then
                            begin
                              rVATAmount := VAT;
                              rPrice := VAT + NetValue;
                              rLineNettTotal := rNettPrice * rQuantity;
                              rLineTotal := rPrice * rQuantity;
                            end
                          else ShowTKError('Ex_CalcLineTax', 144, iStatus);
                        end;{if}
                      end
                    else ShowTKError('Ex_GetLineTotal', 127, iStatus);
                  end
                else ShowTKError('Ex_CalcLineTax', 144, iStatus);
              end;{with}
            end
          else ShowTKError('Ex_GetCorrectVATCode', 145, iStatus);
        end
      else ShowTKError('Ex_CalcStockPrice', 80, iStatus);
    end;{with}
  end;{with}
end; *)

procedure SetLocation(LocCode : PChar; SetOn : Boolean);
begin
  UseLoc := SetOn;
  if UseLoc then
    DefaultLocation := Copy(StrPas(LocCode) + StringOfChar(' ',3), 1, 3);
end;

function CalculatePriceByLocation(RootDir,
                                  AccCode,
                                  StockCode,
                                  DefLoc : pchar;
                                  CurrencyCode : smallint;
                                  Quantity : double;
                              var Price : double) : smallint;
begin
  SetLocation(DefLoc, True);
  Result := CalculatePrice(RootDir, AccCode, StockCode, CurrencyCode, Quantity, Price);
end;

function ProcessPriceUpdateWithLocation(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
begin
  SetLocation('  ', True);
  Result := ProcessPriceUpdate(COMPriceUpdateRec);
end;


end.
