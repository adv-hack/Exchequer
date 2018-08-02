unit EBusLkup;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  BtrvU2, StrUtil, EBusLook;

type
  TEBusBtrieveLookup = class
    private
      FPosBlock: FileVar;
      FDataBuffer: array[1..SizeOf(TEBusLookups)] of char;
      FKeyPrefix: String2;
      FIndexNumber: byte;         // 0, 1, or 2
      FShowErrorMsg: boolean;     // Whether to display error dialogs
      FFileLocation: shortstring; // Directory containing E-Business Lookup Btrieve file

      FDescription: shortstring;   // Description of line
      FTheirItemCode: shortstring; // Their Code
      FOurItemCode: shortstring;   // Our Code
      FOurTraderCode: shortstring; // Enterprise customer or supplier code
      FTag: smallint;              // Line tag
      function  GetKeyValueErrorMsg : string;
      procedure SetShowErrorMsg(const Value: boolean);
      procedure SetKeyPrefix(const Value: String2);
      procedure SetString(Index : integer; const Value: shortstring);
      procedure SetTag(const Value: smallint);
      procedure SetIndexNumber(const Value : byte);
    protected
      function  GetDataBufferKeyPrefix : string2;
      function  GetDataBufferTraderCode : shortstring;
      procedure PopulateDataBuffer;
      procedure BlankProperties;
      procedure PopulateProperties;
      function  FindRecord(SearchMode : integer = B_GetEq;
                  JustVariant : boolean = false;
                  UpdateProperties : boolean =  false) : integer; overload;
      function  FindRecord(var LockRec : boolean; var LockPosn : longint;
                  SearchMode : integer = B_GetEq; JustVariant : boolean = true;
                  UpdateProperties : boolean = true) : integer; overload;
    public
      constructor Create(ShowErrors : boolean = false);
      class procedure FullErrorMessage(const ErrorMsg : ansistring; Status : integer);
      class function CreateFile(const Directory : string; ShowError : boolean): integer;

      function OpenFile : integer;
      function CloseFile : integer;
      function FindRecord(SearchMode : integer = B_GetEq;
                 LockRec : boolean = false) : integer; overload;
      function FindRecord(var LockRec : boolean; var LockPosn : longint;
                 SearchMode : integer = B_GetEq) : integer; overload;

      function GetDirectRecord(LockPosn : longint;
                               LockFunc : Integer) : integer;

      Function FindDirectRecord(LockPosn : longint;
                                LockFunc : Integer) : integer;

      function UnlockRecord(LockPosn : longint) : integer;
      function UpdateRecord  : integer;
      function AddRecord : integer;
      function DeleteRecord(UpdateProperties : boolean = true) : integer;

      procedure UseOurItemCode;
      procedure UseTheirItemCode;

      property ShowErrorMsg : boolean read FShowErrorMsg write SetShowErrorMsg;
      property KeyPrefix : String2 read FKeyPrefix write SetKeyPrefix;
      property FileLocation : shortstring index 1 read FFileLocation write SetString;
      property OurTraderCode : shortstring index 2 read FOurTraderCode write SetString;
      property OurItemCode : shortstring index 3 read FOurItemCode write SetString;
      property TheirItemCode : shortstring index 4 read FTheirItemCode write SetString;
      property Description : shortstring index 5 read FDescription write SetString;
      property Tag : smallint read FTag write SetTag;
      property IndexNumber : byte read FIndexNumber write SetIndexNumber;
  end;

  // Within the file, if a trader has any lookup references, there must be
  // be a single line added via this class.  If all the lookups are deleted then
  // then this row must be deleted also.  Concept is to allow a convenient reference
  // to each trader that has lookups defined.
  TEBusBtrieveLookupTrader = class(TEBusBtrieveLookup)
    public
      constructor Create(ShowErrors : boolean = false);
  end;

  TEBusBtrieveLookupTraderRef = class(TEBusBtrieveLookup)
    private
      fTraderRow : TEBusBtrieveLookupTrader;
    public
      function AddRecord : integer;
      function DeleteRecord : integer;
      function OpenFile : integer;
      function CloseFile : integer;
      constructor Create(ShowErrors : boolean = false);
      destructor  Destroy; override;
  end;

  TEBusBtrieveLookupVAT = class(TEBusBtrieveLookupTraderRef)
    protected
      procedure SetOurVATCode(Value : char);
      function  GetOurVATCode : char;

    public
      constructor Create(ShowErrors : boolean = false);
      property OurVATCode : char read GetOurVATCode write SetOurVATCode;
      property TheirVATCode : shortstring index 4 read FTheirItemCode write SetString;
  end;

  TEBusBtrieveLookupCurrency = class(TEBusBtrieveLookupTraderRef)
    protected
      procedure SetOurCurrencyCode(Value : integer);
      function  GetOurCurrencyCode : integer;
    public
      constructor Create(ShowErrors : boolean = false);
      property OurCurrencyCode : integer read GetOurCurrencyCode write SetOurCurrencyCode;
      property TheirCurrencyCode : shortstring index 4 read FTheirItemCode write SetString;
  end;

