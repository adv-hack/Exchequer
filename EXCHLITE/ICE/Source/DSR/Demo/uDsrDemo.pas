Unit uDsrDemo;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, comobj, activex, dateutils,
  DSR_TLB,
  ComCtrls, msmsg, Mssocket, Mspop
  ;

Type
  TfrmComDSRDemo = Class(TForm)
    btnExport: TButton;
    btnIMport: TButton;
    btngetout: TButton;
    Button4: TButton;
    btnNewMessages: TButton;
    lv: TListView;
    btnResend: TButton;
    btnSetImportPackage: TButton;
    btnSetExportPck: TButton;
    btnDeleteex: TButton;
    btngetinboxmsg: TButton;
    cbExports: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbImports: TComboBox;
    btnGetExpPackages: TButton;
    GetImportPackages: TButton;
    btnDeleteOutbox: TButton;
    btnSetDaySchedule: TButton;
    btnWeeklySchedule: TButton;
    btnMonthlySchedule: TButton;
    btnOneTimeOnly: TButton;
    btnDeleteSchedule: TButton;
    btnBulk: TButton;
    Button2: TButton;
    edtCompany: TEdit;
    Label3: TLabel;
    btnCreateCompany: TButton;
    cbCompanies: TComboBox;
    btnLoadCompanies: TButton;
    edtCode: TEdit;
    Label4: TLabel;
    edtFrom: TEdit;
    edtTo: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    btnSync: TButton;
    btnRebuild: TButton;
    btnCheckDripFeed: TButton;
    btnRemovedripFeed: TButton;
    btnCheckCompanies: TButton;
    btnCheckMails: TButton;
    btnGetDsrSettings: TButton;
    btnSetDsrSettings: TButton;
    btnSyncRequest: TButton;
    msPOP1: TmsPOPClient;
    Button1: TButton;
    msMessage1: TmsMessage;
    Button3: TButton;
    btnLastAuditDate: TButton;
    btnAlive: TButton;
    Button5: TButton;
    btnActivateCompany: TButton;
    btnProductType: TButton;
    btnBulkExport: TButton;
    edtPeriod1: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtPeriod2: TEdit;
    Button6: TButton;
    edtGuid: TEdit;
    btnSyncDeny: TButton;
    btnRecreateCompany: TButton;
    Button7: TButton;
    Procedure btnExportClick(Sender: TObject);
    Procedure Button4Click(Sender: TObject);
    Procedure btnNewMessagesClick(Sender: TObject);
    Procedure btnResendClick(Sender: TObject);
    Procedure btnIMportClick(Sender: TObject);
    Procedure btnSetImportPackageClick(Sender: TObject);
    Procedure btnSetExportPckClick(Sender: TObject);
    Procedure btnDeleteexClick(Sender: TObject);
    Procedure btngetoutClick(Sender: TObject);
    Procedure btngetinboxmsgClick(Sender: TObject);
    Procedure btnGetExpPackagesClick(Sender: TObject);
    Procedure GetImportPackagesClick(Sender: TObject);
    Procedure btnDeleteOutboxClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnSetDayScheduleClick(Sender: TObject);
    Procedure btnWeeklyScheduleClick(Sender: TObject);
    Procedure btnMonthlyScheduleClick(Sender: TObject);
    Procedure btnOneTimeOnlyClick(Sender: TObject);
    Procedure btnDeleteScheduleClick(Sender: TObject);
    Procedure btnBulkClick(Sender: TObject);
    Procedure btnCreateCompanyClick(Sender: TObject);
    Procedure btnLoadCompaniesClick(Sender: TObject);
    Procedure btnSyncClick(Sender: TObject);
    Procedure btnRebuildClick(Sender: TObject);
    Procedure btnCheckDripFeedClick(Sender: TObject);
    Procedure btnRemovedripFeedClick(Sender: TObject);
    Procedure btnCheckCompaniesClick(Sender: TObject);
    Procedure btnCheckMailsClick(Sender: TObject);
    Procedure btnGetDsrSettingsClick(Sender: TObject);
    Procedure btnSetDsrSettingsClick(Sender: TObject);
    Procedure btnSyncRequestClick(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button3Click(Sender: TObject);
    Procedure btnLastAuditDateClick(Sender: TObject);
    Procedure btnAliveClick(Sender: TObject);
    Procedure Button5Click(Sender: TObject);
    procedure btnActivateCompanyClick(Sender: TObject);
    procedure btnProductTypeClick(Sender: TObject);
    procedure btnBulkExportClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btnSyncDenyClick(Sender: TObject);
    procedure btnRecreateCompanyClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  Private
    fResult: longword;
    fDsr: IDSRSERVER;
    fXmlSettings: WideString;
  Public
  End;

  Tpack = Class
  Private
    fId: Integer;
  Published
    Property Id: Integer Read fId Write fId;
  End;

Var
  frmComDSRDemo: TfrmComDSRDemo;

Implementation

uses uCommon, uConsts, uInterfaces;

{$R *.dfm}

Procedure TfrmComDSRDemo.btnExportClick(Sender: TObject);
Var
  lres: longword;
  lResult: widestring;
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);
  If cbExports.Text <> '' Then
  Begin
    lRes := fdsr.DSR_Export(lComp, 'Export Test ' + datetimetostr(now),
      edtFrom.text,
      edtTo.text,
      edtPeriod1.Text,
      edtPeriod2.Text,
      Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id);

    If lres <> 0 Then
    Begin
      lResult := fdsr.DSR_TranslateErrorCode(lRes);
      showmessage(lResult);
    End;
  End
  Else
    ShowMessage('Select a valid export method!');
