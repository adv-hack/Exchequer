{-----------------------------------------------------------------------------
 Unit Name: uExportFrame
 Author:    vmoura
 Purpose:
 History:

 
-----------------------------------------------------------------------------}
Unit uExportFrame;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Variants, AdvMenus, AdvMenuStylers, AdvToolBar,
  AdvToolBarStylers, Menus, ActnList, ComCtrls, StdCtrls, AdvEdit,
  AdvPanel,

  uAdoDsr, uInterfaces, Mask, TEditVal, AdvGlowButton
  ;

Type
  TfrmExportFrame = Class(TFrame)
    advPanel: TAdvPanel;
    advMail: TAdvPanel;
    lblSubject: TLabel;
    advTo: TAdvEdit;
    advSubject: TAdvEdit;
    lblCompany: TLabel;
    cbCompanies: TComboBox;
    lblJob: TLabel;
    cbJobs: TComboBox;
    alExport: TActionList;
    actSend: TAction;
    actCancel: TAction;
    advDockdashTop: TAdvDockPanel;
    advToolMenu: TAdvToolBar;
    advMainMenu: TAdvMainMenu;
    File1: TMenuItem;
    AdvToolBarOfficeStyler: TAdvToolBarOfficeStyler;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    Send1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    lblStartPeriod: TLabel;
    lblEndPeriod: TLabel;
    lblPeriodOfData: TLabel;
    actAddressBook: TAction;
    edtStartPeriod: TEditPeriod;
    edtEndPeriod: TEditPeriod;
    btnSend: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    o1: TMenuItem;
    btnTo: TAdvGlowButton;
    lblSending: TLabel;
    Procedure advToLookupSelect(Sender: TObject; Var Value: String);
    Procedure advToChange(Sender: TObject);
    Procedure cbCompaniesChange(Sender: TObject);
    Procedure actSendExecute(Sender: TObject);
    Procedure actAddressBookExecute(Sender: TObject);
    Procedure edtStartPeriodKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure cbCompaniesKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    fDripfeedRequest: Boolean;
    fBulkExport: Boolean;
    fParamYear1: String;
    fParamYear2: String;
    fSubContractorVerification: Boolean;
    Procedure LoadAddressBook;
    Procedure LoadCompanies;
    Procedure SetDripfeedRequest(Const Value: Boolean);
    Procedure SetBulkExport(Const Value: Boolean);
    procedure SetSubContractorVerification(const Value: Boolean);
  Protected
    fDB: TADODSR;
    Procedure LoadExportPackages(Const pCompany: Longword = 0); Virtual;
  Public
    Procedure ClearComboBoxes;
    Procedure ClearCompanies;
    Procedure ClearJobs;
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SelectCompany(Const pExCode: String): Boolean; Overload;
    Function SelectCompany(pId: Integer): Boolean; Overload;
    Procedure SetExportDetails(pMsg: TMessageInfo; Const pSubj: String = '';
      Const pParamYear1: String = ''; Const pParamYear2: String = '');
    Function ValidatePeriod(pCompany: Integer): Boolean;
    Function SelectDripFeed: Boolean;
    Procedure HidePeriods;
    Procedure ValidateFields;
    property DB: TADODSR read fDB;
  Published
    Property DripfeedRequest: Boolean Read fDripfeedRequest Write SetDripfeedRequest Default
      False;
    Property BulkExport: Boolean Read fBulkExport Write SetBulkExport Default
      False;
    property SubContractorVerification: Boolean read fSubContractorVerification write SetSubContractorVerification Default False;   
    Property ParamYear1: String Read fParamYear1 Write fParamYear1;
    Property ParamYear2: String Read fParamYear2 Write fParamYear2;
  End;

Implementation

Uses StrUtils,
  uDashGlobal, uDashSettings, Dateutils, uAddressBook, uconsts, uCommon, uDSR;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: advToLookupSelect
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.advToLookupSelect(Sender: TObject;
  Var Value: String);
Begin
  {remove texts bigger than 255 characters}
  If advTo.Text <> '' Then
    If (Length(advTo.Text) + Length(Value)) > 255 Then
      Value := '';
End;

