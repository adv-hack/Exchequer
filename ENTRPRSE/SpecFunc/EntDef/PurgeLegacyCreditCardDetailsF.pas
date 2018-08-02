unit PurgeLegacyCreditCardDetailsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GENENTU, ExtCtrls, StdCtrls, bkgroup, ComCtrls;

type
  TCreditCardFilter = record
    IncludeCustomers: Boolean;
    IncludeSuppliers: Boolean;
    IncludeConsumers: Boolean;
    ExcludeNameField: Boolean;
    IsSet: Boolean;
  end;

  TPurgeLegacyCreditCardDetailsForm = class(TTestCust)
    chkCustomers: TCheckBox;
    chkSuppliers: TCheckBox;
    chkConsumers: TCheckBox;
    chkExcludeNameField: TCheckBox;
    lblTitle: TLabel;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Filter: TCreditCardFilter;
  end;

var
  PurgeLegacyCreditCardDetailsForm: TPurgeLegacyCreditCardDetailsForm;

implementation

{$R *.dfm}

uses EntLicence;

procedure TPurgeLegacyCreditCardDetailsForm.OkCP1BtnClick(Sender: TObject);
begin
  inherited;
  Filter.IncludeCustomers := chkCustomers.Checked;
  Filter.IncludeSuppliers := chkSuppliers.Checked;
  Filter.IncludeConsumers := chkConsumers.Checked;
  Filter.ExcludeNameField := chkExcludeNameField.Checked;
  Filter.IsSet            := True;
end;

procedure TPurgeLegacyCreditCardDetailsForm.ClsCP1BtnClick(
  Sender: TObject);
begin
  inherited;
  Filter.IsSet := False;
end;

procedure TPurgeLegacyCreditCardDetailsForm.FormCreate(Sender: TObject);
begin
  inherited;
  if EnterpriseLicence.elModules[modCISRCT] <> mrNone then
  begin
    chkExcludeNameField.Visible := True;
  end
  else
  begin
    chkExcludeNameField.Visible := False;
    chkExcludeNameField.Checked := False;
  end;
end;

end.
