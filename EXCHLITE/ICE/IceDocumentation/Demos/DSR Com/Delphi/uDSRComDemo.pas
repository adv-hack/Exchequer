{-----------------------------------------------------------------------------
 Unit Name: uComCallerDemo
 Author:
 Purpose: Example of DSR COM Object

-----------------------------------------------------------------------------}
Unit uDSRComDemo;

Interface

Uses
  // add the com caller and sync objects
  uDsr,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, Spin,

  uAddPackage
  ;

Const
  cCompany = 1;
  cMachine = 'P002957';
  cPort = 6505;

Type
  TPack = Class
  Private
    fId: Integer;
  Public
    Property Id: Integer Read fId Write fId;
  End;

  TfrmDSRCOM = Class(TForm)
    sbInfo: TStatusBar;
    btnActivateTimer: TButton;
    seTimer: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    tmMsg: TTimer;
    PcDemo: TPageControl;
    tbsOutBox: TTabSheet;
    tbsInbox: TTabSheet;
    tbsGGW: TTabSheet;
    lvOutbox: TListView;
    Label2: TLabel;
    btnExport: TButton;
    btnLoadOutboxMsgs: TButton;
    btnDeleteOutbox: TButton;
    btnImport: TButton;
    btnDeleteInbox: TButton;
    btnLoadInboxMsgs: TButton;
    Label1: TLabel;
    lvInbox: TListView;
    btnGGWSendPacket: TButton;
    btnGGWGetPending: TButton;
    btnGGWPreparePacket: TButton;
    btnGetExportPackages: TButton;
    cbExportPackages: TComboBox;
    Label15: TLabel;
    Label3: TLabel;
    cbImportPackages: TComboBox;
    btnGetImportPackages: TButton;
    btnAddImportPackage: TButton;
    btnDeleteImportPackage: TButton;
    btnAddExportPackage: TButton;
    btnDeleteExportPackage: TButton;
    Procedure btnExportClick(Sender: TObject);
    Procedure btnImportClick(Sender: TObject);
    Procedure btnDeleteInboxClick(Sender: TObject);
    Procedure btnDeleteOutboxClick(Sender: TObject);
    Procedure btnLoadInboxMsgsClick(Sender: TObject);
    Procedure btnLoadOutboxMsgsClick(Sender: TObject);
    Procedure btnGGWGetPendingClick(Sender: TObject);
    Procedure btnGGWSendPacketClick(Sender: TObject);
    Procedure btnGGWPreparePacketClick(Sender: TObject);
    Procedure btnActivateTimerClick(Sender: TObject);
    Procedure tmMsgTimer(Sender: TObject);
    Procedure btnGetExportPackagesClick(Sender: TObject);
    Procedure btnGetImportPackagesClick(Sender: TObject);
    Procedure btnDeleteExportPackageClick(Sender: TObject);
    Procedure btnDeleteImportPackageClick(Sender: TObject);
    Procedure btnAddImportPackageClick(Sender: TObject);
    Procedure btnAddExportPackageClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    fResult: Longword;

    // do something if a new inbox message arrives
    Procedure TranslateError(pResult: Longword);
  Public
  End;

Var
  frmDSRCOM: TfrmDSRCOM;

Implementation

{$R *.dfm}

Procedure TfrmDSRCOM.btnExportClick(Sender: TObject);
Var
  // declare a result variable
  lGuid: TGuid;
  lMsgBody: WideString;
Begin
  If cbExportPackages.Text <> '' Then
  Begin
    fResult := S_OK;
  // create a new GUID to be used as a key reference
    FillChar(lGuid, sizeof(TGuid), 0);
    lMsgBody := 'Test at ' + DateTimeToStr(Now);

  // call com caller export function...
    fResult := TDSR.DSR_Export(cMachine,
      cPort,
      cCompany,
      lGuid,
      'Export Customers',
      'vmoura@ice_mail.com',
      'dsrmail@ice_mail.com',
      lMsgBody,
      '0',
      '01/10/2005',
      TPack(cbExportPackages.Items.Objects[cbExportPackages.ItemIndex]).Id);

  // get the error message if something got wrong...
    TranslateError(fResult);
  End
  Else
    ShowMessage('Select a valid Export Package');
