Unit uMAPI;

Interface

Uses Windows, Sysutils, Classes, Dateutils, strutils,
  IdMessage, IdAttachmentFile,
  VKMAPI,
  uMailMessage, uMailBase

  ;

Type
  TOnDeleteSentBox = Procedure(Const pFrom, pTo, pSubject, pBody: String; Var
    pCanDelete: Boolean) Of Object;

  TMAPI = Class(TEmailBase)
  Private
    fMAPI: TMAPISession;
    fOnDeleteSentBox: TOnDeleteSentBox;
    fSENTBOXLoadAttach: boolean;
    fWASTEBOXLoadAttach: boolean;
    fOUTBOXLoadAttach: boolean;
    fINBOXLoadAttach: boolean;
    Procedure FreeMapi;
    Function GetMessageCount: Integer;
  Protected
    Function GetConnected: Boolean; Override;
    Procedure SetConnected(Const Value: Boolean); Override;
    Function GetMail(Index: Integer): TMailMessage; Override;
  Public
    Function DeleteMail(Index: Integer): Boolean; Override;
    Function SendMail(pMail: TMailMessage): Boolean; Override;
    Procedure DeleteInboxMarkedMsgs;
    Procedure SetMessageToDelete(index: Integer); override;
    Procedure ClearSentBox(Const pBaseDate: String; Const pBaseMinutes: Integer =
      60);

    Constructor Create; Override;
    Destructor Destroy; Override;

    Property Mail;
  Published
    Property UserName;
    Property Password;
    {future use... :)}
    Property Profile;
    property UseDefaultProfile;

    Property OnDeleteSentBox: TOnDeleteSentBox Read fOnDeleteSentBox Write
      fOnDeleteSentBox;
    Property MessageCount: Integer Read GetMessageCount;
    Property INBOXLoadAttach : boolean read fINBOXLoadAttach write fINBOXLoadAttach ;
    Property OUTBOXLoadAttach  : boolean read fOUTBOXLoadAttach write fOUTBOXLoadAttach ;
    Property WASTEBOXLoadAttach  : boolean read fWASTEBOXLoadAttach write fWASTEBOXLoadAttach ;
    Property SENTBOXLoadAttach  : boolean read fSENTBOXLoadAttach write fSENTBOXLoadAttach ;

  End;

Implementation

{ TMAPI }

