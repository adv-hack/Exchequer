unit IncVATRate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmIncVatRate = class(TForm)
    Label1: TLabel;
    cmbIncVATCode: TComboBox;
    Bevel1: TBevel;
    btnOK: TButton;
    lDesc: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    bManual : boolean;
  end;

var
  frmIncVatRate: TfrmIncVatRate;

implementation

{$R *.dfm}

procedure TfrmIncVatRate.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmIncVatRate.FormShow(Sender: TObject);
begin
  if bManual then
  begin
    Caption := 'Manual VAT Rate';
    lDesc.Caption := 'Base the Manual on which rate ?';
  end;{if}
end;

end.