End;

Procedure TfrmDSRCOM.btnImportClick(Sender: TObject);
Begin
  If cbImportPackages.Text <> '' Then
  Begin
    If lvInbox.Selected <> Nil Then
    Begin
      fResult := S_OK;
  // call com caller import function
      fResult := TDSR.DSR_Import(cMachine,
        cPort,
        cCompany,
        StringToGUID(lvInbox.Selected.SubItems[2]),
        TPack(cbImportPackages.Items.Objects[cbImportPackages.ItemIndex]).Id);

  // get the error message if something got wrong...
      If fResult = S_OK Then
        ShowMessage('Sucess!')
      Else
        TranslateError(fResult);
    End; // if assigned and <> nil
  End
  Else
    ShowMessage('Select a valid Import Package');
End;

Procedure TfrmDSRCOM.btnDeleteInboxClick(Sender: TObject);
Begin
  If lvInbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete inbox
    fResult := TDSR.DSR_DeleteInboxMessage(cMachine,
      cPort,
      cCompany,
      StringToGUID(lvInbox.Selected.Caption));

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateError(fResult)
    Else
      btnLoadInboxMsgsClick(Sender);
  End; // if assigned and <> nil
End;

Procedure TfrmDSRCOM.btnDeleteOutboxClick(Sender: TObject);
Begin
  If lvOutbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fResult := TDSR.DSR_DeleteOutboxMessage(cMachine,
      cPort,
      cCompany,
      StringToGUID(lvOutbox.Selected.SubItems[2]));

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateError(fResult)
    Else
      btnLoadOutboxMsgsClick(Sender);
  End; // if assigned and <> nil
End;

Procedure TfrmDSRCOM.btnLoadInboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  lIn: OleVariant;
  I: Longword;
Begin
  fResult := S_OK;
  lvInbox.Clear;

  // call com caller delete outbox

  fResult := TDSR.DSR_GetInboxMessages(cMachine,
    cPort,
    cCompany,
    1,
    -1,
    0,
    50,
    lIn);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
      // update the inbox list
    lvInbox.Items.BeginUpdate;

    For i := 0 To VarArrayHighBound(lIn, VarArrayDimCount(lIn)) - 1 Do
    Begin
      With lvInbox.Items.Add Do
      Begin
        Caption := lIn[i][2];
        SubItems.Add(lIn[i][3]);
        SubItems.Add(datetimetostr(lIn[i][9]));
        SubItems.Add(lIn[i][0]);
      End;
    End;
{
        fieldbyname('guid').asString,
          fieldbyname('company_id').Asinteger,
          fieldbyname('subject').AsString,
          fieldbyname('userfrom').AsString,
          fieldbyname('userto').AsString,
          fieldbyname('msgbody').AsString,
          FieldByName('package_id').AsInteger,
          FieldByName('status').AsInteger,
          FieldByName('totalitems').AsInteger,
          FieldByName('received').AsDateTime

}
    lvInbox.Items.EndUpdate;
  End;
End;

Procedure TfrmDSRCOM.btnLoadOutboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  lOut: OleVariant;
  i: Longword;
Begin
  fResult := S_OK;
  lvOutbox.Clear;

  // call com caller delete outbox

  fResult := TDSR.DSR_GetOutboxMessages('P002957', cPort, cCompany, 0, -1, 0,
    50, lOut);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
      // update the outbox list and test the olevariant type
    lvOutbox.Items.BeginUpdate;

    For i := 0 To VarArrayHighBound(lOut, VarArrayDimCount(lout)) - 1 Do
    Begin
      With lvOutbox.Items.Add Do
      Begin
        Caption := lout[i][2];
        SubItems.Add(lout[i][4]);
        SubItems.Add(datetimetostr(lout[i][12]));
        SubItems.Add(lout[i][0]);
      End;
    End;

    lvOutbox.Items.EndUpdate;
  End;

End;