End;

Procedure TfrmComDSRDemo.Button4Click(Sender: TObject);
Var
  x: longword;
Begin
  //dsr := CreateOleObject('DSR.DSRSERVER') as idsrserver;
  fResult := fdsr.DSR_TotalOutboxMessages(1, x);

  If x > 0 Then
    showmessage(inttostr(x));
End;

Procedure TfrmComDSRDemo.btnNewMessagesClick(Sender: TObject);
Var
  // declare a result variable
  lGuids: OleVariant;
  i,
    lCount: Longword;

  lMsg: String;
Begin
  fResult := S_OK;
  lv.Clear;

  // call com caller delete outbox
  fResult := fdsr.DSR_NewInboxMessage(10, lGuids);

  // get the error message if something got wrong...
  If fResult = 0 Then
  Begin
      // update the outbox list and test the olevariant type
    If VarIsArray(lGuids) Then
    Begin
      lv.Clear;
      lv.Items.BeginUpdate;

      For i := 0 To VarArrayHighBound(lGuids, VarArrayDimCount(lGuids)) - 1 Do
      Begin
        With lv.Items.Add Do
        Begin
          Caption := lGuids[i][2];
          SubItems.Add(datetimetostr(lGuids[i][9]));
          SubItems.Add(lGuids[i][0]);
        End;
      End;

      lv.Items.EndUpdate;
    End; // if varisarray
  End
  Else
  Begin
    lMsg := fdsr.DSR_TranslateErrorCode(fResult);
    ShowMessage(lMsg);
  End;
End;

Procedure TfrmComDSRDemo.btnResendClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If lv.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fResult :=
      fdsr.DSR_ResendOutboxMessage(StringToGUID(lv.Selected.SubItems[1]));

  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;
  End;
End;

Procedure TfrmComDSRDemo.btnIMportClick(Sender: TObject);
Var
  lcomp: Integer;
Begin
  If (lv.Selected <> Nil) And (cbCompanies.ItemIndex >= 0) Then
  Begin
    lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
      Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0)
  End
  Else
    lComp := 0;

  fResult := S_OK;

  // call com caller import function
  fResult := fdsr.DSR_Import(lComp, StringToGUID(lv.Selected.SubItems[1]), 0);

  // get the error message if something got wrong...
  If fResult = S_OK Then
    ShowMessage('Sucess!');
End;

Procedure TfrmComDSRDemo.btnSetImportPackageClick(Sender: TObject);
//Var
  // declare a result variable