implementation

uses
  // VCL
  Dialogs, SysUtils, Forms, EBusUtil;

const
  FNum = EBsL;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.SetShowErrorMsg(const Value: boolean);
begin
  FShowErrorMsg := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.SetKeyPrefix(const Value: String2);
begin
  FKeyPrefix := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.SetString(Index : integer; const Value: shortstring);
begin
  case Index of
    1: FFileLocation := Value;
    2: FOurTraderCode := Trim(Value) +
         StringOfChar(' ', SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode) -1
           - length(Trim(Value)));
    3: FOurItemCode := Trim(Value) +
         StringOfChar(' ', SizeOf(EBusLookupRec.LookupGeneric.OurItemCode) -1
           - length(Trim(Value)));
    4: FTheirItemCode := Trim(Value) +
         StringOfChar(' ', SizeOf(EBusLookupRec.LookupGeneric.TheirItemCode) -1
           - length(Trim(Value)));
    5: FDescription := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.SetTag(const Value: smallint);
begin
  FTag := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.SetIndexNumber(const Value : byte);
begin
  FIndexNumber := Value;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.UseOurItemCode;
begin
  IndexNumber := 0;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.UseTheirItemCode;
begin
  IndexNumber := 1;
end;

//-----------------------------------------------------------------------

