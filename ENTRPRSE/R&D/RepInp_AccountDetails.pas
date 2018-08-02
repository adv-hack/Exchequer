unit RepInp_AccountDetails;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, BTSupU3,
  Repinp1u, StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, bkgroup, Animate,
  BorBtns, ComCtrls;

type
  TAccountReportType = (
                        artCustomerAccountDetails, artSupplierAccountDetails,
                        artCustomerTradingLedger,  artSupplierTradingLedger,
                        artCustomerLabels,         artSupplierLabels,
                        artCustomerList            { Note: Supplier list does not use dialog }
                       );

Const
  TAccountReportType_Customers = [artCustomerAccountDetails, artCustomerTradingLedger, artCustomerLabels, artCustomerList];

Type
  TfrmRepInpAccountDetails = class(TRepInpMsg)
    edtFromAccountCode: Text8Pt;
    edtToAccountCode: Text8Pt;
    lblAccountRange: Label8;
    lblAccountTo: Label8;
    cbAccountTypes: TSBSComboBox;
    lblIncludeAccountTypes: Label8;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure edtFromAccountCodeExit(Sender: TObject);
  private
    FReportType : TAccountReportType;
    CRepParam  :  CustRepParam;
    procedure HideAccountRange;
  public
    {Public declarations }
    Constructor CreateWithReportType (Const AOwner : TComponent; Const ReportType : TAccountReportType);
  end;

  //------------------------------

Procedure RunAccountReport (Const AOwner : TComponent;
                            Const ReportType : TAccountReportType);


Implementation

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  Event1U,
  InvListU,
  ReportU,
  ExWrap1U,
  SysU2,
  BTSupU2;


{$R *.DFM}


//=========================================================================

Procedure RunAccountReport (Const AOwner : TComponent;
                            Const ReportType : TAccountReportType);
Begin // RunAccountReport
  TfrmRepInpAccountDetails.CreateWithReportType(AOwner, ReportType);
End; // RunAccountReport

//=========================================================================

Constructor TfrmRepInpAccountDetails.CreateWithReportType (Const AOwner : TComponent; Const ReportType : TAccountReportType);
Var
  sFormName : ShortString;
  I : Integer;
