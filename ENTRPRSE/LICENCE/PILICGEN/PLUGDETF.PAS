unit PlugDetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlugInDB, DlrDetF, Mask, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmPlugInDetail = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtCode: TEdit;
    edtName: TEdit;
    Label2: TLabel;
    Label6: TLabel;
    mskLicExpiry: TMaskEdit;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPlugInDets : PlugInRecType;
    FFormMode   : TDetailMode;
    procedure SetFormMode(const Value: TDetailMode);
    procedure SetPlugInDets(const Value: PlugInRecType);
  public
    { Public declarations }
    Property PlugInDets : PlugInRecType Read FPlugInDets Write SetPlugInDets;
    Property FormMode : TDetailMode Read FFormMode Write SetFormMode;
  end;


Function DisplayPlugInDetail (Const DealerCode, PlugInCode : ShortString; Const Mode : TDetailMode) : Boolean;

implementation

{$R *.dfm}

//---------------------------------------------------------------------------

Function DisplayPlugInDetail (Const DealerCode, PlugInCode : ShortString; Const Mode : TDetailMode) : Boolean;
Begin { DisplayPlugInDetail }
  With TfrmPlugInDetail.Create (Application.MainForm) Do
    Try
      If (Mode <> mdAdd) Then
        // Load the Dealer Details
        PlugInDets := LoadPlugIn (PlugInCode)
      Else
        PlugInDets := InitNewPlugIn;

      // Reconfigure the dialog for the mode
      FormMode := Mode;

      // Display the Form
      ShowModal;

      If (ModalResult = mrOk) Then Begin
        // Check mode to determine correct action
        If (FormMode In [mdAdd, mdEdit]) Then
          // Extract info from form and update database
          SavePlugIn (DealerCode, PlugInDets, (Mode = mdAdd))
        Else
          If (FormMode = mdDelete) Then
            // Delete the specified Dealer and its Plug-Ins
            DeletePlugIn (DealerCode, PlugInDets.piCode);
      End; { If (ModalResult = mrOk) }

      Result := (ModalResult = mrOk);
    Finally
      Free;
    End;
End; { DisplayPlugInDetail }

//---------------------------------------------------------------------------

procedure TfrmPlugInDetail.SetPlugInDets(const Value: PlugInRecType);
begin
  FPlugInDets := Value;

  // Display Details
  With FPlugInDets Do Begin
    // Plug-In ID Code
    edtCode.Text := Trim(piCode);

    // Plug-in Description
    edtName.Text := Trim(piName);

    // Plug-in Description
    mskLicExpiry.Text := FormatDateTime('DD/MM/YYYY', piExpiry);
  End; { With FDealerDets }
end;

//-------------------------------------------------

procedure TfrmPlugInDetail.SetFormMode(const Value: TDetailMode);
begin
  FFormMode := Value;

  // Caption
  Case FFormMode Of
    mdAdd    : Caption := 'Add New Plug-In';
    mdEdit   : Caption := 'Edit Plug-In ' + FPlugInDets.piCode;
    mdDelete : Caption := 'Delete Plug-In ' + FPlugInDets.piCode;
  End; { Case FFormMode }

  // Fields
  edtCode.ReadOnly := (FormMode In [mdEdit, mdDelete]);
  edtName.ReadOnly := (FormMode = mdDelete);
  mskLicExpiry.ReadOnly := edtName.ReadOnly;

  // OK Button
  If (FFormMode = mdDelete) Then
    btnOK.Caption := '&Delete';
end;

//-------------------------------------------------

procedure TfrmPlugInDetail.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  If (FFormMode In [mdAdd, mdEdit]) Then
    With FPlugInDets Do Begin
      OK := True;

      // Validate Details and update dealer record
      If (FFormMode = mdAdd) Then Begin
        // Check Dealer Code doesn't already exist
        piCode := UpperCase(Trim(edtCode.Text));
        OK := Not PlugInExists (piCode);
        If OK Then Begin
          // Check that the Plug-in number is unique as well as the full code
          OK := PlugInNumberUnique (piCode);
          If (Not OK) Then Begin
            MessageDlg ('A Plug-In with the same Number already exists', mtError, [mbOk], 0);
            If edtCode.CanFocus Then edtCode.SetFocus;
          End; { If (Not OK) }
        End { If OK }
        Else Begin
          MessageDlg ('A Dealer with that code already exists', mtError, [mbOk], 0);
          If edtCode.CanFocus Then edtCode.SetFocus;
        End; { If (Not OK) }
      End; { If (FFormMode = mdAdd) }

      If OK Then Begin
        // Check Company Name is set
        piName := Trim(edtName.Text);
        If (piName = '') Then Begin
          MessageDlg ('The Plug-In Name must be set', mtError, [mbOk], 0);
          If edtName.CanFocus Then edtName.SetFocus;
          OK := False;
        End; { If (piName = '') }
      End; { If OK }

      If OK Then Begin
        // Check Expiry Date is valid
        piExpiry := StrToDate (mskLicExpiry.Text);
        If (piExpiry < Now) Then Begin
          MessageDlg ('The Plug-In Expiry Date has already passed', mtError, [mbOk], 0);
          If mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
          OK := False;
        End { If (piExpiry < Now) }
        Else
          // Confirm if it expires too far into the future - lic runs for 1 year + allow 2 weeks advance for renewal
          If (piExpiry > (Now + 365 + 14)) Then Begin
            OK := (MessageDlg ('Please confirm the Plug-In Expiry Date of ' +
                               QuotedStr(FormatDateTime('DD/MM/YYYY', piExpiry)),
                               mtConfirmation, [mbYes, mbNo], 0) = mrYes);
            If (Not OK) And mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
          End; { If (piExpiry > (Now + 365 + 14)) }
      End; { If OK }

      If OK Then
        // Validated OK - Close form and save details
        ModalResult := mrOK;
    End { With FPlugInDets }
  Else
    If (FFormMode = mdDelete) Then
      ModalResult := mrOK;
end;

//-------------------------------------------------

end.
