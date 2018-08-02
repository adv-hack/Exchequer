unit AddComp;

{ prutherford440 09:36 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAddCompany = class(TForm)
    Label1: TLabel;
    cmbCompanies: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    sNewCompanyCode : shortstring;
    Auth : Boolean;
    { Public declarations }
  end;

var
  frmAddCompany: TfrmAddCompany;

implementation

{$R *.DFM}

procedure TfrmAddCompany.FormShow(Sender: TObject);
begin
  btnOK.Enabled := (cmbCompanies.Items.Count > 0) or Auth;
  if not Auth then
  begin
    if cmbCompanies.Items.Count > 0 then cmbCompanies.ItemIndex := 0;
  end
  else
    cmbCompanies.ItemIndex := -1;
end;

procedure TfrmAddCompany.FormCreate(Sender: TObject);
begin
  Auth := False;
end;

end.
