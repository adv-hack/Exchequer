unit EBusBtrv;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  BtrvU2, StrUtil, EBusVar;

type
  TEBusBtrieve = class
    private
      FPosBlock: FileVar;
      FDataBuffer: array[1..SizeOf(TEBusRec)] of char;
      FDataPointer: pointer;
      FDataSize: longint;
      FKeyPrefix: String2;
      FEBusCode1: shortstring;  // First index code
      FEBusCode2: shortstring;  // Second index code
      FIndexesInUse: byte;      // 1 or 2

      FShowErrorMsg: boolean;   // Whether to display error dialogs
      FFileLocation: string;    // Directory containing E-Business Btrieve file
      procedure SetShowErrorMsg(const Value: boolean);
      procedure SetFileLocation(const Value: string);
      procedure InitialiseFields;
      procedure SetKeyPrefix(const Value: String2);
      procedure SetIndexesInUse(const Value: byte);
    protected
      function  GetDataBufferKeyPrefix : string2;
      function  GetDataBufferEBusCode1 : shortstring;
      function  GetDataBufferEBusCode2 : shortstring;
      procedure SetEBusCode1(const Value: shortstring);
      procedure SetEBusCode2(const Value: shortstring);
      procedure PopulateDataBuffer;
      procedure PopulateRecord(PopulateNonKeys : boolean = true);
      function  FindRecord(var LockRec : boolean; var LockPosn : longint;
                  SearchMode : integer = B_GetEq;
                  JustVariant : boolean = true;
                  UpdateData : boolean = true) : integer; overload;
      function  FindRecord(SearchMode : integer = B_GetEq;
                  JustVariant : boolean = false;
                  UpdateData : boolean =  false) : integer; overload;
    public
      constructor Create(ShowErrors : boolean = false);
      class procedure FullErrorMessage(const ErrorMsg,FileName : ansistring; Status : integer);
      class function CreateFile(const Directory : string; ShowError : boolean): integer;

      function OpenFile : integer;
      function CloseFile : integer;
      function FindRecord(SearchMode : integer = B_GetEq) : integer; overload;
      function FindRecord(var LockRec : boolean; var LockPosn : longint;
                 SearchMode : integer = B_GetEq) : integer; overload;
      function FindRecordWithDefaults : integer;
      function UnlockRecord(LockPosn : longint) : integer;
      function UpdateRecord  : integer;
      function AddRecord : integer;
      function DeleteRecord : integer;

      //PR 14/10/2008
      function  SafeLockRecord(var LockRec : boolean; var LockPosn : longint;
                  SearchMode : integer = B_GetEq) : Integer;

      procedure BlankRecord;

      property FileLocation : string read FFileLocation write SetFileLocation;
      property ShowErrorMsg : boolean read FShowErrorMsg write SetShowErrorMsg;
      property IndexesInUse : byte read FIndexesInUse write SetIndexesInUse;
      property KeyPrefix : String2 read FKeyPrefix write SetKeyPrefix;
      property EBusCode1 : shortstring read FEBusCode1 write SetEBusCode1;
      property EBusCode2 : shortstring read FEBusCode2 write SetEBusCode2;
  end;

  TEBusBtrieveParams = class(TEBusBtrieve)
    public
      ParamsSettings : TEBusParams;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveDragNetParams = class(TEBusBtrieve)
    public
      DragNetSettings : TEBusDragNet;
      constructor Create(ShowErrors : boolean = false);
  end;

  // Introduces CompCode property for convenient sub-classing
  TEBusBtrieveCompCode = class(TEBusBtrieve)
    public
      property CompanyCode : shortstring read FEBusCode1 write SetEBusCode1;
  end;

  TEBusCounter = class(TEBusBtrieveCompCode)
    private
      CounterSettings : TEBusFileCounters;
      fMaxValue : longint;
      procedure SetMaxValue(const Value : longint);
    protected
      function GetCounter : longint; virtual; abstract;
      procedure SetCounter(Value : longint); virtual; abstract;
    public
      property MaxValue : longint read fMaxValue write SetMaxValue;
      function GetNextValue : longint; virtual;
      function GetCurrentValue : longint; virtual;
      procedure SetValue(Value : longint); virtual;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusStockCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;

  TEBusStockGrpCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;

  TEBusTransactionCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;

  TEBusCustomerCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;

  TEBusEmailCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;

  TEBusExportLogCounter = class(TEBusCounter)
    protected
      function GetCounter : longint; override;
      procedure SetCounter(Value : longint); override;
  end;
 
  TEBusBtrieveCompany = class(TEBusBtrieveCompCode)
    public
      CompanySettings : TEBusCompany;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveImport = class(TEBusBtrieveCompCode)
    public
      ImportSettings : TEBusImport;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveExport = class(TEBusBtrieveCompCode)
    public
      ExportSettings : TEBusExport;
      function GetExportCode : shortstring;
      constructor Create(ShowErrors : boolean = false);
      property ExportCode : shortstring read FEBusCode2 write SetEBusCode2;
  end;

  TEBusBtrieveDragNetCompany = class(TEBusBtrieveCompCode)
    public
      DragNetCompanySettings : TEBusDragNetCompany;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveFTP = class(TEBusBtrieveCompCode)
    public
      FTPSettings : TEBusFTP;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveEmail = class(TEBusBtrieveCompCode)
    public
      EmailSettings : TEBusEmail;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveFile = class(TEBusBtrieveCompCode)
    public
      FileSettings : TEBusFile;
      constructor Create(ShowErrors : boolean = false);
      property ExportCode : shortstring read FEBusCode2 write SetEBusCode2;
  end;

  TEBusBtrieveDragNetCountry = class(TEBusBtrieveCompCode)
    public
      DragNetCountrySettings : TEBusDragNetCountry;
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveCatalogue = class(TEBusBtrieveCompCode)
    public
      CatalogueSettings : TEBusCatalogue;
      constructor Create(ShowErrors : boolean = false);
      property CatalogueCode : shortstring read FEBusCode2 write SetEBusCode2;
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  // VCL
  Dialogs, SysUtils, Forms, EBusUtil, TKUtil, FileUtil;

