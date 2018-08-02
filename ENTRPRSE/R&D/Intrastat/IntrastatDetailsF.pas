unit IntrastatDetailsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls;

type
  TIntrastatDetailsFrm = class(TForm)
    lblDeliveryTerms: TLabel;
    lblTransactionType: TLabel;
    lblNoTc: TLabel;
    lblModeOfTransport: TLabel;
    cbDeliveryTerms: TSBSComboBox;
    cbTransactionType: TSBSComboBox;
    cbNoTc: TSBSComboBox;
    cbModeOfTransport: TSBSComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    // Form set-up routines (called from FormCreate)
    procedure PopulateIntrastatLists;
    procedure ArrangeComponents;

    // Property Getters and Setters
    function GetDeliveryTerms: ShortString;
    function GetModeOfTransport: Byte;
    function GetNoTc: Byte;
    function GetTransactionType: Char;
    procedure SetDeliveryTerms(const Value: ShortString);
    procedure SetModeOfTransport(const Value: Byte);
    procedure SetNoTc(const Value: Byte);
    procedure SetTransactionType(const Value: Char);
  public
    function Validate: Boolean;
    property DeliveryTerms: ShortString read GetDeliveryTerms write SetDeliveryTerms;
    property NoTc: Byte read GetNoTc write SetNoTc;
    property ModeOfTransport: Byte read GetModeOfTransport write SetModeOfTransport;
    property TransactionType: Char read GetTransactionType write SetTransactionType;
  end;

implementation

{$R *.dfm}

uses
  // CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  IntrastatXML,
  oSystemSetup;

// =============================================================================
// TIntrastatDetailsFrm }
// =============================================================================

procedure TIntrastatDetailsFrm.FormCreate(Sender: TObject);
begin
  ArrangeComponents;
  PopulateIntrastatLists;
end;

// -----------------------------------------------------------------------------

function TIntrastatDetailsFrm.GetDeliveryTerms: ShortString;
begin
  if cbDeliveryTerms.ItemIndex > -1 then
    Result := IntrastatSettings.DeliveryTerms[cbDeliveryTerms.ItemIndex].Code
  else
    Result := '';
end;

// -----------------------------------------------------------------------------

function TIntrastatDetailsFrm.GetModeOfTransport: Byte;
begin
  if cbModeOfTransport.ItemIndex > -1 then
    Result := StrToIntDef(IntrastatSettings.ModesOfTransport[cbModeOfTransport.ItemIndex].Code, 0)
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

function TIntrastatDetailsFrm.GetNoTc: Byte;
begin
  if cbNoTc.ItemIndex > -1 then
    Result := StrToIntDef(IntrastatSettings.NatureOfTransactionCodes[cbNoTc.ItemIndex].Code, 0)
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

function TIntrastatDetailsFrm.GetTransactionType: Char;
begin
  // Translate the item position of the combo-box into the matching
  // Transaction Type code
  case cbTransactionType.ItemIndex of
    1: Result := 'T';
    2: Result := 'P';
  else
    Result := ' ';
  end;
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.PopulateIntrastatLists;
var
  i: Integer;
  Line: string;
