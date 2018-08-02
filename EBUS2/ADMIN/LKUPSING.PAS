unit LkupSing;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, EBusUtil, BtSupU1, EBusVar, EBusLook,
  EBusCnst, EBusLkup;

type
  TfrmOneLookup = class(TForm)
    Label81: Label8;
    Label82: Label8;
    btnOK: TButton;
    btnCancel: TButton;
    edtDescription: Text8Pt;
    Label83: Label8;
    cbxOurCode: TSBSComboBox;
    edtTheirCode: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ControlsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ControlsKeyPress(Sender: TObject; var Key: Char);
    procedure cbxOurCodeExit(Sender: TObject);
    procedure edtTheirCodeExit(Sender: TObject);
  private
    fLookupType : char;
    fActivate   : TFormActivate;
    fLockPos    : longint;
    fBtrieve    : TEBusBtrieveLookupTraderRef;
    procedure PopulateScreen;
    function  FieldsValid : boolean;
    function  PopulateFields : boolean;
    procedure ActivateFields(CanEdit : boolean);
    procedure PopulateVATDescription;
    procedure PopulateCurrencyDescription;
    procedure PopulateVATCodes;
    procedure PopulateCurrencyCodes;
    procedure PopulateOurCodeCombo;
    function  GetOurCodeComboValue : string;
  public
    procedure Display(FormActivate : TFormActivate; Btrieve : TEBusBtrieveLookupTraderRef;
                LockPos : longint);
  end;

var
  frmOneLookup: TfrmOneLookup;

implementation

{$R *.DFM}

uses
  EBusBtrv, BtrvU2, GlobVar, VarConst, UseTKit, UseDLLU, VarRec2U,
  ETMiscU,
  StrUtil, AdmnUtil, BTSupU2, ISOCurr;

//-----------------------------------------------------------------------

function TfrmOneLookup.FieldsValid : boolean;
// Notes : Validate fields here prior to saving to file
var
  VATInfo : ^TBatchVATRec;
  IntValue : integer;
begin
  Result := true;
  case fLookUpType of
    LOOKUP_TYPE_VAT :
    begin
      new(VATInfo);
      FillChar(VATInfo^, SizeOf(VatInfo^), 0);
      VATInfo^.VATCode := GetOurCodeComboValue[1];
      Result := Ex_GetVATRate(VATInfo, SizeOf(VATInfo^)) = 0;
      dispose(VATInfo);
      if not Result then
        MessageDlg('Invalid VAT code entered', mtError, [mbOK], 0);
    end;
    LOOKUP_TYPE_CURRENCY :
    begin
      try
        IntValue := StrToInt(GetOurCodeComboValue);
      except
        IntValue := 0;
      end;
      if (IntValue < 1) or (IntValue >= CurrencyType) then
      begin
        Result := false;
        MessageDlg(Format('Invalid currency number entered, must be in the range 1 - %d',
          [CurrencyType-1]), mtError, [mbOK], 0);
      end;
    end;
  end;
end; // TfrmOneLookup.FieldsValid

//-----------------------------------------------------------------------

function TfrmOneLookup.PopulateFields : boolean;
begin
  with fBtrieve do
  begin
    // OurTraderCode := ''; // needs to be set properly
    OurItemCode := GetOurCodeComboValue;
    TheirItemCode := edtTheirCode.Text;
    Description := edtDescription.Text;
  end;
  Result := FieldsValid;
end; // TfrmOneLookup.PopulateFields

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateScreen;
begin
  with fBtrieve do
  begin
    case fLookupType of
      LOOKUP_TYPE_VAT :
        cbxOurCode.Text := Format('%s - %s', [Trim(OurItemCode), GetVATDescription(OurItemCode[1])]);
      LOOKUP_TYPE_CURRENCY :
        cbxOurCode.Text := Format('%s - %s', [Trim(OurItemCode),
            GetCurrencyDescription(StrToInt(Trim(OurItemCode)))]);
    end;

    edtTheirCode.Text := Trim(TheirItemCode);
    edtDescription.Text := Description;
  end;
end; // TfrmOneLookup.PopulateScreen

//-----------------------------------------------------------------------

procedure TfrmOneLookup.ActivateFields(CanEdit : boolean);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
    if Components[i] is TMaskEdit then
      (Components[i] as TMaskEdit).ReadOnly := not CanEdit
    else
      if Components[i] is TSBSComboBox then
        (Components[i] as TSBSComboBox).ReadOnly := not CanEdit;
end; // TfrmOneLookup.ActivateFields

//-----------------------------------------------------------------------

procedure TfrmOneLookup.Display(FormActivate : TFormActivate;
                                Btrieve : TEBusBtrieveLookupTraderRef;
                                LockPos : longint);
begin
  fActivate := FormActivate;
  fLockPos := LockPos;
  fBtrieve := Btrieve;

  if fBtrieve is TEBusBtrieveLookupCurrency then
    fLookupType := LOOKUP_TYPE_CURRENCY
  else
    fLookupType := LOOKUP_TYPE_VAT;

  PopulateOurCodeCombo;

  case fActivate of
    actShow :
      begin
        ActivateFields(false);
        PopulateScreen;
      end;
    actEdit :
      begin
        Caption := Caption + ' - Edit record';
        PopulateScreen;
        HelpContext := 70;
      end;
    actAdd :
      begin
        Caption := Caption + ' - Add record';
        HelpContext := 76;
      end;
  end; // case
  Show;