Procedure TfrmDSRCOM.btnGGWGetPendingClick(Sender: TObject);
Var
  // the result array of guids
  lout: OleVariant;
  I: Longword;
Begin
  fResult := S_OK;
  lvOutbox.Clear;

  // call com caller delete outbox
  fResult := TDSR.DSR_GGW_GetPending(cMachine, cPort, cCompany, 0, 50, lout);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
    // update the outbox list
    lvOutbox.Items.BeginUpdate;

    For i := 0 To VarArrayHighBound(lOut, VarArrayDimCount(lout)) - 1 Do
    Begin
      With lvOutbox.Items.Add Do
      Begin
        Caption := lout[i][2];
        SubItems.Add(lout[i][4]);
        SubItems.Add(datetimetostr(lout[i][12]));
        SubItems.Add(lout[i][0]);
      End;
    End;

    lvOutbox.Items.EndUpdate;
  End;
End;

Procedure TfrmDSRCOM.btnGGWSendPacketClick(Sender: TObject);
Begin
  // get the guid that should be sent...
  If lvOutbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

    // get the irmark to this message first and then send...
    fResult := TDSR.DSR_GGW_SendPacket(cMachine,
      cPort,
      cCompany,
      StringToGUID(lvOutbox.Selected.Caption),
      '');

  // get the error message if something got wrong...
    TranslateError(fResult);
  End; // <> nil
End;

Procedure TfrmDSRCOM.btnGGWPreparePacketClick(Sender: TObject);
Var
  lGuid: TGuid;
Begin
  fResult := S_OK;
  FillChar(lGuid, Sizeof(TGuid), 0);

  fResult := TDSR.DSR_GGW_PreparePacket(cMachine,
    cPort,
    cCompany,
    lGuid,
    'GGW Message',
    'mycompany@mycompany.com',
    'ggwmail@ggw.gov.uk',
    '',
    1,
    1,
    'c:\taxreturns\tax2005.xml',
    'c:\taxreturns\tax2005.xsl',
    '');

  // get the error message if something got wrong...
  TranslateError(fResult);
End;

Procedure TfrmDSRCOM.btnActivateTimerClick(Sender: TObject);
Begin
  If btnActivateTimer.Caption = 'Enable Timer' Then
  Begin
    tmMsg.Enabled := False;
    tmMsg.Interval := seTimer.Value * 60 * 1000;
    tmMsg.Enabled := True;
    btnActivateTimer.Caption := 'Disable Timer';
  End
  Else
  Begin
    tmMsg.Enabled := False;
    btnActivateTimer.Caption := 'Enable Timer';
  End;
End;

Procedure TfrmDSRCOM.TranslateError(pResult: Longword);
Var
  lTranslation: WideString;
Begin
  If pResult <> S_OK Then
  Begin
    lTranslation := TDSR.DSR_TranslateErrorCode(cMachine, cPort, pResult);
    ShowMessage(lTranslation);
  End;
End;

Procedure TfrmDSRCOM.tmMsgTimer(Sender: TObject);
Var
  lNewMsg: Longword;
  lIn: OleVariant;
  I: Longword;
Begin
  tmMsg.Enabled := False;

  fResult := TDSR.DSR_NewInboxMessage(cMachine, cPort, 10, lIn);

  If (fResult = S_OK) And Not VarIsNull(lIn) Then
  Begin
    lvInbox.Clear;

    lvInbox.Items.BeginUpdate;

    For i := 0 To VarArrayHighBound(lIn, VarArrayDimCount(lIn)) - 1 Do
    Begin
      With lvInbox.Items.Add Do
      Begin
        Caption := lIn[i][2];
        SubItems.Add(lIn[i][3]);
        SubItems.Add(datetimetostr(lIn[i][9]));
        SubItems.Add(lIn[i][0]);
      End;
    End;

    lvInbox.Items.EndUpdate;

  End; // result = 0 and lcount > 0

  fResult := TDSR.DSR_TotalOutboxMessages(cMachine, cPort, cCompany, lNewMsg);

  If lNewMsg <> lvOutbox.Items.Count Then
  Begin
    btnLoadOutboxMsgsClick(Sender);
    sbInfo.Panels[1].Text := ' Outbox Total: ' + inttostr(lNewMsg);
  End;

  tmMsg.Enabled := True;
