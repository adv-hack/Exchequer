unit SurveyF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles,SETUPBAS, ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmCustSurvey = class(TSetupTemplate)
    Notebook1: TNotebook;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label2: TLabel;
    edtCompanyName: TEdit;
    edtContactName: TEdit;
    edtAddress1: TEdit;
    edtAddress2: TEdit;
    edtAddress3: TEdit;
    edtAddress5: TEdit;
    edtAddress4: TEdit;
    edtEmail: TEdit;
    edtFax: TEdit;
    edtPhone: TEdit;
    edtPostCode: TEdit;
    chkSendCompanies: TCheckBox;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    lstAccountsPackage: TComboBox;
    edtOtherPackage: TEdit;
    lstPersonResponsible: TComboBox;
    edtOtherJobPosition: TEdit;
    lstCurrency: TComboBox;
    lstTurnoverBands: TComboBox;
    lstStaffBands: TComboBox;
    lstIndustry: TComboBox;
    edtOtherIndustry: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BackBtnClick(Sender: TObject);
    procedure lstAccountsPackageClick(Sender: TObject);
    procedure lstPersonResponsibleClick(Sender: TObject);
    procedure lstIndustryClick(Sender: TObject);
  private
    { Private declarations }
    procedure EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
  public
    { Public declarations }
    procedure ShowFirst;
    procedure ShowLast;
  end;

var
  frmCustSurvey: TfrmCustSurvey;

implementation

{$R *.dfm}

Uses ResultsF, oEntList, ContKey;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormCreate(Sender: TObject);
Var
  sList : TStringList;
  I     : SmallInt;
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  sList := TStringList.Create;
  Try
    With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
      Try
        chkSendCompanies.Visible := ReadBool('Options', 'ShowSendCompanies', True);
        Label9.Visible := chkSendCompanies.Visible;

        //------------------------------------------

        ReadSectionValues('AccountsPackages', sList);
        lstAccountsPackage.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstAccountsPackage.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'AccountsPackages', -1);
        If (I >= 0) And (I < lstAccountsPackage.Items.Count) Then
          lstAccountsPackage.ItemIndex := I;

        //------------------------------------------

        ReadSectionValues('ResponsiblePosition', sList);
        lstPersonResponsible.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstPersonResponsible.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'ResponsiblePosition', -1);
        If (I >= 0) And (I < lstPersonResponsible.Items.Count) Then
          lstPersonResponsible.ItemIndex := I;

        //------------------------------------------

        ReadSectionValues('TurnoverCurrency', sList);
        lstCurrency.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstCurrency.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'TurnoverCurrency', 0);
        If (I >= 0) And (I < lstCurrency.Items.Count) Then
          lstCurrency.ItemIndex := I;

        //------------------------------------------

        ReadSectionValues('TurnoverBands', sList);
        lstTurnoverBands.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstTurnoverBands.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'TurnoverBands', 0);
        If (I >= 0) And (I < lstTurnoverBands.Items.Count) Then
          lstTurnoverBands.ItemIndex := I;

        //------------------------------------------

        ReadSectionValues('StaffBands', sList);
        lstStaffBands.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstStaffBands.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'StaffBands', 0);
        If (I >= 0) And (I < lstStaffBands.Items.Count) Then
          lstStaffBands.ItemIndex := I;

        //------------------------------------------

        ReadSectionValues('Industry', sList);
        lstIndustry.Clear;
        If (sList.Count > 0) Then
          For I := 0 To Pred(sList.Count) Do
            lstIndustry.Items.Add (sList.Values[sList.Names[I]]);
        I := ReadInteger ('Defaults', 'Industry', 0);
        If (I >= 0) And (I < lstIndustry.Items.Count) Then
          lstIndustry.ItemIndex := I;
      Finally
        Free;
      End;
  Finally
    sList.Free;
  End;

  With oSurveyInfo Do Begin
    // Company Details
    edtContactName.Text := Contact;
    edtCompanyName.Text := Licencee;
    edtAddress1.Text := Address[1];
    edtAddress2.Text := Address[2];
    edtAddress3.Text := Address[3];
    edtAddress4.Text := Address[4];
    edtAddress5.Text := Address[5];
    edtEmail.Text := EmailAddress;
    edtFax.Text := FaxNumber;
    edtPhone.Text := PhoneNumber;
    edtPostCode.Text := PostCode;
    chkSendCompanies.Checked := SendCompanies;

    If (Trim(Package) <> '') Then lstAccountsPackage.ItemIndex := lstAccountsPackage.Items.IndexOf(Package);
    edtOtherPackage.Text := OtherPackage;
    lstAccountsPackageClick(Sender);

    If (Trim(Position) <> '') Then lstPersonResponsible.ItemIndex := lstPersonResponsible.Items.IndexOf(Position);
    edtOtherJobPosition.Text := OtherPosition;
    lstPersonResponsibleClick(Sender);

    If (Trim(Industry) <> '') Then lstIndustry.ItemIndex := lstIndustry.Items.IndexOf(Industry);
    edtOtherIndustry.Text := OtherIndustry;
    lstIndustryClick(Sender);

    If (Trim(Turnover) <> '') Then lstTurnoverBands.ItemIndex := lstTurnoverBands.Items.IndexOf(Turnover);
    If (Trim(TurnoverCcy) <> '') Then lstCurrency.ItemIndex := lstCurrency.Items.IndexOf(TurnoverCcy);
    If (Trim(Employees) <> '') Then lstStaffBands.ItemIndex := lstStaffBands.Items.IndexOf(Employees);

    (*
    // Company List
    If (oSurveyInfo.Count > 0) Then
      For I := 0 To Pred(oSurveyInfo.Count) Do
        With DataSets[I], ListView1.Items.Add Do Begin
          Caption := compCode;
          SubItems.Add (compName);
          Checked := compDemo;

          // record handle of Data Set object for later updating of the Demo status flag
          Data := DataSets[I];
        End; { With ListView1.Items.Add }
    *)
  End; { With oSurveyInfo }
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.NextBtnClick(Sender: TObject);
{Var
  EntDataSet : TEntDataSet;
  I          : LongInt;}
