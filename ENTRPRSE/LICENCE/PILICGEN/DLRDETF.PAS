unit DlrDetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, DlrDB, StdCtrls, ComCtrls, ExtCtrls, Mask, PlugInDB;

type
  TDetailMode = (mdAdd, mdEdit, mdDelete);

  TfrmDealerDetail = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtDlrCode: TEdit;
    Panel1: TPanel;
    Label2: TLabel;
    edtDlrName: TEdit;
    edtContactName: TEdit;
    Label3: TLabel;
    edtPhone: TEdit;
    Label4: TLabel;
    edtEmail: TEdit;
    Label5: TLabel;
    lvPlugIns: TListView;
    btnOK: TButton;
    btnCancel: TButton;
    Label6: TLabel;
    btnAddPlugIn: TButton;
    btnEditPlugIn: TButton;
    btnDeletePlugIn: TButton;
    memComments: TMemo;
    mskLicExpiry: TMaskEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnAddPlugInClick(Sender: TObject);
    procedure btnEditPlugInClick(Sender: TObject);
    procedure btnDeletePlugInClick(Sender: TObject);
  private
    { Private declarations }
    FDealerDets : DealerRecType;
    FFormMode: TDetailMode;
    Procedure AddDealerPlugInRow (Const PlugInRec : PlugInRecType);
    procedure SetFormMode(const Value: TDetailMode);
    procedure SetDealerDets(const Value: DealerRecType);
  public
    { Public declarations }
    Property DealerDets : DealerRecType Read FDealerDets Write SetDealerDets;
    Property FormMode : TDetailMode Read FFormMode Write SetFormMode;

    Procedure LoadPlugInList;
  end;

Function DisplayDealerDetail (Const DlrCode : ShortString; Const Mode : TDetailMode) : Boolean;

implementation

{$R *.dfm}

Uses PlugDetF, SecSup2U;

//---------------------------------------------------------------------------

Function DisplayDealerDetail (Const DlrCode : ShortString; Const Mode : TDetailMode) : Boolean;
Begin { DisplayDealerDetail }
  With TfrmDealerDetail.Create (Application.MainForm) Do
    Try
      If (Mode <> mdAdd) Then
        // Load the Dealer Details
        DealerDets := LoadDealer (DlrCode)
      Else
        DealerDets := InitNewDealer;

      // Reconfigure the dialog for the mode
      FormMode := Mode;

      // Display the Form
      ShowModal;

      If (ModalResult = mrOk) Then Begin
        // Check mode to determine correct action
        If (FormMode In [mdAdd, mdEdit]) Then Begin
          // Extract info from form and update database
          SaveDealer (DealerDets, (Mode = mdAdd))

          // Remove all Dealers Plug-Ins and re-add

        End { If (FormMode In [mdAdd, mdEdit]) }
        Else
          If (FormMode = mdDelete) Then
            // Delete the specified Dealer and its Plug-Ins
            DeleteDealer (DealerDets.dlrCode);
      End; { If (ModalResult = mrOk) }

      Result := (ModalResult = mrOk);
    Finally
      Free;
    End;
End; { DisplayDealerDetail }

//---------------------------------------------------------------------------

procedure TfrmDealerDetail.SetDealerDets(const Value: DealerRecType);
begin
  FDealerDets := Value;

  // Display Details
  With FDealerDets Do Begin
    // Enterprise Account Code
    edtDlrCode.Text := dlrCode;

    // Company Name
    edtDlrName.Text := dlrCompany;

    // Contact Name
    edtContactName.Text := dlrContact;

    // Contact Phone Number
    edtPhone.Text := dlrPhone;

    // Email Address for Licence Files
    edtEmail.Text := dlrEmail;

    // Licence Expiry Date
    mskLicExpiry.Text := FormatDateTime('DD/MM/YYYY', dlrExpiry);

    // Any comments
    memComments.Text := dlrComments;

    // Plug-Ins
    LoadPlugInList;
  End; { With FDealerDets }
end;

//-------------------------------------------------

procedure TfrmDealerDetail.SetFormMode(const Value: TDetailMode);
begin
  FFormMode := Value;

  // Caption
  Case FFormMode Of
    mdAdd    : Caption := 'Add New Dealer';
    mdEdit   : Caption := 'Edit Dealer ' + FDealerDets.dlrCode;
    mdDelete : Caption := 'Delete Dealer ' + FDealerDets.dlrCode;
  End; { Case FFormMode }

  // Fields
  edtDlrCode.ReadOnly := (FormMode In [mdEdit, mdDelete]);
  edtDlrName.ReadOnly := (FormMode = mdDelete);
  edtContactName.ReadOnly := edtDlrName.ReadOnly;
  edtPhone.ReadOnly := edtDlrName.ReadOnly;
  edtEmail.ReadOnly := edtDlrName.ReadOnly;
  memComments.ReadOnly := edtDlrName.ReadOnly;
  memComments.ReadOnly := edtDlrName.ReadOnly;

  // OK Button
  If (FFormMode = mdDelete) Then
    btnOK.Caption := '&Delete';

  // Plug-In Buttons
  btnAddPlugIn.Visible := (FormMode = mdEdit);
  btnEditPlugIn.Visible := btnAddPlugIn.Visible;
  btnDeletePlugIn.Visible := btnAddPlugIn.Visible;