//  dsr: idsrserver;
//  lStr: TStringlist;
Begin
(*  dsr := CoDSRSERVER.Create As idsrserver;

  lStr := TStringlist.Create;
  lStr.Add('C:\Projects\Ice\Bin\XmlModel\cust.xml');
  lStr.Add('C:\Projects\Ice\Bin\Transform\cust.xsl');
  lStr.Add('C:\Projects\Ice\Bin\Schema\cust.xsd');

  dsr.DSR_SetImportPackage('Customer',
    StringToGUID('{FDC1B564-3F58-462B-8B86-D144D4B9EEA2}'),
    lstr[0], lstr[1], lstr[2], 1, fResult);

  If fResult <> s_ok Then
    Showmessage(inttostr(fresult));

  lstr.free;
  dsr := Nil;
  *)

End;

Procedure TfrmComDSRDemo.btnSetExportPckClick(Sender: TObject);
Var
  // declare a result variable
  lStr: TStringlist;
Begin
(*
  dsr := CoDSRSERVER.Create As idsrserver;

  lStr := TStringlist.Create;
  lStr.Add('C:\Projects\Ice\Bin\XmlModel\cust.xml');
  lStr.Add('C:\Projects\Ice\Bin\Transform\cust.xsl');
  lStr.Add('C:\Projects\Ice\Bin\Schema\cust.xsd');

  dsr.DSR_SetExportPackage('Ex Customer',
    StringToGUID('{DD19A409-26FA-4D30-96C6-8E4DB2E7F55E}'),
    lstr[0], lstr[1], lstr[2], 1, fResult);

  lstr.free;

  dsr := Nil;
  *)

End;

Procedure TfrmComDSRDemo.btnDeleteexClick(Sender: TObject);
Begin
//  dsr.DSR_DeleteExportPackage(2, fResult);

  If fResult <> s_ok Then
    showmessage('error')
  Else
    showmessage('succes');
End;

Procedure TfrmComDSRDemo.btngetoutClick(Sender: TObject);
Var
  // declare a result variable
  lOut: Olevariant;
  i: Integer;
  lComp: Longword;
  lMsg: TMessageInfo;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);
  fResult := fdsr.DSR_GetOutboxMessages(lComp, 0, cDELETED, 0, 0, lOut);

  If Not VarIsNull(lOut) Then
  Begin
    lv.Clear;
    For i := 0 To VarArrayHighBound(lOut, VarArrayDimCount(lout)) - 1 Do
    Begin
      lMsg := _CreateOutboxMsgInfo(lOut[i]);
      if lMsg <> nil then
      begin
        With lv.Items.Add Do
        Begin
          Caption := lMsg.Subject;
          SubItems.Add(datetimetostr(lMsg.Date));
          SubItems.Add(GUIDToString(lMsg.Guid));
        End;

        lMsg.Free;
      end;
    End;

{
        Fieldbyname('guid').asString,
          Fieldbyname('company_id').Asinteger,
          Fieldbyname('subject').AsString,
          Fieldbyname('userfrom').AsString,
          Fieldbyname('userto').AsString,
          FieldByName('package_id').AsInteger,
          FieldByName('status').AsInteger,
          FieldByName('param1').AsString,
          FieldByName('param2').AsString,
          FieldByName('totalitems').AsInteger,
          FieldByName('irmark').AsString,
          FieldByName('sent').AsDateTime
}

    If fResult <> s_ok Then
      showmessage('error')
  End;
End;

Procedure TfrmComDSRDemo.btngetinboxmsgClick(Sender: TObject);
Var
  // declare a result variable
  lIn: OleVariant;
  i: Integer;
Begin
  fResult := fdsr.DSR_GetInboxMessages(0, 0, 99, 0, 10, lIn);

  If Not varisnull(lIn) And VarIsArray(lIn) Then
  Begin
    lv.Clear;
    For i := 0 To VarArrayHighBound(lIn, VarArrayDimCount(lIn)) - 1 Do
    Begin
      With lv.Items.Add Do
      Begin
        Caption := lIn[i][3];
        SubItems.Add(datetimetostr(lIn[i][8]));
        SubItems.Add(lIn[i][0]);
      End;
    End;

  End;

  lIn := null;
