{-----------------------------------------------------------------------------
 Unit Name: uSchedule
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDailyScheduleTask;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, uDailyFrame, StdCtrls,
  uAdoDsr, uInterfaces,

  AdvOfficePager, AdvOfficePagerStylers, uExportFrame, AdvGlowButton,

  ufrmbase
  ;

const
  cINFO = '%s Dripfeed Scheduled Task';  

Type
  //TfrmDailyScheduleTask = Class(TForm)
  TfrmDailyScheduleTask = Class(TfrmBase)
    advSchedule: TAdvPanel;
    Panel1: TPanel;
    lblInfo: TLabel;
    opSchedule: TAdvOfficePager;
    AdvOfficePagerOfficeStyler: TAdvOfficePagerOfficeStyler;
    ofpReceiver: TAdvOfficePage;
    ofpSchedule: TAdvOfficePage;
    frmDailyFrame: TfrmDailyFrame;
    frmExportFrame: TfrmExportFrame;
    lblReceiverInfo: TLabel;
    lblScheduleInfo: TLabel;
    btnAdd: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    AdvPanelStyler: TAdvPanelStyler;
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure btnAddClick(Sender: TObject);
    procedure opScheduleChange(Sender: TObject);
  Private
    fAddNew: Boolean;
    fDb: TADODSR;
    fMsgInfo: TMessageInfo;
  Published
    Property AddNew: Boolean Read fAddNew Write fAddNew;
    property MailInfo: TMessageInfo read fMsgInfo write fMsgInfo;
  End;

Var
  frmDailyScheduleTask: TfrmDailyScheduleTask;

Implementation

Uses uDsr, uDashSettings, uCommon, uConsts, uDashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyScheduleTask.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCancelClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyScheduleTask.FormCreate(Sender: TObject);
Begin
  fMsgInfo := TMessageInfo.Create;
  
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database: ' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('TfrmDailyScheduleTask.FormCreate :- Error creating database connection. Error: '+ e.message);
    End;
  End; {try}

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);

  opSchedule.ActivePage := ofpSchedule;
  opSchedule.ActivePage := ofpReceiver;
  Self.HelpContext := 18;

  With frmExportFrame Do
  Begin
    actSend.Visible := False;
    actCancel.Visible := False;
    advDockdashTop.Visible := False;
    SelectDripFeed;
  End; {with frmExportFrame do}

  With frmDailyFrame Do
  Begin
    btnOk.Visible := False;
    btnCancel.Visible := False;
  End; {with frmDailyFrame do}
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyScheduleTask.FormDestroy(Sender: TObject);
Begin
  frmExportFrame.ClearComboBoxes;

  if Assigned(fMsgInfo) then
    FreeAndNil(fMsgInfo);
  If Assigned(fDb) Then
    FreeAndNil(fDb);

  inherited;  
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyScheduleTask.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyScheduleTask.btnAddClick(Sender: TObject);
Var
  lGuid: TGuid;
  lComp, lPackId: Integer;
Begin
  If Assigned(fDb) Then
  Begin
    frmExportFrame.ValidateFields;

    If frmDailyFrame.edtStartDate.Date > frmDailyFrame.edtEndDate.Date Then
    Begin
      //MessageDlg('Please, select a valid ending date for the schedule!', mtInformation, [mbok], 0);
      ShowDashboardDialog('Please, select a valid ending date for the schedule!', mtInformation, [mbok]);
      Abort;
    End; {If frmDailyFrame.edtStartDate.Date > frmDailyFrame.edtEndDate.Date Then}

  {add the new schedule entry based on a valid message}
    With TDSR, frmExportFrame, frmDailyFrame Do
    Begin
      FillChar(lGuid, SizeOf(TGuid), 0);
      if IsEqualGUID(fMsgInfo.Guid, lGuid) then
        lGuid := _CreateGuid
      else
        lGuid := fMsgInfo.Guid;  

      lComp := TCompany(cbCompanies.Items.Objects[cbCompanies.ItemIndex]).Id;
      With cbJobs Do
        lPackId := TPackageInfo(Items.Objects[ItemIndex]).Id;

      DSR_SetDailySchedule(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lGuid,
        lComp,
        advSubject.Text,
        //_DashboardGetDefaultMail,
        //fDb.GetSystemValue(cDEFAULTEMAILPARAM),
        fDb.GetDefaultEmailAccount,
        advTo.Text,
        edtStartPeriod.Text,
        edtEndPeriod.text,
        lPackId,
        edtStartDate.DateTime,
        edtEndDate.DateTime,
        edtStartTime.DateTime,
        Ord(rbAllDays.checked),
        ord(rbWeekdays.Checked),
        seDays.Value
        );
    End; {With TDSR, fMailInfo, frmDailyFrame Do}

    ModalResult := mrOk;
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: opScheduleChange
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmDailyScheduleTask.opScheduleChange(Sender: TObject);
begin
  if opSchedule.ActivePage = ofpReceiver then
    Self.HelpContext := 18
  else
    Self.HelpContext := 19
end;

End.

