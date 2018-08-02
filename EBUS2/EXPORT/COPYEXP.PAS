unit CopyExp;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmCopyExport = class(TForm)
    cmbCompany: TComboBox;
    Label1: TLabel;
    edDescription: TEdit;
    Label2: TLabel;
    btnCancel: TButton;
    btnCopy: TButton;
    Label3: TLabel;
    lDescription: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCopyExport: TFrmCopyExport;

implementation
uses
  eBusUtil;

{$R *.DFM}

procedure TFrmCopyExport.FormCreate(Sender: TObject);
begin
  FillCompanyList(TStringList(cmbCompany.Items), fmActive);
  if cmbCompany.Items.Count > 0 then cmbCompany.ItemIndex := 0;
  btnCopy.Enabled := cmbCompany.Items.Count > 0;
end;

end.