begin
  If (NoteBook1.ActivePage = 'Last') Then Begin
    // Copy Company Details back into oSurveyInfo object for later use
    With oSurveyInfo Do Begin
      // Tab 1 - Company Details
      Contact := edtContactName.Text;
      Licencee := edtCompanyName.Text;
      Address[1] := edtAddress1.Text;
      Address[2] := edtAddress2.Text;
      Address[3] := edtAddress3.Text;
      Address[4] := edtAddress4.Text;
      Address[5] := edtAddress5.Text;
      PostCode := edtPostCode.Text;
      PhoneNumber := edtPhone.Text;
      FaxNumber := edtFax.Text;
      EmailAddress := edtEmail.Text;
      SendCompanies := chkSendCompanies.Checked;

      // Tab 2 - Marketing Info
      Package := lstAccountsPackage.Text;
      OtherPackage := edtOtherPackage.Text;
      Position := lstPersonResponsible.Text;
      OtherPosition := edtOtherJobPosition.Text;
      Industry := lstIndustry.Text;
      OtherIndustry := edtOtherIndustry.Text;
      Turnover := lstTurnoverBands.Text;
      TurnoverCcy := lstCurrency.Text;
      Employees := lstStaffBands.Text;

      // Update Setup.Usr for next time the app is used
      UpdateSetupUSR;
    End; { With oSurveyInfo }

    (***
    // Update Demo status on Company Data Sets
    If (ListView1.Items.Count > 0) Then
      For I := 0 To Pred(ListView1.Items.Count) Do
        With ListView1.Items[I] Do Begin
          EntDataSet := Data;
          EntDataSet.compDemo := Checked;
        End; { With ListView1.Items[I] }
    ***)

    // Close form and move to Results dialog
    //inherited;
    Hide;
    TfrmResults.Create(Application.MainForm).Show;

    ExitCode := 'N';
    PostMessage (Self.Handle, WM_Close, 0, 0);
  End { If (NoteBook1.ActivePage = 'Last')  }
  Else Begin
    Backbtn.Enabled := True;
    Notebook1.ActivePage := 'Last';
  End; { Else }
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //inherited;
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Self.Handle);
end;

procedure TfrmCustSurvey.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //inherited;
  GlobFormKeyPress(Sender, Key, ActiveControl, Self.Handle);
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.ShowFirst;
begin
  Backbtn.Enabled := False;
  Notebook1.ActivePage := 'First';
  Show;
end;

procedure TfrmCustSurvey.ShowLast;
begin
  Backbtn.Enabled := True;
  Notebook1.ActivePage := 'Last';
  Show;
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.BackBtnClick(Sender: TObject);
begin
  //inherited;

  Backbtn.Enabled := False;
  Notebook1.ActivePage := 'First';
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
begin
  OtherEdit.Enabled := (UpperCase(Trim(MainList.Text)) = 'OTHER');
  If (Not OtherEdit.Enabled) Then 
    OtherEdit.Text := '';
  OtherEditLabel.Enabled := OtherEdit.Enabled;
end;

procedure TfrmCustSurvey.lstAccountsPackageClick(Sender: TObject);
begin
  EnableOther(lstAccountsPackage, edtOtherPackage, Label14);
end;

procedure TfrmCustSurvey.lstPersonResponsibleClick(Sender: TObject);
begin
  EnableOther(lstPersonResponsible, edtOtherJobPosition, Label16);
end;

procedure TfrmCustSurvey.lstIndustryClick(Sender: TObject);
begin
  EnableOther(lstIndustry, edtOtherIndustry, Label19);
end;

//--------------------------------------------------------------------------

end.
