unit AuthObjs;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  AuthBase, AuthVar, Dialogs, Enterprise04_TLB, MailPoll, ExtCtrls, CommsInt, Classes;

const

  BuildNo = '196';

  earError                = -1;
  earAuthorized           =  0;
  earSentForAuthorization =  1;
  earNotInAuthTypes       =  2;
  earNotRequired          =  3;
  earNoForm               =  4;
  earEmailError           =  5;
  earCancelledByUser      =  6;


  erNoProblem             = 0;
  erInvalidCode           = 1;
  erValHasChanged         = 2;
  erAboveAuthLimit        = 3;
  erCannotAuthorize       = 4;
  erUnknownAuthorizer     = 5;
  erNoServer              = 6;
  erComTkNotOpen          = 7;
  erRejected              = 8;
  erApproved              = 9;
  erEmailError            = 10;
  erWrongApprover         = 11;
  erApprovedAndAuthorised = 12;
  erLineChanged           = 13;
  erSuppChanged           = 14;
  erCheckSumChanged       = 15;
  erAutoAuth              = 16;

  ehStoredAndAuthorized    = 0;
  ehStoredNotAuthorized    = 1;
  ehAboveFloorLimit        = 2;
  ehInvalidUser            = 3;
  ehInvalidUserOnAuthorize = 4;

  ovUserNotFound    = 1;
  ovAboveFloorLimit = 2;
  ovAboveAuthLimit  = 3;
  ovUserNotFoundA   = 4;

  ovAllowEAR = 128;

  emNoProblem = 0;
  emUseAdmin = 1;

type
  TErrorStr = Record
    Expected,
    Found : AnsiString;
  end;

  {TPaObject owns one of each of the descendents of the TAuthBaseObject. Its
  descendants use them to provide specialized functions for the PA module}

  TPaObject = Class
  private
    FAuthorizer    : TPaAuthorizer;
    FUser          : TPaUser;
    FRequest       : TPaRequest;
    FGlobalParams  : TPaGlobalParams;
    FCompanyParams : TPaCompanyParams;
    FFilesOpen : Boolean;
  protected
    FCompany       : ShortString;
    FCompanyPath   : ShortString;
    //FToolkit       : IToolkit;
    FErrorStr : TErrorStr;
    function GetAuthorizer    : TPaAuthorizer;
    function GetUser          : TPaUser;
    function GetRequest       : TPaRequest;
    function GetGlobalParams  : TPaGlobalParams;
    function GetCompanyParams : TPaCompanyParams;
    function DataPath(const CoCode : string) : string;
    procedure SetCompany(const Value : ShortString);
    procedure DoAuthorization(const AuthID : string; Reason : Byte;  SetAlarm : Boolean = False);
    function LineSum(const s : ShortString) : Word;
    function CalcCheckSum : Int64;
    function HighestAbsLineNo : longint;
    function FormatErrorString : AnsiString;
    function SaveStatusOnly : SmallInt;
    function FormatMoney(Val : Double): string;
  public
    constructor Create;
    destructor Destroy; override;
    function GetVersion : Shortstring;
    procedure OpenFiles;
    procedure CloseFiles;
    procedure AddCompany(const CoCode : string);
    function AddUser(const CoCode, UName : string) : string;
    function AddAuthorizer(const CoCode : string; const AName : String = '') : string;
    procedure DeleteCompany;
    function MakeRequestString(const CoCode, OurRef : string) : string;
    function EARExists(const TransRef : ShortString) : Boolean;
    function TransHasChanged(const TransRef : ShortString; Value : Double) : Boolean;
    procedure DeleteExistingEAR;
    function GetNextNotesLineNo(const Trans : ITransaction): integer;
    function UserList(const CoCode : ShortString) : AnsiString;
    function EntUserEmail(const UName : ShortString) : ShortString;
    function EntUserFullName(const UName : ShortString) : ShortString;
    procedure AddNotes(const AText : string; ATransaction : ITransaction; SetAlarm : Boolean = False);
    procedure SplitText(const AText : string; AList : TStringList);
    procedure SetDefaultForms;
    function PORAuthorisedAndWithinTolerance(Tolerance : Double) : Boolean;
    function CanAuthorisePINFromPOR(const OurRef : string) : Boolean;
    function FindAndLockRequest(const TransRef : string) : Boolean;
    property Authorizer   : TPaAuthorizer read GetAuthorizer;
    property User         : TPaUser read GetUser;
    property Request       : TPaRequest read GetRequest;
    property GlobalParams  : TPaGlobalParams read GetGlobalParams;
    property CompanyParams : TPaCompanyParams read GetCompanyParams;
    property Version : ShortString read GetVersion;
    property CompanyCode : ShortString read FCompany write FCompany;
    property CompanyPath : ShortString write SetCompany;
  end;

  {Generates new authorization requests and emails them to the appropriate
   authorizer}
  TPaEARGenerator = Class(TPaObject)
  private
    FUseMapi : Boolean;
    TempApprover, TempAuth : ShortString;
    FCurrencySymbol : string;
    function GetSelection(AMode : TAuthModeType; Req : TPaRequest) : Boolean;
    procedure SetDefaultAuth;
    function FormatCurrency(v : double) : string;
  protected
    FEmailErrorString : string;
    function MailRequest(const CoCode, AnEAR : string; Folio : longint;
                         ARecip : ShortString = '';
                         AnApprover : ShortString = '';
                         Approve : Boolean = False;
                        Transfer : Boolean = False;
                        OldAuth : string = '') : SmallInt;

    function CheckLocalUser(const AUser : string) : string;
  public
    function NewEAR(const CoCode, TransRef, AUserID : string; ExistingEar : Boolean = False) : SmallInt;
    procedure EndPrint;
  end;

  {Monitors incoming mail and processes replies to EARs}
  {Change 8/8/2001 to inherit from TPaEarGenerator rather than TPaObject. This
   allows it to send an EAR by email - ie to authoriser once approval is
   received}
  TPaEARMonitor = Class(TPaEARGenerator)
  private
    FAuthCode, FTransRef : ShortString;
    MailPoller : TEmailPoller;
    FSender, FSubject : ShortString;
    FMessageText : PChar;
    FActive : Boolean;
    FReason : integer;
    OutRecipients, OutCC : TStringList;
    OutText : AnsiString;
    OutSubject : ShortString;
    AdminEmail : ShortString;
    EarEmail : ShortString;
    FWindowStart, FWindowEnd : TDateTime;
    FCrossMidnight : Boolean;
    FBusy : Boolean;
    FLogFileName : ShortString;
    FLog : TStringList;
    FTimerEnabled : Boolean;
    FLastPINCheck : TDateTime;
    function LogFileName(const Path : ShortString) : ShortString;
    function AuthFullName(const AName : ShortString) : ShortString;
  protected
    function GetCompany : string;
    procedure SetCompany(const Value : string);
    function GetEmailType : TEmailType;
    procedure SetEmailType(Value : TEmailtype);
    function ValidSubject : Boolean;
    function OutOfOffice : Boolean;
    function ParseSubject : Boolean;
    function ProblemString : Ansistring;
    //Responses
    procedure SendUnableToAuthorise(const OldAuth : string);
    procedure ReturnToSender;
    procedure SendTransferEmails(AUser, OldAuthEmail, OldAuthName : string; ARequest : TPaRequest);
    procedure SendRejectionLetter(const WhoTo : ShortString);
    procedure AuthorizeEAR;
    procedure NotifyProblem(Approval : Boolean = False);

    function ValidAuthorizationCode : Boolean;
    procedure ProcessEAR(const Sender, Subject : ShortString;
                              Text : PChar);
    procedure TimerEvent(Sender : TObject);
    procedure CheckTimer(Secs : longint);
    procedure StopForBackupWindow;
    procedure StartAfterBackupWindow;
    procedure SendEmail;
    function RemoveAuthCode(const s : string) : string;
    function FindUser : Boolean;
    function SendForAuthorisation(ARequest : TPaRequest) : Byte;
    procedure ProcessAuthQueue(Sender : TObject);
    procedure WriteSentForAuthNote;
    function CheckChanges(OKStatus : Byte) : Byte;
    function NeedToTransfer(ARequest : TPaRequest) : Boolean;
    function SendForTransfer(ARequest : TPaRequest; const Auth : string) : Byte;
    procedure CheckForPins(Tolerance : Double);
  public
    constructor Create;
    destructor Destroy; override;
    function Start : SmallInt;
    procedure Stop;
    procedure DeleteExpiredEARs;
    procedure LogIt(const Msg : ShortString);
    procedure ProcessOutstandingAuthorisations;
    property CompanyCode : string read GetCompany write SetCompany;
    property EmailType : TEmailType read GetEmailType write SetEmailType;
    property Busy : Boolean read FBusy;
  end;

  TPaHookUserObject = Class(TPaObject)
  private
    FUserID : ShortString;
    FValidUser : Boolean;
    FErrorStatus : integer;
    FOverridden : Boolean;
    FHook  : integer;
  protected
    procedure SetUserID(const Value : ShortString);
    function AuthorizedUser(const ID, Pass : Shortstring) : SmallInt;
  public
    function CanStoreTransaction(Value : Double) : Boolean;
    function CanAuthorizeTransaction(Value : Double) : Boolean;
    function OverrideUser(Why : integer; Value : Double) : integer;
    procedure ShowError;
    procedure Authorize(const TransRef : ShortString);
    property ValidUser : Boolean read FValidUser write FValidUser;
    property  UserID : ShortString read FUserID write SetUserID;
    property Overridden : Boolean read FOverridden write FOverridden;
    property ErrorStatus : integer read FErrorStatus write FErrorStatus;
    property Hook : integer read FHook write FHook;
  end;

  TPaKPIObject = Class(TPaEarMonitor)
  public
    Procedure Process(Reject : Boolean; RejectReason : ShortString);
  end;

  procedure StartToolkit;
  procedure EndToolkit;

  procedure CreateObjects;
  procedure FreeObjects;


var
  FToolkit       : IToolkit;
  TkAvailable    : Boolean;

  PaObject : TPaObject;
  PaEARGenerator : TPaEARGenerator;
  PaHookUserObject : TPaHookUserObject;

 {..$I ExchDll.Inc}

implementation

uses
  GlobVar, Btrvu2, SysUtils, ComObj, UseDLLU, UserForm, Controls, Forms, Pmsg,
  sbs_Int, comMsg, {ComU,} Windows, SecCodes, AuthSlct, ActiveX, Variants, TkUtil,
  DateUtils, EtDateU, StrUtils, Crypto, EtStrU, SQLUtils, ExchequerRelease;

{..$I EXDLLBT.INC}
//------------------------- TPaObject methods -----------------------------------

constructor TPaObject.Create;
begin
  inherited Create;

  FAuthorizer    := nil;
  FUser          := nil;
  FRequest       := nil;
  FGlobalParams  := nil;
  FCompanyParams := nil;
//  FToolkit := nil;

  FFilesOpen := False;


{  Try
    FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  Except
  End;

  if not Assigned(FToolkit) then
    raise EComTkException.Create('Unable to create COM Toolkit');

}  if not Check4BtrvOk then
    raise EBtrieveException.Create('Database engine not available');

end;

destructor TPaObject.Destroy;
begin
  if Assigned(FAuthorizer) then
    FAuthorizer.Free;
  if Assigned(FUser) then
    FUser.Free;
  if Assigned(FRequest) then
    FRequest.Free;
  if Assigned(FGlobalParams) then
    FGlobalParams.Free;
  if Assigned(FCompanyParams) then
    FCompanyParams.Free;

//  FToolkit := nil;
end;

function TPaObject.GetAuthorizer : TPaAuthorizer;
begin
  if not Assigned(FAuthorizer) then
    FAuthorizer := TPaAuthorizer.Create;

  Result := FAuthorizer;
end;

function TPaObject.GetUser : TPaUser;
begin
  if not Assigned(FUser) then
    FUser := TPaUser.Create;

  Result := FUser;
end;

function TPaObject.GetRequest : TPaRequest;
begin
  if not Assigned(FRequest) then
    FRequest := TPaRequest.Create;

  Result := FRequest;
end;

function TPaObject.GetGlobalParams : TPaGlobalParams;
begin
  if not Assigned(FGlobalParams) then
    FGlobalParams := TPaGlobalParams.Create;

  Result := FGlobalParams;
end;

function TPaObject.GetCompanyParams : TPaCompanyParams;
begin
  if not Assigned(FCompanyParams) then
    FCompanyParams := TPaCompanyParams.Create;

  Result := FCompanyParams;
end;

function TPaObject.GetVersion : Shortstring;
begin
  //PR: 04/08/2015 2015 R1 Amended to use centralise version function
  Result := ExchequerModuleVersion(emAuthorise, BuildNo);
