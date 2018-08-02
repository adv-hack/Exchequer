unit EmailFax;

{ prutherford440 10:08 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtils,
  CommsInt, StdCtrls, Email, msSmtp, msmsg, Mssocket, msMsgCls, MapiEx;

type
  TfrmEmail = class(TForm)
    msMessage1: TmsMessage;
    msSMTP1: TmsSMTPClient;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FUseExtended : Boolean;
  public
    { Public declarations }
    MAPI : TEmail;
    MAPIx : TMapiExEmail;
    procedure SetExtMAPI;
  end;


Function ECMAPIAVAILABLE : WordBool; Export; StdCall;

Function ECSENDEMAIL (Const Info : EmailInfoType) : SmallInt; Export; StdCall;

Function ECERRORSTRING : ShortString; Export; StdCall;

var
  ErrString : ShortString;

implementation

{$R *.DFM}

Uses APIUtil;

Function ECERRORSTRING : ShortString; Export; StdCall;
begin
  Result := ErrString;
end;

procedure LogIt(const Msg : string; const Dir : string);
{$IFDEF 5Star}
var
  F : TextFile;
  FName : string;
begin
  FName := IncludeTrailingBackslash(Dir) + 'EmailLog.txt';
  Assign(F, FName);
  if FileExists(FName) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, Msg);
  CloseFile(F);
{$ELSE}
begin  
{$ENDIF}
end;


{ Returns True if MAPI is OK }
Function ECMAPIAVAILABLE : WordBool;
Var
  frmEmail : TfrmEmail;
  CurrDir  : ShortString;
Begin { ecMapiAvailable }
  Result := False;

  // HM 08/10/01: The MAPIAvailable call was changing the directory to the MAPI dir
  CurrDir := GetCurrentDir;

  Try
    frmEmail := TfrmEmail.Create(Application);
    Try
      With frmEmail Do Begin
        { Check to see if MAPI is available }
        Try
          SetExtMAPI;
          if FUseExtended then
            Result := (MAPIx.Logon = {EMAIL_OK}0)
          else
            Result := MAPI.Logon = EMAIL_OK;

          If Result Then
            { Logged on - so logoff again }
            begin
              if FUseExtended then
                MAPIx.LogOff
              else
                MAPI.LogOff;
            end;
        Except
          Result := False;
        End;
      End; { With }
    Finally
      frmEmail.Free;
    End;
  Except
    On E:Exception Do
      MessageDlg ('The following error occured in ECMAPIAVAILABLE:' + #13#13 + '"' +
                  E.Message + '"', mtError, [mbOk], 0);
  End;

  // HM 08/10/01: The MAPIAvailable call was changing the directory to the MAPI dir
  SetCurrentDir (CurrDir);
End; { ecMapiAvailable }


