{-----------------------------------------------------------------------------
 Unit Name: uCompany
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCompany;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvPanel, ComCtrls, htmltv, uAdoDsr,
  AdvGlowButton, AdvListV,

  ufrmbase
  ;

const
  cINFO = '%s Add New Company';  

Type
  //TfrmCompanyManager = Class(TForm)
  TfrmCompanyManager = Class(TFrmbase)
    advPanelMail: TAdvPanel;
    Label1: TLabel;
    edtCompany: TEdit;
    btnAdd: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    lvComp: TAdvListView;
    edtCompCode: TEdit;
    Label2: TLabel;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label4: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnAddClick(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure edtCompCodeKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    fDB: TAdodsr;
    Procedure LoadCompanies;
  Public
  End;

Var
  frmCompanyManager: TfrmCompanyManager;

Implementation

Uses StrUtils,
  uDashGlobal, uDsr, uDashSettings, uCommon;

{$R *.dfm}

{ TfrmNewCompany }

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.LoadCompanies;
Var
  lCompanies: OleVariant;
  lCont: Integer;
  lTotal: integer;
Begin
  edtCompCode.Clear;
  edtCompany.Clear;

  lvComp.Items.Clear;
  lvComp.Items.BeginUpdate;

  lCompanies := null;
  If Assigned(fDB) Then
  Begin
    lCompanies := fDB.GetCompanies(IfThen(glIsVAO, _GetEnterpriseSystemDir, ''));
    lTotal := _GetOlevariantArraySize(lCompanies);

    If lTotal > 0 Then
      For lCont := 0 To lTotal - 1 Do
        With lvComp.Items.Add Do
        Begin
          Caption := lCompanies[lCont][1];
          SubItems.Add(lCompanies[lCont][2]);

          If Boolean(lCompanies[lCont][3]) Then
            SubItems.Add('True')
          Else
            SubItems.Add('False')
        End; {With lvComp.Items.Add Do}
  End; {if Assigned(fDB) then}

  lvComp.Items.EndUpdate;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.FormCreate(Sender: TObject);
Begin
  Inherited;
  
  Try
    fdb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database: ' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End;
  End;

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);

  LoadCompanies;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.FormDestroy(Sender: TObject);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);

  inherited;  
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.btnAddClick(Sender: TObject);
Var
  lResult: Longword;
  lTrans: String;
Begin
  If edtCompCode.Text = '' Then
  Begin
    //MessageDlg('Invalid company code!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Invalid company code!', mtInformation, [mbok]);

    edtCompCode.SetFocus;
    Abort;
  End;

  If edtCompany.Text = '' Then
  Begin
    //MessageDlg('Invalid company name!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Invalid company name!', mtInformation, [mbok]);
    Abort;
  End;

  If _InvalidCompCode(edtCompCode.Text) Then
  Begin
    //MessageDlg('The new company code must have some characters!', mtInformation, [mbok], 0);
    ShowDashboardDialog('The new company code must have some characters!', mtInformation, [mbok]);
    edtCompCode.SetFocus;
    Abort;
  End;

  lResult := TDSR.DSR_CreateCompany(
    _DashboardGetDSRServer,
    _DashboardGetDSRPort,
    edtCompany.Text,
    edtCompCode.Text);

  If lResult <> S_OK Then
  Begin
    lTrans := TDsr.DSR_TranslateErrorCode(_DashboardGetDSRServer,
      _DashboardGetDSRPort, lResult);

    If lTrans <> '' Then
(*      MessageDlg('An error has occurred creating the new company:' + #13#13 +
        lTrans, mtInformation, [mbok], 0);*)
      ShowDashboardDialog('An error has occurred creating the new company:' + #13#13 +
        lTrans, mtInformation, [mbok]);
  End; {If lResult <> S_OK Then}

  LoadCompanies;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCloseClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: edtCompCodeKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompanyManager.edtCompCodeKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = vk_return Then
  Begin
    Try
      {avoid enter when hit add button}
      Key := 0;
      If Sender Is TEdit Then
        If (Sender As TEdit).Text <> '' Then
          PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    Except
    End;
  End;
End;

End.