end;

procedure TPaObject.OpenFiles;
var
  Res : SmallInt;

  procedure ShowExcept(const Msg : string);
  begin
    if Res <> 0 then
    begin
      FFilesOpen := False;
      ShowMessage('Error ' + IntToStr(Res) + ' occurred while opening ' + Msg + ' file');
//      raise Exception.Create('Error ' + IntToStr(Res) + ' occurred while opening ' + Msg + ' file');
    end;
  end;

begin
  if not FFilesOpen then
  begin
    Res := Authorizer.OpenFile;
    ShowExcept('Authorisers');
    Res := User.OpenFile;
    ShowExcept('Users');
    Res := Request.OpenFile;
    ShowExcept('Requests');
    Res := GlobalParams.OpenFile;
    ShowExcept('Global Parameters');
    Res := CompanyParams.OpenFile;
    ShowExcept('Company parameters');
    FFilesOpen := True;
  end;
end;


procedure TPaObject.CloseFiles;
begin
  Authorizer.CloseFile;
  User.CloseFile;
  Request.CloseFile;
  GlobalParams.CloseFile;
  CompanyParams.CloseFile;
  FFilesOpen := False;
end;

procedure TPaObject.AddCompany(const CoCode : string);
var
  Res : Smallint;
begin
  with CompanyParams do
  begin
    Company := CoCode;
    SetDefaultForms;
    Res := Add;
    if Res <> 0 then
      raise Exception.create('Error ' + IntToStr(Res) + ' adding company ' + CoCode);
  end;
end;

function TPaObject.AddUser(const CoCode, UName : string) : string;
//Will need to change this to use Enterprise user dbase
var
  Res : Smallint;
  i : integer;
  s : string;
begin
  Res := 0;
  i := 1;
  with User do
  begin
    Company := CoCode;
    UserID := UName;
    Res := Add;
    Result := UName;
    if Res <> 0 then
    begin
      Result := '';
      raise Exception.create('Error ' + IntToStr(Res) + ' adding user to company ' + CoCode);
    end;
  end;
end;

function TPaObject.AddAuthorizer(const CoCode : string; const AName : String = '') : string;
var
  Res, i : Smallint;
  s  : string;
begin
  Res := 0;
  i := 1;
  with Authorizer do
  begin
    Company := CoCode;
    if AName <> '' then
    begin
      s := UpperCase(AName);
      Res := GetEqual(s);

      While Res <> 4 do
      begin
        s := UpperCase(AName);
        if i > 1 then s := s + ' (' +IntToStr(i) + ')';
        Name := s;
        Res := GetEqual(Name);
        inc(i);
      end;
//    Company := CoCode;
      Name := s;
      Res := Add;
      Result := s;
      if Res <> 0 then
        raise Exception.create('Error ' + IntToStr(Res) + ' adding authoriser to company ' + CoCode);
    end;
  end;
end;

function TPaObject.DataPath(const CoCode : string) : string;
var
  i : integer;
begin
  Result := '';
  if Assigned(FToolkit) then
  with FToolkit.Company do
  begin
    for i := 1 to cmCount do
      if Trim(cmCompany[i].coCode) = Trim(CoCode) then
        Result := Trim(cmCompany[i].coPath);
  end;
end;

procedure TPaObject.SetCompany(const Value : ShortString);
var
  i : integer;
begin
//Value is the company data path - we need to use the com tk to find the
//company code
  if Assigned(FToolkit) then
  with FToolkit.Company do
  begin
    for i := 1 to cmCount do
      if Trim(cmCompany[i].coPath) = Trim(UpperCase(Value)) then
      begin
        FCompany := cmCompany[i].coCode;
        FCompanyPath := cmCompany[i].coPath;
        Break;
      end;
  end
  else
    raise EComTKException.Create('Unable to access COM Toolkit');
end;

function TPaObject.GetNextNotesLineNo(const Trans : ITransaction): integer;
var
  Res : SmallInt;
begin
   Res := FToolkit.Transaction.thNotes.GetFirst;
   if Res <> 0 then
     Result := 1
   else
   begin
     while Res = 0 do
       Res := FToolkit.Transaction.thNotes.GetNext;
     Result := FToolkit.Transaction.thNotes.ntLineNo + 1;
   end;
end;

function TPaObject.MakeRequestString(const CoCode, OurRef : string) : string;
begin
  Result := 'EAR-' + Copy(CoCode + '      ', 1, 6) + '/' + OurRef;
end;

function TPaObject.EARExists(const TransRef : ShortString) : Boolean;
var
  Res : SmallInt;
begin
  Request.Company := FCompany;
  Res := Request.GetEqual(MakeRequestString(FCompany, TransRef));
  Result := Res = 0;
end;


function TPaObject.FindAndLockRequest(const TransRef : string) : Boolean;
var
  Res : SmallInt;
begin
  Request.Company := FCompany;
  Res := Request.GetEqual(MakeRequestString(FCompany, TransRef), True);
  Result := Res = 0;
end;


function TPaObject.TransHasChanged(const TransRef : ShortString; Value : Double) : Boolean;
//Has the transaction changed since we sent an EAR?

var
  Res : SmallInt;
begin
  Result := False;
  Request.Company := FCompany;
  Res := Request.GetEqual(MakeRequestString(FCompany, TransRef));
  if Res = 0 then
    Result := Abs(Request.TotalValue - Value) > 0.0001;
end;

procedure TPaObject.DeleteExistingEAR;
begin
  Request.Delete;
end;

procedure TPaObject.DeleteCompany;
var
  Res : SmallInt;
begin
//Delete all authorizers, users and requests for the company before deleting
//the companyparam rec
  with Authorizer do
  begin
    Company := CompanyParams.Company;
    Res := GetFirst;
    while Res = 0 do
    begin
      Delete;
      Res := GetFirst;
    end;
  end;

  with User do
  begin
    Company := CompanyParams.Company;
    Res := GetFirst;
    while Res = 0 do
    begin
      Delete;
      Res := GetFirst;
    end;
  end;

  with Request do
  begin
    Company := CompanyParams.Company;
    Res := GetFirst;
    while Res = 0 do
    begin
      Delete;
      Res := GetFirst;
    end;
  end;
  CompanyParams.Delete;
end;

procedure TPaObject.DoAuthorization(const AuthID : string; Reason : Byte;
                                     SetAlarm : Boolean = False);
var
  Res : SmallInt;
  LNo : SmallInt;
  Trans : ITransaction;
  AuthString : String;
  AmountString : String;
  Amount : Double;
begin
  if Reason = erApprovedAndAuthorised then
    AuthString := 'Approved and Authorised by '
  else
  if Reason = erAutoAuth then
    AuthString := 'Automatically authorised '
  else
    AuthString := 'Authorised by ';

//need to reposition on transaction in case we lost it by closing toolkit
  if Trim(Request.EAR) <> '' then
  with FToolkit do
    Res :=
     Transaction.GetEqual(Transaction.BuildOurRefIndex(Copy(Request.EAR, 12, 9)));


  AuthString := FToolkit.Transaction.thOurRef + ' ' + AuthString;

  Trans := FToolkit.Transaction.Update;
  if not Assigned(Trans) then
    raise EComTkException.Create('Unable to get update for transaction ' +
                                    FToolkit.Transaction.thOurRef);
  with Trans do
  begin
    //What????
    thHoldFlag := 3 + 32 + (thHoldFlag and 128);
    Res := Save(False);
    if Res = 30502 then
    begin
      Cancel;
      Res :=  //reposition toolkit on record
        FToolkit.Transaction.GetEqual(FToolkit.Transaction.BuildOurRefIndex(Copy(Request.EAR, 12, 9)));
      Res := SaveStatusOnly;
    end;
    if Res <> 0 then
      raise EComTkException.Create('Unable to save transaction ' +
                                       FToolkit.Transaction.thOurRef + #10 +
                                       'Error ' + IntToStr(Res) + ': ' + FToolkit.LastErrorString);
  end;
  Trans := nil;
  //Add notes to the transaction
  AddNotes(FormatDateTime('hh:mm', Time) + ': ' + AuthString +
                   AuthID + ' for ' + Format('%m', [Request.TotalValue]), FToolkit.Transaction,
                   SetAlarm);

end;

function TPaObject.SaveStatusOnly : SmallInt;
var
  Res : SmallInt;
  KeyS : PChar;
  TH : TBatchTHRec;
  Stat : integer;
begin
  KeyS := StrAlloc(255);
  Try
    FillChar(KeyS^, 255, 0);
    FillChar(TH, SizeOf(TH), 0);

    StrPCopy(KeyS, FToolkit.transaction.thOurRef);

    Res := SetToolkitPath(FToolkit.Configuration.DataDirectory);

    if Res = 0 then
      Res := Ex_InitDLL;

    if Res = 0 then
    begin
     Try
      Res := EX_GETTRANSHED(@TH, SizeOf(TH), KeyS, 0, B_GetEq, True);

      if Res = 0 then
      begin
        TH.HoldFlg := 3;
        Res := EX_STORETRANSHED(@TH, SizeOf(TH));
      end;
     Finally
      Ex_CloseData;
     End;
    end;
    Result := Res;
  Finally
    StrDispose(KeyS);
  End;
end;


function TPaObject.UserList(const CoCode : ShortString): AnsiString;
var
  V : Variant;
  a, b, c : longint;
begin
  if Assigned(FToolkit) then
  begin
    with FToolkit do
    begin
      if Status = tkOpen then
        CloseToolkit;
      Configuration.DataDirectory := DataPath(CoCode);
      OpenToolkit;
      Try
        EncodeOpCode(64, a, b, c);
        V := Configuration.SetDebugMode(a, b, c);
        if VarType(V) <> varEmpty then
        begin
           Result := V.UserNames;
        end
        else
          raise EComTKException.Create('Can''t load user list');
      Finally
        CloseToolkit;
      End;
    end;
  end
  else
    raise EComTKException.Create('COM Toolkit not available');
end;

function TPaObject.EntUserEmail(const UName : ShortString) : ShortString;
var
  V : Variant;
  a, b, c : longint;
begin
  if Assigned(FToolkit) then
  begin
    with FToolkit do
    begin
      if Status = tkOpen then
        CloseToolkit;
      Configuration.DataDirectory := DataPath(FCompany);
      OpenToolkit;
      Try
        EncodeOpCode(64, a, b, c);
        V := Configuration.SetDebugMode(a, b, c);
        if VarType(V) <> varEmpty then
        begin
          if V.Version > '1.00' then
            Result := V.EmailAddress(UName)
          else
            Result := '';
        end
        else
          Result := '';
      Finally
        CloseToolkit;
      End;
    end;
  end
  else
    raise EComTKException.Create('COM Toolkit not available');
end;

function TPaObject.EntUserFullName(const UName : ShortString) : ShortString;
var
  V : Variant;
  a, b, c : longint;
begin
  if Assigned(FToolkit) then
  begin
    with FToolkit do
    begin
      if Status = tkOpen then
        CloseToolkit;
      Configuration.DataDirectory := DataPath(FCompany);
      OpenToolkit;
      Try
        EncodeOpCode(64, a, b, c);
        V := Configuration.SetDebugMode(a, b, c);
        if VarType(V) <> varEmpty then
        begin
          if V.Version > '1.00' then
            Result := V.UserFullName(UName)
          else
            Result := '';
        end
        else
          Result := '';
      Finally
//        CloseToolkit;
      End;
    end;
  end
  else
    raise EComTKException.Create('COM Toolkit not available');
end;

function TPaObject.LineSum(const s : ShortString) : Word;
var
  i : integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    Result := Result + Ord(s[i]);
end;

function TPaObject.CalcCheckSum : Int64;
var
  i : integer;
begin
  Result := 0;
  if Assigned(FToolkit) then
  with FToolkit.Transaction do
  begin
    for i := 1 to thLines.thLineCount do
    begin

      Result := Result + LineSum(Trim(thLines.thLine[i].tlStockCode) +
                                   Trim(thLines.thLine[i].tlDescr));
    end;
  end
  else
    raise EComTKException.Create('COM Toolkit not available');
end;

function TPaObject.HighestAbsLineNo : longint;
var
  i : integer;

  function IsStockDescriptionLine : Boolean;
  begin
    with FToolkit.Transaction.thLines do
//      Result := (thLine[i].tlBOMKitLink = thLine[i].tlFolioNum);
     Result := thLine[i].tlBOMKitLink <> 0;
  end;

begin
  Result := 0;
  if Assigned(FToolkit.Transaction) then
    with FToolkit.Transaction.thLines do
      for i := 1 to thLineCount do
        if not IsStockDescriptionLine then
            if thLine[i].tlABSLineNo > Result then
              Result := thLine[i].tlABSLineNo;

