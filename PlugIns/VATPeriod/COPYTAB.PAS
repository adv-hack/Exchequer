unit CopyTab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmCopyTable = class(TForm)
    btnOK: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    cbCompany: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCopyTable: TfrmCopyTable;

implementation

{$R *.dfm}
uses
  VatPrObj;

  
procedure TfrmCopyTable.FormCreate(Sender: TObject);
begin
  VatPeriod.GetCompanies(cbCompany.Items);
  cbCompany.ItemIndex := 0;
end;

procedure TfrmCopyTable.btnOKClick(Sender: TObject);
var
  Res : integer;
begin
  Res := VatPeriod.CopyTable(cbCompany.Text);
  if Res = mrYes then
  begin
    ShowMessage('Table copied');
    Close;
  end
  else
  if Res = mrCancel then
    Close
  else
  if Res = -1 then
    ShowMessage('An error occurred copying the table');
end;

end.
