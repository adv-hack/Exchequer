{-----------------------------------------------------------------------------
 Unit Name: uInterfaces
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uInterfaces;

Interface

Type
  TMessageInfo = Class
  Private
    fGuid: TGUID;
    fCompany_Id: LongWord;
    fSubject: WideString;
    fFrom: WideString;
    fTo_: WideString;
    fMsgBody: WideString;
    fPack_Id: LongWord;
    fTotalItens: Longword;
    fStatus: Smallint;
    fDate: TDateTime;
    fParam1: WideString;
    fParam2: WideString;
    fScheduleId: Longword;
    fMode: SmallInt;
    fTotalDone: Longword;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Assign(MessageInfo: TMessageInfo);
    Property Guid: TGUID Read fGuid Write fGuid;
    Property Company_Id: LongWord Read fCompany_Id Write fCompany_Id;
    Property Subject: WideString Read fSubject Write fSubject;
    Property From: WideString Read fFrom Write fFrom;
    Property To_: WideString Read fTo_ Write fTo_;
    Property MsgBody: WideString Read fMsgBody Write fMsgBody;
    Property Pack_Id: LongWord Read fPack_Id Write fPack_Id;
    Property TotalItens: Longword Read fTotalItens Write fTotalItens;
    Property Status: Smallint Read fStatus Write fStatus;
    Property Date: TDateTime Read fDate Write fDate;
    Property Param1: WideString Read fParam1 Write fParam1;
    Property Param2: WideString Read fParam2 Write fParam2;
    Property ScheduleId: Longword Read fScheduleId Write fScheduleId;
    Property Mode: Smallint Read fMode Write fMode;
    property TotalDone: Longword read fTotalDone write fTotalDone;
  End;

  TDailySchedule = Class
  Private
    fAllDays: Boolean;
    fWeekDays: Boolean;
    fEveryYDay: Integer;
    fStartTime: TDateTime;
    fStartDate: TDatetime;
    fEndDate: TDatetime;
  Published
    Property StartDate: TDatetime Read fStartDate Write fStartDate;
    Property EndDate: TDatetime Read fEndDate Write fEndDate;
    Property StartTime: TDateTime Read fStartTime Write fStartTime;
    Property AllDays: Boolean Read fAllDays Write fAllDays;
    Property WeekDays: Boolean Read fWeekDays Write fWeekDays;
    {everday means something that happens every x days }
    Property EveryYDay: Integer Read fEveryYDay Write fEveryYDay;
  End;

  TPackageInfo = Class
  Private
    fId: LongWord;
    fGuid: TGuid;
    fUserReference: Longword;
    fDescription: WideString;
    fCompany_Id: LongWord;
    fExCode: WideString;
    fPluginLink: WideString;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Property Id: LongWord Read fId Write fId;
    Property Company_Id: LongWord Read fCompany_Id Write fCompany_Id;
    Property Description: WideString Read fDescription Write fDescription;
    Property ExCode: WideString Read fExCode Write fExCode;
    Property Guid: TGuid Read fGuid Write fGuid;
    Property UserReference: Longword Read fUserReference Write fUserReference;
    Property PluginLink: WideString Read fPluginLink Write fPluginLink;
  End;

  TCompany = Class
  Private
    fId: integer;
    fDesc: String;
    fExCode: String;
    fActive: Boolean;
    fPeriods: Integer;
    fDirectory: String;
    fGuid: String;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Assign(pCompany: TCompany);
  Published
    Property Id: integer Read fId Write fId;
    Property Desc: String Read fDesc Write fDesc;
    Property ExCode: String Read fExCode Write fExCode;
    Property Active: Boolean Read fActive Write fActive;
    Property Periods: Integer Read fPeriods Write fPeriods;
    Property Directory: String Read fDirectory Write fDirectory;
    Property Guid: String Read fGuid Write fGuid;
  End;

  TCISMessage = Class
  Private
    fPolling: integer;
    fFileGuid: Widestring;
    fcorrelationid: Widestring;
    fIrMark: Widestring;
    fRedirection: Widestring;
    fCISClassType: Widestring;
    fOutboxGuid: Widestring;
    fCompanyId: Cardinal;
    fUseTestGateway: Boolean;
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Assign(pCIS: TCISMessage);
  Published
    property OutboxGuid: Widestring read fOutboxGuid write fOutboxGuid;
    Property IrMark: Widestring Read fIrMark Write fIrMark;
    Property CorrelationID: Widestring Read fcorrelationid Write fcorrelationid;
    property CISClassType: Widestring read fCISClassType write fCISClassType;
    Property Polling: integer Read fPolling Write fPolling;
    Property Redirection: Widestring Read fRedirection Write fRedirection;
    Property FileGuid: Widestring Read fFileGuid Write fFileGuid;
    property CompanyID: Cardinal read fCompanyId write fCompanyId;
    property UseTestGateway: Boolean read fUseTestGateway write fUseTestGateway; 
  End;

  TEmailAccount = class
  private
    fIsDefaultOutgoing: boolean;
    fPassword: String;
    fOutgoingServer: String;
    fUserName: String;
    fYourEmail: String;
    fIncomingServer: String;
    fYourName: String;
    fAuthentication: Boolean;
    fUseSSLIncomingPort: Boolean;
    fUseSSLOutgoingPort: Boolean;
    fIncomingPort: Integer;
    fOutgoingPort: Integer;
    fOutgoingUserName: String;
    fOutgoingPassword: String;
    fServerType: String;
    fEmailSystem_ID: Integer;
    fMailBoxSeparator: Char;
    fMailBoxName: String;
    function GetUseSameLoginAsIncoming: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(pEmailAccount: TEmailAccount);
  published
    property EmailSystem_ID: Integer read fEmailSystem_ID write fEmailSystem_ID;
    property YourName: String read fYourName write fYourName;
    property YourEmail: String read fYourEmail write fYourEmail;
    property ServerType: String read fServerType write fServerType;
    property IsDefaultOutgoing: boolean read fIsDefaultOutgoing write fIsDefaultOutgoing;
    property IncomingServer: String read fIncomingServer write fIncomingServer;
    property OutgoingServer: String read fOutgoingServer write fOutgoingServer;
    property UserName: String read fUserName write fUserName;
    property Password: String read fPassword write fPassword;
    property IncomingPort: Integer read fIncomingPort write fIncomingPort;
    property OutgoingPort: Integer read fOutgoingPort write fOutgoingPort;
    // advanced
    property Authentication: Boolean read fAuthentication write fAuthentication;
    property OutgoingUserName: String read fOutgoingUserName write fOutgoingUserName;
    property OutgoingPassword: String read fOutgoingPassword write fOutgoingPassword;
    property UseSSLIncomingPort: Boolean read fUseSSLIncomingPort write fUseSSLIncomingPort;
    property UseSSLOutgoingPort: Boolean read fUseSSLOutgoingPort write fUseSSLOutgoingPort;
    property MailBoxName: String read fMailBoxName write fMailBoxName;
    property MailBoxSeparator: char read fMailBoxSeparator write fMailBoxSeparator;
    property UseSameLoginAsIncoming: Boolean read GetUseSameLoginAsIncoming;
  end;

  TEmailSystem = class
  private
    fActive: Boolean;
    fOutgoingGuid: String;
    fDescription: String;
    fIncomingGuid: String;
    fServerType: String;
    fId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Id: Integer read fId write fId;
    property ServerType: String read fServerType write fServerType;
    property Description: String read fDescription write fDescription;
    property IncomingGuid: String read fIncomingGuid write fIncomingGuid;
    property OutgoingGuid: String read fOutgoingGuid write fOutgoingGuid;
    property Active: Boolean read fActive write fActive;
  end;

Implementation

uses Sysutils, uConsts;

{ TMessageInfo }

{-----------------------------------------------------------------------------
  Procedure: Assign
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMessageInfo.Assign(MessageInfo: TMessageInfo);
Begin
  If MessageInfo <> Nil Then
  Begin
    fGuid := MessageInfo.Guid;
    fCompany_Id := MessageInfo.Company_Id;
    fSubject := MessageInfo.Subject;
    fFrom := MessageInfo.From;
    fTo_ := MessageInfo.To_;
    fMsgBody := MessageInfo.MsgBody;
    fPack_Id := MessageInfo.Pack_Id;
    fTotalItens := MessageInfo.TotalItens;
    fStatus := MessageInfo.Status;
    fDate := MessageInfo.Date;
    fParam1 := MessageInfo.Param1;
    fParam2 := MessageInfo.Param2;
    fScheduleId := MessageInfo.ScheduleId;
    Mode := MessageInfo.Mode;
    fTotalDone := MessageInfo.TotalDone;

  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TMessageInfo.Create;
Begin
  Inherited Create;

  FillChar(fGuid, SizeOf(TGUID), 0);
  fCompany_Id := 0;
  fSubject := '';
  fFrom := '';
  fTo_ := '';
  fMsgBody := '';
  fPack_Id := 0;
  fTotalItens := 0;
  fStatus := 0;
  fDate := 0;
  fParam1 := '';
  fParam2 := '';
  fScheduleId := 0;
  fMode := 0;
  fTotalDone := 0;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TMessageInfo.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TPackageInfo.Create;
Begin
  Inherited Create;
  fId := 0; ;
  FillChar(fGuid, SizeOf(TGUID), 0);
  fUserReference := 0;
  fDescription := '';
  fPluginLink := '';
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TPackageInfo.Destroy;
Begin
  Inherited Destroy;
End;

{ TCompany }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TCompany.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCompany.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Assign
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCompany.Assign(pCompany: TCompany);
Begin
  If Assigned(pCompany) Then
  Begin
    fId := pCompany.Id;
    fDesc := pCompany.Desc;
    fExCode := pCompany.ExCode;
    fActive := pCompany.Active;
    fPeriods := pCompany.Periods;
    fDirectory := pCompany.Directory;
    fGuid := pCompany.Guid;
  End;
End;

{ TCISMessage }

{-----------------------------------------------------------------------------
  Procedure: Assign
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISMessage.Assign(pCIS: TCISMessage);
Begin
  If Assigned(pCis) Then
  Begin
    fOutboxGuid := pCis.OutboxGuid;
    fPolling := pCIS.fPolling;
    fFileGuid := pCIS.FileGuid;
    fcorrelationid := pCIS.CorrelationID;
    fCISClassType := pCis.CISClassType;
    fIrMark := pCIS.IrMark;
    fRedirection := pCIS.Redirection;
    fCompanyId := pCis.CompanyID;
    fUseTestGateway := pCis.UseTestGateway;
  End; {If Assigned(pCis) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TCISMessage.Create;
Begin
  Inherited Create;
  fPolling := 10;
  fFileGuid := '';
  fcorrelationid := '';
  fIrMark := '';
  fRedirection := '';
  fCISClassType := '';
  fOutboxGuid := '';
  fCompanyId := 0;
  fUseTestGateway := True;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCISMessage.Destroy;
Begin
  Inherited Destroy;
End;

{ TEmailAccount }

constructor TEmailAccount.Create;
begin
  Inherited Create;

  fIncomingPort := cPOP3DEFAULTPORT;
  fOutgoingPort := cSMTPDEFAULTPORT;
end;

destructor TEmailAccount.Destroy;
begin
  inherited Destroy;
end;

procedure TEmailAccount.Assign(pEmailAccount: TEmailAccount);
begin
  if pEmailAccount <> nil then
  begin
    Self.EmailSystem_ID := pEmailAccount.EmailSystem_ID; 
    Self.YourName := pEmailAccount.YourName;
    Self.YourEmail := pEmailAccount.YourEmail;
    Self.ServerType := pEmailAccount.ServerType;
    Self.IsDefaultOutgoing := pEmailAccount.IsDefaultOutgoing;
    Self.IncomingServer := pEmailAccount.IncomingServer;
    Self.OutgoingServer := pEmailAccount.OutgoingServer;
    Self.UserName := pEmailAccount.UserName;
    Self.Password := pEmailAccount.Password;
    Self.IncomingPort := pEmailAccount.IncomingPort;
    Self.OutgoingPort := pEmailAccount.OutgoingPort;
    Self.Authentication := pEmailAccount.Authentication;
    Self.OutgoingUserName := pEmailAccount.OutgoingUserName;
    Self.OutgoingPassword := pEmailAccount.OutgoingPassword;
    Self.UseSSLIncomingPort := pEmailAccount.UseSSLIncomingPort;
    Self.UseSSLOutgoingPort := pEmailAccount.UseSSLOutgoingPort;
    Self.MailBoxName := pEmailAccount.MailBoxName;
    Self.MailBoxSeparator := pEmailAccount.MailBoxSeparator;
  end;
end;

function TEmailAccount.GetUseSameLoginAsIncoming: Boolean;
begin
  Result := (Lowercase(trim(UserName)) = Lowercase(trim(OutgoingUserName))) and
     (Lowercase(trim(Password)) = Lowercase(trim(OutgoingPassword)))
end;

{ TEmailSystem }

constructor TEmailSystem.Create;
begin
  Inherited Create;
end;

destructor TEmailSystem.Destroy;
begin
  inherited Destroy;
end;

End.

