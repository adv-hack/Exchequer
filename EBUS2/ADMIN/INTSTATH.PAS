unit intstatH;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar, bkgroup;

type
  TfrmIntraStatHeader = class(TForm)
    btnOK: TButton;
    btnClose: TButton;
    SBSPanel1: TSBSBackGroup;
    edtModeOfTransport: TCurrencyEdit;
    cbxTransactionType: TSBSComboBox;
    Label824: Label8;
    edtNatureOfTrans: TCurrencyEdit;
    Label823: Label8;
    Label822: Label8;
    edtDelTerms: Text8Pt;
    Label81: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtDelTermsExit(Sender: TObject);
    procedure edtNatureOfTransExit(Sender: TObject);
    procedure edtModeOfTransportExit(Sender: TObject);
    procedure cbxTransactionTypeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fDeliveryTerms: string;
    fTransactionNature: byte;
    fTransportMode: byte;
    fTransactionType: char;
    fSettingsUpdated: boolean;
    procedure SetString(const Value: string);
    procedure SetByte(const Index: Integer; const Value: byte);
    procedure SetChar(const Value: char);
    procedure SetBoolean(const Value: boolean);
  public
    property  SettingsUpdated : boolean read fSettingsUpdated write SetBoolean;
    property  DeliveryTerms : string read fDeliveryTerms write SetString;
    property  TransactionType : char read fTransactionType write SetChar;
    property  TransactionNature : byte index 1 read fTransactionNature write SetByte;
    property  TransportMode : byte index 2 read fTransportMode write SetByte;
    procedure SetFormProperties(SetFont : TFont; SetColour : TColor);
    procedure EnableEditing;
  end;

implementation
uses
  SysU3, // validation routines
  VarConst,
  BTSupU1,
  BTSupU2;

{$R *.DFM}

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.SetString(const Value: string);
begin
  if fDeliveryTerms <> Value then
  begin
    fDeliveryTerms := Value;
    edtDelTerms.Text := Value;
    SettingsUpdated := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.SetByte(const Index: Integer; const Value: byte);
begin
  case Index of
    1: if fTransactionNature <> Value then
       begin
         fTransactionNature := Value;
         edtNatureOfTrans.Value := Value;
         SettingsUpdated := true;
       end;
    2: if fTransportMode <> Value then
       begin
         fTransportMode := Value;
         edtModeOfTransport.Value := Value;
         SettingsUpdated := true;
       end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.SetChar(const Value: char);
begin
  if fTransactionType <> Value then
  begin
    fTransactionType := Value;
    case Value of
      'T' : cbxTransactionType.ItemIndex := 1;
      'P' : cbxTransactionType.ItemIndex := 2;
    else
      cbxTransactionType.ItemIndex := 0;
    end;
    SettingsUpdated := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.SetBoolean(const Value: boolean);
begin
  fSettingsUpdated := Value;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.SetFormProperties(SetFont : TFont; SetColour : TColor);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is Text8Pt then
      with (Components[i] as Text8Pt) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
    if Components[i] is TCurrencyEdit then
      with (Components[i] as TCurrencyEdit) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
    if Components[i] is TSBSComboBox then
      with (Components[i] as TSBSCombobox) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
  end;
end; // TfrmIntraStat.SetFormProperties

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.edtDelTermsExit(Sender: TObject);
begin
  if ActiveControl <> btnClose then
    if not ValidDelTerms(edtDelTerms.Text) then
      edtDelTerms.SetFocus
    else
      DeliveryTerms := edtDelTerms.Text;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.edtNatureOfTransExit(Sender: TObject);
begin
  if ActiveControl <> btnClose then
    if not ValidNatTran(Round(edtNatureOfTrans.Value)) then
      edtNatureOfTrans.SetFocus
    else
      TransactionNature := round(edtNatureOfTrans.Value);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.edtModeOfTransportExit(Sender: TObject);
begin
  if ActiveControl <> btnClose then
    if not ValidModeTran(round(edtModeOfTransport.Value)) then
      edtModeOfTransport.SetFocus
    else
      TransportMode := round(edtModeOfTransport.Value);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.cbxTransactionTypeExit(Sender: TObject);
begin
  case cbxTransactionType.ItemIndex of
    0: TransactionType := ' ';
    1: TransactionType := 'T';
    2: TransactionType := 'P';
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.EnableEditing;
begin
  edtDelTerms.ReadOnly := false;
  cbxTransactionType.ReadOnly := false;
  edtNatureOfTrans.ReadOnly := false;
  edtModeOfTransport.ReadOnly := false;
  // Modal result on OK button should be mrCancel in the Object Inspector
  btnOK.ModalResult := mrOK;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatHeader.FormCreate(Sender: TObject);
begin
  cbxTransactionType.ItemIndex := 0;
end;

end.
