{-----------------------------------------------------------------------------
 Unit Name: uRecycleFrame
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uRecycleFrame;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMailBoxBaseFrame, ExtCtrls, ImgList,
  AdvOutlookList, AdvPanel,
  uAdoDSR, uInterfaces,
  Menus, AdvMenus, AdvMenuStylers, ActnList, StdCtrls, AdvProgressBar
  ;

Type
  TfrmRecycleFrame = Class(TfrmMailBoxBaseFrame)
    aclInbox: TActionList;
    actDelete: TAction;
    AdvMenuOfficeStyler: TAdvMenuOfficeStyler;
    ppmInbox: TAdvPopupMenu;
    mniDelete: TMenuItem;
    actSelectAll: TAction;
    N1: TMenuItem;
    SelectAll1: TMenuItem;
    N2: TMenuItem;
    actPreview: TAction;
    Preview1: TMenuItem;
    actRestore: TAction;
    Restore1: TMenuItem;
    Procedure tmBoxTimer(Sender: TObject);
    Procedure ppmInboxPopup(Sender: TObject);
    Procedure actDeleteExecute(Sender: TObject);
    Procedure actSelectAllExecute(Sender: TObject);
    Procedure actPreviewExecute(Sender: TObject);
    Procedure actRestoreExecute(Sender: TObject);
  Private
    fDb: TADODSR;
  Protected
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure LoadRecycleMessages(pMsgs: Olevariant; pBox: TBoxType);
    Procedure AddMessageDetail(Var pMail: TStrings; Var pInfo: TMessageInfo;
      Const pCaption: String; Const pUseBold: Boolean); Override;
    Function DeleteMessage(pGuid: TGuid): Longword;
    Procedure GetMail; Override;
    Procedure CheckActions(Sender: TObject);
  End;

Var
  frmRecycleFrame: TfrmRecycleFrame;

Implementation

Uses uDashSettings, uCommon, uConsts, uDSR, uDASHGlobal;

{$R *.dfm}

{ TfrmRecycleFrame }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmRecycleFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
  BoxType := btRecycle;
  OnDeleteMessage := DeleteMessage;

  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      _LogMSG('TfrmRecycleFrame.Create :- Error creating database connection. Error: '
        + e.message);
    End;
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmRecycleFrame.Destroy;
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.LoadRecycleMessages(pMsgs: Olevariant; pBox:
  TBoxType);
Var
  lMsg: TStrings;
  lCont,
    lTotal: Longword;
  lGroup: TOutlookGroup;
  lMsgInfo: TMessageInfo;
Begin
  lTotal := _GetOlevariantArraySize(pMsgs);

//  If lTotal <> Count Then
//    ClearItems;

  AdvOutlook.BeginUpdate;

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      If pBox = btInbox Then
        lMsgInfo := _CreateInboxMsgInfo(pMsgs[lCont])
      Else
        lMsgInfo := _CreateOutboxMsgInfo(pMsgs[lCont]);

      If lMsgInfo <> Nil Then
      Begin
(*        lGroup := GetGroup(lMsgInfo.Date);

        AddMessageDetail(lMsg, lMsgInfo, lMsgInfo.To_, True);*)

        lMsg := MailExists(GUIDToString(lMsgInfo.Guid));

        If lMsg = Nil Then
        Begin
          lGroup := GetGroup(lMsgInfo.Date);
          lMsg := AdvOutlook.AddItem(lGroup);
          AddMessageDetail(lMsg, lMsgInfo, lMsgInfo.To_, False);
        End {if not MailExists(lMsgInfo.Guid) then}
        Else
          AddMessageDetail(lMsg, lMsgInfo, lMsgInfo.To_, False);

      End; {If lMsgInfo <> Nil Then}
    End; {For lCont := 0 To lTotal - 1 Do}

  AdvOutlook.EndUpdate;
End;

{-----------------------------------------------------------------------------
  Procedure: tmBoxTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.tmBoxTimer(Sender: TObject);
Begin
  tmbox.Enabled := False;

{$IFDEF DEBUG}
  Try
    If Not CheckMessageBox Then
      GetMail;
  Except
    On E: EXCEPTION Do
      _LogMSG('TfrmRecycleFrame.tmBoxTimer := Error refresing list. Error: ' +
        e.Message);
  End;
{$ELSE}
  If Not CheckMessageBox Then
    GetMail;
{$ENDIF}

  tmbox.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: ppmInboxPopup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.ppmInboxPopup(Sender: TObject);
Begin
  CheckActions(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: AddMessageDetail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.AddMessageDetail(Var pMail: TStrings; Var pInfo:
  TMessageInfo; Const pCaption: String; Const pUseBold: Boolean);
Var
  lInfo: TMessageInfo;
  lCompName: String;
Begin
  If Assigned(pMail) And Assigned(pInfo) And FDb.Connected Then
    With pMail Do
    Begin
      {if this message already exists, the messageinfo object must be deleted}
      If Count > 0 Then
        If (Objects[0] <> Nil) And (Objects[0] Is TMessageInfo) Then
        Begin
          lInfo := TMessageInfo(Objects[0]);
          If Assigned(lInfo) Then
            FreeAndNil(lInfo);
        End;

      Clear;

      AddObject(pCaption, pInfo);
      Try
        lCompName := fDb.GetCompanyDescription(pInfo.Company_Id);
      Finally
        If lCompName = '' Then
          lCompName := 'There is no company associated to this message.';
      End;

      Add(lCompName);

      Add(pInfo.Subject);
      Add(datetimetostr(pInfo.Date));
      Add(Inttostr(pInfo.TotalItens));

(*      Case pInfo.Status Of
        cDELETED: Add('Deleted'); // Add('4'); //'Deleted';
        cFAILED: Add('Failed'); // Add('4'); // failure
      End; {Case lMsgInfo.Status Of}*)
    End; {With pMail Do}
End;

{-----------------------------------------------------------------------------
  Procedure: actDeleteExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.actDeleteExecute(Sender: TObject);
Begin
  If fdb.Connected And (AdvOutlook.SelectedCount > 0) Then
(*    If
      MessageDlg('Are you sure you want to remove the selected item(s) from the system?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If
      ShowDashboardDialog('Are you sure you want to remove the selected item(s) from the system?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      If tmBox.Enabled Then
        tmBox.Enabled := False;

      DeleteSelectedMessages;

      If Not tmBox.Enabled Then
        tmBox.Enabled := True;
    End; {if messagedlg}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmRecycleFrame.DeleteMessage(pGuid: TGuid): Longword;
Begin
  Result := S_FALSE;
  If Assigned(fDb) Then
  Begin
    If fdb.SearchInboxEntry(pGuid) > 0 Then
      Result := TDSR.DSR_DeleteInboxMessage(_DashboardGetDSRServer,
        _DashboardGetDSRPort, fDb.GetInboxCompanyId(pGuid), pGuid)
    Else
      Result := TDSR.DSR_DeleteOutboxMessage(_DashboardGetDSRServer,
        _DashboardGetDSRPort, fDb.GetOutboxCompanyId(pGuid), pGuid);
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.GetMail;
Var
  lRes, lTotalIn, lTotalout: Longword;
  lLastInUpdate, lLastOutUpdate: Double;
  lMessages: Olevariant;
  lUpdate: Boolean;
  lCount: Longword;
Begin
  Try
    If Assigned(fDb) Then
      If fDb.Connected Then
      Begin
        lCount := Count;

        {check last updates}
        lLastInUpdate := fDb.GetLastInboxUpdate;
        lLastOutUpdate := fDb.GetLastOutboxUpdate;

        {check total for recycle status}
        lTotalIn := fDb.GetTotalInboxMessages(-1, cALLRECYCLE);
        lTotalout := fDb.GetTotalOutboxMessages(-1, cALLRECYCLE);

        lUpdate := ((lTotalIn + lTotalout) <> lCount) Or ((lLastInUpdate +
          lLastOutUpdate) <> LastUpdate);

        If lUpdate Then
        Begin
          If (lTotalIn + lTotalout) <> lCount Then
            ClearItems;

          Try
            {load all messages using a union command}
            lMessages := fDb.LoadRecycleMessages;
            LoadRecycleMessages(lMessages, btOutbox);
          Except
          {load deleted from outbox}
            lMessages := fDb.GetOutboxMessages(-1, 0, cALLRECYCLE, 0, 0, lRes,
              False);
            LoadRecycleMessages(lMessages, btOutbox);

          {load deleted from inbox}
            lMessages := fDb.GetInboxMessages(-1, 0, cALLRECYCLE, 0, 0, lRes,
              False);
            LoadRecycleMessages(lMessages, btInbox);
          End;

          LastUpdate := lLastInUpdate + lLastOutUpdate;
        End; {total <> count}
      End; {If fDb.Connected Then}
  Except
  End; {Try}

  {clear panel info}
  If Not PaneVisible Or (Count = 0) Then
    SetPaneNoInfo;

  {select the first valid item of the list}
  If Count > 0 Then
  Try
    If GetFocused = Nil Then
      SetFirstValidItem;
    AdvOutlookSelectionChange(Self);
  Except
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: CheckActions
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.CheckActions(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  actDelete.Enabled := False;
  actSelectAll.Enabled := Count > 0;
  actPreview.Enabled := actSelectAll.Enabled;
  actRestore.Enabled := False;
  actRestore.Visible := Not glISCIS;

  {check if there is at least one message selected}
  If (AdvOutlook.FocusedItem <> Nil) And (AdvOutlook.SelectedCount > 0) Then
  Begin
    lMsg := SelectedMsgInfo;
    If lMsg <> Nil Then
    Begin
      {enable delete option}
      actDelete.Enabled := glDSROnline And MenuActive And ((lMsg.Status In
        [cDELETED, cFAILED]));

      {enable restore option}
      actRestore.Enabled := glDSROnline And (SelectedCount = 1) And MenuActive And
        (lMsg.Status = cDELETED) And (lMsg.Mode In [ord(rmDripfeed), ord(rmBulk)])
      And (lMsg.TotalItens > 0) And ((fDb.SearchInboxEntry(lMsg.Guid) > 0) Or
        (fDb.SearchOutboxEntry(lMsg.Guid) > 0)) And (lMsg.Company_Id > 0) And
        fDb.IsCompanyActive(lMsg.Company_Id) and not fDb.IsEndOfSyncRequested(lMsg.Company_Id);
    End
    Else If Assigned(Sender) Then
      Abort;
  End
  Else If Assigned(Sender) Then
    Abort;
End;

{-----------------------------------------------------------------------------
  Procedure: actSelectAllExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.actSelectAllExecute(Sender: TObject);
Begin
  {avoid selecting groups...}
  SetFirstValidItem;
  AdvOutlook.SelectAll;
End;

{-----------------------------------------------------------------------------
  Procedure: actPreviewExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.actPreviewExecute(Sender: TObject);
Begin
  Inherited;
  actPreview.Checked := Not actPreview.Checked;
  AdvOutlook.PreviewSettings.Column := 2;
  AdvOutlook.PreviewSettings.Active := actPreview.Checked;
End;

{-----------------------------------------------------------------------------
  Procedure: actRestoreExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRecycleFrame.actRestoreExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lCallUpdate: Boolean;
Begin
  lMsg := SelectedMsgInfo;
  If fdb.Connected And (lMsg <> Nil) Then
(*    If MessageDlg('Are you sure you want to restore the selected item?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to restore the selected item?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      lCallUpdate := (fDb.GetTotalInboxMessages(lMsg.Company_Id) = 0) Or
        (fDb.GetTotalOutboxMessages(lMsg.Company_Id) = 0);

      TDSR.DSR_RestoreMessage(_DashboardGetDSRServer, _DashboardGetDSRPort,
        lMsg.Guid);

      If lCallUpdate Then
        If Assigned(OnUpdateCompany) Then
          OnUpdateCompany;
    End; {messagedlg}
End;

End.

