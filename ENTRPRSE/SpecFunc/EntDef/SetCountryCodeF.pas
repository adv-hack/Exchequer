unit SetCountryCodeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GENENTU, ExtCtrls, StdCtrls, bkgroup, ComCtrls,
  CountryCodeUtils, CountryCodes, TEditVal, GlobVar;

type
  TCountryCodeFilter = record
    IncludeCustomers: Boolean;
    IncludeSuppliers: Boolean;
    IncludeConsumers: Boolean;
    IncludePopulated: Boolean; // Include records whose Country Code is already populated
    SelectedCode: string;
    IsSet: Boolean;
  end;

  TSetCountryCode = class(TTestCust)
    Label1: TLabel;
    Label2: TLabel;
    lstCountry: TSBSComboBox;
    chkCustomers: TCheckBox;
    chkSuppliers: TCheckBox;
    chkConsumers: TCheckBox;
    chkAllRecords: TRadioButton;
    RadioButton1: TRadioButton;
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Filter: TCountryCodeFilter;
  end;

var
  SetCountryCode: TSetCountryCode;

implementation

{$R *.dfm}

procedure TSetCountryCode.FormCreate(Sender: TObject);
var
  Code: string;
begin
  inherited;
  // Populate the list of country names and codes
  LoadCountryCodes (lstCountry);
  lstCountry.MaxListWidth := lstCountry.Width;
  lstCountry.Items.Assign(lstCountry.ItemsL);
  // Get the country code of the current Exchequer install
  Code := DefaultCountryCode(CurrentCountry);
  // Default the list entry to match this country code
  lstCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, Code);
end;

procedure TSetCountryCode.OkCP1BtnClick(Sender: TObject);
begin
  inherited;
  Filter.IncludeCustomers := chkCustomers.Checked;
  Filter.IncludeSuppliers := chkSuppliers.Checked;
  Filter.IncludeConsumers := chkConsumers.Checked;
  Filter.IncludePopulated := chkAllRecords.Checked;
  Filter.SelectedCode     := ISO3166CountryCodes.ccCountryDetails[lstCountry.ItemIndex].cdCountryCode2;
  Filter.IsSet := True;
end;

procedure TSetCountryCode.ClsCP1BtnClick(Sender: TObject);
begin
  inherited;
  Filter.IsSet := False;
end;

end.