End;

Procedure TfrmComDSRDemo.btnGetExpPackagesClick(Sender: TObject);
Var
  lpacks: OleVariant;
  lPack: Tpack;
  i: Integer;
Begin
  fResult := fdsr.DSR_GetExportPackages(lpacks);

  If fResult <> 0 Then
    showmessage(inttostr(FResult));

  cbExports.Clear;
  cbExports.Items.BeginUpdate;

  For i := 0 To VarArrayHighBound(lPacks, VarArrayDimCount(lPacks)) - 1 Do
  Begin
    lPack := Tpack.Create;
    lPack.Id := lPacks[i][0];
    cbExports.Items.AddObject(lPacks[i][2], lPack);
  End;

  cbExports.Items.EndUpdate;
End;

Procedure TfrmComDSRDemo.GetImportPackagesClick(Sender: TObject);
Var
  lpacks: Olevariant;
  lPack: TPack;
  i: Integer;
Begin
  fResult := fdsr.DSR_GetImportPackages(lpacks);

  If fResult <> 0 Then
    showmessage(inttostr(FResult));

  cbImports.Clear;
  cbImports.Items.BeginUpdate;

  For i := 0 To VarArrayDimCount(lPacks) - 1 Do
  Begin
    lPack := Tpack.Create;
    lPack.Id := lPacks[i][0];
    cbImports.Items.AddObject(lPacks[i][2], lPack);
  End;

  cbImports.Items.EndUpdate;
End;

Procedure TfrmComDSRDemo.btnDeleteOutboxClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If lv.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fResult := fdsr.DSR_DeleteOutboxMessage(1,
      StringToGUID(lv.Selected.SubItems[1]));

  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;

  End;
End;

Procedure TfrmComDSRDemo.FormCreate(Sender: TObject);
Begin
  fdsr := CoDSRSERVER.Create As idsrserver;

  btnLoadCompaniesClick(Sender);
End;

Procedure TfrmComDSRDemo.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  If fDsr <> Nil Then
    fDsr := Nil;
End;

Procedure TfrmComDSRDemo.btnSetDayScheduleClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  If cbExports.Text <> '' Then
  Begin
    fResult := S_OK;

    fResult := fdsr.DSR_SetDailySchedule(_CreateGuid, lComp, 'schedule', 'vmoura@exchequer.com',
      'redbaron@exchequer.com', '01/2006', '01/2007',
      Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id, Date, IncYear(Now,
      1), IncMinute(time, 2), 1, 0, 0);

  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;
  End
  Else
    ShowMessage('Select a valid export package')
End;

Procedure TfrmComDSRDemo.btnWeeklyScheduleClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If cbExports.Text <> '' Then
  Begin
    fResult := S_OK;

{    fResult := fdsr.DSR_SetWeeklySchedule(
      1, 'Schedule', 'vmoura@iris.co.uk', 'vinicios.demoura@iris.co.uk', '', '',
      Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id,
      IncMinute(time, 2), IncMonth(Now, 2), 1, 1, 1, 0, 1, 0, 0, 0);
 }
  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;

  End
  Else
    ShowMessage('Select a valid export package')
End;

Procedure TfrmComDSRDemo.btnMonthlyScheduleClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If cbExports.Text <> '' Then
  Begin
    fResult := S_OK;

{    fResult :=
      fdsr.DSR_SetMonthlySchedule(
      1, 'Schedule', 'vmoura@iris.co.uk', 'vinicios.demoura@iris.co.uk', '', '',
      Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id,
      IncMinute(time, 2), IncMonth(Now, 4), 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1);
 }
  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;

  End
  Else
    ShowMessage('Select a valid export package')
End;

Procedure TfrmComDSRDemo.btnOneTimeOnlyClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If cbExports.Text <> '' Then
  Begin
    fResult := S_OK;