const
  FNum = EBsF;
  NON_VARIANT_SIZE = SizeOf(EBusRec.RecPFix) + SizeOf(EBusRec.SubType) +
    SizeOf(EBusRec.EBusCode1) + SizeOf(EBusRec.EBusCode2);

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetFileLocation(const Value: string);
begin
  FFileLocation := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetShowErrorMsg(const Value: boolean);
begin
  FShowErrorMsg := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetEBusCode1(const Value: shortstring);
begin
  // Right pad to string size with space characters
  FEBusCode1 := Trim(Value) +
    StringOfChar(' ', SizeOf(EBusRec.EBusCode1) -1 - length(Trim(Value)));
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetEBusCode2(const Value: shortstring);
begin
  // Right pad to string size with space characters
  FEBusCode2 := Trim(Value) +
    StringOfChar(' ', SizeOf(EBusRec.EBusCode2) -1 - length(Trim(Value)));
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetIndexesInUse(const Value: byte);
begin
  FIndexesInUse := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.SetKeyPrefix(const Value: String2);
begin
  FKeyPrefix := Value;
end;

//-----------------------------------------------------------------------

class procedure TEBusBtrieve.FullErrorMessage(const ErrorMsg,FileName : ansistring; Status : integer);
// Pre    : ErrorMsg = Extra error information
//          FileName = The file the error occurred in
//          Status   = Btrieve status
// Action : Displays a dialog with verbose Btrieve status information
begin
  MessageDlg(ErrorMsg + CRLF + 'Error Code: ' + IntToStr(Status) + CRLF +
    Set_StatMes(Status)+#13+
    'In File '+FileName, mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

class function TEBusBtrieve.CreateFile(const Directory : string; ShowError : boolean): integer;
begin
  Result := Make_File(F[FNum], Directory + EBUS_FILENAME, FileSpecOfs[FNum]^,
    FileSpecLen[FNum]);
  if (Result <> 0) and ShowError then
    FullErrorMessage('Could not create eBusiness Module data file in directory:' + CRLF +
      Directory,EBUS_FILENAME, Result);
end;

//-----------------------------------------------------------------------

constructor TEBusBtrieve.Create(ShowErrors : boolean = false);
begin
  inherited Create;
  ShowErrorMsg := ShowErrors;
  EBusCode1 := '';
  EBusCode2 := '';
  FIndexesInUse := 1;
  //HV 08/02/2017 2017-R1 ABSEXCH-13906: Printing Transaction to XML file in Sub Company gives Error 12 - EBUS.dat
  FileLocation := GetEnterpriseDirectory;
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.OpenFile: integer;
begin
  Result := Open_File(FPosBlock, FileLocation + EBUS_FILENAME, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not open eBusiness Module data file.',FileLocation + EBUS_FILENAME, Result);
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.InitialiseFields;
begin
  EBusCode1 := '';
  EBusCode2 := '';
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.CloseFile: integer;
begin
  Result := Close_File(FPosBlock);
  if Result = 0 then
    InitialiseFields;
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.FindRecord(SearchMode : integer = B_GetEq) : integer;
// Notes : Public
var
  RecPos : longint;
  LockRec : boolean;
begin
  LockRec := false;
  Result := FindRecord(LockRec, RecPos, SearchMode, true, true);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.FindRecord(var LockRec : boolean; var LockPosn : longint;
           SearchMode : integer = B_GetEq) : integer;
// Notes : Public
begin
  Result := FindRecord(LockRec, LockPosn, SearchMode, true, true);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.FindRecord(SearchMode : integer = B_GetEq;
  JustVariant : boolean = false; UpdateData : boolean =  false) : integer;
// Notes : Protected
var
  LockRec : boolean;
  RecPos : longint;
begin
  LockRec := false;
  Result := FindRecord(LockRec, RecPos, SearchMode, JustVariant, UpdateData);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.FindRecord(var LockRec : boolean; var LockPosn : longint;
           SearchMode : integer = B_GetEq; JustVariant : boolean = true;
           UpdateData : boolean = true) : integer;
// Pre   : LockRec     = true => attempt to lock the record
//         LockPosn    = irrelevant
//         SearchMode  = Btrieve search mode constant
//         JustVariant = true => treat finding a record outside of the variant range as
//                       an error 9 (EOF)
//         UpdateData  = Parameter passed to PopulateRecord
// Post  : LockRec     = true => record locked and position in LockPosn is valid
//                       false => record not locked or didn't request lock
//         LockPosn    = physical record address
// Notes : Protected
var
  KeyS : string[255];
  BtrieveMode  : integer;

  function SearchModeOK : boolean;
  begin
    Result := SearchMode in [B_GetEq, B_GetNext, B_GetPrev, B_GetGretr, B_GetGEq,
      B_GetLess, B_GetLessEq, B_GetFirst, B_GetLast, 22 {GetPos}, B_GetDirect];
  end;

begin // TEBusBtrieve.FindRecord
  if not SearchModeOK then
  begin
    Result := -1;
    exit;
  end;

  // Ensure that GetFirst and GetLast work on only the specified record types
  if JustVariant then
    case SearchMode of
      B_GetFirst:
      begin
        SearchMode := B_GetGEq;
        if FIndexesInUse = 1 then
          EBusCode1 := ''
        else
          EBusCode2 := '';
      end;
      B_GetLast:
      begin
        SearchMode := B_GetLessEq;
        if FIndexesInUse = 1 then
          EBusCode1 := StringOfChar(#255, SizeOf(EBusRec.EBusCode1)-1)
        else
          EBusCode2 := StringOfChar(#255, SizeOf(EBusRec.EBusCode2)-1);
      end
    end;

  KeyS := KeyPrefix + EBusCode1 + EBusCode2;
  if LockRec then
    BtrieveMode := SearchMode + B_MultNWLock
  else
    BtrieveMode := SearchMode;

  Result := Find_Rec(BtrieveMode, FPosBlock, FNum, FDataBuffer, 0, KeyS);

  if Result = 0 then
  begin
    if JustVariant then
    begin
      // If we've moved out of the specified record type return EOF
      if GetDataBufferKeyPrefix <> KeyPrefix then
        Result := 9;

      // and if we're working at the second key level ...
      if (FIndexesInUse = 2) and (GetDataBufferEBusCode1 <> EBusCode1) then
        Result := 9;
    end;

    if Result = 0 then
    begin
      PopulateRecord(UpdateData);
      LockRec := (GetPos(FPosBlock, FNum, LockPosn) = 0) and LockRec;
    end;
  end;

  if Result <> 0 then
  begin
    BlankRecord;
    // Don't show error message for errors ...
    // 4 = record not found
    // 9 = EOF
    // 84, 85 locking problem
    if (not Result in [4, 9, 84, 85]) and ShowErrorMsg then
      FullErrorMessage('Could not find record with: ' + CRLF +
       'EBusCode1 = "' + EBusCode1 + '"'+ CRLF +
       'EBusCode2 = "' + EBusCode2 + '"' + CRLF,FileLocation + EBUS_FILENAME,Result);
  end;
end; // TEBusBtrieve.ReadRecord

//-----------------------------------------------------------------------

function TEBusBtrieve.FindRecordWithDefaults: integer;
// Notes : Looks for specific record e.g. File settings for a company
//         if they cannot be found looks for the global defaults.
//         EBusCode1 is left at its original value.
var
  CurEBusCode1 : shortstring;
  LockPos : longint;
  LockRec : boolean;
begin
  LockRec := false;
  // Look for specified record : EBusCode1 = 'xxxxxx'
  Result := FindRecord(LockRec, LockPos, B_GetEq, true, true);
  if Result <> 0 then
  begin
    CurEBusCode1 := EBusCode1;
    EBusCode1 := '';
    // Look for default record : EBusCode1 = '      '
    Result := FindRecord(LockRec, LockPos, B_GetEq, true, true);
    EBusCode1 := CurEBusCode1;
  end;
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.UnlockRecord(LockPosn : longint) : integer;
begin
  move(LockPosn,  FDataBuffer, SizeOf(LockPosn));
  Result := GetDirect(FPosBlock, FNum, FDataBuffer, 0, 0);
  if Result = 0 then
    Result := UnLockMultiSing(FPosBlock, FNum, LockPosn);
end; // TEBusBtrieve.UnlockRecord

//-----------------------------------------------------------------------

function TEBusBtrieve.UpdateRecord;
// Notes : If using multiple record locks in Btrieve then updating a record will NOT
//         automatically unlock it. 
begin
  PopulateDataBuffer;
  Result := Put_Rec(FPosBlock, FNum, FDataBuffer, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not update record with: ' + CRLF +
      'EBusCode1 = "' + EBusCode1 + '"'+ CRLF +
      'EBusCode2 = "' + EBusCode2 + '"' + CRLF, FileLocation + EBUS_FILENAME,Result);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.AddRecord : integer;
begin
  PopulateDataBuffer;
  Result := Add_Rec(FPosBlock, FNum, FDataBuffer, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not add record with: ' + CRLF +
      'EBusCode1 = "' + EBusCode1 + '"'+ CRLF +
      'EBusCode2 = "' + EBusCode2 + '"' + CRLF, FileLocation + EBUS_FILENAME,Result);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.DeleteRecord : integer;
begin
  Result := Delete_Rec(FPosBlock, FNum, 0);
  if Result = 0 then
    BlankRecord
  else
    if ShowErrorMsg then
      FullErrorMessage('Could not delete record with: ' + CRLF +
        'EBusCode1 = "' + EBusCode1 + '"'+ CRLF +
        'EBusCode2 = "' + EBusCode2 + '"' + CRLF,FileLocation + EBUS_FILENAME, Result);
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.PopulateRecord(PopulateNonKeys : boolean = true);
// Pre   : PopulateNonKeys = false => only update the indexes, leave the main data record
// Notes : Moves data from Btrieve data buffer to specific record structure
var
  Code1,
  Code2 : shortstring;
begin
  Move(FDataBuffer[3], Code1, SizeOf(EBusRec.EBusCode1));
  Move(FDataBuffer[3 + SizeOf(EBusRec.EBusCode1)], Code2, SizeOf(EBusCode2));
  EBusCode1 := Code1;
  EBusCode2 := Code2;
  if PopulateNonKeys then
    Move(FDataBuffer[NON_VARIANT_SIZE+1], FDataPointer^, FDataSize);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.GetDataBufferKeyPrefix : string2;
// Post : Returns the record prefix from the actual Data buffer
begin
  Result := copy(FDataBuffer, 1, 2);
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.GetDataBufferEBusCode1 : shortstring;
// Post : Returns EBusCode1 from the actual Data buffer
begin
  Move(FDataBuffer[3], Result, SizeOf(EBusRec.EBusCode1));
end;

//-----------------------------------------------------------------------

function TEBusBtrieve.GetDataBufferEBusCode2 : shortstring;
// Post : Returns EBusCode2 from the actual Data buffer
begin
  Move(FDataBuffer[3 + SizeOf(EBusRec.EBusCode1)], Result, SizeOf(EBusCode2));
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.PopulateDataBuffer;
// Notes : Moves data from specific record structure to Btrieve data buffer
begin
  FillChar(FDataBuffer, SizeOf(FDataBuffer), 0);
  Move(KeyPrefix[1], FDataBuffer[1], 1);
  Move(KeyPrefix[2], FDataBuffer[2], 1);
  Move(EBusCode1, FDataBuffer[3], SizeOf(EBusRec.EBusCode1));
  Move(EBusCode2, FDataBuffer[3 + SizeOf(EBusRec.EBusCode1)], SizeOf(EBusRec.EBusCode2));
  Move(FDataPointer^, FDataBuffer[NON_VARIANT_SIZE+1], FDataSize);
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieve.BlankRecord;
begin
  FillChar(FDataPointer^, FDataSize, 0);
end;

//=======================================================================

constructor TEBusBtrieveParams.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_GENERAL;
  FDataPointer := @ParamsSettings;
  FDataSize := SizeOf(ParamsSettings);
end;

//=======================================================================

constructor TEBusBtrieveDragNetParams.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_DRAGNET + EBUS_SUBTYPE_GENERAL;
  FDataPointer := @DragNetSettings;
  FDataSize := SizeOf(DragNetSettings);
end;

//=======================================================================

constructor TEBusBtrieveCompany.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_COMPANY;
  FDataPointer := @CompanySettings;
  FDataSize := SizeOf(CompanySettings);
end;

//=======================================================================

constructor TEBusBtrieveImport.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_IMPORT;
  FDataPointer := @ImportSettings;
  FDataSize := SizeOf(ImportSettings);
end;

//=======================================================================

constructor TEBusBtrieveExport.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_EXPORT;
  FDataPointer := @ExportSettings;
  FDataSize := SizeOf(ExportSettings);
  FIndexesInUse := 2;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveExport.GetExportCode : shortstring;
var
  OriginalCompanyCode,
  OriginalExportCode : string;
  Status,
  ExportNumber : integer;
  CurPosn : longint;
  CurPosFound : boolean;
begin
  OriginalCompanyCode := CompanyCode;
  OriginalExportCode := ExportCode;

  CurPosFound := GetPos(FPosBlock, FNum, CurPosn) = 0;
  CompanyCode := copy(CompanyCode, 1, SizeOf(EBusRec.EBusCode1) -2) + #255;
  ExportCode := '';
  Status := FindRecord(B_GetLess, false, false);
  if (Status = 0) and (GetDataBufferKeyPrefix = KeyPrefix) and
    (GetDataBufferEBusCode1 = OriginalCompanyCode) then
  begin
    ExportNumber := StrToInt(Trim(ExportCode));
    Result := Format('%.8d', [ExportNumber + 1])
  end
  else
    Result := Format('%.8d', [1]);

  if CurPosFound then
  begin
    move(CurPosn, FDataBuffer, SizeOf(CurPosn));
    GetDirect(FPosBlock, FNum, FDataBuffer, 0, 0);
  end;

  CompanyCode := OriginalCompanyCode;
  ExportCode := OriginalExportCode;
end;

//=======================================================================

constructor TEBusCounter.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_COUNTERS;
  FDataPointer := @CounterSettings;
  FDataSize := SizeOf(CounterSettings);
  MaxValue := MAXLONGINT; // Default value
end;

//-----------------------------------------------------------------------

procedure TEBusCounter.SetMaxValue(const Value: longint);
// Notes : Maximum value at which to cycle the counter
begin
  fMaxValue := Value;
end;

//-----------------------------------------------------------------------

function TEBusCounter.GetNextValue : longint;
var
  LockPos : longint;
  LockRec : boolean;
  ResetCounter : boolean;
begin
  LockRec := false;
  ResetCounter := true;
  if FindRecord(LockRec, LockPos, B_GetEq, true, true) = 0 then
  begin
    try
      Result := GetCounter + 1;
      if Result <= MaxValue then
      begin
        SetValue(Result);
        ResetCounter := false;
      end;
    except
      on EIntOverFlow do ; // ResetCounter already true
    end;
  end;

  if ResetCounter then
  begin
    Result := 1;
    SetValue(1);
  end; 
end; // TEBusCounter.GetNextValue

//-----------------------------------------------------------------------

function TEBusCounter.GetCurrentValue : longint;
var
  LockPos : longint;
  LockRec : boolean;
begin
  LockRec := false;
  if FindRecord(LockRec, LockPos, B_GetEq, true, true) = 0 then
    Result := GetCounter
  else
    Result := -1;
end;

//-----------------------------------------------------------------------

procedure TEBusCounter.SetValue(Value : longint);
var
  LockPos : longint;
  LockRec : boolean;
begin
  LockRec := true;
  if FindRecord(LockRec, LockPos, B_GetEq, true, true) = 0 then
  begin
    SetCounter(Value);
    UpdateRecord;
    UnlockRecord(LockPos);
  end
  else
  begin
    SetCounter(Value);
    AddRecord;
  end;
end;

//=======================================================================

function TEBusStockCounter.GetCounter : longint;
begin
  Result := CounterSettings.StockCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusStockCounter.SetCounter(Value : longint);
begin
  CounterSettings.StockCounter := Value;
end;

//=======================================================================

function TEBusStockGrpCounter.GetCounter : longint;
begin
  Result := CounterSettings.StockGrpCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusStockGrpCounter.SetCounter(Value : longint);
begin
  CounterSettings.StockGrpCounter := Value;
end;

//=======================================================================

function TEBusTransactionCounter.GetCounter : longint;
begin
  Result := CounterSettings.TransactionCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusTransactionCounter.SetCounter(Value : longint);
begin
  CounterSettings.TransactionCounter := Value;
end;

//=======================================================================

function TEBusCustomerCounter.GetCounter : longint;
begin
  Result := CounterSettings.CustomerCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusCustomerCounter.SetCounter(Value : longint);
begin
  CounterSettings.CustomerCounter := Value;
end;

//=======================================================================

function TEBusEmailCounter.GetCounter : longint;
begin
  Result := CounterSettings.EmailCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusEmailCounter.SetCounter(Value : longint);
begin
  CounterSettings.EmailCounter := Value;
end;

//=======================================================================

function TEBusExportLogCounter.GetCounter : longint;
begin
  Result := CounterSettings.ExportLogCounter;
end;

//-----------------------------------------------------------------------

procedure TEBusExportLogCounter.SetCounter(Value : longint);
begin
  CounterSettings.ExportLogCounter := Value;
end;

//=======================================================================

constructor TEBusBtrieveDragNetCompany.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_DRAGNET + EBUS_SUBTYPE_COMPANY;
  FDataPointer := @DragNetCompanySettings;
  FDataSize := SizeOf(DragNetCompanySettings);
end;

//=======================================================================

constructor TEBusBtrieveFTP.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_FTP;
  FDataPointer := @FTPSettings;
  FDataSize := SizeOf(FTPSettings);
end;

//=======================================================================

constructor TEBusBtrieveEmail.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_EMAIL;
  FDataPointer := @EmailSettings;
  FDataSize := SizeOf(EmailSettings);
end;

//=======================================================================

constructor TEBusBtrieveFile.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_FILE;
  FDataPointer := @FileSettings;
  FDataSize := SizeOf(FileSettings);
  FIndexesInUse := 2;
end;

//=======================================================================

constructor TEBusBtrieveDragNetCountry.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_DRAGNET + EBUS_SUBTYPE_COUNTRY;
  FDataPointer := @DragNetCountrySettings;
  FDataSize := SizeOf(DragNetCountrySettings);
end;

//=======================================================================

constructor TEBusBtrieveCatalogue.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_CATALOGUE;
  FDataPointer := @CatalogueSettings;
  FDataSize := SizeOf(CatalogueSettings);
  FIndexesInUse := 2;
end;


//PR 14/10/2008 Added to be compatible with SQL Emulator locking
function TEBusBtrieve.SafeLockRecord(var LockRec: boolean;
  var LockPosn: Integer; SearchMode: integer): Integer;
begin
  Result := FindRecord(SearchMode, True, True);

  if Result = 0 then
    Result :=  FindRecord(22, False, True);

  if Result = 0 then
    Result := FindRecord(LockRec, LockPosn, B_GetDirect, True, True);
end;

end.


