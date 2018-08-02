{-----------------------------------------------------------------------------
 Unit Name: uOutboxFrame
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uOutboxFrame;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, umailBoxBaseFrame, AdvMenus, AdvMenuStylers, Menus, ExtCtrls,
  ActnList, AdvOutlookList, OutlookGroupedList, AdvPanel,
  ImgList, Math,
  uAdoDsr, StdCtrls, AdvProgressBar
  ;

Type
  TfrmOutboxFrame = Class(TfrmMailBoxBaseFrame)
    ppmOutbox: TAdvPopupMenu;
    mniDelete: TMenuItem;
    AdvMenuOfficeStyler: TAdvMenuOfficeStyler;
    aclExport: TActionList;
    actDelete: TAction;
    actResend: TAction;
    imlPopupmenu: TImageList;
    actRemoveSchedule: TAction;
    actViewSchedule: TAction;
    N1: TMenuItem;
    ViewSchedule1: TMenuItem;
    actChangeSchedule: TAction;
    ChangeSchedule1: TMenuItem;
    Resend2: TMenuItem;
    actViewCISResponse: TAction;
    mnuRemoveSchedule: TMenuItem;
    actSelectAll: TAction;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    N3: TMenuItem;
    actPreview: TAction;
    Preview1: TMenuItem;
    CheckCISResponse1: TMenuItem;
    Procedure actDeleteExecute(Sender: TObject);
    Procedure ppmOutboxPopup(Sender: TObject);
    Procedure actRemoveScheduleExecute(Sender: TObject);
    Procedure actViewScheduleExecute(Sender: TObject);
    Procedure tmBoxTimer(Sender: TObject);
    Procedure actViewCISResponseExecute(Sender: TObject);
    Procedure actSelectAllExecute(Sender: TObject);
    Procedure actPreviewExecute(Sender: TObject);
    Procedure actResendExecute(Sender: TObject);
  Private
    fDb: TADODSR;
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
  End;

Var
  frmOutboxFrame: TfrmOutboxFrame;

Implementation

Uses uConsts, uCommon, uDSR, uDashSettings, uDailyScheduleTask, uInterfaces,
  uDashGlobal, uPasswordDialog,
  uDailyFrame, uCISResponse, uExportFrame
  {, uBulkExport, uExportFrame, uSync}

  ;

{$R *.dfm}

{ TfrmOutboxFrame }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmOutboxFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
  BoxType := btOutbox;

  OnDeleteMessage := DeleteMessage;
  OnCanDelete := CanDelete;

  AskPassword := glISCIS;

  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
      _LogMSG('TfrmOutboxFrame.Create :- Error creating database connection. Error: '
        + e.message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmOutboxFrame.Destroy;
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.LoadMessages(pMsgs: Olevariant; Const pShowAlert:
  Boolean = False; Const pForceUpdate: Boolean = False);
Var
  lCont,
    lTotal: Longword;
  lGroup: TOutlookGroup;
  lMsgInfo: TMessageInfo;
  lMsg: TStrings;
Begin
 { get the total size of the array}
  lTotal := _GetOlevariantArraySize(pMsgs);

  {Clear items if the dashboard detect some e-mails have been deleted}
  If (lTotal <> Count) Or pForceUpdate Then
    Inherited;

  AdvOutlook.BeginUpdate;

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      lMsgInfo := _CreateOutboxMsgInfo(pMsgs[lCont]);

      If lMsgInfo <> Nil Then
      Begin
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
  Procedure: actDeleteExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actDeleteExecute(Sender: TObject);
Begin
  If AdvOutlook.SelectedCount > 0 Then
    If ShowDashboardDialog('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
      DeleteSelectedMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: ppmOutboxPopup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.ppmOutboxPopup(Sender: TObject);
Begin
  CheckActions(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: actRemoveScheduleExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actRemoveScheduleExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lRes: Longword;
Begin
  Inherited;

  lMsg := SelectedMsgInfo;

  If lMsg <> Nil Then
  Begin
    If ShowDashboardDialog('Are you sure you want to delete the scheduled message?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      lRes := TDSR.DSR_DeleteSchedule(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lMsg.Guid
        );

    {check for problens}
      If lRes <> S_OK Then
        If Assigned(OnAfterCallDSR) Then
          OnAfterCallDSR(lRes);
    End;
  End; {If lMsg <> Nil Then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: actViewScheduleExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actViewScheduleExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lSch: OleVariant;
  lDaily: TDailySchedule;
Begin
  Application.ProcessMessages;

  If Assigned(fDb) Then
  Begin
    {get the selected message}
    lMsg := SelectedMsgInfo;
    If lMsg <> Nil Then
    Begin
      {get the schedule from the message}
      lSch := fDb.GetDaySchedule(lMsg.ScheduleId);
      If Not VarIsNull(lSch) Then
      Begin
        {create a daily schedule}
        lDaily := _CreateDailySchedule(lSch);
        If lDaily <> Nil Then
        Begin
          Application.CreateForm(TfrmDailyScheduleTask, frmDailyScheduleTask);

          With frmDailyScheduleTask, frmDailyFrame, frmExportFrame Do
          Begin
            {mail information}
            SelectCompany(lMsg.Company_Id);
            advTo.Text := lMsg.To_;
            SetExportDetails(lMsg, lMsg.Subject, lMsg.Param1, lMsg.Param2);
            SelectDripFeed;
            cbJobs.Enabled := False;

            If (Sender = actViewSchedule) Or (Sender = Nil) Then
            Begin
              {disable fields when in view mode}
              actAddressBook.Enabled := False;
              frmDailyScheduleTask.btnAdd.Visible := False;
              frmDailyScheduleTask.btnCancel.Caption := '&Close';
              //lblInfo.Caption := 'Dashboard Dripfeed Scheduled Task Viewer';
              lblInfo.Caption := 'Dashboard Scheduled Task Viewer';
              frmDailyFrame.Enabled := False;
              frmExportFrame.Enabled := False;
              edtStartPeriod.Enabled := False;
              edtEndPeriod.Enabled := False;
            End {If Sender = actViewSchedule Then}
            Else
            Begin
              //lblInfo.Caption := 'Dashboard Change Dripfeed Scheduled Task';
              lblInfo.Caption := 'Dashboard Change Scheduled Task';
              actAddressBook.Enabled := True;
              MailInfo.Assign(lMsg);
              frmDailyScheduleTask.btnAdd.Caption := '&OK';
              edtStartPeriod.Enabled := True;
              edtEndPeriod.Enabled := True;
            End; {begin}

            {scheduled screen information}
            lblDailyDesc.Caption := 'The selected operation was set as: ';
            edtStartTime.DateTime := lDaily.StartTime;
            edtStartDate.Date := lDaily.StartDate;
            edtEndDate.Date := lDaily.EndDate;
            rbAllDays.checked := lDaily.AllDays;
            rbWeekdays.Checked := lDaily.WeekDays;

            With lDaily Do
              If (EveryYDay > 0) And Not (AllDays Or WeekDays) Then
              Begin
                rbEvery.Checked := True;
                seDays.Value := EveryYDay;
              End; {If (lDaily.EveryYDay > 0) And Not (lDaily.AllDays Or lDaily.WeekDays) Then}

            ShowModal;

            frmDailyScheduleTask.Free;
          End; {With frmDailyScheduleTask Do}
        End; {if lDaily <> nil then}

        If Assigned(lDaily) Then
          FreeAndNil(lDaily);
      End; {if not VarIsNull(lSch) then}
    End; {if lMsg <> nil then}
  End; {If lDb <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: tmBoxTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.tmBoxTimer(Sender: TObject);
Begin
  tmbox.Enabled := False;

{$IFDEF DEBUG}
  Try
    If Not CheckMessageBox Then
      GetMail;
  Except
    On E: EXCEPTION Do
      _LogMSG('TfrmOutboxFrame.tmBoxTimer :- Error refresing list. Error: ' +
        e.Message);
  End;
{$ELSE}
  If Not CheckMessageBox Then
    GetMail;
{$ENDIF}

  tmbox.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmOutboxFrame.DeleteMessage(pGuid: TGuid): Longword;
Begin
  Result := S_FALSE;
  If Assigned(fDb) Then
    Result := TDSR.DSR_DeleteOutboxMessage(_DashboardGetDSRServer,
      _DashboardGetDSRPort, fdb.GetOutboxCompanyId(pGuid), pGuid);
End;

{-----------------------------------------------------------------------------
  Procedure: CanDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.CanDelete(pGuid: TGuid; pStatus: Longword;
  pMode: Smallint; Var pCanDelete: Boolean);
Begin
  pCanDelete := Not (pStatus In [cBULKPROCESSING, cSENDING, cPROCESSING,
    cRECEIVINGDATA, cCHECKING, cLOADINGFILES, cSAVED]);


(*  {ask for password when deleting cis messages}
  If glISCIS And (pMode = Ord(rmCIS)) Then
  Begin
    If pCanDelete Then
    Begin
      If AskPassword Then
      Begin
        Application.CreateForm(TfrmPasswordDlg, frmPasswordDlg);

        With frmPasswordDlg Do
          ValidPassword := ShowModal = mrOk;

        pCanDelete := pCanDelete And ValidPassword;  

        frmPasswordDlg.Free;  

        AskPassword := False;
      End {If AskPassword Then}
      Else
        pCanDelete := pCanDelete And ValidPassword;
    End; {If pCanDelete Then}
  End; {If glISCIS And (pMode = Ord(rmCIS)) Then}*)
End;

{-----------------------------------------------------------------------------
  Procedure: actViewGGWReturnExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actViewCISResponseExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  Inherited;

  {load the selected message}
  lMsg := SelectedMsgInfo;

  If lMsg <> Nil Then
  Begin
    Application.CreateForm(TfrmCISResponse, frmCISResponse);

    With frmCISResponse Do
    Begin
      LoadXmlFileList(lMsg.Guid);
      ShowModal;
      Free;
    End; {with frmXMLViewer do}
  End; {If lMsg <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.GetMail;
Var
  lRes, lTotal: Longword;
  lLastUpdate: TDateTime;
  lMessages: Olevariant;
  lUpdate: Boolean;
Begin
  Try
    If Assigned(fDb) Then
      If fDb.Connected Then
      Begin
        lLastUpdate := fDb.GetLastOutboxUpdate;
        lTotal := fDb.GetTotalOutboxMessages(Company, IfThen(Archive, cARCHIVED,
          -1));

        lUpdate := (lTotal <> Count) Or (lLastUpdate <> LastUpdate);

        {check last outbox update}
        If lUpdate Then
        Begin
          lMessages := fDb.GetOutboxMessages(Company, 0, IfThen(Archive,
            cARCHIVED, -1), 0, 0, lRes, False);

          LoadMessages(lMessages, lUpdate);

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
  Procedure: CheckActions
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.CheckActions(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lSelectedCount,
    lCompActive: Boolean;
  lCount: Integer;
Begin
  lCount := Count;
  actViewCISResponse.Enabled := False;
  actRemoveSchedule.Enabled := False;
  actViewSchedule.Enabled := False;
  actChangeSchedule.Enabled := False;
  actDelete.Enabled := False;
  actSelectAll.Enabled := lCount > 0;
  actPreview.Enabled := actSelectAll.Enabled;
  actResend.Enabled := False;

  N1.Visible := Not glISCIS;
  actRemoveSchedule.Visible := Not glISCIS;
  actViewSchedule.Visible := Not glISCIS;
  actChangeSchedule.Visible := Not glISCIS;
  actResend.Visible := Not glISCIS;

  If (AdvOutlook.FocusedItem <> Nil) And (AdvOutlook.SelectedCount > 0) Then
  Begin
    lMsg := SelectedMsgInfo;

    If (fDb <> Nil) And (lMsg <> Nil) And glDSROnline Then
    Begin
    {look for someone who already has a schedule}

    {if only one message is selected , it will apply the general rule
    otherwise, just verify the dsronline variable
    For some reason, when there is only one item in the list, the component says there
    are two items because it counts the group too}

      lSelectedCount := SelectedCount = 1;

      If lSelectedCount Then
        actDelete.Enabled := glDSROnline And (Not
          (lMsg.Status In [cPROCESSING, cBULKPROCESSING, cSENDING,
          cLOADINGFILES, cRECEIVINGDATA, cCHECKING, cSAVED]))
      Else
        actDelete.Enabled := glDSROnline;

      lCompActive := fDb.IsCompanyActive(lMsg.Company_Id);

(*      N1.Visible := Not glISCIS;
      actRemoveSchedule.Visible := Not glISCIS;
      actViewSchedule.Visible := Not glISCIS;
      actChangeSchedule.Visible := Not glISCIS;*)

      actRemoveSchedule.Enabled := glDSROnline And MenuActive And
        (lMsg.ScheduleId > 0) And lSelectedCount;
      actViewSchedule.Enabled := glDSROnline And MenuActive And
        (lMsg.ScheduleId > 0) And lSelectedCount And lCompActive;
      actChangeSchedule.Enabled := glDSROnline And MenuActive And
        (lMsg.ScheduleId > 0) And lSelectedCount And lCompActive;

      {show option to load cis xml records}
      actViewCISResponse.Visible := fDb.HasCISRecord(lMsg.Guid) And glDSROnline
        And MenuActive And lSelectedCount And lCompActive And glISCIS;

      actViewCISResponse.Enabled := actViewCISResponse.Visible;

      actResend.Enabled := glDSROnline And MenuActive And lSelectedCount And
        lCompActive And (lMsg.TotalItens > 0) And (lMsg.Mode In [Ord(rmBulk),
        Ord(rmDripFeed)]) And (lMsg.Status In [cSENT, cFAILED, cRESTORED]) And
        Not fDb.IsEndOfSyncRequested(lMsg.Company_Id);
        {(Not (lMsg.Status In [cLOADINGFILES, cSENDING,
          cCHECKING, cPROCESSING, cBULKPROCESSING, cSAVED]))};
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
Procedure TfrmOutboxFrame.actSelectAllExecute(Sender: TObject);
Begin
  {avoid selecting groups...}
  SetFirstValidItem;
  AdvOutlook.SelectAll;
End;

{-----------------------------------------------------------------------------
  Procedure: PreviewClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actPreviewExecute(Sender: TObject);
Begin
  Inherited;
  actPreview.Checked := Not actPreview.Checked;
  AdvOutlook.PreviewSettings.Column := 2;
  AdvOutlook.PreviewSettings.Active := actPreview.Checked;
End;

{-----------------------------------------------------------------------------
  Procedure: actResendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmOutboxFrame.actResendExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  lMsg := SelectedMsgInfo;
  If fdb.Connected And (lMsg <> Nil) Then
    If ShowDashboardDialog('Are you sure you want to resend the selected item?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
      TDSR.DSR_ResendOutboxMessage(_DashboardGetDSRServer, _DashboardGetDSRPort,
        lMsg.Guid);

  Application.ProcessMessages;
End;

End.

