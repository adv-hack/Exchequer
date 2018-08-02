Unit uMailMessage;

Interface

Uses Windows, Sysutils, Classes, Contnrs, Strutils,
  uMailMessageAttach,
  vkmapi,
  IdMessage, IdAttachment, IdAttachmentFile, idText
  ;

Const
  cEML = '.eml';

Type
  TOnCheckAttach = Procedure(Const pFile: String; Var pCanAdd: Boolean) Of Object;

  TMailMessage = Class
  Private
    fAttachList: TObjectList;
    FSenderAddress: String;
    FSenderName: String;
    fBCC: TStringList;
    fTo_: TStringList;
    fCC: TStringList;
    fPriority: Integer;
    fSubject: String;
    fBody: TStringList;
    fDate: TDateTime;
    fIndex: Integer;
    fDownloadAttach: Boolean;
    fOutputDir: String;
    fErrorString: String;
    fCanDelete: Boolean;
    fOnCheckAttach: TOnCheckAttach;
    Function GetAttachments(Index: Integer): TMailAttachment;
    Procedure SetAttachments(Index: Integer; Const Value: TMailAttachment);
    Function GetAttachCount: Integer;
    Function GetAttachmentsAsStr: WideString;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Property Attachments[Index: Integer]: TMailAttachment Read GetAttachments Write
    SetAttachments;
    Property AttachmentsAsStr: WideString Read GetAttachmentsAsStr;
    Function AddAttachment: TMailAttachment;

    Function MailMsgToIndyMsg: TIdMessage;
    Procedure IndyMsgToMailMsg(pIndyMsg: TIdMessage);
    Procedure MAPIMsgToMailMsg(pMAPIMsg: TMAPIMessage);
    Procedure LoadFileFromDir(Const pDir: String; Const pExt: String = '*.*');
  Published
    Property OnCheckAttach: TOnCheckAttach Read fOnCheckAttach Write fOnCheckAttach;
    Property SenderName: String Read FSenderName Write FSenderName;
    Property SenderAddress: String Read FSenderAddress Write FSenderAddress;
    Property To_: TStringList Read fTo_ Write fTo_;
    Property CC: TStringList Read fCC Write fCC;
    Property BCC: TStringList Read fBCC Write fBCC;
    Property Priority: Integer Read fPriority Write fPriority;
    Property Subject: String Read fSubject Write fSubject;
    Property Body: TStringList Read fBody Write fBody;
    Property Date: TDateTime Read fDate Write fDate;
    Property Index: Integer Read fIndex Write fIndex;
    Property AttachCount: Integer Read GetAttachCount;
    Property DownloadAttach: Boolean Read fDownloadAttach Write fDownloadAttach;
    Property OutputDir: String Read fOutputDir Write fOutputDir;
    Property ErrorString: String Read fErrorString Write fErrorString;
    Property CanDelete: Boolean Read fCanDelete Write fCanDelete;
  End;

Implementation

Uses uMailBase;

{ TExMailMessage }