end;

function TPaObject.FormatErrorString : AnsiString;
begin
  Result := #10'Value in request:        ' + FErrorStr.Expected +
            #10'Value in transaction:    ' + FErrorStr.Found;
end;

procedure TPaObject.AddNotes(const AText : string; ATransaction : ITransaction;
                             SetAlarm : Boolean = False);
var
  LNo : longint;
  i : SmallInt;
  AList : TStringList;
begin
  AList := TStringList.Create;
  Try
    SplitText(AText, AList);
    for i := 0 to AList.Count - 1 do
    begin
      LNo := GetNextNotesLineNo(FToolkit.Transaction);
      with FToolkit.Transaction.thNotes.Add do
      begin
        ntType := ntTypeDated;
        if i = 0 then
          ntDate := FormatDateTime('yyyymmdd', Date);
        ntOperator := User.UserID;
        ntText := AList[i];
        ntLineNo := LNo;
        if SetAlarm then
        begin
          ntAlarmDate := FormatDateTime('yyyymmdd', Date);
          ntAlarmDays := 0;
          ntAlarmUser := User.UserID;
          ntAlarmSet := True;
        end;
        Save;
      end;
    end;
  Finally
    AList.Free;
  End;
end;

procedure TPaObject.SplitText(const AText : string; AList : TStringList);
const
  Separators = [' '];
var
  s : string;
  i, j, k : integer;
begin

  AList.Clear;
  s := AText;

  Repeat
    i := 65;
    while (i > 0) and (i <= Length(s)) and not (s[i] in Separators) do dec(i);
    AList.Add(Copy(s, 1, i));
    Delete(s, 1, i);
  Until (Length(s) < 1);

end;

procedure TPaObject.SetDefaultForms;
var
  s : string;
begin
  s := DataPath(CompanyParams.Company);
  SetToolkitPath(s);
  if Ex_InitDll = 0 then
  begin
    if InitDefForm(s) then
    begin
      with CompanyParams do
      begin
        SQUForm := DefFormName(fdSQU);
        PQUForm := DefFormName(fdPQU);
        PORForm := DefFormName(fdPOR);
        PINForm := DefFormName(fdPIN);
      end;
      EndDefForm;
    end;
    Ex_CloseData;
  end;
end;

function TPaObject.PORAuthorisedAndWithinTolerance(Tolerance : Double) : Boolean;
var
  Res1, RecPos : Longint;
  Found : Boolean;
  ThisTotal : Double;
begin
  Found := False;
  Result := False;

  with FToolkit do
  begin
    Res1 := Transaction.thMatching.GetFirst;

    while (Res1 = 0) and not Found do
    begin
      Found := (Transaction.thMatching.maType = maTypeSPOP) and
                (Copy(Transaction.thMatching.maPayRef, 1, 3) = 'POR');

      if not Found then
        Res1 := Transaction.thMatching.GetNext;
    end;

    if Found then
    begin
      Transaction.SavePosition;
      RecPos := Transaction.Position;
      ThisTotal := Transaction.thTotals[TransTotNetInBase];
      Res1 := Transaction.GetEqual(Transaction.BuildOurRefIndex(Transaction.thMatching.maPayRef));
      Result := (Res1 = 0) and (Transaction.thHoldFlag and 3 = 3) and
                   (Abs(ThisTotal - Transaction.thTotals[TransTotNetInBase]) <= Tolerance);
      Transaction.Position := RecPos;
      Transaction.RestorePosition;
    end;
  end;
end;

function TPaObject.CanAuthorisePINFromPOR(const OurRef : string) : Boolean;
var
  Res : Integer;
begin
  Result := False;
  if Copy(OurRef, 1, 3) = 'PIN' then
  begin
    CompanyParams.Company := FCompany;
    Res := CompanyParams.GetEqual(FCompany);
    if (Res = 0) and CompanyParams.AuthOnConvert then
    begin
      if FToolkit.Status = tkOpen then
        FToolkit.CloseToolkit;
      FToolkit.Configuration.DataDirectory := DataPath(CompanyParams.Company);
      Res := FToolkit.OpenToolkit;

      if Res = 0 then
      with FToolkit do
      begin
        Res := Transaction.GetEqual(Transaction.BuildOurRefIndex(OurRef));
        if Res = 0 then
          Result := PORAuthorisedAndWithinTolerance(CompanyParams.PINTolerance);
      end;

    end;
  end;
end;

function TPaObject.FormatMoney(Val : Double): string;
var
  FormatString : string;
begin
  with FToolkit do
  begin
    if Transaction.thDocType in [dtSQU] then
      FormatString := IntToStr(SystemSetup.ssSalesDecimals)
    else
      FormatString := IntToStr(SystemSetup.ssCostDecimals);

    Result := SystemSetup.ssCurrency[0].scSymbol +
               Format('%.'+FormatString+'n', [Val]);
  end;
end;


//--------------------------TPaEARGenerator methods----------------------------//

function TPaEARGenerator.CheckLocalUser(const AUser : string) : string;
var
  Res : SmallInt;
begin

end;


function TPaEARGenerator.NewEAR(const CoCode, TransRef, AUserID : string; ExistingEar : Boolean = False) : SmallInt;
var
  Res : SmallInt;
  i : integer;
  RequestString, DataDir : string;
  Continue : Boolean;
  TotValue : Double;
  LNo : Integer;
  AuthString : ShortString;
  TmpPrevDate : string;
  s : string;
