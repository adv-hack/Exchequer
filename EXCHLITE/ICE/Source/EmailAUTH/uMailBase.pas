Unit uMailBase;

Interface

Uses Windows, SysUtils, Classes, Activex, Messages,
  uMailMessage,

  {indy components}
  IdExplicitTLSClientServerBase, idSSLOpenSSL

  ;

Const
  cUSE_TLS: Array[1..4] Of TIdUseTLS = (
    utNoTLSSupport,
    utUseImplicitTLS, // normally that is the common connection
    utUseRequireTLS,
    utUseExplicitTLS
    );

  cTIMEOUT = 60000;

Type
  TOnError = Procedure(Sender: TObject; Const pWhere, pError: String) Of Object;
  TOnBeforeSend = Procedure(Sender: TObject; const pMail: TMailMessage; Var
    pCanSend: Boolean) Of Object;
  TOnAfterSend = Procedure(Sender: TObject) Of Object;
  TOnAfterConnect = Procedure(Sender: TObject) Of Object;

  TEmailBase = Class
  Private
    fIncomingPort: Integer;
    fOutgoingPort: Integer;
    fHost: String;
    fOnError: TOnError;
    fOnBeforeSend: TOnBeforeSend;
    fUseAuthentication: Boolean;
    fUserName: String;
    fPassword: String;
    fProfile: String;
    fUseTLS: TIdUseTLS;
    fSSLVersion: TIdSSLVersion;
    fPassThrough: Boolean;
    fUseIndySASL: Boolean;
    fAttachDirectory: String;
    fTimeout: Integer;
    fOnAfterConnect: TOnAfterConnect;
    fOnAfterSend: TOnAfterSend;
    fKeepTrying: Boolean;
    fUseDefaultProfile: Boolean;
    fMailBoxSeparator: Char;
    fMailBox: String;
    Function GetAttachDirectory: String;
  Protected
    Function GetConnected: Boolean; Virtual; Abstract;
    Procedure SetConnected(Const Value: Boolean); Virtual; Abstract;
    Function GetMail(Index: Integer): TMailMessage; Virtual; Abstract;

    Property Host: String Read fHost Write fHost;
    Property IncomingPort: Integer Read fIncomingPort Write fIncomingPort;
    Property OutgoingPort: Integer Read fOutgoingPort Write fOutgoingPort;
    Property UserName: String Read fUserName Write fUserName;
    Property Password: String Read fPassword Write fPassword;
    Property UseTLS: TIdUseTLS Read fUseTLS Write fUseTLS;
    Property SSLVersion: TIdSSLVersion Read fSSLVersion Write fSSLVersion;
    Property PassThrough: Boolean Read fPassThrough Write fPassThrough;
    Property UseIndySASL: Boolean Read fUseIndySASL Write fUseIndySASL;
    Property Timeout: Integer Read fTimeout Write fTimeout;

    // IMAP pop
    Property MailBox: String Read fMailBox Write fMailBox;
    property MailBoxSeparator: Char read fMailBoxSeparator write fMailBoxSeparator;

    /// MAPI
    Property Profile: String Read fProfile Write fProfile;
    property UseDefaultProfile: Boolean read fUseDefaultProfile write fUseDefaultProfile;
    
    Function DeleteMail(Index: Integer): Boolean; Virtual; Abstract;
    Function SendMail(pMail: TMailMessage): Boolean; Virtual; Abstract;

    Property Mail[Index: Integer]: TMailMessage Read GetMail; Default;
  Public
    Destructor Destroy; Override;
    Constructor Create; Virtual;
    Procedure DoErrorMessage(Const pWhere, pError: String);
    Procedure SetMessageToDelete(index: Integer); virtual;
  Published
    Property OnError: TOnError Read fOnError Write fOnError;
    Property OnBeforeSend: TOnBeforeSend Read fOnBeforeSend Write fOnBeforeSend;
    Property OnAfterSend: TOnAfterSend Read fOnAfterSend Write fOnAfterSend;
    Property OnAfterConnect: TOnAfterConnect Read fOnAfterConnect Write
      fOnAfterConnect;

    Property Connected: Boolean Read GetConnected Write SetConnected;
    Property UseAuthentication: Boolean Read fUseAuthentication Write
      fUseAuthentication;
    Property AttachDirectory: String Read GetAttachDirectory Write fAttachDirectory;
    property KeepTrying: Boolean read fKeepTrying write fKeepTrying default False; 
  End;

Function sysTempPath: String;
Function FileSize(Const FileName: String): LongInt;
Function GenerateUniqueName: String;
Procedure Delay(msecs: Longint);

Implementation

{-----------------------------------------------------------------------------
  Procedure: sysTempPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function sysTempPath: String;
Var
  Buffer: Array[0..MAX_PATH] Of Char;
Begin
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1, Buffer));
End;

{-----------------------------------------------------------------------------
  Procedure: FileSize
  Author:    vmoura
-----------------------------------------------------------------------------}
Function FileSize(Const FileName: String): LongInt;
Var
  SearchRec: TSearchRec;
Begin { !Win32! -> GetFileSize }
  Result := 0;
  If FindFirst(ExpandUNCFileName(FileName), faAnyFile, SearchRec) = 0 Then
    Result := SearchRec.Size;
  FindClose(SearchRec);
End;

{-----------------------------------------------------------------------------
  Procedure: GenerateUniqueName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function GenerateUniqueName: String;
Var
  lGuid: TGUID;
Begin
  Try
    CoCreateGuid(lGuid);
    Result := GUIDToString(lGuid);
  Except
    Result := IntToStr(GetTickCount);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Delay
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure Delay(msecs: Longint);
Var
  targettime: Longint;
  Msg: TMsg;
Begin
  targettime := GetTickCount + msecs;
  While targettime > GetTickCount Do
    If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then
    Begin
      If Msg.message = WM_QUIT Then
      Begin
        {transmit the message to the form}
        TranslateMessage(Msg);
        DispatchMessage(Msg);
        Break;
      End; {If Msg.message = cMCMMESSAGE Then}

      TranslateMessage(Msg);
      DispatchMessage(Msg);
    End; {If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then}
End;

{ TEmailBase }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TEmailBase.Create;
Begin
  Inherited Create;
  CoInitialize(Nil);

  fOnError := Nil;
  fOnBeforeSend := Nil;
  fOnAfterConnect := Nil;
  fOnAfterSend := Nil;

  fSSLVersion := sslvSSLv2;
  fTimeout := cTIMEOUT;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TEmailBase.Destroy;
Begin
  If Assigned(fOnError) Then
    fOnError := Nil;

  If Assigned(fOnBeforeSend) Then
    fOnBeforeSend := Nil;

  If Assigned(fOnAfterConnect) Then
    fOnAfterConnect := Nil;

  If Assigned(fOnAfterSend) Then
    fOnAfterSend := Nil;

  CoUninitialize;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetAttachDirectory
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TEmailBase.GetAttachDirectory: String;
Begin
  If (Trim(fAttachDirectory) = '') Or Not DirectoryExists(fAttachDirectory) Then
    fAttachDirectory := sysTempPath;

  Result := fAttachDirectory;
End;

{-----------------------------------------------------------------------------
  Procedure: DoErrorMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TEmailBase.DoErrorMessage(Const pWhere, pError: String);
Begin
  If Assigned(OnError) Then
    OnError(Self, pWhere, pError);
End;

{-----------------------------------------------------------------------------
  Procedure: SetMessageToDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TEmailBase.SetMessageToDelete(index: Integer);
begin

end;

End.

