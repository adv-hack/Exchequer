unit SurveyContactFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SurveyBaseFrame, StdCtrls, IniFiles, oSurveyStore;

type
  TSurveyFrameContactDetails = class(TSurveyFrameBase)
    Label1: TLabel;
    Label3: TLabel;
    lblAddress: TLabel;
    lblEmail: TLabel;
    lblFax: TLabel;
    lblPhone: TLabel;
    lblPostCode: TLabel;
    Label2: TLabel;
    Label31: TLabel;
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
    lstContactMethod: TComboBox;
    Label9: TLabel;
    procedure lstContactMethodClick(Sender: TObject);
  private
    { Private declarations }
    FValidEmail, fValidPhone, FValidFax, FValidAddress : LongInt;
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

Uses StrUtils;

//=========================================================================

// Loads the pre-defined information from ExSurvey.Dat
Procedure TSurveyFrameContactDetails.InitialiseFromIni(Const InitIni : TIniFile);
Var
  sList : TStringList;
  I : SmallInt;
Begin // InitialiseFromIni
  With InitIni Do
  Begin
    sList := TStringList.Create;
    Try
      ReadSectionValues('ContactMethods', sList);
      lstContactMethod.Clear;
      If (sList.Count > 0) Then
      Begin
        For I := 0 To Pred(sList.Count) Do
          lstContactMethod.Items.Add (sList.Values[sList.Names[I]]);
        lstContactMethod.ItemIndex := 0;
      End; // If (sList.Count > 0)
    Finally
      sList.Free;
    End;

    FValidEmail := ReadInteger('ContactMethodValidation', 'ValidateEmail', -1);
    fValidPhone := ReadInteger('ContactMethodValidation', 'ValidatePhone', -1);
    FValidFax := ReadInteger('ContactMethodValidation', 'ValidateFax', -1);
    FValidAddress := ReadInteger('ContactMethodValidation', 'ValidateAddress', -1);
  End; // With InitIni
End; // InitialiseFromIni

//-------------------------------------------------------------------------

// Updates the from with data from the global oSurveyInfo singleton
Procedure TSurveyFrameContactDetails.LoadPreviousData;
Begin // LoadPreviousData
  With oSurveyInfo Do
  Begin
    edtContactName.Text := Contact;
    edtCompanyName.Text := Licencee;
    If (Trim(ContactMethod) <> '') Then lstContactMethod.ItemIndex := lstContactMethod.Items.IndexOf(ContactMethod);
    edtAddress1.Text := Address[1];
    edtAddress2.Text := Address[2];
    edtAddress3.Text := Address[3];
    edtAddress4.Text := Address[4];
    edtAddress5.Text := Address[5];
    edtEmail.Text := EmailAddress;
    edtFax.Text := FaxNumber;
    edtPhone.Text := PhoneNumber;
    edtPostCode.Text := PostCode;
  End; // With oSurveyInfo

  lstContactMethodClick(Self);
End; // LoadPreviousData

//-------------------------------------------------------------------------

// Updates the global oSurveyInfo singleton with data from the frame
Procedure TSurveyFrameContactDetails.SaveData;
Begin // SaveData
  With oSurveyInfo Do
  Begin
    Contact := edtContactName.Text;
    ContactMethod := lstContactMethod.Text;
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
  End; // With oSurveyInfo
End; // SaveData

//-------------------------------------------------------------------------

// Returns TRUE if the details are OK and we can move onto the next dialog
Function TSurveyFrameContactDetails.Validate : Boolean;
Var
  oEdit : TEdit;
  sDesc : ShortString;
Begin // Validate
  If (lstContactMethod.ItemIndex <> FValidAddress) Then
  Begin
    oEdit := NIL;

    // Check if contact ino OK - then move forward to Marketing Page
    If (lstContactMethod.ItemIndex = FValidEmail) Then
    Begin
      oEdit := edtEmail;
      sDesc := 'Email Address';
    End // If (lstContactMethod.ItemIndex = FValidEmail)
    Else If (lstContactMethod.ItemIndex = fValidPhone) Then
    Begin
      oEdit := edtPhone;
      sDesc := 'Telephone Number';
    End // If (lstContactMethod.ItemIndex = fValidPhone)
    Else If (lstContactMethod.ItemIndex = FValidFax) Then
    Begin
      oEdit := edtFax;
      sDesc := 'Fax Number';
    End; // If (lstContactMethod.ItemIndex = FValidFax)

    If Assigned(oEdit) Then
    Begin
      Result := Trim(oEdit.Text) <> '';
      If (Not Result) Then
      Begin
        If oEdit.CanFocus Then
          oEdit.SetFocus;
        MessageDlg ('You must either set the ' + sDesc + ' before continuing or change the Preferred Contact Method', mtError, [mbOK], 0);
      End; // If (Not Result)
    End // If Assigned(oEdit)
    Else
      Result := True;
  End // If (lstContactMethod.ItemIndex <> FValidAddress)
  Else
  Begin
    // Validate Address
    Result := Trim(edtAddress1.Text) <> '';
    If (Not Result) Then
    Begin
      If edtAddress1.CanFocus Then
        edtAddress1.SetFocus;
      MessageDlg ('You must either set the Address before continuing or change the Preferred Contact Method', mtError, [mbOK], 0);
    End // If (Not Result)
    Else
    Begin
      Result := Trim(edtPostCode.Text) <> '';
      If (Not Result) Then
      Begin
        If edtPostCode.CanFocus Then
          edtPostCode.SetFocus;
        MessageDlg ('You must either set the Postcode before continuing or change the Preferred Contact Method', mtError, [mbOK], 0);
      End // If (Not Result)
    End; // Else
  End; // Else
End; // Validate

//-------------------------------------------------------------------------

procedure TSurveyFrameContactDetails.lstContactMethodClick(Sender: TObject);
begin
  lblAddress.Caption := IfThen (lstContactMethod.ItemIndex = FValidAddress, '* ', '') + 'Address';
  lblPostCode.Caption := IfThen (lstContactMethod.ItemIndex = FValidAddress, '* ', '') + 'Post Code';
  lblPhone.Caption := IfThen (lstContactMethod.ItemIndex = fValidPhone, '* ', '') + 'Telephone';
  lblFax.Caption := IfThen (lstContactMethod.ItemIndex = FValidFax, '* ', '') + 'Fax';
  lblEmail.Caption := IfThen (lstContactMethod.ItemIndex = FValidEmail, '* ', '') + 'Email Address';
end;

//=========================================================================

end.
