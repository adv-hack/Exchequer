{-----------------------------------------------------------------------------
 Unit Name: uInboxFrame
 Author:    vmoura
 Purpose:
 History:

-----------------------------------------------------------------------------}

Unit uInboxFrame;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, umailBoxBaseFrame, AdvMenus, AdvMenuStylers, Menus, ExtCtrls, Math,
  ActnList, ImgList, StdCtrls, AdvOutlookList, OutlookGroupedList, AdvPanel,

  DateUtils,

  uInterfaces, uDashGlobal, uAdoDSR, AdvProgressBar;

Type
  TfrmInboxFrame = Class(TfrmMailBoxBaseFrame)
    ppmInbox: TAdvPopupMenu;
    mnuImport: TMenuItem;
    mnuDelete: TMenuItem;
    AdvMenuOfficeStyler: TAdvMenuOfficeStyler;
    aclInbox: TActionList;
    actImport: TAction;
    actDelete: TAction;
    imlPopupmenu: TImageList;
    N1: TMenuItem;
    actImportTo: TAction;
    mnuImportTo: TMenuItem;
    tmChangeStatus: TTimer;
    actAccept: TAction;
    actDeny: TAction;
    mnuAccept: TMenuItem;
    mnuDeny: TMenuItem;
    N2: TMenuItem;
    actSelectAll: TAction;
    N3: TMenuItem;
    SelectAll1: TMenuItem;
    N4: TMenuItem;
    actPreview: TAction;
    Preview1: TMenuItem;
    Procedure ppmInboxPopup(Sender: TObject);
    Procedure actDeleteExecute(Sender: TObject);
    Procedure actImportExecute(Sender: TObject);
    Procedure actImportToExecute(Sender: TObject);
    Procedure tmBoxTimer(Sender: TObject);
    Procedure tmChangeStatusTimer(Sender: TObject);
    Procedure AdvOutlookItemClick(Sender: TObject; Item: POGLItem;
      Column: Integer);
    Procedure AdvOutlookSelectionChange(Sender: TObject);
    Procedure actDenyExecute(Sender: TObject);
    Procedure actSelectAllExecute(Sender: TObject);
    Procedure actAcceptExecute(Sender: TObject);
    Procedure actPreviewExecute(Sender: TObject);
  Private
    fCompanyActive: Boolean;
    fDb: TADODSR;
    Procedure ProcessMessageSelected(pMsg: TMessageInfo);
  Protected
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure CheckActions(Sender: TObject);
    Procedure LoadMessages(pMsgs: Olevariant; Const pShowAlert: Boolean =
      False; Const pForceUpdate: Boolean = False); Override;
    Function DeleteMessage(pGuid: TGuid): Longword;
    Procedure CanDelete(pGuid: TGuid; pStatus: Longword; pMode: Smallint; Var
      pCanDelete: Boolean);
    Procedure GetMail; Override;
  Published
    Property CompanyActive: Boolean Read fCompanyActive Write fCompanyActive;
  End;

Var
  frmInboxFrame: TfrmInboxFrame;

Implementation

Uses uConsts, uCommon, uDsr, uDashSettings, uCompImport,
  uExportFrame {, uSync};

{$R *.dfm}

{ TfrmInboxFrame }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmInboxFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
  BoxType := btInbox;

  OnDeleteMessage := DeleteMessage;
  OnCanDelete := CanDelete;

  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      _LogMSG('TfrmInboxFrame.Create :- Error creating database connection. Error: '
        + e.message);
    End;
  End; {try}

  ResizeHeaders;
  Self.Perform(WM_SIZE, 0, 0);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmInboxFrame.Destroy;
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.LoadMessages(pMsgs: Olevariant; Const pShowAlert:
  Boolean = False; Const pForceUpdate: Boolean = False);
Var
  lMsg: TStrings;
//  lStr: TStringlist;
  lCont,
    lTotal: Longword;
  lGroup: TOutlookGroup;
  lMsgInfo: TMessageInfo;
  lShow: Boolean;
  lText: String;
