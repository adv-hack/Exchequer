unit AuthBase;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  AuthVar, BtrvU2, SysUtils, Dialogs;

type
  EPaException = Class(Exception)
    constructor Create(const Msg : ShortString; Sender : TObject = nil);
  end;

  EBtrieveException = Class(EPaException);
  EComTKException = Class(EPaException);
  EToolkitException = Class(EPaException);
  EEmailException = Class(EPaException);


{TAuthBaseObject is the base class for accessing the Purchase Authorisation tables.
 It should only be inherited from - never implemented.

 In descendant objects FFileNo is set to the appropriate file number,
 FData is set to point at the appropriate record (in AuthVar) and FDataSize
 is set to the size of that record.

 When data is read it is copied into the FDataBuffer array.  Descendant objects
 have a pointer (FDataPointer) which is of the appropriate type for the data
 record and points at the start of FDataBuffer, allowing data to be accessed
 easily by field name.

 BuildSearchKey is an abstract method which is overridden by descendants to
 create an appropriate search key based on the FIndex property.

 NOTE: before calling any of the get.. methods of the descendant objects, you must
 set the Company property to the appropriate Company Code}


  TAuthBaseObject = Class
  private
    FLockPos  : longint;
    FFileOpen : Boolean;
    FSegmented : Boolean; //does the file have a segmented key
  protected
    FIndex    : byte;
    FCompany  : String[6];
    FFileNo   : integer; //data file
    FDataBuffer  : Array [1..MaxPaRecSize] of Char;
    FData     : Pointer; //Pointer to appropriate data record
    FDataSize : integer; //Size of     "      "    "     "
    function FindRec(const SearchKey : string; SearchType : Byte;
                           Lock : Boolean) : SmallInt;
    procedure SetIndex(Value : Byte);
    procedure SetCompany(const Value : String);
    function GetCompany : string;
    function LockRecord : SmallInt;
    function UnlockRecord : SmallInt;
    function LJVar(const Value : String; len : integer) : String;
    procedure MoveDataForRead;
    procedure MoveDataForWrite;
    function BuildSearchKey(const Key : string) : ShortString; virtual; abstract;
    function TransType(const Trans : String) : SmallInt; virtual;
    function Encrypt(const s : ShortString) : ShortString;
    function Decrypt(const s : ShortString) : ShortString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetGreaterThanOrEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetFirst(Lock : Boolean = False) : SmallInt; virtual;
    function GetNext(Lock : Boolean = False) : SmallInt; virtual;
    function GetLessThan(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetLast(Lock : Boolean = False) : SmallInt; virtual;
    function GetPrevious(Lock : Boolean = False) : SmallInt; virtual;
    function OpenFile : SmallInt; virtual;
    function CloseFile : SmallInt; virtual;
    function Add : smallInt; virtual;
    function Delete : SmallInt; virtual;
    function Save : Smallint;
    function Cancel : Smallint;
    property Index : Byte read FIndex write SetIndex;
    property Company : String read GetCompany write SetCompany;
  end;


  TPaAuthorizer = Class(TAuthBaseObject)
  private
    FDataPointer : ^TPaAuthorizerRec;
  protected
    function GetName : string;
    procedure SetName(const Value : string);
    function GetEmail : string;
    procedure SetEmail(const Value : string);
    function GetDisplayEmail : string;
    procedure SetDisplayEmail(const Value : string);
    function GetAuthCode : string;
    procedure SetAuthCode(const Value : string);
    function GetMaxAuthAmount : Double;
    procedure SetMaxAuthAmount(Value : Double);
    function GetBool(Index : integer) : Boolean;
    procedure SetBool(Index : integer; Value : Boolean);
    function GetDefaultAuth : string;
    procedure SetDefaultAuth(const Value : string);
    function BuildSearchKey(const Key : string) : ShortString; override;
    function GetAlternate : string;
    procedure SetAlternate(const Value : string);
    function GetAltAfter : Smallint;
    procedure SetAltAfter(Value : SmallInt);
  public
    Constructor Create;
    function DoubleToKey(Value : Double) : string;
    function GetGreaterThanOrEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt; override;
    function Add : smallInt; override;
    function CanAuthorize(const Trans : string) : Boolean;
    function GetLast(Lock : Boolean = False) : SmallInt; override;
    property Name : string read GetName write SetName;
    property Email : string read GetEmail write SetEmail;
    property DisplayEmail : string read GetDisplayEmail write SetDisplayEmail;
    property AuthCode : string read GetAuthCode write SetAuthCode;
    property MaxAuthAmount : Double read GetMaxAuthAmount write SetMaxAuthAmount;
    property AuthSQU : Boolean index 1 read GetBool write SetBool;
    property AuthPQU : Boolean index 2 read GetBool write SetBool;
    property AuthPOR : Boolean index 3 read GetBool write SetBool;
    property AuthPIN : Boolean index 4 read GetBool write SetBool;
    property Active  : Boolean index 5 read GetBool write SetBool;
    property ApprovalOnly : Boolean index 6 read GetBool write SetBool;
    property CompressAttachments : Boolean index 7 read GetBool write SetBool;
    property DefaultAuthoriser : string read GetDefaultAuth write SetDefaultAuth;
    property Alternate : string read GetAlternate write SetAlternate;
    property AltAfter  : SmallInt read GetAltAfter write SetAltAfter;
    property AltHours  : Boolean index 8 read GetBool write SetBool;
  end;

  TPaUser = Class(TAuthBaseObject)
  private
    FDataPointer : ^TPaUserRec;
  protected
    function GetUserID : string;
    procedure SetUserID(const Value : string);
    function GetUserName : string;
    procedure SetUserName(const Value : string);
    function GetUserEmail : string;
    procedure SetUserEmail(const Value : string);
    function GetString(Index : Integer) : string;
    procedure SetString(Index : integer; Value : string);
    function GetFloorLimit : Double;
    procedure SetFloorLimit(Value : Double);
    function GetAuthAmount : Double;
    procedure SetAuthAmount(Value : Double);
    function GetSendOptions : Char;
    procedure SetSendOptions(Value : Char);
    function BuildSearchKey(const Key : string) : ShortString; override;
  public
    Constructor Create;
    property UserID : string read GetUserID write SetUserID;
    property UserName : string read GetUserName write SetUserName;
    property UserEmail : string read GetUserEmail write SetUserEmail;
    property FloorLimit : Double read GetFloorLimit write SetFloorLimit;
    property AuthAmount : Double read GetAuthAmount write SetAuthAmount;
    property SendOptions : Char read GetSendOptions write SetSendOptions;
    property DefaultApprover : string Index 0 read GetString write SetString;
    property DefaultAuthoriser : string Index 1 read GetString write SetString;
  end;

  TPaRequest = Class(TAuthBaseObject)
  private
    FDataPointer : ^TpaRequestRec;
  protected
    function GetEAR : string;
    procedure SetEAR(const Value : string);
    function GetOurRef : string;
    procedure SetOurRef(const Value : string);
    function GetUserID : string;
    procedure SetUserID(const Value : string);
    function GetTotalValue : Double;
    procedure SetTotalValue(Value : Double);
    function GetTimeStamp : TDateTime;
    procedure SetTimeStamp(Value : TDateTime);
    function GetStatus : TEarStatusType;
    procedure SetStatus(Value : TEarStatusType);
    function GetString(Index : Integer) : ShortString;
    procedure SetString(Index : Integer; const Value : ShortString);
    function GetFolio : longint;
    procedure SetFolio(Value : longint);
    function GetType : TEARDocType;
    procedure SetType(Value : TEARDocType);
    function GetLineCount : longint;
    procedure SetLineCount(Value : longint);
    function GetCheckSum : int64;
    procedure SetCheckSum(Value : Int64);
    function GetApprovalDateTime : TDateTime;
    procedure SetApprovalDateTime(Value : TDateTime);
    function GetAdminNotified : Boolean;
    procedure SetAdminNotified(Value : Boolean);
    function GetAlreadySent : Boolean;
    procedure SetAlreadySent(Value : Boolean);
    function BuildSearchKey(const Key : string) : ShortString; override;
  public
    Constructor Create;
    function MakeEmailSubjectString : string;
    function DateAsString : string;
    function StatusString : ShortString;
    function DocTypeFromOurRef(const SRef : ShortString) : TEARDocType;
    property EAR : string read GetEAR write SetEAR;
    property OurRef : string read GetOurRef write SetOurRef;
    property UserID : string read GetUserID write SetUserID;
    property TotalValue : Double read GetTotalValue write SetTotalValue;
    property TimeStamp : TDateTime read GetTimeStamp write SetTimeStamp;
    property Status : TEarStatusType read GetStatus write SetStatus;
    property ApprovedBy : ShortString Index 1 read GetString write SetString;
    property Authoriser : ShortString Index 2 read GetString write SetString;
    property Supplier : ShortString index 3 read GetString write SetString;
    property Folio : longint read GetFolio write SetFolio;
    property DocType : TEARDocType read GetType write SetType;
    property LineCount : longint read GetLineCount write SetLineCount;
    property AlreadySent : Boolean read GetAlreadySent write SetAlreadySent;
    property PrevDate : ShortString Index 4 read GetString write SetString;
    property CheckSum : Int64 read GetCheckSum write SetCheckSum;
    property ApprovalDateTime : TDateTime read GetApprovalDateTime
                                          write SetApprovalDateTime;
    property AdminNotified : Boolean read GetAdminNotified
                                     write SetAdminNotified;
  end;

  TPaGlobalParams = Class(TAuthBaseObject)
  private
    FDataPointer : ^TpaGlobalSysParams;
  protected
    function GetFrequency : SmallInt;
    procedure SetFrequency(Value : SmallInt);
    function GetAccountName : string;
    procedure SetAccountName(const Value : string);
    function GetAccountPWord : string;
    procedure SetAccountPWord(const Value : string);
    function GetEmail : string;
    procedure SetEmail(const Value : string);
    function GetAdminEmail : string;
    procedure SetAdminEmail(const Value : string);
    function GetOfflineStart : TDateTime;
    procedure SetOfflineStart(Value : TDateTime);
    function GetOfflineFinish : TDateTime;
    procedure SetOfflineFinish(Value : TDateTime);
    function GetEARTimeOut : SmallInt;
    procedure SetEARTimeOut(Value : SmallInt);
    function GetAdminPassword : ShortString;
    procedure SetAdminPassword(const Value : ShortString);
    function GetUseMapi : Boolean;
    procedure SetUseMapi(Value : Boolean);
    function BuildSearchKey(const Key : string) : ShortString; override;
    function GetServer : string;
    procedure SetServer(const Value : string);
  public
    Constructor Create;
    function GetFirst(Lock : Boolean = False) : SmallInt; override;
    property Frequency : SmallInt read GetFrequency write SetFrequency;
    property AccountName : string read GetAccountName write SetAccountName;
    property AccountPassword  : string read GetAccountPWord write SetAccountPWord;
    property Email : string read GetEmail write SetEmail;
    property AdminEmail : string read GetAdminEmail write SetAdminEmail;
    property OfflineStart : TDateTime read GetOfflineStart write SetOfflineStart;
    property OfflineFinish : TDateTime read GetOfflineFinish write SetOfflineFinish;
    property EARTimeout : SmallInt read GetEARTimeout write SetEARTimeout;
    property AdminPassword : ShortString read GetAdminPassword write SetAdminPassword;
    property Server : String read GetServer write SetServer;
    property UseMapi : Boolean read GetUseMapi write SetUseMapi;
  end;

  TPaCompanyParams = Class(TAuthBaseObject)
  private
    FDataPointer : ^TpaCompanySysParams;
    function GetLastPINCheck: TDateTime;
    procedure SetLastPINCheck(const Value: TDateTime);
    function GetPINCheckInterval: SmallInt;
    procedure SetPINCheckInterval(const Value: SmallInt);
  protected
    function GetBool(Index : Integer) : Boolean;
    procedure SetBool(Index : integer; Value : Boolean);
    function GetString(Index : Integer) : String;
    procedure SetString(Index : integer; Value : String);
    function GetAuthMode : TAuthModeType;
    procedure SetAuthMode(Value : TAuthModeType);
    function GetPINTolerance : Double;
    procedure SetPINTolerance(Value : Double);
    function BuildSearchKey(const Key : string) : ShortString; override;
  public
    Constructor Create;
    function FormName(const TransRef : string) : string;
    property AuthSQU : Boolean Index 1 read GetBool write SetBool;
    property AuthPQU : Boolean Index 2 read GetBool write SetBool;
    property AuthPOR : Boolean Index 3 read GetBool write SetBool;
    property AuthPIN : Boolean Index 4 read GetBool write SetBool;
    property SQUForm : String Index 1 read GetString write SetString;
    property PQUForm : String Index 2 read GetString write SetString;
    property PORForm : String Index 3 read GetString write SetString;
    property PINForm : String Index 4 read GetString write SetString;
    property AuthMode : TAuthModeType read GetAuthMode write SetAuthMode;
    property AllowPrint : Boolean index 5 read GetBool write SetBool;
    property FloorOnPins : Boolean index 6 read GetBool write SetBool;
    property AuthOnConvert : Boolean index 7 read GetBool write SetBool;
    property PINTolerance : Double read GetPINTolerance write SetPINTolerance;
    property LastPINCheck : TDateTime read GetLastPINCheck write SetLastPINCheck;
    property PINCheckInterval : SmallInt read GetPINCheckInterval write SetPINCheckInterval;
  end;

//-------------------------------------------------------------------------//



implementation

uses
{$IFNDEF AUTHINT}
  AuthObjs,
{$ENDIF}
{$IFDEF EXSQL}
  SqlUtils,
{$ENDIF}
  Crypto;


constructor TAuthBaseObject.Create;
begin
  inherited Create;
  FIndex := 0;
  FCompany := '';
  FillChar(FDataBuffer, MaxPaRecSize, #0);
  FSegmented := True;
end;

destructor TAuthBaseObject.Destroy;
begin
  CloseFile;
  inherited Destroy;
end;

function TAuthBaseObject.GetEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetEq, Lock);
end;

function TAuthBaseObject.GetFirst(Lock : Boolean = False) : SmallInt;
begin
//Company is already set, so we want to use GetGEq to get the first record of that company
  Result := FindRec('', B_GetGEq, Lock);
end;

function TAuthBaseObject.GetLast(Lock : Boolean = False) : SmallInt;
begin
//Company is already set, so we want to use GetLessEq to get the last record of that company
  Result := FindRec(#255, B_GetLessEq, Lock);
end;


function TAuthBaseObject.GetGreaterThanOrEqual(const SearchKey : string;
                                               Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetGEq, Lock);
end;

function TAuthBaseObject.GetNext(Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec('', B_GetNext, Lock);
end;

function TAuthBaseObject.Add : smallInt;
var
  i : integer;
begin
  Move(FCompany[0], FDataBuffer[1], 7);
  MoveDataForWrite;
  Result := Add_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TAuthBaseObject.Delete : SmallInt;
begin
  Result := Delete_Rec(F[FFileNo], FFileNo, FIndex);
end;

function TAuthBaseObject.FindRec(const SearchKey : string; SearchType : Byte;
                                       Lock : Boolean) : SmallInt;
//Find record and load into data buffer
var
  KeyS : string[255];
  BtrieveMode  : integer;
  TempString : string[6];
begin
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
  FillChar(KeyS[1], 255, #32);
  KeyS := BuildSearchKey(SearchKey);
  Result := Find_Rec(SearchType, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
  if Result = 0 then
  begin
    if FSegmented and (SearchType in [B_GetGEq, B_GetNext, B_GetPrev, B_GetLess, B_GetLessEq]) then
    begin
    //Move company code into tempstring for comparision
      Move(FData^, TempString[0], 7);
      if (FCompany = TempString) then
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
  end;//Result := 0;

  //Get lock if necessary
  if Lock and (Result = 0) then
  begin
    Result := LockRecord;

    if Result <> 0 then
      ShowMessage('Record is locked by another workstation');
  end;
end;

procedure TAuthBaseObject.SetIndex(Value : Byte);
begin
  FIndex := Value
end;

function TAuthBaseObject.Save : Smallint;
begin
  MoveDataForWrite;
  Result := Put_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TAuthBaseObject.Cancel : Smallint;
begin
  UnlockRecord;
end;

procedure TAuthBaseObject.SetCompany(const Value : String);
begin
  FCompany := LJVar(Value, 6);
end;

function TAuthBaseObject.GetCompany : string;
begin
  Result := FCompany;
end;


function TAuthBaseObject.LockRecord : Smallint;
begin
  Result := GetPos(F[FFileNo], FFileNo, FLockPos);

  if Result = 0 then
  begin
    Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
    Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex,
                       B_SingLock + B_SingNWLock);
    if Result = 0 then
      MoveDataForRead;
  end;
end;

function TAuthBaseObject.UnlockRecord : Smallint;
var
  KeyS : String[255];
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
   Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^,
                        0, KeyS);
   if Result <> 0 then
     raise EBtrieveException.Create('Error ' + IntToStr(Result) + ' unlocking record');
end;

function TAuthBaseObject.LJVar(const Value : String; len : integer) : String;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;

function TAuthBaseObject.OpenFile : SmallInt;
var
  OpenStatus : SmallInt;

begin
//Change from creating data files - we'll supply blank files in install to
//avoid problems with permissions

  OpenStatus := 0;
  {$IFDEF EXSQL}
  if not TableExists(FileNames[FFileNo]) then
  {$ELSE}
  if not FileExists(FileNames[FFileNo]) then
  {$ENDIF}
  begin
    OpenStatus := Make_File(F[FFileNo],FileNames[FFileNo], FileSpecOfs[FFileNo]^,FileSpecLen[FFileNo]);
  end;

  if OpenStatus = 0 then
  begin
    OpenStatus := Open_File(F[FFileNo], FileNames[FFileNo], 0);
  end;

  if OpenStatus = 0 then
    FFileOpen := True;

  Result := OpenStatus;  //if open failed then exception is raised by calling proc
end;

function TAuthBaseObject.CloseFile : SmallInt;
begin
   if FFileOpen then
     Close_File(F[FFileNo]);
   FFileOpen := False;
end;

procedure TAuthBaseObject.MoveDataForRead;
//Moves data from data record to FDataBuffer
begin
  Move(FData^, FDataBuffer, FDataSize);
  Move(FDataBuffer, FCompany, 7);
end;

procedure TAuthBaseObject.MoveDataForWrite;
//Moves data from FDataBuffer to data record for writing to table
begin
  Move(FCompany[0], FDataBuffer[1], 7);
  Move(FDataBuffer, FData^, FDataSize);
end;


function TAuthBaseObject.TransType(const Trans : String) : SmallInt;
var
  s : string;
begin
  s := UpperCase(Copy(Trans, 1, 3));
  if s = 'SQU' then
    Result := 1
  else
  if s = 'PQU' then
    Result := 2
  else
  if s = 'POR' then
    Result := 3
  else
  if s = 'PIN' then
    Result := 4
  else
    Result := 0;
end;

function TAuthBaseObject.GetLessThan(const SearchKey : string; Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetLess, Lock);
end;

function TAuthBaseObject.GetPrevious(Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec('', B_GetPrev, Lock);
end;

function TAuthBaseObject.Encrypt(const s : ShortString) : ShortString;
var
  i : Byte;
begin
  if Length(s) = 0 then
    Result := ''
  else
  begin
    Result := s;
    for i := 1 to Length(s) do
      Result[i] := Char(Ord(s[i]) xor i);
  end;
end;

function TAuthBaseObject.Decrypt(const s : ShortString) : ShortString;
begin
  Result := Encrypt(s);
end;

procedure TAuthBaseObject.Clear;
begin
  FillChar(FCompany, SizeOf(FCompany), #0);
  FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
end;


//--------------Authoriser methods -----------------------------------------------
constructor TPaAuthorizer.Create;
begin
  inherited Create;
  FFileNo := AuthF;
  FData := @AuthRec;
  FDataSize := SizeOf(AuthRec);
  FDataPointer := @FDataBuffer;
  FDataPointer^.Active := True; //default
end;

function TPaAuthorizer.GetName : string;
begin
  Result := Trim(FDataPointer^.auName);
end;

procedure TPaAuthorizer.SetName(const Value : string);
begin
  FDataPointer^.auName := LJVar(Value,60);
end;

function TPaAuthorizer.GetEmail : string;
begin
  Result := Trim(FDataPointer^.auEMail);
end;

procedure TPaAuthorizer.SetEmail(const Value : string);
begin
  FDataPointer^.auEMail := LJVar(Value, 100);
end;

function TPaAuthorizer.GetDisplayEmail : string;
begin
  Result := Trim(FDataPointer^.auDisplayEmail);
end;

procedure TPaAuthorizer.SetDisplayEmail(const Value : string);
begin
  FDataPointer^.auDisplayEmail := LJVar(Value, 100);
end;


function TPaAuthorizer.GetDefaultAuth : string;
begin
  Result := Trim(FDataPointer^.auDefaultAuth);
end;

procedure TPaAuthorizer.SetDefaultAuth(const Value : string);
begin
  FDataPointer^.auDefaultAuth := LJVar(Value,60);
end;

function TPaAuthorizer.GetAuthCode : string;
begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    Result := Trim(Decode(FDataPointer^.auAuthCode))
  else
{$ENDIF}
    Result := Trim(FDataPointer^.auAuthCode);
end;

procedure TPaAuthorizer.SetAuthCode(const Value : string);
begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    FDataPointer^.auAuthCode := Encode(LJVar(Value, 10))
  else
{$ENDIF}
    FDataPointer^.auAuthCode := LJVar(Value, 10);
end;

procedure TPaAuthorizer.SetAlternate(const Value : string);
begin
  FDataPointer^.auAlternate := LJVar(Value,30);
end;

function TPaAuthorizer.GetAlternate : string;
begin
  Result := Trim(FDataPointer^.auAlternate);
end;

procedure TPaAuthorizer.SetAltAfter(Value : SmallInt);
begin
  FDataPointer^.auAltAfter := Value;
end;

function TPaAuthorizer.GetAltAfter : SmallInt;
begin
  Result := FDataPointer^.auAltAfter;
end;


function TPaAuthorizer.GetMaxAuthAmount : Double;
begin
  Result := FDataPointer^.auMaxAuthAmount;
  Result := Result / 100;
end;

procedure TPaAuthorizer.SetMaxAuthAmount(Value : Double);
begin
  FDataPointer^.auMaxAuthAmount := Trunc(Value * 100);
end;

function TPaAuthorizer.GetBool(Index : integer) : Boolean;
begin
  Case Index of
    1 : Result := FDataPointer^.auAuthSQU;
    2 : Result := FDataPointer^.auAuthPQU;
    3 : Result := FDataPointer^.auAuthPOR;
    4 : Result := FDataPointer^.auAuthPIN;
    5 : Result := FDataPointer^.Active;
    6 : Result := FDataPointer^.auApprovalOnly;
    7 : Result := FDataPointer^.auCompressAttachments;
    8 : Result := FDataPointer^.auAltHours;
  end;
end;

procedure TPaAuthorizer.SetBool(Index : integer; Value : Boolean);
begin
  Case Index of
    1 :  FDataPointer^.auAuthSQU := Value;
    2 :  FDataPointer^.auAuthPQU := Value;
    3 :  FDataPointer^.auAuthPOR := Value;
    4 :  FDataPointer^.auAuthPIN := Value;
    5 :  FDataPointer^.Active := Value;
    6 :  FDataPointer^.auApprovalOnly := Value;
    7 :  FDataPointer^.auCompressAttachments := Value;
    8 :  FDataPointer^.auAltHours := Value;
  end;
end;

function TPaAuthorizer.BuildSearchKey(const Key : string) : ShortString;
begin
  Case FIndex of
    0 : Result := FCompany + LJVar(Key, 60);
    1 : Result := FCompany + Key + '!';
    2 : Result := FCompany + LJVar(Key, 100);
    3 : Result := FCompany + LJVar(Key, 10);
  end;
end;

function TPaAuthorizer.DoubleToKey(Value : Double) : string;
var
  TempString : String[8];
  TempInt : Int64;
  i : integer;
begin
  Value := Value * 100;
  TempInt := Trunc(Value);
  TempString[0] := #8;
  Move(TempInt, TempString[1], 8);

  Result := TempString;
end;

function TPaAuthorizer.GetGreaterThanOrEqual(const SearchKey : string;
                                               Lock : Boolean = False) : SmallInt;
var
  KeyS : string[255];
  BtrieveMode  : integer;
  TempStr : String[6];
  Found : Boolean;
begin //don't think i need this any more
{  if FIndex <> AuthValIdx then}
    Result := inherited GetGreaterThanOrEqual(SearchKey, Lock);
{  else
  begin
    Found := False;
    FillChar(FDataBuffer, SizeOf(FDataBuffer), #0);
    FillChar(KeyS[1], 255, #32);
    KeyS := SearchKey + '!';
    Result := Find_Rec(B_GetGEq, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
    while (Result = 0) and not Found do
    begin
      Move(FData^, TempStr, 7);
      if FCompany = TempStr then
        Found := True
      else
        Result := Find_Rec(B_GetNext, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);
    end;
    if Found then
      MoveDataForRead;
  end;}
end;

function TPaAuthorizer.Add : Smallint;
begin
  FDataPointer^.auEndAmountchar := '!';
  Result := inherited Add;
end;

function TPaAuthorizer.CanAuthorize(const Trans : string) : Boolean;
var
  i : integer;
begin
  i := TransType(Trans);
  if i > 0 then
    Result := GetBool(i)
  else
    Result := False;

  Result := Result and FDataPointer^.Active;
end;

function TPaAuthorizer.GetLast(Lock : Boolean = False) : SmallInt;
begin
  if FIndex = AuthValIdx then
    Result := FindRec(StringOfChar(#255, SizeOf(Int64)), B_GetLess, Lock)
  else
    Result := Inherited GetLast(Lock);
end;

//---------------User methods -------------------------------------------------
constructor TPaUser.Create;
begin
  inherited Create;
  FFileNo := UserF;
  FData := @UserRec;
  FDataSize := SizeOf(UserRec);
  FDataPointer := @FDataBuffer;
end;

function TPaUser.GetUserID : string;
begin
  Result := Trim(FDataPointer^.usUserID);
end;

procedure TPaUser.SetUserID(const Value : string);
begin
  FDataPointer^.usUserID := LJVar(Value, 10);
end;

function TPaUser.GetUserName : string;
begin
  Result := Trim(FDataPointer^.usUserName);
end;

procedure TPaUser.SetUserName(const Value : string);
begin
  FDataPointer^.usUserName := LJVar(Value, 30);
end;

function TPaUser.GetUserEmail : string;
begin
  Result := Trim(FDataPointer^.usEMail);
end;

procedure TPaUser.SetUserEmail(const Value : string);
begin
  FDataPointer^.usEMail := LJVar(Value, 100);
end;

function TPaUser.GetFloorLimit : Double;
begin
  Result := FDataPointer^.usFloorLimit;
end;

procedure TPaUser.SetFloorLimit(Value : Double);
begin
  FDataPointer^.usFloorLimit := Value;
end;

function TPaUser.GetAuthAmount : Double;
begin
  Result := FDataPointer^.usAuthAmount;
end;

procedure TPaUser.SetAuthAmount(Value : Double);
begin
  FDataPointer^.usAuthAmount := Value;
end;

function TPaUser.GetSendOptions : Char;
begin
  Result := FDataPointer^.usSendOptions;
end;

procedure TPaUser.SetSendOptions(Value : Char);
begin
  FDataPointer^.usSendOptions := Value;
end;

function TPaUser.GetString(Index : Integer) : string;
begin
  Case Index of
    0  : Result := FDataPointer^.usDefaultApprover;
    1  : Result := FDataPointer^.usDefaultAuthoriser;
  end;
end;

procedure TPaUser.SetString(Index : integer; Value : string);
begin
  Case Index of
    0  : FDataPointer^.usDefaultApprover := Value;
    1  : FDataPointer^.usDefaultAuthoriser := Value;
  end;
end;


function TPaUser.BuildSearchKey(const Key : string) : ShortString;
begin
  Result := FCompany + LJVar(Key, 10);
end;

//---------------Request methods ------------------------------------
constructor TPaRequest.Create;
begin
  inherited Create;
  FFileNo := RequestF;
  FData := @RequestRec;
  FDataSize := SizeOf(RequestRec);
  FDataPointer := @FDataBuffer;
end;

function TPaRequest.GetEAR : string;
begin
  Result := Trim(FDataPointer^.reEAR);
end;

procedure TPaRequest.SetEAR(const Value : string);
begin
  FDataPointer^.reEAR := LJVar(Value, 50);
end;

function TPaRequest.GetOurRef : string;
begin
  Result := Trim(FDataPointer^.reOurRef);
end;

procedure TPaRequest.SetOurRef(const Value : string);
begin
  FDataPointer^.reOurRef := LJVar(Value, 10);
end;

function TPaRequest.GetUserID : string;
begin
  Result := FDataPointer^.reUserID;
end;

procedure TPaRequest.SetUserID(const Value : string);
begin
  FDataPointer^.reUserID := LJVar(Value, 10);
end;

function TPaRequest.GetTotalValue : Double;
begin
  Result := FDataPointer^.reTotalValue;
end;

procedure TPaRequest.SetTotalValue(Value : Double);
begin
  FDataPointer^.reTotalValue := Value;
end;

function TPaRequest.GetTimeStamp : TDateTime;
var
  OldFmt, OldTimeFormat : string;
  TempStr : string;
begin
  OldFmt := ShortDateFormat;
  OldTimeFormat := ShortTimeFormat;

  TempStr := FDataPointer^.reTimeStamp;
  TempStr := Copy(TempStr, 7, 2) + '/' +
             Copy(TempStr, 5, 2) + '/' +
             Copy(TempStr, 3, 2) + ' ' + Copy(TempStr, 9, 2)
             + ':' + Copy(TempStr, 11, 2) ;
  ShortDateFormat := 'dd/mm/yy';
  ShortTimeFormat := 'hh:mm';
  Result := StrToDateTime(TempStr);
  ShortDateFormat := OldFmt;
  ShortTimeFormat := OldTimeFormat;
end;

procedure TPaRequest.SetTimeStamp(Value : TDateTime);
begin
  FDataPointer^.reTimeStamp := FormatDateTime('yyyymmddhhnn', Value);
end;


function TPaRequest.BuildSearchKey(const Key : string) : ShortString;
begin
  Case FIndex of
    ReqEARIdx    : Result := FCompany + LJVar(Key, 50);
    ReqDateIdx   : Result := FCompany + LJVar(Key, 12);
    ReqOurRefIdx : Result := FCompany + LJVar(Key, 10);
  end;
end;

function TPaRequest.MakeEmailSubjectString : string;
begin
  Result := EAR + '(AUTHCODE:xxxxxxxxxx)';
end;

function TPaRequest.DateAsString : string;
begin
  Result :=FDataPointer^.reTimeStamp;
end;

function TPaRequest.GetStatus : TEarStatusType;
begin
  Result := TEarStatusType(FDataPointer^.reStatus);
end;

procedure TPaRequest.SetStatus(Value : TEarStatusType);
begin
  FDataPointer^.reStatus := Ord(Value);
end;

function TPaRequest.GetString(Index : Integer) : ShortString;
begin
  Case Index of
    1 : Result := Trim(FDataPointer^.reApprovedBy);
    2 : Result := Trim(FDataPointer^.reAuthoriser);
    3 : Result := Trim(FDataPointer^.reSupplier);
    4 : Result := Trim(FDataPointer^.rePrevDate);
  end;
end;

procedure TPaRequest.SetString(Index : Integer; const Value : ShortString);
begin
  Case Index of
    1 : FDataPointer^.reApprovedBy := Value;
    2 : FDataPointer^.reAuthoriser := Value;
    3 : FDataPointer^.reSupplier := Value;
    4 : FDataPointer^.rePrevDate := Value;
  end;
end;

function TPaRequest.GetLineCount : longint;
begin
  Result := FDataPointer^.reLineCount;
end;

procedure TPaRequest.SetLineCount(Value : longint);
begin
  FDataPointer^.reLineCount := Value;
end;

function TPaRequest.GetCheckSum : int64;
begin
  Result := FDataPointer^.reCheckSum;
end;

procedure TPaRequest.SetCheckSum(Value : Int64);
begin
  FDataPointer^.reCheckSum := Value;
end;


function TPaRequest.StatusString : ShortString;
begin
  Case Status of
    esSentForApproval : Result := 'Sent for approval';
    esApprovedAndSent : Result := 'Approved. Sent for authorisation';
    esSentForAuth     : Result := 'Sent for authorisation';
    esReadyToSend     : Result := 'Ready to send for authorisation';
    esOrderWaitingForInvoice : Result := 'Waiting for invoice'; //not used
    esOKToAuthorise : Result := 'Waiting to authorise transaction';
    esAuthorised : Result := 'Authorised';
    esRejected        : Result := 'Rejected';
  end;
end;

function TPaRequest.GetFolio : longint;
begin
  Result := FDataPointer^.reFolio;
end;

procedure TPaRequest.SetFolio(Value : longint);
begin
  FDataPointer^.reFolio := Value;
end;

function TPaRequest.GetType : TEARDocType;
begin
  Result := TEARDocType(FDataPointer^.reDocType);
end;

procedure TPaRequest.SetType(Value : TEARDocType);
begin
  FDataPointer^.reDocType := Ord(Value);
end;

function TPaRequest.GetApprovalDateTime : TDateTime;
begin
  Result := FDataPointer^.reApprovalDateTime;
end;

procedure TPaRequest.SetApprovalDateTime(Value : TDateTime);
begin
  FDataPointer^.reApprovalDateTime := Value;
end;

function TPaRequest.GetAdminNotified : Boolean;
begin
  Result := FDataPointer^.reAdminNotified;
end;

procedure TPaRequest.SetAdminNotified(Value : Boolean);
begin
  FDataPointer^.reAdminNotified := Value;
end;

function TPaRequest.GetAlreadySent : Boolean;
begin
  Result := FDataPointer^.reAlreadySent;
end;

procedure TPaRequest.SetAlreadySent(Value : Boolean);
begin
  FDataPointer^.reAlreadySent := Value;
end;


function TPaRequest.DocTypeFromOurRef(const SRef : ShortString) : TEARDocType;
var
  s : String;
begin
  s := Copy(SRef, 1, 3);
  if s = 'PIN' then Result := edtPIN
  else
  if s = 'POR' then Result := edtPOR
  else
  if s = 'PQU' then Result := edtPQU
  else
  if s = 'SQU' then Result := edtSQU;
end;


//---------------GlobalParams  methods -----------------------------------------
constructor TPaGlobalParams.Create;
begin
  inherited Create;
  FFileNo := GlobalParamsF;
  FData := @GlobalParamsRec;
  FDataSize := SizeOf(GlobalParamsRec);
  FDataPointer := @FDataBuffer;
  FSegmented := False;
end;

function TPaGlobalParams.GetFrequency : SmallInt;
begin
  Result := FDataPointer^.spFrequency;
end;

procedure TPaGlobalParams.SetFrequency(Value : SmallInt);
begin
  FDataPointer^.spFrequency := Value;
end;

function TPaGlobalParams.GetAccountName : string;
begin
  Result := FDataPointer^.spAccountName;
end;

procedure TPaGlobalParams.SetAccountName(const Value : string);
begin
  FDataPointer^.spAccountName := Value;
end;

function TPaGlobalParams.GetAccountPWord : string;
begin
  Result := FDataPointer^.spAccountPWord;
end;

procedure TPaGlobalParams.SetAccountPWord(const Value : string);
begin
  FDataPointer^.spAccountPWord := Value;
end;

function TPaGlobalParams.GetAdminPassWord : Shortstring;
begin
  Result := Decrypt(FDataPointer^.spPassWord);
end;

procedure TPaGlobalParams.SetAdminPassWord(const Value : Shortstring);
begin
  FDataPointer^.spPassWord := Encrypt(Value);
end;

function TPaGlobalParams.GetEmail : string;
begin
  Result := FDataPointer^.spEMail;
end;

procedure TPaGlobalParams.SetEmail(const Value : string);
begin
  FDataPointer^.spEMail := Value;
end;

function TPaGlobalParams.GetServer : string;
begin
  Result := FDataPointer^.spServer;
end;

procedure TPaGlobalParams.SetServer(const Value : string);
begin
  FDataPointer^.spServer := Value;
end;

function TPaGlobalParams.GetAdminEmail : string;
begin
  Result := FDataPointer^.spAdminEMail;
end;

procedure TPaGlobalParams.SetAdminEmail(const Value : string);
begin
  FDataPointer^.spAdminEMail := Value;
end;

function TPaGlobalParams.GetOfflineStart : TDateTime;
begin
  Result := FDataPointer^.spOfflineStart;
end;

procedure TPaGlobalParams.SetOfflineStart(Value : TDateTime);
begin
  FDataPointer^.spOfflineStart := Value;
end;

function TPaGlobalParams.GetOfflineFinish : TDateTime;
begin
  Result := FDataPointer^.spOfflineFinish;
end;

procedure TPaGlobalParams.SetOfflineFinish(Value : TDateTime);
begin
  FDataPointer^.spOfflineFinish := Value;
end;

function TPaGlobalParams.GetEARTimeOut : SmallInt;
begin
  Result := FDataPointer^.spEARTimeOut;
end;

procedure TPaGlobalParams.SetEARTimeOut(Value : SmallInt);
begin
  FDataPointer^.spEARTimeOut := Value;
end;

function TPaGlobalParams.GetUseMapi : Boolean;
begin
  Result := FDataPointer^.spUseMapi;
end;

procedure TPaGlobalParams.SetUseMapi(Value : Boolean);
begin
  FDataPointer^.spUseMapi := Value;
end;

function TPaGlobalParams.BuildSearchKey(const Key : string) : ShortString;
begin
  Result := FCompany;
end;

function TPaGlobalParams.GetFirst(Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec('', B_GetFirst, Lock);
end;


//---------------Company Params
constructor TPaCompanyParams.Create;
begin
  inherited Create;
  FFileNo := CompanyParamsF;
  FData := @CompanyParamsRec;
  FDataSize := SizeOf(CompanyParamsRec);
  FDataPointer := @FDataBuffer;
  FSegmented := False;
end;

function TPaCompanyParams.GetBool(Index : integer) : Boolean;
begin
  Case Index of
    1 : Result := FDataPointer^.spAuthSQU;
    2 : Result := FDataPointer^.spAuthPQU;
    3 : Result := FDataPointer^.spAuthPOR;
    4 : Result := FDataPointer^.spAuthPIN;
    5 : Result := FDataPointer^.spAllowPrint;
    6 : Result := FDataPointer^.spFloorOnPins;
    7 : Result := FDataPointer^.spAuthOnConvert;
    else
      Result := False;
  end;//case
end;

procedure TPaCompanyParams.SetBool(Index : integer; Value : Boolean);
begin
  Case Index of
    1 :  FDataPointer^.spAuthSQU := Value;
    2 :  FDataPointer^.spAuthPQU := Value;
    3 :  FDataPointer^.spAuthPOR := Value;
    4 :  FDataPointer^.spAuthPIN := Value;
    5 :  FDataPointer^.spAllowPrint := Value;
    6 :  FDataPointer^.spFloorOnPins := Value;
    7 :  FDataPointer^.spAuthOnConvert := Value;
  end;
end;

function TPaCompanyParams.GetString(Index : integer) : string;
begin
  Case Index of
    1 : Result := FDataPointer^.spSQUForm;
    2 : Result := FDataPointer^.spPQUForm;
    3 : Result := FDataPointer^.spPORForm;
    4 : Result := FDataPointer^.spPINForm;
  end;
end;

procedure TPaCompanyParams.SetString(Index : integer; Value : String);
begin
  Case Index of
    1 :  FDataPointer^.spSQUForm := Value;
    2 :  FDataPointer^.spPQUForm := Value;
    3 :  FDataPointer^.spPORForm := Value;
    4 :  FDataPointer^.spPINForm := Value;
  end;
end;

function TPaCompanyParams.BuildSearchKey(const Key : string) : ShortString;
begin
  Result := Key;
end;

function TPaCompanyParams.FormName(const TransRef : string) : string;
var
  s : string;
  i : integer;
begin
  i := TransType(TransRef);
  if i = 0 then
    Result := ''
  else
    Result := GetString(i);
end;

function TPaCompanyParams.GetAuthMode : TAuthModeType;
begin
  Result := TAuthModeType(FDataPointer^.spAuthMode);
end;
procedure TPaCompanyParams.SetAuthMode(Value : TAuthModeType);
begin
  FDataPointer^.spAuthMode := Ord(Value);
end;

function TPaCompanyParams.GetPINTolerance : Double;
begin
  Result := FDataPointer^.spPINTolerance;
end;

procedure TPaCompanyParams.SetPINTolerance(Value : Double);
begin
  FDataPointer^.spPINTolerance := Value;
end;



//========================= Exception constructor ==========================

constructor EPaException.Create(const Msg : ShortString; Sender : TObject = nil);
begin
{$IFNDEF AUTHINT}
  if Sender <> nil then
    if Sender is TPaEarMonitor then
      TPaEarMonitor(Sender).LogIt(Msg);

  inherited Create(Msg);
{$ENDIF}
end;

function TPaCompanyParams.GetLastPINCheck: TDateTime;
begin
  Result := FDataPointer^.spLastPINCheck;
end;

procedure TPaCompanyParams.SetLastPINCheck(const Value: TDateTime);
begin
  FDataPointer^.spLastPINCheck := Value;
end;

function TPaCompanyParams.GetPINCheckInterval: SmallInt;
begin
  Result := FDataPointer^.spPINCheckInterval;
  if Result < 1 then
    Result := 60;
end;

procedure TPaCompanyParams.SetPINCheckInterval(const Value: SmallInt);
begin
  FDataPointer^.spPINCheckInterval := Value;
end;

end.
