unit DelAddr;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, EBusCnst, GlobVar;

type
  TfrmDelAddress = class(TForm)
    edtDelivery1: Text8Pt;
    edtDelivery2: Text8Pt;
    edtDelivery3: Text8Pt;
    edtDelivery4: Text8Pt;
    edtDelivery5: Text8Pt;
    btnOK: TButton;
    btnClose: TButton;
    edtPostcode: Text8Pt;
    Label1: TLabel;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLine4: TLabel;
    lblLine3: TLabel;
    lblLine5: TLabel;
    Label7: TLabel;
    lstCountry: TSBSComboBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  public
    procedure EnableEditing;
    //PR: 16/10/2013 ABSEXCH-14703 Added postcode parameter
    //PR: 30/08/2016 ABSEXCH-17138 Include country code
    procedure SetAddressDetails(Addr : AddrTyp; PostCode : string; CountryCode : string);
    procedure SetFormProperties(SetFont : TFont; SetColour : TColor);
  end;

var
  frmDelAddress: TfrmDelAddress;

implementation

{$R *.DFM}

uses
  BTSupU2, CountryCodeUtils, CountryCodes, CustomFieldsIntf;

//-----------------------------------------------------------------------

//PR: 16/10/2013 ABSEXCH-14703 Added postcode parameter
procedure TfrmDelAddress.SetAddressDetails(Addr : AddrTyp; PostCode : string; CountryCode : string);
var
  i : integer;
begin
  edtDelivery1.Text := Addr[1];
  edtDelivery2.Text := Addr[2];
  edtDelivery3.Text := Addr[3];
  edtDelivery4.Text := Addr[4];
  edtDelivery5.Text := Addr[5];

  //PR: 16/10/2013 ABSEXCH-14703 Set postcode text
  edtPostcode.Text := Trim(PostCode);

  i := ISO3166CountryCodes.IndexOf(ifCountry2, CountryCode);
  if i >=0 then
    lstCountry.ItemIndex := i;
end;

//-----------------------------------------------------------------------

procedure TfrmDelAddress.SetFormProperties(SetFont : TFont; SetColour : TColor);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
    if Components[i] is Text8Pt then
      with (Components[i] as Text8Pt) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
end;

//-----------------------------------------------------------------------

procedure TfrmDelAddress.EnableEditing;
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if (Components[i] is Text8Pt) then
      (Components[i] as Text8Pt).ReadOnly := false;
  // Modal result on OK button should be mrCancel in the Object Inspector 
  btnOK.ModalResult := mrOK;
end;

//-----------------------------------------------------------------------

procedure TfrmDelAddress.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmDelAddress.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmDelAddress.FormCreate(Sender: TObject);
begin
  //PR: 30/08/2016 ABSEXCH-17138 Add country code handling
  LoadCountryCodes (lstCountry);
  lstCountry.MaxListWidth := lstCountry.Width;
  lstCountry.Items.Assign(lstCountry.ItemsL);

  SetCustomFieldsPath(SetDrive);
  SetUDFCaptions([lblLine1, lblLine2, lblLine3, lblLine4, lblLine5], cfAddressLabels);
end;

end.