Begin
  lTotal := _GetOlevariantArraySize(pMsgs);
  {double check if it really needs to show new messages}
  lShow := pShowAlert And (lTotal > Count) And Not Archive;

  If ClearItemsAllowed Then
    If (lTotal <> Count) Or pForceUpdate Then
      Inherited;

  AdvOutlook.BeginUpdate;

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      {get the message from stringlist}
      lMsgInfo := _CreateInboxMsgInfo(pMsgs[lCont]);

      If lMsgInfo <> Nil Then
      Begin
        {get the respective group}
        lGroup := GetGroup(lMsgInfo.Date);

        {check whether this message exists }
        lMsg := MailExists(GUIDToString(lMsgInfo.Guid));
        If lMsg = Nil Then
          lMsg := AdvOutlook.AddItem(lGroup);

        AddMessageDetail(lMsg, lMsgInfo, lMsgInfo.From, True);

        {show alert when messages arrive. In this case, after receiving the whole batch
        or when a company request to remove sync...}
        If (lShow) And (lMsgInfo.Status In [cREADYIMPORT, cREMOVESYNC,
          cSYNCDENIED, cSYNCFAILED, cSYNCACCEPTED, cCANCELLED, cDRIPFEEDCANCELLED])
          And Not glDashLoading Then
        Begin
          lText := 'New message from: <b>' + lMsgInfo.From + '</b><br>' + CRLF;
          lText := lText + 'Subject: ' + lMsgInfo.Subject + '<br>' + CRLF;
          lText := lText + 'Received: ' + datetimetostr(lMsgInfo.Date);

          If Assigned(OnNewMessageArrived) Then
            OnNewMessageArrived(Self, lText);
        End;
      End; {If lMsgInfo <> Nil Then}
    End; {For lCont := 0 To lTotal - 1 Do}

  AdvOutlook.EndUpdate;
End;