{-----------------------------------------------------------------------------
  Procedure: ClearSentBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMAPI.ClearSentBox(Const pBaseDate: String; Const pBaseMinutes: Integer =
  60);
Var
  lCont: Integer;
  lAux, lFrom, lTo, lSubj, lBody: String;
  lDate: TDatetime;
  lCanDelete: Boolean;
Begin
  If Connected Then
  Begin
    lAux := pBaseDate;
    If lAux <> '' Then
    Begin
      lDate := StrToDateTimeDef(lAux, Now);

      {check last time this process has been done}
      If MinutesBetween(Now, lDate) > 30 Then
      Try
        If fMapi.Active Then
          With fMapi.SENTBOX Do
            If MessagesCount > 0 Then
              For lCont := MessagesCount - 1 Downto 0 Do
                If MinutesBetween(Now, MAPIMessage[lCont].MessageDeliveryTime) >
                  pBaseMinutes Then
                Begin
                  lFrom := MAPIMessage[lCont].REPRESENTING_EMAIL_FROM;

                  With MAPIMessage[lCont] Do
                    lTo := ifThen(Trim(REPRESENTING_MAPI_EMAIL_TO) <> '',
                      Trim(REPRESENTING_MAPI_EMAIL_TO), REPRESENTING_NAME_EMAIL_TO);

                  lSubj := Trim(MAPIMessage[lCont].SUBJECT);
                  lBody := Trim(MAPIMessage[lCont].BODY);

                  lCanDelete := False;
                  If Assigned(fOnDeleteSentBox) Then
                    fOnDeleteSentBox('', '', lSubj, lBody, lCanDelete);

                  If lCanDelete Then
                    DeleteMessage(lCont);
                End; {If MinutesBetween()}
      Except
      End; {try}
    End
  End; {if Assigned(lDb) and lDb.Connected then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TMAPI.Create;
Begin
  Inherited Create;

  fOnDeleteSentBox := Nil;

  fSENTBOXLoadAttach:= True;
  fWASTEBOXLoadAttach:= false;
  fOUTBOXLoadAttach:= False;
  fINBOXLoadAttach:= False;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteInboxMarkedMsgs
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMAPI.DeleteInboxMarkedMsgs;
Var
  lCont: Integer;
Begin
  If Connected Then
    For lCont := fMapi.INBOX.MessagesCount - 1 Downto 0 Do
      If fMapi.INBOX.Messages[lCont].MessageFlags.CAN_DELETE Then
      Try
        fMapi.INBOX.DeleteMessage(lCont);
      Except
      End;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMAPI.DeleteMail(Index: Integer): Boolean;
Begin
  Result := False;
  If Connected Then
    If (Index >= 0) And (Index < fMapi.INBOX.MessagesCount) Then
      Result := fMapi.INBOX.DeleteMessage(Index);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TMAPI.Destroy;
Begin
  FreeMapi;

  If Assigned(fOnDeleteSentBox) Then
    fOnDeleteSentBox := Nil;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: FreeMapi
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMAPI.FreeMapi;
Begin
  If fMAPI <> Nil Then
  Try
    fMapi.Active := False;
  Finally
    FreeAndNil(fMapi);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMAPI.GetConnected: Boolean;
Begin
  Result := False;

  If fMAPI <> Nil Then
    Result := fMAPI.Active;
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMAPI.GetMail(Index: Integer): TMailMessage;
Begin
  Result := Nil;
  If Connected Then
    If (Index >= 0) And (Index < MessageCount) Then
    Begin
      {fill mailmessage details}
      Result := TMailMessage.Create;
      Result.OutputDir := AttachDirectory;
      Result.Index := Index;
      Result.MAPIMsgToMailMsg(fMapi.INBOX.Messages[Index]);

      If Result.ErrorString <> '' Then
        DoErrorMessage('TMAPI.GetMail', Result.ErrorString);
    End {if (Index >= 0) and (Index < MessageCount) then}
    Else
      DoErrorMessage('TMAPI.GetMail', 'Invalid Index: ' + inttostr(Index));
End;

{-----------------------------------------------------------------------------
  Procedure: GetMessageCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMAPI.GetMessageCount: Integer;
Begin
  Result := 0;
  If Connected Then
  Try
    Result := fMAPI.INBOX.MessagesCount;
  Except
    On E: Exception Do
      DoErrorMessage('TMAPI.GetMessageCount', E.Message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: SendMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMAPI.SendMail(pMail: TMailMessage): Boolean;
Var
  lCont: Integer;
  lFiles: TStringList;
Begin
  Result := False;

  If pMail <> Nil Then
    If Connected Then
      If Trim(pMail.To_.Text) <> '' Then
      Begin
        lFiles := TStringList.Create;
        For lCont := 0 To pMail.AttachCount - 1 Do
          lFiles.Add(pMail.Attachments[lCont].FileName);

        Try
          fMAPI.SimpleSend(Trim(pMail.To_.Text), pMail.Subject,
            Trim(pMail.Body.Text), lFiles);
          Result := True;
        Except
          On e: exception Do
            DoErrorMessage('TMAPI.SendMail', e.Message);
        End;

        Try
          fMapi.OUTBOX.Messages.SubmitMessages;
        Except
        End;

        Try
          fMAPI.FlushQs;
        Except
        End;

        lFiles.Free;
      End {if Connected then}
      Else
        DoErrorMessage('TMAPI.SendMail', 'Invalid Destination Address');
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMAPI.SetConnected(Const Value: Boolean);
Begin
  If Value And Not Connected Then
  Begin
    FreeMapi;

    fMAPI := Nil;
    {create MAPI session}
    Try
      fMAPI := TMAPISession.Create(Nil);
    Except
      On e: exception Do
        DoErrorMessage('TMAPI.SetConnected', 'Error creating MAPI session. Error: '
          + e.Message);
    End; {try}

    If fMAPI <> Nil Then
    Begin
      fMapi.LoadWasteBox := False;
      fMapi.AttachTempDirectory := AttachDirectory;
      fMapi.INBOX.LoadAttach := fINBOXLoadAttach;
      fMapi.OUTBOX.LoadAttach := fOUTBOXLoadAttach;
      fMapi.WASTEBOX.LoadAttach := fWASTEBOXLoadAttach;
      fMapi.SENTBOX.LoadAttach := fSENTBOXLoadAttach;

      {set mapi logon parameters}
      With fMapi.LogonFlags Do
      Begin
        LOGON_UI := False;
        NEW_SESSION := True;
        ALLOW_OTHERS := True;
        EXPLICIT_PROFILE := False;
        EXTENDED := True;
        FORCE_DOWNLOAD := False;
        SERVICE_UI_ALWAYS := False;
        NO_MAIL := False;
        NT_SERVICE := True;
        PASSWORD_UI := False;
        TIMEOUT_SHORT := False;
        USE_DEFAULT := True;
      End; {with lMapi.LogonFlags do}

      Try
        {activate}
        Try
          fMapi.Active := True;
        Except
          On e: exception Do
            DoErrorMessage('TMAPI.SetConnected', 'Error activating MAPI (1). Error: '
              + e.Message);
        End;
      Finally
        {if something goes wrong, might be because the ntservice flag}
        If Not fMapi.Active Then
        Begin
          fMapi.LogonFlags.NT_SERVICE := False;
          Try
            fMapi.Active := True;
          Except
            On e: exception Do
              DoErrorMessage('TMAPI.SetConnected',
                'Error activating MAPI (2). Error: ' + e.Message);
          End; {try}
        End; {if not lMapi.Active then}
      End; {try}
    End; {if fMAPI <> nil then}

    If Connected Then
      If Assigned(OnAfterConnect) Then
        OnAfterConnect(Self);
  End
  Else If Not Value Then
    FreeMapi;
End;

{-----------------------------------------------------------------------------
  Procedure: SetMessageToDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMAPI.SetMessageToDelete(index: Integer);
Begin
  If Connected Then
    If (Index >= 0) And (Index < fMapi.INBOX.MessagesCount) Then
      fMapi.INBOX.Messages[Index].MessageFlags.CAN_DELETE := True;
End;

End.