{-----------------------------------------------------------------------------
  Procedure: advToChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.advToChange(Sender: TObject);
Var
  lText: String;
Begin
  Try
    If advTo.Text <> '' Then
    {avoid a sequence of ";;" at the end of the edit}
      If ((advTo.Text[Length(advTo.Text)] = ';') And
        (advTo.Text[Length(advTo.Text) - 1] = ';')) Then
      Begin
        lText := advTo.Text;
        Delete(lText, Length(lText), 1);
        advTo.Text := lText;
        advTo.SelStart := Length(lText);
        advTo.SelLength := 0;
      End;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetDripfeedRequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.SetDripfeedRequest(Const Value: Boolean);
Begin
  fDripfeedRequest := Value;

  If fDripfeedRequest Then
  Begin
    If cbJobs.Items.Count > 0 Then
      cbJobs.Items.Insert(0, cDRIPFEEDREQUEST)
    Else
      cbJobs.Items.Add(cDRIPFEEDREQUEST);
    cbJobs.ItemIndex := 0;
    cbJobs.Enabled := False;
  End; {If fDripffedRequest Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmExportFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  lblSending.Visible := False;

  Try
    fDB := TADODSR.Create(_DashboardGetDBServer);
  Except
    On E: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End;
  End; {try}

  LoadAddressBook;
  LoadCompanies;
  LoadExportPackages;

  Try
    edtStartPeriod.Text := _FormatPeriod(1, Now);
    edtEndPeriod.Text := _FormatPeriod(12, Now);

    edtStartPeriod.RefreshValues;
    edtEndPeriod.RefreshValues;
  Except
  End;

//  edtEndDate.Enabled := False;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmExportFrame.Destroy;
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadAddressBook
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.LoadAddressBook;
Var
  lAddress: Olevariant;
  lCont,
    lTotal: Integer;
Begin
  If Assigned(fDB) Then
  Begin
    lAddress := fDB.GetContacts;
    lTotal := _GetOlevariantArraySize(lAddress);
    If lTotal > 0 Then
    Begin
      With advTo.Lookup Do
      Begin
        DisplayList.Clear;
        ValueList.Clear;
        For lCont := 0 To lTotal - 1 Do
        Try
          DisplayList.Add(lAddress[lCont][0]);
          ValueList.Add(lAddress[lCont][1]);
        Except
        End; {For lCont := 0 To lTotal - 1 Do}
      End; {With frmExportFrame.advTo.Lookup Do}
    End; {If lTotal > 0 Then}
  End; {If Assigned(fDB) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadExportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.LoadExportPackages(Const pCompany: Longword = 0);
Var
  lPacks: OleVariant;
  lCont, lTotal: Integer;
  lExp: TPackageInfo;
Begin
  If Not fDripfeedRequest Then
  Begin
    If Assigned(fDB) Then
    Begin
      ClearJobs;
      lPacks := fdb.GetExportPackages;
      lTotal := _GetOlevariantArraySize(lPacks);

      If lTotal > 0 Then
      Begin
        For lCont := 0 To lTotal - 1 Do
        Begin
          lExp := _CreateExportPackage(lPacks[lCont]);
          If lExp <> Nil Then
          Begin
//        If lExp.Company_Id = pCompany Then
            cbJobs.AddItem(lExp.Description, lExp)
//        Else
//          FreeAndNil(lExp);
          End; {If lExp <> Nil Then}
        End; {for lCont := 0 to lTotal - 1 do}
      End; {if lTotal > 0 then}
    End; {If Assigned(fDB) Then}
  End; {If Not fDripffedRequest Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.LoadCompanies;
Var
  lCompanies: OleVariant;
  lCont: Integer;
  lTotal: integer;
  lComp: TCompany;
Begin
  If Assigned(fDB) Then
  Begin
    cbCompanies.Clear;
    lCompanies := fDb.GetCompanies(IfThen(glIsVAO, _GetEnterpriseSystemDir, ''));
    lTotal := _GetOlevariantArraySize(lCompanies);

    If lTotal > 0 Then
    Begin
      For lCont := 0 To lTotal - 1 Do
      Begin
        lComp := _CreateCompanyObj(lCompanies[lCont]);
        If lComp <> Nil Then
          If lComp.Active Then
            cbCompanies.AddItem(lComp.ExCode + ' - ' + lComp.Desc, lComp);
      End; { for}
    End; { if varisnull}
  End; {If Assigned(fDB) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ClearComboBoxes
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.ClearComboBoxes;
Begin
  ClearCompanies;
  ClearJobs;
End;

{-----------------------------------------------------------------------------
  Procedure: ClearCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.ClearCompanies;
Var
  lCont: Integer;
  lComp: TCompany;
Begin
  If Assigned(cbCompanies) Then
  {remove company objects from the combobox}
    If cbCompanies.Items.Count > 0 Then
    Try
      For lCont := cbCompanies.Items.Count - 1 Downto 0 Do
      Try
        If cbCompanies.Items.Objects[lCont] <> Nil Then
        Begin
          lComp := TCompany(cbCompanies.Items.Objects[lCont]);
          FreeAndNil(lComp);
          cbCompanies.Items.Delete(lCont);
        End; {If cbCompany.Items.Objects[lCont] <> Nil Then}
      Except
      End; {For lCont := cbCompany.Items.Count - 1 Downto 0 Do}
    Finally
      cbCompanies.Clear;
    End; {if cbCompany.Items.Count > 0 then}
End;

{-----------------------------------------------------------------------------
  Procedure: ClearJobs
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.ClearJobs;
Var
  lCont: Integer;
  lExp: TPackageInfo;
Begin
  {remove job details from the combobox}
  If cbJobs.Items.Count > 0 Then
  Try
    For lCont := cbJobs.Items.Count - 1 Downto 0 Do
    Try
      If cbJobs.Items.Objects[lCont] <> Nil Then
      Begin
        lExp := TPackageInfo(cbJobs.Items.Objects[lCont]);
        FreeAndNil(lExp);
        cbJobs.Items.Delete(lCont);
      End; {If frmExportFrame.cbJobs.Items.Objects[lCont] <> Nil Then}
    Except
    End; {For lCont := frmExportFrame.cbJobs.Items.Count - 1 Downto 0 Do}
  Finally
    cbJobs.Clear;
  End; {If frmExportFrame.cbJobs.Items.Count > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: cbCompaniesChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.cbCompaniesChange(Sender: TObject);
Begin
(*
  If (cbCompanies.Text <> '') And Not fBulk Then
    With cbCompanies Do
    Try
      If Items.Objects[ItemIndex] <> Nil Then
        If Items.Objects[ItemIndex] Is TCompany Then
          LoadExportPackages(TCompany(Items.Objects[ItemIndex]).Id)
    Except
    End;
    *)

End;

{-----------------------------------------------------------------------------
  Procedure: actSendExecute
  Author:    vmoura

  check the basic entry values before sending a message
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.actSendExecute(Sender: TObject);
Begin
  ValidateFields;
End;

{-----------------------------------------------------------------------------
  Procedure: actAddressBookExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.actAddressBookExecute(Sender: TObject);
Begin
  Application.CreateForm(TfrmAddressBook, frmAddressBook);

  With frmAddressBook Do
  Begin
    SelectionMade := True;
    If ShowModal = mrOk Then
    Begin
      Try
        advTo.Text := lvAddress.Selected.SubItems[0];
      Finally
        LoadAddressBook;
      End;
    End; {if ShowModal = mrOk then}

    Free;
  End; {with frmAddressBook do}
End;

{-----------------------------------------------------------------------------
  Procedure: SelectCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmExportFrame.SelectCompany(Const pExCode: String): Boolean;
Var
  lCont: Integer;
Begin
  Result := False;
  For lCont := 0 To cbCompanies.Items.Count - 1 Do
    If cbCompanies.Items.Objects[lCont] <> Nil Then
      If Lowercase(TCompany(cbCompanies.Items.Objects[lCont]).ExCode) =
        lowercase(pExCode) Then
      Begin
        Result := True;
        cbCompanies.ItemIndex := lCont;

        edtStartPeriod.PeriodsInYear :=
          TCompany(cbCompanies.Items.Objects[lCont]).Periods;
        edtEndPeriod.PeriodsInYear :=
          TCompany(cbCompanies.Items.Objects[lCont]).Periods;

        Break;
      End; {If Lowercase(TCompany(cbCompanies.Items.Objects[lCont]).ExCode) = lowercase(pExCode) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SelectCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmExportFrame.SelectCompany(pId: Integer): Boolean;
Var
  lExCode: String;
Begin
  Result := False;
  If Assigned(fDB) Then
  Begin
    lExCode := fDb.GetExCode(pId);
    Result := SelectCompany(lExCode);
  End; {If Assigned(fDB) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SetBulkExport
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.SetBulkExport(Const Value: Boolean);
Begin
  fBulkExport := Value;

  If fBulkExport Then
  Begin
    If cbJobs.Items.Count > 0 Then
      cbJobs.Items.Insert(0, cBULKEXPORT)
    Else
      cbJobs.Items.Add(cBULKEXPORT);
    cbJobs.ItemIndex := 0;
    cbJobs.Enabled := False;
  End; {If fBulkExport = True Then}
End;


{-----------------------------------------------------------------------------
  Procedure: SetSubContractorVerification
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmExportFrame.SetSubContractorVerification(
  const Value: Boolean);
begin
  fSubContractorVerification := Value;

  if fSubContractorVerification then
  begin
    if cbJobs.Items.IndexOf(cCISSUBCONTRACTOR) >= 0 then
      cbJobs.ItemIndex := cbJobs.Items.IndexOf(cCISSUBCONTRACTOR)
    else If cbJobs.Items.Count > 0 Then
      cbJobs.Items.Insert(0, cCISSUBCONTRACTOR)
    Else
      cbJobs.Items.Add(cCISSUBCONTRACTOR);

    cbJobs.ItemIndex := 0;
    cbJobs.Enabled := False;
  end; {if fSubContractorVerification then}
end;


{-----------------------------------------------------------------------------
  Procedure: SetExportDetails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.SetExportDetails(pMsg: TMessageInfo; Const pSubj:
  String = ''; Const pParamYear1: String = ''; Const pParamYear2: String = '');
Var
  lP1, lP2: String;
Begin
  lP1 := pParamYear1;
  lP2 := pParamYear2;

  If pMsg <> Nil Then
  Begin
//    SelectCompany(pMsg.Company_Id);

    If pSubj <> '' Then
      advSubject.Text := pSubj
    Else
      advSubject.Text := pMsg.Subject;

    {get the default period and year params}
    If pParamYear1 = '' Then
      lp1 := pMsg.Param1;

    If pParamYear2 = '' Then
      lP2 := pMsg.Param2;
  End; {If pMsg <> Nil Then}

  If edtStartPeriod.Visible Then
  Try
    edtStartPeriod.Text := _GetPeriod(lp1) + _GetYear(lp1);
  Finally
    If (edtStartPeriod.Text = '') Or (_GetYear(edtStartPeriod.Text) = '1900') Then
      edtStartPeriod.Text := _FormatPeriod(1, Now);

    Try
      edtStartPeriod.RefreshValues;
    Except
      edtStartPeriod.Text := _FormatPeriod(1, Now);
      Try
        edtStartPeriod.RefreshValues;
      Except
      End;
    End;
  End; {If edtStartDate.Visible Then}

  If edtEndPeriod.Visible Then
  Try
    edtEndPeriod.Text := _GetPeriod(lP2) + _GetYear(lP2);
  Finally
    If (edtEndPeriod.Text = '') Or (_GetYear(edtEndPeriod.Text) = '1900') Then
      edtEndPeriod.Text := _FormatPeriod(12, Now);

    Try
      edtEndPeriod.RefreshValues;
    Except
      edtEndPeriod.Text := _FormatPeriod(12, Now);
      Try
        edtEndPeriod.RefreshValues;
      Except
      End;
    End
  End; {If edtEndDate.Visible Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ValidatePeriod
  Author:    vmoura

  validate the edited period against the message that requested the sync
-----------------------------------------------------------------------------}
Function TfrmExportFrame.ValidatePeriod(pCompany: Integer): Boolean;
Var
  lP1, lP2: WideString;
Begin
  Result := True;

  lP1 := ParamYear1;
  lP2 := ParamYear2;

  If (lp1 = '') Or (lp2 = '') Then
  Try
    udsr.TDSR.DSR_GetDripFeedParams(_DashboardGetDSRServer, _DashboardGetDSRPort,
      pCompany, lP1, lP2);
  Except
    lp1 := '';
    lp2 := '';
  End;

  If (lP1 <> '') And (lP2 <> '') Then
    If (lP1 <> edtStartPeriod.Text) Or (lP2 <> edtEndPeriod.Text) Then
        {the user is going to accept to go on or cancel the sending}
(*      Result := MessageDlg('The selected period is not the same as the original (' +
        _GetPeriod(lP1) + '/' + _GetYear(lP1) + ' - ' + _GetPeriod(lP2) + '/' +
        _GetYear(lP2) + ').' + #13 + #10 + 'Do you want to continue?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes;*)
      Result := ShowDashboardDialog('The selected period is not the same as the original (' +
        _GetPeriod(lP1) + '/' + _GetYear(lP1) + ' - ' + _GetPeriod(lP2) + '/' +
        _GetYear(lP2) + ').' + #13 + #10 + 'Do you want to continue?',
        mtConfirmation, [mbYes, mbNo]) = mrYes;
End;

{-----------------------------------------------------------------------------
  Procedure: SelectDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmExportFrame.SelectDripFeed: Boolean;
Begin
  {select a drip feed mode export task}
  With cbJobs Do
  Begin
    ItemIndex := -1;
    Try
      ItemIndex := Items.IndexOf(cDRIPFEED)
    Finally
      Result := ItemIndex >= 0;
    End;
  End; {With frmExportFrame.cbCompanies Do}
End;

{-----------------------------------------------------------------------------
  Procedure: edtStartPeriodKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.edtStartPeriodKeyDown(Sender: TObject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = vk_return Then
  Begin
    Try
      Key := 0;
      If Sender Is TEditPeriod Then
        If (Sender As TEditPeriod).Text <> '' Then
        Begin
          //PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);
          SelectNext(TWinControl(Sender), True, True);
          Abort;
        End;
    Except
    End; {try}
  End; {If Key = vk_return Then}
End;

{-----------------------------------------------------------------------------
  Procedure: cbCompaniesKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.cbCompaniesKeyDown(Sender: TObject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = vk_return Then
  Try
    Key := 0;
    SelectNext(TWinControl(Sender), True, True);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: HidePeriods
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.HidePeriods;
Begin
  lblPeriodOfData.Visible := False;
  lblStartPeriod.Visible := False;
  lblEndPeriod.Visible := False;
  edtStartPeriod.Visible := False;
  edtEndPeriod.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: ValidateFields
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExportFrame.ValidateFields;
  Procedure _EnableAddressBook;
  Begin
    If Not advTo.Enabled Then
      advTo.Enabled := True;

    If Not actAddressBook.Enabled Then
      actAddressBook.Enabled := True;

    If advTo.CanFocus Then
      advTo.SetFocus;
  End; {Procedure _EnableAddressBook}

Begin

  {check the company name}
  //If _DashboardGetCompanyName = '' Then
  if Trim(fDB.GetSystemValue(cCOMPANYNAMEPARAM)) = '' then
  Begin
    //MessageDlg('The company name can not be empty. Use the configuration setup to enter a valid name.', mtInformation, [mbok], 0);
    ShowDashboardDialog('The company name can not be empty. Use the configuration setup to enter a valid name.', mtInformation, [mbok]);
    Abort;
  End;

  {validate destination address}
  If advTo.Text = '' Then
  Begin
    //MessageDlg('Please, enter a valid destination address!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, enter a valid destination address!', mtInformation, [mbok]);

    _EnableAddressBook;
    Abort;
  End; {If advTo.Text = '' Then}

  If Pos(cUNKNOWMAIL, advTo.Text) > 0 Then
  Begin
    //MessageDlg('Please, enter a valid destination address!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, enter a valid destination address!', mtInformation, [mbok]);
    _EnableAddressBook;
    Abort;
  End; {If advTo.Text = '' Then}

  {validate subject }
  If advSubject.Text = '' Then
  Begin
    //MessageDlg('Pleas, enter a valid subject text!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Pleas, enter a valid subject text!', mtInformation, [mbok]);

    If advSubject.CanFocus Then
      advSubject.SetFocus;
    Abort;
  End; {If advSubject.Text = '' Then}

  {validate the company wich will send information}
  If cbCompanies.Text = '' Then
  Begin
    //MessageDlg('Please, select a valid company!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, select a valid company!', mtInformation, [mbok]);

    If cbCompanies.CanFocus Then
      cbCompanies.SetFocus;
    Abort;
  End; {If cbCompanies.Text = '' Then}

  {validate the selected "job"}
  If cbJobs.Text = '' Then
  Begin
    //MessageDlg('Please, select a valid job!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, select a valid job!', mtInformation, [mbok]);

    If cbJobs.CanFocus Then
      cbJobs.SetFocus;
    Abort;
  End; {If cbJobs.Text = '' Then}

  {validate the period of operation}
  If edtStartPeriod.Visible And edtEndPeriod.Visible Then
  Begin
    edtStartPeriod.RefreshValues;
    edtEndPeriod.RefreshValues;

    If edtStartPeriod.DateValue > edtEndPeriod.DateValue Then
    Begin
      //MessageDlg('Please, select a valid period of operation!', mtInformation, [mbok], 0);
      ShowDashboardDialog('Please, select a valid period of operation!', mtInformation, [mbok]);

      Abort;
    End; {If edtStartDate.DateValue > edtEndDate.DateValue Then}
  End; {If edtStartDate.Visible And edtEndDate.Visible Then}
End;

End.