end;

//-------------------------------------------------

Procedure TfrmDealerDetail.AddDealerPlugInRow (Const PlugInRec : PlugInRecType);
Var
  PISno   : LongInt;
  ErrCode : Integer;
Begin { AddDealerRow }
  With PlugInRec, lvPlugIns.Items.Add Do Begin
    // Code
    Caption := piCode;

    // Company Name
    SubItems.Add (piName);

    // Expires
    SubItems.Add (FormatDateTime('DD/MM/YYYY', piExpiry));

    // Checksum
    Val (Copy (piCode, 11, 6), PISno, ErrCode);
    If (ErrCode = 0) Then
      SubItems.Add (IntToStr(PI_CheckSum(PISno)))
    Else
      SubItems.Add ('***');
  End; { With lvDealers.Items.Add }
End; { AddDealerRow }

//-------------------------------------------------

Procedure TfrmDealerDetail.LoadPlugInList;
Begin { LoadPlugInList }
  // Initialse the ListView
  lvPlugIns.Clear;

  // Load the list of Dealer Plug-Ins
  EnumDealerPlugIns (FDealerDets.dlrCode, AddDealerPlugInRow);
End; { LoadPlugInList }

//-------------------------------------------------

procedure TfrmDealerDetail.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  If (FFormMode In [mdAdd, mdEdit]) Then
    With FDealerDets Do Begin
      OK := True;

      // Validate Details and update dealer record
      If (FFormMode = mdAdd) Then Begin
        // Check Dealer Code doesn't already exist
        dlrCode := UpperCase(Trim(edtDlrCode.Text));
        OK := Not DealerExists (dlrCode);
        If (Not OK) Then Begin
          MessageDlg ('A Dealer with that code already exists', mtError, [mbOk], 0);
          If edtDlrCode.CanFocus Then edtDlrCode.SetFocus;
        End; { If (Not OK) }
      End; { If (FFormMode = mdAdd) }

      If OK Then Begin
        // Check Company Name is set
        dlrCompany := Trim(edtDlrName.Text);
        If (dlrCompany = '') Then Begin
          MessageDlg ('The Company Name must be set', mtError, [mbOk], 0);
          If edtDlrName.CanFocus Then edtDlrName.SetFocus;
          OK := False;
        End; { If (dlrCompany = '') }
      End; { If OK }

      If OK Then Begin
        // Check Expiry Date is valid
        dlrExpiry := StrToDate (mskLicExpiry.Text);
        If (dlrExpiry < Now) Then Begin
          MessageDlg ('The Licence Expiry Date has already passed', mtError, [mbOk], 0);
          If mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
          OK := False;
        End { If (dlrExpiry < Now) }
        Else
          // Confirm if it expires too far into the future - lic runs for 3 months + allow 2 weeks advance for renewal
          If (dlrExpiry > (Now + 90 + 14)) Then Begin
            OK := (MessageDlg ('Please confirm the Licence Expiry Date of ' +
                               QuotedStr(FormatDateTime('DD/MM/YYYY', dlrExpiry)),
                               mtConfirmation, [mbYes, mbNo], 0) = mrYes);
            If (Not OK) And mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
          End; { If (dlrExpiry > (Now + 90 + 14)) }
      End; { If OK }

      If OK Then Begin
        dlrContact := Trim(edtContactName.Text);
        dlrPhone := Trim(edtPhone.Text);
        dlrEmail := Trim(edtEmail.Text);
        dlrComments := Trim(memComments.Text);
      End; { If OK }

      If OK Then
        // Validated OK - Close form and save details
        ModalResult := mrOK;
    End { With FDealerDets }
  Else
    If (FFormMode = mdDelete) Then
      ModalResult := mrOK;
end;

//-------------------------------------------------

procedure TfrmDealerDetail.btnAddPlugInClick(Sender: TObject);
begin
  If DisplayPlugInDetail (FDealerDets.dlrCode, '', mdAdd) Then
    LoadPlugInList;
end;

//-------------------------------------------------

procedure TfrmDealerDetail.btnEditPlugInClick(Sender: TObject);
begin
  If (lvPlugIns.SelCount = 1) Then
    If DisplayPlugInDetail (FDealerDets.dlrCode, lvPlugIns.Selected.Caption, mdEdit) Then
      LoadPlugInList;
end;

//-------------------------------------------------

procedure TfrmDealerDetail.btnDeletePlugInClick(Sender: TObject);
begin
  If (lvPlugIns.SelCount = 1) Then
    If DisplayPlugInDetail (FDealerDets.dlrCode, lvPlugIns.Selected.Caption, mdDelete) Then
      LoadPlugInList;
end;

//-------------------------------------------------

end.
