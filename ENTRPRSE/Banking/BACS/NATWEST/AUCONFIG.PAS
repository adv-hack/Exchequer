unit auconfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CONFIGF, StdCtrls, ExtCtrls;

type
  TfrmAutopayConfig = class(TfrmBacsConfig)
    cbUDF: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure edtValChange(Sender: TObject);
    procedure edtValExit(Sender: TObject);
    procedure cbUDFChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAutopayConfig: TfrmAutopayConfig;

implementation

{$R *.dfm}

procedure TfrmAutopayConfig.FormCreate(Sender: TObject);
begin
  IniFileName := 'NatWest.ini';
  Section := 'Autopay';
  Key := 'BankRef';
  inherited;
  if edtVal.Text = '' then edtVal.Text := '1';
end;

procedure TfrmAutopayConfig.edtValChange(Sender: TObject);
var
  i : integer;
begin
  cbUDF.ItemIndex := cbUDF.Items.IndexOf(edtVal.Text);
end;

procedure TfrmAutopayConfig.edtValExit(Sender: TObject);
begin
  if ActiveControl <> Button2 then
    if edtVal.Text = '' then
    begin
      ShowMessage('User-defined field must be between 1 and 4');
      ActiveControl := edtVal;
    end;
end;

procedure TfrmAutopayConfig.cbUDFChange(Sender: TObject);
begin
  edtVal.Text := cbUDF.Items[cbUDF.itemIndex];
end;

end.
