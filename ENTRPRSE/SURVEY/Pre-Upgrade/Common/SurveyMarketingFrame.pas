unit SurveyMarketingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SurveyBaseFrame, StdCtrls, IniFiles, oSurveyStore;

type
  TSurveyFrameMarketing = class(TSurveyFrameBase)
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
    procedure lstAccountsPackageClick(Sender: TObject);
    procedure lstPersonResponsibleClick(Sender: TObject);
    procedure lstIndustryClick(Sender: TObject);
  private
    { Private declarations }
    procedure EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
  public
    // Loads the pre-defined information from ExSurvey.Dat
    Procedure InitialiseFromIni(Const InitIni : TIniFile); Override;
    // Updates the from with data from the global oSurveyInfo singleton
    Procedure LoadPreviousData; Override;
    // Updates the global oSurveyInfo singleton with data from the frame
    Procedure SaveData; Override;
    // Returns TRUE if the details are OK and we can move onto the next dialog
    Function Validate : Boolean; Override;
  end;

implementation

{$R *.dfm}

//=========================================================================

// Loads the pre-defined information from ExSurvey.Dat
Procedure TSurveyFrameMarketing.InitialiseFromIni(Const InitIni : TIniFile);
Var
  sList : TStringList;
  I : SmallInt;
Begin // InitialiseFromIni
  With InitIni Do
  Begin
    sList := TStringList.Create;
    Try
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
      sList.Free;
    End;
  End; // With InitIni
End; // InitialiseFromIni

//-------------------------------------------------------------------------

// Updates the from with data from the global oSurveyInfo singleton
Procedure TSurveyFrameMarketing.LoadPreviousData;
Begin // LoadPreviousData
  With oSurveyInfo Do
  Begin
    If (Trim(Package) <> '') Then lstAccountsPackage.ItemIndex := lstAccountsPackage.Items.IndexOf(Package);
    edtOtherPackage.Text := OtherPackage;
    lstAccountsPackageClick(Self);

    If (Trim(Position) <> '') Then lstPersonResponsible.ItemIndex := lstPersonResponsible.Items.IndexOf(Position);
    edtOtherJobPosition.Text := OtherPosition;
    lstPersonResponsibleClick(Self);

    If (Trim(Industry) <> '') Then lstIndustry.ItemIndex := lstIndustry.Items.IndexOf(Industry);
    edtOtherIndustry.Text := OtherIndustry;
    lstIndustryClick(Self);

    If (Trim(Turnover) <> '') Then lstTurnoverBands.ItemIndex := lstTurnoverBands.Items.IndexOf(Turnover);
    If (Trim(TurnoverCcy) <> '') Then lstCurrency.ItemIndex := lstCurrency.Items.IndexOf(TurnoverCcy);
    If (Trim(Employees) <> '') Then lstStaffBands.ItemIndex := lstStaffBands.Items.IndexOf(Employees);
  End; // With oSurveyInfo
End; // LoadPreviousData

//-------------------------------------------------------------------------

// Updates the global oSurveyInfo singleton with data from the frame
Procedure TSurveyFrameMarketing.SaveData;
Begin // SaveData
  With oSurveyInfo Do
  Begin
    Package := lstAccountsPackage.Text;
    OtherPackage := edtOtherPackage.Text;
    Position := lstPersonResponsible.Text;
    OtherPosition := edtOtherJobPosition.Text;
    Industry := lstIndustry.Text;
    OtherIndustry := edtOtherIndustry.Text;
    Turnover := lstTurnoverBands.Text;
    TurnoverCcy := lstCurrency.Text;
    Employees := lstStaffBands.Text;
  End; // With oSurveyInfo
End; // SaveData

//-------------------------------------------------------------------------


// Returns TRUE if the details are OK and we can move onto the next dialog
Function TSurveyFrameMarketing.Validate : Boolean;
Begin // Validate
  Result := True;
End; // Validate

//-------------------------------------------------------------------------

procedure TSurveyFrameMarketing.EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
begin
  OtherEdit.Enabled := (UpperCase(Trim(MainList.Text)) = 'OTHER');
  If (Not OtherEdit.Enabled) Then
    OtherEdit.Text := '';
  OtherEditLabel.Enabled := OtherEdit.Enabled;
end;

//------------------------------

procedure TSurveyFrameMarketing.lstAccountsPackageClick(Sender: TObject);
begin
  EnableOther(lstAccountsPackage, edtOtherPackage, Label14);
end;

procedure TSurveyFrameMarketing.lstPersonResponsibleClick(Sender: TObject);
begin
  EnableOther(lstPersonResponsible, edtOtherJobPosition, Label16);
end;

procedure TSurveyFrameMarketing.lstIndustryClick(Sender: TObject);
begin
  EnableOther(lstIndustry, edtOtherIndustry, Label19);
end;

//-------------------------------------------------------------------------

end.

