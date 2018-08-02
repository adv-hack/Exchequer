unit LockElObjs;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ElVar, Lockbtbase, Btrvu2, ETDateU, SysUtils, dialogs, EngineF, Windows;

const
  EnOffset = 13;
  EnLength = 31;

type
  TElertExportBlockHeader = Record
    BlockType : Char;
    BlockSize : longint;
    Spare : Array[1..16] of Byte;
  end;

  TElertExportFileHeader = Record
    Version  : String[6];
    NoOfSentinels : SmallInt;
    TrailerPos    : longint;
    Spare : Array[1..16] of Byte;
  end;

  TElertFileTrailerRec = Record
    ElertName   :  String[30];
    ElertPos    : longint;
    Spare : Array[1..16] of Byte;
  end;



  EComTKException = Class(Exception);
  EElertException = Class(Exception);
  ETooManySentinels = Class(Exception);

  TElertBaseObject = Class(TBtrieveObject)
{  private
    FPrefix: Char;}
  protected
    FElertName : String[30];
    FCompanyCode : String;
    function GetElertName : ShortString;
    procedure SetelertName(Value : ShortString);
    function FindRec(const SearchKey : string; SearchType : Byte;
                           Lock : Boolean) : SmallInt; override;
    function BuildSearchKey(const Key : string) : ShortString; override;
    function CheckKey(const Comp, El : ShortString) : Boolean; virtual;
    procedure MoveDataForRead; override;
    function StandardWhereClause : string;
  public
    function WriteToFile(var F : File) : SmallInt;
    function ReadFromFile(var F : File) : SmallInt;
    procedure DeleteTempRecs(WhichType : Char); virtual;
    procedure DeleteTempRecsSQL(WhichType : Char); virtual;
    constructor Create;
    destructor Destroy; override;
    function Add : SmallInt; override;
    property ElertName : ShortString read GetElertName write SetElertName;
    property Prefix : Char read FPrefix;
    property CompanyCode : string read FCompanyCode write FCompanyCode;
  end;

  TOutput = Class(TElertBaseObject)
  private
    FDataPointer : ^TElertOutputLine;
    FType : Char;
    FLineNo : SmallInt;
  protected
    function GetOutputType : TOutputLineType;
    procedure SetOutputType(Value : TOutputLineType);
    function GetTypeChar : Char;
    function GetLine(Index : Integer) : ShortString;
    procedure SetLine(Index : Integer; const Value : ShortString);
    function GetLineNo : SmallInt;
    procedure SetLineNo(Value : SmallInt);
    function GetParamType : TElertRangeValType;
    procedure SetParamType(Value : TElertRangeValType);
    function GetDeliveryType : TReportDeliveryType;
    procedure SetDeliveryType(Value : TReportDeliveryType);
    function GetInstance : SmallInt;
    procedure SetInstance(Value : SmallInt);
    function BuildSearchKey(const Key : string) : ShortString; override;
    function CheckKey(const Comp, El : ShortString) : Boolean; override;
    function GetMsgInst : SmallInt;
    procedure SetMsgInst(Value : SmallInt);
    function GetRecipType : TEmailRecipType;
    procedure SetRecipType(Value : TEmailRecipType);
    function GetEntParamType : Byte;
    procedure SetEntParamType(Value : Byte);
    function GetInt(Index : Integer) : SmallInt;
    procedure SetInt(Index : Integer; Value : SmallInt);
  public
    constructor Create;
    function Add : SmallInt; override;
    property OutputType : TOutputLineType read GetOutputType write SetOutputType;
    property Line1 : ShortString Index 1 read GetLine write SetLine;
    property Line2 : ShortString Index 2 read GetLine write SetLine;
    property LineNo : SmallInt read GetLineNo write SetLineNo;
    property ParamType : TElertRangeValType read GetParamType write SetParamType;
    property DeliveryType : TReportDeliveryType read GetDeliveryType
                                                write SetDeliveryType;
    property Instance : SmallInt read GetInstance write SetInstance;
    property MsgInstance : SmallInt read GetMsgInst write SetMsgInst;
    property TypeChar : Char read GetTypeChar;
    property RecipType : TEmailRecipType read GetRecipType write SetRecipType;
    property EntParamType : Byte read GetEntParamType write SetEntParamType;
    property OffStart : SmallInt index 1 read GetInt write SetInt;
    property OffEnd : SmallInt index 2 read GetInt write SetInt;
    property RFName : ShortString  Index 3 read GetLine write SetLine;
  end;

  TSysRec = Class(TOutput)
  private
    FVar : FileVar;
    function GetTimeStamp: TDateTime;
    function GetEngineCounter : longint;
  public
    EntPath : string;
    constructor Create(const APath : string);
    function OpenFile : SmallInt; override;
    function CloseFile : SmallInt; virtual;
    function FindRec(const SearchKey : string; SearchType : Byte;
                           Lock : Boolean) : SmallInt; override;
    function UnlockRecord : SmallInt; override;
    function Save : Smallint; override;
    property EngineCounter : longint read GetEngineCounter;
    property TimeStamp : TDateTime read GetTimeStamp;
  end;

  TAddress = Class(TElertBaseObject)
  private
    FDataPointer : ^TElertEmailAddressRec;
  protected
    function GetAddress : ShortString;
    procedure SetAddress(const Value : ShortString);
    function GetName : ShortString;
    procedure SetName(const Value : ShortString);
    function GetRecipType : TEmailRecipType;
    procedure SetRecipType(Value : TEmailRecipType);
  public
    constructor Create;
    property Address : ShortString read GetAddress write SetAddress;
    property Name : ShortString read GetName write SetName;
    property RecipientType : TEmailRecipType read GetRecipType write SetRecipType;
  end;

  TRemoteAddress = Class(TAddress)
  protected
    function GetRecipNo : SmallInt;
    procedure SetRecipNo(Value : SmallInt);
  public
    constructor Create;
    property RecipNo :  SmallInt read GetRecipNo write SetRecipNo;
  end;

  TSMS = Class(TElertBaseObject)
  private
    FDataPointer : ^TElertSMSRec;
  protected
    function GetString(Index : Integer) : ShortString;
    procedure SetString(Index : Integer; const Value : ShortString);
    function GetFullNumber : ShortString;
  public
    constructor Create;
    property Country : ShortString index 1 read GetString write SetString;
    property Code : ShortString index 2 read GetString write SetString;
    property Number : ShortString index 3 read GetString write SetString;
    property Name : ShortString index 4 read GetString write SetString;
    property FullNumber : ShortString read GetFullNumber;
  end;

  TElertObject = Class(TElertBaseObject)
  private
    FDataPointer : PElertRec;
    FType : Char;
    FPriority : Char;
  protected
    function GetDescription : ShortString;
    procedure SetDescription(const Value : ShortString);
    function GetDaysOfWeek : Byte;
    procedure SetDaysOfWeek(Value : Byte);
    function GetTimeType : TElertTimeType;
    procedure SetTimeType(Value : TElertTimeType);
    function GetExpiration : TElertExpirationType;
    procedure SetExpiration(Value : TElertExpirationType);
    function GetInt(Index : Integer) : Smallint;
    procedure SetInt(Index : Integer; Value : Smallint);
    function GetLongInt(Index : Integer) : LongInt;
    procedure SetLongInt(Index : Integer; Value : LongInt);
    function GetBoolean(Index : Integer) : Boolean;
    procedure SetBoolean(Index : Integer; Value : Boolean);
    function GetDateTime(Index : Integer) : TDateTime;
    procedure SetDateTime(Index : Integer; Value : TDateTime);
    function GetType : TElertType;
    procedure SetType(Value : TElertType);
    function GetRangeStart : TElertRangeRec;
    procedure SetRangeStart(Value : TElertRangeRec);
    function GetRangeEnd : TElertRangeRec;
    procedure SetRangeEnd(Value : TElertRangeRec);
    function GetPriority : TElertPriority;
    procedure SetPriority(Value : TElertPriority);
    function GetStatus : TElertStatus;
    procedure SetStatus(Value : TElertStatus);

    function GetCondition : ShortString;
    procedure SetCondition(const Value : ShortString);

    function GetRepeatPeriod : TElertRepeatPeriod;
    procedure SetRepeatPeriod(Value : TElertRepeatPeriod);

    function GetReportName : ShortString;
    procedure SetReportName(const Value : ShortString);
    function GetTermChar : Char;
    procedure SetTermChar(Value : Char);

    function FindRec(const SearchKey : string; SearchType : Byte;
                           Lock : Boolean) : SmallInt; override;
    function BuildSearchKey(const Key : string) : ShortString; override;
    function GetCoverPage : ShortString;
    procedure SetCoverPage(const Value : ShortString);
    function GetDocName : ShortString;
    procedure SetDocName(const Value : ShortString);
    function RemoveDateSep(const s : string) : String;

    function GetString(Index : Integer) : ShortString;
    procedure SetString(Index : Integer; const Value : ShortString);
  public
    constructor Create;
    constructor CreateNoFile;
    function GetNextRunDue(FromQuery : Boolean; IsEdit : Boolean = False;
                           StartDateChanged : Boolean = False) : TDateTime;

    procedure SetRange(var ARange : TElertRangeRec; const Value : ShortString;
                       Offset : longint; ValType : TElertRangeValType);
    function StatusString : ShortString;
    function Copy(const NewName, NewUser : ShortString; AllRecs : Boolean = False) : SmallInt;
    function Delete : SmallInt; override;
    procedure DeleteSQL;
    function ShowRecs(AList : TStrings) : SmallInt;
    property Description : ShortString read GetDescription write SetDescription;
    property DaysOfWeek : Byte read GetDaysOfWeek write SetDaysOfWeek;
    property TimeType : TElertTimeType read GetTimeType write SetTimeType;
    property Expiration : TElertExpirationType read GetExpiration write SetExpiration;
    property ElertType : TElertType read GetType write SetType;

    property Active : Boolean index 1 read GetBoolean write SetBoolean;
    property EmailReport : Boolean index 2 read GetBoolean write SetBoolean;
    property ActionEmail : Boolean index 3 read GetBoolean write SetBoolean;
    property ActionSMS : Boolean index 4 read GetBoolean write SetBoolean;
    property ActionReport : Boolean index 5 read GetBoolean write SetBoolean;
    property ActionCSV : Boolean index 6 read GetBoolean write SetBoolean;
    property RunOnStartup : Boolean index 7 read GetBoolean write SetBoolean;

    property Frequency  : SmallInt index 1 read GetInt write SetInt;
    property RepeatData : SmallInt index 2 read GetInt write SetInt;
    property FileNumber : SmallInt index 3 read GetInt write SetInt;
    property IndexNumber : SmallInt index 4 read GetInt write SetInt;
    property EventIndex  : SmallInt index 5 read GetInt write SetInt;

    property Time1 : TDateTime index 1 read GetDateTime write SetDateTime;
    property Time2 : TDateTime index 2 read GetDateTime write SetDateTime;
    property ExpirationDate : TDateTime index 3 read GetDateTime write SetDateTime;
    property LastDateRun : TDateTime index 4 read GetDateTime write SetDateTime;
    property NextRunDue : TDateTime index 5 read GetDateTime write SetDateTime;

    property WindowID : longint index 1 read GetLongInt write SetLongInt;
    property HandlerID : longint index 2 read GetLongInt write SetLongInt;

    property RangeStart : TElertRangeRec read GetRangeStart write SetRangeStart;
    property RangeEnd : TElertRangeRec read GetRangeEnd write SetRangeEnd;

    property Conditions : ShortString read GetCondition write SetCondition;

    property RepeatPeriod : TElertRepeatPeriod read GetRepeatPeriod
                                               write SetRepeatPeriod;

    property ReportName : ShortString read GetReportName write SetReportName;

    property Priority : TElertPriority read GetPriority write SetPriority;
    property Status : TElertStatus read GetStatus write SetStatus;
    property StartDate : TDateTime index 6 read GetDateTime write SetDateTime;
    property DeleteAfterExpiry : Boolean index 8 read GetBoolean write SetBoolean;
    property Periodic : Boolean index 9 read GetBoolean write SetBoolean;
    property TriggerCount : SmallInt index 6 read GetInt write SetInt;
    property DaysBetween : SmallInt index 7 read GetInt write SetInt;
    property RunNow : Boolean index 10 read GetBoolean write SetBoolean;
    property Instance : SmallInt index 8 read GetInt write SetInt;
    property SingleEmail : Boolean index 11 read GetBoolean write SetBoolean;
    property SingleSMS : Boolean index 12 read GetBoolean write SetBoolean;
    property Triggered : Smallint index 9 read GetInt write SetInt;
    property TermChar : Char read GetTermChar write SetTermChar;
    property Expired : Boolean index 13 read GetBoolean write SetBoolean;
    property SendDoc : Boolean index 14 read GetBoolean write SetBoolean;

    property EmailRetries : Smallint index 10 read GetInt write SetInt;
    property SMSRetries : Smallint index 11 read GetInt write SetInt;

    property FaxPriority : SmallInt index 12 read GetInt write SetInt;

    property EmailRetriesNotified : Boolean index 15 read GetBoolean write SetBoolean;
    property SMSRetriesNotified : Boolean index 16 read GetBoolean write SetBoolean;

    property ActionRepEmail : Boolean index 17 read GetBoolean write SetBoolean;
    property ActionRepFax : Boolean index 18 read GetBoolean write SetBoolean;
    property ActionRepPrinter : Boolean index 19 read GetBoolean write SetBoolean;
    property HasConditions : Boolean index 20 read GetBoolean write SetBoolean;

    property CoverPage : ShortString read GetCoverPage write SetCoverPage;

    property DocName : ShortString read GetDocName write SetDocName;

    property ReportFolder : ShortString index 1 read GetString write SetString;
    property FTPSite : ShortString index 2 read GetString write SetString;
    property FTPUserName : ShortString index 3 read GetString write SetString;
    property FTPPassword : ShortString index 4 read GetString write SetString;

    property FTPPort : SmallInt index 13 read GetInt write SetInt;
    property FTPTimeout : SmallInt index 14 read GetInt write SetInt;
    property FTPRetries   : SmallInt index 15 read GetInt write SetInt;
    property FaxRetries   : SmallInt index 16 read GetInt write SetInt;
    property HoursToNotify   : SmallInt index 17 read GetInt write SetInt;

    property CSVFilename : ShortString index 5 read GetString write SetString;

    property CSVByEmail : Boolean index 21 read GetBoolean write SetBoolean;
    property CSVByFTP : Boolean index 22 read GetBoolean write SetBoolean;
    property CSVToFolder : Boolean index 23 read GetBoolean write SetBoolean;
    property CSVFileRenamed : Boolean index 24 read GetBoolean write SetBoolean;
    property FTPRetriesNotified : Boolean index 25 read GetBoolean write SetBoolean;
    property FaxRetriesNotified : Boolean index 26 read GetBoolean write SetBoolean;
    property WordWrap : Boolean index 27 read GetBoolean write SetBoolean;
    property DBF : Boolean index 28 read GetBoolean write SetBoolean;

    property UploadDir : ShortString index 6 read GetString write SetString;
    property WorkStation : ShortString index 7 read GetString write SetString;
    property ExRepFormat : SmallInt index 18 read GetInt write SetInt;
    property NewReport : Boolean index 29 read GetBoolean write SetBoolean;
    property NewReportName : ShortString index 8 read GetString write SetString;

    procedure SetDataPointer(Value : PElertRec);
    procedure Purge(Opts : Byte);
    procedure PurgeSQL(Opts : Byte);
    procedure Clear;
    procedure ClearRetryFlags;
    function CanRunPercent(ERec : TEnginesRunningRec) : Byte;
  end;

  TEvent = Class(TElertBaseObject)
  private
    FDataPointer : ^TElertEventRec;
  protected
    function GetKey : ShortString;
    procedure SetKey(const Value : ShortString);
    function GetInstance : SmallInt;
    procedure SetInstance(const Value : SmallInt);
    function GetFileNo : Byte;
    procedure SetFileNo(Value : Byte);
    function GetLongInt(Index : integer) : longint;
    procedure SetLongInt(Index : integer; Value : longint);
  public
    constructor Create;
    constructor CreateNoFile;
    property Key : ShortString read GetKey write SetKey;
    property Instance : SmallInt read GetInstance write SetInstance;
    property FileNo : Byte read GetFileNo write SetFileNo;
    property WinID : longint index 0 read GetLongInt write SetLongInt;
    property HandID : longint index 1 read GetLongInt write SetLongInt;
  end;

  TTriggered = Class(TOutput)
  public
    constructor Create;
    function BuildSearchKey(const Key : string) : ShortString; override;
    function DeleteInstTempRecs(WhichType : Char; WhichInstance : longint) : Integer;
    procedure DeleteInstTempRecsSQL(WhichType : Char; WhichInstance : longint);
  end;