begin
{$IFNDEF EXDLL}
  // The Transaction Type is a hard-coded list, stored in the combo at design
  // time. Copy the entries to the secondary list.
  cbTransactionType.ItemsL.Assign(cbTransactionType.Items);

  // For the other combo-boxes, read the lists using the IntrastatSettings
  // object (from IntrastatXML.pas).
  cbDeliveryTerms.Items.Clear;
  for i := 0 to IntrastatSettings.DeliveryTermsCount - 1 do
  begin
    Line := IntrastatSettings.DeliveryTerms[i].Code + ' - ' +
            IntrastatSettings.DeliveryTerms[i].Description;
    cbDeliveryTerms.Items.Add(Line);
    cbDeliveryTerms.ItemsL.Add(Line);
  end;

  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
    cbNoTc.ItemsL.Add(Line);
  end;

  cbModeOfTransport.Items.Clear;
  for i := 0 to IntrastatSettings.ModesOfTransportCount - 1 do
  begin
    Line := IntrastatSettings.ModesOfTransport[i].Code + ' - ' +
            IntrastatSettings.ModesOfTransport[i].Description;
    cbModeOfTransport.Items.Add(Line);
    cbModeOfTransport.ItemsL.Add(Line);
  end;
{$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.SetDeliveryTerms(const Value: ShortString);
begin
  cbDeliveryTerms.ItemIndex := IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Value);
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.SetModeOfTransport(const Value: Byte);
begin
  cbModeOfTransport.ItemIndex := IntrastatSettings.IndexOf(stModeOfTransport, ifCode, Format('%d', [Value]));
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.SetNoTc(const Value: Byte);
begin
  cbNoTc.ItemIndex := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, Format('%2d', [Value]));
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.SetTransactionType(const Value: Char);
begin
  // Translate the Transaction Type code into the matching combo-box item
  // position.
  case Value of
    'T': cbTransactionType.ItemIndex := 1;
    'P': cbTransactionType.ItemIndex := 2;
  else
    cbTransactionType.ItemIndex := 0;
  end;
end;

// -----------------------------------------------------------------------------

function TIntrastatDetailsFrm.Validate: Boolean;
var
  ErrorMsg: string;
begin
  ErrorMsg := '';
  Result := True;

  if SystemSetup.Intrastat.isShowDeliveryTerms and (cbDeliveryTerms.ItemIndex < 0) then
  begin
    ErrorMsg := 'Intrastat Delivery Terms must be selected';
    self.ActiveControl := cbDeliveryTerms;
  end
  else if cbTransactionType.ItemIndex < 0 then
  begin
    ErrorMsg := 'An Intrastat Transaction Type must be selected';
    self.ActiveControl := cbTransactionType;
  end
  else if cbNoTc.ItemIndex < 0 then
  begin
    ErrorMsg := 'An Intrastat Nature of Transaction Code must be selected';
    self.ActiveControl := cbNoTc;
  end
  else if SystemSetup.Intrastat.isShowModeOfTransport and (cbModeOfTransport.ItemIndex < 0) then
  begin
    ErrorMsg := 'An Intrastat Mode of Transport must be selected';
    self.ActiveControl := cbModeOfTransport;
  end;

  if (ErrorMsg <> '') then
  begin
    Result := False;
    MessageDlg(ErrorMsg, mtError, [mbOk], 0);
  end;
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.btnOKClick(Sender: TObject);
begin
  if not Validate then
    ModalResult := mrNone;
end;

// -----------------------------------------------------------------------------

procedure TIntrastatDetailsFrm.ArrangeComponents;
begin
  if not SystemSetup.Intrastat.isShowDeliveryTerms then
  begin
    // Hide the Delivery Terms components
    lblDeliveryTerms.Visible := False;
    cbDeliveryTerms.Visible := False;

    // Shuffle all the other controls up to fill in the gap (shuffle them
    // starting from the bottom).
    lblModeOfTransport.Top := lblNoTc.Top;
    cbModeOfTransport.Top  := cbNoTc.Top;

    lblNoTc.Top := lblTransactionType.Top;
    cbNoTc.Top  := cbTransactionType.Top;

    lblTransactionType.Top := lblDeliveryTerms.Top;
    cbTransactionType.Top := cbDeliveryTerms.Top;

    btnOK.Top := cbModeOfTransport.Top + cbModeOfTransport.Height + 16;
    btnCancel.Top := cbModeOfTransport.Top + cbModeOfTransport.Height + 16;
  end;

  if not SystemSetup.Intrastat.isShowModeOfTransport then
  begin
    // Hide the Mode of Transport components
    lblModeOfTransport.Visible := False;
    cbModeOfTransport.Visible := False;

    // Move the buttons up to fill the gap
    btnOK.Top := cbNoTc.Top + cbNoTc.Height + 16;
    btnCancel.Top := cbNoTc.Top + cbNoTc.Height + 16;
  end;

  // Use the resulting button positions to determine the correct size for
  // the form.
  self.ClientHeight := btnOk.Top + btnOk.Height + 6;
end;

// -----------------------------------------------------------------------------

end.
