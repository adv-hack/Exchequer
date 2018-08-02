unit DelAddu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal,
  GlobVar,VarConst, ExtCtrls, SBSPanel, SpellCheck4Modal;

Type
  // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
  TDeliveryAddressDlgDisplayMode = (dadmDeliveryAddress=0, dadmReceiptPayDetails=1, dadmReceiptCreditCard=2);

Type
  TDelAddrPop = class(TForm)
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    ADL1F: Text8Pt;
    ADL2F: Text8Pt;
    ADL3F: Text8Pt;
    ADL4F: Text8Pt;
    ADL5F: Text8Pt;
    PostCodePnl: TPanel;
    Label1: TLabel;
    PostCodeTxt: Text8Pt;
    SpellCheck4Modal1: TSpellCheck4Modal;
    Label821: Label8;
    lstCountry: TSBSComboBox;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLine3: TLabel;
    lblLine4: TLabel;
    lblLine5: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ADL1FKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
    // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
    FDisplayMode : TDeliveryAddressDlgDisplayMode;

    PrevHState
             :  Boolean;

    // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
    Procedure SetDisplayMode (Value : TDeliveryAddressDlgDisplayMode);

    Procedure OutDelAddr;

    Procedure SetDelStore(EnabFlg  :  Boolean);

    Procedure Form2Del;

    { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
    procedure HidePostCode;

  public
    { Public declarations }

    PopAddr    :  AddrTyp;
    { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
    PostCode   :  string[20];
    // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
    Country : String;

    // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
    Property DisplayMode : TDeliveryAddressDlgDisplayMode Read FDisplayMode Write SetDisplayMode;

    Function InitDelAddr(VO    :  Boolean;
                         Col1  :  TColor;
                         Fon1  :  TFont):  Word;



  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BTSupU1,
  BTSupU2,

  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodeUtils, CountryCodes,

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  CustomFieldsIntf;

{$R *.DFM}

Const
  ReceiptSet = [dadmReceiptPayDetails, dadmReceiptCreditCard];


procedure TDelAddrPop.FormCreate(Sender: TObject);
begin
  // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
  SetDisplayMode(dadmDeliveryAddress);

  // Bug: The Spell Check component appears to be disconnecting the OnKeyDown event at design-time in Delphi
  OnKeyDown := FormKeyDown;

  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  LoadCountryCodes (lstCountry);
  lstCountry.MaxListWidth := lstCountry.Width;
  lstCountry.Items.Assign(lstCountry.ItemsL);
end;

//-------------------------------------------------------------------------

// MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
Procedure TDelAddrPop.SetDisplayMode (Value : TDeliveryAddressDlgDisplayMode);
Begin // SetDisplayMode
  FDisplayMode := Value;

  Case FDisplayMode of
    dadmDeliveryAddress   : Begin
                              // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
                              SetUDFCaptions([lblLine1, lblLine2, lblLine3, lblLine4, lblLine5], cfAddressLabels);
                            End; // dadmDeliveryAddress
    dadmReceiptPayDetails : Begin
                              lblLine1.Caption := 'Line 1';
                              lblLine2.Caption := 'Line 2';
                              lblLine3.Caption := 'Line 3';
                              lblLine4.Caption := 'Line 4';
                              lblLine5.Caption := 'Line 5';
                            End; // dadmReceiptPayDetails
    dadmReceiptCreditCard : Begin
                              lblLine1.Caption := 'Card Type';
                              lblLine2.Caption := 'Card No';
                              lblLine3.Caption := 'Card Expiry';
                              lblLine4.Caption := 'Auth No';
                              lblLine5.Caption := '';
                            End; // dadmReceiptCreditCard
  End; // Case FDisplayMode
End; // SetDisplayMode

//-------------------------------------------------------------------------

{ ==== Procedure to Display Address ==== }

Procedure TDelAddrPop.OutDelAddr;

Begin

  ADL1F.Text:=PopAddr[1];
  ADL2F.Text:=PopAddr[2];
  ADL3F.Text:=PopAddr[3];
  ADL4F.Text:=PopAddr[4];
  ADL5F.Text:=PopAddr[5];
  { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
  PostCodeTxt.Text := PostCode;
  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  lstCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, Country);
end;


Procedure TDelAddrPop.SetDelStore(EnabFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do
      Begin
        Font.Assign(ADL1F.Font);
        Color:=ADL1F.Color;

        If (Tag=1) then
          ReadOnly:= EnabFlg;
      end
    else If (Components[Loop] is TSBSComboBox) then
      With (Components[Loop] as TSBSComboBox) do
      Begin
        Font.Assign(ADL1F.Font);
        Color:=ADL1F.Color;

        If (Tag=1) then
          ReadOnly:= EnabFlg;
      end

  end;

end;

Procedure TDelAddrPop.Form2Del;

Begin
  PopAddr[1]:=ADL1F.Text;
  PopAddr[2]:=ADL2F.Text;
  PopAddr[3]:=ADL3F.Text;
  PopAddr[4]:=ADL4F.Text;
  PopAddr[5]:=ADL5F.Text;
  { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
  PostCode  := PostCodeTxt.Text;
  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  If (lstCountry.ItemIndex >= 0) Then
    Country := ISO3166CountryCodes.ccCountryDetails[lstCountry.ItemIndex].cdCountryCode2;
end;


Function TDelAddrPop.InitDelAddr(VO    :  Boolean;
                                 Col1  :  TColor;
                                 Fon1  :  TFont):  Word;

Begin

  With ADL1F do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  SetDelStore(VO);

  // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
  If (FDisplayMode In ReceiptSet) then
  Begin
    HidePostCode;
    Self.HelpContext:=1164;
    Caption:='Additional Payment Details...';
  End; // If (FDisplayMode In ReceiptSet)

  OutDelAddr;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
    Form2Del;

end;

procedure TDelAddrPop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TDelAddrPop.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TDelAddrPop.ADL1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,ADL5F,Parent,Key);
  end;

end;

{ CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
procedure TDelAddrPop.HidePostCode;
begin
  if (PostCodePnl.Visible) then
  begin
    PostCodePnl.Visible := False;
    OkCP1Btn.Top  := OkCP1Btn.Top - PostCodePnl.Height;
    ClsCP1Btn.Top := ClsCP1Btn.Top - PostCodePnl.Height;
    ClientHeight  := ClientHeight - PostCodePnl.Height;
  end;
end;

procedure TDelAddrPop.OkCP1BtnClick(Sender: TObject);
begin
  // MH 20/04/2015 2015R1 ABSEXCH-16354: Added validation on Delivery Country
  If (FDisplayMode = dadmDeliveryAddress) Then
  Begin
    // Delivery Country must be valid if any part of the Delivery Adddress is set
    If (Trim(ADL1F.Text) <> '') Or (Trim(ADL2F.Text) <> '') Or (Trim(ADL3F.Text) <> '') Or
       (Trim(ADL4F.Text) <> '') Or (Trim(ADL5F.Text) <> '') Or (Trim(PostCodeTxt.Text) <> '') Then
    Begin
      If (lstCountry.ItemIndex <> -1) Then
        ModalResult := mrOK
      Else
      Begin
        If lstCountry.CanFocus Then
          lstCountry.SetFocus;
        MessageDlg('The Delivery Country must be set when the Delivery Address is set', mtError, [mbOK], 0);
      End; // Else
    End // If (Trim(ADL1F.Text) <> '') Or (...
    Else
      ModalResult := mrOK;
  End // If (FDisplayMode = dadmDeliveryAddress)
  Else
    ModalResult := mrOK;
end;

end.