class procedure TEBusBtrieveLookup.FullErrorMessage(const ErrorMsg : ansistring; Status : integer);
// Pre    : ErrorMsg = Extra error information
//          Status   = Btrieve status
// Action : Displays a dialog with verbose Btrieve status information
begin
  MessageDlg(ErrorMsg + CRLF + 'Error Code: ' + IntToStr(Status) + CRLF +
    Set_StatMes(Status), mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

class function TEBusBtrieveLookup.CreateFile(const Directory : string; ShowError : boolean): integer;
begin
  Result := Make_File(F[FNum], Directory + LOOKUPS_FILENAME, FileSpecOfs[FNum]^,
    FileSpecLen[FNum]);
  if (Result <> 0) and ShowError then
    FullErrorMessage('Could not create E-Business Module lookups data file in directory:'
      + CRLF + Directory, Result);
end;

//-----------------------------------------------------------------------

constructor TEBusBtrieveLookup.Create(ShowErrors : boolean = false);
begin
  inherited Create;
  ShowErrorMsg := ShowErrors;
  OurTraderCode := '';
  OurItemCode := '';
  TheirItemCode := '';
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.OpenFile: integer;
begin
  Result := Open_File(FPosBlock, FileLocation + LOOKUPS_FILENAME, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not open E-Business Module data file.', Result);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.GetKeyValueErrorMsg : string;
// Post : Returns the values in the appropriate keys for an error message
begin
  Result := 'Trader Code = "' + OurTraderCode + '"'+ CRLF;
  case IndexNumber of
    0: Result := Result + 'Our Code = "' + OurItemCode + '"' + CRLF;
    1: Result := Result + 'Their Code = "' + TheirItemCode + '"' + CRLF;
  end;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.CloseFile: integer;
begin
  Result := Close_File(FPosBlock);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.FindRecord(SearchMode : integer = B_GetEq;
           LockRec : boolean = false) : integer;
// Notes : Public
var
  RecPos : longint;
begin
  LockRec := false;
  Result := FindRecord(LockRec, RecPos, SearchMode, true, true);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.FindRecord(var LockRec : boolean; var LockPosn : longint;
           SearchMode : integer = B_GetEq) : integer;
// Notes : Public
begin
  Result := FindRecord(LockRec, LockPosn, SearchMode, true, true);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.FindRecord(SearchMode : integer = B_GetEq;
  JustVariant : boolean = false; UpdateProperties : boolean =  false) : integer;
// Notes : Protected
var
  LockRec : boolean;
  RecPos : longint;
begin
  LockRec := false;
  Result := FindRecord(LockRec, RecPos, SearchMode, JustVariant, UpdateProperties);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.FindRecord(var LockRec : boolean; var LockPosn : longint;
           SearchMode : integer = B_GetEq; JustVariant : boolean = true;
           UpdateProperties : boolean = true) : integer;
// Pre   : LockRec     = true => attempt to lock the record
//         LockPosn    = irrelevant
//         SearchMode  = Btrieve search mode constant
//         JustVariant = true => treat finding a record outside of the variant range as
//                       an error 9 (EOF)
//         UpdatePropeties = Parameter passed to PopulateRecord
// Post  : LockRec     = true => record locked and position in LockPosn is valid
//                       false => record not locked or didn't request lock
//         LockPosn    = physical record address
// Notes : Protected
var
  KeyS : string[255];
  BtrieveMode  : integer;
  ErrorMsg : string;

  function SearchModeOK : boolean;
  begin
    Result := SearchMode in [B_GetEq, B_GetNext, B_GetPrev, B_GetGretr, B_GetGEq,
      B_GetLess, B_GetLessEq, B_GetFirst, B_GetLast,B_GetDirect];
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
        if IndexNumber <> 2 then
          OurTraderCode := '';
        SearchMode := B_GetGEq;
        case IndexNumber of
          0: OurItemCode := '';
          1: TheirItemCode := '';
        end;
      end;
      B_GetLast:
      begin
        if IndexNumber <> 2 then
          OurTraderCode := StringOfChar(#255, SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode)-1);
        SearchMode := B_GetLessEq;
        case IndexNumber of
          0: OurItemCode := StringOfChar(#255, SizeOf(EBusLookupRec.LookupGeneric.OurItemCode)-1);
          1: TheirItemCode := StringOfChar(#255, SizeOf(EBusLookupRec.LookupGeneric.TheirItemCode)-1);
        end;
      end;
    end; // case

  case IndexNumber of
    0: KeyS := KeyPrefix + OurTraderCode + OurItemCode;
    1: KeyS := KeyPrefix + OurTraderCode + TheirItemCode;
    2: KeyS := OurTraderCode;
  end;

  if LockRec then
    BtrieveMode := SearchMode + B_MultNWLock
  else
    BtrieveMode := SearchMode;



  Result := Find_Rec(BtrieveMode, FPosBlock, FNum, FDataBuffer, IndexNumber, KeyS);

  if Result = 0 then
  begin
    if JustVariant and (IndexNumber <> 2) then
    begin
      // If we've moved out of the specified record type return EOF
      if GetDataBufferKeyPrefix <> KeyPrefix then
        Result := 9;
    end;

    if Result = 0 then
    begin
      if UpdateProperties then
        PopulateProperties;
      LockRec := (GetPos(FPosBlock, FNum, LockPosn) = 0) and LockRec;
    end;
  end;

  if Result <> 0 then
  begin
    if UpdateProperties then
      BlankProperties;
    // Don't show error message for errors ...
    // 4 = record not found
    // 9 = EOF
    // 84, 85 locking problem
    if (not Result in [4, 9, 84, 85]) and ShowErrorMsg then
    begin
      ErrorMsg := 'Could not find record with: ' + CRLF;
      ErrorMsg := ErrorMsg + GetKeyValueErrorMsg;
      FullErrorMessage(ErrorMsg + CRLF, Result);
    end;
  end;
end; // TEBusBtrieveLookup.FindRecord


//-----------------------------------------------------------------------

function TEBusBtrieveLookup.GetDirectRecord(LockPosn : longint;
                                            LockFunc : Integer) : integer;
begin
  move(LockPosn,  FDataBuffer, SizeOf(LockPosn));
  Result := GetDirect(FPosBlock, FNum, FDataBuffer, 0, LockFunc);
end; // TEBusBtrieve.UnlockRecord


Function TEBusBtrieveLookup.FindDirectRecord(LockPosn : longint;
                                             LockFunc : Integer) : integer;

Begin
  Result:=GetDirectRecord(LockPosn,LockFunc);

  If (Result=0) then
    PopulateProperties;

end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.UnlockRecord(LockPosn : longint) : integer;
begin
  Result:=GetDirectRecord(LockPosn,0);
  if Result = 0 then
    Result := UnLockMultiSing(FPosBlock, FNum, LockPosn);
end; // TEBusBtrieve.UnlockRecord

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.UpdateRecord;
begin
  PopulateDataBuffer;
  Result := Put_Rec(FPosBlock, FNum, FDataBuffer, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not update record with: ' + CRLF +
      GetKeyValueErrorMsg, Result);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.AddRecord : integer;
begin
  PopulateDataBuffer;
  Result := Add_Rec(FPosBlock, FNum, FDataBuffer, 0);
  if (Result <> 0) and ShowErrorMsg then
    FullErrorMessage('Could not add record with: ' + CRLF +
      GetKeyValueErrorMsg, Result);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.DeleteRecord(UpdateProperties : boolean = true) : integer;
begin
  Result := Delete_Rec(FPosBlock, FNum, 0);
  if Result = 0 then
  begin
    if UpdateProperties then
      BlankProperties
  end
  else
    if ShowErrorMsg then
      FullErrorMessage('Could not delete record with: ' + CRLF +
        GetKeyValueErrorMsg, Result);
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.BlankProperties;
begin
  OurTraderCode := '';
  OurItemCode := '';
  TheirItemCode := '';
  Description := '';
  Tag := 0;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.PopulateProperties;
// Notes : Moves data from Btrieve data buffer to the classes properties
begin
  Move(FDataBuffer[3], FOurTraderCode, SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode));
  Move(FDataBuffer[14], FOurItemCode, SizeOf(EBusLookupRec.LookupGeneric.OurItemCode));
  Move(FDataBuffer[65], FTheirItemCode, SizeOf(EBusLookupRec.LookupGeneric.TheirItemCode));
  Move(FDataBuffer[116], FDescription, SizeOf(EBusLookupRec.LookupGeneric.Description));
  Move(FDataBuffer[217], FTag, SizeOf(EBusLookupRec.LookupGeneric.Tag));
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.GetDataBufferKeyPrefix : string2;
// Post : Returns the record prefix from the actual Data buffer
begin
  Result := copy(FDataBuffer, 1, 2);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookup.GetDataBufferTraderCode : shortstring;
begin
  Move(FDataBuffer[3], Result, SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode));
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookup.PopulateDataBuffer;
// Notes : Moves data from specific properties to Btrieve data buffer
begin
  FillChar(FDataBuffer, SizeOf(FDataBuffer), 0);
  Move(KeyPrefix[1], FDataBuffer[1], 1);
  Move(KeyPrefix[2], FDataBuffer[2], 1);
  Move(FOurTraderCode, FDataBuffer[3], SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode));
  Move(FOurItemCode, FDataBuffer[14], SizeOf(EBusLookupRec.LookupGeneric.OurItemCode));
  Move(FTheirItemCode, FDataBuffer[65], SizeOf(EBusLookupRec.LookupGeneric.TheirItemCode));
  Move(FDescription, FDataBuffer[116], SizeOf(EBusLookupRec.LookupGeneric.Description));
  Move(FTag, FDataBuffer[217], SizeOf(EBusLookupRec.LookupGeneric.Tag));
end;

//=======================================================================

constructor TEBusBtrieveLookupTrader.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := LOOKUP_TYPE_TRADER + LOOKUP_SUBTYPE_NONE;
end;

//=======================================================================

constructor TEBusBtrieveLookupTraderRef.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  fTraderRow := TEBusBtrieveLookupTrader.Create(ShowErrors);
end;

//-----------------------------------------------------------------------

destructor TEBusBtrieveLookupTraderRef.Destroy;
begin
  fTraderRow.Free;
  inherited destroy;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupTraderRef.AddRecord: integer;
// Notes : Adds the specified lookup record
//         Also adds a single row which indicates that a specific trader has
//         some lookups defined, if it doesn't already exist
begin
  Result := inherited AddRecord;
  if Result = 0 then
  begin
    fTraderRow.OurTraderCode := OurTraderCode;
    fTraderRow.IndexNumber := 0;
    if fTraderRow.FindRecord(B_GetEq, true, false) <> 0 then
      fTraderRow.AddRecord;
  end;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupTraderRef.DeleteRecord: integer;
// Notes : Deletes the specified lookup record
//         Also deletes the single row which indicates that a specific trader has
//         some lookups defined.
var
  Status : integer;
  FoundALookup : boolean;
begin
  Result := inherited DeleteRecord(false);
  if Result = 0 then
  begin
    fTraderRow.IndexNumber := 2;
    fTraderRow.OurTraderCode := OurTraderCode;
    FoundALookup := false;

    Status := fTraderRow.FindRecord(B_GetGEq, false, false);
    while (Status = 0) and not FoundALookup and
      (fTraderRow.GetDataBufferTraderCode = OurTraderCode) do
    begin
      FoundALookup := (fTraderRow.GetDataBufferKeyPrefix <>
        LOOKUP_TYPE_TRADER + LOOKUP_SUBTYPE_NONE);
      Status := fTraderRow.FindRecord(B_GetNext, false, false);
    end;

    if not FoundALookup then
    begin
      fTraderRow.IndexNumber := 0;
      if fTraderRow.FindRecord(B_GetEq, false, false) = 0 then
        fTraderRow.DeleteRecord;
    end;
  end;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupTraderRef.OpenFile: integer;
begin
  Result := inherited OpenFile;
  if Result = 0 then
  begin
    fTraderRow.FileLocation := FileLocation;
    Result := fTraderRow.OpenFile;
  end;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupTraderRef.CloseFile: integer;
var
  Status : integer;
begin
  Result := inherited CloseFile;
  // Always attempt to close trader reference handle
  Status := fTraderRow.CloseFile;
  // Can only return one integer value, this class's by preference
  if Result = 0 then
    Result := Status;
end;

//=======================================================================

constructor TEBusBtrieveLookupVAT.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := LOOKUP_TYPE_VAT + LOOKUP_SUBTYPE_NONE;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookupVAT.SetOurVATCode(Value : char);
begin
  OurItemCode := Value;
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupVAT.GetOurVATCode : char;
begin
  if length(OurItemCode) > 0 then
    Result := OurItemCode[1]
  else
    Result := ' ';
end;

//=======================================================================

constructor TEBusBtrieveLookupCurrency.Create(ShowErrors : boolean = false);
begin
  inherited Create(ShowErrors);
  KeyPrefix := LOOKUP_TYPE_CURRENCY + LOOKUP_SUBTYPE_NONE;
end;

//-----------------------------------------------------------------------

procedure TEBusBtrieveLookupCurrency.SetOurCurrencyCode(Value : integer);
begin
  OurItemCode := IntToStr(Value);
end;

//-----------------------------------------------------------------------

function TEBusBtrieveLookupCurrency.GetOurCurrencyCode : integer;
begin
  Result := StrToInt(Trim(OurItemCode));
end;

end.