End;

Procedure TfrmDSRCOM.btnGetExportPackagesClick(Sender: TObject);
Var
  lPacks: OleVariant;
  lPack: TPack;
  i: Integer;
Begin
  fResult := TDSR.DSR_GetExportPackages(cMachine, cPort, lPacks);

  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
    cbExportPackages.Clear;
    cbExportPackages.Items.BeginUpdate;

    If VarIsArray(lPacks) Then
    Begin
      For i := 0 To VarArrayHighBound(lPacks, VarArrayDimCount(lPacks)) - 1 Do
      Begin
        lPack := TPack.Create;
        lPack.Id := lPacks[i][0];
        cbExportPackages.Items.AddObject(lPacks[i][2], lPack);
      End;
    End;

    cbExportPackages.Items.EndUpdate;
//    lpacks := Nil;
  End;
End;

Procedure TfrmDSRCOM.btnGetImportPackagesClick(Sender: TObject);
Var
  lpacks: OleVariant;
  lPack: TPack;
  i: Integer;
Begin
  fResult := TDSR.DSR_GetImportPackages(cMachine, cPort, lPacks);

  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
    cbImportPackages.Items.Clear;
    cbImportPackages.Items.BeginUpdate;

    If VarIsArray(lPacks) Then
      For i := 0 To VarArrayHighBound(lPacks, VarArrayDimCount(lPacks)) - 1 Do
      Begin
        lPack := TPack.Create;
        lPack.Id := lPacks[i][0];
        cbImportPackages.Items.AddObject(lPacks[i][2], lPack);
      End;

    cbImportPackages.Items.EndUpdate;
  End;
end;

Procedure TfrmDSRCOM.btnDeleteExportPackageClick(Sender: TObject);
Begin
  If cbExportPackages.Text <> '' Then
  Begin
    fResult := TDSR.DSR_DeleteExportPackage(cMachine,
      cPort,
      TPack(cbExportPackages.Items.Objects[cbExportPackages.ItemIndex]).Id);

    If fResult <> 0 Then
      TranslateError(fResult)
    Else
      btnGetExportPackagesClick(Sender);
  End;
End;

Procedure TfrmDSRCOM.btnDeleteImportPackageClick(Sender: TObject);
Begin
  If cbImportPackages.Text <> '' Then
  Begin
    fResult := TDSR.DSR_DeleteImportPackage(cMachine,
      cPort,
      TPack(cbImportPackages.Items.Objects[cbImportPackages.ItemIndex]).Id);

    If fResult <> 0 Then
      TranslateError(fResult)
    Else
      btnGetImportPackagesClick(Sender);
  End;
End;

Procedure TfrmDSRCOM.btnAddImportPackageClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAddPackage, frmAddPackage);

  With frmAddPackage Do
  Begin
    If ShowModal = mrOK Then
    Begin
      fResult := TDSR.DSR_SetImportPackage(cMachine,
        cPort,
        edtDescription.Text,
        StringToGUID(edtFileGuid.TExt),
        edtXml.Text,
        edtXSL.Text,
        edtXSD.Text,
        strtoint(edtUserReference.Text));

      If fResult <> S_Ok Then
        TranslateError(fResult);
    End;

    Free;
  End;
End;

Procedure TfrmDSRCOM.btnAddExportPackageClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAddPackage, frmAddPackage);

  With frmAddPackage Do
  Begin
    If ShowModal = mrOK Then
    Begin
      fResult := TDSR.DSR_SetExportPackage(cMachine,
        cPort,
        edtDescription.Text,
        StringToGUID(edtFileGuid.TExt),
        edtXml.Text,
        edtXSL.Text,
        edtXSD.Text,
        strtoint(edtUserReference.Text));

      If fResult <> S_Ok Then
        TranslateError(fResult);
    End;

    Free;
  End;
End;

Procedure TfrmDSRCOM.FormCreate(Sender: TObject);
Begin
  PcDemo.ActivePageIndex := 0;
End;

End.

