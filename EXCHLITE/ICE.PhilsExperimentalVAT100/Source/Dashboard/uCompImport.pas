{-----------------------------------------------------------------------------
 Unit Name: uCompImport
 Author:    vmoura
 Purpose:
 History:

 import to a specific company
-----------------------------------------------------------------------------}
Unit uCompImport;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAdoDsr, uCommon, uConsts, uDSR, StdCtrls, ExtCtrls, AdvPanel,
  uInterfaces, AdvGlowButton,

  ufrmbase
  ;

const
  cINFO = '%s Company Data Import';

Type
  //TfrmCompImport = Class(TForm)
  TfrmCompImport = Class(TFrmbase)
    advPanelMail: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    cbCompany: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label3: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnOkClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
  Private
    fDb: TADODSR;
    fMailInfo: TMessageInfo;
    Procedure LoadCompanies;

  Published
    Property MailInfo: TMessageInfo Read fMailInfo Write fMailInfo;
  End;

Var
  frmCompImport: TfrmCompImport;

Implementation

Uses uDashSettings, strutils, uDashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompImport.FormCreate(Sender: TObject);
Begin
  Inherited;
  
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On E: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End;
  End; {try}

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);

  btnOk.Enabled := Assigned(fDb) And fDb.Connected;

  fMailInfo := TMessageInfo.Create;

  If Assigned(fDb) Then
    LoadCompanies;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompImport.FormDestroy(Sender: TObject);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);

  If Assigned(fMailInfo) Then
    FreeAndNil(fMailInfo);

  Inherited;  
End;

{-----------------------------------------------------------------------------
  Procedure: btnOkClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompImport.btnOkClick(Sender: TObject);
Var
  lResult: Longword;
  lCompId: Longword;
Begin
  Try
    lCompId := TCompany(cbCompany.Items.Objects[cbCompany.ItemIndex]).Id;
  Except
    lCompId := 0;
  End;

  If lCompId > 0 Then
  Begin
(*    If MessageDlg('Are you sure you want to import this dataset to ' +
      cbCompany.Text + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to import this dataset to ' +
      cbCompany.Text + '?', mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      lResult := TDSR.DSR_Import(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lCompId,
        fMailInfo.Guid,
        fMailInfo.Pack_Id
        );

      Application.ProcessMessages;

      If lResult <> S_Ok Then
(*        MessageDlg('An error has occurred. Error number: ' +
          inttostr(lResult), mtError, [mbok], 0)*)
        ShowDashboardDialog('An error has occurred. Error number: ' +
          inttostr(lResult), mtError, [mbok])
      Else
      Begin
        ModalResult := mrOk;
      //Close;
      End; {begin}
    End; {messagedlg}
  End; {If lCompId > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompImport.LoadCompanies;
Var
  lCompanies: OleVariant;
  lCont: Integer;
  lTotal: integer;
  lComp: TCompany;
Begin
  cbCompany.Clear;

  lCompanies := null;
  lCompanies := fDB.GetCompanies(IfThen(glISVAO, _GetEnterpriseSystemDir, ''));
  lTotal := _GetOlevariantArraySize(lCompanies);

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
      With cbCompany Do
      Begin
        lComp := _CreateCompanyObj(lCompanies[lCont]);
        If (lComp <> Nil) And lComp.Active Then
          AddItem(lComp.ExCode + ' - ' + lComp.Desc, lComp);
      End; {With lvComp.Items.Add Do}

  If cbCompany.Items.Count > 0 Then
    cbCompany.ItemIndex := 0;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCompImport.btnCancelClick(Sender: TObject);
Var
  lComp: TCompany;
  lCont: Integer;
Begin
  If cbCompany.Items.Count > 0 Then
  Try
    {free memory elements}
    For lCont := 0 To cbCompany.Items.Count - 1 Do
      If cbCompany.Items.Objects[lCont] <> Nil Then
        If cbCompany.Items.Objects[lCont] Is TCompany Then
        Begin
          lComp := TCompany(cbCompany.Items.Objects[lCont]);
          If Assigned(lComp) Then
            FreeAndNil(lComp);
        End;
  Except
  End;

  Close;
End;

End.