implementation

uses
{$IFNDEF SENTHOOK}
   debugLog,
{$ENDIF}
   FileUtil, SQLUtils;

{$IFDEF SENTHOOK}
procedure LogIt(const s  : String);
begin
end;
{$ENDIF}

constructor TElertBaseObject.Create;
begin
  inherited Create;
  FillChar(FDataBuffer, MaxRecSize, #0);
end;

destructor TElertBaseObject.Destroy;
begin
  inherited Destroy;
end;

function TElertBaseObject.Add : smallInt;
begin
  Move(FElertName[0], FDataBuffer[EnOffset], 31);
  Result := inherited Add;
end;


function TElertBaseObject.GetElertName : ShortString;
begin
  Move(FDataBuffer[EnOffset], FElertName[0], EnLength);
  Result := Trim(FElertName);
end;

procedure TElertBaseObject.SetElertName(Value : ShortString);
begin
  FElertName := LJVar(Value, EnLength - 1);
  Move(FElertName[0], FDataBuffer[EnOffset], EnLength);
end;

function TElertBaseObject.CheckKey(const Comp, El : ShortString) : Boolean;
begin
  Result := (Trim(Comp) = Trim(FUserID)) and
            (Trim(El) = Trim(FElertName));
end;

function TElertBaseObject.FindRec(const SearchKey : string; SearchType : Byte;
                                       Lock : Boolean) : SmallInt;
//Find record and load into data buffer
var
  KeyS : string[255];
  BtrieveMode  : integer;
  TempString : string[10];
  RefString  : String[30];
  TempChar : Char;
begin
  FillChar(KeyS[1], 255, #32);
  KeyS := BuildSearchKey(SearchKey);
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
  if (FPrefix <> '!') and UsingSQL then
    UseVariantForNextCall(F[FFileNo], nil);

  Result := Find_Rec(SearchType, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
  if Result = 0 then
  begin
    if FSegmented and (SearchType in [B_GetGEq, B_GetNext, B_GetPrev, B_GetLess, B_GetLessEq]) then
    begin
    //Move UserID code into tempstring for comparision
      Move(FData^, TempChar, 1);
      Move(Pointer((Longint(FData) + 1))^, TempString[0], 13);
      Move(Pointer((Longint(FData) + 12))^, RefString[0], 31);
      if (FPrefix = TempChar) and (FUserID = TempString) and (FElertName = RefString) then
         MoveDataForRead
      else
      begin
        if SearchType in [B_GetGEq, B_GetNext] then
          Result := 9
        else
          Result := 4;
      end;
    end
    else
    begin
      Move(FData^, TempChar, 1);
      if (FPrefix = TempChar) then
        MoveDataForRead
      else
      begin
        if SearchType in [B_GetGEq, B_GetNext] then
          Result := 9
        else
          Result := 4;
      end;
    end;
  end;//Result := 0;

  //Get lock if necessary
  if Lock and (Result = 0) then
  begin
    Result := LockRecord;
    if Result = 0 then
      MoveDataForRead;
  end;
end;

function TElertBaseObject.BuildSearchKey(const Key : string) : ShortString;
begin
  Result := FPrefix + {LJVar(FUserID, 10)  + LJVar(FElertName, 30)}
             MakeElertNameKey(FUserID, FElertName);
end;

procedure TElertBaseObject.MoveDataForRead;
begin
  inherited;
  GetElertName; //puts elertname into FElertName
end;

function TElertBaseObject.WriteToFile(var F : File) : SmallInt;
var
  Head : TElertExportBlockHeader;
begin
  FillChar(Head, SizeOf(Head), #0);
  with Head do
  begin
    BlockType := FPrefix;
    BlockSize := FDataSize;
  end;
{$I-}
  BlockWrite(F, Head, SizeOf(Head));
  BlockWrite(F, FDataBuffer, FDataSize);
  Result := IOResult;
{$I+}
end;

function TElertBaseObject.ReadFromFile(var F : File) : SmallInt;
begin
{$I-}
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
  BlockRead(F, FDataBuffer, FDataSize);
  Move(FUserID[1], FDataBuffer[2], UIDSize);
  Result := IOResult;
{$I+}
end;




//-----------------Output--------------------------------

constructor TOutput.Create;
begin
  inherited Create;
  FFileNo := LineF;
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
//  FDataPointer^.eoTerm := '!';
  FDataSize := SizeOf({LineRec}TElertOutputLine) + 1;
  FData := @LineRec;
  FPrefix := pxElOutput;
  OpenFile;
end;



function TOutput.GetOutputType : TOutputLineType;
begin
  Case FDataPointer^.eoOutputType of
     'B'  : Result := eolEmailSubject;
     'E'  : Result := eolEmailHeader;
     otEmailLine : Result := eolEmailLine;
     otEmailTrailer : Result := eolEmailTrailer;
     'S'  : Result := eolSMS;
     'R'  : Result := eolReport;
     'C'  : Result := eolCSV;
     'P'  : Result := eolParams;
     'L'  : Result := eolLogic;
     'V'  : Result := eolEvent;
     'X'  : Result := eolFaxNo;
     'F'  : Result := eolFaxFrom;
     'G'  : Result := eolFaxNoteLine;
     'Y'  : Result := eolRepEmailSubject;
     'Z'  : Result := eolRepEmailLine;
     'A'  : Result := eolRepEmailAdd;
     'H'  : Result := eolRepPrinter;

     '1'  : Result := eolSysEmail;
     '2'  : Result := eolSysSMS;
     '3'  : Result := eolSysFax;
     '4'  : Result := eolSysFTP;
     '5'  : Result := eolSysAlerts;
     '6'  : Result := eolSysReports;
     '7'  : Result := eolSysHigh;
     '8'  : Result := eolSysLow;
     else
       Result := eolUnknown;
  end
  //use 'M' for SMS output ready to go, 'I' for Email ready to go
end;

procedure TOutput.SetOutputType(Value : TOutputLineType);
begin
  Case Value of
    eolEmailSubject  : FDataPointer^.eoOutputType := otEmailSubject;
    eolEmailHeader   :  FDataPointer^.eoOutputType := 'E';
    eolEmailLine     : FDataPointer^.eoOutputType := otEmailLine;
    eolEmailTrailer  : FDataPointer^.eoOutputType := otEmailTrailer;
    eolSMS     :  FDataPointer^.eoOutputType := 'S';
    eolReport  :  FDataPointer^.eoOutputType := 'R';
    eolCSV     :  FDataPointer^.eoOutputType := 'C';
    eolParams  :  FDataPointer^.eoOutputType := 'P';
    eolLogic   :  FDataPointer^.eoOutputType := 'L';
    eolEvent   :  FDataPointer^.eoOutputType := 'V';
    eolFaxNo   :  FDataPointer^.eoOutputType := 'X';
    eolFaxFrom :  FDataPointer^.eoOutputType := 'F';
    eolFaxNoteLine       :  FDataPointer^.eoOutputType := 'G';
    eolRepEmailAdd       :  FDataPointer^.eoOutputType := 'A';
    eolRepEmailSubject   :  FDataPointer^.eoOutputType := 'Y';
    eolRepEmailLine      :  FDataPointer^.eoOutputType := 'Z';
    eolRepPrinter        :  FDataPointer^.eoOutputType := 'H';

    eolSysEmail    : FDataPointer^.eoOutputType := '1';
    eolSysSMS      : FDataPointer^.eoOutputType := '2';
    eolSysFax      : FDataPointer^.eoOutputType := '3';
    eolSysFTP      : FDataPointer^.eoOutputType := '4';
    eolSysAlerts   : FDataPointer^.eoOutputType := '5';
    eolSysReports  : FDataPointer^.eoOutputType := '6';
    eolSysHigh     : FDataPointer^.eoOutputType := '7';
    eolSysLow      : FDataPointer^.eoOutputType := '8';
  end;
  FType := FDataPointer^.eoOutputType;
end;

function TOutput.GetLine(Index : Integer) : ShortString;
begin
  Case Index of
    1  :   Result := FDataPointer^.eoLine1;
    2  :   Result := FDataPointer^.eoLine2;
    3  :   Result := FDataPointer^.eoRFName;
  end;
end;

procedure TOutput.SetLine(Index : Integer; const Value : ShortString);
begin
  Case Index of
    1 : FDataPointer^.eoLine1  := Value;
    2 : FDataPointer^.eoLine2  := Value;
    3 : FDataPointer^.eoRFName := Value;
  end;
end;

function TOutput.GetLineNo : SmallInt;
begin
  Result := FDataPointer^.eoLineNo;
end;

procedure TOutput.SetLineNo(Value : SmallInt);
begin
  FDataPointer^.eoLineNo := Value;
  FLineNo := Value;
end;

function TOutput.GetParamType : TElertRangeValType;
begin
  Result := TElertRangeValType(FDataPointer^.eoParamType);
end;

procedure TOutput.SetParamType(Value : TElertRangeValType);
begin
  FDataPointer^.eoParamType := Ord(Value);
end;

function TOutput.GetEntParamType : Byte;
begin
  Result := FDataPointer^.eoEntParamType;
end;

procedure TOutput.SetEntParamType(Value : Byte);
begin
  FDataPointer^.eoEntParamType := Value;
end;


function TOutput.GetDeliveryType : TReportDeliveryType;
begin
  Result := TReportDeliveryType(FDataPointer^.eoParamType);
end;

procedure TOutput.SetDeliveryType(Value : TReportDeliveryType);
begin
  FDataPointer^.eoParamType := Ord(Value);
end;


function TOutput.BuildSearchKey(const Key : string) : ShortString;
var
  s : ShortString;
  i : SmallInt;
begin
  s := StringOfchar(' ', SizeOf(i));
  i := 0;
  Move(i, s[1], SizeOf(i));
  Result := FPrefix + {LJVar(FUserID, 10)  + LJVar(FElertName, 30)}
             MakeElertNameKey(FUserID, FElertName) + s + FDataPointer^.eoOutputType;
end;

function TOutput.CheckKey(const Comp, El : ShortString) : Boolean;
begin
  Result := inherited CheckKey(Comp, El) and (FType = FDataPointer^.eoOutputType);
end;

function TOutput.Add : smallInt;
begin
{  Move(FType, FDataBuffer[EnOffset + 32], 1);
  Move(FLineNo, FDataBuffer[EnOffset + 33], 1);}
  Result := inherited Add;
end;

function TOutput.GetInstance : SmallInt;
begin
  Result := FDataPointer^.eoInstance;
end;

procedure TOutput.SetInstance(Value : SmallInt);
begin
  FDataPointer^.eoInstance := Value;
end;

function TOutput.GetMsgInst : SmallInt;
begin
  Result := FDataPointer^.eoMsgInstance;
end;

procedure TOutput.SetMsgInst(Value : SmallInt);
begin
  FDataPointer^.eoMsgInstance := Value;
end;

function TOutput.GetTypeChar : Char;
begin
  Result :=FDataPointer^.eoOutputType;
end;

function TOutput.GetRecipType : TEmailRecipType;
begin
  Result := TEmailRecipType(FDataPointer^.eoEmType);
end;

procedure TOutput.SetRecipType(Value : TEmailRecipType);
begin
  FDataPointer^.eoEmType := Ord(Value);
end;

function TOutput.GetInt(Index : Integer) : SmallInt;
begin
  Case Index of
    1 : Result := FDataPointer^.eoOffStart;
    2 : Result := FDataPointer^.eoOffEnd;
  end;
end;

procedure TOutput.SetInt(Index : Integer; Value : SmallInt);
begin
  Case Index of
    1  :  FDataPointer^.eoOffStart := Value;
    2  :  FDataPointer^.eoOffEnd := Value;
  end;
end;



//------------------address

constructor TAddress.Create;
begin
  inherited Create;
  FFileNo := LineF;
  FData := @LineRec;
  FDataSize := SizeOf({LineRec}TElertEmailAddressRec) + 1;
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
  FPrefix := pxElEmail;
  OpenFile;
end;

function TAddress.GetAddress : ShortString;
begin
  Result := FDataPointer^.emaAddress;
end;

procedure TAddress.SetAddress(const Value : ShortString);
begin
  FDataPointer^.emaAddress := Value;
end;

function TAddress.GetName : ShortString;
begin
  Result := FDataPointer^.emaName;
end;

procedure TAddress.SetName(const Value : ShortString);
begin
  FDataPointer^.emaName := Value;
end;

function TAddress.GetRecipType : TEmailRecipType;
begin
  Result := TEmailRecipType(FDataPointer^.emaRecipType);
end;

procedure TAddress.SetRecipType(Value : TEmailRecipType);
begin
  FDataPointer^.emaRecipType := Ord(Value);
end;

//--------------------Remote Address--------------

constructor TRemoteAddress.Create;
begin
  inherited Create;
  FPrefix := pxRemoteEmail;
end;

function TRemoteAddress.GetRecipNo : SmallInt;
begin
  Result := FDataPointer^.emaRecipNo;
end;

procedure TRemoteAddress.SetRecipNo(Value : SmallInt);
begin
  FDataPointer^.emaRecipNo := Value;
end;

//--------------------SMS--------------

constructor TSMS.Create;
begin
  inherited Create;
  FFileNo := LineF;
  FData := @LineRec;
  FDataSize := SizeOf({LineRec}TElertSMSRec) + 1;
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
  FPrefix := pxElSMS;
  OpenFile;
end;

function TSMS.GetString(Index : Integer) : ShortString;
begin
  Case Index of
    1  : Result := Trim(FDataPointer^.esCountry);
    2  : Result := Trim(FDataPointer^.esCode);
    3  : result := Trim(FDataPointer^.esNumber);
    4  : result := Trim(FDataPointer^.esName);
    else
      Result := '';
  end;
end;

procedure TSMS.SetString(Index : Integer; const Value : ShortString);
begin
  Case Index of
    1  : FDataPointer^.esCountry := Value;
    2  : FDataPointer^.esCode := Value;
    3  : FDataPointer^.esNumber := Value;
    4  : FDataPointer^.esName := Value;
  end;
end;

function TSMS.GetFullNumber : ShortString;
begin
  Result := Country + ' ' + Code + ' ' + Number;
end;



//------------------Elert object ------------------------

constructor TElertObject.Create;
begin
  inherited Create;
  FFileNo := ElertF;
  FDataPointer := @FDataBuffer;
  Status := esIdle;
  SingleEmail := True;
  SingleSMS := True;
  Priority := elpLow;
  Periodic := False;
  WordWrap := False;

  FaxPriority := 1;

  FDataSize := SizeOf(ElertRec);
  FData := @ElertRec;
  OpenFile;
  FPrefix := '!';
  FDataPointer^.elTermChar := '!';
  SingleEmail := True;
end;

constructor TElertObject.CreateNoFile;
begin
  inherited Create;
  FFileNo := ElertF;
  FDataPointer := @FDataBuffer;
  Status := esIdle;
  SingleEmail := True;
  SingleSMS := True;
  Priority := elpLow;
  Periodic := False;

  FaxPriority := 1;

  FDataSize := SizeOf(ElertRec);
  FData := @ElertRec;
//  OpenFile;
  FPrefix := '!';
  FDataPointer^.elTermChar := '!';
  SingleEmail := True;
end;


function TElertObject.FindRec(const SearchKey : string; SearchType : Byte;
                                       Lock : Boolean) : SmallInt;
//Find record and load into data buffer
var
  KeyS : string[255];
  BtrieveMode  : integer;
  TempString : string[10];
begin
  FillChar(KeyS[1], 255, #0);
  KeyS := BuildSearchKey(SearchKey);
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
  Result := Find_Rec(SearchType{B_GetGEq}, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);

  if Result = 3 then
  begin
    Result := OpenFile;
    if Result = 0 then
      Result := Find_Rec(SearchType, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
  end;
  if Result = 0 then
  begin
    if FSegmented and (SearchType in [B_GetGEq, B_GetNext, B_GetPrev, B_GetLess, B_GetLessEq]) then
    begin
    //Move UserID code into tempstring for comparision
      Move(Pointer(Longint(FData) + 1)^, TempString[0], 11);
      if (FUserID = TempString) or (FIndex = elIdxEvent)  then
         MoveDataForRead
      else
      begin
        if SearchType in [B_GetGEq, B_GetNext] then
          Result := 9
        else
          Result := 4;
      end;
    end
    else
      MoveDataForRead;
  end;//Result := 0; *)

  //Get lock if necessary
  if Lock and (Result = 0) then
    Result := LockRecord;
end;

function TElertObject.BuildSearchKey(const Key : string) : ShortString;

begin
  Case FIndex of
    0  : Result := LJVar(FUserID, 10) + LJVar(Key, 30);
    1  : Result := LJVar(FUserID, 10) + LJVar(Key, 30) + Char(FType);
    2  : Result := LJVar(FUserID, 10) + LJVar(Key, 10) + Char(FPriority);
    3  : Result := IntKey(WindowID) + IntKey(HandlerID) + '!';
  end;
end;


function TElertObject.GetDescription : ShortString;
begin
  Result := FDataPointer^.elDescription;
end;

procedure TElertObject.SetDescription(const Value : ShortString);
begin
  FDataPointer^.elDescription := Value;
end;

function TElertObject.GetDaysOfWeek : Byte;
begin
  Result := FDataPointer^.elDaysOfWeek;
end;

procedure TElertObject.SetDaysOfWeek(Value : Byte);
begin
  FDataPointer^.elDaysOfWeek := Value;
end;

function TElertObject.GetTimeType : TElertTimeType;
begin
  Result := TElertTimeType(FDataPointer^.elTimeType);
end;

procedure TElertObject.SetTimeType(Value : TElertTimeType);
begin
  FDataPointer^.elTimeType := Ord(Value);
end;

function TElertObject.GetExpiration : TElertExpirationType;
begin
  Result := TElertExpirationType(FDataPointer^.elExpiration);
end;

procedure TElertObject.SetExpiration(Value : TElertExpirationType);
begin
  FDataPointer^.elExpiration := Ord(Value);
end;

function TElertObject.GetInt(Index : Integer) : Smallint;
begin
  Case Index of
    1  : Result := FDataPointer^.elFrequency;
    2  : Result := FDataPointer^.elRepeatData;
    3  : Result := FDataPointer^.elFileno;
    4  : Result := FDataPointer^.elIndexNo;
    5  : Result := FDataPointer^.elEventIndex;
    6  : Result := FDataPointer^.elTriggerCount;
    7  : Result := FDataPointer^.elDaysBetween;
    8  : Result := FDataPointer^.elInstance;
    9  : Result := FDataPointer^.elTriggered;
    10 : Result := FDataPointer^.elEmailTries;
    11 : Result := FDataPointer^.elSMSTries;
    12 : Result := FDataPointer^.elFaxPriority;
    13 : Result := FDataPointer^.elFTPPort;
    14 : Result := FDataPointer^.elFTPTimeOut;
    15 : Result := FDataPointer^.elFTPTries;
    16 : Result := FDataPointer^.elFaxTries;
    17 : Result := FDataPointer^.elHoursBeforeNotify;
    18 : Result := FDataPointer^.elExRepFormat;
  end;
end;

procedure TElertObject.SetInt(Index : Integer; Value : Smallint);
begin
  Case Index of
    1  : FDataPointer^.elFrequency := Value;
    2  : FDataPointer^.elRepeatData := Value;
    3  : FDataPointer^.elFileno := Value;
    4  : FDataPointer^.elIndexNo := Value;
    5  : FDataPointer^.elEventIndex := Value;
    6  : FDataPointer^.elTriggerCount := Value;
    7  : FDataPointer^.elDaysBetween := Value;
    8  : FDataPointer^.elInstance := Value;
    9  : FDataPointer^.elTriggered := Value;
    10 : FDataPointer^.elEmailTries := Value;
    11 : FDataPointer^.elSMSTries := Value;
    12 : FDataPointer^.elFaxPriority := Value;
    13 : FDataPointer^.elFTPPort := Value;
    14 : FDataPointer^.elFTPTimeout := Byte(Value);
    15 : FDataPointer^.elFTPTries := Value;
    16 : FDataPointer^.elFaxTries := Value;
    17 : FDataPointer^.elHoursBeforeNotify := Value;
    18 : FDataPointer^.elExRepFormat := Value;
  end;
end;

function TElertObject.GetBoolean(Index : Integer) : Boolean;
begin
  Case Index of
    1  : Result := FDataPointer^.elActive;
    2  : Result := FDataPointer^.elEmailReport;
    3  : Result := FDataPointer^.elActions.eaEmail;
    4  : Result := FDataPointer^.elActions.eaSMS;
    5  : Result := FDataPointer^.elActions.eaReport;
    6  : Result := FDataPointer^.elActions.eaCSV;
    7  : Result := FDataPointer^.elRunOnStartup;
    8  : Result := FDataPointer^.elDeleteOnExpiry;
    9  : Result := FDataPointer^.elPeriodic;
   10  : Result := FDataPointer^.elRunNow;
   11  : Result := FDataPointer^.elSingleEmail;
   12  : Result := FDataPointer^.elSingleSMS;
   13  : Result := FDataPointer^.elExpired;
   14  : Result := FDataPointer^.elSendDoc;
   15  : Result := FDataPointer^.elEmailRetriesNotified;
   16  : Result := FDataPointer^.elSMSRetriesNotified;
   17  : Result := FDataPointer^.elActions.eaRepEmail;
   18  : Result := FDataPointer^.elActions.eaRepFax;
   19  : Result := FDataPointer^.elActions.eaRepPrinter;
   20  : Result := FDataPointer^.elHasConditions;
   21  : Result := FDataPointer^.elCSVByEmail;
   22  : Result := FDataPointer^.elCSVByFTP;
   23  : Result := FDataPointer^.elCSVToFolder;
   24  : Result := FDataPointer^.elCSVFileRenamed;
   25  : Result := FDataPointer^.elFTPRetriesNotified;
   26  : Result := FDataPointer^.elFaxRetriesNotified;
   27  : Result := FDataPointer^.elWordWrap;
   28  : Result := FDataPointer^.elDBF;
   29  : Result := FDataPointer^.elNewReport;
  end;
end;

procedure TElertObject.SetBoolean(Index : Integer; Value : Boolean);
begin
  Case Index of
    1  : FDataPointer^.elActive := Value;
    2  : FDataPointer^.elEmailReport := Value;
    3  : FDataPointer^.elActions.eaEmail := Value;
    4  : FDataPointer^.elActions.eaSMS := Value;
    5  : FDataPointer^.elActions.eaReport := Value;
    6  : FDataPointer^.elActions.eaCSV := Value;
    7  : FDataPointer^.elRunOnStartup := Value;
    8  : FDataPointer^.elDeleteOnExpiry := Value;
    9  : FDataPointer^.elPeriodic := Value;
   10  : FDataPointer^.elRunNow := Value;
   11  : FDataPointer^.elSingleEmail := Value;
   12  : FDataPointer^.elSingleSMS := Value;
   13  : FDataPointer^.elExpired := Value;
   14  : FDataPointer^.elSendDoc := Value;
   15  : FDataPointer^.elEmailRetriesNotified := Value;
   16  : FDataPointer^.elSMSRetriesNotified := Value;
   17  : FDataPointer^.elActions.eaRepEmail := Value;
   18  : FDataPointer^.elActions.eaRepFax := Value;
   19  : FDataPointer^.elActions.eaRepPrinter := Value;
   20  : FDataPointer^.elHasConditions := Value;
   21  : FDataPointer^.elCSVByEmail := Value;
   22  : FDataPointer^.elCSVByFTP := Value;
   23  : FDataPointer^.elCSVToFolder := Value;
   24  : FDataPointer^.elCSVFileRenamed := Value;
   25  : FDataPointer^.elFTPRetriesNotified := Value;
   26  : FDataPointer^.elFaxRetriesNotified := Value;
   27  : FDataPointer^.elWordWrap := Value;
   28  : FDataPointer^.elDBF := Value;
   29  : FDataPointer^.elNewReport := Value;
  end;

end;

function TElertObject.GetDateTime(Index : Integer) : TDateTime;
begin
  Case Index of
    1  : Result := FDataPointer^.elTime1 - Trunc(FDataPointer^.elTime1);
    2  : Result := FDataPointer^.elTime2 - Trunc(FDataPointer^.elTime2);
    3  : Result := FDataPointer^.elExpirationDate;
    4  : Result := FDataPointer^.elLastDateRun;
    5  : Result := FDataPointer^.elNextRunDue;
    6  : Result := FDataPointer^.elStartDate;
  end;
end;

procedure TElertObject.SetDateTime(Index : Integer; Value : TDateTime);
begin
  Case Index of
    1  : FDataPointer^.elTime1 := Value;
    2  : FDataPointer^.elTime2 := Value;
    3  : FDataPointer^.elExpirationDate := Value;
    4  : FDataPointer^.elLastDateRun := Value;
    5  : FDataPointer^.elNextRunDue := Value;
    6  : FDataPointer^.elStartDate := Value;
  end;

end;

function TElertObject.GetLongInt(Index : Integer) : LongInt;
begin
  Case Index of
    1  : Result := FDataPointer^.elWindowID;
    2  : Result := FDataPointer^.elHandlerID;
  end;
end;

procedure TElertObject.SetLongInt(Index : Integer; Value : LongInt);
begin
  Case Index of
    1  : FDataPointer^.elWindowID := Value;
    2  : FDataPointer^.elHandlerID := Value;
  end;
end;

function TElertObject.GetType : TElertType;
begin
  Case FDataPointer^.elType of
    'E'  : Result := etEvent;
    'T'  : Result := etTimer;
    'G'  : Result := etGroup;
  end;
end;

procedure TElertObject.SetType(Value : TElertType);
begin
  Case Value of
    etEvent : FDataPointer^.elType := 'E';
    etTimer : FDataPointer^.elType := 'T';
    etGroup : FDataPointer^.elType := 'G';
  end;
  FType := FDataPointer^.elType;
end;

function TElertObject.GetRangeStart : TElertRangeRec;
begin
  Result := FDataPointer^.elRangeStart;
end;

procedure TElertObject.SetRangeStart(Value : TElertRangeRec);
begin
  FDataPointer^.elRangeStart := Value;
end;

function TElertObject.GetRangeEnd : TElertRangeRec;
begin
  Result := FDataPointer^.elRangeEnd;
end;

procedure TElertObject.SetRangeEnd(Value : TElertRangeRec);
begin
  FDataPointer^.elRangeEnd := Value;
end;

procedure TElertObject.SetRange(var ARange : TElertRangeRec; const Value : ShortString;
                                    Offset : longint; ValType : TElertRangeValType);
var
  d : TDateTime;
begin
  FillChar(ARange, sizeOf(ARange), 0);
  if Value <> '' then
  with ARange do
  begin
{    egType := evNull;

    if egType = evNull then
    Try
      egInt := StrToInt(Value);
      egType := evInt;
    Except
      egInt := 0;
      egType  := evNull;
    end;

    if egType = evNull then
    begin
      egString := Value;
      egType := evString;
    end;}
    egType := ValType;
    egOffset := Offset;
    if ValType = evInt then
      egInt := StrToInt(Value)
    else
    if ValType = evDate
    then
    begin
      Try
        d := StrToDate(Value);
        egString := FormatDateTime('yyyymmdd', d);
      Except
        egString := Value;
      End;
    end
    else
      egString := Value;
  end;
end;

function TElertObject.GetCondition : ShortString;
begin
//  Result := FDataPointer^.elLogic.ecCondition;
end;

procedure TElertObject.SetCondition(const Value : ShortString);
begin
//  FDataPointer^.elLogic.ecCondition := Value;
end;

function TElertObject.GetRepeatPeriod : TElertRepeatPeriod;
begin
  Result := TElertRepeatPeriod(FDataPointer^.elRepeatPeriod);
end;

procedure TElertObject.SetRepeatPeriod(Value : TElertRepeatPeriod);
begin
  FDataPointer^.elRepeatPeriod := Ord(Value);
end;

function TElertObject.GetReportName : ShortString;
begin
  Result := FDataPointer^.elReportName;
end;

procedure TElertObject.SetReportName(const Value : ShortString);
begin
  FDataPointer^.elReportName := Value;
end;

function TElertObject.GetCoverPage : ShortString;
begin
  Result := FDataPointer^.elFaxCover;
end;

procedure TElertObject.SetCoverPage(const Value : ShortString);
begin
  FDataPointer^.elFaxCover := Value;
end;

function TElertObject.GetPriority : TElertPriority;
begin
  Case FDataPointer^.elPriority of
    'H'   :  Result := elpHigh;
    'L'   :  Result := elpLow;
  end;
end;

procedure TElertObject.SetPriority(Value : TElertPriority);
begin
  Case Value of
    elpLow     :  FDataPointer^.elPriority  := 'L';
    elpHigh    :  FDataPointer^.elPriority  := 'H';
  end;
  FPriority := FDataPointer^.elPriority;
end;

function TElertObject.GetStatus : TElertStatus;
begin
  Result := TElertStatus(FDataPointer^.elStatus);
end;

procedure TElertObject.SetStatus(Value : TElertStatus);
begin
  FDataPointer^.elStatus := Ord(Value);
end;



(*function TElertObject.GetNextRunDue(FromQuery : Boolean; IsEdit : Boolean = False) : TDateTime;
var
  DueToday : Boolean;
  Day : SmallInt;
  Time, dtFreq, LastRun : TDateTime;
  WhichDay : Byte;
  ExtraDays : Byte;
  wMin, wHour : Word;
  xHour, xMin, xSec, xMSec : Word;
  Temp : Word;
  yy, mm, dd : Word;
  st : String[10];
  Start : TDateTime;
begin
{  if not FromQuery and not IsEdit then
    Result := NextRunDue
  else}
  begin

    if (Trunc(StartDate) > Trunc(Date)) or IsEdit then
      Start := Trunc(StartDate)
    else
      Start := Trunc(Date);
    DueToday := False;
    Time := Now;
    Time := Time - Trunc(Time);
    ExtraDays := 0;
    xSec := 0;
    xMSec := 0;
    wHour  := Frequency div 60;
    wMin := Frequency mod 60;
    dtFreq := EncodeTime(wHour, wMin, xSec, xMSec); //Frequency as tdatetime
    Day := DayOfWeek(Start) - 2;
    if Day < 0 then Day := 6;

    if TimeType = ettFrequencyInPeriod then
    begin
      LastRun := 0;
      while LastRun + dtFreq <= Time2 do
        LastRun := LastRun + dtFreq;
    end;

    if Periodic then
    begin
      DecodeDate(Start, yy, mm, dd);
      st := CalcDueDate(StrDate(yy, mm, dd), DaysBetween);
      DateStr(st, dd, mm, yy);
      if Trunc(Date) > Trunc(StartDate) then
        ExtraDays := Trunc(EncodeDate(yy, mm, dd)) - Trunc(Start)
      else
        ExtraDays := 0;
    end
    else
    While not DueToday do
    begin

      WhichDay := (1 shl Day);

      DueToday := DaysOfWeek and WhichDay = WhichDay;

      DueToday := DueToday and (

          (TimeType = ettFrequency)

       or ((TimeType = ettFrequencyInPeriod) and
           (Time >= Time1) and (Time <= LastRun))

       or ((TimeType = ettTimeOneOnly) and ((Time < Time1) or (ExtraDays > 0)))
       );

      if not DueToday then
      begin
        Inc(ExtraDays);

        inc(Day);
        if Day > 6 then Day := 0;

        Case TimeType of
          ettFrequency         : Time := EncodeTime(wHour, wMin, 0, 0);
          ettFrequencyInPeriod,
          ettTimeOneOnly       : Time := Time1;
        end;

      end;
    end;
    //At this point Start + ExtraDays gives us the next day to run the elert
    //+ if ExtraDays > 0 we have the time. All we need is the time if
    //ExtraDays = 0

    if IsEdit and (Trunc(StartDate) >= Trunc(Date)) then
    begin
      if ExtraDays = 0 then
        IsEdit := False;
      ExtraDays := 0;
    end;

    if (ExtraDays = 0) and not IsEdit then
    begin
      if TimeType = ettTimeOneOnly then
        Time := Time1
      else
      begin
        if TimeType = ettFrequency then
        begin
          xHour := 0;
          xMin := 0;
        end
        else
        if TimeType = ettFrequencyInPeriod then
          DecodeTime(Time1, xHour, xMin, xSec, xMSec);

        if Start <= Trunc(Date) then
        While EncodeTime(xHour, xMin, xSec, xMSec) < Time do
        begin
          xMin := xMin + Frequency;
          Temp := (xMin div 60);
          xMin :=  xMin mod 60;
          xHour := xHour + Temp;
        end;

        Time := EncodeTime(xHour, xMin, xSec, xMSec);
      end;
    end;


    Time := Time - Trunc(Time);
    Result := Start + ExtraDays + Time;
  end;
end;*)

(*function TElertObject.GetNextRunDue(FromQuery : Boolean; IsEdit : Boolean = False) : TDateTime;
var
  DueToday : Boolean;
  Day : SmallInt;
  ThisTime, dtFreq, LastRun : TDateTime;
  WhichDay : Byte;
  ExtraDays : Byte;
  wMin, wHour : Word;
  xHour, xMin, xSec, xMSec : Word;
  Temp : Word;
  yy, mm, dd : Word;
  st : String[10];
  Start : TDateTime;
begin

  if Trunc(Date) >= Trunc(StartDate) then
    Start := Trunc(Date)
  else
    Start := Trunc(StartDate);

  if not Periodic then
  begin
    While not DueToday do
    begin

      WhichDay := (1 shl Day);

      DueToday := DaysOfWeek and WhichDay = WhichDay;

      DueToday := DueToday and (

          (TimeType = ettFrequency)

       or ((TimeType = ettFrequencyInPeriod) and
           (Time >= Time1) and (Time <= LastRun))

       or ((TimeType = ettTimeOneOnly) and ((Time < Time1) or (ExtraDays > 0)))
       );

      if not DueToday then
      begin
        Inc(ExtraDays);

        inc(Day);
        if Day > 6 then Day := 0;

      end;
    end;
  end
  else
    ExtraDays := DaysBetween;

  if Date <= Trunc(StartDate) then
    ExtraDays := 0;

  if Trunc(LastDateRun) < Trunc(StartDate) then
    Result := Trunc(StartDate)
  else
  begin
    DecodeDate(Start, yy, mm, dd);
    st := CalcDueDate(StrDate(yy, mm, dd), DaysBetween);
    DateStr(st, dd, mm, yy);
    Result := Trunc(EncodeDate(yy, mm, dd));
  end;




  if TimeType = ettTimeOneOnly then
    ThisTime := Time1
  else
  begin
    if TimeType = ettFrequency then
    begin
      xHour := 0;
      xMin := 0;
    end
    else
    if TimeType = ettFrequencyInPeriod then
      DecodeTime(Time1, xHour, xMin, xSec, xMSec);

    if Start <= Trunc(Date) then
    While EncodeTime(xHour, xMin, xSec, xMSec) < Time do
    begin
      xMin := xMin + Frequency;
      Temp := (xMin div 60);
      xMin :=  xMin mod 60;
      xHour := xHour + Temp;
    end;

    ThisTime := EncodeTime(xHour, xMin, xSec, xMSec);
  end;

  ThisTime := ThisTime - Trunc(ThisTime);

  Result := Result + ThisTime;

  ShowMessage(DateTimeToStr(Result);

end; *)

(*function TElertObject.GetNextRunDue(FromQuery : Boolean; IsEdit : Boolean = False) : TDateTime;
var
  DueToday : Boolean;
  Day : SmallInt;
  ThisTime, dtFreq, LastRun : TDateTime;
  WhichDay : Byte;
  ExtraDays : Byte;
  wMin, wHour : Word;
  xHour, xMin, xSec, xMSec : Word;
  Temp : Word;
  yy, mm, dd : Word;
  st : String[10];
  Start, StartTime : TDateTime;
  xd : word;
begin
  xd := 0;
  if (LastDateRun = 0) or (StartDate > Date) then
  begin
    ThisTime := Time;
    Start := Trunc(StartDate);
  end
  else
  begin
    Start := Trunc(LastDateRun);
    if Start < Date then
    begin
      Start := Date;
      ThisTime := Time;
    end
    else
      ThisTime := LastDateRun - Trunc(LastDateRun);
  end;


  DueToday := False;
  ExtraDays := 0;
  xSec := 1;
  xMSec := 0;
  wHour  := Frequency div 60;
  wMin := Frequency mod 60;
  dtFreq := EncodeTime(wHour, wMin, xSec, xMSec); //Frequency as tdatetime
  Day := DayOfWeek(Start) - 2;
  if Day < 0 then Day := 6;

  if TimeType = ettFrequencyInPeriod then
  begin
    LastRun := 0;
    while LastRun + dtFreq <= Time2 do
      LastRun := LastRun + dtFreq;
  end;

  if Periodic then
  begin
    Case TimeType of
       ettFrequency         : if ThisTime + dtFreq > 1 then
                                xd := 1;
       ettFrequencyInPeriod : if ThisTime + dtFreq > Time2 then
                                xd := 1;
       ettTimeOneOnly       : if ThisTime > Time1 then
                                xd := 1;
     end;
    DecodeDate(Start, yy, mm, dd);
    st := CalcDueDate(StrDate(yy, mm, dd), DaysBetween + xd);
    DateStr(st, dd, mm, yy);
    if Date > StartDate then
      if Trunc(LastDateRun) + DaysBetween < Date then
        ExtraDays := xd
      else
        ExtraDays := Trunc(EncodeDate(yy, mm, dd)) - Trunc(Start)
    else
      ExtraDays := xd;


  end
  else
  While not DueToday do
  begin

    WhichDay := (1 shl Day);

    DueToday := DaysOfWeek and WhichDay = WhichDay;

    DueToday := DueToday and (

        (TimeType = ettFrequency)

     or ((TimeType = ettFrequencyInPeriod) and
         {(ThisTime >= Time1) and }(ThisTime <= LastRun))

     or ((TimeType = ettTimeOneOnly) and ((ThisTime < Time1) or (ExtraDays > 0)))
     );

    if not DueToday then
    begin
      Inc(ExtraDays);

      inc(Day);
      if Day > 6 then Day := 0;


    end;
  end;
  //At this point Start + ExtraDays gives us the next day to run the elert
  //+ if ExtraDays > 0 we have the time. All we need is the time if
  //ExtraDays = 0



  if ExtraDays = 0 then
  begin
    if TimeType = ettTimeOneOnly then
      ThisTime := Time1
    else
    begin
      if TimeType = ettFrequency then
      begin
        xHour := 0;
        xMin := 0;
      end
      else
      if TimeType = ettFrequencyInPeriod then
        DecodeTime(Time1, xHour, xMin, xSec, xMSec);

      if Start <= Trunc(Date) then
      While EncodeTime(xHour, xMin, xSec, xMSec) < ThisTime do
      begin
        xMin := xMin + Frequency;
        Temp := (xMin div 60);
        xMin :=  xMin mod 60;
        xHour := xHour + Temp;
      end;

      ThisTime := EncodeTime(xHour, xMin, xSec, xMSec);
    end;
  end
  else
     Case TimeType of
        ettFrequency         : ThisTime := EncodeTime(wHour, wMin, 0, 0);
        ettFrequencyInPeriod,
        ettTimeOneOnly       : ThisTime := Time1;
      end;



  ThisTime := ThisTime - Trunc(ThisTime);
  Result := Start + ExtraDays + ThisTime;

  if Result < Now then
    Result := Now;

end; *)

function TElertObject.GetNextRunDue(FromQuery : Boolean; IsEdit : Boolean = False;
                                    StartDateChanged : Boolean = False) : TDateTime;
var
  DueToday : Boolean;
  Day : SmallInt;
  ThisTime, dtFreq, LastRun, t : TDateTime;
  WhichDay : Byte;
  ExtraDays : Byte;
  wMin, wHour : Word;
  xHour, xMin, xSec, xMSec : Word;
  Temp : Word;
  yy, mm, dd : Word;
  st : String[10];
  Start, StartTime : TDateTime;
  xd : word;

  function RunToday : Boolean;
  begin
    if Periodic then
    begin
      Result := (LastDateRun = 0) or
                ((Trunc(LastDateRun) + DaysBetween = Date) and
                (DaysBetween < 500));
      if TimeType = ettTimeOneOnly then
        Result := Result and (Time1 > Time);
    end
    else
    begin
      Day := DayOfWeek(Date) - 2;
      if Day < 0 then Day := 6;
      WhichDay := (1 shl Day);
      Result := DaysOfWeek and WhichDay = WhichDay;
    end;
  end;

  function NextDayDue(d : TDateTime) : TDateTime;
  var
    Found : Boolean;
    Chk : Byte;
    TempS : ShortString;
  begin
    //Assume day is not today
    if Periodic then
    begin
      if LastDateRun <> 0 then
        TempS := DateToStr(Trunc(LastDateRun))
      else
        TempS := DateToStr(Date);
      TempS := CalcDueDate(Date2Store(RemoveDateSep(TempS)),DaysBetween);
      Result := StrToDate(POutDate(TempS));
    end
    else
    begin
      Result := d;
      Found := False;
      Chk := 0;
      while not Found and (Chk < 8) do
      begin
        inc(Chk);
        Result := Result + 1;
        Day := DayOfWeek(Result) - 2;
        if Day < 0 then Day := 6;
        WhichDay := (1 shl Day);
        Found := DaysOfWeek and WhichDay = WhichDay;
      end;
    end;
  end;


begin
  if IsEdit then
  begin
    Result := NextRunDue;
    EXIT;
  end;
  
  xSec := 1;
  xMSec := 0;
  wHour  := Frequency div 60;
  wMin := Frequency mod 60;
  dtFreq := EncodeTime(wHour, wMin, xSec, xMSec); //Frequency as tdatetime


  if TimeType = ettTimeOneOnly then
  begin
    if RunToday and (Time < Time1) then
      Result := Trunc(Date) + Time1
    else
      Result := NextDayDue(Date) + Time1;
  end
  else
  if TimeType = ettFrequency then
  begin
    if RunToday and (Time + dtFreq < 1) then
    begin
      if Trunc(LastDateRun) = Date then
        Result := LastDateRun + dtFreq
      else
        Result := Now + 1 / (24 * 60);
    end
    else
      Result := Trunc(Date) + 1;
  end
  else
  begin
    if RunToday and (Time + dtFreq < Time2) then
    begin
      if Trunc(LastDateRun) = Date then
        Result := LastDateRun + dtFreq
      else
        if Time > Time1 then
        begin
          t := Time1;
          while t < Time do
            t := t + dtFreq;
          Result := Date + t;
        end
        else
          Result := Date + Time1;
    end
    else
      Result := Date + 1 + Time1;
  end;

  if (StartDate > Result) or StartDateChanged then
  begin
    if Periodic then
      Case TimeType of
        ettTimeOneOnly,
        ettFrequencyInPeriod :  Result := StartDate + (Result - Trunc(Result));
        ettFrequency         :  Result := StartDate;
      end
    else
    begin //need to find first day on or after startdate that we want to run
      if not RunToday then
        Result := NextDayDue(StartDate) + (Result - Trunc(Result)); //figure out later
    end;
  end;


end;


function TElertObject.Copy(const NewName, NewUser : ShortString; AllRecs : Boolean = False) : SmallInt;
var
  OldName : String[30];
  OldUser : String[10];
  Res : SmallInt;
  KeyS : String[255];

  function WantThisRec : Boolean;
  begin
    Result := (LineRec.Prefix in [pxElEmail, pxElSMS]) or
              ((LineRec.Prefix = pxElOutput) and
               not (LineRec.Output.eoOutputType in Outputs2Go)) or
               AllRecs;
  end;

begin
  OldName := FElertName;
  OldUser := FUserID;

  ElertName := NewName;
  UserID := NewUser;

  Result := Add;

  if Result = 0 then
  begin
    //Copy records from lines file
    FillChar(KeyS, SizeOf(KeyS), #0);
    KeyS := LJVar(OldUser, 10) + LJVar(OldName, 30);
    Res := Find_Rec(B_GetEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);

    while (Res = 0) and (LineRec.Output.eoUserID = OldUser) and
                        (LineRec.Output.eoElertName = OldName) do
    begin
        Res := GetPos(F[LineF], LineF, FLockPos);
        if Res = 0 then
        begin
          if WantThisRec then
          begin
            LineRec.Output.eoUserID := LJVar(NewUser, 10);
            LineRec.Output.eoElertName := LJVar(NewName, 30);
            Res := Add_Rec(F[LineF],LineF,RecPtr[LineF]^, ellIdxElert);
          end;

          if Res = 0 then
          begin
            Move(FLockPos, RecPtr[LineF]^, SizeOf(FLockPos));
            Res := GetDirect(F[LineF], LineF, RecPtr[LineF]^, ellIdxElert,  0);
          end;

          if Res = 0 then
            Res := Find_Rec(B_GetNext, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
        end;

    end;

    if Res in [9, 4] then
      Result := 0
    else
      Result := Res;

  end;
end;

function TElertObject.Delete : SmallInt;
var
  Res : SmallInt;
  KeyS : String[255];
  TempE : String[30];
begin
  TempE := FElertName;
  Result := inherited Delete;
  if Result = 0 then
  begin
    if UsingSQL then
    begin
      Result := 0;
      DeleteSQL;
    end
    else
    begin
      //Copy records from lines file
      FillChar(KeyS, SizeOf(KeyS), #0);
      KeyS := LJVar(FUserID, 10) + LJVar(FElertName, 30);
      Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
      while (Res = 0) and (LineRec.Output.eoUserID = FUserID) and
                          (LineRec.Output.eoElertName = FElertName) do
      begin

         Res := Delete_Rec(F[LineF],LineF, ellIdxElert);

         if Res = 0 then
           Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);


      end;

      if Res in [9, 4] then
        Result := 0
      else
        Result := Res;
    end;
  end;
end;

function TElertObject.ShowRecs(AList : TStrings) : SmallInt;
//For debugging - shows contents of lines file
var
  Res : SmallInt;
  KeyS : String[255];
  s : AnsiString;
  Locked : Boolean;
begin

  begin
    //Copy records from lines file
    Res := Find_Rec(B_GetFirst {+ B_SingNWLock}, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
    if Res in [84, 85] then
    begin
      Res := Find_Rec(B_GetFirst, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
      Locked := True;
    end
    else
      Locked := False;

    while (Res in  [0,  84, 85])  do
    begin

       s := LineRec.Prefix;

       Case s[1] of
         'E',
         'A'  : with LineRec.EMail do
                begin
                  s := s + ' ' + emaUserID + ' ' +
                       emaElertName + ' ' + emaName + ' ' +
                         emaAddress;
                end;
         'O'  : with LineRec.Output do
                begin
                  s := s + ' ' + eoUserID + ' ' + eoElertName + ' ' +
                     eoOutputType + ' ' + IntToStr(Ord(eoLineNo)) + ' ' + eoLine1 + ' ' + eoLine2 +
                     ' ' + IntToStr(eoInstance) + ' ' + IntToStr(eoMsgInstance);
                end;

         'S'  : with LineRec.SMS do
                begin
                  s := s + ' ' + esUserID + ' ' + esElertName + ' ' +
                      esName + ' ' + esCountry + esCode + esNumber;
                end;
         'V'  : with LineRec.Event do
                begin
                  s := s + ' ' + evUserID + ' ' + evElertName + ' '
                        + Trim(evKey) + ' ' + IntToStr(evWinID) + ' ' + IntToStr(evHandID);
                end;
         'R'  : with LineRec.RecsSent do
                begin
                  s := s + ' ' + ersUserID + ' ' + ersElertName + ' '
                        + ersID + IntToStr(ersLineNo) + ' ' +
                        FormatDateTime('dd/mm/yyyy', ersDateLastSent);
                end;

         'Z'  : with LineRec.Output do
                begin
                  s := s + ' System flag ' +  eoOutputType;
                end;
         'T'  : with LineRec.Output do
                begin
                  s := s + ' ' + eoUserID + ' ' + eoElertName + ' ' +
                     eoOutputType + ' ' + IntToStr(Ord(eoLineNo)) + ' ' + eoLine1 + ' ' + eoLine2 +
                     ' ' + IntToStr(eoInstance) + ' ' + IntToStr(eoMsgInstance);
                end;
       end; //Case
       if Locked then
         s := s + ' Locked';
       AList.Add(s);
       Res := Find_Rec(B_GetNext {+ B_SingNWLock}, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
       if Res in [84, 85] then
       begin
         Res := Find_Rec(B_GetNext, F[LineF],LineF,RecPtr[LineF]^, ellIdxElert, KeyS);
         Locked := True;
       end
       else
         Locked := False;

    end;

    if Res in [9, 4, 84, 85] then
      Result := 0
    else
      Result := Res;

  end;

  AList.Add(' ');
  AList.Add('========================================================');
  AList.Add(' ');

  begin
    //Copy records from elerts file
    Res := Find_Rec(B_GetFirst {+ B_SingNWLock}, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
    if Res in [84, 85] then
    begin
      Res := Find_Rec(B_GetFirst, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
      Locked := True;
    end
    else
      Locked := False;

    while (Res in  [0,  84, 85])  do
    begin
      with ElertRec do
       s := elUserID + elElertName + ' ' + elType + ' ' + elDescription;
       if Locked then
         s := s + ' Locked';
       AList.Add(s);
       Res := Find_Rec(B_GetNext {+ B_SingNWLock}, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
       if Res in [84, 85] then
       begin
         Res := Find_Rec(B_GetNext, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
         Locked := True;
       end
       else
         Locked := False;

    end;

    if Res in [9, 4, 84, 85] then
      Result := 0
    else
      Result := Res;

  end;

end;

procedure TElertObject.SetDataPointer(Value : PElertRec);
begin
  FDataPointer := Value;
end;

function TElertObject.GetTermChar : Char;
begin
  Result := FDataPointer^.elTermChar;
end;

procedure TElertObject.SetTermChar(Value : Char);
begin
  FDataPointer^.elTermChar := Value;
end;

procedure TElertBaseObject.DeleteTempRecs(WhichType : Char);
var
  Res : SmallInt;
  KeyS : String[255];
begin
    FillChar(KeyS, SizeOf(KeyS), #0);
    KeyS := WhichType + LJVar(FUserID, 10) + LJVar(FElertName, 30);
    Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
    while (Res = 0) and (LineRec.RecsSent.ersUserID = FUserID) and
                        (LineRec.RecsSent.ersElertName = FElertName) and
                        (LineRec.Prefix = WhichType) do
    begin
       Res := Delete_Rec(F[LineF],LineF, ellIdxLineType);

       if Res = 0 then
         Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
    end;
end;



procedure TElertObject.Purge(Opts : Byte);
var
  Res : SmallInt;
  Pos : longint;
  KeyS : String[255];
begin
  if UsingSQL then
    PurgeSQL(Opts)
  else
  begin
    if Opts and poHistory = poHistory then
      DeleteTempRecs(pxElRecsSent);

    if Opts and poEvents = poEvents then
      DeleteTempRecs(pxElEvent);

    if Opts and poCurrentOutput = poCurrentOutput then
    begin
      DeleteTempRecs(pxElRespawn);
      DeleteTempRecs(pxTriggered);
      FillChar(KeyS, SizeOf(KeyS), #0);
      KeyS := pxElOutput + LJVar(FUserID, 10) + LJVar(FElertName, 30);
      Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
      while (Res = 0) and (LineRec.Output.eoUserID = FUserID) and
                          (LineRec.Output.eoElertName = FElertName) and
                          (LineRec.Prefix = pxElOutput) do
      begin
        if LineRec.Output.eoOutputType in Outputs2Go then
          Res := Delete_Rec(F[LineF],LineF, ellIdxLineType);

        if Res = 0 then
           Res := Find_Rec(B_GetNext, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
      end;
    end;
  end;
  {$IFDEF EN551p}
  ResetQueryTick(FDataPointer^);
  {$ENDIF}
  RunNow := False;
  WorkStation := '';
  FDataPointer^.elEmailRetriesNotified := False;
  FDataPointer^.elSMSRetriesNotified := False;
  FDataPointer^.elStatus := 0;
end;

procedure TElertObject.Clear;
begin
  FillChar(FDataPointer^, SizeOf(ElertRec), #0);
end;

function TElertObject.StatusString : ShortString;
var
  FileType : string;
begin
   if FDataPointer^.elRunNow then
     Result := 'Waiting to run'
   else
   if FDataPointer^.elSMSRetriesNotified and FDataPointer^.elEmailRetriesNotified then
     Result := 'Error sending both'
   else
   if FDataPointer^.elSMSRetriesNotified then
     Result := 'Error sending SMS'
   else
   if FDataPointer^.elEmailRetriesNotified then
     Result := 'Error sending Email'
   else
   begin
     if FDataPointer^.elDBF then
       FileType := 'DBF'
     else
     Case FDataPointer^.elExRepFormat of
        2  : FileType := 'HTML';
        3  : FileType := 'XLS';
        else
          FileType := 'CSV';
     end; //Case

     Case Status of
       esIdle                     : Result := 'Idle';
       esInProcess                : Result := 'Running query';
       esSMSReadyToGo             : Result := 'SMS ready to go';
       esEmailReadyToGo           : Result := 'Email ready to go';
       esBothReadyToGo            : Result := 'Both ready to go';
       esInSendProcess            : Result := 'Sending messages';
       esReportToRun              : Result := 'Report ready to run';
       esReportEmailReadyToGo     : Result := 'Report ready to email';
       esFaxReadyToGo             : Result := 'Report ready to fax';
       esReportBothReadyToGo      : Result := 'Report ready to send';
       esCopyReadyToGo            : Result :=  FileType + ' File ready to save to folder';
       esFTPReadyToGo             : Result :=  FileType + ' File ready to send by FTP';
       esCSVEmailReadyToGo        : Result :=  FileType + ' File ready to send by Email';
       esFTPAndCopyReadyToGo,
       esCopyAndEmailReadyToGo,
       esFTPandEmailReadyToGo,
       esAllCSVReadyToGo          : Result :=  FileType + ' File ready to send';

       else
         Result := 'Unknown';
     end;
   end;
end;

procedure TElertObject.ClearRetryFlags;
begin
  EmailRetries := 0;
  EmailRetriesNotified := False;
  SMSRetries := 0;
  SMSRetriesNotified := False;
  FTPRetries := 0;
  FTPRetriesNotified := False;
  FaxRetries := 0;
  FaxRetriesNotified := False;
end;



function TElertObject.GetDocName : ShortString;
begin
  Result := FDataPointer^.elDocName;
end;

procedure TElertObject.SetDocName(const Value : ShortString);
begin
  FDataPointer^.elDocName := Value;
end;

function TElertObject.GetString(Index : Integer) : ShortString;
begin
  Case Index of
    1  : Result := FDataPointer^.elRepFolder;
    2  : Result := FDataPointer^.elFTPSite;
    3  : Result := FDataPointer^.elFTPUserName;
    4  : Result := FDataPointer^.elFTPPassword;
    5  : Result := FDataPointer^.elCSVFileName;
    6  : Result := FDataPointer^.elUploadDir;
    7  : Result := FDataPointer^.elWorkStation;
    8  : Result := FDataPointer^.elNewReportName;
  end;
end;

procedure TElertObject.SetString(Index : Integer; const Value : ShortString);
begin
  Case Index of
    1  : FDataPointer^.elRepFolder := Value;
    2  : FDataPointer^.elFTPSite := Value;
    3  : FDataPointer^.elFTPUserName := Value;
    4  : FDataPointer^.elFTPPassword := Value;
    5  : FDataPointer^.elCSVFileName := Value;
    6  : FDataPointer^.elUploadDir := Value;
    7  : FDataPointer^.elWorkStation := Value;
    8  : FDataPointer^.elNewReportName := Value;
  end;
end;

function TElertObject.CanRunPercent(ERec : TEnginesRunningRec) : Byte;
//ERec tells us the capabilities of the engines currently running
// the function returns an integer between 0 & 100 being the percentage
//of the sentinel that can be completed.
var
  CanRunAtAll : boolean;
  TransportCount, WantedCount : byte;
begin
  CanRunAtAll := ((Priority = elpHigh) and (ERec.HighPriority)) or
                 ((Priority = elpLow) and (ERec.LowPriority));

  CanRunAtAll := CanRunAtAll and (ActionReport and ERec.Reports) or
                                 (not ActionReport and ERec.Alerts);

  if not CanRunAtAll then
    Result := 0
  else
  begin
    TransportCount := 0;
    if ActionReport and not ActionCSV then
    begin
      WantedCount := 2;
      if ActionRepEmail then
      begin
        if ERec.Email then inc(TransportCount);
      end
      else
        dec(WantedCount);

      if ActionRepFax then
      begin
        if ERec.Fax then inc(TransportCount);
      end
      else
        Dec(WantedCount);
    end  //report
    else
    if ActionCSV then
    begin
      WantedCount := 3;
      if CSVByEmail then
      begin
        if ERec.Email then inc(TransportCount);
      end
      else
        dec(WantedCount);

      if CSVByFTP then
      begin
        if ERec.FTP then inc(TransportCount);
      end
      else
        Dec(WantedCount);

      if CSVToFolder then   //if we can run the report at all then we can save it to a file
        inc(TransportCount)
      else
        Dec(WantedCount);

    end  //csv
    else
    begin //Alert
      WantedCount := 2;
      if ActionEmail then
      begin
        if ERec.Email then inc(TransportCount);
      end
      else
        dec(WantedCount);

      if ActionSMS then
      begin
        if ERec.SMS then inc(TransportCount);
      end
      else
        Dec(WantedCount);

    end; //Alert

    if WantedCount = 0 then
      Result := 100
    else
      Result := (TransportCount * 100) div WantedCount;


  end;//can run at all
end;//proc








{---------------------------- Event methods --------------------------------}

constructor TEvent.Create;
begin
  inherited Create;
  FFileNo := LineF;
  FData := @LineRec;
  FDataSize := SizeOf(LineRec);
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
  FPrefix := pxElEvent;
  OpenFile;
end;

constructor TEvent.CreateNoFile;
begin
  inherited Create;
  FFileNo := LineF;
  FData := @LineRec;
  FDataSize := SizeOf(LineRec);
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
  FPrefix := pxElEvent;
end;


function TEvent.GetKey : ShortString;
begin
  Result := FDataPointer^.evKey;
end;

procedure TEvent.SetKey(const Value : ShortString);
begin
  FDataPointer^.evKey := LJVar(Value, 255);
end;

function TEvent.GetInstance : SmallInt;
begin
  Result := FDataPointer^.evInstance;
end;

procedure TEvent.SetInstance(const Value : SmallInt);
begin
  FDataPointer^.evInstance := Value;
end;

function TEvent.GetFileNo : Byte;
begin
  Result := FDataPointer^.evFileNo;
end;

procedure TEvent.SetFileNo(Value : Byte);
begin
  FDataPointer^.evFileNo := Value;
end;

function TEvent.GetLongInt(Index : integer) : longint;
begin
  Case Index of
    0  : Result := FDataPointer^.evWinID;
    1  : REsult := FDataPointer^.evHandID;
  end;
end;


procedure TEvent.SetLongInt(Index : integer; Value : longint);
begin
  Case Index of
    0  : FDataPointer^.evWinID := Value;
    1  : FDataPointer^.evHandID := Value;
  end;

end;


function TElertObject.RemoveDateSep(const s : string) : String;
var
  i : integer;
begin
  i := 1;
  Result := s;
  while i < Length(Result) do
    if Result[i] = DateSeparator then
      System.Delete(Result, i, 1)
    else
      inc(i);
end;

constructor TSysRec.Create(const APath : string);
begin
  inherited Create;
  FFileNo := LineF;
  FData := @LineRec;
  FDataSize := SizeOf({LineRec}TElertOutputLine) + 1;
  FDataPointer := Pointer(Longint(@FDataBuffer) + 1);
  FPrefix := pxSysRec;
  Findex := 0;
//  OpenFile;
end;

function TSysRec.OpenFile : SmallInt;
var
  OpenStatus : SmallInt;

begin
//Define 'CreateFiles' to allow the program to create blank dat files.
  OpenStatus := 0;
{$IFDEF CreateFiles} // Only used in-house for creating empty files.
  if not FileExists(GetEnterpriseDirectory + SysFileName) then
  begin
    OpenStatus :=
       Make_File(FVar,GetEnterpriseDirectory + SysFileName, FileSpecOfs[FFileNo]^,FileSpecLen[FFileNo]);
  end;
{$ENDIF}

  if OpenStatus = 0 then
  begin
    OpenStatus := Open_File(FVar,GetEnterpriseDirectory + SysFileName, 0);
  end;

  if OpenStatus = 0 then
    FFileOpen := True;

  Result := OpenStatus;  //if open failed then exception is raised by calling proc
end;

function TSysRec.CloseFile : SmallInt;
begin
   if FFileOpen then
     Close_File(FVar);
   FFileOpen := False;
end;

function TSysRec.FindRec(const SearchKey : string; SearchType : Byte;
                                       Lock : Boolean) : SmallInt;
//Find record and load into data buffer
var
  KeyS : string[255];
  BtrieveMode  : integer;
  TempString : string[10];
  RefString  : String[30];
  TempChar : Char;
begin
  FillChar(KeyS[1], 255, #32);
  KeyS := BuildSearchKey(SearchKey);
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
  Result := Find_Rec(SearchType + B_MultNWLock, FVar,FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
  if Result = 0 then
    MoveDataForRead;
  //Get lock if necessary
{  if Lock and (Result = 0) then
  begin
    Result := LockRecord;
    if Result = 0 then
      MoveDataForRead;
  end;}

end;

function TSysRec.GetEngineCounter : longint;
begin
  Result := FDataPointer^.eoEngineCounter;
end;



{ TTriggered }

function TTriggered.BuildSearchKey(const Key: string): ShortString;
begin
  Result := FPrefix + Key;
end;

constructor TTriggered.Create;
begin
  inherited;
  FSegmented := False;
  FPrefix := pxTriggered;
end;

function TTriggered.DeleteInstTempRecs(WhichType: Char;  WhichInstance : longint) : Integer;
var
  Res : SmallInt;
  KeyS : String[255];
begin
  Result := 0;
  if UsingSQL then
    DeleteInstTempRecsSQL(WhichType, WhichInstance)
  else
  begin
    FillChar(KeyS, SizeOf(KeyS), #0);
    KeyS := WhichType + LJVar(FUserID, 10) + LJVar(FElertName, 30);
    Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxOutputType, KeyS);
    while (Res = 0) and (LineRec.RecsSent.ersUserID = FUserID) and
                        (LineRec.RecsSent.ersElertName = FElertName) and
                        (LineRec.Prefix = WhichType) and
                        (LineRec.Output.eoInstance = WhichInstance) do
    begin
       Res := Delete_Rec(F[LineF],LineF, ellIdxOutputType);
       Result := Res;
       if Res = 0 then
         Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxOutputType, KeyS);
    end;
  end;
end;

procedure TElertObject.PurgeSQL(Opts: Byte);
const
  OutputsToGoString = '(OutputType = ''M'' OR OutputType = ''J'' OR OutputType = ''I'' OR OutputType = ''D'' OR OutputType = ''O'' OR ' +
                      'OutputType = ''V'' OR OutputType = ''U'' OR OutputType = ''K'' OR OutputType = ''Q'')';
var
  WhereClause : AnsiString;
  Res : Integer;
begin
  WhereClause := StandardWhereClause + ' AND (';
  if Opts and poHistory = poHistory then
    WhereClause := WhereClause + 'Prefix = ''' + pxElRecsSent + ''' OR ';

  if Opts and poEvents = poEvents then
    WhereClause := WhereClause + 'Prefix = ''' + pxElEvent + ''' OR ';

  if Opts and poCurrentOutput = poCurrentOutput then
  begin
    WhereClause := WhereClause + 'Prefix = ''' + pxElRespawn + ''' OR ';
    WhereClause := WhereClause + 'Prefix = ''' + pxTriggered + ''' OR ';

    WhereClause := WhereClause + '(Prefix = ''' + pxElOutput + ''' AND ' + OutputsToGoString + '))';
  end;

  if WhereClause[Length(WhereClause)] <> ')' then
  begin
    System.Delete(WhereClause, Length(WhereClause) - 3, 4);
    WhereClause := WhereClause + ')';
  end;

  Res := DeleteRows(FCompanyCode, 'SENTLINE.DAT', WhereClause);
  if Res <> 0 then
    ShowMessage('Unable to purge records. Error ' + IntToStr(Res) + '. Check log folder for details');
end;

function TElertBaseObject.StandardWhereClause: string;
begin
  Result := 'UserID = '+ QuotedStr(FUserID) + ' AND Name = ' + QuotedStr(FElertName);
end;

procedure TElertObject.DeleteSQL;
var
  WhereClause : AnsiString;
begin
  WhereClause := StandardWhereClause;
  DeleteRows(FCompanyCode, 'SENTLINE.DAT', WhereClause);
end;

procedure TTriggered.DeleteInstTempRecsSQL(WhichType: Char;
  WhichInstance: Integer);
var
  WhereClause : AnsiString;
begin
  WhereClause := StandardWhereClause + ' AND Prefix = ' + QuotedStr(WhichType) + ' AND WhichInstance = ' + IntToStr(WhichInstance);
  DeleteRows(FCompanyCode, 'SENTLINE.DAT', WhereClause);
end;

procedure TElertBaseObject.DeleteTempRecsSQL(WhichType: Char);
var
  WhereClause : AnsiString;
begin
  WhereClause := StandardWhereClause + ' AND Prefix = ''' + WhichType + '''';
  DeleteRows(FCompanyCode, 'SENTLINE.DAT', WhereClause);
end;

function TSysRec.GetTimeStamp: TDateTime;
begin
  Result := FDataPointer^.SysTimeStamp;
end;

function TSysRec.Save: Smallint;
begin
  MoveDataForWrite;
  Result := Put_rec(FVar, FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TSysRec.UnlockRecord: SmallInt;
var
  KeyS : String[255];
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
   Result := Find_Rec(B_Unlock, FVar, FFileNo, RecPtr[FFileNo]^,
                        0, KeyS);
   if Result <> 0 then
     raise EBtrieveException.Create('Error ' + IntToStr(Result) + ' unlocking record');
end;

end.
