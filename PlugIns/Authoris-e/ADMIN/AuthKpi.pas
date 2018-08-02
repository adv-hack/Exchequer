unit AuthKpi;

interface

uses
  AuthObjs, AuthVar, Classes, KPIInt, Contnrs;

type

  TRequest = Class(TInterfacedObject, IRequest)
  private
    FOurRef : string;
    FDate   : string;
    FValue  : Double;
  protected
    function GetOurRef : ShortString;
    procedure SetOurRef(const Value : ShortString);
    function GetDate   : ShortString;
    procedure SetDate(const Value : ShortString);
    function GetValue  : Double;
    procedure SetValue(Value : Double);
  public
    property OurRef : ShortString read GetOurRef write SetOurRef;
    property RequestDate : ShortString read GetDate write SetDate;
    property RequestValue : Double read GetValue write SetValue;
  end;

  TRequestList = Class(TInterfacedObject, IRequestList)
  private
    FList : TList;
  protected
    function GetCount : Integer;
    function GetItem(Index : Integer) : IRequest;
  public
    procedure Add(AnItem : Pointer);
    constructor Create;
    destructor Destroy; override;
  end;

  function GetRequests(CompanyCode,
                       UserID,
                       Password     : ShortString;
                       CutOffDays   : SmallInt) : IRequestList; StdCall; Export;

  function AuthoriseRequest(CompanyCode,
                            UserID,
                            Password,
                            OurRef      : ShortString;
                            Reject      : WordBool;
                            RejectReason : ShortString) : SmallInt; StdCall; Export;

  function GetUserLimits(    CompanyCode : PChar;
                             UserCode    : PChar;
                         var FloorLimit  : Double;
                         var AuthLimit   : Double) : Integer; StdCall; Export;




implementation

uses
  SysUtils, CTKUtil04, Crypto;

type
  TRequestRec = Record
    RequestO : TRequest;
    RequestI : IRequest;
  end;



function GetUserValues(const CompanyCode, UserCode : String;
                         var FloorLimit : Double;
                         var AuthLimit  : Double) : Integer;
var
  Res : Integer;
  UserObject : TPaObject;
begin
  Result := 4;
  UserObject := TPaObject.Create;
  Try
    UserObject.CompanyCode := CompanyCode;
    UserObject.OpenFiles;
    UserObject.User.Company := CompanyCode;
    if UserObject.User.GetEqual(UserCode) = 0 then
    begin
      FloorLimit := UserObject.User.FloorLimit;
      AuthLimit := UserObject.User.AuthAmount;
      Result := 0;
    end;
  Finally
    UserObject.Free;
  End;
end;

function GetUserLimits(    CompanyCode : PChar;
                           UserCode    : PChar;
                       var FloorLimit  : Double;
                       var AuthLimit   : Double) : Integer; StdCall;
begin
  Result := GetUserValues(AnsiString(CompanyCode), AnsiString(UserCode), FloorLimit, AuthLimit);
end;


function AuthoriserIsValid(AuthObject : TPaObject;
                           CompanyCode,
                           UserID,
                           Password     : ShortString) : Boolean;
var
  Res : Integer;
begin
  Result := False;
  AuthObject.Authorizer.Company := CompanyCode;
  AuthObject.Authorizer.Index := AuthNameIdx;
  Res := AuthObject.Authorizer.GetEqual(UserID);
  if Res = 0 then
    Result := Trim(Password) = Trim(AuthObject.Authorizer.AuthCode);

end;

procedure LoadRequests(AuthObject : TPaObject; CutOffDays : SmallInt; ResultList : TRequestList);
var
  Res : Integer;
  CutOffString : string;
  ThisRequest : TRequest;
  ThisRequestRec : ^TRequestRec;

  function ThisAuthoriser : Boolean;
  begin
     Result := (AuthObject.Request.Status in [esApprovedAndSent, esSentForAuth]) and
               (Trim(AuthObject.Request.Authoriser) = Trim(AuthObject.Authorizer.Name))
  end;

  function ThisApprover : Boolean;
  begin
    Result := (AuthObject.Request.Status = esSentForApproval) and
               (Trim(AuthObject.Request.ApprovedBy) = Trim(AuthObject.Authorizer.Name))

  end;