begin
  Result := earError;
  s := '';
  if not Assigned(FToolkit) then
    raise EComTKException.Create('Unable to create COM Toolkit')
  else
  begin
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit.Configuration.DataDirectory := DataPath(CoCode);
    FToolkit.Configuration.AutoSetStockCost := False;
    Res := FToolkit.OpenToolkit;
    if Res <> 0 then
      raise EComTKException.Create('Unable to open COM Toolkit' +
                                   #10#10 + 'Error: ' + FToolkit.LastErrorString)
    else
    begin
      FUseMapi := FToolkit.SystemSetup.ssPaperless.ssEmailUseMAPI;
      with FToolkit.Transaction do
      begin
        Res := GetEqual(BuildOurRefIndex(TransRef));

        if Res <> 0 then
          Raise EComTKException.Create('Unable to find transaction ' + TransRef +
                                         'for company ' + CoCode + #10#10 +
                                         'Error: ' + FToolkit.LastErrorString)
        else
        begin

          if not (thDocType in [dtSQU, dtPQU, dtPOR, dtPIN]) then
            Result := earNotInAuthTypes
          else
          begin
            CompanyParams.Company := CoCode;
            Res := CompanyParams.GetEqual(CoCode);

            if Res <> 0 then
               Raise EBtrieveException.Create('Unable to find company ' + CoCode +
                                              ' in Purchase Authorisation database' +
                                              #10#10 + 'Error: ' + IntToStr(Res))
            else
            begin
              //Company found
              with CompanyParams do
              begin
                Case thDocType of
                  dtSQU   : Continue := AuthSQU;
                  dtPQU   : Continue := AuthPQU;
                  dtPOR   : Continue := AuthPOR;
                  dtPIN   : Continue := AuthPIN;
                end;
              end;

              if not Continue then
                Result := earNotRequired
              else
              begin //Yes we need to authorize this
                 //Have we got a form?
                 if CompanyParams.FormName(thOurRef) = '' then
                 begin
                   Result := earNoForm;
                   FCompany := CoCode;
                 end
                 else
                 begin
                   User.Company := CoCode;
                   Res := User.GetEqual(AUserID);
                   if Res <> 0 then
                       Raise EBtrieveException.Create('Unable to find user ' + AUserID +
                                                      'for company ' + CoCode +
                                                      #10#10 + 'Error: ' + IntToStr(Res))
                   else
                   begin
                     TotValue := {thNetValue}thTotals[TransTotNetInBase];
                     if TotValue <= User.AuthAmount then
                     begin
                     //shouldn't ever get to here
                       DoAuthorization(User.UserName, erNoProblem);
                       Result := earAuthorized;
                     end
                     else
                     begin //need to add ear and send email
                       if (CompanyParams.AuthMode <> auAuthOnlyAuto) or
                          (ComMessageDlg(#10'Please confirm you wish to send an authorisation request for '
                                         + TransRef + '.') = mrYes) then
                       begin

                         CompanyParams.Company := CoCode;
                         CompanyParams.GetEqual(CoCode);
                         SetDefaultAuth;
                         if ExistingEar then
                           EarExists(thOurRef);
                         with Request do
                         begin
                           TmpPrevDate := DateAsString;
                           if not ExistingEar then
                             Clear;
                           Index := 0;
                           Company := CoCode;
                           EAR := MakeRequestString(CoCode, TransRef);
                           UserID := AUserID;
                           OurRef := TransRef;
                           DocType := DocTypeFromOurRef(TransRef);
                           TotalValue := TotValue;
                           TimeStamp := Now;
                           Folio := FToolkit.Transaction.thFolioNum;
                           LineCount := HighestAbsLineNo;
                           Supplier := FToolkit.Transaction.thAcCode;
                           CheckSum := CalcCheckSum;
                           if not GetSelection(CompanyParams.AuthMode, Request) then
                             Result := earCancelledByUser
                           else
                           begin
                             ApprovedBy := TempApprover;
                             Authoriser := TempAuth;
                             if CompanyParams.AuthMode = auApproveAndAuth then
                             begin
                             //Change to allow user to approve immediately if they are on list
                               if Trim(UserID) = Trim(ApprovedBy) then
                               begin
                                 Status := esApprovedAndSent;
                                 ApprovalDateTime := Now;
                                 AuthString := 'Authorisation';
                               end
                               else
                               begin
                                 Status := esSentForApproval;
                                 AuthString := 'Approval';
                               end;
                             end
                             else
                             begin
                               Status := esSentForAuth;
                               AuthString := 'Authorisation';
                             end;
                             if ExistingEar then
                             begin
                               AlreadySent := True;
                               PrevDate := TmpPrevDate;
                               Res := Save;
                             end
                             else
                               Res := Add;
                             if Res <> 0 then
                               Raise EBtrieveException.Create('Unable to add request ' + EAR +
                                                              #10#10 + 'Error: ' + IntToStr(Res))
                             else
                             begin
                               //Request added to database - now find authorizer(s) and send
                               Try
                                 if Status in [esApprovedAndSent, esSentForAuth] then
                                   Res := MailRequest(CoCode, Request.EAR,
                                                      FToolkit.Transaction.thFolioNum, TempAuth, TempApprover)
                                 else
                                   Res := MailRequest(CoCode, Request.EAR,
                                                      FToolkit.Transaction.thFolioNum,
                                                      TempApprover, '', True);

                                 if Res = 0 then
                                   Result := earSentForAuthorization
                                 else
                                   Result := earEmailError;

                                 if Result = earEmailError then
                                   Raise EEmailException.Create('Unable to send Email');

                                 //LNo := GetNextNotesLineNo(FToolkit.Transaction);
                                 Res := FToolkit.Transaction.GetEqual(BuildOurRefIndex(TransRef));
                                 Try
                                   with FToolkit.Transaction.Update do
                                   begin
                                     thHoldFlag := thHoldFlag or 32;
                                     Save(False);
                                   end;

                                   if Status = esApprovedAndSent then
                                   begin
                                   //Write approval note
                                     AddNotes(FormatDateTime('hh:mm', Time) +
                                            ': ' + FToolkit.Transaction.thOurRef + ' ' + 'Approved by  ' +
                                          Request.ApprovedBy + ' for ' + FormatMoney(Request.TotalValue),
                                          FToolkit.Transaction);
                                   end;

                                     s := FormatDateTime('hh:mm', Time) +
                                          ': ' + AuthString + ' request for ' +
                                               FToolkit.Transaction.thOurRef + ' sent to ';
                                     if Res = emUseAdmin then
                                       s := s + ' Administrator'
                                     else
                                     begin
                                       if (User.SendOptions = 'A') and
                                          (Status = esSentForAuth) then
                                         s := s + ' all authorisers'
                                      else
                                         s := s + Authorizer.Name;
                                     end;
                                     s := s + ' for ' + FormatMoney(TotValue);
                                     AddNotes(s, FToolkit.Transaction);


                                 Except
                                 End;
                               Except
                                 //problem - email not sent
                                 Request.Delete;
                                 Result := earError;
                                 Raise;
                               End;
                             end;//send to authorizers
                           end;
                         end;//with request
                       end //if confirm
                       else
                         Result := earCancelledByUser;
                     end; //Trans value more than Users limit - need to add EAR
                   end;//Res = 0 - User found
                 end; //Has a form
              end;//Continue = True - need to authorize
            end;//Res = 0 - Company found
          end;//Transtype in Required types
        end;//Transaction found
      end; // with toolkit.transaction
      FToolkit.CloseToolkit;
    end; //If openToolkit
  end; //If assigned(FToolkit)
end; //Procedure

function TPaEARGenerator.MailRequest(const CoCode, AnEAR : string; Folio : longint;
                                     ARecip : ShortString = '';
                                     AnApprover : ShortString = '';
                                     Approve : Boolean = False;
                                     Transfer : Boolean = False;
                                     OldAuth : string = '') : SmallInt;
const
  tt = ' this transaction ';
var
  Res : SmallInt;
  EMailInfo : TEmailPrintInfoType;
  ToRecip     : PChar;
  CCRecip     : Pchar;
  BCCRecip    : PChar;
  Att         : PChar;
  PMsgChar, MsgText     : PChar;
  DataDir : ShortString;
  Recipients : AnsiString;
  Msg : TStringList;
  LNo : integer;

  UseAdministrator : Boolean;

  MsgLen : integer;

  FromString : String;

  AuthString : ShortString;

  st, st1, TNo, PDate : ShortString;
  Dest : string; //ID of authoriser/approver
  TmpStat : TEarStatusType;

begin
  if Approve and not (Request.Authoriser = Request.ApprovedBy) then
  begin
    AuthString := 'Approve';
  end
  else
  begin
    AuthString := 'Authorise';
  end;

  st := Copy(AnEAR, 12, 3);
  TNo := '(' + Copy(AnEAR, 12, 9) + ') ';
  if st = 'PIN' then
  begin
    st := 'Please a' + Copy(AuthString, 2, Length(AuthString)) + ' for payment';
    st1 := 'Please a' + Copy(AuthString, 2, Length(AuthString)) + tt + TNo + 'for payment';
  end
  else
  begin
    st := 'Please a' + Copy(AuthString, 2, Length(AuthString)) + ' for issue';
    st1 := 'Please a' + Copy(AuthString, 2, Length(AuthString)) + tt + TNo + 'for issue';
  end;

  GlobalParams.GetLast;
  UseAdministrator := False;
  CompanyParams.Company := CoCode;
  Res := CompanyParams.GetEqual(CoCode);
  if Res <> 0 then
      Raise EBtrieveException.Create('Unable to find company parameters' +
                                     ' for company ' + CoCode + #10#10 +
                                     'Error: ' + IntToStr(Res))
  else
  begin
    Request.Company := CoCode;
    if AnEar <> Request.EAR then
      Res := Request.GetEqual(AnEAR)
    else
      Res := 0;
    TmpStat := Request.Status;
    if Res <> 0 then
      Raise EBtrieveException.Create('Unable to find request ' + AnEAR +
                                     ' for company ' + CoCode + #10#10 +
                                     'Error: ' + IntToStr(Res))
    else
    begin
      User.Company := CoCode;
      Res := User.GetEqual(Request.UserID);
      if Res <> 0 then
        Raise EBtrieveException.Create('Unable to find user ' + Request.UserID +
                                       ' for company ' + CoCode + #10#10 +
                                       'Error: ' + IntToStr(Res))
      else
      begin

        Authorizer.Company := CoCode;
        if ARecip = '' then
        begin
          Authorizer.Index := AuthValIdx;
          Res := Authorizer.GetGreaterThanOrEqual(Authorizer.DoubleToKey(Request.TotalValue));

          while (Res = 0) and (not Authorizer.CanAuthorize(Request.OurRef) or
                                    Authorizer.ApprovalOnly) do
            Res := Authorizer.GetNext;
        end
        else
        begin
          Authorizer.Index := AuthNameIdx;
          Res := Authorizer.GetEqual(ARecip);
        end;

        Dest := Authorizer.Name;


        st1 := 'To ' + Dest + #10#10 + st1;

        if Res <> 0 then
          UseAdministrator := true;

        DataDir := DataPath(CoCode);
        //PMsgForm := TPMsgForm.Create(Application);
        Try
          if not InitSBS(PMsgForm, DataDir) then
            Raise EToolkitException.Create('Unable to initialize SBSForm.dll')
          else
          begin
             Try
               Msg := TStringList.Create;
               Try
                 if Approve then
                   Msg.LoadFromFile(IncludeTrailingBackSlash(FToolkit.Configuration.EnterpriseDirectory)
                                      + PaAppMsgFile)
                 else
                   Msg.LoadFromFile(IncludeTrailingBackSlash(FToolkit.Configuration.EnterpriseDirectory)
                                      + PaMessageFile);

               Except
               End;
               Recipients := '';
               Try
                 if UseAdministrator then
                 begin
                 //we haven't been able to find any authorizers so send ear to admin
                   Result := emUseAdmin;
//                   GlobalParams.GetFirst;
                   GlobalParams.GetLast;
                   Recipients := GlobalParams.AdminEmail + ';' +
                                 GlobalParams.AdminEmail + ';';
                   Request.Authoriser := 'Administrator';
                 end
                 else
                 begin
                   while Res = 0 do
                   begin
                     if Authorizer.CanAuthorize(Request.OurRef) or Approve then
                       Recipients := Recipients +
                                     Authorizer.Name + ';' +
                                     Authorizer.Email + ';';

                     if (User.SendOptions = 'B') and (Recipients <> '') or (ARecip <> '') then
                     begin
                       Res := 1;
                       if ARecip = '' then
                         Request.Authoriser := Authorizer.Name;
                     end
                     else
                       Res := Authorizer.GetNext;
                     Result := emNoProblem;

                   end; //while res = 0
                 end;
                 ToRecip := StrAlloc(255);
                 CCRecip := StrAlloc(255);
                 BCCRecip := StrAlloc(255);
                 MsgText := StrAlloc(10000);
                 Att := StrAlloc(255);

                 StrPCopy(ToRecip, Recipients);
                 StrPCopy(BCCRecip,'');
                 StrPCopy(CCRecip, '');
                 StrPCopy(Att, '');

                 if Approve and not (Request.Authoriser = Request.ApprovedBy) then
                   AuthString := 'approval'
                 else
                   AuthString := 'authorisation';

                 FromString := st1 + #10#10;

                 if (CompanyParams.AuthMode = auApproveAndAuth) and not Approve and
                      (not Transfer or (Request.Status = esApprovedAndSent)) then
                   FromString := FromString + 'The transaction was approved by ' +
                    AnApprover + ' on ' + DateToStr(Request.ApprovalDateTime) + ' at ' +
                      TimeToStr(Request.ApprovalDateTime) + #10#10;

                 if Transfer then
                 begin
                   FromString := FromString + 'This transaction was originally sent for ' +
                                   AuthString + ' to ' + OldAuth + #10#10;

{                   if Request.Status = esSentForApproval then
                     FromString := FromString + Trim(Request.ApprovedBy) + #10#10
                   else
                     FromString := FromString + Trim(Request.Authoriser) + #10#10;}
                 end;

                 FromString := FromString + 'This is an ' + AuthString +
                                ' request from: ' + #10#10 + 'ID:     ' +
                                User.UserID + #10 + 'Name:   ' +
                                User.UserName + #10 +  'Email:  ' +
                                User.UserEmail + #10#10 +
                                StringOfChar('-', 60) + #10#10;

                 if Request.AlreadySent then
                 begin
                   PDate := Copy(Request.PrevDate, 1, 8);
                   if Trim(PDate) <> '' then
                     FromString := FromString + 'This request was previously sent on ' +
                               POutDate(PDate) + #10#10;

                 end;


                 StrPCopy(MsgText, FromString);

                 pMsgChar := Msg.GetText;

                 msgLen := StrLen(PMsgChar) + Length(FromString);

                 if MsgLen > 9999  then
                   MsgLen := 9999;
                 StrLCat(MsgText, PMsgChar, MsgLen);

                 //Set other details

                 with EMailInfo do
                 begin
                   emPreview := False;
                   emCoverSheet := '';
                   emSenderName := GlobalParams.AccountName{User.UserName};
                   emSenderAddr := GlobalParams.Email{User.UserEmail};
                   emSubject := Request.MakeEmailSubjectString;
                   if UseAdministrator then
                     emSubject := emSubject + ' No ' + AuthString + 'r found'
                   else
                     emSubject := emSubject + ' ' + st;
                   emPriority := 2;{???}
                   emSendReader := 0;
                   emCompress := Authorizer.CompressAttachments;
                 end;
                 if AddJob(folio, request.ourref,
                           CompanyParams.FormName(Request.OurRef)) then
                   Res := 0
                 else
                   Raise EToolkitException.Create('Unable to add form '
                                             + CompanyParams.FormName(Request.OurRef) +
                                             ' to batch' + #10#10 +
                                              'Error: ' + IntToStr(Res));
                 Try
                   FEmailErrorString := '';
                   PMsgForm.Show;
                   Res := PRINTTOEMAIL(@EMailInfo, SizeOf(EMailInfo), ToRecip, CCRecip,
                                              BCCRecip, MsgText, Att, FUseMapi);
                   PMsgForm.Hide;

                  Request.Company := CoCode;
                  Res := Request.GetEqual(AnEAR);
                  Request.Status := TmpStat;

                  //PR: 30/09/2009 Need to update Request with Authorise/Approver name.
                  if Approve then
                    Request.ApprovedBy := Dest
                  else
                    Request.Authoriser := Dest;

                 Except
                   on E : Exception do
                   begin
                     FEmailErrorString := E.Message;
                     Res := 1001;
                   end;
                 End;
                 Result := Res;
                 if Res <> 0 then
                 begin
                   if FEmailErrorString <> '' then
                     FEmailErrorString := #10#10 + FEmailErrorString;
                   Raise EToolkitException.Create('Unable to send Email.  ' +
                                                  'Error: ' + IntToStr(Res) + FEmailErrorString);
                 end;
               Finally
                DeInitSBS;
               End;
             Finally
               Msg.Free;
               StrDispose(MsgText);
               StrDispose(ToRecip);
               StrDispose(CCRecip);
               StrDispose(BCCRecip);
               StrDispose(Att);
               if (Result = 0) and not Transfer then
                 Request.Save;
{               else
                 Request.Delete;}
             End;
          end; //Toolkit initialized
        Finally
         // PMsgForm.Free
        End;
        Authorizer.Index := 0; //Reset to normal
      end;//Found User
    end; //Found request
  end; //Found company parameters *)
end;


procedure TPaEARGenerator.EndPrint;
begin //not used anymore
  //EX_ENDPRINTFORM;
end;

procedure TPaEARGenerator.SetDefaultAuth;
var
  Res : SmallInt;
  Found : Boolean;
  WantApprover : Boolean;
begin
  TempApprover := '';
  TempAuth := '';

  if not (FToolkit.Transaction.thDocType in [dtSQU, dtPQU]) then
  begin
    Request.Company := FCompany;

    //try POR/PIN in Our ref field
    Request.Index := ReqOurRefIdx;
    Res := Request.GetEqual(FToolkit.Transaction.thYourRef);

    if Res = 0 then
    begin
      TempApprover := Request.ApprovedBy;
      TempAuth := Request.Authoriser;
    end
    else
    begin
      Res := Request.GetEqual(FToolkit.Transaction.thLongYourRef);

      if Res = 0 then
      begin
        TempApprover := Request.ApprovedBy;
        TempAuth := Request.Authoriser;
      end
      else
      begin
        Request.Index := ReqEARIdx;
        Res := Request.GetEqual(MakeRequestString(FCompany, FToolkit.Transaction.thYourRef));

        if Res = 0 then
        begin
          TempApprover := Request.ApprovedBy;
          TempAuth := Request.Authoriser;
        end
        else
        begin
          Request.Index := ReqEARIdx;
          Res := Request.GetEqual(MakeRequestString(FCompany, FToolkit.Transaction.thLongYourRef));

          if Res = 0 then
          begin
            TempApprover := Request.ApprovedBy;
            TempAuth := Request.Authoriser;
          end;
        end;
      end;
    end;


  end;

    Authorizer.Company := FCompany;
    Authorizer.Index := AuthNameIdx;

    CompanyParams.Company := FCompany;
    Res := CompanyParams.GetEqual(FCompany);

    WantApprover := (Res = 0) and (CompanyParams.AuthMode = auApproveAndAuth);



    if WantApprover and (TempApprover = '') then
    begin
      TempApprover := User.DefaultApprover;
      Res := Authorizer.GetEqual(Trim(TempApprover));
      if (Res <> 0) or not Authorizer.Active then
        TempApprover := '';
    end;

    if TempAuth = '' then
    begin
      if WantApprover and (TempApprover <> '') then
      begin
        Res := Authorizer.GetEqual(Trim(TempApprover));
        if (Res = 0) and Authorizer.Active then
          TempAuth := Authorizer.DefaultAuthoriser;
      end;

      if TempAuth = '' then
        TempAuth := User.DefaultAuthoriser;
      Res := Authorizer.GetEqual(Trim(TempAuth));
      if (Res <> 0) or not Authorizer.CanAuthorize(FToolkit.Transaction.thOurRef) or
         (Authorizer.MaxAuthAmount < FToolkit.Transaction.thTotals[TransTotNetInBase]) then
        TempAuth := '';
    end;




end;

function TPaEARGenerator.GetSelection(AMode : TAuthModeType; Req : TPaRequest) : Boolean;
//Show a selection list to get approver and authoriser
begin
  Result := True;
  if AMode = auAuthOnlyAuto then
  begin
{    TempApprover := '';
    TempAuth := '';}
  end
  else
  begin
    with TfrmSelectAuth.Create(nil) do
    Try
      WantApprovers := AMode = auApproveAndAuth;
      if WantApprovers then
        btnAuto.Visible := False;
      RequestAmount := Req.TotalValue;
      Authorizer.Company := Req.Company;
      AuthObject := Authorizer;
      UserID := User.UserID;
      TransRef := Req.OurRef;
      Setup;
      lbApprovers.ItemIndex := lbApprovers.Items.IndexOf(TempApprover);
      lbAuthorisers.ItemIndex := lbAuthorisers.Items.IndexOf(TempAuth);
      ShowModal;
      if ModalResult = mrOK then
      begin
        if WantApprovers then
          TempApprover := Approver
        else
          TempApprover := '';
        TempAuth := Authoriser;
      end
      else
        Result := False;
    Finally
      Free;
    End;
  end;
end;

function TPaEARGenerator.FormatCurrency(v : double) : string;
begin
  Result := FCurrencySymbol + Format('%8.2n', [v]);
end;


//------------------------------- TPaEARMonitor methods -------------------------

constructor TPaEARMonitor.Create;
begin
  inherited Create;
  {$IFDEF Debug}
  DebugModeOn := True;
  {$ELSE}
  DebugModeOn := (ParamCount > 0) and (UpperCase(ParamStr(1)) = '/D');
  {$ENDIF}
  FLastPINCheck := 0;
  MailPoller := TEmailPoller.Create;
  MailPoller.OnGetMessage := ProcessEAR;
  MailPoller.OnLogoff := ProcessAuthQueue;
  MailPoller.OnErrorMessage := LogIt;
  MailPoller.CheckEvent := TimerEvent;
  MailPoller.OnCheckTimer := CheckTimer;
  if DebugModeOn then
    MailPoller.OnStatus := LogIt;
  FTimerEnabled := False;
  FActive := False;
  OutRecipients := TStringList.Create;
  OutCC := TStringList.Create;
  FLog := TStringList.Create;
  FLogFileName := LogFileName(IncludeTrailingBackslash(EntDir) + 'LOGS\');
  FBusy := False;
end;

function TPaEARMonitor.LogFileName(const Path : ShortString) : ShortString;
var
  i : integer;
  s : shortString;
  F : File;
  FSize : LongInt;
  Found : Boolean;
begin
  i := 1;
  s := '001';
  Found := False;
  while (i < 1000) and FileExists(Path + 'EAR' + s + '.Log') and not Found do
  begin
  {$I-}
    AssignFile(F, Path + 'EAR' + s + '.Log');
    Reset(F, 1);
    FSize := FileSize(F);
    CloseFile(F);
  {$I+}
    if FSize < MaxLogFileSize then
      Found := True
    else
    begin
      inc(i);
      s := IntToStr(i);
      s := StringOfChar('0', 3 - Length(s)) + s;
    end;
  end;

  if i >= 1000 then
    i := 0;

  s := IntToStr(i);
  s := StringOfChar('0', 3 - Length(s)) + s;



  Result := Path + 'EAR' + s + '.Log';
end;





destructor TPaEARMonitor.Destroy;
begin
  if Assigned(MailPoller) then
    MailPoller.Free;
  if Assigned(OutRecipients) then
    OutRecipients.Free;
  if Assigned(OutCC) then
    OutCC.Free;
  if Assigned(FLog) then
    FLog.Free;
  inherited Destroy;
end;

function MemFreeString : String;
var
  M : MemoryStatus;
  V : Double;
begin
  FillChar(M, SizeOF(M), #0);
  M.dwLength := SizeOf(M);
  GlobalMemoryStatus(M);
  V := (M.dwAvailVirtual div 1024);
  Result := Format('Available virtual memory: %9.0nkb', [V]);
end;


procedure TPaEARMonitor.LogIt(const Msg : ShortString);
var
  F : File;
  FSize : LongInt;
  s1 : ShortString;
begin
{$I-}
  AssignFile(F, FLogFileName);
  if not FileExists(FLogFileName) then
    Rewrite(F, 1)
  else
    Reset(F, 1);

  FSize := FileSize(F);
  Seek(F, FSize);
  s1 := DateTimeToStr(Now) + '> ' + Msg;
  s1 := s1 + ' (' + GetVersion + ') Poll: ' + IntToStr(MailPoller.PollCount);
  BlockWrite(F, s1[1], Length(s1));
  BlockWrite(F, CRLF, 2);
  CloseFile(F);
{$I+}
  if FSize > MaxLogFileSize then
    FLogFileName := LogFileName(EntDir + {PaPath}'\LOGS\');
end;


function TPaEARMonitor.GetCompany : string;
begin
  Result := FCompany;
end;

procedure TPaEARMonitor.SetCompany(const Value : string);
begin
  FCompany := Copy(Value, 1, 6);
end;

function TPaEARMonitor.GetEmailType : TEmailType;
begin
  if Assigned(MailPoller) then
    Result := MailPoller.EmailType;
end;

procedure TPaEARMonitor.SetEmailType(Value : TEmailtype);
begin
  if Assigned(MailPoller) then
    MailPoller.EmailType := Value;
end;


procedure TPaEARMonitor.DeleteExpiredEARs;
var
  CompRes, ReqRes : Smallint;
  DateStr : String;
  CutOffDate : TDateTime;
begin
  FBusy := True;
  //if timeout is 0 then we assume they never want ears deleted
  if GlobalParams.EARTimeOut > 0 then
  begin
    CutOffDate := Date - GlobalParams.EARTimeOut;
    DateStr := FormatDateTime('yyyymmdd', CutOffDate);

    Request.Index := ReqDateIdx;
    CompRes := CompanyParams.GetFirst;
    while CompRes = 0 do
    begin
      Request.Company := CompanyParams.Company;

      ReqRes := Request.GetLessThan(DateStr);

      while ReqRes = 0 do
      begin
        Request.Delete;

        ReqRes := Request.GetLessThan(DateStr);

//        ReqRes := Request.GetPrevious;
      end;

      CompRes := CompanyParams.GetNext;
    end;

    Request.Index := 0;
  end;


  FBusy := False;
end;

procedure TPaEARMonitor.ReturnToSender;
begin
  //not an EAR - return with note + cc to administrator
  OutRecipients.Clear;
  OutCC.Clear;
  OutRecipients.Add(FSender);
  OutCC.Add(AdminEmail);
  OutSubject := 'Invalid message: ' + FSubject;
  OutText := 'This mailbox is reserved for replies to authorisation requests';
  SendEmail;
end;

procedure TPaEARMonitor.SendUnableToAuthorise(const OldAuth : string);
begin
  OutRecipients.Clear;
  OutCC.Clear;
  OutRecipients.Add(AdminEmail);
  OutSubject := 'Authoris-e: Request above alternate authoriser''s limit';
  OutText := 'Authorisation/Approval request: ' + Request.EAR + #10#10 +
             'This request was sent to ' + OldAuth + ' but was not authorised/approved within' + #10 +
             'the set time. It is not possible to send it to the designated alternate (' +
             Authorizer.Name + ') as it is above his/her limit.';
  SendEmail;
end;


procedure TPaEARMonitor.SendTransferEmails(AUser, OldAuthEmail, OldAuthName : string; ARequest : TPaRequest);
var
  AuthString : string;
begin
  LogIt('Sending transfer notice - User: ' +
            AUser + ', Previous Authoriser: ' + OldAuthEmail + ', Admin: ' + AdminEmail);
  if ARequest.Status = esSentForApproval then
    AuthString := 'Approval'
  else
    AuthString := 'Authorisation';

  OutRecipients.Clear;
  OutCC.Clear;
  OutRecipients.Add(AUser);
  OutRecipients.Add(OldAuthEmail);
  OutCC.Add(AdminEmail);
  OutSubject := AuthString + ' request ' + ARequest.EAR + ': Transfer of ownership';
  if ARequest.Status = esSentForApproval then
    AuthString := 'approving'
  else
    AuthString := 'authorising';
  OutText := 'Responsibility for ' + AuthString + ' this request has been transferred from ' +
               OldAuthName + ' to ';

  if ARequest.Status = esSentForApproval then
    OutText := OutText + ARequest.Approvedby
  else
    OutText := OutText + ARequest.Authoriser;
  SendEmail;
end;

function TPaEARMonitor.ParseSubject : Boolean;
var
  i, j : integer;
  s : string;
begin
  Result := True;
  s := FSubject;
  i := Pos('-',s) + 1;
  if i = 1 then Result := False;
  j := Pos('/',s) - 1;
  FCompany := Copy(s, i, j - i + 1);
  i := Pos('/',s) + 1;
  if i = 1 then Result := False;
  FTransRef := Copy(s, i, 9);
  i := Pos(':',s) + 1;
  if i = 1 then Result := False;
  FAuthCode := Copy(s, i, 10);
  i := Pos(')', FAuthCode);
  Delete(FAuthCode, i, Length(FAuthCode));
end;

function TPaEARMonitor.OutOfOffice : Boolean;
var
  s : string;
begin
  s := UpperCase(FSubject);
  Result := (Pos('OFFICE', s) > 0) or (Pos('AUTO', s) > 0);
end;

function TPaEARMonitor.ValidSubject : Boolean;
var
  i : integer;
begin
//if a reply or forward then we may have 'RE:' or 'FW:' before the EAR so
//delete anything before the ear
  i := Pos('EAR-',FSubject);
  if i = 0 then
    Result := False
  else
  begin
    Delete(FSubject, 1, i - 1);
    Result := True;
  end;
end;

procedure TPaEARMonitor.SendRejectionLetter(const WhoTo : ShortString);
var
  sProblem : string;
begin
  if WhoTo <> '' then
  begin
    OutRecipients.Clear;
    OutCC.Clear;
    OutRecipients.Add(WhoTo);
    OutSubject := 'Request rejected: ' + RemoveAuthCode(FSubject);
    OutText := 'This request has not been authorised.';
    sProblem := ProblemString;
    if sProblem <> '' then OutText := OutText + 'Reason: '#10#10 +
                   ProblemString;
    SendEmail;
    AddNotes(FormatDateTime('hh:mm', Time) + ': ' + 'Request rejected',
             FToolkit.Transaction, False);
  end;
end;

function TPaEARMonitor.ValidAuthorizationCode : Boolean;
begin
  Result := Trim(FAuthCode) = Authorizer.AuthCode;
end;

function TPaEARMonitor.CheckChanges(OKStatus : Byte) : Byte;
var
  HighLine : LongInt;
  Supp : String[6];
  ChkSum : int64;
begin
  Supp := FToolkit.Transaction.thAcCode;
  HighLine := HighestAbsLineNo;
  ChkSum := CalcCheckSum;

  FErrorStr.Expected := '';
  FErrorStr.Found := '';

  if Request.LineCount <> HighLine then
  begin
    FErrorStr.Expected  := IntToStr(Request.lineCount);
    FErrorStr.Found := IntToStr(HighLine);
    Result := erLineChanged;
  end
  else
  if Trim(Request.Supplier) <> Trim(Supp) then
  begin
    FErrorStr.Expected := Request.Supplier;
    FErrorStr.Found := Supp;
    Result := erSuppChanged;
  end
  else
  if ChkSum <> Request.CheckSum then
  begin
    FErrorStr.Expected := IntToStr(Request.CheckSum);
    FErrorStr.Found := IntToStr(ChkSum);
    Result := erCheckSumChanged;
  end
  else
    Result := OKStatus;
end;

function TPaEARMonitor.NeedToTransfer(ARequest : TPaRequest) : Boolean;
begin
  Result := (ARequest.Status in [esSentforApproval, esApprovedAndSent, esSentForAuth]) and
            (Authorizer.AltAfter > 0) and (IncHour(ARequest.TimeStamp, Authorizer.AltAfter) < Now) and
             (Trim(Authorizer.Alternate) <> DefNone) and (Trim(Authorizer.Alternate) <> '');
  if Result then
  begin
    LogIt(ARequest.EAR + '- RequestStatus: ' + IntToStr(Ord(ARequest.Status)) + ' Request TimeStamp: ' +
             FormatDateTime('dd/mm/yyyy hh:nn:ss', ARequest.TimeStamp));
    LogIt('Need to transfer ' + ARequest.EAR + '. Current authoriser: ' + Trim(Authorizer.Name) +
               '. Alternate: ' + Trim(Authorizer.Alternate));
  end;
end;

procedure TPaEARMonitor.ProcessEAR(const Sender, Subject : ShortString;
                                      Text : PChar);

var
  Res : SmallInt;
  SendTo : String;
  LocalDataPath : string;
  sAuthCode : string;

  function BlankAuthCode(const s : string) : string;
  var
   i : integer;
  begin
    Result := s;
    i := Pos('AUTHCODE:', Result);
    if i > 0 then
    begin
      i := i + 9;
      while (i < Length(Result)) and (Result[i] <> ')') do
      begin
        Result[i] := '*';
        inc(i);
      end;
    end;
  end;
begin

  FBusy := True;
  LogIt('Processing authorisation from ' + Sender + ' : ' + BlankAuthCode(Subject));
  Try
    if Assigned(FToolkit) then
    begin
      FSubject := Subject;
      FSender := Sender;
      FMessageText := Text;
      ParseSubject;
      LocalDataPath := DataPath(FCompany);
      if OutOfOffice then
      begin
        LogIt('''Out of Office'' ignored');
      end
      else
      if not ValidSubject then
        ReturnToSender
      else
      if Trim(LocalDataPath) = '' then
        LogIt('Unknown Company: ' + QuotedStr(FCompany))
      else
      begin
       ParseSubject;
       if FToolkit.Status = tkOpen then
         FToolkit.CloseToolkit;
        FToolkit.Configuration.DataDirectory := DataPath(FCompany);
        Res := FToolkit.OpenToolkit;
        if Res <> 0 then
          raise EComTKException.Create('Unable to open COM Toolkit' + #10#10 +
                                        'Error: ' + FToolkit.LastErrorString, Self)
        else
        begin
          with FToolkit.Transaction do
          begin
            Index := thIdxOurRef;
            Res := GetEqual(BuildOurRefIndex(FTransRef));
          end;
          if Res <> 0 then
{            raise EComTKException.Create('Unable to find transaction' + #10#10 +
                                        'Error: ' + FToolkit.LastErrorString, Self)}
          else
          begin
            begin
              Request.Company := FCompany;
              Request.Index := 0;
              Res := Request.GetEqual(Copy(FSubject, 1, 20), True);
              Try
                if Res <> 0 then
                begin
                  //Do what? Request may have been deleted
                end
                else
                begin
                   User.Company := FCompany;
                   User.Index := 0;
                   Res := User.GetEqual(Request.UserID);
                   if Res = 0 then
                     SendTo := User.UserEmail
                   else
                     SendTo := '';

                   FReason := erNoProblem; //Until we know better

                   Authorizer.Company := FCompany;
                   Authorizer.Index := AuthCodeIdx;

                  {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL then
                      sAuthCode := Encode(LJVar(FAuthCode, 10))
                    else
                  {$ENDIF}
                      sAuthCode := LJVar(FAuthCode, 10);

                   Res := Authorizer.GetEqual(sAuthCode);
                   if Res <> 0 then
                   begin
                     User.Company := FCompany;

                     if FAuthCode = 'xxxxxxxxxx' then
                       FReason := erRejected
                     else
                     begin
                       Authorizer.Index := AuthEmailIdx;
                       Res := Authorizer.GetEqual(LowerCase(Sender));
                       if Res = 0 then
                         FReason := erInvalidCode
                       else
                         FReason := erUnknownAuthorizer;
                     end;
                   end;
                  {We now have the request, the authorizer and the original transaction.
                   Now we need to check 3 things:
                     1.  Is the authorization code valid?
                     2.  Is the value of the transaction still the same?
                     3.  Can the authorizer authorize this amount?
                     4.  Can the authorizer authorize this transaction type?
                     8/8/2001 - add approvals to the system:
                     5.  Are we approving or authorising?
                     6.  If approving, is this the correct approver?
                     7.  If approving, can the approver also authorise this request?
                     8.  How much wood would a woodchuck chuck if a woodchuck could chuck wood?
                   }

                   {if not ValidAuthorizationCode then
                     FReason := erInvalidCode;}
                   if FReason = erNoProblem then
                   begin
                     if Request.Status = esSentForApproval then
                     begin
                       //is it the right approver?
                       if Trim(Authorizer.Name) = Trim(Request.ApprovedBy) then
                       begin
                         if Abs(Request.TotalValue -
                              FToolkit.Transaction.thTotals[TransTotNetInBase])
                                > 0.0001 + CompanyParams.PINTolerance then
                           FReason := erValHasChanged
                         else
                           FReason := CheckChanges(erApproved);

                         if (FReason = erApproved) then
                         //if approver is also required authoriser then authorise
                         begin
                           if Trim(Authorizer.Name) = Trim(Request.Authoriser) then
                             FReason := erApprovedAndAuthorised;
                         end;

                       end
                       else
                         FReason := erWrongApprover;
                     end
                     else
                     if Abs(Request.TotalValue -
                              FToolkit.Transaction.thTotals[TransTotNetInBase])
                                 > 0.0001 + CompanyParams.PINTolerance then
                       FReason := erValHasChanged
                     else
                     if Request.TotalValue > Authorizer.MaxAuthAmount then
                         FReason := erAboveAuthLimit
                     else
                     if not Authorizer.CanAuthorize(FTransRef) then
                       FReason := erCannotAuthorize
                     else
                       FReason := CheckChanges(erNoProblem);
                   end;

                   if FReason in [erNoProblem, erApprovedAndAuthorised] then
                     AuthorizeEAR
                   else
                   if FReason = erApproved then
                   begin
                   {Can't send ear through sbsform procedure at this point because it clashes
                   with the current connection to the server.  Set flag on request
                   then once we are logged out of server we can go thru all requests
                   and send any that need sending}
  {                   if SendForAuthorisation(Request) = earEmailError then
                     begin
                       FReason := erEmailError;
                       NotifyProblem;
                     end;}
                     Request.Status := esReadyToSend;
                   end
                   else
                   if Freason = erRejected then
                   begin
                     Request.Status := esRejected;
                     SendRejectionLetter(SendTo);
                   end
                   else
                     NotifyProblem(Request.Status = esSentForApproval);
                end;
              Finally
              //must save or cancel request in order to unlock it
                Res := Request.Save;
              End;
            end;
            Authorizer.Index := 0; //reset to default
          end;
          FToolkit.CloseToolkit;
        end;
      end;
    end;
  Finally
    FBusy := False;
  End;
end;

procedure TPaEARMonitor.AuthorizeEAR;
var
  LNo : integer;
begin
  //Send email
  Try
    FCompany := Authorizer.Company;
    DoAuthorization(AuthFullName(Authorizer.Name), FReason, True{Set alarm});
    if FindUser then
    begin
      OutRecipients.Clear;
      OutCC.Clear;
      OutRecipients.Add(User.UserEmail);
      OutCC.Add(Authorizer.Email);
      OutSubject := RemoveAuthCode(FSubject) + ' has been authorised';
      OutText := Copy(OutSubject, 12, 9) + ' has been authorised by ' +
                    AuthFullName(Request.Authoriser) + #10 + FMessageText;
      SendEmail;
      LogIt('Auth email sent for ' + Request.EAR + ' to user ' + User.UserID);
    end;
    //do the authorization
    //then delete the request
    if Request.DocType in [edtPIN, edtSQU] then
    begin
      Request.Cancel;
      Request.Delete;  //we have to hold on to other types for now
    end
    else
    if Request.DocType in [edtPOR, edtPQU] then
    begin
      Request.Status := esAuthorised;
      Request.Save;
    end;
  Except
    on E: ECOMTkException do
    begin
      //Can''t save the transaction - set status so it can be authorised on next poll
      LogIt(E.Message);
      Request.Status := esOKToAuthorise;
      if Request.Authoriser = '' then
        Request.Authoriser := Authorizer.Name;
      Request.Save;

    end;
  End;
end;

procedure TPaEARMonitor.TimerEvent(Sender : TObject);
var
  PollerWasActive, PollerStopped : Boolean;
  Res : Integer;

  function InWindow : Boolean;
  //returns true if we're inside the backup window - FCrossMidnight is set on startup
  //and is true if the backup window starts one day and ends the next
  var
    T : TDateTime;
  begin
    T := Now;
    T := T - Trunc(T);
    if FCrossMidnight then
      Result := (T > FWindowStart) or (T < FWindowEnd)
    else
      Result := (T > FWindowStart) and (T < FWindowEnd);

    if Result then
      PollerStopped := True; //Don't want to start up again until out of backup window
  end;

begin
  if FActive then
  begin
  //Check through PINs to see if any have been converted from authorised PORs
    if Assigned(Sender) then
    begin
      Res := CompanyParams.GetFirst;

      while Res = 0 do
      begin
        if CompanyParams.AuthOnConvert then
          CheckForPins(CompanyParams.PINTolerance);

        Res := CompanyParams.GetNext;
      end;
    end; //If FActive

  //Check if any requests have OKToAuthorise status
    if Sender = nil then
      ProcessOutstandingAuthorisations;
  end;

//Do we want to shut down for backup, or startup after backup window?
  Case FActive of
    True  : Begin
              if InWindow then
                StopForBackUpWindow;
            end;
    False : begin
              if not InWindow then
                StartAfterBackupWindow;
            end;
  end;

end;

function TPaEARMonitor.Start : SmallInt;
var
  Res : SmallInt;
  ServerSet : Boolean;
begin
  Result := erNoProblem;
  OpenFiles;
  //Get defaults
  GlobalParams.GetFirst;
  if GlobalParams.Frequency >= 0 then
    MailPoller.PollFrequency := GlobalParams.Frequency * 60 //mins to secs
  else
    MailPoller.PollFrequency := -(GlobalParams.Frequency);

  MailPoller.Pop3UserName := GlobalParams.AccountName;
  MailPoller.Pop3Password := GlobalParams.AccountPassword;
  MailPoller.Pop3Address := GlobalParams.Email;
  MailPoller.Pop3Server := GlobalParams.Server;

  if GlobalParams.UseMAPI then
    MailPoller.EmailType := emlMAPI
  else
    MailPoller.EmailType := emlSMTP;

  AdminEmail := GlobalParams.AdminEmail;

  FWindowStart := GlobalParams.OfflineStart;
  FWindowEnd := GlobalParams.OfflineFinish;

  FCrossMidnight := FWindowEnd < FWindowStart;

  if GlobalParams.Server = '' then
  begin

      MailPoller.Pop3Server := GlobalParams.Server;


      ServerSet := (MailPoller.EmailType <> emlSMTP) or
                 (MailPoller.Pop3Server <> '');

      FToolkit.CloseToolkit;

      if not ServerSet then
        Result := erNoServer;
  end;

  if Result <> erNoProblem then
  begin
    CloseFiles;
  end
  else
  begin
    DeleteExpiredEARs;
    FActive := True;
    MailPoller.Start;
    if DebugModeOn then
      LogIt('Polling started');
  end;
end;

procedure TPaEARMonitor.Stop;
begin
  FTimerEnabled := False;
  MailPoller.Stop;
  CloseFiles;
  FActive := False;
  if DebugModeOn then
    LogIt('Polling stopped');
end;

procedure TPaEARMonitor.StopForBackupWindow;
begin
  MailPoller.Active := False;
  CloseFiles;
  FActive := False;
  if DebugModeOn then
    LogIt('Stopping for backup window');
end;

procedure TPaEARMonitor.StartAfterBackupWindow;
begin
  if DebugModeOn then
    LogIt('Starting after backup window');
  OpenFiles;
  MailPoller.Active := True;
  FActive := True;
end;

procedure TPaEARMonitor.SendEmail;
var
  s : ShortString;
  pMsg : PChar;
  CoCode, AnEar : string;

  procedure CleanOutText;
  var
    i, j : SmallInt;
  begin
    i := Pos('Content-Type: application/octet-stream', OutText);

    while (i > 0) and (Copy(OutText, i, 7) <> '------=') do
      dec(i);

    if i > 0 then
      Delete(OutText, i, Length(OutText));
  end;

  procedure CleanList(const AList : TStringList);
  var
    i : integer;
  begin
    i := 0;
    while i < AList.Count do
    begin
      if UpperCase(AList[i]) = UpperCase(GlobalParams.Email) then
      begin
        if UpperCase(AList[i]) <> UpperCase(GlobalParams.AdminEmail) then
        begin
          AList[i] := GlobalParams.AdminEmail;
          inc(i);
        end
        else
          AList.Delete(i);
      end
      else
        inc(i);
    end;
  end;

begin
  CleanOutText;

  //Added functions to make sure that we're not sending to the ear account
  CleanList(OutRecipients);
  CleanList(OutCC);
  if OutRecipients.Count = 0 then
    OutRecipients.Assign(OutCC);

  if OutRecipients.Count > 0 then
  with TEntEmail.Create do
  Try
    s := Copy(OutText, 1, 255);
    if DebugModeOn then
      LogIt('Send email: ' + OutSubject);
    if Pos('Problem', OutSubject) = 1 then
      LogIt(s);


    Message := PChar(OutText);
    Priority := 1; // Normal ???
    Recipients.Assign(OutRecipients);
    CC.Assign(OutCC);

    GlobalParams.GetLast;
    Sender := GlobalParams.Email;
    SenderName := GlobalParams.AccountName;
    SMTPServer := GlobalParams.Server;
    Subject := OutSubject;
    UseMAPI := GlobalParams.UseMapi;
    CoCode := Request.Company;
    AnEar := Request.EAR;

    try
      Send(False);
    except // Trap any exceptions on sending E-mail
    end;
  Finally
    Message := '';
    Free;
    Request.Company := CoCode;
    Request.GetEqual(AnEAR);
    OutRecipients.Clear;
    OutCC.Clear;
  End;

end;

function TPaEARMonitor.RemoveAuthCode(const s : string) : string;
var
  i : integer;
begin
  Result := s;
  i := Pos('(AUTHCODE', Result);
  if i > 0 then
    Delete(Result, i, Length(Result));
end;

function TPaEARMonitor.FindUser : Boolean;
var
  Res : Smallint;
begin
//Assuming the request is correct we set the user to the originator of the request
  User.Company := FCompany;
  Res := User.GetEqual(Request.UserID);
  Result := Res = 0;
end;

procedure TPaEARMonitor.NotifyProblem(Approval : Boolean = False);
var
  TypeStr : String;
begin
  if Approval then
    TypeStr := 'approved'
  else
    TypeStr := 'authorised';
  OutRecipients.Clear;
  OutCC.Clear;
  OutRecipients.Add(FSender);
  OutCC.Add(AdminEmail);
  OutSubject := 'Problem: ' + RemoveAuthCode(FSubject);
  OutText := 'This request has not been ' + TypeStr + '. Reason: '#10#10 +
                 ProblemString;
  SendEmail;
end;

function TPaEARMonitor.ProblemString : AnsiString;
begin
  Case FReason of
    erValHasChanged   : Result := 'The transaction value is not the same as the EAR value' +
                                    #10'Transaction value: ' +
                                    FormatMoney(FToolkit.Transaction.thTotals[TransTotNetInBase]) +
                                    #10'Request value: ' + FormatMoney(Request.TotalValue);
    erAboveAuthLimit    : Result := 'The transaction value is above the authorisation limit for ' +
                                       Authorizer.Name;
    erCannotAuthorize   : Result := Authorizer.Name + ' cannot authorise transactions of this type';
    erUnknownAuthorizer : Result := FSender + ' cannot be found in the authorisers table';
    erInvalidCode       : Result := QuotedStr(FAuthcode) + ' is not a valid authorisation code';
    erRejected          : Result := FMessageText;
    erEmailError        : Result := 'Error sending authorisation email';
    erWrongApprover     : Result := 'Incorrect approval code';
    erLineChanged       : Result := 'Highest line number has changed.' +
                                    FormatErrorString;
    erSuppChanged       : Result := 'Supplier has changed.' + FormatErrorString;
    erCheckSumChanged   : Result := 'CheckSum has changed.' + FormatErrorString;
    else
      Result := 'Unknown reason';
  end;
end;

function TPaEARMonitor.SendForAuthorisation(ARequest : TPaRequest) : Byte;
var
  Res : SmallInt;
begin
  begin
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit.Configuration.DataDirectory := DataPath(FCompany);
    Res := FToolkit.OpenToolkit;

    with ARequest do
    begin
      Status := esApprovedAndSent;
      ApprovalDateTime := Now;
      LogIt('Sending approved request ' + EAR + ' for authorisation');
      {$IFDEF DLLHOOK}
      FUseMapi := FToolkit.SystemSetup.ssPaperless.ssEmailUseMAPI;
      {$ELSE}
      GlobalParams.GetLast;
      FUseMapi := GlobalParams.UseMapi;
      {$ENDIF}
      Try
        Res := MailRequest(Company, EAR, Folio, Authoriser, ApprovedBy);
        Result := Res;
        if Result = 0 then
        begin
          Res := FToolkit.Transaction.GetEqual(FToolkit.Transaction.BuildOurRefIndex(EAR));
          if Res = 0 then
            AddNotes('Approved request sent for authorisation', FToolkit.Transaction);
        end;
      Except
        on E: Exception do
          Logit(E.Message);
      End;
    end;
    FToolkit.CloseToolkit;
  end;
end;

function TPaEARMonitor.SendForTransfer(ARequest : TPaRequest; const Auth : string) : Byte;
var
  Res : SmallInt;
  OldAuth : string;
  OldTime : TDateTime;
begin
  Res := Authorizer.GetEqual(Auth);
  if Authorizer.CanAuthorize(ARequest.OurRef) then
  begin
    OldTime := ARequest.TimeStamp;
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit.Configuration.DataDirectory := DataPath(FCompany);
    Res := FToolkit.OpenToolkit;

    if Res = 0 then
    with ARequest do
    begin
      if ARequest.Status = esSentForApproval then
      begin
          OldAuth := ApprovedBy;
          ApprovedBy := Auth;
      end
      else
      begin
          OldAuth := Authoriser;
          Authoriser := Auth;
      end;
      {$IFDEF DLLHOOK}
      FUseMapi := FToolkit.SystemSetup.ssPaperless.ssEmailUseMAPI;
      {$ELSE}
      GlobalParams.GetLast;
      FUseMapi := GlobalParams.UseMapi;
      {$ENDIF}
        Try
          ARequest.TimeStamp := Now;
        Except
          on E : Exception do
          begin
            Res := -1;
            LogIt('Exception in setting TimeStamp: ' + QuotedStr(E.Message));
          end;
        End;
        Try
          Res := ARequest.Save;
        Except
          on E : Exception do
          begin
            Res := -1;
            LogIt('Exception in Request.Save: ' + QuotedStr(E.Message));
          end;
        End;

      if Res = 0 then
      Try
        Res := MailRequest(Company, EAR, Folio, Auth, ApprovedBy,
                            Status = esSentForApproval, True, OldAuth);
      Except
        Res := -1;
      End
      else
        LogIt('Sending for transfer: Error ' + IntToStr(Res) + ' when saving request');

      Result := Res;
      if Result = 0 then
      begin
        if ARequest.Status = esSentForApproval then
        begin
          LogIt('Approval request transferred from ' + Trim(OldAuth) + ' to ' + Auth);
        end
        else
        begin
          LogIt('Authorisation request transferred from ' + Trim(OldAuth) + ' to ' + Auth);
        end;

        Authorizer.GetEqual(OldAuth);
        User.GetEqual(Request.UserID);
        SendTransferEmails(User.UserEmail, Authorizer.Email, Authorizer.Name, ARequest);
        FToolkit.Transaction.Index := thIdxOurRef;
        Res := FToolkit.Transaction.GetEqual(FToolkit.Transaction.BuildOurRefIndex(OurRef));
        if Res = 0 then
          AddNotes(FormatDateTime('hh:mm', Time) +
                   ': Request transferred to ' + Auth, FToolkit.Transaction);
      end
      else
      begin
        LogIt('SendForTransfer: MailRequest returned ' + IntToStr(Res));
        Res := Request.GetEqual(Request.EAR, True); //Lock
        if Res = 0 then
        begin
          Request.Authoriser := OldAuth;
          Request.TimeStamp := OldTime;
          Request.Save;
        end;
      end;
      FToolkit.CloseToolkit;
    end
    else
      LogIt('SendForTransfer: Error opening COM Toolkit ' + QuotedStr(FToolkit.LastErrorString));
  end
  else
  begin
    if not ARequest.AdminNotified then
    begin
      SendUnableToAuthorise(ARequest.Authoriser);
      ARequest.AdminNotified := True;
      ARequest.Save;
    end;
  end;
end;

procedure TPaEARMonitor.CheckForPins(Tolerance : Double);
var
  Res, Res1 : Integer;
  Found : Boolean;
  RecPos : longint;
  ThisTotal : Double;
  OKToAuthorise : Boolean;
begin
  if MinutesBetween(Now, CompanyParams.LastPINCheck) >= CompanyParams.PINCheckInterval then
  begin
    CompanyParams.LastPINCheck := Now;
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit.Configuration.DataDirectory := DataPath(CompanyParams.Company);
    Res := FToolkit.OpenToolkit;
    with FToolkit do
    begin
      Transaction.Index := thIdxOurRef;
      Res := Transaction.GetGreaterThanOrEqual('PIN');
      while (Res = 0) and (Transaction.thDocType = dtPIN) do
      begin
        if (Transaction.thHoldFlag and 3 <> 3) and Transaction.entCanUpdate then
        begin
          Found := False;
          OKToAuthorise := False;
          Res1 := Transaction.thMatching.GetFirst;

          while (Res1 = 0) and not Found do
          begin
            Found := (Transaction.thMatching.maType = maTypeSPOP) and
                      (Copy(Transaction.thMatching.maPayRef, 1, 3) = 'POR');

            Res1 := Transaction.thMatching.GetNext;
          end;

          if Found then
          begin
            Transaction.SavePosition;
            RecPos := Transaction.Position;
            ThisTotal := Transaction.thTotals[TransTotNetInBase];
            Res1 := Transaction.GetEqual(Transaction.BuildOurRefIndex(Transaction.thMatching.maPayRef));
            OKToAuthorise := (Res1 = 0) and (Transaction.thHoldFlag and 3 = 3) and
                           (Abs(ThisTotal - Transaction.thTotals[TransTotNetInBase]) <= Tolerance);
            Transaction.Position := RecPos;
            Transaction.RestorePosition;

            if OKToAuthorise then
            begin
              Request.TotalValue := Transaction.thTotals[TransTotNetInBase];
              DoAuthorization('', erAutoAuth);
            end;
          end;

        end; //if Holdflag
        Res := Transaction.GetNext;
      end; //While Res = 0
    end; //with FToolkit
    CompanyParams.Save;
  end;
end;


procedure TPaEARMonitor.ProcessAuthQueue(Sender : TObject);
var
  Res, Res1 : SmallInt;
begin
  DeleteExpiredEars;
  if DebugModeOn then
    LogIt('Processing authorisation queue');
  Res := CompanyParams.GetFirst;

  while Res = 0 do
  begin
{    if CompanyParams.AuthOnConvert then
      CheckForPins(CompanyParams.PINTolerance);  Moved to TimerEvent}
    Request.Company := CompanyParams.Company;
    FCompany := Request.Company;
    Res1 := Request.GetFirst(True);

    while Res1 = 0 do
    begin
       User.Company := Request.Company;
       User.Index := 0;
       Res := User.GetEqual(Request.UserID);

       FReason := erNoProblem; //Until we know better

       Authorizer.Company := Request.Company;
       Authorizer.Index := AuthNameIdx;

       Res := Authorizer.GetEqual(Request.Authoriser);

      if Request.Status = esReadyToSend then
      begin
        Res1 := SendForAuthorisation(Request);

        if Res1 = 0 then
        begin
          Res1 := Request.Save;
          WriteSentForAuthNote;
        end;
      end
      else
      if Request.Status = esOKToAuthorise then
      begin
        AuthorizeEAR;
      end
      else
      if Request.Status in [esSentForApproval, esApprovedAndSent, esSentForAuth] then
      begin
        if Request.Status = esSentForApproval then
            Authorizer.GetEqual(Request.ApprovedBy);
        if NeedToTransfer(Request) then
        begin
          Try
            SendForTransfer(Request, Authorizer.Alternate);
          Except
            on E: Exception do
              LogIt('<Send for Transfer> ' + E.Message);
          End;
        end
        else
          Request.Cancel;
      end
      else
        Request.Cancel;

      Res1 := Request.GetNext(True);
    end;

    Res := CompanyParams.GetNext;
  end;

  TimerEvent(Self);
end;

procedure TPaEarMonitor.WriteSentForAuthNote;
var
  LNo : longint;
  OldStatus : longint;
  Res : SmallInt;
begin
 Try
  with FToolkit do
  begin
    OldStatus := Status;
    if Status = tkOpen then
      CloseToolkit;
    Configuration.DataDirectory := DataPath(Request.Company);
    Res := OpenToolkit;
    Transaction.Index := thIdxOurRef;
    Res := Transaction.GetEqual(Transaction.BuildOurRefIndex(Request.OurRef));
  end;

  if Res = 0 then
  begin
     with FToolkit.Transaction.Update do
     begin
       thHoldFlag := thHoldFlag or 32;
       Save(False);
     end;

     AddNotes(FormatDateTime('hh:mm', Time) +
            ': ' + FToolkit.Transaction.thOurRef + ' ' + 'Approved by  ' +
          Request.ApprovedBy + ' for ' + FormatMoney(Request.TotalValue),
          FToolkit.Transaction);


     AddNotes(FormatDateTime('hh:mm', Time) +
            ': Authorisation request for ' +
            FToolkit.Transaction.thOurRef + ' sent to ' +
          Request.Authoriser, FToolkit.Transaction);
  end;

  if OldStatus = tkClosed then
    FToolkit.CloseToolkit;
 Except

 End;
end;

procedure TPaEarMonitor.ProcessOutstandingAuthorisations;
var
  Res, i : SmallInt;
begin
  LogIt('Process outstanding authorisations');
  if Assigned(FToolkit) then
  with FToolkit do
  begin
    //update auth emails
    for i := 1 to Company.cmCount do
    begin
      Authorizer.Company := Company.cmCompany[i].coCode;
      Res := Authorizer.GetFirst;

      while Res = 0 do
      begin
        if Trim(Authorizer.DisplayEmail) = '' then
        begin
          Authorizer.DisplayEmail := Authorizer.Email;
          Authorizer.Email := LowerCase(Authorizer.Email);
        end;
        Res := Authorizer.GetNext;
      end;


    end;

    for i := 1 to Company.cmCount do
    begin
      Request.Company := Company.cmCompany[i].coCode;
      Res := Request.GetFirst;

      while Res = 0 do
      begin
        if Request.Status = esOKToAuthorise then
        begin
          User.Company := Request.Company;
          User.GetEqual(Request.UserID);

          Authorizer.Company := Request.Company;
          Authorizer.GetEqual(Request.Authoriser);

          if Status = tkOpen then
            CloseToolkit;
          Configuration.DataDirectory := Company.cmCompany[i].coPath;
          Res := OpenToolkit;
          if Res = 0 then
          begin
            Res :=
              Transaction.GetEqual(Transaction.BuildOurRefIndex(Copy(Request.EAR, 12, 9)));

            if Res = 0 then
            begin
              if Abs(Transaction.thNetValue - Request.TotalValue) < 0.001 then
              begin
                FSubject := Request.EAR;
                Try
                  AuthorizeEar;
                Except
                  on E : Exception do
                    LogIt('Exception in Authorize Ear: '#10#10 + E.Message);
                End;
              end
              else
              //Transaction has been changed so a new request must be done.
                Request.Delete;
            end;
          end;
        end;

        Res := Request.GetNext;
      end;


    end;

  end;
end;

function TPaEarMonitor.AuthFullName(const AName : ShortString) : ShortString;
begin
  Result := EntUserFullName(AName);
  if Trim(Result) = '' then
    Result := Trim(AName);
end;

//---------------------------- TPaHookObject methods -------------------------

procedure TPaHookUserObject.SetUserID(const Value : ShortString);
var
  Res : SmallInt;
begin
  FValidUser := False;
  Res := User.OpenFile;
  if Res = 0 then
  begin
    User.Company := FCompany;
    Res := User.GetEqual(Value);
    if Res = 0 then
    begin
      FUserID := Value;
      FValidUser := True;
    end;
  end
  else
    raise EBtrieveException.Create('Unable to open PA users file');
end;

function TPaHookUserObject.CanStoreTransaction(Value : Double) : Boolean;
begin
  Result := Value <= User.FloorLimit;
  if not Result and not FOverridden then
  begin
    OverrideUser(ovAboveFloorLimit, Value);
    Result := Value <= User.FloorLimit;
  end;
end;

function TPaHookUserObject.CanAuthorizeTransaction(Value : Double) : Boolean;
begin
  Result := Value <= User.AuthAmount;
end;

function TPaHookUserObject.AuthorizedUser(const ID, Pass : ShortString) : SmallInt;
var
  Res : Smallint;
begin
  Result := User.GetEqual(ID);
  if Result = 0 then
  begin
    with FToolkit do
    begin
      if FToolkit.Status = tkOpen then
        CloseToolkit;
      Configuration.DataDirectory := DataPath(User.Company);
      Result := OpenToolkit;
      if Result = 0 then
      begin
        {$IFDEF Debug}
        ShowMessage('Data directory: ' + Configuration.DataDirectory + #13 +
                    'User ID: ' + ID);
        {$ENDIF}
        Result := Functions.entCheckPassword(ID, Pass);
        {$IFDEF Debug}
        ShowMessage('Result of CheckPassword: ' + IntToStr(Result));
        {$ENDIF}
        CloseToolkit;
      end
      else
        ShowMessage('Unable to open COM Toolkit. Error: ' + QuotedStr(FToolkit.LastErrorString));
    end;
  end
  else
    ShowMessage('Unable to find user ' + QuotedStr(ID) + ' in Users table');
end;

function TPaHookUserObject.OverrideUser(Why : integer; Value : Double) : integer;
var
  s : ShortString;
  AuRes  : SmallInt;
  ValRes : Boolean;
  OldUser : ShortString;
begin
//Display a dialog for another user to enter their details
  with TfrmPaUserID.Create(nil) do
  begin
    Try
      Case Why and not ovAllowEAR of
        ovUserNotFound,
        ovUserNotFoundA   : s := 'Your User ID has not been identified.';
        ovAboveFloorLimit : s := 'This transaction is above the limit you are allowed to add.';
        ovAboveAuthLimit  : s := 'This transaction is above the limit you can authorise.';
      end;

      lblReason.Caption := s;
      if Why and ovAllowEAR = ovAllowEAR then
      begin
        Label3.Caption := Label3.Caption + #10#10 +
                         'Alternatively press the EAR button to generate ' +
                         'an Electronic Authorisation Request';
        Label3.Top := Label3.Top - 20;
        Label3.Height := Label3.Height + 20;
        btnEAR.Visible := True;
      end;
      ShowModal;
      if ModalResult = mrOK then
      begin
        OldUser := User.UserID;
        AuRes := AuthorizedUser(edtUserID.Text, edtPassword.Text);
        if AuRes = 0 then
        begin
          Case Why of
              ovUserNotFound,
              ovAboveFloorLimit : ValRes := CanStoreTransaction(Value);
              ovAboveAuthLimit,
              ovUserNotFoundA   : ValRes := CanAuthorizeTransaction(Value);
          end;
        end
        else
        begin
          User.UserID := OldUser;
          User.GetEqual(OldUser);
        end;
      end;

      while not (ModalResult in  [mrCancel, mrRetry]) and ((AuRes <> 0) or not ValRes) do
      begin
        if (AuRes = 30001) or (AuRes = 4) then
          ShowComMessage('Invalid user name')
        else
        if AuRes = 30002 then
          ShowComMessage('Invalid user password')
        else
        if not ValRes then
          ShowComMessage('Amount is above this User''s limit');

        ShowModal;
        if ModalResult = mrOK then
        begin
          AuRes := AuthorizedUser(edtUserID.Text, edtPassword.Text);
          if AuRes = 0 then
          begin
            Case Why of
              ovUserNotFound,
              ovAboveFloorLimit : ValRes := CanStoreTransaction(Value);
              ovAboveAuthLimit,
              ovUserNotFoundA   : ValRes := CanAuthorizeTransaction(Value);
            end;
          end
          else
          begin
            User.UserID := OldUser;
            User.GetEqual(OldUser);
          end;

        end;
      end;
      if ModalResult = mrOK then
      begin
        UserID := edtUserID.Text;
        FOverridden := True;
      end;

      Result := ModalResult;
    Finally
      Free;
{      if not IsLibrary then
        SetForegroundWindow(Form1.EntCustom1.IntF.SysFunc.hwnd);}
    End;
  end;
end;

procedure TPaHookUserObject.ShowError;
const
  cs = 'You must either edit it so that it is within your floor limit or have someone' +
       ' with a high enough floor limit save it.';
  ds = 'A valid user must save this transaction.';
var
  s : string;

begin
  Case FErrorStatus of
    ehStoredAndAuthorized : s := 'Transaction has been stored and authorised';
    ehStoredNotAuthorized : s := 'Transaction has been stored but requires authorisation';
    ehAboveFloorLimit     : s := 'This transaction is above your floor limit. ' + cs;
    ehInvalidUser         : s := 'No valid user was found. ' + ds;
    ehInvalidUserOnAuthorize : s := 'No valid user was found.  Transaction has not been authorised';
  end;

  if FErrorStatus <> ehStoredAndAuthorized then
    ShowComMessage(s);
end;

procedure TPaHookUserObject.Authorize(const TransRef : ShortString);
var
  Res : SmallInt;
begin
   with FToolkit do
   begin
     if Status = tkClosed then
     begin
       if FToolkit.Status = tkOpen then
         FToolkit.CloseToolkit;
       Configuration.DataDirectory := FCompanyPath;
       Res := OpenToolkit;
     end
     else
       Res := 0;

     if Res = 0 then
     begin
       with Transaction do
       begin
          Res := GetEqual(BuildOurRefIndex(TransRef));
          if Res = 0 then
          begin
            if FindAndLockRequest(TransRef) then
            begin
            {Look for request - if it's already been sent then we need to set the status
             to authorised.}
              DoAuthorization(User.UserName, erNoProblem);
              if Request.DocType in [edtPIN, edtSQU] then
                Request.Delete  //we have to hold on to other types for now
              else
              if Request.DocType in [edtPOR, edtPQU] then
              begin
                Request.Status := esAuthorised;
                Request.Save;
              end;
            end
            else
            begin
            {DoAuthorization takes the value from the request.  As we don't have
            a request here we'll just put the total in so that it gets into the notes ok.}
              Request.TotalValue := thTotals[TransTotNetInBase];
              DoAuthorization(User.UserName, erNoProblem);
            end;
          end;
       end;
     end;

      if Res <> 0 then
        raise EComTKException.Create('Error in COM Toolkit: ' +
                                         LastErrorString);
   end;//with FToolkit
   ShowComMessage('Transaction authorised');
end;


procedure StartToolkit;
var
  a, b, c : longint;

begin
//  Try
    FToolkit := CreateOLEObject('Enterprise04.Toolkit') as IToolkit;
    if Assigned(FToolkit) then
    begin
      EncodeOpCode(97, a, b, c);
      FToolkit.Configuration.SetDebugMode(a, b, c);
    end;

  if not Assigned(FToolkit) then
    raise EComTkException.Create('Unable to create COM Toolkit');
end;


procedure EndToolkit;
begin
  FToolkit := nil;
end;

procedure CreateObjects;
begin
  PaObject := TPaObject.Create;
  PaObject.OpenFiles;
  PaEARGenerator := TPaEARGenerator.Create;
  PaEARGenerator.OpenFiles;
  PaHookUserObject := TPaHookUserObject.Create;
  PaHookUserObject.OpenFiles;
end;

procedure FreeObjects;
begin
  if Assigned(PaObject) then
    FreeAndNil(PaObject);
  if Assigned(PaEARGenerator) then
    FreeAndNil(PaEARGenerator);
  if Assigned(PaHookUserObject) then
    FreeAndNil(PaHookUserObject);
end;

procedure TPaEARMonitor.CheckTimer(Secs: Integer);
begin
  TimerEvent(Self);
end;

{ TPaKPIObject }

procedure TPaKPIObject.Process(Reject : Boolean; RejectReason : ShortString);
var
  Req : ShortString;
  Txt : AnsiString;
begin
  Req := Request.MakeEmailSubjectString;
  if not Reject then
    Req := AnsiReplaceStr(Req, 'xxxxxxxxxx', Authorizer.AuthCode);
  if RejectReason = '' then
    Txt := ' '
  else
    Txt := RejectReason;
  ProcessEar(Authorizer.Email, Req, PChar(Txt));
end;

Initialization
  PaObject := nil;
  PaEARGenerator := nil;
  PaHookUserObject := nil;



end.

