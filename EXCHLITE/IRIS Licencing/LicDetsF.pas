unit LicDetsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, oIRISLicence, StdCtrls, ComCtrls;

type
  TfrmLicenceDetails = class(TForm)
    Label1: TLabel;
    lstCountry: TComboBox;
    Label2: TLabel;
    lstType: TComboBox;
    Label3: TLabel;
    edtUserCount: TEdit;
    udUserCount: TUpDown;
    Label4: TLabel;
    edtCompanyCount: TEdit;
    udCompanyCount: TUpDown;
    Label5: TLabel;
    edtPervasiveKey: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label7: TLabel;
    edtTheme: TEdit;
    udTheme: TUpDown;
    Label8: TLabel;
    edtCompanyName: TEdit;
    procedure btnOKClick(Sender: TObject);
  private
    FIRISLicence : TIRISLicence;

    Procedure SetIRISLicence (IRISLicence : TIRISLicence);
  public
    Property IRISLicence : TIRISLicence Read FIRISLicence Write SetIRISLicence;
  end;

implementation

{$R *.dfm}

//-------------------------------------------------------------------------

Procedure TfrmLicenceDetails.SetIRISLicence (IRISLicence : TIRISLicence);
Begin // SetIRISLicence
  FIRISLicence := IRISLicence;

  // Enable fields as required
  lstCountry.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRCountryCode) <> -1);
  lstType.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRLITEType) <> -1);
  edtTheme.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRTheme) <> -1);

  edtCompanyName.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRCompanyName) <> -1);

  edtUserCount.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRUserCount) <> -1);
  edtCompanyCount.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRCompanyCount) <> -1);

  edtPervasiveKey.Enabled := (FIRISLicence.LicenceRestrictions.IndexOf(LRPervasiveKey) <> -1);
End; // SetIRISLicence

//-------------------------------------------------------------------------

procedure TfrmLicenceDetails.btnOKClick(Sender: TObject);
Var
  Idx : SmallInt;
begin
  // Use the licencing object to validate the limits

  If lstCountry.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRCountryCode);
    If (Idx <> -1) And (lstCountry.ItemIndex <> -1) Then FIRISLicence.LicenceRestrictions[Idx].Value := lstCountry.Text;
  End; // If lstCountry.Enabled

  If lstType.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRLITEType);
    If (Idx <> -1) And (lstType.ItemIndex <> -1) Then FIRISLicence.LicenceRestrictions[Idx].Value := lstType.Text;
  End; // If lstType.Enabled

  If edtTheme.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRTheme);
    If (Idx <> -1) And (Trim(edtTheme.Text) <> '') Then FIRISLicence.LicenceRestrictions[Idx].Value := edtTheme.Text;
  End; // If edtTheme.Enabled

  If edtCompanyName.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRCompanyName);
    If (Idx <> -1) And (Trim(edtCompanyName.Text) <> '') Then FIRISLicence.LicenceRestrictions[Idx].Value := edtCompanyName.Text;
  End; // If edtCompanyName.Enabled

  If edtUserCount.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRUserCount);
    If (Idx <> -1) And (Trim(edtUserCount.Text) <> '') Then FIRISLicence.LicenceRestrictions[Idx].Value := edtUserCount.Text;
  End; // If edtUserCount.Enabled

  If edtCompanyCount.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRCompanyCount);
    If (Idx <> -1) And (Trim(edtCompanyCount.Text) <> '') Then FIRISLicence.LicenceRestrictions[Idx].Value := edtCompanyCount.Text;
  End; // If edtCompanyCount.Enabled

  If edtPervasiveKey.Enabled Then
  Begin
    Idx := FIRISLicence.LicenceRestrictions.IndexOf(LRPervasiveKey);
    If (Idx <> -1) And (Trim(edtPervasiveKey.Text) <> '') Then FIRISLicence.LicenceRestrictions[Idx].Value := edtPervasiveKey.Text;
  End; // If edtPervasiveKey.Enabled

  ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

end.