end; // TfrmOneLookup.Display

//-----------------------------------------------------------------------

procedure TfrmOneLookup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if fActivate = actEdit then
    fBtrieve.UnlockRecord(fLockPos);
  fBtrieve.CloseFile;
  fBtrieve.Free;
  SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.btnOKClick(Sender: TObject);
var
  Status : integer;
  LParam : longint;
begin
  if (fActivate in [actAdd, actEdit]) then
  begin
    if PopulateFields then
    begin
      if fActivate = actAdd then
      begin
        fBtrieve.AddRecord;
        LParam := 0;
      end
      else
      begin
        fBtrieve.UpdateRecord;
        LParam := 1;
      end;

      SendMessage((Owner as TForm).Handle, WM_CustGetRec, 200, LParam);
      Close;
    end;
  end;
  if fActivate = actShow then
    Close;
end; // TfrmOneLookup.btnOKClick

//-----------------------------------------------------------------------

procedure TfrmOneLookup.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.ControlsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.ControlsKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateVATDescription;
begin
  if (Trim(edtDescription.Text) = '') and (Trim(cbxOurCode.Text) <> '') then
    edtDescription.Text := GetVATDescription(cbxOurCode.Text[1]);
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateCurrencyDescription;
var
  CurrNum : integer;
begin
  try
    CurrNum := StrToInt(GetOurCodeComboValue)
  except
    on EConvertError do
      CurrNum := 0;
  end;

  if (Trim(edtDescription.Text) = '') and (CurrNum <> 0) then
    edtDescription.Text := GetCurrencyDescription(CurrNum); 
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateOurCodeCombo;
begin
  case fLookUpType of
    LOOKUP_TYPE_VAT : PopulateVATCodes;
    LOOKUP_TYPE_CURRENCY : PopulateCurrencyCodes;
  end;
end;

//-----------------------------------------------------------------------

function TfrmOneLookup.GetOurCodeComboValue : string;
// Post : VAT => Returns single character or null if string blank
//        Currency => Returns the currency code (integer) as a string
begin
  Result:='';

  case fLookUpType of
    LOOKUP_TYPE_VAT :
      begin
        if cbxOurCode.ItemIndex = -1 then
        begin
          Result := Trim(cbxOurCode.Text);
          if Result = '' then
            Result := 'Z';
        end
        else
          Result := Trim(cbxOurCode.Items.Strings[cbxOurCode.ItemIndex]);

        Result:=Result[1];

        If (Not (Result[1] In VATSet)) then
          Result:='Z';
      end;

    LOOKUP_TYPE_CURRENCY :
     Begin
      if cbxOurCode.ItemIndex = -1 then
        Result := ExtractLeadingInteger(Trim(cbxOurCode.Text))
      else
        Result := ExtractLeadingInteger(Trim(cbxOurCode.Items.Strings[cbxOurCode.ItemIndex]));

      If (IntStr(Result)=0) then
        Result:='1';
     end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateVATCodes;
var
  i : integer;
begin
  for i := Low(VAT_CODES) to High(VAT_CODES) do
    cbxOurCode.Items.Add(VAT_CODES[i] + ' - ' + GetVATDescription(VAT_CODES[i]));

  For i:=0 to MAX_VATDesc do
  Begin
    edtTheirCode.Items.Add(Copy(BASDAVATList(i),1,1));
    edtTheirCode.ItemsL.Add(BASDAVATList(i));
  end;

  With edtTheirCode do
  Begin
    ItemIndex:=0;
    MaxListWidth:=175;
  end;

end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.PopulateCurrencyCodes;
var
  CurrNum : integer;

begin
  for CurrNum := 1 to CurrencyType -1 do
    cbxOurCode.Items.Add(IntToStr(CurrNum) + ' - ' + GetCurrencyDescription(CurrNum));

  For CurrNum:=0 to MAX_CurrDesc do
  Begin
    edtTheirCode.Items.Add(Copy(ISOCurrencyList(CurrNum),1,3));
    edtTheirCode.ItemsL.Add(ISOCurrencyList(CurrNum));
  end;

  With edtTheirCode do
  Begin
    ItemIndex:=Items.IndexOf('GBP');

    If (ItemIndex<0) then
      ItemIndex:=0;
  end;


end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.cbxOurCodeExit(Sender: TObject);
begin
  case fLookUpType of
    LOOKUP_TYPE_VAT : PopulateVATDescription;
    LOOKUP_TYPE_CURRENCY : PopulateCurrencyDescription;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneLookup.edtTheirCodeExit(Sender: TObject);
begin
  If (Sender Is TSBSComboBox) then
    With TSBSComboBox(Sender) do
      If (Not ReadOnly) then
        Text:=UpperCase(Text);
end;

end.