{    fResult :=
      fdsr.DSR_SetOnTimeOnlySchedule(
      1, 'Schedule', 'vmoura@iris.co.uk', 'vinicios.demoura@iris.co.uk', '', '',
      Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id,
      Date, IncMinute(time, 2));
 }
  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;

  End
  Else
    ShowMessage('Select a valid export package')
End;

Procedure TfrmComDSRDemo.btnDeleteScheduleClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If lv.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fResult := fdsr.DSR_DeleteSchedule(StringToGUID(lv.Selected.SubItems[1]));

  // get the error message if something got wrong...
    If fResult = 0 Then
      ShowMessage(' ok ')
    Else
    Begin
      lMsg := fdsr.DSR_TranslateErrorCode(fResult);
      ShowMessage(lMsg);
    End;

  End;
End;

Procedure TfrmComDSRDemo.btnBulkClick(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fResult := S_OK;
  fResult := fDsr.DSR_BulkExport(lComp, 'Export bulk', edtfrom.text,
    edtTo.Text, edtPeriod1.Text, edtPeriod2.Text);

  // get the error message if something got wrong...
//  If fResult = 0 Then
//    ShowMessage(' ok ')
//  Else
 // Begin
//    lMsg := fdsr.DSR_TranslateErrorCode(fResult);
//    ShowMessage(lMsg);
//  End;
End;

Procedure TfrmComDSRDemo.btnCreateCompanyClick(Sender: TObject);
Var
  lMsg: String;
Begin
  fResult := S_OK;
  fResult := fDsr.DSR_CreateCompany(edtCompany.Text, edtCode.Text);

  If fResult = 0 Then
    ShowMessage(' ok ')
  Else
  Begin
    lMsg := fdsr.DSR_TranslateErrorCode(fResult);
    ShowMessage(lMsg);
  End;
End;

Procedure TfrmComDSRDemo.btnLoadCompaniesClick(Sender: TObject);
Var
  lOut: OleVariant;
  lTotal, lCont: Integer;
Begin
  cbCompanies.Clear;
  lTotal := 0;

  fDsr.DSR_GetCompanies(lOut);

  If Not VarIsNull(lOut) And Not VarIsEmpty(lOut) Then
    lTotal := VarArrayHighBound(lOut, VarArrayDimCount(lOut));

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
      cbCompanies.Items.Add(inttostr(lOut[lCont][0]) + ',' +
        Trim(lOut[lCont][2]));

//  If cbCompanies.Items.Count > 0 Then
//    cbCompanies.ItemIndex := 0;
End;

Procedure TfrmComDSRDemo.btnSyncClick(Sender: TObject);
Var
  lres: longword;
  lResult: widestring;
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  lRes := fdsr.DSR_Sync(lComp, 'Dripfeed ' + datetimetostr(now),
    edtFrom.text,
    edtTo.text,
    edtPeriod1.Text,
    edtPeriod2.Text,
    Tpack(cbExports.Items.Objects[cbExports.ItemIndex]).Id);

  If lres <> 0 Then
  Begin
    lResult := fdsr.DSR_TranslateErrorCode(lRes);
    showmessage(lResult);
  End;
End;

Procedure TfrmComDSRDemo.btnRebuildClick(Sender: TObject);
Var
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_ReCreateCompany(lComp);
End;

Procedure TfrmComDSRDemo.btnCheckDripFeedClick(Sender: TObject);
Var
  lStatus,
    lComp: Longword;

Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_CheckDripFeed(lComp, lStatus);

  If lStatus = S_ok Then
    ShowMessage('in Dripfeed')
  Else
    ShowMessage('not in Dripfeed')
End;

Procedure TfrmComDSRDemo.btnRemovedripFeedClick(Sender: TObject);
Var
  lStatus,
    lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  lStatus := fDsr.DSR_RemoveDripFeed(lComp, edtFrom.Text, edtTo.Text,
    'Remove Sync');

  If lStatus = S_ok Then
    ShowMessage('in Dripfeed')
  Else
    ShowMessage('not in Dripfeed')
End;

Procedure TfrmComDSRDemo.btnCheckCompaniesClick(Sender: TObject);
Begin
  fDsr.DSR_CheckCompanies;
End;

Procedure TfrmComDSRDemo.btnCheckMailsClick(Sender: TObject);
Begin
  fDsr.DSR_CheckMailNow;
End;

Procedure TfrmComDSRDemo.btnGetDsrSettingsClick(Sender: TObject);
Begin
  fDsr.DSR_GetDsrSettings(fXmlSettings);
End;

Procedure TfrmComDSRDemo.btnSetDsrSettingsClick(Sender: TObject);
Begin
  If fXmlSettings <> '' Then
    fDsr.DSR_UpdateDSRSettings(fXmlSettings);
End;

Procedure TfrmComDSRDemo.btnSyncRequestClick(Sender: TObject);
Var
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_SyncRequest(lComp, 'Sync Request from ' + cbCompanies.Text,
    edtFrom.text,
    edtTo.text,
    edtPeriod1.Text,
    edtPeriod2.Text);
End;

Procedure TfrmComDSRDemo.Button1Click(Sender: TObject);
Begin
  msPOP1.Login;
End;

Procedure TfrmComDSRDemo.Button3Click(Sender: TObject);
Begin
  msPOP1.Logout;
End;

Procedure TfrmComDSRDemo.btnLastAuditDateClick(Sender: TObject);
Var
  lComp: Longword;
  lp1, lp2: widestring;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_GetDripFeedParams(lComp, lp1, lp2);

  Showmessage('Period/year 1: ' + lp1 + #13 + #10 + 'Period/year 2: ' + lp2);
End;

Procedure TfrmComDSRDemo.btnAliveClick(Sender: TObject);
Begin
  fDsr.DSR_Alive;
End;

Procedure TfrmComDSRDemo.Button5Click(Sender: TObject);
Var
  lComp: Longword;
  lp1, lp2: widestring;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_GetDripFeedParams(lComp, lp1, lp2);

  showmessage(lp1 + ' ' + lp2);
End;

procedure TfrmComDSRDemo.btnActivateCompanyClick(Sender: TObject);
Var
  lComp: Longword;
  lp1, lp2: widestring;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_ActivateCompany(lComp);
end;

procedure TfrmComDSRDemo.btnProductTypeClick(Sender: TObject);
var
  lPro: Longword;
begin
  lPro := fDsr.DSR_ExProductType;

  showmessage(inttostr(lPro));
end;

procedure TfrmComDSRDemo.btnBulkExportClick(Sender: TObject);
Var
  lres: longword;
  lResult: widestring;
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  lRes := fdsr.DSR_BulkExport(lComp, 'Bulk Test ' + datetimetostr(now),
    edtFrom.text,
    edtTo.text,
    edtPeriod1.Text,
    edtPeriod2.Text);

  If lres <> 0 Then
  Begin
    lResult := fdsr.DSR_TranslateErrorCode(lRes);
    showmessage(lResult);
  End;
end;

procedure TfrmComDSRDemo.Button6Click(Sender: TObject);
Var
  lComp: Longword;
  lp1, lp2: widestring;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_GetExPeriodYear(lComp, lp1, lp2);

  showmessage(lp1 + ' ' + lp2);
end;

procedure TfrmComDSRDemo.btnSyncDenyClick(Sender: TObject);
begin
  fDSR.DSR_DenySyncRequest(0, StringToGUID(edtGuid.Text))
end;

procedure TfrmComDSRDemo.btnRecreateCompanyClick(Sender: TObject);
Var
  lComp: Longword;
Begin
  lComp := StrToIntDef(copy(cbCompanies.Items[cbCompanies.ItemIndex], 1,
    Pos(',', cbCompanies.Items[cbCompanies.ItemIndex]) - 1), 0);

  fDsr.DSR_ReCreateCompany(lComp);
end;

procedure TfrmComDSRDemo.Button7Click(Sender: TObject);
Var
  // declare a result variable
  lMsg: String;
Begin
  If lv.Selected <> Nil Then
  Begin
    fResult := S_OK;

    fResult := fdsr.DSR_RestoreMessage(StringToGUID(lv.Selected.SubItems[1]));
  End;
end;

End.