{ 0 = OK }
{ 1 = Error Sending MAPI Email }
{ 2 = Unknown Exception }
{ 3 = reserver by calling object }
{ 4 = reserver by calling object }
Function ecSendEmail (Const Info : EmailInfoType) : SmallInt;
Var
  frmEmail : TfrmEmail;
  UseMAPI  : Boolean;
  I        : SmallInt;
  CurrDir  : ShortString;
  iError   : Integer;

  //------------------------------

  { Calculates the current time in seconds }
  Function xoCurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    Try
      { Get current time }
      DecodeTime(Now, wHour, wMin, wSec, wMSec);

      { Copy fields into longs to force compiler to work in LongInt mode  }
      { otherwise you can get Range Check Errors as it works in Word mode }
      lHour := wHour;
      lMin  := wMin;
      lSec  := wSec;
      lMSec := wMSec;

      { Calculate number of seconds since midbnight }
      Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
    Except
      On Ex: Exception Do begin
        if not Info.emSuppressMessages
        then MessageDlg ('The following exception occurred in xoCurrentTime: '
        + #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
      end;
    End;{try}
  End;

  //------------------------------

  { Returns the Time in seconds since Windows was started }
  { NOTE: Wraps to 0 after approx 49.7 days (as if any    }
  { windows system has run that long without crashing!!!) }
  Procedure xoWaitForSecs (Const Secs : Double);
  Var
    stTime, fiTime, cuTime : Double;
  Begin
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := xoCurrentTime;

      { Calculate end time }
      fiTime := stTime + Secs;

      Repeat
        { Let other apps do something }
        Application.ProcessMessages;

        { Get time again }
        cuTime := xoCurrentTime;

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime);
    Except
      On Ex: Exception Do begin
        if not Info.emSuppressMessages
        then MessageDlg ('The following exception occurred in xoWaitForSecs: '
        + #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
      end;
    End;{try}
  End;

  //------------------------------

  // MH 16/10/2014 v7.0.12 ABSEXCH-15651: Added error logging
  Function MAPIErrorDesc (Const ErrCode : Integer) : String;
  Begin // MAPIErrorDesc
    If frmEmail.FUseExtended Then
    Begin
      // Extended MAPI
      Case ErrCode Of
        262659      : Result := '(MAPI_W_NO_SERVICE)';
        263040      : Result := '(MAPI_W_ERRORS_RETURNED)';
        263297      : Result := '(MAPI_W_POSITION_CHANGED)';
        263298      : Result := '(MAPI_W_APPROX_COUNT)';
        263552      : Result := '(MAPI_W_CANCEL_MESSAGE)';
        263808      : Result := '(MAPI_W_PARTIAL_COMPLETION)';
        -2147467262 : Result := '(MAPI_E_INTERFACE_NOT_SUPPORTED)';
        -2147467259 : Result := '(MAPI_E_CALL_FAILED)';
        -2147221246 : Result := '(MAPI_E_NO_SUPPORT)';
        -2147221245 : Result := '(MAPI_E_BAD_CHARWIDTH)';
        -2147221243 : Result := '(MAPI_E_STRING_TOO_LONG)';
        -2147221242 : Result := '(MAPI_E_UNKNOWN_FLAGS)';
        -2147221241 : Result := '(MAPI_E_INVALID_ENTRYID)';
        -2147221240 : Result := '(MAPI_E_INVALID_OBJECT)';
        -2147221239 : Result := '(MAPI_E_OBJECT_CHANGED)';
        -2147221238 : Result := '(MAPI_E_OBJECT_DELETED)';
        -2147221237 : Result := '(MAPI_E_BUSY)';
        -2147221235 : Result := '(MAPI_E_NOT_ENOUGH_DISK)';
        -2147221234 : Result := '(MAPI_E_NOT_ENOUGH_RESOURCES)';
        -2147221233 : Result := '(MAPI_E_NOT_FOUND)';
        -2147221232 : Result := '(MAPI_E_VERSION)';
        -2147221231 : Result := '(MAPI_E_LOGON_FAILED)';
        -2147221230 : Result := '(MAPI_E_SESSION_LIMIT)';
        -2147221229 : Result := '(MAPI_E_USER_CANCEL)';
        -2147221228 : Result := '(MAPI_E_UNABLE_TO_ABORT)';
        -2147221227 : Result := '(MAPI_E_NETWORK_ERROR)';
        -2147221226 : Result := '(MAPI_E_DISK_ERROR)';
        -2147221225 : Result := '(MAPI_E_TOO_COMPLEX)';
        -2147221224 : Result := '(MAPI_E_BAD_COLUMN)';
        -2147221223 : Result := '(MAPI_E_EXTENDED_ERROR)';
        -2147221222 : Result := '(MAPI_E_COMPUTED)';
        -2147221221 : Result := '(MAPI_E_CORRUPT_DATA)';
        -2147221220 : Result := '(MAPI_E_UNCONFIGURED)';
        -2147221219 : Result := '(MAPI_E_FAILONEPROVIDER)';
        -2147221218 : Result := '(MAPI_E_UNKNOWN_CPID)';
        -2147221217 : Result := '(MAPI_E_UNKNOWN_LCID)';
        -2147221216 : Result := '(MAPI_E_PASSWORD_CHANGE_REQUIRED)';
        -2147221215 : Result := '(MAPI_E_PASSWORD_EXPIRED)';
        -2147221214 : Result := '(MAPI_E_INVALID_WORKSTATION_ACCOUNT)';
        -2147221213 : Result := '(MAPI_E_INVALID_ACCESS_TIME)';
        -2147221212 : Result := '(MAPI_E_ACCOUNT_DISABLED)';
        -2147220992 : Result := '(MAPI_E_END_OF_SESSION)';
        -2147220991 : Result := '(MAPI_E_UNKNOWN_ENTRYID)';
        -2147220990 : Result := '(MAPI_E_MISSING_REQUIRED_COLUMN)';
        -2147220735 : Result := '(MAPI_E_BAD_VALUE)';
        -2147220734 : Result := '(MAPI_E_INVALID_TYPE)';
        -2147220733 : Result := '(MAPI_E_TYPE_NO_SUPPORT)';
        -2147220732 : Result := '(MAPI_E_UNEXPECTED_TYPE)';
        -2147220731 : Result := '(MAPI_E_TOO_BIG)';
        -2147220730 : Result := '(MAPI_E_DECLINE_COPY)';
        -2147220729 : Result := '(MAPI_E_UNEXPECTED_ID)';
        -2147220480 : Result := '(MAPI_E_UNABLE_TO_COMPLETE)';
        -2147220479 : Result := '(MAPI_E_TIMEOUT)';
        -2147220478 : Result := '(MAPI_E_TABLE_EMPTY)';
        -2147220477 : Result := '(MAPI_E_TABLE_TOO_BIG)';
        -2147220475 : Result := '(MAPI_E_INVALID_BOOKMARK)';
        -2147220224 : Result := '(MAPI_E_WAIT)';
        -2147220223 : Result := '(MAPI_E_CANCEL)';
        -2147220222 : Result := '(MAPI_E_NOT_ME)';
        -2147219968 : Result := '(MAPI_E_CORRUPT_STORE)';
        -2147219967 : Result := '(MAPI_E_NOT_IN_QUEUE)';
        -2147219966 : Result := '(MAPI_E_NO_SUPPRESS)';
        -2147219964 : Result := '(MAPI_E_COLLISION)';
        -2147219963 : Result := '(MAPI_E_NOT_INITIALIZED)';
        -2147219962 : Result := '(MAPI_E_NON_STANDARD)';
        -2147219961 : Result := '(MAPI_E_NO_RECIPIENTS)';
        -2147219960 : Result := '(MAPI_E_SUBMITTED)';
        -2147219959 : Result := '(MAPI_E_HAS_FOLDERS)';
        -2147219958 : Result := '(MAPI_E_HAS_MESSAGES)';
        -2147219957 : Result := '(MAPI_E_FOLDER_CYCLE)';
        -2147219956 : Result := '(MAPI_E_STORE_FULL)';
        -2147219712 : Result := '(MAPI_E_AMBIGUOUS_RECIP)';
        -2147024809 : Result := '(MAPI_E_INVALID_PARAMETER)';
        -2147024882 : Result := '(MAPI_E_NOT_ENOUGH_MEMORY)';
        -2147024891 : Result := '(MAPI_E_NO_ACCESS)';
      Else
        Result := '';
      End; // Case ErrCode
    End // If frmEmail.FUseExtended
    Else
    Begin
      // Simple MAPI
      Case ErrCode Of
        1  : Result := '(MAPI_USER_ABORT)';
        2  : Result := '(MAPI_E_FAILURE)';
        3  : Result := '(MAPI_E_LOGIN_FAILURE)';
        4  : Result := '(MAPI_E_DISK_FULL)';
        5  : Result := '(MAPI_E_INSUFFICIENT_MEMORY)';
        6  : Result := '(MAPI_E_ACCESS_DENIED)';
        8  : Result := '(MAPI_E_TOO_MANY_SESSIONS)';
        9  : Result := '(MAPI_E_TOO_MANY_FILES)';
        10 : Result := '(MAPI_E_TOO_MANY_RECIPIENTS)';
        11 : Result := '(MAPI_E_ATTACHMENT_NOT_FOUND)';
        12 : Result := '(MAPI_E_ATTACHMENT_OPEN_FAILURE)';
        13 : Result := '(MAPI_E_ATTACHMENT_WRITE_FAILURE)';
        14 : Result := '(MAPI_E_UNKNOWN_RECIPIENT)';
        15 : Result := '(MAPI_E_BAD_RECIPTYPE)';
        16 : Result := '(MAPI_E_NO_MESSAGES)';
        17 : Result := '(MAPI_E_INVALID_MESSAGE)';
        18 : Result := '(MAPI_E_TEXT_TOO_LARGE)';
        19 : Result := '(MAPI_E_INVALID_SESSION)';
        20 : Result := '(MAPI_E_TYPE_NOT_SUPPORTED)';
        21 : Result := '(MAPI_E_AMBIGUOUS_RECIPIENT)';
        22 : Result := '(MAPI_E_MESSAGE_IN_USE)';
        23 : Result := '(MAPI_E_NETWORK_FAILURE)';
        24 : Result := '(MAPI_E_INVALID_EDITFIELDS)';
        25 : Result := '(MAPI_E_INVALID_RECIPS)';
        26 : Result := '(MAPI_E_NOT_SUPPORTED)';
      Else
        Result := '';
      End; // Case ErrCode
    End; // Else
  End; // MAPIErrorDesc

  //------------------------------

  // MH 16/10/2014 v7.0.12 ABSEXCH-15651: Added error logging
  Procedure LogMAPIError (Const LogType : String; Const ErrCode : Integer);
  Var
    sFilepath, sFilename : String;
    I : Integer;
  Begin // LogMAPIError
    Try
      // Check for Logs directory
      sFilepath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Logs\';
      If DirectoryExists(sFilepath) Then
      Begin
        With TStringList.Create Do
        Begin
          Try
            Add ('Exchequer EntComms.Dll');
            Add (Application.ExeName);
            Add (FormatDateTime ('DD/MM/YY - HH:nn:SS', Now) + '    Computer: ' + WinGetComputerName + '    User: ' + WinGetUserName);
            Add ('---------------------------------------------------------------');
            Add ('Log Type : ' + LogType);
            Add ('Error : ' + IntToStr(ErrCode) + '  ' + MAPIErrorDesc(ErrCode));
            Add ('');
            Add ('Sender Name : ' + Info.emSenderName);
            Add ('Sender Email : ' + Info.emSender);
            Add ('To Recipients :-');
            For I := 0 To (Info.emTo.Count - 1) Do
              Add ('(' + IntToStr(I+1) + ') ' + Info.emTo.Strings[I]);
            If (Info.emCC.Count > 0) Then
            Begin
              Add ('CC Recipients :-');
              For I := 0 To (Info.emCC.Count - 1) Do
                Add ('(' + IntToStr(I+1) + ') ' + Info.emCC.Strings[I]);
            End; // If (Info.emCC.Count > 0)
            If (Info.emBCC.Count > 0) Then
            Begin
              Add ('BCC Recipients :-');
              For I := 0 To (Info.emBCC.Count - 1) Do
                Add ('(' + IntToStr(I+1) + ') ' + Info.emBCC.Strings[I]);
            End; // If (Info.emBCC.Count > 0)
            Add ('Subject : ' + Info.emSubject);
            If (Info.emAttachments.Count > 0) Then
            Begin
              Add ('Attachments :-');
              For I := 0 To (Info.emAttachments.Count - 1) Do
                Add ('(' + IntToStr(I+1) + ') ' + Info.emAttachments.Strings[I]);
            End; // If (Info.emAttachments.Count > 0)

            // Generate a unique filename
            Repeat
              sFilename := sFilepath + 'E' + FormatDateTime('YYYYMMDDHHnnsszzz', Now) + '.Log';
              Sleep(100);
            Until (Not FileExists(sFilename));
            SaveToFile(sFilename);
          Finally
            Free;
          End; // Try..Finally
        End; // With TStringList.Create
      End; // If DirectoryExists(sFilepath)
    Except
      On Exception Do
        ;  // Bury any exception
    End; // Try..Except
  End; // LogMAPIError

  //------------------------------

Begin { ecSendEmail }
  Result := 0;
  // HM 08/10/01: The MAPIAvailable call was changing the directory to the MAPI dir
  CurrDir := GetCurrentDir;
{$IFDEF 5Star}
  LogIt('Subject: ' + Info.emSubject, CurrDir);
  for i := 0 to Info.emTo.Count - 1 do
    LogIt('To: ' + Info.emTo[i], CurrDir);

  for i := 0 to Info.emCC.Count - 1 do
    LogIt('CC: ' + Info.emCC[i], CurrDir);

  LogIt('   ', CurrDir);
{$ENDIF}

  //PR 31/08/04 Changed to use Extended Mapi rather than Simple Mapi - use MAPIx component rather than MAPI.
  With Info Do Begin
    Try
      frmEmail := TfrmEmail.Create(Application);
      Try
        With frmEmail Do Begin
          UseMAPI := emUseMAPI;
          If UseMAPI Then Begin
            SetExtMAPI;
            { Check to see if MAPI is available }
            Try
//              if FUseExtended then
//                UseMAPI := (MAPIx.Logon = {EMAIL_OK}0)
//              else
//                UseMAPI := MAPI.Logon = EMAIL_OK;

              // MH 16/10/2014 v7.0.12 ABSEXCH-15651: Added error logging
              If FUseExtended Then
              Begin
                iError := MAPIx.Logon;
                UseMAPI := (iError = 0);
              End // If FUseExtended
              Else
              Begin
                iError := MAPI.Logon;
                UseMAPI := (iError = EMAIL_OK);
              End; // Else

              If (Not UseMAPI) Then
                LogMAPIError (IfThen(FUseExtended, 'Extended', 'Simple') + ' MAPI Logon Error', iError);
            Except
              UseMAPI := False;
            End;
          End; { If }

          If UseMAPI Then Begin
            { Use MAPI to send Email }
            If FUseExtended Then
            Begin
              // Extended MAPI
              With MAPIx Do
              Begin
                Attachment.AddStrings (emAttachments);
                BCC.AddStrings (emBCC);
                CC.AddStrings (emCC);
//              Password := '';
//              Profile := 'Exchequer Software Ltd';
                Recipient.AddStrings (emTo);
                ShowDialog := False;
                Subject := emSubject;
                SetLongText (emTextPChar);
                UseDefProfile := True;

                // MH 16/10/2014 v7.0.12 ABSEXCH-15651: Added error logging
                iError := MAPIx.SendMail;
                //If (MAPIx.SendMail <> {EMAIL_OK}0) Then Begin
                If (iError <> 0) Then
                Begin
                  { Error Sending }
                  Result := 1;
                  LogMAPIError ('Extended MAPI SendMail Error', iError);
                End; // If (iError <> 0)

                {$IFNDEF IRISEMAIL}
                { Wait a while }
                xoWaitForSecs(2);
                {$ENDIF}
                Logoff;
              End; // With MAPIx
            End // If FUseExtended
            Else
            Begin
              // Simple MAPI
              With MAPI Do
              Begin
                Attachment.AddStrings (emAttachments);
                BCC.AddStrings (emBCC);
                CC.AddStrings (emCC);
  //              Password := '';
  //              Profile := 'Exchequer Software Ltd';
                Recipient.AddStrings (emTo);
                ShowDialog := False;
                Subject := emSubject;
                SetLongText (emTextPChar);
                UseDefProfile := True;

                // MH 16/10/2014 v7.0.12 ABSEXCH-15651: Added error logging
                iError := SendMail;
                If (iError <> EMAIL_OK) Then
                Begin
                //If (SendMail <> EMAIL_OK) Then Begin
                  { Error Sending }
                  Result := 1;
                  LogMAPIError ('Simple MAPI SendMail Error', iError);
                End; { If }

                {$IFNDEF IRISEMAIL}
                { Wait a while }
                xoWaitForSecs(2);
                {$ENDIF}
                Logoff;
              End; // With MAPI
            End; // Else


            {$IFNDEF IRISEMAIL}
            { Wait a while }
            xoWaitForSecs(2);
            {$ENDIF}
          End { If }
          Else Begin
            { Use bespoke components by IMs to send email }

            { Setup Server SMTP Details, ... }
            msSMTP1.Host := emSMTPServer;
            //PR 05/10/2006 Added for VM - allow port property to be set
            if emPort > 0 then
              msSMTP1.Port := emPort;

            { Setup the message }
            With msMessage1 Do Begin
              If (emTo.Count > 0) Then Begin
                For I := 0 To Pred(emTo.Count) Do Begin
                  Recipients.AddAddress(emTo[I], emTo[I]);
                End; { For I }
              End; { If }

              If (emCC.Count > 0) Then Begin
                For I := 0 To Pred(emCC.Count) Do Begin
                  CC.AddAddress(emCC[I], emCC[I]);
                End; { For I }
              End; { If }

              If (emBCC.Count > 0) Then Begin
                For I := 0 To Pred(emBCC.Count) Do Begin
                  BCC.AddAddress(emBCC[I], emBCC[I]);
                End; { For I }
              End; { If }

              If (emHeaders.Count > 0) Then Begin
                For I := 0 To Pred(emHeaders.Count) Do Begin
                  Headers.Add(emHeaders[I]);
                End; { For I }
              End; { If }

              Subject := emSubject;

              Body.Text := emTextPChar;

              { Message Priority }
              Case emPriority Of
                0 : Priority := ptLow;
                1 : Priority := ptNormal;
                2 : Priority := ptHigh;
              Else
                Priority := ptNormal;
              End; { Case }

              { Sent By }
              Sender.Address := emSender;
              Sender.Name := emSenderName;
              If (Trim(Sender.Name) = '') Then Begin
                { Sender Name isn't set - use email address instead }
                Sender.Name := Sender.Address;
              End; { If }

              If (emAttachments.Count > 0) Then Begin
                For I := 0 To Pred(emAttachments.Count) Do Begin
                  { Check file exists before sending it }
                  If FileExists (emAttachments[I]) Then Begin
                    Attachments.AddFile(emAttachments[I]);
                    //PR 7/7/2004 - sending html files is losing some formatting - changing encoding from
                    //quoted-printable to base64 fixes this
                    if Pos('.HTM', UpperCase(ExtractFileExt(emAttachments[i]))) = 1 then
                      Attachments[I].ContentTransferEncoding := etBase64;
                  End; { If }
                End; { For I }
              End; { If }
            End; { With msMessage1 }

            msSMTP1.Send;
          End; { Else }
        End; { With }
      Finally
        frmEmail.Free;
      End;
    Except
      On E:Exception Do Begin
        if not Info.emSuppressMessages
        then MessageDlg ('The following error occured in ECSENDMAIL:' + #13#13 + '"'
        + E.Message + '"', mtError, [mbOk], 0);
        ErrString := E.Message;
        Result := 2;
      End;
    End;
  End; { With }

  // HM 08/10/01: The MAPIAvailable call was changing the directory to the MAPI dir
  SetCurrentDir (CurrDir);
End; { ecSendEmail }

procedure TfrmEmail.FormDestroy(Sender: TObject);
begin
  if FUseExtended then
  begin
    if Assigned(MAPIx) then
      MAPIx.Free
  end
  else
    if Assigned(MAPI) then
      MAPI.Free;
end;

procedure TfrmEmail.SetExtMAPI;
begin
  FUseExtended := ExtendedMAPIAvailable;
  if FUseExtended then
    MAPIx := TMapiExEmail.Create(Self)
  else
    MAPI := TEmail.Create(Self);
end;

end.
