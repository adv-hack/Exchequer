unit AddComp;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, eBusUtil;

type
  TfrmAddCompany = class(TForm)
    Label1: TLabel;
    cmbCompanies: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    sNewCompanyCode : shortstring;
    { Public declarations }
  end;

var
  frmAddCompany: TfrmAddCompany;

implementation

{$R *.DFM}

procedure TfrmAddCompany.FormCreate(Sender: TObject);
begin
  FillCompanyList(TStringList(cmbCompanies.Items), fmInactive);
  btnOK.Enabled := cmbCompanies.Items.Count > 0;
  if cmbCompanies.Items.Count > 0 then cmbCompanies.ItemIndex := 0;
end;

procedure TfrmAddCompany.btnOKClick(Sender: TObject);
begin
  sNewCompanyCode := TCompanyInfo(cmbCompanies.Items.Objects[cmbCompanies.ItemIndex]).CompanyRec.CompCode;
end;

end.