{-----------------------------------------------------------------------------
  Procedure: AddAttachment
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMailMessage.AddAttachment: TMailAttachment;
Begin
  Result := TMailAttachment.Create;
  fAttachList.Add(Result);
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TMailMessage.Create;
Begin
  Inherited Create;
  fOnCheckAttach := Nil;

  fAttachList := TObjectList.Create;
  fPriority := 1;

  fBCC := TStringList.Create;
  fTo_ := TStringList.Create;
  fCC := TStringList.Create;
  fBody := TStringList.Create;

  fDownloadAttach := True;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TMailMessage.Destroy;
Begin
  fAttachList.Clear;

  fAttachList.Free;
  fBCC.Free;
  fTo_.Free;
  fCC.Free;
  fBody.Free;

  If Assigned(fOnCheckAttach) Then
    fOnCheckAttach := Nil;

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: GetAttachCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMailMessage.GetAttachCount: Integer;
Begin
  Result := fAttachList.Count;
End;

{-----------------------------------------------------------------------------
  Procedure: GetAttachments
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMailMessage.GetAttachments(Index: Integer): TMailAttachment;
Begin
  Result := Nil;
  If (Index >= 0) And Not (Index > fAttachList.Count - 1) Then
    Result := TMailAttachment(fAttachList[Index])
End;

{-----------------------------------------------------------------------------
  Procedure: GetAttachmentsAsStr
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMailMessage.GetAttachmentsAsStr: WideString;
Var
  lCont: Integer;
  lStr: TStringList;
Begin
  lStr := TStringList.Create;
  For lCont := 0 To fAttachList.Count - 1 Do
    lStr.Add(TMailAttachment(fAttachList[lCont]).FileName);

  Result := Trim(lStr.CommaText);
  lStr.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: IndyMsgToMailMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMailMessage.IndyMsgToMailMsg(pIndyMsg: TIdMessage);
Var
  lCont: Integer;
  lFileName: String;
  lCanAdd: Boolean;
Begin
  If pIndyMsg <> Nil Then
  Begin
    Self.SenderName := pIndyMsg.From.Name;
    Self.SenderAddress := pIndyMsg.From.Address;
    Self.To_.CommaText := Trim(pIndyMsg.Recipients.EMailAddresses);
    Self.cc.CommaText := Trim(pIndyMsg.CCList.EMailAddresses);
    Self.BCC.CommaText := Trim(pIndyMsg.BccList.EMailAddresses);
    Self.Priority := Ord(pIndyMsg.Priority);
    Self.Subject := Trim(pIndyMsg.Subject);
//    Self.Body.Text := Trim(pIndyMsg.Body.Text);
    Self.Date := pIndyMsg.Date;
    Self.ErrorString := '';

   {load body message part as text}
    With pIndyMsg Do
      For lCont := 0 To Pred(MessageParts.Count) Do
        If MessageParts.Items[lCont] Is TIdText Then
        Begin
          Self.Body.Text := Trim(TIdText(MessageParts.Items[lCont]).Body.Text);
          Break;
        End; {if pIndyMsg.MessageParts.Items[lCont] is TIdText then}

    {check if download is allowed}
    If DownloadAttach Then
      {retrieve attachments}
      With pIndyMsg Do
        For lCont := 0 To Pred(MessageParts.Count) Do
          If (MessageParts.Items[lCont] Is TIdAttachment) Then
          Begin
            lCanAdd := True;

            If Assigned(fOnCheckAttach) Then
              fOnCheckAttach(TIdAttachmentFile(MessageParts.Items[lCont]).Filename,
                lCanAdd);

            If lCanAdd Then
              With AddAttachment Do
              Begin
                {conserving original filename}
                OriginalName :=
                  TIdAttachmentFile(MessageParts.Items[lCont]).Filename;

                {check if files exists... could be a memorystream or something}
                If FileExists(OriginalName) Then
                  lFileName := OriginalName
                Else
                Begin
                  lFileName := IncludeTrailingPathDelimiter(fOutputDir);
                  {unique name}
                  lFileName := lFileName + GenerateUniqueName +
                    ExtractFileExt(OriginalName);

                  {try to save the content of the attachment}
                  Try
                    TIdAttachmentFile(MessageParts.Items[lCont]).SaveToFile(lFileName);
                  Except
                    On e: exception Do
                      //TEmailBase(fOwner).DoErrorMessage('TMailMessage.IndyMsgToMailMsg', E.Message);
                      Self.ErrorString := e.Message;
                  End; {try}
                End; {else begin}

                FileName := lFileName;
              End; {With AddAttachment Do}
          End; {If (MessageParts.Items[lCont] Is TIdAttachment) Then}
  End {if pIndyMsg <> nil then}
  Else
    Self.ErrorString := 'Invalid E-mail Object to convert.';
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessagesFromDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMailMessage.LoadFileFromDir(Const pDir: String; Const pExt: String =
  '*.*');
Var
  lRec: TSearchRec;
  lRes: Integer;
  lDir: String;
Begin
  lDir := IncludeTrailingPathDelimiter(pDir);
  lRes := FindFirst(lDir + pExt, faAnyFile, lRec);
  While lRes = 0 Do
  Begin
    If lRec.Attr = FILE_ATTRIBUTE_ARCHIVE then
      With AddAttachment Do
        FileName := lDir + lRec.Name;

    lRes := FindNext(lRec);
  End; {while lRes = 0 do}

  FindClose(lRec);
End;

{-----------------------------------------------------------------------------
  Procedure: MailMsgToIndyMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TMailMessage.MailMsgToIndyMsg: TIdMessage;
Var
  lCont: Integer;
Begin
  Result := TIdMessage.Create(Nil);

  {fill message details}
  With Result Do
  Begin
    {must be set to be able to read it back}
    From.Name := Self.SenderName;
    From.Address := Self.SenderAddress;

    {fill recipient address}
    For lCont := 0 To Self.To_.Count - 1 Do
      With Recipients.Add Do
        Address := Self.To_[lCont];

    {cc list}
    For lCont := 0 To Self.CC.Count - 1 Do
      With CCList.Add Do
        Address := Self.CC[lCont];

    For lCont := 0 To Self.BCC.Count - 1 Do
      With BccList.Add Do
        Address := Self.BCC[lCont];

    Priority := TidMessagePriority(Self.Priority);
    Subject := Trim(Self.Subject);
//    TIdText.Create(MessageParts, Self.Body);
    Body.Text := Trim(Self.Body.Text);
    Date := Now;

    {insert file attachments}
    With Self Do
      For lCont := 0 To AttachCount - 1 Do
        If FileExists(Attachments[lCont].FileName) Then
          TIdAttachmentFile.Create(MessageParts, Attachments[lCont].FileName);
  End; {with Result do}
End;

{-----------------------------------------------------------------------------
  Procedure: MAPIMsgToMailMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMailMessage.MAPIMsgToMailMsg(pMAPIMsg: TMAPIMessage);
Var
  lMailTo, lFileName: String;
  lCont: Integer;
  lCanAdd: Boolean;
Begin
  If pMAPIMsg <> Nil Then
  Begin
    Self.SenderName := pMAPIMsg.REPRESENTING_NAME;
    Self.SenderAddress := pMAPIMsg.REPRESENTING_EMAIL_FROM;

    With pMAPIMsg Do
      lMailTo := ifThen(Trim(REPRESENTING_MAPI_EMAIL_TO) <> '',
        Trim(REPRESENTING_MAPI_EMAIL_TO), REPRESENTING_NAME_EMAIL_TO);

    Self.To_.CommaText := Trim(lMailTo);
    Self.Subject := Trim(pMAPIMsg.SUBJECT);
    Self.Body.Text := Trim(pMAPIMsg.BODY);
    Self.Date := pMAPIMsg.MessageDeliveryTime;
    Self.ErrorString := '';

    {check if download is allowed}
    If DownloadAttach Then
      {retrieve attachments}
      With pMAPIMsg Do
        If Attachments.Count > 0 Then
          For lCont := 0 To Pred(Attachments.Count) Do
          Begin
            lCanAdd := True;

            If Assigned(fOnCheckAttach) Then
              fOnCheckAttach(Attachments[lCont].FileName, lCanAdd);

            If lCanAdd Then
              With AddAttachment Do
              Begin
                  {conserving original filename}
                OriginalName := Attachments[lCont].FileName;

                  {check if files exists... could be a memorystream or something}
                If FileExists(OriginalName) Then
                  lFileName := OriginalName
                Else
                Begin
                  lFileName := IncludeTrailingPathDelimiter(fOutputDir);
                    {unique name}
                  lFileName := lFileName + GenerateUniqueName +
                    ExtractFileExt(OriginalName);

                    {try to save the content of the attachment}
                  Try
                    If Attachments[lCont].AttachStream <> Nil Then
                      Attachments[lCont].AttachStream.SaveToFile(lFileName);
                  Except
                    On e: exception Do
                      Self.ErrorString := e.Message;
                  End; {try}
                End; {else begin}

                FileName := lFileName;
              End; {with AddAttachment do}
          End; {For lCont := 0 To Pred(Attachments.Count) Do}
  End {if pIndyMsg <> nil then}
  Else
    Self.ErrorString := 'Invalid E-mail Object to convert.';
End;

{-----------------------------------------------------------------------------
  Procedure: SetAttachments
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TMailMessage.SetAttachments(Index: Integer; Const Value: TMailAttachment);
Begin
  If Value <> Nil Then
    fAttachList.Add(Value);
End;

(*
Procedure TDSRMailPoll.ProcessEmlFile(Var lList: TStringList; Const pFile: String);
Var
  lMessage: TmsMessage;
  lDir,
    lFileName: String;
  lCont: Integer;
Begin
  If (_FileSize(pFile) > 0) And Assigned(lList) Then
  Begin
    lMessage := Nil;
    Try
      lMessage := TmsMessage.Create(Nil);
    Except
    End;

    If Assigned(lMessage) Then
    Try
      With lMessage Do
      Begin
        Try
          LoadFromFile(pFile);
        Except
        End;

        lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
        Try
          ForceDirectories(lDir);
        Except
        End;

        {laod the attachements inside the eml file}
        If Attachments.Count > 0 Then
          For lCont := 0 To Attachments.Count - 1 Do
          Begin
            lFileName := '';
            If Assigned(Attachments.Items[lCont]) Then
              With Attachments.Items[lCont] Do
              Begin
                lFileName := lDir + ExtractFileName(FileName);

                Try
                  SavePOP3Attach(Contents, lFileName);
                Except
                End;
              End; {With Attachments.Items[lCont] Do}

            If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
              If _ValidExtension(lFileName) Then
                If lList.IndexOf(lFileName) = -1 Then
                  lList.Add(lFileName)
          End; {For lCont := 0 To Attachments.Count - 1 Do}
      End; {With lMessage Do}
    Finally
      FreeAndNil(lMessage);
    End; {If Assigned(lMessage) Then}
  End; {if _FileSize(pFile) > 0 then}
End;

*)

End.