begin
  CutOffString := FormatDateTime('yyyymmddhhnn', Now - CutOffDays);
  AuthObject.Request.Company := AuthObject.CompanyCode;
  AuthObject.Request.Index := ReqDateIdx;
  Res := AuthObject.Request.GetLast;
  While (Res = 0) and (AuthObject.Request.DateAsString >= CutOffString) do
  begin
    if ThisAuthoriser or ThisApprover then
    begin
      //Add to list
      New(ThisRequestRec);
      ThisRequest := TRequest.Create;
      ThisRequest.OurRef := AuthObject.Request.OurRef;
      ThisRequest.RequestDate := AuthObject.Request.DateAsString;
      ThisRequest.RequestValue := AuthObject.Request.TotalValue;

      ThisRequestRec.RequestO := ThisRequest;
      ThisRequestRec.RequestI := ThisRequest;

      ResultList.Add(ThisRequestRec);
    end;

    Res := AuthObject.Request.GetPrevious;

  end;
end;

function GetRequests(CompanyCode,
                     UserID,
                     Password     : ShortString;
                     CutOffDays   : SmallInt) : IRequestList;
var
  Res : Integer;
  AuthObject : TPaObject;
  TheList : TRequestList;
begin
  Result := nil;
  TheList := TRequestList.Create;
  AuthObject := TPaObject.Create;
  Try
    AuthObject.CompanyCode := CompanyCode;
    AuthObject.OpenFiles;
    if AuthoriserIsValid(AuthObject, CompanyCode, UserID, Password) then
    begin
      LoadRequests(AuthObject, CutOffDays, TheList);
      Result := TheList;
    end;
  Finally
      AuthObject.Free;
  End;
end;

function RequestIsValid(AuthObject : TPaObject;
                        CompanyCode,
                        OurRef    : ShortString) : Boolean;
var
  Res : Integer;
begin
  Result := False;
  AuthObject.Request.Company := CompanyCode;
  AuthObject.Request.Index := ReqEARIdx;
  Result := AuthObject.Request.GetEqual(AuthObject.MakeRequestString(CompanyCode, OurRef)) = 0;
end;


function AuthoriseRequest(CompanyCode,
                          UserID,
                          Password,
                          OurRef       :  ShortString;
                          Reject       :  WordBool;
                          RejectReason : ShortString) : SmallInt;
var
  Res : Integer;
  AuthObject : TPaKPIObject;
begin
  Result := 0;
  AuthObject := TPaKPIObject.Create;
  Try
    StartToolkit;
    AuthObject.CompanyCode := CompanyCode;
    AuthObject.OpenFiles;
    FToolkit.Configuration.DataDirectory := CompanyPathFromCode(FToolkit, CompanyCode);
    if AuthoriserIsValid(AuthObject, CompanyCode, UserID, Password) then
    begin
      if RequestIsValid(AuthObject, CompanyCode, OurRef) then
        AuthObject.Process(Reject, RejectReason)
      else
        Result := 2;
    end
    else
      Result := 1;
  Finally
    AuthObject.CloseFiles;
    AuthObject.Free;
    FToolkit := nil;
  End;
end;

{ TRequest }

function TRequest.GetDate: ShortString;
begin
  Result := FDate;
end;

function TRequest.GetOurRef: ShortString;
begin
  Result := Self.FOurRef;
end;

function TRequest.GetValue: Double;
begin
  Result := FValue;
end;

procedure TRequest.SetDate(const Value: ShortString);
begin
  FDate := Value;
end;

procedure TRequest.SetOurRef(const Value: ShortString);
begin
  FOurRef := Value;
end;

procedure TRequest.SetValue(Value: Double);
begin
  FValue := Value;
end;

{ TRequestList }

procedure TRequestList.Add(AnItem: Pointer);
begin
  FList.Add(AnItem);
end;

constructor TRequestList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TRequestList.Destroy;
var
  TmpItem : ^TRequestRec;
begin
  while FList.Count > 0 do
  begin
    TmpItem := FList[0];
    TmpItem.RequestI := nil;

    FList.Delete(0);
  end;

  FList.Free;
  inherited;
end;

function TRequestList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TRequestList.GetItem(Index: Integer): IRequest;
var
  ThisRequestRec : ^TRequestRec;
begin
  ThisRequestRec := FList[Index];
  Result := ThisRequestRec.RequestI;
end;

Initialization
  ChangeCryptoKey(19701115);

end.