{-----------------------------------------------------------------------------
  Procedure: actDeleteExecute
  Author:    vmoura

  the import operation. The batch can only be imported if
  the status of the message is ready to import. Otherwise, the user shouldn't be able to do so

-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.ppmInboxPopup(Sender: TObject);
Begin
  CheckActions(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: actDeleteExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actDeleteExecute(Sender: TObject);
Begin
  If AdvOutlook.SelectedCount > 0 Then
(*    If MessageDlg('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
      DeleteSelectedMessages;
//  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: actImportExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actImportExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lRes: Longword;
  lText, lAux, lTitle: String;
  lStart, lEnd: Integer;
Begin
  lMsg := SelectedMsgInfo;

  {import the selected mail to its default company}
  If lMsg <> Nil Then
  Begin
    {load title and caption of the message based on their operational modes}
    lAux := lMsg.Subject;
    If (Pos('bulk export', Lowercase(lAux)) > 0) And (lMsg.Mode = Ord(rmBulk)) Then
    Begin
      lStart := Pos('from', Lowercase(lAux)) + 5;
      lEnd := Pos(']', lAux) + 1;
      lTitle := 'Bulk Export data from ';
      lText := Copy(lAux, lStart, lEnd - lStart);
    End
    //Else If (Pos('dripfeed from', Lowercase(lAux)) > 0) And (lMsg.Mode =
      Else If (Pos('update link', Lowercase(lAux)) > 0) And (lMsg.Mode = Ord(rmDripFeed)) Then
    Begin
      lStart := Pos('from', Lowercase(lAux)) + 5;
      lEnd := Pos(']', lAux) + 1;
      //lTitle := 'Dripfeed data from ';
      lTitle := 'Linked data from ';
      lText := Copy(lAux, lStart, lEnd - lStart);
    End
    Else
    Begin
      lTitle := 'data from ';
      lText := lMsg.From + '" subject: "' + lMsg.Subject;
    End; {else begin}

    lText := _ChangeAmpersand(lText);

    If ShowDashboardDialog('Are you sure you want to import ' + lTitle + '"' + lText + '"?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      lRes := TDSR.DSR_Import(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lMsg.Company_Id,
        lMsg.Guid,
        lMsg.Pack_Id
        );

    {check for problens}
      If lRes <> S_OK Then
        If Assigned(OnAfterCallDSR) Then
          OnAfterCallDSR(lRes);

    {try to update the menu}
      If lMsg.Mode = Ord(rmSync) Then
        If Assigned(OnUpdateCompany) Then
          OnUpdateCompany;
    End;
  End; {If lMsg <> Nil Then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: actImportToExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actImportToExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  lMsg := SelectedMsgInfo;
  Refresh;
  {import the selected mail to a choosen company}
  If lMsg <> Nil Then
  Begin
    Application.CreateForm(TfrmCompImport, frmCompImport);
    With frmCompImport Do
    Begin
      MailInfo.Assign(lMsg);
      ShowModal;
      Free;
    End; {With frmCompImport Do}
  End; {If lMsg <> Nil Then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: tmBoxTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.tmBoxTimer(Sender: TObject);
Begin
  tmBox.Enabled := False;

{$IFDEF DEBUG}
  Try
    If Not CheckMessageBox Then
      GetMail;
  Except
    On E: EXCEPTION Do
      _LogMSG('TfrmInboxFrame.tmBoxTimer :- Error refresing list. Error: ' +
        e.Message);
  End;
{$ELSE}
  If Not CheckMessageBox Then
    GetMail;
{$ENDIF}

  tmBox.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteSelectedMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmInboxFrame.DeleteMessage(pGuid: TGuid): Longword;
Begin
  Result := S_False;
  If Assigned(fDb) Then
    Result := TDSR.DSR_DeleteInboxMessage(_DashboardGetDSRServer,
      _DashboardGetDSRPort, fDb.GetInboxCompanyId(pGuid), pGuid);
End;

{-----------------------------------------------------------------------------
  Procedure: CanDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.CanDelete(pGuid: TGuid; pStatus: Longword;
  pMode: Smallint; Var pCanDelete: Boolean);
Begin
  pCanDelete := Not (pStatus In [cPROCESSING, cPOPULATING, cLOADINGFILES,
    cREMOVESYNC, cRECEIVINGDATA, cDRIPFEEDCANCELLED]);
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.GetMail;
Var
  lRes, lTotal, lTotalNew: Longword;
  lLastUpdate: TDateTime;
  lMessages: Olevariant;
  lUpdate: Boolean;
Begin
  Try
    If Assigned(fDb) Then
      If fDb.Connected Then
      Begin
        // Get the time the inbox was last updated
        lLastUpdate := fDb.GetLastInboxUpdate;
        // Get the total number of messages
        lTotal := fDb.GetTotalInboxMessages(Company, IfThen(Archive, cARCHIVED, -1));

        If Assigned(OnUpdateInboxNode) Then
        Begin
          {search for all new messages using the company code}
          lTotalNew := fDb.GetTotalInboxMessages(Company, cALLNEW);

          //if Company > 0 then
          if not glISCIS then
            lTotalNew := lTotalNew + fDb.GetTotalInboxSyncMessages(Company);

          If (lTotalNew > 0) And CompanyActive Then
            OnUpdateInboxNode(Company, Format(cBOLD, [MailBoxName]) +
              ' <font color="clBlue">(' + inttostr(lTotalNew) + ')</font>')
          Else
            OnUpdateInboxNode(Company, MailBoxName)

        End; {If Assigned(OnUpdateInboxNode) Then}

        lUpdate := (lTotal <> Count) Or (lLastUpdate <> LastUpdate);

  {check last inbox update}
        If lUpdate Then
        Begin
          lMessages := fDb.GetInboxMessages(Company, 0, IfThen(Archive,
            cARCHIVED, -1), 0, 0, lRes, False);

          LoadMessages(lMessages, (lUpdate And CompanyActive));

          LastUpdate := lLastUpdate;

          If Assigned(OnAfterLoadMessages) Then
            OnAfterLoadMessages(Self, lRes);
        End; {total <> count}
      End; {If fDb.Connected Then}
  Except
  End; {Try}

  {check pane info}
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
  Procedure: tmChangeStatusTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.tmChangeStatusTimer(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  tmChangeStatus.Enabled := False;
  lMsg := SelectedMsgInfo;
  If lMsg <> Nil Then
    If lMsg.Status In [cSYNCDENIED, cSYNCFAILED, cSYNCACCEPTED, cACKNOWLEDGE] Then
    Begin
      Try
        fDb.SetInboxMessageStatus(lMsg.Guid, cPROCESSED);
        lblStatus.Caption := _GetStatusMessage(cPROCESSED);
      Except
      End;
    End; {If lMsg.Status In [cSYNCDENIED, cSYNCFAILED, cSYNCACCEPTED] Then}
End;

{-----------------------------------------------------------------------------
  Procedure: CheckActions
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.CheckActions(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lSelectedCount,
    lEOSRequested: Boolean;
  lCount: Integer;
Begin
  lCount := Count;
  actImportTo.Enabled := False;
  actDelete.Enabled := False;
  actImport.Enabled := False;
  actAccept.Enabled := False;
  actDeny.Enabled := False;
  actSelectAll.Enabled := lCount > 0;
  actPreview.Enabled := actSelectAll.Enabled;

  If (AdvOutlook.FocusedItem <> Nil) And (AdvOutlook.SelectedCount > 0) Then
  Begin
    lMsg := SelectedMsgInfo;

    If lMsg <> Nil Then
    Begin
      lEOSRequested := False;
      {checl if a end of sync has been requested}
      If Company > 0 Then
        lEOSRequested := fDb.IsEndOfSyncRequested(Company);

      {avoid selecting more than one item to import/deny/accept (only one by one is valid)}


      // a user can send a end of sync at any time or cancel the sync even just after making a request
      lSelectedCount := SelectedCount = 1;

      actAccept.Visible := Not glISCIS;
      actDeny.Visible := Not glISCIS;

      // only accept messages that are sync requests and are ready to import or for some
      // reason has failed in the first attempt

      actAccept.Enabled := glDSROnline And Not lEOSRequested And MenuActive And
        (lMsg.Status In [cREADYIMPORT, cFAILED]) And (lMsg.Mode = ord(rmSync)) And
        lSelectedCount;

      actDeny.Enabled := actAccept.Enabled;

      // only bulk a syncs can be imported
      actImport.Enabled := glDSROnline And Not lEOSRequested And MenuActive And
        (lMsg.Status In [cREADYIMPORT, cFAILED]) And (lMsg.Mode <> ord(rmSync)) And
        lSelectedCount;

      {if only one message is selected, apply the rules for that specific message}
      If lSelectedCount Then
        actDelete.Enabled := glDSROnline And (Not (lMsg.Status In
          [cPROCESSING, cPOPULATING, cREMOVESYNC, cRECEIVINGDATA, cLOADINGFILES,
          cDRIPFEEDCANCELLED]))
      Else
        actDelete.Enabled := glDSROnline;

    {if the dsr failed to get the company, the dashboard will open this option}
{$IFNDEF DEBUG}
      actImportTo.Enabled := glDSROnline And MenuActive And (lMsg.Company_Id = 0)
        And (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed)]) And
      (lMsg.Status In [cREADYIMPORT, cFAILED]);
{$ELSE}
      actImportTo.Enabled := True;
{$ENDIF}
      actImportTo.Visible := actImportTo.Enabled;
    End
    Else If Assigned(Sender) Then
      Abort;
  End
  Else If Assigned(Sender) Then
    Abort;
End;

{-----------------------------------------------------------------------------
  Procedure: AdvOutlookItemClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.AdvOutlookItemClick(Sender: TObject;
  Item: POGLItem; Column: Integer);
Var
  lMsg: TMessageInfo;
Begin
  lMsg := _GetMailInfoFromStrings(GetFocused);

  If lMsg <> Nil Then
    ProcessMessageSelected(lMsg);

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: AdvOutlookSelectionChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.AdvOutlookSelectionChange(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  lMsg := _GetMailInfoFromStrings(GetFocused);

  If lMsg <> Nil Then
    ProcessMessageSelected(lMsg);

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: AfterMessageSelected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.ProcessMessageSelected(pMsg: TMessageInfo);
Begin
  If pMsg <> Nil Then
  Begin
    If pMsg.Status In [cSYNCDENIED, cSYNCFAILED, cSYNCACCEPTED, cACKNOWLEDGE] Then
      tmChangeStatus.Enabled := True
    Else
      tmChangeStatus.Enabled := False;
  End; {if pMsg <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: actDenyExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actDenyExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lStart, lEnd: Integer;
  lAux,
    lText: String;
Begin
  {Ex: Sync request from Don Vini [MC SPOP Customer] for 01/1999 to 12/1999}
  lMsg := SelectedMsgInfo;
  If lMsg <> Nil Then
  Begin
    lAux := lMsg.Subject;
    //If (Pos('dripfeed request', Lowercase(lAux)) > 0) And (lMsg.Mode = Ord(rmSync))
    If (Pos('link request', Lowercase(lAux)) > 0) And (lMsg.Mode = Ord(rmSync)) Then
    Begin
      lStart := Pos('from', Lowercase(lAux)) + 5;
      lEnd := Pos(']', lAux) + 1;
      lText := Copy(lMsg.Subject, lStart, lEnd - lStart);
    End {if Pos('dripfeed request', Lowercase(lAux)) > 0 then}
    Else
      lText := lMsg.From + ' subject ' + lMsg.Subject;

    //If ShowDashboardDialog('Are you sure you want to deny the Dripfeed Request from "' + lText
    If ShowDashboardDialog('Are you sure you want to deny the Link Request from "' + lText
      + '"?', mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      //DeleteSelectedMessages;
      udsr.TDSR.DSR_DenySyncRequest(_DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lMsg.Company_Id,
        lMsg.Guid)
    End; {if message dlg}
  End; {If lMsg <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actSelectAllExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actSelectAllExecute(Sender: TObject);
Begin
  {avoid selecting groups...}
  SetFirstValidItem;
  AdvOutlook.SelectAll;
End;

Procedure TfrmInboxFrame.actAcceptExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lRes: Longword;
  lStart, lEnd: Integer;
  lAux, lText: String;
Begin
  lMsg := SelectedMsgInfo;

  {import the selected mail to its default company}
  If lMsg <> Nil Then
  Begin
    lAux := lMsg.Subject;
    //If (Pos('dripfeed request from', Lowercase(lAux)) > 0) And (lMsg.Mode =
    If (Pos('link request from', Lowercase(lAux)) > 0) And (lMsg.Mode = Ord(rmSync)) Then
    Begin
      lStart := Pos('from', Lowercase(lAux)) + 5;
      lEnd := Pos(']', lAux) + 1;
      lText := Copy(lMsg.Subject, lStart, lEnd - lStart);
    End {if Pos('dripfeed request', Lowercase(lAux)) > 0 then}
    Else
      lText := lMsg.From + '. Subject: ' + lMsg.Subject;

    lText := _ChangeAmpersand(lText);

    //If ShowDashboardDialog('Are you sure you want to accept the Dripfeed Request from "' +
    If ShowDashboardDialog('Are you sure you want to accept the Link Request from "' +
      lText + '"?', mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      lRes := TDSR.DSR_Import(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lMsg.Company_Id,
        lMsg.Guid,
        lMsg.Pack_Id
        );

    {check for problens}
      If lRes <> S_OK Then
        If Assigned(OnAfterCallDSR) Then
          OnAfterCallDSR(lRes);

    {try to update the menu}
      If lMsg.Mode = Ord(rmSync) Then
        If Assigned(OnUpdateCompany) Then
          OnUpdateCompany;
    End;
  End; {If lMsg <> Nil Then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: actPreviewExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmInboxFrame.actPreviewExecute(Sender: TObject);
Begin
  actPreview.Checked := Not actPreview.Checked;
  AdvOutlook.PreviewSettings.Column := 2;
  AdvOutlook.PreviewSettings.Active := actPreview.Checked;
End;

End.