Begin // Create
  Inherited Create (AOwner);

  ClientHeight := 108;
  ClientWidth := 323;

  FReportType := ReportType;

  // Customise the form's Name to include the value of the report type at the end - this causes
  // the different report variants to all have different names, so Eduardo's system for remembering
  // the details treats them all as separate windows - need to ensure the name is unique so the user
  // can open multiple instances of the form
  //Self.Name := Self.Name + IntToStr(Ord(FReportType));
  sFormName := Self.Name + IntToStr(Ord(FReportType));
  For I := 0 To (Screen.FormCount - 1) Do
  Begin
    If (Screen.Forms[I].Name = sFormName) Then
      // Form instance already exists - append the time to make it unique
      sFormName := sFormName + '_' + FormatDateTime ('hhnnsszzz', Now);
  End; // For I
  Self.Name := sFormName;

  Case FReportType Of
    artCustomerAccountDetails : Caption := 'Customer Account Details Report';
    artSupplierAccountDetails : Caption := 'Supplier Account Details Report';
    artCustomerTradingLedger  : Caption := 'Customer Trading Ledger Report';
    artSupplierTradingLedger  : Caption := 'Supplier Trading Ledger Report';
    artCustomerLabels         : Caption := 'Customer Labels';
    artSupplierLabels         : Caption := 'Supplier Labels';
    artCustomerList           : Caption := 'Customer List';
  Else
    Raise Exception.Create ('TfrmRepInpAccountDetails.CreateWithReportType: Unhandled Report Type (' + IntToStr(Ord(FReportType)) + ')');
  End; // Case FReportType

  // Hide the Range of Accounts for Customer List report
  If (FReportType = artCustomerList) Then
    HideAccountRange;

  // Disable the Account Types option for Supplier Reports
  If Not (FReportType In TAccountReportType_Customers) Then
  Begin
    cbAccountTypes.Items.Clear;
    cbAccountTypes.Items.Add ('Suppliers Only');
    cbAccountTypes.ItemIndex := 0;
    cbAccountTypes.Enabled := False;
  End // If (ReportType In [artSupplierAccountDetails])
  Else If (Not Syss.ssConsumersEnabled) Then
  Begin
    // MH 14/01/2014 v7.0.8 ABSEXCH-14941: Force Include Account Types combo to Customers Only if Consumers turned off
    cbAccountTypes.ItemIndex := 1;   // Customers Only
    cbAccountTypes.Enabled := False;
  End; // If (Not Syss.ssConsumersEnabled)

  // Initialise the reporting settings structure
  FillChar(CRepParam, Sizeof(CRepParam), #0);

  // Load any remembered values from previous instances of this form for this report type
  SetLastValues;
End; // Create

//------------------------------

procedure TfrmRepInpAccountDetails.FormCreate(Sender: TObject);
begin
  inherited;

  // Do not use - this has been replaced by the overridden Constructor
end;

//-------------------------------------------------------------------------

procedure TfrmRepInpAccountDetails.HideAccountRange;
Var
  iChange : Integer;
Begin // HideAccountRange
  // Work out how much to resize/reposition controls by
  iChange := cbAccountTypes.Top - edtFromAccountCode.Top;

  // Hide Account Range controls
  lblAccountRange.Visible := False;
  lblAccountTo.Visible := False;
  edtFromAccountCode.Visible := False;
  edtToAccountCode.Visible := False;

  // Move controls up
  lblIncludeAccountTypes.Top := lblIncludeAccountTypes.Top - iChange;
  cbAccountTypes.Top := cbAccountTypes.Top - iChange;
  OkCP1Btn.Top := OkCP1Btn.Top - iChange;
  ClsCP1Btn.Top := ClsCP1Btn.Top - iChange;

  // Resize background frame and form's client area to remove gap at bottom
  SBSPanel4.Height := SBSPanel4.Height - iChange;
  Self.ClientHeight := Self.ClientHeight - iChange;
End; // HideAccountRange

//-------------------------------------------------------------------------

procedure TfrmRepInpAccountDetails.OkCP1BtnClick(Sender: TObject);
Var
  RepMode : Byte;
begin
  // Check it is the OK button - the Cancel button also comes in here - not my idea, talk to Eduardo!
  If (Sender=OkCP1Btn) then
  Begin
    // Force validation of all fields
    If AutoExitValidation Then
    Begin
      // Update the reporting settings structure
      With CRepParam Do
      Begin
        OKCP1Btn.Enabled:=BOff;

        StaStart:=edtFromAccountCode.Text;
        StaEnd:=edtToAccountCode.Text;

        If (Trim(StaEnd)='') then
          StaEnd:=NdxWeight;

        ShowOS := (FReportType In TAccountReportType_Customers);

        // Generate the legacy RepMode value for the report thread object
        Case FReportType Of
          artCustomerAccountDetails : RepMode := 8;
          artSupplierAccountDetails : RepMode := 8;
          artCustomerTradingLedger  : RepMode := 5;
          artSupplierTradingLedger  : RepMode := 5;
          artCustomerLabels         : RepMode := 10;
          artSupplierLabels         : RepMode := 10;
          artCustomerList           : RepMode := 0;
        Else
          Raise Exception.Create ('TfrmRepInpAccountDetails.OkCP1BtnClick: Unhandled Report Type (' + IntToStr(Ord(FReportType)) + ')');
        End; // Case FReportType

        Case cbAccountTypes.ItemIndex Of
          // Customers & Consumers
          0 : IncludeAccountTypes := atCustomersAndConsumers;
          // Customers Only
          1 : IncludeAccountTypes := atCustomersOnly;
          // Consumers Only
          2 : IncludeAccountTypes := atConsumersOnly;
        End; // Case cbAccountTypes.ItemIndex

        // Add the report into the thread controller for scheduling
        If (FReportType In [artCustomerAccountDetails, artSupplierAccountDetails, artCustomerTradingLedger,  artSupplierTradingLedger, artCustomerLabels, artSupplierLabels]) Then
          AddStaRep2Thread(RepMode, @CRepParam, Owner)
        Else If (FReportType = artCustomerList) Then
          AddGenRep2Thread(RepMode, Owner, Ord(IncludeAccountTypes));
      End; // With CRepParam

      // Closes form, remembers last values, etc...
      Inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    // Close button - closes form, remembers last values, etc...
    Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmRepInpAccountDetails.edtFromAccountCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  Inherited;

  If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
      Begin
        StillEdit:=BOn;

        FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,(FReportType In TAccountReportType_Customers),0));

        If (FoundOk) then
        Begin
          StillEdit:=BOff;
          Text:=FoundCode;
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;
    end; {with..}
end;

//=========================================================================

end.

